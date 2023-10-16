function GetRandomItemName(props)
    local totalChance = 0
    for itemName, itemData in pairs(props) do
        totalChance = totalChance + itemData.chance
    end

    local randomValue = math.random(1, totalChance)
    local cumulativeChance = 0

    for itemName, itemData in pairs(props) do
        cumulativeChance = cumulativeChance + itemData.chance
        if randomValue <= cumulativeChance then
            return itemName
        end
    end

    -- Se non viene restituito alcun nome (dovrebbe accadere solo in casi estremamente rari),
    -- è possibile restituire un valore predefinito o gestire diversamente l'errore.
    return nil
end

function SpawnPed(model, pos)
    local pedHash = model
    local position = vec4(pos)

    RequestModel(pedHash)
    while not HasModelLoaded(pedHash) do Citizen.Wait(1) end

    local npc = CreatePed(4, pedHash, position, true, true)
    SetEntityCoordsNoOffset(npc, vec3(position), true, true, true)
    
    return npc
end

function SpawnObj(model, pos)
    if type(model) == "string" then
        model = GetHashKey(model)
    end
    
    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(1) end

    local obj = CreateObject(model, vec3(pos), false, true, false)

    SetModelAsNoLongerNeeded(model)
    PlaceObjectOnGroundProperly(obj)
    SetEntityHeading(entity, pos.w)
    FreezeEntityPosition(obj, true)
    return obj
end

function IsScriptObj(obj, table)
    for k, v in pairs(table) do
        if obj == v then
            return true
        end
    end
    return false
end

function PedHit(entity)
    local prop = GetRandomItemName(Config.props)
    local position = vec4(GetEntityCoords(entity), GetEntityHeading(entity))
    local ped_model = GetEntityModel(entity)
    
    if GetEntityType(entity) == 1 then
        DeleteEntity(entity)
        return SpawnObj(prop, position), ped_model
    elseif GetEntityType(entity) == 3 and IsScriptObj(entity, objs) then
        DeleteEntity(entity)
        return SpawnPed(peds[entity], position), nil
    end
end
