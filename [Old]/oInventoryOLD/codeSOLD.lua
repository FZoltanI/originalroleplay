local func = {}
func["dbConnect"] = exports.oMysql:getDBConnection()
weapons = {}
itemCache = {}

addEventHandler("onResourceStart", resourceRoot,function()
	for k,v in ipairs(getElementsByType("vehicle")) do
		setElementData(v,"veh:use",false)
		setElementData(v,"veh:player",nil)
	end
	for k,v in ipairs(getElementsByType("player")) do
		weapons[v] = {}
		itemCache[v] = {
			["bag"] = {},
			["key"] = {},
			["licens"] = {},
			["vehicle"] = {},
			["object"] = {},
		}
		loadInventoryElement(v)
	end
	for k,v in ipairs(getElementsByType("vehicle")) do
		itemCache[v] = {
			["bag"] = {},
			["key"] = {},
			["licens"] = {},
			["vehicle"] = {},
			["object"] = {},
		}
		loadInventoryElement(v)
	end
end)

addEventHandler("onPlayerSpawn",getRootElement(),
	function()
		weapons[source] = {}
		itemCache[source] = {
			["bag"] = {},
			["key"] = {},
			["licens"] = {},
			["vehicle"] = {},
			["object"] = {},
		}
		loadInventoryElement(source)
	end 
)

function loadInventoryElement(element)
	local elementTypes = getTypeOfElement(element)
	local elementOwnerID 

	itemCache[element] = {
		["bag"] = {},
		["key"] = {},
		["licens"] = {},
		["vehicle"] = {},
		["object"] = {},
	}
	
	if elementTypes[1] == "vehicle" then 
		elementOwnerID = tonumber(getElementData(element, "veh:id"))
	elseif elementTypes[1] == "object"  then 
		elementOwnerID = tonumber(getElementData(element, "dbid"))
	else
		elementOwnerID = tonumber(getElementData(element, "user:id"))
	end
	
	if not itemCache[element] then
		itemCache[element] = {
			["bag"] = {},
			["key"] = {},
			["licens"] = {},
			["vehicle"] = {},
			["object"] = {},
		}
	end

	dbQuery(function(qh, element)
		local res, rows, err = dbPoll(qh, 100)

		if rows > 0 then
			for k, row in pairs(res) do
				itemCache[element][tostring(row["type"])][tonumber(row["slot"])] = {
					["dbid"] = tonumber(row["id"]),
					["id"] = tonumber(row["itemid"]),
					["value"] = tostring(row["value"]),
					["count"] = tonumber(row["count"]),
					["duty"] = tonumber(row["dutyitem"]),
					["slot"] = tonumber(row["slot"]),	
					["health"] = tonumber(row["itemState"]),	
					["name"] = tostring(row["name"]),
					["weaponserial"] = tostring(row["weaponserial"]),
				}
			end
		end
	end, {element}, func["dbConnect"], "SELECT * FROM `items` WHERE `owner` = ?",elementOwnerID)
end

func["onStop"] = function()
	local element = 0
	for k,v in ipairs(getElementsByType("player")) do
		if getElementData(v,"user:loggedin") then
			if getElementData(v,"user:id") > 0 then
				if itemCache[v] then
					saveOneElementInventory(v)
					element = element + 1
				end
			end
		end
	end
	for k,v in ipairs(getElementsByType("vehicle")) do
		local vehID = getElementData(v, "veh:id") or 0
		vehID = tonumber(vehID)
		if tonumber(vehID) then 
			if (vehID > 0 )then
				if itemCache[v] then
					saveOneElementInventory(v)
					element = element + 1
				end	
			end
		end
	end
	for k,v in ipairs(getElementsByType("object", getResourceRootElement(getResourceFromName("oInventory")))) do
		if getElementData(v,"dbid") and getElementData(v,"dbid") > 0 then
			if itemCache[v] then
				saveOneElementInventory(v)
				element = element + 1
			end
		end
	end

	outputDebugString(element.."db element inventory tartalma sikeresen elementve!")
end
addEventHandler("onResourceStop",resourceRoot,func["onStop"])

function saveAllItem(player)
	if getElementData(player, "user:admin") >= 10 then
		local element = 0
		for k,v in ipairs(getElementsByType("player")) do
			if getElementData(v,"user:loggedin") then
				if getElementData(v,"user:id") > 0 then
					if itemCache[v] then
						saveOneElementInventory(v)
						element = element + 1
					end
				end
			end
		end
		for k,v in ipairs(getElementsByType("vehicle")) do
			local vehID = getElementData(v, "veh:id") or 0
			vehID = tonumber(vehID)
			if tonumber(vehID) then 
				if (vehID > 0 )then
					if itemCache[v] then
						saveOneElementInventory(v)
						element = element + 1
					end	
				end
			end
		end
		for k,v in ipairs(getElementsByType("object", getResourceRootElement(getResourceFromName("oInventory")))) do
			if getElementData(v,"dbid") and getElementData(v,"dbid") > 0 then
				if itemCache[v] then
					saveOneElementInventory(v)
					element = element + 1
				end
			end
		end

		outputDebugString(element.."db element inventory tartalma sikeresen elementve!")
	end
end
addCommandHandler("saveallitem", saveAllItem)

