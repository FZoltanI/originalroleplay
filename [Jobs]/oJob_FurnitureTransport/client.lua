setElementData(localPlayer, "transporter:furnitureInHand", false)

local sx, sy = guiGetScreenSize()
local myX, myY = 1600, 900

local markers = {}

local fonts = {
    ["condensed-12"] = exports.oFont:getFont("condensed", 12),
    ["condensed-15"] = exports.oFont:getFont("condensed", 15),
    ["condensed-20"] = exports.oFont:getFont("condensed", 20),
    ["signature-15"] = exports.oFont:getFont("signature", 15),
    ["desyrel-15"] = exports.oFont:getFont("desyrel", 15),
}

local furnitures = {
    ["from"] = {},
    ["to"] = {},
}

local renderableListDatas = {}

local tooltipText = ""

local interiorExitMarker = false

local startX, startY, startZ = 0, 0, 0
local inInt = false

local firstEnter = true

local handInUse = false

local firstTalk = true

local jobElements = {
    ["ped"] = false,
    ["blip"] = false,
    ["blip2"] = false,
    ["blip2"] = false,
}

local inWork = false

local occupiedInteriorNumber = 0
local occupiedInteriorType = false

local bonusPayment = 0

local imageTextures = {}
_dxDrawImage = dxDrawImage
function dxDrawImage(x, y, w, h, img, ...) 
	if not imageTextures[img] then 
		imageTextures[img] = dxCreateTexture(img, "dxt5")
	end

	_dxDrawImage(x, y, w, h, imageTextures[img], ...)
end


function createJobElements()
    jobElements["ped"] = createPed(183, 2363.4389648438,-2011.4404296875,13.68413066864, 0)
    setElementData(jobElements["ped"], "ped:name", "Jonathan Vega")
    setElementData(jobElements["ped"], "ped:prefix", "Telephely vezető")
    setElementFrozen(jobElements["ped"], true)

    jobElements["blip"] = createBlip(2348.505859375,-2004.7490234375,13.543630599976, 11)
    setElementData(jobElements["blip"], "blip:name", "Költöztető telephely")

    jobElements["vehMarker"], jobElements["blip2"] = exports.oJob:createJobVehicleRequest("Költöztető", 498, {2307.7253417969,-2014.9561767578,13.5436668396}, {{2308.0070800781,-1997.2557373047,13.553890228271, 180}, {2314.09375,-1997.0827636719,13.552530288696, 180}, {2322.3959960938,-1996.5285644531,13.550909042358, 180}}, 15)

    outputChatBox(core:getServerPrefix("server", "Költöztető", 3).."A munka kezdéséhez menj el a költöztető telephelyre, amit a térképen egy"..color.." narancssárga #fffffftáska ikonnal jelöltünk.", 255, 255, 255, true)
    outputChatBox(core:getServerPrefix("server", "Költöztető", 3).."A munka kezdéséhez beszélj a "..color.."telephely vezetőjével #ffffffaki oda adja neked a két címet és a bútorok listáját.", 255, 255, 255, true)
end

addEventHandler("onClientResourceStart", resourceRoot, function()
    if getElementData(localPlayer, "char:job") == 6 then 
        createJobElements()
    end
end)

addEventHandler("onClientElementDataChange", root, function(data, old, new)
    if source == localPlayer then 
        if data == "char:job" then 
            if new == 6 then 
                createJobElements()
            elseif old == 6 then 
                for k, v in pairs(jobElements) do 
                    if isElement(v) then 
                        destroyElement(v)
                    end
                end

                local munkakocsi = getElementData(localPlayer, "jobVeh:ownedJobVeh") or false 
                if munkakocsi then 
                    triggerServerEvent("transporter > destroyJobVeh", resourceRoot)
                end

                endJob()

                for k, v in ipairs(markers) do 
                    if isElement(v) then destroyElement(v) end
                end
            end
        end
    end
end)

addEventHandler("onClientClick", root, function(key, state, _, _, _, _, _, element)
    if key == "right" and state == "up" and element then 
        if element == jobElements["ped"] then 
            if core:getDistance(localPlayer, element) < 3 then 

                if not inWork then 
                    startTalkAnimation()
                    setElementData(localPlayer, "user:hideWeapon", true)
                    if firstTalk then 
                        talkingAnimation("start")
                    else
                        talkingAnimation("normal")
                    end 
                end
            end
        end
    end
end)

