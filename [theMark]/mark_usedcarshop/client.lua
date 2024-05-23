local sx, sy = guiGetScreenSize()
local zoom = math.min(1, 0.75 + (sx - 1024) * (1 - 0.75) / (1600 - 1024))
function res(value) return value * zoom end
function resFont(value) return math.floor(res(value)) end

local mainShow = false
local page = "info"
local alignX = "center"

local pages = {
    "info",
    "wealth"
}



addCommandHandler("aronegybuzigeci", function()
    local engineTuning = localPlayer.vehicle:getData("veh:engineTunings") or {}
    outputChatBox(inspect(engineTuning))
end)

bindKey("f7", "down", function()
    if mainShow then
        removeEventHandler("onClientRender", root, renderPanel)
        mainShow = false
        GuiElement.setInputEnabled(false)
    else
        removeEventHandler("onClientRender", root, renderPanel)
        addEventHandler("onClientRender", root, renderPanel)
        mainShow = true
    end
end)

local tags = {}
local scroll, maxShow = 0, 6
--[[local tags = {
    {
        name = "Teszt József",
        ID = "1",
        LastLogin = "2021.04.13",
        SelledCars = "15"
    },
    {
        name = "Teszt Lakatos Huanmigel",
        ID = "2",
        LastLogin = "2021.04.11",
        SelledCars = "30"
    },
}]]

local mainLineTextes = {
    {
        text = "ID"
    },
    {
        text = "NÉV"
    },
    {
        text = "LEGUTOLSÓ BEJELENTKEZÉS"
    },
    {
        text = "ELADOTT AUTÓK"
    }
}

addEventHandler("onClientResourceStart", getRootElement(), function(res)
    if (res == getThisResource()) then
        table.insert(tags, {
            name = "teszt_karakter",
            ID = 5,
            LastLogin = "2021.04.14:14:47",
            SelledCars = 0
        })
    end
end)


local asd = Vehicle(411, 1499.1878662109, -1537.1176757812, 66.760620117188)
asd:setData("trading >> car", true)

