addEventHandler("onClientResourceStart", root, function(res)
	if getResourceName(res) == "oCore" or getResourceName(res) == "oFont" or getResourceName(res) == "oBone" or getResourceName(res) == "oChat" or getResourceName(res) == "oInfobox" or getResourceName(res) == "oTeslaChargera" then  
		core = exports.oCore
        color, r, g, b = core:getServerColor()
        font = exports.oFont
        bone = exports.oBone
        chat = exports.oChat
        infobox = exports.oInfobox
	end
end)

local fuelPumps = {}
local addedRender = false

addEventHandler("onClientElementStreamIn", root, function()
    if getElementModel(source) == 10986 then 
        if (getElementData(source, "teslaCharger:isCharger") or false) then 
            table.insert(fuelPumps, source)
            if not addedRender then
                addedRender = true 
                createRender("renderFuelPumpPipes", renderFuelPumpPipes)

            end
        end
    end
end)

addEventHandler("onClientElementStreamOut", root, function()
    if getElementModel(source) == 10986 then 
        if (getElementData(source, "teslaCharger:isCharger") or false) then 
            for k, v in pairs(fuelPumps) do 
                if v == source then 
                    table.remove(fuelPumps, k)
                    break
                end
            end

            if #fuelPumps <= 0 then 
                if addedRender then
                    addedRender = false
                    destroyRender("renderFuelPumpPipes")
                end
            end        
        end
    end
end)

addEventHandler("onClientElementDestroy", resourceRoot, function()
    if getElementModel(source) == 10986 then 
        if (getElementData(source, "teslaCharger:isCharger") or false) then 
            for k, v in pairs(fuelPumps) do 
                if v == source then 
                    table.remove(fuelPumps, k)
                    break
                end
            end

            if #fuelPumps <= 0 then 
                if addedRender then
                    addedRender = false
                    destroyRender("renderFuelPumpPipes")
                end
            end        
        end
    end
end)

local tempChargerObj = nil
local inCreate = false
local blipType = 0

function createTeslaCharger()
    if isElement(tempChargerObj) then 
        local x, y, z =  getElementPosition(localPlayer)
        setElementPosition(tempChargerObj, x, y, z - 0.55)
        setElementRotation(tempChargerObj, getElementRotation(localPlayer))

        if getKeyState("lalt") then 
            local posX, posY, posZ = getElementPosition(tempChargerObj)
            local rotX, rotY, rotZ = getElementRotation(tempChargerObj)
            local dim, int = getElementDimension(tempChargerObj), getElementInterior(tempChargerObj)

            local table = {posX, posY, posZ, rotX, rotY, rotZ, dim, int}
            inCreate = false 

            if isElement(tempChargerObj) then destroyElement(tempChargerObj) end 
            destroyRender("createTeslaCharger")

            triggerServerEvent("teslaCharger > createCharger", resourceRoot, table, blipType)
        end
    end
end

addCommandHandler("createcharger", function(cmd, hasBlip)
    if getElementData(localPlayer, "user:admin") >= 8 then 
        if inCreate then
            if isElement(tempChargerObj) then destroyElement(tempChargerObj) end 
            destroyRender("createTeslaCharger")

        else
            if hasBlip then 
                hasBlip = tonumber(hasBlip)

                if hasBlip == 0 or hasBlip == 1 then 
                    inCreate = true
                    blipType = hasBlip
                    tempChargerObj = createObject(10986, getElementPosition(localPlayer))
                    setElementAlpha(tempChargerObj, 150)
                    setElementDimension(tempChargerObj, getElementDimension(localPlayer))
                    setElementInterior(tempChargerObj, getElementInterior(localPlayer))
                    setElementCollisionsEnabled(tempChargerObj, false)
                    createRender("createTeslaCharger", createTeslaCharger)

                    outputChatBox(core:getServerPrefix("server", "Tesla Charger", 2).."Beléptél a pozícionáló módba. Kilépéshez írd be a /createcharger paranacsot. Lerakáshoz nyomd meg az [ALT] gombot.", 255, 255, 255, true)
                end
            else
                outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [Blip (0: Nem, 1: Igen)]", 255, 255, 255, true)
            end
        end
    end
end)

local showChargerIDS = false 

function renderIDS()
    for k, v in ipairs(getElementsByType("object", resourceRoot, true)) do 
        if core:getDistance(localPlayer, v) <= 10 then 
            local x, y, z = getElementPosition(v)

            local posx, posy = getScreenFromWorldPosition(x, y, z)

            if posx and posy then 
                local id = getElementData(v, "teslaCharger:id") 

                if id then
                    dxDrawText("#"..id, posx, posy, _, _, tocolor(255, 0, 0), 3, "default-bold")
                end
            end
        end
    end
end

addCommandHandler("showchargerid", function(cmd)
    if getElementData(localPlayer, "user:admin") >= 2 then 
        showChargerIDS = not showChargerIDS 

        if showChargerIDS then 
            createRender("renderIDS", renderIDS)

        else
            destroyRender("renderIDS")
        end
    end
end)

function renderFuelPumpPipes()
    for k, v in pairs(fuelPumps) do 
        --if isElement(v) then
            local head = getElementData(v, "teslaCharger:chargerHead") or false
            if head then    
                local x, y, z = core:getPositionFromElementOffset(v, 0.45, 0, 0.65)
                local x2, y2, z2 = core:getPositionFromElementOffset(head, 0, 0.02, 0)
                exports.oRope:renderRope(x2, y2, z2, x, y, z, 20)
            end
        --end
    end
end

local headInHand = false
local lastClick = 0
local distanceCheckTimer = false
local exportElement

