addEventHandler("onClientResourceStart", root, function(res)
	if getResourceName(res) == "oCore" or getResourceName(res) == "oAdmin" then  
        core = exports.oCore
        serverName = core:getServerName() or "Szerver"
        color, r, g, b = core:getServerColor()
        serverColor = core:getServerColor()
	end
end)
setElementData(localPlayer, "user:idgAs", false)

addEventHandler("onClientElementDataChange", localPlayer, function(key, old, new)
	if not isElement(source) then return end
	if getElementType(source) == "player" then 
		if key == "user:loggedin" then 
			if new == true then 
				--outputChatBox(getElementData(source, "adminJail.Time"))

                if getElementData(localPlayer,"adminJail.IsAdminJail") then
				    if (getElementData(localPlayer, "adminJail.Time") or 0) > 0 then 
				    	setElementData(localPlayer, "adminJail.IsAdminJail", true)
				    	--triggerClientEvent(resourceRoot, "setPlayerAdminJail.Client", source, getElementData(v,"adminJail.Admin"), getElementData(v,"adminJail.Reason"), getElementData(v,"adminJail.Time"))
				    	--triggerClientEvent(source, "setPlayerAdminJail.Client", source, getElementData(v,"adminJail.Admin"),getElementData(v,"adminJail.Reason"),getElementData(v,"adminJail.Time"))
				    else
				    	setElementData(localPlayer, "adminJail.IsAdminJail", false)
				    	triggerServerEvent("playerRemoveFromAdminJail", localPlayer, localPlayer)
				    end
                end 
                
			end
		end
	end
end)

function putPlayerInPosition(timeslice)
    if not getElementData(localPlayer, "char:fly") then toggleAirBrake() end
    if isChatBoxInputActive() or isConsoleActive() then return end
    
    local cx,cy,cz,ctx,cty,ctz = getCameraMatrix()
    ctx,cty = ctx-cx,cty-cy
    timeslice = timeslice*0.1

    if getKeyState("mouse1") then timeslice = timeslice*10 end
    if getKeyState("lshift") then timeslice = timeslice*4 end
    if getKeyState("lalt") then timeslice = timeslice*0.25 end
    local mult = timeslice/math.sqrt(ctx*ctx+cty*cty)
    ctx,cty = ctx*mult,cty*mult
    if getKeyState("w") then
        abx,aby = abx+ctx,aby+cty
        local a = rotFromCam(0)
        setElementRotation(element,0,0,a)
    end
    if getKeyState("s") then
        abx,aby = abx-ctx,aby-cty
        local a = rotFromCam(180)
        setElementRotation(element,0,0,a)
    end
    if getKeyState("d") then
        abx,aby = abx+cty,aby-ctx
        local a = rotFromCam(90)
        setElementRotation(element,0,0,a)
    end
    if getKeyState("a") then
        abx,aby = abx-cty,aby+ctx
        local a = rotFromCam(-90)
        setElementRotation(element,0,0,a)
    end
    if getKeyState("space") then
        abz = abz+timeslice
    end
    if getKeyState("lctrl") then
        abz = abz-timeslice
    end

    tempPos = abx, aby, abz
    setElementPosition(element,abx,aby,abz)
end

function toggleAirBrake()
    air_brake = not air_brake or nil
    if air_brake then
        abx,aby,abz = getElementPosition(element)
        setElementFrozen(element, true)
        setElementCollisionsEnabled(element,false)
        addEventHandler("onClientPreRender",root,putPlayerInPosition)
    else
        abx,aby,abz = nil
        setElementFrozen(element, false)
        setElementCollisionsEnabled(element,true)
        removeEventHandler("onClientPreRender",root,putPlayerInPosition)
        element = nil
    end
end

function rotFromCam(rzOffset)
    local cx,cy,_,fx,fy = getCameraMatrix(localPlayer)
    local deltaY,deltaX = fy-cy,fx-cx
    local rotZ = math.deg(math.atan((deltaY)/(deltaX)))
    if deltaY >= 0 and deltaX <= 0 then
        rotZ = rotZ+180
    elseif deltaY <= 0 and deltaX <= 0 then
        rotZ = rotZ+180
    end
    return -rotZ+90 + rzOffset
end

addEventHandler("onClientVehicleExit", getRootElement(), function()
    if source == element then
        toggleAirBrake()
    end
end)

