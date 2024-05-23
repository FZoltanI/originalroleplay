sx,sy = guiGetScreenSize();
local func = {};
local font = exports.oFont:getFont("condensed", 16);
local font2 = exports.oFont:getFont("condensed", 14);
local maxbuycount = 15;

myX, myY = 1768, 992

local progress = 0;
local entered = false;
local selectedCount = 0;
local convertnumber = {
    [9] = 7;
    [10] = 6;
    [11] = 5;
    [12] = 4;
    [13] = 3;
    [14] = 2;
    [15] = 1;
};
local posX,posY = sx/2 -(maxbuycount*40/2),sy-200;
local show = false;
local showmenu = false;
local panelW,panelH = 320/myX*sx,145/myY*sy;
local panelX,panelY = sx/2 -panelW/2,sy/2 - panelH/2;
local pedCache = {};
local selectedElement = nil;

pedData = {
    {
        type = "iron";
        position = {-2454.5615234375,2254.2758789062,4.9802069664001};
        rotation = 90;
        interior = 0;
        dimension = 0;
        name = "Filbert Thaleia";
        skin = 153;
        amount = 2000;
        item = 203;
    };
    {
        type = "tree";
        position = {2355.8452148438, -646.64782714844, 128.0546875};
        rotation = 180;
        interior = 0;
        dimension = 0;
        name = "Benjamin Kingston";
        skin = 161;
        amount = 1800;
        item = 202;
    };
    {
        type = "plastic";
        position = {2646.1188964844,-2089.376953125,16.953125};
        rotation = 90;
        interior = 0;
        dimension = 0;
        name = "Sandip Keano";
        skin = 222;
        amount = 1500;
        item = 201;
    };
};

typeOfname = {
    ["plastic"] = "Műanyag";
    ["iron"] = "Vas";
    ["tree"] = "Fa";
};

buyCache = {
    ["plastic"] = {
        time = 0;
    };
    ["iron"] = {
        time = 0;
    };
    ["tree"] = {
        time = 0;
    };
};

local colCache = {
	{2541,-1296.3,1043.1,4.8, 5.4, 3.0},
	{2552.5,-1296.3,1043.1,7.1, 5.4, 3.0},
}

if not getElementData(localPlayer,"char:buyCraft") then
    setElementData(localPlayer,"char:buyCraft",buyCache)
end

addCommandHandler("nullbuytime",function()
    if getElementData(localPlayer,"user:admin") >= 10 then
        setElementData(localPlayer,"char:buyCraft",buyCache)
    end
end)

setTimer(function()
    if getElementData(localPlayer,"user:loggedin") then
        local cache = getElementData(localPlayer,"char:buyCraft");
        if cache then
            for type,v in pairs(cache) do
                if cache[type].time > 0 then
                    cache[type].time = cache[type].time-1;
                    --outputChatBox(buyCache[type].time)
                    setElementData(localPlayer,"char:buyCraft",cache)
                end
            end
        end
    end
end,exports.oCore:minToMilisec(1),0)

func.start = function()

    txd_floors = engineLoadTXD ( "files/cj_dfext.txd" )
    engineImportTXD ( txd_floors, 941 )

    for k,v in ipairs(colCache) do
		local colshape = createColCuboid(v[1],v[2],v[3],v[4],v[5],v[6])
		setElementInterior(colshape, 2)
		setElementDimension(colshape, 240)
		setElementData(colshape,"craft:colShape",true)
	end

    for k,v in ipairs(pedData) do
        local ped = createPed(v.skin,v.position[1],v.position[2],v.position[3])
        setElementRotation(ped,0,0,v.rotation)
        setElementData(ped,"ped:name",v.name);
        setElementData(ped,"ped:prefix",typeOfname[v.type]);
        setElementFrozen(ped,true);
        setElementData(ped,"ped:seller",true);
        setElementData(ped,"ped:seller:id",k);
        pedCache[ped] = true;
    end
end
addEventHandler("onClientResourceStart",resourceRoot,func.start)

local move1 = true;
local move2 = false;

