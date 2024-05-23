function renderPositionInfos()
    for k, v in ipairs(getElementsByType("marker")) do 
        if getElementData(v, "carDealership:isEmptyPosition") then 
            local posX, posY, posZ = getElementPosition(v)
            local dis = core:getDistance(v, localPlayer)
            
            if dis < 8 then 
                local renderX, renderY = getScreenFromWorldPosition(posX, posY, posZ + 1.5)
                if renderX and renderY then
                    local sizeX, sizeY = 300, 40
                    local distance = 1 - (dis/8) 

                    sizeX = sizeX * distance
                    sizeY = sizeY * distance

                    dxDrawRectangle(renderX-sizeX/2, renderY, sizeX, sizeY, tocolor(30, 30, 30, 200))
                    dxDrawText("Üres jármű slot", renderX-sizeX/2, renderY, renderX+sizeX/2, renderY+sizeY, tocolor(255, 255, 255, 255), 1*distance, font:getFont("condensed", 15), "center", "center")
                end
            end
        end
    end
end
addEventHandler("onClientRender", root, renderPositionInfos)

local sx, sy = guiGetScreenSize()
local myX, myY = 1768, 992
local panelAlpha = 1
local selectedMenu = 1

_dxDrawText = dxDrawText 
function dxDrawText(text, x, y, w, h, ...)
    _dxDrawText(text, x, y, x + w, y + h, ...)
end

local carshopDatas = {
    ["carPoints"] = {
        [5] = {pos = {1, 1, 1, 1}, car = 48, price = false},
        [6] = {pos = {1, 1, 1, 1}, car = false, price = false},
        [7] = {pos = {1, 1, 1, 1}, car = false, price = false},
        [9] = {pos = {1, 1, 1, 1}, car = 77, price = 12500},
        [10] = {pos = {1, 1, 1, 1}, car = false, price = false},
        [11] = {pos = {1, 1, 1, 1}, car = false, price = false},
        [12] = {pos = {1, 1, 1, 1}, car = false, price = false},
        [13] = {pos = {1, 1, 1, 1}, car = false, price = false},
    },
}

local selectedPanelElement = 1

local panelCarElements = {}

function renderCarshopPanel()
    -- Bg
    dxDrawRectangle(sx*0.25, sy*0.25, sx*0.5, sy*0.5, tocolor(30, 30, 30, 100 * panelAlpha))
    dxDrawRectangle(sx*0.25 + 2/myX*sx, sy*0.25 + 2/myY*sy, sx*0.5 - 4/myX*sx, sy*0.5 - 4/myY*sy, tocolor(35, 35, 35, 255 * panelAlpha))

    -- Header
    dxDrawRectangle(sx*0.25 + 2/myX*sx, sy*0.25 + 2/myY*sy, sx*0.5 - 4/myX*sx, sy*0.02, tocolor(30, 30, 30, 255 * panelAlpha))
    dxDrawText("Original"..color.."Roleplay", sx*0.25 + 5/myX*sx, sy*0.25 + 2/myY*sy, sx*0.5 - 4/myX*sx, sy*0.02, tocolor(255, 255, 255, 100 * panelAlpha), 1, font:getFont("condensed", 9/myX*sx), "left", "center", false, false, false, true)
    dxDrawText("Használtautó kereskedés", sx*0.25 + 2/myX*sx, sy*0.25 + 2/myY*sy, sx*0.5 - 7/myX*sx, sy*0.02, tocolor(255, 255, 255, 100 * panelAlpha), 1, font:getFont("condensed", 9/myX*sx), "right", "center", false, false, false, true)

    -- Navbar
    dxDrawRectangle(sx*0.25 + 2/myX*sx, sy*0.71, sx*0.5 - 4/myX*sx, sy*0.04 - 2/myY*sy, tocolor(30, 30, 30, 255 * panelAlpha))

    local startX = sx*0.25 + 2/myX*sx 
    local textWidth = (sx*0.5 - 4/myX*sx) / #navbarMenus
    for k, v in ipairs(navbarMenus) do 
        if k == selectedMenu then 
            dxDrawText(v[1], startX, sy*0.71, textWidth, sy*0.04 - 2/myY*sy, tocolor(r, g, b, 255 * panelAlpha), 1, font:getFont("condensed", 10/myX*sx), "center", "center")
            --dxDrawRectangle()
        else
            dxDrawText(v[1], startX, sy*0.71, textWidth, sy*0.04 - 2/myY*sy, tocolor(255, 255, 255, 255 * panelAlpha), 1, font:getFont("condensed", 10/myX*sx), "center", "center")
        end

        startX = startX + textWidth
    end

    -- Pages 
    if selectedMenu == 1 then -- Kiállító pozíciók kezelése
        dxDrawRectangle(sx*0.25 + 4/myX*sx, sy*0.25 + 4/myY*sy + sy*0.02, sx*0.2, sy*0.435, tocolor(30, 30, 30, 100 * panelAlpha))

        local startY = sy*0.25 + 4/myY*sy + sy*0.02 + 2/myX*sx
        local count = 1
        for k, v in pairs(carshopDatas["carPoints"]) do 
            local alpha = 150 * panelAlpha 

            if count % 2 == 0 then 
                alpha = 230 * panelAlpha 
            end

            local barText = panelColors["red"].."Nincs beállítva jármű!"
            local barText2 = panelColors["red"].."Nincs beárazva!"
            local barColor = {232, 76, 65}

            if v.car then 
                barText = vehicle:getModdedVehicleName(panelCarElements[k])

                if v.price then 
                    barText2 = panelColors["green"]..v.price .. "$"
                    barColor = {147, 217, 78}
                end
            end

            if selectedPanelElement == count then
                dxDrawRectangle(sx*0.25 + 6/myX*sx, startY, sx*0.19, sy*0.03, tocolor(barColor[1], barColor[2], barColor[3], 35 * panelAlpha))
            else
                dxDrawRectangle(sx*0.25 + 6/myX*sx, startY, sx*0.19, sy*0.03, tocolor(30, 30, 30, alpha))
            end

            if v.car then 
                dxDrawText(barText2, sx*0.25 + 10/myX*sx, startY, sx*0.185, sy*0.03, tocolor(255, 255, 255, 200 * panelAlpha), 1, font:getFont("condensed", 10/myX*sx), "right", "center", false, false, false, true)
            end

            dxDrawText(barText, sx*0.25 + 15/myX*sx, startY, sx*0.17, sy*0.03, tocolor(255, 255, 255, 255 * panelAlpha), 1, font:getFont("condensed", 10/myX*sx), "left", "center", false, false, false, true)
            
            dxDrawRectangle(sx*0.25 + 6/myX*sx, startY, sx*0.0015, sy*0.03, tocolor(barColor[1], barColor[2], barColor[3], alpha))


            startY = startY + sy*0.03 + 2/myY*sy
            count = count + 1
        end
    elseif selectedMenu == 2 then -- Járművek kezelése
    elseif selectedMenu == 3 then -- Tagok kezelése
    elseif selectedMenu == 4 then -- Pénz kezelése
    end 
end

function openPanel()
    addEventHandler("onClientRender", root, renderCarshopPanel)
    loadCarElements()
end

function loadCarElements()
    panelCarElements = {}
    for k, v in pairs(carshopDatas["carPoints"]) do
        for k2, v2 in ipairs(getElementsByType("vehicle")) do 
            if getElementData(v2, "veh:id") == v.car then 
                panelCarElements[k] = v2
            end
        end
    end
end

if getElementData(localPlayer, "playerid") == 1 then
    --openPanel()
end