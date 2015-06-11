<?php

	session_start();
	error_reporting(E_ALL);
	include 'config.php';

	//TEMP VARS TO TEST !!
	/*$_POST['facebookID'] = '818989511510138';
	$_POST['event_name'] = 'get_friend_artefacts';
	$_POST['building_id'] = "257";
	$_POST['isSoft'] = "0";
	$_POST['building_builded_id'] = 35;
	$_POST["ressource"] = 'poudre0';
	$_POST["quantity"] = 100;
	$_POST['rocket_ref'] = "JauneLv3";
	$_POST['rocket_builded_id'] = 1;
	$_POST["clickNb"] = 1000;
	$_POST['rocket_builded_id'] = 7;
	$_POST['friendID'] = "818989511510138";
	$_POST['artefactsID'] = ["701943576599156", "1446334055683188", "906211629440719"];
	$_POST["artefactFbID"] = "1446334055683188";
	$_POST["questID"] = 1;
	$_POST['col'] = 5;
	$_POST['row'] = 5;*/

	// need JSON config file both for the server and the client so that both have the same config
	// in the meantime, the vars used by the server are in $gameInfo
	$gameInfo["maxClickPerSecond"] = 10;
	$gameInfo["faithLossSpeed"] = 0.001;
	$gameInfo["prayerEffect"] = 0.005;
	$gameInfo["museeSoftSpeed"] = 10;
	$gameInfo["musseVisiteGain"] = 1;
	$gameInfo['nicheLv1']['dogepersecond'] = .1;
	$gameInfo['nicheLv2']['dogepersecond'] = .2;
	$gameInfo['nicheLv3']['dogepersecond'] = .3;

	if (empty($_POST['facebookID']) || empty($_POST['event_name']) ) {
		error('missing information');
	}
	$connexion = new PDO($src, $user, $pwd);
	$connexion->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
	$connexion->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);

	switch ($_POST['event_name']) {
		case 'buy_ressource':
			$result = buy_ressource($connexion);
			echo $result;
		break;
		case 'sell_ressource':
			$result = sell_ressource($connexion);
			echo $result;
		break;
		case 'buy_building':
			$result = building_operations($connexion,$_POST['isSoft'],false);
			echo $result;
		break;
		case 'build_building':
			$result = build_buidling($connexion);
			echo $result;
		break;		
		case 'check_building_end':
			$result = check_building_end($connexion);
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
		case 'get_all_buildings':
			$result = get_all_buildings($connexion);
			echo $result;
		break;
		case 'build_rocket':
			$result = build_rocket($connexion);
			echo $result;
		break;
		case 'check_end_rocket_build':
			$result = get_rocket_info($connexion);
			if(is_array($result)){
				$result = check_rocket_construction_end($connexion, $result, $gameInfo["maxClickPerSecond"]);
			}
			echo $result;
		break;		
		case 'destroy_rocket':
			$result = destroy_rocket($connexion);
			echo $result;
		break;		
		case 'launch_rocket':
			$result = get_rocket_info($connexion);
			if(is_array($result)){
				$result = launch_rocket($connexion, $result);
			}
			echo $result;
		break;
		case 'check_rocket_travel_end':
			$result = get_rocket_info($connexion);
			if(is_array($result)){
				$result = check_rocket_travel_end($connexion, $result);
			}
			echo $result;
		break;
		case 'get_friend_artefacts':
			$result = get_friend_artefacts($connexion);
			echo $result;
		break;
		case 'get_my_artefacts':
			$result = get_my_artefacts($connexion);
			echo $result;
		break;		
		case 'give_artefact':
			$result = give_artefact($connexion);
			echo $result;
		break;
		case 'check_quest_completion':
			$result = check_quest_completion($connexion);
			echo $result;
		break;
		case 'update_ressources':
			$result = update_ressources($connexion, $gameInfo);
			echo $result;
		break;
		default: // nothing good
			error('wrong event_name');
		break;
	}

