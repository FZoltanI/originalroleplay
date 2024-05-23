local sx, sy = guiGetScreenSize()
local myX, myY = 1600, 900

local fonts = {
    ["bebasneue-25"] = exports.oFont:getFont("bebasneue", 25),
    ["condensed-25"] = exports.oFont:getFont("condensed", 25),
}

local iconImages = {
    ["saw"] = dxCreateTexture("files/saw.png"),
    ["lockpick"] = dxCreateTexture("files/lockpick.png"),
    ["drill"] = dxCreateTexture("files/drill.png"),
    ["bomb"] = dxCreateTexture("files/bomb.png"),
    ["pliers"] = dxCreateTexture("files/pliers.png"),
    ["pickup"] = dxCreateTexture("files/pickup.png"),
}

local renderTargets = {}
local shaders = {}

addEventHandler("onClientResourceStart", root, function(res)
	if getResourceName(res) == "oCore" or getResourceName(res) == "oBankrob" or getResourceName(res) == "oInfobox" then  
        core = exports.oCore
        color, r, g, b = core:getServerColor()
        infobox = exports.oInfobox
	end
end)
addEventHandler("onClientRender", root, function()
    local px, py, pz = getCameraMatrix()

    for k, v in ipairs(getElementsByType("object", resourceRoot, true)) do        
        local x9, y9, z9 = getElementPosition(localPlayer)
        local xo, yo, zo = getElementPosition(v)
        local extracucc = getElementData(v, "bankrob:element:iconPositions") or {0, 0, 0}
        local dist = 0 

        if extracucc then
            dist = getDistanceBetweenPoints3D(x9, y9, z9, xo + extracucc[1], yo + extracucc[2], zo + extracucc[3])
        else
            dist = core:getDistance(localPlayer, v)
        end

        local checkDis = 2

        if ((getElementData(v, "bankrob:element:id") or {0, 0})[2] or false) == "door_up" then
            checkDis = 3.5
        elseif getElementModel(v) == 18310 then 
            checkDis = 4
        end


        if dist < checkDis then 
            if getElementData(v, "bankrob:element:interactionTypes") then 
                local posX, posY, posZ = getElementPosition(v)

                --if isLineOfSightClear(px, py, pz, posX, posY, posZ, true, false, false, false, false, false, false, localPlayer) then
                    local icons = getElementData(v, "bankrob:element:interactionTypes")

                    if icons then 
                        local iconX, iconY, iconZ = unpack(getElementData(v, "bankrob:element:iconPositions"))
                        for k2, v2 in ipairs(icons) do 
                            posZ = posZ - 0.1*k2
                            local screenX, screenY = getScreenFromWorldPosition(posX+iconX, posY+iconY, posZ+iconZ)

                            local size = 1 - dist/(3 + checkDis) 

                            if screenX and screenY then 
                                if core:isInSlot(screenX, screenY, 50*size, 50*size) then 
                                    dxDrawImage(screenX, screenY, 50*size, 50*size, iconImages[v2], 0, 0, 0, tocolor(r, g, b, 255))
                                else
                                    dxDrawImage(screenX, screenY, 50*size, 50*size, iconImages[v2])
                                end
                            end
                        end
                    end
                --end
            elseif getElementModel(v) == 18315 then 
                local posX, posY, posZ = getElementPosition(v)
                local spark = fxAddSparks(posX, posY, posZ, 0, 0, 0, 1, 1)

                if not renderTargets[v] then 
                    renderTargets[v] = dxCreateRenderTarget(200, 100)
                end

                dxSetRenderTarget(renderTargets[v], true)
                    dxDrawImage(0, 0, 200, 100, "files/screen.png")
                    dxDrawRectangle(8, 43, 184 * (getElementData(v, "bankrob:drill:drillingValue") or 0), 13, tocolor(176, 166, 71))
                dxSetRenderTarget()

                if not getElementData(v, "bankrob:drill:screenSet") then 
                    setElementData(v, "bankrob:drill:screenSet", true, false)

                    shaders[v] = dxCreateShader("files/textureChanger.fx", 0, 100, false, "all")
                    engineApplyShaderToWorldTexture(shaders[v], "screen", v)
                    dxSetShaderValue(shaders[v], "gTexture", renderTargets[v])
                end
            elseif getElementModel(v) == 7045 then 
                local posX, posY, posZ = getElementPosition(v)
                local spark = fxAddSparks(posX, posY, posZ, 0, 0, 0, 1, 1)
            end
        end
    end
end)

local startInteractions
local openingDoor
local bombedDoor