function renderPanel()
    local panelSize = res(Vector2(1114, 591))
    local panePosition = res(Vector2(sx / 2 - panelSize.x / 2, sy / 2 - panelSize.y / 2))
    local lineSize = res(Vector2(57, panelSize.y))
    local topLineSize = res(Vector2(panelSize.x, 70))
    local mainSize = res(Vector2(987, 480))
    local mainLineSize = res(Vector2(985, 60))

    dxDrawRoundedRectangle(panePosition.x, panePosition.y, panelSize.x, panelSize.y, 10, tocolor(40, 40, 40, 255), false, false)
    dxDrawRoundedRectangle(panePosition.x, panePosition.y, lineSize.x, lineSize.y, 10, tocolor(30, 30, 30, 255), false, false)

    dxDrawRoundedRectangle(panePosition.x, panePosition.y, topLineSize.x, topLineSize.y, 10, tocolor(30, 30, 30, 255), false, false) --top line
    dxDrawImage(panePosition.x + res(12), panePosition.y + res(30), res(40), res(35), "assets/logo.png") --logo

    for i=1, #pages do
        dxDrawRectangle(panePosition.x + res(16), panePosition.y + res(40) + i * res(50), res(30), res(30), tocolor(255, 255, 255))
    end
    dxDrawImage(sx - res(285), panePosition.y + res(25), res(31), res(31), "assets/x.png")
    if page == "info" then
        --X
        dxDrawRoundedRectangle(panePosition.x + res(90), panePosition.y + res(80), mainSize.x, mainSize.y, 10, tocolor(30, 30, 30, 255), false, false)
        dxDrawRoundedRectangle(panePosition.x + res(90), panePosition.y + res(85), mainLineSize.x, mainLineSize.y, 10, tocolor(35, 35, 35, 255), false, false)
        
        for key, textes in ipairs(mainLineTextes) do
            drawText(mainLineTextes[key].text, panePosition.x - res(675) + res(90) + key * res(255), panePosition.y + res(85), mainLineSize.x, mainLineSize.y, tocolor(255, 255, 255), 1, exports.oFont:getFont("condensed", resFont(15)), "center", "center")
        end


        for keyMember, members in ipairs(tags) do
            if keyMember and members then
                dxDrawRoundedRectangle(panePosition.x + res(90), panePosition.y + res(85) + keyMember * res(70), mainLineSize.x, mainLineSize.y, 10, tocolor(35, 35, 35, 255), false, false)
                dxDrawImage(sx - res(330), panePosition.y + res(100) + keyMember * res(70), res(31), res(31), "assets/x.png")
                for i=1, 4 do
                    if i == 1 then
                        drawText(tags[keyMember].ID, panePosition.x - res(675) + res(90) + i * res(255), panePosition.y + res(85) + keyMember * res(70), mainLineSize.x, mainLineSize.y, tocolor(255, 255, 255), 1, exports.oFont:getFont("condensed", resFont(15)), "center", "center")
                    elseif i == 2 then
                        drawText(tags[keyMember].name:gsub("_", " "), panePosition.x - res(675) + res(90) + i * res(255), panePosition.y + res(85) + keyMember * res(70), mainLineSize.x, mainLineSize.y, tocolor(255, 255, 255), 1, exports.oFont:getFont("condensed", resFont(15)), "center", "center")
                    elseif i == 3 then
                        drawText(tags[keyMember].LastLogin, panePosition.x - res(675) + res(90) + i * res(255), panePosition.y + res(85) + keyMember * res(70), mainLineSize.x, mainLineSize.y, tocolor(255, 255, 255), 1, exports.oFont:getFont("condensed", resFont(15)), "center", "center")
                    elseif i == 4 then
                        drawText(tags[keyMember].SelledCars, panePosition.x - res(675) + res(90) + i * res(255), panePosition.y + res(85) + keyMember * res(70), mainLineSize.x, mainLineSize.y, tocolor(255, 255, 255), 1, exports.oFont:getFont("condensed", resFont(15)), "center", "center")
                    end
                end
            end
        end
    elseif page == "wealth" then
        local carsPanelSize = res(Vector2(382, 477))
        local carsPanelPosition = res(Vector2(sx / 2 - carsPanelSize.x / 2, sy / 2 - carsPanelSize.y / 2))
        dxDrawRoundedRectangle(carsPanelPosition.x - res(300), carsPanelPosition.y + res(35), carsPanelSize.x, carsPanelSize.y, 10, tocolor(20, 20, 20), false, false)
        dxDrawRoundedRectangle(carsPanelPosition.x - res(300), carsPanelPosition.y + res(35), carsPanelSize.x, carsPanelSize.y - res(440), 10, tocolor(30, 30, 30), false, false)
        drawText("Járművek", carsPanelPosition.x - res(300), carsPanelPosition.y + res(35), carsPanelSize.x, carsPanelSize.y - res(440), tocolor(255, 255, 255), 1, exports.oFont:getFont("condensed", resFont(15)), "center", "center")
        --invoiceGui
        dxDrawRectangle(carsPanelPosition.x + res(300), carsPanelPosition.y + res(45), carsPanelSize.x - res(50), res(40), tocolor(20, 20, 20), false, false)
        dxDrawRectangle(carsPanelPosition.x + res(300), carsPanelPosition.y + res(90), carsPanelSize.x - res(50), res(40), tocolor(20, 20, 20), false, false)
        drawText("Autókereskedés számla", carsPanelPosition.x + res(300), carsPanelPosition.y + res(45), carsPanelSize.x - res(50), res(40), tocolor(255, 255, 255), 1, exports.oFont:getFont("condensed", resFont(15)), "center", "center")


        if #invoiceGui.text > 46 then
            alignX = "right"
            drawText(invoiceGui.text .. "|", carsPanelPosition.x + res(295), carsPanelPosition.y + res(90), carsPanelSize.x - res(50), res(40), tocolor(255, 255, 255), 1, "asd", alignX, "center", true)
        else
            alignX = "left"
            drawText(invoiceGui.text .. "|", carsPanelPosition.x + res(305), carsPanelPosition.y + res(90), carsPanelSize.x - res(50), res(40), tocolor(255, 255, 255), 1, "asd", alignX, "center", true)
        end

        local serverHex, r, g, b = exports.oCore:getServerColor("servercolor")
        -- for i, key in ipairs(Element.getAllByType("vehicle")) do
            if asd:getData("trading >> car") then
                dxDrawRoundedRectangle(carsPanelPosition.x - res(300), carsPanelPosition.y + res(80), carsPanelSize.x, carsPanelSize.y - res(440), 10, tocolor(30, 30, 30), false, false)
                drawText(asd.vehicleType, carsPanelPosition.x - res(290), carsPanelPosition.y + res(80), carsPanelSize.x, carsPanelSize.y - res(440), tocolor(255, 255, 255), 1, exports.oFont:getFont("condensed", resFont(15)), "left", "center", false, false, false, true)
            end
        -- end
    end
