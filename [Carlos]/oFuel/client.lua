local sx, sy = guiGetScreenSize()
local myX, myY = 1768, 992

local fonts = {
    ["receipt-12"] = dxCreateFont("files/receipt.TTF", 12),
}

local renderedFuelScreens = {}
local shaders = {}

addEventHandler("onClientResourceStart", root, function(res)
	if getResourceName(res) == "oCore" or getResourceName(res) == "oFont" or getResourceName(res) == "oBone" or getResourceName(res) == "oChat" or getResourceName(res) == "oInfobox" or getResourceName(res) == "oFuel" then  
		core = exports.oCore
        color, r, g, b = core:getServerColor()
        font = exports.oFont
        bone = exports.oBone
        chat = exports.oChat
        infobox = exports.oInfobox
	end
end)

function renderFuelStationIDS()
    for k, v in ipairs(getElementsByType("ped", resourceRoot, true)) do 
        if core:getDistance(v, localPlayer) < 5 then 
            if getElementData(v, "fuelStation:id") then 
                local x, y = getScreenFromWorldPosition(getElementPosition(v))

                if x and y then
                    dxDrawText("ID: "..color..getElementData(v, "fuelStation:id"), x, y, 0, 0, tocolor(255, 255, 255, 255), 1, exports.oFont:getFont("condensed", 12), _, _, false, false, false, true)    
                end
            end
        end
    end 

    for k, v in ipairs(getElementsByType("object", resourceRoot, true)) do 
        if core:getDistance(v, localPlayer) < 5 then 
            if getElementData(v, "fuelStation:id") then 
                local x, y = getScreenFromWorldPosition(getElementPosition(v))

                if x and y then
                    dxDrawText("ID: "..color..getElementData(v, "fuelStation:id"), x, y, 0, 0, tocolor(255, 255, 255, 255), 1, exports.oFont:getFont("condensed", 12), _, _, false, false, false, true)    
                end
            end
        end
    end 
end

if getElementData(localPlayer, "user:aduty") then 
    addEventHandler("onClientRender", root, renderFuelStationIDS)
end

addEventHandler("onClientElementDataChange", root, function(data, old, new)
    if source == localPlayer then
        if data == "user:aduty" then 
            if new then 
                addEventHandler("onClientRender", root, renderFuelStationIDS)
            else
                removeEventHandler("onClientRender", root, renderFuelStationIDS)
            end
        end
    end
end)

engineImportTXD(engineLoadTXD("files/models/fuelgun.txd"), 11335)
engineReplaceModel(engineLoadDFF("files/models/fuelgun.dff"), 11335, true)
engineReplaceCOL(engineLoadCOL("files/models/fuelgun.col"), 11335)


local activeGun, activeCol = false, false
local lastGunInteraction = 0
local distanceCheckTimer
local activeFuelMarker, nearestVeh
local fuelingSound
local tankedFuel, activeFuelType, fuelingTimer, usedStationID, fuelPriceMultiplier = 0, false, false, 0, 0
local activePump = false
local activeSide = 0

local receiptDatas = {"", 0, 0, 0, "2020 12 08 17 29", "95"}
local activeCashier

