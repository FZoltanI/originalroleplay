local sx, sy = guiGetScreenSize()
--sx,sy = 1360,768
local rel = ((sx/1920)+(sy/1080))/2
local showing = false

local myX, myY = 1768, 992

local browserHudW, browserHudH = 460, 200
local hudBrowser = createBrowser(browserHudW, browserHudH, true, true)
addEventHandler("onClientBrowserCreated", hudBrowser, function()
	loadBrowserURL(hudBrowser, "http://mta/local/hud/hud.html")
end)

local savedValue = {["char:health"] = 0, ["char:armor"] = 0, ["char:hunger"] = 0, ["char:thirst"] = 0, ["char:alcoholLevel"] = 0}
local tick = {["char:health"] = 0, ["char:armor"] = 0, ["char:hunger"] = 0, ["char:thirst"] = 0,  ["char:alcoholLevel"] = 0}
local progress, data = {}, {["char:health"] = 1, ["char:armor"] = 1, ["char:hunger"] = 1, ["char:thirst"] = 1, ["char:alcoholLevel"] = 1}

local fonts = {
    ["condensed-11"] = exports.oFont:getFont("condensed", 11),
    ["condensed-13"] = exports.oFont:getFont("condensed", 13),
    ["bebasneue-15"] = exports.oFont:getFont("bebasneue", 15),
    ["houseScript-15"] = exports.oFont:getFont("houseScript", 15),
    ["houseScript-20"] = exports.oFont:getFont("houseScript", 20),
}

local servername = exports.oCore:getServerName()
local stamina = 0
local realWeapons = {
    [22] = true,
    [23] = true,
    [24] = true,
    [25] = true,
    [26] = true,
    [27] = true,
    [28] = true,
    [29] = true,
    [30] = true,
    [31] = true,
    [33] = true,
    [34] = true,
    [35] = true,
    [36] = true,
    [38] = true,
}

local playerMoney = 0
local moneyChangeValue = 0
local moneyChangeTick = 0
local playerPP = 0
local boneStates = {["head"] = 0, ["body"] = 0, ["l_leg"] = 0, ["r_leg"] = 0, ["r_arm"] = 0, ["l_arm"] = 0}
local isLoggedIn = getElementData(localPlayer,"user:loggedin")

local _dxDrawImage = dxDrawImage
local textures = {}
local function dxDrawImage(x, y, w, h, image, rot, rotX, rotY, color)
    if type(image) == "string" then
        if not textures[image] then
            textures[image] = dxCreateTexture(image, "dxt5", true)
        end

        image = textures[image]
    end
    _dxDrawImage(x, y, w, h, image, rot, rotX, rotY, color)
end


addEventHandler("onClientResourceStart", resourceRoot, function()
    playerMoney = getPlayerElementDataValue("char:money", {"#d92d21", "#7cc576"})
    playerPP = getPlayerElementDataValue("char:money", {"#3d7abc", "#3d7abc"})
    boneStates = getElementData(localPlayer, "char:bones")
    adminDuty = getElementData(localPlayer, "user:aduty")
    smoothMoveAlcohol = getElementData(localPlayer,"char:alcoholLevel")
end)

addEventHandler("onClientElementDataChange", getRootElement(), function(dataName, oldValue, newValue)
    if source == localPlayer then
        if dataName == "char:health" or dataName == "char:armor" or dataName == "char:hunger" or dataName == "char:thirst" or dataName == "char:alcoholLevel" or dataName == "weapon:hot" then
            savedValue[dataName] = oldValue
            tick[dataName] = getTickCount()
           -- outputChatBox(dataName .. " "..getPlayerName(source))

        elseif dataName == "char:money" then
            playerMoney = getPlayerElementDataValue("char:money", {"#d92d21", "#7cc576"})
            --outputChatBox(playerMoney)
            moneyChangeValue = tostring(getElementData(source, "char:money")) - (oldValue or 0)
            moneyChangeTick = getTickCount() + 5000
            setSoundVolume(playSound("assets/moneychange.mp3"), 2)
        elseif dataName == "char:pp" then
            playerPP = getPlayerElementDataValue("char:pp", {"#3d7abc", "#3d7abc"})
        elseif dataName == "user:aduty" then
            adminDuty = getElementData(source, "user:aduty")
        elseif dataName == "char:bones" then
            boneStates = getElementData(source, "char:bones")
        elseif dataName == "user:loggedin" then
            isLoggedIn = getElementData(source,"user:loggedin")
            savedValue["char:health"] = getElementData(source, "char:health") or 100
            savedValue["char:armor"] = getElementData(source, "char:armor") or 100
            savedValue["char:hunger"] = getElementData(source, "char:hunger") or 100
            savedValue["char:thirst"] = getElementData(source, "char:thirst") or 100
            savedValue["char:alcoholLevel"] = getElementData(source, "char:alcoholLevel") or 0
            smoothMoveAlcohol = getElementData(source,"char:alcoholLevel") or 0

        end
    end
end)