end


function renderTwoPanel()
    local panelSizes = res(Vector2(600, 400))
    local panelPosition = res(Vector2(sx / 2 - panelSizes.x / 2, sy / 2 - panelSizes.y / 2))
    dxDrawRectangle(panelPosition, panelSizes, tocolor(0, 0, 0, 180))
end
-- addEventHandler("onClientRender", root, renderTwoPanel)


addEventHandler("onClientClick", root, function(button, state)
    local carsPanelSize = res(Vector2(382, 477))
    local carsPanelPosition = res(Vector2(sx / 2 - carsPanelSize.x / 2, sy / 2 - carsPanelSize.y / 2))
    if button == "left" and state == "down" and page == "wealth" then
        if exports.oCore:isInSlot(carsPanelPosition.x + res(300), carsPanelPosition.y + res(90), carsPanelSize.x - res(50), res(40)) then
            invoiceGui:bringToFront()
            outputChatBox("Gui aktiválva!")
            GuiElement.setInputEnabled(true)
        end
    end
end)

function deletePlayer(key)
    table.remove(tags, key) -- PLAYER KITÖRLÉSE A TÁBLÁBÓL!
end
addEvent("delPlayerServerSide", true)
addEventHandler("delPlayerServerSide", root, deletePlayer)

function removePlayerClick(button, state)
    local panelSize = res(Vector2(1114, 591))
    local panePosition = res(Vector2(sx / 2 - panelSize.x / 2, sy / 2 - panelSize.y / 2))
    local lineSize = res(Vector2(57, 573))
    local topLineSize = res(Vector2(1052, 40))
    local mainSize = res(Vector2(987, 480))
    local mainLineSize = res(Vector2(985, 60))
    
    if button == "left" and state == "down" and mainShow and page == "info" then
        for keyMember, members in ipairs(tags) do
            if keyMember and members then
                if exports.oCore:isInSlot(sx - res(330), panePosition.y + res(100) + keyMember * res(70), res(31), res(31)) then
                    outputChatBox("Ez egy kibaszott X!")
                    triggerServerEvent("deletePlayer", localPlayer, localPlayer, keyMember)
                    --IDE MAJD KELL AZ SQL DELETE!!!!!!NE FELEJTS DOLGOK--<<<<<<<<<<<<<
                end
            end
        end
    end
end
addEventHandler("onClientClick", root, removePlayerClick)


addEvent("tableTreatment", true)
addEventHandler("tableTreatment", root, function(name, id)
    if #tags >= 5 then return end
    outputChatBox("asd!")
    table.insert(tags, {
        name = name,
        ID = id,
        LastLogin = "2021.04.14:14:38",
        SelledCars = 0
    })
end)

addCommandHandler("asd", function(cmd, pos)
    local pos = pos or 1
    tags[pos].SelledCars = tags[pos].SelledCars + math.random(0, 100)
end)

