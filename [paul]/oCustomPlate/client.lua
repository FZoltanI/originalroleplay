local ped = createPed(187, 1504.6188964844, -1774.9859619141, 14.427187919617, 180)
setElementFrozen(ped, true)
setElementData(ped, "ped:name", "Paul Griffiths")
setElementData(ped, "ped:prefix", "Egyedi rendszám")

local sx, sy = guiGetScreenSize()
local myX, myY = 1768, 992

local panelAlpha = 1
local infotext = ""
local editboxtext = false

local setVeh;
local vehID;
local choose;

local panel = false
local vehCount = 0
local maxshow = 6 
local scrolvalue = 0
local buypanel = false

local myVehs = {}       

function renderPanel()

    if not buypanel then 
        dxDrawRectangle(sx*0.4, sy*0.3, sx*0.2, sy*0.4, tocolor(35, 35, 35, 200 * panelAlpha))
        dxDrawRectangle(sx*0.4 + 2/myX*sx, sy*0.3 + 2/myY*sy, sx*0.2 - 4/myX*sx, sy*0.4 - 4/myY*sy, tocolor(35, 35, 35, 255 * panelAlpha))

        dxDrawRectangle(sx*0.4 + 4/myX*sx, sy*0.33 + 4/myY*sy, sx*0.2 - 8/myX*sx, sy*0.29, tocolor(30, 30, 30, 220 * panelAlpha))


        dxDrawText("Saját járművek", sx*0.4 + 4/myX*sx, sy*0.33 + 4/myY*sy, sx*0.4 + 4/myX*sx + sx*0.2 - 8/myX*sx, sy*0.3 + sy*0.01, tocolor(255, 255, 255, 255 * panelAlpha), 1, font:getFont("bebasneue", 15/myX*sx), "center", "center")
        dxDrawText("( "..vehCount.." )", sx*0.57 + 4/myX*sx, sy*0.33 + 4/myY*sy, sx*0.4 + 4/myX*sx + sx*0.2 - 8/myX*sx, sy*0.3 + sy*0.01, tocolor(r, g, b, 255 * panelAlpha), 1, font:getFont("bebasneue", 15/myX*sx), "center", "center")