addCommandHandler("fly", function()
    if hasPermission(localPlayer,'fly') then
        local veh = getPedOccupiedVehicle(localPlayer)
        element = veh and veh or localPlayer
        setElementData(localPlayer, "char:fly", not (getElementData(localPlayer, "char:fly") or false))
        toggleAirBrake()
    end
end)

addEvent("sendMessageToAdmins", true)
addEventHandler("sendMessageToAdmins", localPlayer, function(player, msg, level)
    local alevel = getElementData(localPlayer, "user:admin") or 0
    level = level or 2
   -- outputChatBox(getPlayerName(localPlayer) .. " | "..alevel)
    if alevel >= level then
        if not getElementData(localPlayer, "showAlogs") then 
            outputChatBox(adminMessagePrefixColor.."[Adminisztrátor - LOG]: "..nameColor..getAdminNick(player)..adminMessageColor.." "..msg, r, g, b, true)
        end
    end
end)

addCommandHandler("togalogs", function()
	if hasPermission(localPlayer,'togalogs') then 
        setElementData(localPlayer, "showAlogs", not getElementData(localPlayer, "showAlogs"))
        
        if getElementData(localPlayer, "showAlogs") then 
            outputChatBox(core:getServerPrefix("red-dark", "Adminisztrátor - LOG", 3).."Admin log kikapcsolva.", 255, 255, 255, true)
        else
            outputChatBox(core:getServerPrefix("green-dark", "Adminisztrátor - LOG", 3).."Admin log bekapcsolva.", 255, 255, 255, true)
        end
	end
end)

-- / gotopoint / --
local points = {}

addCommandHandler("addpoint", function(cmd, pointName)
    if hasPermission(localPlayer,'addpoint') then 
        if pointName then
            if not points[pointName] then 
                points[pointName] = Vector3(getElementPosition(localPlayer))
                outputChatBox(core:getServerPrefix("green-dark", "Point", 3).."Sikeresen létrehoztál egy pontot. "..color.."("..pointName..")", 255, 255, 255, true)
            else
                outputChatBox(core:getServerPrefix("red-dark", "Point", 3).. "Már van ilyen nevű pontod létrehozva! "..color.."("..pointName..")", 255, 255, 255, true)
            end
        else
            outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [Pont neve]", 255, 255, 255, true)
        end
    end
end)

addCommandHandler("delpoint", function(cmd, pointName)
    if hasPermission(localPlayer,'delpoint') then 
        if pointName then
            if points[pointName] then 
                points[pointName] = false
                outputChatBox(core:getServerPrefix("green-dark", "Point", 3).."Sikeresen töröltél egy pontot. "..color.."("..pointName..")", 255, 255, 255, true)
            else
                outputChatBox(core:getServerPrefix("red-dark", "Point", 3).. "Nincs ilyen nevű pontod létrehozva! "..color.."("..pointName..")", 255, 255, 255, true)
            end
        else
            outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [Pont neve]", 255, 255, 255, true)
        end
    end
end)

addCommandHandler("mypoints", function() 
    if hasPermission(localPlayer,'mypoints') then 
        outputChatBox(color.."<=== Saját pontjaid ===>", 255, 255, 255, true)
        for k, v in pairs(points) do 
            if v then 
                outputChatBox(color.."~ #ffffff"..k, 255, 255, 255, true)
            end
        end
    end
end)

addCommandHandler("gotopoint", function(cmd, pointName) 
    if hasPermission(localPlayer,'gotopoint') then
        if pointName then 
            if points[pointName] then 
                local position = points[pointName]
                outputChatBox(core:getServerPrefix("green-dark", "Point", 3).."Sikeresen elteleportáltál a(z) "..color..position.x.."#ffffff, "..color..position.y.."#ffffff, "..color..position.z.."#ffffff pozícióra."..color.." ("..pointName..")", 255, 255, 255, true)

                triggerServerEvent("points -> setPlayerPosition", resourceRoot, {position.x, position.y, position.z})
            else
                outputChatBox(core:getServerPrefix("red-dark", "Point", 3).. "Nincs ilyen pontod létrehozva! "..color.."("..pointName..")", 255, 255, 255, true)
            end
        else
            outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [Pont neve]", 255, 255, 255, true)
        end
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    --[[if fileExists("points.json") then 
        local file = fileOpen("points.json")
        local array = fileRead(file, fileGetSize(file))
        points = fromJSON(array)
    end]]
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
    local file
    if fileExists("points.json") then 
        file = fileOpen("points.json")
    else
        file = fileCreate("points.json")

    end

    fileWrite(file, toJSON(points))
    fileClose(file)
end)

