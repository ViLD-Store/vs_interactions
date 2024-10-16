

local function switchOption(direction)
    SendNUIMessage({action = 'SelectOption', direction = direction})
end

function canInteract()
    return not LocalPlayer.state.isDead and not cache.vehicle and not LocalPlayer.state.isCuffed
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
            if not option.canInteract() then
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

    local optionData = globalOptions[globalId].options[optionId]
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
        optionData.onSelect()
    end
end)