func.render = function()

    if selectedElement and isElement(selectedElement) then
        local playerX,playerY,playerZ = getElementPosition(localPlayer);
        local targetX,targetY,targetZ = getElementPosition(selectedElement);
        if getDistanceBetweenPoints3D(playerX,playerY,playerZ,targetX,targetY,targetZ) > 3 then
            func.closeMenu()
        end
    end

    if showmenu and isElement(selectedElement) then
        local pedid = getElementData(selectedElement,"ped:seller:id");
        core:drawWindow(panelX,panelY,panelW,panelH,typeOfname[pedData[pedid].type].." - Kereskedés")

        dxDrawImage(panelX + panelW/2 - 20/myX*sx, panelY + sy*0.03, 40/myX*sx, 40/myY*sy, inventory:getItemImage(pedData[pedid].item), 0, 0, 0, tocolor(255, 255, 255, 255))
        dxDrawText("Darab ár: "..color..pedData[pedid].amount.." $",panelX,panelY + sy*0.08,panelX+panelW,panelY+ sy*0.08+panelH,tocolor(255, 255, 255,255),0.8,font2,"center","top",false,false,false,true)

        core:dxDrawButton(panelX + 40/myX*sx, panelY + sy*0.105, panelW - 80/myX*sx, sy*0.03, r, g, b, 200, "Vásárlás", tocolor(255, 255, 255, 255), 0.8, font2, true, tocolor(0, 0, 0, 150))
    end

    if show then
        dxDrawRectangle(posX + 20 - 2/myX*sx,posY+16 - 2/myY*sy,(maxbuycount*40) + 4/myX*sx,18 + 4/myY*sy,tocolor(35,35,35,150))
        dxDrawRectangle(posX + 20,posY+16,(maxbuycount*40),18,tocolor(35,35,35,255))
        
        core:dxDrawShadowedText("Megállításhoz nyomd le az "..color.."'ENTER'#ffffff gombot.", posX+ 30-1 + (maxbuycount*40)/2,posY+60+1,posX+ 30-1 + (maxbuycount*40)/2,posY+60+1, tocolor(255, 255, 255, 255), tocolor(0, 0, 0, 255), 0.8,font,"center","center", false, false, false, true)

        for i = 1,maxbuycount do
            local r2,g2,b2 = 255,255,255;
            if selectedCount == i then
                r2,g2,b2 = r,g,b;
            end

            core:dxDrawShadowedText(convertnumber[i] or i,posX + (i*40),posY,posX + (i*40),posY,tocolor(r2,g2,b2,255), tocolor(0, 0, 0, 255),1,font,"center","center")

            dxDrawRectangle(posX +(i*40), posY+16, 2, 18)
        end

        if not entered then
            if maxbuycount*40 > progress and move1 and not move2 then
                progress = progress+30;
                if progress == maxbuycount*40 then
                    move1 = false;
                    move2 = true;
                end
            end

            if progress <= 700  and move2 and not move1 then
                progress = progress-30;
                if progress == 0 then
                    move2 = false;
                    move1 = true;
                end
            end
        end


        dxDrawRectangle(posX-20 +(1*40),posY+16,progress,18,tocolor(r,g,b,255))
    end
end
addEventHandler("onClientRender",getRootElement(),func.render)

func.enteredKey = function(button, press)
    if not isTimer(successfullBuy) then
        if show then
            if button == "enter" and (press) then
                if not entered then
                    entered = true;

                    for i = 1,maxbuycount do
                        if posX-20 +(i*40) < posX-20 +(1*40) +progress then
                            selectedCount = i;
                        end
                    end

                    successfullBuy = setTimer(function()
                        if isElement(selectedElement) then
                            local pedid = getElementData(selectedElement,"ped:seller:id");
                            local count = convertnumber[selectedCount] or selectedCount;
                            if getElementData(localPlayer, "char:money") >= count*pedData[pedid].amount then 
                                local cache = getElementData(localPlayer,"char:buyCraft");
                                cache[pedData[pedid].type].time = 360;
                                setElementData(localPlayer,"char:buyCraft",cache);
                                triggerServerEvent("buyItemToSeller",localPlayer,localPlayer,pedData[pedid].item,count,count*pedData[pedid].amount)
                            else
                                outputChatBox(exports.oCore:getServerPrefix("red-dark", "Barkácsbolt", 2).."Nincs nálad elegendő pénz, próbáld újra.", 255, 255, 255, true)
                            end
                            func.closePanel()
                        end
                        killTimer(successfullBuy);
                    end,1500,1)

                    if isTimer(playerTimer) then
                        killTimer(playerTimer)
                    end

                end
            end
        elseif showmenu then
            if button == "backspace" and (press) then
                func.closeMenu();
            end
        end
    end
end
addEventHandler("onClientKey", getRootElement(), func.enteredKey)

