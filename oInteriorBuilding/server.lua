local connection = exports.oMysql:getDBConnection()

local interiorDatas = {
	 
}

local playersInInterior = {
	
}

--[[local file = nil
function saveToFile()
	if fileExists("metaszar.txt") then 
		fileDelete("metaszar.txt")
	end

	file = fileCreate("metaszar.txt")

	for i = 630, 16779 do 
		if fileExists("files/furniture/"..i..".png") then
			fileSetPos(file, fileGetSize(file))
			fileWrite(file, "\n <file src = 'files/furniture/"..i..".png' />")
		end
	end

	setTimer(function()
		fileClose(file)
	end, 15000, 1)
end
saveToFile()]]

local intiState = {}
local editingATM = {}

function isInteriorEditing(id)
	id = tonumber(id)

	return intiState[id]
end

registerEvent("intiEdit:buyPPFurniture", getRootElement(),
	function (intiId, model)
		if isElement(source) then

			local player = source

			if isElement(player) then
				local pp = tonumber(getElementData(player, "char:pp") or 0) or 0
				if pp >= prices["furnitures"][model] then
					setElementData(player, "char:pp", pp-prices["furnitures"][model])
					
					interiorDatas[intiId][4][model] = (interiorDatas[intiId][4][model] or 0) + 1

					triggerClientEvent(player, "intiEdit:gotPPThings", player, interiorDatas[intiId][4])

					local text = ""

					for k, v in pairs(interiorDatas[intiId][4]) do
						for k2=1, v do
							text = text .. k .. ","
						end
					end

					--addPPLog(getElementData(player, "dbid"), "Bútorvásárlás ("..model..")", prices["furnitures"][model])

					dbExec(connection, "UPDATE interior_datas SET unlockedPP=? WHERE interiorId=?", text, intiId)
				else
					exports.oInfobox:outputInfoBox("Nincs elég prémium pontod! (" .. prices["furnitures"][2332] .. "PP)", "error", player)
				end
			end
		end
	end)

registerEvent("intiEdit:placeSafe", getRootElement(),
	function (prompt)
		if isElement(source) then

			local player = source

			if isElement(player) then
				local pp = tonumber(getElementData(player, "char:pp") or 0) or 0
				if pp >= prices["furnitures"][2332] then
					setElementData(player, "char:pp", pp-prices["furnitures"][2332])

					local sourceInterior = getElementInterior(player)
					local sourceDimension = getElementDimension(player)

					exports.oInventory:createSafeFurniture(prompt[2], prompt[3], prompt[4], prompt[5], prompt[6], prompt[7], sourceInterior, sourceDimension, player, false)

					--addPPLog(getElementData(player, "dbid"), "Bútorvásárlás (Széf)", prices["furnitures"][2332])
				else
					exports.oInfobox:outputInfoBox("Nincs elég prémium pontod! (" .. prices["furnitures"][2332] .. "PP)", "error", player)
				end
			end
		end
	end)

registerEvent("intiEdit:placeBilliard", getRootElement(),
	function (prompt)
		--outputChatBox("Ki kell venni", source)
	end)

registerEvent("intiEdit:updateDynamicData", getRootElement(),
	function (id, data, toSync)
		if isElement(source) then

			interiorDatas[id][3] = data
			dbExec(connection, "UPDATE interior_datas SET dynamicData=? WHERE interiorId=?", data, id)

			triggerClientEvent(toSync, "intiEdit:updateDynamicData", source, data)
		end
	end)

registerEvent("intiEdit:exitInterior", getRootElement(),
	function (noPos)
		if isElement(source) then
			local int, dim, x, y, z = unpack(getElementData(source, "intiEditBefore"))

			setElementInterior(source, int)
			setElementDimension(source, dim)
			setElementPosition(source, x, y, z)

			
			setCameraTarget(source, source)
			setElementFrozen(source, false)
			setElementData(source, "currentCustomInterior", -1)
		end
	end)