addEventHandler("onClientClick", root, function(key, state, _, _, _, _, _, obj)
    if key == "right" and state == "up" then
        if obj then 
            if core:getDistance(obj, localPlayer) < 2 then
                if getElementData(obj, "fuelStaiton:isGun") then 
                    if lastGunInteraction + 700 < getTickCount() then 
                        if activeGun then 
                            if obj == activeGun then 
                                putBackFuelGun()
                            end
                        else
                            if getElementData(obj, "fuelStation:gunInUse") then return end 

                            nearestVeh = exports.oVehicle:getNearestVehicle(localPlayer, 7)

                            tankedFuel = 0
                            playSound("files/sounds/pickup.mp3")
                            lastGunInteraction = getTickCount()
                            chat:sendLocalMeAction("leemel egy pisztolyt.")
                            activeGun = obj
                            activeFuelType = getElementData(obj, "fuelStaiton:gun:fuelType")
                            setElementData(obj, "fuelStation:gunInUse", true)
                            triggerServerEvent("fuelStation > attachGunToPlayer", resourceRoot, getElementData(obj, "fuelStaiton:col:gun")) 

                            distanceCheckTimer = setTimer(function()
                                if core:getDistance(activeGun, localPlayer) > 4 then 
                                    putBackFuelGun()
                                    infobox:outputInfoBox("Túl messzire mentél a pisztollyal!", "warning")
                                end 
                            end, 200, 0)

                            toggleControl("fire", false)
                            toggleControl("enter_exit", false)

                            fuelPriceMultiplier = getElementData(resourceRoot, "fuelPrice:"..activeFuelType)

                            addEventHandler("onClientRender", root, renderScreen)

                            if isElement(nearestVeh) then
                                if getElementData(nearestVeh, "veh:fuelType") == "electric" then return end

                                usedStationID = getElementData(getElementData(getElementData(activeGun, "fuelStaiton:col:gun"), "fuelStation:pump"), "fuelStation:id")
                                activePump = getElementData(getElementData(activeGun, "fuelStaiton:col:gun"), "fuelStation:pump")
                                activeSide = getElementData(obj, "fuelStaiton:colSide")

                                local x, y, z = getVehicleComponentPosition(nearestVeh, vehicleFuelPositions[getElementModel(nearestVeh)] or "wheel_lb_dummy", "root")
                                activeFuelMarker = createMarker(1, 1, 1, "cylinder", 1, r, g, b, 100)

                                attachElements(activeFuelMarker, nearestVeh, x, y, z - 0.7)
                            end
                        end
                    end
                elseif getElementData(obj, "fuelStation:isCashier") then 
                    if getElementData(obj, "fuelStation:id") == usedStationID then 
                        if tankedFuel > 0 then
                            activeCashier = obj
                            addEventHandler("onClientRender", root, renderReceipt)
                            addEventHandler("onClientKey", root, keyReceipt) 
                            receiptDatas[1] = getElementData(obj, "fuelStation:name") .. " ORP.NUM.:22535bD6Mg5"
                            receiptDatas[2] = tankedFuel
                            receiptDatas[3] = fuelPriceMultiplier * tankedFuel
                            receiptDatas[4] = math.ceil(receiptDatas[3]*0.05)
                            receiptDatas[5] = string.format("%04d %02d %02d %02d %02d", core:getDate("year"), core:getDate("month"), core:getDate("monthday"), core:getDate("hour"), core:getDate("minute"))
                            receiptDatas[6] = activeFuelType
                        end
                    end
                end
            end
        end
    end
end)

function putBackFuelGun()
    if isTimer(distanceCheckTimer) then killTimer(distanceCheckTimer) end
    lastGunInteraction = getTickCount()
    chat:sendLocalMeAction("visszaakasztja a pisztolyt.")
    triggerServerEvent("fuelStation > attachGunToFuelPump", resourceRoot, getElementData(activeGun, "fuelStaiton:col:gun")) 
    setElementData(activeGun, "fuelStation:gunInUse", false)
    activeGun = false
    toggleControl("fire", true)
    toggleControl("enter_exit", true)
    if activeFuelMarker then destroyElement(activeFuelMarker) end
    playSound("files/sounds/pickup.mp3")
    removeEventHandler("onClientRender", root, renderScreen)
end

local renderTargets = {
    dxCreateRenderTarget(200, 30),
    dxCreateRenderTarget(200, 30),
    dxCreateRenderTarget(200, 30),
}

function renderScreen()
    dxSetRenderTarget(renderTargets[1], true)
        dxDrawRectangle(0, 0, 200, 30, tocolor(30, 30, 30, 255))
        dxDrawText(tankedFuel.."L", 0, 0, 200, 30, tocolor(255, 255, 255), 1, "default-bold", "center", "center")
    dxSetRenderTarget()

    dxSetRenderTarget(renderTargets[2], true)
        dxDrawRectangle(0, 0, 200, 30, tocolor(30, 30, 30, 255))
        dxDrawText(fuelPriceMultiplier * tankedFuel.."$", 0, 0, 200, 30, tocolor(255, 255, 255), 1, "default-bold", "center", "center")
    dxSetRenderTarget()

    dxSetRenderTarget(renderTargets[3], true)
        dxDrawRectangle(0, 0, 200, 30, tocolor(30, 30, 30, 255))
        dxDrawText("Dízel: "..getElementData(resourceRoot, "fuelPrice:D") .. "$/L | Benzin: "..getElementData(resourceRoot, "fuelPrice:95").."$/L", 0, 0, 200, 30, tocolor(255, 255, 255), 1, "default-bold", "center", "center")
    dxSetRenderTarget()
