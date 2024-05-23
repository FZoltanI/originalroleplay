local fisher, fisher2
local mushroomped
local animalped

function createFisherPed()
    if isElement(fisher) then 
        destroyElement(fisher)
    end

    local hour = tonumber(core:getDate("hour"))

    for k, v in ipairs(fisher_peds) do 
        if v.minHour <= hour then 
            fisher = createPed(v.skin, fishMarket.pos.x, fishMarket.pos.y, fishMarket.pos.z, fishMarket.rot)

            if isElement(fisher) then 
                setElementFrozen(fisher, true)
                setElementData(fisher, "ped:name", v.name)
                setElementData(fisher, "ped:prefix", "Halfelvásárló")
                setElementData(fisher, "isFisherPed", true)
                setElementData(fisher, "fisherPriceMultiplier", v.priceMultiplier)
            end
            break
        end
    end
end

function createFisherPed2()
    if isElement(fisher2) then 
        destroyElement(fisher2)
    end

    local hour = tonumber(core:getDate("hour"))

    for k, v in ipairs(fisher_peds2) do 
        if v.minHour <= hour then 
            fisher2 = createPed(v.skin, fishMarket2.pos.x, fishMarket2.pos.y, fishMarket2.pos.z, fishMarket2.rot)

            if isElement(fisher2) then 
                setElementFrozen(fisher2, true)
                setElementData(fisher2, "ped:name", v.name)
                setElementData(fisher2, "ped:prefix", "Halfelvásárló")
                setElementData(fisher2, "isFisherPed", true)
                setElementData(fisher2, "fisherPriceMultiplier", v.priceMultiplier)
            end
            break
        end
    end
end

function createMushroomPed()
    if isElement(mushroomped) then 
        destroyElement(mushroomped)
    end

    local hour = tonumber(core:getDate("hour"))

    for k, v in ipairs(mushroom_peds) do 
        if v.minHour <= hour then 
            mushroomped = createPed(v.skin, mushroomMarket.pos.x, mushroomMarket.pos.y, mushroomMarket.pos.z, mushroomMarket.rot)

            if isElement(mushroomped) then 
                setElementFrozen(mushroomped, true)
                setElementData(mushroomped, "ped:name", v.name)
                setElementData(mushroomped, "ped:prefix", "Gombafelvásárló")
                setElementData(mushroomped, "isMushroomPed", true)
                setElementData(mushroomped, "mushroomPriceMultiplier", v.priceMultiplier)
            end
            break
        end
    end
end

function createAnimalPed()
    if isElement(animalped) then 
        destroyElement(animalped)
    end

    local hour = tonumber(core:getDate("hour"))

    for k, v in ipairs(animal_peds) do 
        if v.minHour <= hour then 
            animalped = createPed(v.skin, animalMarket.pos.x, animalMarket.pos.y, animalMarket.pos.z, animalMarket.rot)

            if isElement(animalped) then 
                setElementFrozen(animalped, true)
                setElementData(animalped, "ped:name", v.name)
                setElementData(animalped, "ped:prefix", "Állatfelvásárló")
                setElementData(animalped, "isAnimalPed", true)
                setElementData(animalped, "animalPriceMultiplier", v.priceMultiplier)
            end
            break
        end
    end
end
createFisherPed()
createFisherPed2()
createMushroomPed()
createAnimalPed()

setTimer(function()
    createFisherPed()
    createFisherPed2()
    createMushroomPed()
    createAnimalPed()
end, core:minToMilisec(60), 0)

addEvent("market > sellItem", true)
addEventHandler("market > sellItem", resourceRoot, function(money, slot)
    setElementData(client, "char:money", getElementData(client, "char:money")+money)
end)