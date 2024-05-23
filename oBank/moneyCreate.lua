local markerposx, markerposy, markerposz = 2558.4353027344, -1296.7315673828, 1044.125

local openingMarker = createMarker(markerposx, markerposy, markerposz-2, "cylinder", 2.0, 245, 66, 66, 100)
setElementInterior(openingMarker, 2)
setElementDimension(openingMarker, 838)

addEventHandler("onClientRender", root, function()
    dxDrawCircle3D(markerposx, markerposy,markerposz, 1, tocolor(245, 66, 66, 30), 1, 50)
    dxDrawCircle3D(markerposx, markerposy,markerposz+0.05, 1, tocolor(245, 66, 66, 40), 1, 50)
    dxDrawCircle3D(markerposx, markerposy,markerposz+0.1, 1, tocolor(245, 66, 66, 50), 1, 50)
end)

local isOpenInProgress = false
function startMoneyCaseOpen()
    if isOpenInProgress then return false end 

    local px, py, pz = getElementPosition(localPlayer)

    if getDistanceBetweenPoints3D(px, py, pz, markerposx, markerposy, markerposz) < 1 then
        if getElementDimension(localPlayer) == getElementDimension(openingMarker) then  
            if exports.oInventory:hasItem(163) then
                triggerServerEvent("bank > caseOpen > start", resourceRoot)
                chat:sendLocalMeAction("elkezdtett kinyitni egy pénzkazettát.")
                setElementFrozen(localPlayer, true)
                exports.oMinigames:createMinigame(3, _, 0.05, "bank > moneyCase > success", "bank > moneyCase > unSuccess")
                isOpenInProgress = true 
                return true
            else
                outputChatBox(core:getServerPrefix("red-dark", "Pénzkazetta", 2).."A pénzkazetta kinyitásához szükséged van egy fúróra!", 255, 255, 255, true)
                return false
            end
        end
    else
        outputChatBox(core:getServerPrefix("red-dark", "Pénzkazetta", 2).."Ezen a helyen nem nyithatod ki a pénzkazettát!", 255, 255, 255, true)
        return false
    end
end

addEvent("bank > moneyCase > success", true)
addEventHandler("bank > moneyCase > success", root, function()
    infobox:outputInfoBox("Sikeresen kinyitottad a pénzkazettát!", "success")

    local money = math.random(5000, 25000)
    outputChatBox(core:getServerPrefix("server", "Pénzkazetta", 2).."A pénzkazetta tartalma #76de7d"..money.."$ #ffffffvolt.", 255, 255, 255, true)

    chat:sendLocalDoAction("sikeresen kinyitotta a pénzkazettát, amely "..money.."$-t tartalmazott.")
    setElementFrozen(localPlayer, false)

    triggerServerEvent("bank > caseOpen > end", resourceRoot, money)
    isOpenInProgress = false
end)

addEvent("bank > moneyCase > unSuccess", true)
addEventHandler("bank > moneyCase > unSuccess", root, function()
    chat:sendLocalDoAction("nem sikerült kinyitnia a pénzkazettát.")
    infobox:outputInfoBox("Nem sikerült kinyitotnod a pénzkazettát, ezért felrobbant a biztonsági patron és festékes lett az arcod!", "warning")
    setElementFrozen(localPlayer, false)
    triggerServerEvent("bank > caseOpen > end", resourceRoot)
    setElementData(localPlayer, "atmRob:painting", 120)
    isOpenInProgress = false
end)

local paintingTimer = nil 
function startPaintingTimer()
    if isTimer(paintingTimer) then 
        killTimer(paintingTimer) 
    end

    paintingTimer = setTimer(function()
        local timeRemain = getElementData(localPlayer, "atmRob:painting")

        if timeRemain <= 0 then 
            if isTimer(paintingTimer) then 
                killTimer(paintingTimer) 
                setElementData(localPlayer, "atmRob:painting", 0)
            end
        else
            setElementData(localPlayer, "atmRob:painting", timeRemain - 1)
        end
    end, core:minToMilisec(1), 0)
end

if (getElementData(localPlayer,  "atmRob:painting") or 0) > 0 then 
    startPaintingTimer()
end 

local moneyCasetBlipTimer = nil
addEventHandler("onClientElementDataChange", getRootElement(), function(data, new, old)
    if source == localPlayer then
        if data == "atmRob:painting" then 
            if (old == false) then 
                startPaintingTimer()
            end
        elseif data == "user:loggedin" then 
            if (getElementData(source,  "atmRob:painting") or 0) > 0 then 
                startPaintingTimer()
            end
        elseif data == "atmRob:hasMoneyCaset" then 
            if new == true then 
                if isTimer(moneyCasetBlipTimer) then 
                    killTimer(moneyCasetBlipTimer)
                end

                moneyCasetBlipTimer = setTimer(function()
                    setElementData(source, "atmRob:hasMoneyCaset", false)
                end, core:minToMilisec(10), 1)
            end
        end
    end
end)

if getElementData(localPlayer, "atmRob:hasMoneyCaset") then 
    if isTimer(moneyCasetBlipTimer) then 
        killTimer(moneyCasetBlipTimer)
    end

    moneyCasetBlipTimer = setTimer(function()
        setElementData(localPlayer, "atmRob:hasMoneyCaset", false)
    end, core:minToMilisec(10), 1)
end


function dxDrawCircle3D( x, y, z, radius, color, width, segments )
    local playerX,playerY,playerZ = getElementPosition(localPlayer)
    if getDistanceBetweenPoints3D(playerX,playerY,playerZ,x, y, z) <= 50 then
        segments = segments or 16;
        color = color or tocolor( 248, 126, 136, 200 );  
        width = width or 1; 
        local segAngle = 360 / segments; 
        local fX, fY, tX, tY;  
        local alpha = 20
        for i = 1, segments do 
            fX = x + math.cos( math.rad( segAngle * i ) ) * radius; 
            fY = y + math.sin( math.rad( segAngle * i ) ) * radius; 
            tX = x + math.cos( math.rad( segAngle * (i+1) ) ) * radius;  
            tY = y + math.sin( math.rad( segAngle * (i+1) ) ) * radius; 
            dxDrawLine3D( fX, fY, z, tX, tY, z, color, width);
        end
    end    
end