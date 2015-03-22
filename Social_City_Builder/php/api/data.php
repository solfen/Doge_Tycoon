<?php

	error_reporting(E_ALL);
	include 'config.php';

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
