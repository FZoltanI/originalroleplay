local core = exports.oCore

local door = createObject(1502, 1510.1849365234, -1791.3331298828, 19.130313873291)
setElementFrozen(door, true)


--[[addEventHandler("onClientRender", root, function()
    local posX, posY, posZ = core:getPositionFromElementOffset(door, 1.45, 0, 1)
    local posX2, posY2, posZ2 = core:getPositionFromElementOffset(door, 0.8, 0, 1)

    local renderX, renderY = getScreenFromWorldPosition(posX, posY, posZ)
    local renderX2, renderY2 = getScreenFromWorldPosition(posX2, posY2, posZ2)

    if renderX and renderY then 
        dxDrawText("", renderX + 1.5, renderY + 1.5, _, _, tocolor(0, 0, 0, 100), 1, exports.oFont:getFont("fontawesome2", 15))
        dxDrawText("", renderX, renderY, _, _, tocolor(235, 52, 52, 100), 1, exports.oFont:getFont("fontawesome2", 15))
    end

    if renderX2 and renderY2 then 
        dxDrawText("", renderX2 + 1.5, renderY2 + 1.5, _, _, tocolor(0, 0, 0, 100), 1, exports.oFont:getFont("fontawesome2", 25))
        dxDrawText("", renderX2, renderY2, _, _, tocolor(255, 255, 255, 100), 1, exports.oFont:getFont("fontawesome2", 25))
    end
end)    ]]