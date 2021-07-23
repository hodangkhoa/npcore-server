local joblist = {}
local resettime = nil
local policeclosed = false
local currentStreetHash, intersectStreetHash
job = nil

RegisterServerEvent('npc-jewelrob:getjob')
AddEventHandler('npc-jewelrob:getjob', function(job)
    job = job
end)

RegisterServerEvent('npc-jewelrobbery:closestore')
AddEventHandler('npc-jewelrobbery:closestore', function()
    local _source = source
    local ispolice = false
	for i, v in pairs(Config.PoliceJobs) do
		if job == v then
			ispolice = true
			break
		end
	end
    if ispolice and resettime ~= nil then
        TriggerClientEvent('npc-jewelrobbery:policeclosure', -1)
        policeclosed = true
    elseif ispolice and resettime == nil then
        TriggerClientEvent('DoLongHudText', _source, 'Store does not appear to be damaged - unable to force closed!', 2)          
    else
        TriggerClientEvent('DoLongHudText', _source, 'Only Law enforcment or Vangelico staff can decide if store is closed!', 2)       
    end
end)

RegisterServerEvent('npc-jewelrobbery:playsound')
AddEventHandler('npc-jewelrobbery:playsound', function(x,y,z, soundtype)
    TriggerClientEvent('npc-jewelrobbery:playsound', -1, x, y, z, soundtype)
end)

RegisterServerEvent('npc-jewelrobbery:setcase')
AddEventHandler('npc-jewelrobbery:setcase', function(casenumber, switch)
    _source = source
    if not Config.CaseLocations[casenumber].Broken then
        Config.CaseLocations[casenumber].Broken  = true
        TriggerEvent('npc-jewelrobbery:RestTimer')
        TriggerClientEvent('npc-jewelrobbery:setcase', -1, casenumber, true)
        TriggerEvent('npc-jewelrobbery:AwardItems', _source)
    end
end)

RegisterServerEvent('npc-jewelrobbery:policenotify')
AddEventHandler('npc-jewelrobbery:policenotify', function()
    TriggerClientEvent('npc-dispatch:jewelrobbery')
	return
end)


RegisterServerEvent('npc-jewelrobbery:loadconfig')
AddEventHandler('npc-jewelrobbery:loadconfig', function()
    local _source = source
    local buildlist = {
        id = _source,
        job = job,
    }
    table.insert(joblist, buildlist)
    TriggerClientEvent('npc-jewelrobbery:loadconfig', _source, Config.CaseLocations)
    if policeclosed then
        TriggerClientEvent('npc-jewelrobbery:policeclosure', _source)
    end

end)

AddEventHandler('npc-jewelrobbery:AwardItems', function(source)
    local _source = source
	if math.random(25) == 20 then
        local myluck = math.random(5)

        if myluck == 1 then
            TriggerClientEvent("npc-banned:getID", _source, "securityblue",1)
        elseif myluck == 2 then
            TriggerClientEvent("npc-banned:getID", _source, "cb",1)
        end
	end

	TriggerClientEvent("npc-banned:getID", _source, "rolexwatch",math.random(2,6))
    if math.random(1,5) == 5 then
        TriggerClientEvent('npc-banned:getID', _source, 'band', math.random(2,8))
    end
	if math.random(5) == 1 then
		TriggerClientEvent("npc-banned:getID", _source, "goldbar",math.random(1,3))
	end

	if math.random(69) == 69 then
		TriggerClientEvent("npc-banned:getID", _source, "valuablegoods",math.random(3))
    end
    TriggerClientEvent("npc-banned:getID", _source, "goldbar",1)
end)


AddEventHandler('npc-jewelrobbery:RestTimer', function()
    if resettime == nil then
        totaltime = Config.ResetTime * 60
        resettime = os.time() + totaltime

        while os.time() < resettime do
            Citizen.Wait(2350)
        end

        for i, v in pairs(Config.CaseLocations) do
            v.Broken = false
        end
        TriggerClientEvent('npc-jewelrobbery:resetcases', -1, Config.CaseLocations)
        resettime = nil
        policeclosed = false
    end
end)