addEventHandler("onResourceStart", root, function(res)
    local resName = getResourceName(res)

    if table.contains(usedScripts, resName) then 
        cmarker = exports.oCustomMarker
        font = exports.oFont
        core = exports.oCore
        infobox = exports.oInfobox
        color, r, g, b = core:getServerColor()
    end
end)

function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

sx, sy = guiGetScreenSize()
myX, myY = 1768, 992 

fonts = {
    ["condensed-11"] = font:getFont("condensed", 11),
    ["condensed-13"] = font:getFont("p_bo", 15),
    ["condensed-13-l"] = font:getFont("p_li", 15),
    ["bebasneue-25"] = font:getFont("p_ba", 25),
}

local a = 1
local tick = getTickCount()

local selectedTuning = 1
local page = 1
local selectedAlTuning = 1
local selectedAlAlTuning = 1

local allowedInteraction = true
local loadinBarShowing = false
local loadingBarTick = getTickCount()
local loadingBarText = "Beszerelés folyamatban"
local loadingTime = 5000

local activeColorPicker = 1

local vehStarterColor = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
local selectedColor = 0

local startCar = false

local startPaintjob = 0
local startNeon = 0

local equippedTuning = 1

local hornTestSound = false

local customPlateTextPanel = false

local availableWheelSizes = {
	["front"] = {
		["verynarrow"] = {0x100, 1},
		["narrow"] = {0x200, 2},
		["wide"] = {0x400, 4},
		["verywide"] = {0x800, 5}
	},
	["rear"] = {
		["verynarrow"] = {0x1000, 1},
		["narrow"] = {0x2000, 2},
		["wide"] = {0x4000, 4},
		["verywide"] = {0x8000, 5}
	}
}

local menuPointAnimations = {}

function resetMenuAnimations ()
    menuPointAnimations = {}

    for i = 1, 50 do 
        table.insert(menuPointAnimations, {alpha = 0, tick = getTickCount(), state = "open"})
    end
end 
resetMenuAnimations()

core:deleteEditbox("customplate")

local allowedWords = true 
local allowedMinLength = true 
local allowedMaxLength = true

