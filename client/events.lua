AddEventHandler("onResourceStart", function(resource)
    -- spawn peds/npcs when the resource start
    if resource == GetCurrentResourceName() then
        peds = SpawnPeds()
    end
end)

AddEventHandler("entityDamaged", function(victim, culprit, weapon, baseDamage)
    if IsScriptEntity(victim, peds) then
        local pedname = GetScriptEntity(victim, peds)
        debug("Shooted "..pedname)
        peds[pedname] = PedHit(pedname, victim)
    end
end)

AddEventHandler("onResourceStop", function(resource)
    -- remove peds/npcs when the resource stops
    if resource == GetCurrentResourceName() then
        for k, v in pairs(peds) do
            DeleteEntity(v)
        end
    end
end)