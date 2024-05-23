local sx, sy = guiGetScreenSize()
local myX, myY = 1600, 900

local core = exports.oCore
local color, r, g, b = core:getServerColor()

local tick = getTickCount()

local x, y, w, h = sx*0.385, sy*0.45, sx*0.23, sy*0.105--sy*0.476

local players = {}
local pointer = 0

local maxPlayers = 500

local fontScript = exports.oFont

local fonts = {
    ["condensed-8"] = exports.oFont:getFont("condensed", 8),
    ["condensed-10"] = exports.oFont:getFont("condensed", 10/myX*sx),

    ["sf-bold-10"] = dxCreateFont("files/font_bold.ttf", 10/myX*sx),
    ["sf-bold-12"] = dxCreateFont("files/font_bold.ttf", 12),
    ["sf-light-10"] = dxCreateFont("files/font_light.ttf", 10),

    ["bebasneue-14"] = exports.oFont:getFont("bebasneue", 14),
}

addEventHandler("onClientResourceStart", root, function(res)
	if getResourceName(res) == "oCore" or getResourceName(res) == "oScoreboard" then  
        core = exports.oCore
        color, r, g, b = exports.oCore:getServerColor()
	end
end)

local adminColors = {
    [0] = "#f7931e",
    [1] = "#E5A254",
    [2] = "#f7931e", 
    [3] = "#f7931e", 
    [4] = "#f7931e", 
    [5] = "#f7931e", 
    [6] = "#f7931e", 
    [7] = "#ae61e8", 
    [8] = "#72b55e", 
    [9] = "#ffbb5b", 
    [10] = "#5db2f7", 
    [11] = "#f44141", 
}

local adminTag = {
    [0] = "[Játékos]",
    [1] = "(AdminSegéd)", 
    [2] = "(Admin 1)", 
    [3] = "(Admin 2)", 
    [4] = "(Admin 3)", 
    [5] = "(Admin 4)", 
    [6] = "(Admin 5)", 
    [7] = "(FőAdmin)", 
    [8] = "(AdminController)", 
    [9] = "(Server Manager)", 
    [10] = "<Fejlesztő/>", 
    [11] = "(Tulajdonos)",
}

local adminIcons = {
    [0] = "null",
    [1] = "admin_s",
    [2] = "admin",
    [3] = "admin",
    [4] = "admin",
    [5] = "admin",
    [6] = "admin",
    [7] = "fadmin",
    [8] = "ac",
    [9] = "sm",
    [10] = "dev",
    [11] = "tulaj",
}

local tiltottgombok = {
    ["mouse_wheel_down"] = true,
    ["mouse_wheel_up"] = true,
	["backspace"] = true,
	["tab"] = true,
	["-"] = true,
	["."] = true,
	[","] = true,
	["lctrl"] = true,
	["rctrl"] = true,
	["lalt"] = true,
	["mouse1"] = true,
	["mouse2"] = true,
	["mouse3"] = true,
	["F1"] = true,
	["F2"] = true,
	["F3"] = true,
	["F4"] = true,
	["F5"] = true,
	["F6"] = true,
	["F7"] = true,
	["F8"] = true,
	["F9"] = true,
	["F10"] = true,
	["F11"] = true,
	["F12"] = true,
	["lshift"] = true, 
	["rshift"] = true,
	["space"] = true,
	["Pgdn"] = true,
	["num_div"] = true,
	["num_mul"] = true,
	["num_sub"] = true,
	["num_add"] = true,
	["num_sub"] = true,
	["escape"] = true,
	["inster"] = true,
	["home"] = true,
	["delete"] = true,
	["end"] = true,
	["pgup"] = true,
	["scroll"] = true,
	["pause"] = true,
	["ralt"] = true,
	["enter"] = true,
}

local showing = false
local animType = "open"

local a = 0
local logo_a = 0
local scoretimer = false

local score_editbox = ""
local score_editbox_active = false

local players = {}