local inMoneyPicking = false
addEventHandler("onClientKey", root, function(key, state)
    if key == "mouse1" and state then 
        local px, py, pz = getCameraMatrix()

    for k, v in ipairs(getElementsByType("object", resourceRoot, true)) do 
        local x9, y9, z9 = getElementPosition(localPlayer)
        local xo, yo, zo = getElementPosition(v)
        local extracucc = getElementData(v, "bankrob:element:iconPositions") or {0, 0, 0}
        local dist = 0 

        if extracucc then
            dist = getDistanceBetweenPoints3D(x9, y9, z9, xo + extracucc[1], yo + extracucc[2], zo + extracucc[3])
        else
            dist = core:getDistance(localPlayer, v)
        end

        local checkDis = 2

        if getElementData(v, "bankrob:element:id") then
            if (getElementData(v, "bankrob:element:id")[2] or "") == "door_up" then
                checkDis = 3.5
            end
        end

        if getElementModel(v) == 18310 then 
            checkDis = 4
        end

        if dist < checkDis then 
            if getElementData(v, "bankrob:element:interactionTypes") then
                local posX, posY, posZ = getElementPosition(v)

                --if isLineOfSightClear(px, py, pz, posX, posY, posZ, true, false, false, false, false, false, false, localPlayer) then
                    local icons = getElementData(v, "bankrob:element:interactionTypes")
                    local iconX, iconY, iconZ = unpack(getElementData(v, "bankrob:element:iconPositions"))
                    for k2, v2 in pairs(icons) do 

                        posZ = posZ - 0.1*k2
                        local screenX, screenY = getScreenFromWorldPosition(posX+iconX, posY+iconY, posZ+iconZ)

                        local size = 1 - dist/(3 + checkDis)  

                        if screenX and screenY then 
                            if core:isInSlot(screenX, screenY, 50*size, 50*size) then 
                                if exports.oDashboard:isPlayerFactionTypeMember({4, 5}) then
                                    if exports.oDashboard:getOnlineFactionTypeMemberCount({1}) >= robStartNeededPoliceCount then
                                        if v2 == "drill" then 
                                            if exports.oInventory:hasItem(70) then 
                                                exports.oInventory:takeItem(70)

                                                triggerServerEvent("bankrob > createDrill", resourceRoot, v)
                                                exports.oChat:sendLocalMeAction("felrakta a fúrót a széf ajtajára, majd bekapcsolta azt.")
                                            else
                                                outputChatBox(core:getServerPrefix("red-dark", "Bankrablás", 3).."Nincs nálad fúró!", 255, 255, 255, true)
                                            end
                                        elseif v2 == "lockpick" then 
                                            if exports.oInventory:hasItem(169) then 
                                                exports.oInventory:takeItem(169)
                                                
                                                setElementFrozen(localPlayer, true)

                                                startInteractions = getElementData(v, "bankrob:element:interactionTypes")
                                                setElementData(v, "bankrob:doorPlaySound", {"lockpicking", 10, 2.5})
                                                setElementData(v, "bankrob:element:interactionTypes", {})

                                                triggerServerEvent("bankrob > setPedAnimation", resourceRoot, "cop_ambient", "copbrowse_loop")
                                                exports.oMinigames:createMinigame(1, 15, 45000, "bankrob > doorLockpickSuccess", "bankrob > doorLockpickUnSuccess")
                                                exports.oChat:sendLocalMeAction("elkezdett kinyitni egy ajtót, egy tolvalkulcs segítségével.")
                                                openingDoor = v
                                            else
                                                outputChatBox(core:getServerPrefix("red-dark", "Bankrablás", 3).."Nincs nálad tolvajkulcs!", 255, 255, 255, true)
                                            end
                                        elseif v2 == "saw" then 
                                            if exports.oInventory:hasItem(170) then 
                                                exports.oInventory:takeItem(170)

                                                exports.oChat:sendLocalMeAction("elkezdett kinyitni egy ajtót, egy fűrész segítségével.")
                                                
                                                setElementFrozen(localPlayer, true)
                                                local openTime = math.random(12500, 20000)
                                                core:createProgressBar("Ajtó kinyitása...", openTime, "bankrob > endDoorLockpicking", true)
                                                setElementData(v, "bankrob:doorPlaySound", {"saw", 35, 1})
                                                setElementData(v, "bankrob:element:interactionTypes", {})

                                                triggerServerEvent("bankrob > openDoor", resourceRoot, v, openTime)

                                                local ID = getElementData(v, "bankrob:element:id")
                                                if not getElementData(resourceRoot, "bank:bankInRob:"..ID[1]) then 
                                                    triggerServerEvent("banrkob > startBankAlarmSound", resourceRoot, ID[1])
                                                end
                                            else
                                                outputChatBox(core:getServerPrefix("red-dark", "Bankrablás", 3).."Nincs nálad fűrész!", 255, 255, 255, true)
                                            end
                                        elseif v2 == "bomb" then 
                                            if exports.oInventory:hasItem(178) then 
                                                exports.oInventory:takeItem(178)

                                                triggerServerEvent("bankrob > setPedAnimation", resourceRoot, "cop_ambient", "copbrowse_loop")
                                                
                                                setElementData(v, "bankrob:element:interactionTypes", {})

                                                exports.oChat:sendLocalDoAction("C4 felhelyezése folyamatban.")

                                                setElementFrozen(localPlayer, true)
                                                local bombTime = math.random(5000, 7500)
                                                core:createProgressBar("Bomba felhelyezése...", bombTime, "bankrob > startBombing", true)
                                                bombedDoor = v
                                            else
                                                outputChatBox(core:getServerPrefix("red-dark", "Bankrablás", 3).."Nincs nálad C4!", 255, 255, 255, true)
                                            end
                                        elseif v2 == "pliers" then 
                                            if exports.oInventory:hasItem(182) then 
                                                if getElementData(resourceRoot, "bankrob:bank:bankdoorOpen") then
                                                    exports.oInventory:takeItem(182)

                                                    setElementFrozen(localPlayer, true)
                                                    triggerServerEvent("bankrob > setPedAnimation", resourceRoot, "cop_ambient", "copbrowse_loop")

                                                    exports.oChat:sendLocalMeAction("elkezdett elvágni egy vezetéket.")
                                                    
                                                    setElementData(v, "bankrob:element:interactionTypes", {})

                                                    exports.oMinigames:createMinigame(2, 20, 20000, "bankrob > cableCutSuccess", "bankrob > cableCutUnSuccess")
                                                else
                                                    infobox:outputInfoBox("Ez a művelet csak a széfajtó kinyitása után végezhető el!", "warning")
                                                end
                                            else
                                                outputChatBox(core:getServerPrefix("red-dark", "Bankrablás", 3).."Nincs nálad fogó!", 255, 255, 255, true)
                                            end
                                        elseif v2 == "pickup" then 
                                            if inMoneyPicking then return end
                                            setElementData(v, "bankrob:element:interactionTypes", {})

                                            setElementFrozen(localPlayer, true)

                                            if getElementModel(v) == 1550 or getElementModel(v) == 18294 then 
                                                local pickupTime = math.random(50000, 70000)
                                                inMoneyPicking = true
                                                triggerServerEvent("bankrob > pickupMoneyBag", resourceRoot, v, pickupTime, "money")
                                                core:createProgressBar("Pénz elpakolása folyamatban...", pickupTime, "bankrob > pickupMoneyBag", true)
                                            elseif getElementModel(v) == 17080 then
                                                local pickupTime = math.random(65000, 85000)
                                                inMoneyPicking = true
                                                triggerServerEvent("bankrob > pickupMoneyBag", resourceRoot, v, pickupTime, "gold")
                                                core:createProgressBar("Arany elpakolása folyamatban...", pickupTime, "bankrob > pickupMoneyBag", true)
                                            end
                                        end 
                                    else
                                        outputChatBox(core:getServerPrefix("red-dark", "Bankrablás", 2).."Minimum "..color..robStartNeededPoliceCount.."db #ffffffrendvédelmi tagnak online kell lennie ahhoz, hogy elkezdhesd a bankrablást.", 255, 255, 255, true)
                                    end
                                else
                                    outputChatBox(core:getServerPrefix("red-dark", "Bankrablás", 2).."Ez a funkció csak "..color.."banda/maffia #fffffftagok számára érhető el!", 255, 255, 255, true)
                                end
                            end
                        end
                    end
                --end
            end
        end
    end
    end
end)

