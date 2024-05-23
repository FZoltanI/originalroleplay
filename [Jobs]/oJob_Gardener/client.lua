exports.oCompiler:loadCompliedModel(10833, "&NU3T&3xBrhtM&aw", ":oJob_Gardener/files/csapdff.originalmodel", ":oJob_Gardener/files/csaptxd.originalmodel", ":oJob_Gardener/files/csapcol.originalmodel")

local createdJobElements = {}

local shader = dxCreateShader("files/graphics.fx",0,50,false)
local texture = dxCreateTexture("files/transparent.png")
local toggleHide = false
local boatFixer = dxCreateShader("files/graphics.fx",0,0,false,"vehicle")
dxSetShaderValue(boatFixer, "TEXTURE", texture)

function fixBoat(v)
	engineApplyShaderToWorldTexture(boatFixer, "*", v)
	for _, tex in ipairs(engineGetModelTextureNames(getElementModel(v))) do
		engineRemoveShaderFromWorldTexture(boatFixer, tex, v)
	end
end

function hidePlayerShad()
	if shader and isElement(shader) and texture then
		dxSetShaderValue(shader, "TEXTURE", texture)
		engineApplyShaderToWorldTexture(shader, "shad_ped")
		engineApplyShaderToWorldTexture(shader, "andydark")
		engineApplyShaderToWorldTexture(shader, "black256")
		engineApplyShaderToWorldTexture(shader, "gun_sign_txta")
		engineApplyShaderToWorldTexture(shader, "gun_guns*")
	end
	
	for k,v in ipairs(getElementsByType("vehicle", root, true)) do
		if getVehicleType(v) == "Boat" and getElementModel(v) == 473 then
			fixBoat(v)
		end
	end
	
	toggleHide = true
end
addEventHandler("onClientResourceStart", resourceRoot, hidePlayerShad)

addEventHandler("onClientElementStreamIn", root, function()
	if getElementType(source) == "vehicle" then
		if getVehicleType(source) == "Boat" and getElementModel(source) == 473 then
			fixBoat(source)
		end
	end
end)


function createJobElements()
    for k, v in ipairs(jobMarkers) do 
        if v[1] == "mower" then
            createdJobElements[1], createdJobElements[2] = exports.oJob:createJobVehicleRequest("Kertész", 572, {v[2], v[3], v[4]}, {{993.4970703125,-1364.6394042969,13.349300384521, 270}, {993.89306640625,-1356.5007324219,13.346591949463, 270}, {993.21466064453,-1339.8422851562,13.3828125, 270}}, 25)
        elseif v[1] == "ped" then 
            createdJobElements[3] = createPed(210, v[2], v[3], v[4], v[5])
            createdJobElements[4] = createBlip(v[2], v[3], v[4], 11)
            setElementData(createdJobElements[4], "blip:name", "Kertészet vezető")
            setElementFrozen(createdJobElements[3], true)
            setElementData(createdJobElements[3], "ped:name", "Marco")
            setElementData(createdJobElements[3], "ped:prefix", "Kertészet vezető")
        end
    end
end 

function destroyJobElements()
    for k, v in pairs(createdJobElements) do 
        if isElement(v) then 
            destroyElement(v)
        end
    end
end

function outputJobTips() 
    outputChatBox(core:getServerPrefix("server", "Kertész", 3).."Kezdéséhez menj el a munkahelyedet jelző blipphez, amit a térképen egy"..color.." narancssárga #fffffftáska ikonnal jelöltünk.", 255, 255, 255, true)
    outputChatBox(core:getServerPrefix("server", "Kertész", 3).."A munka kezdéséhez beszélj a "..color.."munkáltatóddal #ffffffaki oda adja neked a kert címét.", 255, 255, 255, true)
    outputChatBox(core:getServerPrefix("server", "Kertész", 3).."Vedd fel a munkajárműved majd hajts a térképen kijelölt kerthez. ", 255, 255, 255, true)
    outputChatBox(core:getServerPrefix("server", "Kertész", 3).."A megjelölt füveket vágd el, a virágokat pedig locsold meg!", 255, 255, 255, true)