addEventHandler("onClientClick", root, function(button, state)
    local panelSize = res(Vector2(1114, 591))
    local panePosition = res(Vector2(sx / 2 - panelSize.x / 2, sy / 2 - panelSize.y / 2))
    local lineSize = res(Vector2(57, 573))
    local topLineSize = res(Vector2(1052, 40))
    local mainSize = res(Vector2(987, 480))
    local mainLineSize = res(Vector2(985, 60))
    
    if button == "left" and state == "down" and mainShow then
        if exports.oCore:isInSlot(sx - res(285), panePosition.y + res(25), res(31), res(31)) then
            outputChatBox("Bezárás!")
            GuiElement.setInputEnabled(false)
            removeEventHandler("onClientRender", root, renderPanel)
            mainShow = false
        end
    end
end)

addEvent("removePlayer", true)
addEventHandler("removePlayer", root, function(pos)
    outputChatBox("VÁLASZ MEGKAPÓDIK!!!!44!!4!!!!!")
    if pos then
        table.remove(tags, pos)
    else
        outputChatBox("Ez nem létezik, sajnos!")
    end
end)


addEventHandler("onClientClick", root, function(button, state)
    local panelSize = res(Vector2(1114, 591))
    local panePosition = res(Vector2(sx / 2 - panelSize.x / 2, sy / 2 - panelSize.y / 2))
    local lineSize = res(Vector2(57, 573))
    local topLineSize = res(Vector2(1052, 40))
    local mainSize = res(Vector2(987, 480))
    local mainLineSize = res(Vector2(985, 60))
    if button == "left" and state == "down" and mainShow then
        for i=1, #pages do
            if exports.oCore:isInSlot(panePosition.x + res(16), panePosition.y + res(40) + i * res(50), res(30), res(30)) then
                outputChatBox("page" .. "--> " .. i)
                page = pages[i]
            end
        end
    end
end)

--UTILS
function drawText(text, x, y, w, h, ...)
    if text then
        if x and y and w and h then
            return dxDrawText(text, x, y, (x + w), (y + h), ...)
        end
    end
    return false
end

function dxDrawRoundedRectangle(x, y, width, height, radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+radius, width-(radius*2), height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawCircle(x+radius, y+radius, radius, 180, 270, color, color, 16, 1, postGUI)
    dxDrawCircle(x+radius, (y+height)-radius, radius, 90, 180, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, (y+height)-radius, radius, 0, 90, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, y+radius, radius, 270, 360, color, color, 16, 1, postGUI)
    dxDrawRectangle(x, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+height-radius, width-(radius*2), radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+width-radius, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y, width-(radius*2), radius, color, postGUI, subPixelPositioning)
end
--SCROLL


addEventHandler("onClientRender", root, function()
    if not localPlayer.vehicle then return end
    if getKeyState("lctrl") then
        setVehicleNitroActivated(getPedOccupiedVehicle(localPlayer), true)
    else
        setVehicleNitroActivated(getPedOccupiedVehicle(localPlayer), false)
    end
end)

--MARKER RÉSZEK!
local sellCarMarkers = Marker(1509.3715820312, -1540.4306640625, 67.2109375 - 1, "cylinder", 3, 255, 88, 88)

addEventHandler("onClientMarkerHit", getRootElement(), function(hitElement, dimension)
    if localPlayer.vehicle then
        if hitElement == localPlayer and dimension then
            if sellCarMarkers then
                outputChatBox("Sikeresen beraktad az autót a kereskedésbe!")
                local vehiclePos = localPlayer.vehicle.position
                setElementPosition (localPlayer.vehicle, vehiclePos.x + 2.5, vehiclePos.y, vehiclePos.z + 0.5)
                localPlayer.vehicle.frozen = true
                localPlayer.vehicle:setData("trading >> car", true)
                outputChatBox(inspect(localPlayer.vehicle:getData("trading >> car")) .. "<-- Debug üzenet!")
                sellCarMarkers:destroy()
            end
        end
    end
end)