fx_version 'adamant'
games { 'gta5' }

ui_page 'html/index.html'

author 'Danny255' 
description 'TunningSystem3hu' 
version '1.2.2'


client_scripts {
	'client/client.lua',
	'config.lua'
}

-- Thanks to https://www.flaticon.com/ for the amazing icons :3
-- Thanks to FiveM, Alt:V and RAGE:MP for the amazing documentation

files {
	'html/index.html',
	'html/script.js',
	'html/img/*.png',
	'html/main.css',
    'html/*.svg',
}

server_scripts {
   '@mysql-async/lib/MySQL.lua',
   'config.lua',
   'server/server.lua',
}