end

addEventHandler("onClientMarkerHit", root, function(player, mdim)
    if player == localPlayer then 
        if mdim then 
            if source == activeFuelMarker then 
                bindKey("mouse1", "down", startVehFueling)
                bindKey("mouse1", "up", endVehFueling)
            elseif source == activeFuelCanMarker then 
                bindKey("mouse1", "down", startVehFuelingCan)
                bindKey("mouse1", "up", endVehFuelingCan)
            end
        end
    end
end)

addEventHandler("onClientMarkerLeave", root, function(player, mdim)
    if player == localPlayer then 
        if mdim then 
            if source == activeFuelMarker then 
                unbindKey("mouse1", "down", startVehFueling)
                unbindKey("mouse1", "up", endVehFueling)
            elseif source == activeFuelCanMarker then 
                unbindKey("mouse1", "down", startVehFuelingCan)
                unbindKey("mouse1", "up", endVehFuelingCan)
            end
        end
    end
end)

local lastStart = 0
function startVehFueling()
    if lastStart + 400 < getTickCount() then 
        if not getVehicleEngineState(nearestVeh) then
            if getElementData(nearestVeh, "veh:fuel") + tankedFuel < getElementData(nearestVeh, "veh:maxFuel") then
                triggerServerEvent("fuelStation > setPedAnimationOnServer", resourceRoot, "sword", "sword_idle")
                fuelingSound = playSound("files/sounds/fueling.mp3", true)
                lastStart = getTickCount()

                fuelingTimer = setTimer(function()
                    if getElementData(nearestVeh, "veh:fuel") + tankedFuel < getElementData(nearestVeh, "veh:maxFuel") then
                        tankedFuel = tankedFuel + 1
                        
                        if activeSide < 3 then 
                            shaders[1] = dxCreateShader("files/textureChanger.fx", 0, 100, false, "all")
                            engineApplyShaderToWorldTexture(shaders[1], "screen4", activePump)
                            dxSetShaderValue(shaders[1], "gTexture", renderTargets[1])

                            shaders[2] = dxCreateShader("files/textureChanger.fx", 0, 100, false, "all")
                            engineApplyShaderToWorldTexture(shaders[2], "screen5", activePump)
                            dxSetShaderValue(shaders[2], "gTexture", renderTargets[2])
                        else
                            shaders[1] = dxCreateShader("files/textureChanger.fx", 0, 100, false, "all")
                            engineApplyShaderToWorldTexture(shaders[1], "screen1", activePump)
                            dxSetShaderValue(shaders[1], "gTexture", renderTargets[1])

                            shaders[2] = dxCreateShader("files/textureChanger.fx", 0, 100, false, "all")
                            engineApplyShaderToWorldTexture(shaders[2], "screen2", activePump)
                            dxSetShaderValue(shaders[2], "gTexture", renderTargets[2])
                        end

                        shaders[3] = dxCreateShader("files/textureChanger.fx", 0, 100, false, "all")
                        engineApplyShaderToWorldTexture(shaders[3], "screen3", activePump)
                        dxSetShaderValue(shaders[3], "gTexture", renderTargets[3])
                    else
                        infobox:outputInfoBox("Tele van a jármű tankja!", "success")
                        endVehFueling()
                    end
                end, 1000, 0)
            else
                infobox:outputInfoBox("Tele van a jármű tankja!", "warning")
            end
        else
            infobox:outputInfoBox("Járó motorral nem tankolhatsz!", "error")
        end
    end
end

function endVehFueling()
    if isElement(fuelingSound) then destroyElement(fuelingSound) end
    if isTimer(fuelingTimer) then killTimer(fuelingTimer) end
    triggerServerEvent("fuelStation > setPedAnimationOnServer", resourceRoot, "", "")
end

