<?php
    $url = $_POST["webhook"];
    $user_name = $_POST["user_name"];
    $user_pic = $_POST["user_pic"];
    $user_profile = $_POST["user_profile"];

    $msg = json_encode([
        "embeds" => [
            [
                "title" => $user_name,
                "description" => "has connected",
                "type" => "rich",
                "url" => $user_profile,
                "color" => hexdec("48a072"),

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