<?php

	error_reporting(E_ALL);
	include 'config.php';
	//session_start();

	foreach ($_POST as $key => $value) {

		$_POST[$key] = addslashes($value);
	}

	if (empty($_POST['player_id'])) {

		error();
	}

	$config = [
		"db_src" => $src,
		"db_user" => $user,
		"db_pwd" => $pwd,
		"player_id" => $_POST['player_id'] // THE "facebookID"
	]

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
		case 'accept_quest':
			accept_quest($config, $_POST['quest_ref']);
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
			error();
		break;
	}


	function buy_hard ($config, $quantity) {

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


/* exemple
	// ------------------------------------------------------- //
	// -------------< le traitement des erreurs >------------- //
	// ------------------------------------------------------- //

	// la recherche des erreurs, avec un renvoi au formulaire s'il y a une detection

	if (	empty($_POST['Nom'])
		||	empty($_POST['Prenom'])
		||	empty($_POST['DateDeNaissance'])
		||	empty($_POST['Photo'])
		||	empty($_POST['IDSteam'])
		||	empty($_POST['PourJarJar']))
	{
		header("Location:addOne.php?error=1");
		die();
	}

	try
	{
		// ---------------------------------------- //
		// -------------< la requete >------------- //
		// ---------------------------------------- //

		$connexion = new PDO($source, $user, $motDePasse);
		$connexion->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
		$requete = "INSERT INTO `copains` (`Nom`, `Prenom`, `DateDeNaissance`, `Photo`, `IDSteam`, `PourJarJar`) VALUES ("
					."'".addslashes($_POST['Nom'])."'"
					."'".addslashes($_POST['Prenom'])."'"
					."'".addslashes(strtotime($_POST['DateDeNaissance']))."'"
					."'".addslashes($_POST['Photo'])."'"
					."'".addslashes((int)$_POST['IDSteam'])."'"
					."'".addslashes((int)$_POST['PourJarJar'])."'"
					.")";
		$resultat = $connexion->query($requete);
	}
	catch (PDOExeption $e)
	{
		print 'PDO error : '.$e->getMessage().'<br>';
		die();
	}

	header("Location:index.php"); // si tout est bon, on revient à la liste des copains
*/


?>
