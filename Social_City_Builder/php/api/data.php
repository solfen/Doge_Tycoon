<?php

	session_start();
	error_reporting(E_ALL);
	include 'config.php';

	//TEMP VARS TO TEST !!
	$_SESSION['facebookID'] = '818989511510138';
	$_POST['event_name'] = 'launch_rocket';
	$_POST['building_id'] = 513;
	$_POST['isSoft'] = true;
	$_POST['building_builded_id'] = 9;
	$_POST["ressource"] = 'poudre5';
	$_POST["quantity"] = 100;
	$_POST['rocket_ref'] = "JauneLv1";
	$_POST['rocket_builded_id'] = 1;
	$_POST["clickNb"] = 100;
	$_POST['rocket_builded_id'] = 3;

	if (empty($_SESSION['facebookID']) && empty($_POST['facebookID']) || empty($_POST['event_name'])) {
		error('missing information');
	}

	$connexion = new PDO($src, $user, $pwd);
	$connexion->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
	$connexion->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);

	switch ($_POST['event_name']) {
		case 'retour_fussee':
			//buy_hard($config, $_POST['quantity']);
		break;
		case 'buy_ressource':
			$result = buy_ressource($connexion);
			echo $result;
		break;
		case 'sell_ressource':
			$result = sell_ressource($connexion);
			echo $result;
		break;
		case 'build_building':
			$result = building_operations($connexion,$_POST['isSoft'],false);
			echo $result;
		break;
		case 'upgrade_building':
			$result = building_operations($connexion,true,true);
			echo $result;
		break;
		case 'destroy_building':
			$result = destroy_building($connexion);
			echo $result;
		break;
		case 'build_rocket':
			$result = build_rocket($connexion);
			echo $result;
		break;			
		case 'check_end_rocket_build':
			$result = rocket_check($connexion,false);
			echo $result;
		break;		
		case 'destroy_rocket':
			$result = destroy_rocket($connexion);
			echo $result;
		break;
		case 'launch_rocket':
			$result = rocket_check($connexion,true);
			echo $result;
		break;
		default: // nothing good
			error('wrong event_name');
		break;
	}

