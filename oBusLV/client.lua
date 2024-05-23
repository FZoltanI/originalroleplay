local sx, sy = guiGetScreenSize() 
local myX, myY = 1600, 900

local col = false

function createBusStops()
    for k, v in ipairs(bus_stops) do 
        if v.rot then
            local busStopObj = createObject(1257, v.pos.x, v.pos.y, v.pos.z, 0, 0, v.rot-90)
            setObjectBreakable(busStopObj, false)
        end

        local colTube = createColTube(v.pos.x, v.pos.y, v.pos.z-1, 1, 2.3)
        setElementData(colTube, "isBusStationCol", 2)
    end
end
createBusStops()

addEventHandler("onClientResourceStart", root, function(res)
	if getResourceName(res) == "oCore" or getResourceName(res) == "oFont" or getResourceName(res) == "oBus" or getResourceName(res) == "oInfobox" then  
        font = exports.oFont
        core = exports.oCore
        infobox = exports.oInfobox
        color, r, g, b = core:getServerColor()
	end
end)

local fonts = {
    ["condensed-11"] = font:getFont("condensed", 11), 
    ["condensed-13"] = font:getFont("condensed", 15), 
    ["bebasneue-20"] = font:getFont("bebasneue", 20), 
}

local pointer = 0
local selected_bus_stop = 0

local tick = getTickCount() 
local state = "open"
local a = 0

function renderBusPanel() 
    if state == "open" then 
        a = interpolateBetween(a, 0, 0, 1, 0, 0, (getTickCount() - tick)/300, "Linear")
    else
        a = interpolateBetween(a, 0, 0, 0, 0, 0, (getTickCount() - tick)/300, "Linear")
    end

    dxDrawRectangle(sx*0.4, sy*0.3, sx*0.2, sy*0.4, tocolor(40, 40, 40, 255*a))

    dxDrawText("BUS STOP", sx*0.4, sy*0.335, sx*0.4+sx*0.2, sy*0.335+sy*0.04, tocolor(r, g, b, 200*a), 1/myX*sx, fonts["condensed-13"], "center", "center")

    dxDrawImage(sx*0.4, sy*0.3+5/myY*sy, 25/myX*sx, 25/myY*sy, "location.png", 0, 0, 0, tocolor(255, 255, 255, 255*a))

    for k, v in ipairs(bus_stops) do 
        if countLineLength(v) == 0 then 
            dxDrawText(v.name, sx*0.42, sy*0.3, sx*0.42+sx*0.1, sy*0.3+sy*0.04, tocolor(255, 255, 255, 255*a), 0.9/myX*sx, fonts["condensed-11"], "left", "center")
            break
        end
    end

    local starty = sy*0.38
    for i = 1, 8 do 
        
        if bus_stops[i+pointer] then 
            if core:isInSlot(sx*0.402, starty, sx*0.2-sx*0.004, sy*0.035) or selected_bus_stop == i+pointer then 
                dxDrawRectangle(sx*0.402, starty, sx*0.2-sx*0.004, sy*0.035, tocolor(r, g, b, 50*a))
            else
                dxDrawRectangle(sx*0.402, starty, sx*0.2-sx*0.004, sy*0.035, tocolor(30, 30, 30, 255*a))
            end
            dxDrawText(bus_stops[i+pointer].name..color.." ("..countLinePrice(bus_stops[i+pointer]).."$)", sx*0.406, starty, sx*0.406+sx*0.2-sx*0.004, starty+sy*0.035, tocolor(255, 255, 255, 255*a), 0.9/myX*sx, fonts["condensed-11"], "left", "center", false, false, false, true)

            local time = countLineTravellingTime(bus_stops[i+pointer])
            dxDrawText(time[1]..":"..time[2], sx*0.398, starty, sx*0.398+sx*0.2-sx*0.004, starty+sy*0.035, tocolor(255, 255, 255, 255*a), 0.9/myX*sx, fonts["condensed-11"], "right", "center", false, false, false, true)
        end

        starty = starty + sy*0.04
    end

    if selected_bus_stop > 0 then 
        dxDrawRectangle(sx*0.4, sy*0.71, sx*0.2, sy*0.035, tocolor(30, 30, 30, 255*a))
        if core:isInSlot(sx*0.4, sy*0.71, sx*0.2, sy*0.035) then 
            dxDrawRectangle(sx*0.4, sy*0.71, sx*0.2, sy*0.035, tocolor(r, g, b, 150*a))
        end
        dxDrawText("Felszállás a buszra", sx*0.4, sy*0.71, sx*0.4+sx*0.2, sy*0.71+sy*0.035, tocolor(255, 255, 255, 255*a), 1/myX*sx, fonts["condensed-11"], "center", "center")
    end
end

