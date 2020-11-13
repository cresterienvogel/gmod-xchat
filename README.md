# xChat
Simple Garry's mod Discord Relay. 
> cURL and your personal Discord bot are required.

# Initialization
* Create "xchat" folder on Garry's mod server in addons and place there a lua folder
* Create "xchat" folder on Web server and place there contents of php folder

# Web Configuration
### xchat/cfg.php
* Set up a secret key and a bot token
### xchat/channels/<YOUR CHANNEL NAME/base>.php
* Set up a channel id, create another files if you would like to use multiple channels on different servers

# Garry's mod Configuration 
### addons/xchat/lua/xchat/config.lua
* Set up a URL address to the Web server, Web hook URL, Channel id
