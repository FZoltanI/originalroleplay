local gen = {

}
game = {
    screen = Vector2(guiGetScreenSize()),
}
settings = {
    maxRow = 20,
}

panel = {
    maxRow = settings.maxRow,
    openRow = 1,
    rowSize = relY(0.093),
    stickerRow = 1,
}
local textures = {}
local stickers = {}


local sx, sy = guiGetScreenSize()
local myX, myY = 1768, 992



addEventHandler("onClientResourceStart", resourceRoot, function()
	shader = dxCreateShader(shader_data)
    --outputChatBox(rel(0.1,0.1,0.5,0.5))
    for k,v in pairs(stickerTable) do
        for k2,v2 in pairs(v) do
            textures[v2[1]] = dxCreateTexture('assets/'..v2[1]..'.png')
        end
    end
end)

--setClipboard ( toJSON(gen) )



local vehsssss = createVehicle(540,2375.115234375, -1737.9337158203, 12.836840629578)
--setElementData(vehsssss,'[ [ { "A": 255, "startX": 0, "G": 255, "width": 1024, "startY": 0, "name": "aron", "height": 1024, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 200, "G": 255, "width": 500, "startY": 200, "name": "sajt", "height": 500, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 0, "G": 255, "width": 1024, "startY": 0, "name": "aron", "height": 1024, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 200, "G": 255, "width": 500, "startY": 200, "name": "sajt", "height": 500, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 0, "G": 255, "width": 1024, "startY": 0, "name": "aron", "height": 1024, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 200, "G": 255, "width": 500, "startY": 200, "name": "sajt", "height": 500, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 0, "G": 255, "width": 1024, "startY": 0, "name": "aron", "height": 1024, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 200, "G": 255, "width": 500, "startY": 200, "name": "sajt", "height": 500, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 0, "G": 255, "width": 1024, "startY": 0, "name": "aron", "height": 1024, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 200, "G": 255, "width": 500, "startY": 200, "name": "sajt", "height": 500, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 0, "G": 255, "width": 1024, "startY": 0, "name": "aron", "height": 1024, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 200, "G": 255, "width": 500, "startY": 200, "name": "sajt", "height": 500, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 0, "G": 255, "width": 1024, "startY": 0, "name": "aron", "height": 1024, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 200, "G": 255, "width": 500, "startY": 200, "name": "sajt", "height": 500, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 0, "G": 255, "width": 1024, "startY": 0, "name": "aron", "height": 1024, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 200, "G": 255, "width": 500, "startY": 200, "name": "sajt", "height": 500, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 0, "G": 255, "width": 1024, "startY": 0, "name": "aron", "height": 1024, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 200, "G": 255, "width": 500, "startY": 200, "name": "sajt", "height": 500, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 0, "G": 255, "width": 1024, "startY": 0, "name": "aron", "height": 1024, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 200, "G": 255, "width": 500, "startY": 200, "name": "sajt", "height": 500, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 0, "G": 255, "width": 1024, "startY": 0, "name": "aron", "height": 1024, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 200, "G": 255, "width": 500, "startY": 200, "name": "sajt", "height": 500, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 0, "G": 255, "width": 1024, "startY": 0, "name": "aron", "height": 1024, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 200, "G": 255, "width": 500, "startY": 200, "name": "sajt", "height": 500, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 0, "G": 255, "width": 1024, "startY": 0, "name": "aron", "height": 1024, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 200, "G": 255, "width": 500, "startY": 200, "name": "sajt", "height": 500, "B": 255, "R": 255, "rotation": 0 } ] ]')
setVehicleColor(vehsssss, 255, 255, 255)

function loadCustomPaintjobToVehicle(vehicle,paintjob)
    if stickers[vehicle] then
        if isElement(stickers[vehicle].renderTarget) then 
            destroyElement(stickers[vehicle].renderTarget)
        end
    end

    stickers[vehicle] = {
        renderTarget = dxCreateRenderTarget( 1024, 1024, true),
    }

    dxSetRenderTarget( stickers[vehicle].renderTarget )
        local r,g,b = getVehicleColor ( vehicle,true )
        dxDrawRectangle(0,0,1024,1024,tocolor(r,g,b,255))
            for i,sticker in pairs(fromJSON(paintjob)) do
                dxDrawImage(sticker.startX, sticker.startY, sticker.width, sticker.height, textures[sticker.name], sticker.rotation, 0, 0, tocolor(sticker.R, sticker.G, sticker.B, sticker.A))
               -- outputChatBox(sticker.name)
            end
    dxSetRenderTarget()
    dxSetShaderValue(shader, "tex", stickers[vehicle].renderTarget)
    engineApplyShaderToWorldTexture(shader, "*remap*", vehicle)

