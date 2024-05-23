serverColor = "#e97619"
serverRGB = {233, 118, 25}
serverName = "originalRoleplay"
colors = {
	["red-light"] = {"#eb6c5b", 235, 108, 91},
	["red-dark"] = {"#e0361f", 224, 54, 31},

	["green-light"] = {"#aced66", 172, 237, 102},
	["green-dark"] = {"#259908", 37, 153, 8},

	["blue-light"] = {"#34c1e0", 52, 193, 224},
	["blue-dark"] = {"#0d849e", 13, 132, 158},

	["blue-light-2"] = {"#2379cf", 35, 121, 207},
	["blue-dark-2"] = {"#175da3", 23, 93, 163},

	["yellow"] = {"#ebd93b", 235, 217, 59},

	["orange"] = {"#e89b4f", 232, 155, 79},

	["server"] = {"#e97619", 233, 118, 25},
}

serverVersion = "2"

function getServerName()
    return serverName
end

function getServerColor()
    return serverColor, serverRGB[1], serverRGB[2], serverRGB[3]
end

function getServerPrefix(colorType, scriptName, prefixType)
	if not scriptName then 
		scriptName = ""
	end

	if not prefixType then 
		prefixType = 1
	end

	local prefix = serverColor.."["..serverName.."]: #ffffff"

	if prefixType == 2 then 
		prefix = colors[colorType][1].."["..serverName.." - "..scriptName.."]: #ffffff"
	elseif prefixType == 3 then 
		if colors[colorType] then 
			prefix = colors[colorType][1].."["..scriptName.."]: #ffffff"
		else
			prefix = "Error"
		end
	end

	return prefix
end

function getColor(color)
	if colors[color] then 
		return colors[color][1], colors[color][2], colors[color][3], colors[color][4]
	else
		return "#000000"
	end
end

