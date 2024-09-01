name "Mining"
author "Mert Tomac"
description "Mining Script By Skyx"
fx_version "cerulean"
game "gta5"

dependencies {
	'qb-menu',
    'qb-target',
}

shared_scripts {
	'config.lua'
}
client_scripts {
    'client.lua'
}

server_script {
    'server.lua'
}