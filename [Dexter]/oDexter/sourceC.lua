
addEventHandler("onClientClick", getRootElement(), function(button, state, absX,absY, worldX,worldY,worldZ, clickElement)
    if button == "left" and state == "down" and getElementData(localPlayer, "developmentMode") then 
        local x,y,z = getElementPosition(clickElement)
        outputChatBox(getElementType(clickElement) .. " | ".. getElementModel(clickElement))
        outputChatBox("Pos: ".. x .."," .. y .. "," .. z)
    end
end)    