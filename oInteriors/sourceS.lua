local func = {};
func.dbConnect = exports["oMysql"];
local markerCache = {};

local mappedInteriorObjectCache = {};

local getPlayerName_ = getPlayerName
getPlayerName = function( ... )
	s = getPlayerName_( ... )
	return s and s:gsub( "_", " " ) or s
end

function getPlayerSpecialName(player)
    return getPlayerName(player):gsub("_", " ") .. "[" .. (getElementData(player, "player:dbid") or 0) .. "]";
end

function sendMessageToAdmins(player, msg)
	triggerClientEvent(getRootElement(), "sendMessageToAdmins", getRootElement(), player, msg, 8)
end

setElementData(root,"propertyNoti", false)

-- 1hét = 604800
-- 1hónap = 2678400

local rentTimeDuration = 60 * 60 * 24 * 7 -- 7 nap

local dayTimeDuration = 60 * 60 * 24 -- 24 óra

--local ped = createPed(0, 1515.7470703125,-2178.6826171875,13.546875)
--setElementData(ped, "ped:name", "Phill Dwayne")
--setElementData(ped, "renewalPed", true)


func.createInterior = function(playerSource, cmd, intid, inttype, cost, custom, ...)
	if getElementData(playerSource, "user:admin") >= 7 then
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(playerSource) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		intid = tonumber(intid)
		inttype = tonumber(inttype)
		cost = tonumber(cost)
		custom = tonumber(custom)
		if type(intid) == "number" and type(inttype) == "number" and (inttype == 0 or inttype == 1 or inttype == 2 or inttype == 3 or inttype == 4) and type(cost) == "number" and type(custom) == "number" and (custom >= 0 and custom <= 7) and (...) then
			name = table.concat({...}, " ")
			x,y,z = getElementPosition(playerSource)
			intbel = interiorok[intid]
			if intbel then
				local interiorid = intbel[1]
				local ix = intbel[2]
				local iy = intbel[3]
				local iz = intbel[4]
				
				if custom > 0 then
					interiorid = 1
					ix, iy, iz = 701.65826416016, 1700.8586425781, 401.0859375
				end

				local marker_int = getElementInterior(playerSource)
				local marker_dim = getElementDimension(playerSource)
				dbQuery(function(qh)
					local query, query_lines,id = dbPoll(qh, 0)
					local id = tonumber(id)
					if id > 0 then
						sendMessageToAdmins(playerSource, "létrehozott egy interior #db3535"..name.." #557ec9néven. #db3535("..id..")")
						setElementData(playerSource, "log:admincmd", {"Int "..id, cmd})
						local data = {
							id = id;
							owner = 0;
							type = inttype;
							x = x;
							y = y;
							z = z;
							interiorx = ix;
							interiory = iy;
							interiorz = iz;
							custom = custom;
							locked = 0;
							cost = cost;
							name = name;
							dimensionwithin = marker_dim;
							interiorwithin = marker_int;
							interior = interiorid;
							interiorID = intid;
						};
						func.createInteriorMarker(data)
					end
				end,func.dbConnect:getDBConnection(),"INSERT INTO interiors SET x = ?, y = ?, z = ?, interiorx = ?, interiory = ?, interiorz = ?, name = ?, type = ?, cost = ?, interior = ?, interiorwithin = ?, dimensionwithin = ?, owner = ?, custom = ?, interiorID = ?",x, y, z, ix, iy, iz, name, inttype, cost, interiorid, marker_int, marker_dim, 0, custom, intid)
			end
		else
			outputChatBox(core:getServerPrefix("server", "Használat", 3).."/" .. cmd .. " [interiorid] [tipus] [ár] [egyedi: >=1 igen, 0 nem] [név]", playerSource,61,122,188,true)
			outputChatBox(core:getServerPrefix("server", "Típusok", 3).." [0 - ház] [1 - biznisz] [2 - önkormányzati] [3 - bérház #D23131(Nem használható!)#FFFFFF ] [4 - Garázs]", playerSource,61,122,188,true)
		end
	end
end
addCommandHandler("createinterior",func.createInterior)

func.deleteInterior = function (playerSource, cmd, id)
	if getElementData(playerSource, "user:admin") >= 7 then
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(playerSource) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		id = tonumber(id)
		if type(id) == "number" then
			for v,k in pairs(markerCache) do
				if getElementData(v,"isIntMarker") then
					if getElementData(v,"dbid") == id then
						dbQuery(function(qh)
							local res, rows, err = dbPoll(qh, 0)
							if rows > 0 then
								sendMessageToAdmins(playerSource, "kitörölte a(z) #db3535"..getElementData(v,"name").." #557ec9névvel rendelkező interiort. #db3535("..id..")")

								setElementData(playerSource, "log:admincmd", {"Int "..id, cmd})
								local other = getElementData(v,"other")
								--if getElementData(v,"custom") > 0 then
								--	exports["oIntCustom"]:deleteInteriorObjects(id,playerSource,true,getElementInterior(other))
								--end
								destroyElement(other)
								destroyElement(v)
							end
						end, func.dbConnect:getDBConnection(),"DELETE FROM `interiors` WHERE id = ?",tonumber(id))
					end
				end
			end
		else
			outputChatBox(core:getServerPrefix("server", "Használat", 3).."/".. cmd .." [ID]",playerSource,61,122,188,true)
		end
	end
end
addCommandHandler("delinterior",func.deleteInterior)

