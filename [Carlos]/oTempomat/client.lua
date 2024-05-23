local state = false
local nowSpeed = false

local function setElementSpeed(element, unit, speed)
	speed = tonumber(speed)
	local acSpeed = math.floor(getElementSpeed(element, "km/h")*1)
	if (acSpeed~=false) then 
		local diff = speed/acSpeed
		local x,y,z = getElementVelocity(element)
		setElementVelocity(element,x*diff,y*diff,z*diff)
		return true
	else
		return false
	end
end

function toggleTempomat()
    if isChatBoxInputActive() then return end
    local veh = getPedOccupiedVehicle(localPlayer)
    if veh then
        if getVehicleTowedByVehicle(veh) then return end
        if not allowedTypes[getVehicleType(veh)] then return end
        if getPedOccupiedVehicleSeat(localPlayer) == 0 then
            local speed = getElementSpeed(veh)
            if not state and speed > 10 then
                if not isVehicleOnGround(veh) then return end
                
                if tonumber(getSurfaceVehicleIsOn(veh)) and tonumber(getSurfaceVehicleIsOn(veh)) == 178 then
                    return
                end
                
                sourceVeh = veh
                nowSpeed = math.floor(getElementSpeed(veh))
                setElementData(veh, "tempomat", true)
                setElementData(veh, "tempomat.speed", nowSpeed)
               
                addEventHandler("onClientPreRender", root, doingTempo, true, "high")
        
                state = true
            elseif state then
                setElementData(veh, "tempomat", false)
                setPedControlState(localPlayer, "accelerate", false)
                setPedControlState(localPlayer, "brake_reverse", false)
                removeEventHandler("onClientPreRender", root, doingTempo)
                state = false
            end
        end
    end
end

addEventHandler("onClientPlayerVehicleExit", root,
    function(veh, seat)
        if source == localPlayer then
            if state then
                tempomatOff()
            end
        end
    end
)

addEventHandler("onClientElementDataChange", localPlayer, 
    function(dName)
        local value = getElementData(source, dName)
        if dName == "playerInDead" then
            if value then
                if state then
                    tempomatOff()
                end
            end
        end
    end
)

addEventHandler("onClientElementDestroy", root,
    function()
        if getElementType(source) == "vehicle" then
            local veh = getPedOccupiedVehicle(localPlayer)
            if veh == source then
                if state then
                    tempomatOff()
                end
            end
        end
    end
)

bindKey("c", "down", toggleTempomat)
bindKey("accelerate", "down", 
    function()
        if state then
            tempomatOff()
        end
    end
)

bindKey("handbrake", "down",
    function()
        if state then
            tempomatOff()
        end
    end
)

bindKey("brake_reverse", "down", 
    function()
        if state then
            tempomatOff()
        end
    end
)

addEventHandler("onClientVehicleDamage", root,
    function(attacker, weapon, loss)
        local veh = getPedOccupiedVehicle(localPlayer)
        if veh then
            if veh == source then
                local seat = getPedOccupiedVehicleSeat(localPlayer)
                if seat == 0 then
                    if state then
                        tempomatOff()
                    end
                end
            end
        end
    end
)

bindKey("num_sub", "down",
    function()
        if state then
            if nowSpeed - 2 >= 10 then
                nowSpeed = nowSpeed - 2
            
                setElementData(sourceVeh, "tempomat.speed", nowSpeed)
            end
        end
    end
)

bindKey("num_add", "down",
    function()
        if state then
            local t = getVehicleHandling(sourceVeh)
            local maxVelocity = t["maxVelocity"]
            if nowSpeed + 2 <= maxVelocity then
                nowSpeed = nowSpeed + 2
              
                setElementData(sourceVeh, "tempomat.speed", nowSpeed)
            end
        end
    end
)

function getElementSpeed( element, unit )
    local vehicle = getPedOccupiedVehicle(localPlayer)
    if isPedInVehicle(localPlayer) then
        local vx, vy, vz = getElementVelocity(getPedOccupiedVehicle(localPlayer))
        return math.sqrt(vx^2 + vy^2 + vz^2) * 180      
    end
    return 0
end

local sx, sy = guiGetScreenSize()

setTimer(
    function()
        if state then
            local veh = getPedOccupiedVehicle(localPlayer)
            if veh and getPedOccupiedVehicleSeat(localPlayer) == 0 then
                if tonumber(getSurfaceVehicleIsOn(veh)) and tonumber(getSurfaceVehicleIsOn(veh)) == 178 then
                    tempomatOff()
                    return
                end
            end
        end
    end, 250, 0
)

function doingTempo()
    if getElementHealth(sourceVeh) < 250 or not getElementData(sourceVeh, "veh:engine") or getElementData(sourceVeh, "veh:fuel") <= 0 then
        tempomatOff()
    end
    
    nowSpeed = getElementData(sourceVeh, "tempomat.speed")
    local speed = math.floor(getElementSpeed(sourceVeh))
    if speed == nowSpeed or (speed - nowSpeed) == 1 or (nowSpeed - speed) == 1 then
        setPedControlState(localPlayer, "accelerate", false)
        setPedControlState(localPlayer, "brake_reverse", false)
        setElementSpeed(sourceVeh, 1, nowSpeed)
    elseif speed < nowSpeed then
        setPedControlState(localPlayer, "accelerate", true)
        setPedControlState(localPlayer, "brake_reverse", false)
    elseif speed > nowSpeed then
        setPedControlState(localPlayer, "accelerate", false)
        setPedControlState(localPlayer, "brake_reverse", true)
    end
end

function tempomatOff()
    setElementData(getPedOccupiedVehicle(localPlayer), "tempomat", false)
    setPedControlState(localPlayer, "accelerate", false)
    setPedControlState(localPlayer, "brake_reverse", false)
    removeEventHandler("onClientPreRender", root, doingTempo)
    state = false
end

addEventHandler("onClientElementDataChange", root, function(data, old, new)
    if source == getPedOccupiedVehicle(localPlayer) then 
        if data == "tempomat" then 
            if new == false then 
                tempomatOff()
            elseif new == true then 
                local speed = getElementSpeed(source)
                if not state and speed > 10 then
                    if not isVehicleOnGround(source) then return end
                    
                    if tonumber(getSurfaceVehicleIsOn(source)) and tonumber(getSurfaceVehicleIsOn(source)) == 178 then
                        return
                    end
                    
                    sourceVeh = source
                    nowSpeed = math.floor(getElementSpeed(source))
                    setElementData(source, "tempomat", true)
                    setElementData(source, "tempomat.speed", nowSpeed)
                   
                    addEventHandler("onClientPreRender", root, doingTempo, true, "high")
            
                    state = true
                end
            end
        elseif data == "tempomat.speed" then
            nowSpeed = new
        end
    end
end)