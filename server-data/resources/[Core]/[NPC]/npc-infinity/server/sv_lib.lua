RegisterServerEvent('npc:infinity:player:ready')
AddEventHandler('npc:infinity:player:ready', function()
    local sexinthetube = GetEntityCoords(GetPlayerPed(source)) 
    TriggerClientEvent('npc:infinity:player:coords', -1, sexinthetube)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(30000)
        local sexinthetube = GetEntityCoords(source)

        TriggerClientEvent('npc:infinity:player:coords', -1, sexinthetube)
        TriggerEvent("npc-core:updatecoords", sexinthetube.x, sexinthetube.y, sexinthetube.z)
       -- print("[^2npc-infinity^0]^3 Sync Successful.^0")
    end
end)

RegisterServerEvent('player:setJob')
AddEventHandler('player:setJob', function(cid, job)

    local src = source

    exports.ghmattimysql:execute('UPDATE __characters SET job= ? WHERE id= ?', {job, cid})
end)

RegisterServerEvent('player:setRank')
AddEventHandler('player:setRank', function(cid, rank)

    local src = source

    exports.ghmattimysql:execute("UPDATE __characters SET rank = @rank WHERE id = @id", { 
        ['@id'] = cid,
        ['@rank'] = tonumber(rank)
    })
    -- exports.ghmattimysql:execute('UPDATE __characters SET rank= ? WHERE `id`= ?', {tonumber(rank), cid})
end)

RegisterServerEvent('player:removeCash')
AddEventHandler('player:removeCash', function(cid, amount)

    local src = source

    exports.ghmattimysql:execute('UPDATE __characters SET cash= ? WHERE id= ?', {amount, cid})
end)

RegisterServerEvent('player:addCash')
AddEventHandler('player:addCash', function(cid, amount)

    local src = source

    exports.ghmattimysql:execute('UPDATE __characters SET cash= ? WHERE id= ?', {amount, cid})
end)

RegisterServerEvent('player:setCash')
AddEventHandler('player:setCash', function(cid, amount)

    local src = source

    exports.ghmattimysql:execute('UPDATE __characters SET cash= ? WHERE id= ?', {amount, cid})
end)

RegisterServerEvent('player:removeBank')
AddEventHandler('player:removeBank', function(cid, amount)

    local src = source

    exports.ghmattimysql:execute('UPDATE __characters SET bank= ? WHERE id= ?', {amount, cid})
end)

RegisterServerEvent('player:addBank')
AddEventHandler('player:addBank', function(cid, amount)

    local src = source

    exports.ghmattimysql:execute('UPDATE __characters SET bank= ? WHERE id= ?', {amount, cid})
end)

RegisterServerEvent('player:setBank')
AddEventHandler('player:setBank', function(cid, amount)

    local src = source

    exports.ghmattimysql:execute('UPDATE __characters SET bank= ? WHERE id= ?', {amount, cid})
end)