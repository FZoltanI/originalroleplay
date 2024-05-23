local lightCache = {}

function handleTrafficLightsOutOfOrder()
	local time = getRealTime()
	local lightsOff = getTrafficLightState() == 9
	if time.hour >= 23 or time.hour <= 5 then
	    if lightsOff then
	        setTrafficLightState(6)
	    else
	        setTrafficLightState(9)
	    end
	    setTrafficLightsLocked(true)
	else
		if lightsOff then
			setTrafficLightState(6)
			setTrafficLightsLocked(false)
		end
	end
end
setTimer(handleTrafficLightsOutOfOrder,500,0)

addEventHandler("onClientObjectBreak", root,
	function()
		if lightObjects[getElementModel(source)] then
			cancelEvent()
		end
	end
)

addEventHandler("onClientColShapeLeave", root,
	function(element)
        if not isElement(source) then return end
        --outputChatBox("asd4")
		if getElementData(source, "trafficlight") then
            --outputChatBox("asd3")
			if getElementType(element) == "vehicle" then
                --outputChatBox("asd2")
				local playerElement = getVehicleController(element)
				if playerElement and playerElement == localPlayer then
					if not getPedControlState("brake_reverse") then
                        local _, _, a = getElementRotation(lightCache[source])
                        local rot = getRoundedRotation(a)
						triggerServerEvent("tralightCheck", localPlayer, localPlayer, element, rot)
					end
				end
			end
		end
	end
)


addEventHandler("onClientResourceStart", resourceRoot,
	function()
        setTimer(function()
            for key, value in pairs(getElementsByType("object")) do
                local model = getElementModel(value)
                --outputChatBox("asd")
                if lightObjects[model] then
                    --outputChatBox("asd")
                    local lightX, lightY, lightZ = getElementPosition(value)
                    local radius, height, offsetX, offsetY, offsetY = unpack(lightObjects[model])
                    local colshape = createColTube(lightX, lightY, lightZ, radius, height)
                   -- value.collisions = true
                   
                    attachElements(colshape, value, offsetX, offsetY, offsetY)
                    setElementData(colshape, "trafficlight", true)
                    lightCache[colshape] = value
                end
            end
        end,1500,1)
	end
)