--        local lineHeight = math.min(maxshow / vehCount, 1) 

 --       dxDrawRectangle(sx*0.6, sy*0.301, sx*0.0015, sy*0.398, tocolor(r, g, b, 75* panelAlpha))
 --        dxDrawRectangle(sx*0.6, sy*0.301 + (sy*0.378 * (lineHeight * scrolvalue / maxshow)), sx*0.0015, sy*0.398 * lineHeight, tocolor(r, g, b, 200* panelAlpha)) -- pointer helyére a scroll jelenlegi pozíciója
        -- a két 9-es helyére pedig a renderelt sorok száma

        local veh = 0
        for k,v in pairs(getElementsByType("vehicle")) do 
            if getElementData(v,"veh:owner") == getElementData(localPlayer,"char:id") then 
                veh = veh + 1
                if veh <= maxshow and (veh > scrolvalue) then 

                    if veh == choose then 
                        dxDrawRectangle(sx*0.596,sy*0.337+ sy*0.048 *(veh - scrolvalue - 1),sx*0.002,sy*0.045, tocolor(r,g,b, 255 * panelAlpha),true)
                        dxDrawRectangle(sx*0.4025,sy*0.337+ sy*0.048 *(veh - scrolvalue - 1),sx*0.195,sy*0.045, tocolor(r,g,b, 150 * panelAlpha))
                    end 

                    dxDrawRectangle(sx*0.4025,sy*0.337+ sy*0.048 *(veh - scrolvalue - 1),sx*0.195,sy*0.045, tocolor(40, 40, 40, 220 * panelAlpha))

                    dxDrawText(exports["oVehicle"]:getModdedVehicleName(v), sx*0.405,sy*0.35+ sy*0.048 *(veh - scrolvalue - 1),_,_,tocolor(255,255,255, 255 * panelAlpha), 1, font:getFont("condensed", 12/myX*sx), "left", "center")
                    dxDrawText(getElementData(v,"veh:id"),sx*0.405,sy*0.373+ sy*0.048 *(veh - scrolvalue - 1),_,_,tocolor(r,g,b, 255 * panelAlpha), 1, font:getFont("condensed", 12/myX*sx), "left", "center")
                    dxDrawText(getVehiclePlateText(v),sx*0.595,sy*0.35+ sy*0.048 *(veh - scrolvalue - 1),_,_, tocolor(r,g,b, 255 * panelAlpha), 1, font:getFont("condensed", 12/myX*sx), "right", "center")
                end 
            end 
        end     

        core:dxDrawButton(sx*0.4 + 4/myX*sx, sy*0.66, sx*0.2 - 8/myX*sx, sy*0.035, r, g, b, 220 * panelAlpha, "Rendszám módosítása", tocolor(255, 255, 255, 255 * panelAlpha), 1, font:getFont("condensed", 11/myX*sx), false, tocolor(0, 0, 0, 100 * panelAlpha))
        dxDrawText(infotext, sx*0.4 + 6/myX*sx, sy*0.6 + 4/myY*sy, sx*0.4 + 4/myX*sx + sx*0.2 - 8/myX*sx, sy*0.6 + sy*0.02, tocolor(255, 255, 255, 255 * panelAlpha), 1, font:getFont("condensed", 11/myX*sx), "right", "center", false, false, true, true)

        editboxtext = core:getEditboxText("nplate")
        textHossz = string.len(editboxtext) - 1

    else
            dxDrawRectangle(sx*0.435, sy*0.4, sx*0.13, sy*0.13, tocolor(35, 35, 35, 255 * panelAlpha))
            dxDrawRectangle(sx*0.437, sy*0.404, sx*0.126, sy*0.122, tocolor(25, 25, 25, 255 * panelAlpha))

            dxDrawText("#6eacf0500PP #ffffff& #7cc57675.000$", sx*0.4 + 4/myX*sx, sy*0.55 + 4/myY*sy, sx*0.4 + 4/myX*sx + sx*0.2 - 8/myX*sx, sy*0.3 + sy*0.01, tocolor(255, 255, 255, 255 * panelAlpha), 1, font:getFont("bebasneue", 13/myX*sx), "center", "center",false,false,false,true)
            core:dxDrawButton(sx*0.435 + 4/myX*sx, sy*0.455, sx*0.13 - 8/myX*sx, sy*0.035, 110, 172, 240, 220 * panelAlpha, "PP", tocolor(255, 255, 255, 255 * panelAlpha), 1, font:getFont("condensed", 11/myX*sx), false, tocolor(0, 0, 0, 100 * panelAlpha))
            core:dxDrawButton(sx*0.435 + 4/myX*sx, sy*0.491, sx*0.13 - 8/myX*sx, sy*0.035, 124, 197, 118, 220 * panelAlpha, "Készpénz", tocolor(255, 255, 255, 255 * panelAlpha), 1, font:getFont("condensed", 11/myX*sx), false, tocolor(0, 0, 0, 100 * panelAlpha))

    end 

end

addEventHandler("onClientKey", getRootElement(), function(button, press)
    if panel then
        if isInSlot(sx*0.4 + 2/myX*sx, sy*0.3 + 2/myY*sy, sx*0.2 - 4/myX*sx, sy*0.4 - 4/myY*sy) then 
            if button == "mouse_wheel_up" then
              if scrolvalue > 0  then
                scrolvalue = scrolvalue -1
                maxshow = maxshow -1
              end
            elseif button == "mouse_wheel_down" then
              if maxshow < vehCount then
                scrolvalue = scrolvalue +1
                maxshow = maxshow +1
              end
            end
        end
    end
end)

function panelKey(key, state)
if panel and not buypanel then 
    if state then 
        if textHossz >= 3 then
            if textHossz < 7 then
                if checkPlateText(editboxtext) then 
                    infotext = "#f55742Ez a rendszám már használatban van!"
                else
                    infotext = "#74cf6dMegfelelő rendszám!"
                end
            else
                infotext = "#f55742Ez a rendszám hosszú!"
            end
        else
            if textHossz > 0 then
                infotext = "#f55742Ez a rendszám rövid!"
            else
                infotext = ""
            end
        end
    end
end
end

function openPanel()
    addEventHandler("onClientRender", root, renderPanel)
    addEventHandler("onClientKey", root, panelKey)
     core:createEditbox(sx*0.4 + 4/myX*sx, sy*0.625, sx*0.2 - 8/myX*sx, sy*0.035, "nplate", "Egyedi rendszám", "text", true, {32, 32, 32, 255}, 0.4)
    panel = true 

    for k,v in pairs(getElementsByType("vehicle")) do 
        if getElementData(v,"veh:owner") == getElementData(localPlayer,"char:id") then
            vehCount = vehCount + 1
            myVehs[k] = {vehCount}
        end 
    end     

    dist = setTimer(function()
        x,y,z = getElementPosition(ped)
        px,py,pz = getElementPosition(localPlayer)
        local distance = getDistanceBetweenPoints3D(x,y,z,px,py,pz)

        if distance >= 5 then 
            closePanel()
        end 
    end,500,0)