function convertNumber(num, maxnull, color)
    local num = num or 0
    local actualNum = maxnull - string.len(tostring(num))
    local str = ""

    for i = 0, actualNum, 1 do
        str = str.."0"
    end

    if num == 0 then color = "" end

    return {str..num, str..color..num}
end

addEvent("setHudComponentsVisible", true)
addEventHandler("setHudComponentsVisible", getRootElement(), function(state, positions)
    if positions then
        money = math.floor(convertNumber(getElementData(localPlayer, "char:money"), 9, "#7cc576"))
        pp = convertNumber(getElementData(localPlayer, "char:pp"), 6, "#3d7abc")
        userID = getElementData(localPlayer, "user:id")
        pos = positions.hud
    end
	showing = state
end)

local interface = exports.oInterface
local admin = exports.oAdmin
local core = exports.oCore
local font = exports.oFont

addEventHandler("onClientResourceStart", root, function(res)
    if getResourceName(res) == "oCore" or getResourceName(res) == "oHud" or getResourceName(res) == "oInterface" or getResourceName(res) == "oAdmin" or getResourceName(res) == "oFont" then
        interface = exports.oInterface
        color, r, g, b = exports.oCore:getServerColor()
        admin = exports.oAdmin
        core = exports.oCore
        font = exports.oFont

        alcoholPNG = dxCreateTexture("hud/icons/alcohol.png")

        oxygenLevel = getPedOxygenLevel(localPlayer)/10.02  --1002(átlag maxlevel) 1002/x=100 x= 10.2
        oxygenPNG = dxCreateTexture("hud/icons/oxygen.png")
	end
end)


local fps = 0
local fps_show = 0

local lekerhet = true

local components

local hudBars = {
   --[[{color = tocolor(219, 88, 79, 255), icon = "hp", value = "hp"},
    {color = tocolor(72, 132, 217, 255), icon = "armor", value = "armor"},
    {color = tocolor(192, 159, 79, 255), icon = "food", value = "hunger"},
    {color = tocolor(66, 176, 207, 255), icon = "drink", value = "thirst"},
    {color = tocolor(191, 191, 191, 255), icon = "energy", value = "stamina"}, ]]

    {color = tocolor(247, 82, 82, 255), icon = "", value = "hp", bg = tocolor(247, 82, 82, 50), bar = "hp"},
    {color = tocolor(82, 153, 247, 255), icon = "", value = "armor", bg = tocolor(82, 153, 247, 50), bar = "armor"},
    {color = tocolor(237, 157, 66, 255), icon = "", value = "hunger", bg = tocolor(237, 157, 66, 50), bar = "food"},
    {color = tocolor(82, 198, 247, 255), icon = "", value = "thirst", bg = tocolor(82, 198, 247, 50), bar = "food"},
    {color = tocolor(191, 191, 191, 255), icon = "", value = "stamina", bg = tocolor(191, 191, 191, 50), bar = "stamina"},
    {color = tocolor(102, 189, 232, 255), icon = "", value = "oxigen", bg = tocolor(102, 189, 232, 50), bar = "stamina"},
    {color = tocolor(237, 157, 66, 255), icon = "", value = "alcohol", bg = tocolor(237, 157, 66, 50), bar = "alcohol"},
}

local hudElements = {
    ["kocka"] = dxCreateTexture("assets/kocka.png", "dxt1"),
    ["hp"] = dxCreateTexture("assets/hp.png", "dxt5"),
    ["armor"] = dxCreateTexture("assets/armor.png", "dxt5"),
    ["oxigen"] = dxCreateTexture("assets/oxigen.png", "dxt5"),

    ["damage"] = dxCreateTexture("assets/damage.png", "dxt5"),

    ["body"] = dxCreateTexture("assets/bone/body.png", "dxt3"),
    ["full_body"] = dxCreateTexture("assets/bone/full_body.png", "dxt3"),
    ["l_arm"] = dxCreateTexture("assets/bone/l_arm.png", "dxt3"),
    ["l_leg"] = dxCreateTexture("assets/bone/l_leg.png", "dxt3"),
    ["r_arm"] = dxCreateTexture("assets/bone/r_arm.png", "dxt3"),
    ["r_leg"] = dxCreateTexture("assets/bone/r_leg.png", "dxt3"),
}

local weaponTextures = {}
for i = 0, 47 do
    if fileExists("weapons/"..i..".png") then
        table.insert(weaponTextures, i, dxCreateTexture("weapons/"..i..".png", "dxt1"))
    end
end

local boneStateColors = {tocolor(227, 108, 11, 200), tocolor(207, 8, 8, 200)}

local damageAlpha = 0
local newDamageAlpha = 0
local damageTick = 0
local damageTimer = nil
local damageTime = 300

addEventHandler("onClientPlayerDamage", localPlayer, function(attacker, damage)
    if source == localPlayer then
        damageTime = 300
        damageTick = getTickCount()
        newDamageAlpha = math.min(damage * 5, 255)

        if isTimer(damageTimer) then
            killTimer(damageTimer)
        end

        damageTimer = setTimer(function()
            damageTime = 5000
            damageTick = getTickCount()
            newDamageAlpha = 0

            if isTimer(damageTimer) then
                killTimer(damageTimer)
            end
        end, 300, 1)
    end
end)

