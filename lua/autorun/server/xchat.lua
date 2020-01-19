xChat = {}

xChat.HandlerURL = "Your web storage URL"
xChat.WebhookURL = "Your webhook URL"

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
    http.Post(xChat.HandlerURL .. "/xchat.php", {webhook = xChat.WebhookURL, server = game.GetIPAddress(), msg = msg, username = name, avatar_url = avatar})
end

function xChat.PlayerSend(pl, msg)
    xChat.Send(pl:Name(), msg, pl:GetNWString("AvatarIcon"))
end

--[[
    Hooks
]]

hook.Add("PlayerInitialSpawn", "xChat", function(pl)
    xChat.SetAvatar(pl)
end)