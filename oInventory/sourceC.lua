sx,sy = guiGetScreenSize();
func = {};
func.actionbar = {};
func.eating = {};
func.weapon = {};
func.trash = {};
func.frisk = {};
func.safe = {};
func.player = {};
func.drug = {};
func.identity = {};
func.identityPed = {};
func.craft = {};
screen = {guiGetScreenSize()};
width = column*(itemSize+margin)+margin;
height = row*(itemSize+margin)+margin;
pos = {screen[1]/2,screen[2]/2};
screenSource = dxCreateScreenSource(screen[1], screen[2])
cache = {
	ticketData = {};
	font = {
        sansheavy = font:getFont("condensed", 12);
        sfpro = font:getFont("condensed", 12);
		roboto = font:getFont("condensed", 12);
		awesome = font:getFont("condensed", 12);
		freeAdelaide = font:getFont("condensed", 12);
    	sfcDisplaybold = font:getFont("condensed", 12);
    	sfcDisplaybold2 = font:getFont("condensed", 12);
    };
	player = {
		show = true,
	},
	drunk = {},
	drug = {};
	identityPed = {
		box = {256,147};
		pos = {screen[1]/2 -256/2,screen[2]/2 -147/2};
	};
	identity = {
		item = 0;
		["personal"] = {
			pos = {screen[1]/2 - 450/2,screen[2]/2 -257/2};
			box = {450,257};
		};
		["passport"] = {
			pos = {screen[1]/2 - 354/2,screen[2]/2 -370/2};
			box = {354,370};
		};
		["adr"] = {
			pos = {screen[1]/2 - 354/2,screen[2]/2 -488/2};
			box = {354,488};
		};
		["driving1"] = {
			pos = {screen[1]/2 - 450/2,screen[2]/2 -257/2};
			box = {450,257};
		};
		["driving2"] = {
			pos = {screen[1]/2 - 450/2,screen[2]/2 -257/2};
			box = {450,257};
		};
		["fishing"] = {
			pos = {screen[1]/2 - 354/2,screen[2]/2 -488/2};
			box = {354,488};
		};
		["hunting"] = {
			pos = {screen[1]/2 - 450/2,screen[2]/2 -257/2};
			box = {450,257};
		};
		["weapon"] = {
			pos = {screen[1]/2 - 450/2,screen[2]/2 -257/2};
			box = {450,257};
		};
		["traffic"] = {
			pos = {screen[1]/2 - 525/2,screen[2]/2 -300/2};
			box = {525,300};
		};
	};
	frisk = {
		show = false,
		data = {},
		items = {},
		page = "bag",
		categories = {
			{"bag","Tárgyak"},
			{"key","Kulcsok"},
			{"licens","Iratok"},
		},
	},
	inventory = {
		dummyTimer = {},
		show = false,
		textures = {
			item = {},
			siren = dxCreateTexture('files/items/83_2.png'),
		},
		usedSlots = 0,
		page = "bag",
		currentpage = 1,
		defY = 0,
		defX = 0,
		moving = false,
		element = nil,
		cursorInSlot = false,
		cursorInInv = false,
		hoverSlot = -1,
		hoverItem = nil,
		movedSlot = -1,
		movedItem = nil,
		moveX = 0,
		moveY = 0,
		itemMove = false,
		gui = nil,
		editing = false,
		alpha = 255,
		itemlist = {
			show = false,
			box = {300,386},
			pos = {screen[1]/2 - 300/2,screen[2]/2 - 386/2},
			gui = nil,
			wheel = 0,
			text = "",
			edit = false,
		};
		active = {
			weapon = -1,
			ammo = -1,
			dbid = -1,
			card = -1,
			identity = -1,
			badge = -1,
			phone = -1,
			goggle = -1,
		};
		slot = {
			img = nil,
		};
		sound = {
			selected = 0,
		};
		eyed = {
			tooltip = {},
			data = {},
			tick = {},
			anim = {},
			pos = {},
			alpha = {},
			alpha2 = {},
		};
	};
	actionbar = {
		show = false;
		defX = 0;
		defY = 0;
		moveX = 0;
		moveY = 0;
		slot = {};
		hover = {
			slot = -1,
			movedimg = -1,
		};
		itemMove = false;
		hoverInventoryItem = nil;
		hoverItem = nil;
		movedInventoryItem = nil;
		movedItem = nil;
		movedSlot = -1;
		cursorInSlot = false;
	};
	eating = {
		pos = {screen[1]/2 -itemSize/2,screen[2] -190},
	};
	weapon = {
		posX = screen[1]/2,
		posY = screen[2]/2,
		img = {};
	};
	trash = {

	};
	safe = {

	};
	craft = {
		defY = 0,
		defX = 0,
		moving = false,
		moveX = 0;
		moveY = 0;
		show = false;
		hoverSlot = -1;
		cursorInSlot = false;
		hoverItem = nil;
		movedItem = nil;
		movedSlot = -1;
		itemMove = false;
		cursorInCraftbox = false;
		craftedItem = -1;
		progress = 208;
	};
};
inventoryCache = {};
playerCache = {};
actionBarCache = {};
weaponProgress = {};
toggleControlSlot = {};
craftItems = {};

local inventoryAlpha = 0
local inventoryAnimationState = "open"
local inventoryAnimationTick = 0

local drunkenLevel = 0
local drunkHandled = false
local drunkenScreenSource = false
local fuckControlsDisabledControl = false
local fuckControlsChangeTick = 0
local drunkenScreenFlickeringState = false

local players = {};


local ammoboxTXD = engineLoadTXD("files/models/lv_ammo.txd")
engineImportTXD(ammoboxTXD, 2969)
local ammobox = engineLoadDFF("files/models/level_ammobox.dff")
engineReplaceModel(ammobox, 2969)



itemImageTextures = {}
function createItemTextures()
	for k, v in ipairs(availableItems) do
		local texture
		if fileExists("files/items/"..k..".png") then
			texture = dxCreateTexture("files/items/"..k..".png", "dxt1")
		else
			texture = dxCreateTexture("files/items/0.png", "dxt1")
		end

		table.insert(itemImageTextures, k, texture)
	end
end
createItemTextures()

local printerTimer = false

func.start = function()
	if getElementData(localPlayer,"player:badge") then
		setElementData(localPlayer,"player:badge",nil);
	end
	cache.inventory.element = localPlayer
	inventoryCache[localPlayer] = {};

	guiSetInputMode("no_binds_when_editing")
	setElementData(localPlayer,"tazerState",false)
	setCameraShakeLevel(0)
	for i, v in pairs(availableItems) do
        cache.inventory.textures.item[i] = dxCreateTexture(getItemImage(i), "argb");
	end

	if getElementData(localPlayer,"user:loggedin") then
		setPlayerHudComponentVisible("crosshair",true)
		--triggerServerEvent("getItems",localPlayer,localPlayer,2)
	end
	if isTimer(printerTimer) then
		killTimer(printerTimer)
	end
	alcoholTimer = setTimer(checkAlcoholLevel, 10000, 1)

	setElementData(localPlayer,"jewInProgress",false)
end
addEventHandler("onClientResourceStart",resourceRoot,func.start)

func.dataChange = function(dataName)
	if dataName == "user:loggedin" then
		if getElementData(localPlayer,dataName) then
			triggerServerEvent("onLoginDataChange", localPlayer, localPlayer)

			setPlayerHudComponentVisible("crosshair",true)
			alcoholTimer = setTimer(checkAlcoholLevel, 10000, 1)
			--triggerServerEvent("getItems",localPlayer,clickedElement,2)
			--triggerServerEvent("getItems",localPlayer,localPlayer,2)
			--triggerServerEvent("checkBuggedItems",localPlayer,localPlayer)
		end
	end 
end
addEventHandler("onClientElementDataChange",getLocalPlayer(),func.dataChange)


function checkAlcoholLevel()
	if getElementData(localPlayer, "adminJail.IsAdminJail") then
		if isTimer(alcoholTimer) then
			killTimer(alcoholTimer)
			alcoholTimer = nil
		end
		alcoholTimer = setTimer(checkAlcoholLevel, 10000,1)
		return
	end
	if getElementData(localPlayer,"pd:jail") then
		if isTimer(alcoholTimer) then
			killTimer(alcoholTimer)
			alcoholTimer = nil
		end
		alcoholTimer = setTimer(checkAlcoholLevel, 10000,1)
		return
	end
	if isTimer(alcoholTimer) then
		killTimer(alcoholTimer)
		alcoholTimer = nil
	end
	if getElementData(localPlayer, "user:aduty") then
		return
	end

	local level = getElementData(localPlayer, "char:alcoholLevel") or 0
	if level > 0 then
		local loss = math.random(1,4)
		if level - loss <= 0 then
			setElementData(localPlayer, "char:alcoholLevel", 0)
			setTimer(checkAlcoholLevel, 10000, 1)
		else
			setElementData(localPlayer, "char:alcoholLevel", level - loss)
			setTimer(checkAlcoholLevel, 10000, 1)
		end
	end
end

func.setItems = function(element,value,table)
	cache.inventory.element = element
	if value == 2 then
		playerCache[cache.inventory.element] = table
	end
	inventoryCache[cache.inventory.element] = table
end
addEvent("setItems",true)
addEventHandler("setItems",getRootElement(),func.setItems)

func.showInventory = function()
	if inventoryAnimationTick + 250 < getTickCount() then
		if getElementData(localPlayer,"user:loggedin") then
			if not cache.inventory.show then
				cache.inventory.show = true
				addEventHandler("onClientRender",getRootElement(),func.render)

				inventoryAnimationState = "open"
				inventoryAnimationTick = getTickCount()

				cache.inventory.gui = guiCreateEdit(-1000,-1000,0,0,"",false)
				guiEditSetMaxLength(cache.inventory.gui,4)
				addEventHandler("onClientGUIChanged", cache.inventory.gui, function(element)
					if element == cache.inventory.gui then
						editText = guiGetText(cache.inventory.gui);
						editText = editText:gsub("[^0-9]", "");

						guiSetText(cache.inventory.gui,editText);
					end
				end, true);
			else
				if cache.inventory.page == "object" or cache.inventory.page == "vehicle" then
					if cache.inventory.page == "vehicle" then
						setElementData(cache.inventory.element, "veh:player", nil)
						setElementData(cache.inventory.element, "veh:use", false)
						triggerServerEvent("doorState", localPlayer, cache.inventory.element, 0)
					end
					if cache.inventory.page == "object" then
						if getElementModel(cache.inventory.element) == 2332 then
							setElementData(cache.inventory.element,"safe:use",false)
							setElementData(cache.inventory.element,"safe:player",nil)
							setElementData(localPlayer,"player:safe",false)

						end
					end
					--triggerServerEvent("getItems",localPlayer,localPlayer,2)


				end


				inventoryAnimationState = "close"
				inventoryAnimationTick = getTickCount()
				setTimer(function()
					removeEventHandler("onClientRender",getRootElement(),func.render)
					destroyElement(cache.inventory.gui)

					setElementData(localPlayer,"show:inv",nil)
					cache.inventory.show = false

					cache.inventory.element = localPlayer
					inventoryCache[localPlayer] = playerCache[localPlayer]

					cache.inventory.page = "bag";
					cache.inventory.currentpage = 1;
				end, 250, 1)

				if cache.inventory.itemMove then
					cache.inventory.itemMove = false
					cache.inventory.movedSlot = -1
				end
			end
		end
	end
end
bindKey("i","down",func.showInventory)

func.deleteItemKey = function()
	if getElementData(localPlayer,"user:admin") >= 8 then
		if cache.inventory.element == localPlayer and cache.inventory.hoverSlot > 0 and inventoryCache[cache.inventory.element] and inventoryCache[cache.inventory.element][cache.inventory.page] and inventoryCache[cache.inventory.element][cache.inventory.page][cache.inventory.hoverSlot] then
			func.deleteItem(cache.inventory.hoverSlot)
		end
	end
end
bindKey("delete","down",func.deleteItemKey)

setTimer(function()
	if cache.inventory.show and (cache.inventory.page == "vehicle" or cache.inventory.page == "object") then
		if cache.inventory.element then
			local playerX,playerY,playerZ = getElementPosition(localPlayer)
			local targetX,targetY,targetZ = getElementPosition(cache.inventory.element)
			local playerDimension = getElementDimension(localPlayer)
			local targetDimension = getElementDimension(cache.inventory.element)
			local playerInterior = getElementInterior(localPlayer)
			local targetInterior = getElementInterior(cache.inventory.element)
			if playerDimension == targetDimension and playerInterior == targetInterior then
				if getDistanceBetweenPoints3D(playerX,playerY,playerZ,targetX,targetY,targetZ) >= 4 then
					if getElementType(cache.inventory.element) == "vehicle" then
						setElementData(cache.inventory.element, "veh:player", nil)
						setElementData(cache.inventory.element, "veh:use", false)
						triggerServerEvent("doorState", localPlayer, cache.inventory.element, 0)
					end
					if (tostring(getElementType(cache.inventory.element))=="object") then
						if getElementModel(cache.inventory.element) == 2332 then
							setElementData(cache.inventory.element,"safe:use",false)
							setElementData(cache.inventory.element,"safe:player",nil)
							setElementData(localPlayer,"player:safe",false)

						end
					end

					--triggerServerEvent("getItems",localPlayer,localPlayer,2)
					inventoryCache[localPlayer] = playerCache[localPlayer]
					cache.inventory.element = localPlayer
					cache.inventory.show = false;
					cache.inventory.page = "bag";
					cache.inventory.currentpage = 1;
					removeEventHandler("onClientRender",getRootElement(),func.render);

					setElementData(localPlayer,"show:inv",nil)
					destroyElement(cache.inventory.gui);
					if cache.inventory.itemMove then
						cache.inventory.itemMove = false;
						cache.inventory.movedSlot = -1;
					end
				end
			end
		end
	end
end,200,0)

local paperW, paperH = 399, 527
local paperX, paperY = sx/2 - paperW/2, sy/2 - paperH/2
--[[
addEventHandler("onClientRender", getRootElement(), function()
	dxDrawImage(paperX, paperY, paperW, paperH, "files/page.png")
	local startY = paperY + 25
	local startX = paperX + 67
	for i = 1, 20 do
		dxDrawLine(startX, startY, startX + 330, startY, tocolor(30,106,217,255), 2)
		startY = startY + 25
	end
end)]]


