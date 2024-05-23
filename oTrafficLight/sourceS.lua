local core = exports["oCore"]
local color, r, g, b = core:getServerColor()

-- oCity-main maps ba vannak a táblák manuálisan lerakva 

function trafficlight_sendTicket(element)
    outputChatBox(core:getServerPrefix("server").."Átmentél egy piroslámpán!", element ,255, 255, 255, true)
    outputChatBox(core:getServerPrefix("server").."Büntetésed ".. color .."35$#FFFFFF!", element ,255, 255, 255, true)
    setElementData(element, "char:money", getElementData(element, "char:money")-35)
end

function tralightCheck(playerElement, vehicleElement, objRot1)
        if playerElement and getElementType(playerElement) == "player" and not getElementData(playerElement, "user:aduty") then
            local vehicleType = getVehicleType(vehicleElement)
            if vehicleType == "Automobile" or vehicleType == "Bike" or vehicleType == "Monster Truck" or vehicleType == "Quad" then
                local _, _, vehRot = getElementRotation(vehicleElement)
                local vehRot1 = getRoundedRotation(vehRot)
                if objRot1 == vehRot1 or not objRot1 or not vehRot1 then
                    local lightState = getTrafficLightState()
                    if objRot1 == 90 or objRot1 == 270 then
                        if lightState == 0 or lightState == 1 or lightState == 2 then
                            trafficlight_sendTicket(playerElement)
                        end
                    elseif objRot1 == 0 or objRot1 == 180 then
                        if lightState == 4 or lightState == 3 or lightState == 2 then
                            trafficlight_sendTicket(playerElement)
                        end
                    end
                end
            end
        end
    end
    addEvent("tralightCheck", true)
    addEventHandler("tralightCheck", root, tralightCheck)