function createInteriors()
    renderableListDatas = {}
    local randInt = math.random(#interiorPositions)
    local removed1 = interiorPositions[randInt]

    local marker = customMarker:createCustomMarker(interiorPositions[randInt].x, interiorPositions[randInt].y, interiorPositions[randInt].z, 3, 207, 110, 31, 200, "home")
    table.insert(markers, marker)
    setElementData(marker, "transporter:interiorNumber", math.random(#interiorFurnitures))
    setElementData(marker, "transporter:interiorType", "from")
    local blip = createBlip(interiorPositions[randInt].x, interiorPositions[randInt].y, interiorPositions[randInt].z, 3)
    setElementData(blip, "blip:name", "Kipakolandó ház")
    table.insert(markers, blip)

    --outputChatBox("Ki: "..interiorPositions[randInt].x..","..interiorPositions[randInt].y..",".. interiorPositions[randInt].z)

    for k, v in pairs(interiorFurnitures[getElementData(marker, "transporter:interiorNumber")].furnitures) do 
        table.insert(renderableListDatas, {objectTypes[v.objID], false})
    end

    table.remove(interiorPositions, randInt)

    local randInt = math.random(#interiorPositions)
    local removed2 = interiorPositions[randInt]

    local marker2 = customMarker:createCustomMarker(interiorPositions[randInt].x, interiorPositions[randInt].y, interiorPositions[randInt].z, 3, 207, 66, 31, 200, "home")
    table.insert(markers, marker2)
    setElementData(marker2, "transporter:interiorNumber", math.random(#interiorFurnitures))
    setElementData(marker2, "transporter:interiorType", "to")
    local blip = createBlip(interiorPositions[randInt].x, interiorPositions[randInt].y, interiorPositions[randInt].z, 4)
    setElementData(blip, "blip:name", "Berendezendő ház")
    table.insert(markers, blip)
    --outputChatBox("Be: "..interiorPositions[randInt].x..","..interiorPositions[randInt].y..",".. interiorPositions[randInt].z)


    table.remove(interiorPositions, randInt)


    table.insert(interiorPositions, removed1)
    table.insert(interiorPositions, removed2)

    firstEnter = true
end 

function enterToInterior(_, _, type, number)
    if not getPedOccupiedVehicle(localPlayer) then 
        inInt = true
        startX, startY, startZ = getElementPosition(localPlayer)

        local dim = 9999+getElementData(localPlayer, "playerid")
        setElementDimension(localPlayer, dim)
        setElementInterior(localPlayer, interiorFurnitures[number].int)
        setElementPosition(localPlayer, interiorFurnitures[number].exitPos.x, interiorFurnitures[number].exitPos.y, interiorFurnitures[number].exitPos.z)

        interiorExitMarker = customMarker:createCustomMarker(interiorFurnitures[number].exitPos.x, interiorFurnitures[number].exitPos.y, interiorFurnitures[number].exitPos.z, 3, 50, 145, 168, 200, "home")
        setElementData(interiorExitMarker, "transporter:isInteriorExitMarker", true)
        setElementDimension(interiorExitMarker, dim)   
        setElementInterior(interiorExitMarker, interiorFurnitures[number].int)

        occupiedInteriorNumber = number
        occupiedInteriorType = type
        addEventHandler("onClientRender", root, render3DIcons)

        if type == "from" then 
            if firstEnter then 
                for k, v in ipairs(interiorFurnitures[number].furnitures) do 
                    local obj = createObject(v.objID, v.pos.x, v.pos.y, v.pos.z, 0, 0, v.rot)
                    table.insert(furnitures["from"], obj)

                    setElementDimension(obj, dim)
                    setElementInterior(obj, interiorFurnitures[number].int)

                    setElementData(obj, "transporter:moveableFurniture", true)
                end

                firstEnter = false
            else
                for k, v in ipairs(furnitures[occupiedInteriorType]) do 
                    if isElement(v) then 
                        setElementAlpha(v, 255)
                        setElementCollisionsEnabled(v, true)
                    end
                end
            end
        else
            for k, v in ipairs(furnitures[occupiedInteriorType]) do 
                if isElement(v) then 
                    setElementAlpha(v, 255)
                    setElementCollisionsEnabled(v, true)    
                end
            end
        end

        removeEventHandler("onClientRender", root, interactionRender)
        unbindKey("e", "up", enterToInterior)
    end
end

function quitFromInterior()
    inInt = false
    if isElement(interiorExitMarker) then 
        destroyElement(interiorExitMarker)
    end

    setElementPosition(localPlayer, startX, startY, startZ)
    setElementInterior(localPlayer, 0)
    setElementDimension(localPlayer, 0)

    removeEventHandler("onClientRender", root, interactionRender)
    unbindKey("e", "up", quitFromInterior)

    for k, v in ipairs(furnitures[occupiedInteriorType]) do 
        if isElement(v) then 
            setElementAlpha(v, 0)
            setElementCollisionsEnabled(v, false)
        end
    end

    removeEventHandler("onClientRender", root, render3DIcons)
    occupiedInteriorNumber = 0
    occupiedInteriorType = false
end

local lastClickInteraction = 0
addEventHandler("onClientClick", root, function(key, state, absX, absY, wX, wY, wZ, element)
    if key == "right" and state == "up" then 
        if element then 
            if getElementData(element, "transporter:moveableFurniture") then 
                if core:getDistance(element, localPlayer) < 3 then 
                    if not handInUse then 
                        if lastClickInteraction + 1000 < getTickCount() then  
                            lastClickInteraction = getTickCount()
                            triggerServerEvent("transporter > createFurnitureObjectOnServer", resourceRoot, getElementModel(element))

                            for k, v in ipairs(furnitures[occupiedInteriorType]) do 
                                if v == element then 
                                    table.remove(furnitures[occupiedInteriorType], k)
                                    break
                                end
                            end
                            destroyElement(element)

                            for k, v in pairs(carryToggleControlls) do 
                                toggleControl(v, false)
                            end

                            handInUse = true 
                            exports.oChat:sendLocalMeAction("felvesz egy bútort.")
                        end
                    else
                        outputChatBox(core:getServerPrefix("red-dark", "Költöztető", 3).."Már van bútor a kezedben!", 255, 255, 255, true)
                    end
                end
            end
        end
    end

    if key == "left" and state == "up" then 
        local furnitureInHand = getElementData(localPlayer, "transporter:furnitureInHand")
        if furnitureInHand then 
            if occupiedInteriorNumber > 0 and occupiedInteriorType then 
                local playerpos = Vector3(getElementPosition(localPlayer))
                if getDistanceBetweenPoints3D(wX, wY, wZ, playerpos.x, playerpos.y, playerpos.z) < 4 then 
                    if lastClickInteraction + 1000 < getTickCount() then 

                        for k, v in pairs(furnitures[occupiedInteriorType]) do 
                            if getElementAlpha(v) >= 200 then 
                                local objPos = Vector3(getElementPosition(v))
                                if getDistanceBetweenPoints3D(wX, wY, wZ, objPos.x, objPos.y, objPos.z) <= 1.5 then 
                                    outputChatBox(core:getServerPrefix("red-dark", "Költözető", 3).."Már van a közelben bútor!", 255, 255, 255, true)
                                    return
                                end
                            end
                        end

                        lastClickInteraction = getTickCount()
                        handInUse = false

                        local model = getElementModel(furnitureInHand)
                        local type = objectTypes[model]
                        triggerServerEvent("transporter > putDownObject", resourceRoot, furnitureInHand)

                        local newObj = createObject(model, wX, wY, getGroundPosition (wX, wY, wZ))
                        setElementPosition(newObj, wX, wY, getGroundPosition (getElementPosition(localPlayer)))

                        setElementRotation(newObj, getElementRotation(localPlayer))

                        setElementDimension(newObj, getElementDimension(localPlayer))
                        setElementInterior(newObj, getElementInterior(localPlayer))
                        table.insert(furnitures[occupiedInteriorType], newObj)

                        exports.oChat:sendLocalMeAction("lerak egy bútort.")

                        for k, v in pairs(carryToggleControlls) do 
                            toggleControl(v, true)
                        end

                        if occupiedInteriorType == "from" then 
                            setElementData(newObj, "transporter:moveableFurniture", true)
                        elseif occupiedInteriorType == "to" then 
                            for k, v in pairs(renderableListDatas) do 
                                if v[1] == type then 
                                    if not v[2] then 
                                        renderableListDatas[k][2] = getTickCount()
                                        playSound("files/write.mp3")
                                        break
                                    end
                                end
                            end

                            local payment = math.random(320, 440)
                            local bonus = math.random(30, 50)

                            payment = math.floor(payment * 1.2)

                            if exports.oJob:isJobHasDoublePaymant(6) then 
                                payment = payment * 2
                                bonus = bonus * 2
                            end

                            bonusPayment = bonusPayment + bonus

                            outputChatBox(core:getServerPrefix("server", "Költöztető", 2).."Mivel áthoztál egy bútort így kaptál: "..color..payment.."#ffffff$-t.", 255, 255, 255, true)
                            triggerServerEvent("transporter > givePlayerPayment", resourceRoot, payment)

                            local otherNeededFurnitures = 0 

                            for k, v in pairs(renderableListDatas) do 
                                if not v[2] then 
                                    otherNeededFurnitures = otherNeededFurnitures + 1
                                end
                            end

                            if otherNeededFurnitures <= 0 then
                                triggerServerEvent("transporter > givePlayerPayment", resourceRoot, bonusPayment)
                                outputChatBox(core:getServerPrefix("green-dark", "Költöztető", 2).."Ezzel a házzal végeztél. További fizetésed a telephely vezetőtől: "..color..bonusPayment.."#ffffff$.", 255, 255, 255, true)
                                outputChatBox(core:getServerPrefix("green-dark", "Költöztető", 2).."Ha folytatni szeretnéd a munkát, akkor menj vissza a telepre és beszélj újra a telephely vezetővel, ha pedig nem szeretnéd folytatni, akkor add le a munkajárműved.", 255, 255, 255, true)
                                bonusPayment = 0
                                inWork = false
                                endJob()

                                for k, v in pairs(markers) do 
                                    destroyElement(v)
                                end
                            
                                if isElement(interiorExitMarker) then 
                                    destroyElement(interiorExitMarker)
                                end
                            
                                if inInt then 
                                    setElementPosition(localPlayer, startX, startY, startZ)
                                    setElementInterior(localPlayer, 0)
                                    setElementDimension(localPlayer, 0)
                                end

                                inInt = false

                                removeEventHandler("onClientRender", root, render3DIcons)
                                occupiedInteriorNumber = 0
                                occupiedInteriorType = false    
                            end
                        end
                    end
                else
                    outputChatBox(core:getServerPrefix("red-dark", "Költözető", 3).."Ilyen messzire nem teheted le a bútort!", 255, 255, 255, true)
                end
            else
                --outputChatBox(core:getServerPrefix("red-dark", "Költözető", 3).."Csak interiorban teheted le!", 255, 255, 255, true)
            end
        end     
    end
end)

addEventHandler("onClientMarkerHit", root, function(player, mdim)
    if player == localPlayer then 
        if mdim then 
            if isElement(source) then 
                if getElementData(source, "transporter:interiorType") then
                    tooltipText = "A belépéshez"
                    addEventHandler("onClientRender", root, interactionRender)
                    bindKey("e", "up", enterToInterior, getElementData(source, "transporter:interiorType"), getElementData(source, "transporter:interiorNumber"))
                elseif getElementData(source, "transporter:isInteriorExitMarker") then 
                    tooltipText = "A kilépéshez"
                    addEventHandler("onClientRender", root, interactionRender)
                    bindKey("e", "up", quitFromInterior)

                end
            end
        end
    end
end)

addEventHandler("onClientMarkerLeave", root, function(player, mdim)
    if player == localPlayer then 
        if mdim then 
            if getElementData(source, "transporter:interiorType") then
                removeEventHandler("onClientRender", root, interactionRender)
                unbindKey("e", "up", enterToInterior)
            elseif getElementData(source, "transporter:isInteriorExitMarker") then 
                removeEventHandler("onClientRender", root, interactionRender)
                unbindKey("e", "up", quitFromInterior)

            end
        end
    end
end)

function renderVehiclePickup() 
    local munkakocsi = getElementData(localPlayer, "jobVeh:ownedJobVeh") or false 
    if munkakocsi then 
        if core:isInSlot(sx*0.4, sy*0.47, sx*0.2, sy*0.05) then 
            shadowedText("Munkajármű leadása", 0, 0, sx, sy, 201, 73, 68, 255, 1/myX*sx, fonts["condensed-20"], "center", "center")
        else
            shadowedText("Munkajármű leadása", 0, 0, sx, sy, 220, 220, 220, 255, 1/myX*sx, fonts["condensed-20"], "center", "center")
        end
    else
        if core:isInSlot(sx*0.4, sy*0.47, sx*0.2, sy*0.05) then 
            shadowedText("Munkajármű felvétel", 0, 0, sx, sy, 74, 145, 86, 255, 1/myX*sx, fonts["condensed-20"], "center", "center")
        else
            shadowedText("Munkajármű felvétel", 0, 0, sx, sy, 220, 220, 220, 255, 1/myX*sx, fonts["condensed-20"], "center", "center")
        end
    end
end

function keyVehiclePickup(key, state)
    if key == "mouse1" and state then 
        local munkakocsi = getElementData(localPlayer, "jobVeh:ownedJobVeh") or false 
        if core:isInSlot(sx*0.4, sy*0.47, sx*0.2, sy*0.05) then
            if munkakocsi then 
                if not inWork then 
                    triggerServerEvent("transporter > destroyJobVeh", resourceRoot)
                else
                    infobox:outputInfoBox("Mielőtt le adod a munkajárműved, fejezd be a munkát!", "error")
                end
            else
                triggerServerEvent("transporter > makeJobVeh", resourceRoot)
            end
            removeEventHandler("onClientRender", root, renderVehiclePickup)
            removeEventHandler("onClientKey", root, keyVehiclePickup)
        end
    end
end

addEventHandler("onClientResourceStop", resourceRoot, function()
    for k, v in pairs(markers) do 
        if isElement(v) then 
            destroyElement(v)
        end
    end

    for k, v in pairs(jobElements) do 
        if isElement(V) then 
            destroyElement(v)
        end
    end

    if isElement(interiorExitMarker) then 
        destroyElement(interiorExitMarker)
    end

    if inInt then 
        setElementPosition(localPlayer, startX, startY, startZ)
        setElementInterior(localPlayer, 0)
        setElementDimension(localPlayer, 0)
    end
end)

function interactionRender()
    core:dxDrawShadowedText(tooltipText.." nyomd meg az "..color.."[E] #ffffffgombot.", 0, sy*0.89, sx, sy*0.89+sy*0.05, tocolor(255, 255, 255, 255), tocolor(0, 0, 0, 255), 0.9/myX*sx, fonts["condensed-12"], "center", "center", false, false, false, true)
end

local icons = {
    ["table"] = dxCreateTexture("files/table.png"),
    ["chair"] = dxCreateTexture("files/chair.png"),
    ["couch"] = dxCreateTexture("files/couch.png"),
    ["wash"] = dxCreateTexture("files/wash.png"),

    ["box"] = dxCreateTexture("files/box.png"),
}

local animTime = getTickCount()
function render3DIcons()

    if occupiedInteriorNumber > 0 then 
        for k, v in pairs(getElementsByType("object", root, true)) do 
            if getElementData(v, "transporter:moveableFurniture") then 
                if getElementAlpha(v) > 250 then 
                    local mX, mY, mZ = getElementPosition(v)
                    local mR, mG, mB = 200, 0, 150
                    mZ = mZ + 0.01

                    local pX, pY, pZ = getElementPosition(localPlayer)

                    if getDistanceBetweenPoints3D(mX, mY, mZ, pX, pY, pZ) < 60 then 
                        local position = 150

                        local iconColor = {255, 255, 255}

                        dxDrawMaterialLine3D(mX, mY, mZ+0.9+0.5+(position/2500),mX, mY, mZ+0.9+(position/2500), icons[(objectTypes[getElementModel(v)] or "box")], 0.5, tocolor(iconColor[1], iconColor[2], iconColor[3], 200))
                    end
                end
            end
        end
    end

end 

local lastKeyInteraction = 0
function checkNearestVehicle()
    local nearestVeh = exports.oVehicle:getNearestVehicle(localPlayer, 5)

    if nearestVeh then
        if getElementModel(nearestVeh) == 498 then  
            if getElementData(nearestVeh, "isJobVeh") then 
                if getElementData(nearestVeh, "jobVeh:owner") == localPlayer then 
                    local door = Vector3(core:getPositionFromElementOffset(nearestVeh, -0.8, -3, 0))
                    local playerPos = Vector3(getElementPosition(localPlayer))

                    --dxDrawLine3D(door.x, door.y, -10, door.x, door.y, 100, tocolor(200, 0, 0, 100), 3)

                    local dis = getDistanceBetweenPoints3D(door.x, door.y, door.z, playerPos.x, playerPos.y, playerPos.z)
                    --print(dis)
                    
                    if dis < 1.5 then 
                        local door1, door2 = getVehicleDoorOpenRatio(nearestVeh, 4), getVehicleDoorOpenRatio(nearestVeh, 5)

                        if (door1 == 1 and door2 == 1) then
                            if lastKeyInteraction + 5000 < getTickCount() then 

                                local rendX, rendY = getScreenFromWorldPosition(door.x, door.y, door.z)

                                if not rendX or not rendY then return end

                                if core:isInSlot(rendX, rendY-55/myY*sy, 50/myX*sx, 50/myY*sy) then 
                                    dxDrawImage(rendX, rendY-55/myY*sy, 50/myX*sx, 50/myY*sy, "files/in.png", 0, 0, 0, tocolor(r, g, b, 200))
                                else
                                    dxDrawImage(rendX, rendY-55/myY*sy, 50/myX*sx, 50/myY*sy, "files/in.png", 0, 0, 0, tocolor(255, 255, 255, 200))
                                end

                                if core:isInSlot(rendX, rendY, 50/myX*sx, 50/myY*sy) then 
                                    dxDrawImage(rendX, rendY, 50/myX*sx, 50/myY*sy, "files/out.png", 0, 0, 0, tocolor(r, g, b, 200))
                                else
                                    dxDrawImage(rendX, rendY, 50/myX*sx, 50/myY*sy, "files/out.png", 0, 0, 0, tocolor(255, 255, 255, 200))
                                end

                                --dxDrawRectangle(rendX-25/myX*sx, rendY+50/myY*sy, 100/myX*sx, 25/myY*sy)
                                core:dxDrawShadowedText("Bútorok: "..color..#(getElementData(nearestVeh, "transporter:furnitures") or {}).."#ffffffdb", rendX-25/myX*sx, rendY+60/myY*sy, rendX-25/myX*sx+100/myX*sx, rendY+60/myY*sy+25/myY*sy, tocolor(255, 255, 255, 200), tocolor(0, 0, 0, 200), 1/myX*sx, fonts["condensed-12"], "center", "center", false, false, false, true)
                                --tooltipText = "A bútor berakásához"
                                --interactionRender() 

                                if getKeyState("mouse1") then
                                    if isCursorShowing() then 
                                        if core:isInSlot(rendX, rendY-55/myY*sy, 50/myX*sx, 50/myY*sy) then 
                                            if handInUse then 
                                                lastKeyInteraction = getTickCount()
                                                --removeEventHandler("onClientRender", root, checkNearestVehicle)
                                                local obj = getElementData(localPlayer, "transporter:furnitureInHand")
                                                local objModel = getElementModel(obj)

                                                local furnitures = getElementData(nearestVeh, "transporter:furnitures") or {}

                                                local attachX, attachY, attachZ, attachRotX, attachRotY, attachRotZ = unpack(attachmentPositionsVehicle[objModel])

                                                local length = 0

                                                local objCount = 0
                                                local tableAdd = false
                                                local chairMinus = false

                                                for k, v in ipairs(furnitures) do 
                                                    local model = getElementModel(v)

                                                    if model == objModel then 
                                                        objCount = objCount + 1
                                                    end
                                                end

                                                for k, v in spairs(furnitures, function(t,a,b) return getElementModel(t[b]) < getElementModel(t[a]) end) do 
                                                    if isElement(v) then 
                                                        local model = getElementModel(v)

                                                        if objectTypes[model] == "chair" then 
                                                            if objectTypes[objModel] == "chair" then 
                                                                if objCount > 1 then 
                                                                    --print("2")
                                                                    if objCount % 2 == 0 then 
                                                                        if not chairMinus then 
                                                                            attachY = attachY - objectSizes[model][2]

                                                                            length = length + objectSizes[model][2]
                                                                        end
                                                                        chairMinus = false
                                                                    end
                                                                else
                                                                    --print("1")
                                                                    if not (objectTypes[objModel] == "chair") then 
                                                                        if objCount == 0 then 
                                                                            if not chairMinus then 
                                                                                attachY = attachY - objectSizes[model][2]
                                                                                length = length + objectSizes[model][2]

                                                                                chairMinus = true
                                                                            end
                                                                        end            
                                                                    end
                                                                end
                                                            elseif objectTypes[objModel] == "table" or objectTypes[objModel] == "couch" or objectTypes[objModel] == "wash" then 
                                                                if objCount == 0 then 
                                                                    if not chairMinus then 
                                                                        attachY = attachY - objectSizes[model][2]
                                                                        length = length + objectSizes[model][2]

                                                                        chairMinus = true
                                                                    end
                                                                end
                                                            end
                                                        elseif objectTypes[model] == "table" or objectTypes[model] == "wash" then
                                                            if (objectTypes[objModel] == "couch") or (objectTypes[objModel] == "wash") then 
                                                                if not tableAdd then 
                                                                    if objCount == 0 then 
                                                                        attachY = attachY - objectSizes[model][2]
                                                                        length = length + objectSizes[model][2]

                                                                        tableAdd = true
                                                                    end
                                                                end
                                                            elseif (objectTypes[objModel] == "chair") then 
                                                                --outputChatBox(objCount % 2)

                                                                if (objCount % 2) == 0 then 
                                                                    attachY = attachY - objectSizes[model][2]
                                                                    length = length + objectSizes[model][2]
                                                                end
                                                            end
                                                        elseif objectTypes[model] == "couch" then 
                                                            if (objectTypes[objModel] == "couch") then 
                                                                attachY = attachY - objectSizes[model][2]
                                                                length = length + objectSizes[model][2]
                                                            elseif objectTypes[objModel] == "chair" or objectTypes[objModel] == "wash" then 
                                                                --if objCount > 1 then 
                                                                    --if k > 1 then 
                                                                        --if objCount % 2 == 0 then 
                                                                            attachY = attachY - objectSizes[model][2]
                                                                            length = length + objectSizes[model][2]
                                                                        --end
                                                                    --end
                                                                --else
                                                                    --attachY = attachY - objectSizes[model][2]
                                                                    --length = length + objectSizes[model][2]
                                                                --end
                                                            elseif objectTypes[objModel] == "table" then 
                                                                if objCount == 0 then 
                                                                    if not chairMinus then 
                                                                        attachY = attachY - objectSizes[model][2]
                                                                        length = length + objectSizes[model][2]

                                                                        chairMinus = true
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end

                                                local alpha = 255
                                                if (objCount+1) > 1 then 
                                                    alpha = 0
                                                end

                                                if not (objCount % 2 == 0) then 
                                                    if objectTypes[objModel] == "chair" then 
                                                        attachRotY = 180
                                                        attachRotZ = 180 
                                                        attachZ = attachZ + objectSizes[objModel][3]
                                                    end 
                                                end

                                                if objCount >= 1 then 
                                                    if objectTypes[objModel] == "table" or objectTypes[objModel] == "wash" then 
                                                        attachZ = attachZ + objectSizes[objModel][3]*(objCount)
                                                    end
                                                end

                                                local height = 0 

                                                if objectTypes[objModel] == "couch" then 
                                                    height = (objCount+1)*math.abs(objectSizes[objModel][3])
                                                end

                                                length = length + objectSizes[objModel][2]

                                               -- print("Y: "..length, "Z: ".. height)

                                                if height <= 1.8 then -- magasság check
                                                    if length <= 3.3 then 
                                                        handInUse = false
                                                        triggerServerEvent("transporter > putFurnitureToTheCar", resourceRoot, nearestVeh, {attachX, attachY, attachZ, attachRotX, attachRotY, attachRotZ}, alpha)
                                                        exports.oChat:sendLocalMeAction("berak egy bútort az autóba.")
                                 
                                                        for k, v in pairs(carryToggleControlls) do 
                                                            toggleControl(v, true)
                                                        end
                                                    else
                                                        outputChatBox(core:getServerPrefix("red-dark", "Költöztető", 3).."Nincs több hely ennek a bútornak az autóban! (Hosszúság)", 255, 255, 255, true)
                                                    end
                                                else
                                                    outputChatBox(core:getServerPrefix("red-dark", "Költöztető", 3).."Nincs több hely ennek a bútornak az autóban! (Magasság)", 255, 255, 255, true)
                                                end
                                            end
                                        elseif core:isInSlot(rendX, rendY, 50/myX*sx, 50/myY*sy) then 
                                            if not handInUse then 
                                                local furnitures = getElementData(nearestVeh, "transporter:furnitures") or {}

                                                if #furnitures > 0 then 
                                                    handInUse = true 
                                                    exports.oChat:sendLocalMeAction("kivesz egy bútort az autóból.")

                                                    outputChatBox(core:getServerPrefix("server", "Költöztető", 3).."A bútor lerakásához kattints "..color.."[Bal klikkel] #ffffffa földre a lakáson belül.", 255, 255, 255, true)

                                                    triggerServerEvent("transporter > putFurnitureFromCarToHand", resourceRoot, nearestVeh, furnitures[#furnitures])
                                                    lastKeyInteraction = getTickCount()

                                                    
                                                    for k, v in pairs(carryToggleControlls) do 
                                                        toggleControl(v, false)
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

local clipboard = {sx*0.83, sy*0.3}
local click = {0, 0}
local clipboardInMove = false
function renderClipboard()
    dxDrawImage(clipboard[1], clipboard[2], 270/myX*sx, 361.2/myY*sy, "files/clipboard.png")
    
    dxDrawText("Jonathan Vega", clipboard[1]+sx*0.105, clipboard[2]+sy*0.32, clipboard[1]+sx*0.105+sx*0.05, clipboard[2]+sy*0.32+sy*0.03, tocolor(52, 158, 235), 0.8/myX*sx, fonts["signature-15"], "center", "center")
    dxDrawText("Telephely vezető", clipboard[1]+sx*0.105, clipboard[2]+sy*0.35, clipboard[1]+sx*0.105+sx*0.05, clipboard[2]+sy*0.35+sy*0.02, tocolor(52, 158, 235), 0.5/myX*sx, fonts["condensed-12"], "center", "center")

    local startY = clipboard[2] + sy*0.08

    for k, v in ipairs(renderableListDatas) do 
        dxDrawText((objectNames[v[1]] or "Ismeretlen bútor"), clipboard[1]+sx*0.035, startY, clipboard[1]+sx*0.035+sx*0.1, startY+sy*0.02, tocolor(52, 158, 235), 0.7/myX*sx, fonts["desyrel-15"], "left", "center")

        if v[2] then
            local width = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount() - v[2])/750, "Linear")
            
            dxDrawLine(clipboard[1]+sx*0.035, startY+sy*0.01, clipboard[1]+sx*0.035+dxGetTextWidth((objectNames[v[1]] or "Ismeretlen bútor"),  0.7/myX*sx, fonts["desyrel-15"])*width, startY+sy*0.01, tocolor(52, 158, 235), 2)
        end
        startY = startY + sy*0.022
    end

    if clipboardInMove then 
        if isCursorShowing() then 

            if (clipboard[1]+270/myX*sx) >= 270/myX*sx then 
                local keyX, keyY = getCursorPosition()
                keyX = keyX - click[1]
                keyY = keyY - click[2]

                if keyX*sx > 0 and keyY*sy > 0 then 
                    if sx*keyX + 270/myX*sx < sx then 
                        if sy*keyY + 361.2/myY*sy < sy then 
                            clipboard = {sx*keyX, sy*keyY}
                        end
                    end
                end
            end
        end
    end
end

function clipboardKey(key, state)
    if key == "mouse1" then 
        if state then 
            if core:isInSlot(clipboard[1], clipboard[2], 270/myX*sx, 361.2/myY*sy) then 
                click = {getCursorPosition()}
                click[1] = click[1] - clipboard[1]/sx
                click[2] = click[2] - clipboard[2]/sy

                clipboardInMove = true 
            end
        else
            clipboardInMove = false
        end
    end
end

function startJob()
    addEventHandler("onClientKey", root, clipboardKey)
    addEventHandler("onClientRender", root, renderClipboard)
    addEventHandler("onClientRender", root, checkNearestVehicle)

    inWork = true 
    createInteriors()
   -- setElementData(localPlayer, "user:hideWeapon", false)
    outputChatBox(core:getServerPrefix("server", "Költöztető", 3).."A térképen a kipakolandó házat egy #e34242piros #ffffff6 szög ikonnal jelöltünk.", 255, 255, 255, true)
    outputChatBox(core:getServerPrefix("server", "Költöztető", 3).."A berendezendő házat pedig egy #459cedkék #ffffff6 szög ikonnal.", 255, 255, 255, true)
    outputChatBox(core:getServerPrefix("server", "Költöztető", 3).."A bútorokat hord át a kipakolandó házból a berendezendőbe! Minden bútor után, illetve a munka végén is kapsz fizetést.", 255, 255, 255, true)
end

function endJob()
    removeEventHandler("onClientKey", root, clipboardKey)
    removeEventHandler("onClientRender", root, renderClipboard)
    removeEventHandler("onClientRender", root, checkNearestVehicle)
   -- setElementData(localPlayer, "user:hideWeapon", false)
    inWork = false 
end

-- / Talk / --
local animation_tick = getTickCount()
local animation_state = "open"
local talk_text = {"nan", 1}
local inTalk = false

local pC1x, pC1y, pC1z, pC2x, pC2y, pC2z
function renderTalkPanel()
    local alpha 
    
    if animation_state == "open" then 
        alpha = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount() - animation_tick)/1000, "Linear")
    else
        alpha = interpolateBetween(1, 0, 0, 0, 0, 0, (getTickCount() - animation_tick)/1000, "Linear")
    end

    dxDrawRectangle(0, sy*0.9, sx*0.5*alpha, sy*0.1, tocolor(30, 30, 30, 255*alpha))
    dxDrawRectangle(sx-sx*0.5*alpha, sy*0.9, sx/2, sy*0.1, tocolor(30, 30, 30, 255*alpha))

    if talk_text then 
        dxDrawText(color.."[Jonathan]: #dcdcdc"..texts[talk_text[1]][talk_text[2]], 0, sy*0.9, sx, sy, tocolor(220, 220, 220, 255*alpha), 1/myX*sx, fonts["condensed-15"], "center", "center", false, false, false, true)
    end
end

function startTalkAnimation() 
    setElementAlpha(localPlayer, 0)
    pC1x, pC1y, pC1z, pC2x, pC2y, pC2z = getCameraMatrix()

    local bossPedPos = Vector3(getElementPosition(jobElements["ped"]))

    smoothMoveCamera(pC1x, pC1y, pC1z, pC2x, pC2y, pC2z, bossPedPos.x, bossPedPos.y+3, bossPedPos.z+0.6, bossPedPos.x, bossPedPos.y, bossPedPos.z+0.6, 1000)

    animation_state = "open"
    animation_tick = getTickCount() 
    addEventHandler("onClientRender", root, renderTalkPanel)

    setElementFrozen(localPlayer, true)

    showChat(false)
    exports.oInterface:toggleHud(true)

    inTalk = true

    setTimer(function() 
        bindKey("backspace", "up", stopTalkAnimation) 
    end, 1000, 1)
end

function stopTalkAnimation()
    setElementAlpha(localPlayer, 255)
    local bossPedPos = Vector3(getElementPosition(jobElements["ped"]))

    smoothMoveCamera(bossPedPos.x, bossPedPos.y-3, bossPedPos.z+0.6, bossPedPos.x, bossPedPos.y, bossPedPos.z+0.6, pC1x, pC1y, pC1z, pC2x, pC2y, pC2z, 1000)

    animation_state = "close"
    animation_tick = getTickCount() 

    showChat(true)
    setPedAnimation(jobElements["ped"])
    exports.oInterface:toggleHud(false)
    unbindKey("backspace", "up", stopTalkAnimation)

    setElementFrozen(localPlayer, false)

    killTalkingTimers() 

    inTalk = false

    setTimer(function() 
        setElementData(localPlayer, "user:hideWeapon", false)
        setCameraTarget(localPlayer, localPlayer) 
        inAnimation = false  
        removeEventHandler("onClientRender", root, renderTalkPanel) 
        talk_text = false 
        talking_timers = {}
    end, 1000, 1)
end

function killTalkingTimers()
    for k, v in ipairs(talking_timers) do 
        if isTimer(v) then 
            killTimer(v)
        end
    end

    talking_timers = {}
end

function talkingAnimation(text_group)
    talking_timers = {}
    local timer_time = 0

    setPedAnimation(jobElements["ped"], "GHANDS", "gsign5", -1, true, false, false, false)
    for k, v in ipairs(texts[text_group]) do 
        timer_time = timer_time + string.len(v)*text_wait

        if k == 1 then 
            talk_text = {text_group, 1}
        elseif k == #texts[text_group] then 
            local timer = setTimer(function() 
                talk_text[2] = talk_text[2] + 1

                setTimer(function() 
                    talk_text = false 
                    setPedAnimation(jobElements["ped"])

                    firstTalk = false

                    stopTalkAnimation()
                    startJob()
                    inWork = true

                end, string.len(v)*text_wait, 1)
            end, timer_time,1)

            table.insert(talking_timers, #talking_timers+1, timer)
        else
            local timer = setTimer(function() 
                talk_text[2] = talk_text[2] + 1
            end, timer_time,1)

            table.insert(talking_timers, #talking_timers+1, timer)
        end
    end
end
---------


-----SmoothCamera
local sm = {}
sm.moov = 0
sm.object1,sm.object2 = nil,nil
 
local function removeCamHandler()
	if(sm.moov == 1)then
		sm.moov = 0
	end
end
 
local function camRender()
	if (sm.moov == 1) then
		local x1,y1,z1 = getElementPosition(sm.object1)
		local x2,y2,z2 = getElementPosition(sm.object2)
		setCameraMatrix(x1,y1,z1,x2,y2,z2)
	else
		removeEventHandler("onClientPreRender",root,camRender)
	end
end

function smoothMoveCamera(x1,y1,z1,x1t,y1t,z1t,x2,y2,z2,x2t,y2t,z2t,time)
	if(sm.moov == 1)then
		destroyElement(sm.object1)
		destroyElement(sm.object2)
		killTimer(timer1)
		killTimer(timer2)
		killTimer(timer3)
		removeEventHandler("onClientPreRender",root,camRender)
	end
	sm.object1 = createObject(1337,x1,y1,z1)
	sm.object2 = createObject(1337,x1t,y1t,z1t)
        setElementCollisionsEnabled (sm.object1,false) 
	setElementCollisionsEnabled (sm.object2,false) 
	setElementAlpha(sm.object1,0)
	setElementAlpha(sm.object2,0)
	setObjectScale(sm.object1,0.01)
	setObjectScale(sm.object2,0.01)
	moveObject(sm.object1,time,x2,y2,z2,0,0,0,"InOutQuad")
	moveObject(sm.object2,time,x2t,y2t,z2t,0,0,0,"InOutQuad")
	sm.moov = 1
	timer1 = setTimer(removeCamHandler,time,1)
	timer2 = setTimer(destroyElement,time,1,sm.object1)
	timer3 = setTimer(destroyElement,time,1,sm.object2)
	addEventHandler("onClientPreRender",root,camRender)
	return true
end

function shadowedText(text,x,y,x2,y2,r,g,b,a,size,font,align1,align2) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x+1,y+1,x2+1,y2+1,tocolor(0,0,0,a),size,font,align1,align2,false,false,false,false)
    dxDrawText(text,x,y,x2,y2,tocolor(r,g,b,a),size,font,align1,align2,false,false,false,true)
end
