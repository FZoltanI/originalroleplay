local func = {}
sX, sY = guiGetScreenSize()
pW, pH = itemSize*column + margin*(column+1), itemSize * row + (1+row)*margin
s = {guiGetScreenSize()}
moveX, moveY = s[1]/1.2 -pW/2,s[2]/2 - pH/2
showInventory = false

myX, myY = 1768, 992

local lastClick = 0
local invMenu = 1
local selectedAmount = 1
local inSlotBox = false
local selectedSound = 0
local updateClick = 0
-- Funkció rész
playerItems = {}
inventoryItems = {}
actionBarItems = {}
usedSlots = 0
local actionItems = {}
elementSource = nil
activeSide = "bag"
newMenu = nil
local vehBoot = false
local hoverSlot = -1
local hoverItem = nil

local inMove = false
local startTick = -1
local movedItem = nil
local movedSlot = -1

local inClone = false
local clonedItem = nil
local clonedSlot = -1

-- Action Bar
actionSlots = interface:getActionBarSlotCount()
local isCursorInAction = false
local current_action_slot = -1
local isMove = false

defX, defY = 0,0

actBox = {255,itemSize}
actPos = {s[1]/2 -255/2,s[2]/1.1 - 36/2}
namePos = {0,0,200,28}
local showNameBar = false

local nameGui = nil

local listShow = false
local listWheel = 0
local searchWheel = 0

activeWeaponSlot = -1
activeAmmoSlot = -1
activeIdentity = -1

activeShield = -1
activeBadge = -1
activePhone = -1

-- Item List
local searchGui = nil
local listBox = {sX*0.225, sY*0.15}
local listPos = {sX/2 - sX*0.225/2, sY/2 - sY*0.15/2 - sY*0.07}
local addTimer

tick = getTickCount()
animState = "close"
inventoryAnimating = false

local itemMoveType = 1

local categoryTable = {
	{"inv","Tárgyak","bag"},
	{"key","Kulcsok","key"},
	{"wallet","Iratok","licens"},
}

local animTime = 400

local closeTimer 

local _dxDrawImage = dxDrawImage
local textures = {}
local function dxDrawImage(x, y, w, h, image, rot, rotX, rotY, color, postGui)
    if type(image) == "string" then 
        if not textures[image] then 
            textures[image] = dxCreateTexture(image, "dxt5", true)
        end

        image = textures[image]
    end
    _dxDrawImage(x, y, w, h, image, rot, rotX, rotY, color, postGui)
end

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

addEventHandler("onClientResourceStart", root, function(res)
	if getResourceName(res) == "oCore" or getResourceName(res) == "oInventory" or getResourceName(res) == "oInterface" or getResourceName(res) == "oBone" or getResourceName(res) == "oFont" or getResourceName(res) == "oChat" then  
		core = exports.oCore
		chat = exports.oChat
		admin = exports.oAdmin
		fontScript = exports.oFont
		bone = exports.oBone
		interface = exports.oInterface

		logcolor = "#ed6b0e"
		color, r, g, b = core:getServerColor()
	end
end)

addEventHandler("onClientResourceStart", resourceRoot, function() 
	scriptStartLoad()

	if getElementData(localPlayer, "user:loggedin") then 
		addEventHandler("onClientRender", getRootElement(), renderActionbar)
	end
end)

-- [ FONTS ] -- 
opensans = fontScript:getFont("Roboto",10)
font = fontScript:getFont("roboto",14)
toolfont = fontScript:getFont("arial",8)
menuFont = fontScript:getFont("arial",11)
menuFont2 = fontScript:getFont("arial",10)

condensedBig = fontScript:getFont("condensed", 18)
---------------

addEventHandler("onClientResourceStart",resourceRoot,function()
	setElementData(localPlayer,"weap:hot",0)
	setElementData(localPlayer,"handTaser",false)
	setElementData(localPlayer,"active:itemID",-1)
	setElementData(localPlayer,"active:itemSlot",-1)
	setElementData(localPlayer,"badgeState", false)
	setElementData(localPlayer,"drugUsing",false)
	setElementData(localPlayer,"show:inv",localPlayer)
	
	actionBarItems[localPlayer] = {}
	for i=1, actionSlots do
		actionBarItems[localPlayer][i] = {-1, -1, ""}
	end

	bindActionbarSlots()
end)

function getCursorFuck()
	cX, cY = getCursorPosition()
	cX, cY = cX*sX, cY*sY
	return cX, cY
end

addEventHandler("onClientClick",getRootElement(),function(button,state)
	if showInventory then
		if button == "left" and state == "down" then
			if not hoverCategory then return end
			if core:isInSlot(moveX+80, moveY-50+20,pW-80,26) then
				isMove = true
				local curX, curY = getCursorFuck()
				local x,y = moveX,moveY
				defX, defY = curX - x, curY - y
			elseif core:isInSlot(moveX-25+margin+(hoverCategory*25),moveY-27,20,20) then
				if not inMove then
					if invMenu ~= hoverCategory then
						if categoryTable[hoverCategory] then
							playSound("files/sounds/bincoselect.mp3")
							invMenu = hoverCategory
							activeSide = categoryTable[hoverCategory][3]
						end
					end
				end
			end	
		elseif button == "left" and state == "up" then
			if isMove then
				isMove = false
			end
		end
	end
end)

addCommandHandler("inventoryreset",function()
	if getElementData(localPlayer,"user:loggedin") then
		if showInventory then
			moveX, moveY = s[1]/1.2 -pW/2,s[2]/2 - pH/2
		end
	end
end)

local openDelayTimer = false
local openDenyTimer = false
local openCountAtLastMin = 0
bindKey("i", "down",function()
	if getElementData(localPlayer, "user:loggedin") then
		if not isTimer(addTimer) then
			if core:getNetworkConnection() then 
				if not inventoryAnimating then 
					if animState == "open" then 
						inventoryAnimating = true
						animState = "close"
						tick = getTickCount()
						setTimer(function()
							inventoryAnimating = false
							openInventory(localPlayer) 

							if activeSide == "vehicle" then 
								triggerServerEvent("getElementItems", localPlayer, localPlayer, localPlayer, 2, playerItems)
							end
						end, animTime, 1)

						if activeSide == "vehicle" then 
							if isTimer(closeTimer) then 
								killTimer(closeTimer)
							end
							
							setElementData(elementSource, "veh:use", false)
							triggerServerEvent("getElementItems", localPlayer, localPlayer, localPlayer, 2, playerItems)
						elseif activeSide == "object" then 
							if isTimer(closeTimer) then 
								killTimer(closeTimer)
							end
							
							setElementData(elementSource, "safe:use", false)
							triggerServerEvent("getElementItems", localPlayer, localPlayer, localPlayer, 2, playerItems)
						end

						openDelayTimer = setTimer(function() 
							if isTimer(openDelayTimer) then 
								killTimer(openDelayTimer)
								openDelayTimer = false
							end
						end, 1000, 1)
					else
						--if openCountAtLastMin < 5 then 
							if not isTimer(openDelayTimer) then 
								if not isTimer(openDenyTimer) then
									triggerServerEvent("getElementItems", localPlayer, localPlayer, localPlayer)

									openCountAtLastMin = openCountAtLastMin + 1

									if openCountAtLastMin == 6 then 
										--outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."Ez a funkció flood miatt letiltásra kerül az elkövetkező "..color.."1#ffffff percre!", 255, 255, 255, true)
										--openDenyTimer = setTimer(function() outputChatBox(core:getServerPrefix("green-dark", "Inventory", 3).."Az inventory újra megnyitható! "..color.."Legközelebb ne floodolj!", 255, 255, 255, true) end, core:minToMilisec(1), 1)
									end	
									inventoryAnimating = true
									animState = "open"
									tick = getTickCount()
									openInventory(localPlayer)
									setTimer(function() if openCountAtLastMin > 0 then openCountAtLastMin = openCountAtLastMin - 1 end end, 10000, 1)
									setTimer(function() inventoryAnimating = false end, animTime, 1)
								end
							end
						--end
					end
				end
			end
		end
	end
end)

