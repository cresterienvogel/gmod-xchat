<?php
	include_once("../cfg.php");

	$url = $_POST["webhook"];
	$user_name = $_POST["user_name"];
	$user_pic = $_POST["user_pic"];
	$user_profile = $_POST["user_profile"];
	$user_reason = $_POST["user_reason"];
	$secret = $_POST["secret"];

	if ($secret !== $cfg_secret) {
		exit;
	};

	$msg = json_encode([
		"embeds" => [
			[
				"title" => $user_name,
				"description" => "has disconnected: " . $user_reason,
				"type" => "rich",
				"url" => $user_profile,
				"color" => $clr_disconnect,
				"thumbnail" => [
					"url" => $user_pic
				],
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