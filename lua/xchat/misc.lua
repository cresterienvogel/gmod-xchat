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