local lastSound = nil
local buttonPos = {}

func.render = function()
	cache.inventory.cursorInSlot = false
	cache.inventory.cursorInInv = false
	cache.inventory.hoverSlot = -1
	cache.inventory.hoverItem = nil
	--
	if cache.inventory.show then

		if inventoryAnimationState == "open" then
			inventoryAlpha = interpolateBetween(inventoryAlpha, 0, 0, 1, 0, 0, (getTickCount() - inventoryAnimationTick) / 250, "Linear")
		else
			inventoryAlpha = interpolateBetween(inventoryAlpha, 0, 0, 0, 0, 0, (getTickCount() - inventoryAnimationTick) / 250, "Linear")
		end

		local drawRow = 0
		local drawColumn = 0

		if cache.inventory.moving then
			if isCursorShowing() then
				local cursorX,cursorY = func.getCursorPosition()
				pos[1] = cursorX - cache.inventory.defX
				pos[2] = cursorY - cache.inventory.defY
			else
				cache.inventory.moving = false
			end
		end

		--háttér
		dxDrawRectangle(pos[1],pos[2]-30,width,height+30,tocolor(30, 30, 30,255 * inventoryAlpha))
		dxDrawRectangle(pos[1] - 2,pos[2]-30 - 2,width + 4,height+30 + 4,tocolor(30, 30, 30,150 * inventoryAlpha))
		if func.inBox(pos[1],pos[2]-30,width,height+30) then
			cache.inventory.cursorInInv = true;
		end

		if cache.inventory.page == "bag" or cache.inventory.page == "key" or cache.inventory.page == "licens" then
			for i = 1, 3 do
				if func.inBox(pos[1]+(i*30) - 25,pos[2] - 27,25, 25) or pages[i].page == cache.inventory.page then
					dxDrawImage(pos[1]+(i*30) - 25,pos[2] - 27,25, 25,pages[i].img,0,0,0,tocolor(r, g, b, 255*inventoryAlpha));
				else
					dxDrawImage(pos[1]+(i*30) - 25,pos[2] - 27,25, 25,pages[i].img,0,0,0,tocolor(255, 255, 255, 200 * inventoryAlpha));
				end
			end
			dxDrawText(pages[cache.inventory.currentpage].name,pos[1],pos[2],pos[1]+width,pos[2]-27,tocolor(255, 255, 255, 255*inventoryAlpha),1, font:getFont("condensed", 12),"center","center");
		elseif cache.inventory.page == "object" then
			dxDrawImage(pos[1]+30 - 25,pos[2] - 27,25, 25,pages[4].img,0,0,0,tocolor(255, 255, 255, 255*inventoryAlpha));
			dxDrawText(pages[4].name,pos[1],pos[2],pos[1]+width,pos[2]-27,tocolor(255, 255, 255, 255*inventoryAlpha),1, font:getFont("condensed", 12),"center","center");
		elseif cache.inventory.page == "vehicle" then
			dxDrawImage(pos[1]+30 - 25,pos[2] - 27,25, 25,pages[5].img,0,0,0,tocolor(255, 255, 255, 255*inventoryAlpha));
			dxDrawText(pages[5].name,pos[1],pos[2],pos[1]+width,pos[2]-27,tocolor(255, 255, 255, 255*inventoryAlpha),1, font:getFont("condensed", 12),"center","center");
		end

		dxDrawRectangle(pos[1],pos[2] + height + 6, width, 20,tocolor(30, 30, 30, 255 * inventoryAlpha))
		dxDrawRectangle(pos[1] - 2,pos[2] + height + 6 - 2, width + 4, 20 + 4,tocolor(30, 30, 30, 150 * inventoryAlpha))

		local itemWeight = getAllItemWeight()
		if itemWeight > 0 then
			local actualweight = math.min(math.ceil(itemWeight)/getTypeElement(cache.inventory.element)[3], 1);

			dxDrawRectangle(pos[1],pos[2] + height + 6, width * actualweight, 20,tocolor(r, g, b, 200 * inventoryAlpha))
		end
		dxDrawText(math.ceil(itemWeight).."/"..getTypeElement(cache.inventory.element)[3].." kg",pos[1] - 2,pos[2] + height + 6 - 2, pos[1] + width, pos[2] + height + 6 + 24,tocolor(255,255,255,110 * inventoryAlpha), 1, font:getFont("condensed", 10),"center","center");

			if cache.inventory.itemMove then
				if func.inBox(pos[1] + width/2 - 40,pos[2] - 80,80,38) then
					dxDrawImage(pos[1] + width/2 - 40,pos[2] - 80,80,38,"files/images/icons/eye.png",0,0,0,tocolor(r, g, b, 255 * inventoryAlpha))
				else
					dxDrawImage(pos[1] + width/2 - 40,pos[2] - 80,80,38,"files/images/icons/eye.png",0,0,0, tocolor(255, 255, 255, 255 * inventoryAlpha))
				end
			end

			dxDrawRectangle(pos[1]+width - 88,pos[2]-27,86,25,tocolor(35,35,35,255*inventoryAlpha))
			if #guiGetText(cache.inventory.gui) > 0 then
				dxDrawText(guiGetText(cache.inventory.gui),pos[1]+width-88+5,pos[2]-27,pos[1]+width-88+86,pos[2]-27+25,tocolor(255,255,255,255*inventoryAlpha), 1, font:getFont("condensed", 11), "left", "center");

				if cache.inventory.editing then
					dxDrawRectangle(pos[1]+width-88+2+5 +dxGetTextWidth(guiGetText(cache.inventory.gui),1, font:getFont("condensed", 11)),pos[2]-23,2,14,tocolor(230,230,230,cache.inventory.alpha*inventoryAlpha))
				end
			else
				if not cache.inventory.editing then
					dxDrawText("Stack",pos[1]+width-88+5,pos[2]-27,pos[1]+width-88+86,pos[2]-27+25,tocolor(255,255,255,100*inventoryAlpha), 1, font:getFont("condensed", 11), "left", "center");
				else
					dxDrawRectangle(pos[1]+width-88+2+5 +dxGetTextWidth(guiGetText(cache.inventory.gui),1, font:getFont("condensed", 11)),pos[2]-23,2,14,tocolor(230,230,230,cache.inventory.alpha*inventoryAlpha))
				end
			end

			cache.inventory.usedSlots = 0
			for i = 1, row * column do
				local left = pos[1] + drawColumn * (itemSize + margin) + margin;
				local top = pos[2] + drawRow * (itemSize + margin) + margin;
				local hover = func.inBox(left,top,itemSize,itemSize)
				if hover then
					cache.inventory.cursorInSlot = true
					cache.inventory.hoverSlot = i
				end

				if hover then
					dxDrawRectangle(left,top,itemSize,itemSize,tocolor(35,35,35,200*inventoryAlpha))
				else
					dxDrawRectangle(left,top,itemSize,itemSize,tocolor(35,35,35,100*inventoryAlpha))
				end

				if inventoryCache[cache.inventory.element] and inventoryCache[cache.inventory.element][cache.inventory.page] and inventoryCache[cache.inventory.element][cache.inventory.page][i] and inventoryCache[cache.inventory.element][cache.inventory.page][i]["item"] then
					cache.inventory.usedSlots = cache.inventory.usedSlots+1
					local id = inventoryCache[cache.inventory.element][cache.inventory.page][i]["id"]
					local item = inventoryCache[cache.inventory.element][cache.inventory.page][i]["item"]
					local value = inventoryCache[cache.inventory.element][cache.inventory.page][i]["value"]
					local count = inventoryCache[cache.inventory.element][cache.inventory.page][i]["count"]
					local state = inventoryCache[cache.inventory.element][cache.inventory.page][i]["state"]
					local weaponserial = inventoryCache[cache.inventory.element][cache.inventory.page][i]["weaponserial"]
					local pp = inventoryCache[cache.inventory.element][cache.inventory.page][i]["pp"]
					local warn = inventoryCache[cache.inventory.element][cache.inventory.page][i]["warn"]
					if hover then
						cache.inventory.sound.selected = i
						cache.inventory.hoverItem = inventoryCache[cache.inventory.element][cache.inventory.page][i]
						cache.inventory.moveX = left
						cache.inventory.moveY = top
						if cache.inventory.movedSlot ~= i then
							if getElementData(localPlayer,"user:aduty") and getElementData(localPlayer, "user:admin") >= 5 then
								func.toolTip(getItemName(item,value)..color, " [sql id: "..id.." itemid: "..item.."]","#ffffff"..tostring(value));
							else
								func.toolTip(unpack(getItemTooltip(id,item,value,count,state,weaponserial,pp,warn)));
							end

							if not (lastSound == i) then
								lastSound = i;
							end
						end
					end

					if cache.inventory.movedSlot == i then
						local actualamount = guiGetText(cache.inventory.gui);
						if actualamount ~= "" or #actualamount > 0 then
							if count > tonumber(actualamount) then
								dxDrawImage(left,top,itemSize,itemSize,cache.inventory.textures.item[item]);
								dxDrawText(count- tonumber(actualamount), left, top, left+itemSize-1, top+itemSize,tocolor(0,0,0,255*inventoryAlpha), 0.8, font:getFont("condensed", 10),"right","bottom")
								dxDrawText(count- tonumber(actualamount), left, top, left+itemSize-2, top+itemSize-1,tocolor(255,255,255,255*inventoryAlpha), 0.8, font:getFont("condensed", 10),"right","bottom")
							end
						end
					else
						if (state == 2) then
							if fileExists("files/items/"..item.."_2.png") then
								dxDrawImage(left,top,itemSize,itemSize,'files/items/'..item..'_2.png', 0, 0, 0, tocolor(255, 255, 255, 255 * inventoryAlpha));
							else
								dxDrawImage(left,top,itemSize,itemSize,cache.inventory.textures.item[item], 0, 0, 0, tocolor(255, 255, 255, 255 * inventoryAlpha));
							end
						elseif ((tonumber(value) or 1) >= 2) then
							dxDrawImage(left,top,itemSize,itemSize,getItemImage(item, value), 0, 0, 0, tocolor(255, 255, 255, 255 * inventoryAlpha));
						else
							dxDrawImage(left,top,itemSize,itemSize,getItemImage(item, value), 0, 0, 0, tocolor(255, 255, 255, 255 * inventoryAlpha));
						end

                    	dxDrawText(count, left, top, left+itemSize-1, top+itemSize,tocolor(0,0,0,255*inventoryAlpha), 0.8, font:getFont("condensed", 10),"right","bottom")
						dxDrawText(count, left, top, left+itemSize-2, top+itemSize-1,tocolor(255,255,255,255*inventoryAlpha), 0.8, font:getFont("condensed", 10),"right","bottom")

						if (getTypeElement(cache.inventory.element,tonumber(item))[1] == "bag" and (cache.inventory.active.weapon == i or cache.inventory.active.ammo == i or cache.inventory.active.phone == i or cache.inventory.active.goggle == i)) or (getTypeElement(cache.inventory.element,tonumber(item))[1] == "licens" and (cache.inventory.active.card == i or cache.inventory.active.identity == i or cache.inventory.active.badge == i)) then
							dxDrawImage(left,top,itemSize,itemSize,"files/activeItem.png",0,0,0,tocolor(r, g, b, 180*inventoryAlpha))
						end
					end
				end

				drawColumn = drawColumn + 1;
				if (drawColumn == column) then
					drawColumn = 0;
					drawRow = drawRow + 1;
				end
			end

		if cache.inventory.itemMove then
			if isCursorShowing() then
				local x, y = func.getCursorPosition()
				moveX,moveY = x - cache.inventory.defX,y - cache.inventory.defY
			else
				moveX,moveY = 0,0
				if cache.inventory.itemMove then
					cache.inventory.itemMove = false
					cache.inventory.movedSlot = -1
				end
			end
			dxDrawImage(moveX,moveY,itemSize,itemSize,getItemImage(cache.inventory.movedItem["item"],cache.inventory.movedItem["value"]),0,0,0,tocolor(255,255,255,255*inventoryAlpha),true);

			local count = cache.inventory.movedItem["count"];
			if #guiGetText(cache.inventory.gui) > 0 then
				count = guiGetText(cache.inventory.gui);
			end

			if tonumber(guiGetText(cache.inventory.gui)) == 0 then
				count = "";
			end

			if #guiGetText(cache.inventory.gui) > 0 and tonumber(guiGetText(cache.inventory.gui)) > cache.inventory.movedItem["count"] then
				count = cache.inventory.movedItem["count"];
			end

    	    dxDrawText(count, moveX, moveY, moveX+itemSize-1, moveY+itemSize,tocolor(0,0,0,255*inventoryAlpha), 0.8, font:getFont("condensed", 10),"right","bottom",false,false,true)
			dxDrawText(count, moveX, moveY, moveX+itemSize-2, moveY+itemSize-1,tocolor(255,255,255,255*inventoryAlpha), 0.8, font:getFont("condensed", 10),"right","bottom",false,false,true)
		end

	else
		if cache.inventory.itemMove then
			cache.inventory.itemMove = false
			cache.inventory.movedSlot = -1
		end
	end
end

local isCameraShake = false
local shakeTimer = false

addEventHandler("onClientResourceStart",getResourceRootElement(getThisResource()), function()
	if (getElementData(localPlayer, "char:alcoholLevel") or 0) > 15 then
		setTimer(function()
			drunkenLevel = getElementData(localPlayer, "char:alcoholLevel")/10
			--outputChatBox("asd")
			processDrunkRender()

		end,1500,1)

	end
end)

function addDrunkenLevel(amount)
	drunkenLevel = drunkenLevel + amount

	processDrunkRender()

--	setTimer(removeDrunkenLevel, 30000, 1, 2, 30000)
end

function removeDrunkenLevel(amount, renderTime)
	drunkenLevel = drunkenLevel - amount

	if drunkenLevel < 0 then
		drunkenLevel = 0
	end

	processDrunkRender()

	if renderTime and drunkenLevel > 0 then
	--	setTimer(removeDrunkenLevel, renderTime, 1, 2, renderTime)
	end
