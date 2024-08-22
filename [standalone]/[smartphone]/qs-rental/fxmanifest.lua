fx_version 'cerulean'

game 'gta5'

lua54 'yes'

shared_scripts {
	'config/*.lua',
	'locales/*.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/custom/framework/*.lua',
	'server/*.lua',
}

client_scripts {
	'client/custom/framework/*.lua',
	'client/*.lua',
	'client/modules/*.lua',
	'client/custom/**/*.lua',
}

escrow_ignore {
	'config/*.lua',
	'locales/*.lua',
	'client/custom/framework/*.lua',
	'server/custom/framework/*.lua',
}

dependency '/assetpacks'