local adminTimeCounter = false
local onlineTimeCounter = false

addEventHandler("onClientElementDataChange", root, function(data, old, new)
    if source == localPlayer then 
        if data == "user:aduty" then 
            if new == true then 
                if isTimer(adminTimeCounter) then 
                    killTimer(adminTimeCounter)
                end
            
                adminTimeCounter = setTimer(function()
                    local dutytime = getElementData(localPlayer, "user:adutyTime") or 0 
            
                    setElementData(localPlayer, "user:adutyTime", dutytime + 1)
                end, core:minToMilisec(1), 0)
            elseif new == false then 
                if isTimer(adminTimeCounter) then 
                    killTimer(adminTimeCounter)
                end
            end
        elseif data == "user:loggedin" then 
            if new then 
                if isTimer(onlineTimeCounter) then 
                    killTimer(onlineTimeCounter)
                end
                
                onlineTimeCounter = setTimer(function()
                    local time = getElementData(localPlayer, "user:adminOnlineTime") or 0 
            
                    setElementData(localPlayer, "user:adminOnlineTime", time + 1)
                end, core:minToMilisec(1), 0)
            end
        elseif data == "aclLogin" then 
            if new == true then
                setDevelopmentMode(true)
            end
        end
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    if getElementData(localPlayer, "user:aduty") then
        if isTimer(adminTimeCounter) then 
            killTimer(adminTimeCounter)
        end
    
        adminTimeCounter = setTimer(function()
            local dutytime = getElementData(localPlayer, "user:adutyTime") or 0 
    
            setElementData(localPlayer, "user:adutyTime", dutytime + 1)
        end, core:minToMilisec(1), 0) 
    end

    if getElementData(localPlayer, "user:admin") > 1 then 
        if isTimer(onlineTimeCounter) then 
            killTimer(onlineTimeCounter)
        end

        onlineTimeCounter = setTimer(function()
            local time = getElementData(localPlayer, "user:adminOnlineTime") or 0 
    
            setElementData(localPlayer, "user:adminOnlineTime", time + 1)
        end, core:minToMilisec(1), 0)
    end
end)

local dataNames = {
    {"Ban", "db"}, 
    {"Kick", "db"}, 
    {"Jail", "db"}, 
    {"Unban", "db"}, 
    {"Unjail", "db"}, 
    {"Kimenő PM", "db"}, 
    {"Bejövő PM", "db"}, 
    {"Fixveh", "db"}, 
    {"Admin duty idő", "perc"},
    {"Online idő", "perc"},
}

addCommandHandler("showmydatas", function()
    if hasPermission(localPlayer,'showmydatas') then 
        outputChatBox(" ")
        outputChatBox("<== Adminisztrátor statisztikáid: ===>", r, g, b, true)
        outputChatBox(core:getServerPrefix("red-dark", "Adminduty Idő", 3)..color..(getElementData(localPlayer, "user:adutyTime") or 0).." #ffffffperc.", 255, 255, 255, true)
        outputChatBox(core:getServerPrefix("red-dark", "Online idő", 3)..color..(getElementData(localPlayer, "user:adminOnlineTime") or 0).." #ffffffperc.", 255, 255, 255, true)

        local datas = getElementData(localPlayer, "user:adminDatas") 

        for k, v in ipairs(datas) do 
            outputChatBox(core:getServerPrefix("red-dark", dataNames[k][1], 3)..color..v.." #ffffff"..dataNames[k][2]..".", 255, 255, 255, true)
        end
    end
end)

addEvent("admin:playPMSound", true)
addEventHandler("admin:playPMSound", root, function()
    playSound("files/pm.mp3")
end)

addCommandHandler("getpos",function()
    if getElementData(localPlayer, "user:admin") > 1 then
        local x, y, z = getElementPosition(localPlayer)
        local pos = x..","..y..","..z
        setClipboard(pos)
    end
end)

addEventHandler("onClientPedDamage", getRootElement(), function()
    if getElementData(source, "invulnerable") then 
        cancelEvent()
    end
end)


local active = false
local fileName
local fileHandle

