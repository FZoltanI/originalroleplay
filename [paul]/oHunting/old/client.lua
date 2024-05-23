exports.oCompiler:loadCompliedModel(199, "jH8X&B-TUTj!Pk-S", ":oForestAnimals/files/models/beardff.originalmodel", ":oForestAnimals/files/models/beartxd.originalmodel", _, false)
exports.oCompiler:loadCompliedModel(218, "jH8X&B-TUTj!Pk-S", ":oForestAnimals/files/models/foxdff.originalmodel", ":oForestAnimals/files/models/foxtxd.originalmodel", _, false)
--exports.oCompiler:loadCompliedModel(207, "jH8X&B-TUTj!Pk-S", ":oForestAnimals/files/models/turtledff.originalmodel", ":oForestAnimals/files/models/turtletxd.originalmodel", _, false)
local animals = {}

addEventHandler( "onClientElementStreamIn", root,
    function ( )
        if getElementType( source ) == "ped" then
            if getElementData(source,"isForestAnimal") then 
                local headMarker1 = createMarker(0,0,0,"corona",0.2,255,255,0,0)
                local headMarker2 = createMarker(0,0,0,"corona",0.2,0,255,255,0)
                attachElements(headMarker1, source, 0, 0.4, -0.5)
                attachElements(headMarker2, source, 0, 3, 1)
                animals[source] = {source,nil,headMarker1,headMarker2,nil,nil} 

            end 
        end
    end
);

addEventHandler( "onClientElementStreamOut", root,
    function ( )
        if getElementType( source ) == "ped" then
            if getElementData(source,"isForestAnimal") then 
                animals[source] = nil 
             end 
        end
    end
);

local closeDistance = 0.4
local mediumDistance = 2
local bigDistance = 10
local bigDistance2 = 100

local rots = {
    {342},
    {252},
    {162},
    {72},
    {20},
    {50},
    {70},
}

setTimer(function()
    for animal,data in pairs(animals) do 
		if not isElement(animal) then
			animals[animal] = nil
			break
		end

		if not isElement(data[1]) then
			animal[animal] = nil
			break
		end

		if isPedDead(animal) then
			animal[animal] = nil
			break
		end

		local tempDist = closeDistance
		local isAttack = false
		local px,py,pz = getElementPosition(animal)
		local x,y,z
		local targetElement = getElementData(animal,"animal:target")
		local targetPlayer
        local walkTimer

		if isElement(targetElement) then
			isAttack = true
			targetPlayer = targetElement
			x,y,z = getElementPosition(targetElement)
			tempDist = tempDist + 0.8
		else
			local collision = getElementData(data[1], "animal:rangeCol")

			if not isElement(collision) then
				animals[animal] = nil
				break
			end

			targetPlayer = data[1]
			x,y,z = getElementPosition(collision)

		end

		local dist = getDistanceBetweenPoints3D(x,y,z,px,py,pz)

		local isClear = true

		-- if getElementDimension(pet) == 0 then

			local px,py,pz = getElementPosition(animal)
			local hX, hY, hZ = getElementPosition(data[3])
			local hX2, hY2, hZ2 = getElementPosition(data[4])

			local hit = isLineOfSightClear(px, py, px, hX, hY, hZ, true, true, false, true, true, true, false, targetPlayer)
			local hit2 = isLineOfSightClear(hX, hY, hZ, hX2, hY2, hZ2, true, true, false, true, true, true, false, targetPlayer)

			if not hit and not hit2 then
				isClear = false
			else
				isClear = true
			end

            if isClear then

                if dist > tempDist+0.5 then
                    
                    setPedRotation(animal, (math.atan2(y - py, x - px) * 180 / math.pi)-90)
    
                    setPedControlState(animal, "forwards", true)
    
                    if dist > bigDistance then
    
                        setPedControlState(animal, "sprint", true)
    
                        setPedControlState(animal, "walk", false)
    
                    elseif dist > mediumDistance then
    
                        setPedControlState(animal, "walk", false)
    
                        setPedControlState(animal, "sprint", false)
    
                    else
    
                        setPedControlState(animal, "walk", true)
    
                        setPedControlState(animal, "sprint", false)
    
                    end
    
                    setPedControlState(animal, "fire", false)
    
                    if isTimer(data[6]) then
    
                        killTimer(data[6])
    
                    end
    
                else
    
                    if isAttack then

                        if isPlayerDead(targetElement) then 
                            isAttack = false 
                            killTimer(data[6])
                        end

                        if not isTimer(data[6]) then
    
                            setPedControlState(animal, "fire", true)
    
                            data[6] = setTimer(function(animal)
    
                                setPedControlState(animal, "fire", false)
    
                            end, 200, 1, animal)
    
                        end
    
                    end
    
                    setPedControlState(animal, "sprint", false)
    
                    setPedControlState(animal, "forwards", false)
    
                    setPedControlState(animal, "walk", false)
    
                end
            elseif dist > tempDist+0.5 then


                if not isTimer(data[5]) then
    
                    setPedRotation(animal, (math.atan2(y - py, x - px) * 180 / math.pi)-90)
    
                    setPedControlState(animal, "jump", true)
    
                    data[5] = setTimer(function(animal)
    
                        setPedControlState(animal, "jump", false)
    
                    end, 1000, 1, animal)
    
                end
    
                setPedControlState(animal, "sprint", false)
    
                setPedControlState(animal, "forwards", false)
    
                setPedControlState(animal, "walk", false)
    
                setPedControlState(animal, "fire", false)
    
                if isTimer(data[6]) then
    
                    killTimer(data[6])
    
                end
    
            end
    end
end,200,0)