addEvent("bankrob > startBombing", true)
addEventHandler("bankrob > startBombing", root, function()
    exports.oChat:sendLocalMeAction("felrakott egy C4-et a falra.")
    triggerServerEvent("bankrob > exploseWall", resourceRoot, bombedDoor)
    triggerServerEvent("bankrob > setPedAnimation", resourceRoot, "", "")
    setElementFrozen(localPlayer, false)
    bombedDoor = false
end)

addEvent("bankrob > pickupMoneyBag", true)
addEventHandler("bankrob > pickupMoneyBag", root, function()
    setElementFrozen(localPlayer, false)
    triggerServerEvent("bankrob > setPedAnimation", resourceRoot, "", "")
    inMoneyPicking = false
end)

addEvent("bankrob > doorLockpickSuccess", true)
addEventHandler("bankrob > doorLockpickSuccess", root, function()
    triggerServerEvent("bankrob > openDoor", resourceRoot, openingDoor)
    setElementFrozen(localPlayer, false)

    exports.oChat:sendLocalDoAction("sikerült kinyitnia az ajtót.")
end)

addEvent("bankrob > doorLockpickUnSuccess", true)
addEventHandler("bankrob > doorLockpickUnSuccess", root, function()
    setElementFrozen(localPlayer, false)

    exports.oChat:sendLocalDoAction("nem sikerült kinyitnia az ajtót.")

    setElementData(openingDoor, "bankrob:element:interactionTypes", startInteractions)
    setElementData(openingDoor, "bankrob:doorPlaySound", false)
    triggerServerEvent("bankrob > setPedAnimation", resourceRoot, "", "")
end)

addEvent("bankrob > cableCutSuccess", true)
addEventHandler("bankrob > cableCutSuccess", root, function()
    triggerServerEvent("bankrob > cutWires", resourceRoot)

    setElementFrozen(localPlayer, false)
    exports.oChat:sendLocalDoAction("sikerült elvágnia a vezetékeket.")

    outputChatBox(core:getServerPrefix("green-dark", "Bankrablás", 2).."Sikeresen elvágtad a lézerek áramellátását, viszont "..color.."1 #ffffffperc múlva újra aktivizálódnak.", 255, 255, 255, true)

    triggerServerEvent("bankrob > setPedAnimation", resourceRoot, "", "")
end)

addEvent("bankrob > cableCutUnSuccess", true)
addEventHandler("bankrob > cableCutUnSuccess", root, function()
    setElementFrozen(localPlayer, false)

    exports.oChat:sendLocalDoAction("nem sikerült elvágnia a vezetékeket.")

    triggerServerEvent("bankrob > setPedAnimation", resourceRoot, "", "")
    triggerServerEvent("banrkob > startBankAlarmSound", resourceRoot, "market_ls")
end)

addEvent("bankrob > endDoorLockpicking", true)
addEventHandler("bankrob > endDoorLockpicking", root, function()
    setElementFrozen(localPlayer, false)
end)

addEvent("bankrob > playDoorOpenSoundEffect", true)
addEventHandler("bankrob > playDoorOpenSoundEffect", resourceRoot, function(door)
    local posX, posY, posZ = getElementPosition(door)

    if isElementStreamedIn(door) then 
        local sound = playSound3D("files/door_open.wav", posX, posY, posZ)
        setSoundVolume(sound, 2.5)
        setSoundMaxDistance(sound, 10)
    end
end)

addEvent("bankrob > createExplosion", true)
addEventHandler("bankrob > createExplosion", root, function(x, y, z)
    createExplosion(x, y, z, 10, true)

    setSoundMaxDistance(playSound3D("files/bomb.mp3", x, y, z), 25)
end)

addEvent("bankrob > glassdoorSoundEffect", true)
addEventHandler("bankrob > glassdoorSoundEffect", root, function(x, y, z)
    local sound = playSound3D("files/glassdoor_open.mp3", x, y, z)
    setSoundVolume(sound, 4)
    setSoundMaxDistance(sound, 15)
end)

local createdSounds = {}

addEventHandler("onClientElementStreamIn", resourceRoot, function()
    if getElementModel(source) == 18315 then 
        if not createdSounds[source] then
            local posX, posY, posZ = getElementPosition(source)
            createdSounds[source] = playSound3D("files/drill.wav", posX, posY, posZ, true)
            setSoundVolume(createdSounds[source], 2.5)
            setSoundMaxDistance(createdSounds[source], 25)
        end
    elseif getElementData(source, "bankrob:doorPlaySound") then 
        if not createdSounds[source] then
            local values = getElementData(source, "bankrob:doorPlaySound")
            local posX, posY, posZ = getElementPosition(source)
            createdSounds[source] = playSound3D("files/"..values[1]..".wav", posX, posY, posZ, true)
            setSoundVolume(createdSounds[source], values[3])
            setSoundMaxDistance(createdSounds[source], values[2])
        end
    elseif getElementData(source, "bank:siren:state") then 
        if not createdSounds[source] then
            local posX, posY, posZ = getElementPosition(source)
            createdSounds[source] = playSound3D("files/alarm.wav", posX, posY, posZ, true)
            setSoundVolume(createdSounds[source], 7)
            setSoundMaxDistance(createdSounds[source], 120)
        end
    end
end)

addEventHandler("onClientElementDestroy", resourceRoot, function()
	if getElementModel(source) == 18315 then 
        if createdSounds[source] then
            if isElement(createdSounds[source]) then 
                destroyElement(createdSounds[source])
            end

            createdSounds[source] = false
        end
    elseif getElementData(source, "bankrob:doorPlaySound") then 
        if createdSounds[source] then
            if isElement(createdSounds[source]) then 
                destroyElement(createdSounds[source])
            end

            createdSounds[source] = false
        end
    elseif getElementData(source, "bank:siren:state") then 
        if createdSounds[source] then
            if isElement(createdSounds[source]) then 
                destroyElement(createdSounds[source])
            end

            createdSounds[source] = false
        end
    end
end)

addEventHandler("onClientElementStreamOut", resourceRoot, function()
    if getElementModel(source) == 18315 then 
        if createdSounds[source] then
            if isElement(createdSounds[source]) then 
                destroyElement(createdSounds[source])
            end

            createdSounds[source] = false
        end
    elseif getElementData(source, "bankrob:doorPlaySound") then 
        if createdSounds[source] then
            if isElement(createdSounds[source]) then 
                destroyElement(createdSounds[source])
            end

            createdSounds[source] = false
        end
    elseif getElementData(source, "bank:siren:state") then 
        if createdSounds[source] then
            if isElement(createdSounds[source]) then 
                destroyElement(createdSounds[source])
            end

            createdSounds[source] = false
        end
    end
end)

