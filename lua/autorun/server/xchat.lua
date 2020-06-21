xChat = xChat or {}
xChat.Sent = {}

xChat.HandlerURL = "Your web storage URL"
xChat.WebhookURL = "Your webhook URL"
xChat.BotAvatar = "Your preferred bot avatar URL"

util.AddNetworkString("xChat")

xChat.NextTime = xChat.NextTime or SysTime()

xChat.Started = xChat.Started or false
timer.Simple(0, function()
    if not xChat.Started then
        xChat.Started = true
        xChat.Send("Server", "> Server is going online. Public IP is " .. game.GetIPAddress() .. ".", xChat.BotAvatar)
    end
end)

--[[
    Funcs
]]

function xChat.SetAvatar(pl)
    http.Fetch("http://steamcommunity.com/profiles/" .. pl:SteamID64() .. "?xml=1", function(content)
        pl:SetNWString("AvatarIcon", content:match("<avatarFull><!%[CDATA%[(.-)%]%]></avatarFull>"))
    end)
end

function xChat.Send(name, msg, avatar)
    http.Post(xChat.HandlerURL .. "/xchat_to.php", {webhook = xChat.WebhookURL, server = game.GetIPAddress(), msg = msg, username = name, avatar_url = avatar})
end

function xChat.PlayerSend(pl, msg)
    xChat.Send(pl:Name(), msg, pl:GetNWString("AvatarIcon"))
end

function xChat.GetMessages()
    http.Fetch(xChat.HandlerURL .. "/xchat_from.php", 
        function(contents)
            local messages = util.JSONToTable(contents)
            if messages == nil then 
                return
            end

            if messages["message"] == "You are being rate limited." then
                xChat.NextTime = SysTime() + messages["retry_after"]
                return
            end

            for _, msg in pairs(messages) do
                if xChat.Sent[msg["id"]] then
                    continue
                end

                if msg["author"]["bot"] or msg["content"] == "" then
                    continue
                end

                local msg_time = msg["timestamp"]
                msg_time = string.Explode("T", msg_time)
                msg_time = string.Explode(".", msg_time[2])
                msg_time = msg_time[1]
                msg_time = string.Explode(":", msg_time)
                local msg_hour = msg_time[1]
                local msg_min = msg_time[2]

                local cur_time = os.time()
                cur_time = os.date("%H:%M:%S", cur_time)
                cur_time = string.Explode(":", cur_time)
                local cur_hour = cur_time[1] - 3
                local cur_min = cur_time[2]

                if msg_hour ~= cur_hour and msg_min ~= cur_min then
                    return
                end

                net.Start("xChat")
                    net.WriteString(msg["author"]["username"])
                    net.WriteString(msg["content"])
                net.Broadcast()

                if string.find(msg["content"], ".status") then
                    local players = ""
                    for _, pl in pairs(player.GetAll()) do
                        players = players .. "\n    " .. pl:Name() .. " `(" .. pl:SteamID() .. ")`"
                    end
                    
					if players == "" then
						players = " `No players on the server`"
					end
                
                    xChat.Send("Server Status", "> Current server statistic:\n\n⚡ Online: `" .. #player.GetAll() .. "/" .. game.MaxPlayers() .. "` players\n🎪 Map: `" .. game.GetMap() .. "`\n📁 Players:" .. players, xChat.BotAvatar)
                end

                xChat.Sent[msg["id"]] = true
            end
        end
    )
end

--[[
    Hooks
]]

hook.Add("Think", "xChat", function()
    if SysTime() >= xChat.NextTime then
        xChat.GetMessages()
        xChat.NextTime = SysTime() + 1
    end
end)

hook.Add("PlayerInitialSpawn", "xChat", function(pl)
    xChat.Send("Server", "> " .. pl:Name() .. " has spawned.", xChat.BotAvatar)
    xChat.SetAvatar(pl)
end)

hook.Add("ShutDown", "xChat", function()
    xChat.Send("Server", "> Server is going offline.", xChat.BotAvatar)
end)

hook.Add("PlayerSay", "xChat", function(pl, msg, team)
    if not team and not string.find(msg, "@") then
        xChat.PlayerSend(pl, msg)
    end
end)

--[[
    Game events
]]

gameevent.Listen("player_connect")
hook.Add("player_connect", "AnnounceConnection", function(data)
    xChat.Send("Server", "> " .. data.name .. " (" .. data.networkid .. ") has connected.", xChat.BotAvatar)
end)

gameevent.Listen("player_disconnect")
hook.Add("player_disconnect", "xChat", function(data)
    xChat.Send("Server", "> " .. data.name .. " (" .. data.networkid .. ") has disconnected: " .. data.reason, xChat.BotAvatar)
end)
