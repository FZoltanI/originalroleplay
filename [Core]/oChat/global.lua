function getNearestPlayers(thePlayer, dist)
	if not dist then dist = 20 end
	local tempTable = {}
	local x1, y1, z1 = getElementPosition(thePlayer)
	local int = getElementInterior(thePlayer)
	local dim = getElementDimension(thePlayer)

	for _, player in pairs(getElementsByType("player")) do
		if int == getElementInterior(player) and dim == getElementDimension(player) then
			local x2, y2, z2 = getElementPosition(player)
			if getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2) < dist then
				table.insert(tempTable, player)

				if getElementData(player, "recon:reconerPlayer") then 
					table.insert(tempTable, getElementData(player, "recon:reconerPlayer"))
				end
			--[[elseif getElementData(player, "recon:reconedPlayer") then 
				if getElementData(player, "recon:reconedPlayer") == thePlayer then 
					table.insert(tempTable, player)
				end]]
			end
		end
	end
	return tempTable
end

core = exports.oCore