addEventHandler("onClientElementDataChange", resourceRoot, function(data, old, new)
    if data == "bankrob:doorPlaySound" then 
        if new then 
            if not createdSounds[source] then
                local posX, posY, posZ = getElementPosition(source)
                createdSounds[source] = playSound3D("files/"..new[1]..".wav", posX, posY, posZ, true)
                setSoundVolume(createdSounds[source], new[3])
                setSoundMaxDistance(createdSounds[source], new[2])
            end
        else
            if createdSounds[source] then
                if isElement(createdSounds[source]) then 
                    destroyElement(createdSounds[source])
                end
    
                createdSounds[source] = false
            end
        end
    elseif data == "bank:siren:state" then 
        if new then 
            if not createdSounds[source] then
                local posX, posY, posZ = getElementPosition(source)
                createdSounds[source] = playSound3D("files/alarm.wav", posX, posY, posZ, true)
                setSoundVolume(createdSounds[source], 7)
                setSoundMaxDistance(createdSounds[source], 120)
            end
        else
            if createdSounds[source] then
                if isElement(createdSounds[source]) then 
                    destroyElement(createdSounds[source])
                end
    
                createdSounds[source] = false
            end
        end
    end
end)

local occupiedCol = false
local moneyUnloadTimer = false

local lastDetectorTrigger = 0 

addEventHandler("onClientColShapeHit", resourceRoot, function(player, mdim)
    if player == localPlayer and mdim then 
        occupiedCol = source

        if getElementData(source, "bankrob:col:defMoney") then 
            addEventHandler("onClientRender", root, renderSafeStats)
            bindKey("e", "up", setMoneyUnloadState)
        elseif getElementData(source, "bankrob:isIronDetector") then 
            local hasIllegalItem = false 

            for k, v in ipairs(illegalItems) do 
                if exports.oInventory:hasItem(v) then 
                    hasIllegalItem = v 
                    break 
                end
            end

            if hasIllegalItem then 
                if lastDetectorTrigger + core:minToMilisec(2) < getTickCount() then
                    triggerServerEvent("bankrob > sendIronDetectorMessage", resourceRoot, getElementData(source, "bankrob:isIronDetector"))
                    lastDetectorTrigger = getTickCount()
                end
            end
        end
    end
end)

addEventHandler("onClientColShapeLeave", resourceRoot, function(player, mdim)
    if player == localPlayer and mdim then 
        occupiedCol = false

        if getElementData(source, "bankrob:col:defMoney") then 
            removeEventHandler("onClientRender", root, renderSafeStats)
            unbindKey("e", "up", setMoneyUnloadState)
        end
    end
end)

function renderSafeStats()  
    if isElement(occupiedCol) then 
        local allMoney, moneyInSafe = getElementData(occupiedCol, "bankrob:col:defMoney"), getElementData(occupiedCol, "bankrob:col:money")

        if allMoney and moneyInSafe then 
            core:dxDrawShadowedText((allMoney - moneyInSafe).."$#ffffff/"..allMoney.."$", sx*0.855, sy*0.9, sx*0.855+sx*0.14, sy*0.9+sy*0.055, tocolor(r, g, b, 255), tocolor(0, 0, 0, 255), 0.8/myX*sx, fonts["bebasneue-25"], "right", "bottom", false, false, false, true)

            if not moneyUnloadTimer then 
                core:dxDrawShadowedText("A pakolás elkezdéséhez nyomd meg az "..color.."[E] #ffffffgombot.", sx*0.855, sy*0.93, sx*0.855+sx*0.14, sy*0.93+sy*0.055, tocolor(255, 255, 255, 255), tocolor(0, 0, 0, 255), 0.6/myX*sx, fonts["bebasneue-25"], "right", "bottom", false, false, false, true)
            else
                core:dxDrawShadowedText("A pakolás félbehagyásához nyomd meg az "..color.."[E] #ffffffgombot.", sx*0.855, sy*0.93, sx*0.855+sx*0.14, sy*0.93+sy*0.055, tocolor(255, 255, 255, 255), tocolor(0, 0, 0, 255), 0.6/myX*sx, fonts["bebasneue-25"], "right", "bottom", false, false, false, true)
            end
        end
    end
end

function setMoneyUnloadState()
    if not moneyUnloadTimer and not getElementData(localPlayer,'playerInDead') then
        setElementFrozen(localPlayer, true)
        triggerServerEvent("bankrob > setPedAnimation", resourceRoot, "rob_bank", "cat_safe_rob")
        moneyUnloadTimer = setTimer(function()
            if not isElement(occupiedCol) then 
                safeRobEnd()
                removeEventHandler("onClientRender", root, renderSafeStats)
                unbindKey("e", "up", setMoneyUnloadState)
                return 
            end

            local moneyNow = getElementData(occupiedCol, "bankrob:col:money") 

            if moneyNow <= 0 then 
                safeRobEnd()
            end

            local randMoney = math.random(320, 685)

            if moneyNow - randMoney < 0 then 
                randMoney = moneyNow 
            end

            setElementData(occupiedCol, "bankrob:col:money", moneyNow-randMoney)
            setElementData(localPlayer, "char:money", getElementData(localPlayer, "char:money")+randMoney)
        end, 1000, 0) 
    else 
        safeRobEnd()
    end
end

function safeRobEnd()
    setElementFrozen(localPlayer, false)
    triggerServerEvent("bankrob > setPedAnimation", resourceRoot, "", "")

    if isTimer(moneyUnloadTimer) then 
        killTimer(moneyUnloadTimer)
    end
    moneyUnloadTimer = false
end

--/ Keyboard /--
local keyboardKeys = {"7", "8", "9", "4", "5", "6", "1", "2", "3", "OK", "0", "DEL"}
local keyboardAlphas = {}

for k, v in ipairs(keyboardKeys) do 
    table.insert(keyboardAlphas, {getTickCount(), "close", 0.5, false, 0.5})
end

local keyboardAlpha, keyboardTick, keyboardAnimType = 0, getTickCount(), "open"
local keyboardX, keyboardY = sx*0.5 - (sx*0.122/2), sy*0.3

local keyboardText = ""