end

local processWalkStyle = false

walkingStyles = {0, 54, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138}

addEventHandler("onClientElementDataChange", getRootElement(), function(dataName, newValue, oldValue)
	if getElementType(source) == "player" and source == localPlayer then
		if dataName == "char:alcoholLevel" then
			--print(drunkenLevel)
			if getElementData(source, dataName) > 15 then
				oldWalkStyle = getElementData(source, "char:walkStyle");
				addDrunkenLevel(getElementData(source, dataName)/10)
				if getElementData(source, dataName) >= 50 then
					processWalkStyle = true
					triggerServerEvent("setPedWalkStyle", localPlayer, localPlayer, 126);
				elseif getElementData(source, dataName) < 50 then
					if processWalkStyle then
						triggerServerEvent("setPedWalkStyle", localPlayer, localPlayer, walkingStyles[oldWalkStyle]);
						processWalkStyle = false
						setAnalogControlState("vehicle_left", 0)
						setAnalogControlState("vehicle_right", 0)
					   	toggleControl("vehicle_left", true)
					   	toggleControl("vehicle_right", true)
					end
				end
			elseif getElementData(source, dataName) <= 15 then
				drunkenLevel = 0
				processDrunkRender()
				setCameraShakeLevel(0)

			elseif newValue ~= oldValue then
				removeDrunkenLevel(math.random(1,4))
				--processDrunkRender()
			end
		end
	end
end)



function processDrunkRender()
	if drunkenLevel > 0 then
		if not drunkHandled then
			drunkHandled = true
			addEventHandler("onClientHUDRender", getRootElement(), drunkenRender, true, "low-999")

			drunkenScreenSource = dxCreateScreenSource(sx, sy)
		end
	else
		if drunkHandled then
			drunkHandled = false
			removeEventHandler("onClientHUDRender", getRootElement(), drunkenRender)

			if isElement(drunkenScreenSource) then
				destroyElement(drunkenScreenSource)
			end
		end

		if fuckControlsDisabledControl then
			setAnalogControlState("vehicle_left", 0)
     		setAnalogControlState("vehicle_right", 0)
			toggleControl("vehicle_left", true)
			toggleControl("vehicle_right", true)
     		fuckControlsDisabledControl = false
		end
	end
end

function drunkenRender()
	if getElementData(localPlayer, "user:aduty") then
		return
	end
	if isElement(drunkenScreenSource) then
		dxUpdateScreenSource(drunkenScreenSource, true)
	--	dxSetBlendMode("modulate_add")
	end

	local currentTick = getTickCount()
	local elapsedTime = currentTick - fuckControlsChangeTick

		if elapsedTime >= 3000 then
			fuckControlsChangeTick = currentTick
			elapsedTime = 0
			drunkenScreenFlickeringState = not drunkenScreenFlickeringState
			if getElementData(localPlayer, "char:alcoholLevel") > 50 then
				if fuckControlsDisabledControl then
					setAnalogControlState("vehicle_left", 0)
					setAnalogControlState("vehicle_right", 0)
					toggleControl("vehicle_left", true)
					toggleControl("vehicle_right", true)
					fuckControlsDisabledControl = false
				end

				if math.random(5) <= 3 then
					toggleControl("vehicle_left", false)
					toggleControl("vehicle_right", false)
					fuckControlsDisabledControl = true

					if math.random(10) <= 5 then
						setAnalogControlState("vehicle_left", 1)
					else
						setAnalogControlState("vehicle_right", 1)
					end
				end
			end
			--if getElementData(localPlayer, dataName) == 0 then
			--	setCameraShakeLevel(getElementData(localPlayer, "char:alcoholLevel"))
		--	end
		end

	local progress = elapsedTime / 3000
	local flickerOffsetX = 0
	local flickerOffsetY = 0

	if drunkenScreenFlickeringState then
		flickerOffsetX, flickerOffsetY = interpolateBetween(0, 0, 0, -drunkenLevel * 5, -drunkenLevel * 5, 0, progress, "OutQuad")
	--	rot = interpolateBetween(-30, 0, 0, 30, 0, 0, progress, "OutQuad")
	else
		flickerOffsetX, flickerOffsetY = interpolateBetween(-drunkenLevel * 5, -drunkenLevel * 5, 0, 0, 0, 0, progress, "OutQuad")
	--	rot = interpolateBetween(30, 0, 0, -30, 0, 0, progress, "OutQuad")
	end




	if isElement(drunkenScreenSource) then
		dxDrawImage(0 - flickerOffsetX, 0 - flickerOffsetY, sx, sy, drunkenScreenSource, 0, 0, 0, tocolor(255, 255, 255, 200))
		dxDrawImage(0 + flickerOffsetX, 0 + flickerOffsetY, sx, sy, drunkenScreenSource, 0, 0, 0, tocolor(255, 255, 255, 200))
	end
end

