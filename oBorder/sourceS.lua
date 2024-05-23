local core = exports.oCore
color, r, g, b = core:getServerColor()
color2, r2, g2, b2 = core:getColor("red-dark")
local connection = exports.oMysql:getDBConnection()




addEvent("warnAboutBorderSet", true)
addEventHandler("warnAboutBorderSet", getRootElement(), function(playerName, borderId, mode)
    triggerClientEvent(getRootElement(), "warnAboutBorderSet", getRootElement(), playerName, borderId, mode)
end)

addEvent("warnAboutBorderSet2", true)
addEventHandler("warnAboutBorderSet2", getRootElement(), function(playerName, mode)
    triggerClientEvent(getRootElement(), "warnAboutBorderSet2", getRootElement(), playerName, mode)
end)

addEvent("openTheBorder", true)
addEventHandler("openTheBorder", getRootElement(), function(borderId, borderColshapeId, vehicleElement, price)
    local playerSource = getVehicleOccupant ( vehicleElement )
    if getElementData(resourceRoot, "border."..borderId..".mode") == 1 then
        setElementData(resourceRoot, "border.".. borderId ..".state", true)
        
        dbQuery(function(qh)
            local result, numAff = dbPoll(qh, 0)
           -- print(numAff)
            local isWanted = false
            if numAff > 0 then 
                triggerClientEvent(getRootElement(),"warnAboutBorderCross", getRootElement(), vehicleElement, true, result[1])
            else 
                triggerClientEvent(getRootElement(),"warnAboutBorderCross", getRootElement(), vehicleElement, false, false)
            end
        end, connection,"SELECT * FROM mdcWantedCars WHERE numberPlate = ?", getVehiclePlateText(vehicleElement))

        setElementData(vehicleElement, "borderTargetColShapeId", borderColshapeId)
        setElementData(playerSource, "char:money", getElementData(playerSource, "char:money")-price)
        if exports["oInventory"]:hasItem(playerSource, 44, 1) then
            setElementData(playerSource, "atmRob:hasMoneyCaset", true)
            if not getElementData(playerSource, "atmRob:hasMoneyCaset") then
                outputChatBox(core:getServerPrefix("red-dark", "Határ", 3) .."A pénzkazetta jeladója újra aktív!",playerSource, 255, 255, 255, true)
            end
        end
        
    elseif getElementData(resourceRoot, "border."..borderId..".mode") == 3 then
        outputChatBox(core:getServerPrefix("red-dark", "Határ", 3).."Ez a határ zárva van!",playerSource, 255, 255, 255, true)
    end
end)

addEvent("openTheBorderManual", true)
addEventHandler("openTheBorderManual", getRootElement(), function(borderId)
    if getElementData(resourceRoot, "border."..borderId..".mode") == 3 then
        setElementData(resourceRoot, "border.".. borderId ..".state", true)
    else 
        outputChatBox(core:getServerPrefix("red-dark", "Határ", 3).."Ez a funkció nem elérhető mivel a kapu nem 3-as módban van!",playerSource, 255, 255, 255, true)
    end
end)

addEvent("closeTheBorder", true)
addEventHandler("closeTheBorder", getRootElement(), function(borderId, borderColshapeId, vehicleElement)
    setElementData(resourceRoot, "border.".. borderId ..".state", false)
    setElementData(vehicleElement, "borderTargetColShapeId", nil)
  --  outputChatBox("zar")
end)

addEvent("closeTheBorderManual", true)
addEventHandler("closeTheBorderManual", getRootElement(), function(borderId)
    if getElementData(resourceRoot, "border."..borderId..".mode") == 3 then
        setElementData(resourceRoot, "border.".. borderId ..".state", false)
    else 
        outputChatBox(core:getServerPrefix("red-dark", "Határ", 3).."Ez a funkció nem elérhető mivel a kapu nem 3-as módban van!",playerSource, 255, 255, 255, true)
    end
end)