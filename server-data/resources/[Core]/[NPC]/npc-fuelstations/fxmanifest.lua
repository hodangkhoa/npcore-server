fx_version 'cerulean'
games { 'gta5' }

description 'NPC-Fuel-Stations'
version '1.0.0'

client_script "@npc-scripts/client/errorlog.lua"
ui_page 'html/ui.html'

files {
	'html/*',
}

client_script 'client/client.lua'

exports {
	'SetFuel',
	'GetFuel'
}