/* ------------------------------------------------------------------ */

	function buy_ressource ($connexion) {
		$ressource = dbRequest($connexion,"SELECT `softBuyValue`, `hardBuyValue`, `discount` FROM `means` WHERE `ref` = :ref", array(':ref' => $_POST["ressource"]), true);
		if(!count($ressource) || (!$ressource[0]["softBuyValue"] && !$ressource[0]["hardBuyValue"])){
			return "0=Ressource is not valid";
		} 
		$ressource = $ressource[0];

		$playerConfig = dbRequest($connexion,"SELECT `hardCurrency`, `softCurrency` FROM `players` WHERE `facebookID` = :id", array(':id'=>$_SESSION['facebookID']), true)[0];
		if($ressource["softBuyValue"] && $playerConfig["softCurrency"] >= $ressource["softBuyValue"]*$_POST["quantity"]){
			$playerConfig["softCurrency"] -= $ressource["softBuyValue"]*$_POST["quantity"];
		}
		else if($ressource["hardBuyValue"] && $playerConfig["hardCurrency"] >= $ressource["hardBuyValue"]*$_POST["quantity"]){
			$playerConfig["hardCurrency"] -= $ressource["hardBuyValue"]*$_POST["quantity"];
		}
		else{
			return "0=Player too poor";
		}

		dbRequest($connexion,"UPDATE `players` SET `hardCurrency`= :hard ,`softCurrency`= :soft WHERE `facebookID` = :id", array(':hard'=>$playerConfig["hardCurrency"],':soft'=>$playerConfig["softCurrency"], ':id'=>$_SESSION['facebookID']),false);
		return '1';
	}

	function sell_ressource ($connexion) {
		$ressource = dbRequest($connexion,"SELECT `ref_nb`,`softSellValue`, `discount` FROM `means` WHERE `ref` = :ref", array(':ref' => $_POST["ressource"]), true);
		if(!count($ressource) || !$ressource[0]["softSellValue"]){
			return "0=Ressource is not valid";
		} 
		$ressource = $ressource[0];

		$playerConfig = dbRequest($connexion,"SELECT `softCurrency`,`ressource_".$ressource['ref_nb']."` FROM `players` WHERE `facebookID` = :id", array(':id'=>$_SESSION['facebookID']), true)[0];
		if($playerConfig["ressource_".$ressource['ref_nb']] >= $_POST["quantity"]){
			$playerConfig["softCurrency"] += $ressource["softSellValue"]*$_POST["quantity"];
			$playerConfig["ressource_".$ressource['ref_nb']] -= $_POST["quantity"];
		}
		else{
			return "0=Player too poor";
		}

		dbRequest($connexion,"UPDATE `players` SET `ressource_".$ressource['ref_nb']."` = :ressource ,`softCurrency`= :soft WHERE `facebookID` = :id", array(':ressource' => $playerConfig["ressource_".$ressource['ref_nb']], ':soft'=>$playerConfig["softCurrency"], ':id'=>$_SESSION['facebookID']),false);
		return '1';
	}

	function building_operations ($connexion,$isSoft,$isUpgrade) {
		$buildingConfig = dbRequest($connexion,"SELECT `hardCost`, `softCost`, `dogeCost`, `buildingTime`, `ressource_cost_1`, `ressource_cost_2`, `ressource_cost_3`, `ressource_cost_4`, `ressource_cost_5`, `ressource_cost_6` FROM `buildings` WHERE `ID` = :id", array(':id'=>$_POST['building_id']), true);
		$playerConfig = dbRequest($connexion,"SELECT `ID`, `hardCurrency`, `softCurrency`, `population`, `ressource_1`, `ressource_2`, `ressource_3`, `ressource_4`, `ressource_5`, `ressource_6` FROM `players` WHERE `facebookID` = :id", array(':id'=>$_SESSION['facebookID']), true);
		$playerConfig = $playerConfig[0];
		$buildingConfig = $buildingConfig[0];
		
		if(!count($playerConfig) || !count($buildingConfig)){
			return "0=invalid params";
		}

		$canBuild = true;
		if(!$isSoft && $playerConfig['hardCurrency'] <= $buildingConfig['hardCost']){
			$canBuild = false;
		}
		else if($isSoft && $playerConfig['softCurrency'] <= $buildingConfig['softCost']){
			$canBuild = false;
		}
		else if($playerConfig['population'] <= $buildingConfig['dogeCost']){
			$canBuild = false;
		}
		else{
			for($i=1; $i<7; $i++){
				if($playerConfig['ressource_'.$i] <= $buildingConfig['ressource_cost_'.$i]){
					$canBuild = false;
				}
			}
		}

		if($canBuild){
			$str = "UPDATE `players` SET `hardCurrency`= :hard ,`softCurrency`= :soft,`ressource_1`= :r1,`ressource_2`= :r2,`ressource_3`= :r3,`ressource_4`= :r4,`ressource_5`= :r5,`ressource_6`= :r6, `population`= :doge WHERE `facebookID` = :id";
			
			$playerConfig['hardCurrency'] -= $isSoft ? 0 : $buildingConfig['hardCost'];
			$playerConfig['softCurrency'] -= $isSoft ? $buildingConfig['softCost'] : 0;
			$playerConfig['population']   -= $buildingConfig['dogeCost'];
			$params = array(':id'=>$_SESSION['facebookID'], ':hard'=>$playerConfig['hardCurrency'], ':soft'=>$playerConfig['softCurrency'], ':doge'=>$playerConfig['population']);
			for($i=1; $i<7; $i++){
				$playerConfig['ressource_'.$i] -= $buildingConfig['ressource_cost_'.$i];
				$params['r'.$i] = $playerConfig['ressource_'.$i];
			}
			dbRequest($connexion, $str, $params, false);

			if($isUpgrade){
				dbRequest($connexion,"UPDATE `builded_buildings` SET `buildingID` = :buildingID, `buildingEnd` = :time WHERE `ID` = :id",array('buildingID' => $_POST['building_id'], ':time' => date("Y-m-d H:i:s",time() + $buildingConfig['buildingTime']), ':id'=>$_POST['building_builded_id']), false);
			}
			else{
				dbRequest($connexion,"INSERT INTO `builded_buildings`(`ID`, `buildingID`, `playerID`, `buildingEnd`, `col`, `row`) VALUES ('',:buildingID, :playerID, :time, 0,0)",array(':buildingID' => $_POST['building_id'], ':playerID' => $playerConfig['ID'], ':time' => date("Y-m-d H:i:s",time() + $buildingConfig['buildingTime'])), false);
			}

			return "1";
		}
		else{
			return "0=not enough ressources";
		}
	}

	function destroy_building ($connexion) {
		dbRequest($connexion,"DELETE FROM `builded_buildings` WHERE `ID` = :id",array(':id'=>$_POST['building_builded_id']), false);
		echo "1";
	}

	function build_rocket ($connexion) {
		$rocketConfig = dbRequest($connexion,"SELECT `ID`, `ref`, `softCost`, `dogeCost`, `travelDuration`, `constructionDuration`, `ressource_cost_1`, `ressource_cost_2`, `ressource_cost_3`, `ressource_cost_4`, `ressource_cost_5`, `ressource_cost_6` FROM `rockets` WHERE `ref` = :ref", array(':ref'=>$_POST['rocket_ref']), true);
		$playerConfig = dbRequest($connexion,"SELECT `ID`, `hardCurrency`, `softCurrency`, `population`, `ressource_1`, `ressource_2`, `ressource_3`, `ressource_4`, `ressource_5`, `ressource_6` FROM `players` WHERE `facebookID` = :id", array(':id'=>$_SESSION['facebookID']), true);
		
		if(!count($playerConfig) || !count($rocketConfig)){
			return "0=invalid params";
		}
		$playerConfig = $playerConfig[0];
		$rocketConfig = $rocketConfig[0];
		
		$canBuild = true;
		if($playerConfig['softCurrency'] <= $rocketConfig['softCost']){
			$canBuild = false;
		}
		else if($playerConfig['population'] <= $rocketConfig['dogeCost']){
			$canBuild = false;
		}
		else{
			for($i=1; $i<7; $i++){
				if($playerConfig['ressource_'.$i] <= $rocketConfig['ressource_cost_'.$i]){
					$canBuild = false;
				}
			}
		}

		if($canBuild){
			$str = "UPDATE `players` SET `softCurrency`= :soft,`ressource_1`= :r1,`ressource_2`= :r2,`ressource_3`= :r3,`ressource_4`= :r4,`ressource_5`= :r5,`ressource_6`= :r6, `population`= :doge WHERE `facebookID` = :id";
			
			$playerConfig['softCurrency'] -= $rocketConfig['softCost'];
			$playerConfig['population']   -= $rocketConfig['dogeCost'];

			$params = array(':id'=>$_SESSION['facebookID'], ':soft'=>$playerConfig['softCurrency'], ':doge'=>$playerConfig['population']);
			
			for($i=1; $i<7; $i++){
				$playerConfig['ressource_'.$i] -= $rocketConfig['ressource_cost_'.$i];
				$params['r'.$i] = $playerConfig['ressource_'.$i];
			}

			dbRequest($connexion, $str, $params, false);

			dbRequest($connexion,"INSERT INTO `builded_rockets`(`ID`, `playerID`, `rocketID`, `buildingEnd`, `travelEnd`) VALUES ('',:id,:rocketID,:buildEnd,'')",array(':id' => $playerConfig['ID'], ':rocketID' => $rocketConfig['ID'], ':buildEnd' => date("Y-m-d H:i:s",time() + $rocketConfig['constructionDuration'])), false);


			return "1";
		}
		else{
			return "0=not enough ressources";
		}
	}
	function get_rocket_info ($connexion,$needToLaunch){
		$maxClickPerSecond = 10; //pour contrôler la triche au nombre de click (comme c'est l'user qui envoie son nombre de click on limite à 10/sec)
		$rocket = dbRequest($connexion,"SELECT `rocketID`, `buildingEnd`, `travelEnd`,`isBuiled` FROM `builded_rockets` WHERE ID = :id",array(':id' => $_POST['rocket_builded_id']),true);
		if(!count($rocket)){
			return "0=Invalid ID";
		}
		$rocket = $rocket[0];

		$rocketConfig = dbRequest($connexion,"SELECT `clickTimeReward`, `travelDuration`, `constructionDuration` FROM `rockets` WHERE `ID` = :id",array(':id' => $rocket["rocketID"]),true);
		if(!count($rocketConfig)){
			return "0=Invalid rocket ref";
		}
		$rocketConfig  = $rocketConfig[0];
		return [$rocket,$rocketConfig];
	}
	function check_rocket_construction_end ($connexion, $rocketInfo){
		$rocket = $rocketInfo[0];
		$rocketConfig = $rocketInfo[1];
		$clickBonusPercent = min($rocketConfig["constructionDuration"] * $maxClickPerSecond, $_POST["clickNb"]) * $rocketConfig["clickTimeReward"];
		$rocketEndTime = strtotime($rocket['buildingEnd']) - $clickBonusPercent*$rocketConfig["constructionDuration"];
		if(time() >= $rocketEndTime){
			return "1";
		}
		else {
			return '{"durationLeft":"'. ($rocketEndTime - time()) .'"}';
		}
	}
	function lauch_rocket ($connexion, $rocketInfo){
		$rocket = $rocketInfo[0];
		$rocketConfig = $rocketInfo[1];
		if(!$rocket['isBuiled']){
			return "0=Rocket not builded";
		}
		if($rocket['travelEnd'] != "0000-00-00 00:00:00"){
			return "0=Rocket already launched";
		}
		dbRequest($connexion,"UPDATE `builded_rockets` SET `travelEnd`=:dateEnd WHERE ID = :id",array(':dateEnd' => date("Y-m-d H:i:s",time() + $rocketConfig['travelDuration']), ':id' => $_POST['rocket_builded_id']),false);
	}

	function destroy_rocket ($connexion){
		dbRequest($connexion,"DELETE FROM `builded_rockets` WHERE `ID` = :id",array(':id'=>$_POST['rocket_builded_id']), false);
		echo "1";
	}


