fx_version 'bodacious'

game 'gta5'

author 'OrigenNetwork'

version '1.0.3'

shared_scripts {
    'config/_framework.lua',
    'config/translations/*.lua',
    'config/*.lua',
    'tables.lua',
}

client_scripts {
    'custom/framework/client/*.lua',
    'client/*.lua',
    'custom/*.lua',
    'custom/client/*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'custom/framework/server/*.lua',
    'server/*.lua',
    'custom/server/*.lua',
    'config/logs/*.lua',
}

files {
    'html/index.html',
    'html/js/*.js',
    'html/css/*.css',
    'html/fonts/*.ttf',
    'html/img/*.*',
    'html/apps/*.html',
    'anims.json'
}

ui_page 'html/index.html'

--Escrow

lua54 'yes'

escrow_ignore {
    'config/*.lua',
    'config/**/*.lua',
    'custom/**/*.lua',
    'custom/**/**/*.lua',
}
dependency '/assetpacks'