end

--setTimer(function()
--loadCustomPaintjobToVehicle(vehsssss,'[ [ { "A": 255, "startX": 0, "G": 255, "width": 1024, "startY": 0, "name": "aron", "height": 1024, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 200, "G": 255, "width": 500, "startY": 200, "name": "sajt", "height": 500, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 0, "G": 255, "width": 1024, "startY": 0, "name": "aron", "height": 1024, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 200, "G": 255, "width": 500, "startY": 200, "name": "sajt", "height": 500, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 0, "G": 255, "width": 1024, "startY": 0, "name": "aron", "height": 1024, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 200, "G": 255, "width": 500, "startY": 200, "name": "sajt", "height": 500, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 0, "G": 255, "width": 1024, "startY": 0, "name": "aron", "height": 1024, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 200, "G": 255, "width": 500, "startY": 200, "name": "sajt", "height": 500, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 0, "G": 255, "width": 1024, "startY": 0, "name": "aron", "height": 1024, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 200, "G": 255, "width": 500, "startY": 200, "name": "sajt", "height": 500, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 0, "G": 255, "width": 1024, "startY": 0, "name": "aron", "height": 1024, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 200, "G": 255, "width": 500, "startY": 200, "name": "sajt", "height": 500, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 0, "G": 255, "width": 1024, "startY": 0, "name": "aron", "height": 1024, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 200, "G": 255, "width": 500, "startY": 200, "name": "sajt", "height": 500, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 0, "G": 255, "width": 1024, "startY": 0, "name": "aron", "height": 1024, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 200, "G": 255, "width": 500, "startY": 200, "name": "sajt", "height": 500, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 0, "G": 255, "width": 1024, "startY": 0, "name": "aron", "height": 1024, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 200, "G": 255, "width": 500, "startY": 200, "name": "sajt", "height": 500, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 0, "G": 255, "width": 1024, "startY": 0, "name": "aron", "height": 1024, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 200, "G": 255, "width": 500, "startY": 200, "name": "sajt", "height": 500, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 0, "G": 255, "width": 1024, "startY": 0, "name": "aron", "height": 1024, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 200, "G": 255, "width": 500, "startY": 200, "name": "sajt", "height": 500, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 0, "G": 255, "width": 1024, "startY": 0, "name": "aron", "height": 1024, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 200, "G": 255, "width": 500, "startY": 200, "name": "sajt", "height": 500, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 0, "G": 255, "width": 1024, "startY": 0, "name": "aron", "height": 1024, "B": 255, "R": 255, "rotation": 0 }, { "A": 255, "startX": 200, "G": 255, "width": 500, "startY": 200, "name": "sajt", "height": 500, "B": 255, "R": 255, "rotation": 0 } ] ]')
--loadCustomPaintjobToVehicle(vehsssss,'[ [ { "A": 255, "startX": 500, "G": 130, "width": 500, "startY": 500, "name": "aron", "height": 500, "B": 20, "R": 255, "rotation": 0 } ] ]')
--end, 5000, 1)

i = 1

local selectedCategory = 3
local scroll1 = 0

local scrollInputValues = {
    ["x"] = 500,
    ["y"] = 500,
    ["w"] = 500,
    ["h"] = 500,
    ["a"] = 255,
    ["rotation"] = 0,
    ["color"] = 0,
    ["a"] = 255,
}

function resetScrollDatas()
    scrollInputValues = {
        ["x"] = 500,
        ["y"] = 500,
        ["w"] = 500,
        ["h"] = 500,
        ["a"] = 255,
        ["rotation"] = 0,
        ["color"] = 0,
        ["a"] = 255,
    }
end
resetScrollDatas()

local stickerInEdit = false
local stickerDatas = false 

