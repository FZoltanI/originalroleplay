local screenX, screenY = guiGetScreenSize()
local panelW, panelH = 250, 300
local panelX, panelY = screenX/2 - panelW/2, screenY/2 - panelH/2
local textures = {}

local selectedMachineType = "food"

local panelState = false

for k,v in pairs(items["food"]) do
    --print(v[1])
    textures[v[1]] = dxCreateTexture(exports["oInventory"]:getItemImage(v[1], 1))
end
for k,v in pairs(items['drink']) do
    textures[v[1]] = dxCreateTexture(exports["oInventory"]:getItemImage(v[1], 1))
end 
for k,v in pairs(items["coffee"]) do
    textures[v[1]] = dxCreateTexture(exports["oInventory"]:getItemImage(v[1],1))
end


addEventHandler("onClientClick", getRootElement(),function(button, state, absX, absY, worldX, worldY, worldZ, clickedElement)
    if button == "right" and state == "down" then
        if clickedElement and isElement(clickedElement) and type[getElementModel(clickedElement)]then 
            local px,py,pz = getElementPosition(localPlayer)
             tx,ty,tz = getElementPosition(clickedElement)
            if getDistanceBetweenPoints3D(px,py,pz,tx,ty,tz) <= 2 then
                hex, r, g, b = exports.oCore:getServerColor()
                fontB = dxCreateFont("files/fontB.otf", 14)
                if type[getElementModel(clickedElement)] == "food" then 
                --    outputChatBox("kaja")
                    selectedMachineType = "food"
                else
                --   outputChatBox("pia")
                    selectedMachineType = "drink"
                end
                if getDistanceBetweenPoints3D(px,py,pz,tx,ty,tz) <= 2 then
                    hex, r, g, b = exports.oCore:getServerColor()
                    fontB = dxCreateFont("files/fontB.otf", 14)
                    if type[getElementModel(clickedElement)] == "coffee" then 
                    --    outputChatBox("kaja")
                        selectedMachineType = "coffee"
                    end
                end
                panelState = true
                removeEventHandler("onClientRender",getRootElement(), drawPanel, true, "low-9999")
                removeEventHandler("onClientClick", getRootElement(), vendingMachineClick)
                removeEventHandler("onClientKey", getRootElement(), vendingMachineKey)
                addEventHandler("onClientRender",getRootElement(), drawPanel, true, "low-9999")
                addEventHandler("onClientClick", getRootElement(), vendingMachineClick)
                addEventHandler("onClientKey", getRootElement(), vendingMachineKey)
            else 
                --outputChatBox(core:getServerPrefix("server", "VendingMachine", 3).."Túl messze vagy!", 0, 0, 0,true);
            end
        end
    end
end)