function saveOneElementInventory(element)
	if getElementType(element) == "player" then
		for i = 1, row * column do
			if (itemCache[element]["bag"][i]) then
				local dbid = tonumber(itemCache[element]["bag"][i]["dbid"])
				local item = tonumber(itemCache[element]["bag"][i]["id"])
				local value = tostring(itemCache[element]["bag"][i]["value"])
				local count = tonumber(itemCache[element]["bag"][i]["count"])
				local duty = tonumber(itemCache[element]["bag"][i]["duty"])
				local state = tonumber(itemCache[element]["bag"][i]["health"])
				local name = tostring(itemCache[element]["bag"][i]["name"])
				local weaponserial = tostring(itemCache[element]["bag"][i]["weaponserial"])
				dbExec(func["dbConnect"],"UPDATE items SET slot = ?, value = ?, count = ?, type = ?, owner = ?, dutyitem = ?, itemState = ?, name = ?, weaponserial = ? WHERE id = ?",i,value,count,"bag",getElementData(element,"user:id"),duty,state,name,weaponserial,dbid)
			end
		end
		for i = 1, row * column do
			if (itemCache[element]["key"][i]) then
				local dbid = tonumber(itemCache[element]["key"][i]["dbid"])
				local item = tonumber(itemCache[element]["key"][i]["id"])
				local value = tostring(itemCache[element]["key"][i]["value"])
				local count = tonumber(itemCache[element]["key"][i]["count"])
				local duty = tonumber(itemCache[element]["key"][i]["duty"])
				local state = tonumber(itemCache[element]["key"][i]["health"])
				local name = tostring(itemCache[element]["key"][i]["name"])
				local weaponserial = tostring(itemCache[element]["key"][i]["weaponserial"])
				dbExec(func["dbConnect"],"UPDATE items SET slot = ?, value = ?, count = ?, type = ?, owner = ?, dutyitem = ?, itemState = ?, name = ?, weaponserial = ? WHERE id = ?",i,value,count,"key",getElementData(element,"user:id"),duty,state,name,weaponserial,dbid)
			end
		end
		for i = 1, row * column do
			if (itemCache[element]["licens"][i]) then
				local dbid = tonumber(itemCache[element]["licens"][i]["dbid"])
				local item = tonumber(itemCache[element]["licens"][i]["id"])
				local value = tostring(itemCache[element]["licens"][i]["value"])
				local count = tonumber(itemCache[element]["licens"][i]["count"])
				local duty = tonumber(itemCache[element]["licens"][i]["duty"])
				local state = tonumber(itemCache[element]["licens"][i]["health"])
				local name = tostring(itemCache[element]["licens"][i]["name"])
				local weaponserial = tostring(itemCache[element]["licens"][i]["weaponserial"])
				dbExec(func["dbConnect"],"UPDATE items SET slot = ?, value = ?, count = ?, type = ?, owner = ?, dutyitem = ?, itemState = ?, name = ?, weaponserial = ? WHERE id = ?",i,value,count,"licens",getElementData(element,"user:id"),duty,state,name,weaponserial,dbid)
			end
		end
	else
		for i = 1, row * column do
			if (itemCache[element][getTypeOfElement(element)[1]][i]) then
				local dbid = tonumber(itemCache[element][getTypeOfElement(element)[1]][i]["dbid"])
				local item = tonumber(itemCache[element][getTypeOfElement(element)[1]][i]["id"])
				local value = tostring(itemCache[element][getTypeOfElement(element)[1]][i]["value"])
				local count = tonumber(itemCache[element][getTypeOfElement(element)[1]][i]["count"])
				local duty = tonumber(itemCache[element][getTypeOfElement(element)[1]][i]["duty"])
				local state = tonumber(itemCache[element][getTypeOfElement(element)[1]][i]["health"])
				local name = tostring(itemCache[element][getTypeOfElement(element)[1]][i]["name"])
				local weaponserial = tostring(itemCache[element][getTypeOfElement(element)[1]][i]["weaponserial"])
				dbExec(func["dbConnect"],"UPDATE items SET slot = ?, value = ?, count = ?, type = ?, owner = ?, dutyitem = ?, itemState = ?, name = ?, weaponserial = ? WHERE id = ?",i,value,count,getTypeOfElement(element)[1],getElementData(element,getTypeOfElement(element)[2]),duty,state,name,weaponserial,dbid)
			end
		end
	end
end

function getElementItems(playerSource, element, playerValue, itemsNow)
	if (element) then
		if not itemCache[element] then
			itemCache[element] = {
				["bag"] = {},
				["key"] = {},
				["licens"] = {},
				["vehicle"] = {},
				["object"] = {},
			}
		end
		if (tonumber(playerValue) == 1 or tonumber(playerValue) == 2) then
			if (itemCache == itemsNow) then 
				print("nincs változás")
			else
				print("update")
				triggerClientEvent(playerSource, "setElementItems", playerSource, itemCache, playerValue, element)	
			end
		else
			return itemCache
		end		
	end
end
addEvent("getElementItems", true)
addEventHandler("getElementItems", getRootElement(), getElementItems)

function takeStatus(playerSource, elementSource, itemData, newStatus)
	if (newStatus) then
		itemCache[elementSource][getTypeOfElement(elementSource,tonumber(itemData["id"]))[1]][tonumber(itemData["slot"])]["health"] = newStatus
	end
end
addEvent("takeStatus", true)
addEventHandler("takeStatus", getRootElement(), takeStatus)

function updateItemSlot(playerSource, elementSource, newSlot, oldItem,oldSlot,click)
	if (newSlot and oldItem) then
		if click == 1 then
			itemCache[elementSource][getTypeOfElement(elementSource,tonumber(oldItem["id"]))[1]][tonumber(oldSlot)] = nil
			itemCache[elementSource][getTypeOfElement(elementSource,tonumber(oldItem["id"]))[1]][tonumber(newSlot)] = {
				["dbid"] = tonumber(oldItem["dbid"]),
				["id"] = tonumber(oldItem["id"]),
				["value"] = tostring(oldItem["value"]),
				["count"] = tonumber(oldItem["count"]),
				["duty"] = tonumber(oldItem["duty"]),
				["slot"] = tonumber(newSlot),	
				["health"] = tonumber(oldItem["health"]),	
				["name"] = tostring(oldItem["name"]),
				["weaponserial"] = tostring(oldItem["weaponserial"]),
			}

			triggerClientEvent(playerSource,"updateItemClick",playerSource)
		end
		
		getElementItems(playerSource, elementSource, 2)
	else
		triggerClientEvent(playerSource,"updateItemClick",playerSource)
	end
end
addEvent("updateItemSlot", true)
addEventHandler("updateItemSlot", getRootElement(), updateItemSlot)

function updateItemCount(playerSource, elementSource, itemSlot, newCount,itemData)
	if (newCount) then
		itemCache[elementSource][getTypeOfElement(elementSource,tonumber(itemData["id"]))[1]][tonumber(itemSlot)]["count"] = newCount
	end
end
addEvent("updateItemCount", true)
addEventHandler("updateItemCount", getRootElement(), updateItemCount)

function updateItemName(playerSource, elementSource, itemSlot, newName, itemData)
	if (newName) then
		itemCache[elementSource][getTypeOfElement(elementSource,tonumber(itemData["id"]))[1]][tonumber(itemData["slot"])]["name"] = newName
	end
end
addEvent("updateItemName", true)
addEventHandler("updateItemName", getRootElement(), updateItemName)

function updateItemValue(playerSource, elementSource, itemSlot, newValue, itemData)
	if (newValue) then
		itemCache[elementSource][getTypeOfElement(elementSource,tonumber(itemData["id"]))[1]][tonumber(itemData["slot"])]["value"] = newValue
	end
end
addEvent("updateItemValue", true)
addEventHandler("updateItemValue", getRootElement(), updateItemValue)

function deleteItem(playerSource, elementSource,itemData,state)
	if not state then
		state = 0
	end
	if (elementSource) then
		if state == 0 then
			if getElementType(elementSource) == "player" then
				func["delActionbarItem"](elementSource,itemData["dbid"])
			end
		end
		dbExec(func["dbConnect"],"DELETE FROM `items` WHERE `id` = ?",itemData["dbid"])
		itemCache[elementSource][getTypeOfElement(elementSource,tonumber(itemData["id"]))[1]][tonumber(itemData["slot"])] = nil
		getElementItems(playerSource, elementSource, 2)
	end
end
addEvent("deleteItem", true)
addEventHandler("deleteItem", getRootElement(), deleteItem)

func["delActionbarItem"] = function(element,itemDBID)
	dbQuery(function(q, element)
		local rs, rws, errs = dbPoll(q, 0)
		if rws > 0 then
			print(toJSON(rs))
			for k,r in pairs(rs) do
				dbExec(func["dbConnect"], "DELETE FROM `actionbaritems` WHERE `itemdbid`=?",r["itemdbid"])
				triggerClientEvent(element,"delActionBarSlot",element,element,r["actionslot"])
			end
		end
	end, {element}, func["dbConnect"],"SELECT * FROM `actionbaritems` WHERE `itemdbid` = ?", itemDBID)
end

