local updateDelay = 1000
local showDistance = 40

local positions = {}


setTimer(function() 
    if getElementData(localPlayer, "user:loggedin") then 
        if getElementDimension(localPlayer) == 0 then 
            if #positions == 0 then 
                table.insert(positions, 1, {10, Vector3(getElementPosition(localPlayer))})
            else

                local nowpos = Vector3(getElementPosition(localPlayer))
                local oldpos = positions[#positions][2]

                if not (oldpos.x == nowpos.x) and not (oldpos.y == nowpos.y) then 
                    table.insert(positions, 1, {10, Vector3(getElementPosition(localPlayer))})
                end
            end
        end
    end
end, updateDelay, 0)

function showMyLines() 
    for k, v in pairs(positions) do
        if positions[k+1] then 
            local startPos = v[2]
            local endPos = positions[k+1][2]

            local playerPos = Vector3(getElementPosition(localPlayer))

            if getDistanceBetweenPoints3D(endPos.x, endPos.y, endPos.z, playerPos.x, playerPos.y, playerPos.z) <= showDistance then 
                dxDrawLine3D(startPos.x, startPos.y, startPos.z, endPos.x, endPos.y, endPos.z, tocolor(0, 0, 255), 5)
            end
        end
    end
end

local linesState = false 

addCommandHandler("showlines", function()
    if linesState then 
        removeEventHandler("onClientRender", root, showMyLines)
    else 
        addEventHandler("onClientRender", root, showMyLines)
    end

    linesState = not linesState
end)

-- afk --
--

afk = false
lastClickTick = -5000

function startAfkTimer()
    stopAfkTimer()
    if afk then
        setElementData(localPlayer, "char:afk", true)

        seconds = 0
        setElementData(localPlayer, "afk:seconds", "00")
        minutes = 0
        setElementData(localPlayer, "afk:minutes", "00")
        hours = 0
        setElementData(localPlayer, "afk:hours", "00")
        afkTimer = setTimer(
            function()
                seconds = seconds + 1
                setElementData(localPlayer, "afk:seconds", formatString(seconds))
                if seconds >= 60 then
                    seconds = 0 
                    setElementData(localPlayer, "afk:seconds", formatString(seconds))
                    minutes = minutes + 1
                    setElementData(localPlayer, "afk:minutes", formatString(minutes))

                    if minutes >= 60 then
                        minutes = 0
                        setElementData(localPlayer, "afk:minutes", formatString(minutes))
                        hours = hours + 1
                        setElementData(localPlayer, "afk:hours", formatString(hours))
                    end
                end
            end, 1000, 0
        )
    end
end

function stopAfkTimer()
    if isTimer(afkTimer) then
        killTimer(afkTimer)
        seconds, minutes, hours = 0,0,0
        setElementData(localPlayer, "afk:seconds", 0)
        setElementData(localPlayer, "afk:minutes", 0)
        setElementData(localPlayer, "afk:hours", 0)
    end
end

local lastClickTick = getTickCount()

addEventHandler("onClientKey", root, 
    function()
        lastClickTick = getTickCount()
        if afk then
            --outputChatBox("asd")
            stopAfkTimer()
            setElementData(localPlayer, "char:afk", false)
            afk = false
        end
    end
)

setTimer( 
    function()
	    local nowTick = getTickCount()
        if nowTick - lastClickTick >= 30000 then -- def: 30000
            if not afk then
                afk = true
                startAfkTimer()
                setElementData(localPlayer, "char:afk", true)
            end
        end
    end, 300, 0
)
	
addEventHandler("onClientRestore", root, 
    function()
        lastClickTick = getTickCount()
        if afk then
            setElementData(localPlayer, "char:afk", false)
            stopAfkTimer()
            afk = false
        end
    end
)

addEventHandler("onClientMinimize", root, 
    function()
        if not afk then
            afk = true
            startAfkTimer()
            setElementData(localPlayer, "char:afk", true)
        end
    end
)
	
addEventHandler("onClientCursorMove", root, 
    function()
	    lastClickTick = getTickCount()
        if afk then
            setElementData(localPlayer, "char:afk", false)
            stopAfkTimer()
            afk = false
        end
    end
)

local seconds,minutes,hours = 0, 0, 0

function formatString(s)
    if s < 10 then
        return "0" .. tostring(s)
    end
    return tostring(s)
end

if getElementData(localPlayer, "char:afk") then
    afk = true
    startAfkTimer()
end

addEventHandler("onClientElementDataChange", localPlayer, function(key, old, new)

    if key == "user:admin" then
        if (new or 0) > 1 then 
            triggerServerEvent("anticheat > checkAdminVerifiedStatus", resourceRoot)
        end
    end

	if old then
		if key == "char:money" or key == "char:pp" or key == "char:cc" then
			local sourceAdminLevel = getElementData(localPlayer, "user:admin") or 0

			if sourceAdminLevel <= 8 then
				if key ==  "char:money" then 
					local valtozas = new - old 
					if math.abs(valtozas) >= 100000 then 
						triggerServerEvent("sendMessageToAdmins", localPlayer, core:getServerPrefix("red-dark", "Anticheat", 3)..red.."Magas készpénz változás érzékelve!")
						triggerServerEvent("sendMessageToAdmins", localPlayer, red.." ~ Játékos: "..color..getElementData(localPlayer, "char:name").." (ID: "..getElementData(localPlayer, "playerid")..")")
						triggerServerEvent("sendMessageToAdmins", localPlayer, red.." ~ Készpénz: "..color..new.."$"..red.." | Változás: "..color..valtozas.."$")
					end

					if new >= 2500000 then 
						triggerServerEvent("sendMessageToAdmins", localPlayer, core:getServerPrefix("red-dark", "Anticheat", 3)..red.."Magas készpénz érzékelve!")
						triggerServerEvent("sendMessageToAdmins", localPlayer, red.." ~ Játékos: "..color..getElementData(localPlayer, "char:name").." (ID: "..getElementData(localPlayer, "playerid")..")")
						triggerServerEvent("sendMessageToAdmins", localPlayer, red.." ~ Készpénz: "..color..new.."$")
					end

				elseif key == "char:pp" then 

					local valtozas = new - old 
					if math.abs(valtozas) >= 25000 then 
						triggerServerEvent("sendMessageToAdmins", localPlayer, core:getServerPrefix("red-dark", "Anticheat", 3)..red.."Magas prémium változás érzékelve!")
						triggerServerEvent("sendMessageToAdmins", localPlayer, red.." ~ Játékos: "..color..getElementData(localPlayer, "char:name").." (ID: "..getElementData(localPlayer, "playerid")..")")
						triggerServerEvent("sendMessageToAdmins", localPlayer, red.." ~ Prémium egyenleg: "..color..new.."PP"..red.." | Változás: "..color..valtozas.."PP")
					end

					if new >= 50000 then 
						triggerServerEvent("sendMessageToAdmins", localPlayer, core:getServerPrefix("red-dark", "Anticheat", 3)..red.."Magas prémium egyenleg érzékelve!")
						triggerServerEvent("sendMessageToAdmins", localPlayer, red.." ~ Játékos: "..color..getElementData(localPlayer, "char:name").." (ID: "..getElementData(localPlayer, "playerid")..")")
						triggerServerEvent("sendMessageToAdmins", localPlayer, red.." ~ Prémium egyenleg: "..color..new.."PP")
					end

				elseif key == "char:cc" then 

					local valtozas = new - old 
					if math.abs(valtozas) >= 50000 then 
						triggerServerEvent("sendMessageToAdmins", localPlayer, core:getServerPrefix("red-dark", "Anticheat", 3)..red.."Magas CasinoCoin változás érzékelve!")
						triggerServerEvent("sendMessageToAdmins", localPlayer, red.." ~ Játékos: "..color..getElementData(localPlayer, "char:name").." (ID: "..getElementData(localPlayer, "playerid")..")")
						triggerServerEvent("sendMessageToAdmins", localPlayer, red.." ~ Casino egyenleg: "..color..new.."cc"..red.." | Változás: "..color..valtozas.."cc")
					end

					if new >= 100000 then 
						triggerServerEvent("sendMessageToAdmins", localPlayer, core:getServerPrefix("red-dark", "Anticheat", 3)..red.."Magas Casino egyenleg érzékelve!")
						triggerServerEvent("sendMessageToAdmins", localPlayer, red.." ~ Játékos: "..color..getElementData(localPlayer, "char:name").." (ID: "..getElementData(localPlayer, "playerid")..")")
						triggerServerEvent("sendMessageToAdmins", localPlayer, red.." ~ Casino egyenleg: "..color..new.."cc")
					end
				end
			end
		end
	end
end)