function renderTuningPanel()
    local occupiedVeh = getPedOccupiedVehicle(localPlayer)
    if occupiedVeh then 
        a = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount()-tick)/500, "Linear")

        local vehEngineTunings = getElementData(occupiedVeh, "veh:engineTunings") or {}

        --dxDrawImage(sx*0.7 -63/myX*sx, 0-25/myX*sx, 80/myX*sx, 50/myY*sy, "files/triangle.png", 270, 0, 0, tocolor(35, 35, 35, 255))
        --dxDrawRectangle(sx*0.7, 0, sx*0.3, sy*0.04, tocolor(35, 35, 35, 255), true)

        dxDrawRectangle(sx*0.01, sy*0.02, sx*0.12, sy*0.035, tocolor(35, 35, 35, 200))
        dxDrawText(comma_value(getElementData(localPlayer, "char:money")).."#ffffff$", sx*0.01, sy*0.02, sx*0.01 + sx*0.115, sy*0.02 + sy*0.035, tocolor(78, 191, 107, 255), 1/myX*sx, fonts["condensed-13"], "right", "center", false, false, false, true)
        dxDrawText("", sx*0.015, sy*0.02, sx*0.023 + sx*0.115, sy*0.02 + sy*0.035, tocolor(78, 191, 107, 255), 1/myX*sx, font:getFont("fontawesome2", 13), "left", "center", false, false, false, true)

        dxDrawRectangle(sx*0.01, sy*0.06, sx*0.12, sy*0.035, tocolor(35, 35, 35, 200))
        dxDrawText(comma_value(getElementData(localPlayer, "char:pp")).."#ffffffPP", sx*0.01, sy*0.06, sx*0.01 + sx*0.115, sy*0.06 + sy*0.035, tocolor(62, 151, 230, 255), 1/myX*sx, fonts["condensed-13"], "right", "center", false, false, false, true)
        dxDrawText("", sx*0.013, sy*0.06, sx*0.02 + sx*0.115, sy*0.06 + sy*0.035, tocolor(62, 151, 230, 255), 1/myX*sx, font:getFont("fontawesome2", 13), "left", "center", false, false, false, true)

        dxDrawRectangle(sx*0.7, sy*0.02, sx*0.29, sy*0.035, tocolor(35, 35, 35, 200))
        dxDrawText(color.."[Backspace]: #ffffffVisszalépés, "..color.."[Enter]: #ffffffTovábblépés, "..color.."[Nyilak]: #ffffffNavigálás", sx*0.7, sy*0.02, sx*0.7+sx*0.29, sy*0.02 + sy*0.035, tocolor(255, 255, 255, 255), 0.85/myX*sx, fonts["condensed-13"], "center", "center", false, false, true, true)

        if customPlateTextPanel then 
            allowedWords = true 
            allowedMinLength = true
            allowedMaxLength = true 

            core:drawWindow(sx*0.4, sy*0.4, sx*0.2, sy*0.2, "Egyedi rendszám", 1)

            if core:isInSlot(sx*0.585, sy*0.4, sx*0.02, sy*0.02) then
                if getKeyState("mouse1") then
                    toggleCustomPlateTextpanel()
                end
                dxDrawText("", sx*0.4 + 2/myX*sx, sy*0.4 + 2/myY*sy, sx*0.4 + 2/myX*sx + sx*0.197 - 8/myX*sx, sy*0.4 + 2/myY*sy+sy*0.02, tocolor(255, 255, 255, 150), 1, font:getFont("fontawesome2", 9/myX*sx), "right", "center", false, false, false, true)
            else
                dxDrawText("", sx*0.4 + 2/myX*sx, sy*0.4 + 2/myY*sy, sx*0.4 + 2/myX*sx + sx*0.197 - 8/myX*sx, sy*0.4 + 2/myY*sy+sy*0.02, tocolor(255, 255, 255, 100), 1, font:getFont("fontawesome2", 9/myX*sx), "right", "center", false, false, false, true)
            end

            local platetext = core:getEditboxText("customplate") or ""
            local inputValue = string.lower(platetext)
            if string.len(inputValue) >= 3 then 
                allowedMinLength = true 
            else
                allowedMinLength = false
            end

            if string.len(inputValue) <= 7 then 
                allowedMaxLength = true 
            else
                allowedMaxLength = false
            end
            
            if allowedMinLength then 
                dxDrawText("Minimum 3 karakter", sx*0.4, sy*0.445, sx*0.6, sy*0.445, tocolor(135, 227, 125, 255), 0.85/myX*sx, fonts["condensed-13"], "center", "center")
            else
                dxDrawText("Minimum 3 karakter", sx*0.4, sy*0.445, sx*0.6, sy*0.445, tocolor(245, 98, 98, 255), 0.85/myX*sx, fonts["condensed-13"], "center", "center")
            end

            if allowedMaxLength then 
                dxDrawText("Maximum 7 karakter", sx*0.4, sy*0.465, sx*0.6, sy*0.465, tocolor(135, 227, 125, 255), 0.85/myX*sx, fonts["condensed-13"], "center", "center")
            else
                dxDrawText("Maximum 7 karakter", sx*0.4, sy*0.465, sx*0.6, sy*0.465, tocolor(245, 98, 98, 255), 0.85/myX*sx, fonts["condensed-13"], "center", "center")
            end

            for k, v in ipairs(disallowedPlateTexts) do
                if string.find(inputValue, v) then 
                    allowedWords = false
                end
            end
            if allowedWords then
                dxDrawText("Tiltott kifejezések", sx*0.4, sy*0.485, sx*0.6, sy*0.485, tocolor(135, 227, 125, 255), 0.85/myX*sx, fonts["condensed-13"], "center", "center")
            else
                dxDrawText("Tiltott kifejezések", sx*0.4, sy*0.485, sx*0.6, sy*0.485, tocolor(245, 98, 98, 255), 0.85/myX*sx, fonts["condensed-13"], "center", "center")
            end

            if allowedWords and allowedMinLength and allowedMaxLength then 
                core:dxDrawButton(sx*0.45, sy*0.54, sx*0.1, sy*0.03, r, g, b, 150, "Rendszám vásárlása", tocolor(255, 255, 255, 255), 0.85/myX*sx, fonts["condensed-13"])
                if core:isInSlot(sx*0.45, sy*0.54, sx*0.1, sy*0.03) then 
                    if getKeyState("mouse1") then 
                        if getElementData(localPlayer, "char:pp") >= 1000 then 
                            local rendszam = core:getEditboxText("customplate")

                            local hasznalt = false 
                            for k, v in ipairs(getElementsByType("vehicle")) do
                                if getVehiclePlateText(v) == rendszam then
                                    hasznalt = true 
                                    break
                                end
                            end

                            if not hasznalt then
                                triggerServerEvent("tuning > setCustomPlateText", resourceRoot, getPedOccupiedVehicle(localPlayer), rendszam)
                            else                             
                                infobox:outputInfoBox("Ez a rendszám már használatban van!", "error")
                            end
                        else
                            infobox:outputInfoBox("Nincs elegendő prémium pontod! {#colorcode}1.000PP", "error")
                        end

                        toggleCustomPlateTextpanel()
                    end
                end 
            else
                core:dxDrawButton(sx*0.45, sy*0.54, sx*0.1, sy*0.03, r, g, b, 50, "Rendszám vásárlása", tocolor(255, 255, 255, 100), 0.85/myX*sx, fonts["condensed-13"])
            end

            dxDrawText("Egyedi rendszám ára #0390fc1.000PP#ffffff.", sx*0.4, sy*0.58, sx*0.6, sy*0.58, tocolor(255, 255, 255, 100), 0.75/myX*sx, fonts["condensed-13"], "center", "center", false, false, false, true)
        end

        if loadinBarShowing then 
            local loadValue = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount()-loadingBarTick)/loadingTime, "Linear")

            dxDrawRectangle(0, 0, sx, sy, tocolor(30, 30, 30, 150))
            dxDrawImage(sx*0.48, sy*0.48, 50/myX*sx, 50/myX*sx, "files/loadIcon.png", loadValue * 1000, 0, 0, tocolor(r, g, b, 255 * interpolateBetween(0.3, 0, 0, 1, 0, 0, (getTickCount() - 200 - loadingBarTick) / 2500, "CosineCurve")))
            dxDrawImage(sx*0.5, sy*0.425, 90/myX*sx, 90/myX*sx, "files/loadIcon.png", -(loadValue * 1000), 0, 0, tocolor(r, g, b, 255 * interpolateBetween(0.1, 0, 0, 1, 0, 0, (getTickCount() - 500 - loadingBarTick) / 2500, "CosineCurve")))
            dxDrawImage(sx*0.5, sy*0.52, 30/myX*sx, 30/myX*sx, "files/loadIcon.png", -(loadValue * 1000), 0, 0, tocolor(r, g, b, 255 * interpolateBetween(0.5, 0, 0, 1, 0, 0, (getTickCount() - loadingBarTick) / 2500, "CosineCurve")))
            --dxDrawRectangle(sx*0.4, sy*0.49, sx*0.2, sy*0.025, tocolor(35, 35, 35, 255*a))
            --dxDrawRectangle(sx*0.4+2/myX*sx, sy*0.49+2/myY*sy, sx*0.2-4/myX*sx, sy*0.025-4/myY*sy, tocolor(40, 40, 40, 255*a))

            --dxDrawRectangle(sx*0.4+2/myX*sx, sy*0.49+2/myY*sy, (sx*0.2-4/myX*sx)*loadValue, sy*0.025-4/myY*sy, tocolor(r, g, b, 200*a))
            --core:dxDrawShadowedText(loadingBarText, sx*0.4+2/myX*sx, sy*0.49+2/myY*sy, sx*0.4+2/myX*sx+sx*0.2-4/myX*sx, sy*0.49+2/myY*sy+sy*0.025-4/myY*sy, tocolor(255, 255, 255, 255*a), tocolor(0, 0, 0, 255*a), 0.8/myX*sx, fonts["condensed-13"], "center", "center")
        end

       -- core:dxDrawShadowedText(core:getServerName().." #ffffff- Tuning Garage", sx*0.01, sy*0.775, sx*0.01+sx*0.2, sy*0.775+sy*0.05, tocolor(r, g, b, 255*a), tocolor(0, 0, 0, 255*a), 0.8/myX*sx, fonts["bebasneue-25"], "left", "center", false, false, false, true)

        local almenuTitle = ""
        if page == 1 then 
            almenuTitle = "Kategória"
         --   core:dxDrawShadowedText("Válassz kategóriát!", sx*0.01, sy*0.8, sx*0.01+sx*0.2, sy*0.8+sy*0.05, tocolor(255, 255, 255, 255*a), tocolor(0, 0, 0, 255*a), 0.6/myX*sx, fonts["bebasneue-25"], "left", "center", false, false, false, true)
            local startX = sx*0.01
            for k, v in ipairs(tunings) do 
                if k == selectedTuning then 
                    if menuPointAnimations[k].state == "close" then
                        if menuPointAnimations[k].tick < getTickCount() then 
                            menuPointAnimations[k].tick = getTickCount()
                            menuPointAnimations[k].state = "open"
                        end
                    end
                else
                    if menuPointAnimations[k].state == "open" then
                        if menuPointAnimations[k].tick < getTickCount() then 
                            menuPointAnimations[k].tick = getTickCount()
                            menuPointAnimations[k].state = "close"
                        end
                    end
                end

                if menuPointAnimations[k].state == "open" then 
                    menuPointAnimations[k].alpha =  interpolateBetween(menuPointAnimations[k].alpha, 0, 0, 1, 0, 0, (getTickCount() - menuPointAnimations[k].tick) / 250, "Linear")
                else
                    menuPointAnimations[k].alpha =  interpolateBetween(menuPointAnimations[k].alpha, 0, 0, 0.5, 0, 0, (getTickCount() - menuPointAnimations[k].tick) / 250, "Linear")
                end

                dxDrawRectangle(startX, sy*0.84, 150/myX*sx, 150/myX*sx, tocolor(35, 35, 35, 255*math.max(menuPointAnimations[k].alpha, 0.7)*a))

                
                dxDrawImage(startX+((150/myX*sx)/2)-(60 + 10 * menuPointAnimations[k].alpha)/myX*sx/2, sy*0.85, (60 + 10 * menuPointAnimations[k].alpha)/myX*sx, (60 + 10 * menuPointAnimations[k].alpha)/myY*sy, "files/"..v.icon..".png", 0, 0, 0, tocolor(255, 255, 255, 255*menuPointAnimations[k].alpha*a))
                dxDrawText(v.title, startX, sy*0.94, startX+150/myX*sx, sy*0.94+sy*0.03, tocolor(220, 220, 220, 255*menuPointAnimations[k].alpha*a), (0.8 + (0.1 * menuPointAnimations[k].alpha))/myX*sx, fonts["condensed-13"], "center", "center")

                startX = startX + 160/myX*sx
            end
        elseif page == 2 then 
            local pagePlus = 0

            if selectedAlTuning > 10 then 
                pagePlus = pagePlus + (selectedAlTuning-10)
            end

            almenuTitle = tunings[selectedTuning].title

            local startX = sx*0.01
            for i = 1, 10 do 
                local v = tunings[selectedTuning].tunings[i+pagePlus]
                if not v then break end


                if i+pagePlus == selectedAlTuning then 
                    if menuPointAnimations[i+pagePlus].state == "close" then
                        if menuPointAnimations[i+pagePlus].tick < getTickCount() then 
                            menuPointAnimations[i+pagePlus].tick = getTickCount()
                            menuPointAnimations[i+pagePlus].state = "open"
                        end
                    end
                else
                    if menuPointAnimations[i+pagePlus].state == "open" then
                        if menuPointAnimations[i+pagePlus].tick < getTickCount() then 
                            menuPointAnimations[i+pagePlus].tick = getTickCount()
                            menuPointAnimations[i+pagePlus].state = "close"
                        end
                    end
                end

                if menuPointAnimations[i+pagePlus].state == "open" then 
                    menuPointAnimations[i+pagePlus].alpha =  interpolateBetween(menuPointAnimations[i+pagePlus].alpha, 0, 0, 1, 0, 0, (getTickCount() - menuPointAnimations[i+pagePlus].tick) / 250, "Linear")
                else
                    menuPointAnimations[i+pagePlus].alpha =  interpolateBetween(menuPointAnimations[i+pagePlus].alpha, 0, 0, 0.5, 0, 0, (getTickCount() - menuPointAnimations[i+pagePlus].tick) / 250, "Linear")
                end

                local textR, textB, textG = 255, 255, 255

                if tunings[selectedTuning].tunings[i+pagePlus].isCustomTuning then 
                    if not (specialTuningIsAvailableForOccupiedVehicle(tunings[selectedTuning].tunings[i+pagePlus].customTuningID)) then 
                        textR, textB, textG = 250, 87, 75
                    end
                end

                dxDrawRectangle(startX, sy*0.84, 150/myX*sx, 150/myX*sx, tocolor(35, 35, 35, 255*math.max(menuPointAnimations[i+pagePlus].alpha, 0.7)*a))
                
                dxDrawImage(startX+((150/myX*sx)/2)-(60 + 10 * menuPointAnimations[i+pagePlus].alpha)/myX*sx/2, sy*0.85, (60 + 10 * menuPointAnimations[i+pagePlus].alpha)/myX*sx, (60 + 10 * menuPointAnimations[i+pagePlus].alpha)/myY*sy, "files/"..v.icon..".png", 0, 0, 0, tocolor(textR, textB, textG, 255*menuPointAnimations[i+pagePlus].alpha*a))
                dxDrawText(v.title, startX, sy*0.94, startX+150/myX*sx, sy*0.94+sy*0.03, tocolor(textR, textB, textG, 255*menuPointAnimations[i+pagePlus].alpha*a), (0.8 + (0.1 * menuPointAnimations[i+pagePlus].alpha))/myX*sx, fonts["condensed-13"], "center", "center")

                startX = startX + 160/myX*sx
            end
        elseif page == 3 then 
            local pagePlus = 0

            if selectedAlAlTuning > 10 then 
                pagePlus = pagePlus + (selectedAlAlTuning-10)
            end
            
            almenuTitle = tunings[selectedTuning].tunings[selectedAlTuning].title

            local startX = sx*0.01
            for i = 1, 10 do 
                local v
                if not (tunings[selectedTuning].tunings[selectedAlTuning].isCustomTuning or false) then 
                    v = tunings[selectedTuning].tunings[selectedAlTuning].options[i+pagePlus]
                else
                    v = customTunings[getElementModel(occupiedVeh)][tunings[selectedTuning].tunings[selectedAlTuning].customTuningID][i+pagePlus]
                end

                if not v then break end
    
                local backgorundAlpha = 230 
                local dataAlpha = 100

                if selectedAlAlTuning == i+pagePlus then
                    backgorundAlpha = 255 
                    dataAlpha = 255
                end

                if i+pagePlus == selectedAlAlTuning then 
                    if menuPointAnimations[i+pagePlus].state == "close" then
                        if menuPointAnimations[i+pagePlus].tick < getTickCount() then 
                            menuPointAnimations[i+pagePlus].tick = getTickCount()
                            menuPointAnimations[i+pagePlus].state = "open"
                        end
                    end
                else
                    if menuPointAnimations[i+pagePlus].state == "open" then
                        if menuPointAnimations[i+pagePlus].tick < getTickCount() then 
                            menuPointAnimations[i+pagePlus].tick = getTickCount()
                            menuPointAnimations[i+pagePlus].state = "close"
                        end
                    end
                end

                if menuPointAnimations[i+pagePlus].state == "open" then 
                    menuPointAnimations[i+pagePlus].alpha =  interpolateBetween(menuPointAnimations[i+pagePlus].alpha, 0, 0, 1, 0, 0, (getTickCount() - menuPointAnimations[i+pagePlus].tick) / 250, "Linear")
                else
                    menuPointAnimations[i+pagePlus].alpha =  interpolateBetween(menuPointAnimations[i+pagePlus].alpha, 0, 0, 0.5, 0, 0, (getTickCount() - menuPointAnimations[i+pagePlus].tick) / 250, "Linear")
                end

                local textR, textB, textG = 255, 255, 255

                dxDrawRectangle(startX, sy*0.84, 150/myX*sx, 150/myX*sx, tocolor(35, 35, 35, 255*math.max(menuPointAnimations[i+pagePlus].alpha, 0.7)*a))
                dxDrawImage(startX+((150/myX*sx)/2)-(60 + 10 * menuPointAnimations[i+pagePlus].alpha)/myX*sx/2, sy*0.85, (60 + 10 * menuPointAnimations[i+pagePlus].alpha)/myX*sx, (60 + 10 * menuPointAnimations[i+pagePlus].alpha)/myY*sy, "files/"..v.icon..".png", 0, 0, 0, tocolor(textR, textB, textG, 255*menuPointAnimations[i].alpha*a))

                local mainText = ""
                local secondaryTitle = ""

                if v.price then 
                    mainText = v.title

                    if tunings[selectedTuning].tunings[selectedAlTuning].title == "Meghajtás" then    
                        local vehHandling = getVehicleHandling(occupiedVeh)

                        if ("driveType-"..vehHandling["driveType"]) == (v.tuningID) then 
                            secondaryTitle = color.."Jelenlegi"
                        end 
                    elseif tunings[selectedTuning].title == "Optikai tuning" or tunings[selectedTuning].title == "Egyéb" then 
                        local activeTuning = false

                        if tunings[selectedTuning].tunings[selectedAlTuning].title == "Kerekek" then 
                            if (getElementData(occupiedVeh, "veh:tuningWheel") or 0) == (v.upID) then 
                                activeTuning = true 
                            end 
                        elseif tunings[selectedTuning].tunings[selectedAlTuning].title == "Spoiler" then 
                            if (getElementData(occupiedVeh, "veh:tuning:spoiler") or 0) == (v.upID) then 
                                activeTuning = true 
                            end 
                        elseif tunings[selectedTuning].tunings[selectedAlTuning].title == "Airride" then 
                            if (getElementData(occupiedVeh, "veh:tuning:airride") or 0) == (v.upID) then 
                                activeTuning = true 
                            end 
                        elseif tunings[selectedTuning].tunings[selectedAlTuning].isCustomTuning then 
                            if not tunings[selectedTuning].tunings[selectedAlTuning].customTuningID == "supercharger" then
                                if customTunings[getElementModel(occupiedVeh)][tunings[selectedTuning].tunings[selectedAlTuning].customTuningID][i+pagePlus].upID == getElementData(occupiedVeh, "veh:tuning:"..tunings[selectedTuning].tunings[selectedAlTuning].customTuningID) then 
                                    activeTuning = true
                                end 
                            end
                        end

                        if activeTuning then 
                            secondaryTitle = color.."Jelenlegi"                
                        end
                    else
                        if core:tableContains(vehEngineTunings, v.tuningID) then 
                            secondaryTitle = color.."Kiszerelés"
                        end
                    end
                end

                if secondaryTitle == "" then 
                    if v.price[1] == 1 then 
                        secondaryTitle = "#4ebf6b"..comma_value(v.price[2]).."$"
                    elseif v.price[1] == 2 then
                        secondaryTitle = "#3e97e6"..comma_value(v.price[2]).."PP"
                    end   
                end
                dxDrawText(mainText, startX, sy*0.94, startX+150/myX*sx, sy*0.94+sy*0.03, tocolor(textR, textB, textG, 255*menuPointAnimations[i+pagePlus].alpha*a), (0.8 + (0.1 * menuPointAnimations[i+pagePlus].alpha))/myX*sx, fonts["condensed-13"], "center", "center")
                dxDrawText(secondaryTitle, startX, sy*0.96, startX+150/myX*sx, sy*0.96+sy*0.02, tocolor(textR, textB, textG, 255*menuPointAnimations[i+pagePlus].alpha*a), (0.8 + (0.1 * menuPointAnimations[i+pagePlus].alpha))/myX*sx, fonts["condensed-13-l"], "center", "center", false, false, false, true)

                startX = startX + 160/myX*sx
            end

            local lineWidth
            local availableMenus = 0

            if not (tunings[selectedTuning].tunings[selectedAlTuning].isCustomTuning or false) then 
                availableMenus = math.min(#tunings[selectedTuning].tunings[selectedAlTuning].options, 10)
                lineWidth = availableMenus/#tunings[selectedTuning].tunings[selectedAlTuning].options
            else
                availableMenus = math.min(#customTunings[getElementModel(occupiedVeh)][tunings[selectedTuning].tunings[selectedAlTuning].customTuningID], 10)
                lineWidth = availableMenus/#customTunings[getElementModel(occupiedVeh)][tunings[selectedTuning].tunings[selectedAlTuning].customTuningID]
            end

            if lineWidth > 1 then lineWidth = 1 end

            dxDrawRectangle(sx*0.01, sy*0.993, (availableMenus * 160/myX*sx) - 10/myX*sx , sy*0.003, tocolor(35, 35, 35, 200*a))
            dxDrawRectangle(sx*0.01+(((availableMenus * 160/myX*sx) - 10/myX*sx)*(lineWidth/availableMenus*pagePlus)), sy*0.993, ((availableMenus * 160/myX*sx) - 10/myX*sx)*lineWidth, sy*0.003, tocolor(r, g, b, 200*a))
 
            --[[for i = 1, #tunings[selectedTuning].tunings[selectedAlTuning].options do 
                dxDrawRectangle(sx*0.01+(sx*0.985/#tunings[selectedTuning].tunings[selectedAlTuning].options)*(i-1), sy*0.988, sx*0.01, sy*0.1)
            end]]

            if tunings[selectedTuning].title == "Optikai tuning" then    
                if tunings[selectedTuning].tunings[selectedAlTuning].title == "Fényezés" then 
                    if selectedColor > 0 then 
                        drawColorPicker()
                    end
                end
            end
        end

        dxDrawRectangle(sx*0.01, sy*0.8, dxGetTextWidth(almenuTitle, 1/myX*sx, fonts["condensed-13"]) + sx*0.01, sy*0.035, tocolor(35, 35, 35, 200 * a))
        dxDrawText(almenuTitle, sx*0.015, sy*0.8, sx*0.015 + dxGetTextWidth(almenuTitle, 1/myX*sx, fonts["condensed-13"]) + sx*0.005, sy*0.8 + sy*0.035, tocolor(255, 255, 255, 255 * a),  1/myX*sx, fonts["condensed-13"], "left", "center")
    else
        quitFromTuning()    
    end
end

local superchargerBuy = false
function tuningKey(key, state)
    if state then 
        if allowedInteraction then 
            if page == 1 then 
                if key == "arrow_r" then 
                    if selectedTuning < #tunings then 
                        selectedTuning = selectedTuning + 1
                    else
                        selectedTuning = 1
                    end
                    playSound("files/sounds/hover.wav")
                elseif key == "arrow_l" then 
                    if selectedTuning > 1 then 
                        selectedTuning = selectedTuning - 1
                    else
                        selectedTuning = #tunings
                    end
                    playSound("files/sounds/hover.wav")
                elseif key == "enter" then 
                    page = 2
                    resetMenuAnimations()
                    selectedAlTuning = 1
                    playSound("files/sounds/select.wav")
                elseif key == "backspace" then 
                    quitFromTuning()
                end
            elseif page == 2 then 
                if key == "arrow_r" then 
                    if customPlateTextPanel then return end

                    if selectedAlTuning < #tunings[selectedTuning].tunings then 
                        if tunings[selectedTuning].tunings[selectedAlTuning + 1].isCustomTuning then 
                            if not (specialTuningIsAvailableForOccupiedVehicle(tunings[selectedTuning].tunings[selectedAlTuning + 1].customTuningID)) then 
                                for k, v in ipairs(tunings[selectedTuning].tunings) do 
                                    if not v.isCustomTuning then 
                                        if k > selectedAlTuning then 
                                            selectedAlTuning = k
                                            break 
                                        end
                                    else
                                        if (specialTuningIsAvailableForOccupiedVehicle(v.customTuningID)) then 
                                            if k > selectedAlTuning then 
                                                selectedAlTuning = k 
                                                break
                                            end
                                        end
                                    end
                                end
                            else
                                selectedAlTuning = selectedAlTuning + 1
                            end 
                        else
                            selectedAlTuning = selectedAlTuning + 1
                        end
                    else
                        selectedAlTuning = 1
                    end

                    playSound("files/sounds/hover.wav")
                elseif key == "arrow_l" then 
                    if customPlateTextPanel then return end

                    if selectedAlTuning > 1 then 
                        if tunings[selectedTuning].tunings[selectedAlTuning - 1].isCustomTuning then 
                            if not (specialTuningIsAvailableForOccupiedVehicle(tunings[selectedTuning].tunings[selectedAlTuning - 1].customTuningID)) then 
                                for k = #tunings[selectedTuning].tunings, 1, -1 do 
                                    v = tunings[selectedTuning].tunings[k]

                                    if not v.isCustomTuning then 
                                        if k < selectedAlTuning then 
                                            selectedAlTuning = k
                                            break 
                                        end
                                    else
                                        if (specialTuningIsAvailableForOccupiedVehicle(v.customTuningID)) then 
                                            if k < selectedAlTuning then 
                                                selectedAlTuning = k 
                                                break
                                            end
                                        end
                                    end
                                end
                            else
                                selectedAlTuning = selectedAlTuning - 1
                            end 
                        else
                            selectedAlTuning = selectedAlTuning - 1
                        end
                    else
                        selectedAlTuning = #tunings[selectedTuning].tunings
                    end
                    playSound("files/sounds/hover.wav")
                elseif key == "enter" then 
                    if customPlateTextPanel then return end

                    if tunings[selectedTuning].tunings[selectedAlTuning].isCustomTuning then 
                        if not (specialTuningIsAvailableForOccupiedVehicle(tunings[selectedTuning].tunings[selectedAlTuning].customTuningID)) then 
                            infobox:outputInfoBox("Erre a járműre ez az elem nem érhető el!", "error")
                            return
                        end

                        selectedAlAlTuning = 1 

                        if tunings[selectedTuning].tunings[selectedAlTuning].customTuningID == "paintjob" then
                            startPaintjob = getElementData(getPedOccupiedVehicle(localPlayer), "veh:paintjob")
                            setElementData(getPedOccupiedVehicle(localPlayer), "veh:paintjob", customTunings[getElementModel(getPedOccupiedVehicle(localPlayer))][tunings[selectedTuning].tunings[selectedAlTuning].customTuningID][selectedAlAlTuning].upID, false)
                        end

                        addVehicleUpgrade(getPedOccupiedVehicle(localPlayer),  customTunings[getElementModel(getPedOccupiedVehicle(localPlayer))][tunings[selectedTuning].tunings[selectedAlTuning].customTuningID][selectedAlAlTuning].upID)

                        if tunings[selectedTuning].tunings[selectedAlTuning].component then 
                            local needToggle = tunings[selectedTuning].tunings[selectedAlTuning].toogleNeeded or false 
    
                            if tunings[selectedTuning].tunings[selectedAlTuning].title == "Kerekek" then
                                needToggle = false 
    
                                if (getElementData(getPedOccupiedVehicle(localPlayer), "veh:tuningWheel") or 0) > 0 then
                                    removeVehicleUpgrade(getPedOccupiedVehicle(localPlayer),  getElementData(getPedOccupiedVehicle(localPlayer), "veh:tuningWheel"))
                                end
                            end
    
                            if needToggle then  
                                setVehicleComponentVisible(getPedOccupiedVehicle(localPlayer), tunings[selectedTuning].tunings[selectedAlTuning].component, false)
                            end
                            
                            local camX, camY, camZ, camX2, camY2, camZ2 = getCameraMatrix()
                            local carX, carY, carZ = getElementPosition(getPedOccupiedVehicle(localPlayer))
    
                            local camrot = camRotations[tunings[selectedTuning].tunings[selectedAlTuning].component]
    
                            local componentX, componentY, componentZ = getVehicleComponentPosition(getPedOccupiedVehicle(localPlayer), tunings[selectedTuning].tunings[selectedAlTuning].component)
                            local comX, comY, comZ = getPositionFromElementOffset(getPedOccupiedVehicle(localPlayer), componentX-camrot[4], componentY-camrot[5], componentZ-camrot[6])
                            local comX2, comY2, comZ2 = getPositionFromElementOffset(getPedOccupiedVehicle(localPlayer), camrot[1], camrot[2], camrot[3])
    
                            --removeCamHandler()
                            if componentX and componentY and componentZ then
                                smoothMoveCamera(camX, camY, camZ, camX2, camY2, camZ2, comX, comY, comZ, comX2, comY2, comZ2, 1000)
                                allowedInteraction = false 
                                setTimer(function() 
                                    allowedInteraction = true
                                end, 1000, 1)
                            end
                        end
                    elseif tunings[selectedTuning].tunings[selectedAlTuning].component then 
                        local vehType = getVehicleType(getPedOccupiedVehicle(localPlayer))

                        if vehType == "Bike" then 
                            if tunings[selectedTuning].tunings[selectedAlTuning].disabledForMotors then 
                                infobox:outputInfoBox("Motorra ez a lehetőség nem érhető el!", "warning")
                                return 
                            end 
                        end

                        local needToggle = tunings[selectedTuning].tunings[selectedAlTuning].toogleNeeded or false 

                        if tunings[selectedTuning].tunings[selectedAlTuning].title == "Kerekek" then
                            needToggle = false 

                            if (getElementData(getPedOccupiedVehicle(localPlayer), "veh:tuningWheel") or 0) > 0 then
                                removeVehicleUpgrade(getPedOccupiedVehicle(localPlayer),  getElementData(getPedOccupiedVehicle(localPlayer), "veh:tuningWheel"))
                            end
                        end

                        if not (vehType == "Bike") then
                            if needToggle then  
                                setVehicleComponentVisible(getPedOccupiedVehicle(localPlayer), tunings[selectedTuning].tunings[selectedAlTuning].component, false)
                            end

                                local camX, camY, camZ, camX2, camY2, camZ2 = getCameraMatrix()
                                local carX, carY, carZ = getElementPosition(getPedOccupiedVehicle(localPlayer))
        
                                local camrot = camRotations[tunings[selectedTuning].tunings[selectedAlTuning].component]
        
                                local componentX, componentY, componentZ = getVehicleComponentPosition(getPedOccupiedVehicle(localPlayer), tunings[selectedTuning].tunings[selectedAlTuning].component)
                                
                                if componentX and componentY and componentZ then
                                    local comX, comY, comZ = getPositionFromElementOffset(getPedOccupiedVehicle(localPlayer), componentX-camrot[4], componentY-camrot[5], componentZ-camrot[6])
                                    local comX2, comY2, comZ2 = getPositionFromElementOffset(getPedOccupiedVehicle(localPlayer), camrot[1], camrot[2], camrot[3])
            
                                    --removeCamHandler()
                                    if componentX and componentY and componentZ then
                                        smoothMoveCamera(camX, camY, camZ, camX2, camY2, camZ2, comX, comY, comZ, comX2, comY2, comZ2, 1000)
                                        allowedInteraction = false 
                                        setTimer(function() 
                                            allowedInteraction = true
                                        end, 1000, 1)
                                    end
                                end
                            
                        end
                    elseif tunings[selectedTuning].tunings[selectedAlTuning].icon == "paint" then 
                    elseif tunings[selectedTuning].tunings[selectedAlTuning].icon == "supercharger" then 
                        superchargerBuy = getElementData(getPedOccupiedVehicle(localPlayer), "veh:sc")
                        setElementData(getPedOccupiedVehicle(localPlayer), "veh:sc", false)
                    elseif tunings[selectedTuning].tunings[selectedAlTuning].icon == "neon" then 
                        startNeon = (getElementData(getPedOccupiedVehicle(localPlayer), "veh:paintjob:id") or 0)
                        setElementData(getPedOccupiedVehicle(localPlayer), "veh:neon:active", true)
                    elseif tunings[selectedTuning].tunings[selectedAlTuning].icon == "plate" then 
                        playSound("files/sounds/select.wav")
                        
                        showCustomPlateTextPanel()

                        return 

                    end
 
                   selectedAlAlTuning = 1 
                    page = 3
                    resetMenuAnimations()

                    playSound("files/sounds/select.wav")
                elseif key == "backspace" then 
                    if customPlateTextPanel then
                        return 
                    end 

                    page = 1
                    resetMenuAnimations()

                end
            elseif page == 3 then 
                if key == "arrow_r" then 
                    if selectedColor == 0 then 

                        local oldSelected = selectedAlAlTuning

                        if not (tunings[selectedTuning].tunings[selectedAlTuning].isCustomTuning or false) then 
                            if selectedAlAlTuning < #tunings[selectedTuning].tunings[selectedAlTuning].options then 
                                selectedAlAlTuning = selectedAlAlTuning + 1
                            else
                                selectedAlAlTuning = 1
                            end 
                        else
                            if selectedAlAlTuning < #customTunings[getElementModel(getPedOccupiedVehicle(localPlayer))][tunings[selectedTuning].tunings[selectedAlTuning].customTuningID] then 
                                selectedAlAlTuning = selectedAlAlTuning + 1
                            else
                                selectedAlAlTuning = 1
                            end 
                        end

                        if tunings[selectedTuning].title == "Optikai tuning" then 
                            if (tunings[selectedTuning].tunings[selectedAlTuning].title == "Kerekek") then 
                                removeVehicleUpgrade(getPedOccupiedVehicle(localPlayer),  tunings[selectedTuning].tunings[selectedAlTuning].options[oldSelected].upID)
                                addVehicleUpgrade(getPedOccupiedVehicle(localPlayer),  tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].upID)
                            elseif (tunings[selectedTuning].tunings[selectedAlTuning].title == "Spoiler") then 
                                removeVehicleUpgrade(getPedOccupiedVehicle(localPlayer),  tunings[selectedTuning].tunings[selectedAlTuning].options[oldSelected].upID)
                                addVehicleUpgrade(getPedOccupiedVehicle(localPlayer),  tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].upID)
                            elseif tunings[selectedTuning].tunings[selectedAlTuning].customTuningID == "paintjob" then
                                setElementData(getPedOccupiedVehicle(localPlayer), "veh:paintjob", customTunings[getElementModel(getPedOccupiedVehicle(localPlayer))][tunings[selectedTuning].tunings[selectedAlTuning].customTuningID][selectedAlAlTuning].upID, false)
                            elseif tunings[selectedTuning].tunings[selectedAlTuning].title == "Neon" then 
                                setElementData(getPedOccupiedVehicle(localPlayer), "veh:neon:id", tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].upID, false)
                            elseif (tunings[selectedTuning].tunings[selectedAlTuning].isCustomTuning or false) then 
                                removeVehicleUpgrade(getPedOccupiedVehicle(localPlayer),  customTunings[getElementModel(getPedOccupiedVehicle(localPlayer))][tunings[selectedTuning].tunings[selectedAlTuning].customTuningID][oldSelected].upID)
                                addVehicleUpgrade(getPedOccupiedVehicle(localPlayer),  customTunings[getElementModel(getPedOccupiedVehicle(localPlayer))][tunings[selectedTuning].tunings[selectedAlTuning].customTuningID][selectedAlAlTuning].upID)
                            end
                        elseif tunings[selectedTuning].title == "Egyéb" then 
                            if tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].wheelScale then 
                                local wScale = tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].wheelScale
                                local type = tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].scale
                                local occupidveh = getPedOccupiedVehicle(localPlayer)
                                --print(wScale)
                                if type == "front" then 
                                    triggerServerEvent("tuning:vehicleWheelWidth", localPlayer, occupidveh, "front", wScale)
                                elseif type == "rear" then 
                                    triggerServerEvent("tuning:vehicleWheelWidth", localPlayer, occupidveh, "rear", wScale)
                                end
                            elseif (tunings[selectedTuning].tunings[selectedAlTuning].title == "Variáns") then 
                                local occupiedVeh = getPedOccupiedVehicle(localPlayer)

                                setVehicleVariant(occupiedVeh, unpack(tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].upID))

                                resetCamera()
                            elseif (tunings[selectedTuning].tunings[selectedAlTuning].title == "Egyedi duda") then 
                                local sound = "files/sounds/horns/"..tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].upID..".mp3"

                                if isElement(hornTestSound) then 
                                    destroyElement(hornTestSound)
                                end

                                if fileExists(sound) then 
                                    hornTestSound = playSound(sound)
                                end
                            elseif (tunings[selectedTuning].tunings[selectedAlTuning].title == "Supercharger") then
                                setElementData(getPedOccupiedVehicle(localPlayer), "veh:sc", customTunings[getElementModel(getPedOccupiedVehicle(localPlayer))][tunings[selectedTuning].tunings[selectedAlTuning].customTuningID][selectedAlAlTuning].upID)
                            end
                        end

                        playSound("files/sounds/hover.wav")
                    end
                elseif key == "arrow_l" then 
                    if selectedColor == 0 then 
                        local oldSelected = selectedAlAlTuning


                        if selectedAlAlTuning > 1 then 
                            selectedAlAlTuning = selectedAlAlTuning - 1
                        else
                            if not (tunings[selectedTuning].tunings[selectedAlTuning].isCustomTuning or false) then 
                                selectedAlAlTuning = #tunings[selectedTuning].tunings[selectedAlTuning].options
                            else
                                selectedAlAlTuning = #customTunings[getElementModel(getPedOccupiedVehicle(localPlayer))][tunings[selectedTuning].tunings[selectedAlTuning].customTuningID]
                            end
                        end

                        if tunings[selectedTuning].title == "Optikai tuning" then 
                            if (tunings[selectedTuning].tunings[selectedAlTuning].title == "Kerekek") then 
                                removeVehicleUpgrade(getPedOccupiedVehicle(localPlayer),  tunings[selectedTuning].tunings[selectedAlTuning].options[oldSelected].upID)
                                addVehicleUpgrade(getPedOccupiedVehicle(localPlayer),  tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].upID)
                            elseif (tunings[selectedTuning].tunings[selectedAlTuning].title == "Spoiler") then 
                                removeVehicleUpgrade(getPedOccupiedVehicle(localPlayer),  tunings[selectedTuning].tunings[selectedAlTuning].options[oldSelected].upID)
                                addVehicleUpgrade(getPedOccupiedVehicle(localPlayer),  tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].upID)
                            elseif tunings[selectedTuning].tunings[selectedAlTuning].customTuningID == "paintjob" then
                                setElementData(getPedOccupiedVehicle(localPlayer), "veh:paintjob", customTunings[getElementModel(getPedOccupiedVehicle(localPlayer))][tunings[selectedTuning].tunings[selectedAlTuning].customTuningID][selectedAlAlTuning].upID, false)
                            elseif tunings[selectedTuning].tunings[selectedAlTuning].title == "Neon" then 
                                setElementData(getPedOccupiedVehicle(localPlayer), "veh:neon:id", tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].upID, false)
                            elseif (tunings[selectedTuning].tunings[selectedAlTuning].isCustomTuning or false) then 
                                removeVehicleUpgrade(getPedOccupiedVehicle(localPlayer),  customTunings[getElementModel(getPedOccupiedVehicle(localPlayer))][tunings[selectedTuning].tunings[selectedAlTuning].customTuningID][oldSelected].upID)
                                addVehicleUpgrade(getPedOccupiedVehicle(localPlayer),  customTunings[getElementModel(getPedOccupiedVehicle(localPlayer))][tunings[selectedTuning].tunings[selectedAlTuning].customTuningID][selectedAlAlTuning].upID)
                            end
                        elseif tunings[selectedTuning].title == "Egyéb" then 
                            if tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].wheelScale then 
                                local wScale = tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].wheelScale
                                local type = tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].scale
                                local occupidveh = getPedOccupiedVehicle(localPlayer)

                                if type == "front" then 
                                    triggerServerEvent("tuning:vehicleWheelWidth", localPlayer, occupidveh, "front", wScale)
                                elseif type == "rear" then 
                                    triggerServerEvent("tuning:vehicleWheelWidth", localPlayer, occupidveh, "rear", wScale)
                                end
                            elseif (tunings[selectedTuning].tunings[selectedAlTuning].title == "Variáns") then 
                                local occupiedVeh = getPedOccupiedVehicle(localPlayer)

                                setVehicleVariant(occupiedVeh, unpack(tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].upID))

                                resetCamera()
                            elseif (tunings[selectedTuning].tunings[selectedAlTuning].title == "Egyedi duda") then 
                                local sound = "files/sounds/horns/"..tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].upID..".mp3"

                                if isElement(hornTestSound) then 
                                    destroyElement(hornTestSound)
                                end

                                if fileExists(sound) then 
                                    hornTestSound = playSound(sound)
                                end
                            elseif (tunings[selectedTuning].tunings[selectedAlTuning].title == "Supercharger") then 
                                setElementData(getPedOccupiedVehicle(localPlayer), "veh:sc", customTunings[getElementModel(getPedOccupiedVehicle(localPlayer))][tunings[selectedTuning].tunings[selectedAlTuning].customTuningID][selectedAlAlTuning].upID)
                            end
                        end
                        playSound("files/sounds/hover.wav")
                    end
                elseif key == "enter" then 
                    playSound("files/sounds/select.wav")

                    if tunings[selectedTuning].title == "Teljesítmény tuning" then      
                        local activeMenuTitle, alTitle, price, priceType, tuningID, mainTitle = getActiveMenuPoint()
                        local vehEngineTunings = getElementData(getPedOccupiedVehicle(localPlayer), "veh:engineTunings") or {}

                        if core:tableContains(vehEngineTunings, tuningID) then 
                            allowedInteraction = false
                            loadinBarShowing = true

                            loadingBarTick = getTickCount()
                            loadingBarText = "Kiszerelés folyamatban"
                            loadingTime = math.random(3000, 7000)

                            local sound = playSound("files/sounds/wrench.wav", true)

                            setTimer(function() 
                                destroyElement(sound)
                                allowedInteraction = true
                                loadinBarShowing = false

                                local newTable = vehEngineTunings
                                
                                for k, v in pairs(newTable) do 
                                    if v == tuningID then 
                                        table.remove(newTable, k)
                                        break
                                    end
                                end

                                infobox:outputInfoBox("A tuning kiszerelésre került!", "success")
                                triggerServerEvent("tuning > updateVehicleTuningsTable", resourceRoot, "engine", getPedOccupiedVehicle(localPlayer), newTable)
                            end, loadingTime, 1)
                        else
                            if price > 0 and priceType > 0 then 
                                if getElementData(localPlayer, priceTypes[priceType]) >= price then 
                                    if tuningID then 
                                        if not (string.match(toJSON(vehEngineTunings), tuningID:gsub("-%d", ""))) then 
                                            triggerServerEvent("tuning > updatePlayerMoney", resourceRoot, priceTypes[priceType], price)
                                            --print("beszerelés", tuningID)
                                            allowedInteraction = false
                                            loadinBarShowing = true

                                            loadingBarTick = getTickCount()
                                            loadingBarText = "Beszerelés folyamatban"
                                            loadingTime = math.random(5000, 11000)

                                            local sound = playSound("files/sounds/wrench.wav", true)

                                            setTimer(function() 
                                                destroyElement(sound)
                                                allowedInteraction = true
                                                loadinBarShowing = false

                                                local newTable = vehEngineTunings
                                                table.insert(newTable, tuningID)
                                                triggerServerEvent("tuning > updateVehicleTuningsTable", resourceRoot, "engine", getPedOccupiedVehicle(localPlayer), newTable)
                                                infobox:outputInfoBox("A tuning beszerelésre került!", "success")
                                            end, loadingTime, 1)
                                        else
                                            infobox:outputInfoBox("Már van beszerelve ilyen tuning! Először szereld ki!", "warning")
                                        end
                                    end
                                else
                                    if priceType == 1 then 
                                        infobox:outputInfoBox("Nincs elegendő készpénzed! ("..price.."$)", "error")
                                    elseif priceType == 2 then 
                                        infobox:outputInfoBox("Nincs elegendő prémium pontod! ("..price.."PP)", "error")
                                    end
                                end
                            end
                        end
                    elseif tunings[selectedTuning].title == "Optikai tuning" then 
                        if tunings[selectedTuning].tunings[selectedAlTuning].title == "Fényezés" then 
                            if selectedColor == 0 then 
                                addEventHandler("onClientKey", root, onClientPanelKey)
                                addEventHandler("onClientClick", root, onClientPanelClick)
                                addEventHandler("onClientCharacter", root, onClientPanelCharacter)

                                if tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].title == "Fényszóró" then 
                                    selectedColor = 5
                                else
                                    selectedColor = tonumber(tostring(tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].title:gsub("Szín ", "")))
                                end


                                local r1, g1, b1, r2, g2, b2, r3, b3, g3, r4, b4, g4 = getVehicleColor(getPedOccupiedVehicle(localPlayer), true)
                                local lR, lG, lB = getVehicleHeadLightColor(getPedOccupiedVehicle(localPlayer))
                                vehStarterColor = {r1, g1, b1, r2, g2, b2, r3, b3, g3, r4, b4, g4, lR, lG, lB}
                            else
                                local priceType = tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].price[1]
                                local price = tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].price[2]
                                if getElementData(localPlayer, priceTypes[priceType]) >= price then 
                                    local r1, g1, b1, r2, g2, b2, r3, b3, g3, r4, b4, g4 = getVehicleColor(getPedOccupiedVehicle(localPlayer), true)
                                    local lR, lG, lB = getVehicleHeadLightColor(getPedOccupiedVehicle(localPlayer))
                                    vehColorNow = {r1, g1, b1, r2, g2, b2, r3, b3, g3, r4, b4, g4, lR, lG, lB}

                                    if not (toJSON(vehColorNow) == toJSON(vehStarterColor)) then
                                        local r1, g1, b1, r2, g2, b2, r3, b3, g3, r4, b4, g4 = getVehicleColor(getPedOccupiedVehicle(localPlayer), true)
                                        local lR, lG, lB = getVehicleHeadLightColor(getPedOccupiedVehicle(localPlayer))
                                        vehStarterColor = {r1, g1, b1, r2, g2, b2, r3, b3, g3, r4, b4, g4, lR, lG, lB}

                                        triggerServerEvent("tuning > updatePlayerMoney", resourceRoot, priceTypes[priceType], price)
                                        allowedInteraction = false
                                        loadinBarShowing = true

                                        loadingBarTick = getTickCount()
                                        loadingBarText = "Fényezés folyamatban"
                                        loadingTime = math.random(5000, 11000)
                                        local sound = playSound("files/sounds/spray.wav", true)

                                        setTimer(function() 
                                            destroyElement(sound)
                                            allowedInteraction = true
                                            loadinBarShowing = false
                                            selectedColor = 0
                                            removeEventHandler("onClientKey", root, onClientPanelKey)
                                            removeEventHandler("onClientClick", root, onClientPanelClick)
                                            removeEventHandler("onClientCharacter", root, onClientPanelCharacter)
                                            triggerServerEvent("tuning > updateVehicleTuningsTable", resourceRoot, "paint", getPedOccupiedVehicle(localPlayer), vehStarterColor)
                                            infobox:outputInfoBox("A fényezés befejezésre került!", "success")
                                        end, loadingTime, 1)
                                    else 
                                        infobox:outputInfoBox("Nem módosítottál semmit a színezésen!", "error")
                                    end
                                else
                                    if priceType == 1 then 
                                        infobox:outputInfoBox("Nincs elegendő készpénzed! ("..price.."$)", "error")
                                    elseif priceType == 2 then 
                                        infobox:outputInfoBox("Nincs elegendő prémium pontod! ("..price.."PP)", "error")
                                    end
                                end
                            end
                        elseif tunings[selectedTuning].tunings[selectedAlTuning].title == "Kerekek" then 
                            local priceType = tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].price[1]
                            local price = tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].price[2]
                            if getElementData(localPlayer, priceTypes[priceType]) >= price then 
                                if (getElementData(getPedOccupiedVehicle(localPlayer), "veh:tuningWheel") or 0) == tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].upID then infobox:outputInfoBox("Jelenleg is ez a kerék van a járművön!", "error") return end
                                removeVehicleUpgrade(getPedOccupiedVehicle(localPlayer),  tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].upID)
                                triggerServerEvent("tuning > updatePlayerMoney", resourceRoot, priceTypes[priceType], price)
                                allowedInteraction = false
                                loadinBarShowing = true

                                loadingBarTick = getTickCount()
                                loadingBarText = "Felszerelés folyamatban"
                                loadingTime = math.random(6000, 11000)
                                local sound = playSound("files/sounds/wrench.wav", true)

                                setTimer(function() 
                                    destroyElement(sound)
                                    allowedInteraction = true
                                    loadinBarShowing = false
                                    selectedColor = 0
                                    removeEventHandler("onClientKey", root, onClientPanelKey)
                                    removeEventHandler("onClientClick", root, onClientPanelClick)
                                    removeEventHandler("onClientCharacter", root, onClientPanelCharacter)
                                    triggerServerEvent("tuning > updateVehicleTuningsTable", resourceRoot, "wheel", getPedOccupiedVehicle(localPlayer), tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].upID)
                                    infobox:outputInfoBox("A kerék felszerelésre került!", "success")
                                end, loadingTime, 1)
                            else
                                if priceType == 1 then 
                                    infobox:outputInfoBox("Nincs elegendő készpénzed! ("..price.."$)", "error")
                                elseif priceType == 2 then 
                                    infobox:outputInfoBox("Nincs elegendő prémium pontod! ("..price.."PP)", "error")
                                end
                            end
                        elseif tunings[selectedTuning].tunings[selectedAlTuning].title == "Spoiler" then 
                            local priceType = tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].price[1]
                            local price = tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].price[2]
                            if getElementData(localPlayer, priceTypes[priceType]) >= price then 
                                if (getElementData(getPedOccupiedVehicle(localPlayer), "veh:tuning:spoiler") or 0) == tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].upID then infobox:outputInfoBox("Jelenleg is ez a spoiler van a járművön!", "error") return end
                                removeVehicleUpgrade(getPedOccupiedVehicle(localPlayer),  tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].upID)
                                triggerServerEvent("tuning > updatePlayerMoney", resourceRoot, priceTypes[priceType], price)
                                allowedInteraction = false
                                loadinBarShowing = true

                                loadingBarTick = getTickCount()
                                loadingBarText = "Felszerelés folyamatban"
                                loadingTime = math.random(6000, 11000)
                                local sound = playSound("files/sounds/wrench.wav", true)

                                setTimer(function() 
                                    destroyElement(sound)
                                    allowedInteraction = true
                                    loadinBarShowing = false
                                    selectedColor = 0
                                    removeEventHandler("onClientKey", root, onClientPanelKey)
                                    removeEventHandler("onClientClick", root, onClientPanelClick)
                                    removeEventHandler("onClientCharacter", root, onClientPanelCharacter)
                                    triggerServerEvent("tuning > updateVehicleTuningsTable", resourceRoot, "spoiler", getPedOccupiedVehicle(localPlayer), tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].upID)
                                    infobox:outputInfoBox("A spoiler felszerelésre került!", "success")
                                end, loadingTime, 1)
                            else
                                if priceType == 1 then 
                                    infobox:outputInfoBox("Nincs elegendő készpénzed! ("..price.."$)", "error")
                                elseif priceType == 2 then 
                                    infobox:outputInfoBox("Nincs elegendő prémium pontod! ("..price.."PP)", "error")
                                end
                            end
                        elseif (tunings[selectedTuning].tunings[selectedAlTuning].isCustomTuning or false) then 
                            local priceType = customTunings[getElementModel(getPedOccupiedVehicle(localPlayer))][tunings[selectedTuning].tunings[selectedAlTuning].customTuningID][selectedAlAlTuning].price[1]
                            local price = customTunings[getElementModel(getPedOccupiedVehicle(localPlayer))][tunings[selectedTuning].tunings[selectedAlTuning].customTuningID][selectedAlAlTuning].price[2]
                            if getElementData(localPlayer, priceTypes[priceType]) >= price then 

                                if tunings[selectedTuning].tunings[selectedAlTuning].customTuningID == "paintjob" then
                                    if startPaintjob == customTunings[getElementModel(getPedOccupiedVehicle(localPlayer))][tunings[selectedTuning].tunings[selectedAlTuning].customTuningID][selectedAlAlTuning].upID then infobox:outputInfoBox("Ez a matrica van jelenleg a járművön!", "error") return end
                                else
                                    if (getElementData(getPedOccupiedVehicle(localPlayer), "veh:tuning:"..tunings[selectedTuning].tunings[selectedAlTuning].customTuningID) or 0) == customTunings[getElementModel(getPedOccupiedVehicle(localPlayer))][tunings[selectedTuning].tunings[selectedAlTuning].customTuningID][selectedAlAlTuning].upID then infobox:outputInfoBox("Ez az elem van jelenleg is a járművön!", "error") return end
                                end
                                removeVehicleUpgrade(getPedOccupiedVehicle(localPlayer), customTunings[getElementModel(getPedOccupiedVehicle(localPlayer))][tunings[selectedTuning].tunings[selectedAlTuning].customTuningID][selectedAlAlTuning].upID)
                                triggerServerEvent("tuning > updatePlayerMoney", resourceRoot, priceTypes[priceType], price)
                                allowedInteraction = false
                                loadinBarShowing = true

                                loadingBarTick = getTickCount()
                                
                                loadingTime = math.random(6000, 11000)
                                local sound

                                if tunings[selectedTuning].tunings[selectedAlTuning].customTuningID == "paintjob" then
                                    loadingBarText = "Festés folyamatban"
                                    sound = playSound("files/sounds/spray.wav", true)
                                else
                                    loadingBarText = "Felszerelés folyamatban"
                                    sound = playSound("files/sounds/wrench.wav", true)
                                end

                                setTimer(function() 
                                    destroyElement(sound)
                                    allowedInteraction = true
                                    loadinBarShowing = false
                                    selectedColor = 0
                                    removeEventHandler("onClientKey", root, onClientPanelKey)
                                    removeEventHandler("onClientClick", root, onClientPanelClick)
                                    removeEventHandler("onClientCharacter", root, onClientPanelCharacter)
                                    if tunings[selectedTuning].tunings[selectedAlTuning].customTuningID == "paintjob" then
                                        infobox:outputInfoBox("Az matrica felfestésre került!", "success")
                                        startPaintjob = customTunings[getElementModel(getPedOccupiedVehicle(localPlayer))][tunings[selectedTuning].tunings[selectedAlTuning].customTuningID][selectedAlAlTuning].upID
                                        triggerServerEvent("tuning > updateVehicleTuningsTable", resourceRoot, "paintjob", getPedOccupiedVehicle(localPlayer), customTunings[getElementModel(getPedOccupiedVehicle(localPlayer))][tunings[selectedTuning].tunings[selectedAlTuning].customTuningID][selectedAlAlTuning].upID)
                                    else
                                        infobox:outputInfoBox("Az elem felszerelésre került!", "success")
                                        triggerServerEvent("tuning > updateVehicleTuningsTable", resourceRoot, "customOpticTuning", getPedOccupiedVehicle(localPlayer), {tunings[selectedTuning].tunings[selectedAlTuning].customTuningID, customTunings[getElementModel(getPedOccupiedVehicle(localPlayer))][tunings[selectedTuning].tunings[selectedAlTuning].customTuningID][selectedAlAlTuning].upID})
                                    end
                                end, loadingTime, 1)
                            else
                                if priceType == 1 then 
                                    infobox:outputInfoBox("Nincs elegendő készpénzed! ("..price.."$)", "error")
                                elseif priceType == 2 then 
                                    infobox:outputInfoBox("Nincs elegendő prémium pontod! ("..price.."PP)", "error")
                                end
                            end
                        elseif tunings[selectedTuning].tunings[selectedAlTuning].title == "Neon" then 
                            local priceType = tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].price[1]
                            local price = tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].price[2]
                            if getElementData(localPlayer, priceTypes[priceType]) >= price then 
                                if startNeon == tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].upID then infobox:outputInfoBox("Jelenleg is ez a neon van a járművön!", "error") return end
                                removeVehicleUpgrade(getPedOccupiedVehicle(localPlayer),  tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].upID)
                                triggerServerEvent("tuning > updatePlayerMoney", resourceRoot, priceTypes[priceType], price)
                                allowedInteraction = false
                                loadinBarShowing = true

                                loadingBarTick = getTickCount()
                                loadingBarText = "Felszerelés folyamatban"
                                loadingTime = math.random(6000, 11000)
                                local sound = playSound("files/sounds/wrench.wav", true)

                                startNeon = tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].upID

                                setTimer(function() 
                                    destroyElement(sound)
                                    allowedInteraction = true
                                    loadinBarShowing = false
                                    selectedColor = 0
                                    removeEventHandler("onClientKey", root, onClientPanelKey)
                                    removeEventHandler("onClientClick", root, onClientPanelClick)
                                    removeEventHandler("onClientCharacter", root, onClientPanelCharacter)
                                    triggerServerEvent("tuning > updateVehicleTuningsTable", resourceRoot, "neon", getPedOccupiedVehicle(localPlayer), tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].upID)
                                    infobox:outputInfoBox("A neon felszerelésre került!", "success")
                                end, loadingTime, 1)
                            else
                                if priceType == 1 then 
                                    infobox:outputInfoBox("Nincs elegendő készpénzed! ("..price.."$)", "error")
                                elseif priceType == 2 then 
                                    infobox:outputInfoBox("Nincs elegendő prémium pontod! ("..price.."PP)", "error")
                                end
                            end
                        end
                    elseif tunings[selectedTuning].title == "Egyéb" then 

                        if tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].wheelScale then 
                            local wScale = tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].wheelScale
                            local type = tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].scale
                            local priceType = tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].price[1]
                            local price = tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].price[2]
                            local occupidveh = getPedOccupiedVehicle(localPlayer)
                            if getElementData(localPlayer, priceTypes[priceType]) >= price then
                                if type == "front" then 
                                    equippedTuning = getVehicleWheelSize(occupidveh, "front")
                                    triggerServerEvent("tuning:vehicleWheelWidth", localPlayer, occupidveh, "front", wScale)
                                elseif type == "rear" then 
                                    equippedTuning = getVehicleWheelSize(occupidveh, "rear")
                                    triggerServerEvent("tuning:vehicleWheelWidth", localPlayer, occupidveh, "rear", wScale)
                                end

                                triggerServerEvent("tuning > updatePlayerMoney", resourceRoot, priceTypes[priceType], price)

                                allowedInteraction = false
                                loadinBarShowing = true

                                loadingBarTick = getTickCount()
                                loadingBarText = "Beszerelés folyamatban"
                                loadingTime = math.random(5000, 11000)
                                local sound = playSound("files/sounds/wrench.wav", true)

                                setTimer(function() 
                                    destroyElement(sound)
                                    allowedInteraction = true
                                    loadinBarShowing = false
                                    
                                    infobox:outputInfoBox("A tuning beszerelésre került!", "success")
                                end, loadingTime, 1)
                            else 
                                if priceType == 1 then 
                                    infobox:outputInfoBox("Nincs elegendő készpénzed! ("..price.."$)", "error")
                                elseif priceType == 2 then 
                                    infobox:outputInfoBox("Nincs elegendő prémium pontod! ("..price.."PP)", "error")
                                end
                            end
                        elseif tunings[selectedTuning].tunings[selectedAlTuning].title == "Meghajtás" then  
                            local priceType = tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].price[1]
                            local price = tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].price[2]
                            if getElementData(localPlayer, priceTypes[priceType]) >= price then 
                                local vehHandling = getVehicleHandling(getPedOccupiedVehicle(localPlayer))

                                local tuningID = tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].tuningID
                                if not (("driveType-"..vehHandling["driveType"]) == (tuningID)) then 

                                    local vehEngineTunings = getElementData(getPedOccupiedVehicle(localPlayer), "veh:engineTunings") or {}
                                    triggerServerEvent("tuning > updatePlayerMoney", resourceRoot, priceTypes[priceType], price)

                                    allowedInteraction = false
                                    loadinBarShowing = true

                                    loadingBarTick = getTickCount()
                                    loadingBarText = "Beszerelés folyamatban"
                                    loadingTime = math.random(5000, 11000)

                                    local sound = playSound("files/sounds/wrench.wav", true)

                                    setTimer(function() 
                                        destroyElement(sound)
                                        allowedInteraction = true
                                        loadinBarShowing = false

                                        local newTable = vehEngineTunings

                                        if not (string.match(toJSON(vehEngineTunings), "driveType-")) then 
                                            table.insert(newTable, tuningID)
                                        else
                                            for k, v in pairs(vehEngineTunings) do 
                                                if string.match(v, "driveType-") then 
                                                    vehEngineTunings[k] = tuningID
                                                end
                                            end
                                        end
                                        triggerServerEvent("tuning > updateVehicleTuningsTable", resourceRoot, "engine", getPedOccupiedVehicle(localPlayer), newTable)
                                        infobox:outputInfoBox("A tuning beszerelésre került!", "success")
                                    end, loadingTime, 1)
                                else
                                    infobox:outputInfoBox("Ez a meghajtás van beszerelve jelenleg a járművedbe!", "warning")
                                end
                            else
                                if priceType == 1 then 
                                    infobox:outputInfoBox("Nincs elegendő készpénzed! ("..price.."$)", "error")
                                elseif priceType == 2 then 
                                    infobox:outputInfoBox("Nincs elegendő prémium pontod! ("..price.."PP)", "error")
                                end
                            end
                        elseif tunings[selectedTuning].tunings[selectedAlTuning].title == "Airride" then
                            local priceType = tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].price[1]
                            local price = tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].price[2]
                            if getElementData(localPlayer, priceTypes[priceType]) >= price then 
                                local tuningID = tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].upID
                                if not (getElementData(getPedOccupiedVehicle(localPlayer), "veh:tuning:airride") == tuningID) then 
                                    triggerServerEvent("tuning > updatePlayerMoney", resourceRoot, priceTypes[priceType], price)

                                    allowedInteraction = false
                                    loadinBarShowing = true

                                    loadingBarTick = getTickCount()
                                    loadingBarText = "Beszerelés folyamatban"
                                    loadingTime = math.random(5000, 11000)

                                    local sound = playSound("files/sounds/wrench.wav", true)

                                    setTimer(function() 
                                        destroyElement(sound)
                                        allowedInteraction = true
                                        loadinBarShowing = false

            
                                        triggerServerEvent("tuning > updateVehicleTuningsTable", resourceRoot, "airride", getPedOccupiedVehicle(localPlayer), tuningID)
                                        infobox:outputInfoBox("A tuning beszerelésre került!", "success")
                                    end, loadingTime, 1)
                                else
                                    infobox:outputInfoBox("Ebben a járműben jelenleg is ez az aktív elem!", "warning")
                                end
                            else
                                if priceType == 1 then 
                                    infobox:outputInfoBox("Nincs elegendő készpénzed! ("..price.."$)", "error")
                                elseif priceType == 2 then 
                                    infobox:outputInfoBox("Nincs elegendő prémium pontod! ("..price.."PP)", "error")
                                end
                            end
                        elseif tunings[selectedTuning].tunings[selectedAlTuning].title == "Variáns" then 
                            local priceType = tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].price[1]
                            local price = tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].price[2]
                            if getElementData(localPlayer, priceTypes[priceType]) >= price then 
                                local tuningID = tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].upID
                                if not (toJSON(getElementData(getPedOccupiedVehicle(localPlayer), "tuning:vehVariant") or {255, 255}) == toJSON(tuningID)) then 
                                    triggerServerEvent("tuning > updatePlayerMoney", resourceRoot, priceTypes[priceType], price)

                                    allowedInteraction = false
                                    loadinBarShowing = true

                                    loadingBarTick = getTickCount()
                                    loadingBarText = "Beszerelés folyamatban"
                                    loadingTime = math.random(5000, 11000)

                                    local sound = playSound("files/sounds/wrench.wav", true)

                                    setTimer(function() 
                                        destroyElement(sound)
                                        allowedInteraction = true
                                        loadinBarShowing = false

            
                                        triggerServerEvent("tuning > updateVehicleTuningsTable", resourceRoot, "variant", getPedOccupiedVehicle(localPlayer), tuningID)
                                        infobox:outputInfoBox("A tuning beszerelésre került!", "success")
                                        resetCamera()
                                    end, loadingTime, 1)
                                else
                                    infobox:outputInfoBox("Ebben a járműben jelenleg is ez az aktív elem!", "warning")
                                end
                            else
                                if priceType == 1 then 
                                    infobox:outputInfoBox("Nincs elegendő készpénzed! ("..price.."$)", "error")
                                elseif priceType == 2 then 
                                    infobox:outputInfoBox("Nincs elegendő prémium pontod! ("..price.."PP)", "error")
                                end
                            end
                        elseif (tunings[selectedTuning].tunings[selectedAlTuning].title == "Egyedi duda") then 
                            local priceType = tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].price[1]
                            local price = tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].price[2]
                            if getElementData(localPlayer, priceTypes[priceType]) >= price then 
                                local tuningID = tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].upID
                                local hornID = getElementData(getPedOccupiedVehicle(localPlayer), "veh:customHorn") or 0 

                                if not (tuningID == hornID) then 
                                    triggerServerEvent("tuning > updatePlayerMoney", resourceRoot, priceTypes[priceType], price)

                                    allowedInteraction = false
                                    loadinBarShowing = true

                                    loadingBarTick = getTickCount()
                                    loadingBarText = "Beszerelés folyamatban"
                                    loadingTime = math.random(2500, 7500)

                                    local sound = playSound("files/sounds/wrench.wav", true)

                                    setTimer(function() 
                                        destroyElement(sound)
                                        allowedInteraction = true
                                        loadinBarShowing = false

            
                                        triggerServerEvent("tuning > updateVehicleTuningsTable", resourceRoot, "horn", getPedOccupiedVehicle(localPlayer), tuningID)
                                        infobox:outputInfoBox("A tuning beszerelésre került!", "success")
                                        resetCamera()
                                    end, loadingTime, 1)
                                else
                                    infobox:outputInfoBox("Ebben a járműben jelenleg is ez az aktív elem!", "warning")
                                end
                            else
                                if priceType == 1 then 
                                    infobox:outputInfoBox("Nincs elegendő készpénzed! ("..price.."$)", "error")
                                elseif priceType == 2 then 
                                    infobox:outputInfoBox("Nincs elegendő prémium pontod! ("..price.."PP)", "error")
                                end
                            end
                        elseif (tunings[selectedTuning].tunings[selectedAlTuning].title == "Supercharger") then 
                            local priceType = customTunings[getElementModel(getPedOccupiedVehicle(localPlayer))][tunings[selectedTuning].tunings[selectedAlTuning].customTuningID][selectedAlAlTuning].price[1]
                            local price = customTunings[getElementModel(getPedOccupiedVehicle(localPlayer))][tunings[selectedTuning].tunings[selectedAlTuning].customTuningID][selectedAlAlTuning].price[2]
                            if getElementData(localPlayer, priceTypes[priceType]) >= price then 
                                local tuningID = customTunings[getElementModel(getPedOccupiedVehicle(localPlayer))][tunings[selectedTuning].tunings[selectedAlTuning].customTuningID][selectedAlAlTuning].upID

                                if not (tuningID == superchargerBuy) then
                                    triggerServerEvent("tuning > updatePlayerMoney", resourceRoot, priceTypes[priceType], price)

                                    allowedInteraction = false
                                    loadinBarShowing = true

                                    loadingBarTick = getTickCount()
                                    loadingBarText = "Beszerelés folyamatban"
                                    loadingTime = math.random(5000, 15000)

                                    local sound = playSound("files/sounds/wrench.wav", true)

                                    setTimer(function() 
                                        destroyElement(sound)
                                        allowedInteraction = true
                                        loadinBarShowing = false

                                        superchargerBuy = tuningID
            
                                        triggerServerEvent("tuning > updateVehicleTuningsTable", resourceRoot, "supercharger", getPedOccupiedVehicle(localPlayer), tuningID)
                                        infobox:outputInfoBox("A tuning beszerelésre került!", "success")
                                    end, loadingTime, 1)
                                else
                                    infobox:outputInfoBox("Ebben a járműben jelenleg is ez az aktív elem!", "warning")
                                end
                            else
                                if priceType == 1 then 
                                    infobox:outputInfoBox("Nincs elegendő készpénzed! ("..price.."$)", "error")
                                elseif priceType == 2 then 
                                    infobox:outputInfoBox("Nincs elegendő prémium pontod! ("..price.."PP)", "error")
                                end
                            end
                        end
                    end
                elseif key == "backspace" then 
                    local activeMenuTitle, alTitle, price, priceType, tuningID, mainTitle = getActiveMenuPoint()  
                    local needToggle = tunings[selectedTuning].tunings[selectedAlTuning].toogleNeeded or false 

                    if needToggle then 
                        setVehicleComponentVisible(getPedOccupiedVehicle(localPlayer), tunings[selectedTuning].tunings[selectedAlTuning].component, true)
                    end
                    
                    local camX, camY, camZ, camX2, camY2, camZ2 = getCameraMatrix()
                    local carX, carY, carZ = getElementPosition(getPedOccupiedVehicle(localPlayer))
                    local carX2, carY2, carZ2 = getPositionFromElementOffset(getPedOccupiedVehicle(localPlayer), 5, 5, 3)

                    smoothMoveCamera(camX, camY, camZ, camX2, camY2, camZ2, carX2, carY2, carZ2, carX, carY, carZ, 1000)
                    allowedInteraction = false 
                    setTimer(function() 
                        allowedInteraction = true
                    end, 1000, 1)

                    if tunings[selectedTuning].title == "Teljesítmény tuning" then    
                    elseif tunings[selectedTuning].title == "Optikai tuning" then 
                        if tunings[selectedTuning].tunings[selectedAlTuning].title == "Fényezés" then 
                            if activeColorInput then return end
                            if selectedColor > 0 then 
                                selectedColor = 0 
                        
                                removeEventHandler("onClientKey", root, onClientPanelKey)
                                removeEventHandler("onClientClick", root, onClientPanelClick)
                                removeEventHandler("onClientCharacter", root, onClientPanelCharacter)
                                
                                setVehicleColor(getPedOccupiedVehicle(localPlayer), vehStarterColor[1], vehStarterColor[2], vehStarterColor[3], vehStarterColor[4], vehStarterColor[5], vehStarterColor[6], vehStarterColor[7], vehStarterColor[8], vehStarterColor[9], vehStarterColor[10], vehStarterColor[11], vehStarterColor[12])
                                setVehicleHeadLightColor(getPedOccupiedVehicle(localPlayer), vehStarterColor[13], vehStarterColor[14], vehStarterColor[15])
                                return
                            else
                                selectedColor = 0
                            end
                        end

                        if not (tunings[selectedTuning].tunings[selectedAlTuning].title == "Fényezés") then 
                            if (tunings[selectedTuning].tunings[selectedAlTuning].title == "Kerekek") then 
                                removeVehicleUpgrade(getPedOccupiedVehicle(localPlayer),  tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].upID)

                                if getElementData(getPedOccupiedVehicle(localPlayer), "veh:tuningWheel") then  
                                    addVehicleUpgrade(getPedOccupiedVehicle(localPlayer),  getElementData(getPedOccupiedVehicle(localPlayer), "veh:tuningWheel"))
                                end
                            elseif (tunings[selectedTuning].tunings[selectedAlTuning].title == "Spoiler") then 
                                removeVehicleUpgrade(getPedOccupiedVehicle(localPlayer),  tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].upID)

                                if getElementData(getPedOccupiedVehicle(localPlayer), "veh:tuning:spoiler") then  
                                    addVehicleUpgrade(getPedOccupiedVehicle(localPlayer),  getElementData(getPedOccupiedVehicle(localPlayer), "veh:tuning:spoiler"))
                                end
                            elseif tunings[selectedTuning].tunings[selectedAlTuning].customTuningID == "paintjob" then
                                setElementData(getPedOccupiedVehicle(localPlayer), "veh:paintjob", startPaintjob, false)
                            elseif (tunings[selectedTuning].tunings[selectedAlTuning].title == "Neon") then
                                setElementData(getPedOccupiedVehicle(localPlayer), "veh:neon:id", startNeon, false)
                            elseif tunings[selectedTuning].tunings[selectedAlTuning].isCustomTuning then 
                                removeVehicleUpgrade(getPedOccupiedVehicle(localPlayer),  customTunings[getElementModel(getPedOccupiedVehicle(localPlayer))][tunings[selectedTuning].tunings[selectedAlTuning].customTuningID][selectedAlAlTuning].upID)

                                if getElementData(getPedOccupiedVehicle(localPlayer), "veh:tuning:"..tunings[selectedTuning].tunings[selectedAlTuning].customTuningID) then  
                                    addVehicleUpgrade(getPedOccupiedVehicle(localPlayer),  getElementData(getPedOccupiedVehicle(localPlayer), "veh:tuning:"..tunings[selectedTuning].tunings[selectedAlTuning].customTuningID))
                                end
                            end

                            local camX, camY, camZ, camX2, camY2, camZ2 = getCameraMatrix()
                            local carX, carY, carZ = getElementPosition(getPedOccupiedVehicle(localPlayer))
                            local carX2, carY2, carZ2 = getPositionFromElementOffset(getPedOccupiedVehicle(localPlayer), 5, 5, 3)

                            smoothMoveCamera(camX, camY, camZ, camX2, camY2, camZ2, carX2, carY2, carZ2, carX, carY, carZ, 1000)
                            allowedInteraction = false 
                            setTimer(function() 
                                allowedInteraction = true
                            end, 1000, 1)
                        end
                    elseif tunings[selectedTuning].title == "Egyéb" then
                        if tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].wheelScale then 
                            local wScale = tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].wheelScale
                            local type = tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].scale
                            local occupiedVeh = getPedOccupiedVehicle(localPlayer)
                            if type == "front" then 
                                local defaultWheelSize = (equippedTuning == 1 and "verynarrow") or (equippedTuning == 2 and "narrow") or (equippedTuning == 3 and "default") or (equippedTuning == 4 and "wide") or (equippedTuning == 5 and "verywide")
                                triggerServerEvent("tuning:vehicleWheelWidth", localPlayer, occupiedVeh, "front", defaultWheelSize)
                            elseif type == "rear" then 
                                local defaultWheelSize = (equippedTuning == 1 and "verynarrow") or (equippedTuning == 2 and "narrow") or (equippedTuning == 3 and "default") or (equippedTuning == 4 and "wide") or (equippedTuning == 5 and "verywide")
                                triggerServerEvent("tuning:vehicleWheelWidth", localPlayer, occupiedVeh, "rear", defaultWheelSize)
                            end
                        elseif (tunings[selectedTuning].tunings[selectedAlTuning].title == "Variáns") then 
                            local occupiedVeh = getPedOccupiedVehicle(localPlayer)

                            local boughtVariant = getElementData(occupiedVeh, "tuning:vehVariant") or {255, 255}

                            setVehicleVariant(occupiedVeh, unpack(boughtVariant))

                            local camX, camY, camZ, camX2, camY2, camZ2 = getCameraMatrix()
                            local carX, carY, carZ = getElementPosition(getPedOccupiedVehicle(localPlayer))
                            local carX2, carY2, carZ2 = getPositionFromElementOffset(getPedOccupiedVehicle(localPlayer), 5, 5, 3)
        
                            smoothMoveCamera(camX, camY, camZ, camX2, camY2, camZ2, carX2, carY2, carZ2, carX, carY, carZ, 1000)
                            allowedInteraction = false 
                            setTimer(function() 
                                allowedInteraction = true
                            end, 1000, 1)
                        elseif (tunings[selectedTuning].tunings[selectedAlTuning].title == "Supercharger") then 
                            setElementData(getPedOccupiedVehicle(localPlayer), "veh:sc", superchargerBuy)
                        end
                    end

                    page = 2
                    resetMenuAnimations()

                end
            end
        end
    end
