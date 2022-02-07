fx_version 'adamant'
game 'gta5'

shared_script '@DiamondCasino/shared.lua'

--[[

  ESX RP Chat

--]]


description 'ESX RP Chat'

version '1.0.0'

client_script 'client/main.lua'

dependency 'es_extended'

server_scripts {

  '@mysql-async/lib/MySQL.lua',
  'server/main.lua'

}

--
--
 
