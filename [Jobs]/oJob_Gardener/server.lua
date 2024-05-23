addEvent("gardener > createTrashBag", true)
addEventHandler("gardener > createTrashBag", resourceRoot, function() 
    local playerpos = Vector3(getElementPosition(client))
    local trashbag = createObject(1264, playerpos.x, playerpos.y, playerpos.z)

    setElementCollisionsEnabled(trashbag, false)
    setObjectScale(trashbag, 0.35)

    setElementData(client, "player:trashbag", trashbag)

    bone:attachElementToBone(trashbag, client, 11, 0.03, 0.02, 0.2, 180, 0, 0)
end)

addEvent("gardener > destroyTrashBag", true)
addEventHandler("gardener > destroyTrashBag", resourceRoot, function()
    destroyElement(getElementData(client, "player:trashbag"))
    setElementData(client, "player:trashbag", false)
end)