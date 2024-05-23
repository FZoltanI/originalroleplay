local sx,sy = guiGetScreenSize()
local myX, myY = 1600, 900

local size = 1.2 -- NE VÉLTOZTASD!

local oilCheck1 = false
local oilCheck2 = false

local speedoX, speedoY = sx*0.82, sy*0.71
local sizeX, sizeY = sx*0.2,sy*0.4--240/myX*sx, 290/myY*sy
local fuelW, fuelH = (108/myX*sx), (108/myX*sx)

local speedo_maxspeed = 240

local fonts = {
    ["heavy-50"] = dxCreateFont("files/heavy.ttf", 50),
    ["thin-15"] = dxCreateFont("files/thin.ttf", 15),
}

local tempomatFont = exports.oFont:getFont("condensed", 13)

local interface = exports.oInterface
local core = exports.oCore
local index = exports.oIndex
local vehicleScript = exports.oVehicle

speedoX = interface:getInterfaceElementData(5, "posX")*sx
speedoY = interface:getInterfaceElementData(5, "posY")*sy

local color, r, g, b = core:getServerColor()

local tick = getTickCount()

--local browser = guiCreateBrowser(sx*0.8, sy*0.9, sizeX, sizeY, true, true, true)
local browser2 = createBrowser(sizeX, sizeY, true, true)
local fuelBrowser = createBrowser(120, 120, true, true)

local currDis = 0
local currFuel = 100
local maxFuel = 100


local usedScripts = {"oInterface", "oCore", "oIndex", "oVehicle", "oSpeedo"}
addEventHandler("onClientResourceStart", root, function(res)
    local resName = getResourceName(res)

    if table.contains(usedScripts, resName) then
        interface = exports.oInterface
        core = exports.oCore
        index = exports.oIndex
        vehicleScript = exports.oVehicle
    end
end)

function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

addEventHandler("onClientBrowserCreated", browser2, function()
	loadBrowserURL(browser2, "http://mta/local/speedov2.html")
end)

addEventHandler("onClientBrowserCreated", fuelBrowser, function()
	loadBrowserURL(fuelBrowser, "http://mta/local/speedov2_fuel.html")
end)

addEventHandler("onClientElementDataChange", root, function(key, old, new)
    local pedVeh = getPedOccupiedVehicle(localPlayer)
    if key == "vehicle:seatbeltState" then
        local sourceVeh = getPedOccupiedVehicle(source)
        if pedVeh == sourceVeh then
            checkSeatbelts()
        end
    end

    if pedVeh then
        if pedVeh == source then
            if key == "veh:IndicatorState" then
                local states = new

                if states.left then
                    indicatorL = true
                else
                    indicatorL = false
                end

                if states.right then
                    indicatorR = true
                else
                    indicatorR = false
                end
            end
        end
    end
end)