function drawPanel()
    local x,y,z = getElementPosition (localPlayer)
    if panelState and (getDistanceBetweenPoints3D (x,y,z,tx,ty,tz) <3) then
    -- if getPlayerSerial(localPlayer) == "8B23EC8A49888EB7A5778CE0AF7D88A2" or getPlayerSerial(localPlayer) == "0B25976E227D03EB223B81589A372224" then
        dxDrawRectangle(panelX,panelY + 40, panelW, 55 * #items[selectedMachineType], tocolor(35,35,35,160))
        dxDrawRectangle(panelX,panelY, panelW, 40, tocolor(30,30,30,250))
        dxDrawText(hex.."OriginalRoleplay#FFFFFF - Automata", screenX/2, panelY, screenX/2 , panelY + 40, tocolor(255,255,255,255),0.8,fontB, "center", "center", false,false,false,true)
        for k,v in pairs(items[selectedMachineType]) do 
            if isMouseInPosition(panelX, panelY + 51 * k - 10, panelW, 50) then
                dxDrawRectangle(panelX, panelY + 51 * k - 10, panelW, 50, tocolor(r, g, b, 220)) 
            else 
                dxDrawRectangle(panelX, panelY + 51 * k - 10, panelW, 50, tocolor(32,32,32, 200))
            end
            dxDrawText(exports["oInventory"]:getItemName(v[1]), panelX + 45, panelY + 50 * k, 0, 0, tocolor(255,255,255,230), 0.65, fontB, "left", "top", false,false,false,true)
            dxDrawText("Ár: #85bb65"..v[2] .. "#FFFFFF $", panelX + 45, panelY + 50 * k + 15, 0, 0, tocolor(255,255,255,230), 0.65, fontB, "left", "top", false,false,false,true)
            dxDrawImage(panelX + 5, panelY + 51 * k - 5, 36, 36, textures[v[1]])
           -- iprint(textures[v[1]])
        end
    --   end
    else 
        vendingAlreadyBuy()
    end
end

function vendingMachineClick(button, state)
    if button == "left" and state == "down" then 
        if panelState then 
            for k,v in pairs(items[selectedMachineType]) do 
                if isMouseInPosition(panelX, panelY + 51 * k - 10, panelW, 50) then
                    if getElementData(localPlayer, "char:money") >= v[2] then 
                        
                        --exports["oInventory"]:giveItem()
                        triggerServerEvent("giveItem:vendingMachine", localPlayer, localPlayer, v[1], v[2])
                    else
                        outputChatBox(core:getServerPrefix("server", "VendingMachine", 3).."Nincs elég pénzed!", 0, 0, 0,true);
                    end
                end
            end
        end
    end
end

function vendingMachineKey(button, state)
    if button == "backspace" and state then 
        panelState = false 
        removeEventHandler("onClientRender",getRootElement(), drawPanel)
        removeEventHandler("onClientClick",getRootElement(), vendingMachineClick)
        removeEventHandler("onClientKey",getRootElement(), vendingMachineKey)
        if isElement(fontB) then 
            destroyElement(fontB)
        end
    end
end


function vendingAlreadyBuy ()
    panelState = false 
    removeEventHandler("onClientRender",getRootElement(), drawPanel)
    removeEventHandler("onClientClick",getRootElement(), vendingMachineClick)
    removeEventHandler("onClientKey",getRootElement(), vendingMachineKey)
end

addEvent ("vendingAlreadyBuy", true)
addEventHandler ("vendingAlreadyBuy", localPlayer, vendingAlreadyBuy)

local createAutomata = false
local objID = 1776

addCommandHandler("createautomata",function(cmd, type)
    if getElementData(localPlayer, "user:admin") >= 7 then 
        if not type then 
            outputChatBox(core:getServerPrefix("server", "vendingMachine", 3).."Használat: ".. cmd.." [Típus]", 0, 0, 0, true);
            outputChatBox(core:getServerPrefix("server", "vendingMachine", 3).."Típus: 1 = Étel | 2 = Ital | 3 = Kávé", 0, 0, 0, true);
        else
            type = tonumber(type)
            if type == 1 then 
                objID = 1776
            elseif type == 2 then 
                objID = 1775
            elseif type == 3 then 
                objID = 955
            end
            createAutomata = createObject(objID, 0, 0, 0)
            setElementCollisionsEnabled(createAutomata, false)
            setElementAlpha(localPlayer, 0)
            addEventHandler("onClientRender",getRootElement(),renderAutomataPlacement)
            --addEventHandler("onClientKey", getRootElement(), automataPlacementKey)
            setElementInterior(createAutomata, getElementInterior(localPlayer))
            setElementDimension(createAutomata, getElementDimension(localPlayer))
        end
    end
end)

function renderAutomataPlacement()
    setElementPosition(createAutomata, getElementPosition(localPlayer))
    rotX,rotY,rotZ = getElementRotation(localPlayer)
    setElementRotation(createAutomata, rotX,rotY,rotZ)
    if getKeyState("lalt") then 
        removeEventHandler("onClientRender",getRootElement(), renderAutomataPlacement)
        destroyElement(createAutomata)
        createAutomata = false 
        setElementAlpha(localPlayer, 255)
       
        triggerServerEvent("placeAutomata", localPlayer, localPlayer,objID)
        local px,py,pz = getElementPosition(localPlayer)
        setElementPosition(localPlayer, px,py+5,pz)
    end
end

addCommandHandler("delautomata",function(cmd, id)
    if getElementData(localPlayer, "user:admin") >= 7 then 
        if not id then 
            outputChatBox(core:getServerPrefix("server", "vendingMachine", 3).."Használat: ".. cmd.." [ID]", 0, 0, 0, true);
        else
            triggerServerEvent("deleteAutomata", localPlayer, localPlayer, id)
        end
    end
end)

addCommandHandler("nearbyautomata", function(cmd, distance)
    if getElementData(localPlayer, "user:admin") >= 7 then 
        if not distance then
            distance = 15 
        else 
            distance = tonumber(distance)
        end
        hex, r, g, b = exports.oCore:getServerColor()
        local count = 0
        local px,py,pz = getElementPosition(localPlayer)
        outputChatBox(core:getServerPrefix("server", "vendingMachine", 3).."Közeledben lévő automaták (".. distance .." Yard)", 0, 0, 0, true);
        for k,v in ipairs(getElementsByType("object")) do 
            if getElementData(v, "vendingMachine.isMachine") then 
                local tx,ty,tz = getElementPosition(v)
                if getDistanceBetweenPoints3D(px,py,pz,tx,ty,tz) <= distance then 
                    outputChatBox(hex.."*#FFFFFF Azonosító: "..hex.. getElementData(v, "vendingMachine.Id") .."#FFFFFF | Távolság: "..hex..math.floor(getDistanceBetweenPoints3D(px,py,pz,tx,ty,tz)), 255, 255, 255, true)
                    count = count + 1
                end
            end
        end
        if count == 0 then 
            outputChatBox(core:getServerPrefix("server", "vendingMachine", 3).."Nincs a közeledben automata (".. distance .." Yard)", 0, 0, 0, true);
        end
    end
end)


function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end