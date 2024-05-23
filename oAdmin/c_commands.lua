local sx, sy = guiGetScreenSize()
local pos = {sx/2 - 200, sy/2 - 250}
local showing = false

local font = {exports.oFont:getFont("condensed", 18), exports.oFont:getFont("roboto-light", 15), exports.oFont:getFont("roboto-light", 13), exports.oFont:getFont("roboto-light", 11)}

local adminLevels = {"Adminsegéd", "Admin 1", "Admin 2", "Admin 3", "Admin 4", "Admin 5", "FőAdmin", "AdminController", "ServerManager", "Fejlesztő", "Tulajdonos"}

local cmdTable = {
    -- parancs név, jog, info
}

function acmdsRender()
    if showing then
        cmdCount = #cmdTable
        dxDrawRectangle(pos[1], pos[2], 400, 490, tocolor(30, 30, 30, 255))

        dxDrawRectangle(pos[1] + 5, pos[2] + 5, 390, 50, tocolor(37, 37, 37, 255))

        dxDrawRectangle(pos[1] + 5, pos[2] + 55, 195, 40, tocolor(34, 34, 34, 255))
        dxDrawRectangle(pos[1] + 200, pos[2] + 55, 195, 40, tocolor(34, 34, 34, 255))

        dxDrawText("Admin parancsok", pos[1], pos[2], pos[1] + 400, pos[2] + 60, tocolor(255, 255, 255), 1, font[1], "center", "center")

        dxDrawText("Parancs neve", pos[1] + 5, pos[2] + 55, pos[1] + 200, pos[2] + 95, tocolor(255, 255, 255), 1, font[2], "center", "center")
        dxDrawText("Rang szükséges", pos[1] + 200, pos[2] + 55, pos[1] + 395, pos[2] + 95, tocolor(255, 255, 255), 1, font[2], "center", "center")


        for i = 1, (cmdCount > 13 and 13 or cmdCount) do
            dxDrawRectangle(pos[1] + 5, pos[2] + 65 + 30*i, 390, 30, i%2==0 and tocolor(40, 40, 40, 255) or tocolor(40, 40, 40, 100))
            dxDrawText("/"..cmdTable[i+list][1], pos[1] + 10, pos[2] + 65 + 30*i, pos[1] + 200, pos[2] + 95 + 30*i, tocolor(255, 255, 255), 0.9, font[3], "left", "center")
            dxDrawText(adminLevels[cmdTable[i+list][2]], pos[1] + 200, pos[2] + 65 + 30*i, pos[1] + 390, pos[2] + 95 + 30*i, tocolor(255, 255, 255), 0.9, font[3], "right", "center", false, false, false, true)

            if isCursorHover(pos[1] + 5, pos[2] + 65 + 30*i, 390, 30) then
                local cx, cy = getCursorPosition()
                local cx, cy = cx*sx, cy*sy
            
                dxDrawRectangle(cx, cy, dxGetTextWidth(cmdTable[i+list][3], 1, font[4]) + 10, dxGetFontHeight(1, font[4]) + 10, tocolor(30, 30, 30, 255))
                dxDrawText(cmdTable[i+list][3], cx + 5, cy + 5, 0, 0, tocolor(255, 255, 255), 1, font[4], "left", "top", false, false, true)
            end
        end
    end
end

function acmdsKey(button, press)
    if press and showing then
        if button == "mouse_wheel_up" then
            if list > 0 then
                list = list - 1
            end
        elseif button == "mouse_wheel_down" then
            if list < cmdCount - 13 then
                list = list + 1
            end
        elseif button == "backspace" then
            showing = false
        end
    end
end

addCommandHandler("ah", function()
    if getElementData(localPlayer, "user:admin") >= 2 then  
        list = 0
        showing = not showing

        table.sort(cmdTable, function(a, b) return b[2] - a[2] > 0 end)
        if showing then
            addEventHandler("onClientKey", getRootElement(), acmdsKey)
            addEventHandler("onClientRender", getRootElement(), acmdsRender)
        else 
            removeEventHandler("onClientKey", getRootElement(), acmdsKey)
            removeEventHandler("onClientRender", getRootElement(), acmdsRender)
        end
    end
end)

function addAdminCMD(command, level, desc)
    if not tableContains(cmdTable, command) then
        table.insert(cmdTable, #cmdTable+1, {command, level, desc})
    end
end


function isCursorHover(rectX, rectY, rectW, rectH)
    if isCursorShowing() then
        local cursorX, cursorY = getCursorPosition()
        cursorX, cursorY = cursorX * sx, cursorY * sy
        return (cursorX >= rectX and cursorX <= rectX+rectW) and (cursorY >= rectY and cursorY <= rectY+rectH)
    else
        return false
    end
end

addEventHandler("onClientResourceStart", resourceRoot, function() 
    for k, o in pairs(adminCMD) do
        addAdminCMD(o.command, o.permission, o.shortDescription)
    end
end)

function tableContains(table, element)
    for _, value in pairs(table) do
      if value[1] == element then
        return true
      end
    end
    return false
  end

  hasPermission(localPlayer,'showplayers')