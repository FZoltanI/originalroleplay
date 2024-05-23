local sx, sy = guiGetScreenSize()
local playerBlips = {}
local showPlayers
local checkTimer

addCommandHandler("getobj", function(cmd, elore)
	if not elore then
		elore = false
	else
		elore = true
	end
	if exports['oAdmin']:isPlayerDeveloper(localPlayer) then
		local x,y,z = getElementPosition(localPlayer)
		local marker
		local targetX, targetY, targetZ = x,y,z-10
		if elore then
			marker = createMarker(x, y, z, "cylinder", 2, 255, 0, 0, 255)
			attachElements(marker, localPlayer, 0, 10, 0)
		end
		
		outputChatBox("Lekérdezés ...")
		setTimer(function()
			if elore then
				targetX, targetY, targetZ = getElementPosition(marker)
			end
			local hit,x,y,z,elementHit,nx,ny,nz,material,lighting,piece,buildingId,wX,wY,wZ,rX,rY,rZ,lodID = processLineOfSight(x,y,z,targetX, targetY, targetZ,true,true,true,true,true,true,false,true,localPlayer,true)
			if hit then
				if buildingId then
					outputChatBox(buildingId.." -> "..engineGetModelNameFromID(buildingId))
					
					if elementHit then
						outputChatBox("Radius: "..getElementRadius(elementHit))
						outputChatBox("LOD: "..tonumber(lodID or 0))
						local wX, wY, wZ = getElementPosition(elementHit)
						local rX, rY, rZ = getElementRotation(elementHit)
						outputChatBox("Position: "..wX..", "..wY..", "..wZ)
						outputChatBox("Rotation: "..rX..", "..rY..", "..rZ)
					else
						local tempObj = createObject(buildingId, wX, wY, wZ, rX, rY, rZ)
						outputChatBox("Radius: "..getElementRadius(tempObj))
						outputChatBox("LOD: "..tonumber(lodID or 0))
						outputChatBox("Position: "..wX..", "..wY..", "..wZ)
						outputChatBox("Rotation: "..rX..", "..rY..", "..rZ)
						destroyElement(tempObj)
					end
					
					if isElement(marker) then
						destroyElement(marker)
					end
				end
			else
				outputChatBox("Hiba")

                if isElement(marker) then
                    destroyElement(marker)
                end
			end
		end, 1000, 1)
	end
end)

addCommandHandler("gethandling", 
    function()
        if exports['oAdmin']:isPlayerDeveloper(localPlayer) then
            local veh = getPedOccupiedVehicle(localPlayer)
            if veh then
                local syntax = exports['oCore']:getServerPrefix("green-dark", "dev", 2)    
                local str = ""
                local handling = getVehicleHandling(veh)
                for k, v in pairs(handling) do
                    if type(v) == "table" then
                        v = table.tostring(v)
                        str = str .. "setVehicleHandling(veh, \""..k.."\", "..v..")\n"
                    else
                        if k == "handlingFlags" or k == "modelFlags" then
                            str = str .. "setVehicleHandling(veh, \""..k.."\", 0x"..v..")\n"
                        elseif type(v) == "boolean" then
                            str = str .. "setVehicleHandling(veh, \""..k.."\", "..tostring(v)..")\n"
                        else
                            str = str .. "setVehicleHandling(veh, \""..k.."\", "..(type(v) == "number" and v or "\""..v.."\"")..")\n"
                        end
                    end
                end
                setClipboard(str)
                outputChatBox(syntax .. "Vágólapra másolva", 255,255,255,true)
            else
                local syntax = exports['oCore']:getServerPrefix("red-dark", "dev", 2)    
                outputChatBox(syntax .. "Nem ülsz járműben", 255,255,255,true)
            end
        end
    end
)

addCommandHandler("getcampos", 
    function()
        if exports['oAdmin']:isPlayerDeveloper(localPlayer) then
            local x,y,z,x1,y1,z1,rot,fov = getCameraMatrix()

            outputChatBox(x .. ", " .. y .. ", " .. z .. ", " .. x1 .. ", " .. y1 .. ", " .. z1 .. ", " .. rot .. ", " .. fov)
            setClipboard(x .. ", " .. y .. ", " .. z .. ", " .. x1 .. ", " .. y1 .. ", " .. z1 .. ", " .. rot .. ", " .. fov)
        end 
    end 
)

local dummystate = false
addCommandHandler("showdummy", 
    function()
        if exports['oAdmin']:isPlayerDeveloper(localPlayer) then
            dummystate = not dummystate
            if dummystate then
                local syntax =exports['oCore']:getServerPrefix("green-dark", "dev", 2)        
                outputChatBox(syntax .. "Dummy listázás bekapcsolva!", 0, 255, 0, true)
                addEventHandler("onClientRender", root, showVehicleDummy, true, "low-5")
            else
                local syntax = exports['oCore']:getServerPrefix("red-dark", "dev", 2)    
                outputChatBox(syntax .. "Dummy listázás kikapcsolva!", 255, 0, 0, true)
                removeEventHandler("onClientRender", root, showVehicleDummy)
            end
        end
    end
)

