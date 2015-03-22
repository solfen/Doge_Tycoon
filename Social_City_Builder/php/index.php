<?php
session_start();
include("vendor/autoload.php");
include("config.php");
use Facebook\FacebookSession;
use Facebook\FacebookRequest;
use Facebook\GraphUser;
use Facebook\FacebookRequestException;
use Facebook\FacebookCanvasLoginHelper;
use Facebook\FacebookRedirectLoginHelper;
 
$APP_ID = "597963723664837";
$APP_SECRET = "14ecee6ab4082ec9387f9c1203a2f4f1";
FacebookSession::setDefaultApplication($APP_ID,$APP_SECRET);

$connexion = new PDO($source, $user, $motDePasse);
$connexion->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
 
/**
Récupération d'une session si on a pas de token en mémoire
*/
$helper = new FacebookCanvasLoginHelper();
try
{
    $session = $helper->getSession();
}
catch(FacebookRequestException $ex)
{
    print_r($ex);
}
catch(\Exception $ex)
{
    print_r($ex);
}
 
/**
Passage d'un Short-lived token à un Long-lived token
*/
if($session)
{
    $accessToken = $session->getAccessToken();

    try
    {
        $longLivedAccessToken = $accessToken->extend();
    }
    catch(FacebookSDKException $e)
    {
        echo 'Error extending short-lived access token: '.$e->getMessage();
        exit;
    }

    // Enregistrer le token en BDD
}
 
 
/**
Appel à l'Open Graph de Facebook
*/
if($session)
{
    $request = new FacebookRequest($session, 'GET', '/me');
    $response = $request->execute();
    $graphObject = $response->getGraphObject();
    $graphObject = $response->getGraphObject(GraphUser::className());
    $arr = $graphObject->asArray();
    $id = $arr["id"];
    $name = $arr["name"];
    $email = "none"; //todo

    $requete = 'SELECT `facebookID` FROM `players` WHERE facebookID ="'.$id.'"';
    $resultat = $connexion->query($requete);
    if($resultat->rowCount() == 0){ // si pas de réponse, nouveau joueur
        $requete = 'INSERT INTO `players`(`ID`, `facebookID`, `login`, `email`, `level`) VALUES ("",'.$id.',"'.$name.',"'.$email.'",1)';
        $resultat = $connexion->query($requete);
    }  
}
else
{
    //Si l'utilisateur n'a pas encore autorisé l'application
    $helper = new FacebookRedirectLoginHelper("https://apps.facebook.com/".$APP_ID."/");
    $auth_url = $helper->getLoginUrl(['email']);
    echo 'Redirecting to Facebook authentication page, please wait...<script>top.location.href = "'.$auth_url.'";</script>';
}
?>