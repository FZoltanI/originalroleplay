local sx, sy = guiGetScreenSize()
local myX, myY = 1600, 900 

local selectedLevel = 1
local notExistElements = {1, 4}

function renderMinigame()
    local startX = sx*0.77
    local startY = sy*0.53

    dxDrawRectangle(startX, startY, sx*0.21, sy*0.38, tocolor(35, 35, 35, 100))

    for k, v in pairs(pipes[selectedLevel]) do
        
        if type(v) == "table" then 
            if core:tableContains(notExistElements, k) then     
                dxDrawImage(startX + v[1]*sx, startY + v[2]*sy, v[3]/myX*sx, v[4]/myY*sy, "files/pipes/"..pipes[selectedLevel].folder.."/"..v[5]..".png", v[6], v[7], v[8], tocolor(255, 255, 255, 100))
            else
                dxDrawImage(startX + v[1]*sx, startY + v[2]*sy, v[3]/myX*sx, v[4]/myY*sy, "files/pipes/"..pipes[selectedLevel].folder.."/"..v[5]..".png", v[6], v[7], v[8], tocolor(255, 255, 255, 255))
            end
        end
    end

    dxDrawImage(0, 0, sx, sy, "files/1.png")


end
addEventHandler("onClientRender", root, renderMinigame)