registerEvent("intiEdit:exitInterior2", getRootElement(),
	function ()
		if isElement(source) then

			setCameraTarget(source, source)
			setElementFrozen(source, false)

			local editingInteriorID = getElementData(source, "currentCustomInterior")

			editingInteriorID = tonumber(editingInteriorID)

			if editingInteriorID and getElementData(source, "editingInterior") then
				intiState[editingInteriorID] = nil
			end
			setElementData(source, "currentCustomInterior", -1)
			removeElementData(source, "editingInterior")
			--removeElementData(source, "currentCustomInterior")
			removeElementData(source, "intiEditBefore")

		end
	end)

registerEvent("intiEdit:saveInterior", getRootElement(),
	function (id, data, cost)
		player = source
		if isElement(player) then

			dbQuery(
				function (qh)
					local result = dbPoll( qh, -1 )

					if isElement(player) then
						if #result == 1 then
							interiorDatas[id][2] = result[1]["paidCash"]

							local costDiff = cost-interiorDatas[id][2]

							local success = true

							local pmoney = getElementData(player, "char:money")
							setElementData(player, "char:money", pmoney-costDiff)

							if success then
								interiorDatas[id][2] = costDiff+interiorDatas[id][2]
								interiorDatas[id][1] = data

								--processDynamicObjects(editingInteriorID, true)

								dbExec(connection, "UPDATE interior_datas SET paidCash=paidCash+?, interiorData=? WHERE interiorId=?", costDiff, data, id)

								local int, dim, x, y, z = unpack(getElementData(player, "intiEditBefore"))

								setElementInterior(player, int)
								setElementDimension(player, dim)
								setElementPosition(player, x, y, z)
								setCameraTarget(player, player)
								setElementFrozen(player, false)

								local editingInteriorID = getElementData(player, "currentCustomInterior")

								editingInteriorID = tonumber(editingInteriorID)

								if editingInteriorID and getElementData(player, "editingInterior") then
									intiState[editingInteriorID] = nil
								end

								removeElementData(player, "editingInterior")
								removeElementData(player, "currentCustomInterior")
								removeElementData(player, "intiEditBefore")
							else
								exports.oInfobox:outputInfoBox("Nincs elég pénzed!", "error", player)
							end
						end
					end
				end, connection, "SELECT paidCash FROM interior_datas WHERE interiorId=?", id)
		end
	end)

function isSBEditingInterior(editingInteriorID)
	if editingInteriorID and editingATM[editingInteriorID] then
		if isElement(editingATM[editingInteriorID]) and getElementType(editingATM[editingInteriorID]) == 'player' then
			return true
		else
			editingATM[editingInteriorID] = nil
		end
	end
end

function loadInterior(v, editingInteriorID, edit, size)
	editingInteriorID = tonumber(editingInteriorID)

	if editingInteriorID then
		if edit and isSBEditingInterior(editingInteriorID) then
			exports.oInfobox:outputInfoBox("Valaki már éppen szerkeszti ezt az interiort!", "error", v)
			return false;
		end

		if size and size ~= "N" then
			if interiorDatas[editingInteriorID] then
				--outputChatBox(getElementType(v))
				loadInterior2(v, editingInteriorID, edit, size)
				--outputChatBox("asd")
			else
				dbQuery(
					function (qh)
						local result = dbPoll( qh, -1 )

						if isElement(v) then
							local data = false
							local paidCash = 0
							local dynamicData = ""
							local ppData = {}

							if #result == 1 then
								data = result[1]["interiorData"]
								paidCash = result[1]["paidCash"]
								dynamicData = result[1]["dynamicData"]

								ppData = {}

								local dat = split(result[1]["unlockedPP"], ",")

								for k=1, #dat do
									ppData[tonumber(dat[k])] = (ppData[tonumber(dat[k])] or 0) + 1
								end
							else
								dbExec(connection, "INSERT INTO interior_datas SET interiorId=?", editingInteriorID)
							end

							interiorDatas[editingInteriorID] = {data, paidCash, dynamicData, ppData}

							loadInterior2(v, editingInteriorID, edit, size)
						end
					end, connection, "SELECT * FROM interior_datas WHERE interiorId=?", editingInteriorID)
			end
		end
	end
end
registerEvent("intiEdit:loadInterior", getRootElement(), loadInterior)

