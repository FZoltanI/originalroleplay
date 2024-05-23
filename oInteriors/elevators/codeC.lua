local showIcons = true
local marker = nil
local displayWidth, displayHeight = guiGetScreenSize();

local notificationData = {};

local notificationFont = exports.oFont:getFont("condensed", 12) 

sx, sy = guiGetScreenSize();
defaultXx, defaultYx = sx/2 - 426/2, (sy/2 - 280/2) * 2;

intTexture = dxCreateTexture("files/icons/lift.png")

function renderElevatorPanel()
	if not elevatorTick then
        elevatorTick = getTickCount();
    end

    if elevatorAnimation == 'inComing' then
        alpha = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount() - elevatorTick) / 200, "Linear");
    else
        alpha = interpolateBetween(1, 0, 0, 0, 0, 0, (getTickCount() - elevatorTick) / 200, "Linear");
    end
    dxDrawRectangle(sx*0.4, sy*0.8, sx*0.2, sy*0.06, tocolor(40, 40, 40, 255*alpha))
    
    dxDrawText(text, sx*0.4, sy*0.8, sx*0.4+sx*0.2, sy*0.8+sy*0.04, tocolor(255,255,255, 255*alpha), 0.85, notificationFont, "center", 'center', true, false, false, true)
    dxDrawText("Belépéshez használd az "..color.."[E] #ffffffgombot.", sx*0.4, sy*0.835, sx*0.4+sx*0.2, sy*0.835+sy*0.015, tocolor(255, 255, 255, 255*alpha), 0.7, notificationFont, "center", "center", false, false, false, true)
end

function bindKeyElevatorFunctions()
	if isElement(marker) then
		local theElement = getElementData(marker, "other")
		if theElement then
			if not isPedInVehicle(localPlayer) then
				local intID = getElementData(marker,"dbid")
				local x,y,z = getElementData(theElement,"x"),getElementData(theElement,"y"),getElementData(theElement,"z")
				local intInt = getElementInterior(theElement)
                local intDim = getElementDimension(theElement)
                
				triggerServerEvent("changeElevator",localPlayer,localPlayer,x,y,z,intInt,intDim)
				if isElement(enterSound) then
					destroyElement(enterSound)
				end
				enterSound = playSound("files/sounds/tp.wav")
			else
				outputChatBox("#008080[Elevator]:#ffffff Ez nem egy garázs.",61,122,188,true)
			end
		end
	end
end

function clientMarkerHit(thePlayer, matchingDimension)
	cancelEvent()
	if thePlayer == localPlayer then
		if getElementDimension(source) == getElementDimension(thePlayer) then
            if getElementData(source,"isElevatorIn") == true or getElementData(source,"isElevatorOut") == true then
                
                if core:getDistance(localPlayer, source) <= 2 then
                    marker = nil
                    bindKey("e", "up", bindKeyElevatorFunctions)
                    setElementData(thePlayer, "isInElevatorMarker",true)
                    setElementData(thePlayer, "elevator:Marker", source)
                    
                    local sound = playSound("files/sounds/menter.wav")
                        setSoundVolume(sound, 1)
                        
                    marker = source
                    text = "Lift "..color.."["..tonumber(getElementData(marker,"dbid")).."]" 
                    removeEventHandler("onClientRender", getRootElement(), renderElevatorPanel)
                    addEventHandler("onClientRender", getRootElement(), renderElevatorPanel)
                    elevatorTick = nil;
                    elevatorAnimation = 'inComing';

                    if isTimer(hidetime) then
                        killTimer(hidetime)
                    end
                end
			end
		end
	end
end
addEventHandler("onClientMarkerHit", resourceRoot, clientMarkerHit)

local count = 0
local interiors = {}

addEventHandler("onClientElementStreamOut", root,
    function()
        if getElementType(source) == "marker" and getElementData(source, "dbid") then
            if getElementData(source, "isElevatorIn") or getElementData(source, "isElevatorOut") then
                --outputChatBox("TÖRLÉS")
                interiors[source] = nil
                local cont = 0
                for k,v in pairs(interiors) do
                    count = count + 1
                    break
                end
                if count <= 0 then
                    if state then
                        --removeEventHandler("onClientRender", root, renderIcons)
                        state = false
                    end
                end
            end    
        end
    end
)

