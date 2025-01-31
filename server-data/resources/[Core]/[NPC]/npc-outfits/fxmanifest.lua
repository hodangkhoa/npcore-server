fx_version 'cerulean'
games { 'gta5' }

description 'NPC-Outfits'
version '1.0.0'

ui_page 'client/html/index.html'

files {
  'client/html/*.html',
  'client/html/*.js',
  'client/html/*.css',
  'client/html/webfonts/*.eot',
  'client/html/webfonts/*.svg',
  'client/html/webfonts/*.ttf',
  'client/html/webfonts/*.woff',
  'client/html/webfonts/*.woff2',
  'client/html/css/*',
}

client_scripts {
  '@npc-scripts/client/errorlog.lua',
  'client/cl_tattooshop.lua',
  'client/cl_*.lua',
}

shared_script {
  'shared/sh_*.*',
}

server_scripts {
  'server/server.lua',
}

export "CreateHashList"
export "GetTatCategs"
export "GetCustomSkins"