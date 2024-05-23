local sx,sy = guiGetScreenSize()
local resStat = false
local clientRows = {}, {}
local serverRows = {}, {}

local avgC, avgCM, avgS, avgSM = 0,0, 0,0

local MED_CLIENT_CPU = 5 -- 5%
local MAX_CLIENT_CPU = 10 -- 10%

local MED_SERVER_CPU = 1 -- 1%
local MAX_SERVER_CPU = 2 -- 3%

addCommandHandler("stat", 
    function()
        if exports['oAdmin']:isPlayerDeveloper(localPlayer) then
            colors = {
                ["yellow"] = {exports['oCore']:getServerPrefix("yellow", "dev", 2), 255, 255, 255},
                ["red"] = {exports['oCore']:getServerPrefix("red-dark", "dev", 2), 255, 255, 255},
                ["green"] = {exports['oCore']:getServerPrefix("green-dark", "dev", 2), 255, 255, 255},
                ["white"] = {"#ffffff", 255, 255, 255},
                ["gray"] = {"#9c9c9c", 156, 156, 156},
            }
            resStat = not resStat
            startTick = getTickCount()
            if resStat then
                start = true
                local syntax = exports['oCore']:getServerPrefix("green-dark", "dev", 2)
                _, clientRows = getPerformanceStats("Lua timing")
                outputChatBox(syntax .. "Szerver terhelési nézet bekapcsolva!", 0, 255, 0, true)
                --addEventHandler("onClientRender", root, resStatRender, true, "low")
                --renderTimer1 = setTimer(resStatRender, 8, 0)
                createRender("resStatRender", resStatRender)
                triggerServerEvent("getServerStat", localPlayer)
                getClientCPU()
                if isTimer(timer) then killTimer(timer) end
                timer = setTimer(getClientCPU, 500, 0)
            else
                if isTimer(timer) then killTimer(timer) end
                local syntax = exports['oCore']:getServerPrefix("red-dark", "dev", 2)
                outputChatBox(syntax .. "Szerver terhelési nézet kikapcsolva!", 255, 0, 0, true)
                start = false
            end
        end
    end
)

function toFloor(num)
	return tonumber(string.sub(tostring(num):gsub("%%", ""), 0, 5)) or 0
end

