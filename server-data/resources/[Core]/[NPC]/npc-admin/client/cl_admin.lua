function spairs(t, order)
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end
function NPC.Admin.Init(self)
    self.Menu:Init()
    self:CheckForSessions()
    SetRichPresence("Sup")
end

local checkingForSessions
local exludedZones = {
    [1] = {['x'] = 238.41,['y'] = -404.68,['z'] = 47.93,["r"] = 20},
    [2] = {['x'] = 234.16,['y'] = -418.85,['z'] = -118.19,["r"] = 60},
    [3] = {['x'] = 257.02,['y'] = -368.93,['z'] = -44.13,["r"] = 40},
    [4] = {['x'] = 323.47,['y'] = -1619.64,['z'] = -66.78,["r"] = 100},
}

local isInNoclip = false
local devmodeToggle = false


function NPC.Admin.CheckForSessions(self)
    if checkingForSessions then return else checkingForSessions = true end

    -- Citizen.CreateThread(function()
    --     while true do
    --         Citizen.Wait(2000)

    --         local players = NPC._Admin.Players

    --         for k,v in pairs(players) do
    --             local src = v.source
    --             local playerId = GetPlayerFromServerId(src)
    --             if not src then
    --                 NPC._Admin.Players[src].sessioned = true
    --             else
    --                 if not NetworkIsPlayerActive(playerId) or not NetworkIsPlayerConnected(playerId) then NPC._Admin.Players[src].sessioned = true end
    --             end
    --         end
    --     end
    -- end)
end

RegisterNetEvent("npc-admin:setStatus")
AddEventHandler("npc-admin:setStatus", function(src, status)
    local player = NPC._Admin.Players[src]
    if not player then return else NPC._Admin.Players[src].status = status end
end)

RegisterNetEvent("npc-admin:sendPlayerInfo")
AddEventHandler("npc-admin:sendPlayerInfo", function(data, discData)
    NPC._Admin.Players = data
    NPC._Admin.DiscPlayers = discData
end)

function NPC.Admin.BeginAFK(self, stop)
    if stop then
        afk.isAfk = false
        afk.msgAFK = false
        afk.stringToType = ""
        afk.afkStart = nil
        afk.posStart = nil
        URP.Admin:SetStatus("Playing")
        if afk.event then
            RemoveEventHandler(afk.event)
        end
        return
    end

    if afk.msgAFK then return end

    self:SetStatus("AFK")
    afk.stringToType = ""

    for i = 1, 5 do
        local c = string.char(GetRandomIntInRange(97, 122))
        afk.stringToType = afk.stringToType .. string.lower(c)
    end

    afk.event = AddEventHandler("npc-admin:afkStringCheck", function(text)
        if string.lower(text) == afk.stringToType then NPC.Admin:BeginAFK(true) return end
    end)

    afk.msgAFK = true
    local beginTime = GetGameTimer()

    Citizen.CreateThread(function()
        local lastNotify = 0

        while true do
            Citizen.Wait(1000)

            if not afk.msgAFK then return end

            local curTime = GetGameTimer()

            if curTime - lastNotify >= 6500 then
                lastNotify = GetGameTimer()

                local string = [[<center><span style="font-size:28px;color:red;">You have been detected as AFK. Please type the message below within 5 minutes!<br /><hr style="border-color: rgba(255, 0, 0, 0.5);">%s</span></center>]]
                TriggerEvent("pNotify:SendNotification", {text = string.format(string, afk.stringToType), layout = "top", timeout = 5000, type = "error", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}, queue = "afk", progressBar = false})
            end

            if curTime - beginTime >= 300000 then TriggerServerEvent("npc-admin:Disconnect", "AFK Kick") return end
        end
    end)
end

RegisterNetEvent("npc-admin:RemovePlayer")
AddEventHandler("npc-admin:RemovePlayer", function(src)
    local data = NPC._Admin.Players[src]
    NPC._Admin.DiscPlayers[src] = data
    NPC._Admin.Players[src] = nil
end)

RegisterNetEvent("npc-admin:AddPlayer")
AddEventHandler("npc-admin:AddPlayer", function(player)
    NPC._Admin.Players[player.source] = player
end)


RegisterNetEvent('event:control:adminDev')
AddEventHandler('event:control:adminDev', function(useID)
    if not devmodeToggle then return end
    if NPC.Admin:GetPlayerRank() == "dev" then
        if useID == 1 then
            TriggerEvent("npc-admin:openMenu")
        elseif useID == 2 then
            local bool = not isInNoclip
            NPC.Admin.RunNclp(nil,bool)
            TriggerEvent("npc-admin:noClipToggle",bool)
            TriggerServerEvent("admin:noclipFromClient",bool)
        elseif useID == 3 then
            TriggerEvent("npc-admin:CloakRemote")
        elseif useID == 4 then
            NPC.Admin.teleportMarker(nil)
        end
    end
end)

RegisterNetEvent("npc-admin:currentDevmode")
AddEventHandler("npc-admin:currentDevmode", function(devmode)
    devmodeToggle = devmode
end)