function item_tooltip(text)
	local x, y = getCursorPosition( )
	x, y = x * sX, y * sY

	x, y = x + 5, y + 5

	local width = 0

	local widths = {}
	for k, v in ipairs(text) do 
		table.insert(widths, (dxGetTextWidth(v, 1.0, toolfont, true)+10))
	end

	width = math.max(unpack(widths))
	
	local height = (dxGetFontHeight(1.0, toolfont)*#text) + 5

	y = y - height/2

	dxDrawRectangle(x, y, width, height, tocolor(35, 35, 35, 255), true);

	drawedText = table.concat(text, "\n")

	dxDrawText(drawedText, x, y, x + width, y + height, tooltip_text_color, 1.0, toolfont, "center", "center", false, false, true, true)
end

function tooltip_item(x, y, text, color)
	text = tostring( text )
	local width = dxGetTextWidth( text, 1, "clear" ) + 10
	local height = 10 * ( text2 and 4 or 2 )
	x = x - (width/1.5) + (itemSize)
	dxDrawText( text, x+28, y+78, x + width, y + height, color, 1, toolfont, "center", "center", false, false, false )
end

function openInventory(pElement)
	if (pElement) then
		showInventory = not showInventory

		if showInventory then 
			triggerServerEvent("getElementItems", localPlayer, localPlayer, pElement, 2, inventoryItems)
			addEventHandler("onClientRender", getRootElement(), renderInventory)
		else
			removeEventHandler("onClientRender", getRootElement(), renderInventory)
		end

		if showInventory then
			setElementData(localPlayer,"show:inv",pElement)
		else
			invMenu = 1
			activeSide = "bag"
		
			if getElementType(elementSource) == "vehicle" then
				setElementData(elementSource, "veh:player", nil)
				setElementData(elementSource, "veh:use", false)
				triggerServerEvent("doorState", localPlayer, elementSource, 0)
			end
			if (tostring(getElementType(elementSource))=="object") then
				if getElementModel(elementSource) == 2332 then
					setElementData(elementSource,"safe:use",false)
					setElementData(elementSource,"safe:player",nil)
				end
			end
			setElementData(localPlayer,"show:inv",localPlayer)
		end

	end
end

addEventHandler("onClientElementDataChange", root, function(dataName, oldValue)
	if source == localPlayer then
		if dataName == "user:id" then
			local newValue = tonumber(getElementData(source, dataName))
			if newValue > 0 then
				triggerServerEvent("getElementItems", localPlayer, localPlayer, localPlayer, 2)
				triggerServerEvent("loadActionBarItems",localPlayer,localPlayer)
			end
		end
	end
end)

function setElementItems(itemsTable, itemValue, pElement)
	elementSource = pElement
	if (itemValue == 2) then
		playerItems = itemsTable
	end
	if getElementType(pElement) == "vehicle" then
		if showInventory then
			elementSource = pElement
			setElementData(elementSource, "veh:player",localPlayer)
			setElementData(elementSource, "veh:use", true)
		else
			elementSource = localPlayer
			setElementData(pElement, "veh:player", nil)
			setElementData(pElement, "veh:use", false)
			triggerServerEvent("doorState", localPlayer, pElement, 0)
		end
	end
	if getElementType(pElement) == "object" then
		if showInventory then
			elementSource = pElement
			setElementData(elementSource,"safe:use",true)
			setElementData(elementSource,"safe:player",localPlayer)
		else
			elementSource = localPlayer
			setElementData(pElement,"safe:use",false)
			setElementData(pElement,"safe:player",nil)
		end
	end
	inventoryItems = itemsTable
end
addEvent("setElementItems", true)
addEventHandler("setElementItems", getRootElement(), setElementItems)

addEvent("actionBarEvent",true)
addEventHandler("actionBarEvent",getRootElement(),function(loadedPlayer,tbl)
	for k,v in ipairs(tbl) do
		actionBarItems[loadedPlayer][v["actionslot"]] = {v["itemdbid"],v["item"],v["category"]}
	end
end)

addEvent("delActionBarSlot",true)
addEventHandler("delActionBarSlot",getRootElement(),function(element,slot)
	actionBarItems[element][slot] = {-1, -1, ""}
end)

local inAction = false
local inItem = false
local weaponHot = 0
local randState = 0

addEventHandler("onClientElementStreamIn",getRootElement(),function()
	if getElementType(source) == "player" then
		if source == localPlayer then
			if getElementData(localPlayer,"user:loggedin") then
				if getElementData(localPlayer,"active:itemID") == -1 then
					createClientAttachWeapons()
				end
				if getElementData(localPlayer,"isBriefCaseInHand") then
					triggerServerEvent("giveBriefCase",localPlayer,localPlayer)
				end
			end
		end
	end
end)

addEventHandler("onClientElementStreamOut",getRootElement(),function()
	if getElementType(source) == "player" then
		if source == localPlayer then
			if getElementData(localPlayer,"user:loggedin") then
				if getElementData(localPlayer,"active:itemID") == -1 then
					destroyClientAttachWeapons()
				end
				if getElementData(localPlayer,"isBriefCaseInHand") then
					triggerServerEvent("takeBriefCase",localPlayer,localPlayer)
				end
			end
		end
	end
end)

function scriptStartLoad()
	if getElementData(localPlayer,"user:loggedin") then
		local count = 0

		triggerServerEvent("getElementItems", localPlayer, localPlayer, localPlayer, 2)
		triggerServerEvent("loadActionBarItems",localPlayer,localPlayer)
		setTimer(function()
			createClientAttachWeapons()
		end,1500,1)
	end
end

addEventHandler("onClientElementDataChange", root, function(data, old, new)
	if source == localPlayer then 
		if data == "user:loggedin" then 
			if new == true then 
				scriptStartLoad()
				addEventHandler("onClientRender", getRootElement(), renderActionbar)
			elseif new == false then 
				removeEventHandler("onClientRender", getRootElement(), renderActionbar)
			end
		end
	end
end)

function createClientAttachWeapons()
	if (playerItems[elementSource]["bag"]) then
		for i = 1, row * column do
			if (playerItems[elementSource]["bag"][i]) then
				if weaponModels[playerItems[elementSource]["bag"][i]["id"]] then
					triggerServerEvent("addAttachWeapon",localPlayer,localPlayer,playerItems[elementSource]["bag"][i]["id"],playerItems[elementSource]["bag"][i]["value"],playerItems[elementSource]["bag"][i]["dbid"])
				end
			end
		end
	end
end

function destroyClientAttachWeapons()
	if (playerItems[elementSource]["bag"]) then
		for i = 1, row * column do
			if (playerItems[elementSource]["bag"][i]) then
				if weaponModels[playerItems[elementSource]["bag"][i]["id"]] then
					triggerServerEvent("delAttachWeapon",localPlayer,localPlayer,playerItems[elementSource]["bag"][i]["id"],playerItems[elementSource]["bag"][i]["value"],playerItems[elementSource]["bag"][i]["dbid"])
				end
			end
		end
	end
end

function bindActionbarSlots()
	actionSlots = exports.oInterface:getActionBarSlotCount() or 6

	for i=1, (actionSlots or 6) do
		unbindKey(i, "down")
		bindKey(i, "down", function()
			if actionBarItems[localPlayer][i] and actionBarItems[localPlayer][i][1] > 0 then
				for b = 1, row * column do
					if (playerItems[localPlayer][getTypeOfElement(localPlayer,actionBarItems[localPlayer][i][2])[1]][b]) then
						if playerItems[localPlayer][getTypeOfElement(localPlayer,actionBarItems[localPlayer][i][2])[1]][b]["dbid"] == actionBarItems[localPlayer][i][1] then
							useItem(playerItems[localPlayer][getTypeOfElement(localPlayer,actionBarItems[localPlayer][i][2])[1]][b],b)
						end
					end
				end
			end
		end)
	end
end
addEvent("inv > bindActionbarSlots", true)
addEventHandler("inv > bindActionbarSlots", root, bindActionbarSlots)

function renderInventory()
	hoverSlot = -1
	hoverItem = nil
	hoverCategory = 0

	if inMove then
		showCursor(true)
	else 
		showCursor(false)
	end

	local alpha 
	
	if animState == "open" then 
		alpha = interpolateBetween(0,0,0,1,0,0,((getTickCount()-tick)/animTime),"Linear")
	else
		alpha = interpolateBetween(1,0,0,0,0,0,((getTickCount()-tick)/animTime),"Linear")
	end

	if not (activeSide == "vehicle" or activeSide == "object") then 
		if movedItem then 
			if core:isInSlot(moveX+pW/2-73.8/myX*sX/2, moveY-85/myY*sY, 73.8/myX*sX, 47.4/myY*sY) then
				dxDrawImage(moveX+pW/2-73.8/myX*sX/2, moveY-85/myY*sY, 73.8/myX*sX, 47.4/myY*sY, "files/images/eye.png", 0, 0, 0, tocolor(r, g, b, 255*alpha))
			else
				dxDrawImage(moveX+pW/2-73.8/myX*sX/2, moveY-85/myY*sY, 73.8/myX*sX, 47.4/myY*sY, "files/images/eye.png", 0, 0, 0, tocolor(220, 220, 220, 255*alpha))
			end
		end
	end
	
	if isMove then
		if isCursorShowing() then
			local x, y = getCursorFuck()
			moveX,moveY = x - defX,y - defY
		end
	end
		
	local itemWeight = getAllItemWeight()
	inItem = false
	if (core:isInSlot(moveX-6, moveY-5, pW+12, pH+75)) then
		inItem = true
	end
	
	local drawRow = 0
	local drawColumn = 0
	
	if getElementType(elementSource) == "vehicle" then
		categoryText = "Jármű"
		categoryImage = "car"
	elseif getElementType(elementSource) == "object" then
		categoryText = "Széf"
		categoryImage = "safe"
	else
		categoryText = categoryTable[invMenu][2]
		categoryImage = categoryTable[invMenu][1]
	end
	--usedSlots = 0
	if activeSide == "bag" or activeSide == "licens" or activeSide == "key" or activeSide == "vehicle" or activeSide == "object" then
		dxDrawRectangle(moveX, moveY-50+20,pW,pH+27, tocolor(32, 32, 32, 255*alpha))
		dxDrawRectangle(moveX, moveY-50+20,pW,26, tocolor(28, 28, 28, 255*alpha))

		dxDrawText("original"..color.."Roleplay",moveX,moveY-50+20,moveX+pW-margin,moveY-50+20+26,tocolor(220,220,220,255*alpha),1,menuFont2,"center","center", false, false, false, true)

		local line_width 
		local max_weight = maxweight["player"]

		if activeSide == "vehicle" then 
			max_weight = exports.oVehicle:getVehicleTrunkMaxSize(getElementModel(elementSource)) or 100
		elseif activeSide == "object" then 
			max_weight = maxweight["safe_normal"]
		end

		if animState == "open" then 
			line_width = interpolateBetween(0,0,0,(pH-3)*math.ceil(itemWeight)/max_weight,0,0,((getTickCount()-tick)/animTime),"Linear")
		else
			line_width = interpolateBetween((pH-3)*math.ceil(itemWeight)/max_weight,0,0,0,0,0,((getTickCount()-tick)/animTime),"Linear")
		end

		dxDrawRectangle(moveX+pW+margin,moveY-margin*2,20,pH,tocolor(32,32,32,255*alpha))
		--dxDrawRectangle(moveX+pW+margin+1,moveY-3,20-2,pH-2,tocolor(28,28,28,255*alpha))
		dxDrawRectangle(moveX+pW+margin+1,moveY+pH-5,20-2,line_width-(line_width*2),tocolor(r, g, b,255*alpha))
		dxDrawText(math.ceil(itemWeight).."kg / "..max_weight.."kg",moveX+pW+margin,moveY-margin*2, moveX+pW+margin+20,moveY-margin*2+pH,tocolor(220,220,220,255*alpha),0.8,menuFont2,"center","center", false, false, false, true, false, 90)

		if core:isInSlot(moveX+320+45,moveY-6-2,50,15) then
			if getKeyState("mouse1") and lastClick+200 <= getTickCount() then
				lastClick = getTickCount()
			end
		end

		usedSlots = 0
		for i = 1, row * column do
			if core:isInSlot(moveX+3 + drawColumn * (itemSize + margin) + margin * 1-3.5, moveY - 5 + drawRow * (itemSize + margin) + margin * 1.6, itemSize, itemSize) then
				inSlotBox = true
				dxDrawRectangle(moveX+3 + drawColumn * (itemSize + margin) + margin * 1-3.5, moveY - 5 + drawRow * (itemSize + margin) + margin * 1.6, itemSize, itemSize,tocolor(20,20,20,255*alpha))
				--
				hoverSlot = i
				if inventoryItems[elementSource] then 
					if (inventoryItems[elementSource][activeSide][i]) then
						if selectedSound ~= i then
							playSound("files/sounds/hover.mp3")
						end
						selectedSound = i
						hoverItem = (inventoryItems[elementSource][activeSide][i])
						local itemName = ""
						
						if #inventoryItems[elementSource][activeSide][i]["name"] <= 0 then 
							itemName = getItemName(inventoryItems[elementSource][activeSide][i]["id"],tonumber(inventoryItems[elementSource][activeSide][i]["value"]))
						else
							itemName = inventoryItems[elementSource][activeSide][i]["name"]
						end
						if getElementData(localPlayer,"user:admin") >= 9 and getElementData(localPlayer,"user:aduty") == true then
							item_tooltip({"#D23131"..itemName.."#ffffff #ffa800("..inventoryItems[elementSource][activeSide][i]["id"]..")#ffffff","SQL azonosító: #D23131"..inventoryItems[elementSource][activeSide][i]["dbid"].."#ffffff", "Érték: #D23131"..inventoryItems[elementSource][activeSide][i]["value"].."#ffffff", "Állapot: #D23131"..inventoryItems[elementSource][activeSide][i]["value"].."#ffffff %"})
						else
							if inventoryItems[elementSource][activeSide][i]["id"] >= 112 and inventoryItems[elementSource][activeSide][i]["id"] <= 116 then
								item_tooltip({color..itemName.."#ffffff","Még "..color..tonumber(inventoryItems[elementSource][activeSide][i]["value"]).."#ffffff szál van benne."})
							elseif hotTable[weaponIndexByID[inventoryItems[elementSource][activeSide][i]["id"]]] then
								item_tooltip({color..itemName.."#ffffff #787878["..inventoryItems[elementSource][activeSide][i]["weaponserial"].."]#ffffff","Állapot: #eb4242"..inventoryItems[elementSource][activeSide][i]["value"].."#ffffff%", color..items[inventoryItems[elementSource][activeSide][i]["id"]].weight*inventoryItems[elementSource][activeSide][i]["count"].."#ffffff kg"})
							elseif inventoryItems[elementSource][activeSide][i]["id"] >= 2 and inventoryItems[elementSource][activeSide][i]["id"] <= 26 then
								item_tooltip({color..itemName.."#ffffff",color..items[inventoryItems[elementSource][activeSide][i]["id"]].weight*inventoryItems[elementSource][activeSide][i]["count"].."#ffffff kg", " Még "..color..inventoryItems[elementSource][activeSide][i]["value"].." #ffffffalkalom."})
							elseif inventoryItems[elementSource][activeSide][i]["id"] >= 51 and inventoryItems[elementSource][activeSide][i]["id"] <= 54 then
								item_tooltip({color..itemName.."#ffffff","ID: "..color..inventoryItems[elementSource][activeSide][i]["value"].."#ffffff"})
							elseif inventoryItems[elementSource][activeSide][i]["id"] == 1 then
								item_tooltip({color..itemName.."#ffffff",color..items[inventoryItems[elementSource][activeSide][i]["id"]].weight*inventoryItems[elementSource][activeSide][i]["count"].."#ffffff kg", "Telefonszám: "..color..inventoryItems[elementSource][activeSide][i]["value"]})
							else
								item_tooltip({color..itemName.."#ffffff",color..items[inventoryItems[elementSource][activeSide][i]["id"]].weight*inventoryItems[elementSource][activeSide][i]["count"].."#ffffff kg"})
							end
						end
					else
						hoverItem = nil
					end
				end
			else
				dxDrawRectangle(moveX+3 + drawColumn * (itemSize + margin) + margin * 1-3.5, moveY - 5 + drawRow * (itemSize + margin) + margin * 1.6, itemSize, itemSize,tocolor(25,25,25,255*alpha))
				inSlotBox = false
			end
			
			--print(elementSource, activeSide, i)
			if inventoryItems[elementSource] then 
				local itemData = inventoryItems[elementSource][activeSide][i] or false
				if (itemData) then
					local itemDbid = itemData["dbid"]
					local itemID = itemData["id"]
					local itemCount = itemData["count"]
					local itemHeath = itemData["health"]
					local itemValue = itemData["value"]
					usedSlots = usedSlots+1
					if ((movedSlot == i)) then
						inMove = true
						local cX, cY = getCursorPosition()
						if isCursorShowing() then
							cX,cY = sX*cX,sY*cY
						else
							cX,cY = 0,0
						end
						dxDrawImage(cX - itemSize/2+1, cY - itemSize/2+1, itemSize-2, itemSize-2, getItemImage(tonumber(movedItem["id"]),movedItem["value"]), 0, 0, 0, tocolor(255, 255, 255, 255*alpha), true)													
					else
						dxDrawImage(moveX+1 + drawColumn * (itemSize + margin) + margin * 1, moveY-5 + drawRow * (itemSize + margin) + margin * 1.6+1, itemSize-2, itemSize-2, getItemImage(tonumber(itemID),itemData["value"]), 0, 0, 0, tocolor(255, 255, 255, 255*alpha))
						tooltip_item(moveX+1 + drawColumn * (itemSize + margin) + margin * 1-18, moveY-5 + drawRow * (itemSize + margin) + margin * 1.6-20,itemCount, tocolor(220, 220, 220, 255*alpha))

						if itemID >= 2 and itemID <= 18 then 
							dxDrawRectangle(moveX+1 + drawColumn * (itemSize + margin) + margin * 1, moveY-5 + drawRow * (itemSize + margin) + margin * 1.6+1+itemSize-5, (itemSize-2)/food_maxvalues[itemID]*itemValue, 3, tocolor(50, 140, 168,230*alpha))
						elseif itemID >= 19 and itemID <= 26 then 
							dxDrawRectangle(moveX+1 + drawColumn * (itemSize + margin) + margin * 1, moveY-5 + drawRow * (itemSize + margin) + margin * 1.6+1+itemSize-5, (itemSize-2)/drink_maxvalues[itemID]*itemValue, 3, tocolor(50, 140, 168, 230*alpha))
						elseif itemID == 71 then 
							dxDrawRectangle(moveX+1 + drawColumn * (itemSize + margin) + margin * 1, moveY-5 + drawRow * (itemSize + margin) + margin * 1.6+1+itemSize-5, (itemSize-2)*(itemValue/5), 3, tocolor(50, 140, 168, 230*alpha))
						elseif itemID >= 112 and itemID <= 114 then 
							dxDrawRectangle(moveX+1 + drawColumn * (itemSize + margin) + margin * 1, moveY-5 + drawRow * (itemSize + margin) + margin * 1.6+1+itemSize-5, (itemSize-2)*(itemValue/12), 3, tocolor(50, 140, 168, 230*alpha))
						elseif items[itemID].isWeapon or itemID == 163 or itemID == 164 then
							if not (itemID == 36 or itemID == 29 or itemID == 31 or itemID == 32 or itemID == 33 or itemID == 43 or itemID == 161 or itemID == 162 or itemID == 152) then 
								dxDrawRectangle(moveX+1 + drawColumn * (itemSize + margin) + margin * 1, moveY-5 + drawRow * (itemSize + margin) + margin * 1.6+1+itemSize-5, (itemSize-2)*(itemValue/100), 3, tocolor(201, 42, 42, 230*alpha))
							end
						elseif itemID == 183 or itemID == 184 then 
							dxDrawRectangle(moveX+1 + drawColumn * (itemSize + margin) + margin * 1, moveY-5 + drawRow * (itemSize + margin) + margin * 1.6+1+itemSize-5, (itemSize-2)*(itemValue/10), 3, tocolor(r, g, b, 230*alpha))
						end

						if activeSide == "bag" then 
							if i == activeWeaponSlot then 
								dxDrawImage(moveX+1 + drawColumn * (itemSize + margin) + margin * 1, moveY-5 + drawRow * (itemSize + margin) + margin * 1.6+1, itemSize-2, itemSize-2, "files/images/activeItem.png", 0, 0, 0, tocolor(217, 63, 63, 255*alpha))
							elseif i == activeAmmoSlot then 
								dxDrawImage(moveX+1 + drawColumn * (itemSize + margin) + margin * 1, moveY-5 + drawRow * (itemSize + margin) + margin * 1.6+1, itemSize-2, itemSize-2, "files/images/activeItem.png", 0, 0, 0, tocolor(245, 125, 5, 255*alpha))
							end	
						end
					end
				end	
			end

			if (inClone) then
				local cX, cY = getCursorPosition()
				if isCursorShowing() then
					cX,cY = sX*cX,sY*cY
				else
					cX,cY = 0,0
				end
				dxDrawImage(cX - itemSize/2, cY - itemSize/2, itemSize, itemSize, getItemImage(tonumber(clonedItem["id"]),clonedItem["value"]), 0, 0, 0, tocolor(255, 255, 255, 255*alpha), true)									
			end
			drawColumn = drawColumn + 1
			if (drawColumn == column) then
				drawColumn = 0
				drawRow = drawRow + 1
			end
		end
	end

	
	if getElementType(elementSource) == "vehicle" or getElementType(elementSource) == "object" then
	else
		for k,v in ipairs(categoryTable) do
			if core:isInSlot(moveX-25+margin+(k*25),moveY-28+1,20,20) then
				if not inMove then
					hoverCategory = k
				end

				dxDrawImage(moveX-25+margin+(k*25),moveY-28+1,20,20,"files/images/"..v[1]..".png", 0, 0, 0, tocolor(r, g, b,240*alpha))
			else

				if invMenu == k then 
					dxDrawImage(moveX-25+margin+(k*25),moveY-28+1,20,20,"files/images/"..v[1]..".png", 0, 0, 0, tocolor(r, g, b,240*alpha))
				else
					dxDrawImage(moveX-25+margin+(k*25),moveY-28+1,20,20,"files/images/"..v[1]..".png", 0, 0, 0, tocolor(220,220,220,220*alpha))
				end
			end
		end
	end
end

function renderActionbar()
	actPos = {sX*interface:getInterfaceElementData(3,"posX"), sY*interface:getInterfaceElementData(3,"posY")}
	actionSlots = interface:getActionBarSlotCount()
	if interface:getInterfaceElementData(3,"showing") then
		dxDrawRectangle(actPos[1],actPos[2],(itemSize+(margin*2))*actionSlots+(margin*2),itemSize+margin*4,tocolor(40,40,40,255))
		current_action_slot = -1
		
		if core:isInSlot(actPos[1],actPos[2],(itemSize+(margin*2))*actionSlots+(margin*2),itemSize+margin*4) then
			isCursorInAction = true
		else
			isCursorInAction = false
		end
		
		for i=1,actionSlots do 
			
			if (not guiGetInputEnabled() and not isMTAWindowActive() and not isCursorShowing() and getKeyState(i)) or core:isInSlot(actPos[1]+(i*((itemSize+margin*2)))-40+margin,actPos[2]+margin*2, itemSize, itemSize) then
				dxDrawRectangle(actPos[1]+(i*((itemSize+margin*2)))-40+margin,actPos[2]+margin*2, itemSize, itemSize, tocolor(25,25,25,255))
				current_action_slot = i
			else
				dxDrawRectangle(actPos[1]+(i*((itemSize+margin*2)))-40+margin,actPos[2]+margin*2, itemSize, itemSize, tocolor(30,30,30,255))
			end

			--print(toJSON(actionBarItems[localPlayer][i]), toJSON(actionBarItems[localPlayer][i][1]))
			if actionBarItems[localPlayer][i] and actionBarItems[localPlayer][i][1] > 0 then
				
				for b = 1, row * column do
					if (playerItems[localPlayer][getTypeOfElement(localPlayer,actionBarItems[localPlayer][i][2])[1]][b]) then
						if playerItems[localPlayer][getTypeOfElement(localPlayer,actionBarItems[localPlayer][i][2])[1]][b]["dbid"] == actionBarItems[localPlayer][i][1] then
							dxDrawImage(actPos[1]+(i*((itemSize+margin*2)))-40+margin,actPos[2]+margin*2, itemSize, itemSize,getItemImage(actionBarItems[localPlayer][i][2],playerItems[localPlayer][getTypeOfElement(localPlayer,actionBarItems[localPlayer][i][2])[1]][b]["value"]), 0, 0, 0, tocolor(255,255,255, 255))
							if core:isInSlot(actPos[1]+(i*((itemSize+margin*2)))-40+margin,actPos[2]+margin*2, itemSize, itemSize) then
						
								local actItem = playerItems[localPlayer][getTypeOfElement(localPlayer,actionBarItems[localPlayer][i][2])[1]][b]["id"]
								local actValue = playerItems[localPlayer][getTypeOfElement(localPlayer,actionBarItems[localPlayer][i][2])[1]][b]["value"]
								local actCount = playerItems[localPlayer][getTypeOfElement(localPlayer,actionBarItems[localPlayer][i][2])[1]][b]["count"]
								local actState = playerItems[localPlayer][getTypeOfElement(localPlayer,actionBarItems[localPlayer][i][2])[1]][b]["health"]
								local actSerial = playerItems[localPlayer][getTypeOfElement(localPlayer,actionBarItems[localPlayer][i][2])[1]][b]["weaponserial"]
								local actName = ""
								
								if #playerItems[localPlayer][getTypeOfElement(localPlayer,actionBarItems[localPlayer][i][2])[1]][b]["name"] <= 0 then 
									actName = getItemName(actItem, tonumber(actValue))
								else
									actName = playerItems[localPlayer][getTypeOfElement(localPlayer,actionBarItems[localPlayer][i][2])[1]][b]["name"]
								end

								if weaponModels[actItem] then
									item_tooltip({color..actName.."#ffffff #787878["..actSerial.."]#ffffff","Állapot: #eb4242"..actValue.."#ffffff%", color..items[actItem].weight*actCount.."#ffffff kg"})
								elseif food_maxvalues[actItem] or drink_maxvalues[actItem] then
									item_tooltip({color..actName.."#ffffff"," "..color..items[actItem].weight*actCount.."#ffffff kg ", " Még "..color..actValue.." #ffffffalkalom."})
								else
									item_tooltip({color..actName.."#ffffff"," "..color..items[actItem].weight*actCount.."#ffffff kg"})
								end
							end
							
							tooltip_item(actPos[1]+(i*((itemSize+margin*2)))-itemSize-15,actPos[2]-13, playerItems[localPlayer][getTypeOfElement(localPlayer,actionBarItems[localPlayer][i][2])[1]][b]["count"], tocolor(220, 220, 220, 255))
						
						--elseif actionBarItems[localPlayer][i][1] == -1 then 
						--	dxDrawImage(actPos[1]+(i*((itemSize+margin*2)))-40+margin,actPos[2]+margin*2, itemSize, itemSize,getItemImage(0), 0, 0, 0, tocolor(255,255,255, 255))
						end
					end
				end
			end
		end
	end
end

local selectedItemInList = 1

local itemListButtons = {
	{"Item kérése"},
	{"(50db) Ammo kérése"},
}

function renderItemlist()
	dxDrawRectangle(listPos[1], listPos[2], listBox[1], listBox[2], tocolor(30, 30, 30, 255))

	local count = 0
	local count2 = 0

	for k, v in ipairs(items) do
		if k > listWheel and count < 4 then
			count2 = count2 + 1

			if getItemImage(tonumber(k + listWheel*10)) then
				dxDrawImage(listPos[1] + 2/myX*sX + ((count2-1)*36/myX*sX), listPos[2]+3/myY*sY+(count*36/myY*sY), 35/myX*sX, 35/myY*sY, getItemImage(tonumber(k + listWheel*10)))
				if core:isInSlot(listPos[1] + 2/myX*sX + ((count2-1)*36/myX*sX), listPos[2]+3/myY*sY+(count*36/myY*sY), 35/myX*sX, 35/myY*sY) or tonumber(k + listWheel*10) == selectedItemInList then 
					core:dxDrawOutLine(listPos[1] + 2/myX*sX + ((count2-1)*36/myX*sX), listPos[2]+3/myY*sY+(count*36/myY*sY), 35/myX*sX, 35/myY*sY, tocolor(r, g, b, 255), 1)
				end
			end

			if count2 == 11 then 
				count = count + 1
				count2 = 0
			end
		end
	end

	if selectedItemInList > 0 then 
		dxDrawRectangle(listPos[1], listPos[2] + listBox[2] + 2/myY*sY, listBox[1], sY*0.1, tocolor(30, 30, 30, 255))
		dxDrawImage(listPos[1] + 2/myX*sX, listPos[2] + listBox[2] + 4/myY*sY, 50/myX*sX, 50/myY*sY, getItemImage(selectedItemInList))

		--dxDrawRectangle(listPos[1] + 2/myX*sX + 55/myX*sX, listPos[2] + listBox[2] + 4/myY*sY, sX*0.1, sY*0.03)
		dxDrawText(color.."("..selectedItemInList..") #ffffff"..getItemName(selectedItemInList), listPos[1] + 2/myX*sX + 55/myX*sX, listPos[2] + listBox[2] + 4/myY*sY, listPos[1] + 2/myX*sX + 55/myX*sX + sX*0.1, listPos[2] + listBox[2] + 4/myY*sY + sY*0.03, tocolor(255, 255, 255, 255), 1, fontScript:getFont("bebasneue", 15/myX*sX), "left", "center", false, false, false, true)
		dxDrawText("Súly: "..getItemWeight(selectedItemInList).."kg", listPos[1] + 2/myX*sX + 55/myX*sX, listPos[2] + listBox[2] + 4/myY*sY + sY*0.03, listPos[1] + 2/myX*sX + 55/myX*sX + sX*0.1, listPos[2] + listBox[2] + 4/myY*sY + sY*0.03 + sY*0.015, tocolor(255, 255, 255, 100), 1, fontScript:getFont("condensed", 10/myX*sX), "left", "center", false, false, false, true)
	
		local startX = listPos[1] + 2/myX*sX
		for k, v in ipairs(itemListButtons) do 
			local bWidth = dxGetTextWidth(v[1], 1, fontScript:getFont("condensed", 12/myX*sX)) + 4/myX*sX

			local allowed = true 

			if k == 2 then 
				if not items[selectedItemInList].ammo then 
					allowed = false
				end
			end

			if allowed then
				if core:isInSlot(startX, listPos[2] + listBox[2] + 4/myY*sY + sY*0.055, bWidth, sY*0.04) then 
					dxDrawRectangle(startX, listPos[2] + listBox[2] + 4/myY*sY + sY*0.055, bWidth, sY*0.04, tocolor(r, g, b, 220))
				else
					dxDrawRectangle(startX, listPos[2] + listBox[2] + 4/myY*sY + sY*0.055, bWidth, sY*0.04, tocolor(r, g, b, 150))
				end

				core:dxDrawShadowedText(v[1], startX, listPos[2] + listBox[2] + 4/myY*sY + sY*0.055, startX+bWidth, listPos[2] + listBox[2] + 4/myY*sY + sY*0.055+sY*0.04, tocolor(255, 255, 255), tocolor(0, 0, 0), 1, fontScript:getFont("condensed", 10/myX*sX), "center", "center")
			else
				if core:isInSlot(startX, listPos[2] + listBox[2] + 4/myY*sY + sY*0.055, bWidth, sY*0.04) then 
					dxDrawRectangle(startX, listPos[2] + listBox[2] + 4/myY*sY + sY*0.055, bWidth, sY*0.04, tocolor(r, g, b, 100))
				else
					dxDrawRectangle(startX, listPos[2] + listBox[2] + 4/myY*sY + sY*0.055, bWidth, sY*0.04, tocolor(r, g, b, 70))
				end

				core:dxDrawShadowedText(v[1], startX, listPos[2] + listBox[2] + 4/myY*sY + sY*0.055, startX+bWidth, listPos[2] + listBox[2] + 4/myY*sY + sY*0.055+sY*0.04, tocolor(255, 255, 255, 100), tocolor(0, 0, 0, 100), 1, fontScript:getFont("condensed", 10/myX*sX), "center", "center")
			end
			startX = startX + bWidth + 2/myX*sX
		end
	end
end

function itemListClick(key, state)
	if state and key == "mouse1" then 
		local count = 0
		local count2 = 0

		for k, v in ipairs(items) do
			if k > listWheel and count < 4 then
				count2 = count2 + 1

				if getItemImage(tonumber(k + listWheel*10)) then
					if core:isInSlot(listPos[1] + 2/myX*sX + ((count2-1)*36/myX*sX), listPos[2]+3/myY*sY+(count*36/myY*sY), 35/myX*sX, 35/myY*sY) then 
						selectedItemInList = tonumber(k + listWheel*10)
					end
				end

				if count2 == 11 then 
					count = count + 1
					count2 = 0
				end
			end
		end

		local startX = listPos[1] + 2/myX*sX
		for k, v in ipairs(itemListButtons) do 
			local bWidth = dxGetTextWidth(v[1], 1, fontScript:getFont("condensed", 12/myX*sX)) + 4/myX*sX

			local allowed = true 

			if k == 2 then 
				if not items[selectedItemInList].ammo then 
					allowed = false
				end
			end

			if allowed then
				if core:isInSlot(startX, listPos[2] + listBox[2] + 4/myY*sY + sY*0.055, bWidth, sY*0.04) then 
					if k == 1 then 
						if not items[selectedItemInList].ammo then 
							giveItem(selectedItemInList, 1, 1, 0, true)
						else
							giveItem(selectedItemInList, 100, 1, 0, true)
						end
					elseif k == 2 then 
						giveItem(items[selectedItemInList].ammo, 1, 50, 0, true)
					end
				end
			end
			startX = startX + bWidth + 2/myX*sX
		end
	end
end

local lastStack = 0
local lastTrade = 0
func["invClick"] = function(pButton, pState, _, _, _, _, _, clickedElement)
	if getPlayerPing(localPlayer) <= 150 then
		if core:getNetworkConnection() then 
			if not isTimer(addTimer) then
				if (pButton == "left" and pState == "down" and showInventory) then
					if (tonumber(hoverSlot) > -1 and hoverItem and not inClone) then
						itemMoveType = 1		
						startTick = getTickCount()
						movedItem = hoverItem
						movedSlot = tonumber(hoverSlot)
						playSound("files/sounds/select.mp3")
						nilMoving = true
					end
					if activeSide == "bag" or activeSide == "key" or activeSide == "licens" then
						if(isCursorInAction and current_action_slot > -1) then
							actionBarItems[elementSource][current_action_slot] = {-1, -1, ""}
							triggerServerEvent("deleteActionBarItem",localPlayer,localPlayer,current_action_slot)
						end
					end
		
				elseif (pButton == "middle" and pState == "down" and showInventory) then
					if hoverItem then
						if hoverItem["count"] > 1 then 
							if (tonumber(hoverSlot) > -1 and hoverItem and not inClone) then
								itemMoveType = 2
								if activeSide == "bag" and activeWeaponSlot == hoverSlot or activeAmmoSlot == hoverSlot or activeShield == hoverSlot or activeBadge == hoverSlot or activePhone == hoverSlot then
								elseif activeSide == "licens" and activeIdentity == hoverSlot then
								elseif activeSide == "licens" and hoverItem["id"] == 147 then
									outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."Ezt a tárgyat nem mozgathatod.",61,122,188,true)
								else
									startTick = getTickCount()
									movedItem = hoverItem
									movedSlot = tonumber(hoverSlot)
									playSound("files/sounds/select.mp3")	
									inClone = true
									clonedItem = hoverItem
									clonedSlot = tonumber(hoverSlot)
								end
							end
						end
					end
				elseif (pButton == "left" and pState == "up" and showInventory) then
					if itemMoveType == 1 then 
						if activeSide == "bag" or activeSide == "key" or activeSide == "licens" then
							if (not inItem and isCursorInAction and movedItem and movedSlot > -1) then
								--print(current_action_slot)
								if current_action_slot > -1 then
									local actionbarData = (actionBarItems[elementSource][current_action_slot][1] or -1)
									print(actionbarData)
									if (actionbarData) == -1 then
										actionBarItems[elementSource][current_action_slot] = {movedItem["dbid"], movedItem["id"], activeSide}
										triggerServerEvent("moveItemToActionBar",localPlayer,localPlayer,movedItem["dbid"], movedItem["id"], activeSide,current_action_slot)
									end
								end
							end			
						end
		
						if not (activeSide == "vehicle" or activeSide == "object") then 
							if core:isInSlot(moveX+pW/2-73.8/myX*sX/2, moveY-85/myY*sY, 73.8/myX*sX, 47.4/myY*sY) then
								if not getElementData(localPlayer, "inventory:showedItem") then 
									local value = movedItem["value"] or "false"
									local id = movedItem["id"]
		
									if weaponModels[id] then
										value = movedItem["weaponserial"].." ("..value.."%)"
									elseif id == 1 then 
										value = "Telefonszám: "..string.sub(value,7)
									elseif food_maxvalues[id] or drink_maxvalues[id] then
										value = "Még "..value.." alkalom"
									elseif id == 69 then 
										value = value
									elseif id == 65 then 
										value = "Név: "..string.sub(value,23):gsub("_", " ").." | Érvényes: "..string.sub(value,9,12).."."..string.sub(value,13,14).."."..string.sub(value,15,16).."-ig"
									elseif id == 66 then
										value = "Név: "..string.sub(value,22):gsub("_", " ").." | Érvényes: "..string.sub(value,9,12).."."..string.sub(value,13,14).."."..string.sub(value,15,16).."-ig"
									elseif id == 68 then 
										value = "Név: "..string.sub(value,20):gsub("_", " ").." | Érvényes: "..string.sub(value,9,12).."."..string.sub(value,13,14).."."..string.sub(value,15,16).."-ig"
									else 
										value = ""
									end
		
									exports.oChat:sendLocalMeAction("felmutat egy "..getItemName(id).."-(e)t.")
									triggerServerEvent("show > item", resourceRoot, id, value)
									setTimer(function() triggerServerEvent("resetItemShowing > show", resourceRoot) end, 10000, 1)
								else
									outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."Jelenleg egy item felmutatása folyamatban van!", 255, 255, 255, true)
								end
								hideMove()
								hideClone()
								return
							end
						end
						
						if hoverSlot == movedSlot then
							hideClone()
						end
						
						if not hoverItem then
							if hoverSlot == -1 then
								hideClone()
							end
						end
						
						if hoverItem and movedItem then
							if hoverItem["id"] == movedItem["id"] then
								if not items[hoverItem["id"]].stackable then
									if selectedAmount >= 1 then
										hideClone()
									end
								end
							elseif hoverItem["id"] ~= movedItem["id"] then
								if selectedAmount >= 1 then
									hideClone()
								end
							end
						end
						if movedItem then 
							if not ( (movedItem["slot"] == activeWeaponSlot) or (movedItem["slot"] == activeAmmoSlot) ) then 
								if (movedSlot > -1 and movedItem and not hoverItem and hoverSlot > -1 and hoverSlot ~= movedSlot and inItem and inMove) then
									--if not (activeSide == "vehicle" or activeSide == "object") then 
									--	if lastStack + 700 < getTickCount() then
											setItemSlot(movedSlot, hoverSlot)
											delItemSlot(movedSlot)
											playSound("files/sounds/move.mp3")
									--		lastStack = getTickCount()
									--	end
									--end
								elseif (movedSlot > -1 and movedItem and hoverItem and hoverSlot > -1 and hoverItem["id"] == movedItem["id"] and hoverSlot ~= movedSlot and inItem and inMove and items[movedItem["id"]].stackable) then
									if not (activeSide == "vehicle" or activeSide == "object") then 
										if lastStack + 700 < getTickCount() then
											if hoverItem["value"] == movedItem["value"] then 
												setItemCount(hoverSlot, hoverItem["count"] + movedItem["count"])
												delItem(movedSlot)
												lastStack = getTickCount()
											end
										end
									end
								elseif (movedSlot > -1 and movedItem and not inAction and inMove and not inItem and clickedElement and getElementType(clickedElement) == "vehicle" and getElementData(clickedElement, "veh:id") > 0) and not isCursorInAction then
									if core:getDistance(elementSource, clickedElement) < 3.5 then
										if not (isVehicleLocked(clickedElement)) then
											if not getElementData(clickedElement, "veh:use") then
												if movedItem["duty"] == 1 then
													outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."Szolgálati tárggyal nem végezhető el ez a funkció.",61,122,188,true)
												else	
													if movedItem["id"] == 1 then 
														exports.oPhone:checkPhoneVisible(movedItem["value"])
													elseif movedItem["id"] == 65 or movedItem["id"] == 66 or movedItem["id"] == 68 then 
														if (movedItem["value"] == getElementData(localPlayer, "active:itemValue")) then 
															exports.oLicenses:closeCard()
															setElementData(localPlayer, "active:itemValue", false)
														end
													end	
													
													if not (movedItem["slot"] == (activeWeaponSlot or 0)) then 
														updateClick = updateClick+1
														
														if lastTrade + 1000 < getTickCount() then
															lastTrade = getTickCount()
															triggerServerEvent("tradeItem", localPlayer, localPlayer, clickedElement, elementSource, movedItem, updateClick)
														end
													else
														outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."Előbb rakd el a fegyvert!", 255, 255, 255, true)
													end
												end
											else
												outputChatBox(core:getServerPrefix("red-dark", "Csomagtartó", 3).."A jármű csomagtartója éppen használatban van!", 255, 255, 255, true)
											end
										else
											outputChatBox(core:getServerPrefix("red-dark", "Csomagtartó", 3).." A kiválasztott jármű zárva van.",61,122,188,true)
										end
									end
								elseif (movedSlot > -1 and movedItem and not inAction and inMove and not inItem and clickedElement and getElementType(clickedElement) == "player" and getElementData(clickedElement, "user:id") > 0) and not isCursorInAction and clickedElement ~= localPlayer then		
									if core:getDistance(elementSource, clickedElement) < 3.5 then	
										if movedItem["duty"] == 1 then
											outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."Szolgálati tárggyal nem végezhető el ez a funkció.",61,122,188,true)
										else
											if getElementType(elementSource) ~= "vehicle" and getElementType(elementSource) ~= "object" then
												if movedItem["id"] == 1 then 
													exports.oPhone:checkPhoneVisible(movedItem["value"])
												elseif movedItem["id"] == 65 or movedItem["id"] == 66 or movedItem["id"] == 68 then 
													if (movedItem["value"] == getElementData(localPlayer, "active:itemValue")) then 
														exports.oLicenses:closeCard()
														setElementData(localPlayer, "active:itemValue", false)
													end
												end	
		
												if not (movedItem["slot"] == (activeWeaponSlot or 0)) then 
													updateClick = updateClick+1
		
													if lastTrade + 1000 < getTickCount() then
														lastTrade = getTickCount()
														triggerServerEvent("tradeItem", localPlayer, localPlayer, clickedElement, elementSource, movedItem,updateClick)
													end
												else
													outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."Előbb rakd el a fegyvert!", 255, 255, 255, true)
												end
		
											else
												outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."A kiválasztott inventoryból, csak magadra tudod húzni ezt a tárgyat.",61,122,188,true)
											end
										end
									end
								elseif (movedSlot > -1 and movedItem and not inAction and inMove and not inItem and clickedElement and getElementType(clickedElement) == "object") and getElementModel(clickedElement) == 1359 and clickedElement ~= localPlayer and not isCursorInAction then		
									if core:getDistance(elementSource, clickedElement) < 3.5 then
										local itemName = ""
										if #movedItem["name"] <= 0 then 
											itemName = getItemName(movedItem["id"],tonumber(movedItem["value"]))
										else
											itemName = movedItem["name"]
										end
										if movedItem["id"] == 1 then 
											exports.oPhone:checkPhoneVisible(movedItem["value"])
										elseif movedItem["id"] == 65 or movedItem["id"] == 66 or movedItem["id"] == 68 then 
											if (movedItem["value"] == getElementData(localPlayer, "active:itemValue")) then 
												exports.oLicenses:closeCard()
												setElementData(localPlayer, "active:itemValue", false)
											end
										end	
										
										chat:sendLocalMeAction("kidob egy tárgyat a szemetesbe. ("..itemName..")")
										if weaponModels[movedItem["id"]] then
											--outputChatBox("asd")
											triggerServerEvent("delAttachWeapon",localPlayer,localPlayer,movedItem["id"],movedItem["value"],movedItem["dbid"])
										end
										triggerServerEvent("deleteItem", localPlayer, localPlayer, elementSource, movedItem)
										inventoryItems[elementSource][activeSide][movedSlot] = nil
									end
								elseif (movedSlot > -1 and movedItem and not inAction and inMove and not inItem and clickedElement and getElementType(elementSource) == "object") and clickedElement == localPlayer and not isCursorInAction then		
									if core:getDistance(elementSource, clickedElement) < 3.5 then
										updateClick = updateClick+1
										
										if movedItem["id"] == 1 then 
											exports.oPhone:checkPhoneVisible(movedItem["value"])
										elseif movedItem["id"] == 65 or movedItem["id"] == 66 or movedItem["id"] == 68 then 
											if (movedItem["value"] == getElementData(localPlayer, "active:itemValue")) then 
												exports.oLicenses:closeCard()
												setElementData(localPlayer, "active:itemValue", false)
											end
										end	

										if lastTrade + 1000 < getTickCount() then
											lastTrade = getTickCount()
											triggerServerEvent("tradeItem", localPlayer, localPlayer, clickedElement, elementSource, movedItem,updateClick)
										end
		
										if movedItem["value"] == getElementData(localPlayer, "active:itemValue") then 
											exports.oLicenses:toggleCard()
										end
									end
								elseif (movedSlot > -1 and movedItem and not inAction and inMove and not inItem and clickedElement and getElementType(elementSource) == "vehicle") and clickedElement == localPlayer and not isCursorInAction then		
									if core:getDistance(elementSource, clickedElement) < 3.5 then
										updateClick = updateClick+1
		
										if movedItem["id"] == 1 then 
											exports.oPhone:checkPhoneVisible(movedItem["value"])
										elseif movedItem["id"] == 65 or movedItem["id"] == 66 or movedItem["id"] == 68 then 
											if (movedItem["value"] == getElementData(localPlayer, "active:itemValue")) then 
												exports.oLicenses:closeCard()
												setElementData(localPlayer, "active:itemValue", false)
											end
										end	
		
										if lastTrade + 1000 < getTickCount() then
											lastTrade = getTickCount()
											triggerServerEvent("tradeItem", localPlayer, localPlayer, clickedElement, elementSource, movedItem,updateClick)
										end
		
										if movedItem["value"] == getElementData(localPlayer, "active:itemValue") then 
											exports.oLicenses:toggleCard()
										end
									end
								elseif (movedSlot > -1 and movedItem and not inAction and inMove and not inItem and clickedElement and getElementType(clickedElement) == "object") and getElementData(clickedElement, "szef") and clickedElement ~= localPlayer and not isCursorInAction then		
									if core:getDistance(elementSource, clickedElement) < 3.5 then
										if movedItem["duty"] == 1 then
											outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."Szolgálati tárggyal nem végezhető el ez a funkció.",61,122,188,true)
										else
											if movedItem["id"] ~= 93 then
												if hasItem(54,getElementData(clickedElement, "dbid")) then
													updateClick = updateClick+1

													if lastTrade + 1000 < getTickCount() then
														lastTrade = getTickCount()
														triggerServerEvent("tradeItem", localPlayer, localPlayer, clickedElement, elementSource, movedItem,updateClick)
													end
												else
													outputChatBox(core:getServerPrefix("red-dark", "Széf", 3).."Nincs kulcsod ehhez a széfhez.",61,122,188,true)
												end
											else
												outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."A kiválasztott tárgyat, csak egy másik játékosnak tudod átadni.",61,122,188,true)
											end
										end
									end
								elseif (movedSlot > -1 and movedItem and not inAction and inMove and not inItem and clickedElement and getElementType(clickedElement) == "object") and getElementData(clickedElement, "atm:id") and not isCursorInAction then		
									if core:getDistance(elementSource, clickedElement) < 3.5 then
										if movedItem["id"] == 155 then
											exports.oBank:openATM(movedItem["value"], clickedElement)
										end
									end
								elseif (movedSlot > -1 and movedItem and not inAction and inMove and not inItem and clickedElement and getElementType(clickedElement) == "ped") and getElementData(clickedElement, "isFisherPed") and not isCursorInAction then	
									if core:getDistance(elementSource, clickedElement) < 4 then
										exports.oMarket:sellFishItem(movedItem["id"], movedItem["count"], movedItem, getElementData(clickedElement, "fisherPriceMultiplier"))
									end
								elseif (movedSlot > -1 and movedItem and not inAction and inMove and not inItem and clickedElement and getElementType(clickedElement) == "ped") and getElementData(clickedElement, "isMushroomPed") and not isCursorInAction then	
									if core:getDistance(elementSource, clickedElement) < 4 then
										exports.oMarket:sellMushroomItem(movedItem["id"], movedItem["count"], movedItem, getElementData(clickedElement, "mushroomPriceMultiplier"))
									end
								elseif (movedSlot > -1 and movedItem and not inAction and inMove and not inItem and clickedElement and getElementType(clickedElement) == "ped") and getElementData(clickedElement, "isAnimalPed") and not isCursorInAction then	
									if core:getDistance(elementSource, clickedElement) < 4 then
										if exports.oLicenses:playerHasValidLicense(79) then
											exports.oMarket:sellAnimalItem(movedItem["id"], movedItem["count"], movedItem, getElementData(clickedElement, "animalPriceMultiplier"))
										else 
											outputChatBox(core:getServerPrefix("red-dark", "Vadászat", 3).."Nincs nálad érvényes vadászengedély.", 255, 255, 255, true)
										end
									end
								elseif (movedSlot > -1 and movedItem and not inAction and inMove and not inItem and clickedElement and getElementType(clickedElement) == "ped") and getElementData(clickedElement, "treasureHunt:antiqueStore") and not isCursorInAction then	
									if core:getDistance(elementSource, clickedElement) < 4 then
										exports.oTreasureHunt:sellAntiqueItem(movedItem["id"], movedItem["count"], movedItem)
									end
								elseif (movedSlot > -1 and movedItem and not inAction and inMove and not inItem and clickedElement and getElementType(clickedElement) == "ped") and getElementData(clickedElement, "treasureHunt:jewelryStore") and not isCursorInAction then	
									if core:getDistance(elementSource, clickedElement) < 4 then
										exports.oTreasureHunt:sellJewelryItem(movedItem["id"], movedItem["count"], movedItem)
									end
								elseif (movedSlot > -1 and movedItem and not inAction and inMove and not inItem and clickedElement and getElementType(clickedElement) == "object") and getElementData(clickedElement, "drug:isDrugCraftTable") and not isCursorInAction then	
									if exports.oDrugs:addItemToCraftTable(clickedElement, movedItem["id"], movedItem["count"]) then 
										triggerServerEvent("deleteItem", localPlayer, localPlayer, elementSource, movedItem)
									end
								elseif (movedSlot > -1 and movedItem and not inAction and inMove and not inItem and clickedElement and getElementType(clickedElement) == "ped") and getElementData(clickedElement, "isDrugPed") and not isCursorInAction then	
									if core:getDistance(elementSource, clickedElement) < 3.5 then
										if exports.oDrugs:addDrugDealerExperience(clickedElement, movedItem["id"], movedItem["count"]) then 
											triggerServerEvent("deleteItem", localPlayer, localPlayer, elementSource, movedItem)
										end
									end
								end
							else
								outputChatBox(core:getServerPrefix("red-dark", "Inventory", 2).."Előbb tedd el!", 255, 255, 255, true)
							end
						end
						hideMove()
					end
				elseif (pButton == "middle" and pState == "up" and showInventory) then
					if lastStack + 700 < getTickCount() then
						if itemMoveType == 2 then 
							if hoverSlot == movedSlot then
								hideClone()
							end
		
							if not hoverSlot then 
								hideClone()
							end
							
							if not hoverItem then
								if hoverSlot == -1 then
									hideClone()
								end
							end
		
							if not hasItemOnSlot(hoverSlot) then 
								if not (activeSide == "vehicle" or activeSide == "object") then 
									lastStack = getTickCount()
									if movedItem["count"] > 1 then 
										if movedItem["count"]%2 == 0 then 
											setItemSlot(movedSlot, movedSlot)
											createNewItem(hoverSlot, movedItem["dbid"], movedItem["id"], movedItem["value"], movedItem["count"]/2, movedItem["duty"],movedItem["health"],movedItem["name"],movedItem["weaponserial"])
											setItemCount(movedSlot, tonumber(movedItem["count"])/2)
											hideClone()
											hideMove()
										else
											setItemSlot(movedSlot, movedSlot)
											createNewItem(hoverSlot, movedItem["dbid"], movedItem["id"], movedItem["value"], 1, movedItem["duty"],movedItem["health"],movedItem["name"],movedItem["weaponserial"])
											setItemCount(movedSlot, movedItem["count"]-1)
											hideClone()
											hideMove()
										end
									else
										setItemSlot(movedSlot, hoverSlot)
									end
								else
									hideClone()
									hideMove()
								end
							else
								hideClone()
								hideMove()
							end
		
							playSound("files/sounds/move.mp3")
						end
					else
						hideClone()
						hideMove()
					end
				elseif (pButton == "right" and pState == "up" and showInventory) then 
					if activeSide == "vehicle" then 
						if hoverItem then 
							if not hoverItem["id"] == 65 or not hoverItem["id"] == 66 or not hoverItem["id"] == 68 then 
								useItem(hoverItem,hoverSlot)
							end
						end
					elseif activeSide == "object" then 
					else
						
							if not movedItem then 
								useItem(hoverItem,hoverSlot)
							end
						--end
					end
				end
		
				if (pState == "down" and pButton == "right") then
					if (clickedElement and getElementType(clickedElement) == "object" and tonumber(getElementData(clickedElement, "dbid") or 0) > 0) then -- Széf
						if core:getDistance(localPlayer, clickedElement) < 3.5 then
							if showInventory then
								if core:isInSlot(moveX-4,moveY-16,pW+12,pH+64) then
									return
								end
							end
							if getElementData(clickedElement,"szef") then
								if hasItem(54,getElementData(clickedElement, "dbid")) then
									if getElementData(clickedElement,"safe:use") then
										outputChatBox(core:getServerPrefix("red-dark", "Széf", 3).."A kiválasztott széf használatban van.",61,122,188,true)
									else
										if not showInventory then 
											showInventory = true
											addEventHandler("onClientRender", getRootElement(), renderInventory)
										end
		
										invMenu = 1
		
										activeSide = "object"
										elementSource = clickedElement
										triggerServerEvent("getElementItems", localPlayer, localPlayer, clickedElement, 2)
										setElementData(localPlayer,"show:inv",clickedElement)
										setElementData(clickedElement,"safe:use",true)
										setElementData(clickedElement,"safe:player",localPlayer)
										exports.oChat:sendLocalMeAction("belenézett egy széfbe.")
		
										inventoryAnimating = true
										animState = "open"
										tick = getTickCount()
										setTimer(function() inventoryAnimating = false end, animTime, 1)
		
										closeTimer = setTimer(function() 
											if core:getDistance(elementSource, localPlayer) > 3.5 then 
												inventoryAnimating = true
												animState = "close"
												tick = getTickCount()
					
												if isTimer(closeTimer) then 
													killTimer(closeTimer)
												end
		
												if activeSide == "object" then 											
													setElementData(elementSource, "safe:use", false)
													triggerServerEvent("getElementItems", localPlayer, localPlayer, localPlayer, 2, playerItems)
												end
					
												openDelayTimer = setTimer(function() 
													if isTimer(openDelayTimer) then 
														killTimer(openDelayTimer)
														openDelayTimer = false
														--animState = "open"
														openInventory(localPlayer)
														inventoryAnimating = false
													end
												end, 1000, 1)
											end
										end, 100, 0)
									end
								else
									if activeSide ~= "object" then
										outputChatBox(core:getServerPrefix("red-dark", "Széf", 3).."Nincs kulcsod ehhez a széfhez.",61,122,188,true)
									end
								end
							end
						end
					end
				end
			end
		else
			outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."Rossz internetkapcsolat miatt a funkció letiltva!", 255, 255, 255, true)
			hideMove()
			hideClone()
		end
	else
		outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."Magas ping miatt a funkció letiltva!", 255, 255, 255, true)
		hideMove()
		hideClone()
	end
