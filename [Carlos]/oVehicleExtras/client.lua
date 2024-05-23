local streamedVehs = {}

addEventHandler("onClientResourceStart", resourceRoot, function()
    for k, v in ipairs(getElementsByType("vehicle", root, true)) do 
        if getElementModel(v) == 451 then 
            streamedVehs[v] = v
        elseif getElementModel(v) == 410 then 
                streamedVehs[v] = v
        elseif getElementModel(v) == 502 then 
                streamedVehs[v] = v
                setVehicleComponentRotation(v,"movspoiler_25_1300",359,0,0)
        elseif getElementModel(v) == 411 then 
                setVehicleComponentRotation(v,"movspoiler_17.0_1400",359,0,0)
                streamedVehs[v] = v
        elseif getElementModel(v) == 415 then 
                setVehicleComponentPosition(v,"movspoiler_25_550",0,-2.04,0.13)
                streamedVehs[v] = v
        elseif getElementType(v) == "vehicle" then 
            if getVehicleType(v) == "Helicopter" then 
                streamedVehs[v] = v
            end
        end
    end
end)

addEventHandler("onClientElementStreamIn", root, function()
    if getElementModel(source) == 451 then 
        streamedVehs[source] = source
    elseif getElementModel(source) == 410 then 
        streamedVehs[source] = source
    elseif getElementModel(source) == 502 then 
        streamedVehs[source] = source
        setVehicleComponentRotation(source,"movspoiler_25_1300",359,0,0)
    elseif getElementModel(source) == 411 then 
        streamedVehs[source] = source
        setVehicleComponentRotation(source,"movspoiler_17.0_1400",359,0,0)
    elseif getElementModel(source) == 415 then 
        setVehicleComponentPosition(source,"movspoiler_25_550",0,-2.04,0.13)
        streamedVehs[source] = source
    elseif getElementType(source) == "vehicle" then 
        if getVehicleType(source) == "Helicopter" then 
            streamedVehs[source] = source
        end
    end
end)

addEventHandler("onClientElementStreamOut", root, function()
    if getElementModel(source) == 451 then 
        if streamedVehs[source] then 
            streamedVehs[source] = false 
        end
    elseif getElementModel(source) == 410 then 
        if streamedVehs[source] then 
            streamedVehs[source] = false 
        end    
    elseif getElementModel(source) == 502 then 
        if streamedVehs[source] then 
            streamedVehs[source] = false 
        end    
        setVehicleComponentRotation(source,"movspoiler_25_1300",359,0,0)
    elseif getElementModel(source) == 411 then 
        if streamedVehs[source] then 
            streamedVehs[source] = false 
        end    
        setVehicleComponentRotation(source,"movspoiler_17.0_1400",359,0,0)
    elseif getElementModel(source) == 415 then 
        if streamedVehs[source] then 
            streamedVehs[source] = false 
        end    
        setVehicleComponentPosition(source,"movspoiler_25_550",0,-2.04,0.13)
    elseif getElementType(source) == "vehicle" then 
        if getVehicleType(source) == "Helicopter" then 
            streamedVehs[source] = false
        end
    end
end)