func.start = function()
	dbQuery(function(qh)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for k, row in pairs(res) do
				local data = {
					id = row["id"];
					owner = row["owner"];
					type = row["type"];
					x = row["x"];
					y = row["y"];
					z = row["z"]-0.35;
					interiorx = row["interiorx"];
					interiory = row["interiory"];
					interiorz = row["interiorz"];
					custom = row["custom"];
					locked = row["locked"];
					cost = row["cost"];
					name = row["name"];
					dimensionwithin = row["dimensionwithin"];
					interiorwithin = row["interiorwithin"];
					interior = row["interior"];
					interiorID = row["interiorID"];
					renewalTime = row["renewalTime"];
				};
				func.createInteriorMarker(data)
			end
		end
	end,func.dbConnect:getDBConnection(),"SELECT * FROM `interiors`")
end
addEventHandler("onResourceStart",getResourceRootElement(getThisResource()),func.start)

serverSyntax = serverColor.."["..core:getServerName().."]:#ffffff"


function processRentedInteriors()
	local currentTime = getRealTime().timestamp
	for v,k in pairs(markerCache) do
		if getElementData(v,"isIntMarker") then
			if getElementData(v, "owner") > 0 and getElementData(v, "renewalTime") > 0 then 
				local playerSource = false

				for k2, v2 in ipairs(getElementsByType("player")) do
					if isElement(v2) then
						if getElementData(v, "owner") == getElementData(v2, "char:id") then
							playerSource = v2
							break
						end
					end
				end

				if currentTime + 600 >= getElementData(v, "renewalTime") then
					if isElement(playerSource) then 
						outputChatBox(serverSyntax .." Nem hosszabbítottad meg az ingatlanod!",playerSource, 255, 255, 255, true)
					end

					resetInterior(getElementData(v,"dbid"))

				elseif getElementData(v, "renewalTime") - dayTimeDuration <= currentTime then
					if isElement(playerSource) then
						local remaining = math.floor((getElementData(v, "renewalTime")  - currentTime) % dayTimeDuration / 3600) + 1
						outputChatBox(serverSyntax .." Hamarosan lejár a(z) "..color..getElementData(v, "name").." #ffffffnévvel rendelkező ingatlanod bérlési ideje. (".. remaining .." óra) Meghosszabbítani a /rent parancsal tudod!",playerSource, 255, 255, 255, true)
					end
				end
			end
		end
	end
end
setTimer(processRentedInteriors, core:minToMilisec(60), 0)

func.createInteriorMarker = function(row) 
	local interiorR, interiorG, interiorB = getInteriorMarkerColor(row["type"], row["owner"])

	markerElement = createMarker( row["x"], row["y"], row["z"]-1.2, "cylinder",1, interiorR, interiorG, interiorB , 150)
	intmarkerElement = createMarker( row["interiorx"], row["interiory"], row["interiorz"]-1.2, "cylinder", 0.8, interiorR, interiorG, interiorB, 150)

	setElementAlpha(markerElement, 0)
	setElementAlpha(intmarkerElement, 0)
    
	setElementData(markerElement,"ownerName","")
	setElementData(intmarkerElement,"ownerName","")
	
	dbQuery(function(qh,markerElement,intmarkerElement)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for k, row in pairs(res) do
				setElementData(markerElement,"ownerName",row["charactername"])
				setElementData(intmarkerElement,"ownerName",row["charactername"])
			end
		end
	end,{markerElement,intmarkerElement},func.dbConnect:getDBConnection(),"SELECT * FROM `characters` WHERE `id` = ?",row["owner"])
	
	markerCache[markerElement] = true;
	markerCache[intmarkerElement] = true;
	
	setElementData(markerElement,"isIntMarker",true)
	setElementData(intmarkerElement,"isIntOutMarker",true)
	setElementData(markerElement,"other",intmarkerElement)
	setElementData(intmarkerElement,"other",markerElement)
	setElementData(markerElement,"dbid",row["id"])
	setElementData(intmarkerElement,"dbid",row["id"])
	setElementData(markerElement,"time",0)
	setElementData(intmarkerElement,"time",0)
	setElementData(markerElement,"inttype",row["type"])
	setElementData(intmarkerElement,"inttype",row["type"])
	setElementData(markerElement,"owner",row["owner"])
	setElementData(intmarkerElement,"owner",row["owner"])
	
	setElementData(markerElement,"x",row["x"])
	setElementData(intmarkerElement,"x",row["interiorx"])
	setElementData(markerElement,"y",row["y"])
	setElementData(intmarkerElement,"y",row["interiory"])
	setElementData(markerElement,"z",row["z"])
	setElementData(intmarkerElement,"z",row["interiorz"])
	
	setElementData(markerElement,"custom",row["custom"])
	setElementData(intmarkerElement,"custom",row["custom"])
	
	setElementData(markerElement, "locked", row["locked"])
	setElementData(markerElement, "cost", row["cost"])
	setElementData(markerElement, "name", row["name"])
	setElementDimension(markerElement, row["dimensionwithin"])
	setElementInterior(markerElement, row["interiorwithin"])
	
	setElementData(intmarkerElement, "locked", row["locked"])
	setElementData(intmarkerElement, "cost", row["cost"])
	setElementData(intmarkerElement, "name", row["name"])
	setElementInterior(intmarkerElement, row["interior"])
	setElementDimension(intmarkerElement, row["id"])

	setElementData(intmarkerElement,"interiorid",row["interiorID"])


	setElementData(markerElement, "renewalTime", row["renewalTime"])

	if customInteriorObjects[row["interiorID"]] then 
		mappedInteriorObjectCache[row["id"]] = {}

		for k, v in ipairs(customInteriorObjects[row["interiorID"]]) do 
			local object = createObject(v[1], v[2], v[3], v[4], v[5], v[6], v[7])
			setObjectScale(object, v[8] or 1)
			setElementDimension(object, row["id"])
			setElementInterior(object,  row["interior"])
			setElementDoubleSided(object, v[9] or true)

			table.insert(mappedInteriorObjectCache[row["id"]], object)

			if row["interiorID"] == 138 then
				if v[1] == 1715 then 
					setElementData(object, "job:hacker:isHackerChair", true)
				end
			end
		end
	end

	if (row["renewalTime"] or 0) > 0 and getRealTime().timestamp >( row["renewalTime"] or 0) then 
		resetInterior(row["id"])
	end

	return markerElement
