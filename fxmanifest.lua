fx_version 'cerulean'
game 'gta5'
lua54 'on'

client_scripts {
    'clientconfig.lua',
    'client/init.lua',
    'client/commands.lua'
}

server_scripts {
    'serverconfig.lua',
    'server/server.lua',
    '@mysql-async/lib/MySQL.lua'
}