addEventHandler("onPlayerQuit", root, function()
	local showElement = getElementData(source,"show:inv")
	if getElementData(source, "user:loggedin") then 
		if isElement(showElement) then
			if getElementType(showElement) == "vehicle" then
				if (getElementData(showElement, "veh:use") or false) then
					if getElementData(showElement, "veh:player") == source then
						setElementData(showElement, "veh:player", nil)
						setElementData(showElement, "veh:use", false)
						setVehicleDoorOpenRatio(showElement,1,0,1200)
					end
				end
			end
			if getElementType(showElement) == "object" then
				if getElementModel(showElement) == 2332 then
					if (getElementData(showElement, "safe:use") or false) then
						if getElementData(showElement, "safe:player") == source then
							setElementData(showElement, "safe:player", nil)
							setElementData(showElement, "safe:use", false)
						end
					end
				end
			end
		end
	end
end)

addCommandHandler("fixinv",function(playerSource,cmd)
	if getElementData(playerSource,"user:admin") >= 4 then
		local playerX,playerY,playerZ = getElementPosition(playerSource)
		for k,v in ipairs(getElementsByType("object")) do
			if getElementData(v,"szef") then
				if getElementData(v,"safe:use") then
					local objectX,objectY,objectZ = getElementPosition(v)
					if getDistanceBetweenPoints3D(playerX,playerY,playerZ,objectX,objectY,objectZ) <= 2 then
						setElementData(v, "safe:player", nil)
						setElementData(v, "safe:use", false)
						outputChatBox(core:getServerPrefix("green-dark", "Inventory", 3).."Sikeresen fix-eltél egy"..color.."'széf'#ffffff inventory-t.",playerSource,61,122,188,true)
						return
					end
				end
			end
		end
		
		for k,v in ipairs(getElementsByType("vehicle")) do
			if getElementData(v,"veh:id") and getElementData(v,"veh:id") > 0 then
				if getElementData(v, "veh:use") then
					local vehicleX,vehicleY,vehicleZ = getElementPosition(v)
					if getDistanceBetweenPoints3D(playerX,playerY,playerZ,vehicleX,vehicleY,vehicleZ) <= 2 then
						setElementData(v, "veh:player", nil)
						setElementData(v, "veh:use", false)
						setVehicleDoorOpenRatio(v,1,0,1200)
						outputChatBox(core:getServerPrefix("green-dark", "Inventory", 3).."Sikeresen fix-eltél egy "..color.."'csomagtartó'#ffffff inventory-t.",playerSource,61,122,188,true)
					end
				end
			end
		end
		
	end
end)

function createNewItem(playerSource, elementSource, itemID, itemSlot, itemCount, itemDuty, itemValue,itemHealth,itemName,weaponserial,oldDBID)
	if (itemID and itemSlot) then
		local elementType = getTypeOfElement(elementSource)
		local elementOwnerID = tonumber(getElementData(elementSource,"user:id"))
		dbQuery(function(qh,itemID,elementOwnerID,itemSlot)
			local query, query_lines, id = dbPoll(qh, 0)
			local id = tonumber(id) or 0
			if id > 0 then
				itemCache[elementSource][getTypeOfElement(elementSource,tonumber(itemID))[1]][tonumber(itemSlot)] = {
					["dbid"] = tonumber(id),
					["id"] = tonumber(itemID),
					["value"] = tostring(itemValue),
					["count"] = tonumber(itemCount),
					["duty"] = tonumber(itemDuty),
					["slot"] = tonumber(itemSlot),	
					["health"] = tonumber(itemHealth),	
					["name"] = tostring(itemName),
					["weaponserial"] = tostring(weaponserial),
				}
				if getElementType(elementSource) == "player" and weaponModels[itemID] then
					if isElement(weapons[elementSource][oldDBID]) then
						weapons[elementSource][id] = weapons[elementSource][oldDBID]
					end
				end
				getElementItems(playerSource, elementSource, 2)
			end
		end,{itemID,elementOwnerID,itemSlot},func["dbConnect"], "INSERT INTO `items` SET `itemid` = ?, `slot` = ?, `owner` = ?, `value` = ?, `count` = ?, `type` = ?, `dutyitem` = ?, `itemState` = ?, `name` = ?, `weaponserial` = ?",itemID, itemSlot, elementOwnerID, itemValue, itemCount, getTypeOfElement(elementSource,tonumber(itemID))[1], itemDuty,itemHealth,itemName,weaponserial)
	end
end
addEvent("createNewItem", true)
addEventHandler("createNewItem", getRootElement(), createNewItem)

function tradeItem(playerSource, elementSource, activeElementSource, activeItem,click)
	if (playerSource and elementSource and activeItem) then
		if click == 1 then
			local elementType = getTypeOfElement(elementSource)
			local itemDBID = activeItem["dbid"]
			
			local elementOwnerID = tonumber(getElementData(elementSource, "user:id"))
			--local elementOwnerType = elementType[1]
			if not itemCache[elementSource] then
				itemCache[elementSource] = {
					["bag"] = {},
					["key"] = {},
					["licens"] = {},
					["vehicle"] = {},
					["object"] = {},
				}
			end

			local weight = getElementItemsWeight(elementSource)
			if weight + (getItemWeight(activeItem["id"]) * activeItem["count"]) > elementType[3] then
				outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."A kiválaszott elem inventoryja nem bír el több tárgyat.", playerSource,61,122,188, true)
				triggerClientEvent(playerSource,"updateItemClick",playerSource)
				return
			end
			
			local pSlotState, pSlotID = getFreeSlot(elementSource, activeItem["id"])
			if (pSlotState and pSlotID) then
				local itemName = ""
				if #activeItem["name"] <= 0 then 
					itemName = getItemName(activeItem["id"],tonumber(activeItem["value"]))
				else
					itemName = activeItem["name"]
				end
				
				itemCache[activeElementSource][getTypeOfElement(activeElementSource,tonumber(activeItem["id"]))[1]][tonumber(activeItem["slot"])] = nil
				itemCache[elementSource][getTypeOfElement(elementSource,tonumber(activeItem["id"]))[1]][tonumber(pSlotID)] = {
					["dbid"] = tonumber(activeItem["dbid"]),
					["id"] = tonumber(activeItem["id"]),
					["value"] = tostring(activeItem["value"]),
					["count"] = tonumber(activeItem["count"]),
					["duty"] = tonumber(activeItem["duty"]),
					["slot"] = tonumber(pSlotID),
					["health"] = tonumber(activeItem["health"]),	
					["name"] = tostring(activeItem["name"]),
					["weaponserial"] = tostring(activeItem["weaponserial"]),
				}

				if getElementType(elementSource) == "player" and elementSource ~= playerSource then
					if isElement(getElementData(elementSource,"show:inv")) and getElementType(getElementData(elementSource,"show:inv")) == "player" then
						getElementItems(elementSource, elementSource, 2)
					end
					func["delActionbarItem"](activeElementSource,activeItem["dbid"])
				end
				getElementItems(playerSource, activeElementSource, 2)
				
				if getElementType(elementSource) == "player" and elementSource ~= playerSource then
					chat:sendLocalMeAction(playerSource,"átadott egy tárgyat "..string.gsub(getPlayerName(elementSource), "_", " ").." -nak/nek. ("..itemName..")")
					itemAnim(playerSource,elementSource)
					if weaponModels[activeItem["id"]] then
						delAttachWeapon(playerSource,activeItem["id"],activeItem["value"],activeItem["dbid"])
						addAttachWeapon(elementSource,activeItem["id"],activeItem["value"],activeItem["dbid"])
					end
				elseif getElementType(elementSource) == "vehicle" and elementSource ~= playerSource then
					chat:sendLocalMeAction(playerSource, "berakott egy tárgyat a jármű csomagtartójába. ("..itemName..")")
					if weaponModels[activeItem["id"]] then
						delAttachWeapon(playerSource,activeItem["id"],activeItem["value"],activeItem["dbid"])
					end
				elseif getElementType(activeElementSource) == "vehicle" and elementSource == playerSource then
					chat:sendLocalMeAction(playerSource, "kivett egy tárgyat a jármű csomagtartójából. ("..itemName..")")
					if weaponModels[activeItem["id"]] then
						addAttachWeapon(playerSource,activeItem["id"],activeItem["value"],activeItem["dbid"])
					end
				elseif getElementType(elementSource) == "object" and elementSource ~= playerSource then
					chat:sendLocalMeAction(playerSource, "berakott egy tárgyat a széfbe. ("..itemName..")")
					if weaponModels[activeItem["id"]] then
						delAttachWeapon(playerSource,activeItem["id"],activeItem["value"],activeItem["dbid"])
					end
				elseif getElementType(activeElementSource) == "object" and elementSource == playerSource then
					chat:sendLocalMeAction(playerSource, "kivett egy tárgyat a széfből. ("..itemName..")")
					if weaponModels[activeItem["id"]] then
						addAttachWeapon(playerSource,activeItem["id"],activeItem["value"],activeItem["dbid"])
					end
				end
			else
				outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."A kiválaszott elem inventoryja nem bír el több tárgyat.", playerSource,61,122,188, true)
			end
			triggerClientEvent(playerSource,"updateItemClick",playerSource)
		end
	end
