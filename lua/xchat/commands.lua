xChat.Commands = xChat.Commands or {}

xChat.Commands["status"] = function(username, message)
	http.Post(xChat.Config.Handler .. "status.php", {
		webhook = xChat.Config.Webhook, 
		server_name = GetHostName(),
		server_ip = game.GetIPAddress(),
		server_map = game.GetMap(),
		server_gamemode = engine.ActiveGamemode(),
		server_online = #player.GetAll() .. "/" .. game.MaxPlayers(),
		server_players = xChat.GetPlayers()
	})
end