setTimer(function()
    if isLoggedIn then 
            components = {
                ["hud"] = {
                    interface:getInterfaceElementData(4,"showing"),
                },

                ["fps"] = {
                    interface:getInterfaceElementData(6,"showing"),
                },

                ["ping"] = {
                    interface:getInterfaceElementData(7,"showing"),
                },

                ["name"] = {
                    interface:getInterfaceElementData(9,"showing"),
                },

                ["time"] = {
                    --interface:getInterfaceElementData(11,"showing"),
                },

                ["weapon"] = {
                    interface:getInterfaceElementData(12,"showing"),
                },

                ["money"] = {
                    --interface:getInterfaceElementData(15,"showing"),
                },

                ["premium"] = {
                    --interface:getInterfaceElementData(16,"showing"),
                },

                ["bone"] = {
                    --interface:getInterfaceElementData(18,"showing"),
                },

                ["cc"] = {
                    --interface:getInterfaceElementData(19,"showing"),
                },


                ["hp"] = {
                    --interface:getInterfaceElementData(21,"showing"),
                },


                ["armor"] = {
                    --interface:getInterfaceElementData(22,"showing"),
                },


                ["food"] = {
                    --interface:getInterfaceElementData(23,"showing"),
                },


                ["stamina"] = {
                    --interface:getInterfaceElementData(24,"showing"),
                },

                ["alcohol"] = {
                    interface:getInterfaceElementData(16,"showing"),
                },

                ["oxygen"] = {
                    interface:getInterfaceElementData(14,"showing"),
                },

                ["vCard"] = {
                    interface:getInterfaceElementData(10,"showing"),
                },
            }




        --dxDrawRectangle(0, 0, 400, 95)

        for k, v in pairs(savedValue) do
            if k == "char:health" then
                value = getElementData(localPlayer, "char:health")
            elseif k == "char:armor" then
                value = getElementData(localPlayer, "char:armor")
            else
                value = getElementData(localPlayer, k) or 0
            end
            --print(v)
            local num = 4*math.abs(math.abs(value or 0) - (v or 0))

            progress[k] = (getTickCount() - tick[k])/(num > 0 and num or 4)
            data[k] = interpolateBetween(v, 0, 0, (value or 0), 0, 0, progress[k], "InOutQuad")
        end

        components["alcohol"][2] = interface:getInterfaceElementData(16,"posX")
        components["alcohol"][3] = interface:getInterfaceElementData(16,"posY")
        components["alcohol"][4] = interface:getInterfaceElementData(16,"width")
        components["alcohol"][5] = interface:getInterfaceElementData(16,"height")

        local values = {
            ["hp"] = data["char:health"]/100,
            ["armor"] = data["char:armor"]/100,
            ["hunger"] = data["char:hunger"]/100,
            ["thirst"] = data["char:thirst"]/100,
            ["alcohol"] = data["char:alcoholLevel"]/100,
            ["stamina"] = stamina/100,
        }

        if values["armor"] == 0 then
            values["armor"] = getPedArmor(localPlayer)/100
        end

        if values["hp"] == 0 then
            values["armor"] = getElementHealth(localPlayer)/100
        end

        if values["hunger"] == 0 then
            values["hunger"] = (getElementData(localPlayer, "char:hunger") or 0)/100
        end

        if values["thirst"] == 0 then
            values["thirst"] = (getElementData(localPlayer, "char:thirst") or 0)/100
        end
        if values["alcohol"] == 0 then
            values["alcohol"] = (getElementData(localPlayer, "char:alcoholLevel") or 0)/100
        end

        local iconSize = 18

        local startY = 0--sy*components["hud"][3]+6/myY*sy
        local startX = 0--sx*components["hud"][2] + iconSize/myX*sx
        for k, v in ipairs(hudBars) do
            if components[v.bar][1] then
                startX, startY = sx*components[v.bar][2] + iconSize/myX*sx, sy*components[v.bar][3]+6/myY*sy

                local lineWidth = (sx*components[v.bar][4] - iconSize/myX*sx)

                if smoothMoveAlcohol < getElementData(localPlayer,"char:alcoholLevel") then
                    smoothMoveAlcohol = smoothMoveAlcohol + 1
                elseif smoothMoveAlcohol > getElementData(localPlayer,"char:alcoholLevel") then
                    smoothMoveAlcohol = smoothMoveAlcohol - 1
                end

                if oxygenLevel < getPedOxygenLevel(localPlayer)/10.02 then
                    oxygenLevel = oxygenLevel + 1
                elseif oxygenLevel > getPedOxygenLevel(localPlayer)/10.02 then
                    oxygenLevel = oxygenLevel - 1
                end

                if components["oxygen"][1] then
                    if isElementInWater(localPlayer) then
                        local oxygen_stat = -oxygenLevel
                        ox,oy = interface:getInterfaceElementData(14,"posX"),interface:getInterfaceElementData(14,"posY")
                        startOx,startOy = sx*ox + iconSize/myX*sx, sy*oy+6/myY*sy
                        --dxDrawRectangle(startX, startY, lineWidth, sy*0.013, tocolor(30, 30, 30, 255))
                        --dxDrawRectangle(startX + 2/myX*sx, startY + 2/myY*sy, lineWidth - 4/myX*sx, sy*0.013 - 4/myY*sy, v.bg)
                        --dxDrawRectangle(startX + 2/myX*sx, startY + 2/myY*sy, (lineWidth - 4/myX*sx) * oxigenLevel, sy*0.013 - 4/myY*sy, v.color)
                        --core:dxDrawShadowedText(v.icon, startX - iconSize/myX*sx, startY - 2/myY*sy, startX - iconSize/myX*sx + iconSize, startY - 2/myY*sy + iconSize, v.color, tocolor(0, 0, 0, 255), 1, font:getFont("fontawesome2", 8/myX*sx), "center", "center")
                        dxDrawImage(startOx + 2/myX*sx, startOy + 2/myY*sy, 40, 41,oxygenPNG,0,0,0,tocolor(25,25,25,200))
                        dxDrawImageSection(startOx + 2/myX*sx, startOy + 2/myY*sy + 41,40, 41*oxygen_stat/100,0,0,40, 41*oxygen_stat/100,oxygenPNG,0,0,0,tocolor(72, 154, 247,250))

                    end
                end

                if v.value == "alcohol" then
                    if values[v.value] > 0 then
                        local alcohol_stat = -smoothMoveAlcohol

                        --dxDrawRectangle(startX, startY, lineWidth, sy*0.013, tocolor(30, 30, 30, 255))
                        --dxDrawRectangle(startX + 2/myX*sx, startY + 2/myY*sy, lineWidth - 4/myX*sx, sy*0.013 - 4/myY*sy, v.bg)
                        --dxDrawRectangle(startX + 2/myX*sx, startY + 2/myY*sy, (lineWidth - 4/myX*sx) * values[v.value], sy*0.013 - 4/myY*sy, v.color)
                        --core:dxDrawShadowedText(v.icon, startX - iconSize/myX*sx, startY - 2/myY*sy, startX - iconSize/myX*sx + iconSize, startY - 2/myY*sy + iconSize, v.color, tocolor(0, 0, 0, 255), 1, font:getFont("fontawesome2", 8/myX*sx), "center", "center")
                        dxDrawImage(startX + 2/myX*sx, startY + 2/myY*sy, 40, 41,alcoholPNG,0,0,0,tocolor(25,25,25,200))
                        dxDrawImageSection(startX + 2/myX*sx, startY + 2/myY*sy + 41,40, 41*alcohol_stat/100,0,0,40, 41*alcohol_stat/100,alcoholPNG,0,0,0,v.color)

                    end
                end

                --else
                --    --outputChatBox(values[v.value])
                --    dxDrawRectangle(startX, startY, lineWidth, sy*0.013, tocolor(30, 30, 30, 255))
                --    dxDrawRectangle(startX + 2/myX*sx, startY + 2/myY*sy, lineWidth - 4/myX*sx, sy*0.013 - 4/myY*sy, v.bg)
                --    dxDrawRectangle(startX + 2/myX*sx, startY + 2/myY*sy, (lineWidth - 4/myX*sx) * values[v.value], sy*0.013 - 4/myY*sy, v.color)
                --    core:dxDrawShadowedText(v.icon, startX - iconSize/myX*sx, startY - 2/myY*sy, startX - iconSize/myX*sx + iconSize, startY - 2/myY*sy + iconSize, v.color, tocolor(0, 0, 0, 255), 1, font:getFont("fontawesome2", 8/myX*sx), "center", "center")
                --end
            end
        end


        if getElementData(localPlayer, "char:health") <= 10 then
            damageAlpha = interpolateBetween(0, 0, 0, 255, 0, 0, (getTickCount() - damageTick) / 1000, "CosineCurve")
        else
            damageAlpha = interpolateBetween(damageAlpha, 0, 0, newDamageAlpha, 0, 0, (getTickCount() - damageTick) / damageTime, "Linear")
        end

        dxDrawImage(0, 0, sx, sy, hudElements["damage"], 0, 0, 0, tocolor(237, 64, 64, damageAlpha), true)


        if components["hud"][1] then



            components["hud"][2] = interface:getInterfaceElementData(4,"posX")
            components["hud"][3] = interface:getInterfaceElementData(4,"posY")
            components["hud"][4] = interface:getInterfaceElementData(4,"width")
            components["hud"][5] = interface:getInterfaceElementData(4,"height")

            dxDrawImage(sx*components["hud"][2], sy*components["hud"][3], browserHudW, browserHudH, hudBrowser)

            --dxDrawImage(sx*components["hud"][2], sy*components["hud"][3], 21.75/myX*sx, 51.2/myY*sy, hudElements["full_body"], 0, 0, 0, tocolor(30, 30, 30, 200))
           -- pairsBones = boneStates
           -- for k, v in pairs(pairsBones) do
            --    if v > 0 then
             --       dxDrawImage(sx*components["hud"][2] + 413.5, sy*components["hud"][3] + 26.5, 25, 60, hudElements[k], 0, 0, 0, boneStateColors[v])
              --  end
           -- end
            executeBrowserJavascript(hudBrowser, "setValue('hp', "..(values['hp'])..");")
            executeBrowserJavascript(hudBrowser, "setValue('armor', "..(values['armor'])..");")
            executeBrowserJavascript(hudBrowser, "setValue('food', "..(values['hunger'])..");")
            executeBrowserJavascript(hudBrowser, "setValue('drink', "..(values['thirst'])..");")
            executeBrowserJavascript(hudBrowser, "setValue('energy', "..(stamina/100)..");")

            local time_h = core:getDate("hour")
            local time_m = core:getDate("minute")
            local time_s = core:getDate("second")

            executeBrowserJavascript(hudBrowser, "setClock("..time_h..", "..time_m..", "..time_s..");")
            executeBrowserJavascript(hudBrowser, "setMoney("..getElementData(localPlayer, "char:money")..");")
            executeBrowserJavascript(hudBrowser, "setPP("..getElementData(localPlayer, "char:pp")..");")
            executeBrowserJavascript(hudBrowser, "setCC("..getElementData(localPlayer, "char:cc")..");")





            --[[dxDrawRectangle(sx*components["hud2"][2], sy*components["hud2"][3], 307/myX*sx, 65/myY*sy, tocolor(40, 40, 40, 255))
            dxDrawImage(sx*components["hud2"][2], sy*components["hud2"][3], 307/myX*sx, 65/myY*sy, "assets/bg.png")

            local startX2 = sx*components["hud2"][2]+6/myX*sx
            for k, v in ipairs(hudBars) do
                if not (v.value == "oxygen") then
                    dxDrawImageSection(startX2, sy*components["hud2"][3]+60/myY*sy, 55.5/myX*sx, -55*values[v.value]/myY*sy, 0, 0, 55.5, -55*values[v.value], hudElements["kocka"], 0, 0, 0, v.color)

                    startX2 = startX2 + 60/myX*sx
                end
            end

            dxDrawImage(sx*components["hud2"][2], sy*components["hud2"][3], 307/myX*sx, 65/myY*sy, "assets/icons.png")]]
        end

        if components["fps"][1] then

            components["fps"][2] = interface:getInterfaceElementData(6,"posX")
            components["fps"][3] = interface:getInterfaceElementData(6,"posY")
            components["fps"][4] = interface:getInterfaceElementData(6,"width")
            components["fps"][5] = interface:getInterfaceElementData(6,"height")
            fps = fps + 1

            if not lastFPSReset then
                lastFPSReset = getTickCount()
            end

            if getTickCount() - lastFPSReset >= 1000 then
                fps_show = fps
                fps = 0
                lastFPSReset = getTickCount()
            end

            local color = "#dcdcdc"

            if fps_show < 20 then
                color = "#c23421"
            elseif fps_show >= 20 and fps_show < 40 then
                color = "#eb8f34"
            else
                color = "#7cc576"
            end

            core:dxDrawShadowedText(color..fps_show.." #ffffffFPS",sx*components["fps"][2],sy*components["fps"][3],sx*components["fps"][2]+sx*components["fps"][4],sy*components["fps"][3]+sy*components["fps"][5],tocolor(220,220,220,255),tocolor(0,0,0,255), 1/myX*sx, fonts["condensed-11"], "center", "center", false, false, false, true)
        end

        if components["vCard"][1] then
            components["vCard"][2] = interface:getInterfaceElementData(10,"posX")
            components["vCard"][3] = interface:getInterfaceElementData(10,"posY")
            components["vCard"][4] = interface:getInterfaceElementData(10,"width")
            components["vCard"][5] = interface:getInterfaceElementData(10,"height")
            local text = color ..  dxGetStatus().VideoCardName .."#ffffff\nVRAM: "..color.. dxGetStatus().VideoCardRAM - dxGetStatus().VideoMemoryFreeForMTA .. "/" .. dxGetStatus().VideoCardRAM .. "#ffffff MB, FONT: "..color.. dxGetStatus().VideoMemoryUsedByFonts .. "#ffffff MB\nTEXTURE: ".. color ..dxGetStatus().VideoMemoryUsedByTextures.."#ffffff MB, RTARGET: "..color.. dxGetStatus().VideoMemoryUsedByRenderTargets .. "#ffffff MB\nRATIO: ".. color ..  dxGetStatus().SettingAspectRatio .."#ffffff, SIZE: "..color .. sx .."x"..sy .. "x" .. (dxGetStatus().Setting32BitColor and "32" or "16")
            core:dxDrawShadowedText(text,sx*components["vCard"][2],sy*components["vCard"][3],sx*components["vCard"][2]+sx*components["vCard"][4],sy*components["vCard"][3]+sy*components["vCard"][5],tocolor(220,220,220,255),tocolor(0,0,0,255), 1/myX*sx, fonts["bebasneue-15"], "center", "center", false, false, false, true)
        end

        if components["ping"][1] then

            components["ping"][2] = interface:getInterfaceElementData(7,"posX")
            components["ping"][3] = interface:getInterfaceElementData(7,"posY")
            components["ping"][4] = interface:getInterfaceElementData(7,"width")
            components["ping"][5] = interface:getInterfaceElementData(7,"height")

            local ping = getPlayerPing(localPlayer)
            local color = "#dcdcdc"

            if ping < 60 then
                color = "#7cc576"
            elseif ping >= 60 and ping < 120 then
                color = "#eb8f34"
            else
                color = "#c23421"
            end

            core:dxDrawShadowedText("Ping: "..color..ping.."ms",sx*components["ping"][2],sy*components["ping"][3],sx*components["ping"][2]+sx*components["ping"][4],sy*components["ping"][3]+sy*components["ping"][5],tocolor(255, 255, 255, 255),tocolor(0,0,0,255), 1/myX*sx, fonts["condensed-11"], "center", "center", false, false, false, true)
        end

        if components["name"][1] then
            components["name"][2] = interface:getInterfaceElementData(9,"posX")
            components["name"][3] = interface:getInterfaceElementData(9,"posY")
            components["name"][4] = interface:getInterfaceElementData(9,"width")
            components["name"][5] = interface:getInterfaceElementData(9,"height")
            if getElementData(localPlayer, "user:aduty") then
                local alevel = getElementData(localPlayer, "user:admin")
                core:dxDrawShadowedText(admin:getAdminColor(alevel).."("..admin:getAdminPrefix(alevel)..") #ffffff"..getPlayerName(localPlayer):gsub("_", " ")..color.." ("..getElementData(localPlayer, "playerid")..")",sx*components["name"][2],sy*components["name"][3],sx*components["name"][2]+sx*components["name"][4],sy*components["name"][3]+sy*components["name"][5],tocolor(255,255,255,255),tocolor(0,0,0,255), 1/myX*sx, fonts["houseScript-20"], "center", "center", false, false, false, true)
            else
                core:dxDrawShadowedText(getPlayerName(localPlayer):gsub("_", " ")..color.." ("..getElementData(localPlayer, "playerid")..")",sx*components["name"][2],sy*components["name"][3],sx*components["name"][2]+sx*components["name"][4],sy*components["name"][3]+sy*components["name"][5],tocolor(255,255,255,255),tocolor(0,0,0,255), 1/myX*sx, fonts["houseScript-20"], "center", "center", false, false, false, true)
            end
        end

        --[[if components["time"][1] then

            components["time"][2] = interface:getInterfaceElementData(11,"posX")
            components["time"][3] = interface:getInterfaceElementData(11,"posY")
            components["time"][4] = interface:getInterfaceElementData(11,"width")
            components["time"][5] = interface:getInterfaceElementData(11,"height")

            local time_h = core:getDate("hour")
            local time_m = core:getDate("minute")
            local time_s = core:getDate("second")

            core:dxDrawShadowedText(time_h..":"..time_m..":"..time_s, sx*components["time"][2],sy*components["time"][3],sx*components["time"][2]+sx*components["time"][4],sy*components["time"][3]+sy*components["time"][5], tocolor(255, 255, 255, 255), tocolor(0, 0, 0, 255), 1/myX*sx, fonts["bebasneue-15"], "center", "center", false, false)
        end]]

        if components["weapon"][1] then
            components["weapon"][2] = interface:getInterfaceElementData(12,"posX")
            components["weapon"][3] = interface:getInterfaceElementData(12,"posY")
            components["weapon"][4] = interface:getInterfaceElementData(12,"width")
            components["weapon"][5] = interface:getInterfaceElementData(12,"height")

            local weapon = getPedWeapon(localPlayer)
            dxDrawImage(sx*components["weapon"][2], sy*components["weapon"][3], 204.8/myX*sx, 102.4/myY*sy, weaponTextures[weapon])

            if realWeapons[weapon] or weapon == 41 then -- Weapon 41 - Spray item
                if not getElementData(localPlayer, "inWeaponSkilling") then
                    core:dxDrawShadowedText(((getPedAmmoInClip(localPlayer) or 1) - 1).." | "..((getPedTotalAmmo(localPlayer) or 1) - 1), sx*components["weapon"][2], sy*components["weapon"][3], sx*components["weapon"][2]+204.8/myX*sx, sy*components["weapon"][3]+102.4/myY*sy, tocolor(255, 255, 255, 255), tocolor(0, 0, 0, 255), 1/myX*sx, fonts["condensed-11"], "right", "bottom", false, false, false, true)

                    if not (weapon == 41) then
                        dxDrawRectangle(sx*components["weapon"][2] + 5, sy*components["weapon"][3]+sy*0.07 + 40, 204.8/myX*sx, sy*0.022, tocolor(50, 50, 50, 255))
                        dxDrawRectangle(sx*components["weapon"][2]+2/myX*sx + 5, sy*components["weapon"][3]+sy*0.07+2/myY*sy + 40, 204.8/myX*sx-4/myX*sx, sy*0.022-4/myY*sy, tocolor(40, 40, 40, 255))

                        local weaponhot = getElementData(localPlayer, "weapon:hot")
                        if weaponhot then
                            dxDrawRectangle(sx*components["weapon"][2]+2/myX*sx + 5, sy*components["weapon"][3]+sy*0.07+2/myY*sy + 40, (204.8/myX*sx-4/myX*sx)/100*weaponhot, sy*0.022-4/myY*sy, tocolor(r, g, b, 255))
                        end
                    end
                end
            end
        end
    end

    --[[if components["money"][1] then
        components["money"][2] = interface:getInterfaceElementData(15,"posX")
        components["money"][3] = interface:getInterfaceElementData(15,"posY")
        components["money"][4] = interface:getInterfaceElementData(15,"width")
        components["money"][5] = interface:getInterfaceElementData(15,"height")
        if moneyChangeTick and moneyChangeTick >= getTickCount() then
            if moneyChangeValue > 0 then
                core:dxDrawShadowedText("+"..moneyChangeValue.."$", sx*components["money"][2], sy*components["money"][3], sx*components["money"][2]+sx*components["money"][4], sy*components["money"][3]+sy*components["money"][5], tocolor(124, 197, 118, 255), tocolor(0, 0, 0, 255), 1/myX*sx, fonts["bebasneue-15"], "right", "center", false, false, false, true)
            else
                core:dxDrawShadowedText("-"..math.abs(moneyChangeValue).."$", sx*components["money"][2], sy*components["money"][3], sx*components["money"][2]+sx*components["money"][4], sy*components["money"][3]+sy*components["money"][5], tocolor(217, 45, 33, 255), tocolor(0, 0, 0, 255), 1/myX*sx, fonts["bebasneue-15"], "right", "center", false, false, false, true)
            end
        else
            core:dxDrawShadowedText(tostring(playerMoney).."$", sx*components["money"][2], sy*components["money"][3], sx*components["money"][2]+sx*components["money"][4], sy*components["money"][3]+sy*components["money"][5], tocolor(255, 255, 255, 255), tocolor(0, 0, 0, 255), 1/myX*sx, fonts["bebasneue-15"], "right", "center", false, false, false, true)
        end
    end

    if components["premium"][1] then
        components["premium"][2] = interface:getInterfaceElementData(16,"posX")
        components["premium"][3] = interface:getInterfaceElementData(16,"posY")
        components["premium"][4] = interface:getInterfaceElementData(16,"width")
        components["premium"][5] = interface:getInterfaceElementData(16,"height")
        core:dxDrawShadowedText(tostring(playerPP).."PP", sx*components["premium"][2], sy*components["premium"][3], sx*components["premium"][2]+sx*components["premium"][4], sy*components["premium"][3]+sy*components["premium"][5], tocolor(255, 255, 255, 255), tocolor(0, 0, 0, 255), 1/myX*sx, fonts["bebasneue-15"], "right", "center", false, false, false, true)
    end

    if components["bone"][1] then
        components["bone"][2] = interface:getInterfaceElementData(18,"posX")
        components["bone"][3] = interface:getInterfaceElementData(18,"posY")
        components["bone"][4] = interface:getInterfaceElementData(18,"width")
        components["bone"][5] = interface:getInterfaceElementData(18,"height")

        dxDrawImage(sx*components["bone"][2], sy*components["bone"][3], 21.75/myX*sx, 51.2/myY*sy, hudElements["full_body"], 0, 0, 0, tocolor(30, 30, 30, 200))

        for k, v in pairs(boneStates) do
            if v > 0 then
                dxDrawImage(sx*components["bone"][2], sy*components["bone"][3], 21.75/myX*sx, 51.2/myY*sy, hudElements[k], 0, 0, 0, boneStateColors[v])
            end
        end
    end

    if components["cc"][1] then
        components["cc"][2] = interface:getInterfaceElementData(19,"posX")
        components["cc"][3] = interface:getInterfaceElementData(19,"posY")
        components["cc"][4] = interface:getInterfaceElementData(19,"width")
        components["cc"][5] = interface:getInterfaceElementData(19,"height")
        core:dxDrawShadowedText(convertNumber(getElementData(localPlayer, "char:cc"), 9, color)[2].."CC", sx*components["cc"][2], sy*components["cc"][3], sx*components["cc"][2]+sx*components["cc"][4], sy*components["cc"][3]+sy*components["cc"][5], tocolor(255, 255, 255, 255), tocolor(0, 0, 0, 255), 1/myX*sx, fonts["bebasneue-15"], "right", "center", false, false, false, true)
    end]]
end,5,0)