function startVehFuelingCan()
    if lastStart + 400 < getTickCount() then 
        if not getVehicleEngineState(nearestVeh) then
            if tonumber(getElementData(nearestVeh, "veh:fuel")) < tonumber(getElementData(nearestVeh, "veh:maxFuel")) then
                if getElementData(localPlayer, "availableFuelInCan") > 0 then
                    triggerServerEvent("fuelStation > setPedAnimationOnServer", resourceRoot, "sword", "sword_idle")
                    lastStart = getTickCount()

                    fuelingTimer = setTimer(function()
                        if tonumber(getElementData(nearestVeh, "veh:fuel")) < tonumber(getElementData(nearestVeh, "veh:maxFuel")) then
                            if getElementData(localPlayer, "availableFuelInCan") > 0 then
                                setElementData(localPlayer, "availableFuelInCan", getElementData(localPlayer, "availableFuelInCan") - 1)
                                setElementData(nearestVeh, "veh:fuel", getElementData(nearestVeh, "veh:fuel") + 1)
                                setElementData(nearestVeh, "veh:lastFuelType", getElementData(localPlayer, "petrolCanType"))
                            else
                                infobox:outputInfoBox("Kifogyott a benzin a kannából!", "warning")
                                endVehFuelingCan()
                            end
                        else
                            infobox:outputInfoBox("Tele van a jármű tankja!", "success")
                            endVehFuelingCan()
                        end
                    end, 1000, 0)
                end
            else
                infobox:outputInfoBox("Tele van a jármű tankja!", "warning")
            end
        else
            infobox:outputInfoBox("Járó motorral nem tankolhatsz!", "error")
        end
    end
end

function endVehFuelingCan()
    if isTimer(fuelingTimer) then killTimer(fuelingTimer) end
    triggerServerEvent("fuelStation > setPedAnimationOnServer", resourceRoot, "", "")
    unbindKey("mouse1", "down", startVehFuelingCan)
    unbindKey("mouse1", "up", endVehFuelingCan)
end

local fuelPumps = {}
local addedRender = false

addEventHandler("onClientElementStreamIn", root, function()
    if getElementModel(source) == 11335 then 
        if (getElementData(source, "fuelStation:pump") or false) then 
            table.insert(fuelPumps, source)
            if not addedRender then 
                addedRender = true 
                addEventHandler("onClientRender", root, renderFuelPumpPipes)
            end
        end
    end
end)

addEventHandler("onClientElementStreamOut", root, function()
    if getElementModel(source) == 11335 then 
        if (getElementData(source, "fuelStation:pump") or false) then 
            for k, v in pairs(fuelPumps) do 
                if v == source then 
                    table.remove(fuelPumps, k)
                    break
                end
            end

            if #fuelPumps <= 0 then 
                if addedRender then
                    addedRender = false
                    removeEventHandler("onClientRender", root, renderFuelPumpPipes)
                end
            end        
        end
    end
end)

function renderFuelPumpPipes()
    for k, v in pairs(fuelPumps) do 
        local pump = getElementData(v, "fuelStation:pump") or false
        if pump then    
            local x, y, z = getElementPosition(v)
            local x2, y2, z2 = core:getPositionFromElementOffset(pump, unpack(gasPumpPipePositions[getElementData(v, "fuelStation:gun:id")]))
            exports.oRope:renderRope(x2, y2, z2, x, y, z, 20)
        end
    end
end

