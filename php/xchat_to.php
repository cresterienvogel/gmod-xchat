<?php
    $allowed = array(
        '192.168.0.0:27015'
    );

    $webhook = $_POST["webhook"];
    $server = $_POST["server"];
    $msg = $_POST["msg"];
    $username = $_POST["username"];
    $avatar_url = $_POST["avatar_url"];

    $json_data = array(
        'content' => "$msg", 
        'username' => "$username", 
        'avatar_url' => "$avatar_url"
    );

    $make_json = json_encode($json_data);

    $webhookurl = $webhook;
    $ch = curl_init($webhookurl);
    curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-type: application/json'));
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $make_json);
    curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
    curl_setopt($ch, CURLOPT_HEADER, 0);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);

    if (in_array($server, $allowed)) {
        $response = curl_exec($ch);
    }
?>