end
addEvent("tradeItem", true)
addEventHandler("tradeItem", getRootElement(), tradeItem)

function getElementItemsWeight(element)
	local bagWeight = 0
	local keyWeight = 0
	local licensWeight = 0
	local vehWeight = 0
	local objectWeight = 0

	local elementType = getElementType(element)
	if elementType == "player" then
		for i = 1, row * column do
			if (itemCache[element]["bag"][i]) then
				bagWeight = bagWeight + (getItemWeight(itemCache[element]["bag"][i]["id"]) * itemCache[element]["bag"][i]["count"])
			end
		end
	elseif elementType == "vehicle" then 
		for i = 1, row * column do
			if (itemCache[element]["vehicle"][i]) then
				vehWeight = vehWeight + (getItemWeight(itemCache[element]["vehicle"][i]["id"]) * itemCache[element]["vehicle"][i]["count"])
			end	
		end
	elseif elementType == "object" then 
		for i = 1, row * column do
			if (itemCache[element]["object"][i]) then
				objectWeight = objectWeight + (getItemWeight(itemCache[element]["object"][i]["id"]) * itemCache[element]["object"][i]["count"])
			end	
		end
	end

	return math.ceil(bagWeight + licensWeight + keyWeight + vehWeight + objectWeight)
end

function hasItem(element,item,value)
	if not value then
		value = 1
	end
	for i = 1, row * column do
		if (itemCache[element][getTypeOfElement(element,tonumber(item))[1]][i]) then
			if tonumber(itemCache[element][getTypeOfElement(element,tonumber(item))[1]][i]["id"]) == tonumber(item) then
				if value == -1 then
					if tonumber(itemCache[element][getTypeOfElement(element,tonumber(item))[1]][i]["value"]) < 4 then
						return true,itemCache[element][getTypeOfElement(element,tonumber(item))[1]][i]["id"],itemCache[element][getTypeOfElement(element,tonumber(item))[1]][i]["value"]
					end
				elseif value == "?" then 
					return true,itemCache[element][getTypeOfElement(element,tonumber(item))[1]][i]["id"],itemCache[element][getTypeOfElement(element,tonumber(item))[1]][i]["value"],itemCache[element][getTypeOfElement(element,tonumber(item))[1]][i]
				else
					if tonumber(itemCache[element][getTypeOfElement(element,tonumber(item))[1]][i]["value"]) == tonumber(value) then
						return true,itemCache[element][getTypeOfElement(element,tonumber(item))[1]][i]["id"],itemCache[element][getTypeOfElement(element,tonumber(item))[1]][i]["value"],itemCache[element][getTypeOfElement(element,tonumber(item))[1]][i]
					end
				end
			end
		end
	end
	return false,-1,-1
end

function hasItemCount(element,item,count,itemData)
	if not itemData then
		itemData = itemCache
	end
		
	for i = 1, row * column do
		if (itemData[element][getTypeOfElement(element,tonumber(item))[1]][i]) then
			if tonumber(itemData[element][getTypeOfElement(element,tonumber(item))[1]][i]["id"]) == tonumber(item) and tonumber(itemData[element][getTypeOfElement(element,tonumber(item))[1]][i]["count"]) >= tonumber(count) then
				return true
			end
		end
	end
	if count == -1 then
		return true
	end
	return false
end

function giveItem(playerSource, itemID, itemValue, itemCount, itemDuty, itemState,itemName,serial,premium, adminlog)
	if (playerSource and itemID and itemValue and itemCount and itemDuty) then
		if not itemState then
			itemState = 100
		else
			itemState = itemState
		end
		if not itemName then
			itemName = ""
		else
			itemName = itemName
		end

		if items[itemID].ammo then
			weaponSerial = generateSerial()
		else
			weaponSerial = ""
		end

		if not adminlog then adminlog = false end

		local elementType = getTypeOfElement(playerSource)
		local elementOwnerID = tonumber(getElementData(playerSource, "user:id"))
		local elementOwnerType = elementType[1]
		local pSlotState, pSlotID = getFreeSlot(playerSource, itemID)

		if pSlotID < 0 then 
			return false
		end

		local cretedItemID = 0

		if not premium then 
			premium = false 
		end

		if adminlog then 
			if isElement(client) then 
				admin:sendMessageToAdmins(client, "adott #db3535"..getItemName(tonumber(itemID),tostring(itemValue)).." #557ec9-ból/ből #db3535"..tonumber(itemCount).."#557ec9db-ot #db3535"..string.gsub(getPlayerName(client), "_", " ").."#557ec9-nak/nek.")
			end
		end
		
		dbQuery(function(qh,itemID,elementOwnerID,pSlotID)
			local query, query_lines, id = dbPoll(qh, 50)
			local id = tonumber(id)
			if id > 0 then
				cretedItemID = id
				if itemID == 1 then 
					local value_phonenumber = "2812"..tostring(id*2) 

					itemValue = value_phonenumber
				elseif food_maxvalues[itemID] then 
					itemValue = food_maxvalues[itemID]
				elseif drink_maxvalues[itemID] then 
					itemValue = drink_maxvalues[itemID]
				end
			
				itemCache[playerSource][getTypeOfElement(playerSource,tonumber(itemID))[1]][tonumber(pSlotID)] = {
					["dbid"] = tonumber(id),
					["id"] = tonumber(itemID),
					["value"] = tostring(itemValue),
					["count"] = tonumber(itemCount),
					["duty"] = tonumber(itemDuty),
					["slot"] = tonumber(pSlotID),	
					["health"] = tonumber(itemState),	
					["name"] = tostring(itemName),
					["weaponserial"] = tostring(weaponSerial),
				}
			
				if weaponModels[itemID] then
					addAttachWeapon(playerSource,itemID,itemValue,id)
				end
				if isElement(getElementData(playerSource,"show:inv")) and getElementType(getElementData(playerSource,"show:inv")) == "player" then
					getElementItems(playerSource, playerSource, 2)
				end

				if premium then 
					outputChatBox(core:getServerPrefix("server", "Prémium", 2).."Az általad vásárolt item azonosítója: "..color..id.."#ffffff.", playerSource, 255, 255, 255, true)
				end
			end
		end,{itemID,elementOwnerID,pSlotID},func["dbConnect"], "INSERT INTO `items` SET `itemid` = ?, `slot` = ?, `owner` = ?, `value` = ?, `count` = ?, `type` = ?, `dutyitem` = ?, `itemState` = ?, `name` = ?, `weaponserial` = ?, `amount` = ? ",itemID, pSlotID, elementOwnerID, itemValue, itemCount, getTypeOfElement(playerSource,tonumber(itemID))[1], itemDuty, itemState,itemName,weaponSerial, 0)
	end