func.click = function(button,state,absoluteX,absoluteY,worldX,worldY,worldZ,clickedElement)
	if getElementData(localPlayer,"hudVisible") or cache.actionbar.show then
		if button == "left" and state == "down" then
			if cache.actionbar.hover.slot > 0 then
				if not cache.actionbar.itemMove and actionBarCache[cache.actionbar.hover.slot] then
					cache.actionbar.movedSlot = cache.actionbar.hover.slot
					cache.actionbar.movedItem = cache.actionbar.hoverItem
					cache.actionbar.movedInventoryItem = cache.actionbar.hoverInventoryItem
					cache.actionbar.itemMove = true
					local img = cache.actionbar.slot.noitem
					if cache.actionbar.hoverItem then
						img = cache.inventory.textures.item[cache.actionbar.movedInventoryItem["item"]]
					end
					cache.actionbar.slot.movedimg = img
					local curX, curY = func.getCursorPosition()
					local x,y = cache.actionbar.moveX,cache.actionbar.moveY
					cache.actionbar.defX, cache.actionbar.defY = curX - x, curY - y
				end
			end
		elseif button == "left" and state == "up" then
			if cache.actionbar.itemMove then

				if cache.actionbar.hover.slot > 0 then
					if cache.actionbar.movedSlot ~= cache.actionbar.hover.slot and not actionBarCache[cache.actionbar.hover.slot] then
						triggerServerEvent("updateActionBarItemSlot",localPlayer,localPlayer,cache.actionbar.movedSlot,cache.actionbar.hover.slot)
						playSound("files/sounds/move.mp3")
						actionBarCache[cache.actionbar.hover.slot] = actionBarCache[cache.actionbar.movedSlot]
						actionBarCache[cache.actionbar.movedSlot] = nil
					end
				else
					if not cache.actionbar.cursorInSlot then
						triggerServerEvent("deleteActionBarItem",localPlayer,localPlayer,cache.actionbar.movedSlot)
						playSound("files/sounds/select.mp3")
						actionBarCache[cache.actionbar.movedSlot] = nil
					end
				end

				cache.actionbar.itemMove = false
				cache.actionbar.movedSlot = -1
			end
		end
	end

	if cache.inventory.show then
		if button == "left" and state == "down" then
			if getElementType(cache.inventory.element) == "player" then
				if cache.inventory.page == "bag" or cache.inventory.page == "key" or cache.inventory.page == "licens" then
					for i = 1, 3 do
						if func.inBox(pos[1]+(i*30) - 25,pos[2] - 27,25, 25) then
							if pages[i].page ~= cache.inventory.page then
								cache.inventory.page = pages[i].page;
								cache.inventory.currentpage = i;
								playSound("files/sounds/bincoselect.mp3")
							end
						end
					end
					if cache.inventory.itemMove then
						cache.inventory.itemMove = false
						cache.inventory.movedSlot = -1
					end
				end
			end

			if func.inBox(pos[1],pos[2] - 30,width,30) and not cache.inventory.moving and not func.inBox(pos[1]+width-102,pos[2]-42,86,30) then
				cache.inventory.moving = true
				local cursorX, cursorY = func.getCursorPosition()
				local x,y = pos[1],pos[2]
				cache.inventory.defX, cache.inventory.defY = cursorX - x, cursorY - y
			end

			if cache.inventory.page ~= "craft" then
				if func.inBox(pos[1]+width-102,pos[2]-42,86,30) then
					if guiEditSetCaretIndex(cache.inventory.gui, string.len(guiGetText(cache.inventory.gui))) then
						guiBringToFront(cache.inventory.gui)
						if not cache.inventory.editing then
							cache.inventory.editing = true
						end
					end
				else
					if cache.inventory.editing then
						cache.inventory.editing = false
					end
				end
			end

			if cache.inventory.hoverSlot > 0 and cache.inventory.hoverItem and not cache.inventory.itemMove then
			--	if cache.inventory.hoverItem["item"] == 125 then
			--		outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."Ezt a tárgyat nem mozgathatod.",220,20,60,true)
			--	else
					if (getTypeElement(cache.inventory.element,cache.inventory.hoverItem["item"])[1] == "bag" and (cache.inventory.active.weapon == cache.inventory.hoverSlot or cache.inventory.active.ammo == cache.inventory.hoverSlot or cache.inventory.active.phone == cache.inventory.hoverSlot or cache.inventory.active.goggle == cache.inventory.hoverSlot )) or (getTypeElement(cache.inventory.element,cache.inventory.hoverItem["item"])[1] == "licens" and (cache.inventory.active.card == cache.inventory.hoverSlot or cache.inventory.active.identity == cache.inventory.hoverSlot or cache.inventory.active.badge == cache.inventory.hoverSlot)) then
						outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."A kiválasztott tárgy használatban van.",220,20,60,true)
					else
						cache.inventory.movedSlot = cache.inventory.hoverSlot
						cache.inventory.movedItem = cache.inventory.hoverItem
						cache.inventory.itemMove = true
						local cursorX,cursorY = func.getCursorPosition()
						local x,y = cache.inventory.moveX,cache.inventory.moveY
						cache.inventory.defX,cache.inventory.defY = cursorX - x, cursorY - y
					end
			--	end
			end

		elseif button == "left" and state == "up" then
			--worldInteract(worldX,worldY,worldZ)
			--outputChatBox("ad")
			--outputChatBox(getElementType(clickedElement))
			if cache.inventory.moving then
				cache.inventory.moving = false;
			end

			if cache.inventory.itemMove then
				if cache.craft.hoverSlot > 0 then
					if not craftItems[cache.craft.hoverSlot] then
						craftItems[cache.craft.hoverSlot] = {
							item = cache.inventory.movedItem.item,
							slot = cache.craft.hoverSlot,
							count = 1,
							itemdbid = cache.inventory.movedItem.id,
						};
					end
				elseif cache.actionbar.hover.slot > 0 then
					if cache.inventory.page == "bag" or cache.inventory.page == "key" or cache.inventory.page == "licens" then
						if not actionBarCache[cache.actionbar.hover.slot] then
							actionBarCache[cache.actionbar.hover.slot] = {cache.inventory.movedItem["id"],cache.inventory.movedItem["item"],cache.inventory.page}
							triggerServerEvent("moveItemToActionBar",localPlayer,localPlayer,cache.actionbar.hover.slot,actionBarCache[cache.actionbar.hover.slot])
							playSound("files/sounds/move.mp3")

						end
					end
				else
					if cache.inventory.hoverSlot > 0 then
						if not cache.inventory.hoverItem then
							local amount = guiGetText(cache.inventory.gui)
							if amount == "" then
								if not inventoryCache[cache.inventory.element][getTypeElement(cache.inventory.element,cache.inventory.movedItem["item"])[1]][cache.inventory.hoverSlot] then
									playSound("files/sounds/move.mp3")
									func.updateSlot(cache.inventory.movedSlot,cache.inventory.hoverSlot,cache.inventory.movedItem)
								else
									outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."A kiválasztott sloton, már van egy tárgy.",220,20,60,true)
								end
							else
								amount = tonumber(amount) or 0;
								if amount > 0 then
									if cache.inventory.movedItem["count"] == amount then
										if not inventoryCache[cache.inventory.element][getTypeElement(cache.inventory.element,cache.inventory.movedItem["item"])[1]][cache.inventory.hoverSlot] then
											func.updateSlot(cache.inventory.movedSlot,cache.inventory.hoverSlot,cache.inventory.movedItem)
											playSound("files/sounds/move.mp3")
										else
											outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."A kiválasztott sloton, már van egy tárgy.",220,20,60,true)
										end
									else
										if cache.inventory.movedItem["count"] >= amount then
											if not inventoryCache[cache.inventory.element][getTypeElement(cache.inventory.element,cache.inventory.movedItem["item"])[1]][cache.inventory.hoverSlot] then
												func.createStackedItem(cache.inventory.hoverSlot, cache.inventory.movedItem, amount);
												func.setItemCount(cache.inventory.movedSlot,cache.inventory.movedItem["count"] - amount);
												playSound("files/sounds/move.mp3")
											else
												outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."A kiválasztott sloton, már van egy tárgy.",220,20,60,true)
											end
										end
									end
								end
							end
						else
							if cache.inventory.hoverSlot ~= cache.inventory.movedSlot and cache.inventory.movedItem["item"] == cache.inventory.hoverItem["item"] and cache.inventory.movedItem["duty"] == cache.inventory.hoverItem["duty"] and getItemStackable(cache.inventory.hoverItem["item"]) and cache.inventory.movedItem["state"] == cache.inventory.hoverItem["state"] and cache.inventory.movedItem["pp"] == cache.inventory.hoverItem["pp"] then
								local amount = guiGetText(cache.inventory.gui)
								if amount == "" then
									func.setItemCount(cache.inventory.hoverSlot,cache.inventory.hoverItem["count"]+cache.inventory.movedItem["count"])
									func.deleteItem(cache.inventory.movedSlot)
									playSound("files/sounds/move.mp3")
								else
									amount = tonumber(amount) or 0;
									if cache.inventory.movedItem["count"] >= amount then
										func.setItemCount(cache.inventory.hoverSlot,cache.inventory.hoverItem["count"]+amount)
										func.setItemCount(cache.inventory.movedSlot,cache.inventory.movedItem["count"]-amount)
										playSound("files/sounds/move.mp3")
									end
								end
							end
						end
					else
						if func.inBox(pos[1] + width/2 - 40,pos[2] - 80,80,38) then
							if cache.inventory.itemMove and cache.inventory.page ~= "craft" then
								if not getElementData(localPlayer,"showitem") then
									local item = cache.inventory.movedItem["item"];
									local value = cache.inventory.movedItem["value"] or "false"

									if weaponCache[item] then
										value = cache.inventory.movedItem["weaponserial"].." ("..cache.inventory.movedItem["state"].."%)"
									elseif item == 1 then
										value = "Telefonszám: "..value
									elseif availableItems[item].eatPercent or availableItems[item].drinkPercent then
										value = cache.inventory.movedItem["state"].." %"
									elseif item == 69 then
										value = value
									elseif item == 65 then
										value = "Név: "..string.sub(value,23):gsub("_", " ").." | Érvényes: "..string.sub(value,9,12).."."..string.sub(value,13,14).."."..string.sub(value,15,16).."-ig"
									elseif item == 66 then
										value = "Név: "..string.sub(value,22):gsub("_", " ").." | Érvényes: "..string.sub(value,9,12).."."..string.sub(value,13,14).."."..string.sub(value,15,16).."-ig"
									elseif item == 68 then
										value = "Név: "..string.sub(value,20):gsub("_", " ").." | Érvényes: "..string.sub(value,9,12).."."..string.sub(value,13,14).."."..string.sub(value,15,16).."-ig"
									else
										value = ""
									end

									chat:sendLocalMeAction("felmutat egy tárgyat: "..getItemName(item,cache.inventory.movedItem["value"])..".");
									setElementData(localPlayer, "inventory:showedItem", {item, cache.inventory.movedItem["value"], value})

									setTimer(function()
										setElementData(localPlayer, "inventory:showedItem", false)
									end, core:minToMilisec(0.5), 1)
								end
							end
						else
							--if exports.bank:getCardPosition() and cache.inventory.active.card == -1 and cache.inventory.movedItem.item == 120 then
							--	exports.bank:setCardDataByItem(cache.inventory.movedItem,cache.inventory.movedSlot);
								---cache.inventory.active.card = cache.inventory.movedSlot;
							--	setActiveSlot(cache.inventory.movedSlot,120,"card")
							--else
								if clickedElement then
									if getElementType(clickedElement) == "player" then
										if getElementData(clickedElement,"user:loggedin") and clickedElement ~= cache.inventory.element then
											if cache.inventory.movedItem["item"] == 44 or cache.inventory.movedItem["item"] == 228 or cache.inventory.movedItem["item"] == 229 then
												outputChatBox(core:getServerPrefix("red-dark", "Inventory", 2).."Ezt az itemet nem adhatod át!", 255, 255, 255, true)
											else
												local playerX,playerY,playerZ = getElementPosition(localPlayer)
												local targetX,targetY,targetZ = getElementPosition(clickedElement)
												local playerDimension = getElementDimension(localPlayer)
												local targetDimension = getElementDimension(cache.inventory.element)
												local playerInterior = getElementInterior(localPlayer)
												local targetInterior = getElementInterior(clickedElement)
												if playerDimension == targetDimension and playerInterior == targetInterior then
													if getDistanceBetweenPoints3D(playerX,playerY,playerZ,targetX,targetY,targetZ) < 4 then
														if cache.inventory.movedItem["duty"] == 0 then
															if getElementData(localPlayer, "playerInAnim") then
																outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."Animba nem tudod át húzni a tárgyat!",220,20,60,true)
																cache.inventory.itemMove = false
																cache.inventory.movedSlot = -1
																return
															end
															if getElementData(clickedElement, "playerInAnim") then
																outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."A kiválasztott játékos animban van így nem tudsz tárgyat átadni neki!",220,20,60,true)
																cache.inventory.itemMove = false
																cache.inventory.movedSlot = -1
																return
															end
															triggerServerEvent("itemTransfer",localPlayer,cache.inventory.element,clickedElement,cache.inventory.movedItem,weaponProgress[cache.inventory.movedSlot] or 0)
															if cache.inventory.movedItem then
																deleteCraftitem(cache.inventory.movedItem.id)
															end
														else
															outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."Szolgálati eszközzel ezt nem teheted meg.",220,20,60,true)
														end
													end
												end
											end

										end
									elseif getElementType(clickedElement) == "vehicle" then
										if getElementData(clickedElement,"veh:id") and getElementData(clickedElement,"veh:id") > 0 and cache.inventory.element == localPlayer then
											if not (getVehicleType(clickedElement) == "BMX") then
												if not getElementData(clickedElement, "renteltcar") then
													if cache.inventory.movedItem["item"] == 44 or cache.inventory.movedItem["item"] == 228 or cache.inventory.movedItem["item"] == 229 then
														outputChatBox(core:getServerPrefix("red-dark", "Inventory", 2).."Ezt az itemet nem teheted be a csomagtartóba!", 255, 255, 255, true)
													else
														local playerX,playerY,playerZ = getElementPosition(localPlayer)
														local targetX,targetY,targetZ = getElementPosition(clickedElement)
														local playerDimension = getElementDimension(localPlayer)
														local targetDimension = getElementDimension(clickedElement)
														local playerInterior = getElementInterior(localPlayer)
														local targetInterior = getElementInterior(clickedElement)
														if playerDimension == targetDimension and playerInterior == targetInterior then
															if getDistanceBetweenPoints3D(playerX,playerY,playerZ,targetX,targetY,targetZ) < 4 then
																if not isVehicleLocked(clickedElement) then
																	if cache.inventory.movedItem["duty"] == 0 then
																		--if cache.inventory.movedItem.item ~= 120 then
																			triggerServerEvent("itemTransfer",localPlayer,cache.inventory.element,clickedElement,cache.inventory.movedItem)
																			if cache.inventory.movedItem then
																				deleteCraftitem(cache.inventory.movedItem.id)
																			end
																		--else
																		--	outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."A kiválasztott tárgyat csak és kizárólag egy másik játékosnak tudod átadni.",220,20,60,true)
																		--end
																	else
																		outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."Szolgálati eszközzel ezt nem teheted meg.",220,20,60,true)
																	end
																else
																	outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."A kiválasztott jármű csomagtartója zárva van.",220,20,60,true)
																end
															end
														end
													end
												end
											end
										end
									elseif getElementType(clickedElement) == "object" then
										--outputChatBox("asd")
										if getElementData(clickedElement, "object:isPrinter") then
											local playerX,playerY,playerZ = getElementPosition(localPlayer)
											local targetX,targetY,targetZ = getElementPosition(clickedElement)
											local playerDimension = getElementDimension(localPlayer)
											local targetDimension = getElementDimension(clickedElement)
											local playerInterior = getElementInterior(localPlayer)
											local targetInterior = getElementInterior(clickedElement)
											local isUsing = getElementData(clickedElement, "printer:isUsing")
											if not isUsing then
												if playerDimension == targetDimension and playerInterior == targetInterior then
													if getDistanceBetweenPoints3D(playerX,playerY,playerZ,targetX,targetY,targetZ) < 4 then
														local data = {}
														local printing = false
														if printerItems[cache.inventory.movedItem["item"]] then
															if printerItems[cache.inventory.movedItem["item"]] == 209 then
																savedValue = cache.inventory.movedItem["value"]
																printerTimer = setTimer(function()
																	if getElementData(clickedElement, "printer:status") >= 175 then
																		setElementData(clickedElement, "printer:status", 0)
																		setElementData(clickedElement, "printer:isUsing", false)
																		giveItem(209, savedValue, 1, 0)
																		savedValue = false
																		--printing = true
																		if isTimer(printerTimer) then
																			killTimer(printerTimer)
																			chat:sendLocalMeAction("kihúzza a lapot a nyomtatóból")
																			triggerServerEvent("printerAnim", localPlayer, localPlayer, false)
																		end
																	end
																end, 500,0)
															else
																data = {}

																--giveItem(209, toJSON({data}), 1, 0)
																if printerItems[cache.inventory.movedItem["item"]] == 1 then
																	data = {printerItems[cache.inventory.movedItem["item"]], string.sub(cache.inventory.movedItem["value"],1, 8), string.sub(cache.inventory.movedItem["value"],9, 16), string.sub(cache.inventory.movedItem["value"],17,19),string.sub(cache.inventory.movedItem["value"],20, 20),string.sub(cache.inventory.movedItem["value"],21, 22),string.sub(cache.inventory.movedItem["value"],23):gsub("_", " "),math.random(-100,100),math.random(-80,80) }
																elseif printerItems[cache.inventory.movedItem["item"]] == 2 then
																	data = {printerItems[cache.inventory.movedItem["item"]], string.sub(cache.inventory.movedItem["value"],1, 8), string.sub(cache.inventory.movedItem["value"],9, 16), string.sub(cache.inventory.movedItem["value"],17,19),string.sub(cache.inventory.movedItem["value"],20, 21),string.sub(cache.inventory.movedItem["value"],20,21),string.sub(cache.inventory.movedItem["value"],22):gsub("_", " "),math.random(-100,100),math.random(-80,80) }
																elseif printerItems[cache.inventory.movedItem["item"]] == 3 then
																	data = {printerItems[cache.inventory.movedItem["item"]], string.sub(cache.inventory.movedItem["value"],1, 8), string.sub(cache.inventory.movedItem["value"],9, 16), string.sub(cache.inventory.movedItem["value"],17,19),024,0,string.sub(cache.inventory.movedItem["value"],20):gsub("_", " "),math.random(-100,100),math.random(-80,80) }
																elseif printerItems[cache.inventory.movedItem["item"]] == 4 then
																	data = {printerItems[cache.inventory.movedItem["item"]], string.sub(cache.inventory.movedItem["value"],1, 8), string.sub(cache.inventory.movedItem["value"],9, 16), string.sub(cache.inventory.movedItem["value"],17,19),0,0,string.sub(cache.inventory.movedItem["value"],20):gsub("_", " "),math.random(-100,100),math.random(-80,80) }
																elseif printerItems[cache.inventory.movedItem["item"]] == 5 then
																	data = {printerItems[cache.inventory.movedItem["item"]], string.sub(cache.inventory.movedItem["value"],1, 8), string.sub(cache.inventory.movedItem["value"],9, 16), string.sub(cache.inventory.movedItem["value"],17),string.sub(cache.inventory.movedItem["value"],20),string.sub(cache.inventory.movedItem["value"],21, 22),string.sub(cache.inventory.movedItem["value"],23):gsub("_", " "),math.random(-100,100),math.random(-80,80) }
																end
																printerTimer = setTimer(function()
																	if getElementData(clickedElement, "printer:status") >= 175 then
																		setElementData(clickedElement, "printer:status", 0)
																		setElementData(clickedElement, "printer:isUsing", false)
																		giveItem(209, toJSON({data}), 1, 0)
																		savedValue = false
																		--printing = true
																		if isTimer(printerTimer) then
																			killTimer(printerTimer)
																			chat:sendLocalMeAction("kihúzza a lapot a nyomtatóból")
																			triggerServerEvent("printerAnim", localPlayer, localPlayer, false)
																		end
																	end
																end, 500,0)
															end
															triggerServerEvent("printerAnim", localPlayer, localPlayer, true, clickedElement)
															chat:sendLocalMeAction("elkezd fénymásolni egy dokumentumot (".. getItemName(cache.inventory.movedItem["item"], cache.inventory.movedItem["value"])..")")

															--outputChatBox(cache.inventory.movedItem["value"])
															setElementData(clickedElement, "printer:isUsing", true)
														else
															outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."Ezt az itemet nem tudod le fénymásolni!",220,20,60,true)
														end
													end
												end
											else
												outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."Ez a nyomtató már használatban van!",220,20,60,true)
											end
										elseif getElementData(clickedElement,"object:dbid") and getElementData(clickedElement,"object:dbid") > 0 then
											if cache.inventory.movedItem["item"] == 44 or cache.inventory.movedItem["item"] == 228 or cache.inventory.movedItem["item"] == 229 then
												outputChatBox(core:getServerPrefix("red-dark", "Inventory", 2).."Ezt az itemet nem teheted be széfbe!", 255, 255, 255, true)
											else
												local playerX,playerY,playerZ = getElementPosition(localPlayer)
												local targetX,targetY,targetZ = getElementPosition(clickedElement)
												local playerDimension = getElementDimension(localPlayer)
												local targetDimension = getElementDimension(clickedElement)
												local playerInterior = getElementInterior(localPlayer)
												local targetInterior = getElementInterior(clickedElement)
												if playerDimension == targetDimension and playerInterior == targetInterior then
													if getDistanceBetweenPoints3D(playerX,playerY,playerZ,targetX,targetY,targetZ) < 4 then
														if getElementModel(clickedElement) == 1359 then
															if cache.inventory.element == localPlayer then
																chat:sendLocalMeAction("kidobott egy tárgyat a szemetesbe. ("..getItemName(cache.inventory.movedItem["item"])..")")

																func.deleteItem(cache.inventory.movedSlot)
															end
														elseif getElementModel(clickedElement) == 2332 then
															if hasItem(54,getElementData(clickedElement,"object:dbid")) then
																if cache.inventory.movedItem["item"] == 54 and tonumber(cache.inventory.movedItem["value"]) == tonumber(getElementData(clickedElement,"object:dbid")) then
																	outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."A széfbe nem rakhatod bele a kulcsát.",220,20,60,true)
																else
																	if cache.inventory.movedItem["duty"] == 0 then
																		--if cache.inventory.movedItem.item ~= 120 then
																			triggerServerEvent("itemTransfer",localPlayer,cache.inventory.element,clickedElement,cache.inventory.movedItem)
																			if cache.inventory.movedItem then
																				deleteCraftitem(cache.inventory.movedItem.id)
																			end
																		--else
																		--	outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."A kiválasztott tárgyat csak és kizárólag egy másik játékosnak tudod átadni.",220,20,60,true)
																		--end
																	else
																		outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."Szolgálati eszközzel ezt nem teheted meg.",220,20,60,true)
																	end
																end
															else
																outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."Nincs kulcsod ehhez a széfhez.",220,20,60,true)
															end
														end
													end
												end
											end
										elseif getElementData(clickedElement, "atm:id") then
											if getElementData(clickedElement, "atm:working") then
												if core:getDistance(localPlayer, clickedElement) < 3.5 then
													if cache.inventory.movedItem.item == 155 then
														exports.oBank:openATM(cache.inventory.movedItem.value, clickedElement)
													end
												end
											end
										elseif getElementData(clickedElement, "drug:isDrugCraftTable") then
											if exports.oDrugs:addItemToCraftTable(clickedElement, cache.inventory.movedItem.item, cache.inventory.movedItem.count) then
												func.deleteItem(cache.inventory.movedSlot)
											end
										end
									elseif getElementType(clickedElement) == "ped" then
										if core:getDistance(clickedElement, localPlayer) <= 3 then
											if not (cache.inventory.page == "object" or cache.inventory.page == "vehicle") then
												if getElementData(clickedElement, "isFisherPed") then
													exports.oMarket:sellFishItem(cache.inventory.movedItem.item, cache.inventory.movedItem.count, cache.inventory.movedItem, getElementData(clickedElement, "fisherPriceMultiplier"))
												elseif getElementData(clickedElement, "isMushroomPed") then
													exports.oMarket:sellMushroomItem(cache.inventory.movedItem.item, cache.inventory.movedItem.count, cache.inventory.movedItem, getElementData(clickedElement, "mushroomPriceMultiplier"))
												elseif getElementData(clickedElement, "isAnimalPed") then
													if exports.oLicenses:playerHasValidLicense(79) then
														exports.oMarket:sellAnimalItem(cache.inventory.movedItem.item, cache.inventory.movedItem.count, cache.inventory.movedItem, getElementData(clickedElement, "animalPriceMultiplier"))
													else
														outputChatBox(core:getServerPrefix("red-dark", "Vadászat", 3).."Nincs nálad érvényes vadászengedély.", 255, 255, 255, true)
													end
												elseif getElementData(clickedElement, "treasureHunt:antiqueStore") then
													if cache.inventory.movedItem.count == 1 then
														if exports.oTreasureHunt:sellAntiqueItem(cache.inventory.movedItem.item, cache.inventory.movedItem.count, cache.inventory.movedItem) then
															func.deleteItem(cache.inventory.movedSlot)
														end
													else
														outputChatBox(core:getServerPrefix("red-dark", "Régiségkereskedő", 3).."Csak akkor adható le ha nincs összestackelve.", 255, 255, 255, true)
													end
												elseif getElementData(clickedElement, "treasureHunt:jewelryStore") then
													if tonumber(cache.inventory.movedItem.value) == 101 or tonumber(cache.inventory.movedItem.value) == 102 or tonumber(cache.inventory.movedItem.value) == 103 or tonumber(cache.inventory.movedItem.value) == 104 or tonumber(cache.inventory.movedItem.value) == 105 then
														local szorzo = 1
														if tonumber(cache.inventory.movedItem.item) == 142 then 
															szorzo = 1.1
														elseif tonumber(cache.inventory.movedItem.item) == 143 then
															szorzo = 1.2
														elseif tonumber(cache.inventory.movedItem.item) == 195 then
															szorzo = 1.3
														elseif tonumber(cache.inventory.movedItem.item) == 196 then
															szorzo = 1.4
														elseif tonumber(cache.inventory.movedItem.item) == 197 then
															szorzo = 1.5  
														elseif tonumber(cache.inventory.movedItem.item) == 198 then
															szorzo = 1.6
														end
														exports.oTreasureHunt:sellJewelryItem(cache.inventory.movedItem.item, cache.inventory.movedItem.count*szorzo*(cache.inventory.movedItem.value - 100), cache.inventory.movedItem)
														func.deleteItem(cache.inventory.movedSlot)
													else
														outputChatBox(core:getServerPrefix("red-dark", "Drágakő kereskedő", 3).."Csak olyan drágakő adható el, amelyet a szakértő felbecsült! (Bayside, piros ikon)", 255, 255, 255, true)
													end
												elseif getElementData(clickedElement, "treasureHunt:jew") then
													if tonumber(cache.inventory.movedItem.item) == 142 or tonumber(cache.inventory.movedItem.item) == 143 or tonumber(cache.inventory.movedItem.item) == 195 or tonumber(cache.inventory.movedItem.item) == 196 or tonumber(cache.inventory.movedItem.item) == 197 or tonumber(cache.inventory.movedItem.item) == 198 then
														if tonumber(cache.inventory.movedItem.value) == 1 then
															if getElementData(localPlayer,"char:money") >= 300 then
																if not getElementData(localPlayer,"jewInProgress") then	
																	setElementData(localPlayer,"jewInProgress",true)
																	outputChatBox("Peter (Drágakő szakértő) mondja: Hmm, szép darab, máris megnézem milyen súlyban lehet...", 255, 255, 255, true)
																	local deletedItemID = tonumber(cache.inventory.movedItem.item) 
																	func.deleteItem(cache.inventory.movedSlot)
																	setElementData(localPlayer, "char:money", getElementData(localPlayer, "char:money")-300)
																	local jewAmount = math.random(101,105)
																	valuesetTimer = setTimer(function()
																		giveItem(tonumber(deletedItemID), tonumber(jewAmount), 1, 0)
																		if jewAmount >= 103 then
																			outputChatBox("Peter (Drágakő szakértő) mondja: Tessék ez egy szép darab volt.", 255, 255, 255, true)
																			setElementData(localPlayer,"jewInProgress",false)
																		else
																			outputChatBox("Peter (Drágakő szakértő) mondja: Nem a legnagyobb, de valaki biztos megveszi.", 255, 255, 255, true)
																			setElementData(localPlayer,"jewInProgress",false)
																		end
																	end, 5000,1)
																else
																	outputChatBox(core:getServerPrefix("red-dark", "Drágakő kereskedő", 3).."Egyszerre csak egyet!", 255, 255, 255, true)
																end
															else
																outputChatBox(core:getServerPrefix("red-dark", "Drágakő kereskedő", 3).."Nincs elegendő pénzed! (300$)", 255, 255, 255, true)
															end
														end
													else
														outputChatBox("Peter (Drágakő szakértő) mondja: Nekem csak drágakövet hozzál...", 255, 255, 255, true)
													end
												elseif getElementData(clickedElement, "lucky:ped") then
													if getElementData(resourceRoot,"lotto_winnercode") then
														if tonumber(cache.inventory.movedItem.item) == 241 then
															if tonumber(cache.inventory.movedItem.value) == tonumber(getElementData(resourceRoot,"lotto_winnercode")) then
																outputChatBox(core:getServerPrefix("green-dark", "Lottózó", 3).."Gratulálunk! Te voltál a szerencsés, aki megnyerte a nyereményt!", 255, 255, 255, true)
																setElementData(localPlayer, "char:money", getElementData(localPlayer, "char:money")+50000)
															else
																outputChatBox(core:getServerPrefix("red-dark", "Lottózó", 3).."Ez most sajnos nem sikerült!", 255, 255, 255, true)
																func.deleteItem(cache.inventory.movedSlot)
															end
														end
													end
												elseif getElementData(clickedElement, "isDrugPed") then
													if exports.oDrugs:addDrugDealerExperience(clickedElement, cache.inventory.movedItem.item, cache.inventory.movedItem.count) then
														func.deleteItem(cache.inventory.movedSlot)
													end
												elseif getElementData(clickedElement, "drugBuyerNPC") then
													if exports.oDrugs:sellDrugItem(clickedElement, cache.inventory.movedItem.item, cache.inventory.movedItem.count) then
														func.deleteItem(cache.inventory.movedSlot)
													end
												elseif getElementData(clickedElement, "ped:prefix") == "Csekk befizetés" then
													if cache.inventory.movedItem.item == 228 or cache.inventory.movedItem.item == 229 then
														local money = tonumber(fromJSON(cache.inventory.movedItem.value)["money|num-only|5"])

														if getElementData(localPlayer, "char:money") >= money then
															triggerServerEvent("ticket > payTicket", root, money, "orfk")
															func.deleteItem(cache.inventory.movedSlot)
															outputChatBox(core:getServerPrefix("green-dark", "Ticket", 3).."Sikeresen befizettél egy bírságot. "..color.." ("..money.."$)", 255, 255, 255, true)
														else
															outputChatBox(core:getServerPrefix("red-dark", "Ticket", 3).."Nincs nálad elegendő pénz. "..color.." ("..money.."$)", 255, 255, 255, true)
														end
													end
												elseif getElementData(clickedElement, "inventory:copyPed") then
													if cache.inventory.movedItem.item == 51 or cache.inventory.movedItem.item == 52 then
														if getElementData(localPlayer, "char:money") >= 500 then
															triggerServerEvent("inventory > copyKey", resourceRoot, cache.inventory.movedItem)
														end
													else
														outputChatBox(core:getServerPrefix("red-dark", "Kulcsmásolás", 3).."Csak kulcsokat másoltathatsz le.", 255, 255, 255, true)
													end
												end
											end
										end
										--outputDebugString("asd")
									end

								end
								--worldItemInteract(worldX,worldY,worldZ, clickedElement)
							--end
						end
					end
				end
				cache.inventory.itemMove = false
				cache.inventory.movedItem = false
				cache.inventory.movedSlot = -1
			end
		end
	end
	if button == "right" and state == "down" then
		if cache.inventory.show and cache.inventory.hoverSlot > 0 and cache.inventory.hoverItem and cache.inventory.element == localPlayer then
			if cache.inventory.itemMove and cache.inventory.movedSlot ~= cache.inventory.hoverSlot then return end
			--print(cache.inventory.hoverSlot)
			func.useItem(cache.inventory.hoverSlot,cache.inventory.hoverItem)
		end
		if clickedElement and cache.actionbar.hover.slot == -1 then
			if getElementType(clickedElement) == "vehicle" then

			elseif getElementType(clickedElement) == "object" then
				if getElementData(clickedElement,"object:dbid") and getElementData(clickedElement,"object:dbid") > 0 and getElementModel(clickedElement) == 2332 then
					local playerX,playerY,playerZ = getElementPosition(localPlayer)
					local targetX,targetY,targetZ = getElementPosition(clickedElement)
					local playerDimension = getElementDimension(localPlayer)
					local targetDimension = getElementDimension(clickedElement)
					local playerInterior = getElementInterior(localPlayer)
					local targetInterior = getElementInterior(clickedElement)
					if playerDimension == targetDimension and playerInterior == targetInterior then
						if getDistanceBetweenPoints3D(playerX,playerY,playerZ,targetX,targetY,targetZ) < 4 then
							if cache.inventory.page ~= getElementType(clickedElement) then
								if cache.inventory.show then
									if func.inBox(pos[1],pos[2]-25,404,252) then
										return
									end
								end
								if cache.inventory.page ~= "object" then
									if hasItem(54,getElementData(clickedElement,"object:dbid")) then
										if not getElementData(clickedElement,"safe:use") then
											if cache.inventory.page ~= "vehicle" then
												if not isTimer(cache.inventory.dummyTimer) then
													cache.inventory.dummyTimer = setTimer(function() killTimer(cache.inventory.dummyTimer) end,2000,1)
													chat:sendLocalMeAction("belenézett egy széfbe.");
													if not cache.inventory.show then
														cache.inventory.gui = guiCreateEdit(-1000,-1000,0,0,"",false)
														guiEditSetMaxLength(cache.inventory.gui,4)
														addEventHandler("onClientGUIChanged", cache.inventory.gui, function(element)
															if element == cache.inventory.gui then
																editText = guiGetText(cache.inventory.gui);
																editText = editText:gsub("[^0-9]", "");

																guiSetText(cache.inventory.gui,editText);
															end
														end, true);
														addEventHandler("onClientRender",getRootElement(),func.render)
														inventoryAnimationState = "open"
														inventoryAnimationTick = getTickCount()
													end
													cache.inventory.show = true
													cache.inventory.page = "object"
													cache.inventory.currentpage = 5;
													cache.inventory.element = clickedElement
													setElementData(localPlayer,"player:safe",clickedElement)
													setElementData(clickedElement, "safe:player", localPlayer)
													setElementData(clickedElement, "safe:use", localPlayer)
													setElementData(localPlayer,"show:inv",clickedElement)
													inventoryCache[clickedElement] = getElementData(clickedElement,"inventory:items");
												end
											end
										else
											outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."A kiválasztott széf használatban van.",220,20,60,true)
										end
									else
										outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."Nincs kulcsod ehhez a széfhez.",220,20,60,true)
									end
								end
							end
						end
					end
				elseif getElementData(clickedElement, "isWorldItem") then
					--outputDebugString("witem")
					if not isPedInVehicle(localPlayer) then
						--if notDropItems[]
						if isTimer(placeTimer) or isTimer(upTimer) then
							outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."Várj egy kicsit!",220,20,60,true)
							return
						end
						local yard = getDistanceBetweenPoints3D(Vector3(getElementPosition(localPlayer)), Vector3(getElementPosition(clickedElement)))
						if yard <= 5 then
							if not func.inBox(pos[1],pos[2]-30,width,height+30) then
								upTimer = setTimer(function() end, 1500, 1)
								triggerServerEvent("deleteWorldItem", localPlayer, localPlayer, clickedElement)
							end
						end
					else
						outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."Járműbe ülve nem veheted fel!",220,20,60,true)
					end
				end
			end
		end
	end
	if cache.inventory.itemlist.show then
		if button == "left" and state == "down" then
			if func.inBox(cache.inventory.itemlist.pos[1]+276,cache.inventory.itemlist.pos[2]+6,16,16) then
				cache.inventory.itemlist.show = false
				removeEventHandler("onClientRender",getRootElement(),func.renderItemlist)
				cache.inventory.itemlist.text = ""
				destroyElement(cache.inventory.itemlist.gui)
			elseif func.inBox(cache.inventory.itemlist.pos[1]+165,cache.inventory.itemlist.pos[2]+cache.inventory.itemlist.box[2]-25,14,14) then
				cache.inventory.itemlist.text = guiGetText(cache.inventory.itemlist.gui)
			elseif func.inBox(cache.inventory.itemlist.pos[1]+75,cache.inventory.itemlist.pos[2]+cache.inventory.itemlist.box[2]-27,217,20) then
				if guiEditSetCaretIndex(cache.inventory.itemlist.gui, string.len(guiGetText(cache.inventory.itemlist.gui))) then
					guiBringToFront(cache.inventory.itemlist.gui)
					cache.inventory.itemlist.edit = true;
				end
			else
				cache.inventory.itemlist.edit = false;
			end
		end
	end