addEventHandler("onClientElementStreamIn", root,
    function()
        if getElementType(source) == "marker" and getElementData(source, "dbid") and getElementDimension(localPlayer) == getElementDimension(source) then
            if getElementData(source, "isElevatorIn") or getElementData(source, "isElevatorOut") then
                --outputChatBox("HOZZÁADÁS!")
                local pX,pY,pZ = getElementPosition(localPlayer)
                local x,y,z = getElementPosition(source)
                local cont = 0
                for k,v in pairs(interiors) do
                    count = count + 1
                    break
                end
                interiors[source] = {
                    ["position"] = getElementPosition(source),
                    ["markType"] = getElementData(source,"inttype"),
                    ["markOwner"] = getElementData(source,"owner"),
                    ["distance"] = getDistanceBetweenPoints3D(pX,pY,pZ,x,y,z),
                    --["line"] = isLineOfSightClear(pX,pY,pZ,x,y,z,true,false,false,true,false,false,false),
                }
                if count >= 1 then
                    if not state then
                        --addEventHandler("onClientRender", root, renderIcons, true, "low")
                        state = true
                    end
                end
            end
        end
    end
)

addEventHandler("onClientElementDataChange", root,
    function(dName, oValue)
        if dName == "owner" and getElementType(source) == "marker" and isElementStreamedIn(source) then
            if getElementType(source) == "marker" and getElementData(source, "dbid") and getElementDimension(localPlayer) == getElementDimension(source) then
                if getElementData(source, "isElevatorIn") or getElementData(source, "isElevatorOut") then 
                    --outputChatBox("HOZZÁADÁS!")
                    local pX,pY,pZ = getElementPosition(localPlayer)
                    local x,y,z = getElementPosition(source)
                    local cont = 0
                    for k,v in pairs(interiors) do
                        count = count + 1
                        break
                    end
                    interiors[source] = {
                        ["position"] = getElementPosition(source),
                        ["markType"] = getElementData(source,"inttype"), 
                        ["markOwner"] = getElementData(source,"owner"),
                        ["distance"] = getDistanceBetweenPoints3D(pX,pY,pZ,x,y,z),
                        --["line"] = isLineOfSightClear(pX,pY,pZ,x,y,z,true,false,false,true,false,false,false),
                    }
                    if count >= 1 then
                        if not state then
                            --addEventHandler("onClientRender", root, renderIcons, true, "low")
                            state = true
                        end
                    end
                end
            end 
        end
    end
)

addEventHandler("onClientResourceStart",resourceRoot,function()
	for k,v in ipairs(getElementsByType("marker")) do
		if getElementType(v) == "marker" and getElementData(v, "dbid") and getElementDimension(localPlayer) == getElementDimension(v) then
            if getElementData(v, "isElevatorIn") or getElementData(v, "isElevatorOut") then
                --outputChatBox("HOZZÁADÁS!")
                local pX,pY,pZ = getElementPosition(localPlayer)
                local x,y,z = getElementPosition(v)
                local cont = 0
                for k,v in pairs(interiors) do
                    count = count + 1
                    break
                end
                interiors[v] = {
                    ["position"] = getElementPosition(v),
                    ["markType"] = getElementData(v,"inttype"),
                    ["markOwner"] = getElementData(v,"owner"),
                    ["distance"] = getDistanceBetweenPoints3D(pX,pY,pZ,x,y,z),
                    --["line"] = isLineOfSightClear(pX,pY,pZ,x,y,z,true,false,false,true,false,false,false),
                }
                if count >= 1 then
                    if not state then
                        --addEventHandler("onClientRender", root, renderIcons, true, "low")
                        state = true
                    end
                end
            end
        end
	end
end)

local renderCache = {}

setTimer(
    function()
        
        local pX,pY,pZ = getElementPosition(localPlayer)
        
        renderCache = {}
        for v, k in pairs(interiors) do
            if isElementStreamedIn(v) and not renderCache[v] then
                local markX,markY,markZ = getElementPosition(v)
                local markType = k["markType"]
                local markOwner = k["markOwner"]
                local x, y = getScreenFromWorldPosition(markX, markY, markZ+1)
                local distance = getDistanceBetweenPoints3D(markX, markY, markZ, pX, pY, pZ)
                k["distance"] = distance
                --local line = true
                if distance <= 40 then
                    local line = isLineOfSightClear(markX, markY, markZ+1, pX, pY, pZ, true, true, false, true, false, false, false, localPlayer)
                    if line then
                        renderCache[v] = k
                    end
                end
            end
        end
    end, 50, 0
)

