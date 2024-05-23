function runString(commandstring, source)
	me = source
	local sourceName = source and getElementData(source, "user:adminnick") or "Console"

	outputDebugString(""..sourceName.." lefuttata ezt a parancsot: "..commandstring, 0)

	function getLocalPlayer( )
		return source
	end
    localPlayer = source
    
	_G['source'] = source
	if getElementType(source) == 'player' then
		vehicle = getPedOccupiedVehicle(source) or getPedContactElement(source)
		car = vehicle
	end
	settingsSet = set
	settingsGet = get
	p = getPlayerFromName
	c = getPedOccupiedVehicle
	set = setElementData
	get = getElementData
    me = source
	id = function(a) return exports['oCore']:getPlayerFromPartialName(localPlayer, tostring(a)) end

	local notReturned
	local commandFunction, errorMsg = loadstring("return "..commandstring)
	if errorMsg then
		commandFunction, errorMsg = loadstring(commandstring)
	end
	if errorMsg then
		outputDebugString("Hiba: "..errorMsg, 1)
		return
	end
	local results = { pcall(commandFunction) }
	if not results[1] then
		outputDebugString("Hiba: "..results[2], 1)
		return
	end

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
		resultsString = resultsString..tostring(results[i]).." ["..resultType.."]"
	end

	if #results > 1 then
		outputDebugString("Eredmény: " ..resultsString, 3)
		return
	end
end

addCommandHandler("run", function(thePlayer, cmd, ...)
	if getElementType(thePlayer) == "console" or isPlayerDeveloper(thePlayer) then
		return runString(table.concat({...}, " "), thePlayer)
	end
end)