function renderKeyboard()
    if keyboardAnimType == "open" then 
        keyboardAlpha = interpolateBetween(keyboardAlpha, 0, 0, 1, 0, 0, (getTickCount() - keyboardTick) / 750, "Linear")
    else
        keyboardAlpha = interpolateBetween(keyboardAlpha, 0, 0, 0, 0, 0, (getTickCount() - keyboardTick) / 750, "Linear")
    end

    dxDrawRectangle(keyboardX, keyboardY, sx*0.122, sy*0.4, tocolor(30, 30, 30, 150*keyboardAlpha))
    dxDrawRectangle(keyboardX + 2/myX*sx, keyboardY + 2/myY*sy, sx*0.122 - 4/myX*sx, sy*0.4 - 4/myY*sy, tocolor(30, 30, 30, 255*keyboardAlpha))

    dxDrawRectangle(keyboardX + 5.5/myX*sx, keyboardY + 5.5/myY*sy, sx*0.122 - 11/myX*sx, sy*0.089, tocolor(32, 32, 32, 255*keyboardAlpha))
    dxDrawText(keyboardText, keyboardX + 5.5/myX*sx, keyboardY + 5.5/myY*sy, keyboardX + 5.5/myX*sx + sx*0.122 - 11/myX*sx, keyboardY + 5.5/myY*sy + sy*0.089, tocolor(255, 255, 255, 220*keyboardAlpha), 0.9/myX*sx, fonts["condensed-25"], "center", "center")

    for k, v in ipairs(keyboardAlphas) do 
        if v[2] == "open" then 
            v[3] = interpolateBetween(v[5], 0, 0, 1, 0, 0, (getTickCount() - v[1]) / 200, "Linear")
        else
            v[3] = interpolateBetween(v[5], 0, 0, 0.5, 0, 0, (getTickCount() - v[1]) / 200, "Linear")
        end
    end

    local keyIndexInRow = 0
    local startX, startY = keyboardX + 5.5/myX*sx, keyboardY + sy*0.1
    for k, v in ipairs(keyboardKeys) do 

        if core:isInSlot(startX, startY, 60/myX*sx, 60/myY*sy) then
            if not keyboardAlphas[k][4] then 
                keyboardAlphas[k][5] = keyboardAlphas[k][3]
                keyboardAlphas[k][4] = true  
                keyboardAlphas[k][1] = getTickCount()
                keyboardAlphas[k][2] = "open"
            end

        else
            if keyboardAlphas[k][4] then 
                keyboardAlphas[k][5] = keyboardAlphas[k][3]
                keyboardAlphas[k][4] = false  
                keyboardAlphas[k][1] = getTickCount()
                keyboardAlphas[k][2] = "close"
            end
        end

        dxDrawRectangle(startX, startY, 60/myX*sx, 60/myY*sy, tocolor(35, 35, 35, 255*keyboardAlpha * keyboardAlphas[k][3]))
        dxDrawRectangle(startX + 2/myX*sx, startY + 2/myY*sy, 60/myX*sx - 4/myX*sx, 60/myY*sy - 4/myY*sy, tocolor(32, 32, 32, 255*keyboardAlpha * keyboardAlphas[k][3]))
        dxDrawText(v, startX, startY, startX + 60/myX*sx, startY + 60/myY*sy, tocolor(255, 255, 255, 255*keyboardAlpha * keyboardAlphas[k][3]), 0.7/myX*sx, fonts["condensed-25"], "center", "center")

        keyIndexInRow = keyIndexInRow + 1

        if keyIndexInRow == 3 then 
            startX = keyboardX + 5/myX*sx
            startY = startY + 62/myY*sy
            keyIndexInRow = 0
        else
            startX = startX + 62/myX*sx
        end
    end

    dxDrawText("Original Security System", keyboardX, keyboardY, keyboardX + sx*0.122, keyboardY + sy*0.3945, tocolor(r, g, b, 255*keyboardAlpha), 0.35/myX*sx, fonts["condensed-25"], "center", "bottom")
end

function keyKeyboard(key, state)
    if state then 
        if key == "backspace" then 
            closeKeyboard()
        elseif key == "mouse1" then 
            local keyIndexInRow = 0
            local startX, startY = keyboardX + 5.5/myX*sx, keyboardY + sy*0.1
            for k, v in ipairs(keyboardKeys) do 

                if core:isInSlot(startX, startY, 60/myX*sx, 60/myY*sy) then
                    if v == "OK" then 
                        if string.len(keyboardText) >= 5 then 
                            if keyboardText == getElementData(resourceRoot, "bankrob:bank:safeDoorCode") then
                                if not getElementData(resourceRoot, "bankrob:bank:bankdoorOpen") then
                                    infobox:outputInfoBox("Megfelelő biztonsági kód! A széfajtó nyitása folyamatban van!", "success")
                                    triggerServerEvent("bankrob > openBigSafeDoor", resourceRoot)
                                end
                            elseif keyboardText == getElementData(resourceRoot, "bankrob:bank:laserToggleCode") then 
                                if getElementData(resourceRoot, "bankrob:bank:bankdoorOpen") then
                                    infobox:outputInfoBox("Megfelelő biztonsági kód! A lézerek kikapcsolása folyamatban van!", "success")

                                    setElementData(resourceRoot, "bankrob:bank:lasersAreActive", false)
                                else
                                    infobox:outputInfoBox("Ez a kód csak a széfajtó kinyitása után használható!", "warning")
                                end
                            else
                                if not getElementData(resourceRoot, "bank:bankInRob:market_ls") then 
                                    triggerServerEvent("banrkob > startBankAlarmSound", resourceRoot, "market_ls")
                                    infobox:outputInfoBox("Hibás biztonsági kód!", "error")
                                end
                            end

                            keyboardText = ""
                        end
                    elseif v == "DEL" then 
                        keyboardText = ""
                    else
                        if string.len(keyboardText) < 5 then 
                            keyboardText = keyboardText .. v
                        end
                    end
                end

                keyIndexInRow = keyIndexInRow + 1

                if keyIndexInRow == 3 then 
                    startX = keyboardX + 5/myX*sx
                    startY = startY + 62/myY*sy
                    keyIndexInRow = 0
                else
                    startX = startX + 62/myX*sx
                end
            end
        end
    end
end

function openKeyboard()
    keyboardText = ""
    addEventHandler("onClientRender", root, renderKeyboard)
    addEventHandler("onClientKey", root, keyKeyboard)
    keyboardTick = getTickCount()
    keyboardAnimType = "open"