function getClientCPU()
    --outputChatBox("update")
    
    _, clientRows = getPerformanceStats("Lua timing")

    for k,v in pairs(clientRows) do 
        if toFloor(v[2]) < 0.1 then 
            table.remove(clientRows, k)
        end 
    end 
    
    table.sort(clientRows, function(a, b)
        return toFloor(a[2]) > toFloor(b[2])
    end)
    
    avgC = 0
    for k,v in pairs(clientRows) do
        avgC = avgC + toFloor(v[2])
    end
    avgCM = toFloor(avgC)
    avgC = toFloor(avgC / #clientRows)
end

addEvent("receiveServerStat", true)
addEventHandler("receiveServerStat", root, 
    function(stat1,stat2)
        serverRows = stat2

        for k,v in pairs(serverRows) do 
            if toFloor(v[2]) < 0.025 then 
                table.remove(serverRows, k)
            end 
        end 

        table.sort(serverRows, function(a, b)
            return toFloor(a[2]) > toFloor(b[2])
        end)
        
        avgS = 0
        for k,v in pairs(serverRows) do
            avgS = avgS + toFloor(v[2])
        end
        avgSM = toFloor(avgS)
        avgS = toFloor(avgS / #serverRows)
    end
)

function dxDrawOuterBorder(x, y, w, h, borderSize, borderColor, postGUI)
	borderSize = borderSize or 2
	borderColor = borderColor or tocolor(0, 0, 0, 255)
	
	dxDrawRectangle(x - borderSize, y - borderSize, w + (borderSize * 2), borderSize, borderColor, postGUI)
	dxDrawRectangle(x, y + h, w, borderSize, borderColor, postGUI)
	dxDrawRectangle(x - borderSize, y, borderSize, h + borderSize, borderColor, postGUI)
	dxDrawRectangle(x + w, y, borderSize, h + borderSize, borderColor, postGUI)
end

startAnimation = "InOutQuad"
startAnimationTime = 250 -- / 1000 = 0.2 másodperc

local disabledResources = {}
function resStatRender()
    local alpha
    local nowTick = getTickCount()
    if start then
        local elapsedTime = nowTick - startTick
        local duration = (startTick + startAnimationTime) - startTick
        local progress = elapsedTime / duration
        local alph = interpolateBetween(
            0, 0, 0,
            255, 0, 0,
            progress, startAnimation
        )
        
        alpha = alph
    else
        local elapsedTime = nowTick - startTick
        local duration = (startTick + startAnimationTime) - startTick
        local progress = elapsedTime / duration
        local alph = interpolateBetween(
            255, 0, 0,
            0, 0, 0,
            progress, startAnimation
        )
        
        alpha = alph
        
        if progress >= 1 then
            destroyRender("resStatRender")
            serverRows = {}, {}
            clientRows = {}, {}
            triggerServerEvent("destroyServerStat", localPlayer)
        end
    end
    
    local alpha = math.max(alpha,25)-25
    local alpha_2 = math.max(alpha,135)-135
    
    font = exports['cr_fonts']:getFont("Roboto", 9)
    
	local x = sx-300
	if #serverRows == 0 then
		x = sx-140
	end
	if #clientRows ~= 0 then
        local count = 0
        for i, row in ipairs(clientRows) do
            local usedCPU = toFloor(row[2])
            count = count + 1
        end
        
		local height = (15*count)+15
		local y = sy/2-height/2
        local cHex = colors["white"][1]
        if avgC > 5 then
            cHex = colors["red"][1]
        elseif avgC > 2.5 then
            cHex = colors["yellow"][1]
        end
        
        local cHex2 = colors["white"][1]
        if avgC > 60 then
            cHex2 = colors["red"][1]
        elseif avgC > 35 then
            cHex2 = colors["yellow"][1]
        end
		if #serverRows == 0 then
			--dxDrawText("Kliens: "..avgC.."% | "..avgCM.."%",sx-74,y-19,sx-74,y-19,tocolor(0,0,0,255),1, font,"center")
			dxDrawText(colors["white"][1] .. "Kliens: "..cHex..avgC..colors["white"][1].."% | "..cHex2..avgCM..colors["white"][1].."%",sx-75,y-20,sx-75,y-20,tocolor(255,255,255,255),1, font,"center", nil, false, false, false, true)
		else
			--dxDrawText("Kliens: "..avgC.."% | "..avgCM.."%",sx-234,y-19,sx-234,y-19,tocolor(0,0,0,255),1, font,"center")
			dxDrawText(colors["white"][1] .. "Kliens: "..cHex..avgC..colors["white"][1].."% | "..cHex2..avgCM..colors["white"][1].."%",sx-235,y-20,sx-235,y-20,tocolor(255,255,255,255),1, font,"center", nil,  false, false, false, true)
		end
		--dxDrawRectangle(x-10,y,150,height,tocolor(r,g,b,150), tocolor(0,0,0,150))
        dxDrawOuterBorder(x-10,y,150,height, 2, tocolor(30,30,30,alpha_2))
		dxDrawRectangle(x-10,y,150,height, tocolor(30,30,30,alpha))
		y = y + 5
		for i, row in ipairs(clientRows) do
            local usedCPU = toFloor(row[2])
            local cHex = colors["white"][1]
            if usedCPU > MAX_CLIENT_CPU then
                cHex = colors["red"][1]
            elseif usedCPU > MED_CLIENT_CPU then
                cHex = colors["yellow"][1]
            end
            local text = cHex .. row[1]..": "..usedCPU.."%"
            dxDrawText(text,x,y,150,15,tocolor(255, 255, 255,alpha),1,font, nil, nil, false, false, false, true)
            y = y + 15
		end
	end
	
	if #serverRows ~= 0 then
        local count = 0
        for i, row in ipairs(serverRows) do
            local usedCPU = toFloor(row[2])
            count = count + 1
        end
        
		local x = sx-140
		local height = (15*count)
		local y = sy/2-height/2
		dxDrawText("Szerver: "..avgS.."% | Össz: "..avgSM.."%",sx-74,y-19,sx-74,y-19,tocolor(0,0,0,255),1, font,"center")
		dxDrawText("Szerver: "..avgS.."% | Össz: "..avgSM.."%",sx-75,y-20,sx-75,y-20,tocolor(255,255,255,255),1, font,"center")
        local r,g,b,a = 255,255,255,255
        if avgS > MAX_CLIENT_CPU then
            r,g,b,a = 255,0,0,255
        elseif avgS > MED_CLIENT_CPU then
            r,g,b,a = 255,255,0,255
        end
		dxDrawOuterBorder(x-10,y,150,height + 15, 2, tocolor(30,30,30,alpha_2))
		dxDrawRectangle(x-10,y,150,height + 15, tocolor(30,30,30,alpha))
		y = y + 5
		for i, row in ipairs(serverRows) do
			local usedCPU = toFloor(row[2])
            local cHex = colors["white"][1]
            if usedCPU > MAX_CLIENT_CPU then
                cHex = colors["red"][1]
            elseif usedCPU > MED_CLIENT_CPU then
                cHex = colors["yellow"][1]
            end
            local text = cHex .. row[1]..": "..usedCPU.."%"
            dxDrawText(text,x,y,150,15,tocolor(255, 255, 255,alpha),1,font, nil, nil, false, false, false, true)
            y = y + 15
		end
	end
end