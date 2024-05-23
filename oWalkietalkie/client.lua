local sx, sy = guiGetScreenSize()
local myX, myY = 1600, 900

local tick = getTickCount()
local animType = "open"

local size = 0.4
local font = exports.oFont 

local fonts = {
    ["lcd-13"] = font:getFont("lcd", 13),
}

function renderWalkietalkie()
    local a 

    
    if animType == "open" then 
        a = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount() - tick) / 350, "Linear")
    else
        a = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount() - tick) / 350, "Linear")
    end

    dxDrawImage(sx*0.885, sy*0.25, 439/myX*sx*size, 1151/myY*sy*size, "files/walkietalkie.png", 0, 0, 0, tocolor(255, 255, 255, 255*a))

    --dxDrawRectangle(sx*0.912, sy*0.476, sx*0.06, sy*0.05, tocolor(255, 255, 255, 200))
    dxDrawText("25336", sx*0.912, sy*0.476, sx*0.912+sx*0.06, sy*0.476+sy*0.05, tocolor(0, 0, 0, 255*a), 1/myX*sx, fonts["lcd-13"], "center", "center")
end
addEventHandler("onClientRender", root, renderWalkietalkie)