function renderReceipt()
    if core:getDistance(activeCashier, localPlayer) > 2 then
        removeEventHandler("onClientRender", root, renderReceipt) 
        removeEventHandler("onClientKey", root, keyReceipt) 
    end

    dxDrawImage(sx/2 - 243/myX*sx*0.9/2, sy/2 - 368/myY*sy*0.9/2, 243/myX*sx*0.9, 368/myY*sy*0.9, "files/receipt.png")

    dxDrawText(receiptDatas[2].."l "..string.upper(receiptDatas[6]).."  "..receiptDatas[3].."$", sx/2 - 243/myX*sx*0.9/2 + sx*0.06, sy/2 - 368/myY*sy*0.9/2 + sy*0.065, sx/2 - 243/myX*sx*0.9/2 + sx*0.06+sx*0.05, sy/2 - 368/myY*sy*0.9/2 + sy*0.065+sy*0.025, tocolor(0, 0, 0, 210), 0.85/myX*sx, fonts["receipt-12"], "right", "center")
    dxDrawText(receiptDatas[4].."$", sx/2 - 243/myX*sx*0.9/2 + sx*0.06, sy/2 - 368/myY*sy*0.9/2 + sy*0.09, sx/2 - 243/myX*sx*0.9/2 + sx*0.06+sx*0.05, sy/2 - 368/myY*sy*0.9/2 + sy*0.09+sy*0.025, tocolor(0, 0, 0, 210), 0.85/myX*sx, fonts["receipt-12"], "right", "center")
    dxDrawText(receiptDatas[4]+receiptDatas[3].."$", sx/2 - 243/myX*sx*0.9/2 + sx*0.06, sy/2 - 368/myY*sy*0.9/2 + sy*0.15, sx/2 - 243/myX*sx*0.9/2 + sx*0.06+sx*0.05, sy/2 - 368/myY*sy*0.9/2 + sy*0.15+sy*0.025, tocolor(0, 0, 0, 210), 0.85/myX*sx, fonts["receipt-12"], "right", "center")

    dxDrawText(receiptDatas[5], sx/2 - 243/myX*sx*0.9/2 + sx*0.06, sy/2 - 368/myY*sy*0.9/2 + sy*0.25, sx/2 - 243/myX*sx*0.9/2 + sx*0.06+sx*0.05, sy/2 - 368/myY*sy*0.9/2 + sy*0.25+sy*0.025, tocolor(0, 0, 0, 210), 0.8/myX*sx, fonts["receipt-12"], "right", "bottom")
    dxDrawText(receiptDatas[1], sx/2 - 243/myX*sx*0.9/2, sy/2 - 368/myY*sy*0.9/2 + sy*0.31, sx/2 - 243/myX*sx*0.9/2+243/myX*sx*0.9, sy/2 - 368/myY*sy*0.9/2 + sy*0.31+sy*0.02, tocolor(0, 0, 0, 100), 0.65/myX*sx, fonts["receipt-12"], "center", "bottom")
   
    if core:isInSlot(sx/2 - 243/myX*sx*0.9/2, sy/2 - 368/myY*sy*0.9/2 + 368/myY*sy*0.9 + sy*0.01, 243/myX*sx*0.9, sy*0.03) then
        dxDrawRectangle(sx/2 - 243/myX*sx*0.9/2, sy/2 - 368/myY*sy*0.9/2 + 368/myY*sy*0.9 + sy*0.01, 243/myX*sx*0.9, sy*0.03, tocolor(r, g, b, 180))
        dxDrawRectangle(sx/2 - 243/myX*sx*0.9/2 + 2/myX*sx, sy/2 - 368/myY*sy*0.9/2 + 368/myY*sy*0.9 + sy*0.01 + 2/myY*sy, 243/myX*sx*0.9 - 4/myX*sx, sy*0.03 - 4/myY*sy, tocolor(r, g, b, 240))
    else
        dxDrawRectangle(sx/2 - 243/myX*sx*0.9/2, sy/2 - 368/myY*sy*0.9/2 + 368/myY*sy*0.9 + sy*0.01, 243/myX*sx*0.9, sy*0.03, tocolor(r, g, b, 120))
        dxDrawRectangle(sx/2 - 243/myX*sx*0.9/2 + 2/myX*sx, sy/2 - 368/myY*sy*0.9/2 + 368/myY*sy*0.9 + sy*0.01 + 2/myY*sy, 243/myX*sx*0.9 - 4/myX*sx, sy*0.03 - 4/myY*sy, tocolor(r, g, b, 180))
    end

    dxDrawText("Fizetés ("..receiptDatas[4]+receiptDatas[3].."$)", sx/2 - 243/myX*sx*0.9/2, sy/2 - 368/myY*sy*0.9/2 + 368/myY*sy*0.9 + sy*0.01, sx/2 - 243/myX*sx*0.9/2 + 243/myX*sx*0.9, sy/2 - 368/myY*sy*0.9/2 + 368/myY*sy*0.9 + sy*0.01 + sy*0.032, tocolor(240, 240, 240, 255), 1, font:getFont("condensed", 10/myX*sx), "center", "center")

    if core:isInSlot(sx/2 - 243/myX*sx*0.9/2, sy/2 - 368/myY*sy*0.9/2 + 368/myY*sy*0.9 + sy*0.042, 243/myX*sx*0.9, sy*0.03) then
        dxDrawRectangle(sx/2 - 243/myX*sx*0.9/2, sy/2 - 368/myY*sy*0.9/2 + 368/myY*sy*0.9 + sy*0.042, 243/myX*sx*0.9, sy*0.03, tocolor(235, 64, 52, 180))
        dxDrawRectangle(sx/2 - 243/myX*sx*0.9/2 + 2/myX*sx, sy/2 - 368/myY*sy*0.9/2 + 368/myY*sy*0.9 + sy*0.042 + 2/myY*sy, 243/myX*sx*0.9 - 4/myX*sx, sy*0.03 - 4/myY*sy, tocolor(235, 64, 52, 240))
    else
        dxDrawRectangle(sx/2 - 243/myX*sx*0.9/2, sy/2 - 368/myY*sy*0.9/2 + 368/myY*sy*0.9 + sy*0.042, 243/myX*sx*0.9, sy*0.03, tocolor(235, 64, 52, 120))
        dxDrawRectangle(sx/2 - 243/myX*sx*0.9/2 + 2/myX*sx, sy/2 - 368/myY*sy*0.9/2 + 368/myY*sy*0.9 + sy*0.042 + 2/myY*sy, 243/myX*sx*0.9 - 4/myX*sx, sy*0.03 - 4/myY*sy, tocolor(235, 64, 52, 180))
    end

    dxDrawText("Mégsem", sx/2 - 243/myX*sx*0.9/2, sy/2 - 368/myY*sy*0.9/2 + 368/myY*sy*0.9 + sy*0.042, sx/2 - 243/myX*sx*0.9/2 + 243/myX*sx*0.9, sy/2 - 368/myY*sy*0.9/2 + 368/myY*sy*0.9 + sy*0.042 +sy*0.032, tocolor(240, 240, 240, 255), 1, font:getFont("condensed", 10/myX*sx), "center", "center")