end

addEventHandler("onClientResourceStart", resourceRoot, function()
    if getElementData(localPlayer, "char:job") == 7 then 
        outputJobTips()
        createJobElements()
    end
end)

addEventHandler("onClientElementDataChange", root, function(data, old, new)
    if source == localPlayer then 
        if data == "char:job" then 
            if new == 7 then 
                outputJobTips()
                createJobElements()
            end

            if old == 7 then 
                destroyJobElements()
                destroyAllCreatedJobElement()
                inWork = false
                isFirstTalk = true
            end
        end
    end
end)

local tapStartPos
local createdObjects = {}
local workCol = false
local randGarden = false

local inTalk, inWork, isFirstTalk = false, false, true

local flowerObjects = {869}

function createRandomGarden()
    createdObjects = {}
    randGarden = math.random(#gardenObjects)
    inWork = true
    for k, v in ipairs(gardenObjects[randGarden]["grass"]) do
        local col = createColSphere(v[1], v[2], v[3], 4)

        local obj = createObject(826, v[1], v[2], v[3]-1.5)

        setElementData(col, "gardener:grassHP", 100)
        setElementData(col, "gardener:obj", obj)
        setElementData(col, "gardener:blip", blip)

        table.insert(createdObjects, col)
        table.insert(createdObjects, obj)
    end

    for k, v in ipairs(gardenObjects[randGarden]["bins"]) do
        local obj = createObject(1331, v[1], v[2], v[3]-0.15, 0, 0, v[4])

        local blip = createBlip(v[1], v[2], v[3], 59)
        setElementData(blip, "blip:name", "Fű leadása")

        table.insert(createdObjects, blip)
        table.insert(createdObjects, obj)
    end

    local tap = createObject(10833, unpack(gardenObjects[randGarden]["tap"]))
    local blip = createBlip(gardenObjects[randGarden]["tap"][1], gardenObjects[randGarden]["tap"][2], gardenObjects[randGarden]["tap"][3], 57)
    setElementData(blip, "blip:name", "Csap")
    setElementData(tap, "gardener:isTap", true)
    table.insert(createdObjects, tap)
    table.insert(createdObjects, blip)

    tapStartPos = gardenObjects[randGarden]["tap-start"]

    for k, v in ipairs(gardenObjects[randGarden]["flowers"]) do

        local obj = createObject(flowerObjects[math.random(#flowerObjects)], v[1], v[2], v[3]-1.3)
        setElementCollisionsEnabled(obj, false)
        local ped = createPed(0, v[1], v[2], v[3]-1.3)

        local blip = createBlip(v[1], v[2], v[3], 60)
        setElementData( blip, "blip:name", "Locsolásra szoruló virág")
        setElementFrozen(ped, true)
        setElementAlpha(ped, 0)
        setElementData(ped, "gardener:isFlowerPed", true)
        setElementData(ped, "gardener:flowerObj", obj)
        setElementData(ped, "gardener:flowerBlip", blip)    
        setElementData(ped, "gardener:flowerHP", 100)
        
        table.insert(createdObjects, obj)
        table.insert(createdObjects, ped)
        table.insert(createdObjects, blip)
    end

    workCol2 = createColCuboid(unpack(gardenObjects[randGarden]["col"]))
    x,y,z = gardenObjects[randGarden]["blipPos"][1],gardenObjects[randGarden]["blipPos"][2],gardenObjects[randGarden]["blipPos"][3]
    local blip = createBlip(x,y,z, 56)
    setElementData(blip, "blip:name", "Munka terület")
    setElementData(workCol2, "gardener:workplaceCol", true)
    table.insert(createdObjects, workCol2)
    table.insert(createdObjects, blip)
end

function destroyAllCreatedJobElement()
    for k, v in ipairs(createdObjects) do 
        if isElement(v) then 
            destroyElement(v)
        end
    end
end

local sprinklerState = false

local activeCol = false
local grassTimer = false
local mowerSound = false
local mowerState = false 
local mowerGrass = 0
local bagInHand = false
local trashInBag = 0

addEventHandler("onClientColShapeHit", getRootElement(), function(player, mdim)
    if player == localPlayer and mdim then 
        if getElementData(source, "gardener:grassHP") then
            local occupiedveh = getPedOccupiedVehicle(localPlayer)
            
            if occupiedveh then
                if getElementModel(occupiedveh) == 572 then
                    if getElementData(localPlayer, "jobVeh:ownedJobVeh") == occupiedveh then
                        if not mowerState then return end
                        
                        if isElement(mowerSound) then
                            setSoundVolume(mowerSound, 1)
                        end

                        activeCol = source

                        grassTimer = setTimer(function()
                            if mowerState then
                                if mowerGrass <= 100 then
                                    if not isElement(activeCol) then 
                                        activeCol = false

                                        if isTimer(grassTimer) then 
                                            killTimer(grassTimer) 
                                        end

                                        if isElement(mowerSound) then
                                            setSoundVolume(mowerSound, 0.5)
                                        end

                                        return
                                    end

                                    local obj = getElementData(activeCol, "gardener:obj")
                                    local objpos = {getElementPosition(obj)}
                                    moveObject(obj, 100, objpos[1], objpos[2], objpos[3]-0.015)

                                    local hp = getElementData(activeCol, "gardener:grassHP")

                                    if hp <= 0 then 
                                    --    destroyElement(getElementData(activeCol, "gardener:blip"))
                                        destroyElement(activeCol)
                                        destroyElement(obj)

                                        activeCol = false

                                        if isTimer(grassTimer) then 
                                            killTimer(grassTimer) 
                                        end

                                        if isElement(mowerSound) then
                                            setSoundVolume(mowerSound, 0.5)
                                        end

                                        local payment = 39

                                        if exports.oJob:isJobHasDoublePaymant(7) then 
                                            payment = payment * 2 
                                        end

                                        outputChatBox(core:getServerPrefix("server", "Kertész", 2).."Mivel levágtál egy füvet, így kaptál "..moneycolor..payment.."$#ffffff-t.", 255, 255, 255, true)
                                        setElementData(localPlayer, "char:money", getElementData(localPlayer, "char:money") + payment)

                                        if mowerGrass == 100 then 
                                            outputChatBox(core:getServerPrefix("server", "Kertész", 2).."A fűnyíró tartálya megtelet, üritsd ki a tartályt!", 255, 255, 255, true)
                                        end
                                    else
                                        setElementData(activeCol, "gardener:grassHP", hp - 1)
                                        mowerGrass = mowerGrass + 0.25
                                    end                                
                                end
                            end
                        end, 100, getElementData(activeCol, "gardener:grassHP") + 1)
                    end
                end
            end
        elseif source == workCol2 and player == localPlayer and mdim then 
            infobox:outputInfoBox("Megérkeztél a kerthez! A munkát a kert elhagyásával fejezheted be!", "success")
        end
    end
end)

addEventHandler("onClientColShapeLeave", getRootElement(), function(player, mdim)
    if player == localPlayer and mdim then 
        if getElementData(source, "gardener:grassHP") then 
            activeCol = false

            if isTimer(grassTimer) then 
                killTimer(grassTimer) 
            end

            if isElement(mowerSound) then
                setSoundVolume(mowerSound, 0.5)
            end
        elseif source == workCol2 and player == localPlayer and mdim then 
            --[[if #gardenObjects[randGarden]["flowers"] > 0 or #gardenObjects[randGarden]["grass"] > 0 then 
                infobox:outputInfoBox("Még maradt néhány feladatod a kerten! (Virágok: "..(#gardenObjects[randGarden]["flowers"]).."db | Fű: "..(#gardenObjects[randGarden]["grass"]) .."db)", "warning")
                toggleControl("fire", true)
                toggleControl("enter_exit", true)
                return
            end]]
            infobox:outputInfoBox("Elhagytad a kert területét, így a munka véget ért!", "info")
            destroyAllCreatedJobElement()
            inTalk = false
            inWork = false
            inWork = false 


            if sprinklerState then 
                if isTimer(waterPipeSyncTimer) then 
                    killTimer(waterPipeSyncTimer) 
                end

                removeEventHandler("onClientPreRender", root, renderWaterPipes)
                randGarden = false
                pipeDatas = {}
                playersLastPos = {}

                if isElement(tempVeh) then 
                    destroyElement(tempVeh)
                end

                if isElement(tempPed) then 
                    destroyElement(tempPed)
                end

                toggleControl("fire", true)
                toggleControl("enter_exit", true)
            end
        end
    end
end)

bindKey("x", "up", function()
    local occupiedveh = getPedOccupiedVehicle(localPlayer)

    if occupiedveh then
        if getElementModel(occupiedveh) == 572 then
            if getElementData(occupiedveh, "jobVeh:owner") == localPlayer then
                mowerState = not mowerState 

                if mowerState then
                    mowerSound = playSound("files/mower.mp3", true)
                    setSoundVolume(mowerSound, 0.5)
                else
                    if isElement(mowerSound) then
                        destroyElement(mowerSound)
                    end
                end
            end
        end
    end
end)

local tempVeh, tempPed = false, false
local waterPipeSyncTimer = false

local pipeDatas = {}
local playersLastPos = {}

local lastSlag = 0


addEventHandler("onClientClick", root, function(key, state, _, _, _, _, _, element)
    if key == "left" and state == "up" and element then 
        if getElementModel(element) == 572 then
            if core:getDistance(element, localPlayer) < 3 then 
                if not bagInHand then
                    if mowerGrass > 0 then
                        if not getPedOccupiedVehicle(localPlayer) then
                            bagInHand = true

                            trashInBag = math.abs(math.max(mowerGrass - 20, 0) - mowerGrass)
                            mowerGrass = math.max(mowerGrass - 20, 0)
                            toggleControl("sprint", false)
                            toggleControl("fire", false)
                            toggleControl("enter_exit", false)

                            chat:sendLocalMeAction("kivett egy zsák szemetet a fűnyíróból.")
                            triggerServerEvent("gardener > createTrashBag", resourceRoot)
                        end
                    else
                        outputChatBox(core:getServerPrefix("server", "Kertész", 2).."Nincs fű a fűnyíró tartályában.", 255, 255, 255, true)
                    end
                end
            end
        elseif getElementModel(element) == 1331 then 
            if core:getDistance(element, localPlayer) < 3 then 
                if bagInHand then
                    if trashInBag > 0 then
                        if not getPedOccupiedVehicle(localPlayer) then
                            bagInHand = false
                            toggleControl("sprint", true)
                            toggleControl("fire", true)
                            toggleControl("enter_exit", true)

                            chat:sendLocalMeAction("kidobott egy zsák levágott füvet a kukába.")
                            triggerServerEvent("gardener > destroyTrashBag", resourceRoot)

                            local payment = (trashInBag*11)

                            if exports.oJob:isJobHasDoublePaymant(7) then 
                                payment = payment * 2
                            end

                            outputChatBox(core:getServerPrefix("server", "Kertész", 2).."Mivel kidobtál egy zsák levágott füvet, így kaptál "..moneycolor..payment.."$#ffffff-t.", 255, 255, 255, true)
                            setElementData(localPlayer, "char:money", getElementData(localPlayer, "char:money") + payment)
                            trashInBag = 0
                        end
                    end
                else 
                    outputChatBox(core:getServerPrefix("server", "Kertész", 2).."Nincs a kezedben semmi!", 255, 255, 255, true)
                end
            end 
        end
    elseif key == "right" and state == "up" and element then 
        if getElementData(element, "gardener:isTap") then 
            if core:getDistance(element, localPlayer) < 3 then 
                if lastSlag + 250 < getTickCount() then
                    lastSlag = getTickCount()
                    if sprinklerState then 
                        if isTimer(waterPipeSyncTimer) then 
                            killTimer(waterPipeSyncTimer) 
                        end

                        removeEventHandler("onClientPreRender", root, renderWaterPipes)

                        pipeDatas = {}
                        playersLastPos = {}

                        if isElement(tempVeh) then 
                            destroyElement(tempVeh)
                        end

                        if isElement(tempPed) then 
                            destroyElement(tempPed)
                        end

                        chat:sendLocalMeAction("visszatette a slagot.")

                        toggleControl("fire", true)
                        toggleControl("enter_exit", true)
                    else
                        local playerX, playerY, playerZ = getElementPosition(localPlayer)
                        tempVeh = createVehicle(407, playerX, playerY, playerZ -10)
                        setElementCollisionsEnabled(tempVeh, false)
                        setElementAlpha(tempVeh, 0)
                        setElementFrozen(tempVeh, true)
                        setElementStreamable(tempVeh, false)
                        setVehicleEngineState(tempVeh, false)
                        setElementParent(tempVeh, localPlayer)

                        tempPed = createPed(0, 0, 0, 0)
                        warpPedIntoVehicle(tempPed, tempVeh)
                        setElementAlpha(tempPed, 0)
                        setElementStreamable(tempPed, false)
                        setElementParent(tempPed, localPlayer)
                        toggleControl("fire", false)
                        toggleControl("enter_exit", false)

                        setVehicleEngineState(tempVeh, false)

                        addEventHandler("onClientPreRender", root, renderWaterPipes)

                        waterPipeSyncTimer = setTimer(syncWaterPipes, 80, 0)

                        chat:sendLocalMeAction("levette a slagot.")
                    end

                    sprinklerState = not sprinklerState
                end
            end
        elseif element == createdJobElements[3] then 
            if not inTalk then 
                if not inWork then 
                    if isFirstTalk then 
                        talkingAnimation("start")
                        startTalkAnimation()
                    else
                        talkingAnimation("normal")
                        startTalkAnimation()
                    end
                    inTalk = true
                else 
                    outputChatBox(core:getServerPrefix("server", "Kertész", 2).."Már van egy munka folyamatod!", 255, 255, 255, true)
                end 
            end
        end
    end
end)

-- 
local sx, sy = guiGetScreenSize()
local myX, myY = 1768, 992

local _dxDrawText = dxDrawText 

function dxDrawText(text, x, y, w, h, ...)
    _dxDrawText(text, x, y, x + w, y + h, ...)
end

local panelX, panelY, panelW, panelH = sx*0.41, sy*0.8, sx*0.18, sy*0.08
function renderVehicleStatsPanel()
    dxDrawRectangle(panelX, panelY, panelW, panelH, tocolor(35, 35, 35, 150))
    dxDrawRectangle(panelX + 2/myX*sx, panelY + 2/myY*sy, panelW - 4/myX*sx, panelH - 4/myY*sy, tocolor(35, 35, 35, 255))

    dxDrawRectangle(panelX + 2/myX*sx, panelY + 2/myY*sy, panelW - 4/myX*sx, sy*0.02, tocolor(30, 30, 30, 255))
    dxDrawText("Fűnyíró", panelX + 2/myX*sx, panelY + 2/myY*sy, panelW - 4/myX*sx, sy*0.02, tocolor(255, 255, 255, 100), 1, font:getFont("condensed", 9/myX*sx), "center", "center")

    dxDrawRectangle(panelX + 6/myX*sx, panelY + sy*0.025, panelW - 12/myX*sx, sy*0.023, tocolor(30, 30, 30, 200))
    dxDrawRectangle(panelX + 8/myX*sx, panelY + sy*0.025 + 2/myY*sy, (panelW - 16/myX*sx), sy*0.023 - 4/myY*sy, tocolor(35, 35, 35, 50))
    dxDrawRectangle(panelX + 8/myX*sx, panelY + sy*0.025 + 2/myY*sy, (panelW - 16/myX*sx) * (mowerGrass/100), sy*0.023 - 4/myY*sy, tocolor(150, 219, 77, 200))
    dxDrawText(math.floor(mowerGrass).."%", panelX + 8/myX*sx, panelY + sy*0.025 + 2/myY*sy, (panelW - 16/myX*sx), sy*0.023 - 4/myY*sy, tocolor(255, 255, 255, 100), 1, font:getFont("condensed", 10/myX*sx), "center", "center")
    if math.floor(mowerGrass) < 100 then 
        dxDrawText("A fűnyíró ki/be kapcsolásához nyomd meg az "..color.."[X] #ffffffgombot.", panelX + 2/myX*sx, panelY + 2/myY*sy, panelW - 4/myX*sx, panelH - sy*0.015, tocolor(255, 255, 255, 100), 1, font:getFont("condensed", 8/myX*sx), "center", "bottom", false, false, false, true)
    else 
        dxDrawText("A fűnyírót a "..color.."[Bal klikk]#ffffff segítségével ürítheted ki.", panelX + 2/myX*sx, panelY + 2/myY*sy, panelW - 4/myX*sx, panelH - sy*0.015, tocolor(255, 255, 255, 100), 1, font:getFont("condensed", 8/myX*sx), "center", "bottom", false, false, false, true)
    end
end

-- Water pipe
addEventHandler("onClientPlayerHitByWaterCannon", root, function(ped)
    cancelEvent()
end)

addEventHandler("onClientPedHitByWaterCannon", root, function(ped)
    if getElementData(ped, "gardener:flowerObj") then
        --print("asd")
        if getElementData(ped, "gardener:flowerHP") > 1 then
            local x, y, z = getElementPosition(getElementData(ped, "gardener:flowerObj"))
            moveObject( getElementData(ped, "gardener:flowerObj"), 100,x, y, z+0.005)

            setElementData(ped, "gardener:flowerHP", getElementData(ped,  "gardener:flowerHP") - 1)
        else
            destroyElement(getElementData(ped, "gardener:flowerBlip"))
            destroyElement(ped)

            local payment = 162
            if exports.oJob:isJobHasDoublePaymant(7) then 
                payment = payment * 2
            end

            setElementData(localPlayer, "char:money", getElementData(localPlayer, "char:money") + payment)
            outputChatBox(core:getServerPrefix("server", "Kertész", 2).."Mivel meglocsoltál egy virágot, így kaptál "..moneycolor..payment.."$#ffffff-t.", 255, 255, 255, true)
        end
    end
end)

local rendercount = 0
function renderWaterPipes()
    rendercount = 0
    for k, v in pairs(pipeDatas) do 
        for k2, v2 in ipairs(v) do 
            if v[k2 - 1] then 
                local x, y, z = getScreenFromWorldPosition(v[k2 - 1][1], v[k2 - 1][2], v[k2 - 1][3])
                local x2, y2, z2 = getScreenFromWorldPosition(v2[1], v2[2], v2[3])
                if (x and y and z) or (x2 and y2 and z2) then
                    dxDrawLine3D(v[k2 - 1][1], v[k2 - 1][2], v[k2 - 1][3], v2[1], v2[2], v2[3], tocolor(0, 0, 0), 5)
                    rendercount = rendercount + 1
                end
            else
                dxDrawLine3D(v2[1], v2[2], v2[3], v2[1], v2[2], v2[3], tocolor(0, 0, 0), 5)
                rendercount = rendercount + 1
            end
        end

        local boneX, boneY, boneZ = getPedBonePosition(k, 25)

        dxDrawLine3D(v[#v][1], v[#v][2], v[#v][3], boneX, boneY, boneZ, tocolor(0, 0, 0), 5)
    end
    --dxDrawText(rendercount, 0, 0, 0, 0)


    if getKeyState("mouse1") then 
        local playerX, playerY, playerZ = getElementPosition(localPlayer)
        local handX, handY, handZ = core:getPositionFromElementOffset(localPlayer, 0.25, -0.92, -0.15)

        setVehicleComponentVisible(tempVeh, "misc_a", false)
        setElementPosition(tempVeh, playerX, playerY, playerZ - 10)
        setVehicleComponentPosition(tempVeh, "misc_a", handX, handY, handZ, "world")

        setVehicleEngineState(tempVeh, false)

        setPedControlState(tempPed, "vehicle_fire", true)
        
        local startX, startY, startZ = getPedTargetStart(localPlayer)
        local targetX, targetY, targetZ = getPedTargetEnd(localPlayer)
        local vectorX, vectorY, vectorZ = startX - targetX, startZ - targetZ, startY - targetY
        
        local rotX, rotY, rotZ = getElementRotation(localPlayer)
        setElementRotation(tempVeh, -math.deg(math.atan2(vectorY, math.sqrt(vectorZ * vectorZ + vectorX * vectorX))), 0, rotZ)
    else
        setPedControlState(tempPed, "vehicle_fire", false)
    end
end
--
function linesIntersect(x1, y1, x2, y2, x3, y3, x4, y4)
	local d = (y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1)

	if d == 0 then
		return false
	end

	local n_a = (x4 - x3) * (y1 - y3) - (y4 - y3) * (x1 - x3)
	local n_b = (x2 - x1) * (y1 - y3) - (y2 - y1) * (x1 - x3)

	local ua = n_a / d
	local ub = n_b / d

	if ua >= 0 and ua <= 1 and ub >= 0 and ub <= 1 then
		return x1 + ua * (x2 - x1), y1 + ua * (y2 - y1)
	end

	return false
end


function syncWaterPipes()
    local v = localPlayer
    if not pipeDatas[v] then 
        pipeDatas[v] = {}
        table.insert(pipeDatas[v], tapStartPos)
    else
        local playerX, playerY, playerZ = core:getPositionFromElementOffset(v, 0.5, -0.25, 1)
        playerZ = getGroundPosition(playerX, playerY, playerZ) 
        playerZ = playerZ + 0.04

        if not playersLastPos[v] then 
            playersLastPos[v] = {math.floor(playerX*10), math.floor(playerY*10), math.floor(playerZ*10)}
            table.insert(pipeDatas[v], {playerX, playerY, playerZ})
        else
            if not (playersLastPos[v][1] == math.floor(playerX*10) and playersLastPos[v][2] == math.floor(playerY*10) and playersLastPos[v][3] == math.floor(playerZ*10)) then
                playersLastPos[v] = {math.floor(playerX*10), math.floor(playerY*10), math.floor(playerZ*10)}
                table.insert(pipeDatas[v], {playerX, playerY, playerZ})
            end
        end
    end
end

-- Mower speed limit
local vehicle = nil 

function checkBicycleSpeed()
    if not getPedOccupiedVehicle(localPlayer) == vehicle or not isElement(vehicle) then 
        removeEventHandler("onClientPreRender", root, checkBicycleSpeed)
        return
    end

    if getPedControlState(localPlayer, "accelerate") then
        if mowerState then
            if getElementSpeed(vehicle, "km/h") > 10 then 
                setElementSpeed(vehicle, "km/h", 10)
            end
        end
    end
end

addEventHandler("onClientVehicleStartEnter", root, function(player, seat)
    if player == localPlayer then 
        if sprinklerState then 
            outputChatBox(core:getServerPrefix("server", "Kertész", 2).."Előbb tedd le a slagot!", 255, 255, 255, true)
            cancelEvent() 
        end
    end
end)

addEventHandler("onClientVehicleEnter", root, function(player, seat)
    if player == localPlayer then 
        if seat == 0 then 
            if getElementModel(source) == 572 then 
                if getElementData(source, "jobVeh:owner") == localPlayer then
                    vehicle = source

                    addEventHandler("onClientPreRender", root, checkBicycleSpeed)
                    addEventHandler("onClientRender", root, renderVehicleStatsPanel)
                end
            end
        end
    end
end)

addEventHandler("onClientVehicleExit", root, function(player, seat)
    if player == localPlayer then 
        if vehicle == source then
            if getElementData(source, "jobVeh:owner") == localPlayer then

                if mowerState then  
                    if isElement(mowerSound) then
                        destroyElement(mowerSound)
                    end
                    mowerState = false
                end

                removeEventHandler("onClientPreRender", root, checkBicycleSpeed)
                removeEventHandler("onClientRender", root, renderVehicleStatsPanel)

                vehicle = false
            end
        end
    end
end)

addEventHandler("onClientElementDestroy", root, function()
    if vehicle == source then
        removeEventHandler("onClientPreRender", root, checkBicycleSpeed)
        removeEventHandler("onClientRender", root, renderVehicleStatsPanel)

        vehicle = false
    end
end)

function setElementSpeed(element, unit, speed)
    local unit    = unit or 0
    local speed   = tonumber(speed) or 0
	local acSpeed = getElementSpeed(element, unit)
	if acSpeed and acSpeed~=0 then -- if true - element is valid, no need to check again
		local diff = speed/acSpeed
		if diff ~= diff then return false end -- if the number is a 'NaN' return false.
        	local x, y, z = getElementVelocity(element)
		return setElementVelocity(element, x*diff, y*diff, z*diff)
	end
	return false
end

function getElementSpeed(theElement, unit)
    -- Check arguments for errors
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    local elementType = getElementType(theElement)
    assert(elementType == "player" or elementType == "ped" or elementType == "object" or elementType == "vehicle" or elementType == "projectile", "Invalid element type @ getElementSpeed (player/ped/object/vehicle/projectile expected, got " .. elementType .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    -- Default to m/s if no unit specified and 'ignore' argument type if the string contains a number
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    -- Setup our multiplier to convert the velocity to the specified unit
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    -- Return the speed by calculating the length of the velocity vector, after converting the velocity to the specified unit
    return (Vector3(getElementVelocity(theElement)) * mult).length
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
        _dxDrawText(color.."[Marco]: #dcdcdc"..texts[talk_text[1]][talk_text[2]], 0, sy*0.9, sx, sy, tocolor(220, 220, 220, 255*alpha), 1, font:getFont("condensed", 15/myX*sx), "center", "center", false, false, false, true)
    end
end

function startTalkAnimation() 
    setElementAlpha(localPlayer, 0)
    pC1x, pC1y, pC1z, pC2x, pC2y, pC2z = getCameraMatrix()

    local bossPedPos = Vector3(getElementPosition(createdJobElements[3]))

    smoothMoveCamera(pC1x, pC1y, pC1z, pC2x, pC2y, pC2z, bossPedPos.x-3, bossPedPos.y+2, bossPedPos.z+0.6, bossPedPos.x, bossPedPos.y, bossPedPos.z+0.6, 1000)

    animation_state = "open"
    animation_tick = getTickCount() 
    addEventHandler("onClientRender", root, renderTalkPanel)

    setElementFrozen(localPlayer, true)

    showChat(false)
    interface:toggleHud(true)

    inTalk = true

    setTimer(function() 
        setElementData(localPlayer, "user:hideWeapon", true)
        bindKey("backspace", "up", stopTalkAnimation) 
    end, 1000, 1)
end

function stopTalkAnimation()
    setElementAlpha(localPlayer, 255)
    local bossPedPos = Vector3(getElementPosition(createdJobElements[3]))

    smoothMoveCamera(bossPedPos.x-3, bossPedPos.y+2, bossPedPos.z+0.6, bossPedPos.x, bossPedPos.y, bossPedPos.z+0.6, pC1x, pC1y, pC1z, pC2x, pC2y, pC2z, 1000)

    animation_state = "close"
    animation_tick = getTickCount() 

    showChat(true)
    setPedAnimation(createdJobElements[3])
    interface:toggleHud(false)
    unbindKey("backspace", "up", stopTalkAnimation)

    setElementFrozen(localPlayer, false)

    killTalkingTimers() 

    inTalk = false

    setTimer(function() 
        toggleControl("fire", true)
        toggleControl("enter_exit", true)
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

    setPedAnimation(createdJobElements[3], "GHANDS", "gsign5", -1, true, false, false, false)
    for k, v in ipairs(texts[text_group]) do 
        timer_time = timer_time + string.len(v)*text_wait

        if k == 1 then 
            talk_text = {text_group, 1}
        elseif k == #texts[text_group] then 
            local timer = setTimer(function() 
                talk_text[2] = talk_text[2] + 1

                setTimer(function() 
                    talk_text = false 
                    setPedAnimation(createdJobElements[3])
                    isFirstTalk = false
                    

                    stopTalkAnimation()

                    createRandomGarden()
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
