xChat = xChat or {}

AddCSLuaFile("xchat/chatdraw.lua")
if SERVER then
	include("xchat/config.lua")
	include("xchat/commands.lua")
	include("xchat/lib/misc.lua")
	include("xchat/lib/get.lua")
	include("xchat/lib/init.lua")
else
	include("xchat/chatdraw.lua")
end