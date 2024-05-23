local func = {};
func.dbConnect = exports.oMysql
local objectCache = {};
local intinCache = {};

func.start = function()
	dbQuery(function(query)
		local res,rows,errs = dbPoll(query,0)
		if rows > 0 then
			for k,row in pairs(res) do
				if not intinCache[row.interiordbid] then
					intinCache[row.interiordbid] = {};
				end
				local default = false;
				if tostring(row.isdefault) == "true" then
					default = true;
				end
				local defaultDoor = false;
				if tostring(row.defaultdoor) == "true" then
					defaultDoor = true;
				end
				intinCache[row.interiordbid][row.id] = {
					id = tonumber(row.id);
					x = tonumber(row.x);
					y = tonumber(row.y);
					z = tonumber(row.z);
					rx = tonumber(row.rx);
					ry = tonumber(row.ry);
					rz = tonumber(row.rz);
					interior = tonumber(row.interior);
					dimension = tonumber(row.dimension);
					
					model = tonumber(row.model);
					type = tostring(row.type);
					isdefault = default;
					defaultdoor = defaultDoor;
					
					doorLock = false;

					textureDatas = fromJSON(row.texture);
				};
			end
		end
	end,func.dbConnect:getDBConnection(),"SELECT * FROM `interior_objects`")
end
addEventHandler("onResourceStart",resourceRoot,func.start)

function createDefaultObjects(interiordbid,data)
	if not intinCache[interiordbid] then
		local custom = tonumber(data.custom);
		local interior = tonumber(data.interior);
		local dimension = tonumber(data.dimension);
		for k,v in ipairs(defaultCustomObjects[custom]) do
			local defaultdoor = false
			if v.defaultDoor then
				defaultdoor = true
			end
			dbQuery(function(query,k)
				local _, _, id = dbPoll(query, 0);
				if id > 0 then
					if not intinCache[interiordbid] then
						intinCache[interiordbid] = {};
					end
					if not intinCache[interiordbid][id] then
						intinCache[interiordbid][id] = {
							id = tonumber(id);
							x = tonumber(v.x);
							y = tonumber(v.y);
							z = tonumber(v.z);
							rx = tonumber(v.rx);
							ry = tonumber(v.ry);
							rz = tonumber(v.rz);
							interior = tonumber(interior);
							dimension = tonumber(dimension);
							texture = "";
							texID = 0;
							model = tonumber(v.model);
							type = v.type;
							isdefault = true;
							defaultdoor = defaultdoor;
							folder1 = "";
							folder2 = "";
							doorLock = false;
						};
					end
				end
			end,{k},func.dbConnect:getDBConnection(), "INSERT INTO `interior_objects` SET `interiordbid` = ?, `x` = ?, `y` = ?, `z` = ?, `rx` = ?, `ry` = ?, `rz` = ?, `interior` = ?, `dimension` = ?, `texture` = ?, `model` = ?, `type` = ?, `isdefault` = ?, `defaultdoor` = ?",interiordbid,v.x,v.y,v.z,v.rx,v.ry,v.rz,interior,dimension,"",v.model,v.type,tostring(true),tostring(defaultdoor));
		end
	end
end

function deleteInteriorObjects(interiordbid,playerSource,state,interior)
	local count = 0;
	if intinCache[interiordbid] then
		for k,v in pairs(intinCache[interiordbid]) do
			if intinCache[interiordbid][v.id] then
				dbExec(func.dbConnect:getDBConnection(),"DELETE FROM `interior_objects` WHERE `id` = ?",v.id)
				intinCache[interiordbid][v.id] = nil;
				count = count+1
			end
		end
	end
	if count > 0 then
		local send = func.getPlayersInInterior(interior,interiordbid);
		triggerClientEvent(send,"deleteInteriorObjectSync",playerSource,interiordbid)
		if state then
			outputChatBox("[classGaming]:#ffffff Sikeresen kitörlődött #d23131'"..count.."'#ffffff interior elem.",playerSource,61,122,188,true)
		end
	end
end

function createInteriorObjectsServer(playerSource,dimension)
	triggerClientEvent(playerSource,"interiorObjectsSync",playerSource,intinCache[dimension])
end
addEvent("createInteriorObjectsServer",true)
addEventHandler("createInteriorObjectsServer",getRootElement(),createInteriorObjectsServer)

