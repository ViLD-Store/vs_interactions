fx_version 'cerulean'
game 'gta5'
description 'VS Interactions'
lua54 'yes'
version '0.0.2'

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server.lua'
}

shared_script '@ox_lib/init.lua'

ui_page 'web/index.html'

files {
    'web/index.html',
    'web/app.js',
    'web/style.css'
}