function showVehicleDummy()
	local x,y,z = getElementPosition(localPlayer)
	for k, veh in ipairs(getElementsByType("vehicle", root, true)) do
		if isElementOnScreen(veh) then
			local xx,yy,yz = getElementPosition(veh)
			if getDistanceBetweenPoints3D(x,y,z,xx,yy,yz) < 10 then
				for v in pairs(getVehicleComponents(veh)) do
					local x,y,z = getVehicleComponentPosition(veh, v, "world")
					local wx,wy,wz = getScreenFromWorldPosition(x, y, z)
					if wx and wy then
						dxDrawText(v, wx -1, wy -1, wx -1, wy -1, tocolor(0,0,0), 1, "default-bold", "center", "center")
						dxDrawText(v, wx +1, wy -1, wx +1, wy -1, tocolor(0,0,0), 1, "default-bold", "center", "center")
						dxDrawText(v, wx -1, wy +1, wx -1, wy +1, tocolor(0,0,0), 1, "default-bold", "center", "center")
						dxDrawText(v, wx +1, wy +1, wx +1, wy +1, tocolor(0,0,0), 1, "default-bold", "center", "center")
						dxDrawText(v, wx, wy, wx, wy, tocolor(0,255,255), 1, "default-bold", "center", "center")
					end
				end
			end
		end
	end
end

addCommandHandler("devmode", 
    function()
        if exports['oAdmin']:isPlayerDeveloper(localPlayer) then
            local mode = getDevelopmentMode()
            if not mode then
                local syntax =exports['oCore']:getServerPrefix("green-dark", "dev", 2)        
                outputChatBox(syntax .. "Fejlesztői mód bekapcsolva!", 0, 255, 0, true)
            else
                local syntax =exports['oCore']:getServerPrefix("red-dark", "dev", 2)        
                outputChatBox(syntax .. "Fejlesztői mód kikapcsolva!", 255, 0, 0, true)
            end
            setDevelopmentMode(not mode)
        end
    end
)

addCommandHandler("aircars", 
    function(cmd)
        if exports['oAdmin']:isPlayerDeveloper(localPlayer) then
            local mode = isWorldSpecialPropertyEnabled(cmd)
            if not mode then
                local syntax =exports['oCore']:getServerPrefix("green-dark", "dev", 2)        
                outputChatBox(syntax .. "Aircars mód bekapcsolva!", 0, 255, 0, true)
            else
                local syntax =exports['oCore']:getServerPrefix("red-dark", "dev", 2)        
                outputChatBox(syntax .. "Aircars mód kikapcsolva!", 255, 0, 0, true)
            end
            setWorldSpecialPropertyEnabled(cmd, not mode)
        end
    end
)

function displayMyTask ()
    local x,y = 50,400
    for k=0,4 do
        local a,b,c,d = getPedTask ( getLocalPlayer(), "primary", k )
        dxDrawText ( "Primary task #"..k.." is "..tostring(a).." -> "..tostring(b).." -> "..tostring(c).." -> "..tostring(d).." -> ", x, y )
        y = y + 15
    end
    y = y + 15
    for k=0,5 do
        local a,b,c,d = getPedTask ( getLocalPlayer(), "secondary", k )
        dxDrawText ( "Secondary task #"..k.." is "..tostring(a).." -> "..tostring(b).." -> "..tostring(c).." -> "..tostring(d).." -> ", x, y )    
        y = y + 15
    end
end

local taskList = nil
addCommandHandler("showtask", 
    function()
        if exports['oAdmin']:isPlayerDeveloper(localPlayer) then
            taskList = not taskList
            if taskList then
                local syntax =exports['oCore']:getServerPrefix("green-dark", "dev", 2)        
                addEventHandler("onClientRender", root, displayMyTask, true, "low")
                outputChatBox(syntax .. "TaskList bekapcsolva!", 0, 255, 0, true)
            else
                local syntax =exports['oCore']:getServerPrefix("red-dark", "dev", 2)        
                removeEventHandler("onClientRender", root, displayMyTask)
                outputChatBox(syntax .. "TaskList kikapcsolva!", 255, 0, 0, true)
            end
        end
    end
)

local testValues = {
	["none"] = "Kikapcsolva",
	["no_mem"] = "Nincs memória",
	["low_mem"] = "Kevés memória",
	["no_shader"] = "Nincs shader",
}
addCommandHandler("setmode", 
    function(cmd, value)
        if exports['oAdmin']:isPlayerDeveloper(localPlayer) then
            if testValues[value] then
                local syntax =exports['oCore']:getServerPrefix("green-dark", "dev", 2)        
                dxSetTestMode(value)
                outputChatBox(syntax .. "DX Memória teszt mód: " .. value, 220, 175, 20, true)
            else
                local syntax =exports['oCore']:getServerPrefix("red-dark", "dev", 2)        
                outputChatBox(syntax .. "DX Memória teszt módok:", 245, 20, 20, true)
                for k, v in pairs(testValues) do
                    outputChatBox(syntax .. ""..k.." > "..v, 245, 20, 20, true)
                end
            end
        end
    end
)