end

function createInteriorExport(intid, inttype, cost, custom, name, x, y, z, marker_int, marker_dim) 
	intid = tonumber(intid)
	inttype = tonumber(inttype)
	cost = tonumber(cost)
	custom = tonumber(custom)
	if type(intid) == "number" and type(inttype) == "number" and (inttype >= 0 and inttype <= 5) and type(cost) == "number" and type(custom) == "number" and (custom >= 0 and custom <= 7) and name then
		intbel = interiorok[intid]
		if intbel then
			local interiorid = intbel[1]
			local ix = intbel[2]
			local iy = intbel[3]
			local iz = intbel[4]
			
			if custom > 0 then
				interiorid = 1
				ix, iy, iz = 701.65826416016, 1700.8586425781, 401.0859375
			end

			dbQuery(function(qh)
				local query, query_lines,id = dbPoll(qh, 0)
				local id = tonumber(id)
				if id > 0 then

					local data = {
						id = id;
						owner = 0;
						type = inttype;
						x = x;
						y = y;
						z = z;
						interiorx = ix;
						interiory = iy;
						interiorz = iz;
						custom = custom;
						locked = 0;
						cost = cost;
						name = name;
						dimensionwithin = marker_dim;
						interiorwithin = marker_int;
						interior = interiorid;
						interiorID = intid;
					};
					marker = func.createInteriorMarker(data)
					
					if inttype == 5 then -- DROGFARM (NE BIRIZGÁLD MERT AKKOR ELROMLIK!)
						triggerEvent("attachInteriorWithContainer", root, {x, y, z}, id)
					end
				end
			end,func.dbConnect:getDBConnection(),"INSERT INTO interiors SET x = ?, y = ?, z = ?, interiorx = ?, interiory = ?, interiorz = ?, name = ?, type = ?, cost = ?, interior = ?, interiorwithin = ?, dimensionwithin = ?, owner = ?, custom = ?, interiorID = ?",x, y, z, ix, iy, iz, name, inttype, cost, interiorid, marker_int, marker_dim, 0, custom, intid)
		end
	end
end



addEvent("renewalInterior", true)
addEventHandler("renewalInterior", getRootElement(), function(interiorId, player, price)
	local markerElement, markerElement2 = getInteriorDetails(interiorId)
	local currentTime = getRealTime().timestamp
	if getElementData(markerElement, "renewalTime") - dayTimeDuration <= currentTime then
		local renewalTime = getRealTime().timestamp + 2678400
		setElementData(markerElement, "renewalTime", renewalTime)
		dbExec(func.dbConnect:getDBConnection(), "UPDATE interiors SET renewalTime = ? WHERE id = ?", renewalTime, interiorId)
		outputChatBox(serverSyntax.. " Sikeresen meghosszabítottad az ingatlanod (".. formatDate("Y-m-d", "'", tostring(renewalTime))..") ".. price.." $-ért", player, 255,255,255,true)
		setElementData(player,"char:money", getElementData(player,"char:money")-price)
	else 
		outputChatBox(serverSyntax.. " Még nem tudod meghosszabítani!", player, 255,255,255,true)
	end
end)


function resetInterior(interiorId)

	local markerElement, markerElement2 = getInteriorDetails(interiorId)
	if isElement(markerElement) and isElement(markerElement2) then 
		setElementData(markerElement, "locked", 0)
		setElementData(markerElement2, "locked", 0)		
		
		setElementData(markerElement, "owner", 0)
		setElementData(markerElement2, "owner", 0)
		local inttype = getElementData(markerElement, "inttype")
		local owner = getElementData(markerElement, "owner")

		local interiorR, interiorG, interiorB = getInteriorMarkerColor(inttype, owner)

		for v,k in pairs(markerCache) do
			if getElementData(v, "dbid") == interiorId then
				setMarkerColor(v,interiorR, interiorG, interiorB, 150)
				setElementAlpha(v, 0)
			end	
		end

		dbExec(func.dbConnect:getDBConnection(), "UPDATE interiors SET locked = ?, owner = ? WHERE id = ?",0, 0, interiorId)

		exports["oInventory"]:takeAllItem(52, interiorId)
	end
end

function getInteriorDetails(interiorId)
	for v,k in pairs(markerCache) do
		if getElementData(v,"isIntMarker") then
			if getElementData(v,"dbid") == interiorId then
				return v, getElementData(v,"other")
			end
		end
	end
	return false
end


func.onDestroy = function()
	if getElementType(source) == "marker" and markerCache[source] then
		markerCache[source] = nil;
	end
end
addEventHandler("onElementDestroy", getRootElement(),func.onDestroy)