addCommandHandler("crash", function()
	active = not active
	if active then
		fileName = "crashlogs/"..tostring(getRealTime().timestamp)..".txt"
		fileHandle = fileCreate(fileName)
		local date = getStringTime()
		local status = dxGetStatus()
		writeToFile("["..date.."] - - - - - - - - - - - - - - - - - - - - - - - - - -")
		writeToFile("["..date.."] - CRASH FIGYELŐ ELINDÍTVA")
		writeToFile("["..date.."] - VIDEÓKÁRTYA: "..status["VideoCardName"].." ("..status["VideoCardRAM"].." VRAM)")
		writeToFile("["..date.."] - ((FREE FOR MTA: "..status["VideoMemoryFreeForMTA"].."MB/"..status["VideoCardRAM"].."MB))")
		writeToFile("["..date.."] - ((USAGE: "..status["VideoCardRAM"]-status["VideoMemoryFreeForMTA"].."MB/"..status["VideoCardRAM"].."MB))")
		writeToFile("["..date.."] - BEÁLLÍTÁSOK:")
		writeToFile("["..date.."] -         - ABLAKOS MÓD: "..(status["SettingWindowed"] and "Igen" or "Nem"))
		writeToFile("["..date.."] -         - ÁRNYÉKOK: "..(status["SettingVolumetricShadows"] and "Igen" or "Nem"))
		writeToFile("["..date.."] -         - FŰ EFFEKT: "..(status["SettingGrassEffect"] and "Igen" or "Nem"))
		writeToFile("["..date.."] -         - HŐSÉG EFFEKT: "..(status["SettingHeatHaze"] and "Igen" or "Nem"))
		writeToFile("["..date.."] -         - 32 BITES SZÍNEK: "..(status["Setting32BitColor"] and "Igen" or "Nem"))
		writeToFile("["..date.."] -         - FX MINŐSÉG: "..status["SettingFXQuality"])
		writeToFile("["..date.."] -         - LÁTÓHATÁR: "..status["SettingDrawDistance"])
		writeToFile("["..date.."] -         - STREAM MEMORY: "..status["SettingStreamingVideoMemoryForGTA"])
		writeToFile("["..date.."] -         - FIELD OF VIEW: "..status["SettingFOV"])
		writeToFile("["..date.."] - - - - - - - - - - - - - - - - - - - - - - - - - -")
		outputChatBox("Crash-figyelő bekapcsolva! (oAdmin/"..fileName..")", 0, 255, 0, true)
		addEventHandler("onClientElementStreamIn", root, streamDetect)
	else
		outputChatBox("Crash-figyelő kikapcsolva! (oAdmin/"..fileName..")", 255, 0, 0, true)
		removeEventHandler("onClientElementStreamIn", root, streamDetect)
		fileFlush(fileHandle)
		fileClose(fileHandle)
		fileName = nil
	end
end)

function writeToFile(adat)
	fileWrite(fileHandle, adat .. "\n")
	fileFlush(fileHandle)
end

function streamDetect()
	if getElementType(source) == "player" then
		writeToFile("["..getStringTime().."] - PLAYER - SKIN: "..getElementModel(source).."")
	elseif getElementType(source) == "ped" then
		local x,y,z = getElementPosition(source)
		writeToFile("["..getStringTime().."] - PED - SKIN: "..getElementModel(source).." - XYZ: {"..x..", "..y..", "..z.."}")
	elseif getElementType(source) == "vehicle" then
		local model = getElementModel(source)
		local dbid = tonumber(getElementData(source, "dbid")) or 0
		writeToFile("["..getStringTime().."] - VEHICLE - MODEL: "..model.." ("..getVehicleNameFromModel(model).." - #"..dbid..")")
	elseif getElementType(source) == "object" then
		local x,y,z = getElementPosition(source)
		writeToFile("["..getStringTime().."] - OBJECT - MODEL: "..getElementModel(source).." - XYZ: {"..x..", "..y..", "..z.."}")
	end
end

function getStringTime(timestamp)
	if not timestamp then
		timestamp = getRealTime().timestamp
	end
	local date = getRealTime(timestamp)
	date.year = 1900+date.year
	date.month = 1+date.month
	if date.month < 10 then
		date.month = "0"..date.month
	end
	if date.minute < 10 then
		date.minute = "0"..date.minute 
	end
	if date.hour < 10 then
		date.hour = "0"..date.hour  
	end
	if date.monthday < 10 then
		date.monthday = "0"..date.monthday  
	end
	if date.second < 10 then
		date.second = "0"..date.second  
	end
	return date.year.."."..date.month.."."..date.monthday..". "..date.hour..":"..date.minute..":"..date.second
end