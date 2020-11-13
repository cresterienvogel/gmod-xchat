local cfg = xChat.Config
local handler = cfg.Handler
local webhook = cfg.Webhook
local secret = cfg.Secret

function xChat.PlayerSend(pl, msg)
    http.Post(handler .. "lib/message.php", {
        webhook = webhook, 
        user_name = pl:Name(), 
        user_pic = pl:GetNWString("xChat Avatar"),
        user_message = msg,
        secret = secret
    })
end

function xChat.Send(msg, clr)
    http.Post(handler .. "lib/custom.php", {
        webhook = webhook, 
        message = msg, 
        color = clr or "ff957e",
        secret = secret
    })
end
