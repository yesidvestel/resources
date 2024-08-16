fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'vames™️'
description 'vms_gym'
version '1.0.8'

shared_scripts {
	'config/config.lua',
	'config/config.translation.lua',
}

client_scripts {
	'client/*.lua',
	'config/config.client.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/*.lua',
	'config/config.server.lua'
}

ui_page 'html/index.html'

files {
	'html/*.*',
	'html/**/*.*',
	'config/*.js'
}

escrow_ignore {
	'config/*.lua',
	'client/*.lua',
	'server/*.lua',
	'server/version_check.lua'
}