func.updateInteriorObjectTexture = function(playerSource, interiordbid, id, newtable)
	dbExec(func.dbConnect:getDBConnection(),"UPDATE `interior_objects` SET `texture` = ? WHERE `id` = ?", toJSON(newtable), id)
	local data = intinCache[interiordbid][id];
	intinCache[interiordbid][id] = {
		id = data.id;
		x = data.x;
		y = data.y;
		z = data.z;
		rx = data.rx;
		ry = data.ry;
		rz = data.rz;
		interior = data.interior;
		dimension = data.dimension;

		model = data.model;
		type = data.type;
		isdefault = data.isdefault;
		defaultdoor = data.defaultdoor;

		textureDatas = newtable;
	};
	local send = func.getPlayersInInterior(data.interior,data.dimension);

	print(id .. " > "..toJSON(newtable))
	triggerClientEvent(send,"updateInteriorObjectTex",playerSource,intinCache[interiordbid][id],id, newtable)
end
addEvent("updateInteriorObjectTexture",true)
addEventHandler("updateInteriorObjectTexture",getRootElement(),func.updateInteriorObjectTexture)

func.updateDefaultDoor = function(playerSource,interiordbid,id,marker,markerX,markerY,markerZ,doorX,doorY,doorZ,model)
	if marker then
		local data = intinCache[interiordbid][id];
		if data then
			dbExec(func.dbConnect:getDBConnection(),"UPDATE `interior_objects` SET `x` = ?, `y` = ?, `z` = ?, `model` = ? WHERE `id` = ?",doorX,doorY,doorZ,model,id)
			intinCache[interiordbid][id].x = doorX;
			intinCache[interiordbid][id].y = doorY;
			intinCache[interiordbid][id].z = doorZ;
			intinCache[interiordbid][id].model = model;
			local send = func.getPlayersInInterior(data.interior,data.dimension);
			triggerClientEvent(send,"syncClientDoorObject",playerSource,{x = doorX,y = doorY,z = doorZ, model = model});
			exports["pb_interiors"]:updateInteriorPosition(marker,markerX,markerY,markerZ)
		end
	end
end
addEvent("updateDefaultDoor",true)
addEventHandler("updateDefaultDoor",getRootElement(),func.updateDefaultDoor)

local timer = {};

func.createInteriorWalls = function(playerSource,interiordbid,playerInterior,data)
	local count = 0;
	local load = 0;
	for k,v in pairs(data) do
		count = count+1
		dbQuery(function(query,v)
			local _, _, id = dbPoll(query, 0);
			if id > 0 then
				if not intinCache[interiordbid] then
					intinCache[interiordbid] = {};
				end
				if not intinCache[interiordbid][id] then
					load = load+1
					intinCache[interiordbid][id] = {
						id = tonumber(id);
						x = tonumber(v.x);
						y = tonumber(v.y);
						z = tonumber(v.z);
						rx = tonumber(v.rx);
						ry = tonumber(v.ry);
						rz = tonumber(v.rz);
						interior = tonumber(v.interior);
						dimension = tonumber(v.dimension);
						texture = "";
						texID = 0;
						model = tonumber(v.model);
						type = v.type;
						isdefault = false;
						defaultdoor = false;
						folder1 = "";
						folder2 = "";
						doorLock = false;
					};
				end
			end
		end,{v},func.dbConnect:getDBConnection(), "INSERT INTO `interior_objects` SET `interiordbid` = ?, `x` = ?, `y` = ?, `z` = ?, `rx` = ?, `ry` = ?, `rz` = ?, `interior` = ?, `dimension` = ?, `texture` = ?, `model` = ?, `type` = ?, `isdefault` = ?, `defaultdoor` = ?",interiordbid,v.x,v.y,v.z,v.rx,v.ry,v.rz,v.interior,v.dimension, toJSON({}), v.model,v.type,tostring(false),tostring(false));
	end
	
	if not timer[playerSource] then
		timer[playerSource] = {};
	end
	timer[playerSource][interiordbid] = setTimer(function()
		if count > 0 and load == count then
			local send = func.getPlayersInInterior(playerInterior,interiordbid);
			triggerClientEvent(send,"syncUpdateInteriorObjects",playerSource,intinCache[interiordbid]);
			killTimer(timer[playerSource][interiordbid])
		end
	end,50,0)
end
addEvent("createInteriorWalls",true)
addEventHandler("createInteriorWalls",getRootElement(),func.createInteriorWalls)

func.changeWalldoorLock = function(playerSource,interiordbid,id,playerInterior,state)
	intinCache[interiordbid][id].doorLock = state;
	local send = func.getPlayersInInterior(playerInterior,interiordbid);
	triggerClientEvent(send,"syncWallDoorLock",playerSource,id,intinCache[interiordbid][id].doorLock);
end
addEvent("changeWalldoorLock",true)
addEventHandler("changeWalldoorLock",getRootElement(),func.changeWalldoorLock)

func.getPlayersInInterior = function(interior,dimension)
	local players = getElementsByType("player")
	local players_in_interior = {};
	for k, player in ipairs(players) do
		if(getElementInterior(player) == interior and getElementDimension(player) == dimension) then
			table.insert(players_in_interior, player)
		end
	end
	return players_in_interior
end