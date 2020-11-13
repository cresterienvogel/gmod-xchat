util.AddNetworkString("xChat")

local cfg = xChat.Config
local handler = cfg.Handler
local channel = cfg.Channel
local command = cfg.Command

xChat.Sent = xChat.Sent or {}
xChat.NextTime = xChat.NextTime or SysTime()

local messages
local msg_time, msg_hour, msg_min
local cur_time, cur_hour, cur_min

function xChat.GetMessages()
	http.Fetch(handler .. "/channels/" .. channel .. ".php", 
		function(contents)
			messages = util.JSONToTable(contents)
			if messages == nil then 
				return
			end

			if messages["message"] == "You are being rate limited." then
				xChat.NextTime = SysTime() + (messages["retry_after"] / 1000)
				return
			end

			for _, msg in pairs(messages) do
				if not msg["id"] then
					continue
				end
				
				if xChat.Sent[msg["id"]] then
					continue
				end

				if msg["author"]["bot"] or msg["content"] == "" then
					continue
				end

				msg_time = msg["timestamp"]
				msg_time = string.Explode("T", msg_time)
				msg_time = string.Explode(".", msg_time[2])
				msg_time = msg_time[1]
				msg_time = string.Explode(":", msg_time)
				msg_hour = msg_time[1]
				msg_min = msg_time[2]

				cur_time = os.time()
				cur_time = os.date("%H:%M:%S", cur_time)
				cur_time = string.Explode(":", cur_time)
				cur_hour = cur_time[1] - 3
				cur_min = cur_time[2]

				if msg_hour ~= cur_hour and msg_min ~= cur_min then
					return
				end

				net.Start("xChat")
					net.WriteString(msg["author"]["username"])
					net.WriteString(msg["content"])
				net.Broadcast()

				for cmd, func in pairs(xChat.Commands) do
					if string.find(msg["content"],  command .. cmd) then
						func(msg["author"]["username"] .. "#" .. msg["author"]["discriminator"], msg["content"])
						break
					end
				end

				xChat.Sent[msg["id"]] = true
			end
		end
	)
end