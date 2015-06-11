<?php
session_start();
ini_set('display_errors',1);
include("../config.php");

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

$CASINO          =   0x001;
$EGLISE          =   0x002;
$HANGAR_BLEU     =   0x003;
$HANGAR_CYAN     =   0x004;
$HANGAR_JAUNE    =   0x005;
$HANGAR_ROUGE    =   0x006;
$HANGAR_VERT     =   0x007;
$HANGAR_VIOLET   =   0x008;
$LABO            =   0x009;
$NICHE           =   0x00A;
$PAS_DE_TIR      =   0x00B;
$ENTREPOT        =   0x00C;
$MUSEE           =   0x00D;

$LVL_1           =   0x100;
$LVL_2           =   0x200;
$LVL_3           =   0x300;

$buildings = [
    $CASINO | $LVL_1 => [
        "width" => 3,
        "height" => 3,
        "building_time" => 30,
        "frames_nb" => 25,
        "img" => "CasinoLv1",
        "fric" => 1000,
        "hard" => 3,
        "doges" => 0,
        "r1" => 0,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
    ],
    $CASINO | $LVL_2 => [
        "width" => 3,
        "height" => 3,
        "building_time" => 60,
        "frames_nb" => 18,
        "img" => "CasinoLv2",
        "fric" => 1000,
        "hard" => 3,
        "doges" => 0,
        "r1" => 0,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
    ],
    $CASINO | $LVL_3 => [
        "width" => 3,
        "height" => 3,
        "building_time" => 90,
        "frames_nb" => 12,
        "img" => "CasinoLv3",
        "fric" => 1000,
        "hard" => 3,
        "doges" => 0,
        "r1" => 0,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
    ],
    $EGLISE | $LVL_1 => [
        "width" => 3,
        "height" => 3,
        "building_time" => 30,
        "frames_nb" => 13,
        "img" => "EgliseLv1",
        "fric" => 1000,
        "hard" => 3,
        "doges" => 0,
        "r1" => 0,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
    ],
    $EGLISE | $LVL_2 => [
        "width" => 3,
        "height" => 3,
        "building_time" => 60,
        "frames_nb" => 16,
        "img" => "EgliseLv2",
        "fric" => 1000,
        "hard" => 3,
        "doges" => 0,
        "r1" => 0,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
    ],
    $EGLISE | $LVL_3 => [
        "width" => 3,
        "height" => 3,
        "building_time" => 90,
        "frames_nb" => 16,
        "img" => "EgliseLv3",
        "fric" => 1000,
        "hard" => 3,
        "doges" => 0,
        "r1" => 0,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
    ],
    $HANGAR_BLEU | $LVL_1 => [
        "width" => 4,
        "height" => 2,
        "building_time" => 30,
        "frames_nb" => 1,
        "img" => "HangarBleuLv1",
        "fric" => 1000,
        "hard" => 3,
        "doges" => 0,
        "r1" => 0,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
    ],
    $HANGAR_BLEU | $LVL_2 => [
        "width" => 4,
        "height" => 2,
        "building_time" => 60,
        "frames_nb" => 1,
        "img" => "HangarBleuLv2",
        "fric" => 1000,
        "hard" => 3,
        "doges" => 0,
        "r1" => 0,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
    ],
    $HANGAR_BLEU | $LVL_3 => [
        "width" => 4,
        "height" => 2,
        "building_time" => 90,
        "frames_nb" => 1,
        "img" => "HangarBleuLv3",
        "fric" => 1000,
        "hard" => 3,
        "doges" => 0,
        "r1" => 0,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
    ],
    $HANGAR_CYAN | $LVL_1 => [
        "width" => 4,
        "height" => 2,
        "building_time" => 30,
        "frames_nb" => 1,
        "img" => "HangarCyanLv1",
        "fric" => 1000,
        "hard" => 3,
        "doges" => 0,
        "r1" => 0,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
    ],
    $HANGAR_CYAN | $LVL_2 => [
        "width" => 4,
        "height" => 2,
        "building_time" => 60,
        "frames_nb" => 1,
        "img" => "HangarCyanLv2",
        "fric" => 1000,
        "hard" => 3,
        "doges" => 0,
        "r1" => 0,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
    ],
    $HANGAR_CYAN | $LVL_3 => [
        "width" => 4,
        "height" => 2,
        "building_time" => 90,
        "frames_nb" => 1,
        "img" => "HangarCyanLv3",
        "fric" => 1000,
        "hard" => 3,
        "doges" => 0,
        "r1" => 0,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
    ],
    $HANGAR_JAUNE | $LVL_1 => [
        "width" => 4,
        "height" => 2,
        "building_time" => 30,
        "frames_nb" => 1,
        "img" => "HangarJauneLv1",
        "fric" => 1000,
        "hard" => 3,
        "doges" => 0,
        "r1" => 0,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
    ],
    $HANGAR_JAUNE | $LVL_2 => [
        "width" => 4,
        "height" => 2,
        "building_time" => 60,
        "frames_nb" => 1,
        "img" => "HangarJauneLv2",
        "fric" => 1000,
        "hard" => 3,
        "doges" => 0,
        "r1" => 0,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
    ],
    $HANGAR_JAUNE | $LVL_3 => [
        "width" => 4,
        "height" => 2,
        "building_time" => 90,
        "frames_nb" => 1,
        "img" => "HangarJauneLv3",
        "fric" => 1000,
        "hard" => 3,
        "doges" => 0,
        "r1" => 0,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
    ],
    $HANGAR_ROUGE | $LVL_1 => [
        "width" => 4,
        "height" => 2,
        "building_time" => 30,
        "frames_nb" => 1,
        "img" => "HangarRougeLv1",
        "fric" => 1000,
        "hard" => 3,
        "doges" => 0,
        "r1" => 0,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
    ],
    $HANGAR_ROUGE | $LVL_2 => [
        "width" => 4,
        "height" => 2,
        "building_time" => 60,
        "frames_nb" => 1,
        "img" => "HangarRougeLv2",
        "fric" => 1000,
        "hard" => 3,
        "doges" => 0,
        "r1" => 0,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
    ],
    $HANGAR_ROUGE | $LVL_3 => [
        "width" => 4,
        "height" => 2,
        "building_time" => 90,
        "frames_nb" => 1,
        "img" => "HangarRougeLv3",
        "fric" => 1000,
        "hard" => 3,
        "doges" => 0,
        "r1" => 0,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
    ],
    $HANGAR_VERT | $LVL_1 => [
        "width" => 4,
        "height" => 2,
        "building_time" => 30,
        "frames_nb" => 1,
        "img" => "HangarVertLv1",
        "fric" => 1000,
        "hard" => 3,
        "doges" => 0,
        "r1" => 0,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
    ],
    $HANGAR_VERT | $LVL_2 => [
        "width" => 4,
        "height" => 2,
        "building_time" => 60,
        "frames_nb" => 1,
        "img" => "HangarVertLv2",
        "fric" => 1000,
        "hard" => 3,
        "doges" => 0,
        "r1" => 0,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
    ],
    $HANGAR_VERT | $LVL_3 => [
        "width" => 4,
        "height" => 2,
        "building_time" => 90,
        "frames_nb" => 1,
        "img" => "HangarVertLv3",
        "fric" => 1000,
        "hard" => 3,
        "doges" => 0,
        "r1" => 0,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
    ],
    $HANGAR_VIOLET | $LVL_1 => [
        "width" => 4,
        "height" => 2,
        "building_time" => 30,
        "frames_nb" => 1,
        "img" => "HangarVioletLv1",
        "fric" => 1000,
        "hard" => 3,
        "doges" => 0,
        "r1" => 0,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
    ],
    $HANGAR_VIOLET | $LVL_2 => [
        "width" => 4,
        "height" => 2,
        "building_time" => 60,
        "frames_nb" => 1,
        "img" => "HangarVioletLv2",
        "fric" => 1000,
        "hard" => 3,
        "doges" => 0,
        "r1" => 0,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
    ],
    $HANGAR_VIOLET | $LVL_3 => [
        "width" => 4,
        "height" => 2,
        "building_time" => 90,
        "frames_nb" => 1,
        "img" => "HangarVioletLv3",
        "fric" => 1000,
        "hard" => 3,
        "doges" => 0,
        "r1" => 0,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
    ],
    $LABO | $LVL_1 => [
        "width" => 2,
        "height" => 2,
        "building_time" => 30,
        "frames_nb" => 1,
        "img" => "LaboLv1",
        "fric" => 1000,
        "hard" => 3,
        "doges" => 0,
        "r1" => 0,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
    ],
    $LABO | $LVL_2 => [
        "width" => 2,
        "height" => 2,
        "building_time" => 60,
        "frames_nb" => 1,
        "img" => "LaboLv2",
        "fric" => 1000,
        "hard" => 3,
        "doges" => 0,
        "r1" => 0,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
    ],
    $LABO | $LVL_3 => [
        "width" => 3,
        "height" => 3,
        "building_time" => 90,
        "frames_nb" => 1,
        "img" => "LaboLv3",
        "fric" => 1000,
        "hard" => 3,
        "doges" => 0,
        "r1" => 0,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
    ],
    $NICHE | $LVL_1 => [
        "width" => 1,
        "height" => 1,
        "building_time" => 30,
        "frames_nb" => 11,
        "img" => "NicheLv1",
        "fric" => 1000,
        "hard" => 3,
        "doges" => 0,
        "r1" => 0,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
    ],
    $NICHE | $LVL_2 => [
        "width" => 1,
        "height" => 1,
        "building_time" => 60,
        "frames_nb" => 33,
        "img" => "NicheLv2",
        "fric" => 1000,
        "hard" => 3,
        "doges" => 0,
        "r1" => 0,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
    ],
    $NICHE | $LVL_3 => [
        "width" => 1,
        "height" => 1,
        "building_time" => 90,
        "frames_nb" => 18,
        "img" => "NicheLv3",
        "fric" => 1000,
        "hard" => 3,
        "doges" => 0,
        "r1" => 0,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
    ],
    $PAS_DE_TIR | $LVL_1 => [
        "width" => 5,
        "height" => 5,
        "building_time" => 5,
        "frames_nb" => 23,
        "img" => "PasdetirLv1",
        "fric" => 1000,
        "hard" => 3,
        "doges" => 0,
        "r1" => 0,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
    ],
    $PAS_DE_TIR | $LVL_2 => [
        "width" => 5,
        "height" => 5,
        "building_time" => 60,
        "frames_nb" => 12,
        "img" => "PasdetirLv2",
        "fric" => 1000,
        "hard" => 3,
        "doges" => 0,
        "r1" => 0,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
    ],
    $PAS_DE_TIR | $LVL_3 => [
        "width" => 5,
        "height" => 5,
        "building_time" => 90,
        "frames_nb" => 7,
        "img" => "PasdetirLv3",
        "fric" => 1000,
        "hard" => 3,
        "doges" => 0,
        "r1" => 0,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
    ],
    $ENTREPOT | $LVL_1 => [
        "width" => 2,
        "height" => 2,
        "building_time" => 30,
        "frames_nb" => 4,
        "img" => "EntrepotLv1",
        "fric" => 1000,
        "hard" => 3,
        "doges" => 0,
        "r1" => 0,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
    ],
    $ENTREPOT | $LVL_2 => [
        "width" => 2,
        "height" => 2,
        "building_time" => 60,
        "frames_nb" => 4,
        "img" => "EntrepotLv2",
        "fric" => 1000,
        "hard" => 3,
        "doges" => 0,
        "r1" => 0,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
    ],
    $ENTREPOT | $LVL_3 => [
        "width" => 2,
        "height" => 2,
        "building_time" => 90,
        "frames_nb" => 4,
        "img" => "EntrepotLv3",
        "fric" => 1000,
        "hard" => 3,
        "doges" => 0,
        "r1" => 0,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
    ],
    $MUSEE | $LVL_1 => [
        "width" => 2,
        "height" => 2,
        "building_time" => 30,
        "frames_nb" => 1,
        "img" => "MuseeLv1",
        "fric" => 1000,
        "hard" => 3,
        "doges" => 0,
        "r1" => 0,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
    ],
    $MUSEE | $LVL_2 => [
        "width" => 2,
        "height" => 2,
        "building_time" => 60,
        "frames_nb" => 1,
        "img" => "MuseeLv2",
        "fric" => 1000,
        "hard" => 3,
        "doges" => 0,
        "r1" => 0,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
    ],
    $MUSEE | $LVL_3 => [
        "width" => 2,
        "height" => 3,
        "building_time" => 90,
        "frames_nb" => 1,
        "img" => "MuseeLv3",
        "fric" => 1000,
        "hard" => 3,
        "doges" => 0,
        "r1" => 0,
        "r2" => 0,
        "r3" => 0,
        "r4" => 0,
        "r5" => 0,
        "r6" => 0,
    ]
];

try {
    foreach ($buildings as $key => $value) {
        $str = "INSERT INTO `buildings`(`ID`, `ref`, `hardCost`, `softCost`, `buildingTime`, `ressource_cost_1`, `ressource_cost_2`, `ressource_cost_3`, `ressource_cost_4`, `ressource_cost_5`, `ressource_cost_6`) VALUES (:id, :ref, :hard, :soft, :time, :r1, :r2, :r3, :r4, :r5, :r6)";

        $requete = $connexion->prepare($str);
        $requete->execute(array(':id'=>$key, ':ref'=>$value['img'], ':hard' => $value['hard'], ':soft' => $value['fric'], ':time' => $value['building_time'], ':r1' => $value['r1'], ':r2' => $value['r2'], ':r3' => $value['r3'], ':r4' => $value['r4'], ':r5' => $value['r5'], ':r6' => $value['r6']));
        //$resultat = $requete->fetchAll();
    }
} 
catch (PDOExeption $e) {
    echo '{"error":"'.$e->getMessage().'"}';
    die();
}

?>

