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
    'poudre0' => [
        "buyCost" => 10,
        "sellCost" => 5,
        "hardBuyValue" => 0
    ],
    'poudre1' => [
        "buyCost" => 25,
        "sellCost" => 10,
        "hardBuyValue" => 0
    ],
    'poudre2' => [
        "buyCost" => 50,
        "sellCost" => 25,
        "hardBuyValue" => 0
    ],
    'poudre3' => [ 
        "buyCost" => 100,
        "sellCost" => 40,
        "hardBuyValue" => 0
    ],      
    'poudre4' => [
        "buyCost" => 300,
        "sellCost" => 200,
        "hardBuyValue" => 0
    ],
    'poudre5' => [
        "buyCost" => 1000,
        "sellCost" => 700,
        "hardBuyValue" => 0
    ],
    'fric' => [
        "buyCost" => 0,
        "sellCost" => 0,
        "hardBuyValue" => 0.1
    ],
    'hardMoney' => [
        "buyCost" => 0,
        "sellCost" => 0,
        "hardBuyValue" => 0
    ],
    'doges' => [
        "buyCost" => 0,
        "sellCost" => 0,
        "hardBuyValue" => 0
    ]
];

try {
    $cpt = 1;
    foreach ($ressources as $key => $value) {
        $str = "INSERT INTO `means`(`ID`, `ref`,`ref_nb`, `softBuyValue`, `softSellValue`, `hardBuyValue`, `discount`) VALUES ('', :ref, :ref_nb, :softBuy, :softSell, :harBuy, 0)";
        $requete = $connexion->prepare($str);
        $requete->execute(array(':ref'=>$key, ':ref_nb' => $cpt, ':softBuy' => $value['buyCost'], ':softSell' => $value['sellCost'], ':harBuy' => $value['hardBuyValue']));
        $cpt++;
    }
} 
catch (PDOExeption $e) {

    echo '{"error":"'.$e->getMessage().'"}';
    die();

}
?>