RegisterNetEvent("npc-admin:AddPlayer")
AddEventHandler("npc-admin:AddPlayer", function(player)
    NPC._Admin.Players[player.source] = player
end)

function NPC.Admin.RunCommand(self, args)
    if not args or not args.command then return end
    TriggerServerEvent("npc-admin:runCommand", args)
end

function NPC.Admin.RunClCommand(self, cmd, args)
    if not cmd or not self:CommandExists(cmd) then return end
    self:GetCommandData(cmd).runclcommand(args)
end


function NPC.Admin.teleportMarker(self)
    local rank = NPC.Admin:GetPlayerRank()
    local rankData = NPC.Admin:GetRankData(rank)

    if rankData and rankData.grant < 90 then return end

    local WaypointHandle = GetFirstBlipInfoId(8)
    if DoesBlipExist(WaypointHandle) then
        local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

        for height = 1, 1000 do
            SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

            local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

            if foundGround then
                SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                break
            end

            Citizen.Wait(5)
        end

    else
        TriggerEvent("DoLongHudText", 'Failed to find marker.',2)
    end

end

function NPC.Admin.split(source, sep)
    local result, i = {}, 1
    while true do
        local a, b = source:find(sep)
        if not a then break end
        local candidat = source:sub(1, a - 1)
        if candidat ~= "" then
            result[i] = candidat
        end i=i+1
        source = source:sub(b + 1)
    end
    if source ~= "" then
        result[i] = source
    end
    return result
end

function NPC.Admin.RunNclp(self,bool)
    local cmd = {}
    cmd = {
        vars = {}
    }


    local rank = NPC.Admin:GetPlayerRank()
    local rankData = NPC.Admin:GetRankData(rank)

    if rankData and rankData.grant < 90 then return end

    if bool and isInNoclip then return end
    isInNoclip = bool

    TriggerEvent("npc-admin:noClipToggle", isInNoclip)
end

function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            players[#players+1]= i
        end
    end

    return players
end

RegisterNetEvent("npc-admin:RunClCommand")
AddEventHandler("npc-admin:RunClCommand", function(cmd, args)
    NPC.Admin:RunClCommand(cmd, args)
end)

RegisterNetEvent("npc-admin:updateData")
AddEventHandler("npc-admin:updateData", function(src, type, data)
    if not src or not type or not data then return end
    if not NPC._Admin.Players[src] then return end

    NPC._Admin.Players[src][type] = data
end)

RegisterNetEvent("npc-admin:noLongerAdmin")
AddEventHandler("npc-admin:noLongerAdmin", function()
    NPC._Admin.Players = {}

    for k,v in pairs(NPC._Admin.Menu.Menus) do
        if WarMenu.IsMenuOpened(k) then WarMenu.CloseMenu() end
    end
end)

RegisterNetEvent("npc-admin:bringPlayer")
AddEventHandler("npc-admin:bringPlayer", function(targPos)
    Citizen.CreateThread(function()
        RequestCollisionAtCoord(targPos.x, targPos.y, targPos.z)
        SetEntityCoordsNoOffset(PlayerPedId(), targPos.x, targPos.y, targPos.z, 0, 0, 2.0)
        FreezeEntityPosition(PlayerPedId(), true)
        SetPlayerInvincible(PlayerId(), true)

        local startedCollision = GetGameTimer()

        while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
            if GetGameTimer() - startedCollision > 5000 then break end
            Citizen.Wait(0)
        end

        FreezeEntityPosition(PlayerPedId(), false)
        SetPlayerInvincible(PlayerId(), false)
    end)
end)

local LastVehicle = nil
RegisterNetEvent("npc-admin:runSpawnCommand")
AddEventHandler("npc-admin:runSpawnCommand", function(model, livery)
    Citizen.CreateThread(function()

        local hash = GetHashKey(model)

        if not IsModelAVehicle(hash) then return end
        if not IsModelInCdimage(hash) or not IsModelValid(hash) then return end

        RequestModel(hash)

        while not HasModelLoaded(hash) do
            Citizen.Wait(0)
        end

        local localped = PlayerPedId()
        local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 1.5, 5.0, 0.0)

        local heading = GetEntityHeading(localped)
        local vehicle = CreateVehicle(hash, coords, heading, true, false)

        SetVehicleModKit(vehicle, 0)
        SetVehicleMod(vehicle, 11, 3, false)
        SetVehicleMod(vehicle, 12, 2, false)
        SetVehicleMod(vehicle, 13, 2, false)
        SetVehicleMod(vehicle, 15, 3, false)
        SetVehicleMod(vehicle, 16, 4, false)

        local plate = GetVehicleNumberPlateText(vehicle)
        TriggerEvent("keys:addNew",vehicle,plate)
        TriggerServerEvent('garages:addJobPlate', plate)
        SetModelAsNoLongerNeeded(hash)

        SetVehicleDirtLevel(vehicle, 0)
        SetVehicleWindowTint(vehicle, 0)

        if livery ~= nil then
            SetVehicleLivery(vehicle, tonumber(livery))
        end
        LastVehicle = vehicle
    end)
end)


