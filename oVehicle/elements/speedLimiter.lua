local vehicle = nil 
local maxSpeed = 0

local bikes = {
    [509] = 27,
    [481] = 29,
    [510] = 28,
}

function checkBicycleSpeed()
    if not getPedOccupiedVehicle(localPlayer) == vehicle or not isElement(vehicle) then 
        removeEventHandler("onClientPreRender", root, checkBicycleSpeed)
        return
    end

    if getPedControlState(localPlayer, "accelerate") then
        if getElementSpeed(vehicle, "km/h") > maxSpeed then 
            setElementSpeed(vehicle, "km/h", maxSpeed)
        end
    end
end

addEventHandler("onClientVehicleEnter", root, function(player, seat)
    if player == localPlayer then 
        if seat == 0 then 
            if bikes[getElementModel(source)] then 
                maxSpeed = bikes[getElementModel(source)] 
                vehicle = source

                addEventHandler("onClientPreRender", root, checkBicycleSpeed)
            end
        end
    end
end)

addEventHandler("onClientVehicleExit", root, function(player, seat)
    if player == localPlayer then 
        if vehicle == source then
            removeEventHandler("onClientPreRender", root, checkBicycleSpeed)
            maxSpeed = 0
            vehicle = false
        end
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