addEvent("createSkinObject", true)
addEventHandler("createSkinObject", getResourceRootElement(), function(player)
    local pX, pY, pZ = getElementPosition(player)
    local obj = createObject(skinObject[math.random(#skinObject)],pX,pY,pZ)

    setElementCollisionsEnabled(obj, false)
    setElementData(player,"skinhop>selected_skin>model", obj)

    bone:attachElementToBone(obj,player,11,-0.17,0.05,0.15,0,100,100)
    setPedAnimation(player, "CARRY", "crry_prtial", 0, true, false, true, true)
end)