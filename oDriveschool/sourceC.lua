-- 80$ elméleti vizsga
-- 150$ városi
local sx,sy = guiGetScreenSize()
local screenX,screenY = guiGetScreenSize()
local panelW, panelH = 480, 300
local panelX, panelY = screenX/2 - panelW/2, screenY/2 - panelH/2
local showPanel = false

local cache = {}
cache.bebasneue = exports["oFont"]:getFont("bebasneue",20);
cache.condensed = exports["oFont"]:getFont("condensed",12);
cache.condensed2 = exports["oFont"]:getFont("condensed",14);
cache.fontawesome2 = exports["oFont"]:getFont("fontawesome2",25);

cache.serverName = exports["oCore"]:getServerName();
cache.serverhex = exports["oCore"]:getServerColor();

local h,r,g,b = exports["oCore"]:getServerColor();
local y = screenY*0.05


local panelId = 1
local page = "quest"
local selectedButtonId = 0
local correctPoint = 0
local questCount = 1
local animType = "open"

cache.question = questCount

addEventHandler("onClientResourceStart", root, function(res)
	if getResourceName(res) == "oCore" or getResourceName(res) == "oInfobox" or getResourceName(res) == "oJob" then  
        core = exports.oCore
        color = core:getServerColor()
        info = exports.oInfobox
        font = exports.oFont
	end
end)

local theoryExam = 500
local trafficExam = 1000
local renewLicenses = 600
local isRenew = false

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), function()
    ped = createPed(187, 1488.8396728516, 1305.4716796875, 1093.9163867188-1,271.72338867188)
    setElementFrozen(ped, true)
    setElementData(ped,"ped:name","Carlos Johanson");
    setElementData(ped,"ped:prefix","Autósiskola");
    setElementInterior(ped,3);
    setElementDimension(ped,72);
end)