addEventHandler("onPlayerQuit", getRootElement(),
	function ()
		local editingInteriorID = getElementData(source, "currentCustomInterior")

		if editingInteriorID then
			if not playersInInterior[editingInteriorID] then
				playersInInterior[editingInteriorID] = {}
			end

			--table.insert(playersInInterior[editingInteriorID], v)	
			for k=1, #playersInInterior[editingInteriorID] do
				if playersInInterior[editingInteriorID][k] == source then
					table.remove(playersInInterior[editingInteriorID], k)
					break
				end
			end
		end

		for k, v in pairs(editingATM) do
			if v == source then
				editingATM[k] = nil
			end
		end
	end)

addEventHandler("onElementDataChange", getRootElement(),
	function (data, oldValue)
		if data == "currentCustomInterior" then
			local editingInteriorID = getElementData(source, "currentCustomInterior")

			if (not editingInteriorID or editingInteriorID < 0) and tonumber(oldValue) then
				editingInteriorID = tonumber(oldValue)

				if not playersInInterior[editingInteriorID] then
					playersInInterior[editingInteriorID] = {}
				end

				--table.insert(playersInInterior[editingInteriorID], v)	
				for k=1, #playersInInterior[editingInteriorID] do
					if playersInInterior[editingInteriorID][k] == source then
						table.remove(playersInInterior[editingInteriorID], k)
						break
					end
				end
			end
		elseif data == "spawned" then
			local editingInteriorID = getElementData(source, "currentCustomInterior")
			
			if editingInteriorID then
				editingInteriorID = tonumber(editingInteriorID)

				loadInterior(source, editingInteriorID, false)
			end
		elseif data == "editingInterior" then
			local value = getElementData(source, data)
			if not value then
				for k, v in pairs(editingATM) do
					if v == source then
						editingATM[k] = nil
					end
				end
			end
		end
	end)

function loadInterior2(v, editingInteriorID, edit, size)
	editingInteriorID = tonumber(editingInteriorID)
	--outputChatBox(getElementData(v, "currentCustomInterior"))
	if (tonumber(getElementData(v, "currentCustomInterior") or -1) or -1) ~= editingInteriorID then
	--	outputChatBox("asd")
		if edit then
			deleteDynamicObjects(editingInteriorID)
		else
			processDynamicObjects(editingInteriorID)
		end
		--outputChatBox("loadInterior2")
		data = interiorDatas[editingInteriorID][1]
		paidCash = interiorDatas[editingInteriorID][2]
		dynamicData = interiorDatas[editingInteriorID][3]
		ppData = interiorDatas[editingInteriorID][4]

		setElementData(v, "editingInterior", edit)
		setElementData(v, "currentCustomInterior", editingInteriorID)

		if not playersInInterior[editingInteriorID] then
			playersInInterior[editingInteriorID] = {}
		end

		intiState[editingInteriorID] = nil

		if edit then
			intiState[editingInteriorID] = true
			editingATM[editingInteriorID] = v

			for k=1, #playersInInterior[editingInteriorID] do
				if isElement(playersInInterior[editingInteriorID][k]) then
					
					setElementPosition(playersInInterior[editingInteriorID][k], x, y, z)
					setElementInterior(playersInInterior[editingInteriorID][k], int)
					setElementDimension(playersInInterior[editingInteriorID][k], dim)

					outputChatBox(core:getServerPrefix("red-dark", "Interior szerkesztés", 2).."Az interior tulajdonosa aktiválta a szerkesztő módot, ezért ki lettél teleportálva.", playersInInterior[editingInteriorID][k], 255, 255, 255, true)
				end
			end
		end

		table.insert(playersInInterior[editingInteriorID], v)
		
		triggerClientEvent(v, "intiEdit:onInteriorLoaded", v, editingInteriorID, data, edit, size, paidCash, dynamicData, ppData)

		local x, y, z = getElementPosition(v)

		setElementData(v, "intiEditBefore", {getElementInterior(v), getElementDimension(v), x, y, z})

		setElementInterior(v, 1)
		setElementDimension(v, editingInteriorID)
	end