function getPlayerFromPartialName(thePlayer, nick, nomsg, type)
	if not type then type = 1 end
	local playerTbl = {}
    local players = getElementsByType("player")

	if nick == "*" then
		return thePlayer, getPlayerName(thePlayer):gsub("_", " ")
	end
	
	if tonumber(nick) then
        local nick = tonumber(nick) or 0
		for _, p in ipairs(players) do
            if getElementData(p, "user:loggedin") then
                if tonumber(getElementData(p, "playerid")) == nick then
                    table.insert(playerTbl, {p, getPlayerName(p):gsub("_", " "), nick})
                end
            end
        end
	else
		local nick = nick and nick:gsub("#%x%x%x%x%x%x", ""):lower() or nil
		if nick then
			for _, p in ipairs(players) do
				if getElementData(p, "user:loggedin") then
                    local playerName = getPlayerName(p)
					local name_ = playerName:gsub("#%x%x%x%x%x%x", ""):lower()
					if name_:find(nick, 1, true) then
						table.insert(playerTbl, {p, playerName:gsub("_", " "), tonumber(getElementData(p, "playerid"))})
					end
				end
			end
		end
	end
	
	if #playerTbl == 1 then
		return unpack(playerTbl[1])
	elseif #playerTbl == 0 then
		if nomsg then return end
		if type == 1 then
			outputChatBox("[Játékos]: #ffffffNem található a játékos.", thePlayer, 244, 40, 40, true)
		else
			outputChatBox("[Játékos]: #ffffffNem található a játékos.", 244, 40, 40, true)
		end
	else
		if nomsg then return end
		if type == 1 then
			outputChatBox(serverColor..#playerTbl.." #ffffffjátékos található ezzel a névrészlettel:", thePlayer, 255, 255, 255, true)
			for k, v in ipairs(playerTbl) do
				outputChatBox(serverColor..v[3].." - "..v[2], thePlayer, 247, 147, 30, true)
			end
		else
			outputChatBox(serverColor..#playerTbl.." #ffffffjátékos található ezzel a névrészlettel:", 255, 255, 255, true)
			for k, v in ipairs(playerTbl) do
				outputChatBox(serverColor..v[3].." - "..v[2], 247, 147, 30, true)
			end
		end
	end
	return false
end

dayNames = {"Vasárnap","Hétfő","Kedd","Szerda","Csütörtök","Péntek","Szombat"}
monthNames = {"Január","Február","Március","Április","Május","Június","Július","Augusztus","Szeptember","Október","November","December"}

function getDate(type)
	local realtime = getRealTime()

	local second = realtime.second
	local minute = realtime.minute
	local hour = realtime.hour

	local monthday = realtime.monthday
	local month = realtime.month
	month = month + 1

	local year = realtime.year
	local yearday = realtime.yearday

	local weekday = realtime.weekday

	if type == "second" then 
		if second < 10 then 
			second = "0" .. second 
		end
		return second
	elseif type == "minute" then  
		if minute < 10 then 
			minute = "0" .. minute 
		end
		return minute
	elseif type == "hour" then 
		if hour < 10 then 
			hour = "0" .. hour 
		end
		return hour
	elseif type == "monthday" then
		if monthday < 10 then  
			monthday = "0".. monthday
		end
		return monthday
	elseif type == "month" then 
		if month < 10 then  
			month = "0".. month
		end
		return month
	elseif type == "monthname" then 
		return monthNames[month]
	elseif type == "year" then 
		return year + 1900
	elseif type == "yearday" then 
		return yearday
	elseif type == "dayname" then 
		return dayNames[weekday+1]

	else
		return "false"
	end
end

function minToMilisec(min)
	return min*60000
end

function getDistance(element1,element2) 
	local element1X, element1Y, element1Z = getElementPosition(element1)
	local element2X, element2Y, element2Z = getElementPosition(element2)

	return getDistanceBetweenPoints3D(element1X, element1Y, element1Z, element2X, element2Y, element2Z)
end

function hexaToRGB(hex)
    hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
end

function tableContains(table, element)
	for _, value in pairs(table) do
		if value == element then
			return true
		end
	end
	return false
end

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element ) 
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z 
end

tiltottgombok = {
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
	["capslock"] = true,

	["mouse_wheel_up"] = true,
	["mouse_wheel_down"] = true,
}

function keyIsRealKeyboardLetter(key)
	if tiltottgombok[key] then 
		return false 
	else
		return true 
	end
end

customKeys = {
    ["="] = "ó",
    ["#"] = "á",
    [";"] = "é",
    ["]"] = "ú",
    ["["] = "ő",
    ["'"] = "ö",
    ["/"] = "ü",
}

function getHungarianKeyboardLetter(key)
	return customKeys[key] or key
end

randomNames = {
	["family"] = {"Smith", "Jones", "Williams", "Brown", "White", "Wilson", "Taylor", "Johnson", "Andrerson", "Thompson", "Lee", "Ryan", "Harris", "Tremblay", "Clark", "Young", "Sanchez", "Philips", "Collins", "Torres", "Parker", "Evans", "Green", "Morales", "Fisher", "Davis"},
	["boy"] = {"Liam", "Noah", "James", "Logan", "Benjamin", "Ethan", "Daniel", "Matthew", "Mason", "David", "Dylan", "Luke", "Christian", "Dominic", "Austin", "Adam", "Axel", "Luis", "Ivan", "Jasper", "Brian", "Milo", "Derek", "Felix", "Arthur", "Jake", "Tobias", "Karson", "Mario", "Angelo", "Troy", "Odin", "Gregory", "Roberto", "Mohamed", "Mathias"},
	["girl"] = {"Mia", "Emily", "Mila", "Victoria", "Scarlett", "Chole", "Lily", "Stella", "Zoe", "Claire", "Lucy", "Julia", "Josephine", "Sophie", "Iris", "Mary", "Molly", "Sara", "Daisy", "Kayla", "Diana", "Lola", "Angela", "Myla", "Kiara", "Kate", "Leia", "Allie", "Kira", "Lana", "Elisa", "Jenna", "Nia", "Sierra", "Aisha", "Virginia", "Elaine", "Gloria", "Kara", "Julie", "Marie", "Aliza"},
}

function createRandomName(type)
	local name = ""

	if type == "boy" or type == "male" then 
		name = randomNames["boy"][math.random(#randomNames["boy"])] .." ".. randomNames["family"][math.random(#randomNames["family"])]
	elseif type == "girl" or type == "female" then 
		name = randomNames["girl"][math.random(#randomNames["girl"])] .." ".. randomNames["family"][math.random(#randomNames["family"])]
	elseif type == "family" then 
		name = randomNames["family"][math.random(#randomNames["family"])]
	end
		
	return name
end