function convertMBtoGB(mb)
    if mb then
         return mb/1024
    end
    return false
end


function getPlayerElementDataValue(data, colors)
    local value = getElementData(localPlayer, data)

    if tonumber(value) then
        if colors then
            if data == "char:money" or data == "char:pp" or data == "char:cc" then
                if value < 0 then
                    value = convertNumber(value, 9, colors[1])
                else
                    value = convertNumber(value, 9, colors[2])
                end
                value = value[2]
            else
                if value < 0 then
                    value = colors[1]..tostring(value)
                else
                    value = colors[2]..tostring(value)
                end
            end
        end

        return value
    else
        return false
    end
end

-- / Stamina / --
stamina = 100

local isJumped = false
local controlsState = true

local increaseValue = 0.0075
local decreaseValue = 0.00575

local weight = 0
local lastAct = 0

local adminDuty = false
local staminaFueling = false

addEventHandler("onClientPreRender", getRootElement(),
	function (timeSlice)
        --print(adminDuty)
        if not getElementData(localPlayer, "user:aduty") then
            if not doesPedHaveJetPack(localPlayer) then
                if not getElementData(localPlayer, "veh:vehSit:attachDatas") then
                    local playerVelX, playerVelY, playerVelZ = getElementVelocity(localPlayer)
                    local occupiedVehicle = getPedOccupiedVehicle(localPlayer)
                    local actualSpeed = (playerVelX * playerVelX + playerVelY * playerVelY) ^ 0.5
                    if getTickCount()-lastAct >= 10000 then
                        lastAct = getTickCount()
                    --    weight = tonumber(math.ceil(exports["oInventory"]:getAllItemWeight()))
                    end

                    if playerVelZ >= 0.1 and not isJumped and not occupiedVehicle then
                        -- Ugrás
                        isJumped = true
                        stamina = stamina - 4.5
                        staminaFueling = true
                        if stamina <= 0 then
                            stamina = 0

                            if controlsState then
                                toggleAllControls(false, true, false)
                                triggerServerEvent("setStaminaAnimation", localPlayer, true)
                                controlsState = false
                            end
                        end
                    end

                    if playerVelZ < 0.05 then
                        isJumped = false
                    end
                    --outputChatBox(actualSpeed)
                    if actualSpeed < 0.05 and not isJumped and staminaFueling then -- feltöltés
                    -- outputChatBox("a")
                        if stamina <= 100 then
                            if stamina > 25 then
                                if not controlsState then
                                    toggleAllControls(true, true, false)
                                    if getElementData(localPlayer, "playerNoAmmo") then
                                        toggleControl("fire", false)
                                        toggleControl("action", false)
                                    end
                                    triggerServerEvent("setStaminaAnimation", localPlayer)
                                    controlsState = true
                                end

                                stamina = stamina + increaseValue * timeSlice
                            else
                                stamina = stamina + increaseValue * timeSlice * 0.75
                            end
                        else
                        --    if stamina >= 100 then
                                stamina = 100
                                staminaFueling = false
                        --   end
                        end

                    elseif actualSpeed >= 0.1 and not occupiedVehicle then  -- sprint
                    -- if not getElementData(localPlayer, "job:cleaning") then
                            if stamina >= 0 then
                                staminaFueling = true
                                stamina = stamina - decreaseValue * timeSlice
                            else
                                stamina = 0
                                if controlsState then
                                    toggleAllControls(false, true, false)
                                    triggerServerEvent("setStaminaAnimation", localPlayer, true)
                                    controlsState = false
                                end
                            end
                        --end
                    end
                    setPedControlState("walk", true)
                end
            end
        else
            stamina = 100
        end
    end
)