end
addEvent("giveItem", true)
addEventHandler("giveItem", root, giveItem)

addCommandHandler("giveitem",function(playerSource, cmd, id, item, value, count, itemState)
	if getElementData(playerSource, "user:admin") >= 7 then
		if id and item and value and count then
			local targetPlayer, targetPlayerName = core:getPlayerFromPartialName(playerSource, id)		
			if targetPlayer then
				if getElementData(targetPlayer,"user:loggedin") then
					local weight = getElementItemsWeight(targetPlayer)
					if weight + (getItemWeight(tonumber(item)) * tonumber(count)) > getTypeOfElement(targetPlayer)[3] then
						outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."A kiválasztott játékos nem bír el több tárgyat. "..color.."(Súly)", playerSource,61,122,188,true)	
						return
					end
					local pSlotState, pSlotID = getFreeSlot(targetPlayer, tonumber(item))
					if pSlotState then
						if tonumber(item) == 65 then 
							createLicense(targetPlayer, 1)
						elseif tonumber(item) == 66 then 
							createLicense(targetPlayer, 2)
						elseif tonumber(item) == 68 then
							createLicense(targetPlayer, 3)
						else
							giveItem(targetPlayer,tonumber(item),tostring(value),tonumber(count), 0)
							outputChatBox(core:getServerPrefix("green-dark", "Inventory", 3).."Sikeresen adtál "..color..string.gsub(getPlayerName(targetPlayer), "_", " ").."#ffffff -nak/nek "..color..tonumber(count).."#ffffff darab "..color..getItemName(tonumber(item),tostring(value)).."#ffffff -t.",playerSource,61,122,188,true)
							outputChatBox(core:getServerPrefix("green-dark", "Inventory", 1).."Kaptál "..color..getElementData(playerSource,"user:adminnick").."#ffffff -tól/től "..color..tonumber(count).."#ffffff darab "..color..getItemName(tonumber(item),tostring(value)).."#ffffff -t.",targetPlayer,61,122,188,true)
						
							admin:sendMessageToAdmins(playerSource, "adott #db3535"..getItemName(tonumber(item),tostring(value)).." #557ec9-ból/ből #db3535"..tonumber(count).."#557ec9db-ot #db3535"..string.gsub(getPlayerName(targetPlayer), "_", " ").."#557ec9-nak/nek.")
						end

						setElementData(playerSource, "log:admincmd", {getElementData(targetPlayer, "char:id"), cmd})
					else
						outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."A kiválasztott játékos nem bír el több tárgyat. (Slot)", playerSource,61,122,188,true)	
					end
				else
					outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."A kiválasztott játékos nincs bejelentkezve.", playerSource,61,122,188,true)
				end
			end
		else
			outputChatBox(core:getServerPrefix("server", "Használat", 3).." /"..cmd.." [ID] [ItemID] [Érték] [Darab]", playerSource,61,122,188,true)	
		end
	end
end)

local monthDays = {31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}

function createLicense(player, type)
	if type == 1 then 
		local createDate = {core:getDate("year"), core:getDate("month"), core:getDate("monthday")}

		if createDate[2] < 10 then 
			createDate[2] = "0"..createDate[2]
		end

		if createDate[3] < 10 then 
			createDate[3] = "0"..createDate[3]
		end 

		local endDate = {0, 0, 0}

		if createDate[2] == 12 then 
			endDate[1] = createDate[1] + 1
			endDate[2] = 1
			endDate[3] = createDate[3]
		else
			endDate[1] = createDate[1]
			endDate[2] = createDate[2] + 1
			endDate[3] = createDate[3]
		end

		endDate[2] = tonumber(endDate[2])
		endDate[3] = tonumber(endDate[3])

		if monthDays[endDate[2]] < endDate[3] then 
			endDate[3] = endDate[3] - monthDays[endDate[2]] 
			endDate[2] = endDate[2] + 1
		end
 
		if endDate[2] < 10 then 
			endDate[2] = "0"..endDate[2]
		end

		if endDate[3] < 10 then 
			endDate[3] = "0"..endDate[3]
		end
		
		local skin = getElementModel(player)

		if skin < 10 then 
			skin = "00"..skin 
		elseif skin < 100 then 
			skin = "0"..skin 
		end

		local createDateText = createDate[1]..createDate[2]..createDate[3] -- 8
		local endDateText = endDate[1]..endDate[2]..endDate[3] --8
		local skinText = tostring(skin)
		local genderText = tostring(getElementData(player, "char:gender"))
		local ageText = tostring(getElementData(player, "char:age"))
		local nameText = getElementData(player, "char:name")

		giveItem(player, 65, createDateText..endDateText..skinText..genderText..ageText..nameText, 1, 0)
	elseif type == 2 then 
		local createDate = {core:getDate("year"), core:getDate("month"), core:getDate("monthday")}

		if createDate[2] < 10 then 
			createDate[2] = "0"..createDate[2]
		end

		if createDate[3] < 10 then 
			createDate[3] = "0"..createDate[3]
		end 

		local endDate = {0, 0, 0}

		if createDate[2] == 12 then 
			endDate[1] = createDate[1] + 1
			endDate[2] = 1
			endDate[3] = createDate[3]
		else
			endDate[1] = createDate[1]
			endDate[2] = createDate[2] + 1
			endDate[3] = createDate[3]
		end

		endDate[2] = tonumber(endDate[2])
		endDate[3] = tonumber(endDate[3])

		if monthDays[endDate[2]] < endDate[3] then 
			endDate[3] = endDate[3] - monthDays[endDate[2]] 
			endDate[2] = endDate[2] + 1
		end
 
		if endDate[2] < 10 then 
			endDate[2] = "0"..endDate[2]
		end

		if endDate[3] < 10 then 
			endDate[3] = "0"..endDate[3]
		end
		
		local skin = getElementModel(player)

		if skin < 10 then 
			skin = "00"..skin 
		elseif skin < 100 then 
			skin = "0"..skin 
		end

		local createDateText = createDate[1]..createDate[2]..createDate[3] -- 8
		local endDateText = endDate[1]..endDate[2]..endDate[3] --8
		local skinText = tostring(skin)
		local ageText = tostring(getElementData(player, "char:age"))
		local nameText = getElementData(player, "char:name")

		giveItem(player, 66, createDateText..endDateText..skinText..ageText..nameText, 1, 0)
	elseif type == 3 then 
		local createDate = {core:getDate("year"), core:getDate("month"), core:getDate("monthday")}

		if createDate[2] < 10 then 
			createDate[2] = "0"..createDate[2]
		end

		if createDate[3] < 10 then 
			createDate[3] = "0"..createDate[3]
		end 

		local endDate = {0, 0, 0}

		if createDate[2] + 6 > 12 then 
			endDate[1] = createDate[1] + 1
			endDate[2] = (createDate[2] + 6) - 12
			endDate[3] = createDate[3]
		else
			endDate[1] = createDate[1]
			endDate[2] = createDate[2] + 6
			endDate[3] = createDate[3]
		end

		endDate[2] = tonumber(endDate[2])
		endDate[3] = tonumber(endDate[3])

		if monthDays[endDate[2]] < endDate[3] then 
			endDate[3] = endDate[3] - monthDays[endDate[2]] 
			endDate[2] = endDate[2] + 1
		end
 
		if endDate[2] < 10 then 
			endDate[2] = "0"..endDate[2]
		end

		if endDate[3] < 10 then 
			endDate[3] = "0"..endDate[3]
		end
		
		local skin = getElementModel(player)

		if skin < 10 then 
			skin = "00"..skin 
		elseif skin < 100 then 
			skin = "0"..skin 
		end

		local createDateText = createDate[1]..createDate[2]..createDate[3] -- 8
		local endDateText = endDate[1]..endDate[2]..endDate[3] --8
		local skinText = tostring(skin)
		local genderText = tostring(getElementData(player, "char:gender"))
		local ageText = tostring(getElementData(player, "char:age"))
		local nameText = getElementData(player, "char:name")

		giveItem(player, 68, createDateText..endDateText..skinText..nameText, 1, 0)
	elseif type == 4 then 
		local createDate = {core:getDate("year"), core:getDate("month"), core:getDate("monthday")}

		if createDate[2] < 10 then 
			createDate[2] = "0"..createDate[2]
		end

		if createDate[3] < 10 then 
			createDate[3] = "0"..createDate[3]
		end 

		local endDate = {0, 0, 0}

		if createDate[2] + 4 > 12 then 
			endDate[1] = createDate[1] + 1
			endDate[2] = (createDate[2] + 4) - 12
			endDate[3] = createDate[3]
		else
			endDate[1] = createDate[1]
			endDate[2] = createDate[2] + 4
			endDate[3] = createDate[3]
		end

		endDate[2] = tonumber(endDate[2])
		endDate[3] = tonumber(endDate[3])

		if monthDays[endDate[2]] < endDate[3] then 
			endDate[3] = endDate[3] - monthDays[endDate[2]] 
			endDate[2] = endDate[2] + 1
		end
 
		if endDate[2] < 10 then 
			endDate[2] = "0"..endDate[2]
		end

		if endDate[3] < 10 then 
			endDate[3] = "0"..endDate[3]
		end
		
		local skin = getElementModel(player)

		if skin < 10 then 
			skin = "00"..skin 
		elseif skin < 100 then 
			skin = "0"..skin 
		end

		local createDateText = createDate[1]..createDate[2]..createDate[3] -- 8
		local endDateText = endDate[1]..endDate[2]..endDate[3] --8
		local skinText = tostring(skin)
		local genderText = tostring(getElementData(player, "char:gender"))
		local ageText = tostring(getElementData(player, "char:age"))
		local nameText = getElementData(player, "char:name")

		giveItem(player, 79, createDateText..endDateText..skinText..nameText, 1, 0)
	end