end
addEventHandler("onClientClick",getRootElement(),func.click)

local count = 0
local pictureDatas = {}

--[[function worldItemInteract(worldX, worldY, worldZ, element)
	if cache.inventory.movedItem and cache.inventory.movedItem["item"] and cache.inventory.hoverSlot == -1 then
		--print(element)
		if not element then
			if not func.inBox(pos[1] + width/2 - 40,pos[2] - 80,80,38) then
				if not cache.inventory.cursorInInv then
					if not notDropItems[cache.inventory.movedItem["item"]] --then
						--if isTimer(placeTimer) or isTimer(upTimer) then
							--outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."Várj egy kicsit!",220,20,60,true)
						--	return
						--end
						--if cache.inventory.movedItem["duty"] == 0 then
							--local playerPosX, playerPosY, playerPosZ = getElementPosition(localPlayer)
							--local allowed = true
							--print("yard")
							--count = 0
							--for k,v in ipairs(getElementsByType("object")) do
								--local objectPosX2, objectPosY2, objectPosZ2 = getElementPosition(v)
								--local yard3 = getDistanceBetweenPoints3D(playerPosX, playerPosY, playerPosZ, objectPosX2, objectPosY2, objectPosZ2)
								--if getElementData(v, "isWorldItem") then
									--local objectPosX, objectPosY, objectPosZ = getElementPosition(v)
									--local yard = getDistanceBetweenPoints3D(worldX, worldY, worldZ, objectPosX, objectPosY, objectPosZ)
									--if yard < 100 then
									--	count = count + 1
									--end

									--if yard > 0 and yard <= 1 then
									--	print(yard)
										--allowed = false
										--break
									--end
								--end
							--end
							--print(count)
							--local yard2 = getDistanceBetweenPoints3D(playerPosX, playerPosY, playerPosZ, worldX, worldY, worldZ)
							--if allowed then
								--if yard2 <= 5 then
									--if count < 100 then
										--placeTimer = setTimer(function() end, 1500, 1)
									----	count = 0
									--	triggerServerEvent("placeWorldItem", localPlayer, localPlayer, cache.inventory.movedItem, worldX, worldY, worldZ)
									--else
									--	count = 0
									--	outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."Túl sok lehelyezett item van a környéken! (Max: 100db)",220,20,60,true)
									--end
								--else
									--count = 0
									--outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."Ilyen messzire nem tudod le helyezni!",220,20,60,true)
							--	end
							--else
							--	count = 0
							--	outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."A közelbe már van item lerakva!",220,20,60,true)
							--end
						--else
							--count = 0
							--outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."Duty itemet nem tudsz a földre húzni!",220,20,60,true)
					--	end
					--else
						--count = 0
					--	outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."Ezt az itemet nem tudod lerakni a földre!",220,20,60,true)
					--end
				--end
			--end
		--end
	--end
