<?php
	include_once("../cfg.php");
	include_once("../hide.php");
	$channel_id = "<Channel ID>";
	$ch = curl_init("https://discordapp.com/api/channels/" . $channel_id . "/messages?limit=3");
   	curl_setopt($ch, CURLOPT_HTTPHEADER, array("Authorization: Bot " . $bot_token));
    
	$output = curl_exec($ch);
	curl_close($ch);

?>
