-- may be wrong idk ((sway))
RegisterServerEvent('police:spikesLocation')
AddEventHandler('police:spikesLocation', function(x,y,z,heading)
    TriggerClientEvent('addSpikes', -1, x..y..z,heading)
end)

RegisterServerEvent('police:removespikes')
AddEventHandler('police:removespikes', function(data)
    TriggerClientEvent('removeSpikes', -1, data)
end)