end

function keyReceipt(key, state)
    if key == "mouse1" and state then 
        if core:isInSlot(sx/2 - 243/myX*sx*0.9/2, sy/2 - 368/myY*sy*0.9/2 + 368/myY*sy*0.9 + sy*0.01, 243/myX*sx*0.9, sy*0.03) then
            if getElementData(localPlayer, "char:money") >= (receiptDatas[4]+receiptDatas[3]) then 
                setElementData(localPlayer, "char:money", getElementData(localPlayer, "char:money") - (receiptDatas[4]+receiptDatas[3]))
                setElementData(nearestVeh, "veh:fuel", math.floor(getElementData(nearestVeh, "veh:fuel") + tankedFuel))
                setElementData(nearestVeh, "veh:lastFuelType", activeFuelType)

                tankedFuel = 0
                removeEventHandler("onClientRender", root, renderReceipt) 
                removeEventHandler("onClientKey", root, keyReceipt) 

                infobox:outputInfoBox("Kifizetted a tankolást!", "success")
            else
                infobox:outputInfoBox("Nincs elég pénzed! ("..receiptDatas[4]+receiptDatas[3].."$)", "error")
            end
        end

        if core:isInSlot(sx/2 - 243/myX*sx*0.9/2, sy/2 - 368/myY*sy*0.9/2 + 368/myY*sy*0.9 + sy*0.042, 243/myX*sx*0.9, sy*0.03) then
            tankedFuel = 0
            nearestVeh = false 
            removeEventHandler("onClientRender", root, renderReceipt) 
            removeEventHandler("onClientKey", root, keyReceipt) 

            infobox:outputInfoBox("Elutasítottad a tankolást!", "info")
        end
    end
end

-- benzines kanna 
function createFuelMarker()
    nearestVeh = exports.oVehicle:getNearestVehicle(localPlayer, 7)

    if isElement(nearestVeh) then
        if getElementData(nearestVeh, "veh:fuelType") == "electric" then return end
        local x, y, z = getVehicleComponentPosition(nearestVeh, vehicleFuelPositions[getElementModel(nearestVeh)] or "wheel_lb_dummy", "root")
        activeFuelCanMarker = createMarker(1, 1, 1, "cylinder", 1, r, g, b, 100)
        setElementDimension(activeFuelCanMarker, getElementDimension(localPlayer))
        setElementInterior(activeFuelCanMarker, getElementInterior(localPlayer))

        attachElements(activeFuelCanMarker, nearestVeh, x, y, z - 0.7)
    end
end

function destroyFuelMarker()
    if isElement(activeFuelCanMarker) then
        destroyElement(activeFuelCanMarker)
    end
end