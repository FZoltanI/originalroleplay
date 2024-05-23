local sx, sy = guiGetScreenSize() 
local myX, myY = 1600, 900

local elementeditor = exports.oElementEditor
local admin = exports.oAdmin

local gateCache 
local gatePositions = {
    ["close"] = {},
    ["open"] = {},
}

local positionState = 1
local selectedGate = 1

local fonts = {
    ["condensed-11"] = exports.oFont:getFont("condensed", 11),
}

local menus = {"Zárási pozíció", "Nyitási pozíció", "Kapu modell"}

function renderGatePosingPanel() 
    dxDrawRectangle(sx*0.35, sy*0.01, sx*0.3, sy*0.04, tocolor(50, 50, 50, 255))

    local startX = sx*0.352
    for i = 1, 3 do 

        if positionState == i then 
            dxDrawRectangle(startX, sy*0.012, sx*0.098, sy*0.035, tocolor(r, g, b, 150))
        else
            dxDrawRectangle(startX, sy*0.012, sx*0.098, sy*0.035, tocolor(35, 35, 35, 255))
        end

        local text = menus[i]
        local textsize = 1
        if i == 3 then 
            text = gates[selectedGate][2].."("..gates[selectedGate][1]..")"
            textsize = 0.8
        end 

        dxDrawText(text, startX, sy*0.012, startX+sx*0.098, sy*0.012+sy*0.035, tocolor(220, 220, 220, 255), textsize/myX*sx, fonts["condensed-11"], "center", "center")
        startX = startX + sx*0.099
    end
end

function panelClick(key, state)
    if key == "mouse1" then 
        if state then 
            local startX = sx*0.352
            for i = 1, 3 do 

                if core:isInSlot(startX, sy*0.012, sx*0.098, sy*0.035) then 
                    if i == 1 or i == 2 then 
                        --positionState = i

                    elseif i == 3 then 
                        if selectedGate < #gates then 
                            selectedGate = selectedGate + 1
                        else
                            selectedGate = 1
                        end

                        changeGateCacheModel()
                    end
                end
        
                startX = startX + sx*0.099
            end
        end
    end
end

function changeGateCacheModel()
    --elementeditor:quitEditor()

    local x, y, z = getElementPosition(gateCache)
    local rotx, roty, rotz = getElementRotation(gateCache)

    if isElement(gateCache) then 
        destroyElement(gateCache)
        gateCache = false 
    end

    gateCache = createObject(gates[selectedGate][1], x, y, z, rotx, roty, rotz)

    setElementInterior(gateCache, getElementInterior(localPlayer))
    setElementDimension(gateCache, getElementDimension(localPlayer))

    --setElementAlpha(gateCache, 950)
    setElementCollisionsEnabled(gateCache, false)

    elementeditor:toggleEditor(gateCache, "saveGate", "endGateEdit")
end

function startGateCreating()
    if getElementData(localPlayer, "user:admin") >= 7 then 
        selectedGate = 1
        if isElement(gateCache) then 
            destroyElement(gateCache)
            gateCache = false 
        end

        local playerPos = Vector3(getElementPosition(localPlayer))
        gateCache = createObject(969, playerPos.x, playerPos.y, playerPos.z)

        setElementInterior(gateCache, getElementInterior(localPlayer))
        setElementDimension(gateCache, getElementDimension(localPlayer))

        --setElementAlpha(gateCache, 950)
        setElementCollisionsEnabled(gateCache, false)

        elementeditor:toggleEditor(gateCache, "saveGate", "endGateEdit")

        addEventHandler("onClientRender", root, renderGatePosingPanel)
        addEventHandler("onClientKey", root, panelClick)

        outputChatBox(core:getServerPrefix("server", "Kapu", 2).."Állítsd be a kapu "..color.."Zárási#ffffff pozícióját.", 255, 255, 255, true)
    end
end 
addCommandHandler("makegate", startGateCreating)
addCommandHandler("addgate", startGateCreating)
addCommandHandler("creategate", startGateCreating)
admin:addAdminCMD("makegate", 7, "Kapu létrehozása")
admin:addAdminCMD("creategate", 7, "Kapu létrehozása")
admin:addAdminCMD("addgate", 7, "Kapu létrehozása")

addEvent("saveGate", true)
addEventHandler("saveGate", root, function() 
    if positionState == 1 then 
        gatePositions["close"]["x"], gatePositions["close"]["y"], gatePositions["close"]["z"] = getElementPosition(gateCache)
        gatePositions["close"]["rx"], gatePositions["close"]["ry"], gatePositions["close"]["rz"] = getElementRotation(gateCache)

        positionState = 2
        outputChatBox(core:getServerPrefix("server", "Kapu", 2).."Állítsd be a kapu "..color.."Nyitási#ffffff pozícióját.", 255, 255, 255, true)
        setTimer(function() elementeditor:toggleEditor(gateCache, "saveGate", "endGateEdit") end, 100, 1)
    elseif positionState == 2 then 
        gatePositions["open"]["x"], gatePositions["open"]["y"], gatePositions["open"]["z"] = getElementPosition(gateCache)
        gatePositions["open"]["rx"], gatePositions["open"]["ry"], gatePositions["open"]["rz"] = getElementRotation(gateCache)
        
        triggerServerEvent("gate > createGateOnServer", resourceRoot, gatePositions, gates[selectedGate][1], getElementInterior(gateCache), getElementDimension(gateCache))

        stopGateEditing()
    end
end)

addEvent("endGateEdit", true)
addEventHandler("endGateEdit", root, function() 
    stopGateEditing()
end)

function stopGateEditing() 
    if isElement(gateCache) then 
        destroyElement(gateCache)
        gateCache = false 

        positionState = 1
        gatePositions = {
            ["close"] = {},
            ["open"] = {},
        }

        removeEventHandler("onClientRender", root, renderGatePosingPanel)
        removeEventHandler("onClientKey", root, panelClick)
    end
end

-- commands --
admin:addAdminCMD("nearbygates", 7, "Közeledben lévő kapuk lekérése")
addCommandHandler("nearbygates", function() 
    if getElementData(localPlayer, "user:admin") >= 7 then 
        local allGates = getAllGates()

        for k, v in pairs(allGates) do 
            local distance = core:getDistance(localPlayer, v) 

            if distance < 15 then 
                outputChatBox(core:getServerPrefix("server", "Közeledben lévő kapu", 3).. "Kapu ID: "..color..getElementData(v, "gate:id").." #ffffffModel ID: "..color..getElementModel(v).." #ffffffTávolság: "..color..math.floor(distance).."#ffffffyard.", 255, 255, 255, true)
            end
        end
    end
end)

addCommandHandler("gate", function()
    local nearestGate = getNearestGate(localPlayer, 10)
    if nearestGate then 
        local gateId = getElementData(nearestGate, "gate:id")

        if ((exports.oInventory:hasItem(53, gateId)) or (getElementData(localPlayer, "user:aduty")) or (getElementData(localPlayer, "user:admin") >= 8 )) then 
            if not getElementData(nearestGate, "gate:inMove") then 
                triggerServerEvent("gate > setGateState", resourceRoot, nearestGate)
            end
        else
            outputChatBox(core:getServerPrefix("red-dark", "Kapu", 2).."Nincs kulcsod ehez a kapuhoz!", 255, 255, 255, true) 
        end
    else 
        outputChatBox(core:getServerPrefix("red-dark", "Kapu", 2).."Nincs a közeledben kapu!", 255, 255, 255, true)
    end 
end)

admin:addAdminCMD("delgate", 7, "Kapu törlése")