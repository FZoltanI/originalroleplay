local screen = {guiGetScreenSize()};
local box = {actionSlots*(itemSize+actionMargin)+actionMargin,itemSize+(actionMargin*2)};
local pos = {screen[1]/2 -box[1]/2+actionMargin,screen[2] -box[2]-30};
cache.actionbar.show = false;
interface = exports.oInterface

func.actionbar.start = function(resource)
	if resource == getThisResource() then
		cache.actionbar.slot.noitem = dxCreateTexture("files/cross.png", "argb");
		if getElementData(localPlayer,"user:loggedin") then
			
			cache.actionbar.show = true;
		end
	elseif getResourceName(resource) == "oInterface" then 
		interface = exports.oInterface
	end
end
addEventHandler("onClientResourceStart",getRootElement(),func.actionbar.start)

func.actionbar.dataChange = function(dataName,value)
	if dataName == "user:loggedin" then
		if getElementData(localPlayer,dataName) then
			--addEventHandler("onClientRender",getRootElement(),func.actionbar.render, true, "low-9999");
			cache.actionbar.show = true;
			--triggerServerEvent("getActionbarItems",localPlayer,localPlayer,1);
		end
	end
end
addEventHandler("onClientElementDataChange",getLocalPlayer(),func.actionbar.dataChange)

func.actionbar.setItems = function(cache)
    actionBarCache = cache
end
addEvent("setActionbarItems", true)
addEventHandler("setActionbarItems", getRootElement(),func.actionbar.setItems)



function bindActionbarSlots()
	for i=1, 9 do 
		unbindKey(i, "down")
	end

	for i=1, interface:getActionBarSlotCount() do
		bindKey(i, "down", function()
			if not isCursorShowing() then
				if actionBarCache[i] then
					for k = 1, row * column do
						if (playerCache[localPlayer][getTypeElement(localPlayer,actionBarCache[i][2])[1]][k]) then
							if playerCache[localPlayer][getTypeElement(localPlayer,actionBarCache[i][2])[1]][k]["id"] == actionBarCache[i][1] then
								func.useItem(k,playerCache[localPlayer][getTypeElement(localPlayer,actionBarCache[i][2])[1]][k])
								setTimer(function()
									if getElementData(localPlayer,"char:goggleUser->thermalVision") then 
										setCameraGoggleEffect("thermalvision")
									elseif getElementData(localPlayer,"char:goggleUser->nightVision") then 
										setCameraGoggleEffect("nightvision")
									end 
								end,50,1)
							end
						end
					end
				end
			end
		end)
	end
end
bindActionbarSlots()