end
addEventHandler("onClientClick", getRootElement(),func["invClick"])

function createNewItem(newSlot, itemDBID, itemID, itemValue, itemCount, itemDuty, itemHealth,itemName,weaponSerial)
	if (newSlot > -1 and itemDBID and itemID and itemValue and itemCount and itemDuty and itemHealth) then
		triggerServerEvent("createNewItem", localPlayer, localPlayer, elementSource, itemID, newSlot,itemCount,itemDuty,itemValue,itemHealth,itemName,weaponSerial,itemDBID)
	end
end

function setItemCount(itemSlot, newCount)
	if (itemSlot > -1 and newCount > -1) then
		if activeSide == "craft" then
			newMenu = "bag"
		else
			newMenu = activeSide
		end
		triggerServerEvent("updateItemCount", localPlayer, localPlayer, elementSource, itemSlot, newCount,inventoryItems[elementSource][newMenu][itemSlot])
		inventoryItems[elementSource][newMenu][itemSlot]["count"] = newCount
		if (elementSource == localPlayer) then
			playerItems[elementSource][newMenu][itemSlot]["count"] = newCount
		end
	end
end

function getItemCount(itemSlot)
	if (itemSlot > -1) then
		if activeSide == "craft" then
			newMenu = "bag"
		else
			newMenu = activeSide
		end

		if (elementSource == localPlayer) then
			return playerItems[elementSource][newMenu][itemSlot]["count"]
		else
			return inventoryItems[elementSource][newMenu][itemSlot]["count"]
		end
	end
