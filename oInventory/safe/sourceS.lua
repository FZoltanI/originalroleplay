func.safe.start = function()
	dbQuery(function(qh)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for k, row in pairs(res) do
				local position = fromJSON(row.pos);
				local safe = createObject(2332,position[1],position[2],position[3]-0.52,position[4],position[5],position[6]);
				if isElement(safe) then
					setElementInterior(safe,position[7]);
					setElementDimension(safe,position[8]);
					setElementData(safe,"object:dbid",row.id);
					safeCache[safe] = true;
				end
			end
		end
	end,connection, "SELECT * FROM `szefek`");
end
addEventHandler("onResourceStart",resourceRoot,func.safe.start)

function createSafeFurniture(x, y, z, rx, ry, rz, interior, dimension, player, admincreate)
	dbQuery(function(qh)
		local query, query_lines,id = dbPoll(qh, 0)
		local id = tonumber(id)
		if id > 0 then
			if admincreate then
				outputChatBox(core:getServerPrefix("green-dark", "Inventory", 3).."Sikeresen leraktál egy széfet.",player,0,0,0,true)
				admin:sendMessageToAdmins(player, "létrehozott egy széfet. #db3535("..id..")")
			end
			giveItem(player,54,id,1,0)

			local position = {x,y,z,rx,ry,rz,interior,dimension};
			local safe = createObject(2332,position[1],position[2],position[3]-0.52,position[4],position[5],position[6]);
			setElementInterior(safe,position[7]);
			setElementDimension(safe,position[8]);
			setElementData(safe,"object:dbid",id);
			safeCache[safe] = true;
		end
	end,connection,"INSERT INTO `szefek` SET `pos` = ?",toJSON({x,y,z,rx,ry,rz,interior,dimension}))
end

func.safe.createSafe = function(playerSource,cmd)
	if getElementData(playerSource,"user:admin") >= 7 then
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(playerSource) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		local x,y,z = getElementPosition(playerSource)
		local rx,ry,rz = getElementRotation(playerSource)
		local interior = getElementInterior(playerSource)
		local dimension = getElementDimension(playerSource)
		createSafeFurniture(x, y, z, rx, ry, rz, interior, dimension, playerSource, true)
	end
end
addCommandHandler("createsafe",func.safe.createSafe)

func.safe.delSafe = function(playerSource,cmd,id)
	if getElementData(playerSource,"user:admin") >= 7 then
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(playerSource) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		if id and type(tonumber(id)) == "number" then
			id = tonumber(id)
			local count = 0
			local x,y,z = getElementPosition(playerSource)
			for v,k in pairs(safeCache) do
				if getElementData(v,"object:dbid") and getElementData(v,"object:dbid") == id then
					count=count+1
					dbExec(connection,"DELETE FROM `szefek` WHERE `id` = ?",id)
					admin:sendMessageToAdmins(playerSource, "törölt egy széfet. #db3535("..id..")")
					outputChatBox(core:getServerPrefix("green-dark", "Inventory", 3).." Sikeresen töröltél egy széfet.", playerSource,0,0,0,true)
					destroyElement(v);
				end
			end
			if count == 0 then
				outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."Hibás id.", playerSource,0,0,0,true)
			end
		else
			outputChatBox("Használat:#ffffff /"..cmd.." [id]", playerSource,r,g,b,true)
		end
	end
end
addCommandHandler("delsafe",func.safe.delSafe)

func.safe.goto = function(playerSource, cmd, id)
	if (getElementData(playerSource,"user:admin") >= 3) then
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(playerSource) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		if id and type(tonumber(id)) == "number" then
			id = tonumber(id)
			local count = 0
			for v,k in pairs(safeCache) do
				if getElementData(v,"object:dbid") and getElementData(v,"object:dbid") == id then
					count=count+1
					local x,y,z = getElementPosition(v)
					local rx,ry,rz = getElementRotation(v)
					local interior = getElementInterior(v)
					local dimension = getElementDimension(v)
					
					setElementPosition(playerSource,x,y,z + 0.52)
					setElementRotation(playerSource,rx,ry,rz)
					setElementInterior(playerSource,interior)
					setElementDimension(playerSource,dimension)
					outputChatBox(core:getServerPrefix("green-dark", "Inventory", 3).."Sikeresen elteleportáltál a(z) "..color..id.."#ffffff id-jű széf poziciójára.", playerSource,0,0,0, true)
				end
			end
			if count == 0 then
				outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).." Hibás id.", playerSource,0,0,0,true)
			end
		else
			outputChatBox("Használat:#ffffff /"..cmd.." [id]", playerSource,r,gb, true)
		end
	end
end
addCommandHandler("gotosafe",func.safe.goto)

func.safe.debug = function(playerSource, cmd, id)
	if (getElementData(playerSource,"user:admin") >= 7) then
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(playerSource) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		if id and type(tonumber(id)) == "number" then
			id = tonumber(id)
			local count = 0
			for v,k in pairs(safeCache) do
				if getElementData(v,"object:dbid") and getElementData(v,"object:dbid") == id then
					count=count+1
					setElementData(v,"safe:use",false)
					outputChatBox(core:getServerPrefix("green-dark", "Inventory", 3).."Sikeresen debugoltad a(z) "..color..id.."#ffffff id-jű széfet.", playerSource,0,0,0, true)
				end
			end
			if count == 0 then
				outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).." Hibás id.", playerSource,0,0,0,true)
			end
		else
			outputChatBox("Használat:#ffffff /"..cmd.." [id]", playerSource,r,g,b, true)
		end
	end
end
addCommandHandler("debugsafe",func.safe.debug)

func.safe.move = function(playerSource, cmd, id)
	if (getElementData(playerSource,"user:admin") >= 7) then
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(playerSource) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		if id and type(tonumber(id)) == "number" then
			local x,y,z = getElementPosition(playerSource)
			local rx,ry,rz = getElementRotation(playerSource)
			local interior = getElementInterior(playerSource)
			local dimension = getElementDimension(playerSource)
			id = tonumber(id)
			local count = 0
			for v,k in pairs(safeCache) do
				if getElementData(v,"object:dbid") and getElementData(v,"object:dbid") == id then
					count = count+1
					dbExec(connection, "UPDATE `szefek` SET `pos` = ? WHERE `id` = ?",toJSON({x,y,z,rx,ry,rz,interior,dimension}), id)
					setElementPosition(v,x,y,z - 0.52)
					setElementRotation(v,rx,ry,rz)
					setElementInterior(v,interior)
					setElementDimension(v,dimension)
					outputChatBox(core:getServerPrefix("green-dark", "Inventory", 3).."Sikeresen áthelyeztél egy széfet a te pozíciódra.", playerSource,0,0,0, true)
					admin:sendMessageToAdmins(playerSource, "áthelyezett egy széfet. #db3535("..id..")")

				end
			end
			if count == 0 then
				outputChatBox(core:getServerPrefix("red-dark", "Inventory", 3).."Hibás id.", playerSource,0,0,0,true)
			end
			
		else
			outputChatBox("Használat:#ffffff /"..cmd.." [id]", playerSource,r,g,b, true)
		end
	end
end
addCommandHandler("movesafe",func.safe.move)

func.safe.destroy = function()
	if getElementType(source) == "object" and getElementData(source,"object:dbid") and getElementModel(source) == 2332 then
		if safeCache[source] then
			safeCache[source] = nil;
		end
	end
end
addEventHandler("onElementDestroy",getRootElement(),func.safe.destroy)