RegisterNetEvent("npc-admin:SeatIntoLast")
AddEventHandler("npc-admin:SeatIntoLast", function()
    local rank = NPC.Admin:GetPlayerRank()
    local rankData = NPC.Admin:GetRankData(rank)

    if rankData and rankData.grant < 90 then return end
    if LastVehicle ~= nil then
        TaskWarpPedIntoVehicle(PlayerPedId(),LastVehicle,-1)
    else
         TriggerEvent("DoLongHudText", 'Failed to find Vehicle.',2)
    end
end)

RegisterNetEvent("npc-admin:ReviveInDistance")
AddEventHandler("npc-admin:ReviveInDistance", function()
    local rank = NPC.Admin:GetPlayerRank()
    local rankData = NPC.Admin:GetRankData(rank)

    if rankData and rankData.grant < 90 then return end
    local playerList = {}

    local players = GetPlayers()
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)


    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
        local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
        if(distance < 50) then
            playerList[index] = GetPlayerServerId(value)
        end
    end

    if playerList ~= {} and playerList ~= nil then
        TriggerServerEvent("admin:reviveAreaFromClient",playerList)

        for k,v in pairs(playerList) do
             TriggerServerEvent("reviveGranted", v)
             TriggerEvent("Hospital:HealInjuries",true)
             TriggerServerEvent("ems:healplayer", v)
             TriggerEvent("heal")
        end
    end

end)

RegisterNetEvent('admin:RegetGroup')
AddEventHandler('admin:RegetGroup', function()
    NPC.Admin:GetPlayerRank()
end)

RegisterNetEvent("npc-admin:bringPlayer")
AddEventHandler("npc-admin:bringPlayer", function(targPos)
    Citizen.CreateThread(function()
        RequestCollisionAtCoord(targPos.x, targPos.y, targPos.z)
        SetEntityCoordsNoOffset(PlayerPedId(), targPos.x, targPos.y, targPos.z, 0, 0, 2.0)
        FreezeEntityPosition(PlayerPedId(), true)
        SetPlayerInvincible(PlayerId(), true)

        local startedCollision = GetGameTimer()

        while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
            if GetGameTimer() - startedCollision > 5000 then break end
            Citizen.Wait(0)
        end

        FreezeEntityPosition(PlayerPedId(), false)
        SetPlayerInvincible(PlayerId(), false)
    end)
end)

function DrawPlayerInfo(target)
	drawTarget = target
	drawInfo = true
end

function StopDrawPlayerInfo()
	drawInfo = false
	drawTarget = 0
end

Citizen.CreateThread( function()
	while true do
		Citizen.Wait(0)
		if drawInfo then
			local text = {}
			local targetPed = GetPlayerPed(drawTarget)
			table.insert(text,"~g~Health:~s~  "..GetEntityHealth(targetPed).." / "..GetEntityMaxHealth(targetPed))
			table.insert(text,"~b~Armor:~s~  "..GetPedArmour(targetPed))
			for i,theText in pairs(text) do
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.30)
				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString(theText)
				EndTextCommandDisplayText(0.3, 0.7+(i/30))
			end
		end
	end
end)

local called = false
local x,y,z = nil
local TargetC = nil

RegisterNetEvent("admin:attach")
AddEventHandler("admin:attach", function(tSrc, toggle)
    local ped = PlayerPedId()
    local PlayerPos = GetEntityCoords(ped, false)
    if called == false then
        x,y,z = PlayerPos.x, PlayerPos.y, PlayerPos.z
    end
    Citizen.CreateThread(function()
        if toggle == true then
            called = true
            Citizen.Wait(300)
            if TargetC ~= nil then
                SetEntityVisible(ped, false)
                SetPlayerInvincible(ped, true)
                SetEntityCollision(ped,false,false)
                SetEntityCoordsNoOffset(PlayerPedId(), TargetC.x - 0.5, TargetC.y, TargetC.z, 0, 0, 4.0)
                local startedCollision = GetGameTimer()

                while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
                    if GetGameTimer() - startedCollision > 5000 then break end
                    Citizen.Wait(0)
                end

                Citizen.Wait(500)
                SetEntityVisible(ped, false)
                SetPlayerInvincible(ped, true)
                SetEntityCollision(ped,false,false)
                local targId = GetPlayerFromServerId(tSrc)
                local targPed = GetPlayerPed(targId)

                DrawPlayerInfo(targId)
                AttachEntityToEntity(ped, targPed, 11816, 0.0, -1.48, 2.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
            else
                print("[npc-admin]: No Target Coords")
            end
        else
            TargetC = nil
            called = false
            DetachEntity(ped,true,true)
            SetEntityCollision(ped,true,true)
            SetPlayerInvincible(ped, false)
            SetEntityVisible(ped, true)
            StopDrawPlayerInfo()
            SetEntityCoords(ped, x,y,z)
        end
    end)
end)

RegisterNetEvent("admin:sendCoords")
AddEventHandler("admin:sendCoords", function(coords)
    TargetC = coords
end)

NPC.Admin:Init()