local lastBeep = getTickCount()
local tick = getTickCount()
function drawspeedo()
    local occupiedVeh = getPedOccupiedVehicle(localPlayer)
    if occupiedVeh then
        if interface:getInterfaceElementData(5, "showing") then
            --*local ouccupiedVeh = getPedOccupiedVehicle(localPlayer)
            speedoX = interface:getInterfaceElementData(5, "posX")*sx
            speedoY = interface:getInterfaceElementData(5, "posY")*sy

            fuelX = interface:getInterfaceElementData(15, "posX")*sx
            fuelY = interface:getInterfaceElementData(15, "posY")*sy
            dxDrawImage(speedoX, speedoY, sizeX+5/myX*sx, sizeY, browser2)

            dxDrawImage(fuelX,fuelY, fuelW, fuelH, fuelBrowser)
        --if getPedOccupiedVehicle(localPlayer) then
            local carrpm = getVehicleRPM(occupiedVeh)
            local carspeed = math.floor(getElementSpeed(occupiedVeh, "km/h"))
            local vehModel = getElementModel(occupiedVeh)

            --print(carrpm)

            if tonumber(currFuel) < 0 then
                currFuel = 0
            end

            local gear = getVehicleCurrentGear(occupiedVeh)
            
            if tonumber(gear) > 0 then
                if vehicleScript:isElectricCar(vehModel) then
                    gear = 0
                end
            end

            executeBrowserJavascript(browser2, "setSpeed("..carspeed..", "..gear..", "..math.min(carrpm/1000, 8)..", "..math.floor(currDis)..");")

            local browserFuel = (currFuel/(maxFuel or 100))

            if vehicleScript:isElectricCar(vehModel) then
                executeBrowserJavascript(fuelBrowser, "setFuel("..browserFuel..", "..math.floor(currFuel)..", 1);")
            else
                executeBrowserJavascript(fuelBrowser, "setFuel("..browserFuel..", "..math.floor(currFuel)..", 0);")
            end

            local seatbeltState = "none"
            local vehicleOccupants = getVehicleOccupants(occupiedVeh)
            if getElementModel(occupiedVeh) == 572 then
                seatbeltState = "none"
            else
                for k, v in pairs(vehicleOccupants) do
                    if not getElementData(v, "vehicle:seatbeltState") then
                        seatbeltState = "block"
                        break
                    end
                end
            end



            local handbrake = 0
            if getElementData(occupiedVeh, "veh:handbrake") then handbrake = 1 end
            --executeBrowserJavascript(browser2, "setHandbrakeState("..handbrake..");")



            --[[if exports.oInterface:getInterfaceElementData(20,"showing") then
                local x, y, w, h = exports.oInterface:getInterfaceElementData(20, "posX"), exports.oInterface:getInterfaceElementData(20, "posY"), exports.oInterface:getInterfaceElementData(20, "width"), exports.oInterface:getInterfaceElementData(20, "height")

                if getElementData(occupiedVeh, "tempomat") then
                    core:dxDrawShadowedText(vehicleScript:getModdedVehicleName(occupiedVeh)..color.." ("..getElementData(occupiedVeh, "tempomat.speed").."km/h)", x*sx, y*sy, (x+w)*sx, (y+h)*sy, tocolor(255, 255, 255, 255), tocolor(0, 0, 0, 255), 0.9/myX*sx, tempomatFont, "center", "center", false, false, false, true)
                else
                    core:dxDrawShadowedText(vehicleScript:getModdedVehicleName(occupiedVeh), x*sx, y*sy, (x+w)*sx, (y+h)*sy, tocolor(255, 255, 255, 255), tocolor(0, 0, 0, 255), 0.9/myX*sx, tempomatFont, "center", "center", false, false, false, false)
                end
            end]]

            local carName = getVehicleName(occupiedVeh) 
            
            if vehicleScript:getModdedVehicleName(getElementModel(occupiedVeh)) then 
                carName = vehicleScript:getModdedVehicleName(getElementModel(occupiedVeh))
            end 
            --print(carName)
            executeBrowserJavascript(browser2, "setCarName('"..carName.."', 0);")
            if getElementData(occupiedVeh, "tempomat") then
                local tempomat = getElementData(occupiedVeh, "tempomat.speed")
                executeBrowserJavascript(browser2, "setCarName('"..carName.."', "..tempomat..");")
            else
                executeBrowserJavascript(browser2, "setCarName('"..carName.."', 0);")
            end


            local indicator = getElementData(occupiedVeh, "veh:IndicatorState")

            dxDrawImage(speedoX + 67, speedoY + 180, 30/myX*sx, 30/myX*sx, "files/icons/left.png", 0, 0, 0, tocolor(25, 25, 25, 150))
            if getElementData(occupiedVeh,"vehindex_left") then
                if getElementData(occupiedVeh,"i:active") then
                local alphaChange = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount() - tick) / 1000, "Linear")
                dxDrawImage(speedoX + 67, speedoY + 180, 30/myX*sx, 30/myX*sx, "files/icons/left.png", 0, 0, 0, tocolor(169, 217, 78, 220*alphaChange))
                end
            end

            dxDrawImage(speedoX + 160, speedoY + 180, 30/myX*sx, 30/myX*sx, "files/icons/left.png", 180, 0, 0, tocolor(25, 25, 25, 150))
            if getElementData(occupiedVeh,"vehindex_right") then
                if getElementData(occupiedVeh,"i:active") then
                local alphaChange = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount() - tick) / 1000, "Linear")
                dxDrawImage(speedoX + 160, speedoY + 180, 30/myX*sx, 30/myX*sx, "files/icons/left.png", 180, 0, 0, tocolor(169, 217, 78, 220*alphaChange))
                end
            end

            if getElementData(occupiedVeh,"vehindex_middle") then
                if getElementData(occupiedVeh,"i:active") then
                local alphaChange = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount() - tick) / 1000, "Linear")
                dxDrawImage(speedoX + 160, speedoY + 180, 30/myX*sx, 30/myX*sx, "files/icons/left.png", 180, 0, 0, tocolor(169, 217, 78, 220*alphaChange))
                dxDrawImage(speedoX + 67, speedoY + 180, 30/myX*sx, 30/myX*sx, "files/icons/left.png", 0, 0, 0, tocolor(169, 217, 78, 220*alphaChange))
                end
            end

            dxDrawImage(speedoX + 130, speedoY + 205, 30/myX*sx, 30/myX*sx, "files//icons/handbrake.png", 0, 0, 0, tocolor(25, 25, 25, 150))
            if getElementData(occupiedVeh, "veh:handbrake") then
            dxDrawImage(speedoX + 130, speedoY + 205, 30/myX*sx, 30/myX*sx, "files//icons/handbrake.png", 0, 0, 0, tocolor(235, 84, 84, 250))
            end

            dxDrawImage(speedoX + 95, speedoY + 180, 30/myX*sx, 30/myX*sx, "files/icons/seatbelt.png", 0, 0, 0, tocolor(25, 25, 25, 150))
            if getVehicleType(occupiedVeh) == "Automobile" or getVehicleType(occupiedVeh) == "Monster Truck" then
                  if seatbeltState == "block" then
                    local alphaChange = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount() - tick) / 1000, "CosineCurve")
                    dxDrawImage(speedoX + 95, speedoY + 180, 30/myX*sx, 30/myX*sx, "files/icons/seatbelt.png", 0, 0, 0, tocolor(235, 84, 84, 250 * alphaChange))
                  end
            end
            --
            dxDrawImage(speedoX + 125, speedoY + 180, 30/myX*sx, 30/myX*sx, "files/icons/lamp.png", 0, 0, 0, tocolor(25, 25, 25, 150))
            if getVehicleOverrideLights(occupiedVeh) == 2 then
                dxDrawImage(speedoX + 125, speedoY + 180, 30/myX*sx, 30/myX*sx, "files/icons/lamp.png", 0, 0, 0, tocolor(235, 195, 84, 250))
            end

            dxDrawImage(speedoX + 100, speedoY + 208, 25/myX*sx, 25/myX*sx, "files/oil.png", 0, 0, 0, tocolor(25, 25, 25, 150))
            if getElementData(occupiedVeh,"oilLamp") then
                dxDrawImage(speedoX + 100, speedoY + 208, 25/myX*sx, 25/myX*sx, "files/oil.png", 0, 0, 0, tocolor(235, 84, 84, 250))
            end


            --[[dxDrawImage(speedoX + sx*0.085, speedoY + sy*0.125, 30/myX*sx, 30/myX*sx, "files/icons/tempomat.png", 0, 0, 0, tocolor(25, 25, 25, 150))
            if getElementData(occupiedVeh, "tempomat") then                                                                                                     -- Carlos szerint ki kell venni ezt innen
                dxDrawImage(speedoX + sx*0.085, speedoY + sy*0.125, 30/myX*sx, 30/myX*sx, "files/icons/tempomat.png", 0, 0, 0, tocolor(182, 94, 209, 250))
            end]]

            --dxDrawImage(speedoX + sx*0.075, speedoY + sy*0.215, 30/myX*sx, 30/myX*sx, "files/icons/oil.png", 0, 0, 0, tocolor(235, 84, 84, 240))


            if vehicleScript:isElectricCar(vehModel) then
                --executeBrowserJavascript(browser2, "setSpeedoType('electric');")
                --executeBrowserJavascript(browser2, "setRPM(".. 0 ..");")

                local gear = getVehicleCurrentGear(occupiedVeh)
                if tonumber(gear) > 0 then
                    --executeBrowserJavascript(browser2, "setGear('D');")
                else
                    --executeBrowserJavascript(browser2, "setGear(".. gear ..");")
                end
            else
                --executeBrowserJavascript(browser2, "setSpeedoType('default');")
                --executeBrowserJavascript(browser2, "setRPM("..(getVehicleRPM(occupiedVeh))..");")
                --executeBrowserJavascript(browser2, "setGear("..getVehicleCurrentGear(occupiedVeh)..");")

                --dxDrawRectangle(speedoX + sx*0.035, speedoY + sy*0.08, sx*0.003, sy*0.1, tocolor(0, 0, 0, 100))
                --dxDrawRectangle(speedoX + sx*0.035, speedoY + sy*0.08, sx*0.003, sy*0.1, tocolor(r, g, b, 255))



            end
        end
    else
        destroyRender("drawspeedo")
    end