addEventHandler("onClientPlayerQuit", getRootElement(), function()
    for k, v in ipairs(players) do
        if v == source then
           table.remove(players, k)
        end
    end

    y = sy*0.45
    h = sy*0.105

    if #players <= 10 then 
        h = sy*0.105 + (#players * sy*0.037)
        y = sy*0.45 - (#players * sy*0.037/1.5)
    else
        h = sy*0.105 + (10 * sy*0.037)
        y = sy*0.45 - (10 * sy*0.037/1.7)
    end

end)

function renderScore()

    --[[dxDrawLine(0, sy, sx, sy, tocolor(255, 0, 0), 5)
    dxDrawLine(sx, 0, sx, sy, tocolor(255, 0, 0), 5)]]

    --dxDrawLine(0, sy*0.5, sx, sy*0.5)
    --dxDrawLine(sx*0.5, 0, sx*0.5, sy)

    if animType == "open" then 
        a = interpolateBetween(a,0,0,1,0,0,(getTickCount() - tick)/300,"Linear")
        logo_a = interpolateBetween(logo_a,0,0,1,0,0,(getTickCount() - tick)/300,"Linear")
    elseif animType == "close" then 
        a = interpolateBetween(a,0,0,0,0,0,(getTickCount() - tick)/300,"Linear")
        logo_a = interpolateBetween(logo_a,0,0,0,0,0,(getTickCount() - tick)/300,"Linear") 
    else
        --logo_a = interpolateBetween(0,0,0,1,0,0,(getTickCount() - tick)/2500,"CosineCurve")
    end


    local colorLogo, colorLogoInv = interpolateBetween(0, 1, 0, 1, 0, 0, (getTickCount() - tick)/6000, "CosineCurve")

    dxDrawImage(x, y-(sy*0.12 - sy*0.04 * logo_a), w, 100/myY*sy, "files/orp.png", 0, 0, 0, tocolor(255, 255, 255, 255 * logo_a * colorLogoInv))
    dxDrawImage(x, y-(sy*0.12 - sy*0.04 * logo_a), w, 100/myY*sy, "files/orp.png", 0, 0, 0, tocolor(r,g , b, 255 * logo_a * colorLogo))


    dxDrawRectangle(x, y, w, h + sy*0.004, tocolor(40, 40, 40,240*a))
    --dxDrawRectangle(x, y, w, h, tocolor(255,25,25,240*a))
    dxDrawRectangle(x+2/myX*sx, y+2/myY*sy, w-4/myX*sx, sy*0.025, tocolor(35, 35, 35, 220*a))

    dxDrawText("Scoreboard", x, y, x+w, y+sy*0.031, tocolor(220,220,220,255*a), 1, fontScript:getFont("p_bo", 15/myX*sx), "center", "center", false, false, false, true)
    --dxDrawImage(x + sx*0.2145, y + 2/myY*sy, 22/myY*sy, 22/myY*sy, "files/logo.png", 0, 0, 0, tocolor(220, 220, 220, 255*logo_a))s

    roundedRectangle(x+sx*0.035, y+sy*0.032, sx*0.16, sy*0.025, tocolor(35, 35, 35,240*a), tocolor(35, 35, 35,240*a), false)
    --dxDrawRectangle(x+sx*0.035, y+sy*0.04, sx*0.16, sy*0.025, tocolor(40,40,40,240*a))

    if string.len(score_editbox) > 0 then
        dxDrawText(score_editbox, x+sx*0.035, y+sy*0.032, x+sx*0.035+sx*0.16, y+sy*0.032+sy*0.025, tocolor(255, 255, 255, 200*a), 0.8/myX*sx, fonts["sf-light-10"], "center", "center") 
    else
        dxDrawText("Játékos keresése (ID vagy névrészlet alapján)", x+sx*0.035, y+sy*0.032, x+sx*0.035+sx*0.16, y+sy*0.032+sy*0.025, tocolor(255, 255, 255, 100*a), 0.8/myX*sx, fonts["sf-light-10"], "center", "center")
    end

    dxDrawRectangle(x+2/myX*sx, y+sy*0.062, w-4/myX*sx, sy*0.03, tocolor(35, 35, 35, 220*a))
    dxDrawText("#", x+2/myX*sx, y+sy*0.062, x+2/myX*sx+35/myX*sx, y+sy*0.062+sy*0.032, tocolor(r,g,b,255*a), 0.85, fontScript:getFont("p_bo", 15/myX*sx), "center", "center")
    dxDrawText("ID", x+sx*0.01, y+sy*0.062,  x+sx*0.025+sx*0.025, y+sy*0.062+sy*0.032, tocolor(r,g,b,255*a), 0.85, fontScript:getFont("p_bo", 15/myX*sx), "center", "center")
    dxDrawText("Játékosnév", x+sx*0.04, y+sy*0.062, x+sx*0.04+sx*0.14, y+sy*0.062+sy*0.032, tocolor(r,g,b,255*a), 0.85, fontScript:getFont("p_bo", 15/myX*sx), "center", "center")
    dxDrawText("Szint", x+sx*0.05+sx*0.12, y+sy*0.062, x+sx*0.05+sx*0.12+sx*0.04, y+sy*0.062+sy*0.032, tocolor(r,g,b,255*a), 0.85, fontScript:getFont("p_bo", 15/myX*sx), "center", "center")
    dxDrawText("Ping", x+sx*0.05+sx*0.147, y+sy*0.062, x+sx*0.05+sx*0.147+sx*0.04, y+sy*0.062+sy*0.032, tocolor(r,g,b,255*a), 0.85, fontScript:getFont("p_bo", 15/myX*sx), "center", "center")

    local starty = y+sy*0.095
    for i = 1, 10 do
        if players[i+pointer] then 
            local v = players[i+pointer]

            local color = tocolor(35, 35, 35, 220*a)

            dxDrawRectangle(x+2/myX*sx, starty, w-4/myX*sx, sy*0.035, color) 

            if getElementData(v, "user:loggedin") then 
                dxDrawText(getElementData(v,"playerid"), x+sx*0.01, starty, x+sx*0.05, starty+sy*0.038, tocolor(220,220,220,255*a), 0.8, fontScript:getFont("p_m", 15/myX*sx), "center", "center")

                local name = getPlayerName(v)
                local hadmin = getElementData(v, "user:hadmin")
                if getElementData(v, "user:aduty") and not hadmin or getElementData(v, "user:admin") == 1 then 
                    local rank = getElementData(v, "user:admin") 

                    dxDrawRectangle(x+4/myX*sx, starty+2/myY*sy, 27/myX*sx, 27/myY*sy, tocolor(25, 25, 25, 100*a))

                    local adminIcon = adminIcons[rank]
                    dxDrawImage(x+8/myX*sx, starty+2/myY*sy + 4/myX*sx, 19/myX*sx, 19/myY*sy, "files/adminIcons/"..adminIcon..".png", 0, 0, 0, tocolor(255,255,255,255*a))


                    name = getElementData(v, "user:adminnick")
                    
                    name = adminColors[rank] ..adminTag[rank].." #dcdcdc".. name

                    if (string.len(name)-14) > 30 then
                        name = adminColors[rank] .. getPlayerName(v)
                    end
                else
                    dxDrawImage(x+4/myX*sx, starty+2/myY*sy, 27/myX*sx, 27/myY*sy, ":oAccount/avatars/"..(getElementData(v, "char:avatarID") or 1)..".png", 0, 0, 0, tocolor(255,255,255,255*a))
                end

                if getElementData(v, "user:idgAs") then 
                    name = "#f7931e(Adminsegéd) #dcdcdc".. name
                end

                dxDrawText(name:gsub("_", " "), x+sx*0.04, starty, x+sx*0.04+sx*0.14, starty+sy*0.038, tocolor(220, 220, 220, 255*a), 0.8, fontScript:getFont("p_m", 15/myX*sx), "center", "center", false, false, false, true)

                local playedTime = getElementData(v,"char:playedTime") or {0, 0}
                dxDrawText(tonumber(exports.oLvl:countPlayerLevel(playedTime[1] or 0)), x+sx*0.05+sx*0.12, starty, x+sx*0.05+sx*0.12+sx*0.04, starty+sy*0.038, tocolor(220, 220, 220, 255*a),  0.8, fontScript:getFont("p_m", 15/myX*sx), "center", "center")

                local playerping = getPlayerPing(v)

                local pingicon = 1
                if playerping < 25 then 
                    pingicon = 4
                elseif playerping >= 25 and playerping < 40 then 
                    pingicon = 3
                elseif playerping >= 40 and playerping < 75 then 
                    pingicon = 2 
                elseif playerping > 75 then 
                    pingicon = 1
                end

                dxDrawImage(x+sx*0.05+sx*0.158, starty+2/myY*sy, 27/myX*sx, 27/myY*sy, "files/4.png", 0,0,0, tocolor(220, 220, 220, 50*a))
                dxDrawImage(x+sx*0.05+sx*0.158, starty+2/myY*sy, 27/myX*sx, 27/myY*sy, "files/"..pingicon..".png", 0,0,0, tocolor(220, 220, 220, 255*a))
            else
                dxDrawRectangle(x+4/myX*sx, starty+2/myY*sy, 27/myX*sx, 27/myY*sy, tocolor(25, 25, 25, 255*a))
                dxDrawText("?", x+4/myX*sx, starty+2/myY*sy, x+4/myX*sx+27/myX*sx, starty+2/myY*sy+27/myY*sy, tocolor(r, g, b, 100*a), 1/myX*sx, fonts["sf-light-10"], "center", "center")
                dxDrawText(getElementData(v,"playerid"), x+sx*0.01, starty, x+sx*0.05, starty+sy*0.035, tocolor(220,220,220, 100*a), 0.8/myX*sx, fonts["sf-light-10"], "center", "center")

                local name = getPlayerName(v)

                dxDrawText(name:gsub("_", " "):gsub("#%x%x%x%x%x%x", ""), x+sx*0.04, starty, x+sx*0.04+sx*0.14, starty+sy*0.035, tocolor(220, 220, 220, 100*a), 0.95/myX*sx, fonts["sf-light-10"], "center", "center", false, false, false, false)
                dxDrawText("#", x+sx*0.05+sx*0.12, starty, x+sx*0.05+sx*0.12+sx*0.04, starty+sy*0.035, tocolor(220, 220, 220, 100*a), 1/myX*sx, fonts["sf-light-10"], "center", "center")

                local playerping = getPlayerPing(v)

                local pingicon = 1
                if playerping < 25 then 
                    pingicon = 4
                elseif playerping >= 25 and playerping < 40 then 
                    pingicon = 3
                elseif playerping >= 40 and playerping < 75 then 
                    pingicon = 2 
                elseif playerping > 75 then 
                    pingicon = 1
                end

                dxDrawImage(x+sx*0.05+sx*0.158, starty+2/myY*sy, 27/myX*sx, 27/myY*sy, "files/4.png", 0,0,0, tocolor(220, 220, 220, 25*a))
                dxDrawImage(x+sx*0.05+sx*0.158, starty+2/myY*sy, 27/myX*sx, 27/myY*sy, "files/"..pingicon..".png", 0,0,0, tocolor(220, 220, 220, 100*a))
            end
            starty = starty + sy*0.037
        end
    end

    local multiplier = #players / maxPlayers
    --dxDrawRectangle(x, starty + sy*0.005, w, sy*0.021, tocolor(25,25,25,200*a))
    dxDrawRectangle(x + 2/myX*sx, starty + sy*0.0013, w - 4/myX*sx, sy*0.01, tocolor(35, 35, 35,200*a))
    dxDrawRectangle(x + 2/myX*sx, starty + sy*0.0013, (w - 4/myX*sx) * multiplier * a, sy*0.01, tocolor(r, g, b, 230*a))

    roundedRectangle(x + 2/myX*sx + ((w - 4/myX*sx) * multiplier) - sx*0.015, starty + sy*0.042 - (sy*0.02 * a), sx*0.03, sy*0.025, tocolor(25,25,25, 220 * a), tocolor(25,25,25, 255 * a), false)
    dxDrawImage(x + 2/myX*sx + ((w - 4/myX*sx) * multiplier) - 6/myX*sx, starty + sy*0.0328 - (sy*0.02 * a), 12/myX*sx, 12/myX*sx, "files/arrow.png", 180, 0, 0, tocolor(25,25,25, 255 * a))
    dxDrawText(#players, x + 22/myX*sx + ((w - 4/myX*sx) * multiplier) - sx*0.015, starty + sy*0.042 - (sy*0.02 * a), x + 22/myX*sx + ((w - 4/myX*sx) * multiplier) - sx*0.015 + sx*0.015, starty + sy*0.042 - (sy*0.02 * a) + sy*0.028, tocolor(255, 255, 255, 255 * a),  0.8, fontScript:getFont("p_bo", 15/myX*sx), "center", "center")
    dxDrawImage(x + 4/myX*sx + ((w - 4/myX*sx) * multiplier) - sx*0.015, starty + sy*0.042 - (sy*0.02 * a) + sy*0.004, 14/myX*sx, 14/myX*sx, "files/people.png", 0, 0, 0, tocolor(255, 255, 255, 255 * a))
    --dxDrawText(math.ceil(#players * a).."/"..maxPlayers, x, starty + sy*0.005, x + w, starty + sy*0.005 + sy*0.02, tocolor(255, 255, 255, 100*a), 0.8, fonts["condensed-10"], "center", "center")
end

function sortPlayers(a, b)
    if ((getElementData(a, "playerid") or 0) < (getElementData(b, "playerid") or 0)) then
        return true
    elseif ((getElementData(a, "playerid") or 0) > (getElementData(b, "playerid") or 0)) then
        return false
    else
        return false
    end
end

function loadPlayers()
    players = {}
    for k, v in ipairs(getElementsByType("player")) do 
        table.insert(players, #players+1, v)
    end
    table.sort(players, sortPlayers)
    
    for k, v in ipairs(players) do 
        if v == localPlayer then 
            table.remove(players, k)
            table.insert(players, 1, v)
        end
    end
end
addEventHandler("onClientResourceStart", resourceRoot, loadPlayers)

function openScore()
    score_editbox = ""
    showing = true
    tick = getTickCount()
    animType = "open"
    loadPlayers()

    y = sy*0.45
    h = sy*0.105

    if #players <= 10 then 
        h = sy*0.105 + (#players * sy*0.037)
        y = sy*0.45 - (#players * sy*0.037/1.5)
    else
        h = sy*0.105 + (10 * sy*0.037)
        y = sy*0.45 - (10 * sy*0.037/1.7)
    end
    removeEventHandler("onClientRender", root, renderScore)
    addEventHandler("onClientRender", root, renderScore)
end

function scoreKey(key, state) 
    if getElementData(localPlayer, "user:loggedin") then 
        if key == "tab" then
            cancelEvent()
            if state then

                if score_editbox_active then 
                    animType = "close"
                    tick = getTickCount()

                    scoretimer = setTimer(function() 
                        showing = false
                        score_editbox_active = false
                        removeEventHandler("onClientRender", root, renderScore)
                    end, 300, 1)
                end

                if not isTimer(scoretimer) then 
                    openScore()
                end
            else    
                if not score_editbox_active then 
                    if not isTimer(scoretimer) then 
                        animType = "close"
                        tick = getTickCount()

                        scoretimer = setTimer(function() 
                            showing = false
                            score_editbox_active = false
                            removeEventHandler("onClientRender", root, renderScore)
                        end, 300, 1)
                    end
                end
            end 
        end

        if state then 
            if showing then 
                if key == "mouse_wheel_down" then 
                    if pointer + 10 < #players then 
                        pointer = pointer + 1
                    end
                end

                if key == "mouse_wheel_up" then 
                    if pointer > 0 then 
                        pointer = pointer - 1
                    end
                end

                if key == "mouse1" then 
                    if core:isInSlot(x+sx*0.035, y+sy*0.04, sx*0.16, sy*0.025) then 
                        score_editbox_active = true
                    else
                        score_editbox_active = false
                    end
                end

                if score_editbox_active then 
                    if not tiltottgombok[key] then 
                        cancelEvent()
                        score_editbox = score_editbox .. key:gsub("num_", "")
                        refreshSearch()
                    end

                    if key == "backspace" then 
                        cancelEvent()
                        score_editbox = score_editbox:gsub("[^\128-\191][\128-\191]*$", "")
                        refreshSearch()
                    end
                end
            end
        end
    end
end

addEventHandler("onClientResourceStart", resourceRoot, function() 
    addEventHandler("onClientKey", root, scoreKey)
end)

function refreshSearch()
    local playersCache = getElementsByType("player")
    players = {}
    for k, v in ipairs(playersCache) do
        if tonumber(score_editbox) then
            if getElementData(v, "playerid") == tonumber(score_editbox) then
                table.insert(players, v)
            end
        else
            if utf8.lower(getPlayerName(v):gsub("_", " ")):find(utf8.lower(score_editbox), 1, true) then
                table.insert(players, v)
            end
        end
    end

    y = sy*0.45
    h = sy*0.105

    if #players <= 10 then 
        h = sy*0.105 + (#players * sy*0.037)
        y = sy*0.45 - (#players * sy*0.037/1.5)
    else
        h = sy*0.105 + (10 * sy*0.037)
        y = sy*0.45 - (10 * sy*0.037/1.7)
    end
end

function roundedRectangle(x, y, w, h, borderColor, bgColor, postGUI)
	if (x and y and w and h) then
		if (not borderColor) then
			borderColor = tocolor(0, 0, 0, 200);
		end
		if (not bgColor) then
			bgColor = borderColor;
		end
		dxDrawRectangle(x, y, w, h, bgColor, postGUI);
		dxDrawRectangle(x + 2, y - 1, w - 4, 1, borderColor, postGUI);
		dxDrawRectangle(x + 2, y + h, w - 4, 1, borderColor, postGUI);
		dxDrawRectangle(x - 1, y + 2, 1, h - 4, borderColor, postGUI);
		dxDrawRectangle(x + w, y + 2, 1, h - 4, borderColor, postGUI);
	end
end
 
function spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end