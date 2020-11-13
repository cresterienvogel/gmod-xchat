<?php
	include_once("cfg.php");

	$url = $_POST["webhook"];
	$server_name = $_POST["server_name"];
	$server_ip = $_POST["server_ip"];
	$server_map = $_POST["server_map"];
	$server_gamemode = $_POST["server_gamemode"];
	$server_online = $_POST["server_online"];
	$server_players = $_POST["server_players"];
	$secret = $_POST["secret"];

	if ($secret !== $cfg_secret) {
		exit;
	};

	$msg = json_encode([
		"embeds" => [
			[
				"title" => $server_name,
				"description" => $server_ip,
				"type" => "rich",
				"color" => $clr_status,

				"footer" => [
					"text" => $server_players
				],

				"fields" => [
					[
						"name" => "Map",
						"value" => $server_map,
						"inline" => false
					],
					[
						"name" => "Online",
						"value" => $server_online . " players",
						"inline" => false
					],
					[
						"name" => "Gamemode",
						"value" => $server_gamemode,
						"inline" => false
					]
				]
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