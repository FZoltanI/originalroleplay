local sx, sy = guiGetScreenSize()
local myX, myY = 1600, 900

addEventHandler('onClientResourceStart', resourceRoot, function()
    engineImportTXD(engineLoadTXD("files/rod.txd"), 338)
    engineReplaceModel(engineLoadDFF("files/rod.dff"), 338)

    triggerServerEvent("getRods", resourceRoot)

    engineSetModelLODDistance(338, 20000)
end)

addEventHandler("onClientResourceStart", root, function(res)
	if getResourceName(res) == "oCore" or getResourceName(res) == "oFont" or getResourceName(res) == "oInventory" or getResourceName(res) == "oBone" or getResourceName(res) == "oInfobox" or getResourceName(res) == "oFishing" or getResourceName(res) == "oChat" then  
		core = exports.oCore
        bone = exports.oBone
        infobox = exports.oInfobox
        font = exports.oFont
        inventory = exports.oInventory
        chat = exports.oChat

        color, r, g, b = core:getServerColor()
	end
end)

local fishingRods = {}
local inWater = false
local inGame = false

local lastClick = getTickCount()

local timer = false

local minigameValue = 0
local minigameTime = 1

local csaliPos

local sound 

addEvent("getRodsFromServer", true)
addEventHandler("getRodsFromServer", root, function(rods)
    fishingRods = rods
end)

addEventHandler("onClientRender", root, function()
    for k, v in pairs(fishingRods) do 
        if v then 
            if isElement(v[1]) and v[2] then 
                if core:getDistance(localPlayer, v[1]) < 55 then 
                    --local startX, startY, startZ = getElementPosition(v[1])
                    local startX, startY, startZ = core:getPositionFromElementOffset(v[1], 0, 0, 2.2)
                    local endX, endY, endZ = unpack(v[2])

                    dxDrawLine3D(startX, startY, startZ, endX, endY, endZ, tocolor(0, 0, 0), 1)
                end
            end
        end
    end

    if csaliPos then 
        local playerPos = Vector3(getElementPosition(localPlayer))

        if getDistanceBetweenPoints3D(playerPos.x, playerPos.y, playerPos.z, csaliPos.x, csaliPos.y, csaliPos.z) > 35 then 
            if isTimer(timer) then killTimer(timer) end
            csaliPos = false
            infobox:outputInfoBox("Túl messzire mentél a csalitól!", "error")
            removeEventHandler("onClientRender", root, renderMinigame)
            triggerServerEvent("syncRod", resourceRoot, 0, 0, 0, false)
            showCursor(false)
            inWater = false 
        end
    end
end)