end

function seatbeltBeep()
    local ouccupiedVeh = getPedOccupiedVehicle(localPlayer)

    if ouccupiedVeh then
        local vehicleOccupants = getVehicleOccupants(ouccupiedVeh)
        local seatbeltState = "none"
        if getElementModel(ouccupiedVeh) == 572 or getVehicleType(ouccupiedVeh) == "Boat" then
            seatbeltState = "none"
        else
            for k, v in pairs(vehicleOccupants) do
                if not getElementData(v, "vehicle:seatbeltState") then
                    seatbeltState = "block"
                    break
                end
            end
        end

        if not (noBeepVehicles[getElementModel(ouccupiedVeh)]) then
            --if not (getVehicleType(ouccupiedVeh) == "BMX") then
                if getVehicleEngineState(ouccupiedVeh) then
                    if seatbeltState == "block" then
                        if lastBeep + 1000 < getTickCount() then
                            lastBeep = getTickCount()

                            playSound("files/belt_beep.mp3")
                        end
                    end
                end
            --end
        end
    else
        destroyRender("seatbeltBeep")
    end
end

function showSpeedo()
    checkSeatbelts()
    executeBrowserJavascript(browser2, "showSpeedo('block');")
    createRender("drawspeedo", drawspeedo)
end

function closeSpeedo()
    destroyRender("drawspeedo")
    executeBrowserJavascript(browser2, "showSpeedo('none');")
