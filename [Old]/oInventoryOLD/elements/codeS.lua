local connection = exports["oMysql"]:getDBConnection()
local func = {}
local objects = {}

func["onStart"] = function()
	--trash load
	dbQuery(function(qh)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for k, row in pairs(res) do
				func["loadTrash"](row["id"])
			end
		end
	end,connection,"SELECT * FROM bins")
	--safe load
	dbQuery(function(qh)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for k, row in pairs(res) do
				func["loadSafe"](row["id"])
			end
		end
	end,connection,"SELECT * FROM szefek")
end
addEventHandler("onResourceStart",resourceRoot,func["onStart"])

---------------------------------- trash functions ----------------------------------
func["loadTrash"] = function(id)
	dbQuery(function(qh)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for k, row in pairs(res) do
				binPos = fromJSON(row["pos"]) or "[[ 0,0,0,0,0,0,0,0 ]]"
				bin = createObject(1359,binPos[1],binPos[2],binPos[3]-0.4,binPos[4],binPos[5],binPos[6])
				setElementInterior(bin,binPos[7])
				setElementDimension(bin,binPos[8])
				setElementData(bin,"isTrash",true)
				setElementData(bin,"dbid",id)
			end
		end
	end,connection,"SELECT * FROM bins WHERE id=?",id)
end

func["createTrash"] = function(playerSource, cmd)
	if getElementData(playerSource, "user:admin") >= 7 then
		local x,y,z = getElementPosition(playerSource)
		local rx,ry,rz = getElementRotation(playerSource)
		local int = getElementInterior(playerSource)
		local Dim = getElementDimension(playerSource)
		dbQuery(function(qh)
			local query, query_lines,id = dbPoll(qh, 0)
			local id = tonumber(id)
			if id > 0 then
				outputChatBox(core:getServerPrefix("green-dark", "Kuka", 2).."Sikeresen leraktál egy kukát. "..color.."("..id..")",playerSource,61, 122, 188,true)
				admin:sendMessageToAdmins(playerSource, "létrehozott egy kukát. #db3535(ID:"..id..")")
				func["loadTrash"](id)
			end
		end,connection,"INSERT INTO bins SET pos = ?",toJSON({x, y, z, rx, ry, rz, int ,Dim}))
	end
end
addCommandHandler("addbin",func["createTrash"])
addCommandHandler("createbin",func["createTrash"])
addCommandHandler("makebin",func["createTrash"])

func["delTrash"] = function(playerSource)
	if getElementData(playerSource, "user:admin") >= 7 then
		local count = 0
		local x,y,z = getElementPosition(playerSource)
		for k,v in ipairs(getElementsByType("object")) do
			if getElementData(v,"isTrash") then
				local px,py,pz = getElementPosition(v)
				if getDistanceBetweenPoints3D(x,y,z,px,py,pz)<=1.5 then
					count=count+1
					dbQuery(function(qh, v)
						local res, rows, err = dbPoll(qh, 0)
						if rows > 0 then
							outputChatBox(core:getServerPrefix("green-dark", "Kuka", 2).."Sikeresen töröltél egy kukát. "..color.."("..tonumber(getElementData(v,"dbid"))..")", playerSource,61,122,188, true)
							admin:sendMessageToAdmins(playerSource, "törölt egy kukát. #db3535(ID:"..tonumber(getElementData(v,"dbid"))..")")
							destroyElement(v)
						end
					end, {v}, connection,"DELETE FROM bins WHERE id = ?",tonumber(getElementData(v, "dbid")))
				end
			end
		end
		if count == 0 then
			outputChatBox(core:getServerPrefix("red-dark", "Kuka", 3).."Nincs a közeledben kuka.", playerSource,61,122,188, true)
		end
	end
end
addCommandHandler("delbin",func["delTrash"])

---------------------------------- safe functions ----------------------------------
func["createSafe"] = function(playerSource)
	local x,y,z = getElementPosition(playerSource)
	local rx,ry,rz = getElementRotation(playerSource)
	local int = getElementInterior(playerSource)
	local Dim = getElementDimension(playerSource)
	dbQuery(function(qh)
		local query, query_lines, id = dbPoll(qh, 0)
		local id = tonumber(id)
		if id > 0 then
			outputChatBox(core:getServerPrefix("green-dark", "Széf", 2).."Sikeresen leraktál egy széfet. "..color.."("..id..")", playerSource,61,122,188, true)
			admin:sendMessageToAdmins(playerSource, "létrehozott egy széfet. #db3535(ID:"..id..")")
			giveItem(playerSource,54,id,1,0)
			func["loadSafe"](id)
			return id
		end
	end,connection,"INSERT INTO szefek SET pos = ?",toJSON({x, y, z, rx, ry, rz, int ,Dim}))
end
addEvent("addSafeToServer", true)
addEventHandler("addSafeToServer",getRootElement(),func["createSafe"])

addCommandHandler("createsafe",
	function(source,cmd)
		if getElementData(source, "user:admin") >= 7 then 
			func["createSafe"](source)
		end
	end 
)

func["loadSafe"] = function(id)
	dbQuery(function(qh)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for k, row in pairs(res) do
				safePos = fromJSON(row["pos"]) or "[[ 0,0,0,0,0,0,0,0 ]]"
				
				safe = createObject(2332,safePos[1],safePos[2],safePos[3]-0.52,safePos[4],safePos[5],safePos[6])
				setElementInterior(safe,safePos[7])
				setElementDimension(safe,safePos[8])
				setElementDoubleSided(safe,true)
				setElementData(safe,"szef",true)
				setElementData(safe,"dbid",id)
				setElementData(safe,"safe:use",false)
				loadInventoryElement(safe)
			end
		end
	end,connection,"SELECT * FROM szefek WHERE id=?",id)
