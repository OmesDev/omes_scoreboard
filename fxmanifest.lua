fx_version 'cerulean'
game 'gta5'

name 'omes_scoreboard'
author 'omes'
description 'Player scoreboard system for FiveM'
version '1.1.0'
lua54 'yes'

shared_script 'config.lua'

client_scripts {
    'client.lua',
    --'@qbx_core/modules/playerdata.lua' -- Uncomment this line when using QBX framework
}

server_scripts {
    'server.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}