end

function showCustomPlateTextPanel()
    customPlateTextPanel = true 

    core:createEditbox(sx*0.41, sy*0.5, sx*0.18, sy*0.035, "customplate", "Egyedi rendszám", _, true, {30, 30, 30, 200}, 0.4)
end

function toggleCustomPlateTextpanel()
    customPlateTextPanel = false
    core:deleteEditbox("customplate")
end

function resetCamera()
    local camX, camY, camZ, camX2, camY2, camZ2 = getCameraMatrix()
    local carX, carY, carZ = getElementPosition(getPedOccupiedVehicle(localPlayer))
    local carX2, carY2, carZ2 = getPositionFromElementOffset(getPedOccupiedVehicle(localPlayer), 5, 5, 3)
    setCameraMatrix(carX2, carY2, carZ2, carX, carY, carZ) 
end

--[[if getElementData(localPlayer, "playerid") == 1 then 
    addEventHandler("onClientRender", root, renderTuningPanel)
    addEventHandler("onClientKey", root, tuningKey)
end]]
--addEventHandler("onClientRender", root, renderTuningPanel)

function quitFromTuning()
    removeEventHandler("onClientRender", root, renderTuningPanel)
    triggerServerEvent("tuning > quitFromMarker", resourceRoot, startCar)
    removeEventHandler("onClientKey", root, tuningKey)
    showChat(true)
    exports.oInterface:toggleHud(false)
    setCameraTarget(localPlayer, localPlayer)
    startCar = false
    setElementData(localPlayer,"playerInTuning",false)