addEventHandler("onClientPreRender", root, function()
    for k, v in pairs(streamedVehs) do 
        if isElement(v) then
            if (getElementModel(v) == 451) then
                local x, y, z = getVehicleComponentRotation(v, "misc_a")

                if tonumber(x) then
                    if getElementData(v, "veh:lamp") then
                        if not (math.floor(x) == 40) then
                            setVehicleComponentRotation(v, "misc_a", x+1, y, z)
                        end
                    else
                        if not (math.floor(x) == 0) then
                            setVehicleComponentRotation(v, "misc_a", x-1, y, z)
                        end
                    end
                end
            elseif (getElementModel(v) == 410) then
                local x, y, z = getVehicleComponentRotation(v, "misc_a")

                if tonumber(x) then
                    if getElementData(v, "veh:lamp") then
                        if not (math.floor(x) == 40) then
                            setVehicleComponentRotation(v, "misc_a", x+1, y, z)
                        end
                    else
                        if not (math.floor(x) == 0) then
                            setVehicleComponentRotation(v, "misc_a", x-1, y, z)
                        end
                    end
                end
            elseif (getElementModel(v) == 415) then 
                local component = "movspoiler_25_550"
                local x,y,z = getVehicleComponentPosition(v,component)
                local rx,ry,rz = getVehicleComponentRotation(v,component)
                if tonumber(z) then --0.47
                    if getElementSpeed(v, "km/h") >= 200 then
                        if not (z >= 0.30) then
                            setVehicleComponentPosition(v,component,x,y - 0.001,z + 0.001)
                            setVehicleComponentRotation(v,component,rx - 0.15,ry,rz)

                            --setVehicleComponentPosition(v,"movspoiler_23.5_1800",x,y - 0.001,z + 0.001)
                            --setVehicleComponentRotation(v,"movspoiler_23.5_1800",rx - 0.15,ry,rz)
                        end 
                    else 
                        if not (z < 0.13) then
                            setVehicleComponentPosition(v,component,x,y + 0.001,z - 0.001)
                            setVehicleComponentRotation(v,component,rx + 0.15,ry,rz)

                            --setVehicleComponentPosition(v,"movspoiler_23.5_1800",x,y + 0.001,z - 0.001)
                            --setVehicleComponentRotation(v,"movspoiler_23.5_1800",rx + 0.15,ry,rz)
                        end 
                    end

                    setVehicleComponentPosition(v,"hub_rb",x - 0.425 ,y - 0.15,z - 0.26)
                    setVehicleComponentRotation(v,"hub_rb",rx + 50,ry,rz)
                    setVehicleComponentPosition(v,"hub_lb",x + 0.425,y - 0.15,z - 0.26)
                    setVehicleComponentRotation(v,"hub_lb",rx + 50,ry,rz)

                    --outputChatBox(tostring(math.floor(rx)))
                end 
            elseif (getElementModel(v) == 411) then 
                local component = "movspoiler_17.0_1400"
                local x,y,z = getVehicleComponentPosition(v,component)
                local rx,ry,rz = getVehicleComponentRotation(v,component)
                if tonumber(z) then --0.47
                    if getElementSpeed(v, "km/h") >= 200 then
                        if not (z >= 0.40) then
                            setVehicleComponentPosition(v,component,x,y - 0.001,z + 0.001)
                        end 
                    else 
                        if not (z < 0.29) then
                            setVehicleComponentPosition(v,component,x,y + 0.001,z - 0.001)
                        end 
                    end

                    if isBrakeing(v) then 
                        if getElementSpeed(v,"km/h") > 80 then 
                            if not (rx <= 353) then
                                setVehicleComponentRotation(v,component,rx - 1.5,ry,rz)
                            end 
                        end
                    else 
                        if not (math.floor(rx) >= 359) then
                            setVehicleComponentRotation(v,component,rx + 0.1,ry,rz)
                        end 
                    end
                end 
            elseif (getElementModel(v) == 502) then 
                local component = "movspoiler_25_1300"
                local x,y,z = getVehicleComponentPosition(v,component)
                local rx,ry,rz = getVehicleComponentRotation(v,component)
                if tonumber(z) then --0.47

                    if getElementSpeed(v, "km/h") >= 200 then
                        if not (z >= 0.6) then
                            setVehicleComponentPosition(v,component,x,y - 0.001,z + 0.001)
                        end 
                    else 
                        if not (z < 0.45) then
                            setVehicleComponentPosition(v,component,x,y + 0.001,z - 0.001)
                        end 
                    end

                        if isBrakeing(v) then 
                            if getElementSpeed(v,"km/h") > 80 then 
                                if not (rx <= 322) then
                                    setVehicleComponentRotation(v,component,rx - 1,ry,rz)
                                end 
                            end
                        else 
                            if not (math.floor(rx) >= 359) then
                                setVehicleComponentRotation(v,component,rx + 0.1,ry,rz)
                            end 
                        end

                end 
            elseif getVehicleType(v) == "Helicopter" then 
                if not getVehicleEngineState(v) then 
                    local speed = getHelicopterRotorSpeed(v)

                    if speed > 0 then
                        setHelicopterRotorSpeed(v, math.max(speed - 0.002, 0))
                    end
                end     
            end
        end
    end
end)

function isBrakeing(veh)
    thePlayer = getVehicleOccupant ( veh,0 ) or false

    if thePlayer then 
        brake = getPedControlState(thePlayer,"brake_reverse") or false 
        return brake
    else 
        return false
    end 
end     

local gvc = false
addCommandHandler ( "gvc",
    function ( )
        local theVehicle = getPedOccupiedVehicle ( localPlayer )
        if ( theVehicle ) then
            resetVehicleComponentPosition(theVehicle,"movspoiler_25_1300")
            resetVehicleComponentRotation(theVehicle,"movspoiler_25_1300")


            if not gvc then 
                gvc = true 
            else 
                gvc = false 
            end 
        end
    end
)

addEventHandler ( "onClientRender", root,
function()
    if gvc then 
	    if isPedInVehicle ( localPlayer ) and getPedOccupiedVehicle ( localPlayer ) then
	    	local veh = getPedOccupiedVehicle ( localPlayer )
	    	for v in pairs ( getVehicleComponents(veh) ) do
	    		local x,y,z = getVehicleComponentPosition ( veh, v, "world" )
	    		local wx,wy,wz = getScreenFromWorldPosition ( x, y, z )
	    		if wx and wy then
	    			dxDrawText ( v, wx -1, wy -1, 0 -1, 0 -1, tocolor(0,0,0), 1, "default-bold" )
	    			dxDrawText ( v, wx +1, wy -1, 0 +1, 0 -1, tocolor(0,0,0), 1, "default-bold" )
	    			dxDrawText ( v, wx -1, wy +1, 0 -1, 0 +1, tocolor(0,0,0), 1, "default-bold" )
	    			dxDrawText ( v, wx +1, wy +1, 0 +1, 0 +1, tocolor(0,0,0), 1, "default-bold" )
	    			dxDrawText ( v, wx, wy, 0, 0, tocolor(0,255,255), 1, "default-bold" )
	    		end
	    	end
	    end
    end
end)

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