end

func["delSafe"] = function(playerSource)
	if getElementData(playerSource, "user:admin") >= 7 then
		local count = 0
		local x,y,z = getElementPosition(playerSource)
		for k,v in ipairs(getElementsByType("object")) do
			if getElementData(v,"szef") then
				local px,py,pz = getElementPosition(v)
				if getDistanceBetweenPoints3D(x,y,z,px,py,pz)<=1.5 then
					count=count+1
					dbQuery(function(qh, v)
						local res, rows, err = dbPoll(qh, 0)
		
						if tonumber(rows) > 0 then
							outputChatBox(core:getServerPrefix("green-dark", "Széf", 1).."Sikeresen töröltél egy széfet. "..color.."("..tonumber(getElementData(v,"dbid"))..")", playerSource, 255, 255, 255, true)
							admin:sendMessageToAdmins(playerSource, "törölt egy széfet. #db3535(ID:"..tonumber(getElementData(v,"dbid"))..")")
							takeAllItem(54,tonumber(getElementData(v, "dbid")))
							destroyElement(v)
						end
					end, {v}, connection,"DELETE FROM szefek WHERE id = ?", tonumber(getElementData(v, "dbid")))
				end
			end
		end
		if count == 0 then
			outputChatBox(core:getServerPrefix("red-dark", "Széf", 3).."Nincs széf a közeledben.", playerSource,61,122,188, true)
		end
	end
end
addCommandHandler("delsafe",func["delSafe"])

func["nearbySafes"] = function(playerSource)
	if getElementData(playerSource, "user:admin") >= 7 then
		local count = 0
		local x,y,z = getElementPosition(playerSource)
		for k,v in ipairs(getElementsByType("object")) do
			if getElementData(v,"szef") then
				if getElementInterior(playerSource) == getElementInterior(v) and getElementDimension(playerSource) == getElementDimension(v) then
					local px,py,pz = getElementPosition(v)
					if core:getDistance(playerSource, v) <= 3 then
						count=count+1
						outputChatBox(core:getServerPrefix("red-dark", "Széf", 1).."Közeledben lévő széf ID-je: "..color..getElementData(v,"dbid").."", playerSource,61,122,188, true)
					end
				end
			end
		end
		
		if(count == 0) then
			outputChatBox(core:getServerPrefix("red-dark", "Széf", 3).."Nincs széf a közeledben.", playerSource,61,122,188, true)
		end
	end
end
addCommandHandler("nearbysafes",func["nearbySafes"])

func["moveSafe"] = function(playerSource, cmd, safeID)
	if getElementData(playerSource, "user:admin") >= 7 then
		local x,y,z = getElementPosition(playerSource)
		local rx,ry,rz = getElementRotation(playerSource)
		local int = getElementInterior(playerSource)
		local Dim = getElementDimension(playerSource)
		safeID = tonumber(safeID)
		if safeID then
			for k,v in ipairs(getElementsByType("object")) do
				if getElementData(v,"szef") and safeID == getElementData(v,"dbid") then
					dbExec(connection, "UPDATE szefek SET pos = ? WHERE id = ?",toJSON({x, y, z, rx, ry, rz, int ,Dim}), safeID)
					setElementPosition(v,x,y,z - 0.52)
					setElementRotation(v,rx,ry,rz)
					setElementInterior(v,int)
					setElementDimension(v,Dim)
					outputChatBox(core:getServerPrefix("red-dark", "Széf", 1).."Sikeresen áthelyeztél egy széfet a te pozíciódra.", playerSource,61,122,188, true)
				end
			end
		else
			outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [Széf ID]", playerSource,61,122,188, true)
		end
	end
end
addCommandHandler("movesafe",func["moveSafe"])

func["gotoSafe"] = function(playerSource, cmd, safeID)
	if getElementData(playerSource, "user:admin") >= 7 then
		safeID = tonumber(safeID)
		if safeID then
			for k,v in ipairs(getElementsByType("object")) do
				if getElementData(v,"szef") and safeID == getElementData(v,"dbid") then
					local x,y,z = getElementPosition(v)
					local rx,ry,rz = getElementRotation(v)
					local int = getElementInterior(v)
					local Dim = getElementDimension(v)
					
					setElementPosition(playerSource,x,y,z + 0.52)
					setElementRotation(playerSource,rx,ry,rz)
					setElementInterior(playerSource,int)
					setElementDimension(playerSource,Dim)
					outputChatBox(core:getServerPrefix("server", "Használat", 1).."Sikeresen elteleportáltál a(z) "..color..safeID.."#ffffff id-jű széf poziciójára.", playerSource,61,122,188, true)
				end
			end
		else
			outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [Széf ID]", playerSource,61,122,188, true)
		end
	end
end
addCommandHandler("gotosafe",func["gotoSafe"])

addEvent("walkiTalkie > sendChatMessage", true)
addEventHandler("walkiTalkie > sendChatMessage", root, function(msg, station)
	for k, v in ipairs(getElementsByType("player")) do 
		if tonumber(getElementData(v, "char:radioStation")) == station then 
			if hasItem(v, 154) then 
				--if not (v == client) then
					outputChatBox(getPlayerName(client):gsub("_", " ").." rádióban: "..msg, v, r, g, b, true)
					triggerClientEvent(v, "faction > pd > playRadioSound", v)
				--end
			end
		end
	end
end)

-- Reload 
addEvent("inventory > reloadWeaponAmmo", true)
addEventHandler("inventory > reloadWeaponAmmo", resourceRoot, function(ped)
    reloadPedWeapon(ped) 
end)