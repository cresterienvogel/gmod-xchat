<?php
	include_once("../cfg.php");

	$url = $_POST["webhook"];
	$message = $_POST["message"];
	$color = $_POST["color"];
	$secret = $_POST["secret"];

	if ($secret !== $cfg_secret) {
		exit;
	};

	$msg = json_encode([
		"embeds" => [
			[
				"name" => "",
				"description" => $message,
				"type" => "rich",
				"color" => hexdec($color)
			]
		]
	], JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);

	$ch = curl_init();
	curl_setopt_array($ch, [
		CURLOPT_URL => $url,
		CURLOPT_POST => true,
		CURLOPT_POSTFIELDS => $msg,
		CURLOPT_HTTPHEADER => [
			"Content-Type: application/json"
		]
	]);

	$response = curl_exec($ch);
	curl_close($ch);
?>