addEvent("lockIntToClient",true)
addEventHandler("lockIntToClient",getRootElement(),function(playerSource,id,lock)
	dbExec(func.dbConnect:getDBConnection(), "UPDATE interiors SET locked = ? WHERE id = ?",lock,id)

	if getElementData(playerSource, "user:aduty") then 
		if lock == 1 then 
			triggerClientEvent(getRootElement(), "sendMessageToAdmins", getRootElement(), playerSource, "bezárta egy ingatlan ajtaját. #db3535("..id..")")
		else
			triggerClientEvent(getRootElement(), "sendMessageToAdmins", getRootElement(), playerSource, "kinyitotta egy ingatlan ajtaját. #db3535("..id..")")
		end
	end
end)

function updateInteriorOwner(intID,inttype,playerSource)
	local owner = getElementData(playerSource,"char:id");
	dbExec(func.dbConnect:getDBConnection(),"UPDATE interiors SET owner=? WHERE id = ?",owner,intID)

	local interiorR, interiorG, interiorB = getInteriorMarkerColor(inttype, owner)

	if owner > 0 and inttype == 0 then 
		local renewalTime = getRealTime().timestamp + 2678400
		dbExec(func.dbConnect:getDBConnection(), "UPDATE interiors SET renewalTime = ? WHERE id = ?", renewalTime, intID)
	elseif owner > 0 and inttype == 5 then 
		local renewalTime = getRealTime().timestamp + 500
		dbExec(func.dbConnect:getDBConnection(), "UPDATE interiors SET renewalTime = ? WHERE id = ?", renewalTime, intID)
	end
	
	for v,k in pairs(markerCache) do
		if getElementData(v, "dbid") == intID then
			setMarkerColor(v,interiorR, interiorG, interiorB, 150)
			setElementAlpha(v, 0)
			setElementData(v,"owner",owner)
			setElementData(v,"ownerName",getPlayerName(playerSource))
			local renewalTime = getRealTime().timestamp + 2678400
			setElementData(v, "renewalTime", renewalTime)
		end	
	end
end
addEvent("updateInteriorOwner", true)
addEventHandler("updateInteriorOwner", getRootElement(), updateInteriorOwner)

local timers = {}
function changeInterior(playerSource, x, y, z, int, dim,marker)
    local playerSource = playerSource
	setElementPosition(playerSource, x, y, z + 1.1)
	setElementDimension(playerSource, dim)
	setElementInterior(playerSource, int)
    setElementFrozen(playerSource, true)
    setTimer(
        function()
            if isElement(playerSource) then
                setElementFrozen(playerSource, false)
            end
        end, 1500, 1
    )
    
    --setElementCollisionsEnabled(playerSource, false)
    
    if isTimer(timers[playerSource]) then
        triggerClientEvent(playerSource, "ghostPlayerOff", playerSource)
        local oldAlpha = getElementData(playerSource, "oldAlpha")
        setElementAlpha(playerSource, oldAlpha)
        killTimer(timers[playerSource])
    end
    
    triggerClientEvent(playerSource, "ghostPlayerOn", playerSource)
    local oldAlpha = getElementAlpha(playerSource)
    setElementData(playerSource, "oldAlpha", oldAlpha)
    setElementAlpha(playerSource, 150)
    timers[playerSource] = setTimer(
        function()
            if isElement(playerSource) then
                triggerClientEvent(playerSource, "ghostPlayerOff", playerSource)
                setElementAlpha(playerSource, oldAlpha)
            end
        end, 4000, 1
    )

	if dim > 0 then
		local custom = getElementData(marker, "custom")
		if custom > 0 then 
			exports.oInteriorBuilding:loadInterior(playerSource, dim, false, custom)
		end
	end
end
addEvent("changeInterior", true)
addEventHandler("changeInterior", getRootElement(), changeInterior)

function changeVehInterior(playerSource,veh, x, y, z, int, dim)
    local playerSource = playerSource
	local veh = getPedOccupiedVehicle(playerSource)
	if veh then
		setElementPosition(veh, x, y, z + 1)
		setElementDimension(veh, dim)
		setElementInterior(veh, int)
        
        setElementFrozen(veh, true)
        setTimer(
            function()
                if isElement(veh) then
                    setElementFrozen(veh, false)
                end
            end, 1500, 1
        )
        
        if isTimer(timers[playerSource]) then
            triggerClientEvent(playerSource, "ghostOff", playerSource)
            local oldAlpha = getElementData(playerSource, "oldAlpha")
            setElementAlpha(playerSource, oldAlpha)
            
            local oldAlpha = getElementData(veh, "oldAlpha")
            setElementAlpha(veh, oldAlpha)
            killTimer(timers[playerSource])
        end
        
        local oldAlpha = getElementAlpha(veh)
        setElementData(veh, "oldAlpha", oldAlpha)
        setElementAlpha(veh, 150)
        local oldAlpha2 = getElementAlpha(playerSource)
        setElementData(playerSource, "oldAlpha", oldAlpha2)
        setElementAlpha(playerSource, 150)
        triggerClientEvent(playerSource, "ghostOn", playerSource)
        timers[playerSource] = setTimer(
            function()
                if isElement(playerSource) then
                    triggerClientEvent(playerSource, "ghostOff", playerSource)
                    setElementAlpha(playerSource, oldAlpha2)
                    setElementAlpha(veh, oldAlpha)
                end
            end, 5000, 1
        )
        
        local lampObject = getElementData(veh, "lampObject")
        if isElement(lampObject) then
            setElementDimension(lampObject, dim)
            setElementInterior(lampObject, int)
        end
        local lampMarker = getElementData(veh, "lampMarker")
        if isElement(lampMarker) then
            setElementDimension(lampMarker, dim)
            setElementInterior(lampMarker, int)
        end
        
        local sirenObject = getElementData(veh, "sirenObject")
        if isElement(sirenObject) then
            setElementDimension(sirenObject, dim)
            setElementInterior(sirenObject, int)
        end
        local sirenMarker = getElementData(veh, "sirenMarker")
        if isElement(sirenMarker) then
            setElementDimension(sirenMarker, dim)
            setElementInterior(sirenMarker, int)
        end
        
        for k,v in pairs(getVehicleOccupants(veh)) do
            --setElementPosition(playerSource, x, y, z)
            setElementDimension(v, dim)
            setElementInterior(v, int)
        end
	end
