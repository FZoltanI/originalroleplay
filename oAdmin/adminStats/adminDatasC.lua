local myX, myY = 1768, 992
local sx, sy = guiGetScreenSize()

local datas = {
    -- "Admin név", alevel, {ban, kick, jail, ub, unjail, kimenő pm, bejövő pm, rtc, admin duty idő, online idő}
}

local panelShowing = false
local lastOpen = 0

local fonts = {
    ["condensed-12"] = exports.oFont:getFont("condensed", 12)
}

addCommandHandler("showadminstats", function()
    if hasPermission(localPlayer,'showadminstats') then
        if panelShowing then
            removeEventHandler("onClientKey", root, keyAdminStatPanel)
            removeEventHandler("onClientRender", root, renderAdminStatsPanel)
        else
            if (lastOpen + core:minToMilisec(5)) <= getTickCount() then
                lastOpen = getTickCount()
                openAdminStatPanel(true)
            else
                if #datas > 0 then
                    openAdminStatPanel(false)
                else
                    openAdminStatPanel(true)
                end
            end
        end

        panelShowing = not panelShowing
    end
end)

local selectedLine = 1
local scroll = 0

local dataNames = {
    {"Ban", "db"},
    {"Kick", "db"},
    {"Jail", "db"},
    {"Unban", "db"},
    {"Unjail", "db"},
    {"Kimenő PM", "db"},
    {"Bejövő PM", "db"},
    {"Fixveh", "db"},
    {"Admin duty idő", "perc"},
    {"Online idő", "perc"},
}

function renderAdminStatsPanel()
    dxDrawRectangle(sx*0.35, sy*0.25, sx*0.3, sy*0.5, tocolor(35, 35, 35, 255))
    dxDrawRectangle(sx*0.35+2/myX*sx, sy*0.25+2/myY*sy, sx*0.1, sy*0.5-4/myY*sy, tocolor(40, 40, 40, 255))

    local startY = sy*0.255

    for i = 1, 10 do
        local v = datas[i+scroll]

        if v then
            local color = tocolor(35, 35, 35, 255)

            if i % 2 == 0 then
                color = tocolor(35, 35, 35, 150)
            end

            dxDrawRectangle(sx*0.35+4/myX*sx, startY, sx*0.1-4/myX*sx, sy*0.046, color)

            --dxDrawRectangle(sx*0.35+7/myX*sx, startY+3/myY*sy, sx*0.1-4/myX*sx, sy*0.025, tocolor(255, 0, 0))
            if selectedLine == i+scroll or core:isInSlot(sx*0.35+4/myX*sx, startY, sx*0.1-4/myX*sx, sy*0.046) then
                dxDrawText(v[1], sx*0.35+10/myX*sx, startY+3/myY*sy, sx*0.35+10/myX*sx+sx*0.1-4/myX*sx, startY+3/myY*sy+sy*0.025, tocolor(r, g, b, 255), 0.8/myX*sx, fonts["condensed-12"], "left", "center")
                dxDrawText(adminPrefixs[v[2]], sx*0.35+10/myX*sx, startY+3/myY*sy+sy*0.025, sx*0.35+10/myX*sx+sx*0.1-4/myX*sx, startY+3/myY*sy+sy*0.03, tocolor(r, g, b, 100), 0.7/myX*sx, fonts["condensed-12"], "left", "center")
            else
                dxDrawText(v[1], sx*0.35+10/myX*sx, startY+3/myY*sy, sx*0.35+10/myX*sx+sx*0.1-4/myX*sx, startY+3/myY*sy+sy*0.025, tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["condensed-12"], "left", "center")
                dxDrawText(adminPrefixs[v[2]], sx*0.35+10/myX*sx, startY+3/myY*sy+sy*0.025, sx*0.35+10/myX*sx+sx*0.1-4/myX*sx, startY+3/myY*sy+sy*0.03, tocolor(255, 255, 255, 100), 0.7/myX*sx, fonts["condensed-12"], "left", "center")
            end
            startY = startY + sy*0.049
        end
    end

    if selectedLine > 0 then
        if not datas[selectedLine] then return end
        local startY2 = sy*0.255

        for k, v in pairs(dataNames) do
            local color = tocolor(40, 40, 40, 255)

            if k % 2 == 0 then
                color = tocolor(40, 40, 40, 150)
            end

            dxDrawRectangle(sx*0.45+5/myX*sx, startY2, sx*0.194, sy*0.03, color)
            --dxDrawRectangle(sx*0.45-1/myX*sx, startY2, sx*0.194, sy*0.03, tocolor(255, 255, 0, 100))

            dxDrawText(v[1]..":", sx*0.45+10/myX*sx, startY2, sx*0.45+10/myX*sx+sx*0.194, startY2+sy*0.03, tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["condensed-12"], "left", "center")
            dxDrawText(serverColor..comma_value(datas[selectedLine][3][k]).." #ffffff"..v[2], sx*0.45-1/myX*sx, startY2, sx*0.45-1/myX*sx+sx*0.194, startY2+sy*0.03, tocolor(255, 255, 255, 255), 0.8/myX*sx, fonts["condensed-12"], "right", "center", false, false, false, true)

            startY2 = startY2 + sy*0.033
        end

        dxDrawRectangle(sx*0.45+5/myX*sx, sy*0.63, sx*0.194, sy*0.045, tocolor(40, 40, 40, 255))
            dxDrawText("Online idő és Szolgálatban töltött idő aránya", sx*0.45+5/myX*sx, sy*0.61, sx*0.45+5/myX*sx+sx*0.194, sy*0.61+sy*0.045, tocolor(255, 255, 255, 255), 0.7/myX*sx, fonts["condensed-12"], "left", "top")

            local allTime = datas[selectedLine][3][9] + datas[selectedLine][3][10]
            local adutyTime = datas[selectedLine][3][9]
            local onlineTime = datas[selectedLine][3][10]

            if allTime > 0 then
                dxDrawRectangle(sx*0.45+9/myX*sx, sy*0.63+4/myY*sy, (sx*0.194-8/myX*sx)*(adutyTime/allTime), sy*0.045-8/myY*sy, tocolor(66, 170, 245, 255))
                    dxDrawText("Admin duty idő \n ("..math.floor(adutyTime)..")", sx*0.45+9/myX*sx, sy*0.63+4/myY*sy, sx*0.45+9/myX*sx+(sx*0.194-8/myX*sx)*(adutyTime/allTime), sy*0.63+4/myY*sy+sy*0.045-8/myY*sy, tocolor(255, 255, 255, 255), 0.65/myX*sx, fonts["condensed-12"], "center", "center")
                dxDrawRectangle(sx*0.45+9/myX*sx+sx*0.194-8/myX*sx, sy*0.63+4/myY*sy, 0-((sx*0.194-8/myX*sx)*(onlineTime/allTime)), sy*0.045-8/myY*sy, tocolor(30, 124, 212, 255))
                    dxDrawText("Online idő \n ("..math.floor((onlineTime))..")", sx*0.45+9/myX*sx+(sx*0.194-8/myX*sx)*(adutyTime/allTime), sy*0.63+4/myY*sy, sx*0.45+9/myX*sx+sx*0.194-8/myX*sx, sy*0.63+4/myY*sy+sy*0.045-8/myY*sy, tocolor(255, 255, 255, 255), 0.65/myX*sx, fonts["condensed-12"], "center", "center")
            end

        dxDrawRectangle(sx*0.45+5/myX*sx, sy*0.7, sx*0.194, sy*0.045, tocolor(40, 40, 40, 255))
            dxDrawText("Bejövő és Kimenő privát üzenetek aránya", sx*0.45+5/myX*sx, sy*0.68, sx*0.45+5/myX*sx+sx*0.194, sy*0.68+sy*0.045, tocolor(255, 255, 255, 255), 0.7/myX*sx, fonts["condensed-12"], "left", "top")

            local allPM = datas[selectedLine][3][6] + datas[selectedLine][3][7]
            local pmOUT = datas[selectedLine][3][6]
            local pmIN = datas[selectedLine][3][7]

            if allPM > 0 then
                dxDrawRectangle(sx*0.45+9/myX*sx, sy*0.7+4/myY*sy, (sx*0.194-8/myX*sx)*(pmOUT/allPM), sy*0.045-8/myY*sy, tocolor(230, 62, 62, 255))
                    dxDrawText("Kimenő PM \n ("..math.floor(pmOUT)..")", sx*0.45+9/myX*sx, sy*0.7+4/myY*sy, sx*0.45+9/myX*sx+(sx*0.194-8/myX*sx)*(pmOUT/allPM), sy*0.7+4/myY*sy+sy*0.045-8/myY*sy, tocolor(255, 255, 255, 255), 0.65/myX*sx, fonts["condensed-12"], "center", "center")
                dxDrawRectangle(sx*0.45+9/myX*sx+sx*0.194-8/myX*sx, sy*0.7+4/myY*sy, 0-((sx*0.194-8/myX*sx)*(pmIN/allPM)), sy*0.045-8/myY*sy, tocolor(212, 40, 40, 255))
                    dxDrawText("Bejövő PM \n ("..math.floor((pmIN))..")", sx*0.45+9/myX*sx+(sx*0.194-8/myX*sx)*(pmOUT/allPM), sy*0.7+4/myY*sy, sx*0.45+9/myX*sx+sx*0.194-8/myX*sx, sy*0.7+4/myY*sy+sy*0.045-8/myY*sy, tocolor(255, 255, 255, 255), 0.65/myX*sx, fonts["condensed-12"], "center", "center")
            end
    end
