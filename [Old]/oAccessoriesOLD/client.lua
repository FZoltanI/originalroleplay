function loadModels()
    for k, v in ipairs(accessories) do 
        local txd = engineLoadTXD("models/"..v.texture)
        engineImportTXD(txd, v.objID)

        local dff = engineLoadDFF("models/"..v.model)
        engineReplaceModel(dff, v.objID)
    end
end
addEventHandler("onClientResourceStart", resourceRoot, loadModels)

createObject(11515, 1229.6975097656, -1373.2945556641, 13.388954162598)

local sx, sy = guiGetScreenSize()
local myX, myY = 1600, 900 

local panelPos = {sx*0.4, sy*0.28}

local fonts = {
    ["condensed-13"] = exports.oFont:getFont("condensed", 13),
    ["bebasneue-18"] = exports.oFont:getFont("bebasneue", 18),
}

local myAccessories = {
    {1, true},
    {2, true},
    {3, false},
}

local pointer = 0

function drawAccessoriesPanel()
    dxDrawRectangle(panelPos[1], panelPos[2], sx*0.2, sy*0.445, tocolor(35, 35, 35, 255))
    dxDrawRectangle(panelPos[1]+2/myX*sx, panelPos[2]+2/myY*sy, sx*0.2-4/myX*sx, sy*0.07, tocolor(30, 30, 30, 255))

    dxDrawText("Kiegészítők", panelPos[1]+2/myX*sx, panelPos[2]+2/myY*sy, panelPos[1]+2/myX*sx+sx*0.2-4/myX*sx, panelPos[2]+2/myY*sy+sy*0.055, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["bebasneue-18"], "center", "center")
    dxDrawText("Szervezeti kiegészítők", panelPos[1]+2/myX*sx, panelPos[2]+2/myY*sy, panelPos[1]+2/myX*sx+sx*0.2-4/myX*sx, panelPos[2]+2/myY*sy+sy*0.11, tocolor(r, g, b, 255), 0.6/myX*sx, fonts["bebasneue-18"], "center", "center")

    local startY = panelPos[2]+2/myY*sy+sy*0.073
    for i = 1, 10 do 
        local color = tocolor(30, 30, 30, 200)
        local color2 = tocolor(r, g, b, 240)

        if i % 2 == 0 then 
            color = tocolor(30, 30, 30, 150)
            color2 = tocolor(r, g, b, 150)
        end

        dxDrawRectangle(panelPos[1]+2/myX*sx, startY, sx*0.18, sy*0.035, color)

        if myAccessories[i+pointer] then 
            local v = myAccessories[i+pointer]
            dxDrawRectangle(panelPos[1]+2/myX*sx, startY, sx*0.001, sy*0.035, color2)

            if v[2] then 
                dxDrawText(accessories[v[1]].name, panelPos[1]+35/myX*sx, startY, panelPos[1]+35/myX*sx+sx*0.18, startY+sy*0.035, tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["condensed-13"], "left", "center")

                if core:isInSlot(panelPos[1]+8/myX*sx, startY+5/myY*sy, 20/myX*sx, 20/myY*sy) then 
                    dxDrawImage(panelPos[1]+8/myX*sx, startY+5/myY*sy, 20/myX*sx, 20/myY*sy, "images/cross.png", 0, 0, 0, tocolor(232, 78, 67, 255))
                else
                    dxDrawImage(panelPos[1]+8/myX*sx, startY+5/myY*sy, 20/myX*sx, 20/myY*sy, "images/cross.png", 0, 0, 0, tocolor(232, 78, 67, 100))
                end

                if core:isInSlot(panelPos[1]+sx*0.165, startY+5/myY*sy, 20/myX*sx, 20/myY*sy) then
                    dxDrawImage(panelPos[1]+sx*0.165, startY+5/myY*sy, 20/myX*sx, 20/myY*sy, "images/modify.png", 0, 0, 0, tocolor(232, 78, 67, 255))
                else
                    dxDrawImage(panelPos[1]+sx*0.165, startY+5/myY*sy, 20/myX*sx, 20/myY*sy, "images/modify.png", 0, 0, 0, tocolor(232, 78, 67, 100))
                end

                if accessories[v[1]].factionIcon then 
                    dxDrawImage(panelPos[1]+35/myX*sx+dxGetTextWidth(accessories[v[1]].name, 0.8/myX*sx, fonts["condensed-13"])+3/myX*sx, startY+5/myY*sy, 20/myX*sx, 20/myY*sy, "images/"..accessories[v[1]].factionIcon..".png", 0, 0, 0, tocolor(255, 255, 255, 255))
                end
            else
                dxDrawText(accessories[v[1]].name, panelPos[1]+8/myX*sx, startY, panelPos[1]+8/myX*sx+sx*0.18, startY+sy*0.035, tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["condensed-13"], "left", "center")

                if accessories[v[1]].factionIcon then 
                    dxDrawImage(panelPos[1]+8/myX*sx+dxGetTextWidth(accessories[v[1]].name, 0.8/myX*sx, fonts["condensed-13"])+3/myX*sx, startY+5/myY*sy, 20/myX*sx, 20/myY*sy, "images/"..accessories[v[1]].factionIcon..".png", 0, 0, 0, tocolor(255, 255, 255, 255))
                end
            end
        end

        startY = startY + sy*0.037
    end
end
if getElementData(localPlayer, "playerid") == 1 then addEventHandler("onClientRender", root, drawAccessoriesPanel) end