function countLoadedAnimals()
    for k,v in pairs(getElementsByType("ped")) do 
        if isElementStreamedIn(v) then 
            if getElementData(v,"isForestAnimal") then
            end
        end
    end 
end 

function setTask(element,task,value)
 setPedControlState(element,task,value)
end 
addEvent("setTask",true)
addEventHandler("setTask",root,setTask)

local rots = {
    {40},
    {70},
    {120},
    {160},
    {240}
}

function setWalk()
    for k,v in pairs(getElementsByType("ped")) do 
        if getElementData(v,"isForestAnimal") then 
            setPedControlState(v,"forwards",true)
            setPedControlState(v,"walk",true)

            setElementRotation(v,0,0,rots[math.random(#rots)][1])
        end 
    end 
end 

setWalk()

setTimer(function()
    setWalk()
end,1000 * 60 * math.random(2,7), 0)

addEventHandler("onClientPedDamage", resourceRoot, function(attacker, weapon)
    --if weapon == 0 then 
      --  cancelEvent()
    --else
        if attacker == localPlayer then 
            if getElementData(source, "animal:targetPlayer") == localPlayer then return end
            --triggerServerEvent("animal > startPlayerFighting", resourceRoot, source)
        end 
    --end
end)

addEventHandler("onClientColShapeHit", resourceRoot, function(player, mdim)
    if player == localPlayer and mdim then 
        if getElementData(source, "animal:isAnimalFightRange") then 
            if getElementData(getElementData(source, "animal:colAnimal"), "animal:targetPlayer") then return end
            --triggerServerEvent("animal > startPlayerFighting", resourceRoot, getElementData(source, "animal:colAnimal"))
        end
    end
end)

setTimer(function()
    for k, v in ipairs(getElementsByType("ped", resourceRoot)) do 
        local posX, posY, posZ = getElementPosition(v)
        posZ2 = getGroundPosition(posX, posY, posZ+3)
        posZ2 = posZ2 + 1

        --if not isElementInWater(v) then 
        if posZ < posZ2 then 
            setElementPosition(v, posX, posY, posZ2)
            --print("set")
        end
        --else 
        --    setElementPosition(v, posX, posY, getWaterLevel(posX, posY, posZ), false)
        --end
    end
end, 250, 0)

local inInteraction = false

function skinAnimal(animal)
    if inInteraction then outputChatBox(core:getServerPrefix("red-dark", "OriginalRP", 1).."Egyszerre csak egy dolgot csinálj!", 255, 255, 255, true) return end
    local items = getElementData(animal, "animal:loot")

    if items[2][2] > 0 then 
        if exports.oInventory:getAllItemWeight() + (exports.oInventory:getItemWeight(items[2][1])) <= 20 then 
            setElementFrozen(localPlayer, true)
            inInteraction = true
            items[2][2] = items[2][2] - 1

            local isLast = false 
            local count = 0 
            for k, v in ipairs(items) do             
                count = count + v[2]
            end

            if count == 0 then 
                isLast = true
            end

            triggerServerEvent("forestAnimal > startAnimalSkinInServer", resourceRoot, animal, items, items[2][1], isLast)

            core:createProgressBar(getElementData(animal, "ped:name").." megnyúzása", math.random(15000, 25000), "forestAnimal > skinEnd", true)

            exports.oChat:sendLocalMeAction("elkezdtett megnyúzni egy "..getElementData(animal, "ped:name").."-t.")
        else
            exports.oInfobox:outputInfoBox("Nincs elég hely az inventorydban!", "error")
        end
    end
end 

function createAnimalTrophy(animal)
    if inInteraction then outputChatBox(core:getServerPrefix("red-dark", "OriginalRP", 1).."Egyszerre csak egy dolgot csinálj!", 255, 255, 255, true) return end
    local items = getElementData(animal, "animal:loot")

    if items[1][2] > 0 then 
        if exports.oInventory:getAllItemWeight() + (exports.oInventory:getItemWeight(items[1][1])) <= 20 then 
            setElementFrozen(localPlayer, true)
            inInteraction = true
            items[1][2] = items[1][2] - 1
            
            local isLast = false 
            local count = 0 
            for k, v in ipairs(items) do             
                count = count + v[2]
            end

            if count == 0 then 
                isLast = true
            end

            triggerServerEvent("forestAnimal > startCreateTrophy", resourceRoot, animal, items, items[1][1], isLast)

            core:createProgressBar(getElementData(animal, "ped:name").." trófea készítése", math.random(25000, 35000), "forestAnimal > skinEnd", true)

            exports.oChat:sendLocalMeAction("elkezdtett készíteni "..getElementData(animal, "ped:name").." trófeát.")
        else
            exports.oInfobox:outputInfoBox("Nincs elég hely az inventorydban!", "error")
        end
    end
end 

addEvent("forestAnimal > skinEnd", true)
addEventHandler("forestAnimal > skinEnd", root, function()
    inInteraction = false 
    setElementFrozen(localPlayer, false)

    triggerServerEvent("forestAnimal > endInteraction", resourceRoot)
end)

--dev
--[[addEventHandler("onClientRender", root, function()
    for k, v in ipairs(getElementsByType("ped", resourceRoot, true)) do 
        local posX, posY, posZ = getElementPosition(v)
        local color = tocolor(0, 0, 255)

        if getElementHealth(v) < 10 then 
            color = tocolor(255, 0, 0)
        end

        dxDrawLine3D(posX, posY, posZ-50, posX, posY, posZ+50, color, 10)
        
    end
end)]]