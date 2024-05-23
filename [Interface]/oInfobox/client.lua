local sx, sy = guiGetScreenSize()
local rel = ((sx/1920)+(sy/1080))/2
local myX, myY = 1768, 992
local showing = true

local pos = {sx*0.005, sy*0.45}

local font = {exports.oFont:getFont("bebasneue", 15), exports.oFont:getFont("condensed", 11), exports.oFont:getFont("fontawesome2", 16)}
local core = exports.oCore

local tempTable = {}
local infoTable = {}
local infoType = {success = "Siker!", error = "Hiba!", warning = "Figyelmeztetés!", info = "Információ!", aduty = "Adminisztrátor szolgálat!", bug = "Hibajelentés!", gift = "Ajándék!"}
local infoColors = {success = {55, 155, 31}, error = {168, 45, 31}, warning = {206, 149, 16}, info = {38, 117, 173}, aduty = {240, 129, 24}, bug = {224, 44, 20}, gift = {222, 42, 75}}
local colorHexa = {success = "#379b1f", error = "#a82d1f", warning = "#ce9510", info = "#2675ad", aduty = "#f08118", bug = "#e02c14", gift = "#de2a4b"}
local infoIcons = {
    success = "",
    error = "",
    warning = "",
    info = "",
    aduty = "",
    bug = "",
    gift = "",
}

addEvent("setHudComponentsVisible", true)
addEventHandler("setHudComponentsVisible", getRootElement(), function(state, positions)
    if positions then pos = positions.info end
    showing = true --state
end)

