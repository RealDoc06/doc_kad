objs = {}
peds = {}

AddEventHandler("entityDamaged", function(victim, culprit, weapon, baseDamage)
    local entity_type = GetEntityType(victim)
    -- objs[victim] = {}
    if entity_type == 1 and not IsPedAPlayer(victim) and IsPedAPlayer(culprit) and IsWeaponValid(weapon) then
        debug("Shooted npc "..victim)
        local v1, v2 = PedHit(victim)
        objs[victim] = v1
        peds[objs[victim]] = v2
    elseif entity_type == 3 then
        debug("Shooted obj "..victim)
        PedHit(victim)
    end
end)

AddEventHandler("onResourceStop", function(resource)
    -- remove peds/npcs when the resource stops
    if resource == GetCurrentResourceName() then
        for k, v in pairs(objs) do
            DeleteEntity(v)
        end
    end
end)