local sx, sy = guiGetScreenSize()

local animValues = {}

function renderReaction()
    for k, v in ipairs(getElementsByType("player", root, true)) do
        local emoji = getElementData(v, "animation:emoji") or false 

        if emoji then 
            local startReaction = getElementData(v, "animation:start")
            if not animValues[v] then 
                animValues[v] = {0, 0, 0, 0, 0, 0}
            end
            animValues[v][1], animValues[v][2] = interpolateBetween(0, 1, 0, 1, 0, 0, (getTickCount() - startReaction) / 1200, "InOutQuad")
            animValues[v][3], animValues[v][4] = interpolateBetween(0, 1, 0, 1, 0, 0, (getTickCount() - startReaction) / 1500, "InOutQuad")
            animValues[v][5], animValues[v][6] = interpolateBetween(0, 1, 0, 1, 0, 0, (getTickCount() - startReaction) / 900, "InOutQuad")

            local px, py, pz = getElementPosition(v)
            pz = pz + 0.7 + (0.6 * animValues[v][1])


            local x, y = getScreenFromWorldPosition(px, py, pz)

            if x and y then

                --emoji = "xd"
                dxDrawImage(interpolateBetween(x - sx*0.025, 0, 0, x - sx*0.045, 0, 0, (getTickCount() - startReaction) / 7000, "OutInElastic"), y + sy*0.02, sx*0.02, sx*0.02, "files/emojis/"..emoji..".png", 0, 0, 0, tocolor(255, 255, 255, 255 * animValues[v][2]))

                --emoji = "sad"
                dxDrawImage(interpolateBetween(x - sx*0.005, 0, 0, x - sx*0.02, 0, 0, (getTickCount() - startReaction) / 7000, "OutInElastic"), y - sy*0.01, sx*0.02, sx*0.02, "files/emojis/"..emoji..".png", 0, 0, 0, tocolor(255, 255, 255, 255 * animValues[v][4]))
                
                --emoji = "love"
                dxDrawImage(interpolateBetween(x - sx*0.01, 0, 0, x + sx*0.015, 0, 0, (getTickCount() - startReaction) / 7000, "OutInElastic"), y - sy*0.022, sx*0.02, sx*0.02, "files/emojis/"..emoji..".png", 0, 0, 0, tocolor(255, 255, 255, 255 * animValues[v][6]))
                
                --emoji = "z"
                dxDrawImage(interpolateBetween(x + sx*0.01, 0, 0, x - sx*0.01 , 0, 0, (getTickCount() - startReaction) / 7000, "OutInElastic"), y + sy*0.045, sx*0.02, sx*0.02, "files/emojis/"..emoji..".png", 0, 0, 0, tocolor(255, 255, 255, 255 * animValues[v][4]))
                
                --emoji = "cry"
                dxDrawImage(interpolateBetween(x - sx*0.01, 0, 0, x + sx*0.025, 0, 0, (getTickCount() - startReaction) / 7000, "OutInElastic"), y + sy*0.015, sx*0.02, sx*0.02, "files/emojis/"..emoji..".png", 0, 0, 0, tocolor(255, 255, 255, 255 * animValues[v][6]))
                dxDrawImage(interpolateBetween(x - sx*0.01, 0, 0, x - sx*0.05, 0, 0, (getTickCount() - startReaction) / 7000, "OutInElastic"), y - sy*0.015, sx*0.02, sx*0.02, "files/emojis/"..emoji..".png", 0, 0, 0, tocolor(255, 255, 255, 255 * animValues[v][2]))
                dxDrawImage(interpolateBetween(x - sx*0.01, 0, 0, x , 0, 0, (getTickCount() - startReaction) / 7000, "OutInElastic"), y - sy*0.055, sx*0.02, sx*0.02, "files/emojis/"..emoji..".png", 0, 0, 0, tocolor(255, 255, 255, 255 * animValues[v][4]))
            end
        end
    end
end

for k, v in ipairs(getElementsByType("player", root, true)) do
    --setElementData(v, "animation:emoji", false)
    --setElementData(v, "animation:start", getTickCount())
end

--[[addEventHandler("onClientRender", root, function()
    renderReaction()
end)]]