end

function setItemName(itemSlot, newName)
	if (itemSlot > -1 and newName) then
		if activeSide == "craft" then
			newMenu = "bag"
		else
			newMenu = activeSide
		end
		triggerServerEvent("updateItemName", localPlayer, localPlayer, elementSource, itemSlot, newName, inventoryItems[elementSource][newMenu][itemSlot])

		inventoryItems[elementSource][newMenu][itemSlot]["name"] = newName
		if (elementSource == localPlayer) then
			playerItems[elementSource][newMenu][itemSlot]["name"] = newName
		end
	end
end

function setItemValue(itemSlot, newCount)
	if (itemSlot > -1 and newCount > -1) then
		if activeSide == "craft" then
			newMenu = "bag"
		else
			newMenu = activeSide
		end
		triggerServerEvent("updateItemValue", localPlayer, localPlayer, elementSource, itemSlot, newCount, inventoryItems[elementSource][newMenu][itemSlot])

		inventoryItems[elementSource][newMenu][itemSlot]["value"] = newCount
		if (elementSource == localPlayer) then
			playerItems[elementSource][newMenu][itemSlot]["value"] = newCount
		end
	end
end

function addItemValue(itemSlot, newCount)
	if (itemSlot > -1) then
		if activeSide == "craft" then
			newMenu = "bag"
		else
			newMenu = activeSide
		end

		local oldCount = inventoryItems[elementSource][newMenu][itemSlot]["value"]

		local newValue = oldCount + newCount 

		if newValue < 0 then
			newValue = 0
		end

		triggerServerEvent("updateItemValue", localPlayer, localPlayer, elementSource, itemSlot, newValue, inventoryItems[elementSource][newMenu][itemSlot])

		inventoryItems[elementSource][newMenu][itemSlot]["value"] = newValue
		if (elementSource == localPlayer) then
			playerItems[elementSource][newMenu][itemSlot]["value"] = newValue
		end
	end