func.click = function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
    if not isTimer(successfullBuy) then
        if button == "right" and state == "down" then
            if clickedElement and getElementType(clickedElement) == "ped" and getElementData(clickedElement,"ped:seller") then
                local playerX,playerY,playerZ = getElementPosition(localPlayer);
                local targetX,targetY,targetZ = getElementPosition(clickedElement);
                if getDistanceBetweenPoints3D(playerX,playerY,playerZ,targetX,targetY,targetZ) < 3 then
                    if not showmenu and not show then
                        local pedid = getElementData(clickedElement,"ped:seller:id");
                        local cache = getElementData(localPlayer,"char:buyCraft");
                        if cache[pedData[pedid].type].time == 0 then
                            showmenu = true;
                            selectedElement = clickedElement;
                        else
                            outputChatBox(exports.oCore:getServerPrefix("red-dark", "Barkácsbolt", 2).."Ennél az árusnál már vásároltál, várj még "..color..cache[pedData[pedid].type].time.."#ffffff percet.", 255, 255, 255, true)
                        end
                    end
                end
            end
        end

        if button == "left" and state == "down" then
            if showmenu then
                if func.inBox(panelX + 40/myX*sx, panelY + sy*0.12, panelW - 80/myX*sx, sy*0.03) then
                    showmenu = false;
                    show = true;
                    playerTimer = setTimer(function()
                        outputChatBox(exports.oCore:getServerPrefix("red-dark", "Barkácsbolt", 2).."Tétlen voltál, próbáld újra.", 255, 255, 255, true)
                        func.closePanel()
                        killTimer(playerTimer)
                    end,15000,1)
                end
            end
        end
    end
end
addEventHandler("onClientClick", getRootElement(), func.click)

func.closePanel = function()
    entered = false;
    selectedCount = 0;
    progress = 0;
    move1 = true;
    move2 = false;
    show = false;
    selectedElement = nil;
end

func.closeMenu = function()
    showmenu = false;
    selectedElement = nil;
    if isTimer(playerTimer) then
        killTimer(playerTimer)
    end
end

func.inBox = function(x,y,w,h)
	if(isCursorShowing()) then
		local cursorX, cursorY = getCursorPosition();
		cursorX, cursorY = cursorX*sx, cursorY*sy;
		if(cursorX >= x and cursorX <= x+w and cursorY >= y and cursorY <= y+h) then
			return true;
		else
			return false;
		end
	end	
end

addCommandHandler("getobj", function(cmd, elore)
	if not elore then
		elore = false
	else
		elore = true
	end
	if (getElementData( localPlayer, "user:admin" )) >= 10 then
		local x,y,z = getElementPosition(localPlayer)
		local marker
		local targetX, targetY, targetZ = x,y,z-10
		if elore then
			marker = createMarker(x, y, z, "cylinder", 2, 255, 0, 0, 255)
			attachElements(marker, localPlayer, 0, 10, 0)
		end
		
		outputChatBox("Lekérdezés ...")
		setTimer(function()
			if elore then
				targetX, targetY, targetZ = getElementPosition(marker)
			end
			local hit,x,y,z,elementHit,nx,ny,nz,material,lighting,piece,buildingId,wX,wY,wZ,rX,rY,rZ,lodID = processLineOfSight(x,y,z,targetX, targetY, targetZ,true,true,true,true,true,true,false,true,localPlayer,true)
			if hit then
				if buildingId then
					outputChatBox(buildingId.." -> "..engineGetModelNameFromID(buildingId))
					
					if elementHit then
						outputChatBox("Radius: "..getElementRadius(elementHit))
						outputChatBox("LOD: "..tonumber(lodID or 0))
						local wX, wY, wZ = getElementPosition(elementHit)
						local rX, rY, rZ = getElementRotation(elementHit)
						outputChatBox("Position: "..wX..", "..wY..", "..wZ)
						outputChatBox("Rotation: "..rX..", "..rY..", "..rZ)
					else
						local tempObj = createObject(buildingId, wX, wY, wZ, rX, rY, rZ)
						outputChatBox("Radius: "..getElementRadius(tempObj))
						outputChatBox("LOD: "..tonumber(lodID or 0))
						outputChatBox("Position: "..wX..", "..wY..", "..wZ)
						outputChatBox("Rotation: "..rX..", "..rY..", "..rZ)
						destroyElement(tempObj)
					end
					
					if isElement(marker) then
						destroyElement(marker)
					end
				end
			else
				outputChatBox("Hiba")
			end
		end, 1000, 1)
	else
		outputChatBox("Hiba")
	end
end)