end
addEvent("changeVehInterior", true)
addEventHandler("changeVehInterior", getRootElement(), changeVehInterior)

function giveInteriorKey(playerSource,value)
	exports.oInventory:giveItem(playerSource, 52, value, 1, 0)
end
addEvent("giveInteriorKey",true)
addEventHandler("giveInteriorKey",getRootElement(),giveInteriorKey)

func.changeInteriorName = function(playerSource,cmd,id,...)
	if getElementData(playerSource, "user:admin") >= 4 then
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(playerSource) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		id = tonumber(id)
		if type(id) == "number" and (...) then
			local name = table.concat({...}, " ");
			local count = 0;
			local oldName
			local newName
			for v,k in pairs(markerCache) do
				if getElementData(v,"dbid") == id then
					count = count+1
					oldName = getElementData(v, "name")
					setElementData(v,"name",name)
					newName = name
				end
			end
			
			if count == 0 then
				outputChatBox(serverSyntax.." Hibás interior id.",playerSource,61,122,188,true)
			else
				sendMessageToAdmins(playerSource, "megváltoztatta a(z) #db3535"..newName.." #557ec9névvel rendelkező interior nevét. Régi név:#db3535 "..oldName.."#557ec9. #db3535("..id..")")
				setElementData(playerSource, "log:admincmd", {"Int "..id, cmd})
				dbExec(func.dbConnect:getDBConnection(), "UPDATE `interiors` SET `name` = ? WHERE id = ?",name,id)
			end
		else
			outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [id] [Név]",playerSource,61,122,188,true)
		end
	end
end
addCommandHandler("setinteriorname",func.changeInteriorName)

func.setInteriorCost = function(playerSource,cmd,id,cost)
	if getElementData(playerSource, "user:admin") >= 7 then
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(playerSource) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		id = tonumber(id)
		cost = tonumber(cost)
		if type(id) == "number" and type(cost) == "number" then
			local count = 0;
			local oldCost
			local name
			for v,k in pairs(markerCache) do
				if getElementData(v,"dbid") == id then
					count = count+1;
					oldCost = getElementData(v, "cost")
					name = getElementData(v, "name")
					setElementData(v,"cost",cost)
				end
			end
			if count == 0 then
				outputChatBox(core:getServerPrefix("red-dark", "Interior", 3).." Hibás interior id.",playerSource,61,122,188,true)
			else
				sendMessageToAdmins(playerSource, "megváltoztatta a(z) #db3535"..name.." #557ec9névvel rendelkező interior alapárát. #db3535 "..oldCost.."$ #557ec9>#db3535 "..cost.."$#557ec9. #db3535("..id..")")
				setElementData(playerSource, "log:admincmd", {"Int "..id, cmd})
				dbExec(func.dbConnect:getDBConnection(), "UPDATE `interiors` SET `cost` = ? WHERE id = ?",cost,id)
			end
		else
			outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [InteriorID] [Összeg]",playerSource,61,122,188,true)
		end
	end
end
addCommandHandler("setinteriorcost",func.setInteriorCost)

func.getInteriorCost = function(playerSource)
	if getElementData(playerSource, "user:admin") >= 4 then
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(playerSource) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		if getElementData(playerSource, "isInIntMarker") then
			local theIntElement = getElementData(playerSource,"int:Marker")
			if getElementData(theIntElement,"isIntMarker") then
				local cost = getElementData(theIntElement,"cost")
				outputChatBox(core:getServerPrefix("server", "Interior", 3).." Ennek az interior-nak az alapára #7cc576"..cost.."#ffffff $.",playerSource,61,122,188,true)
			end
		else
			outputChatBox(core:getServerPrefix("red-dark", "Interior", 3).." Nem állsz interior markerben.",playerSource,61,122,188,true)
		end
	end
end
addCommandHandler("getinteriorcost",func.getInteriorCost)