end

addEventHandler("onClientVehicleEnter", root, function(player, seat)
    if player == localPlayer then
        local vehType = getVehicleType(source)
        if vehType == "BMX" then return end
        createRender("seatbeltBeep", seatbeltBeep)

        oilCheck1 = false
        oilCheck2 = false
        if seat == 0 or seat == 1 then
            showSpeedo()
            currFuel = getElementData(source, "veh:fuel")
            maxFuel = getElementData(source, "veh:maxFuel")
            currDis = getElementData(source, "veh:traveledDistance")
            currOil = getElementData(source,"veh:distanceToOilChange")
        end
    end
end)

addEventHandler("onClientVehicleStartExit", root, function(player, seat)
    if player == localPlayer then
        local vehType = getVehicleType(source)
        if vehType == "BMX" then return end
        destroyRender("seatbeltBeep")
        if seat == 0 then
            closeSpeedo()
            triggerServerEvent("speedo > setVehicleDatas", resourceRoot, source, currFuel, currDis, currOil)
        end
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    if getPedOccupiedVehicle(localPlayer) then
        local vehType = getVehicleType(getPedOccupiedVehicle(localPlayer))
        if vehType == "BMX" then return end

        local seat = getPedOccupiedVehicleSeat(localPlayer)

        createRender("seatbeltBeep", seatbeltBeep)

        if seat == 0 then
            setTimer(function() showSpeedo() end, 250, 1)

            --if seat == 0 then
                currFuel = getElementData(getPedOccupiedVehicle(localPlayer), "veh:fuel")
                maxFuel = getElementData(getPedOccupiedVehicle(localPlayer), "veh:maxFuel")
                currDis = getElementData(getPedOccupiedVehicle(localPlayer), "veh:traveledDistance")
            --end
        end
    end
end)

addEventHandler("onClientPlayerWasted", root, function()
    if source == localPlayer then
        closeSpeedo()
        oilChech1 = false
        oilChech2 = false
    end
end)

function checkSeatbelts()
    local vehicleOccupants = getVehicleOccupants(getPedOccupiedVehicle(localPlayer))

    local vehType = getVehicleType(getPedOccupiedVehicle(localPlayer))
    local seatbeltState = "none"
    if vehType == "BMX" or vehType == "Bike" or getElementModel(getPedOccupiedVehicle(localPlayer)) == 572 then
        seatbeltState = "none"
    else
        for k, v in pairs(vehicleOccupants) do
            if not getElementData(v, "vehicle:seatbeltState") then
                seatbeltState = "block"
                break
            end
        end
    end
   -- print(seatbeltState)

    executeBrowserJavascript(browser2, "setSeatbelt('"..seatbeltState.."');")
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

