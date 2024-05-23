local createdAnimals = {}

function spawnAnimals(player)
    local type = math.random(1,#animals)
    local x, y, z = unpack(spawnPoints[math.random(1, #spawnPoints)][math.random(1, 100)])

    --outputChatBox(x..","..y..","..z)

    z = z + 2
    local animal = createPed(animals[type].model,x,y,z)
    
    setElementData(animal, "ped:name", animals[type].name)
    setElementData(animal, "isForestAnimal", true)

    setElementData(animal, "animal:loot", animals[type].loot)
    setElementData(animal,"animal:task","walk")
    setElementData(animal, "ped:damageable", true)

    setElementData(animal,"animal:headMarker1",headMarker1)
    setElementData(animal,"animal:headMarker2",headMarker2)

    if animals[type].danger then 
        local col = createColSphere(x, y, z, 18)
        setElementData(col, "animal:isAnimalFightRange", true)
        setElementData(col, "animal:colAnimal", animal)
        setElementData(animal, "animal:rangeCol", col)
        attachElements(col, animal)

        setPedArmor(animal, math.random(25, 75))
    else 
        setElementHealth(animal, math.random(65, 80))
    end

    createdAnimals[animal] = animal
end 

for i = 1, maxAnimals do 
    spawnAnimals()
end

function hill_Enter ( thePlayer, matchingDimension )
    if getElementType ( thePlayer ) == "player" then 
        if matchingDimension then 
            if getElementData(source,"animal:isAnimalFightRange") then 
                animal = getElementData(source,"animal:colAnimal")
                setElementData(animal,"animal:target",thePlayer)
            end 
        end
    end
end
addEventHandler ( "onColShapeHit", root, hill_Enter )

function hill_Exit ( thePlayer, matchingDimension )
    if getElementType ( thePlayer ) == "player" then 
        if matchingDimension then 
            if getElementData(source,"animal:isAnimalFightRange") then 
                animal = getElementData(source,"animal:colAnimal")
                setElementData(animal,"animal:target",false)
            end 
        end
    end
end
addEventHandler ( "onColShapeLeave", root, hill_Exit )

addEventHandler("onPedWasted", resourceRoot, function(ammo, killer, weapon, bodypart, stealth)
    if getElementData(source, "isForestAnimal") then 
        cancelEvent()
        setElementData(source, "ped:damageable", false)

        local col = getElementData(source, "animal:rangeCol") or false 

        if isElement(col) then 
            destroyElement(col)
        end

        createdAnimals[source] = false

        local datas = {getElementModel(source), getElementData(source, "animal:loot"), "Halott: "..getElementData(source, "ped:name"), Vector3(getElementPosition(source))}
        destroyElement(source)

        local diedAnimal = createPed(datas[1], datas[4].x, datas[4].y, datas[4].z)
        setElementData(diedAnimal, "animal:loot", datas[2])
        setElementData(diedAnimal, "ped:name", datas[3])
        setElementData(diedAnimal,"animal:task","dead")
        setElementData(diedAnimal, "animal:diedAnimal", true)
        setElementRotation(diedAnimal, 90, 90, 90,"ZXY", true)
        --setPedAnimation(diedAnimal,"crack","crckidle4",-1,true)

        setElementFrozen(diedAnimal, true)

        spawnAnimals()
    end
end)

--[[function spawnAnimal()
    local type = math.random(1, #animals)
    local x, y, z = unpack(spawnPoints[math.random(1, #spawnPoints)][math.random(1, 100)])

    z = z + 2

    local animal = createPed(animals[type].model, x, y, z)
    --createBlipAttachedTo(animal, 4)
    setElementData(animal, "ped:name", animals[type].name)
    setElementData(animal, "isForestAnimal", true)

    setElementData(animal, "animal:loot", animals[type].loot)

    hlc:enableHLCForNPC(animal, "walk")

    startAnimalWalk(animal)
    setElementData(animal, "ped:damageable", true)

    if animals[type].danger then 
        local col = createColSphere(x, y, z, 18)
        setElementData(col, "animal:isAnimalFightRange", true)
        setElementData(col, "animal:colAnimal", animal)
        setElementData(animal, "animal:rangeCol", col)
        attachElements(col, animal)

        setPedArmor(animal, math.random(25, 75))
    else 
        setElementHealth(animal, math.random(65, 80))
    end

    createdAnimals[animal] = animal

    for k,v in pairs(createdAnimals) do 
        outputChatBox(v)
    end 
end

function startAnimalWalk(animal)
    if not getElementData(animal, "animal:diedAnimal") then
        local apos = Vector3(getElementPosition(animal))
        local apos2 = Vector3(getElementPosition(animal))
        local x, y, z 

        x = math.random(-20,20)
        y = math.random(-20,20)
        z = 0

        apos.x = apos.x + x
        apos.y = apos.y + y

        hlc:addNPCTask(animal, {"walkToPos", apos.x, apos.y, 0, 10})
        setTimer(function()
            hlc:addNPCTask(animal, {"walkToPos", apos2.x, apos2.y, 0, 10})
            setTimer(function()
                startAnimalWalk(animal)  
            end, 1000 * 60 * math.random(2,7), 1)
        end, 1000 * 60 * math.random(2,7), 1)
    end
end

function fightPlayer(animal, player)
    hlc:clearNPCTasks(animal)
    hlc:setNPCWalkSpeed(animal, "run")
    hlc:addNPCTask(animal, {"killPed", player, 2, 2})
    setElementData(animal, "animal:targetPlayer", player)
end

addEventHandler("npc_hlc:onNPCTaskDone", root, function(task)
    if task[1] == "walkToPos" then 
        startAnimalWalk(source)
    elseif task[1] == "killPed" then 
        setElementData(source, "animal:targetPlayer", false)
        hlc:setNPCWalkSpeed(source, "walk")
        hlc:clearNPCTasks(source)
        startAnimalWalk(source)
    end
end)

addEvent("animal > startPlayerFighting", true)
addEventHandler("animal > startPlayerFighting", resourceRoot, function(animal)
    fightPlayer(animal, client)
end)

addEventHandler("onPedWasted", resourceRoot, function(ammo, killer, weapon, bodypart, stealth)
    if getElementData(source, "isForestAnimal") then 
        cancelEvent()
        setElementData(source, "ped:damageable", false)

        local col = getElementData(source, "animal:rangeCol") or false 

        if isElement(col) then 
            destroyElement(col)
        end

        createdAnimals[source] = false

        local datas = {getElementModel(source), getElementData(source, "animal:loot"), getElementData(source, "ped:name"), Vector3(getElementPosition(source))}
        destroyElement(source)

        local diedAnimal = createPed(datas[1], datas[4].x, datas[4].y, datas[4].z)
        setElementData(diedAnimal, "animal:loot", datas[2])
        setElementData(diedAnimal, "ped:name", datas[3])
        setElementData(diedAnimal, "animal:diedAnimal", true)
        setElementRotation(diedAnimal, 90, 90, 90, "ZXY", true)

        setElementFrozen(diedAnimal, true)

        spawnAnimal()
    end
end)    

setTimer(function()
    for k, v in pairs(createdAnimals) do 
        if isElement(v) then 
            local x, y, z = getElementPosition(k)

            local target = getElementData(k, "animal:targetPlayer") or false 

            if target then 
                if isElement(target) then 
                    if core:getDistance(k, target) > 35 then 
                        setElementData(k, "animal:targetPlayer", false)
                        hlc:setNPCWalkSpeed(k, "walk")
                        hlc:clearNPCTasks(k)
                        startAnimalWalk(k)
                    end
                else
                    setElementData(k, "animal:targetPlayer", false)
                    hlc:setNPCWalkSpeed(k, "walk")
                    hlc:clearNPCTasks(k)
                    startAnimalWalk(k)
                end
            end
        end
    end
end, 10000, 0)

for i = 1, maxAnimals do 
    spawnAnimal()
end]]

addEvent("forestAnimal > startAnimalSkinInServer", true)
addEventHandler("forestAnimal > startAnimalSkinInServer", resourceRoot, function(animal, items, item, isLast)
    if isLast then 
        destroyElement(animal)
    else
        setElementData(animal, "animal:loot", items)
    end

    setPedAnimation(client, "bomber", "bom_plant_loop", -1, true, false, false)

    exports.oInventory:giveItem(client, item, 1, 1, 0)
end)

addEvent("forestAnimal > startCreateTrophy", true)
addEventHandler("forestAnimal > startCreateTrophy", resourceRoot, function(animal, items, item, isLast)
    if isLast then 
        destroyElement(animal)
    else
        setElementData(animal, "animal:loot", items)
    end
    
    setPedAnimation(client, "bomber", "bom_plant_loop", -1, true, false, false)

    exports.oInventory:giveItem(client, item, 1, 1, 0)
end)

addEvent("forestAnimal > endInteraction", true)
addEventHandler("forestAnimal > endInteraction", resourceRoot, function(item)
    setPedAnimation(client, "", "")
end)

local playerCollisions = {}

function addCollision(player)
	local x,y,z = getElementPosition(player)
	playerCollisions[player] = createMarker(x+0.5,y+0.5,z,"corona",0.2,0,0,0,0)
	attachElements(playerCollisions[player], player, 0.5, 0.1)
	setElementData(player, "player:animalCollision", playerCollisions[player])
	setElementInterior(playerCollisions[player], getElementInterior(player))
	setElementDimension(playerCollisions[player], getElementDimension(player))
end

function destroyCollision(player)
    removeElementData(player,"player:animalCollision")
    playerCollision[player] = nil
end 