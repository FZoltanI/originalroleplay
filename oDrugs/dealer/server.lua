local dealerPeds = {}
function createDrugDealerPeds()
    for k, v in ipairs(drugdealerPositions) do 
        local ped = createPed(drugPedSkins[math.random(#drugPedSkins)], v[1], v[2], v[3], v[4])
        setElementData(ped, "drugBuyerNPC", true)
        setElementData(ped, "drugBuyer:buyedItems", 0)
        setElementData(ped, "drugBuyer:campos", {v[5], v[6], v[7], v[8], v[9], v[10]})
        setElementData(ped, "ped:name", core:createRandomName("boy"))
        setElementData(ped, "ped:prefix", "Dealer")
        setElementFrozen(ped, true)

        dealerPeds[ped] = ped
    end
end
createDrugDealerPeds()

setTimer(function()
    for k, v in pairs(dealerPeds) do 
        local buyed = getElementData(v, "drugBuyer:buyedItems")
        if buyed > 0 then 
            setElementData(v, "drugBuyer:buyedItems", math.max(0, buyed - 10))
        end
    end
end, core:minToMilisec(5), 0)