end

function delItemSlot(itemSlot)
	if (itemSlot > -1) then
		inventoryItems[elementSource][activeSide][itemSlot] = nil
		if (elementSource == localPlayer) then
			playerItems[elementSource][activeSide][itemSlot] = nil
		end		
	end
end

function getAllItemWeight()
	local bagWeight = 0
	local keyWeight = 0
	local licensWeight = 0
	local vehWeight = 0
	local objectWeight = 0
	if isElement(elementSource) then
		if getElementType(elementSource) == "player" then
			if inventoryItems[elementSource]["bag"] then
				for i = 1, row * column do
					if (inventoryItems[elementSource]["bag"][i]) then
						local elem1 = tonumber(getItemWeight(inventoryItems[elementSource]["bag"][i]["id"])) 
						local elem2 = tonumber(inventoryItems[elementSource]["bag"][i]["count"])

						bagWeight = bagWeight + elem1*elem2
					end
				end
			end
			if inventoryItems[elementSource]["key"] then
				for i = 1, row * column do
					if (inventoryItems[elementSource]["key"][i]) then
						keyWeight = keyWeight + (getItemWeight(inventoryItems[elementSource]["key"][i]["id"]) * inventoryItems[elementSource]["key"][i]["count"])
					end
				end
			end
			if inventoryItems[elementSource]["licens"] then
				for i = 1, row * column do
					if (inventoryItems[elementSource]["licens"][i]) then
						licensWeight = licensWeight + (getItemWeight(inventoryItems[elementSource]["licens"][i]["id"]) * inventoryItems[elementSource]["licens"][i]["count"])
					end	
				end
			end
		end
		if getElementType(elementSource) == "vehicle" then
			if inventoryItems[elementSource] then
				if inventoryItems[elementSource]["vehicle"] then
					for i = 1, row * column do
						if (inventoryItems[elementSource]["vehicle"][i]) then
							vehWeight = vehWeight + (getItemWeight(inventoryItems[elementSource]["vehicle"][i]["id"]) * inventoryItems[elementSource]["vehicle"][i]["count"])
						end	
					end
				end
			end
		end
		if getElementType(elementSource) == "object" then
			if inventoryItems[elementSource]["object"] then
				for i = 1, row * column do
					if (inventoryItems[elementSource]["object"][i]) then
						objectWeight = objectWeight + (getItemWeight(inventoryItems[elementSource]["object"][i]["id"]) * inventoryItems[elementSource]["object"][i]["count"])
					end	
				end
			end
		end
	end
	--outputDebugString("bag: "..bagWeight..", licens: "..licensWeight..", key: "..keyWeight..", veh: "..vehWeight..", obj: "..objectWeight)
	return bagWeight + licensWeight + keyWeight + vehWeight + objectWeight