addEventHandler("onClientClick", root, function(key, state, x2, y2, x, y, z, element)
    if key == "left" and state == "up" then 
        if getElementData(localPlayer, "hasFishingRod") then 
            if lastClick + 250 < getTickCount() then 
                if not inGame then 
                    local wordPos = Vector3(getWorldFromScreenPosition(x2, y2, 20))

                    if testLineAgainstWater(wordPos.x, wordPos.y, wordPos.z, wordPos.x, wordPos.y, wordPos.z+500) then
                        if isLineOfSightClear(wordPos.x, wordPos.y, wordPos.z, wordPos.x, wordPos.y, wordPos.z+500) then 

                            local playerPos = Vector3(getElementPosition(localPlayer))

                            if inWater then 
                                triggerServerEvent("syncRod", resourceRoot, 0, 0, 0, false)
                                inWater = false 
                                lastClick = getTickCount()
        
                                inGame = false
                                reached = false 
                                minigameValue = 0
                                csaliPos = false
        
                                if isTimer(timer) then killTimer(timer) end
                                return
                            end

                            if getDistanceBetweenPoints3D(playerPos.x, playerPos.y, playerPos.z, wordPos.x, wordPos.y, wordPos.z) < 35 then 
                                if not inWater then 
                                    local csaliType = 0
                                    local csaliID

                                    if inventory:hasItem(147) then
                                        _, csaliID, _, slot = inventory:hasItem(147)
                                        csaliType = 1 
                                        csaliID = 147
                                    elseif inventory:hasItem(148) then
                                        _, csaliID, _, slot = inventory:hasItem(148)
                                        csaliType = 2 
                                        csaliID = 148
                                    end

                                    if csaliType > 0 then 

                                        inventory:takeItem(csaliID)

                                        triggerServerEvent("syncRod", resourceRoot, wordPos.x, wordPos.y, wordPos.z, _)
                                        csaliPos = Vector3(wordPos.x, wordPos.y, wordPos.z)
                                        local randomTime = math.random(2500, kapasTimes[csaliType])
                                        timer = setTimer(function() 
                                            startMinigame() 
                                            infobox:outputInfoBox("Kapás van! Ahhoz, hogy kifáraszd a halat, tartsd a kurzort a négyzetben!", "info")
                                            chat:sendLocalDoAction("kapása van.")
                                        end, randomTime, 1)
                                        inWater = true
                                        lastClick = getTickCount()
                                        chat:sendLocalMeAction("bedobta a csalit a vízbe.")

                                        playSound("files/water_sound.mp3")
                                    else
                                        outputChatBox(core:getServerPrefix("red-dark", "Horgászat", 3).."Nincs nálad csali!", 255, 255, 255, true)
                                    end
                                end
                            else
                                outputChatBox(core:getServerPrefix("red-dark", "Horgászat", 3).."Ilyen messzire nem dobhatod be a csalit!", 255, 255, 255, true)
                            end
                        end
                    end
                end
            end
        end
    end
end)

local reached = false

local oldCursorPos = {0, 0}

function renderMinigame()
    showCursor(true)

    local cX, cY = getCursorPosition()
    --print(cX, cY)
 
    local rand = math.random(0-cursorMovingNumber/myX*sx, cursorMovingNumber/myX*sx)

    local cpos = {getCursorPosition()}
    oldCursorPos = {cpos[1]*10000, cpos[2]}
    
    setCursorPosition(cX*sx - rand, cY*sy + rand)

    local cpos = {getCursorPosition()}
    newCursorPos = {cpos[1]*10000, cpos[2]}
    --print(toJSON(oldCursorPos), toJSON(newCursorPos))

    local cursorDifference = {math.abs(oldCursorPos[1]-newCursorPos[1]), math.abs(oldCursorPos[2]-newCursorPos[2])}
    local averageDifference = (cursorDifference[1]+cursorDifference[2])/2

    print(averageDifference)

    if (averageDifference > 1) then 
        if core:isInSlot(sx*0.5-(70/myX*sx-(40/myX*sx*minigameValue))/2, sy*0.8-(70/myY*sy-(40/myY*sy*minigameValue))/2, 70/myX*sx-(40/myX*sx*minigameValue), 70/myY*sy-(40/myY*sy*minigameValue)) then 
            minigameValue = minigameValue + 0.005

            if minigameValue > 0.3 then
                reached = true
            end

            if minigameValue >= 1 then 
                endMinigame("success")
            end
        else
            if minigameValue > 0 then 
                minigameValue = minigameValue - 0.002
            end

            if minigameValue <= 0 then 
                if reached then 
                    endMinigame(false)
                end
            end
        end
    end

    if minigameTime > 0 then 
        minigameTime = minigameTime - 0.0007
    else
        endMinigame(false)
    end

    dxDrawRectangle(sx*0.5-(70/myX*sx)/2, sy*0.8-(70/myY*sy)/2, 70/myX*sx, 70/myY*sy, tocolor(35, 35, 35, 255))
    dxDrawRectangle(sx*0.5-(70/myX*sx-(40/myX*sx*minigameValue))/2, sy*0.8-(70/myY*sy-(40/myY*sy*minigameValue))/2, 70/myX*sx-(40/myX*sx*minigameValue), 70/myY*sy-(40/myY*sy*minigameValue), tocolor(40, 40, 40, 255))
    dxDrawRectangle(sx*0.5-200/myX*sx/2, sy*0.845, 200/myX*sx, 10/myY*sy, tocolor(35, 35, 35, 255))
    dxDrawRectangle(sx*0.5-200/myX*sx/2+1.5/myX*sx, sy*0.845+2/myY*sy, 200/myX*sx-4/myX*sx, 10/myY*sy-4/myY*sy, tocolor(40, 40, 40, 255))
    dxDrawRectangle(sx*0.5-200/myX*sx/2+1.5/myX*sx, sy*0.845+2/myY*sy, (200/myX*sx-4/myX*sx)*minigameValue, 10/myY*sy-4/myY*sy, tocolor(r, g, b, 200))

    dxDrawRectangle(sx*0.5-200/myX*sx/2, sy*0.858, 200/myX*sx, 10/myY*sy, tocolor(35, 35, 35, 255))
    dxDrawRectangle(sx*0.5-200/myX*sx/2+1.5/myX*sx, sy*0.858+2/myY*sy, 200/myX*sx-4/myX*sx, 10/myY*sy-4/myY*sy, tocolor(40, 40, 40, 255))
    dxDrawRectangle(sx*0.5-200/myX*sx/2+1.5/myX*sx, sy*0.858+2/myY*sy, (200/myX*sx-4/myX*sx)*minigameTime, 10/myY*sy-4/myY*sy, tocolor(224, 70, 70, 200))
