<?php

	/*$src = 'mysql:host=10.1.100.18;dbname=dogeexplorer';
	//$src = 'mysql:host=fbgame.isartdigital.com;dbname=dogeexplorer';
	$user = 'dogeexplorer';
	$pwd = 'doge2015';*/

	$src = 'mysql:host=127.0.0.1;dbname=dogeexplorer_dev';
	$user = 'root';
	$pwd = '';

	function error ($error_msg) {

		echo '{"error":"'.$error_msg.'"}';
		die();
	}
?>