setElementData(localPlayer, "teslaChargerInHand", false)
addEventHandler("onClientClick", root, function(key, state, _, _, _, _, _, element)
    if key == "right" and state == "up" and element then 
        if getElementData(element, "teslaCharger:col:realHead") then 
            if core:getDistance(localPlayer, element) < 2 then 
                if not getElementData(element, "teslaCharger:col:inUse") then 
                    if getElementData(localPlayer, "teslaChargerInHand") then return end
                    if lastClick + 1000 > getTickCount() then return end
                    if getPedOccupiedVehicle(localPlayer) then return end
                    lastClick = getTickCount()
                    setElementData(element, "teslaCharger:col:inUse", true)
                    headInHand = element
                    setElementData(localPlayer, "teslaChargerInHand", true)
                    triggerServerEvent("teslaCharger > giveChargerHeadToPlayer", resourceRoot, getElementData(element, "teslaCharger:col:realHead"))
                    exportElement = element 

                    chat:sendLocalMeAction("leemel egy töltőfejet.")

                    toggleControl("enter_exit", false)
                    
                    distanceCheckTimer = setTimer(function()
                        if core:getDistance(localPlayer, headInHand) > 4.5 then 
                            lastClick = getTickCount()

                            if isTimer(distanceCheckTimer) then killTimer(distanceCheckTimer) end 

                            infobox:outputInfoBox("Túl távolra mentél, ezért a töltőfej visszakerült a töltőre!", "warning")

                            chat:sendLocalMeAction("visszatesz egy töltőfejet.")

                            toggleControl("enter_exit", true)
            
                            setElementData(element, "teslaCharger:col:inUse", false)
                            setElementData(localPlayer, "teslaChargerInHand", false)
                            headInHand = false
                            triggerServerEvent("teslaCharger > removeChargerHeadFromPlayer", resourceRoot, getElementData(element, "teslaCharger:col:realHead"), element)
                        end
                    end, 200, 0)
                elseif element == headInHand then 
                    if lastClick + 1000 > getTickCount() then return end
                    lastClick = getTickCount()

                    if isTimer(distanceCheckTimer) then killTimer(distanceCheckTimer) end 

                    chat:sendLocalMeAction("visszatesz egy töltőfejet.")

                    setElementData(element, "teslaCharger:col:inUse", false)
                    setElementData(localPlayer, "teslaChargerInHand", false)

                    toggleControl("enter_exit", true)
                    headInHand = false
                    triggerServerEvent("teslaCharger > removeChargerHeadFromPlayer", resourceRoot, getElementData(element, "teslaCharger:col:realHead"), element)
                end
            end
        end
    end
end)

function addTeslaChargerToVeh(veh)
    if not getVehicleEngineState(veh) then 
        if not (getElementData(veh, "veh:locked")) then 
            chat:sendLocalMeAction("feltesz egy autót a töltőre.")
            triggerServerEvent("teslaCharger > addTeslaChargerToVeh", resourceRoot, veh, getElementModel(veh), getElementData(headInHand, "teslaCharger:col:realHead"))

            if isTimer(distanceCheckTimer) then killTimer(distanceCheckTimer) end 
            setElementData(localPlayer, "teslaChargerInHand", false)
            toggleControl("enter_exit", true)
            
            headInHand = false
        else
            outputChatBox(core:getServerPrefix("red-dark", "Töltés", 2).."Először nyisd ki a járműved!", 255, 255, 255, true)
        end
    else
        outputChatBox(core:getServerPrefix("red-dark", "Töltés", 2).."Először állítsd le a jármű motorját!", 255, 255, 255, true)
    end
end

function removeTeslaChargerToVeh(veh)
    if not isntmessage then 
        isntmessage = false 
    end

    if not (getElementData(veh, "veh:locked")) then
        if not isntmessage then
            chat:sendLocalMeAction("levesz egy autót a töltőről.")
        end

        local head = getElementData(veh, "vehicleInTeslaCharger")
        headInHand = getElementData(head, "teslaCharger:chargerBody")
        triggerServerEvent("teslaCharger > removeTeslaChargerToVeh", resourceRoot, veh)

        setElementData(localPlayer, "teslaChargerInHand", true)
        toggleControl("enter_exit", false)

        triggerServerEvent("teslaCharger > giveChargerHeadToPlayer", resourceRoot, head)

        distanceCheckTimer = setTimer(function()
            if core:getDistance(localPlayer, headInHand) > 4.5 then 
                lastClick = getTickCount()

                if isTimer(distanceCheckTimer) then killTimer(distanceCheckTimer) end 

                infobox:outputInfoBox("Túl távolra mentél, ezért a töltőfej visszakerült a töltőre!", "warning")

                chat:sendLocalMeAction("visszatesz egy töltőfejet.")

                setElementData(element, "teslaCharger:col:inUse", false)
                setElementData(localPlayer, "teslaChargerInHand", false)
                headInHand = false
                triggerServerEvent("teslaCharger > removeChargerHeadFromPlayer", resourceRoot, head, headInHand)
            end
        end, 200, 0)
    else
        outputChatBox(core:getServerPrefix("red-dark", "Töltés", 2).."Először nyisd ki a járműved!", 255, 255, 255, true)
    end
end

renderTimers = {}

function createRender(id, func)
    if not isTimer(renderTimers[id]) then
        renderTimers[id] = setTimer(func, 5, 0)
    end
end

function destroyRender(id)
    if isTimer(renderTimers[id]) then
        killTimer(renderTimers[id])
        renderTimers[id] = nil
        collectgarbage("collect")
    end
end

function checkRender(id)
    return renderTimers[id]
end