end

function delItem(itemSlot,state, side)
	if not state then
		state = 0
	end
	if (itemSlot > -1) then
		if not side then 
			if activeSide == "craft" then
				newMenu = "bag"
			else
				newMenu = activeSide
			end
		else
			newMenu = side
		end
		
		if state == 0 then
			if getElementType(elementSource) == "player" then
				for i=1, actionSlots do
					if actionBarItems[elementSource][i] then
						if actionBarItems[elementSource][i][1] == inventoryItems[elementSource][newMenu][itemSlot]["dbid"] then
							actionBarItems[elementSource][i] = {-1, -1, ""}
							triggerServerEvent("deleteActionBarItem",localPlayer,localPlayer,i)
						end
					end
				end
			end
		end
		
		triggerServerEvent("deleteItem", localPlayer, localPlayer, elementSource, inventoryItems[elementSource][newMenu][itemSlot],state)
		inventoryItems[elementSource][newMenu][itemSlot] = nil
		if (elementSource == localPlayer) then
			playerItems[elementSource][newMenu][itemSlot] = nil
		end	
	end
end

function takeStatus(itemSlot, statusMinus)
	itemSlot = tonumber(itemSlot)
	if (itemSlot > -1) then
		if tonumber(inventoryItems[elementSource]["bag"][itemSlot]["health"]) - tonumber(statusMinus) <= 0 then
			triggerServerEvent("deleteItem", localPlayer, localPlayer, elementSource, inventoryItems[elementSource][activeSide][itemSlot])
			inventoryItems[elementSource][activeSide][itemSlot] = nil
			if (elementSource == localPlayer) then
				playerItems[elementSource][activeSide][itemSlot] = nil
			end	
			local activeItemID = getElementData(localPlayer,"active:itemID")
			local activeitemSlot = getElementData(localPlayer,"active:itemSlot")
			local activeWeapSlot = getElementData(localPlayer,"active:weaponSlot")
			if(activeItemID>-1) and (activeitemSlot>-1) then
				if activeWeaponSlot == itemSlot then
					activeWeaponSlot = -1
					activeAmmoSlot = - 1
					setElementData(localPlayer,"active:weaponSlot",-1)
					setElementData(localPlayer,"active:itemID",-1)
					setElementData(localPlayer,"active:itemSlot",-1)
					triggerServerEvent("elveszfegyot",localPlayer,localPlayer)
				end
			end
			return
		else
			triggerServerEvent("takeStatus", localPlayer, localPlayer, elementSource, inventoryItems[elementSource]["bag"][itemSlot], tonumber(inventoryItems[elementSource]["bag"][itemSlot]["health"]) - statusMinus)
			inventoryItems[elementSource]["bag"][itemSlot]["health"] = tonumber(inventoryItems[elementSource]["bag"][itemSlot]["health"]) - statusMinus
			return
		end	
	end
