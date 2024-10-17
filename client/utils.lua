

local function switchOption(direction)
    SendNUIMessage({action = 'SelectOption', direction = direction})
end

function canInteract()
    return not LocalPlayer.state.isDead and not cache.vehicle and not LocalPlayer.state.isCuffed and not IsPauseMenuActive() and not lib.progressActive()
end

-- RegisterCommand('test_model', function()
--     getClosestModel(GetEntityCoords(cache.ped), 4.0, 'elegy')
-- end)

function getClosestModel(coords, distance, model)
    local hashModel = GetHashKey(model)
    local veh, vehCoords = lib.getClosestVehicle(coords, distance, true)
    if veh and veh ~= 0 and joaat(GetEntityModel(veh)) == hashModel then
        return veh, vector3(vehCoords.x, vehCoords.y, vehCoords.z + 0.5)
    end

    local obj, objCoords = lib.getClosestObject(coords, distance)
    if obj and obj ~= 0 and joaat(GetEntityModel(obj)) == hashModel then
        return obj, objCoords
    end
    
    local ped, pedCoords = lib.getClosestPed(coords, distance)
    if ped and ped ~= 0 and joaat(GetEntityModel(ped)) == hashModel then
        return ped, pedCoords
    end

    return nil
end

local lastOptions = {}
function sortOptions(data)
    local newData = data
    local sortedOptions = {}
    local optionsCount = #newData.options
    local id = 0
    for i = 1, #newData.options do
        id += 1
        local option = newData.options[i]
        sortedOptions[id] = lib.table.deepclone(option)
        if option.onSelect then
            sortedOptions[id].onSelect = nil
        end

        if option.canInteract then
            if not option.canInteract(data.tempEntity, data.coords) then
                optionsCount -= 1
                sortedOptions[id] = nil
            else
                sortedOptions[id].canInteract = nil
            end
        end
    end

    local isChanged = false
    if not lib.table.matches(lastOptions, sortedOptions) then
        lastOptions = sortedOptions
        isChanged = true
    end

    return {options = sortedOptions, isChanged = isChanged, optionsCount = optionsCount}
end

Citizen.CreateThread(function()
    lib.addKeybind({
        name = 'interact_up',
        description = 'Switch interaction to up',
        defaultKey = 'UP',
        onPressed = function(self)
            switchOption('up')
        end,
    })

    lib.addKeybind({
        name = 'interact_down',
        description = 'Switch interaction to down',
        defaultKey = 'DOWN',
        onPressed = function(self)
            switchOption('down')
        end,
    })

    lib.addKeybind({
        name = 'interact_confirm',
        description = 'Confirm option',
        defaultKey = 'E',
        onPressed = function(self)
            SendNUIMessage({
                action = 'ConfirmOption'
            })
        end,
    })
end)

RegisterNUICallback('ConfirmSelect', function(data, cb)
    local globalId = tonumber(data.id)
    local optionId = tonumber(data.optionId) + 1
    if not globalOptions[globalId] then
        return
    end

    local optionsData = globalOptions[globalId]
    local optionData = optionsData.options[optionId]
    if not optionData then
        return
    end
    if optionData.event then
        TriggerEvent(optionData.event, optionData.args)
    elseif optionData.serverEvent then
        TriggerServerEvent(optionData.serverEvent, optionData.args)
    elseif optionData.command then
        ExecuteCommand(optionData.command)
    elseif optionData.onSelect then
        optionData.onSelect({entity = optionsData.tempEntity, coords = optionsData.coords})
    end
end)