--end



worldNotePad = {
	--[1] = {1752.7478027344,-1137.6931152344,47.395721435547, 1}
}

--function worldInteract(wx,wy,wz)
	--outputChatBox(cache.inventory.movedItem["item"])
	--if cache.inventory.movedItem and cache.inventory.movedItem["item"] and cache.inventory.hoverSlot == -1 then
		--if printerItems[cache.inventory.movedItem["item"]] then
			--local pos = Vector3(wx, wy, wz)
			--if getDistanceBetweenPoints3D(pos, localPlayer.position) <= 5 then
				--outputChatBox(wx .. "," ..wy.."," ..wz)
				--table.insert(worldNotePad, {wx,wy,wz, 1})
			--end
		--else
			--outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."Ezt az itemet nem tudod ki tenni!",220,20,60,true)
		--end
	--end
--end


function openVehicleInventory(vehicle)
	if getElementData(vehicle,"veh:id") and getElementData(vehicle,"veh:id") > 0 then
		local playerX,playerY,playerZ = getElementPosition(localPlayer)
		local targetX,targetY,targetZ = getElementPosition(vehicle)
		local playerDimension = getElementDimension(localPlayer)
		local targetDimension = getElementDimension(vehicle)
		local playerInterior = getElementInterior(localPlayer)
		local targetInterior = getElementInterior(vehicle)
		if playerDimension == targetDimension and playerInterior == targetInterior then
			if getDistanceBetweenPoints3D(playerX,playerY,playerZ,targetX,targetY,targetZ) < 4 then
				if cache.inventory.page ~= getElementType(vehicle) then
					if cache.inventory.show then
						if func.inBox(pos[1],pos[2]-25,404,252) then
							return
						end
					end
					if not isVehicleLocked(vehicle) then
						if not getElementData(vehicle, "veh:locked") then
							if not isPedInVehicle(localPlayer) then
								if not getElementData(vehicle,"veh:use") then
									if cache.inventory.page ~= "object" then
										if not isTimer(cache.inventory.dummyTimer) then
											cache.inventory.dummyTimer = setTimer(function() killTimer(cache.inventory.dummyTimer) end,2000,1)
											chat:sendLocalMeAction("belenézett egy jármű csomagtartójába.");
											if not cache.inventory.show then
												cache.inventory.gui = guiCreateEdit(-1000,-1000,0,0,"",false)
												guiEditSetMaxLength(cache.inventory.gui,4)
												addEventHandler("onClientGUIChanged", cache.inventory.gui, function(element)
													if element == cache.inventory.gui then
														editText = guiGetText(cache.inventory.gui);
														editText = editText:gsub("[^0-9]", "");

														guiSetText(cache.inventory.gui,editText);
													end
												end, true);
												addEventHandler("onClientRender",getRootElement(),func.render)

												inventoryAnimationState = "open"
												inventoryAnimationTick = getTickCount()

												cache.inventory.show = true
											end
											cache.inventory.show = true
											cache.inventory.page = "vehicle"
											cache.inventory.currentpage = 6;
											cache.inventory.element = vehicle
											setElementData(vehicle, "veh:player", localPlayer)
											setElementData(vehicle, "veh:use", true)
											setElementData(localPlayer,"show:inv",vehicle)
											triggerServerEvent("doorState",localPlayer,vehicle,1)
											--triggerServerEvent("getItems",localPlayer,clickedElement,1)
											inventoryCache[vehicle] = getElementData(vehicle,"inventory:items");
										end
									end
								else
									outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."A kiválasztott jármű csomagtartója használatban van.",220,20,60,true)
								end
							end
						end
					else
						outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."A kiválasztott jármű csomagtartója zárva van.",220,20,60,true)
					end
				end
			end
		end
	end
end

func.vehicleEnter = function(thePlayer, seat)
    if thePlayer == getLocalPlayer() then
        if cache.inventory.show and cache.inventory.page == "vehicle" then
			--triggerServerEvent("getItems",localPlayer,localPlayer,2)
			inventoryCache[localPlayer] = playerCache[localPlayer]
			cache.inventory.element = localPlayer
			cache.inventory.show = false;
			cache.inventory.page = "bag";
			cache.inventory.currentpage = 1;
			removeEventHandler("onClientRender",getRootElement(),func.render);
			setElementData(source, "veh:player", nil)
			setElementData(source, "veh:use", false)
			triggerServerEvent("doorState", localPlayer, source, 0)
			destroyElement(cache.inventory.gui);
			if cache.inventory.itemMove then
				cache.inventory.itemMove = false;
				cache.inventory.movedSlot = -1;
			end
		end
    end
end
addEventHandler("onClientVehicleEnter", getRootElement(),func.vehicleEnter)

function getAllItemWeight()
	local bagWeight = 0
	local keyWeight = 0
	local licensWeight = 0
	local vehWeight = 0
	local objectWeight = 0
	if isElement(cache.inventory.element) then
		if getElementType(cache.inventory.element) == "player" then
			if not inventoryCache[cache.inventory.element] then
				inventoryCache[cache.inventory.element] = {};
			end
			if inventoryCache[cache.inventory.element]["bag"] then
				for i = 1, row * column do
					if (inventoryCache[cache.inventory.element]["bag"][i] and inventoryCache[cache.inventory.element]["bag"][i]["item"]) then
						bagWeight = bagWeight + (getItemWeight(inventoryCache[cache.inventory.element]["bag"][i]["item"]) * inventoryCache[cache.inventory.element]["bag"][i]["count"])
					end
				end
			end
			if inventoryCache[cache.inventory.element]["key"] then
				for i = 1, row * column do
					if (inventoryCache[cache.inventory.element]["key"][i] and inventoryCache[cache.inventory.element]["key"][i]["item"]) then
						keyWeight = keyWeight + (getItemWeight(inventoryCache[cache.inventory.element]["key"][i]["item"]) * inventoryCache[cache.inventory.element]["key"][i]["count"])
					end
				end
			end
			if inventoryCache[cache.inventory.element]["licens"] then
				for i = 1, row * column do
					if (inventoryCache[cache.inventory.element]["licens"][i] and inventoryCache[cache.inventory.element]["licens"][i]["item"]) then
						licensWeight = licensWeight + (getItemWeight(inventoryCache[cache.inventory.element]["licens"][i]["item"]) * inventoryCache[cache.inventory.element]["licens"][i]["count"])
					end
				end
			end
		end
		if getElementType(cache.inventory.element) == "vehicle" then
			if inventoryCache[cache.inventory.element] then
				if inventoryCache[cache.inventory.element]["vehicle"] then
					for i = 1, row * column do
						if (inventoryCache[cache.inventory.element]["vehicle"][i]) then
							vehWeight = vehWeight + (getItemWeight(inventoryCache[cache.inventory.element]["vehicle"][i]["item"]) * inventoryCache[cache.inventory.element]["vehicle"][i]["count"])
						end
					end
				end
			end
		end
		if getElementType(cache.inventory.element) == "object" then
			if inventoryCache[cache.inventory.element] then
				if inventoryCache[cache.inventory.element]["object"] then
					for i = 1, row * column do
						if (inventoryCache[cache.inventory.element]["object"][i]) then
							objectWeight = objectWeight + (getItemWeight(inventoryCache[cache.inventory.element]["object"][i]["item"]) * inventoryCache[cache.inventory.element]["object"][i]["count"])
						end
					end
				end
			end
		end
	end
	return bagWeight + licensWeight + keyWeight + vehWeight + objectWeight
end

function takeItem(item)
	local elem = 0
	local thisElement = cache.inventory.element
	if getElementData(localPlayer,"show:inv") and getElementType(getElementData(localPlayer,"show:inv")) ~= "player" then
		thisElement = localPlayer
	end

	if cache.inventory.page == "craft" then
		thisMenu = "bag"
	else
		thisMenu = getTypeElement(thisElement,tonumber(item))[1] or cache.inventory.page;
	end

	--outputChatBox(thisMenu.." - "..getElementType(thisElement))

	for i = 1, row * column do
		if (inventoryCache[thisElement][thisMenu][i]) then
			if item == inventoryCache[thisElement][thisMenu][i]["item"] then
				elem = elem+1
				if elem == 1 then
					if inventoryCache[thisElement][thisMenu][i]["count"] > 1 then
						triggerServerEvent("setItemCount", localPlayer, thisElement, inventoryCache[thisElement][thisMenu][i], inventoryCache[thisElement][thisMenu][i]["count"]-1);
						inventoryCache[thisElement][thisMenu][i]["count"] = inventoryCache[thisElement][thisMenu][i]["count"]-1;
					else
						triggerServerEvent("deleteItem", localPlayer, thisElement, inventoryCache[thisElement][thisMenu][i],false);
						inventoryCache[thisElement][thisMenu][i] = nil;
					end
				end
			end
		end
	end

	if thisElement == localPlayer then
		for i = 1, row * column do
			if (playerCache[thisElement][thisMenu][i]) then
				if item == playerCache[thisElement][thisMenu][i]["item"] then
					elem = elem+1
					if elem == 1 then
						if playerCache[thisElement][thisMenu][i]["count"] > 1 then
							triggerServerEvent("setItemCount", localPlayer, thisElement, playerCache[thisElement][thisMenu][i], playerCache[thisElement][thisMenu][i]["count"]-1);
							playerCache[thisElement][thisMenu][i]["count"] = playerCache[thisElement][thisMenu][i]["count"]-1;
						else
							func.deleteItem(i,false,thisMenu)
							triggerServerEvent("deleteItem", localPlayer, thisElement, playerCache[thisElement][thisMenu][i],false);
							playerCache[thisElement][thisMenu][i] = nil;
						end
					end
				end
			end
		end
	end
end

func.editAlpha = function()
	if cache.inventory.alpha == 255 then
		cache.inventory.alpha = 0
	elseif cache.inventory.alpha == 0 then
		cache.inventory.alpha = 255
	end
end
setTimer(func.editAlpha,700,0)

func.updateSlot = function(oldSlot,newSlot,data)
	triggerServerEvent("updateSlot",localPlayer,cache.inventory.element,oldSlot,newSlot,data)

	if inventoryCache[cache.inventory.element][cache.inventory.page][oldSlot] then
		inventoryCache[cache.inventory.element][cache.inventory.page][newSlot] = {
			["id"] = data["id"],
			["slot"] = newSlot,
			["item"] = data["item"],
			["value"] = data["value"],
			["count"] = data["count"],
			["duty"] = data["duty"],
			["pp"] = data["pp"],
			["warn"] = data["warn"],
			["state"] = data["state"],
			["weaponserial"] = data["weaponserial"],
		}
		inventoryCache[cache.inventory.element][cache.inventory.page][oldSlot] = nil
	end

	if cache.inventory.element == localPlayer then
		if weaponProgress[oldSlot] then
			weaponProgress[newSlot] = weaponProgress[oldSlot];
		end
	end
end

