local connection = exports.oMysql

addEventHandler("onResourceStart",resourceRoot,function()
	local loadCount = 0
	dbQuery(function(qh)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for k, row in pairs(res) do
				loadOneElevatorWhereID(row["id"])
				loadCount = loadCount+1
			end
		end
	end,connection:getDBConnection(),"SELECT * FROM elevators")
end)

function loadOneElevatorWhereID(id)
	dbQuery(function(qh)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for k, row in pairs(res) do
				markerElement = createMarker( row["x"], row["y"], row["z"]-1.2, "cylinder", 0.8, 0, 128, 128, 150)
				intmarkerElement = createMarker( row["tpx"], row["tpy"], row["tpz"]-1.2, "cylinder", 0.8, 0, 128, 128, 150)
				setElementAlpha(markerElement, 0)
				setElementAlpha(intmarkerElement, 0)
				setElementDimension(markerElement,row["dimensionwithin"])
				setElementInterior(markerElement,row["interiorwithin"])
				setElementDimension(intmarkerElement,row["dimension"])
				setElementInterior(intmarkerElement,row["interior"])
				setElementData(markerElement,"isElevator",true)
				setElementData(intmarkerElement,"isElevator",true)
				setElementData(markerElement,"isElevatorIn",true)
				setElementData(intmarkerElement,"isElevatorOut",true)
				setElementData(markerElement,"other",intmarkerElement)
				setElementData(intmarkerElement,"other",markerElement)
				setElementData(markerElement,"dbid",row["id"])
				setElementData(intmarkerElement,"dbid",row["id"])
				setElementData(markerElement,"x",row["x"])
				setElementData(intmarkerElement,"x",row["tpx"])
				setElementData(markerElement,"y",row["y"])
				setElementData(intmarkerElement,"y",row["tpy"])
				setElementData(markerElement,"z",row["z"])
				setElementData(intmarkerElement,"z",row["tpz"])
			end
		end
	end,connection:getDBConnection(),"SELECT * FROM elevators WHERE id=?",id)
end

addCommandHandler("addelevator", function(playerSource,commandName,interior,dimension,tpX,tpY,tpZ)
		if getElementData(playerSource, "user:admin") >= 7 then
			if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(playerSource) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

			if interior and dimension and tpX and tpY and tpZ then
				interior = tonumber(interior)
				dimension = tonumber(dimension)
				tpX = tonumber(tpX)
				tpY = tonumber(tpY)
				tpZ = tonumber(tpZ) - 0.3
				local x,y,z = getElementPosition(playerSource)
				z = z - 0.3
				local marker_int = getElementInterior(playerSource)
				local marker_dim = getElementDimension(playerSource)
				dbQuery(function(qh)
					local query, query_lines,id = dbPoll(qh, 150)
					local id = tonumber(id)
					if id > 0 then
						sendMessageToAdmins(playerSource, "létrehozott egy liftet. #db3535("..id..")")
						setElementData(playerSource, "log:admincmd", {"Elevator "..id, cmd})
						loadOneElevatorWhereID(id)
					end
				end,connection:getDBConnection(),"INSERT INTO elevators SET x = ?, y = ?, z = ?, tpx = ?, tpy = ?, tpz = ?, dimensionwithin = ?, interiorwithin = ?, interior = ?, dimension = ?",x, y, z, tpX, tpY, tpZ, marker_dim, marker_int, interior, dimension)
				
			else
				outputChatBox(core:getServerPrefix("server", "Használat", 3).."/ ".. commandName .. " [Interior ID] [Dimension ID] [X] [Y] [Z]", playerSource, 255, 255, 255, true)
			end
		end
	end
)


addCommandHandler("delelevator",function (playerSource, cmd, id)
	if getElementData(playerSource, "user:admin") >= 7 then
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(playerSource) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		if id then
			if (tostring(type(tonumber(id))) == "number") then
				for k, v in pairs(getElementsByType("marker")) do
					if getElementData(v,"isElevator") == true then
						if getElementData(v,"dbid") == tonumber(id) then
							dbQuery(function(qh)
								local res, rows, err = dbPoll(qh, 0)
								if rows > 0 then
									sendMessageToAdmins(playerSource, "törölt egy liftet. #db3535("..tonumber(getElementData(v,"dbid"))..")")
									setElementData(playerSource, "log:admincmd", {"Elevator "..id, cmd})
								
									local other = getElementData(v,"other")
									destroyElement(other)
									destroyElement(v)
								end
							end, connection:getDBConnection(),"DELETE FROM elevators WHERE id = ?",tonumber(id))
						end
					end
				end
			else
				outputChatBox(core:getServerPrefix("red-dark", "Elevator", 3).."Csak számot.", playerSource, 255, 255, 255, true)
			end
		else
			outputChatBox(core:getServerPrefix("server", "Használat", 3).."/ ".. cmd .." [ID]", playerSource, 255, 255, 255, true)
		end
	end
end)

local timers = {}

function changeElevator(playerSource, x, y, z, int, dim)
    local playerSource = playerSource
	setElementPosition(playerSource, x, y, z + 0.5)
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
end
addEvent("changeElevator", true)
addEventHandler("changeElevator", getRootElement(), changeElevator)