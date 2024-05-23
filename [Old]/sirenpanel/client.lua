--- A scriptet készitette Anthony
local sx, sy = guiGetScreenSize()
local x,y = guiGetScreenSize()
local screenWidth,screenHeight = guiGetScreenSize() 
local kepernyom = {guiGetScreenSize()}
local panelSize = {500, 500} 
local minipanelSize = {500, 300}
local panelPos = {sx*0.39,sy*0.7} 

local panelVisible = false
local moveing = false
local startX, startY = 0,0

local sirenAllowedVehicles = {
    [598] = true,
}

function drawSirenapanel()
    if moveing then 
        if isCursorShowing() then
            local cx,cy = getCursorPosition(  )
            cx,cy = cx*sx,cy*sy 

            panelPos[1] = cx - startX / 10
            panelPos[2] = cy - startY / 10
        end
    end
    dxDrawImage(panelPos[1], panelPos[2], sx*0.22,sy*0.195, "xxa.png")
end 

addEventHandler("onClientVehicleEnter", getRootElement(), 
    function(player,seat)
        if player == getLocalPlayer() then 
            if sirenAllowedVehicles[getElementModel(source)] then
                if seat == 0 or seat == 1 then
                    addEventHandler("onClientRender",root,drawSirenapanel)
                    panelVisible = true
                end
            end
        end
    end
)

addEventHandler("onClientVehicleExit", getRootElement(), 
    function(player,seat)
        if player == getLocalPlayer() then 
            if sirenAllowedVehicles[getElementModel(source)] then
                if seat == 0 or seat == 1 then
                    removeEventHandler("onClientRender",root,drawSirenapanel)
                    panelVisible = false
                end
            end
        end
    end
)




function isCursorOnBox(xS,yS,wS,hS)
	if(isCursorShowing()) then
		XY = {guiGetScreenSize()}
		local cursorX, cursorY = getCursorPosition()
		cursorX, cursorY = cursorX*XY[1], cursorY*XY[2]
		if(cursorX >= xS and cursorX <= xS+wS and cursorY >= yS and cursorY <= yS+hS) then
			return true
		else
			return false
		end
	end	
end


function panelClick(button, state, cx, cy)
    if (panelVisible) then 

        if button == "left" then 
            --[[if isInBox(panelPos[1], panelPos[2], sx*0.22,sy*0.195) then 
                if state == "down" then
                    moveing = true
                    local cx,cy = getCursorPosition(  )
                    cx,cy = cx*sx,cy*sy
                    startX, startY = cx,cy
                elseif state == "up" then 
                    moveing = false 
                    startX, startY = 0,0
                end
            end]]

            if state == "up" then 
                if isInBox(panelPos[1]+sx*0.02,panelPos[2]+sy*0.05,sx*0.04,sy*0.05) then 
                    triggerServerEvent("siren", root, vehicle, not getVehicleSirensOn(vehicle))
                elseif  isInBox(panelPos[1]+sx*0.09,panelPos[2]+sy*0.05,sx*0.04,sy*0.05) then 
                    triggerServerEvent("play3DSound", root, getPedOccupiedVehicle(localPlayer),"sirenhorn")
                elseif  isInBox(panelPos[1]+sx*0.16,panelPos[2]+sy*0.05,sx*0.04,sy*0.05) then 
                    triggerServerEvent("play3DSound", root, getPedOccupiedVehicle(localPlayer),"siren4")
                else 
                    return 
                end 
                exports.cl_chat:sendLocalMeAction("megnyomott egy gombot a sziréna vezérlő paneljén." )
            end
        end
    end 
                
end 
addEventHandler("onClientClick", getRootElement(), panelClick)


function isInBox(x, y, w, h)
    if isCursorShowing( ) then
        local cx,cy = getCursorPosition(  )
        cx, cy = cx*sx, cy*sy
        if cx>=x and cx<=x+w and cy>=y and cy<=y+h then
            return true
        end
        return false
    else
        return false
    end
end

addEvent("playSoundOnClient",true)
addEventHandler("playSoundOnClient", root,
    function(vehicle,sound_name,state)
        outputChatBox("client:"..sound_name)
        if state == "on" then 
            local sound = false
            if sound_name == "sirenhorn" then
                sound = playSound3D("sound/"..sound_name..".mp3", 0,0,0)
            else
                sound = playSound3D("sound/"..sound_name..".mp3", 0,0,0,true)
            end
            setSoundVolume(sound,8)
            setSoundMaxDistance(sound,40)
            attachElements(sound,vehicle)
            setElementData(vehicle,"pd:siren:sound:"..sound_name,sound)
        else   
            stopSound(getElementData(vehicle,"pd:siren:sound:"..sound_name))

        end
	end 
)