xChat.Commands = xChat.Commands or {}

local cfg = xChat.Config
local handler = cfg.Handler
local webhook = cfg.Webhook
local secret = cfg.Secret

local function GetPlayers()
	local players = ""
	for _, pl in pairs(player.GetAll()) do
		players = players .. "\n" .. pl:Name() .. " (" .. pl:SteamID() .. ")"
	end
	if players == "" then
		players = "No players on the server"
	end
	return players
end

xChat.Commands["status"] = function(username, message)
	http.Post(handler .. "lib/status.php", {
		webhook = webhook, 
		server_name = GetHostName(),
		server_ip = game.GetIPAddress(),
		server_map = game.GetMap(),
		server_gamemode = engine.ActiveGamemode(),
		server_online = #player.GetAll() .. "/" .. game.MaxPlayers(),
		server_players = GetPlayers(),
		secret = secret
	})
end