end

function keyAdminStatPanel(key, state)
    if state then
        if key == "mouse1" then
            local startY = sy*0.255

            for i = 1, 10 do
                local v = datas[i+scroll]

                if v then

                    if core:isInSlot(sx*0.35+4/myX*sx, startY, sx*0.1-4/myX*sx, sy*0.046) then
                        selectedLine = i+scroll
                    end
                    startY = startY + sy*0.049
                end
            end
        elseif key == "mouse_wheel_up" then
            if core:isInSlot(sx*0.35+2/myX*sx, sy*0.25+2/myY*sy, sx*0.1, sy*0.5-4/myY*sy) then
                if scroll > 0 then
                    scroll = scroll - 1
                end
            end
        elseif key == "mouse_wheel_down" then
            if core:isInSlot(sx*0.35+2/myX*sx, sy*0.25+2/myY*sy, sx*0.1, sy*0.5-4/myY*sy) then
                if datas[11+scroll] then
                    scroll = scroll + 1
                end
            end
        end
    end
end

function openAdminStatPanel(update)
    if update then triggerServerEvent("admin > getAdminDatasFromServerside", resourceRoot) end
    addEventHandler("onClientKey", root, keyAdminStatPanel)
    addEventHandler("onClientRender", root, renderAdminStatsPanel)
end

addEvent("admin > adminDatasToClientside", true)
addEventHandler("admin > adminDatasToClientside", root, function(adminDatas)
    datas = adminDatas
end)

function comma_value(amount)
    local formatted = amount
    while true do
      formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')
      if (k==0) then
        break
      end
    end
    return formatted
end
