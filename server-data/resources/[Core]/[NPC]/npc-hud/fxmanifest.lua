fx_version 'cerulean'
games { 'gta5' }

description 'NPC-HUD'
version '1.0.0'

client_script "@npc-scripts/client/errorlog.lua"
client_script 'client/carhud.lua'
client_script 'client/cl_autoKick.lua'
client_script 'client/newsStands.lua'
server_script 'server/carhud_server.lua'
server_script 'server/sr_autoKick.lua'

ui_page('html/index.html')
files({
	"html/index.html",
	"html/script.js",
	"html/styles.css",
	"html/img/*.svg",
	"html/img/*.png"
})

exports {
	"playerLocation",
	"playerZone",
}