addEventHandler("onClientRender",getRootElement(),function()
		local pX,pY,pZ = getElementPosition(localPlayer)
        
        if minus then
            if progress <= 60 then
                progress = progress+0.5
                if progress == 60.5 then
                    minus = false
                    plus = true
                end
            end
        end

        if plus then
            if progress >= 0 then
                progress = progress-0.5
                if progress == -0.5 then
                    plus = false1
                    minus = true
                end
            end
        end 
        
        local playerDimension = getElementDimension(localPlayer) 
        local playerInterior = getElementInterior(localPlayer)
        local a = 0
		for v, k in pairs(renderCache) do 
            if not isElement(v) then renderCache[v] = nil else
                local markX,markY,markZ = getElementPosition(v)
                local scale, zplus = interpolateBetween(0.4, 1.2, 0, 0.55, 1.7, 0, (getTickCount() - tick) / 5000, "CosineCurve")

                local x, y = getScreenFromWorldPosition(markX, markY, markZ+zplus)
                if (x) and (y) then
                    local markerDimension = getElementDimension(v)
                    local distance = core:getDistance(v, localPlayer)


                    local size = interpolateBetween(40,0,0, 40 - distance/1.4,0,0, distance, "Linear")

                    local markerInterior = getElementInterior(v)
                    if playerDimension == markerDimension and playerInterior == markerInterior then
                        dxDrawImage(x-size/2,y-size/2,size,size,textures["elevator"],0,0,10, tocolor(0, 128, 128,200),true)
                    end
                end
            end
		end
end)

addEventHandler("onClientMarkerLeave", resourceRoot, function(thePlayer, matchingDimension)
	if thePlayer == localPlayer then
		if getElementData(source,"isElevatorIn") or getElementData(source,"isElevatorOut") then
			marker = nil
			unbindKey("e", "up", bindKeyElevatorFunctions)
			setElementData(thePlayer, "isInElevatorMarker",false) 
			setElementData(thePlayer, "elevator:Marker", nil)
            elevatorTick = nil;
            elevatorAnimation = ''

            hidetime = setTimer(function()
                removeEventHandler("onClientRender", getRootElement(), renderElevatorPanel)
            end, 1200, 1)
		end
	end
end)

addEventHandler("onClientElementDestroy", root,
    function()
        if getElementType(source) == "marker" and getElementData(source, "dbid") and getElementDimension(localPlayer) == getElementDimension(source) then
            interiors[source] = nil
            if marker == source then
                marker = nil
				unbindKey("e", "up", bindKeyElevatorFunctions)
				setElementData(localPlayer, "isInElevatorMarker",false)
				setElementData(localPlayer, "elevator:Marker", nil)
				for k, v in pairs(notificationData) do
					v.State = 'fixTile';
					v.Tick = getTickCount();
					v.State = 'closeTile';
				end
            end
        end
    end
)

function dxDrawBorder(x, y, w, h, radius, color)
	dxDrawRectangle(x - radius, y, radius, h, color)
	dxDrawRectangle(x + w, y, radius, h, color)
	dxDrawRectangle(x - radius, y - radius, w + (radius * 2), radius, color)
	dxDrawRectangle(x - radius, y + h, w + (radius * 2), radius, color)
end

addEvent("ghostOn", true)
addEventHandler("ghostOn", root,
    function()
        if source == localPlayer then
            local veh = getPedOccupiedVehicle(localPlayer) or localPlayer
            for index,vehicle in ipairs(getElementsByType( "vehicle" )) do
                setElementCollidableWith(vehicle, veh, false)
                setElementData(veh, "ghostMode", false)
                setElementData(veh, "ghostMode", true)
            end
        end
    end
)

addEvent("ghostOff", true)
addEventHandler("ghostOff", root,
    function()
        if source == localPlayer then
            local veh = getPedOccupiedVehicle(localPlayer) or localPlayer
            for index,vehicle in ipairs(getElementsByType( "vehicle" )) do
                setElementCollidableWith(vehicle, veh, true)
                setElementData(veh, "ghostMode", true)
                setElementData(veh, "ghostMode", false)
            end
        end
    end
)

addEventHandler("onClientElementDataChange", root,
    function(dName, oValue)
        if dName == "ghostMode" and getElementType(source) == "vehicle" then
            local veh = getPedOccupiedVehicle(localPlayer)
            if veh then
                setElementCollidableWith(source, veh, not getElementData(source, dName))
            end
        elseif dName == "ghostMode" and getElementType(source) == "player" then
            setElementCollidableWith(source, localPlayer, not getElementData(source, dName))
        end
    end
)

addEvent("ghostPlayerOn", true)
addEventHandler("ghostPlayerOn", root,
    function()
        if source == localPlayer then
            for index,vehicle in ipairs(getElementsByType( "player" )) do
                setElementCollidableWith(vehicle, localPlayer, false)
                setElementData(localPlayer, "ghostMode", false)
                setElementData(localPlayer, "ghostMode", true)
            end
        end
    end
)

addEvent("ghostPlayerOff", true)
addEventHandler("ghostPlayerOff", root,
    function()
        if source == localPlayer then
            for index,vehicle in ipairs(getElementsByType( "player" )) do
                setElementCollidableWith(vehicle, localPlayer, true)
                setElementData(localPlayer, "ghostMode", true)
                setElementData(localPlayer, "ghostMode", false)
            end
        end
    end
)

--admin:addAdminCMD("addelevator", 5, "Lift létrehozása")
--admin:addAdminCMD("delelevator", 5, "Lift törlése")