end

function closeKeyboard()
    removeEventHandler("onClientKey", root, keyKeyboard)

    keyboardTick = getTickCount()
    keyboardAnimType = "close"

    setTimer(function()
        removeEventHandler("onClientRender", root, renderKeyboard)
    end, 750, 1)
end

local openKeyboardCol = createColTube(1675.6396484375, -1197.1398925781, 18.8, 1, 3)

addEventHandler("onClientColShapeHit", resourceRoot, function(element, mdim)
    if element == localPlayer then 
        if mdim then 
            if source == openKeyboardCol then 
                openKeyboard()
            end
        end
    end
end)

addEventHandler("onClientColShapeLeave", resourceRoot, function(element, mdim)
    if element == localPlayer then 
        if mdim then 
            if source == openKeyboardCol then 
                closeKeyboard()
            end
        end
    end
end)

-- / Laser /

local laserRenderCol = createColCuboid(1667.775390625,-1202.4326171875,18.5, 30, 30, 4.2)

addEventHandler("onClientColShapeHit", resourceRoot, function(player, mdim)
    if player == localPlayer and mdim then 
        if source == laserRenderCol then
            addEventHandler("onClientRender", root, renderLasers)
        end
    end
end)

addEventHandler("onClientColShapeLeave", resourceRoot, function(player, mdim)
    if player == localPlayer and mdim then 
        if source == laserRenderCol then
            removeEventHandler("onClientRender", root, renderLasers)
        end
    end
end)

function renderLasers()
    if getElementData(resourceRoot, "bankrob:bank:lasersAreActive") then 
        --outputChatBox("asd")
        for k, v in ipairs(bigSafeLasers) do 
            dxDrawLine3D(v[1], v[2], v[3], v[4], v[5], v[6], tocolor(220, 0, 0, 100), 2.5)

            if not isLineOfSightClear(v[1], v[2], v[3], v[4], v[5], v[6], false, false, true, false, false) then 
                setElementData(resourceRoot, "bankrob:bank:lasersAreActive", false)
                triggerServerEvent("banrkob > startBankAlarmSound", resourceRoot, "market_ls")
                break
            end
        end
    end

    local alarmTime = getElementData(resourceRoot, "bankrob:bank:alarmTime") or 0
    if alarmTime > 0 then 
        core:dxDrawShadowedText(color..getElementData(resourceRoot, "bankrob:bank:alarmTime").."#ffffffmp a riasztó indulásáig", 0, 0, sx, sy*0.1, tocolor(255, 255, 255, 255), tocolor(0, 0, 0, 255), 0.7/myX*sx, fonts["condensed-25"], "center", "center", false, false, false, true)
    end
end

-- / Jack mission /
local missionElements = {}
local talkSound
local inTalk = false

function startMission(mission)
    missionElements = {}
    outputChatBox("")
    outputChatBox(core:getServerPrefix("server", "Küldetés", 2).."Küldetés elkezdve: "..color..missionTexts[mission]["name"], 255, 255, 255, true)
    outputChatBox(core:getServerPrefix("server", "Küldetés", 2)..missionTexts[mission]["start"], 255, 255, 255, true) 

    --infobox:outputInfoBox("Küldetés elkezdve: "..missionTexts[mission]["name"], "info")

    if mission == "beforeMission" then
        local jack = createPed(104, 1469.6062011719, 351.58010864258, 18.928014755249, 111)
        setElementData(jack, "ped:name", "Jack")
        setElementData(jack, "bankrob:talkPed", "beforeMission_jack")

        local blip = createBlip(1469.6062011719, 351.58010864258, 18.928014755249, 3)
        setElementData(blip, "blip:name", "Jack")

        table.insert(missionElements, jack)
        table.insert(missionElements, blip)
    elseif mission == "startMission" then 
        local jack = createPed(104, 2472.4077148438, -1771.8415527344, 13.563500404358, 180)
        setElementData(jack, "ped:name", "Jack")
        setElementData(jack, "bankrob:talkPed", "startMission_jack")

        local blip = createBlip(2472.4077148438, -1771.8415527344, 13.563500404358, 3)
        setElementData(blip, "blip:name", "Jack")

        table.insert(missionElements, jack)
        table.insert(missionElements, blip)
    elseif mission == "talkWithKlara" then 
        local klara = createPed(77, 1114.2974853516, -1091.9367675781, 26.004482269287, 272)
        setElementData(klara, "ped:name", "Klara")
        setElementData(klara, "bankrob:talkPed", "talkWithKlara")

        local blip = createBlip(1114.2974853516, -1091.9367675781, 26.004482269287, 3)
        setElementData(blip, "blip:name", "Klara")

        table.insert(missionElements, jack)
        table.insert(missionElements, blip)
    end
end
--startMission("talkWithKlara")

addEventHandler("onClientClick", root, function(key, state, _, _, _, _, _, element)
    if element then
        if key == "right" and state == "up" then
            local talkText = getElementData(element, "bankrob:talkPed") or false 
            if not talkText then return end

            if core:getDistance(element, localPlayer) < 3 then 
                if inTalk then return end
                for k, v in ipairs(missionElements) do 
                    if getElementData(v, "ped:name") == "Jack" or getElementData(v, "ped:name") == "Klara" then 
                        startTalk(talkText, v)
                    end
                end
            end
        end
    end
end)

local talkAnimV, talkAnimT, talkAnimS = 0, getTickCount(), "open"
local renderedText, textWait = "", 0

local talkIndex = 1
local startX1, startY1, startZ1, startX2, startY2, startZ2 

function startTalk(talk, element)
    inTalk = true 
    talkSound = playSound("files/missionFiles/music.mp3", true)

    setPedAnimation(element, "GHANDS", "gsign5", -1, true, false, false, false)

    showChat(false)
    exports.oInterface:toggleHud(true)

    local x1, y1, z1, x2, y2, z2 = getCameraMatrix()
    local x3, y3, z3, x4, y4, z4 = unpack(missionCameraPositions[talk])

    startX1, startY1, startZ1, startX2, startY2, startZ2 = x1, y1, z1, x2, y2, z2

    smoothMoveCamera(x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4, 1000)

    setElementAlpha(localPlayer, 0)

    talkAnimV, talkAnimT, talkAnimS = 0, getTickCount(), "open"
    addEventHandler("onClientRender", root, renderTalk)

    talkIndex = 1

    --print(talk)
    processText(talk, talkIndex)
end

