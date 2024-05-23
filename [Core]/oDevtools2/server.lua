--[[local resCount = {}
local addedToDebug = {}
addDebugHook("preFunction", function(sourceResource, functionName)
	if sourceResource and functionName then
		local resname = sourceResource and getResourceName(sourceResource)
		if not resCount[sourceResource] then
			resCount[sourceResource] = {}
		end
		if not resCount[sourceResource][functionName] then
			resCount[sourceResource][functionName] = 0
		end
		resCount[sourceResource][functionName] = resCount[sourceResource][functionName] + 1
		if resCount[sourceResource][functionName] > 15 and not addedToDebug["preFunction"..resname..functionName] then
			addedToDebug["preFunction"..resname..functionName] = true
			outputDebugString("1mp alatt 10szer lefutott -> preFunction => "..resname.." => "..functionName)
		end
	end
end)

addDebugHook("postFunction", function(sourceResource)
	if sourceResource and functionName then
		local resname = sourceResource and getResourceName(sourceResource)
		if not resCount[sourceResource] then
			resCount[sourceResource] = {}
		end
		if not resCount[sourceResource][functionName] then
			resCount[sourceResource][functionName] = 0
		end
		resCount[sourceResource][functionName] = resCount[sourceResource][functionName] + 1
		if resCount[sourceResource][functionName] > 15 and not addedToDebug["postFunction"..resname..functionName] then
			addedToDebug["postFunction"..resname..functionName] = true
			outputDebugString("1mp alatt 10szer lefutott -> postFunction => "..resname.." => "..functionName)
		end
	end
end)

setTimer(function()
	addedToDebug = {}
	resCount = {}
end, 1000, 1)]]