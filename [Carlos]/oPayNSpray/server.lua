local doors = {}
local cols = {}

for k, v in ipairs(points) do 
--    local obj = createObject(v.obj, v.close[1], v.close[2], v.close[3], 0, 0, v.close[4])

--    moveObject(obj, 6000, v.open[1], v.open[2], v.open[3], 0, 90, 0, "Linear")
--    doors[k] = obj

    local col = createColTube(v.col[1], v.col[2], v.col[3]-1, 4, 5)
    setElementData(col, "PayAndSpray:ID", k)
    cols[k] = col

    setElementData(createBlip(v.col[1], v.col[2], v.col[3], 40), "blip:name", "Pay N Spray")
end

function startVehicleFixing(veh, price, garageID, fixableElements)
    local veh = veh 
    local price = price 
    local garageID = garageID
    local player = client
    setElementData(client, "char:money", getElementData(client, "char:money")-price)

  --  local rot = {getElementRotation(doors[garageID])}

    --moveObject(doors[garageID], 6000, points[garageID].close[1], points[garageID].close[2], points[garageID].close[3], 0, -90, 0, "Linear")
    setElementFrozen(veh, true)

    setTimer(function()
        if isElement(veh) then 
            setElementFrozen(veh, false)
            setElementHealth(veh, 1000)

            for k, v in ipairs(fixableElements) do 
                if vehicleMechanicComponents[v].panelID then 
                    setVehiclePanelState(veh, vehicleMechanicComponents[v].panelID, 0)
                elseif vehicleMechanicComponents[v].doorID then 
                    setVehicleDoorState(veh, vehicleMechanicComponents[v].doorID, 1)
                elseif vehicleMechanicComponents[v].wheelID then 
                    local wheels = {getVehicleWheelStates(veh)}
                    wheels[vehicleMechanicComponents[v].wheelID] = 0
                    setVehicleWheelStates(veh, unpack(wheels))
                end        
            end
        end

        --moveObject(doors[garageID], 6000, points[garageID].open[1], points[garageID].open[2], points[garageID].open[3], 0, 90, 0, "Linear")
        triggerClientEvent(player, "PayNSpray > end", player)
    end, 10000, 1)
end
addEvent("PayNSpray > startVehFixing", true)
addEventHandler("PayNSpray > startVehFixing", resourceRoot, startVehicleFixing)