end

function takeItem(item)
	local elem = 0

	thisMenu = items[item].typ

	for i = 1, row * column do
		if (inventoryItems[elementSource][thisMenu][i]) then
			if item == inventoryItems[elementSource][thisMenu][i]["id"] then
				elem = elem+1
				if elem == 1 then
					if inventoryItems[elementSource][thisMenu][i]["count"] > 1 then
						setItemCount(i,inventoryItems[elementSource][thisMenu][i]["count"]-1)
					else
						delItem(i, 0, thisMenu)
					end
				end
			end
		end
	end
end
addEvent("takeItemServer",true)
addEventHandler("takeItemServer",getRootElement(),takeItem)

function setItemSlot(oldSlot, newSlot)
	if (oldSlot > -1 and newSlot > -1) then
		inventoryItems[elementSource][activeSide][newSlot] = inventoryItems[elementSource][activeSide][oldSlot]
		if (elementSource == localPlayer) then
			playerItems[elementSource][activeSide][newSlot] = inventoryItems[elementSource][activeSide][oldSlot]
		end
		updateClick = updateClick+1
		triggerServerEvent("updateItemSlot", localPlayer, localPlayer, elementSource, newSlot, inventoryItems[elementSource][activeSide][oldSlot],oldSlot,updateClick)
	end
end

function hideMove()
	startTick = -1
	movedItem = nil
	movedSlot = -1
	inMove = false
end

function hideClone()
	clonedItem = nil
	clonedSlot = -1
	inClone = false
end

function hasActionItem(actionItem)
	hasTheItem = false
	if (actionItem) then
		if (playerItems[elementSource]["bag"] and playerItems[elementSource]["key"] and playerItems[elementSource]["licens"]) then
			for i = 1, row * column do
				if (playerItems[elementSource]["bag"][i]) then
					if (actionItem["dbid"] == playerItems[elementSource]["bag"][i]["dbid"]) then
						hasTheItem = true
					end
				end
			end
			for i = 1, row * column do
				if (playerItems[elementSource]["key"][i]) then
					if (actionItem["dbid"] == playerItems[elementSource]["key"][i]["dbid"]) then
						hasTheItem = true
					end
				end
			end
			for i = 1, row * column do
				if (playerItems[elementSource]["licens"][i]) then
					if (actionItem["dbid"] == playerItems[elementSource]["licens"][i]["dbid"]) then
						hasTheItem = true
					end
				end	
			end
			if hasTheItem then
				return true
			else
				return false
			end
			return false
		end
		return false
	end
	return false
end

function giveItem(itemID, itemValue, itemCount, itemDuty, adminlog)
	if not adminlog then adminlog = false end
	triggerServerEvent("giveItem", localPlayer, localPlayer, itemID, itemValue, itemCount, itemDuty, _, _, _, _, adminlog)
end

