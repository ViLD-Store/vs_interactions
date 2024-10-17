local optionId = 0

local function addCoords(data)
    if not data.coords or not data.options then
        return
    end

    local isInserted = false
    for i = 1, #globalOptions do
        local option = globalOptions[i]
        local coords = option.coords
        if coords and #(coords - data.coords) < 1.0 then
            isInserted = true
            local options = option.options
            for i = 1, #data.options do
                table.insert(options, data.options[i])
            end
            break
        end
    end

    if not isInserted then
        optionId += 1
        table.insert(globalOptions, {
            id = optionId,
            resource = GetInvokingResource(),
            coords = data.coords,
            distance = data.distance or 2,
            options = data.options
        })

        return optionId
    end
end

exports('addCoords', addCoords)

local function addLocalEntity(data)
    if not data.entity or not data.options then
        return
    end

    optionId += 1
    table.insert(globalOptions, {
        id = optionId,
        resource = GetInvokingResource(),
        type = 'localEntity',
        entity = data.entity,
        distance = data.distance or 2,
        options = data.options
    })
    
    return optionId
end

exports('addLocalEntity', addLocalEntity)

local function addEntity(data)
    if not data.netId or not data.options then
        return
    end

    optionId += 1
    table.insert(globalOptions, {
        id = optionId,
        resource = GetInvokingResource(),
        type = 'netEntity',
        entity = data.netId,
        distance = data.distance or 2,
        options = data.options
    })

    return optionId
end

exports('addEntity', addEntity)

local function addGlobalPed(data)
    if not data.options then
        return
    end

    optionId += 1
    table.insert(globalOptions, {
        id = optionId,
        resource = GetInvokingResource(),
        type = 'globalPed',
        distance = data.distance or 3,
        options = data.options
    })

    return optionId
end

exports('addGlobalPed', addGlobalPed)

local function addGlobalVehicle(data)
    if not data.options then
        return
    end

    optionId += 1
    table.insert(globalOptions, {
        id = optionId,
        resource = GetInvokingResource(),
        type = 'globalVehicle',
        distance = data.distance or 2,
        options = data.options
    })

    return optionId
end

exports('addGlobalVehicle', addGlobalVehicle)

local function addModel(data)
    if not data.options or not data.model then
        return
    end

    optionId += 1
    table.insert(globalOptions, {
        id = optionId,
        resource = GetInvokingResource(),
        model = data.model,
        type = 'globalModel',
        distance = data.distance or 2,
        options = data.options
    })

    return optionId
end

exports('addModel', addModel)

local function removeInteract(id)
    if not id then
        return
    end

    local isRemoved = false
    for k, v in pairs(globalOptions) do
        if v.id == id then
            table.remove(globalOptions, k)
            isRemoved = true
            break
        end
    end

    if not isRemoved then
        print(('Attempt to remove option which doesnt exist id: '):format(id))
    end

    HideInteraction()
end

exports('removeInteract', removeInteract)

-- AddEventHandler('onResourceStop', function(resourceName)
--     for k, v in pairs(globalOptions) do
--         if v.resource and v.resource == resourceName then
--             table.remove(globalOptions, k)
--         end
--     end
-- end)

-- SetTimeout(2000, function()
--     addModel({
--         model = 'elegy',
--         distance = 4.0,
--         options = {
--             {
--                 label = 'Zrób kupe',
--                 onSelect = function() print('fiut') end
--             }
--         }
--     })
-- end)