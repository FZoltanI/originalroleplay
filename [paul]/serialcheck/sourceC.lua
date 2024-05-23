--A62119868F7900D49FE9BF6167D46884

local serials = {
	["A62119868F7900D49FE9BF6167D46884"] = true,
	["A51AEA488C429FDF52385CC085F80134"] = true,
}

addEventHandler("onResourceStart",resourceRoot,function()
	for k,v in pairs(getElementsByType("player")) do 
		if serials[tostring(getPlayerSerial(v))] then 
			kickPlayer(v,"Kapcsolat megtagadva!")
		end 
	end 	
end)