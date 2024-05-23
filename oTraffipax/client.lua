addEventHandler("onClientResourceStart", resourceRoot, function() 
    for k, v in ipairs(trafipaxes) do 
        local traficol = createColSphere(v[1], v[2], v[3], 10)

        setElementData(traficol, "isTraffipax", true)
        setElementData(traficol, "traffipax:speedlimit", v[4])

        if v[5] then 
            createObject(v[5], v[6], v[7], v[8] - 1, v[9], v[10], v[11])
        end
    end
end)

--setDevelopmentMode(true)

local tick = getTickCount()

local months = {"JAN", "FEB", "MAR", "APR", "MAJ", "JUN", "JUL", "AUG", "SEP", "OKT", "NOV", "DEC"}

addEventHandler("onClientResourceStart", getRootElement(), function(res)
	if getResourceName(res) == "oCore" or getResourceName(res) == "oTraffipax" then  
		core = exports.oCore
        color, r, g, b = core:getServerColor()
	end
end)

local seatForName = {
    [0] = "Sofőr ülés",
    [1] = "Jobb első ülés",
    [3] = "Bal hátsó ülés",
    [4] = "Jobb hátsó ülés",
}

local lastTraffipax = 0
addEventHandler("onClientColShapeHit", getRootElement(), function(element, mdim)
    if element == localPlayer and mdim then 
        if not isElement(source) then return end
        if (getElementData(source, "isTraffipax") or false) then 
            local veh = getPedOccupiedVehicle(localPlayer)

            if veh then 
                if getPedOccupiedVehicleSeat(localPlayer) == 0 and not getElementData(localPlayer, "user:aduty") then 
                    if not deniedCars[getElementModel(veh)] then 
                        if not getVehicleSirensOn(veh) then 
                            if lastTraffipax + 5000 < getTickCount() then 
                                lastTraffipax = getTickCount()
                                
                                checkAtlepes(getElementData(source, "traffipax:speedlimit"), veh, 10, true)
                            end
                        end
                    end
                end
            end
        end
    end
end)

function checkAtlepes(limit, veh, difference, message)
    local speedlimit = limit
    local carspeed = math.floor(getElementSpeed(veh, "km/h"))

    print(limit, carspeed, difference, message)

    local atlepes = carspeed-speedlimit
    local birsag = math.floor(atlepes*price)
    
    if atlepes > difference then 
        outputChatBox(" ", 255, 255, 255, true)
        local vehicleplayers = getVehicleOccupants(veh)

        outputChatBox(core:getServerPrefix("server", "Traffipax", 3).."Átlépted a sebességhatárt!", 255, 255, 255, true)
        outputChatBox(core:getServerPrefix("server", "Traffipax", 3).."Sebbességed: "..color..carspeed .." #ffffffkm/h | Sebességhatár: "..color..speedlimit.." #ffffffkm/h | Átlépés mértéke: "..color..atlepes.." #ffffffkm/h.", 255, 255, 255, true)
        

        if not (getVehicleType(veh) == "Quad" or getVehicleType(veh) == "Bike" or getVehicleType(veh) == "BMX") then 
            local seatbelts = 0 

            for k, v in pairs(getVehicleOccupants(veh)) do 
                if not (getElementData(v, "vehicle:seatbeltState")) then 
                    seatbelts = seatbelts + 1 
                end
            end

            if seatbelts > 0 then
                outputChatBox(" ", 255, 255, 255, true)
                birsag = birsag + (50*seatbelts)
                outputChatBox(core:getServerPrefix("server", "Traffipax", 3).."Mivel "..color..seatbelts.."#ffffffdb embernek nem volt bekötve a biztonsági öve, így "..color..(50*seatbelts).."$#ffffff további büntetést kaptál.", 255, 255, 255, true) 
                --outputChatBox(" ", 255, 255, 255, true)
                outputChatBox(core:getServerPrefix("server", "Traffipax", 3).."Bírság: ".. color .. birsag .. "$", 255, 255, 255, true)
            end
            if seatbelts == 0 then 
                outputChatBox(core:getServerPrefix("server", "Traffipax", 3).."Bírság: "..color..birsag.." #ffffff$.", 255, 255, 255, true)
            end
        end

        tick = getTickCount()
        addEventHandler("onClientRender", root, renderFlash)
        setTimer(function() removeEventHandler("onClientRender", root, renderFlash) end, 1000, 1)

        playSound("traffipax.wav")


        triggerServerEvent("traffipax > moneyminus", resourceRoot, birsag)



        if message then
            triggerServerEvent("factionScripts > cctv > sendMessage", resourceRoot, core:getServerPrefix("blue-light-2", "Traffipax", 2).."Gyorshajtás érzékelve.", core:getServerPrefix("blue-light-2", "Traffipax", 2).."Rendszám: "..color..getVehiclePlateText(veh).."#ffffff | Helyszín: "..color..getZoneName(getElementPosition(veh)).."#ffffff.", core:getServerPrefix("blue-light-2", "Traffipax", 2).."Átlépés mértéke: "..color..atlepes.."km/h#ffffff | Bírság: "..color..birsag.."$#ffffff.")
        else 
            triggerServerEvent("factionScripts > cctv > sendMessage", resourceRoot, core:getServerPrefix("blue-light-2", "Traffipax", 2).."Gyorshajtás érzékelve. "..color.."(TRAFFIPAX)", core:getServerPrefix("blue-light-2", "Traffipax", 2).."Rendszám: "..color..getVehiclePlateText(veh).."#ffffff | Helyszín: "..color..getZoneName(getElementPosition(veh)).."#ffffff.", core:getServerPrefix("blue-light-2", "Traffipax", 2).."Átlépés mértéke: "..color..atlepes.."km/h#ffffff | Bírság: "..color..birsag.."$#ffffff.")
        end 
    else
        if not (getVehicleType(veh) == "Quad" or getVehicleType(veh) == "Bike" or getVehicleType(veh) == "BMX") then 
            local seatbelts = 0 
            outputChatBox(" ", 255, 255, 255, true)

            for k, v in pairs(getVehicleOccupants(veh)) do 
                if not (getElementData(v, "vehicle:seatbeltState")) then 
                    seatbelts = seatbelts + 1 
                end
            end

            if seatbelts > 0 then
                tick = getTickCount()
                addEventHandler("onClientRender", root, renderFlash)
                setTimer(function() removeEventHandler("onClientRender", root, renderFlash) end, 1000, 1)

                playSound("traffipax.wav")
                birsag = 50
                outputChatBox(core:getServerPrefix("server", "Traffipax", 3).."Mivel "..color..seatbelts.."#ffffffdb embernek nem volt bekötve a biztonsági öve, így "..color..birsag.."$#ffffff büntetést kaptál.", 255, 255, 255, true) 
            
                triggerServerEvent("traffipax > moneyminus", resourceRoot, birsag)
            end
        end
    end 
end

addEvent("traffipax > checkAtlepes", true)
addEventHandler("traffipax > checkAtlepes", root, checkAtlepes)

local sx, sy = guiGetScreenSize()

function renderFlash()
    local a = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount()-tick)/1000, "SineCurve")
    --dxDrawRectangle(0, 0, sx, sy, tocolor(220, 220, 220, 255*a))
    dxDrawImage(0,0,sx,sy,":oHud/assets/damage.png", 0, 0, 0, tocolor(255, 255, 255, 255*a))
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

