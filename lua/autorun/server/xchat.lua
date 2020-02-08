xChat = {}
xChat.Sent = {}

xChat.HandlerURL = "Your web storage UR"
xChat.WebhookURL = "Your webhook URL"

util.AddNetworkString("xChat")

xChat.NextTime = xChat.NextTime or SysTime()

--[[
    Funcs
]]

function xChat.SetAvatar(pl)
    local avatar = "https://avatarfiles.alphacoders.com/165/thumb-165625.jpg" -- doge
    http.Fetch("http://steamcommunity.com/profiles/" .. pl:SteamID64() .. "?xml=1", function(content)
        local ret = content:match("<avatarFull><!%[CDATA%[(.-)%]%]></avatarFull>")
        avatar = ret and ret or avatar
        pl:SetNWString("AvatarIcon", avatar)
    end)
end

function xChat.Send(name, msg, avatar)
    http.Post(xChat.HandlerURL .. "/xchat_to.php", {webhook = xChat.WebhookURL, server = game.GetIPAddress(), msg = msg, username = name, avatar_url = avatar})
end

function xChat.PlayerSend(pl, msg)
    xChat.Send(pl:Name(), msg, pl:GetNWString("AvatarIcon"))
end

function xChat.Get()
    http.Fetch(xChat.HandlerURL .. "/xchat_from.php", 
        function(contents)
            local messages = util.JSONToTable(contents)
            if messages == nil then 
                return
            end

            if messages.message == "You are being rate limited." then
                xChat.NextTime = SysTime() + messages.retry_after
                return
            end

            for _, msg in pairs(messages) do
                if xChat.Sent[msg.id] then
                    continue
                end

                if msg.author.bot or msg.content == "" then
                    continue
                end

                local msg_time = msg.timestamp
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
                    net.WriteString(msg.author.username)
                    net.WriteString(msg.content)
                net.Broadcast()

                xChat.Sent[msg.id] = true
            end
        end
    )
end

--[[
    Hooks
]]

hook.Add("Think", "xChat", function()
    if SysTime() >= xChat.NextTime then
        xChat.Get()
        xChat.NextTime = SysTime() + 1
    end
end)

hook.Add("PlayerInitialSpawn", "xChat", function(pl)
    xChat.Send("Server", "> " .. pl:Name() .. " has spawned.", "https://avatarfiles.alphacoders.com/165/thumb-165625.jpg")
    xChat.SetAvatar(pl)
end)

hook.Add("PlayerConnect", "xChat", function(name)
    xChat.Send("Server", "> " .. name .. " has connected, current online is " .. #player.GetAll() + 1 .. "/" .. game.MaxPlayers() .. " players.", "https://avatarfiles.alphacoders.com/165/thumb-165625.jpg")
end)

hook.Add("PlayerDisconnected", "xChat", function(pl)
    xChat.Send("Server", "> " .. pl:Name() .. " has disconnected, current online is " .. #player.GetAll() - 1 .. "/" .. game.MaxPlayers() .. " players.", "https://avatarfiles.alphacoders.com/165/thumb-165625.jpg")
end)

hook.Add("ShutDown", "xChat", function(pl)
    xChat.Send("Server", "> Server is going offline.", "https://avatarfiles.alphacoders.com/165/thumb-165625.jpg")
end)

hook.Add("Initialize", "xChat", function(pl)
    xChat.Send("Server", "> Server is going online. Public IP is " .. game.GetIPAddress() .. ".", "https://avatarfiles.alphacoders.com/165/thumb-165625.jpg")
end)

hook.Add("PlayerSay", "xChat", function(pl, msg, team)
    if not team and not string.find(msg, "@") then
        xChat.PlayerSend(pl, msg)
    end
end)
