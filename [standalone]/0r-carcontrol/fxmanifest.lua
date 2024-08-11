fx_version 'adamant'
game 'gta5'
author '0RESMON'
description '0R-CarControl.'
lua54 "yes"
version '1.1'

shared_scripts {
	'config.lua',
	'functions.lua'
}

client_scripts {
	'client/*.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua', -- Uncomment this line if you use 'oxmysql'
	'server/*.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/*.js',
    'html/*.css',
	'html/images/*.png',
	'html/images/*.svg',
}