func.deleteItem = function(slot,state,category,element)
	if not element then
		element = cache.inventory.element;
	end
	if not category then
		category = getTypeElement(cache.inventory.element,tonumber(inventoryCache[cache.inventory.element][cache.inventory.page][slot]["item"]))[1]
	end
	if inventoryCache[element][category][slot] then
		if (getTypeElement(element,tonumber(inventoryCache[element][category][slot]["item"]))[1] == "bag" and (cache.inventory.active.weapon == slot or cache.inventory.active.ammo == slot)) then
			if weaponProgress[cache.inventory.active.weapon] then
				weaponProgress[cache.inventory.active.weapon] = 0
			end
			cache.inventory.active.weapon = -1
			cache.inventory.active.ammo = -1
			cache.inventory.active.dbid = -1
			toggleControl("fire",true)
			toggleControl("action",true)
			triggerServerEvent("takeWeaponServer",localPlayer,localPlayer)
		end

		if cache.inventory.active.identity > 0 then
			cache.inventory.active.identity = -1;
		end

		triggerServerEvent("deleteItem", localPlayer, element, inventoryCache[element][category][slot],state);
		inventoryCache[element][category][slot] = nil;
		if element == localPlayer then

			if playerCache[element][category][slot] then
				deleteCraftitem(playerCache[element][category][slot].id)
			end
			playerCache[element][category][slot] = nil;
		end
	end
end

func.setItemCount = function(slot,count,category,state,element)
	if not element then
		element = cache.inventory.element;
	end
	if not category then
		if inventoryCache[cache.inventory.element][cache.inventory.page][slot] then
			category = getTypeElement(cache.inventory.element,tonumber(inventoryCache[cache.inventory.element][cache.inventory.page][slot]["item"]))[1]
		else
			if inventoryCache[cache.inventory.element] then
				for type,_ in pairs(inventoryCache[cache.inventory.element]) do
					for i = 1, row * column do
						if inventoryCache[cache.inventory.element][type][i] then
							if count == inventoryCache[cache.inventory.element][type][i].count-1 and slot == i then
								category = type
							end
						end
					end
				end
			end
		end
	end
	if inventoryCache[element][category][slot] then
        if count > 0 then
            triggerServerEvent("setItemCount", localPlayer, element, inventoryCache[element][category][slot], count);
            inventoryCache[element][category][slot]["count"] = count;
			if cache.inventory.element == localPlayer then
				if playerCache[element][category][slot] then
					playerCache[element][category][slot]["count"] = count;
				end
			end
        else
            func.deleteItem(slot,state,category,element);
        end
	end
end

func.setItemValue = function(slot,value,category,state,element)
	if not element then
		element = cache.inventory.element;
	end
	if not category then
		if inventoryCache[cache.inventory.element][cache.inventory.page][slot] then
			category = getTypeElement(cache.inventory.element,tonumber(inventoryCache[cache.inventory.element][cache.inventory.page][slot]["item"]))[1]
		else
			if inventoryCache[cache.inventory.element] then
				for type,_ in pairs(inventoryCache[cache.inventory.element]) do
					for i = 1, row * column do
						if inventoryCache[cache.inventory.element][type][i] then
							if value == inventoryCache[cache.inventory.element][type][i].value-1 and slot == i then
								category = type
							end
						end
					end
				end
			end
		end
	end

	if inventoryCache[element][category][slot] then
        if (string.len(tostring(value)) > 0) then
            triggerServerEvent("setItemValue", localPlayer, element, inventoryCache[element][category][slot], value);
            inventoryCache[element][category][slot]["value"] = value;
			if cache.inventory.element == localPlayer then
				--print(value)
				playerCache[element][category][slot]["value"] = value;
			end
        else
            func.deleteItem(slot,state,category,element);
        end
	end
end

func.setItemState = function(slot,state,category,hot)
	if not category then
		category = getTypeElement(cache.inventory.element,tonumber(inventoryCache[cache.inventory.element][cache.inventory.page][slot]["item"]))[1];
	end
	if inventoryCache[cache.inventory.element][category][slot] then
        if state > 0 or hot then
            triggerServerEvent("setItemState", localPlayer, cache.inventory.element, inventoryCache[cache.inventory.element][category][slot], state);
            inventoryCache[cache.inventory.element][category][slot]["state"] = state;
			if cache.inventory.element == localPlayer then
				playerCache[cache.inventory.element][category][slot]["state"] = state;
			end
        else
            func.deleteItem(slot,false,category);
        end
	end
end

function setItemState(slot,state,category,hot)
	if not category then
		category = getTypeElement(cache.inventory.element,tonumber(inventoryCache[cache.inventory.element][cache.inventory.page][slot]["item"]))[1];
	end
	if inventoryCache[cache.inventory.element][category][slot] then
        if state > 0 or hot then
            triggerServerEvent("setItemState", localPlayer, cache.inventory.element, inventoryCache[cache.inventory.element][category][slot], state);
            inventoryCache[cache.inventory.element][category][slot]["state"] = state;
			if cache.inventory.element == localPlayer then
				playerCache[cache.inventory.element][category][slot]["state"] = state;
			end
        else
            func.deleteItem(slot,false,category);
        end
	end
end

func.createStackedItem = function(slot,data,count)
	inventoryCache[cache.inventory.element][getTypeElement(cache.inventory.element,data["item"])[1]][slot] = {};
	triggerServerEvent("createStackedItem",localPlayer,cache.inventory.element,slot,data,count);
end

func.refreshItem = function(element,data,type,extras)
	if not inventoryCache[element] then
		inventoryCache[element] = {
			["bag"] = {},
			["key"] = {},
			["wallet"] = {},
			["vehicle"] = {},
			["object"] = {},
		}
	end
	if element == localPlayer then
		if not playerCache[element] then
			playerCache[element] = {
				["bag"] = {},
				["key"] = {},
				["wallet"] = {},
				["vehicle"] = {},
				["object"] = {},
			}
		end
	end
	if type == "delete" then
		if cache.inventory.active.weapon == data["slot"] then
			cache.inventory.active.weapon = -1;
			cache.inventory.active.ammo = -1;
			cache.inventory.active.dbid = -1;
			triggerServerEvent("takeWeaponServer2",localPlayer,localPlayer)
		end
		inventoryCache[element][getTypeElement(element,data["item"])[1]][data["slot"]] = nil;
		if element == localPlayer then
			playerCache[element][getTypeElement(element,data["item"])[1]][data["slot"]] = nil;
		end
		if extras then
			func.checkDuplicated(element,data,extras)
		end
		if cache.inventory.itemMove then
			cache.inventory.itemMove = false
			cache.inventory.movedSlot = -1
		end
	elseif type == "create" then
		if not inventoryCache[element][getTypeElement(element,data["item"])[1]] then
			inventoryCache[element][getTypeElement(element,data["item"])[1]] = {};
		end
		inventoryCache[element][getTypeElement(element,data["item"])[1]][data["slot"]] = data;
		if element == localPlayer then
			weaponProgress[data.slot] = extras;
			if not playerCache[element][getTypeElement(element,data["item"])[1]] then
				playerCache[element][getTypeElement(element,data["item"])[1]] = {};
			end
			playerCache[element][getTypeElement(element,data["item"])[1]][data["slot"]] = data;
		end

	end
end
addEvent("refreshItem",true)
addEventHandler("refreshItem",getRootElement(),func.refreshItem)

addCommandHandler("resetinv",function(cmd,typ)
	if typ == "bag" or typ == "licens" or typ == "key" then
		if getElementData(localPlayer,"user:admin") >= 10 then
			if playerCache[localPlayer][typ] then
				for i = 1, row * column do
					if playerCache[localPlayer][typ][i] then
						func.deleteItem(i,false,typ);
					end
				end
			end
		end
	end
end)

function hasItem(item,value,slot)
	if not playerCache[localPlayer] then
		playerCache[localPlayer] = {};
	end
	if slot then
		if playerCache[localPlayer][getTypeElement(localPlayer,item)[1]][slot] then
			if item == playerCache[localPlayer][getTypeElement(localPlayer,item)[1]][slot]["item"] then
				return true,playerCache[localPlayer][getTypeElement(localPlayer,item)[1]][slot],slot
			end
		end
		return false
	else
		if not value then
			if item ~= -1 and playerCache[localPlayer][getTypeElement(localPlayer,item)[1]] then
				for i = 1, row * column do
					if playerCache[localPlayer][getTypeElement(localPlayer,item)[1]][i] then
						if item == playerCache[localPlayer][getTypeElement(localPlayer,item)[1]][i]["item"] then
							return true,playerCache[localPlayer][getTypeElement(localPlayer,item)[1]][i],playerCache[localPlayer][getTypeElement(localPlayer,item)[1]][i]["value"],i,playerCache[localPlayer][getTypeElement(localPlayer,item)[1]][i]["count"]
						end
					end
				end
				return false
			end
			return false
		else
			if item ~= -1 and playerCache[localPlayer][getTypeElement(localPlayer,item)[1]] then
				for i = 1, row * column do
					if playerCache[localPlayer][getTypeElement(localPlayer,item)[1]][i] then
						if item == playerCache[localPlayer][getTypeElement(localPlayer,item)[1]][i]["item"] and tonumber(value) == tonumber(playerCache[localPlayer][getTypeElement(localPlayer,item)[1]][i]["value"]) then
							return true,playerCache[localPlayer][getTypeElement(localPlayer,item)[1]][i],i
						end
					end
				end
				return false
			end
			return false
		end
	end
end

function deleteCraftitem(dbid)
	for i = 1, craftSlots * craftSlots do
        if craftItems and craftItems[i] and craftItems[i].itemdbid == dbid then
			craftItems[i] = nil;
		end
	end
end

function setActiveSlot(slot,item,type)
	if type == "card" then
		if slot == -1 then
			if playerCache[localPlayer][getTypeElement(localPlayer,item)[1]][cache.inventory.active.card] then
				local jsonData = fromJSON(playerCache[localPlayer][getTypeElement(localPlayer,item)[1]][cache.inventory.active.card].value);
				jsonData.used = false;
				local newValue = toJSON(jsonData);
				playerCache[localPlayer][getTypeElement(localPlayer,item)[1]][cache.inventory.active.card].value = newValue;
				triggerServerEvent("setItemValue",localPlayer,localPlayer,playerCache[localPlayer][getTypeElement(localPlayer,item)[1]][cache.inventory.active.card],newValue)
			end
			cache.inventory.active.card = -1
		end
		if playerCache[localPlayer][getTypeElement(localPlayer,item)[1]][slot] and cache.inventory.active.card ~= slot then
			cache.inventory.active.card = slot;
			local jsonData = fromJSON(playerCache[localPlayer][getTypeElement(localPlayer,item)[1]][slot].value);
			jsonData.used = true;
			local newValue = toJSON(jsonData);
			playerCache[localPlayer][getTypeElement(localPlayer,item)[1]][slot].value = newValue;
			triggerServerEvent("setItemValue",localPlayer,localPlayer,playerCache[localPlayer][getTypeElement(localPlayer,item)[1]][slot],newValue)
		end
	end
end

func.weaponFire = function(_,_,ammoInClip)
	if cache.inventory.active.weapon > 0 and cache.inventory.active.ammo > 0 then
		if weaponCache[playerCache[localPlayer]["bag"][cache.inventory.active.weapon]["item"]] then
		--	if playerCache[localPlayer]["bag"][cache.inventory.active.ammo]
			if playerCache[localPlayer]["bag"][cache.inventory.active.ammo]["count"] <= 1 then
				triggerServerEvent("deleteItem", localPlayer, localPlayer, playerCache[localPlayer]["bag"][cache.inventory.active.ammo]);
				playerCache[localPlayer]["bag"][cache.inventory.active.ammo] = nil;
				inventoryCache[localPlayer]["bag"][cache.inventory.active.ammo] = nil;
				cache.inventory.active.weapon = -1;
				cache.inventory.active.ammo = -1;
				cache.inventory.active.dbid = -1;
				--outputChatBox("takeAmmo")
			else
				--outputChatBox("takeAmmo-1")
				playerCache[localPlayer]["bag"][cache.inventory.active.ammo]["count"] = playerCache[localPlayer]["bag"][cache.inventory.active.ammo]["count"]-1;
				inventoryCache[localPlayer]["bag"][cache.inventory.active.ammo]["count"] = playerCache[localPlayer]["bag"][cache.inventory.active.ammo]["count"];
				triggerServerEvent("setItemCount", localPlayer, localPlayer, playerCache[localPlayer]["bag"][cache.inventory.active.ammo], playerCache[localPlayer]["bag"][cache.inventory.active.ammo]["count"]);
				if weaponCache[playerCache[localPlayer]["bag"][cache.inventory.active.weapon]["item"]].hotTable then
					weaponProgress[cache.inventory.active.weapon] = weaponProgress[cache.inventory.active.weapon]+weaponCache[playerCache[localPlayer]["bag"][cache.inventory.active.weapon]["item"]].hotTable
				end
			end
		end
	end
end
addEventHandler("onClientPlayerWeaponFire", getLocalPlayer(),func.weaponFire)

func.checkDuplicated = function(element,data,dbid)
	if inventoryCache[element] and inventoryCache[element][getTypeElement(element,tonumber(data.item))[1]] then
		for i = 1, row * column do
			if inventoryCache[element][getTypeElement(element,tonumber(data.item))[1]][i] and (inventoryCache[element][getTypeElement(element,tonumber(data.item))[1]][i]["id"] == dbid) then
				inventoryCache[element][getTypeElement(element,tonumber(data.item))[1]][i] = nil
				if element == localPlayer then
					playerCache[element][getTypeElement(element,tonumber(data.item))[1]][i] = nil
				end
			end
		end
	end
end

local listBox = {screen[1]*0.225, screen[2]*0.15}
local listPos = {screen[1]/2 - screen[1]*0.225/2,  screen[2]/2 -  screen[2]*0.15/2 -  screen[2]*0.07}
local myX, myY = 1768, 992
local listWheel = 0
local selectedItemInList = 1

local itemListButtons = {
	{"Item kérése"},
	{"(50db) Ammo kérése"},
}

