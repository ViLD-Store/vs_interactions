local function addCoords(data)
    if not data.coords or not data.options then
        return
    end

    local isInserted = false
    for i = 1, #globalOptions do
        local option = globalOptions[i]
        local coords = option.coords
        if #(coords - data.coords) < 1.0 then
            isInserted = true
            local options = option.options
            for i = 1, #data.options do
                table.insert(options, data.options[i])
            end
            break
        end
    end

    if not isInserted then
        table.insert(globalOptions, {
            resource = GetInvokingResource(),
            coords = data.coords,
            distance = data.distance or 2,
            options = data.options
        })
    end
end

exports('addCoords', addCoords)

local function addLocalEntity(data)
    if not data.entity or not data.options then
        return
    end

    table.insert(globalOptions, {
        resource = GetInvokingResource(),
        type = 'localEntity',
        entity = data.entity,
        distance = data.distance or 2,
        options = data.options
    })
end

exports('addLocalEntity', addLocalEntity)

local function addEntity(data)
    if not data.netId or not data.options then
        return
    end

    table.insert(globalOptions, {
        resource = GetInvokingResource(),
        type = 'netEntity',
        entity = data.netId,
        distance = data.distance or 2,
        options = data.options
    })
end

exports('addEntity', addEntity)

local function addGlobalPed(data)
    if not data.options then
        return
    end

    table.insert(globalOptions, {
        resource = GetInvokingResource(),
        type = 'globalPed',
        distance = data.distance or 3,
        options = data.options
    })
end

exports('addGlobalPed', addGlobalPed)

local function addGlobalVehicle(data)
    if not data.options then
        return
    end

    table.insert(globalOptions, {
        resource = GetInvokingResource(),
        type = 'globalVehicle',
        distance = data.distance or 2,
        options = data.options
    })
end

exports('addGlobalVehicle', addGlobalVehicle)

function addInteract(data)
    if not data.options then
        return
    end

    if not data.coords and not data.entity then
        return
    end

    local interactId <const> = (#interactOptions + 1)
    interactOptions[interactId] = {
        coords = data.coords or nil,
        entity = data.entity or nil,
        distance = data.distance or 1.75,
        options = data.options
    }
    return interactId
end

exports('addInteract', addInteract)