end

addCommandHandler("givelicense",function(playerSource, cmd, id, type)
	if admin:getPlayerAdminLevel(playerSource) >= 5 then
		if id and type then
			local targetPlayer, targetPlayerName = core:getPlayerFromPartialName(playerSource, id)		
			if targetPlayer then
				if getElementData(targetPlayer,"user:loggedin") then
					local pSlotState, pSlotID = getFreeSlot(targetPlayer, tonumber(item))
					if pSlotState then
						local licnesname = "nan"

						local type = tonumber(type)

						if type == 1 then 
							licensename = "Személyi Igazolvány"
						elseif type == 2 then 
							licensename = "Vezetői Engedély"
						elseif type == 3 then
							licensename = "Fegyvertartási Engedély"
						elseif type == 4 then
							licensename = "Vadászati Engedély"
						end
					
						createLicense(targetPlayer, tonumber(type))
						outputChatBox(core:getServerPrefix("green-dark", "Inventory", 3).."Sikeresen adtál egy "..licensename.."-t "..string.gsub(getPlayerName(targetPlayer), "_", " ").."#ffffff -nak/nek. ",playerSource,61,122,188,true)
						outputChatBox(core:getServerPrefix("red-dark", "Inventory", 1).."Kaptál egy "..licensename.."-t "..getElementData(playerSource,"user:adminnick").."#ffffff -tól/től. ",targetPlayer,61,122,188,true)
					
						admin:sendMessageToAdmins(playerSource, "adott egy #db3535"..licensename.." #557ec9-t #db3535"..string.gsub(getPlayerName(targetPlayer), "_", " ").."#557ec9-nak/nek.")

						setElementData(playerSource, "log:admincmd", {getElementData(targetPlayer, "char:id"), cmd})
					end
				else
					outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."A kiválasztott játékos nincs bejelentkezve.", playerSource,61,122,188,true)
				end
			end
		else
			outputChatBox(core:getServerPrefix("server", "Használat", 3).." /"..cmd.." [ID] [Típus (1-Személyi, 2-Vezetői engedély, 3-Fegyvertartási engedély, 4-Vadászati engedély)]", playerSource,61,122,188,true)	
		end
	end
end)

addCommandHandler("changelock",function(playerSource,cmd,typ)
	if getElementData(playerSource,"adminlevel") >= 7 then
		if typ then
			typ = tostring(typ)
			if typ == "vehicle" then
				local veh = getPedOccupiedVehicle(playerSource)
				if isElement(veh) then
					local dbid = getElementData(veh,"dbid")
					takeAllItem(40,dbid)
					giveItem(playerSource,40,dbid,1,0)
					outputChatBox(core:getServerPrefix("green-dark", "Inventory", 3).."Sikeresen changelock-oltál egy járművet."..color.."("..dbid..")", playerSource,61,122,188, true)
				else
					outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."Nem ülsz járműben.", playerSource,61,122,188, true)
				end
			elseif typ == "interior" then
				if getElementData(playerSource, "isInIntMarker") then
					local theMarkElement = getElementData(playerSource,"int:Marker")
					if getElementData(theMarkElement,"isIntMarker") then
						local dbid = getElementData(theMarkElement,"dbid")
						takeAllItem(41,dbid)
						giveItem(playerSource,41,dbid,1,0)
						outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."Sikeresen changelock-oltál egy interiort. "..color.."("..dbid..")", playerSource,61,122,188, true)
					end
				else
					outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."Nem állsz interior marker-ben.",playerSource,61,122,188,true)
				end
			end
		else
			outputChatBox(core:getServerPrefix("server", "Használat", 3).." /"..cmd.." [Típus: vehicle, interior]", playerSource,61,122,188, true)
		end
	end
end)

