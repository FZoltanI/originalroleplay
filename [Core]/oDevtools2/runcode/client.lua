function outputChatBoxR(message)
	--outputChatBox(syntax .. message, 200, 250, 200, true)
    local syntax = exports['oCore']:getServerPrefix("yellow", "Dev", 2)    
    exports['oAdmin']:sendMessageToAdmin(localPlayer, syntax .. message, 10)
end

function map(element, level)
	level = level or 0
	element = element or getRootElement()
	local indent = string.rep('  ', level)
	local eType = getElementType(element)
	local eID = getElementID(element)
	local eChildren = getElementChildren(element)
	
	local tagStart = '<'..eType
	if eID then
		tagStart = tagStart..' id="'..eID..'"'
	end
	
	if #eChildren < 1 then
		outputConsole(indent..tagStart..'"/>')
	else
		outputConsole(indent..tagStart..'">')
		for k, child in ipairs(eChildren) do
			map(child, level+1)
		end
		outputConsole(indent..'</'..eType..'>')
	end
end

local triggered
local function runString(commandstring)
    --outputChatBox("asd")
	if not exports['oAdmin']:isPlayerDeveloper(localPlayer) then return end
    --outputChatBox("asd2")
	
	vehicle = getPedOccupiedVehicle(getLocalPlayer()) or getPedContactElement(getLocalPlayer())
	car = vehicle
	p = getPlayerFromName
	c = getPedOccupiedVehicle
	set = setElementData
	get = getElementData
    me = localPlayer
    id = function(a) return exports['oCore']:getPlayerFromName(localPlayer, tostring(a)) end
	
	outputChatBoxR("Kliens oldali parancs futtatás: "..commandstring)
	local notReturned
	local commandFunction,errorMsg = loadstring("return "..commandstring)
	if errorMsg then
		notReturned = true
		commandFunction, errorMsg = loadstring(commandstring)
	end
	if errorMsg then
		outputChatBoxR("Hiba: "..errorMsg)
		return
	end
	results = { pcall(commandFunction) }
	if not results[1] then
		outputChatBoxR("Hiba: "..results[2])
		return
	end
	if not notReturned then
		local resultsString = ""
		local first = true
		for i = 2, #results do
			if first then
				first = false
			else
				resultsString = resultsString..", "
			end
			local resultType = type(results[i])
			if isElement(results[i]) then
				resultType = "element:"..getElementType(results[i])
			end
			resultsString = resultsString..inspect(results[i]).." ["..resultType.."]"
		end
		outputChatBoxR("Eredmény: "..resultsString)
	elseif not errorMsg then
		outputChatBoxR("Parancs lefuttatva!")
	end
end
addEvent("doCrun", true)
addEventHandler("doCrun", getRootElement(), runString)

--[[
addEventHandler("onClientElementDataChange", root,
    function(dName, oValue, nValue)
        outputChatBox(inspect(source) .. " - "..dName.." - "..tostring(oValue).." - "..tostring(nValue))    
    end
)]]