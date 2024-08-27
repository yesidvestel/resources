
fx_version 'adamant'
game 'gta5'

author 'c8re'
description 'Modern crafting system'
version '1.2.0'

ui_page 'html/form.html'

lua54 'yes'

files {
	'html/form.html',
	'html/css.css',
--[[ 	'html/water.png', ]]
	'html/script.js',
	'html/jquery-3.4.1.min.js',
	'html/img/*.png',
}

client_scripts{
    'config.lua',
    'client/main.lua',
}

server_scripts{
    'config.lua',
    'server/main.lua',
}


shared_scripts {
    'config.lua',
}

escrow_ignore {
  'client/main.lua',
  'server/main.lua',
  'config.lua'
}

dependency '/assetpacks'