--[[func.sellProperty = function(playerSource)
	if getElementData(playerSource, "isInIntMarker") == true then
		local marker = getElementData(playerSource,"int:Marker")
		local owner = getElementData(marker,"owner")
		if getElementData(marker,"isIntMarker") then
			if tonumber(getElementData(playerSource,"char:id")) == tonumber(owner) then
				local cost = getElementData(marker,"cost")
				local id = getElementData(marker,"dbid")
				local inttype = getElementData(marker,"inttype")
				setElementData(playerSource,"char:money",getElementData(playerSource,"char:money")+(cost/2))
				outputChatBox(core:getServerPrefix("green-dark", "Interior", 3).." Sikeresen eladóvá tetted az ingatlanodat, így megkaptad az alapárának a felét, ami #7cc576"..(cost/2).."#ffffff$.",playerSource,61,122,188,true)
				exports.oInventory:takeAllItem(52, id)
				dbExec(func.dbConnect:getDBConnection(), "UPDATE `interiors` SET `owner` = ? WHERE id = ?",0,id)
				local color = {61,122,188,150};
				if 0 <= 0 and inttype == 0 then
					color = {124,197,118,150};
				elseif inttype == 1 and 0 <= 0 then
					color = {124,197,118,150};
				elseif inttype == 1 and 0 >= 1 then
					color = {248,126,136,150};
				elseif inttype == 2 then
					color = {255,128,64,150};
				elseif inttype == 4 and 0 <= 0 then
					color = {124,197,118,150};
				elseif inttype == 4 and 0 >= 1 then
					color = {128,128,192,150};
				end
				
				for v,k in pairs(markerCache) do
					if getElementData(v, "dbid") == id then
						setMarkerColor(v,color[1],color[2],color[3],color[4])
						setElementData(v,"owner",0)
						setElementAlpha(v, 0)
						setElementData(v,"ownerName","")
					end
				end
				setElementData(playerSource,"isInIntMarker",false)
				setElementData(playerSource,"int:Marker",nil)
			else
				outputChatBox(core:getServerPrefix("red-dark", "Interior", 3).." Ennek az interiornak nem te vagy a tulajdonosa.",playerSource,61,122,188,true)
			end
		end
	else
		outputChatBox(core:getServerPrefix("red-dark", "Interior", 3).." Nem állsz interior markerben.",playerSource,61,122,188,true)
	end
end
addCommandHandler("sellproperty",func.sellProperty)]]

func.adminSell = function(playerSource)
	if getElementData(playerSource, "user:admin") >= 7 then
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(playerSource) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		if getElementData(playerSource, "isInIntMarker") then
			local marker = getElementData(playerSource,"int:Marker")
			if getElementData(marker,"isIntMarker") then
				local owner = getElementData(marker,"owner")
				if owner > 0 then
					local id = getElementData(marker,"dbid")
					local inttype = getElementData(marker,"inttype")
					outputChatBox(core:getServerPrefix("green-dark", "Interior", 3).." Sikeresen eladóvá tettél egy ingatlant.",playerSource,61,122,188,true)

					local intName = getElementData(marker, "name")
					sendMessageToAdmins(playerSource, "eladóvá tette a(z) #db3535"..(intName or "nan").." #557ec9nevű ingatlant. Előző tulajdonos: #db3535"..(getElementData(marker, "ownerName") or "nan").."#557ec9. #db3535("..(id or 0)..") ")
					setElementData(playerSource, "log:admincmd", {"Int "..id, "asellint"})
					dbExec(func.dbConnect:getDBConnection(), "UPDATE `interiors` SET `owner` = ? WHERE `id` = ?",0,id)
					exports.oInventory:takeAllItem(52, tonumber(id))
					local color = {61,122,188,150};
					if 0 <= 0 and inttype == 0 then
						color = {124,197,118,150};
					elseif inttype == 1 and 0 <= 0 then
						color = {124,197,118,150};
					elseif inttype == 1 and 0 >= 1 then
						color = {248,126,136,150};
					elseif inttype == 2 then
						color = {255,128,64,150};
					elseif inttype == 4 and 0 <= 0 then
						color = {124,197,118,150};
					elseif inttype == 4 and 0 >= 1 then
						color = {128,128,192,150};
					end
					
					for v,k in pairs(markerCache) do
						if getElementData(v, "dbid") == id then
							setMarkerColor(v,color[1],color[2],color[3],color[4])
							setElementAlpha(v, 0)
							setElementData(v,"owner",0)
							setElementData(v,"ownerName","")
						end
					end
					setElementData(playerSource,"isInIntMarker",false)
					setElementData(playerSource,"int:Marker",nil)
				end
			end
		else
			outputChatBox(core:getServerPrefix("red-dark", "Interior", 3).." Nem állsz interior markerben.",playerSource,61,122,188,true)
		end
	end
end
addCommandHandler("asellint",func.adminSell)

func.gotoHouse = function(playerSource,cmd,id)
	if getElementData(playerSource,"user:admin") >= 3 then
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(playerSource) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		id = tonumber(id)
		if type(id) == "number" then
			local count = 0;
			for v,k in pairs(markerCache) do
				if getElementData(v,"isIntMarker") then
					if getElementData(v,"dbid") == id then
						count = count+1
						local x,y,z = getElementPosition(v)
						setElementPosition(playerSource,x,y,z+1.45)
						setElementInterior(playerSource,getElementInterior(v))
						setElementDimension(playerSource,getElementDimension(v))

						local intName = getElementData(v, "name")
						sendMessageToAdmins(playerSource, "odateleportált a(z) #db3535"..intName.." #557ec9nevű ingatlanhoz. #db3535("..id..")")
					end
				end
			end
			if count == 0 then
				outputChatBox(core:getServerPrefix("red-dark", "Interior", 3).." Hibás interior id.",playerSource,61,122,188,true)
			end
		else
			outputChatBox(core:getServerPrefix("server", "Használat", 3).."/ "..cmd.." [ID]", playerSource,61,122,188,true)
		end
	end
end
addCommandHandler("gotohouse",func.gotoHouse)