addEventHandler("onClientRender", getRootElement(), function()

    if exports.oInterface:getInterfaceElementData(2, "showing") then
        pos = {exports.oInterface:getInterfaceElementData(2, "posX")*sx, exports.oInterface:getInterfaceElementData(2, "posY")*sy}
    else
        pos = {sx*0.005, sy*0.45}
    end

    for i, v in ipairs(infoTable) do
        if i > 5 then return end

        if (getTickCount() - v.start) > v.interval + 250 then
            table.remove(infoTable, i)
            if #tempTable > 0 then
                addInfoBox(unpack(tempTable[1]))
                table.remove(tempTable, 1)
            end
        end

        v.time = interpolateBetween(1, 0, 0, 0, 0, 0, getProgress(v.interval, v.start), "Linear")

        if (getTickCount() - v.start) < 300 then
            v.alpha = interpolateBetween(0, 0, 0, 255, 0, 0, getProgress(250, v.start), "Linear")
        elseif (getTickCount() - v.start) > v.interval then
            v.alpha = interpolateBetween(255, 0, 0, 0, 0, 0, getProgress(250, v.start + v.interval), "Linear")
        elseif (getTickCount() - v.start) > 300 then
            v.width = interpolateBetween(60*rel, 0, 0, v.towidth, 0, 0, getProgress(500, v.start + 300), "OutQuad")
            v.alpha = 255
        end

        local width = v.towidth--v.width or 60*rel

        if showing then
            dxDrawRectangle(pos[1], pos[2] + ((i-1)*(58/myY*sy)), width, 55/myY*sy, tocolor(35, 35, 35, v.alpha*0.5), true)
            dxDrawRectangle(pos[1]+2/myX*sx, pos[2] + ((i-1)*(58/myY*sy)) + 2/myY*sy, width-4/myX*sx, 55/myY*sy-4/myY*sy, tocolor(40, 40, 40, v.alpha), true)

            --dxDrawRectangle(pos[1], pos[2] + ((i-1)*(58/myY*sy)), width, 55/myY*sy, tocolor(infoColors[v.type][1], infoColors[v.type][2], infoColors[v.type][3], v.alpha*0.5))
            --dxDrawRectangle(pos[1]+2/myX*sx, pos[2] + ((i-1)*(58/myY*sy)) + 2/myY*sy, width-4/myX*sx, 55/myY*sy-4/myY*sy, tocolor(infoColors[v.type][1], infoColors[v.type][2], infoColors[v.type][3], v.alpha*0.7))

            dxDrawRectangle(pos[1]+5/myX*sx, pos[2] + ((i-1)*(58/myY*sy)) + 5/myY*sy, 2/myX*sx, 45/myY*sy, tocolor(infoColors[v.type][1], infoColors[v.type][2], infoColors[v.type][3], v.alpha*0.5), true)
            dxDrawRectangle(pos[1]+5/myX*sx, pos[2] + ((i-1)*(58/myY*sy)) + 5/myY*sy + 45/myY*sy, 2/myX*sx, -45/myY*sy*v.time, tocolor(infoColors[v.type][1], infoColors[v.type][2], infoColors[v.type][3], v.alpha), true)

            --dxDrawText(infoType[v.type], pos[1]+50/myX*sx, pos[2] + ((i-1)*(58/myY*sy)) + 5/myY*sy, pos[1]+50/myX*sx+width-4/myX*sx, pos[2] + ((i-1)*(58/myY*sy)) + 5/myY*sy+35/myY*sy-4/myY*sy, tocolor(255, 255, 255, v.alpha), 1/myX*sx, font[1], "left", "center", true)
            dxDrawText(infoType[v.type], pos[1]+50/myX*sx, pos[2] + ((i-1)*(58/myY*sy)) + 5/myY*sy, pos[1]+50/myX*sx+width-4/myX*sx, pos[2] + ((i-1)*(58/myY*sy)) + 5/myY*sy+35/myY*sy-4/myY*sy, tocolor(infoColors[v.type][1], infoColors[v.type][2], infoColors[v.type][3], v.alpha), 0.8/myX*sx, font[1], "left", "center", true, false, true)
            dxDrawText(v.text, pos[1]+50/myX*sx, pos[2] + ((i-1)*(58/myY*sy)) + 22/myY*sy, pos[1]+50/myX*sx+width-4/myX*sx, pos[2] + ((i-1)*(58/myY*sy)) + 22/myY*sy+35/myY*sy-4/myY*sy, tocolor(255, 255, 255, v.alpha*0.7), 0.8/myX*sx, font[2], "left", "center", true, false, true, true)

            --dxDrawRectangle( pos[1]+10/myX*sx, pos[2] + ((i-1)*(58/myY*sy)) + 2/myY*sy, 38/myX*sx, 51/myY*sy)

            --dxDrawText(infoIcons[v.type], pos[1]+10/myX*sx, pos[2] + ((i-1)*(58/myY*sy)) + 2/myY*sy, pos[1]+10/myX*sx+38/myX*sx, pos[2] + ((i-1)*(58/myY*sy)) + 2/myY*sy+48.5/myY*sy, tocolor(infoColors[v.type][1], infoColors[v.type][2], infoColors[v.type][3], v.alpha*0.5), 1/myX*sx, font[4], "center", "center", true)
            dxDrawText(infoIcons[v.type], pos[1]+10/myX*sx, pos[2] + ((i-1)*(58/myY*sy)) + 2/myY*sy, pos[1]+10/myX*sx+38/myX*sx, pos[2] + ((i-1)*(58/myY*sy)) + 2/myY*sy+51/myY*sy, tocolor(infoColors[v.type][1], infoColors[v.type][2], infoColors[v.type][3], v.alpha), 0.8/myX*sx, font[3], "center", "center", true, false, true)

            -- dxDrawRectangle(pos[1], pos[2] + i*(63*rel)-12*rel, width*v.time, 3*rel, tocolor(infoColors[v.type][1], infoColors[v.type][2], infoColors[v.type][3], v.alpha))]]
        end
    end
end)

function addInfoBox(msg, type)
    msg = msg:gsub("{#colorcode}", colorHexa[type])
    table.insert(infoTable, {
        type = type,
        text = msg,
        towidth = dxGetTextWidth(msg, 0.8/myX*sx, font[2], true) + 55/myX*sx,
        interval = string.len(msg) * 100,
        start = getTickCount()
    })

    outputConsole("["..infoType[type].."]: "..msg)

    if fileExists("files/"..type..".mp3") then 
        playSound("files/"..type..".mp3")
    else
        playSound("files/notsound.mp3")
    end
end

function outputInfoBox(msg, type)
    if not infoType[type] then
        outputDebugString("Nem megfelelő típus.", 1)
        return
    end

    if #infoTable >= 5 then
        table.insert(tempTable, {msg, type})
    else
        addInfoBox(msg, type)
    end
end
addEvent("outputInfoBox", true)
addEventHandler("outputInfoBox", localPlayer, outputInfoBox)

function getProgress(addtick, start)
    local elapsedTime = getTickCount() - start
    local duration = start+addtick - start
    return elapsedTime / duration
end