end
addEvent("quitWhenCrash",true)
addEventHandler("quitWhenCrash",root,quitFromTuning)



addEventHandler("onClientMarkerHit", root, function(player, mdim)
    if player == localPlayer then 
        if mdim then 
            if getElementData(source, "isTuningMarker") then 
                if not getElementData(source,"tuningMarkerInUse") then
                    local vehicle = getPedOccupiedVehicle(localPlayer)
                    if vehicle then 
                        if getPedOccupiedVehicleSeat(localPlayer) == 0 then 
                            if getVehicleType(vehicle) == "Bike" or getVehicleType(vehicle) == "Automobile" then 
                                if not getElementData(vehicle, "renteltcar") then
                                    if getElementData(vehicle, "veh:isFactionVehice") == 1 then 
                                        local faction = getElementData(vehicle, "veh:owner")
                                        if not (exports.oDashboard:isPlayerLeader(faction)) then 
                                            infobox:outputInfoBox("Mivel nem vagy a "..exports.oDashboard:getFactionName(faction).." frakció vezetője így nem tuningolhatod ezt a járművet!", "error")
                                            return 
                                        end
                                    end
                                    --print(core:getDistance(localPlayer, source))
                                    if core:getDistance(localPlayer, source) < 6 then 
                                        startCar = getPedOccupiedVehicle(player)
                                        tick = getTickCount()
                                        selectedTuning = 1
                                        page = 1
                                        resetMenuAnimations()
                                        setElementData(localPlayer,"playerInTuning",true)
                                        selectedAlTuning = 1
                                        selectedAlAlTuning = 1
                                        addEventHandler("onClientRender", root, renderTuningPanel)
                                        addEventHandler("onClientKey", root, tuningKey)
                                        triggerServerEvent("tuning > goToMarker", resourceRoot, source)
                                        showChat(false)
                                        equipTuning = 
                                        exports.oInterface:toggleHud(true)
                                    
                                        setTimer(function() 
                                            resetCamera()
                                        end, 100, 1)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

function getActiveMenuPoint()
    if page == 3 then 
        if not (tunings[selectedTuning].tunings[selectedAlTuning].isCustomTuning or false) then 
            return tunings[selectedTuning].tunings[selectedAlTuning].title, tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].title, (tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].price[2] or 0), (tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].price[1] or 0), (tunings[selectedTuning].tunings[selectedAlTuning].options[selectedAlAlTuning].tuningID or false), tunings[selectedTuning].title 
        else
            return tunings[selectedTuning].tunings[selectedAlTuning].title, customTunings[getElementModel(getPedOccupiedVehicle(localPlayer))][tunings[selectedTuning].tunings[selectedAlTuning].customTuningID][selectedAlAlTuning].title, (customTunings[getElementModel(getPedOccupiedVehicle(localPlayer))][tunings[selectedTuning].tunings[selectedAlTuning].customTuningID][selectedAlAlTuning].price[2] or 0), (customTunings[getElementModel(getPedOccupiedVehicle(localPlayer))][tunings[selectedTuning].tunings[selectedAlTuning].customTuningID][selectedAlAlTuning].price[1] or 0), (customTunings[getElementModel(getPedOccupiedVehicle(localPlayer))][tunings[selectedTuning].tunings[selectedAlTuning].customTuningID][selectedAlAlTuning].tuningID or false), tunings[selectedTuning].title 
        end
    end