getCursorPos = getCursorPosition
function getCursorPosition()
    --outputChatBox(tostring(isCursorShowing()))
    if isCursorShowing() then
        --outputChatBox("asd")
        local x,y = getCursorPos()
        --outputChatBox("x"..tostring(x)
        --outputChatBox("y"..tostring(y))
        x, y = x * sx, y * sy
        return x,y
    else
        return -5000, -5000
    end
end

function cursorWorldPos()
    local _, _, x,y,z = getCursorPos()
    local cx, cy = getCursorPosition()
	local cameraX, cameraY, cameraZ = getWorldFromScreenPosition(cx, cy, 0.1)
	local col, x, y, z, hoverElement = processLineOfSight(cameraX, cameraY, cameraZ, x,y,z)
	return col, x, y, z, hoverElement
end
local hoverElement = false

func.actionbar.render = function()
	if cache.actionbar.show and interface:getInterfaceElementData(3,"showing") then
		cache.actionbar.cursorInSlot = false
		cache.actionbar.hover.slot = -1
		cache.actionbar.hoverItem = nil
		cache.actionbar.hoverInventoryItem = nil
		if cache.actionbar.show then
			pos[1],pos[2] = screen[1]*interface:getInterfaceElementData(3,"posX"), screen[2]*interface:getInterfaceElementData(3,"posY")

			actionSlots = interface:getActionBarSlotCount()

			if func.inBox(pos[1]+10-actionMargin,pos[2]+10-actionMargin,box[1],box[2]) then
				cache.actionbar.cursorInSlot = true
			end

			dxDrawRectangle(pos[1]-actionMargin,pos[2]-actionMargin, (actionSlots * (itemSize + actionMargin)) + actionMargin,box[2],tocolor(30,30,30,255),postGUI)
			
			for i = 1,actionSlots do
				local left = pos[1]-itemSize-actionMargin +(i*(itemSize+actionMargin));
				local hover = func.inBox(left+1, pos[2]+1, itemSize-2, itemSize-2);
				if hover then cache.actionbar.hover.slot = i end
				if ((not isCursorShowing() and getKeyState(i)) or hover) then
					dxDrawRectangle(left,pos[2],itemSize,itemSize,tocolor(37,37,37,255),postGUI);
				else
					dxDrawRectangle(left,pos[2],itemSize,itemSize,tocolor(35,35,35,255),postGUI);
				end
				if actionBarCache[i] then
					if cache.actionbar.movedSlot ~= i then
						dxDrawImage(left+1, pos[2]+1, itemSize-2, itemSize-2,cache.actionbar.slot.noitem, 0, 0, 0, tocolor(255, 255, 255, 255),postGUI);
						
						if hover then
							cache.actionbar.moveX = pos[1]-itemSize-actionMargin +(i*(itemSize+actionMargin))
							cache.actionbar.moveY = pos[2]
						end
						
					end
					
					if playerCache[localPlayer] and playerCache[localPlayer][getTypeElement(localPlayer,actionBarCache[i][2])[1]] then
						for k = 1, row * column do
							if (playerCache[localPlayer][getTypeElement(localPlayer,actionBarCache[i][2])[1]][k]) and playerCache[localPlayer][getTypeElement(localPlayer,actionBarCache[i][2])[1]][k]["id"] == actionBarCache[i][1] then
								local id = playerCache[localPlayer][getTypeElement(localPlayer,actionBarCache[i][2])[1]][k]["id"];
								local item = playerCache[localPlayer][getTypeElement(localPlayer,actionBarCache[i][2])[1]][k]["item"];
								local value = tostring(playerCache[localPlayer][getTypeElement(localPlayer,actionBarCache[i][2])[1]][k]["value"]);
								local count = playerCache[localPlayer][getTypeElement(localPlayer,actionBarCache[i][2])[1]][k]["count"];
								local state = playerCache[localPlayer][getTypeElement(localPlayer,actionBarCache[i][2])[1]][k]["state"];
								local weaponserial = playerCache[localPlayer][getTypeElement(localPlayer,actionBarCache[i][2])[1]][k]["weaponserial"];
								if cache.actionbar.movedSlot ~= i then
									
									if hover then
										if not cache.actionbar.itemMove then
											cache.actionbar.moveX = pos[1]-itemSize-actionMargin +(i*(itemSize+actionMargin))
											cache.actionbar.moveY = pos[2]
										end
										cache.actionbar.hoverItem = actionBarCache[i];
										cache.actionbar.hoverInventoryItem = playerCache[localPlayer][getTypeElement(localPlayer,actionBarCache[i][2])[1]][k];
										func.toolTip(unpack(getItemTooltip(id,item,value,count,state,weaponserial)));
									end
									--outputDebugString(state)
									if (state == 2) then
										if fileExists("files/items/"..item.."_2.png") then 
											dxDrawImage(left, pos[2], itemSize, itemSize, "files/items/"..item.."_2.png", 0, 0, 0, tocolor(255, 255, 255, 255),postGUI);
										else
											dxDrawImage(left, pos[2], itemSize, itemSize, cache.inventory.textures.item[item], 0, 0, 0, tocolor(255, 255, 255, 255),postGUI);
										end
									--print(value)
									
									elseif value then 
										dxDrawImage(left, pos[2], itemSize, itemSize,getItemImage(item, value), 0, 0, 0, tocolor(255, 255, 255, 255));
									else
										dxDrawImage(left, pos[2], itemSize, itemSize, cache.inventory.textures.item[item], 0, 0, 0, tocolor(255, 255, 255, 255),postGUI);
									end
									dxDrawText(count,left,pos[2],left+itemSize,pos[2]+itemSize,tocolor(0,0,0,255),0.42,cache.font.sfpro,"right","bottom",false,false,postGUI);
									dxDrawText(count,left,pos[2],left+itemSize-2,pos[2]+itemSize-2, tocolor(255,255,255,255),0.42,cache.font.sfpro,"right","bottom",false,false,postGUI);

									if getTypeElement(localPlayer,actionBarCache[i][2])[1] == "bag" and ((cache.inventory.active.weapon == k) or (cache.inventory.active.ammo == k) or (cache.inventory.active.badge == k) or (cache.inventory.active.phone == k)) then
										dxDrawImage(left, pos[2], itemSize, itemSize,"files/activeItem.png",0,0,0,tocolor(r, g, b, 180));
									end
								end
							end
						end
					end
				end 
			end
			
			if cache.actionbar.itemMove then
				if isCursorShowing() then    
					local x, y = func.getCursorPosition()
					cache.actionbar.moveX,cache.actionbar.moveY = x - cache.actionbar.defX,y - cache.actionbar.defY
				else
					cache.actionbar.moveX,cache.actionbar.moveY = 0,0
					cache.actionbar.movedSlot = -1
					cache.actionbar.slot.movedimg = -1
					cache.actionbar.itemMove = false
				end
				dxDrawImage(cache.actionbar.moveX,cache.actionbar.moveY,itemSize,itemSize,cache.actionbar.slot.movedimg);
			end
			if isCursorShowing() then 
				col, x, y, z, hoverElement = cursorWorldPos()
				if hoverElement then 
					if getElementData(hoverElement, "isWorldItem") then 
						local yard = getDistanceBetweenPoints3D(Vector3(getElementPosition(localPlayer)), Vector3(getElementPosition(hoverElement)))
						if yard <= 5 then 
							--outputDebugString("hover")
							local cx, cy = getCursorPosition()
							--dxDrawImage(cx,cy-36, 36, 36, getItemImage(getElementData(hoverElement, "worldItem:itemId"), getElementData(hoverElement, "worldItem:itemValue")))
							if getElementData(localPlayer,"user:aduty") and getElementData(localPlayer, "user:admin") >= 5 then
								worldItemHover(getItemName(getElementData(hoverElement, "worldItem:itemId"), getElementData(hoverElement, "worldItem:itemValue"))..color,"[DropOwnerId : ".. getElementData(hoverElement, "worldItem:owner").." | DropOwnerName : ".. getElementData(hoverElement, "worldItem:ownerName").."]","#fffffférték: ".. getElementData(hoverElement, "worldItem:itemValue"),"#7cc576"..getElementData(hoverElement, "worldItem:itemCount").."#ffffff db")
							else
								worldItemHover(unpack(getItemTooltipWorldItem(getElementData(hoverElement, "worldItem:itemId"), getElementData(hoverElement, "worldItem:itemValue"), getElementData(hoverElement, "worldItem:itemCount"), getElementData(hoverElement, "worldItem:itemState"))))
							end
							--dxDrawRectangle(cx,cy)
							--func.toolTip(unpack(getItemTooltip(id,item,value,count,state,weaponserial,pp,warn)));
						end
					end
				end
			end
			--dxDrawRectangle(x,y,120,20)
		end
	end
end
addEventHandler("onClientRender",getRootElement(),func.actionbar.render, true, "low-9999");

function worldItemHover(...)
	if isCursorShowing() then
		local x,y = getCursorPosition()
		local args = {...};
		local width = 0;

		for i, v in ipairs(args) do
			local thisWidth = dxGetTextWidth( v, 0.9, font:getFont("condensed", 10), true) + 20;
			if thisWidth > width then
				width = thisWidth;
			end
		--	print(v)
		end
		--iprint(args)
		text = table.concat(args, "\n");
		local height = dxGetFontHeight(0.9, font:getFont("condensed", 10)) * #args + 10;
		x = math.max( 10, math.min( x, sx - width - 10 ) )
		y = math.max( 10, math.min( y, sy - height - 10 ) )
		alpha = 1

		dxDrawRectangle(x-21 + width/2, y-41, 38, 38, tocolor(35,35,35,250*alpha))
		dxDrawImage(x-20 + width/2,y-40,36,36,getItemImage(getElementData(hoverElement, "worldItem:itemId"), getElementData(hoverElement, "worldItem:itemValue")))

		dxDrawRectangle( x, y, width, height, tocolor( 35, 35, 35, 250 * alpha ), true )
		dxDrawText( text, x, y, x + width, y + height, tocolor( 255, 255, 255, 230 * alpha ), 0.9, font:getFont("condensed", 10), "center", "center", false, false, true, true )
	end
end