addCommandHandler("delplayeritem",function(playerSource,cmd,who,category,slot)
	if admin:getPlayerAdminLevel(playerSource) >= 7 then
		if who and category and slot then
			if category == "bag" or category == "key" or category == "licens" then
				slot = tonumber(slot)
				if type(slot) == "number" then
					local targetPlayer, targetPlayerName = exports.oCore:getPlayerFromPartialName(playerSource,who)		
					if targetPlayer then
						if(itemCache[targetPlayer][category])then
							if(itemCache[targetPlayer][category][slot])then
								outputChatBox(core:getServerPrefix("green-dark", "Inventory", 3).."Sikeresen töröltél "..color..getPlayerName(targetPlayer):gsub("_", " ").."#ffffff -tól/től egy "..color..getItemName(itemCache[targetPlayer][category][slot]["id"],itemCache[targetPlayer][category][slot]["value"]).."#ffffff -t.",playerSource,61,122,188, true)
								outputChatBox(core:getServerPrefix("red-dark", "Inventory", 1)..getElementData(targetPlayer,"user:adminnick").."#ffffff törölt tőled egy "..color..getItemName(itemCache[targetPlayer][category][slot]["id"],itemCache[targetPlayer][category][slot]["value"]).."#ffffff -t.",targetPlayer,61,122,188, true)
								
								admin:sendMessageToAdmins(playerSource, "törölt egy #db3535"..getItemName(itemCache[targetPlayer][category][slot]["id"],itemCache[targetPlayer][category][slot]["value"]).."#557ec9-t tőle: #db3535"..getPlayerName(targetPlayer):gsub("_", " ").."#557ec9!")
								if(weaponModels[itemCache[targetPlayer][category][slot]["id"]])then
									delAttachWeapon(targetPlayer,itemCache[targetPlayer][category][slot]["id"],itemCache[targetPlayer][category][slot]["value"],itemCache[targetPlayer][category][slot]["dbid"])
								end
								deleteItem(targetPlayer,targetPlayer,itemCache[targetPlayer][category][slot])

								setElementData(playerSource, "log:admincmd", {getElementData(targetPlayer, "char:id"), cmd})
							else
								outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).." A kiválaszott játékosnak a "..color.."'"..category.."'#ffffff inventoryjában nincs ezen a sloton item."..color.."("..slot..")", playerSource,61,122,188, true)
							end
						end
					end
				else
					outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).." A slot csak szám lehet.", playerSource,61,122,188, true)
				end
			else
				outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."A kategória csak bag, key, licens lehet.", playerSource,61,122,188, true)
			end
		else
			outputChatBox(core:getServerPrefix("server", "Használat", 3).." /"..cmd.." [ID] [Kategória: bag, key, licens] [Slot]", playerSource,61,122,188, true)
		end
	end
end)

function addPhone(playerSource,typ)
	local thePhoneNumber = math.random(7868771+getElementData(playerSource,"dbid"),7968771+getElementData(playerSource,"playerid"))
	dbQuery(function(qh, playerSource)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			giveItem(playerSource,174,thePhoneNumber,1,0)
		end
	end, {playerSource}, func["dbConnect"],"INSERT INTO phones SET phoneNumber = ?, type = ?, date = NOW()",tonumber(thePhoneNumber),tostring(typ))
end
addEvent("addPhone",true)
addEventHandler("addPhone",getRootElement(),addPhone)

function getFreeSlot(elementSource, forItemID)
	local nextSlot = 1
	for i = 1, (row * column) do
		if not (itemCache[elementSource][getTypeOfElement(elementSource,tonumber(forItemID))[1]][i]) then
			return true, nextSlot
		else
			nextSlot = nextSlot  + 1
		end
	end

	return false, -1
end

function doorState(vehicle,typ)
	if typ == 1 then
		setVehicleDoorOpenRatio(vehicle,1,1,500)
		--setElementData(vehicle,"veh:use",true)
		--setElementData(vehicle,"veh:player",source)
	else
		setVehicleDoorOpenRatio(vehicle,1,0,500)
		--setElementData(vehicle,"veh:use",false)
		--setElementData(vehicle,"veh:player",nil)
	end
end
addEvent("doorState", true)
addEventHandler("doorState", root, doorState)

function itemAnim(element, targetElement)
	if isElement(element) and isElement(targetElement) then
		setPedAnimation(element,"DEALER","DEALER_DEAL",3000,false,false,false,false)
		setPedAnimation(targetElement,"DEALER","DEALER_DEAL",3000,false,false,false,false)
	end
end
addEvent("itemAnim", true)
addEventHandler("itemAnim", root, itemAnim)

function takeItem(playerSource,item)
	local elem = 0
	if itemCache[playerSource][getTypeOfElement(playerSource,tonumber(item))[1]] then
		for i = 1, row * column do
			if (itemCache[playerSource][getTypeOfElement(playerSource,tonumber(item))[1]][i]) then
				if itemCache[playerSource][getTypeOfElement(playerSource,tonumber(item))[1]][i]["id"] == item then
					elem = elem+1
					if elem == 1 then
						if itemCache[playerSource][getTypeOfElement(playerSource,tonumber(item))[1]][i]["count"] > 1 then
							itemCache[playerSource][getTypeOfElement(playerSource,tonumber(item))[1]][i]["count"] = itemCache[playerSource][getTypeOfElement(playerSource,tonumber(item))[1]][i]["count"]-1
							getElementItems(playerSource, playerSource, 2)
						else
							if weaponModels[itemCache[playerSource][getTypeOfElement(playerSource,tonumber(item))[1]][i]["id"]] then
								delAttachWeapon(playerSource,itemCache[playerSource][getTypeOfElement(playerSource,tonumber(item))[1]][i]["id"],itemCache[playerSource][getTypeOfElement(playerSource,tonumber(item))[1]][i]["value"],itemCache[playerSource][getTypeOfElement(playerSource,tonumber(item))[1]][i]["dbid"])
							end
							deleteItem(playerSource,playerSource,itemCache[playerSource][getTypeOfElement(playerSource,tonumber(item))[1]][i])
						end
					end
				end
			end
		end
	end
end

