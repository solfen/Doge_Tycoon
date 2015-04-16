<?php

	error_reporting(E_ALL);
	include 'config.php';
	//session_start();

	foreach ($_POST as $key => $value) {

		$_POST[$key] = addslashes($value);
	}

	//print_r($_POST);

	if (empty($_POST['facebookID']) || empty($_POST['event_name'])) {

		error('missing information');
	}

	$connexion = new PDO($src, $user, $pwd);
	$connexion->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

	$config = [
		'connexion' => $connexion,
		'facebookID' => $_POST['facebookID']
	];

	$config['player_data'] = get_all_player_data($config);

	if (!$config['player_data']) {

		error('no player_data');
	}

	// 1 : update data if possible
	// 2 : send usefull data about the player: level, hardCurrency, softCurrency, ressource_1, ressource_2, ressource_3, ressource_4, ressource_5, ressource_6, meansQttMax, population, populationMax, collected_artefacts[], builded_buildings[], explored_planets[], player_quests[], player_rocket[];

	switch ($_POST['event_name']) {
		
		case 'buy_hard':
			buy_hard($config, $_POST['quantity']);
		break;
		case 'buy_soft':
			buy_soft($config, $_POST['quantity']);
		break;
		case 'buy_plpp':
			buy_plpp($config, $_POST['quantity']);
		break;
		case 'sell_plpp':
			sell_plpp($config, $_POST['quantity']);
		break;
		case 'finish_quest':
			finish_quest($config, $_POST['quest_id']);
		break;
		case 'build_building':
			build_building($config, $_POST['building_ref']);
		break;
		case 'destroy_building':
			destroy_building($config, $_POST['building_id']);
		break;
		case 'build_rocket':
			build_rocket($config, $_POST['planet_dest_ref']);
		break;
		case 'launch_rocket':
			launch_rocket($config, $_POST['rocket_id']);
		break;
		default: // nothing good
			error('wrong event_name');
		break;
	}

/* ------------------------------------------------------------------ */

	function buy_hard ($config, $quantity) {

		echo "okay: ".$quantity;
	}

	function buy_soft ($config, $quantity) {

	}

	function buy_plpp ($config, $quantity) {

	}

	function sell_plpp ($config, $quantity) {

	}

	function accept_quest ($config, $quest_ref) {

	}

	function finish_quest ($config, $quest_id) {

	}

	function build_building ($config, $building_ref) {

	}

	function destroy_building ($config, $building_id) {

	}

	function build_rocket ($config, $planet_dest_ref) {

	}

	function launch_rocket ($config, $rocket_id) {

	}

/* ------------------------------------------------------------------ */

	function get_all_player_data ($config) {

		$player = get_db_select_query($config, '*', '`players`', '`facebookID`="'.$config['facebookID'].'"')[0];

		//print_r($player);
		//echo '<br>empty($player[ID]) ? '.empty($player['ID']).'<br>';

		if (empty($player['ID'])) {

			return null;
		}

		return [
			'player' => $player,
			'artefacts' => get_db_select_query($config, '*', '`collected_artefacts`', '`player_id`="'.$player['ID'].'"'),
			'buildings' => get_db_select_query($config, '*', '`builded_buildings`', '`player_id`="'.$player['ID'].'"'),
			'planets' => get_db_select_query($config, '*', '`explored_planets`', '`player_id`="'.$player['ID'].'"'),
			'quests' => get_db_select_query($config, '*', '`player_quests`', '`player_id`="'.$player['ID'].'"'),
			'rocket' => get_db_select_query($config, '*', '`player_rocket`', '`player_id`="'.$player['ID'].'"')
		];
	}

	function get_db_select_query ($config, $select, $from, $where) {

		$req = "SELECT $select FROM $from WHERE $where";

		try {

			return $config['connexion']->query($req)->fetchAll();

		} catch (PDOExeption $e) {

			echo '{"error":"'.$e->getMessage().'"}';
			die();

		}
	}

?>
