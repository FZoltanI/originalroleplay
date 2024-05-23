addEvent("weaponCraft > startWeaponCraft", true)
addEventHandler("weaponCraft > startWeaponCraft", resourceRoot, function(items)
    setElementFrozen(client, true)
    setPedAnimation(client, "shop", "shp_serve_loop", _, true, false, false, _, _)

    for k, v in ipairs(items) do 
        if v[2] > 0 then 
            inventory:takeItem(client, v[1], v[2])
        end
    end
end)

addEvent("weaponCraft > endWeaponCraft", true)
addEventHandler("weaponCraft > endWeaponCraft", resourceRoot, function(success, itemDatas)
    setElementFrozen(client, false)
    setPedAnimation(client)
    
    if success then 
        inventory:giveItem(client, itemDatas[1], itemDatas[2], itemDatas[3], 0, itemDatas[2])
    end
end)