function getVehicleRPM(vehicle)
    local vehicleRPM = 0
    if (vehicle) then
        if (getVehicleEngineState(vehicle) == true) then
            if getVehicleCurrentGear(vehicle) > 0 then
                vehicleRPM = math.floor(((getElementSpeed(vehicle, "km/h") / getVehicleCurrentGear(vehicle)) * 160) + 0.5)
                if (vehicleRPM < 650) then
                    vehicleRPM = math.random(650, 750)
                elseif (vehicleRPM >= 9000) then
                    vehicleRPM = math.random(9000, 9900)
                end
            else
                vehicleRPM = math.floor((getElementSpeed(vehicle, "km/h") * 160) + 0.5)
                if (vehicleRPM < 650) then
                    vehicleRPM = math.random(650, 750)
                elseif (vehicleRPM >= 9000) then
                    vehicleRPM = math.random(9000, 9900)
                end
            end
        else
            vehicleRPM = 0
        end

        return tonumber(vehicleRPM)
    else
        return 0
    end
end

local checkNeed = true
local lastTrigger = 0
addEventHandler("onClientPreRender", getRootElement(), function (deltaTime)
    local vehicle = getPedOccupiedVehicle(localPlayer)

    if vehicle and getVehicleEngineState(vehicle) then
        local vehType = getVehicleType(vehicle)
        if vehType == "BMX" then return end

        local speed = getElementSpeed(vehicle, "km/h")

        local dis = speed / 3600 / 2.5 / deltaTime

        currDis = (currDis or 0) + dis
        modelID = getElementModel(vehicle)

        if modelID == 546 or modelID == 496 then
            return
        else
            setElementData(vehicle, "veh:distanceToOilChange", (getElementData(vehicle, "veh:distanceToOilChange") or 0) - dis)
        end

        if not getElementData(vehicle, "vehicle:tempVeh:isTempVeh") then
            if (tonumber(currFuel) or 100) > 0 then
                if getPedOccupiedVehicle(localPlayer) then 
                    checkNeed = true
                    currFuel = (currFuel or 100) - vehicleScript:getVehicleConsumption(getElementModel(vehicle))/15000
                end
            else
                if checkNeed then
                    triggerServerEvent("speedo > setVehicleDatas", resourceRoot, vehicle, currFuel, currDis)
                    exports.oInfobox:outputInfoBox("Kifogyott az üzemanyag!", "warning")
                    checkNeed = false
                end
            end

            local oil = getElementData(vehicle, "veh:distanceToOilChange")

            if math.floor(oil) > 0 then 
                if math.floor(oil) <= 1000 then
                    if lastTrigger + 1000 < getTickCount() then
                        if not oilCheck1 then
                            lastTrigger = getTickCount()
                            modelID = getElementModel(vehicle)
                            outputChatBox(core:getServerPrefix("red-dark", "Jármű",3)..""..vehicleScript:getModdedVehName(modelID).." tipusú járműved a jelenlegi olajszintjével már csak "..math.floor(oil).."km-t lehet tenni! További infók a dashboardban.",255,255,255,true)
                            exports.oInfobox:outputInfoBox("Járműved olajszintje alacsony, Információk a chatboxban!", "warning")
                            setElementData(vehicle,"oilLamp",true)
                            oilCheck1 = true
                        end
                    end
                elseif math.floor(oil) <= 100 then
                    if lastTrigger + 1000 < getTickCount() then
                        if not oilCheck2 then
                            lastTrigger = getTickCount()
                            modelID = getElementModel(vehicle)
                            outputChatBox(core:getServerPrefix("red-dark", "Jármű",3)..""..vehicleScript:getModdedVehName(modelID).." tipusú járműved a jelenlegi olajszintjével már csak "..math.floor(oil).."km-t lehet tenni! További infók a dashboardban.",255,255,255,true)
                            exports.oInfobox:outputInfoBox("Járműved olajszintje alacsony, Információk a chatboxban!", "warning")
                            oilCheck2 = true
                            setElementData(vehicle,"oilLamp",true)

                        end
                    end
                end
            end 

            if tonumber(oil) <= 0 then
                if lastTrigger + 1000 < getTickCount() then
                    lastTrigger = getTickCount()
                    triggerServerEvent("speedo > setVehicleDatas", resourceRoot, vehicle, currFuel, currDis, oil)
                    exports.oInfobox:outputInfoBox("A járműved lerobbant mivel kifogyott az olaj belőle!", "warning")


                    checkNeed2 = false
                    setElementData(vehicle,"oilLamp",false)

                end
            end
        end
    end
end)

addEventHandler("onClientElementDataChange", root, function(key, old, new)
    if source == getPedOccupiedVehicle(localPlayer) then
        if key == "veh:fuel" then
            currFuel = new
        end

        if key == "veh:traveledDistance" then
            currDis = new
        end
    end
end)

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