function takeAllItem(item,value)
	for k,v in ipairs(getElementsByType("vehicle")) do
		local vehID = (tonumber(getElementData(v, "veh:id")) or 0)
		if vehID > 0 then
			if itemCache[v] then
				if itemCache[v][getTypeOfElement(v,tonumber(item))[1]] then
					for i = 1, row * column do
						if itemCache[v][getTypeOfElement(v,tonumber(item))[1]][i] then
							if itemCache[v][getTypeOfElement(v,tonumber(item))[1]][i]["id"] == tonumber(item) and tonumber(itemCache[v][getTypeOfElement(v,tonumber(item))[1]][i]["value"]) == tonumber(value) then
								itemCache[v][getTypeOfElement(v,tonumber(itemCache[v][getTypeOfElement(v,tonumber(item))[1]][i]["id"]))[1]][tonumber(i)] = nil
								if isElement(getElementData(v, "veh:player")) then
									getElementItems(getElementData(v, "veh:player"),v,1)
								end
							end
						end
					end
				end
			end
		end
	end
	
	for k,v in ipairs(getElementsByType("object")) do
		if getElementData(v,"szef") and getElementData(v,"dbid") > 0 then
			if itemCache[v][getTypeOfElement(v,tonumber(item))[1]] then
				for i = 1, row * column do
					if itemCache[v][getTypeOfElement(v,tonumber(item))[1]][i] then
						if itemCache[v][getTypeOfElement(v,tonumber(item))[1]][i]["id"] == tonumber(item) and tonumber(itemCache[v][getTypeOfElement(v,tonumber(item))[1]][i]["value"]) == tonumber(value) then
							itemCache[v][getTypeOfElement(v,tonumber(itemCache[v][getTypeOfElement(v,tonumber(item))[1]][i]["id"]))[1]][tonumber(i)] = nil
							if isElement(getElementData(v, "safe:player")) then
								getElementItems(getElementData(v, "safe:player"),v,1)
							end
						end
					end
				end
			end
		end
	end
	
	for k,v in ipairs(getElementsByType("player")) do
		if getElementData(v,"user:loggedin") then
			if itemCache[v] then
				if itemCache[v][getTypeOfElement(v,tonumber(item))[1]] then
					for i = 1, row * column do
						if itemCache[v][getTypeOfElement(v,tonumber(item))[1]][i] then
							if itemCache[v][getTypeOfElement(v,tonumber(item))[1]][i]["id"] == tonumber(item) and tonumber(itemCache[v][getTypeOfElement(v,tonumber(item))[1]][i]["value"]) == tonumber(value) then
								itemCache[v][getTypeOfElement(v,tonumber(itemCache[v][getTypeOfElement(v,tonumber(item))[1]][i]["id"]))[1]][tonumber(i)] = nil
								if isElement(getElementData(v,"show:inv")) and getElementType(getElementData(v,"show:inv")) == "player" then
									getElementItems(v,v,2)
								end
							end
						end
					end
				end
			end
		end
	end
	
	dbQuery(function(query)
		local query, query_lines = dbPoll(query, 0)
		for k, row in pairs (query) do
			dbExec(func["dbConnect"],"DELETE FROM `items` WHERE `id` = ?",row["id"])
		end
	end, func["dbConnect"], "SELECT * FROM `items` WHERE `value` = ? AND `itemid` = ?",tonumber(value),tonumber(item))
end

function RemovePlayerDutyItems(element) -- duty cuccok
	if itemCache[element]["bag"] then
		for i = 1, row * column do
			if (itemCache[element]["bag"][i]) then
				if itemCache[element]["bag"][i]["duty"] == 1 then
					if weaponModels[itemCache[element]["bag"][i]["id"]] then
						delAttachWeapon(element,itemCache[element]["bag"][i]["id"],itemCache[element]["bag"][i]["value"],itemCache[element]["bag"][i]["dbid"])
					end
					deleteItem(element,element,itemCache[element]["bag"][i])
				end
			end
		end
	end
end
addEvent("RemovePlayerDutyItems", true)
addEventHandler("RemovePlayerDutyItems",getRootElement(),RemovePlayerDutyItems)

function addAttachWeapon(playerSource,item,value,dbid)
	if not weapons[playerSource] then
		weapons[playerSource] = {}
	end
	if not isElement(weapons[playerSource][dbid]) or not weapons[playerSource][dbid] then
		local x,y,z = getElementPosition(playerSource)
		if weaponModels[item] then
			if weaponPositions[tonumber(weaponIndexByID[item])] then 
				weapons[playerSource][dbid] = createObject(weaponModels[item][1],x,y,z)
				setElementInterior(weapons[playerSource][dbid],getElementInterior(playerSource))
				setElementDimension(weapons[playerSource][dbid],getElementDimension(playerSource))
				setElementData(weapons[playerSource][dbid],"attachedObject",true)

				bone:attachElementToBone(weapons[playerSource][dbid], playerSource,weaponPositions[tonumber(weaponIndexByID[item])][1],weaponPositions[tonumber(weaponIndexByID[item])][2],weaponPositions[tonumber(weaponIndexByID[item])][3],weaponPositions[tonumber(weaponIndexByID[item])][4],weaponPositions[tonumber(weaponIndexByID[item])][5],weaponPositions[tonumber(weaponIndexByID[item])][6],weaponPositions[tonumber(weaponIndexByID[item])][7])
			end
		end
	end
end
addEvent("addAttachWeapon",true)
addEventHandler("addAttachWeapon",getRootElement(),addAttachWeapon)

function delAttachWeapon(playerSource,item,value,dbid)
	if weapons[playerSource] then
		if isElement(weapons[playerSource][dbid]) then
			bone:detachElementFromBone(weapons[playerSource][dbid])
			destroyElement(weapons[playerSource][dbid])
			weapons[playerSource][dbid] = {}
		end
	end
end
addEvent("delAttachWeapon",true)
addEventHandler("delAttachWeapon",getRootElement(),delAttachWeapon)

addEventHandler("onPlayerQuit",getRootElement(),function()
	if getElementData(source,"user:loggedin") then
		saveOneElementInventory(source)
		for i = 1, row * column do
			if (itemCache[source]["bag"][i]) then
				if weapons[source] then
					if isElement(weapons[source][itemCache[source]["bag"][i]["dbid"]]) then
						bone:detachElementFromBone(weapons[source][itemCache[source]["bag"][i]["dbid"]])
						destroyElement(weapons[source][itemCache[source]["bag"][i]["dbid"]])
					end
				end
			end
		end
		weapons[source] = {}
	end
end)

--Actionbar server--

addEvent("moveItemToActionBar",true)
addEventHandler("moveItemToActionBar", getRootElement(),function(playerSource,itemdbid,item,category,actionslot)

	local dbid = tonumber(getElementData(playerSource, "user:id"))
	dbExec(func["dbConnect"],"INSERT INTO actionbaritems SET itemdbid = ?, item = ?, owner = ?, category = ?, actionslot = ?",itemdbid,item,dbid,category,actionslot)
end)

function deleteActionBarItem(player,actionslot)
	local dbid = tonumber(getElementData(player, "user:id"))
	dbExec(func["dbConnect"], "DELETE FROM `actionbaritems` WHERE owner=? and actionslot=?", dbid, actionslot)
end
addEvent("deleteActionBarItem",true)
addEventHandler("deleteActionBarItem", getRootElement(), deleteActionBarItem)

function loadActionBarItems(playerSource)
	local dbid = getElementData(playerSource,"user:id")
	local loadedTables = {}
	dbQuery(function(qh)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for k, row in pairs(res) do
				loadedTables[#loadedTables+1] = {["id"] = tonumber(row["id"]),["owner"] = tonumber(row["owner"]),["itemdbid"] = tonumber(row["itemdbid"]),["item"] = tonumber(row["item"]),["category"] = tostring(row["category"]),["actionslot"] = tonumber(row["actionslot"])}
			end
		end
		triggerClientEvent(playerSource,"actionBarEvent",playerSource,playerSource,loadedTables)
	end,func["dbConnect"],"SELECT * FROM actionbaritems WHERE owner=?",dbid)
end
addEvent("loadActionBarItems",true)
addEventHandler("loadActionBarItems",getRootElement(),loadActionBarItems)

addEventHandler("onPlayerQuit", root, function()
	RemovePlayerDutyItems(source)
	delAttachWeapon(source)
end)

addEvent("show > item", true)
addEventHandler("show > item", resourceRoot, function(itemID, itemValue)
	--outputChatBox(getPlayerName(client).." felmutatott egy itemet: ("..itemID..", "..itemValue..")")
	setElementData(client, "inventory:showedItem", {itemID, itemValue})
end)

addEvent("resetItemShowing > show", true)
addEventHandler("resetItemShowing > show", resourceRoot, function()
	setElementData(client, "inventory:showedItem", false)
end)