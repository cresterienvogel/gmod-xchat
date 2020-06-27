function xChat.GetPlayers()
	local players = ""
	for _, pl in pairs(player.GetAll()) do
		players = players .. "\n" .. pl:Name() .. " (" .. pl:SteamID() .. ")"
	end
	
	if players == "" then
		players = "No players on the server"
	end

	return players
end

function xChat.PlayerSend(pl, msg)
    http.Post(xChat.Config.Handler .. "message.php", {
        webhook = xChat.Config.Webhook, 
        user_name = pl:Name(), 
        user_pic = pl:GetNWString("xChat Avatar"),
        user_message = msg
    })
end
