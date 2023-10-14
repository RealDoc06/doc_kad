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

function PedHit(name, entity)
    local prop = GetRandomItemName(Config.npcs[name].props)
    local position = Config.npcs[name].position
    local ped = Config.npcs[name].ped

    if GetEntityType(entity) == 1 then
        DeleteEntity(entity)
        return SpawnObj(prop, vec3(position))
    elseif GetEntityType(entity) == 3 then
        DeleteEntity(entity)
        return SpawnPed(ped, position)
    end
    -- return false
end

function SpawnPed(model, pos)
    local pedHash = GetHashKey(model)
    local position = vec4(pos)
    
    RequestModel(pedHash)
    while not HasModelLoaded(pedHash) do Citizen.Wait(1) end

    local npc = CreatePed(4, pedHash, position, true, true)

    SetEntityCoordsNoOffset(npc, vec3(position), true, true, true)
    SetModelAsNoLongerNeeded(pedHash)
    FreezeEntityPosition(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    
    -- workaround because if ped set to invincible it will not trigger the "entityDamaged" event
    SetPedArmour(npc, 999999)
    SetPedHelmet(npc, true)

    RequestAnimDict("anim@amb@nightclub@peds@")
    while not HasAnimDictLoaded("anim@amb@nightclub@peds@") do Citizen.Wait(1) end
    TaskPlayAnim(npc, "anim@amb@nightclub@peds@", "amb_world_human_stand_guard_male_base", 1.0, 1.0, -1, 1, 1.0, 0, 0, 0)
    return npc
end

function SpawnObj(model, pos)
    local model = GetHashKey(model)
    local position = vec3(pos)
    
    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(1) end

    local obj = CreateObject(model, vec3(position), false, true, false)

    SetModelAsNoLongerNeeded(model)
    PlaceObjectOnGroundProperly(obj)
    FreezeEntityPosition(obj, true)
    return obj
end

function SpawnPeds()
    local peds = {}
    for k, v in pairs(Config.npcs) do
        
        npc = SpawnPed(v.ped, v.position)

        debug(string.format("+ %s", k))
        peds[k] = npc
    end
    return peds
end

function IsScriptEntity(entity, table)
    for k, v in pairs(table) do
        if entity == v then
            return true
        end
    end
    return false
end

function GetScriptEntity(entity, table)
    for k, v in pairs(table) do
        if v == entity then
            return k
        end
    end
    return nil
end