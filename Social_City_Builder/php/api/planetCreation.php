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

$planets = [
    'SprungField' => [
        "totalRessourceMax" => 1000,     
        "totalRessourceMin" => 500,
        "ratio1" => 0.5,
        "ratio2" => 0.25,
        "ratio3" => 0.25,
        "ratio4" => 0,
        "ratio5" => 0,
        "ratio6" => 0     
    ],
    'Mordor' => [
        "totalRessourceMax" => 1000,
        "totalRessourceMin" => 500,
        "ratio1" => 0.5,
        "ratio2" => 0.25,
        "ratio3" => 0.25,
        "ratio4" => 0,
        "ratio5" => 0,
        "ratio6" => 0
    ],
    'Namok' => [
        "totalRessourceMax" => 1000,
        "totalRessourceMin" => 500,
        "ratio1" => 0.5,
        "ratio2" => 0.25,
        "ratio3" => 0.25,
        "ratio4" => 0,
        "ratio5" => 0,
        "ratio6" => 0
    ],
    'Terre' => [
        "totalRessourceMax" => 1000,
        "totalRessourceMin" => 500,
        "ratio1" => 0.5,
        "ratio2" => 0.25,
        "ratio3" => 0.25,
        "ratio4" => 0,
        "ratio5" => 0,
        "ratio6" => 0
    ],
    'Wunderland' => [
        "totalRessourceMax" => 1000,
        "totalRessourceMin" => 500,
        "ratio1" => 0.5,
        "ratio2" => 0.25,
        "ratio3" => 0.25,
        "ratio4" => 0,
        "ratio5" => 0,
        "ratio6" => 0
    ],
    'StarWat' => [
        "totalRessourceMax" => 1000,
        "totalRessourceMin" => 500,
        "ratio1" => 0.5,
        "ratio2" => 0.25,
        "ratio3" => 0.25,
        "ratio4" => 0,
        "ratio5" => 0,
        "ratio6" => 0
    ]
];


try {
    foreach ($planets as $key => $value) {
        $str = "INSERT INTO `planets`(`ID`, `ref`, `meansRewardMax`, `meansRewardMin`, `ressource_ratio_1`, `ressource_ratio_2`, `ressource_ratio_3`, `ressource_ratio_4`, `ressource_ratio_5`, `ressource_ratio_6`) VALUES ('', :ref, :max, :min, :ratio1, :ratio2, :ratio3, :ratio4, :ratio5, :ratio6)";
        $requete = $connexion->prepare($str);
        $requete->execute(array(':ref'=>$key, ':max' => $value['totalRessourceMax'], ':min' => $value['totalRessourceMin'], ':ratio1' => $value['ratio1'], ':ratio2' => $value['ratio2'], ':ratio3' => $value['ratio3'], ':ratio4' => $value['ratio4'], ':ratio5' => $value['ratio5'], ':ratio6' => $value['ratio6']));
        //$resultat = $requete->fetchAll();
    }
} 
catch (PDOExeption $e) {

    echo '{"error":"'.$e->getMessage().'"}';
    die();

}

?>
