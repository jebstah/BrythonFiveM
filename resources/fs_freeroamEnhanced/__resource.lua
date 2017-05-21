resource_type 'gametype' { name = 'fs_freeroamEnhanced'}

-- Manifest
resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

-- Requiring essentialmode
dependency 'enhancedessentialmode'

-- General
client_scripts {
  'client.lua',
  'events/smoke.lua',
  'events/fleecaJob.lua',
  'player/map.lua',
  'player/scoreboard.lua',
  'stores/stripclub.lua',
  'stores/vehshop.lua'
}

server_scripts {
  'server.lua',
  'player/commands.lua',
  'stores/vehshop_s.lua',
}
