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
 
$APP_ID = "855211017867902";
$APP_SECRET = "ed316cbb88696b4a16f4a53a77aff738";
FacebookSession::setDefaultApplication($APP_ID,$APP_SECRET);

$connexion = new PDO($src, $user, $pwd);
$connexion->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
$connexion->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
if($_GET['request_ids'])
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
    try{
        $request = new FacebookRequest($session, 'GET', '/me?fields=id,name,email');
        $response = $request->execute();
        $graphObject = $response->getGraphObject();
        $graphObject = $response->getGraphObject(GraphUser::className());
    }
    catch(FacebookSDKException $e){
        echo "Session Error please refresh";
        die();
    }
    $arr = $graphObject->asArray();

    $id = $arr["id"];
    $name = $arr["name"];
    $email = array_key_exists("email",$arr) ? $arr["email"] : '';

    $requete = $connexion->prepare('SELECT `facebookID` FROM `players` WHERE facebookID =:id');
    $requete->execute(array(':id'=>$id));
    $resultat = $requete->fetchAll();

    if(count($resultat) == 0){ // si pas de réponse, nouveau joueur
        $requete = $connexion->prepare('INSERT INTO `players`(`ID`, `facebookID`, `login`, `email`, `level`) VALUES ("",:id,:name,:email,1)');
        $resultat = $requete->execute( array(':id' => $id,':name'=>$name,':email'=>$email) );
    }
    $_SESSION["facebookID"] = $id;
    
    echo '<script>window.location.replace("/bin/index.html")</script>'; 
}
else
{
    //Si l'utilisateur n'a pas encore autorisé l'application
    $helper = new FacebookRedirectLoginHelper("https://apps.facebook.com/".$APP_ID."/");
    $auth_url = $helper->getLoginUrl(['email','publish_actions']);
    echo '<script>top.location.href = "'.$auth_url.'";</script>';
}
?>