end

function specialTuningIsAvailableForOccupiedVehicle(stTY)
    local veh = getPedOccupiedVehicle(localPlayer)

    if veh then 
        local model = getElementModel(veh)

        if customTunings[model] then 
            if customTunings[model][stTY] then 
                return true 
            else
                return false 
            end
        else
            return false 
        end
    end
end

--/Smooth camera/--
local sm = {}
sm.moov = 0
sm.object1,sm.object2 = nil,nil
 
function removeCamHandler()
	if(sm.moov == 1)then
		sm.moov = 0
	end
end
 
local function camRender()
	if (sm.moov == 1) then
		local x1,y1,z1 = getElementPosition(sm.object1)
		local x2,y2,z2 = getElementPosition(sm.object2)
		setCameraMatrix(x1,y1,z1,x2,y2,z2)
	else
		removeEventHandler("onClientPreRender",root,camRender)
	end
end

 
function smoothMoveCamera(x1,y1,z1,x1t,y1t,z1t,x2,y2,z2,x2t,y2t,z2t,time)
	if(sm.moov == 1)then return false end
	sm.object1 = createObject(1337,x1,y1,z1)
	sm.object2 = createObject(1337,x1t,y1t,z1t)
        setElementCollisionsEnabled (sm.object1,false) 
	setElementCollisionsEnabled (sm.object2,false) 
	setElementAlpha(sm.object1,0)
	setElementAlpha(sm.object2,0)
	setObjectScale(sm.object1,0.01)
	setObjectScale(sm.object2,0.01)
	moveObject(sm.object1,time,x2,y2,z2,0,0,0,"InOutQuad")
	moveObject(sm.object2,time,x2t,y2t,z2t,0,0,0,"InOutQuad")
	sm.moov = 1
	setTimer(removeCamHandler,time,1)
	setTimer(destroyElement,time,1,sm.object1)
	setTimer(destroyElement,time,1,sm.object2)
	addEventHandler("onClientPreRender",root,camRender)
	return true
