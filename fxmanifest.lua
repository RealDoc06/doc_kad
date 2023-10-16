fx_version 'adamant'
game 'gta5'

author "El Cringo Doc#6969"
description "kad application script"
version "1.0"

lua54 'yes'

escrow_ignore {
    "config.lua",
}

client_scripts {
    'client/functions.lua',
    'client/*.lua',
}

server_scripts {
    -- script files
    'server/functions.lua',
    'server/*.lua',
}

shared_scripts {
    -- script files
    'shared/functions.lua',
    'shared/*.lua',
    'config.lua',
}

dependencies {
    'oxmysql',
}