func.setInteriorId = function(playerSource,cmd,reID)
	if getElementData(playerSource, "user:admin") >= 7 then
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(playerSource) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		if reID then
			reID = tonumber(reID)
			if getElementData(playerSource, "isInIntMarker") then
				local theInteriorElement = getElementData(playerSource,"int:Marker")
				if getElementData(theInteriorElement,"isIntOutMarker") or false then
					local customInt = getElementData(theInteriorElement,"custom")
					if customInt == 0 then
						intOut = interiorok[tonumber(reID)]
						if intOut then
							local interiorid = intOut[1]
							local ix = intOut[2]
							local iy = intOut[3]
							local iz = intOut[4]

							local dbid = getElementData(theInteriorElement, "dbid")

							setElementPosition(playerSource,ix,iy,iz)
							setElementInterior(playerSource,interiorid)
							setElementPosition(theInteriorElement,ix,iy,iz-1.45)
							setElementInterior(theInteriorElement,interiorid)
							setElementData(theInteriorElement,"x",ix-1.45)
							setElementData(theInteriorElement,"y",iy)
							setElementData(theInteriorElement,"z",iz)
							dbExec(func.dbConnect:getDBConnection(), "UPDATE interiors SET interiorx = ?, interiory = ?, interiorz = ?, interior = ?, interiorID = ? WHERE id = ?",ix,iy,iz,interiorid,reID,dbid)
							
							sendMessageToAdmins(playerSource, "megváltoztatt a(z) #db3535"..getElementData(theInteriorElement,"name").." #557ec9nevű ingatlan belsejét. #db3535("..getElementData(theInteriorElement,"dbid")..")")
							setElementData(playerSource, "log:admincmd", {"Int "..interiorid, cmd})

							if mappedInteriorObjectCache[dbid] then
								if #mappedInteriorObjectCache[dbid] > 0 then
									for k, v in ipairs(mappedInteriorObjectCache[dbid]) do 
										destroyElement(v)
									end
								end
							end
						
							if customInteriorObjects[reID] then 
								mappedInteriorObjectCache[dbid] = {}
	
								for k, v in ipairs(customInteriorObjects[reID]) do 
									local object = createObject(v[1], v[2], v[3], v[4], v[5], v[6], v[7])
									setObjectScale(object, v[8] or 1)
									setElementDimension(object, dbid)
									setElementInterior(object,  interiorid)
									setElementDoubleSided(object, v[9] or true)
						
									table.insert(mappedInteriorObjectCache[dbid], object)

									if reID == 138 then
										if v[1] == 1715 then 
											setElementData(object, "job:hacker:isHackerChair", true)
										end
									end
								end
							end
						end
					else
						outputChatBox(core:getServerPrefix("red-dark", "Interior", 3).." Ennek az interiornak a belsejét, nem módosíthatod.",playerSource,61,122,188,true)
					end
				end
			else
				outputChatBox(core:getServerPrefix("red-dark", "Interior", 3).." Nem állsz interior marker-ben.",playerSource,61,122,188,true)
			end
		else
			outputChatBox(core:getServerPrefix("server", "Használat", 3).."/ "..cmd.." [ID]",playerSource,61,122,188,true)
		end
	end
end
addCommandHandler("setinteriorid",func.setInteriorId)


func.setInteriorExit = function(playerSource,cmd,id)
	if getElementData(playerSource,"user:admin") >= 7 then
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(playerSource) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		id = tonumber(id)
		if type(id) == "number" then
			local count = 0;
			for v,k in pairs(markerCache) do
				if getElementData(v,"isIntOutMarker") then
					if getElementData(v,"dbid") == id then
						if getElementData(v,"custom") == 0 then
							count = count+1
							local newX,newY,newZ = getElementPosition(playerSource)
							local newInt = getElementInterior(playerSource)
							setElementPosition(v,newX,newY,newZ-1)
							setElementInterior(v,newInt)
							setElementData(v,"x",newX)
							setElementData(v,"y",newY)
							setElementData(v,"z",newZ-1.45)
							dbExec(func.dbConnect:getDBConnection(), "UPDATE interiors SET interiorx = ?, interiory = ?, interiorz = ?, interior = ? WHERE id = ?",newX,newY,newZ,newInt,id)
							
							sendMessageToAdmins(playerSource, "megváltoztatt a(z) #db3535"..getElementData(v,"name").." #557ec9nevű ingatlan kilépési pozícióját. #db3535("..getElementData(v,"dbid")..")")
							setElementData(playerSource, "log:admincmd", {"Int "..id, cmd})
						else
							outputChatBox(serverSyntax.." Ennek az interiornak a belépőjét, nem módosíthatod.",playerSource,61,122,188,true)
						end
					end
				end
			end
			if count == 0 then
				outputChatBox(core:getServerPrefix("red-dark", "Interior", 3).." Hibás interior id.",playerSource,61,122,188,true)
			end
		else
			outputChatBox(core:getServerPrefix("server", "Használat", 3).."/ "..cmd.." [id]", playerSource,61,122,188,true)
		end
	end
end
addCommandHandler("setinteriorexit",func.setInteriorExit)

