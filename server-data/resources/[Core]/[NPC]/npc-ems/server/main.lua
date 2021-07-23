local playersHealing = {}

RegisterServerEvent('npc-ambulancejob:revive')
AddEventHandler('npc-ambulancejob:revive', function(data, target)

	if Player.job == 'EMS' then
		xPlayer.addMoney(Config.ReviveReward)
		TriggerClientEvent('admin:revivePlayerClient', target)
	else
	end
end)

RegisterServerEvent('npc-ambulancejob:revivePD')
AddEventHandler('npc-ambulancejob:revivePD', function(data, target)
	local Player = data

	if Player.job == 'Police' then
		TriggerClientEvent('admin:revivePlayerClient', target)
	else
	end
end)

RegisterServerEvent('admin:revivePlayer')
AddEventHandler('admin:revivePlayer', function(target)
	if target ~= nil then
		TriggerClientEvent('admin:revivePlayerClient', target)
		TriggerClientEvent('npc-hospital:client:RemoveBleed', target) 
        TriggerClientEvent('npc-hospital:client:ResetLimbs', target)
	end
end)

RegisterServerEvent('admin:healPlayer')
AddEventHandler('admin:healPlayer', function(target)
	if target ~= nil then
		TriggerClientEvent('npc_basicneeds:healPlayer', target)
	end
end)

RegisterServerEvent('npc-ambulancejob:heal')
AddEventHandler('npc-ambulancejob:heal', function(target, type)

	TriggerClientEvent('npc-ambulancejob:heal', target, type)

	TriggerClientEvent('npc-hospital:client:RemoveBleed', target) 	
	TriggerClientEvent('npc-ambulancejob:heal', target, type)
	--TriggerClientEvent('MF_SkeletalSystem:HealBones', target, "all")
	TriggerClientEvent('npc-hospital:client:RemoveBleed', target) 
	TriggerClientEvent('npc-hospital:client:ResetLimbs', target)
end)

RegisterServerEvent('npc-ambulancejob:putInVehicle')
AddEventHandler('npc-ambulancejob:putInVehicle', function(data, target)

	if Player.job == 'EMS' then
		TriggerClientEvent('npc-ambulancejob:putInVehicle', target)
	else
	end
end)

RegisterServerEvent('npc-ambulancejob:pullOutVehicle')
AddEventHandler('npc-ambulancejob:pullOutVehicle', function(data, target)

	if Player.job == 'EMS' then
		TriggerClientEvent('npc-ambulancejob:pullOutVehicle', target)
	end
end)

RegisterServerEvent('npc-ambulancejob:drag')
AddEventHandler('npc-ambulancejob:drag', function(data, target)
	_source = source
	if Player.job == 'EMS' then
		TriggerClientEvent('npc-ambulancejob:drag', target, _source)
	else
	end
end)

RegisterServerEvent('npc-ambulancejob:undrag')
AddEventHandler('npc-ambulancejob:undrag', function(data, target)
	_source = source
	if Player.job == 'EMS' then
		TriggerClientEvent('npc-ambulancejob:un_drag', target, _source)
	else
	end
end)

function getPriceFromHash(hashKey, jobGrade, type)
	if type == 'helicopter' then
		local vehicles = Config.AuthorizedHelicopters[jobGrade]

		for k,v in ipairs(vehicles) do
			if GetHashKey(v.model) == hashKey then
				return v.price
			end
		end
	elseif type == 'car' then
		local vehicles = Config.AuthorizedVehicles[jobGrade]

		for k,v in ipairs(vehicles) do
			if GetHashKey(v.model) == hashKey then
				return v.price
			end
		end
	end

	return 0
end

RegisterServerEvent('npc-ambulancejob:drag')
AddEventHandler('npc-ambulancejob:drag', function(target)
	TriggerClientEvent('npc-ambulancejob:drag', target, source)
end)