end

function startMinigame()
    inGame = true
    minigameTime = 1
    addEventHandler("onClientRender", root, renderMinigame)
    setCursorPosition(sx*0.5, sy*0.85)
    sound = playSound("files/sound_loop.mp3", true)
end

function endMinigame(type)
    inGame = false
    reached = false 
    minigameValue = 0
    csaliPos = false
    if type == "success" then 
        local randomItem = fishes[math.random(#fishes)]
        local itemWeight = inventory:getItemWeight(randomItem)

        if inventory:getAllItemWeight() + itemWeight <= 20 then 
            infobox:outputInfoBox("Sikeresen kifogtál egy "..inventory:getItemName(randomItem).."-(e)t.", "success")
            outputChatBox(core:getServerPrefix("green-dark", "Horgászat", 2).." Kifogtál egy "..color..inventory:getItemName(randomItem).."#ffffff-(e)t.", 255, 255, 255, true)
            triggerServerEvent("fishing > giveItem", resourceRoot, randomItem)
            chat:sendLocalMeAction("kifogott egy "..inventory:getItemName(randomItem).."-(e)t a vízből.")
        else
            outputChatBox(core:getServerPrefix("red-dark", "Horgászat", 2).."Mivel nincs elég hely az inventorydban így nem kaptál semmit!", 255, 255, 255, true)

            infobox:outputInfoBox("Mivel nincs elég hely az inventorydban így nem kaptál semmit!", "error")
            chat:sendLocalDoAction("nem fogott semmit.")
        end
    else
        outputChatBox(core:getServerPrefix("red-dark", "Horgászat", 2).."A hal elúszott!", 255, 255, 255, true)
        chat:sendLocalDoAction("elúszott az általa fárasztott hal.")
        infobox:outputInfoBox("A hal sajnos elúszott!", "warning")
    end
    removeEventHandler("onClientRender", root, renderMinigame)
    triggerServerEvent("syncRod", resourceRoot, 0, 0, 0, false)
    showCursor(false)
    inWater = false 

    if isElement(sound) then 
        destroyElement(sound)
    end
end

addEventHandler("onClientPlayerWasted", root, function()
    if source == localPlayer then 
        if inWater then 
            endMinigame("unsuccess")
            if isTimer(timer) then killTimer(timer) end
        end
    end
end)

addEvent("checkRod", true)
addEventHandler("checkRod", root, function()
    if inWater then 
        inGame = false
        reached = false 
        minigameValue = 0
        csaliPos = false

        triggerServerEvent("syncRod", resourceRoot, 0, 0, 0, false)
        inWater = false 
        lastClick = getTickCount()

        removeEventHandler("onClientRender", root, renderMinigame)
        showCursor(false)

        if isTimer(timer) then killTimer(timer) end
        return
    end
end)