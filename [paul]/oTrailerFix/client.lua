--[[addEventHandler("onClientElementStreamIn", getRootElement( ), 
    function ( ) 
        if not getElementData(source, "isTowingVeh") then return end 
        local trailer = getElementData(source, "isTownedTrailer")
		iprint(trailer)
		local truck = source
		setTimer(function()
			iprint(truck)
			detachTrailerFromVehicle(truck, trailer)
			attachTrailerToVehicle(truck, trailer)
		end, 1000, 1)
    end 
)

setTimer(function()
	for k, v in ipairs(getElementsByType("vehicle")) do
		if getElementData(v, "isTowingVeh") then 
			local trailer = getElementData(v, "isTownedTrailer")
			attachTrailerToVehicle(v, trailer)
		end
	end
end, 5000, 0)

local towingAvalibleVehicles = {
	[514] = true,
	[515] = true,
	[403] = true,
	[552] = true,
}

addEventHandler("onClientResourceStart",resourceRoot,function()
	for k,v in pairs(getElementsByType("vehicle")) do 
		setTowingStatus(true)
	end 

	setTimer(function()
		setTowingStatus(true)
	end,5000,0)
end)

function setTowingStatus(status)
	for k,v in pairs(getElementsByType("vehicle")) do 
		if towingAvalibleVehicles[getElementModel(v)] then 
			setElementData(v,"isTowingVeh",false)
		end 
	end 
end ]]