end

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end

--=======[ Colorpicker ]=========

local activeItem = false
local hoveredInputfield = false

function reMap(value, low1, high1, low2, high2)
	return low2 + (value - low1) * (high2 - low2) / (high1 - low1)
end

local colorPanel = {
	isActive = false,
	hue = 0.5,
	saturation = 0,
	lightness = 1,
	colorInputs = {
		rgb = {
			width = dxGetTextWidth("255", 1, fonts["condensed-11"]) + 10,
			red = 255,
			green = 255,
			blue = 255
		},
		hex = {
			width = dxGetTextWidth("#FFFFFF", 1, fonts["condensed-11"]) + 10,
			hex = "#FFFFFF"
		}
	},
	selectedColor = tocolor(255, 255, 255)
}


colorPanel.width = 290/myX*sx
colorPanel.height = 280/myX*sx
colorPanel.posX = (sx - colorPanel.width) * 0.01
colorPanel.posY = sy*0.1
colorPanel.barHeight = 25/myX*sx
colorPanel.paletteWidth = colorPanel.width - 20/myX*sx
colorPanel.paletteHeight = colorPanel.height - 20/myY*sy - colorPanel.barHeight * 2
colorPanel.palettePosX = colorPanel.posX + 10/myX*sx
colorPanel.palettePosY = colorPanel.posY + 10/myX*sx
colorPanel.inputPosY = colorPanel.palettePosY + colorPanel.paletteHeight + 5/myX*sx
colorPanel.luminancePosY = colorPanel.inputPosY + colorPanel.barHeight + 5
colorPanel.luminanceHeight = 10/myX*sx