end

local interiorDynamicObjects = {}

function deleteDynamicObjects(id)
	if interiorDynamicObjects[id] then
		for k=1, #interiorDynamicObjects[id] do
			destroyElement(interiorDynamicObjects[id][k])
		end

		interiorDynamicObjects[id] = nil
	end
end

function processDynamicObjects(id, force)
	if interiorDynamicObjects[id] then
		if not force then
			return
		end

		deleteDynamicObjects(id)
	end
	
	interiorDynamicObjects[id] = {}

	if interiorDatas[id] and interiorDatas[id][1] then
		local proc = split(interiorDatas[id][1], ";")

		local modelCount = {}
		local ppData = interiorDatas[id][4]

		if proc[8] and proc[8] ~= "-" then
			local dat = split(proc[8], "/")

			for k=1, #dat, 5 do
				local model = tonumber(dat[k])

				if hiFis[model] then
					local obj = createObject(model, dat[k+1], dat[k+2], dat[k+3], 0, 0, dat[k+4])

					setElementInterior(obj, 1)
					setElementDimension(obj, id)

					setElementData(obj, "radioFurniture", true)
					setElementData(obj, "radioState", false)
					
					table.insert(interiorDynamicObjects[id], obj)
				elseif useableTvs[model] then
					modelCount[model] = (modelCount[model] or 0) + 1

					--if modelCount[model] <= (ppData[model] or 0) then
						local obj = createObject(model, dat[k+1], dat[k+2], dat[k+3], 0, 0, dat[k+4])

						setElementInterior(obj, 1)
						setElementDimension(obj, id)
						
						setElementData(obj, "tvFurniture", true)
						setElementData(obj, "tvState", false)
						
						table.insert(interiorDynamicObjects[id], obj)
					--end
				end
			end
		end
	end
end

--setTimer(
--	function ()
--		for k, v in pairs(getElementsByType("player")) do
--			local name = getPlayerName(v)
--
--			local editingInteriorID = 0
--
--			outputDebugString(name)
--
--			for k=1, utf8.len(name) do
--				editingInteriorID = editingInteriorID+(utf8.byte(name:sub(k,k))-64)
--			end
--
--			dbQuery(
--				function (qh)
--					local result = dbPoll( qh, -1 )
--
--					local data = false
--
--					if #result == 1 then
--						data = result[1]["interiorData"]
--					end
--
--					interiorDatas[editingInteriorID] = data
--
--					outputDebugString("your id: " .. editingInteriorID .. ", your data: " .. tostring(data))
--					triggerClientEvent(v, "intiEdit:onInteriorLoaded", v, editingInteriorID, data)
--					setElementInterior(v, 1)
--					setElementDimension(v, editingInteriorID)
--				end, connection, "SELECT * FROM interior_datas WHERE interiorId=?", editingInteriorID)
--		end
--	end, 1500, 1)--

local currentMovies = {}

registerEvent("intiEdit:playMovie", getRootElement(), 
	function (url, intiID)
		if isElement(source) then
			currentMovies[source] = {url, getTickCount()}

			--outputChatBox("play movie Server (" .. intiID .. ")")
			
			triggerClientEvent(playersInInterior[intiID], "intiEdit:playMovieC", source, url, 0)
		end
	end)

registerEvent("intiEdit:requestTV", getRootElement(), 
	function (url, intiID)
		if isElement(source) and isElement(client) and currentMovies[source] then
			videoStarted = math.floor((getTickCount() - (tonumber(currentMovies[source][2]) or 0))/1000)

			triggerClientEvent(client, "intiEdit:playMovieC", source, currentMovies[source][1], videoStarted)
		end
	end)

addEventHandler("onElementDestroy", getRootElement(), 
	function ()
			if currentMovies[source] then
				currentMovies[source] = nil
			end
		end)

registerEvent("intiEdit:stopMovie", getRootElement(), 
	function (intiID)
		if isElement(source) and currentMovies[source] then
			currentMovies[source] = false

			triggerClientEvent(playersInInterior[intiID], "intiEdit:playMovieC", source, false)
		end
	end)
