xChat = xChat or {}

AddCSLuaFile("xchat/lib/chatdraw.lua")
if SERVER then
	include("xchat/config.lua")
	include("xchat/commands.lua")
	include("xchat/lib/misc.lua")
	include("xchat/lib/get.lua")
	include("xchat/lib/init.lua")
else
	include("xchat/lib/chatdraw.lua")
end