/* ------------------------------------------------------------------ */

	function buy_ressource ($connexion) {
		$ressource = dbRequest($connexion,"SELECT `ref_nb`,`softBuyValue`, `hardBuyValue`, `discount` FROM `means` WHERE `ref` = :ref", array(':ref' => $_POST["ressource"]), true);
		if(!count($ressource) || (!$ressource[0]["softBuyValue"] && !$ressource[0]["hardBuyValue"])){
			return "0=Ressource is not valid";
		} 
		$ressource = $ressource[0];

		$playerConfig = dbRequest($connexion,"SELECT `hardCurrency`, `softCurrency` FROM `players` WHERE `facebookID` = :id", array(':id'=>$_POST['facebookID']), true)[0];
		if($ressource["softBuyValue"] && $playerConfig["softCurrency"] >= $ressource["softBuyValue"]*$_POST["quantity"]){
			$playerConfig["softCurrency"] -= $ressource["softBuyValue"]*$_POST["quantity"];
		}
		else if($ressource["hardBuyValue"] && $playerConfig["hardCurrency"] >= $ressource["hardBuyValue"]*$_POST["quantity"]){
			$playerConfig["hardCurrency"] -= $ressource["hardBuyValue"]*$_POST["quantity"];
		}
		else{
			return "0=Player too poor";
		}

		dbRequest($connexion,"UPDATE `players` SET `hardCurrency`= :hard ,`softCurrency`= :soft, `ressource_".$ressource['ref_nb']."` = ressource_".$ressource['ref_nb']."+:quantity  WHERE `facebookID` = :id", array(':hard'=>$playerConfig["hardCurrency"],':soft'=>$playerConfig["softCurrency"], ':quantity'=>$_POST["quantity"], ':id'=>$_POST['facebookID']),false);
		return '1';
	}

	function sell_ressource ($connexion) {
		$ressource = dbRequest($connexion,"SELECT `ref_nb`,`softSellValue`, `discount` FROM `means` WHERE `ref` = :ref", array(':ref' => $_POST["ressource"]), true);
		if(!count($ressource) || !$ressource[0]["softSellValue"]){
			return "0=Ressource is not valid";
		} 
		$ressource = $ressource[0];

		$playerConfig = dbRequest($connexion,"SELECT `softCurrency`,`ressource_".$ressource['ref_nb']."` FROM `players` WHERE `facebookID` = :id", array(':id'=>$_POST['facebookID']), true)[0];
		if($playerConfig["ressource_".$ressource['ref_nb']] >= $_POST["quantity"]){
			$playerConfig["softCurrency"] += $ressource["softSellValue"]*$_POST["quantity"];
			$playerConfig["ressource_".$ressource['ref_nb']] -= $_POST["quantity"];
		}
		else{
			return "0=Player too poor";
		}

		dbRequest($connexion,"UPDATE `players` SET `ressource_".$ressource['ref_nb']."` = :ressource ,`softCurrency`= :soft WHERE `facebookID` = :id", array(':ressource' => $playerConfig["ressource_".$ressource['ref_nb']], ':soft'=>$playerConfig["softCurrency"], ':id'=>$_POST['facebookID']),false);
		return '1';
	}

	function building_operations ($connexion,$isSoft,$isUpgrade) {
		if(!isset($_POST['building_id'])){
			return "0=Missing infos";
		}
		$buildingConfig = dbRequest($connexion,"SELECT `hardCost`, `softCost`, `dogeCost`, `buildingTime`, `ressource_cost_1`, `ressource_cost_2`, `ressource_cost_3`, `ressource_cost_4`, `ressource_cost_5`, `ressource_cost_6` FROM `buildings` WHERE `ID` = :id", array(':id'=>$_POST['building_id']), true);
		$playerConfig = dbRequest($connexion,"SELECT `ID`, `hardCurrency`, `softCurrency`, `population`, `ressource_1`, `ressource_2`, `ressource_3`, `ressource_4`, `ressource_5`, `ressource_6` FROM `players` WHERE `facebookID` = :id", array(':id'=>$_POST['facebookID']), true);
		$playerConfig = $playerConfig[0];
		$buildingConfig = $buildingConfig[0];
		
		if(!count($playerConfig) || !count($buildingConfig)){
			return "0=invalid params";
		}

		$canBuild = true;
		if(!$isSoft && $playerConfig['hardCurrency'] < $buildingConfig['hardCost']){
			$canBuild = false;
		}
		else if($isSoft && $playerConfig['softCurrency'] < $buildingConfig['softCost']){
			$canBuild = false;
		}
		else if($playerConfig['population'] < $buildingConfig['dogeCost']){
			$canBuild = false;
		}
		else{
			for($i=1; $i<7; $i++){
				if($playerConfig['ressource_'.$i] < $buildingConfig['ressource_cost_'.$i]){
					$canBuild = false;
				}
			}
		}

		if($canBuild){
			if($isUpgrade){
				$buildedBuilding = dbRequest($connexion,"SELECT `ID` FROM `builded_buildings` WHERE `ID` = :id && `playerFbID` = :fbID", array(':id'=>$_POST['building_builded_id'], ':fbID'=>$_POST["facebookID"]), true);
				if(!count($buildedBuilding)){
					return "0=Invalid building ID";
				}
			}

			$str = "UPDATE `players` SET `hardCurrency`= :hard ,`softCurrency`= :soft,`ressource_1`= :r1,`ressource_2`= :r2,`ressource_3`= :r3,`ressource_4`= :r4,`ressource_5`= :r5,`ressource_6`= :r6, `population`= :doge WHERE `facebookID` = :id";
			
			$playerConfig['hardCurrency'] -= $isSoft ? 0 : $buildingConfig['hardCost'];
			$playerConfig['softCurrency'] -= $isSoft ? $buildingConfig['softCost'] : 0;
			$playerConfig['population']   -= $buildingConfig['dogeCost'];
			$params = array(':id'=>$_POST['facebookID'], ':hard'=>$playerConfig['hardCurrency'], ':soft'=>$playerConfig['softCurrency'], ':doge'=>$playerConfig['population']);
			for($i=1; $i<7; $i++){
				$playerConfig['ressource_'.$i] -= $buildingConfig['ressource_cost_'.$i];
				$params['r'.$i] = $playerConfig['ressource_'.$i];
			}
			dbRequest($connexion, $str, $params, false);

			if($isUpgrade){
				dbRequest($connexion,"UPDATE `builded_buildings` SET `isBuilded` = 0, `buildingID` = :buildingID, `buildingEnd` = :time WHERE `ID` = :id",array('buildingID' => $_POST['building_id'], ':time' => date("Y-m-d H:i:s",time() + $buildingConfig['buildingTime']), ':id'=>$_POST['building_builded_id']), false);
				return "1";
			}
			else{
				dbRequest($connexion,"INSERT INTO `builded_buildings`(`ID`, `buildingID`, `playerFbID`) VALUES ('',:buildingID, :playerFbID)",array(':buildingID' => $_POST['building_id'], ':playerFbID' => $_POST["facebookID"]), false);
				return $connexion->lastInsertId();
			}
		}
		else{
			return "0=not enough ressources";
		}
	}
	function build_buidling($connexion){
		$cheatRatio = 0.01; // pour les test de construction
		if(!isset($_POST['building_builded_id']) || !isset($_POST['building_id']) || !isset($_POST['col']) || !isset($_POST['row']) ){
			return "0=Missing params";
		}

		$buildingTime = dbRequest($connexion,"SELECT `buildingTime` FROM `buildings` WHERE `ID` = :id", array(':id'=>$_POST['building_id']), true);
		if(!count($buildingTime)){
			return "0=Invalid building ID";
		}
		$buildingTime = $buildingTime[0];		

		/*we have to check if we can place the building at the indicated coord butsince it's lucien who did the client side check ,
		I have absolutly no idea how it works and it looks complex so for now I dont do this check.*/

		dbRequest($connexion,"UPDATE `builded_buildings` SET  buildingEnd = :time, col = :col, row = :row  WHERE `ID` = :id",array(':time' => date("Y-m-d H:i:s",time() + $buildingTime['buildingTime'] * $cheatRatio), ':id'=>$_POST['building_builded_id'], ':col'=>$_POST['col'], ':row'=>$_POST['row']), false);

		return "1";
	}
	function check_building_end($connexion){
		if(!isset($_POST['building_builded_id']) ){
			return "0=Missing params";
		}
		$building = dbRequest($connexion,"SELECT `buildingEnd`, `isBuilded` FROM `builded_buildings` WHERE `ID` = :id && `playerFbID` = :fbID", array(':id'=>$_POST['building_builded_id'],':fbID'=>$_POST['facebookID']), true);
		if(!count($building)){
			return "0=Invalid building ID";
		}
		$building = $building[0];
		if(time() < strtotime($building['buildingEnd'])){
			return '{"durationLeft":"'. (strtotime($building['buildingEnd']) - time()) .'"}';
		}
		
		dbRequest($connexion,"UPDATE `builded_buildings` SET `isBuilded` = 1 WHERE `ID` = :id",array(':id'=>$_POST['building_builded_id']), false);
		return "1";
	}

	function destroy_building ($connexion) {
		dbRequest($connexion,"DELETE FROM `builded_buildings` WHERE `ID` = :id && `playerFbID` = :fbID",array(':id'=>$_POST['building_builded_id'],':fbID'=>$_POST['facebookID']), false);
		echo "1";
	}
	function get_all_buildings($connexion) {
		$buildings = dbRequest($connexion,"SELECT `ID`, `buildingID`, `buildingEnd`, `col`, `row` FROM `builded_buildings` WHERE playerFbID = :fbID", array(":fbID"=>$_POST['facebookID']), true);
		return json_encode($buildings);
	}

	function build_rocket ($connexion) {
		$rocketConfig = dbRequest($connexion,"SELECT `ID`, `ref`, `softCost`, `dogeCost`, `travelDuration`, `constructionDuration`, `ressource_cost_1`, `ressource_cost_2`, `ressource_cost_3`, `ressource_cost_4`, `ressource_cost_5`, `ressource_cost_6` FROM `rockets` WHERE `ref` = :ref", array(':ref'=>$_POST['rocket_ref']), true);
		$playerConfig = dbRequest($connexion,"SELECT `ID`, `hardCurrency`, `softCurrency`, `population`, `ressource_1`, `ressource_2`, `ressource_3`, `ressource_4`, `ressource_5`, `ressource_6` FROM `players` WHERE `facebookID` = :id", array(':id'=>$_POST['facebookID']), true);
		
		if(!count($playerConfig) || !count($rocketConfig)){
			return "0=invalid params";
		}
		$playerConfig = $playerConfig[0];
		$rocketConfig = $rocketConfig[0];
		
		$canBuild = true;
		if($playerConfig['softCurrency'] < $rocketConfig['softCost']){
			$canBuild = false;
		}
		else if($playerConfig['population'] < $rocketConfig['dogeCost']){
			$canBuild = false;
		}
		else{
			for($i=1; $i<7; $i++){
				if($playerConfig['ressource_'.$i] < $rocketConfig['ressource_cost_'.$i]){
					$canBuild = false;
				}
			}
		}

		if($canBuild){
			$str = "UPDATE `players` SET `softCurrency`= :soft,`ressource_1`= :r1,`ressource_2`= :r2,`ressource_3`= :r3,`ressource_4`= :r4,`ressource_5`= :r5,`ressource_6`= :r6, `population`= :doge WHERE `facebookID` = :id";
			
			$playerConfig['softCurrency'] -= $rocketConfig['softCost'];
			$playerConfig['population']   -= $rocketConfig['dogeCost'];

			$params = array(':id'=>$_POST['facebookID'], ':soft'=>$playerConfig['softCurrency'], ':doge'=>$playerConfig['population']);
			
			for($i=1; $i<7; $i++){
				$playerConfig['ressource_'.$i] -= $rocketConfig['ressource_cost_'.$i];
				$params['r'.$i] = $playerConfig['ressource_'.$i];
			}

			dbRequest($connexion, $str, $params, false);

			dbRequest($connexion,"INSERT INTO `builded_rockets`(`ID`, `playerFbID`, `rocketID`, `buildingEnd`, `travelEnd`) VALUES ('',:id,:rocketID,:buildEnd,'')",array(':id' => $_POST["facebookID"], ':rocketID' => $rocketConfig['ID'], ':buildEnd' => date("Y-m-d H:i:s",time() + $rocketConfig['constructionDuration'])), false);

			return $connexion->lastInsertId();
		}
		else{
			return "0=not enough ressources";
		}
	}
	function get_rocket_info ($connexion){
		$rocket = dbRequest($connexion,"SELECT `rocketID`, `buildingEnd`, `travelEnd`,`isBuilded`,`isOver` FROM `builded_rockets` WHERE ID = :id",array(':id' => $_POST['rocket_builded_id']),true);
		if(!count($rocket)){
			return "0=Invalid ID";
		}
		$rocket = $rocket[0];

		$rocketConfig = dbRequest($connexion,"SELECT `clickTimeReward`, `travelDuration`, `constructionDuration`,`destinationID` FROM `rockets` WHERE `ID` = :id",array(':id' => $rocket["rocketID"]),true);
		if(!count($rocketConfig)){
			return "0=Invalid rocket ref";
		}
		$rocketConfig  = $rocketConfig[0];
		return [$rocket,$rocketConfig];
	}
	function check_rocket_construction_end ($connexion, $rocketInfo, $maxClickPerSecond){
		$rocket = $rocketInfo[0];
		$rocketConfig = $rocketInfo[1];
		if(!$rocket['isBuilded']){
			$clickBonusPercent = min($rocketConfig["constructionDuration"] * $maxClickPerSecond, $_POST["clickNb"]) * $rocketConfig["clickTimeReward"];
			$rocketEndTime = strtotime($rocket['buildingEnd']) - $clickBonusPercent*$rocketConfig["constructionDuration"];
			if(time() >= $rocketEndTime){
				dbRequest($connexion,"UPDATE `builded_rockets` SET `isBuilded`= 1 WHERE `ID` = :id",array(':id' => $_POST['rocket_builded_id']),false);
				return "1";
			}
			else {
				return '{"durationLeft":"'. ($rocketEndTime - time()) .'"}';
			}
		}
		else {
			return "1";
		}
	}
	function launch_rocket ($connexion, $rocketInfo){
		$rocket = $rocketInfo[0];
		$rocketConfig = $rocketInfo[1];
		if(!$rocket['isBuilded']){
			return "0=Rocket not builded";
		}
		if($rocket['travelEnd'] != "0000-00-00 00:00:00"){
			return "0=Rocket already launched";
		}
		dbRequest($connexion,"UPDATE `builded_rockets` SET `travelEnd`=:dateEnd WHERE ID = :id",array(':dateEnd' => date("Y-m-d H:i:s",time() + $rocketConfig['travelDuration']), ':id' => $_POST['rocket_builded_id']),false);
		return "1";
	}
	function check_rocket_travel_end ($connexion, $rocketInfo) {
		$rocket = $rocketInfo[0];
		$rocketConfig = $rocketInfo[1];
		if(!$rocket['isBuilded']){
			return "0=Rocket not builded";
		}
		if(!$rocket['isOver']){
			/*$maxClickPerSecond = 10; //pour contrôler la triche au nombre de click (comme c'est l'user qui envoie son nombre de click on limite à 10/sec)
			$clickBonusPercent = min($rocketConfig["travelDuration"] * $maxClickPerSecond, $_POST["clickNb"]) * $rocketConfig["clickTimeReward"];*/
			$rocketEndTime = strtotime($rocket['travelEnd']) /*- $clickBonusPercent*$rocketConfig["travelDuration"]*/;
			if(time() >= $rocketEndTime){
				dbRequest($connexion,"UPDATE `builded_rockets` SET `isOver`= 1 WHERE `ID` = :id",array(':id' => $_POST['rocket_builded_id']),false);

				$planet = dbRequest($connexion,"SELECT `meansRewardMax`, `meansRewardMin`, `ressource_ratio_1`, `ressource_ratio_2`, `ressource_ratio_3`, `ressource_ratio_4`, `ressource_ratio_5`, `ressource_ratio_6` FROM `planets` WHERE ID = :id", array(':id' => $rocketConfig["destinationID"]),true);
				if(!count($planet)){
					return "0=Wrong planet ID";
				}
				$planet = $planet[0];

				$artefacts =  dbRequest($connexion,"SELECT `ID`, `ref`, `rarity`, `facebookID` FROM `artefacts` WHERE planetID = :id", array(":id"=>$rocketConfig["destinationID"]),true);
				if(!count($artefacts)){
					return "0= Wrong planet ID";
				}

				$ressourceNb = rand($planet["meansRewardMin"],$planet["meansRewardMax"]);
				$ressources = [];
				for($i=1;$i<7;$i++){
					array_push($ressources, $ressourceNb * $planet['ressource_ratio_'.$i]);
				}

				$artefactsFound = [];
				foreach ($artefacts as $artefact) {
					if(rand(1, 1/$artefact["rarity"]) == 1){
						dbRequest($connexion,"INSERT INTO `collected_artefacts`(`ID`, `artefactID`, `playerFbID`) VALUES ('',:artId,:id)", array(':id'=>$_POST['facebookID'], ':artId'=>$artefact["ID"]),false);
						array_push($artefactsFound, array("name" => $artefact["ref"], "facebookID" => $artefact["facebookID"]) );
					}
				}
				return json_encode(array("ressources" => $ressources, "artefacts" => $artefactsFound) );
			}
			else {
				return '{"durationLeft":"'. ($rocketEndTime - time()) .'"}';
			}
		}
		else {
			return "0=Rocket already returned";
		}
	}

	function destroy_rocket ($connexion){
		dbRequest($connexion,"DELETE FROM `builded_rockets` WHERE `ID` = :id",array(':id'=>$_POST['rocket_builded_id']), false);
		echo "1";
	}

	function get_friend_artefacts ($connexion){
		$params = ["id"=>$_POST["friendID"]];
		$str = "SELECT  artefacts.facebookID, COUNT(*) as nb FROM `collected_artefacts` JOIN `artefacts` ON collected_artefacts.artefactID = artefacts.ID WHERE collected_artefacts.playerFbID = :id && ( ";

		$_POST["artefactsID"] = json_decode($_POST["artefactsID"]);
		for($i=0;$i<count($_POST["artefactsID"]);$i++){
			$str .= " artefacts.facebookID = :id" . $i . " || ";
			$params[':id'.$i] = $_POST["artefactsID"][$i];
		}
		$str = substr($str,0,count($str)-4); // get rid of the last "||"
		$str .= " ) GROUP BY artefacts.facebookID ORDER BY nb DESC";

		$artefacts = dbRequest($connexion,$str,$params,true);

		$arr = [];
		foreach ($artefacts as $artefact) {
			$arr[$artefact["facebookID"]] = $artefact["nb"];
		}
		return json_encode($arr);
	}
	function give_artefact ($connexion){
		if(!isset($_POST["friendID"]) || !isset($_POST["artefactFbID"])){
			return "0=not enough data";
		}
		if($_POST["friendID"] == $_POST["facebookID"]) {
			return "0=can't give to yourself";
		}

		$artefact = dbRequest($connexion,"SELECT collected_artefacts.ID FROM `collected_artefacts` JOIN `artefacts` ON artefacts.ID = collected_artefacts.artefactID WHERE artefacts.facebookID = :artefactID && collected_artefacts.playerFbID = :id",array(":artefactID"=>$_POST["artefactFbID"],":id"=>$_POST['facebookID']),true);
		if(!count($artefact)){
			return "0=No artefact";
		}

		$artefact = $artefact[0];
		dbRequest($connexion,"UPDATE `collected_artefacts` SET `playerFbID`=:friendID WHERE `ID`=:artefactID",array(":friendID"=>$_POST["friendID"],":artefactID"=>$artefact["ID"]),false);

		return "1";
	}
	function get_my_artefacts($connexion) {

		$artefacts = dbRequest($connexion,"SELECT artefacts.facebookID, COUNT(*) as nb FROM `collected_artefacts` JOIN `artefacts` ON artefacts.ID = collected_artefacts.artefactID WHERE collected_artefacts.playerFbID = :id GROUP BY artefacts.facebookID ORDER BY nb DESC  ",array(":id"=>$_POST['facebookID']),true);
		
		$arr = [];
		foreach ($artefacts as $artefact) {
			$arr[$artefact["facebookID"]] = $artefact["nb"];
		}
		return json_encode($arr);
	}
	function check_quest_completion($connexion){
		if(!isset($_POST["questID"])){
			return "0=missing information";
		}

		$questFinished = dbRequest($connexion,"SELECT `ID` FROM `quests_finished` WHERE `playerFbID` = :id && `questID` = :questID", array(":id"=>$_POST['facebookID'],":questID"=>$_POST["questID"]),true);
		if(count($questFinished)){
			return "0=Quest already finished";
		}

		$quest = dbRequest($connexion,"SELECT `buildingID`, `nbOfBuildings`, `rocketsConstructedNb`, `rocketsLaunchedNb`, `fric`, `ressource_1`, `ressource_2`, `ressource_3`, `ressource_4`, `ressource_5`, `ressource_6` FROM `quests` WHERE `ID` = :id", array(":id"=>$_POST["questID"]),true);
		if(!count($quest)){
			return "0=invalid ID";
		}
		$quest = $quest[0];
		$questAcomplished = false;

		if($quest["buildingID"] && $quest["nbOfBuildings"]){
			$buildings = dbRequest($connexion,"SELECT `ID` FROM `builded_buildings` WHERE `buildingID` = :buildID && playerFbID = :id && `isBuilded` = 1",array(":buildID"=>$quest["buildingID"], ":id"=>$_POST['facebookID']),true);
			if(count($buildings) < $quest["nbOfBuildings"]){
				return json_encode(["nbBuilding"=>count($buildings), "nbToBuild"=> $quest["nbOfBuildings"]]);
			}
		}
		else if($quest["rocketsConstructedNb"]){
			$rockets = dbRequest($connexion,"SELECT `ID` FROM `builded_rockets` WHERE playerFbID = :id && `isBuilded` = 1 ",array(":id"=>$_POST['facebookID']),true);
			if(count($rockets) < $quest["rocketsConstructedNb"]){
				return json_encode(["rocketBuilded"=>count($rockets), "rocketToBuild"=>$quest["rocketsConstructedNb"]]);
			}
		}
		else if($quest["rocketsLaunchedNb"]){
			$rockets = dbRequest($connexion,"SELECT `ID` FROM `builded_rockets` WHERE playerFbID = :id && `travelEnd` != '0000-00-00 00:00:00' ",array(":id"=>$_POST['facebookID']),true);
			if(count($rockets) < $quest["rocketsLaunchedNb"]){
				return json_encode(["rocketsLaunched"=>count($rockets), "rocketsToLaunch"=>$quest["rocketsLaunchedNb"]]);
			}
		}

		$str = "UPDATE `players` SET `softCurrency`=softCurrency+:fric";
		$params = [];
		for($i=1; $i<7; $i++){
			$str .= ",ressource_". $i . "=ressource_" . $i . "+:r" . $i;
			$params["r".$i] = $quest["ressource_" . $i];
		}
		$str .= " WHERE facebookID = :id";
		$params[":fric"] = $quest["fric"];
		$params[":id"] = $_POST["facebookID"];
		dbRequest($connexion,$str,$params,false);
		
		dbRequest($connexion,"INSERT INTO `quests_finished`(`ID`, `playerFbID`, `questID`) VALUES ('',:id,:questID)", array(":id"=>$_POST['facebookID'],":questID"=>$_POST["questID"]),false);

		return "1";

	}
	function update_ressources($connexion, $gameInfo) {
		// need fichier gameplay config in JSON
		$player = dbRequest($connexion,"SELECT `gameTime`, `hardCurrency`, `softCurrency`, `ressource_1`, `ressource_2`, `ressource_3`, `ressource_4`, `ressource_5`, `ressource_6`, `population`, `populationMax`, `faithPercent`, `lastTimeUpdated` FROM `players` WHERE `facebookID` = :id", array(":id"=>$_POST["facebookID"]),true);
		if(!count($player)){
			return "0=Wrong player id";
		}
		$player = $player[0];

		$_POST["churchClicks"] = isset($_POST["churchClicks"]) ? $_POST["churchClicks"] : 0;
		$_POST["museumClicks"] = isset($_POST["museumClicks"]) ? $_POST["museumClicks"] : 0;


		$delta_time = time() - strtotime($player["lastTimeUpdated"]);
		$player["lastTimeUpdated"] = time();

		$chuches = dbRequest($connexion, "SELECT `ID` FROM `builded_buildings` WHERE isBuilded = 1 && playerFbID = :id && (buildingID = 258 || buildingID = 514 || buildingID = 770)", array(":id"=>$_POST["facebookID"]),true);
		if(count($chuches)){
			$faithClicks = $delta_time * $gameInfo["maxClickPerSecond"] > $_POST["churchClicks"] ?  $_POST["churchClicks"] : 0;
			$player["faithPercent"] = min(max($player["faithPercent"] - $gameInfo["faithLossSpeed"] * $delta_time + $gameInfo["prayerEffect"] * $faithClicks, 0), 1);
		}		

		$museums = dbRequest($connexion, "SELECT `ID` FROM `builded_buildings` WHERE isBuilded = 1 && playerFbID = :id && (buildingID = 269 || buildingID = 525 || buildingID = 781)", array(":id"=>$_POST["facebookID"]),true);
		if(count($museums)){
			$museumClicks = $delta_time * $gameInfo["maxClickPerSecond"] > $_POST["museumClicks"] ?  $_POST["museumClicks"] : 0;
			$player["softCurrency"] += $gameInfo["museeSoftSpeed"] * $delta_time + $museumClicks * $gameInfo['musseVisiteGain'];
		}

		$niches = dbRequest($connexion,"SELECT sum(case when buildingID = 266 then 1 else 0 end) nicheLv1,
		    sum(case when buildingID = 525 then 1 else 0 end) nicheLv2,
		    sum(case when buildingID = 778 then 1 else 0 end) nicheLv3 FROM `builded_buildings` WHERE `playerFbID` = :id", array(":id"=>$_POST["facebookID"]),true);

		$niches = $niches[0];
		$dogeSpeed = $niches["nicheLv1"] * $gameInfo['nicheLv1']['dogepersecond'] + $niches["nicheLv2"] * $gameInfo['nicheLv2']['dogepersecond'] + $niches["nicheLv3"] * $gameInfo['nicheLv3']['dogepersecond'];
		$player["population"]  = min($player["population"] + $dogeSpeed * $delta_time, $player["populationMax"]);

		dbRequest($connexion, "UPDATE `players` SET `softCurrency`=:fric, `population`= :pop, `faithPercent`=:faith, `lastTimeUpdated`=:time WHERE facebookID = :id", array(":id"=>$_POST["facebookID"], ":fric"=>$player["softCurrency"], ":pop"=>$player["population"], ":faith"=>$player["faithPercent"], ":time"=>date("Y-m-d H:i:s")),false);
		
		return json_encode($player);
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
?>
