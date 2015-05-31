<?php
session_start();
ini_set('display_errors',1);
include("config.php");

/**
    <SECURITY>
*/
echo "security enabeled remove security to continue";
die(); 
/**
    </SECURITY>
*/

$connexion = new PDO($src, $user, $pwd);
$connexion->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

$ressources = [
    "JauneLv1" => [
        "fric" => 1000,
        "hard" => 0,
        "doges" => 10,
        "r0" => 10,
        "r1" => 25,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
        "constructionTime" => 1, //sec
        "clickBonus" => 0.01,
        "timeToDestination" => 5, //sec
        "destination" => "SprungField"
    ],
    "JauneLv2" => [
        "fric" => 1000,
        "hard" => 0,
        "doges" => 10,
        "r0" => 10,
        "r1" => 25,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
        "constructionTime" => 60, //sec
        "clickBonus" => 0.005,
        "timeToDestination" => 600, //sec
        "destination" => "SprungField"
    ],
    "JauneLv3" => [
        "fric" => 1000,
        "hard" => 0,
        "doges" => 10,
        "r0" => 10,
        "r1" => 25,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
        "constructionTime" => 60, //sec
        "clickBonus" => 0.0025,
        "timeToDestination" => 600, //sec
        "destination" => "SprungField"
    ],
    "VertLv1" => [
        "fric" => 1000,
        "hard" => 0,
        "doges" => 10,
        "r0" => 10,
        "r1" => 25,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
        "constructionTime" => 60, //sec
        "clickBonus" => 0.01,
        "timeToDestination" => 600, //sec
        "destination" => "Mordor"
    ],
    "VertLv2" => [
        "fric" => 1000,
        "hard" => 0,
        "doges" => 10,
        "r0" => 10,
        "r1" => 25,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
        "constructionTime" => 60, //sec
        "clickBonus" => 0.005,
        "timeToDestination" => 600, //sec
        "destination" => "Mordor"
    ],
    "VertLv3" => [
        "fric" => 1000,
        "hard" => 0,
        "doges" => 10,
        "r0" => 10,
        "r1" => 25,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
        "constructionTime" => 60, //sec
        "clickBonus" => 0.0025,
        "timeToDestination" => 600, //sec
        "destination" => "Mordor"
    ],
    "CyanLv1" => [
        "fric" => 1000,
        "hard" => 0,
        "doges" => 10,
        "r0" => 10,
        "r1" => 25,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
        "constructionTime" => 60, //sec
        "clickBonus" => 0.01,
        "timeToDestination" => 600, //sec
        "destination" => "Namok"
    ],
    "CyanLv2" => [
        "fric" => 1000,
        "hard" => 0,
        "doges" => 10,
        "r0" => 10,
        "r1" => 25,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
        "constructionTime" => 60, //sec
        "clickBonus" => 0.005,
        "timeToDestination" => 600, //sec
        "destination" => "Namok"
    ],
    "CyanLv3" => [
        "fric" => 1000,
        "hard" => 0,
        "doges" => 10,
        "r0" => 10,
        "r1" => 25,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
        "constructionTime" => 60, //sec
        "clickBonus" => 0.0025,
        "timeToDestination" => 600, //sec
        "destination" => "Namok"
    ],
    "BleuLv1" => [
        "fric" => 1000,
        "hard" => 0,
        "doges" => 10,
        "r0" => 10,
        "r1" => 25,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
        "constructionTime" => 60, //sec
        "clickBonus" => 0.01,
        "timeToDestination" => 600, //sec
        "destination" => "Terre"
    ],
    "BleuLv2" => [
        "fric" => 1000,
        "hard" => 0,
        "doges" => 10,
        "r0" => 10,
        "r1" => 25,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
        "constructionTime" => 60, //sec
        "clickBonus" => 0.005,
        "timeToDestination" => 600, //sec
        "destination" => "Terre"
    ],
    "BleuLv3" => [
        "fric" => 1000,
        "hard" => 0,
        "doges" => 10,
        "r0" => 10,
        "r1" => 25,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
        "constructionTime" => 60, //sec
        "clickBonus" => 0.0025,
        "timeToDestination" => 600, //sec
        "destination" => "Terre"
    ],
    "VioletLv1" => [
        "fric" => 1000,
        "hard" => 0,
        "doges" => 10,
        "r0" => 10,
        "r1" => 25,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
        "constructionTime" => 60, //sec
        "clickBonus" => 0.01,
        "timeToDestination" => 600, //sec
        "destination" => "Wunderland"
    ],
    "VioletLv2" => [
        "fric" => 1000,
        "hard" => 0,
        "doges" => 10,
        "r0" => 10,
        "r1" => 25,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
        "constructionTime" => 60, //sec
        "clickBonus" => 0.005,
        "timeToDestination" => 600, //sec
        "destination" => "Wunderland"
    ],
    "VioletLv3" => [
        "fric" => 1000,
        "hard" => 0,
        "doges" => 10,
        "r0" => 10,
        "r1" => 25,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
        "constructionTime" => 60, //sec
        "clickBonus" => 0.0025,
        "timeToDestination" => 600, //sec
        "destination" => "Wunderland"
    ],
    "OrangeLv1" => [
        "fric" => 1000,
        "hard" => 0,
        "doges" => 10,
        "r0" => 10,
        "r1" => 25,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
        "constructionTime" => 60, //sec
        "clickBonus" => 0.01,
        "timeToDestination" => 600, //sec
        "destination" => "StarWat"
    ],
    "OrangeLv2" => [
        "fric" => 1000,
        "hard" => 0,
        "doges" => 10,
        "r0" => 10,
        "r1" => 25,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
        "constructionTime" => 60, //sec
        "clickBonus" => 0.005,
        "timeToDestination" => 600, //sec
        "destination" => "StarWat"
    ],
    "OrangeLv3" => [
        "fric" => 1000,
        "hard" => 0,
        "doges" => 10,
        "r0" => 10,
        "r1" => 25,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
        "constructionTime" => 60, //sec
        "clickBonus" => 0.0025,
        "timeToDestination" => 600, //sec
        "destination" => "StarWat"
    ]
];

try {
    foreach ($ressources as $key => $value) {
        $str = "SELECT `ID` FROM `planets` WHERE `ref` = :dest";
        $requete = $connexion->prepare($str);
        $requete->execute(array(':dest'=>$value['destination']));
        $resultat = $requete->fetchAll();

        $str = "INSERT INTO `rockets`(`ID`, `ref`, `destinationID`, `hardCost`, `softCost`, `dogeCost`, `clickTimeReward`, `travelDuration`, `constructionDuration`, `ressource_cost_1`, `ressource_cost_2`, `ressource_cost_3`, `ressource_cost_4`, `ressource_cost_5`, `ressource_cost_6`) VALUES ('', :ref, :dest, :hard, :soft, :doge, :clickBonus, :destTime, :constrTime, :r1, :r2, :r3, :r4, :r5, :r6)";
        $requete = $connexion->prepare($str);
        $requete->execute(array(':ref'=>$key, ':dest'=>$resultat[0]["ID"], ':soft' => $value['fric'], ':hard' => $value['hard'], ':doge' => $value['doges'], ':clickBonus' => $value['clickBonus'], ':destTime' => $value['timeToDestination'], ':constrTime' => $value['constructionTime'], ':r1' => $value['r1'],':r2' => $value['r2'], ':r3' => $value['r3'], ':r4' => $value['r4'], ':r5' => $value['r5'], ':r6' => $value['r6']));
    }
} 
catch (PDOExeption $e) {

    echo '{"error":"'.$e->getMessage().'"}';
    die();

}
?>
