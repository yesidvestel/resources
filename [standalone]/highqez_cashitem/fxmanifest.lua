
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 		'highqez_cashitem'
author 		'HighQez'
version     '1.0.1'
description 'Advanced Cash item system for roleplay'

shared_script 'Unlocked/config.lua'

server_scripts {
	'Unlocked/sv_function.lua',
    'Locked/server.lua',
    'Locked/version.lua'
}

escrow_ignore {
	'Unlocked/config.lua',
    'Unlocked/sv_function.lua',
    'INSTALL/items.lua'
}

dependencies {
    'qb-core'
}
dependency '/assetpacks'