end

function closePanel()
    if panel and not buypanel then 
        removeEventHandler("onClientRender",root,renderPanel)
        removeEventHandler("onClientKey",root,panelKey)
        core:deleteEditbox("nplate")
        panel = false 
        vehCount = 0 
        veh = 0 
        choose = nil
        scrolvaule = 0

        if dist then 
            killTimer(dist)
        end
    end 
end 

bindKey("backspace","down",closePanel)

function checkPlateText(text)
    local isUsed = false 

    for k, v in ipairs(getElementsByType("vehicle")) do 
        if getVehiclePlateText(v) == text then 
            isUsed = true 
            break
        end
    end

    return isUsed
end

function closeBuyPanel()
    if buypanel then 
        buypanel = false 
        core:createEditbox(sx*0.4 + 4/myX*sx, sy*0.625, sx*0.2 - 8/myX*sx, sy*0.035, "nplate", "Egyedi rendszám", "text", true, {32, 32, 32, 255}, 0.4)
    end 
end 

bindKey("backspace","down",closeBuyPanel)

function ClickFunction ( button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement )
    if (button == "right") and (state == "down") then 
        if (clickedElement) and (clickedElement == ped) then 
            openPanel()
        end 
    end 

    if (button == "left") and (state == "down") and panel and not buypanel then 
        local vehClick = 0
        for k,v in pairs(getElementsByType("vehicle")) do 
            if getElementData(v,"veh:owner") == getElementData(localPlayer,"char:id") then 
                if getElementData(v, "veh:isFactionVehice") == 0 then
                    vehClick = vehClick + 1
                    if vehClick <= maxshow and (vehClick > scrolvalue) then 

                        if isInSlot(sx*0.4025,sy*0.337+ sy*0.049 *(vehClick - scrolvalue - 1),sx*0.195,sy*0.045) then
                            setVeh = v
                            vehID = k
                            choose = vehClick
                        end 

                    end 
                end
            end 
        end   
        
        if isInSlot(sx*0.4 + 4/myX*sx, sy*0.66, sx*0.2 - 8/myX*sx, sy*0.035) then 
            if not checkPlateText(editboxtext) then 
                if textHossz >= 3 then
                    buypanel = true 
                    core:deleteEditbox("nplate")
                end 
            end 
        end 
    end 

    if (button == "left") and (state == "down") and panel and buypanel then 
        if isInSlot(sx*0.435 + 4/myX*sx, sy*0.455, sx*0.13 - 8/myX*sx, sy*0.035) then 
            if getElementData(localPlayer,"char:pp") >= 500 then 
                if textHossz >= 3 then    
                    triggerServerEvent("takePP",localPlayer,localPlayer,500)
                    triggerServerEvent("setVehPlate",localPlayer,setVeh,editboxtext)
                    exports["oInfobox"]:outputInfoBox("Sikeresen beállítottad járműved új rendszámát!","success")
                    buypanel = false
                    core:createEditbox(sx*0.4 + 4/myX*sx, sy*0.625, sx*0.2 - 8/myX*sx, sy*0.035, "nplate", "Egyedi rendszám", "text", true, {32, 32, 32, 255}, 0.4)
                end
            else 
                exports["oInfobox"]:outputInfoBox("Nincs elegendő prémium pontod a vásárláshoz!","error")
            end 
        elseif isInSlot(sx*0.435 + 4/myX*sx, sy*0.491, sx*0.13 - 8/myX*sx, sy*0.035) then 
            if getElementData(localPlayer,"char:money") >= 75000 then 
                if textHossz >= 3 then
                    triggerServerEvent("takeMoney",localPlayer,localPlayer,500)
                    triggerServerEvent("setVehPlate",localPlayer,setVeh,editboxtext)
                    exports["oInfobox"]:outputInfoBox("Sikeresen beállítottad járműved új rendszámát!","success")
                    buypanel = false
                    core:createEditbox(sx*0.4 + 4/myX*sx, sy*0.625, sx*0.2 - 8/myX*sx, sy*0.035, "nplate", "Egyedi rendszám", "text", true, {32, 32, 32, 255}, 0.4)
                end 
            else 
                exports["oInfobox"]:outputInfoBox("Nincs elegendő pénzed a vásárláshoz!","error")
            end 
        end 
    end 

end
addEventHandler ( "onClientClick", getRootElement(), ClickFunction)


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