addEventHandler("onClientPlayerSpawn", localPlayer, function()
	stamina = 100
end)

function roundedRectangle(x, y, w, h, borderColor, bgColor, postGUI)
	if (x and y and w and h) then
		if (not borderColor) then
			borderColor = tocolor(0, 0, 0, 200);
		end
		if (not bgColor) then
			bgColor = borderColor;
		end
		dxDrawRectangle(x, y, w, h, bgColor, postGUI);
		dxDrawRectangle(x + 2, y - 1, w - 4, 1, borderColor, postGUI);
		dxDrawRectangle(x + 2, y + h, w - 4, 1, borderColor, postGUI);
		dxDrawRectangle(x - 1, y + 2, 1, h - 4, borderColor, postGUI);
		dxDrawRectangle(x + w, y + 2, 1, h - 4, borderColor, postGUI);
	end
end

function getPedMaxOxygenLevel(ped)
    -- Output an error and stop executing the function if the argument is not valid
    assert(isElement(ped) and (getElementType(ped) == "ped" or getElementType(ped) == "player"), "Bad argument @ 'getPedMaxOxygenLevel' [Expected ped at argument 1, got " .. tostring(ped) .. "]")

    -- underwater stamina ped
    local underwater_stamina = getPedStat(ped, 225)

    -- stamina ped
    local stamina = getPedStat(ped, 22)

    -- Do a linear interpolation to get how many oxygen a ped can have.
    -- Assumes: 1000 level = 0 underwater_stamina and 0 stamina stat, 4000 level = 1000 underwater_stamina and 1000 stamina stat.
    local maxoxygen = 1000 + underwater_stamina * 1.5 + stamina * 1.5

    -- Return the max oxygen level.
    return maxoxygen
end