func.renderItemlist = function()
	if cache.inventory.itemlist.show then
		dxDrawRectangle(listPos[1], listPos[2], listBox[1], listBox[2], tocolor(30, 30, 30, 255))

		local count = 0
		local count2 = 0

		for k, v in ipairs(availableItems) do
			if k > listWheel and count < 4 then
				count2 = count2 + 1

				if getItemImage(tonumber(k + listWheel*10),false) then
					dxDrawImage(listPos[1] + 2/myX*screen[1] + ((count2-1)*36/myX*screen[1]), listPos[2]+3/myY*screen[2]+(count*36/myY*screen[2]), 35/myX*screen[1], 35/myY*screen[2], getItemImage(tonumber(k + listWheel*10),false))
					if core:isInSlot(listPos[1] + 2/myX*screen[1] + ((count2-1)*36/myX*screen[1]), listPos[2]+3/myY*screen[2]+(count*36/myY*screen[2]), 35/myX*screen[1], 35/myY*screen[2]) or tonumber(k + listWheel*10) == selectedItemInList then
						core:dxDrawOutLine(listPos[1] + 2/myX*screen[1] + ((count2-1)*36/myX*screen[1]), listPos[2]+3/myY*screen[2]+(count*36/myY*screen[2]), 35/myX*screen[1], 35/myY*screen[2], tocolor(r, g, b, 255), 1)
					end
				end

				if count2 == 11 then
					count = count + 1
					count2 = 0
				end
			end
		end

		if selectedItemInList > 0 then
			dxDrawRectangle(listPos[1], listPos[2] + listBox[2] + 2/myY*screen[2], listBox[1], screen[2]*0.1, tocolor(30, 30, 30, 255))
			dxDrawImage(listPos[1] + 2/myX*screen[1], listPos[2] + listBox[2] + 4/myY*screen[2], 50/myX*screen[1], 50/myY*screen[2], getItemImage(selectedItemInList))

			dxDrawText(color.."("..selectedItemInList..") #ffffff"..getItemName(selectedItemInList), listPos[1] + 2/myX*screen[1] + 55/myX*screen[1], listPos[2] + listBox[2] + 4/myY*screen[2], listPos[1] + 2/myX*screen[1] + 55/myX*screen[1] + screen[1]*0.1, listPos[2] + listBox[2] + 4/myY*screen[2] + screen[2]*0.03, tocolor(255, 255, 255, 255), 1, font:getFont("bebasneue", 15/myX*screen[1]), "left", "center", false, false, false, true)
			dxDrawText("Súly: "..getItemWeight(selectedItemInList).."kg", listPos[1] + 2/myX*screen[1] + 55/myX*screen[1], listPos[2] + listBox[2] + 4/myY*screen[2] + screen[2]*0.03, listPos[1] + 2/myX*screen[1] + 55/myX*screen[1] + screen[1]*0.1, listPos[2] + listBox[2] + 4/myY*screen[2] + screen[2]*0.03 + screen[2]*0.015, tocolor(255, 255, 255, 100), 1, font:getFont("condensed", 10/myX*screen[1]), "left", "center", false, false, false, true)

			local startX = listPos[1] + 2/myX*screen[1]
			for k, v in ipairs(itemListButtons) do
				local bWidth = dxGetTextWidth(v[1], 1, font:getFont("condensed", 12/myX*screen[1])) + 4/myX*screen[1]

				local allowed = true

				if k == 2 then
					if not weaponCache[selectedItemInList] or (weaponCache[selectedItemInList].ammo < 0) then
						allowed = false
					end
				end

				if allowed then
					if core:isInSlot(startX, listPos[2] + listBox[2] + 4/myY*screen[2] + screen[2]*0.055, bWidth, screen[2]*0.04) then
						dxDrawRectangle(startX, listPos[2] + listBox[2] + 4/myY*screen[2] + screen[2]*0.055, bWidth, screen[2]*0.04, tocolor(r, g, b, 220))
					else
						dxDrawRectangle(startX, listPos[2] + listBox[2] + 4/myY*screen[2] + screen[2]*0.055, bWidth, screen[2]*0.04, tocolor(r, g, b, 150))
					end

					core:dxDrawShadowedText(v[1], startX, listPos[2] + listBox[2] + 4/myY*screen[2] + screen[2]*0.055, startX+bWidth, listPos[2] + listBox[2] + 4/myY*screen[2] + screen[2]*0.055+screen[2]*0.04, tocolor(255, 255, 255), tocolor(0, 0, 0), 1, font:getFont("condensed", 10/myX*screen[1]), "center", "center")
				else
					if core:isInSlot(startX, listPos[2] + listBox[2] + 4/myY*screen[2] + screen[2]*0.055, bWidth, screen[2]*0.04) then
						dxDrawRectangle(startX, listPos[2] + listBox[2] + 4/myY*screen[2] + screen[2]*0.055, bWidth, screen[2]*0.04, tocolor(r, g, b, 100))
					else
						dxDrawRectangle(startX, listPos[2] + listBox[2] + 4/myY*screen[2] + screen[2]*0.055, bWidth, screen[2]*0.04, tocolor(r, g, b, 70))
					end

					core:dxDrawShadowedText(v[1], startX, listPos[2] + listBox[2] + 4/myY*screen[2] + screen[2]*0.055, startX+bWidth, listPos[2] + listBox[2] + 4/myY*screen[2] + screen[2]*0.055+screen[2]*0.04, tocolor(255, 255, 255, 100), tocolor(0, 0, 0, 100), 1, font:getFont("condensed", 10/myX*screen[1]), "center", "center")
				end
				startX = startX + bWidth + 2/myX*screen[1]
			end
		end
	end
end

function itemListClick(key, state)
	if state and key == "mouse1" then
		local count = 0
		local count2 = 0

		for k, v in ipairs(availableItems) do
			if k > listWheel and count < 4 then
				count2 = count2 + 1

				if getItemImage(tonumber(k + listWheel*10)) then
					if core:isInSlot(listPos[1] + 2/myX*screen[1] + ((count2-1)*36/myX*screen[1]), listPos[2]+3/myY*screen[2]+(count*36/myY*screen[2]), 35/myX*screen[1], 35/myY*screen[2]) then
						selectedItemInList = tonumber(k + listWheel*10)
					end
				end

				if count2 == 11 then
					count = count + 1
					count2 = 0
				end
			end
		end

		local startX = listPos[1] + 2/myX*screen[1]
		for k, v in ipairs(itemListButtons) do
			local bWidth = dxGetTextWidth(v[1], 1, font:getFont("condensed", 12/myX*screen[1])) + 4/myX*screen[1]

			local allowed = true

			if k == 2 then
				if not weaponCache[selectedItemInList] or (weaponCache[selectedItemInList].ammo < 0) then
					allowed = false
				end
			end

			if allowed then
				if core:isInSlot(startX, listPos[2] + listBox[2] + 4/myY*screen[2] + screen[2]*0.055, bWidth, screen[2]*0.04) then
					if k == 1 then
						giveItem(selectedItemInList, 1, 1, 0)
						exports.oInfobox:outputInfoBox('Sikeressen lehívtál egy '..getItemName(selectedItemInList)..'!','success')
						sendMessagetoAdmins(selectedItemInList, 1, 1)
					elseif k == 2 then
						if weaponCache[selectedItemInList] or (weaponCache[selectedItemInList].ammo > 0) then
							giveItem(weaponCache[selectedItemInList].ammo, 1, 50, 0)
							exports.oInfobox:outputInfoBox('Sikeressen lehívtál 50db '..getItemName(weaponCache[selectedItemInList].ammo)..'!','success')
							sendMessagetoAdmins(weaponCache[selectedItemInList].ammo, 1, 50)
						end
					end
				end
			end
			startX = startX + bWidth + 2/myX*screen[1]
		end
	end
end

func.showItemlist = function()
	if getElementData(localPlayer,"user:admin") >= 7 then
		cache.inventory.itemlist.show = not cache.inventory.itemlist.show
		if cache.inventory.itemlist.show then
			addEventHandler("onClientRender",getRootElement(),func.renderItemlist)
			addEventHandler("onClientKey", root, itemListClick)
			cache.inventory.itemlist.gui = guiCreateEdit(-1000,-1000,0,0,"",false)
			guiEditSetMaxLength(cache.inventory.itemlist.gui,16)
		else
			removeEventHandler("onClientRender",getRootElement(),func.renderItemlist)
			removeEventHandler("onClientKey", root, itemListClick)
			destroyElement(cache.inventory.itemlist.gui)
		end
	end
end
addCommandHandler("itemlist",func.showItemlist)

function upList()
	if cache.inventory.itemlist.show then
		listWheel = listWheel - 1
		if listWheel < 1 then
			listWheel = 0
		end
	end
end
bindKey("mouse_wheel_up", "down",upList)
bindKey("arrow_u", "down",upList)

function downList()
	if cache.inventory.itemlist.show then
		--iprint(listWheel)
		if listWheel > math.floor(#availableItems) /10 - 7 then
			listWheel = math.floor(#availableItems) /10 - 7
		else
			listWheel = listWheel + 1
		end
	end
end
bindKey("mouse_wheel_down", "down",downList)
bindKey("arrow_d", "down",downList)

func.border = function(x, y, w, h, radius, color)
    dxDrawRectangle(x - radius, y, radius, h, color)
    dxDrawRectangle(x + w, y, radius, h, color)
    dxDrawRectangle(x - radius, y - radius, w + (radius * 2), radius, color)
    dxDrawRectangle(x - radius, y + h, w + (radius * 2), radius, color)
end

func.rounded = function(x, y, w, h, borderColor, bgColor, postGUI)
	if (x and y and w and h) then
		if (not borderColor) then
			borderColor = tocolor(0, 0, 0, 200);
		end

		if (not bgColor) then
			bgColor = borderColor;
		end

		--> Background
		dxDrawRectangle(x, y, w, h, bgColor, postGUI);

		--> Border
		dxDrawRectangle(x + 2, y - 1, w - 4, 1, borderColor, postGUI); -- top
		dxDrawRectangle(x + 2, y + h, w - 4, 1, borderColor, postGUI); -- bottom
		dxDrawRectangle(x - 1, y + 2, 1, h - 4, borderColor, postGUI); -- left
		dxDrawRectangle(x + w, y + 2, 1, h - 4, borderColor, postGUI); -- right
	end
end

func.getCursorPosition = function()
	local cursorX,cursorY = getCursorPos();
	cursorX,cursorY = cursorX*screen[1], cursorY*screen[2];
	return cursorX,cursorY;
end

func.toolTip = function(...)
	if isCursorShowing() then
		local x,y = getCursorPosition()
		local args = {...};
		local width = 0;

		for i, v in ipairs(args) do
			local thisWidth = dxGetTextWidth( v, 0.9, font:getFont("condensed", 10), true) + 20;
			if thisWidth > width then
				width = thisWidth;
			end
		end

		text = table.concat(args, "\n");

		local height = dxGetFontHeight(0.9, font:getFont("condensed", 10)) * #args + 10;
		x = math.max( 10, math.min( x, screen[1] - width - 10 ) )
		y = math.max( 10, math.min( y, screen[2] - height - 10 ) )

		local alpha = inventoryAlpha
		if not cache.inventory.show then
			alpha = 1
		end

		dxDrawRectangle( x, y, width, height, tocolor( 35, 35, 35, 250 * alpha ), true )
		dxDrawText( text, x, y, x + width, y + height, tocolor( 255, 255, 255, 230 * alpha ), 0.9, font:getFont("condensed", 10), "center", "center", false, false, true, true )
	end
end

func.inBox = function(x,y,w,h)
	if(isCursorShowing()) then
		local cursorX, cursorY = getCursorPos();
		cursorX, cursorY = cursorX*screen[1], cursorY*screen[2];
		if(cursorX >= x and cursorX <= x+w and cursorY >= y and cursorY <= y+h) then
			return true;
		else
			return false;
		end
	end
end

func.formatMoney = function(amount)
    local formatted = amount
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1 %2')
        if (k==0) then
            break
        end
    end
    return formatted
end

if not xmlLoadFile("inventory.xml") then
	local posF = xmlCreateFile("inventory.xml", "root")
	local mainC2 = xmlCreateChild(posF, "position")
	xmlNodeSetValue(xmlCreateChild(mainC2, "x"), pos[1])
	xmlNodeSetValue(xmlCreateChild(mainC2, "y"), pos[2])
	xmlSaveFile(posF)
	--outputChatBox("Mivel neked nem volt xml file-od ahova menthetné most le kreáltam neked egyet.")
else
	local posF = xmlLoadFile("inventory.xml")
	local mainC2 = xmlFindChild(posF, "position", 0)
	setElementData(localPlayer, "inv:x", tonumber(xmlNodeGetValue(xmlFindChild(mainC2, "x", 0))))
	setElementData(localPlayer, "inv:y", tonumber(xmlNodeGetValue(xmlFindChild(mainC2, "y", 0))))

	pos[1] = getElementData(localPlayer, "inv:x")
	pos[2] = getElementData(localPlayer, "inv:y")
end


function savePos()
	local posF = xmlLoadFile("inventory.xml")
	if posF then
		local mainC2 = xmlFindChild(posF, "position", 0)
		xmlNodeSetValue(xmlFindChild(mainC2, "x", 0), pos[1])
		xmlNodeSetValue(xmlFindChild(mainC2, "y", 0), pos[2])
		xmlSaveFile(posF)
	end
end
addEventHandler("onClientResourceStop", getResourceRootElement(getThisResource()), savePos)
addEventHandler("onClientPlayerQuit", getRootElement(), savePos)

function giveItem(item,value,count,dutyitem)
	triggerServerEvent("giveItem", resourceRoot, localPlayer, item,value,count,dutyitem)
end

function sendMessagetoAdmins(item,value,count)
	triggerServerEvent("itemmsgtoadmins", resourceRoot, localPlayer, item, value, count)
end
local soundElementPrinter = false
addEvent("printerSound", true)
addEventHandler("printerSound",getRootElement(), function(objects)
	--files/sounds/copy.mp3
	local x,y,z = getElementPosition(objects)
	soundElementPrinter = playSound3D("files/sounds/copy.mp3",x,y,z)
	setTimer(function()
		if isElement(soundElementPrinter) then
			destroyElement(soundElementPrinter)
		end
	end,7000,1)
end)

function onClientExplosion(x, y, z, theType)
	if theType == 0 then 
		if hasItem(242) then 	
			takeItem(242)
		end 
	end 
end
addEventHandler("onClientExplosion", root, onClientExplosion)