inSlot = false
function drawColorPicker()
    inSlot = false 
    dxDrawRectangle(colorPanel.palettePosX-5/myX*sx, colorPanel.palettePosY-5/myY*sy, colorPanel.paletteWidth+10/myX*sx, colorPanel.height-12/myX*sx, tocolor(40, 40, 40, 255*a))
	local cursorX, cursorY = getCursorPosition()
	dxDrawImage(colorPanel.palettePosX, colorPanel.palettePosY, colorPanel.paletteWidth, colorPanel.paletteHeight, "files/colorpalette.png", 0, 0, 0, tocolor(255, 255, 255, 255*a))
	
	if core:isInSlot(colorPanel.palettePosX, colorPanel.palettePosY, colorPanel.paletteWidth, colorPanel.paletteHeight) and getKeyState("mouse1") then
		colorPanel.hue = (cursorX*sx - colorPanel.palettePosX) / colorPanel.paletteWidth
		colorPanel.saturation = (colorPanel.paletteHeight + colorPanel.palettePosY - cursorY*sy) / colorPanel.paletteHeight

		local r, g, b = hslToRgb(colorPanel.hue, colorPanel.saturation, colorPanel.lightness)
		colorPanel.selectedColor = tocolor(r * 255, g * 255, b * 255, 255)
		
		processColorpickerUpdate(true)
	end
	
	local colorX = (colorPanel.palettePosX + (colorPanel.hue * colorPanel.paletteWidth)) - 5
	local colorY = (colorPanel.palettePosY + (1 - colorPanel.saturation) * colorPanel.paletteHeight) - 5
	local r, g, b = hslToRgb(colorPanel.hue, colorPanel.saturation, 0.5)
	
	dxDrawRectangle(colorX - 1, colorY - 1, 10 + 2, 10 + 2, tocolor(35, 35, 35, 255*a))
	dxDrawRectangle(colorX, colorY, 10, 10, tocolor(r * 255, g * 255, b * 255, 255*a))
	
	dxDrawText("RGB:", colorPanel.palettePosX, colorPanel.inputPosY, colorPanel.palettePosX + colorPanel.paletteWidth, colorPanel.inputPosY + colorPanel.barHeight, tocolor(220, 220, 220, 255*a), 1/myX*sx, fonts["condensed-11"], "left", "center")
	
	for k, v in ipairs({"red", "green", "blue"}) do
		local rowX = colorPanel.palettePosX + 45 + ((k - 1) * (colorPanel.colorInputs.rgb.width + 3))

		dxDrawRectangle(rowX, colorPanel.inputPosY, colorPanel.colorInputs.rgb.width, colorPanel.barHeight, tocolor(30, 30, 30, 220 * a))
	
		if core:isInSlot(rowX, colorPanel.inputPosY, colorPanel.colorInputs.rgb.width, colorPanel.barHeight) then
            hoveredInputfield = v
            inSlot = true 
		end
        
        if activeColorInput == v then
            dxDrawText(colorPanel.colorInputs.rgb[v], rowX, colorPanel.inputPosY, rowX + colorPanel.colorInputs.rgb.width, colorPanel.inputPosY + colorPanel.barHeight, tocolor(233, 118, 25, 255*a), 1/myX*sx, fonts["condensed-11"], "center", "center")
        else
            dxDrawText(colorPanel.colorInputs.rgb[v], rowX, colorPanel.inputPosY, rowX + colorPanel.colorInputs.rgb.width, colorPanel.inputPosY + colorPanel.barHeight, tocolor(220, 220, 220, 255*a), 1/myX*sx, fonts["condensed-11"], "center", "center")
		end
	end
	
	dxDrawText("HEX:", colorPanel.palettePosX, colorPanel.inputPosY, colorPanel.palettePosX + colorPanel.paletteWidth - colorPanel.colorInputs.hex.width - 5, colorPanel.inputPosY + colorPanel.barHeight, tocolor(220, 220, 220, 255*a), 1, fonts["condensed-11"], "right", "center")

	dxDrawRectangle(colorPanel.palettePosX + colorPanel.paletteWidth - colorPanel.colorInputs.hex.width, colorPanel.inputPosY, colorPanel.colorInputs.hex.width, colorPanel.barHeight, tocolor(30, 30, 30, 220 * a))
	
	if core:isInSlot(colorPanel.palettePosX + colorPanel.paletteWidth - colorPanel.colorInputs.hex.width, colorPanel.inputPosY, colorPanel.colorInputs.hex.width, colorPanel.barHeight) then
        hoveredInputfield = "hex"
        inSlot = true
    end

    if activeColorInput == "hex" then
        dxDrawText(colorPanel.colorInputs.hex.hex, colorPanel.palettePosX + colorPanel.paletteWidth - colorPanel.colorInputs.hex.width, colorPanel.inputPosY, colorPanel.palettePosX + colorPanel.paletteWidth, colorPanel.inputPosY + colorPanel.barHeight, tocolor(233, 118, 25, 255*a), 1, fonts["condensed-11"], "center", "center")
    else
        dxDrawText(colorPanel.colorInputs.hex.hex, colorPanel.palettePosX + colorPanel.paletteWidth - colorPanel.colorInputs.hex.width, colorPanel.inputPosY, colorPanel.palettePosX + colorPanel.paletteWidth, colorPanel.inputPosY + colorPanel.barHeight, tocolor(220, 220, 220, 255*a), 1, fonts["condensed-11"], "center", "center")
    end
	
	dxDrawRectangle(colorPanel.palettePosX - 1, colorPanel.luminancePosY - 1, colorPanel.paletteWidth + 2, colorPanel.luminanceHeight + 2, tocolor(220, 220, 220, 255*a))
	
	for i = 0, colorPanel.paletteWidth do
		local r, g, b = hslToRgb(colorPanel.hue, colorPanel.saturation, i / colorPanel.paletteWidth)
		
		dxDrawRectangle(colorPanel.palettePosX + i, colorPanel.luminancePosY, 1, colorPanel.luminanceHeight, tocolor(r * 255, g * 255, b * 255, 255*a))
	end
	
	dxDrawRectangle(colorPanel.palettePosX + reMap(colorPanel.lightness, 0, 1, 0, colorPanel.paletteWidth), colorPanel.luminancePosY - 5, 5, colorPanel.luminanceHeight + 10, tocolor(220, 220, 220, 255*a))
	
	if core:isInSlot(colorPanel.palettePosX - 5, colorPanel.luminancePosY - 5, colorPanel.paletteWidth + 10, colorPanel.luminanceHeight + 10) and getKeyState("mouse1")  then
		colorPanel.lightness = reMap(cursorX*sx - colorPanel.palettePosX, 0, colorPanel.paletteWidth, 0, 1)
		processColorpickerUpdate(true)
    end
    
    if not inSlot then 
        hoveredInputfield = false 
    end
