fx_version 'bodacious'

game 'gta5'

lua54 'yes'

client_scripts {
	"config.lua",
	"client/main.lua",
	"client/events.lua",
	"client/exports/info.lua",
	"client/exports/play.lua",
	"client/exports/manipulation.lua",
	"client/exports/events.lua",
	"client/effects/main.lua",
}

server_scripts {
	"config.lua",
	"server/main.lua",
	"server/exports/play.lua",
	"server/exports/manipulation.lua",
}

ui_page "html/index.html"

files {
	"html/index.html",
	"html/scripts/config.js",
	"html/scripts/listener.js",
	"html/scripts/SoundPlayer.js",
	"html/scripts/functions.js",
	"html/sounds/*.ogg",
	"html/sounds/*.mp3",
}

escrow_ignore {
    "config.lua",
}
dependency '/assetpacks'