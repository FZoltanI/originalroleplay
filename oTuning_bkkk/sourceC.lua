addEventHandler("onClientResourceStart", getRootElement(), function(res)
    local resName = getResourceName(res)

    if table.contains(usedScripts, resName) then 
        cmarker = exports.oCustomMarker
        font = exports.oFont
        core = exports.oCore
        infobox = exports.oInfobox
        color, r, g, b = core:getServerColor()
    end
end)

function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

fonts = {
    ["condensed-11"] = font:getFont("condensed", 11),
    ["condensed-13"] = font:getFont("condensed", 13),
    ["bebasneue-25"] = font:getFont("bebasneue", 25),
}

sx, sy = guiGetScreenSize()
screenX, screenY = guiGetScreenSize()
myX, myY = 1768, 992 
responsiveMultipler = 1

function resp(value)
    return value * responsiveMultipler
end

function respc(value)
    return math.ceil(value * responsiveMultipler)
end

function reMap(value, low1, high1, low2, high2)
    return (value - low1) * (high2 - low2) / (high1 - low1) + low2
end
  
fontSizeMultipler = reMap(screenX, 1024, 1920, 0.7, 1)
menuPosX = respc(20)
menuPosY = screenY - respc(50)
rowHeight = respc(135)
vehicleElement = false
local currentPage = 1
local maxRowPerPage = 7
local hoveredCategory, selectedCategory, selectedSubCategory = 1, 0, 0


addEventHandler("onClientRender", getRootElement(), function()
    dxDrawImage(sx*0.7 -63/myX*sx, 0-25/myX*sx, 80/myX*sx, 50/myY*sy, "files/triangle.png", 270, 0, 0, tocolor(35, 35, 35, 255))
    dxDrawRectangle(sx*0.7, 0, sx*0.3, sy*0.04, tocolor(35, 35, 35, 255), true)
    dxDrawText(color.."[Backspace]: #ffffffVisszalépés, "..color.."[Enter]: #ffffffTovábblépés, "..color.."[Nyilak]: #ffffffNavigálás", sx*0.7, 0, sx*0.7+sx*0.3, sy*0.04, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["condensed-13"], "center", "center", false, false, true, true)

    dxDrawImage(sx*0.11, 0-25/myY*sy, 80/myX*sx, 50/myY*sy, "files/triangle.png", 90, 0, 0, tocolor(35, 35, 35, 255))
    dxDrawImage(sx*0.07, sy*0.04-25/myY*sy, 80/myX*sx, 50/myY*sy, "files/triangle.png", 90, 0, 0, tocolor(33, 33, 33, 255))
    dxDrawRectangle(0, 0, sx*0.12, sy*0.04, tocolor(35, 35, 35, 255))
    dxDrawRectangle(0, sy*0.04, sx*0.08, sy*0.04, tocolor(33, 33, 33, 255))

    dxDrawImage(sx*0.005, sy*0.003, 35/myX*sx, 35/myY*sy, "files/dollar.png", 0, 0, 0, tocolor(78, 191, 107, 255))
    dxDrawText(getElementData(localPlayer, "char:money").."#ffffff$", sx*0.03, 0, sx*0.03+sx*0.09, sy*0.04, tocolor(78, 191, 107, 255), 1/myX*sx, fonts["condensed-13"], "center", "center", false, false, false, true)
    dxDrawImage(sx*0.005, sy*0.043, 35/myX*sx, 35/myY*sy, "files/premium.png", 0, 0, 0, tocolor(62, 151, 230, 255))
    dxDrawText(getElementData(localPlayer, "char:pp").."#ffffffPP", sx*0.03, sy*0.04, sx*0.03+sx*0.05, sy*0.08, tocolor(62, 151, 230, 255), 1/myX*sx, fonts["condensed-13"], "center", "center", false, false, false, true)





end)