function processText(talk, index)
    renderedText = ""
    local text = missionTalks[talk][index]
    local textindex = 1
    setTimer(function()
        renderedText = renderedText .. text:sub(textindex, textindex)
        textindex = textindex + 1
    end, 70, string.len(text))

    setTimer(function()
        talkIndex = talkIndex + 1

        if missionTalks[talk][talkIndex] then 
            processText(talk, talkIndex)
        else
            renderedText = ""
            talkAnimS = getTickCount(), "close"

            local x1, y1, z1, x2, y2, z2 = getCameraMatrix()

            smoothMoveCamera(x1, y1, z1, x2, y2, z2, startX1, startY1, startZ1, startX2, startY2, startZ2, 1000)

            setElementAlpha(localPlayer, 255)

            for k, v in ipairs(missionElements) do 
                if talk == "beforeMission_jack" or talk == "startMission_jack" then 
                    if getElementData(v, "ped:name") or getElementData(v, "blip:name") == "Jack" then 
                        destroyElement(v)
                    end
                end
            end

            destroyElement(talkSound)

            setTimer(function()
                removeEventHandler("onClientRender", root, renderTalk)
                setCameraTarget(localPlayer, localPlayer)
                showChat(true)
                exports.oInterface:toggleHud(false)
                inTalk = false
            end, 1000, 1)
        end
    end, 100 * string.len(text) + 1500, 1)
end

function renderTalk()
    if talkAnimS == "open" then 
        talkAnimV = interpolateBetween(talkAnimV, 0, 0, 1, 0, 0, (getTickCount() - talkAnimT) / 1000, "Linear")
    else
        talkAnimV = interpolateBetween(talkAnimV, 0, 0, 0, 0, 0, (getTickCount() - talkAnimT) / 1000, "Linear")
    end

    dxDrawRectangle(0, 0, sx, sy*0.15 * talkAnimV, tocolor(0, 0, 0, 255))
    dxDrawRectangle(0, sy - (sy*0.15 * talkAnimV), sx, sy*0.15, tocolor(0, 0, 0, 255))
    dxDrawText(renderedText, 0, sy - (sy*0.15 * talkAnimV), sx, sy, tocolor(255, 255, 255, 255), 2, "default-bold", "center", "center")
end

-- /IDG Jack/
local jackPanelAlpha, jackPanelTick, jackPanelAnim = 0, getTickCount(), "open"
local activeJack
local panelShowing = false

function renderJackPanel()
    if activeJack then 
        if core:getDistance(activeJack, localPlayer) > 2 then 
            closeJackPanel()
        end
    end

    if jackPanelAnim == "open" then 
        jackPanelAlpha = interpolateBetween(jackPanelAlpha, 0, 0, 1, 0, 0, (getTickCount() - jackPanelTick)/500, "Linear")
    else
        jackPanelAlpha = interpolateBetween(jackPanelAlpha, 0, 0, 0, 0, 0, (getTickCount() - jackPanelTick)/500, "Linear")
    end

    dxDrawRectangle(sx*0.4, sy*0.4, sx*0.2, sy*0.2, tocolor(30, 30, 30, 200*jackPanelAlpha))
    dxDrawRectangle(sx*0.4 + 2/myX*sx, sy*0.4 + 2/myY*sy, sx*0.2 - 4/myX*sx, sy*0.2 - 4/myY*sy, tocolor(30, 30, 30, 255*jackPanelAlpha))

    if core:isInSlot(sx*0.4 + 6/myX*sx, sy*0.4 + 6/myY*sy, (sx*0.2 - 12/myX*sx) / 2 - 2/myX*sy, sy*0.2 - 12/myY*sy) then 
        dxDrawRectangle(sx*0.4 + 6/myX*sx, sy*0.4 + 6/myY*sy, (sx*0.2 - 12/myX*sx) / 2 - 2/myX*sy, sy*0.2 - 12/myY*sy, tocolor(r, g, b, 100*jackPanelAlpha))
    else
        dxDrawRectangle(sx*0.4 + 6/myX*sx, sy*0.4 + 6/myY*sy, (sx*0.2 - 12/myX*sx) / 2 - 2/myX*sy, sy*0.2 - 12/myY*sy, tocolor(35, 35, 35, 100*jackPanelAlpha))
    end

    dxDrawImage(sx*0.4 + 6/myX*sx + (((sx*0.2 - 12/myX*sx) / 2 - 2/myX*sy)/2) - 41/myX*sx, sy*0.4 + 10/myY*sy, 80/myX*sx, 80/myY*sy, "files/idg_jack/safe.png", 0, 0, 0, tocolor(255, 255, 255, 255*jackPanelAlpha))
    dxDrawText("Széfajtó kód", sx*0.4 + 6/myX*sx, sy*0.4 + 95/myY*sy, sx*0.4 + 6/myX*sx + (sx*0.2 - 12/myX*sx) / 2 - 2/myX*sx, sy*0.4 + 95/myY*sy+sy*0.03, tocolor(255, 255, 255, 255*jackPanelAlpha), 0.4/myX*sx, fonts["condensed-25"], "center", "center")
    dxDrawText("25.000$", sx*0.4 + 6/myX*sx, sy*0.4 + 95/myY*sy + sy*0.03, sx*0.4 + 6/myX*sx + (sx*0.2 - 12/myX*sx) / 2 - 2/myX*sx, sy*0.4 + 95/myY*sy+sy*0.03 + sy*0.03 + sy*0.02, tocolor(r, g, b, 255*jackPanelAlpha), 0.6/myX*sx, fonts["condensed-25"], "center", "center")

    if core:isInSlot(sx*0.4 + 6/myX*sx + (sx*0.2 - 12/myX*sx) / 2, sy*0.4 + 6/myY*sy, (sx*0.2 - 12/myX*sx) / 2 - 2/myX*sy, sy*0.2 - 12/myY*sy) then
        dxDrawRectangle(sx*0.4 + 6/myX*sx + (sx*0.2 - 12/myX*sx) / 2, sy*0.4 + 6/myY*sy, (sx*0.2 - 12/myX*sx) / 2 - 2/myX*sy, sy*0.2 - 12/myY*sy, tocolor(r, g, b, 100*jackPanelAlpha))
    else
        dxDrawRectangle(sx*0.4 + 6/myX*sx + (sx*0.2 - 12/myX*sx) / 2, sy*0.4 + 6/myY*sy, (sx*0.2 - 12/myX*sx) / 2 - 2/myX*sy, sy*0.2 - 12/myY*sy, tocolor(35, 35, 35, 100*jackPanelAlpha))
    end

    dxDrawImage(sx*0.4 + 6/myX*sx + (sx*0.2 - 12/myX*sx) / 2 + (((sx*0.2 - 12/myX*sx) / 2 - 2/myX*sy)/2) - 41/myX*sx, sy*0.4 + 10/myY*sy, 80/myX*sx, 80/myY*sy, "files/idg_jack/security.png", 0, 0, 0, tocolor(255, 255, 255, 255*jackPanelAlpha))
    --dxDrawRectangle(sx*0.4 + 6/myX*sx + (sx*0.2 - 12/myX*sx) / 2, sy*0.4 + 95/myY*sy, (sx*0.2 - 12/myX*sx) / 2 - 2/myX*sx, sy*0.03)
    dxDrawText("Biztonsági lézer kód", sx*0.4 + 6/myX*sx + (sx*0.2 - 12/myX*sx) / 2, sy*0.4 + 95/myY*sy, sx*0.4 + 6/myX*sx + (sx*0.2 - 12/myX*sx) / 2 + (sx*0.2 - 12/myX*sx) / 2 - 2/myX*sx, sy*0.4 + 95/myY*sy+sy*0.03, tocolor(255, 255, 255, 255*jackPanelAlpha), 0.4/myX*sx, fonts["condensed-25"], "center", "center")
    dxDrawText("65.000$", sx*0.4 + 6/myX*sx + (sx*0.2 - 12/myX*sx) / 2, sy*0.4 + 95/myY*sy + sy*0.03, sx*0.4 + 6/myX*sx + (sx*0.2 - 12/myX*sx) / 2 + (sx*0.2 - 12/myX*sx) / 2 - 2/myX*sx, sy*0.4 + 95/myY*sy+sy*0.03 + sy*0.03 + sy*0.02, tocolor(r, g, b, 255*jackPanelAlpha), 0.6/myX*sx, fonts["condensed-25"], "center", "center")
    --dxDrawRectangle(sx*0.4 + 6/myX*sx + (sx*0.2 - 12/myX*sx) / 2, sy*0.4 + 95/myY*sy + sy*0.03, (sx*0.2 - 12/myX*sx) / 2 - 2/myX*sy, sy*0.04)

    if getKeyState("backspace") then 
        closeJackPanel()
    end
