local cfg = xChat.Config
local handler = cfg.Handler
local webhook = cfg.Webhook
local secret = cfg.Secret

hook.Add("Think", "xChat", function()
    if SysTime() >= xChat.NextTime then
        xChat.GetMessages()
        xChat.NextTime = SysTime() + 1
    end
end)

hook.Add("PlayerInitialSpawn", "xChat", function(pl)
	local profile_url = "https://steamcommunity.com/profiles/" .. pl:SteamID64()
	http.Fetch(profile_url .. "?xml=1", function(content)
		pl:SetNWString("xChat Avatar", content:match("<avatarFull><!%[CDATA%[(.-)%]%]></avatarFull>"))
		http.Post(handler .. "lib/spawn.php", {
			webhook = webhook, 
			user_name = pl:Name() .. " (" .. pl:SteamID() .. ")", 
			user_pic = pl:GetNWString("xChat Avatar"),
			user_profile = profile_url,
			secret = secret
		})
    end)
end)

if cfg.DefaultChatMessaging then
	hook.Add("PlayerSay", "xChat", function(pl, msg, team)
		if not team and not string.find(msg, "@") then
			xChat.PlayerSend(pl, msg)
		end
	end)
end

gameevent.Listen("player_connect")
hook.Add("player_connect", "xChat", function(data)
	local profile_url = "https://steamcommunity.com/profiles/" .. util.SteamIDTo64(data.networkid)
	http.Fetch(profile_url .. "?xml=1", function(content)
		http.Post(handler .. "lib/connect.php", {
			webhook = webhook, 
			user_name = data.name .. " (" .. data.networkid .. ")", 
			user_pic = content:match("<avatarFull><!%[CDATA%[(.-)%]%]></avatarFull>"),
			user_profile = profile_url,
			secret = secret
		})
    end)
end)

gameevent.Listen("player_disconnect")
hook.Add("player_disconnect", "xChat", function(data)
	local profile_url = "https://steamcommunity.com/profiles/" .. util.SteamIDTo64(data.networkid)
	http.Fetch(profile_url .. "?xml=1", function(content)
		http.Post(handler .. "lib/disconnect.php", {
			webhook = webhook, 
			user_name = data.name .. " (" .. data.networkid .. ")", 
			user_pic = content:match("<avatarFull><!%[CDATA%[(.-)%]%]></avatarFull>"),
			user_profile = profile_url,
			user_reason = data.reason,
			secret = secret
		})
    end)
end)