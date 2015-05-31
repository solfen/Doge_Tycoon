<?php
ini_set('display_errors',1);
session_start();
include("../vendor/autoload.php");
include("config.php");
use Facebook\FacebookSession;
use Facebook\FacebookRequest;
use Facebook\GraphUser;
use Facebook\FacebookRequestException;
use Facebook\FacebookCanvasLoginHelper;
use Facebook\FacebookRedirectLoginHelper;
 
/**
 <SECURITY>
*/
echo "security enabeled remove security to continue";
die(); 
/**
 </SECURITY>
*/

$APP_ID = "855211017867902";
$APP_SECRET = "ed316cbb88696b4a16f4a53a77aff738";
$artefacts = [
   /* ["name" => "Skate","img" => "IconArtefactsSimpsons1.png"],
    ["name" => "Beer","img" => "IconArtefactsSimpsons2.png"],
    ["name" => "Donut","img" => "IconArtefactsSimpsons3.png"],
    ["name" => "Hair","img" => "IconArtefactsLotr1.png"],
    ["name" => "Sting","img" => "IconArtefactsLotr2.png"],
    ["name" => "Precious","img" => "IconArtefactsLotr3.png"],
    ["name" => "Armor","img" => "IconArtefactsDbz1.png"],
    ["name" => "Kinto-un","img" => "IconArtefactsDbz2.png"],*/
    ["name" => "Dragon-Ball","img" => "IconArtefactsDbz3.png"],
    ["name" => "Pot","img" => "IconArtefactsTerre1.png"],
    ["name" => "Boot","img" => "IconArtefactsTerre2.png"],
    ["name" => "Smartphone","img" => "IconArtefactsTerre3.png"],
    /*["name" => "Hat","img" => "IconArtefactsWonderland1.png"],
    ["name" => "Cup","img" => "IconArtefactsWonderland2.png"],
    ["name" => "Potion","img" => "IconArtefactsWonderland3.png"],
    ["name" => "Helmet","img" => "IconArtefactsStarwars1.png"],
    ["name" => "Saber","img" => "IconArtefactsStarwars2.png"],
    ["name" => "Blaster","img" => "IconArtefactsStarwars3.png"],*/
];


FacebookSession::setDefaultApplication($APP_ID,$APP_SECRET);

$connexion = new PDO($src, $user, $pwd);
$connexion->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
 
$session = new FacebookSession("855211017867902|hnIzpY5DttAJFyQ4pAaowAzcopY");
try {

    //ajout BDD des objets des artefacts de l'app fb
    $response = (new FacebookRequest($session, 
        'GET',
        '/app/objects/space_dogs_tycoon:artefact?fields=id,title'
    ))->execute();
    $response = $response->getGraphObject()->getProperty('data')->asArray();
    foreach ($response as $key) {
        $str = "INSERT INTO `artefacts`(`ID`, `ref`, `planetID`, `rarity`, `facebookID`) VALUES ('', :ref ,'','1', :fbID )";
        $requete = $connexion->prepare($str);
        $requete->execute(array(':ref'=>$key->title,':fbID' => $key->id));
        //$resultat = $requete->fetchAll();
    }

    die();

    // création des artefacts dans FB
    for($i=0;$i<count($artefacts);$i++){
        $artefact = $artefacts[$i];
        $response = (new FacebookRequest($session, 
            'POST',
            '/app/objects/space_dogs_tycoon:artefact',
            array(
            'object' => "{
                'og:url' : 'https://fbgame.isartdigital.com/isartdigital/dogeexplorer/FbObjects/".$artefact["name"].".html',
                'og:title' : '".$artefact["name"]."',
                'og:type' : 'space_dogs_tycoon:artefact',
                'og:image' : 'https://fbgame.isartdigital.com/isartdigital/dogeexplorer/FbObjects/Imgs/".$artefact["img"]."',
                'og:description' : 'An awesome ".$artefact['name']."',
                'fb:app_id' : '855211017867902'
            }"
        ) ))->execute();
    }
} 
catch (FacebookRequestException $ex) {
    echo $ex->getMessage();
} 
catch (\Exception $ex) {
    echo $ex->getMessage();
}
catch (PDOExeption $e) {

            echo '{"error":"'.$e->getMessage().'"}';
            die();

        }
// handle the response
?>