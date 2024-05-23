local sx,sy = guiGetScreenSize()
local resStat = false
local clientRows = {}, {}
local serverRows = {}, {}

local MED_CLIENT_CPU = 2 -- 5%
local MAX_CLIENT_CPU = 5 -- 5%

local MED_SERVER_CPU = 0.5 -- 5%
local MAX_SERVER_CPU = 1 -- 5%

local _, r, g, b = exports.oCore:getServerColor()
local font = exports.oFont:getFont("roboto", 9)

addCommandHandler("stat", function()
	if isPlayerDeveloper(localPlayer) then
		resStat = not resStat
		if resStat then
			_, clientRows = getPerformanceStats("Lua timing")
			outputChatBox("[Admin]: #FFFFFFCPU figyelő bekapcsolva!", r, g, b, true)
			addEventHandler("onClientRender", root, resStatRender)
			triggerServerEvent("getServerStat", localPlayer)
		else
			outputChatBox("[Admin]: #FFFFFFCPU figyelő kikapcsolva!", r, g, b, true)
			removeEventHandler("onClientRender", root, resStatRender)
			serverRows = {}, {}
			clientRows = {}, {}
			triggerServerEvent("destroyServerStat", localPlayer)
		end
	end
end)

function toFloor(num)
	return tonumber(string.sub(tostring(num), 0, -2)) or 0
end

local avgC, avgCM, avgS, avgSM = 0,0, 0,0

function toFloor(num)
	return tonumber(string.sub(tostring(num), 0, -2)) or 0
end

addEvent("receiveServerStat", true)
addEventHandler("receiveServerStat", root, 
    function(stat1,stat2)
        _, clientRows = getPerformanceStats("Lua timing")
        _, serverRows = stat1,stat2

        table.sort(clientRows, function(a, b)
            return toFloor(a[2]) > toFloor(b[2])
        end)

        table.sort(serverRows, function(a, b)
            return toFloor(a[2]) > toFloor(b[2])
        end)
        
        avgC = 0
        for k,v in pairs(clientRows) do
            avgC = avgC + toFloor(v[2])
        end
        avgCM = math.floor(avgC)
        avgC = math.floor(avgC / #clientRows)
        
        avgS = 0
        for k,v in pairs(serverRows) do
            avgS = avgS + toFloor(v[2])
        end
        avgSM = math.floor(avgS)
        avgS = math.floor(avgS / #serverRows)
    end
)

local disabledResources = {}
function resStatRender()
	local x = sx-300
	if #serverRows == 0 then
		x = sx-140
	end
	if #clientRows ~= 0 then
        local count = 0
        for i, row in ipairs(clientRows) do
			if not disabledResources[row[1]] then
				local usedCPU = toFloor(row[2])
                if usedCPU > 1 or string.match(row[1], "oPaintjobs") then
                    count = count + 1
                end
            end
        end
        
		local height = (15*count)+15
		local y = sy/2-height/2
        local r,g,b,a = 255,255,255,255
        if avgCM > MAX_CLIENT_CPU* 10 then
            r,g,b,a = 255,0,0,255
        elseif avgCM > MED_CLIENT_CPU* 10 then
            r,g,b,a = 255,255,0,255
        end
		if #serverRows == 0 then
			dxDrawText("Client: "..avgC.."%, "..avgCM.."%",sx-74,y-19,sx-74,y-19,tocolor(0,0,0,255),1, font,"center")
			dxDrawText("Client: "..avgC.."%, "..avgCM.."%",sx-75,y-20,sx-75,y-20,tocolor(r,g,b,a),1, font,"center")
		else
			dxDrawText("Client: "..avgC.."%, "..avgCM.."%",sx-234,y-19,sx-234,y-19,tocolor(0,0,0,255),1, font,"center")
			dxDrawText("Client: "..avgC.."%, "..avgCM.."%",sx-235,y-20,sx-235,y-20,tocolor(r,g,b,a),1, font,"center")
		end
		dxDrawRectangle(x-10,y,150,height,tocolor(30,30,30,230))
		y = y + 5
		for i, row in ipairs(clientRows) do
			if not disabledResources[row[1]] then
				local usedCPU = toFloor(row[2])
                if usedCPU > 1 or string.match(row[1], "oPaintjobs") then
                    local r,g,b,a = 255,255,255,255

                    if string.match(row[1], "oShader") then 
                        r, g, b, a = 52, 137, 235, 255
                    end                              
                    if string.match(row[1], "oPaintjobs") then 
                        r, g, b, a = 255, 137, 235, 255
                    end                    

                    if usedCPU > MAX_CLIENT_CPU then
                        r,g,b,a = 255,0,0,255
                    elseif usedCPU > MED_CLIENT_CPU then
                        r,g,b,a = 255,255,0,255
                    end
                    local text = row[1]:sub(0,15)..": "..usedCPU.."%"

                    
                    --    r,g,b = 150,0,0
                    --end
                    --if string.match(row[1], "oPaintjobs") then 
                    dxDrawText(text,x+1,y+1,150,15,tocolor(0,0,0,220),1,font)
                    dxDrawText(text,x,y,150,15,tocolor(r,g,b,a),1,font)
                    --end
                    y = y + 15
                end
			end
		end
	end
	
	if #serverRows ~= 0 then
        local count = 0
        for i, row in ipairs(serverRows) do
			if not disabledResources[row[1]] then
				local usedCPU = toFloor(row[2])
                if usedCPU > 1 then
                    count = count + 1
                end
            end
        end
        
		local x = sx-140
		local height = (15*count)
		local y = sy/2-height/2
        local r,g,b,a = 255,255,255,255
        if avgSM > MAX_SERVER_CPU* 10 then
            r,g,b,a = 255,0,0,255
        elseif avgSM > MED_SERVER_CPU* 10 then
            r,g,b,a = 255,255,0,255
        end
		dxDrawText("Server: "..avgS.."%, "..avgSM.."%",sx-74,y-19,sx-74,y-19,tocolor(0,0,0,255),1, font,"center")
		dxDrawText("Server: "..avgS.."%, "..avgSM.."%",sx-75,y-20,sx-75,y-20,tocolor(r,g,b,a),1, font,"center")
		dxDrawRectangle(x-10,y,150,height+15,tocolor(30, 30, 30, 230))
		y = y + 5
		for i, row in ipairs(serverRows) do
			if not disabledResources[row[1]] then
				local usedCPU = toFloor(row[2])
                if usedCPU > 1 then
                    local r,g,b,a = 255,255,255,255
                    if usedCPU > MAX_SERVER_CPU then
                        r,g,b,a = 255,0,0,255
                    elseif usedCPU > MED_SERVER_CPU then
                        r,g,b,a = 255,255,0,255
                    end
                    local text = row[1]:sub(0,15)..": "..usedCPU.."%"
                    dxDrawText(text,x+1,y+1,150,15,tocolor(0,0,0,200),1,font)
                    dxDrawText(text,x,y,150,15,tocolor(r,g,b,a),1,font)
                    y = y + 15
                end
			end
		end
	end
end