/* ------------------------------------------------------------------ */
	function dbRequest ($connexion, $req, $params, $isReturn){
		try{
			$requete = $connexion->prepare($req);
			$requete->execute($params);
			if($isReturn){
				$resultat = $requete->fetchAll(PDO::FETCH_ASSOC);
				return $resultat;
			}
		}
		catch (PDOExeption $e) {
		    echo '{"error":"'.$e->getMessage().'"}';
		    die();
		}
	}
	function get_all_player_data ($config) {
		$players = get_db_select_query($config, '*', '`players`', '`facebookID`="'.$config['facebookID'].'"');


		if (!$players) {

			return null;
		}
		
		$player = $players[0];
		//print_r($player);
		//echo '<br>empty($player[ID]) ? '.empty($player['ID']).'<br>';

		if (empty($player['ID'])) {

			return null;
		}

		return [
			'player' => $player,
			'artefacts' => get_db_select_query($config, '*', '`collected_artefacts`', '`playerID`="'.$player['ID'].'"'),
			'buildings' => get_db_select_query($config, '*', '`builded_buildings`', '`playerID`="'.$player['ID'].'"'),
			'planets' => get_db_select_query($config, '*', '`explored_planets`', '`playerID`="'.$player['ID'].'"'),
			'quests' => get_db_select_query($config, '*', '`player_quests`', '`playerID`="'.$player['ID'].'"'),
			'rocket' => get_db_select_query($config, '*', '`player_rocket`', '`playerID`="'.$player['ID'].'"')
		];

	}

	function get_db_select_query ($config, $select, $from, $where) {

		$req = "SELECT $select FROM $from WHERE $where";

		try {

			$res =  $config['connexion']->query($req);

			if ($res->rowCount() == 0) {
				return null;
			}

			return $res->fetchAll();

		} catch (PDOExeption $e) {

			echo '{"error":"'.$e->getMessage().'"}';
			die();

		}
	}

?>
