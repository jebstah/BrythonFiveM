-- Manifest
resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

description 'EnhancedEssentialMode by c7a1 and Zaedred.'

ui_page 'ui.html'

-- NUI Files
files {
	'ui.html',
	'pdown.ttf'
}

-- Server
server_script '../common/db.lua'
server_script 'server/classes/player.lua'
server_script 'server/classes/groups.lua'
server_script 'server/player/login.lua'
server_script 'server/main.lua'
server_script 'server/util.lua'

-- Client
client_script 'client/main.lua'
client_script 'client/player.lua'