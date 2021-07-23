fx_version 'adamant'
game 'gta5'

description 'NPC-DP-Emotes'
version '1.0.0'

client_scripts {
	'NativeUI.lua',
	'config.lua',
	'client/*.lua'
}

server_scripts {
	'config.lua',
	'server/*.lua'
}

ui_page "html/menu.html"

files {
	"html/menu.html",
	"html/raphael.min.js",
    "html/wheelnav.min.js",
    "html/doors.png",
    "html/engine.png",
    "html/hood.png",
    "html/key.png",
    "html/trunk.png"
}