function click ( button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement )
    if (button == "right") and (state == "down") then 
        if clickedElement == ped then 
            if not showPanel then 
                --if not exports.oInventory:hasItem(66) then 
                    --if getElementData(localPlayer,"char:money") >= theoryExam then 
                        page = "selector"
                        showPanel = true
                        animType = "open"
                        addEventHandler("onClientRender",getRootElement(),drivingPanel)
                        addEventHandler("onClientKey", getRootElement(), onKey)
                        start = getTickCount()
                        panelId = 1
                        correctPoint = 0
                        questCount = 1
                        selectedButtonId = 0
                        cache.question = 1
                        
                        
                    --else 
                     --   outputChatBox(core:getServerPrefix("red-dark", 2) .." Nincs elég pénzed ("..theoryExam.." $)",255,255,255,true)
                   -- end
               -- else 
                 --   outputChatBox(core:getServerPrefix("red-dark", 2) .." Neked már van jogosítványod!",255,255,255,true)
                --end
            end
        end
    end
    if button == "left" and state == "down" and showPanel then 
        if page == "selector" then 
            local startY = panelY + 25
            if isInSlot(panelX+5, startY, panelW-10, 45) then 
                if not exports.oLicenses:playerHasValidLicense(66) and not getElementData(localPlayer, "isExam") then
                    if getElementData(localPlayer,"char:money") >= theoryExam then
                        page = "menu"
                    else 
                        outputChatBox(core:getServerPrefix("red-dark", 2) .." Nincs elég pénzed ("..theoryExam.." $)",255,255,255,true)
                    end
                end
            end
            startY = startY + 48
            if isInSlot(panelX+5, startY, panelW-10, 45) then 
                if getElementData(localPlayer, "isExam") then 
                    if getElementData(localPlayer,"char:money") >= trafficExam then 
                        triggerServerEvent("createLicenseVeh", localPlayer)
                        animType = "close"
                        start = getTickCount()
                
                        setTimer(function()
                            removeEventHandler("onClientRender",getRootElement(), drivingPanel)
                            removeEventHandler("onClientKey",getRootElement(), onKey)
                            showPanel = false
                        end, 300, 1)
                    else 
                        outputChatBox(core:getServerPrefix("red-dark", 2) .." Nincs elég pénzed ("..trafficExam.." $)",255,255,255,true)
                    end
                end
            end            
            startY = startY + 48
            if isInSlot(panelX+5, startY, panelW-10, 45) then 
                if exports.oInventory:hasItem(66) and not exports.oLicenses:playerHasValidLicense(66) then  
                    if getElementData(localPlayer,"char:money") >= renewLicenses then 
                        isRenew = true
                        exports["oInventory"]:takeItem(66)
                        triggerServerEvent("createLicenseVeh", localPlayer)
                        animType = "close"
                        start = getTickCount()
                
                        setTimer(function()
                            removeEventHandler("onClientRender",getRootElement(), drivingPanel)
                            removeEventHandler("onClientKey",getRootElement(), onKey)
                            showPanel = false
                        end, 300, 1)
                    else 
                        outputChatBox(core:getServerPrefix("red-dark", 2) .." Nincs elég pénzed ("..renewLicenses.." $)",255,255,255,true)
                    end
                end
            end
        elseif page == "menu" then
            if exports["oCore"]:isInSlot(panelX + panelW/2 - 65, panelY+panelH-40, 120, 30) then -- nextPage
                if panelId == #learn then
                    page = "quest"
                    takeMoneyDriveschool(localPlayer,theoryExam)
                else 
                    if panelId < #learn then
                        panelId = panelId + 1
                    end
                end
            end
        elseif page == "quest" then 
            if exports["oCore"]:isInSlot(panelX+10, panelY+120, panelW - 20, 30) then
                selectedButtonId = 1
            end            
            if exports["oCore"]:isInSlot(panelX+10, panelY+120+35, panelW - 20, 30) then
                selectedButtonId = 2
            end            
            if exports["oCore"]:isInSlot(panelX+10, panelY+120+35+35, panelW - 20, 30) then
                selectedButtonId = 3
            end            
            
            if exports["oCore"]:isInSlot(panelX+10, panelY+120+35+35+35+35, panelW - 20, 30) then
                if question[cache.question][5] == selectedButtonId then 
                    correctPoint = correctPoint + 1
                end
                if selectedButtonId > 0 then
                    selectedButtonId = 0
                    questCount = questCount + 1
                    generateQuestions()
                    if questCount > #question then 
                        if (math.floor(100/(#question)*correctPoint)) >= 85 then 
                            --questCount = 1
                            outputChatBox(core:getServerPrefix("red-dark", 2) .." Sikeres elméleti vizsga! (" ..(math.floor(100/(#question)*correctPoint)) .."%)",255,255,255,true)
                        --    triggerServerEvent("createLicenseVeh", localPlayer)
                            --removeEventHandler("onClientRender",getRootElement(), drivingPanel)
                            --showPanel = false
                            page = "selector"
                            resetPanel()
                            setElementData(localPlayer, "isExam", true)
                        else
                            --questCount = 1
                            outputChatBox(core:getServerPrefix("red-dark", 2) .." Sajnos nem sikerült! (min. 85 %)",255,255,255,true)
                            --removeEventHandler("onClientRender",getRootElement(), drivingPanel)
                            --showPanel = false
                            page = "selector"
                            resetPanel()
                        end
                    end
                else
                    outputChatBox(core:getServerPrefix("red-dark", 2) .." Válasz nélkül nem tudsz tovább menni!",255,255,255,true)
                end
            end
        end
    end
end
addEventHandler("onClientClick", getRootElement(), click)

function resetPanel()
    panelId = 1
    correctPoint = 0
    questCount = 1
    selectedButtonId = 0
    cache.question = 1
end

function onKey(button, state)
    if button == "backspace" and state then 
        animType = "close"
        start = getTickCount()

        setTimer(function()
            removeEventHandler("onClientRender",getRootElement(), drivingPanel)
            removeEventHandler("onClientKey",getRootElement(), onKey)
            showPanel = false
        end, 300, 1)
    end
end

start = getTickCount()
function drivingPanel()
    --if getElementData(localPlayer,"char:name") == "Dexter_Power" then
        local now = getTickCount()
        local endTime = start + 250
        local elapsedTime = now - start
        local duration = endTime - start 
        local progress = elapsedTime/duration * 2
        if animType == "open" then
            alpha = interpolateBetween(0,0,0,1,0,0,progress,"OutQuad");
        else 
            alpha = interpolateBetween(1,0,0,0,0,0,progress,"OutQuad");
        end
        if page == "menu" then
            exports["oCore"]:drawWindow(panelX, panelY, panelW, panelH, "OriginalRoleplay - "..cache.serverhex.."Autósiskola", alpha)
        elseif page == "selector" then 
            exports["oCore"]:drawWindow(panelX, panelY, panelW, 172, "OriginalRoleplay - "..cache.serverhex.."Autósiskola", alpha)
        else 
            --(math.floor(100/(#question)*correctPoint))
            exports["oCore"]:drawWindow(panelX, panelY, panelW, panelH, "OriginalRoleplay - "..cache.serverhex.."Autósiskola ("..(math.floor(100/(#question)*correctPoint)).. "%)", alpha)
        end
        if page == "selector" then
            local startY = panelY + 25
            if not exports.oLicenses:playerHasValidLicense(66) and not getElementData(localPlayer, "isExam") then
                if isInSlot(panelX+5, startY, panelW-10, 45) then 
                    dxDrawRectangle(panelX+5, startY, panelW-10, 45, tocolor(r,g,b,150*alpha))
                else 
                    dxDrawRectangle(panelX+5, startY, panelW-10, 45, tocolor(30,30,30,255*alpha))
                end
                dxDrawText("", panelX+10, startY, 0, 45 + startY, tocolor(255,255,255,255*alpha),0.85,cache.fontawesome2, "left", "center")
                dxDrawText("Elméleti oktatás", panelX+20+dxGetTextWidth("", 0.85, cache.fontawesome2), startY+5, 0, 0, tocolor(255,255,255,255*alpha),0.85,cache.condensed, "left", "top")
                dxDrawText("500$", panelX+20+dxGetTextWidth("", 0.85, cache.fontawesome2), startY+25, 0, 0, tocolor(255,255,255,255*alpha),0.85,cache.condensed, "left", "top")
                dxDrawText("Oktató: Carlos Johanson", panelX+20+dxGetTextWidth("", 0.85, cache.fontawesome2), startY, panelW-10+panelX, 45 + startY, tocolor(255,255,255,255*alpha),0.85,cache.condensed, "right", "center")
            else 
                --dxDrawRectangle(panelX+5, startY, panelW-10, 45, tocolor(10,10,10,200*alpha))
                dxDrawImage(panelX+5, startY, panelW-10, 45, ":oMinigames/files/gradient.png", 180, 0, 0,tocolor(166,51,51,50*alpha))
                dxDrawText("", panelX+10, startY, 0, 45 + startY, tocolor(255,255,255,255*alpha),0.85,cache.fontawesome2, "left", "center")
                dxDrawText("Elméleti oktatás", panelX+20+dxGetTextWidth("", 0.85, cache.fontawesome2), startY+5, 0, 0, tocolor(255,255,255,255*alpha),0.85,cache.condensed, "left", "top")
                dxDrawText("500$", panelX+20+dxGetTextWidth("", 0.85, cache.fontawesome2), startY+25, 0, 0, tocolor(255,255,255,255*alpha),0.85,cache.condensed, "left", "top")
                --dxDrawText("Oktató: Carlos Johanson", panelX+20+dxGetTextWidth("", 0.85, cache.fontawesome2), startY, panelW-10+panelX, 45 + panelY + 25, tocolor(255,255,255,255*alpha),0.85,cache.condensed, "right", "center")
                if getElementData(localPlayer, "isExam") then
                    dxDrawText("Már le tetted az elméleti vizsgát!", panelX+20+dxGetTextWidth("", 0.85, cache.fontawesome2), startY, panelW-10+panelX, 45 + startY, tocolor(166, 51, 55, 255*alpha),0.85,cache.condensed, "right", "center")
                else 
                    dxDrawText("Már van jogosítványod!", panelX+20+dxGetTextWidth("", 0.85, cache.fontawesome2), startY, panelW-10+panelX, 45 + startY, tocolor(166, 51, 55, 255*alpha),0.85,cache.condensed, "right", "center")
                end
            end
            startY = startY + 48
            if getElementData(localPlayer, "isExam") then 
                if isInSlot(panelX+5, startY, panelW-10, 45) then 
                    dxDrawRectangle(panelX+5, startY, panelW-10, 45, tocolor(r,g,b,150*alpha))
                else 
                    dxDrawRectangle(panelX+5, startY, panelW-10, 45, tocolor(30,30,30,255*alpha))
                end
                --dxDrawRectangle(panelX+5, startY, panelW-10, 45, tocolor(40,40,40,255*alpha))
                dxDrawText("", panelX+10, startY, 0, 45 + startY, tocolor(255,255,255,255*alpha),0.85,cache.fontawesome2, "left", "center")
                dxDrawText("Gyakorlati oktatás", panelX+20+dxGetTextWidth("", 0.85, cache.fontawesome2), startY+5, 0, 0, tocolor(255,255,255,255*alpha),0.85,cache.condensed, "left", "top")
                dxDrawText("1000$", panelX+20+dxGetTextWidth("", 0.85, cache.fontawesome2), startY+25, 0, 0, tocolor(255,255,255,255*alpha),0.85,cache.condensed, "left", "top")
                dxDrawText("Oktató: Carlos Johanson", panelX+20+dxGetTextWidth("", 0.85, cache.fontawesome2), startY, panelW-10+panelX, 45 + startY, tocolor(255,255,255,255*alpha),0.85,cache.condensed, "right", "center")
            else
                dxDrawImage(panelX+5, startY, panelW-10, 45, ":oMinigames/files/gradient.png", 180, 0, 0,tocolor(166,51,51,50*alpha))
                --dxDrawRectangle(panelX+5, startY, panelW-10, 45, tocolor(10,10,10,255*alpha))
                dxDrawText("", panelX+10, startY, 0, 45 + startY, tocolor(255,255,255,255*alpha),0.85,cache.fontawesome2, "left", "center")
                dxDrawText("Gyakorlati oktatás", panelX+20+dxGetTextWidth("", 0.85, cache.fontawesome2), startY+5, 0, 0, tocolor(255,255,255,255*alpha),0.85,cache.condensed, "left", "top")
                dxDrawText("1000$", panelX+20+dxGetTextWidth("", 0.85, cache.fontawesome2), startY+25, 0, 0, tocolor(255,255,255,255*alpha),0.85,cache.condensed, "left", "top")
                dxDrawText("Nem elérhető!", panelX+20+dxGetTextWidth("", 0.85, cache.fontawesome2), startY, panelW-10+panelX, 45 + startY, tocolor(166, 51, 55,255*alpha),0.85,cache.condensed, "right", "center")
            end            
            startY = startY + 48
            if exports.oInventory:hasItem(66) and not exports.oLicenses:playerHasValidLicense(66) then 
                if isInSlot(panelX+5, startY, panelW-10, 45) then 
                    dxDrawRectangle(panelX+5, startY, panelW-10, 45, tocolor(r,g,b,150*alpha))
                else 
                    dxDrawRectangle(panelX+5, startY, panelW-10, 45, tocolor(30,30,30,255*alpha))
                end
                --dxDrawRectangle(panelX+5, startY, panelW-10, 45, tocolor(40,40,40,255*alpha))
                dxDrawText("", panelX+10, startY, 0, 45 + startY, tocolor(255,255,255,255*alpha),0.85,cache.fontawesome2, "left", "center")
                dxDrawText("Jogosítvány megújítása", panelX+25+dxGetTextWidth("", 0.85, cache.fontawesome2), startY+5, 0, 0, tocolor(255,255,255,255*alpha),0.85,cache.condensed, "left", "top")
                dxDrawText("600$", panelX+25+dxGetTextWidth("", 0.85, cache.fontawesome2), startY+25, 0, 0, tocolor(255,255,255,255*alpha),0.85,cache.condensed, "left", "top")
                dxDrawText("Ügyintéző: Jack Rodrigez", panelX+25+dxGetTextWidth("", 0.85, cache.fontawesome2), startY, panelW-10+panelX, 45 + startY, tocolor(255,255,255,255*alpha),0.85,cache.condensed, "right", "center")
            else
                dxDrawImage(panelX+5, startY, panelW-10, 45, ":oMinigames/files/gradient.png", 180, 0, 0,tocolor(166,51,51,50*alpha))
                --dxDrawRectangle(panelX+5, startY, panelW-10, 45, tocolor(10,10,10,255*alpha))
                dxDrawText("", panelX+10, startY, 0, 45 + startY, tocolor(255,255,255,255*alpha),0.85,cache.fontawesome2, "left", "center")
                dxDrawText("Jogosítvány megújítása", panelX+25+dxGetTextWidth("", 0.85, cache.fontawesome2), startY+5, 0, 0, tocolor(255,255,255,255*alpha),0.85,cache.condensed, "left", "top")
                dxDrawText("600$", panelX+25+dxGetTextWidth("", 0.85, cache.fontawesome2), startY+25, 0, 0, tocolor(255,255,255,255*alpha),0.85,cache.condensed, "left", "top")
                dxDrawText("Nem elérhető!", panelX+25+dxGetTextWidth("", 0.85, cache.fontawesome2), startY, panelW-10+panelX, 45 + startY, tocolor(166, 51, 55,255*alpha),0.85,cache.condensed, "right", "center")
            end
        elseif page == "menu" then 
            dxDrawText(cache.serverhex .."Elméleti Vizsga", panelX, panelY, panelX + panelW, panelY+80, tocolor(255,255,255,255*alpha),0.85, cache.condensed2, "center", "center", false, false, false, true)
            dxDrawText(learn[panelId][1], panelX, panelY+150, panelX + panelW, panelH+panelY-200, tocolor(255,255,255,255*alpha),0.75, cache.condensed, "center", "center", false, true)
            if panelId == #learn then
                exports["oCore"]:dxDrawButton(panelX + panelW/2 - 65, panelY+panelH-40, 120, 30, r, g, b, 255*alpha, "Kezdés", tocolor(255,255,255,255*alpha), 0.85, cache.condensed, true, tocolor(0,0,0,255*alpha)) 
            else
                exports["oCore"]:dxDrawButton(panelX + panelW/2 - 65, panelY+panelH-40, 120, 30, r, g, b, 255*alpha, "Következő", tocolor(255,255,255,255*alpha), 0.85, cache.condensed, true, tocolor(0,0,0,255*alpha))
            end
        elseif page == "quest" then 
            dxDrawText(question[cache.question][1],panelX,panelY+(50),panelX+panelW,panelY+(50),tocolor(255,255,255,255*alpha),0.85,cache.condensed,"center","center", false,false,false, true)

            if selectedButtonId == 1 then 
                exports["oCore"]:dxDrawButton(panelX+10, panelY+120, panelW - 20, 30, r, g, b, 255, question[cache.question][2], tocolor(255,255,255,255), 0.8, cache.condensed, true, tocolor(0,0,0,255)) 
            else
                exports["oCore"]:dxDrawButton(panelX+10, panelY+120, panelW - 20, 30, r, g, b, 100, question[cache.question][2] , tocolor(255,255,255,255), 0.8, cache.condensed, true, tocolor(0,0,0,255)) 
            end

            if selectedButtonId == 2 then 
                exports["oCore"]:dxDrawButton(panelX+10, panelY+120+35, panelW - 20, 30, r, g, b, 255, question[cache.question][3], tocolor(255,255,255,255), 0.8, cache.condensed, true, tocolor(0,0,0,255)) 
            else
                exports["oCore"]:dxDrawButton(panelX+10, panelY+120+35, panelW - 20, 30, r, g, b, 100, question[cache.question][3], tocolor(255,255,255,255), 0.8, cache.condensed, true, tocolor(0,0,0,255)) 
            end
            if selectedButtonId == 3 then 
                exports["oCore"]:dxDrawButton(panelX+10, panelY+120+35+35, panelW - 20, 30, r, g, b, 255, question[cache.question][4], tocolor(255,255,255,255), 0.8, cache.condensed, true, tocolor(0,0,0,255)) 
            else
                exports["oCore"]:dxDrawButton(panelX+10, panelY+120+35+35, panelW - 20, 30, r, g, b, 100, question[cache.question][4], tocolor(255,255,255,255), 0.8, cache.condensed, true, tocolor(0,0,0,255)) 

            end

            exports["oCore"]:dxDrawButton(panelX+10, panelY+120+35+35+35+35, panelW - 20, 30, r, g, b, 150, "Következő", tocolor(255,255,255,255), 0.85, cache.condensed, true, tocolor(0,0,0,255)) 
        end
    --end
end

function isInSlot(xS,yS,wS,hS)
	if(isCursorShowing()) then
		XY = {guiGetScreenSize()}
		local cursorX, cursorY = getCursorPosition()
		cursorX, cursorY = cursorX*XY[1], cursorY*XY[2]
		if(isInBox(xS,yS,wS,hS, cursorX, cursorY)) then
			return true
		else
			return false
		end
	end	
end

function isInBox(dX, dY, dSZ, dM, eX, eY)
	if(eX >= dX and eX <= dX+dSZ and eY >= dY and eY <= dY+dM) then
		return true
	else
		return false
	end
end

---------------------

function generateQuestions()
    cache.question = questCount
end


function testQuestionAlreadyUsed()
    for k, v in pairs(question) do
        if v[6] then 
            return true
        else
            return false
        end
    end
end
------------------------------

local cpValue = 1
local trafficMarker = false 
local trafficBlip = false 
local trafficWarning = 0
local speedMessageTimer = false
local maxTrafficSpeed = 70
local randTextTimer = false

function getElementSpeed( element, unit )
    if isElement( element ) then
        local x,y,z = getElementVelocity( element )
        if unit == "mph" or unit == 1 or unit == "1" then
            return ( x ^ 2 + y ^ 2 + z ^ 2 ) ^ 0.5 * 100
        else
            return ( x ^ 2 + y ^ 2 + z ^ 2 ) ^ 0.5 * 1.8 * 100
        end
    else
        outputDebugString( "Not an element. Can't get speed" )
        return false
    end
end

addEvent("createTrafficLine",true)
addEventHandler("createTrafficLine",getRootElement(), function()
    trafficWarning = 0
    cpValue = 1
    trafficMarker = createMarker(licenseTraffic[cpValue][1],licenseTraffic[cpValue][2],licenseTraffic[cpValue][3], "checkpoint", 2.5, 255, 87, 87)
    addEventHandler("onClientMarkerHit",getRootElement(),trafficMarkerHandler)
    setElementData(trafficMarker,"marker.trafficMarker",true)
    setElementData(trafficMarker,"marker.trafficMarker.type",licenseTraffic[cpValue][4])
    trafficBlip = createBlip(licenseTraffic[cpValue][1],licenseTraffic[cpValue][2],licenseTraffic[cpValue][3], 4)
    setElementData(trafficBlip, "blip:name", "Forgalmi vizsga")
    
    outputChatBox("Carlos Johanson mondja: Indulás előtt kösse be az övét! ((Öv bekötése: F5))",255,255,255,true)

    trafficSpeedTimer = setTimer(function()
        if isTimer(speedMessageTimer) then return end
		local veh = getPedOccupiedVehicle(localPlayer)
        if not veh then return end
        local speed = getElementSpeed(veh)
        if (speed > maxTrafficSpeed) then
			speedMessageTimer = setTimer(function() end, 2000, 1)
			trafficWarning = trafficWarning + 1
            outputChatBox("Carlos Johanson mondja: "..randSpeed[math.random(1,#randSpeed)][1],255,255,255,true)
            outputChatBox(core:getServerPrefix("red-dark", 2) .." Figyelmeztetést kaptál gyorshajtásért! #d23131("..trafficWarning..")",255,255,255,true)
        end
        if not getElementData(localPlayer, "vehicle:seatbeltState") then 
            speedMessageTimer = setTimer(function() end, 2000, 1)
			trafficWarning = trafficWarning + 1
            outputChatBox("Carlos Johanson mondja: "..randBelt[math.random(1,#randBelt)][1],255,255,255,true)
            outputChatBox(core:getServerPrefix("red-dark", 2) .." Figyelmeztetést kaptál nem volt becsatolva az öved! #d23131("..trafficWarning..")",255,255,255,true)
        end
    end,5000,0)
    outputChatBox("Carlos Johanson mondja: "..randVoice[math.random(1,#randVoice)][1],255,255,255,true)
    randTextTimer = setTimer(function()
        outputChatBox("Carlos Johanson mondja: "..randVoice[math.random(1,#randVoice)][1],255,255,255,true)
    end,30*1000,0)
end)



function trafficMarkerHandler(hitPlayer, matchDim)
    local marker = source
    if (hitPlayer == localPlayer) and matchDim then
        local mLicense = getElementData(marker,"marker.trafficMarker")
        if (mLicense) then
            local mType = getElementData(marker,"marker.trafficMarker.type")
            if (mType == "next") then
                if isElement(trafficMarker) then
					destroyElement(trafficMarker)
					destroyElement(trafficBlip)
					trafficMarker = nil
					trafficBlip = nil
				end
                cpValue = cpValue + 1
                trafficMarker = createMarker(licenseTraffic[cpValue][1],licenseTraffic[cpValue][2],licenseTraffic[cpValue][3], "checkpoint", 2.5, 255, 87, 87)
                setElementData(trafficMarker,"marker.trafficMarker",true)
                setElementData(trafficMarker,"marker.trafficMarker.type",licenseTraffic[cpValue][4])
                trafficBlip = createBlip(licenseTraffic[cpValue][1],licenseTraffic[cpValue][2],licenseTraffic[cpValue][3], 4)
                setElementData(trafficBlip, "blip:name", "Forgalmi vizsga")
                if cpValue == 13 then 
                    outputChatBox("Carlos Johanson mondja: És egy STOP tábla megállunk!",255,255,255,true)
                elseif cpValue == 23 then 
                    outputChatBox("Carlos Johanson mondja: Rendben végeztünk, menjünk vissza a telephelyre!",255,255,255,true)
                end
            elseif (mType == "end") then
                if isTimer(trafficSpeedTimer) then
                    killTimer(trafficSpeedTimer)
                    killTimer(randTextTimer)
                end
                if isElement(trafficMarker) then
                    destroyElement(trafficBlip)
                    destroyElement(trafficMarker)
                    trafficMarker = nil
                    trafficBlip = nil
                end
                removeEventHandler("onClientMarkerHit",getRootElement(),trafficMarkerHandler)
                if isRenew then 
                    takeMoneyDriveschool(localPlayer,theoryExam)
                else
                    takeMoneyDriveschool(localPlayer,theoryExam)
                end
                triggerServerEvent("vehDestroyer", localPlayer,localPlayer)
                
                local vehHealth = getElementHealth(getPedOccupiedVehicle(localPlayer))
                if (trafficWarning >= 5) then
                    outputChatBox(core:getServerPrefix("red-dark", 2) .." A vizsgád sikertelen lett, túl sokszor lettél figyelmeztetve! (Hiba pont: ".. trafficWarning ..")",255,255,255,true)
                else 
                    if not(vehHealth >= 900) then
                        outputChatBox(core:getServerPrefix("red-dark", 2) .." A kocsi túlságosan összetört, ezért megbuktál a vizsgán.",255,255,255,true)
                    else
                        setElementData(localPlayer, "isExam", false)
                        isRenew = false
                        outputChatBox(core:getServerPrefix("red-dark", 2) .." Sikeresen teljesítetted a vizsgát, így meg kapod a jutalmadat.",255,255,255,true)
                        triggerServerEvent("addLicense", localPlayer, localPlayer)
                    end
				end
            end
        end
    end
end


function takeMoneyDriveschool(element,money)
    if getElementData(element,"char:money") >= money then 
        setElementData(element,"char:money",getElementData(element,"char:money") - money)
    end
end 

------------------------------

local vehDestroyTimer = false
addEventHandler("onClientVehicleExit", root, function(player)
    if player == localPlayer then 
        if getElementData(source, "isLicenseCar") then 
            if getElementData(source, "licenseCar:owner") == localPlayer then 
                info:outputInfoBox("Ha nem szállsz vissza a járműbe "..getElementData(source, "licenseCar:destroyTime").." percen belül, akkor a járműved törlésre kerül!", "warning")
                outputChatBox(core:getServerPrefix("red-dark", 2).."Ha nem szállsz vissza a járműbe "..core:getServerColor()..getElementData(source, "licenseCar:destroyTime").." #ffffffpercen belül, akkor a járműved törlésre kerül!", 255, 255, 255, true)
                vehDestroyTimer = setTimer(function()
                    triggerServerEvent("vehDestroyer", localPlayer, localPlayer)
                end, core:minToMilisec(getElementData(source, "licenseCar:destroyTime")), 1)
            end
        end
    end
end)

addEventHandler("onClientVehicleEnter", root, function(player)
    if player == localPlayer then 
        if getElementData(source, "isLicenseCar") then 
            if getElementData(source, "licenseCar:owner") == localPlayer then 
                if isTimer(vehDestroyTimer) then 
                    killTimer(vehDestroyTimer)
                    info:outputInfoBox("Mivel időben visszaszálltál a járműbe, így az nem kerül törlésre!", "success")
                    outputChatBox(core:getServerPrefix("green-dark", 2).."Mivel időben visszaszálltál a járműbe, így az nem kerül törlésre!", 255, 255, 255, true)
                end
            end
        end
    end
end)
