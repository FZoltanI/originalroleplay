local mysql = exports.oMysql:getDBConnection()
local inventoryItems = {}

addEventHandler("onResourceStart", resourceRoot, function()
	for k, v in ipairs(getElementsByType("player")) do 
		if getElementData(v, "user:loggedin") then 
			loadElementInventory(v)
		end
	end

	setTimer(function()
		triggerClientEvent(root, "updateItems", root, inventoryItems)
	end, 1000, 1)
end)

addEventHandler("onResourceStop", resourceRoot, function()
	for k, v in ipairs(getElementsByType("player")) do 
		if getElementData(v, "user:loggedin") then 
			saveOneElementInventory(v)
		end
	end
end)

addEventHandler("onPlayerQuit", root, function()
	if getElementData(source, "user:loggedin") then 
		saveOneElementInventory(source)
	end
end)

addEventHandler("onElementDataChange", root, function(key, old, new)
	if key == "user:loggedin" then 
		if new == true then 
			loadElementInventory(source)
			triggerClientEvent(source, "updateItems", source, inventoryItems)
		end
	end
end)

function loadElementInventory(element)
	local elementOwnerID 
	local elementDatas = getElementTypeDatas(element)

	inventoryItems[element] = {
		["bag"] = {},
		["key"] = {},
		["licens"] = {},
		["vehicle"] = {},
		["object"] = {},
	}
	
	elementOwnerID = tonumber(getElementData(element, elementDatas[2]))
	
	dbQuery(function(qh, element)
		local res, rows, err = dbPoll(qh, 100)

		if rows > 0 then
			for k, row in pairs(res) do
				inventoryItems[element][tostring(row["type"])][tonumber(row["slot"])] = {tonumber(row["id"]), tonumber(row["itemid"]), tonumber(row["count"]), tostring(row["value"]), tostring(row["weaponserial"], tonumber(row["dutyitem"])), tostring(row["name"])}
			end
		end
	end, {element}, mysql, "SELECT * FROM `items` WHERE `owner` = ?",elementOwnerID)
end

function saveOneElementInventory(element)
	if getElementType(element) == "player" then
        local userid = getElementData(element,"user:id")
		for i = 1, slotCount do
			if (inventoryItems[element]["bag"][i]) then
				local dbid = tonumber(inventoryItems[element]["bag"][i][1])
				local item = tonumber(inventoryItems[element]["bag"][i][2])
				local value = tostring(inventoryItems[element]["bag"][i][4])
				local count = tonumber(inventoryItems[element]["bag"][i][3])
				local duty = tonumber(inventoryItems[element]["bag"][i][7])
				local name = tostring(inventoryItems[element]["bag"][i][6])
				local weaponserial = tostring(inventoryItems[element]["bag"][i][5])
				dbExec(mysql,"UPDATE items SET slot = ?, value = ?, count = ?, type = ?, owner = ?, dutyitem = ?, itemState = ?, name = ?, weaponserial = ? WHERE id = ?",i,value,count,"bag",userid,duty,0,name,weaponserial,dbid)
			end
		end
		for i = 1, slotCount do
			if (inventoryItems[element]["key"][i]) then
				local dbid = tonumber(inventoryItems[element]["key"][i][1])
				local item = tonumber(inventoryItems[element]["key"][i][2])
				local value = tostring(inventoryItems[element]["key"][i][4])
				local count = tonumber(inventoryItems[element]["key"][i][3])
				local duty = tonumber(inventoryItems[element]["key"][i][7])
				local name = tostring(inventoryItems[element]["key"][i][6])
				local weaponserial = tostring(inventoryItems[element]["key"][i][5])
				dbExec(mysql,"UPDATE items SET slot = ?, value = ?, count = ?, type = ?, owner = ?, dutyitem = ?, itemState = ?, name = ?, weaponserial = ? WHERE id = ?",i,value,count,"key",userid,duty,0,name,weaponserial,dbid)
			end
		end
		for i = 1, slotCount do
			if (inventoryItems[element]["licens"][i]) then
				local dbid = tonumber(inventoryItems[element]["licens"][i][1])
				local item = tonumber(inventoryItems[element]["licens"][i][2])
				local value = tostring(inventoryItems[element]["licens"][i][4])
				local count = tonumber(inventoryItems[element]["licens"][i][3])
				local duty = tonumber(inventoryItems[element]["licens"][i][7])
				local name = tostring(inventoryItems[element]["licens"][i][6])
				local weaponserial = tostring(inventoryItems[element]["licens"][i][5])
				dbExec(mysql,"UPDATE items SET slot = ?, value = ?, count = ?, type = ?, owner = ?, dutyitem = ?, itemState = ?, name = ?, weaponserial = ? WHERE id = ?",i,value,count,"licens",userid,duty,0,name,weaponserial,dbid)
			end
		end
	else
		local datas = getElementTypeDatas(element)
        local ownerid = getElementData(element, datas[2])
		for i = 1, slotCount do
			if (inventoryItems[element][datas[1]][i]) then
				local dbid = tonumber(inventoryItems[element][datas[1]][i][1])
				local item = tonumber(inventoryItems[element][datas[1]][i][2])
				local value = tostring(inventoryItems[element][datas[1]][i][4])
				local count = tonumber(inventoryItems[element][datas[1]][i][3])
				local duty = tonumber(inventoryItems[element][datas[1]][i][7])
				local name = tostring(inventoryItems[element][datas[1]][i][6])
				local weaponserial = tostring(inventoryItems[element][datas[1]][i][5])
				dbExec(mysql,"UPDATE items SET slot = ?, value = ?, count = ?, type = ?, owner = ?, dutyitem = ?, itemState = ?, name = ?, weaponserial = ? WHERE id = ?",i,value,count,datas[1],ownerid,duty,0,name,weaponserial,dbid)
			end
		end
	end
end

function setItemSlot(element, item, oldslot, newslot, panel)
	inventoryItems[element][panel][oldslot] = nil 
	inventoryItems[element][panel][newslot] = item
end
addEvent("setItemSlot", true)
addEventHandler("setItemSlot", resourceRoot, setItemSlot)

function giveItem(element, item, value, count, duty)

end	

function getFreeSlot(element, item)
	--for k, v in ipairs(inventoryItems[element][])
end