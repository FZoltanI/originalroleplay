local robberyBlips = {}

addEvent("shoprob > startShopRob", true)
addEventHandler("shoprob > startShopRob", resourceRoot, function(ped)
    local x, y, z = getElementPosition(ped)

    robberyBlips[ped] = createBlip(x, y, z, 18)
    setElementData(robberyBlips[ped], "blip:name", "Rablás alatt álló üzlet")

    setPedAnimation(ped, "shop", "shp_rob_react", 1000, true, false, false)
    setTimer(function()
        setPedAnimation(ped, "shop", "shp_rob_givecash", -1, true, false, false)
    end, 1000, 1)
    setElementData(ped, "shop:inRob", true)

    local zoneName = getZoneName(x, y, z)

    for k, v in ipairs(getElementsByType("player")) do 
        if exports.oDashboard:getFactionType(getElementData(v, "char:duty:faction")) == 1 then 
            outputChatBox(core:getServerPrefix("blue-light-2", "Központ", 3).."Figyelem! Boltrablás folyamatban "..color..zoneName.." #ffffffterületén!", v, 255, 255, 255, true)
        end
    end
end)

addEvent("shoprob > endShopRob", true)
addEventHandler("shoprob > endShopRob", resourceRoot, function(ped)
    if isElement(robberyBlips[ped]) then 
        destroyElement(robberyBlips[ped])
    end

    setPedAnimation(ped, "", "")
    setElementData(ped, "shop:inRob", false)

    local shop = ped 

    setTimer(function()
        setElementData(shop, "shop:isRobbable", true)
    end, core:minToMilisec(180), 1)
end)