func.setInteriorEntrance = function(playerSource,cmd,id)
	if getElementData(playerSource,"user:admin") >= 7 then
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(playerSource) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		id = tonumber(id)
		if type(id) == "number" then
			local count = 0;
			for v,k in pairs(markerCache) do
				if getElementData(v,"isIntMarker") then
					if getElementData(v,"dbid") == id then
						if getElementData(v,"custom") == 0 then
							count = count+1
							local newX,newY,newZ = getElementPosition(playerSource)
							local newInt = getElementInterior(playerSource)
							setElementPosition(v,newX,newY,newZ-1)
							setElementInterior(v,newInt)
							setElementData(v,"x",newX)
							setElementData(v,"y",newY)
							setElementData(v,"z",newZ-1.45)
							dbExec(func.dbConnect:getDBConnection(), "UPDATE interiors SET x = ?, y = ?, z = ?, interior = ? WHERE id = ?",newX,newY,newZ,newInt,id)
							
							sendMessageToAdmins(playerSource, "megváltoztatt a(z) #db3535"..getElementData(v,"name").." #557ec9nevű ingatlan belépési pozícióját. #db3535("..getElementData(v,"dbid")..")")
							setElementData(playerSource, "log:admincmd", {"Int "..id, cmd})
						else
							outputChatBox(serverSyntax.." Ennek az interiornak a belépőjét, nem módosíthatod.",playerSource,61,122,188,true)
						end
					end
				end
			end
			if count == 0 then
				outputChatBox(core:getServerPrefix("red-dark", "Interior", 3).." Hibás interior id.",playerSource,61,122,188,true)
			end
		else
			outputChatBox(core:getServerPrefix("server", "Használat", 3).."/ "..cmd.." [id]", playerSource,61,122,188,true)
		end
	end
end
addCommandHandler("setinteriorentrance",func.setInteriorEntrance)

function updateInteriorPosition(marker,newX,newY,newZ)
	setElementPosition(marker,newX,newY,newZ)
	setElementData(marker,"x",newX)
	setElementData(marker,"y",newY)
	setElementData(marker,"z",newZ+1.45)
	dbExec(func.dbConnect:getDBConnection(), "UPDATE `interiors` SET `interiorx` = ?, `interiory` = ?, `interiorz` = ? WHERE `id` = ?",newX,newY,newZ+1.45,getElementData(marker,"dbid"))
end

function playSoundServer(sound,x, y, z, int, dim)
	triggerClientEvent(getRootElement(), "playSoundClient", getRootElement(), sound, x, y, z, int, dim)
end
addEvent("playSoundServer", true)
addEventHandler("playSoundServer", getRootElement(), playSoundServer)

-- Interior building
addEvent("editInterior", true)
addEventHandler("editInterior", getRootElement(), function(intMarker)
	if isElement(source) then
		if isElement(intMarker) then
			local characterId = tonumber(getElementData(source, "char:id"))
			if characterId then
				if tonumber(getElementData(intMarker, "owner")) == characterId  then
					exports.oInteriorBuilding:loadInterior(source, getElementData(intMarker, "dbid"), true, getElementData(intMarker, "custom"))
				end
			end
		end
	end
end)
---

function sendToAdmins(message)
	for k,v in ipairs(getElementsByType("player")) do 
		if isPlayerAdmin(v) then 
			outputChatBox(message,v,255,255,255,true)
		end
	end
end

function isPlayerAdmin(player)
	if not player then 
		return false 
	else 
		local adminszint = exports.oAdmin:getPlayerAdminLevel(player)
		if adminszint > 1 then 
			return true
		else 
			return false
		end
	end
end
local weekDays = {"Vasárnap", "Hétfő", "Kedd", "Szerda", "Csütörtök", "Péntek", "Szombat"}
function formatDate(format, escaper, timestamp)
	escaper = escaper or "'"
	escaper = string.sub(escaper, 1, 1)

	local time = getRealTime(timestamp)
	local formattedDate = ""
	local escaped = false

	time.year = time.year + 1900
	time.month = time.month + 1
	
	local datetime = {
		d = string.format("%02d", time.monthday),
		h = string.format("%02d", time.hour),
		i = string.format("%02d", time.minute),
		m = string.format("%02d", time.month),
		s = string.format("%02d", time.second),
		w = string.sub(weekDays[time.weekday + 1], 1, 2),
		W = weekDays[time.weekday + 1],
		y = string.sub(tostring(time.year), -2),
		Y = time.year
	}
	
	for char in string.gmatch(format, ".") do
		if char == escaper then
			escaped = not escaped
		else
			formattedDate = formattedDate .. (not escaped and datetime[char] or char)
		end
	end
	
	return formattedDate
end

function getInteriorMarkerColor(type, owner)
	local interiorR, interiorG, interiorB = r, g, b
	if type <= 0 and owner <= 0 then
		interiorR, interiorG, interiorB = core:hexaToRGB(interior_colors.buyable_inteior)
	elseif type == 1 and owner <= 0 then
		interiorR, interiorG, interiorB = core:hexaToRGB(interior_colors.buyable_inteior)
	elseif type == 1 and owner >= 1 then
		interiorR, interiorG, interiorB = core:hexaToRGB(interior_colors.business)
	elseif type == 2 then
		interiorR, interiorG, interiorB = core:hexaToRGB(interior_colors.gov)
	elseif type == 4 and owner <= 0 then
		interiorR, interiorG, interiorB = core:hexaToRGB(interior_colors.buyable_inteior)
	elseif type == 4 and owner >= 1 then
		interiorR, interiorG, interiorB = core:hexaToRGB(interior_colors.garage)
	elseif type == 5 and owner <= 0 then
		interiorR, interiorG, interiorB = core:hexaToRGB(interior_colors.buyable_inteior)
	elseif type == 5 and owner >= 1 then
		interiorR, interiorG, interiorB = core:hexaToRGB(interior_colors.weed_farm)
	else
		interiorR, interiorG, interiorB = core:hexaToRGB(interior_colors.house)
	end

	return interiorR, interiorG, interiorB
end