function hasItem(itemID, itemValue)
	if (not itemValue) then
		if (playerItems[elementSource]["bag"] and playerItems[elementSource]["key"] and playerItems[elementSource]["licens"] and getElementType(elementSource) == "player") then
			for i = 1, row * column do
				if (playerItems[elementSource]["bag"][i]) then
					if (itemID == playerItems[elementSource]["bag"][i]["id"]) then
						itemValue = playerItems[elementSource]["bag"][i]["value"]
						return true, itemID, itemValue, i, "bag", countItemsInInventory(itemID),playerItems[elementSource]["bag"][i]["count"]
					end
				end
			end
			for i = 1, row * column do
				if (playerItems[elementSource]["key"][i]) then
					if (itemID == playerItems[elementSource]["key"][i]["id"]) then
						itemValue = playerItems[elementSource]["key"][i]["value"]
						return true, itemID, itemValue, i, "key"
					end
				end
			end
			for i = 1, row * column do
				if (playerItems[elementSource]["licens"][i]) then
					if (itemID == playerItems[elementSource]["licens"][i]["id"]) then
						itemValue = playerItems[elementSource]["licens"][i]["value"]
						return true, itemID, playerItems[elementSource]["licens"][i]["value"], i, "licens"
					end
				end	
			end
			return false
		end
		return false
	else
		if (playerItems[elementSource]["bag"] and playerItems[elementSource]["key"] and playerItems[elementSource]["licens"] and getElementType(elementSource) == "player") then
			for i = 1, row * column do
				if (playerItems[elementSource]["bag"][i]) then
					if (itemID == playerItems[elementSource]["bag"][i]["id"] and tonumber(itemValue) == tonumber(playerItems[elementSource]["bag"][i]["value"])) then
						return true, itemID, tonumber(itemValue), i
					end
				end
			end
			for i = 1, row * column do
				if (playerItems[elementSource]["key"][i]) then
					if (itemID == playerItems[elementSource]["key"][i]["id"] and tonumber(itemValue) == tonumber(playerItems[elementSource]["key"][i]["value"])) then
						return true, itemID, tonumber(itemValue), i
					end
				end
			end
			for i = 1, row * column do
				if (playerItems[elementSource]["licens"][i]) then
					if (itemID == playerItems[elementSource]["licens"][i]["id"] and tonumber(itemValue) == tonumber(playerItems[elementSource]["licens"][i]["value"])) then
						return true, itemID, tonumber(itemValue), i
					end
				end	
			end
			return false
		end
		return false
	end
	return false
end

function countItemsInInventory(itemID, count)
	if (playerItems[elementSource]["bag"]) then
		local count = 0
		for i = 1, row * column do
			if (playerItems[elementSource]["bag"][i]) then
				if (itemID == playerItems[elementSource]["bag"][i]["id"]) then
					count = count + 1
				end
			end
		end
		return count
	end
	return false
end

function hasItemOnSlot(slot)
	if (playerItems[elementSource]["bag"][slot] and tonumber(playerItems[elementSource]["bag"][slot]["id"] or -1) > -1) then
		return true
	end
	return false
end

addEventHandler ( "onClientPlayerWeaponFire", getLocalPlayer(),function(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement )
	local activeItemID = getElementData(localPlayer,"active:itemID")
	local activeitemSlot = getElementData(localPlayer,"active:itemSlot")
	if(activeItemID>-1) and (activeitemSlot>-1) then
		if (getElementData(localPlayer, "playerInWeaponSkilling") or false) then return end
		local witem = tonumber(getElementData(localPlayer,"active:itemID"))
		local wslot = tonumber(getElementData(localPlayer,"active:itemSlot"))
		if (items[witem].isWeapon) then
			if(tonumber(playerItems[localPlayer]["bag"][wslot]["count"] or -1)<=1)then
				activeAmmoSlot = -1
				delItem(wslot)

				local weaponAmmoBoxID = tonumber(items[playerItems[localPlayer]["bag"][activeWeaponSlot]["id"]].ammo)
				local statja,itemidje,valueja,ammoSlot,typ,_,darab = hasItem(weaponAmmoBoxID)

				if statja then
					activeAmmoSlot = ammoSlot

					triggerServerEvent("adjfgytolivel", localPlayer, localPlayer, weapon, darab, items[playerItems[localPlayer]["bag"][activeWeaponSlot]["value"]])

					setElementData(localPlayer,"active:itemSlot",activeAmmoSlot)
				else
					activeWeaponSlot = -1
					setElementData(localPlayer,"active:itemID",-1)
					setElementData(localPlayer,"active:itemSlot",-1)
				end
			else
				setItemCount(wslot,playerItems[localPlayer]["bag"][wslot]["count"]-1)
			end

			if hotTable[getPedWeapon(localPlayer)] then
				randState = math.random(1,7)
				weaponHot = weaponHot+hotTable[getPedWeapon(localPlayer)]
				setElementData(localPlayer,"weap:hot",getElementData(localPlayer,"weap:hot")+hotTable[getPedWeapon(localPlayer)])
			end
		end
	end
end)

addEvent("activeWeapon",true)
addEventHandler("activeWeapon",getRootElement(),function(slot)
	activeWeaponSlot = slot
end)

local maxAmmoInClips = {
	[22] = 17,
	[24] = 7,
	[25] = 1,
	[26] = 2,
	[27] = 7,
	[28] = 50,
	[29] = 30,
	[32] = 50,
	[30] = 30,
	[31] = 50,
	[33] = 1,
	[34] = 1,
	[35] = 1,
	[36] = 1,
	[37] = 50,
	[38] = 500,
}

bindKey("R", "up", function()
	if activeWeaponSlot > 0 and activeAmmoSlot > 0 then 
		print(getPedTotalAmmo(localPlayer))
		if getPedTotalAmmo(localPlayer) < maxAmmoInClips[getPedWeapon(localPlayer)] then return end
		if getPedAmmoInClip(localPlayer) < maxAmmoInClips[getPedWeapon(localPlayer)] then
			triggerServerEvent("inventory > reloadWeaponAmmo", resourceRoot, localPlayer)
		end
	end
end)

function deleteActiveIdentitySlot()
	if activeIdentity >= 1 then
		delItem(activeIdentity)
		activeIdentity = -1
	end
end

function deleteActiveIdentity()
	if activeIdentity >= 1 then
		activeIdentity = -1
	end
end

addCommandHandler("itemlist",function(cmd,typ)
	if getElementData(localPlayer, "user:admin") >= 7 then
		if not listShow then
			listShow = true

			addEventHandler("onClientRender", getRootElement(), renderItemlist)
			addEventHandler("onClientKey", root, itemListClick)
		else
			listShow = false
			removeEventHandler("onClientRender", getRootElement(), renderItemlist)
			removeEventHandler("onClientKey", root, itemListClick)
		end
	end
end)


function upList()
	if listShow then
		--if guiGetText(searchGui) == "" then
			listWheel = listWheel - 1
			if listWheel < 1 then
				listWheel = 0
			end
		--end
	end
end
bindKey("mouse_wheel_up", "down",upList)
bindKey("arrow_u", "down",upList)

function downList()
	if listShow then
		--if guiGetText(searchGui) == "" then
			listWheel = listWheel + 1

			if listWheel > math.floor(#items / 11) - 3 then
				listWheel = math.floor(#items / 11) - 3
			end
		--end
	end
end
bindKey("mouse_wheel_down", "down",downList)
bindKey("arrow_d", "down",downList)

addEventHandler("onClientClick",getRootElement(),function(button,state)
	if listShow then
		if button == "left" and state == "down" then
			if core:isInSlot(listPos[1]+307,listPos[2]+5,18,18) then
				listShow = false
				removeEventHandler("onClientRender", getRootElement(), renderItemlist)
				if isElement(searchGui) then
					destroyElement(searchGui)
				end
			elseif core:isInSlot(listPos[1]+10,listPos[2]+495,listBox[1]-20,25) then
				if isElement(searchGui) then
					if guiEditSetCaratIndex(searchGui, string.len(guiGetText(searchGui))) then
						guiBringToFront(searchGui)
					end
				end
			elseif core:isInSlot(listPos[1]+176,listPos[2]+495,22,22) then
				
			end
		end
	end
end)

addEvent("updateItemClick",true)
addEventHandler("updateItemClick",getRootElement(),function()
	updateClick = 0
end)

function openVehicleInventory(vehicle)
	if (tonumber(getElementData(vehicle, "veh:id") or 0) > 0 ) then
		if showInventory then
			if core:isInSlot(moveX-4,moveY-16,pW+12,pH+64) then
				return
			end
		end
		if isPedInVehicle(localPlayer) then return end
		--if not getElementData(localPlayer,"mechanicing") then
			if (isVehicleLocked(vehicle)) then
				outputChatBox(core:getServerPrefix("red-dark", "Csomagtartó", 3).."A kiválasztott jármű csomagtartója zárva van.",61,122,188,true)
			else
				if getElementData(vehicle,"veh:use") then
					outputChatBox(core:getServerPrefix("red-dark", "Csomagtartó", 3).."A kiválasztott jármű csomagtartóját éppen használják.",61,122,188,true)
				else
					if not showInventory then 
						showInventory = true
						addEventHandler("onClientRender", getRootElement(), renderInventory)
					end
					invMenu = 1
					activeSide = "vehicle"
					elementSource = vehicle

					inventoryAnimating = true
					animState = "open"
					tick = getTickCount()
					setTimer(function() inventoryAnimating = false end, animTime, 1)

					setElementData(vehicle, "veh:player", localPlayer)
					setElementData(vehicle, "veh:use", true)
					triggerServerEvent("getElementItems", localPlayer, localPlayer, clickedElement, 2)
					setElementData(localPlayer,"show:inv",vehicle)
					
					triggerServerEvent("doorState", localPlayer, vehicle, 1)
					chat:sendLocalMeAction("belenézett egy "..getVehicleName(vehicle).." csomagtartójába.")

					closeTimer = setTimer(function() 
						if core:getDistance(vehicle, localPlayer) > 3.5 then 
							inventoryAnimating = true
							animState = "close"
							tick = getTickCount()

							if activeSide == "vehicle" then 
								setElementData(elementSource, "veh:use", false)
							end

							if isTimer(closeTimer) then 
								killTimer(closeTimer)
							end


							if activeSide == "vehicle" then 
								--openInventory(localPlayer) 
								
								setElementData(elementSource, "veh:use", false)
								triggerServerEvent("getElementItems", localPlayer, localPlayer, localPlayer, 2, playerItems)
							end

							openDelayTimer = setTimer(function() 
								if isTimer(openDelayTimer) then 
									killTimer(openDelayTimer)
									openDelayTimer = false
									--animState = "open"
									openInventory(localPlayer)
									inventoryAnimating = false
								end
							end, 1000, 1)
						end
					end, 100, 0)
				end
			end
		--end
	end
end

local admin = exports.oAdmin
admin:addAdminCMD("giveitem", 7, "Item adása játékosnak")
admin:addAdminCMD("givelicense", 5, "Igazolvány adása játékosnak")
admin:addAdminCMD("changelock", 7, "Zár lecserélése")
admin:addAdminCMD("delplayeritem", 7, "Játékostól item törlése")
admin:addAdminCMD("fixinv", 4, "Inventory fixelés")
admin:addAdminCMD("showinv", 2, "Játékos inventoryjának megtekintése")