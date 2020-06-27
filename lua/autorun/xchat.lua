xChat = xChat or {}

AddCSLuaFile("xchat/misc.lua")
AddCSLuaFile("xchat/get.lua")
if SERVER then
	include("xchat/config.lua")
	include("xchat/misc.lua")
	include("xchat/commands.lua")
	include("xchat/get.lua")
	include("xchat/init.lua")
else
	include("xchat/misc.lua")
	include("xchat/get.lua")
end