end

function jackPanelKey(key, state)
    if key == "mouse1" and state then 
        if core:isInSlot(sx*0.4 + 6/myX*sx, sy*0.4 + 6/myY*sy, (sx*0.2 - 12/myX*sx) / 2 - 2/myX*sy, sy*0.2 - 12/myY*sy) then 
            if getElementData(localPlayer, "char:money") >= 25000 then 
                setElementData(localPlayer, "char:money", getElementData(localPlayer, "char:money") - 25000)
                outputChatBox(core:getServerPrefix("server", "Bankrablás", 2).."A széfajtó nyitásához szükséges kód: "..color..getElementData(resourceRoot, "bankrob:bank:safeDoorCode").."#ffffff. "..color.."(A kódot érdemes a használatáig lementeni illetve figyelni arra, hogy minden rablás után változik!)", 255, 255, 255, true)
                closeJackPanel()
            end
        end

        if core:isInSlot(sx*0.4 + 6/myX*sx + (sx*0.2 - 12/myX*sx) / 2, sy*0.4 + 6/myY*sy, (sx*0.2 - 12/myX*sx) / 2 - 2/myX*sy, sy*0.2 - 12/myY*sy) then 
            if getElementData(localPlayer, "char:money") >= 65000 then 
                setElementData(localPlayer, "char:money", getElementData(localPlayer, "char:money") - 65000)
                outputChatBox(core:getServerPrefix("server", "Bankrablás", 2).."A lézerek kikapcsolásához szükséges kód: "..color..getElementData(resourceRoot, "bankrob:bank:laserToggleCode").."#ffffff. "..color.."(A kódot érdemes a használatáig lementeni illetve figyelni arra, hogy minden rablás után változik!)", 255, 255, 255, true)
                closeJackPanel()
            end
        end
    end
end

function pedClick(key, state, _, _, _, _, _, element)
    if key == "right" and state == "up" and element then 
        if getElementData(element, "idgBankrobCodePed") then 
            if core:getDistance(element, localPlayer) < 2 then
                if exports.oDashboard:isPlayerFactionTypeMember({4, 5}) then
                    if exports.oDashboard:getOnlineFactionTypeMemberCount({1}) >= robStartNeededPoliceCount then
                        if not panelShowing then  
                            activeJack = element
                            openJackPanel()
                        end
                    else
                        outputChatBox(core:getServerPrefix("red-dark", "Bankrablás", 2).."Minimum "..color..robStartNeededPoliceCount.."db #ffffffrendvédelmi tagnak kell online lennie ennek a műveletnek az elvégzéséhez.", 255, 255, 255, true)
                    end
                end
            end
        end
    end
end
addEventHandler("onClientClick", root, pedClick)

function openJackPanel()
    jackPanelTick = getTickCount()
    jackPanelAnim = "open"
    addEventHandler("onClientRender", root, renderJackPanel)
    addEventHandler("onClientKey", root, jackPanelKey)
    panelShowing = true
end

function closeJackPanel()
    if activeJack then
        activeJack = false 
        jackPanelTick = getTickCount()
        jackPanelAnim = "close"

        removeEventHandler("onClientKey", root, jackPanelKey)

        setTimer(function()
            removeEventHandler("onClientRender", root, renderJackPanel)
            panelShowing = false
        end, 500, 1)
    end
end

-- /Smooth camera/
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
	if(sm.moov == 1)then return false end
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
	setTimer(removeCamHandler,time,1)
	setTimer(destroyElement,time,1,sm.object1)
	setTimer(destroyElement,time,1,sm.object2)
	addEventHandler("onClientPreRender",root,camRender)
	return true
end
--
exports.oCompiler:loadCompliedModel(18315, "*CC^g!UCYgV&bngFtnQDA*=3DcgfJ@", ":oBankrob/files/models/drilldff.originalmodel", ":oBankrob/files/models/drilltxd.originalmodel", ":oBankrob/files/models/drillcol.originalmodel", true)
exports.oCompiler:loadCompliedModel(9579, "Q^Mtt$-zJn7^E@Gw", ":oBankrob/files/models/sawdff.originalmodel", ":oBankrob/files/models/sawtxd.originalmodel", false, true)