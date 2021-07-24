fx_version 'cerulean'
games {'gta5'}

description 'NPC-Recoil'
version '1.0.0'
--resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

client_script "@npc-scripts/client/errorlog.lua"

client_script 'client/client.lua'
--client_script 'client/crouch.lua' -- Disabled until npc-recoil gets fixed.
client_script 'client/stress.lua'