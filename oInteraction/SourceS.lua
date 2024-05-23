for k,v in ipairs(getElementsByType("vehicle")) do 
    if getElementModel(v) == 416 then 
        setElementData(v, "veh:Stretcher", true)
    end
end

addEventHandler("onResourceStart",getResourceRootElement(getThisResource()),function()
    removeElementData(source, "strecher.objectAttached")
end)


function CreateStrecher(thePlayer)
    local x,y,z = getElementPosition(thePlayer)
    strecherElement[thePlayer] = createObject( 1356, x+1.75, y-1.75, z)
    setElementData(strecherElement[thePlayer], "strecher.isObject", strecherElement[thePlayer])
    setElementData(strecherElement[thePlayer], "strecher.objectAttached", thePlayer)
    setElementData(thePlayer, "strecher.objectAttached", strecherElement[thePlayer])
    attachElements( strecherElement[thePlayer], thePlayer, 0, 1.75, 0, 0, 0, 90)
end
addEvent( "strecher.CreateStrecher", true)
addEventHandler( "strecher.CreateStrecher", getRootElement(), CreateStrecher)

addEvent("strecher.dropDown",true)
addEventHandler("strecher.dropDown", getRootElement(), function(selectedObject, thePlayer)
    if isElementAttached(selectedObject) then 
      detachElements(selectedObject,thePlayer)
      local rotX,rotY,rotZ = getElementRotation(thePlayer)
      setElementRotation(selectedObject, 0, 0, rotZ+90) 
      setElementData(selectedObject, "strecher.objectAttached", nil)
      setElementData(thePlayer, "strecher.objectAttached", nil)
    end
end)


addEvent("strecher.pickup",true)
addEventHandler("strecher.pickup", getRootElement(), function(selectedObject, thePlayer)
    setElementData(selectedObject, "strecher.objectAttached", thePlayer)
    setElementData(thePlayer, "strecher.objectAttached", selectedObject)
    attachElements( selectedObject, thePlayer, 0, 1.75, 0, 0, 0, 90)
end)

addEvent("strecher.DeleteStrecher", true)
addEventHandler("strecher.DeleteStrecher", getRootElement(), function(thePlayer)
    if isElement(strecherElement[thePlayer]) then
        setElementData(strecherElement[thePlayer], "strecher.objectAttached", nil)
        setElementData(thePlayer, "strecher.objectAttached", nil)
        destroyElement( strecherElement[thePlayer]) 
    end
end)

addEvent("stretcher.playerAnim",true)
addEventHandler("stretcher.playerAnim", getRootElement(), function(element, state)
    if state then 
        setPedAnimation(element, "crack", "crckidle1", -1, true, false, false, false)
    else 
        setPedAnimation(element) 
    end
end)

addEvent("apiaryLockedHandler",true)
addEventHandler("apiaryLockedHandler", getRootElement(), function(player, element)
    exports["oApiary"]:changeLockApiary(element, player)
end)

addEvent("apiaryBeeBuy",true)
addEventHandler("apiaryBeeBuy", getRootElement(), function(player, element)
    exports["oApiary"]:buyBee(element, player)
end)

addEvent("apiaryCollect",true)
addEventHandler("apiaryCollect", getRootElement(), function(player, element)
    exports["oApiary"]:collectHoney(element, player)
end)

addEvent("apiaryCleaning",true)
addEventHandler("apiaryCleaning", getRootElement(), function(player, element)
    exports["oApiary"]:apiaryCleaning(element, player)
end)

addEvent("apiaryUp",true)
addEventHandler("apiaryUp", getRootElement(), function(player, element)
    exports["oApiary"]:pickUpApiary(element, player)
end)

--warpPedIntoVehicle(savedElement, vehicle, i)

addEvent("warpPedIntoVeh", true)
addEventHandler("warpPedIntoVeh", getRootElement(), function(element, vehicle, seat)
    warpPedIntoVehicle(element, vehicle, seat)
end)