end

function onClientPanelClick(button, state, _, _, worldX, worldY, worldZ)
	if button == "left" and state == "down" then
        activeColorInput = false
		if hoveredInputfield then
			activeColorInput = hoveredInputfield
		else
			activeColorInput = false
		end
	end
end


function onClientPanelKey(key, press)
	if not press then
		return
	end
	if key == "backspace" then
		cancelEvent()
		
		if activeColorInput then 
			if activeColorInput == "hex" then
				if utf8.len(colorPanel.colorInputs.hex[activeColorInput]) > 1 then
					colorPanel.colorInputs.hex[activeColorInput] = utf8.sub(colorPanel.colorInputs.hex[activeColorInput], 1, utf8.len(colorPanel.colorInputs.hex[activeColorInput]) - 1)

					updateVehicleColor()
					vehicleColor = {colorPanel.colorInputs.rgb.red, colorPanel.colorInputs.rgb.green, colorPanel.colorInputs.rgb.blue}
				end
			else
				if utf8.len(colorPanel.colorInputs.rgb[activeColorInput]) > 0 then
					colorPanel.colorInputs.rgb[activeColorInput] = tonumber(utf8.sub(colorPanel.colorInputs.rgb[activeColorInput], 1, utf8.len(colorPanel.colorInputs.rgb[activeColorInput]) - 1)) or 0
					
					colorPanel.hue, colorPanel.saturation, colorPanel.lightness = rgbToHsl(colorPanel.colorInputs.rgb.red / 255, colorPanel.colorInputs.rgb.green / 255, colorPanel.colorInputs.rgb.blue / 255)
					colorPanel.colorInputs.hex.hex = rgbToHex(colorPanel.colorInputs.rgb.red, colorPanel.colorInputs.rgb.green, colorPanel.colorInputs.rgb.blue)
					colorPanel.selectedColor = tocolor(colorPanel.colorInputs.rgb.red, colorPanel.colorInputs.rgb.green, colorPanel.colorInputs.rgb.blue)

					updateVehicleColor()
					vehicleColor = {colorPanel.colorInputs.rgb.red, colorPanel.colorInputs.rgb.green, colorPanel.colorInputs.rgb.blue}
					
					if activeItem then
						activeItem.color = colorPanel.selectedColor
					end
				end
			end
		end
	end
end

function updateVehicleColor()
    local newColors = {
        [1] = {vehStarterColor[1], vehStarterColor[2], vehStarterColor[3]},
        [2] = {vehStarterColor[4], vehStarterColor[5], vehStarterColor[6]},
        [3] = {vehStarterColor[7], vehStarterColor[8], vehStarterColor[9]},
        [4] = {vehStarterColor[10], vehStarterColor[11], vehStarterColor[12]},
        [5] = {getVehicleHeadLightColor(getPedOccupiedVehicle(localPlayer))},
    }

    newColors[selectedColor] = {colorPanel.colorInputs.rgb.red, colorPanel.colorInputs.rgb.green, colorPanel.colorInputs.rgb.blue}

    if selectedColor == 5 then 
        local occupiedveh = getPedOccupiedVehicle(localPlayer)
        setVehicleHeadLightColor(occupiedveh, newColors[5][1], newColors[5][2], newColors[5][3])
        setVehicleOverrideLights(occupiedveh, 2)
    else
        setVehicleColor(getPedOccupiedVehicle(localPlayer), newColors[1][1], newColors[1][2], newColors[1][3], newColors[2][1], newColors[2][2], newColors[2][3], newColors[3][1], newColors[3][2], newColors[3][3], newColors[4][1], newColors[4][2], newColors[4][3])
    end
end

function onClientPanelCharacter(character)
	character = utf8.upper(character)
	
	if activeColorInput == "hex" then
		if utf8.len(colorPanel.colorInputs.hex[activeColorInput]) < 7 and utf8.find("0123456789ABCDEF", character) then
			colorPanel.colorInputs.hex[activeColorInput] = colorPanel.colorInputs.hex[activeColorInput] .. character
		end
		
		if utf8.len(colorPanel.colorInputs.hex[activeColorInput]) >= 7 then
			local r, g, b = fixRGB(hexToRgb(colorPanel.colorInputs.hex[activeColorInput]))
			
			colorPanel.hue, colorPanel.saturation, colorPanel.lightness = rgbToHsl(r / 255, g / 255, b / 255)
			colorPanel.colorInputs.rgb.red = r
			colorPanel.colorInputs.rgb.green = g
			colorPanel.colorInputs.rgb.blue = b
			colorPanel.selectedColor = tocolor(r, g, b)

			updateVehicleColor()

			vehicleColor = {colorPanel.colorInputs.rgb.red, colorPanel.colorInputs.rgb.green, colorPanel.colorInputs.rgb.blue}
			
			if activeItem then
				activeItem.color = colorPanel.selectedColor
			end
		end
	else
		if tonumber(character) then
			if utf8.len(colorPanel.colorInputs.rgb[activeColorInput]) < 3 then
				colorPanel.colorInputs.rgb[activeColorInput] = tonumber(colorPanel.colorInputs.rgb[activeColorInput] .. character)
			end
			
			colorPanel.hue, colorPanel.saturation, colorPanel.lightness = rgbToHsl(colorPanel.colorInputs.rgb.red / 255, colorPanel.colorInputs.rgb.green / 255, colorPanel.colorInputs.rgb.blue / 255)
			colorPanel.colorInputs.hex.hex = rgbToHex(colorPanel.colorInputs.rgb.red, colorPanel.colorInputs.rgb.green, colorPanel.colorInputs.rgb.blue)
			colorPanel.selectedColor = tocolor(colorPanel.colorInputs.rgb.red, colorPanel.colorInputs.rgb.green, colorPanel.colorInputs.rgb.blue)

			updateVehicleColor()

			vehicleColor = {colorPanel.colorInputs.rgb.red, colorPanel.colorInputs.rgb.green, colorPanel.colorInputs.rgb.blue}
			
			if activeItem then
				activeItem.color = colorPanel.selectedColor
			end
		end
	end
end

function processColorpickerUpdate(selecting)
	if selecting then
		local r, g, b = hslToRgb(colorPanel.hue, colorPanel.saturation, colorPanel.lightness)
		r, g, b = fixRGB(r * 255, g * 255, b * 255)
		
		colorPanel.colorInputs.rgb.red = r
		colorPanel.colorInputs.rgb.green = g
		colorPanel.colorInputs.rgb.blue = b
		colorPanel.colorInputs.hex.hex = rgbToHex(r, g, b)
		colorPanel.selectedColor = tocolor(r, g, b)
		
		if activeItem then
			activeItem.color = colorPanel.selectedColor
		end
		updateVehicleColor()

		vehicleColor = {colorPanel.colorInputs.rgb.red, colorPanel.colorInputs.rgb.green, colorPanel.colorInputs.rgb.blue}
	else
		local r, g, b, a = fixRGB(getColorFromDecimal(colorPanel.selectedColor))
		
		colorPanel.hue, colorPanel.saturation, colorPanel.lightness = rgbToHsl(r / 255, g / 255, b / 255)
		colorPanel.colorInputs.rgb.red = r
		colorPanel.colorInputs.rgb.green = g
		colorPanel.colorInputs.rgb.blue = b
		colorPanel.colorInputs.hex.hex = rgbToHex(r, g, b)

		updateVehicleColor()

		vehicleColor = {colorPanel.colorInputs.rgb.red, colorPanel.colorInputs.rgb.green, colorPanel.colorInputs.rgb.blue}
	end
end

function fixRGB(r, g, b, a)
	r = math.max(0, math.min(255, math.floor(r)))
	g = math.max(0, math.min(255, math.floor(g)))
	b = math.max(0, math.min(255, math.floor(b)))
	a = a and math.max(0, math.min(255, math.floor(a))) or 255
	
	return r, g, b, a
end

function hexToRgb(code)
	code = string.gsub(code, "#", "")
	return tonumber("0x" .. string.sub(code, 1, 2)), tonumber("0x" .. string.sub(code, 3, 4)), tonumber("0x" .. string.sub(code, 5, 6))
end

function rgbToHex(r, g, b, a)
	if (r < 0 or r > 255 or g < 0 or g > 255 or b < 0 or b > 255) or (a and (a < 0 or a > 255)) then
		return nil
	end
	
	if a then
		return string.format("#%.2X%.2X%.2X%.2X", r, g, b, a)
	else
		return string.format("#%.2X%.2X%.2X", r, g, b)
	end
end

function hslToRgb(h, s, l)
	local lightnessValue
	
	if l < 0.5 then
		lightnessValue = l * (s + 1)
	else
		lightnessValue = (l + s) - (l * s)
	end
	
	local lightnessValue2 = l * 2 - lightnessValue
	local r = hueToRgb(lightnessValue2, lightnessValue, h + 1 / 3)
	local g = hueToRgb(lightnessValue2, lightnessValue, h)
	local b = hueToRgb(lightnessValue2, lightnessValue, h - 1 / 3)
	
	return r, g, b
end

function hueToRgb(l, l2, h)
	if h < 0 then
		h = h + 1
	elseif h > 1 then
		h = h - 1
	end

	if h * 6 < 1 then
		return l + (l2 - l) * h * 6
	elseif h * 2 < 1 then
		return l2
	elseif h * 3 < 2 then
		return l + (l2 - l) * (2 / 3 - h) * 6
	else
		return l
	end
end

function rgbToHsl(r, g, b)
	local maxValue = math.max(r, g, b)
	local minValue = math.min(r, g, b)
	local h, s, l = 0, 0, (minValue + maxValue) / 2

	if maxValue == minValue then
		h, s = 0, 0
	else
		local different = maxValue - minValue

		if l < 0.5 then
			s = different / (maxValue + minValue)
		else
			s = different / (2 - maxValue - minValue)
		end

		if maxValue == r then
			h = (g - b) / different
			
			if g < b then
				h = h + 6
			end
		elseif maxValue == g then
			h = (b - r) / different + 2
		else
			h = (r - g) / different + 4
		end

		h = h / 6
	end

	return h, s, l
end

function getColorFromDecimal(decimal)
	local red = bitExtract(decimal, 16, 8)
	local green = bitExtract(decimal, 8, 8)
	local blue = bitExtract(decimal, 0, 8)
	local alpha = bitExtract(decimal, 24, 8)
	
	return red, green, blue, alpha
end

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

function getVehicleWheelSize(vehicle, side)
	if vehicle and side then
		local flags = getVehicleHandling(vehicle)["handlingFlags"]

		for name, flag in pairs(availableWheelSizes[side]) do
			if isFlagSet(flags, flag[1]) then
				return flag[2]
			end
		end

		return 3
	end
end

function isFlagSet(val, flag)
	return (bitAnd(val, flag) == flag)
end