local GetEntityCoords = GetEntityCoords
local SendNUIMessage = SendNUIMessage
local GetScreenCoordFromWorldCoord = GetScreenCoordFromWorldCoord
local GetActiveScreenResolution = GetActiveScreenResolution

globalOptions = {}
local visibleOptions = {}
local screenData = {}
local cacheCoords = nil
Citizen.CreateThread(function()
    while true do
        Wait(500)
        local newCoords = GetEntityCoords(cache.ped)
        cacheCoords = vector3(newCoords.x, newCoords.y, newCoords.z)
    end
end)

Citizen.CreateThread(function()
    while true do
        local x, y = GetActiveScreenResolution()
        screenData.x = x
        screenData.y = y
        Wait(5000)
    end
end)

local function showInteraction(data)
    local optionData = globalOptions[data.id]
    local optionCoords = optionData.coords 
    local isVisible, screenX, screenY = GetScreenCoordFromWorldCoord(optionCoords.x, optionCoords.y, optionCoords.z)
    if isVisible and (screenX > 0.33 and screenX < 0.67) and (screenY > 0.22 and screenY < 0.78) then
        screenX = screenX * screenData.x
        screenY = screenY * screenData.y
        optionData.isClose = data.isClose
        local sortedOptions = sortOptions(optionData)
        if sortedOptions.optionsCount > 0 then
            if not optionData.display then
                optionData.display = true
                SendNUIMessage({
                    action = 'CreateInteraction',
                    id = data.id,
                    data = sortedOptions,
                    pos = {top = screenY, left = screenX},
                    isClose = data.isClose
                })
                return 5
            else
                SendNUIMessage({
                    action = 'UpdateInteraction',
                    id = data.id,
                    data = sortedOptions,
                    pos = {top = screenY, left = screenX},
                    isClose = data.isClose
                })
                return 5
            end
        else
            SendNUIMessage({action = 'HideInteraction'})
            optionData.display = false
            optionData.isClose = false
            return 100
        end
    else
        SendNUIMessage({action = 'HideInteraction'})
        optionData.display = false
        optionData.isClose = false
        return 100
    end
end

local function HideInteraction()
    SendNUIMessage({action = 'HideInteraction'})
end

Citizen.CreateThread(function()
    Wait(1000)
    while true do
        local sleep = 2000
        local newId = nil

        local isSkip = false
        if not cacheCoords or not canInteract() then
            isSkip = true
            goto skip
        end

        for i = 1, #globalOptions do
            local globalItem = globalOptions[i]
            local itemDistance = globalItem.distance
            local itemType = globalItem.type
            if itemType then
                if itemType == 'globalPed' then
                    local ped, pedCoords = lib.getClosestPed(cacheCoords, itemDistance * 2.5)
                    if ped and ped ~= 0 then
                        globalItem.coords = pedCoords
                    else
                        globalItem.coords = nil
                    end
                elseif itemType == 'globalVehicle' then
                    local vehicle, vehCoords = lib.getClosestVehicle(cacheCoords, itemDistance * 2.25, true)
                    if vehicle and vehicle ~= 0 then
                        globalItem.coords = vehCoords
                    else
                        globalItem.coords = nil
                    end
                elseif itemType == 'localEntity' then
                    if DoesEntityExist(globalItem.entity) then
                        globalItem.coords = GetEntityCoords(globalItem.entity)
                    else
                        globalItem.coords = nil
                    end
                elseif itemType == 'netEntity' then
                    local netEntity = NetworkGetEntityFromNetworkId(globalItem.entity)
                    if netEntity and netEntity ~= 0 and DoesEntityExist(netEntity) then
                        globalItem.coords = GetEntityCoords(netEntity)
                    end
                end
            end

            if globalItem.coords then
                local itemCoords = vector3(globalItem.coords.x, globalItem.coords.y, globalItem.coords.z)
                local itemDist = #(cacheCoords - itemCoords)
                if itemDist < (itemDistance * 2) then
                    sleep = showInteraction({isClose = itemDist < itemDistance and true or false, id = i})
                    newId = i
                    break
                end
            end
        end

        if newId then
            for k, v in pairs(visibleOptions) do
                if k ~= newId then
                    globalOptions[k].display = false
                    globalOptions[k].isClose = false
                end
            end
            visibleOptions[newId] = true
        else
            local wasDisplayed = false
            for k, v in pairs(visibleOptions) do
                if globalOptions[k].display then
                    wasDisplayed = true
                end

                globalOptions[k].display = false
                globalOptions[k].isClose = false
            end
            
            if wasDisplayed then
                HideInteraction()
            end
        end

        ::skip::
        if isSkip then
            local wasDisplayed = false
            for k, v in pairs(visibleOptions) do
                if globalOptions[k].display then
                    wasDisplayed = true
                end

                globalOptions[k].display = false
                globalOptions[k].isClose = false
            end
            
            if wasDisplayed then
                HideInteraction()
            end
        end
        Wait(sleep)
    end
end)