function busPanelClick(key, state)
    if state then 
        if key == "mouse1" then 
            local starty = sy*0.38
            for i = 1, 8 do 
                if bus_stops[i+pointer] then 
                    if core:isInSlot(sx*0.402, starty, sx*0.2-sx*0.004, sy*0.035)then 
                        selected_bus_stop = i+pointer
                        break
                    end
                end

                starty = starty + sy*0.04
            end

            if selected_bus_stop > 0 then 
                if core:isInSlot(sx*0.4, sy*0.71, sx*0.2, sy*0.035) then 
                    if countLinePrice(bus_stops[selected_bus_stop]) > 0 then 
                        if getElementData(localPlayer, "char:money") >= countLinePrice(bus_stops[selected_bus_stop]) then 
                            startTravell()
                        else
                            infobox:outputInfoBox("Nincs elegendő pénzed ahoz, hogy felszállj a buszra!", "error")
                        end 
                    else
                        infobox:outputInfoBox("Jelenleg ebben a buszmegállóban állsz!", "warning")
                    end
                end
            end

        elseif key == "mouse_wheel_down" then 
            if core:isInSlot(sx*0.4, sy*0.3, sx*0.2, sy*0.4) then
                if bus_stops[pointer+9] then 
                    pointer = pointer + 1
                end
            end
        elseif key == "mouse_wheel_up" then 
            if core:isInSlot(sx*0.4, sy*0.3, sx*0.2, sy*0.4) then
                if pointer > 0 then 
                    pointer = pointer - 1
                end
            end
        end
    end 
end

addEventHandler("onClientColShapeHit", root, function(element, mdim)
    if element == localPlayer then 
        if mdim then
            if not getPedOccupiedVehicle(element) then 
                if (getElementData(source, "isBusStationCol") or 0) == 2 then 
                    openBusPanel()
                    col = source
                end
            end
        end
    end
end)

addEventHandler("onClientColShapeLeave", root, function(element, mdim)
    if element == localPlayer then 
        if mdim then
            if not getPedOccupiedVehicle(element) then 
                if (getElementData(source, "isBusStationCol") or 0) == 2 then 
                    closeBusPanel()
                end
            end
        end
    end
end)

function openBusPanel() 
    pointer = 0
    selected_bus_stop = 0
    tick = getTickCount()
    state = "open"
    addEventHandler("onClientKey", root, busPanelClick)
    addEventHandler("onClientRender", root, renderBusPanel)
end

function closeBusPanel() 
    tick = getTickCount()
    state = "close"
    setTimer(function()
        removeEventHandler("onClientKey", root, busPanelClick)
        removeEventHandler("onClientRender", root, renderBusPanel)
        col = false
    end, 300, 1)
end

function createSound()
    local sound = playSound3D("bus.wav", 1924.6517333984, -2426.037109375, 23.620956420898, true)
    setSoundMaxDistance(sound, 30)
    setElementDimension(sound, 1)
end
createSound()

function countLinePrice(line) 
    local distance = countLineLength(line)

    return math.floor(distance/8)
end

function countLineTravellingTime(line)
    local distance = countLineLength(line)
    local time = math.floor(distance/11)

    local min = math.floor(time/60)
    local sec = time - min*60
    
    return {min, sec, min*60+sec}
end

function countLineLength(line)
    local playerpos = Vector3(getElementPosition(col)) 

    local distance = math.floor(getDistanceBetweenPoints3D(playerpos.x, playerpos.y, playerpos.z, line.pos.x, line.pos.y, line.pos.z))

    if distance <= 5 then 
        distance = 0 
    end

    return distance
end

-- / Travelling / --
local passedTime = 0
local travellingTime = 0
local travellLocation = false
function startTravell()
    local price = countLinePrice(bus_stops[selected_bus_stop])

    fadeCamera(false, 0.3, 30, 30, 30)
    travellingTime = countLineTravellingTime(bus_stops[selected_bus_stop])
    setElementData(localPlayer, "bus:travellingTime", travellingTime)

    passedTime = 0
    travellLocation = bus_stops[selected_bus_stop]
    setTimer(function()
        passedTime = passedTime + 1

        if passedTime == travellingTime[3] then 
            removeEventHandler("onClientRender", root, renderLineInformationPanel)
            fadeCamera(false, 0.3, 30, 30, 30)
            infobox:outputInfoBox("Megérkeztél ide: "..travellLocation.name..".", "success")
            triggerServerEvent("bus > endTravell", resourceRoot, travellLocation.pos.x, travellLocation.pos.y, travellLocation.pos.z, localPlayer)
            setTimer(function() fadeCamera(true, 0.3, 30, 30, 30) end, 300, 1)
        end
    end, 1000, travellingTime[3])

    closeBusPanel()
    setTimer(function() 
        triggerServerEvent("bus > startTravell", resourceRoot, price, localPlayer) 
        infobox:outputInfoBox("Sikeresen felszálltál a buszra!", "success")
        addEventHandler("onClientRender", root, renderLineInformationPanel)
        fadeCamera(true, 0.3, 30, 30, 30)
    end, 300, 1)
end

function renderLineInformationPanel()
    local time = travellingTime[3]-passedTime
    local min = math.floor(time/60)
    local sec = time - min*60
    
    dxDrawRectangle(sx*0.475, sy*0.75, 70/myX*sx, 70/myY*sy, tocolor(35, 35, 35, 255))
    dxDrawRectangle(sx*0.475, sy*0.75+70/myY*sy, 70/myX*sx, (0-70/myY*sy)*(passedTime/travellingTime[3]), tocolor(r, g, b, 100))
    dxDrawText(min..":"..sec, sx*0.475, sy*0.75, sx*0.475+70/myX*sx, sy*0.75+70/myY*sy, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["bebasneue-20"], "center", "center")
end
--------------------