function renderStickerPanel()


    -- Matrica szerkesztése
    if stickerInEdit then
        core:drawWindow(sx*0.005, sy*0.35, sx*0.15, sy*0.375, "Elérhető matricák", 1)

        renderScrollInput(sx*0.008, sy*0.4, sx*0.15 - sx*0.006, sy*0.02, "x", 1024, 1, {r, g, b}, "X pozíció")
        renderScrollInput(sx*0.008, sy*0.45, sx*0.15 - sx*0.006, sy*0.02, "y", 1024, 1, {r, g, b}, "Y pozíció")
        renderScrollInput(sx*0.008, sy*0.5, sx*0.15 - sx*0.006, sy*0.02, "w", 1024, 1, {r, g, b}, "Szélesség")
        renderScrollInput(sx*0.008, sy*0.55, sx*0.15 - sx*0.006, sy*0.02, "h", 1024, 1, {r, g, b}, "Magasság")
        renderScrollInput(sx*0.008, sy*0.6, sx*0.15 - sx*0.006, sy*0.02, "rotation", 360, 1, {r, g, b}, "Rotáció")
        --renderScrollInput(sx*0.008, sy*0.7, sx*0.15 - sx*0.006, sy*0.02, "color", 16777215, 1, {r, g, b}, "Szín", true)
        renderScrollInput(sx*0.008, sy*0.65, sx*0.15 - sx*0.006, sy*0.02, "color", 1, 1, {r, g, b}, "Szín", true)
        renderScrollInput(sx*0.008, sy*0.7, sx*0.15 - sx*0.006, sy*0.02, "a", 255, 1, {r, g, b}, "Áttetszőség")

        core:dxDrawButton(sx*0.005, sy*0.73, sx*0.15, sy*0.03, r, g, b, 200, "Matrica mentése", tocolor(255, 255, 255, 255), 1, fonts:getFont("condensed", 10/myX*sx), true, tocolor(0, 0, 0, 100))
    else
        core:drawWindow(sx*0.3, sy*0.3, sx*0.4, sy*0.4, "Elérhető matricák", 1)

        if categories[selectedCategory - 1] then
            dxDrawText(categories[selectedCategory - 1], sx*0.3, sy*0.32, sx*0.3 + sx*0.1, sy*0.32 + sy*0.05, tocolor(255, 255, 255, 100), 1, "default-bold", "center", "center")
        end

        dxDrawText(categories[selectedCategory], sx*0.45, sy*0.32, sx*0.45 + sx*0.1, sy*0.32 + sy*0.05, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center")

        if categories[selectedCategory + 1] then
            dxDrawText(categories[selectedCategory + 1], sx*0.6, sy*0.32, sx*0.6 + sx*0.1, sy*0.32 + sy*0.05, tocolor(255, 255, 255, 100), 1, "default-bold", "center", "center")
        end

        local startX = sx*0.305
        local startY = sy*0.373
        for i = 1, 8 do 
            if stickerTable[categories[selectedCategory] ][i + scroll1] then 
                if core:isInSlot(startX, startY, sx*0.09, (sy*0.153)) then 
                    dxDrawRectangle(startX, startY, sx*0.09, (sy*0.153), tocolor(r, g, b, 100))
                else
                    dxDrawRectangle(startX, startY, sx*0.09, (sy*0.153), tocolor(30, 30, 30, 255))
                end

                dxDrawImage(startX + 3/myX*sx, startY + 3/myX*sx, sx*0.09 - 6/myX*sx, sy*0.153 - 6/myX*sx, textures[stickerTable[categories[selectedCategory] ][i + scroll1][1] ])
                dxDrawRectangle(startX, startY + sy*0.12, sx*0.09, sy*0.03, tocolor(35, 35, 35, 150))
                dxDrawText(stickerTable[categories[selectedCategory] ][i + scroll1][2].."$", startX, startY + sy*0.12, startX + sx*0.09, startY + sy*0.12 + sy*0.03, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center")

                if i == 4 then 
                    startX = sx*0.305
                    startY = startY + sy * 0.165
                else
                    startX = startX + sx*0.097
                end
            end
        end

        local scrollH = 0.5

        scrollH = 8 / #stickerTable[categories[selectedCategory] ]

        dxDrawRectangle(sx*0.692, sy*0.373, sx*0.002, sy*0.315, tocolor(r, g, b, 100))
        dxDrawRectangle(sx*0.692, sy*0.373 + ((scroll1 / 8) * (sy*0.315) * scrollH), sx*0.002, (sy*0.315) * scrollH, tocolor(r, g, b, 255)) 
    end
end

function renderScrollInput(x, y, w, h, value, maxvalue, alpha, barColor, title, colorbar)
    if not stickerInEdit then 
        return 
    end

    dxDrawRectangle(x, y, w, h, tocolor(255, 255, 255, 50 * alpha))

    if not colorbar then
        dxDrawRectangle(x + 2/myX*sx, y + 2/myY*sy, w - 4/myX*sx, h - 4/myY*sy, tocolor(255, 255, 255, 50 * alpha))
        dxDrawRectangle(x + 2/myX*sx, y + 2/myY*sy, (w - 4/myX*sx) * (scrollInputValues[value] / maxvalue), h - 4/myY*sy, tocolor(barColor[1], barColor[2], barColor[3], 255 * alpha))
    else
        dxDrawImage(x + 2/myX*sx, y + 2/myY*sy, w - 4/myX*sx, h - 4/myY*sy, "assets/rgb.jpg", 180, 0, 0, tocolor(255, 255, 255, 255 * alpha))
    end

    dxDrawRectangle(x + 2/myX*sx + (w - 4/myX*sx) * (scrollInputValues[value] / maxvalue) - 2/myX*sx, y - 2/myY*sy, 4/myX*sx, h + 4/myY*sy, tocolor(255, 255, 255, 255 * alpha))

    dxDrawText(title, x + 2/myX*sx, y - sy*0.03, x + w, y, tocolor(255, 255, 255, 255 * alpha), 1, fonts:getFont("condensed", 10/myX*sx), "left", "center")

    if isCursorShowing() then
        if core:isInSlot(x, y, w, h) then 
            if getKeyState("mouse1") then 
                local cx, cy = getCursorPosition()
                local newvalue = maxvalue * (((cx * sx) - x)/w)

                if not colorbar then
                    newvalue = math.floor(newvalue)
                end

                if not (scrollInputValues[value] == newvalue) then 
                    scrollInputValues[value] = newvalue
                    
                    local r, g, b = valueToRGB(scrollInputValues["color"])

                    if not r then r = 0 end 
                    if not g then g = 0 end 
                    if not b then b = 0 end

                    if not core:tableContains(colorableTextures, stickerInEdit) then 
                        r, g, b = 255, 255, 255
                    end
                    
                    editVehicleSticker(vehsssss, {
                        ["name"] = stickerInEdit,
                        ["startX"] = scrollInputValues["x"],
                        ["startY"] = scrollInputValues["y"],
                        ["R"] = r,
                        ["G"] = g,
                        ["B"] = b,
                        ["A"] = scrollInputValues["a"],
                        ["width"] = scrollInputValues["w"],
                        ["height"] = scrollInputValues["h"],
                        ["rotation"] = scrollInputValues["rotation"],
                    })
                end
            end
        end
    end
end

function keyStickerPanel(key, state)
    if state then
        if core:isInSlot(sx*0.3, sy*0.3, sx*0.4, sy*0.4) then
            if not stickerInEdit then
                if key == "mouse_wheel_down" then 
                    if stickerTable[categories[selectedCategory]][scroll1 + 12] then
                        scroll1 = scroll1 + 4
                    end
                elseif key == "mouse_wheel_up" then 
                    if scroll1 > 0 then
                        scroll1 = scroll1 - 4
                    end
                end

                if key == "mouse1" then
                    local startX = sx*0.305
                    local startY = sy*0.373
                    for i = 1, 8 do 
                        if stickerTable[categories[selectedCategory] ][i + scroll1] then 
                            if core:isInSlot(startX, startY, sx*0.09, (sy*0.153)) then 
                                resetScrollDatas()

                                stickerInEdit = stickerTable[categories[selectedCategory] ][i + scroll1][1] 

                                if core:tableContains(colorableTextures, stickerInEdit) then 
                                    editVehicleSticker(vehsssss, {
                                        ["name"] = stickerInEdit,
                                        ["startX"] = scrollInputValues["x"],
                                        ["startY"] = scrollInputValues["y"],
                                        ["R"] = 0,
                                        ["G"] = 0,
                                        ["B"] = 0,
                                        ["A"] = scrollInputValues["a"],
                                        ["width"] = scrollInputValues["w"],
                                        ["height"] = scrollInputValues["h"],
                                        ["rotation"] = scrollInputValues["rotation"],
                                    })
                                else
                                    editVehicleSticker(vehsssss, {
                                        ["name"] = stickerInEdit,
                                        ["startX"] = scrollInputValues["x"],
                                        ["startY"] = scrollInputValues["y"],
                                        ["R"] = 255,
                                        ["G"] = 255,
                                        ["B"] = 255,
                                        ["A"] = scrollInputValues["a"],
                                        ["width"] = scrollInputValues["w"],
                                        ["height"] = scrollInputValues["h"],
                                        ["rotation"] = scrollInputValues["rotation"],
                                    })
                                end
                               
                            end

                            if i == 4 then 
                                startX = sx*0.305
                                startY = startY + sy * 0.165
                            else
                                startX = startX + sx*0.097
                            end
                        end
                    end

                    if core:isInSlot(sx*0.3, sy*0.32, sx*0.1, sy*0.05) then 
                        if selectedCategory > 1 then 
                            selectedCategory = selectedCategory - 1
                        end
                    end

                    if core:isInSlot(sx*0.6, sy*0.32, sx*0.1, sy*0.05) then 
                        if selectedCategory < #categories then 
                            selectedCategory = selectedCategory + 1
                        end
                    end
                end
            end
        else
            if stickerInEdit then
                if key == "mouse1" then 
                    if core:isInSlot(sx*0.005, sy*0.73, sx*0.15, sy*0.03) then 
                        stickerInEdit = false

                        local vehStickers = getElementData(vehsssss, "veh:stickers") or {}

                        table.insert(vehStickers, stickerDatas)
                        stickerDatas = nil 
                        setElementData(vehsssss, "veh:stickers", vehStickers)
                    end
                end
            end
        end
    end
end

--'[ [ { "A": '..scrollInputValues["a"]..', "startX": '..scrollInputValues["x"]..', "G": '..g..', "width": '..scrollInputValues["w"]..', "startY": '..scrollInputValues["y"]..', "name": "'..stickerInEdit..'", "height": '..scrollInputValues["h"]..', "B": '..b..', "R": '..r..', "rotation": '..scrollInputValues["rotation"]..' } ] ]'
function editVehicleSticker(veh, newSticker)
    local vehStickers = getElementData(veh, "veh:stickers") or {}

    table.insert(vehStickers, newSticker)
    stickerDatas = newSticker
    vehStickers = toJSON(vehStickers)
    loadCustomPaintjobToVehicle(vehsssss, vehStickers)
end

if getElementData(localPlayer, "user:adminnick") == "Paul" then
    addEventHandler("onClientRender", root, renderStickerPanel)    
    addEventHandler("onClientKey", root, keyStickerPanel)    
    addEventHandler ( "onClientRender", root, PaintjobLoadRender )
end


--addEventHandler ( "onClientRender", root, PaintjobLoadRender )
local testMarker = createMarker(2316.5888671875, -1741.6159667969, 12.5, "cylinder", 2.8, 255, 255, 0, 0 )
setElementData(testMarker,'marker:stickerShop',true)



start = getTickCount()

--[[addEventHandler( "onClientRender", root,
    function()
        --if stickers[vehsssss].renderTarget then
            --dxDrawImage( 0,  0,  500, 500, stickers[vehsssss].renderTarget )
        --end
        --local cx,cy,cz = 2316.5888671875, -1741.6159667969, 12.9
        local now = getTickCount()
        local endTime = start + 3000
        local elapsedTime = now - start
        local duration = endTime - start
        local progress = elapsedTime / duration
        local x, y, z = interpolateBetween ( 0.1, -0.35, 0.7, -0.25, -0.35, -0.15, progress, "SineCurve")
        local markers = getElementsByType ( 'marker', getRootElement(), true ) 
        for i,marker in pairs(markers) do
            local position = Vector3(marker:getPosition())
            dxDrawCircle3D( position.x, position.y, position.z + z + 0.4, 1.4, 50) 
            dxDrawCircle3D( position.x, position.y, position.z + y + 0.4, 1.4, 50) 
            dxDrawCircle3D( position.x, position.y, position.z + x + 0.4, 1.4, 50) 
        end
        --outputChatBox(x..'/'..px)
        
            --dxDrawImage( 150, 350, 150, 100, myRenderTarget )
            --dxDrawImage( 250, 250, 100, 150, myRenderTarget )
            --dxDrawImage( 350, 30,  150, 150, myRenderTarget )
    end
)

]]