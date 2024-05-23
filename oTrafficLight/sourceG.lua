lightObjects = {
	[1352] = {5, 4, -6, 0, 0},
}

function getRoundedRotation(rotation)
	local rot = math.floor(rotation)
	rot = 360 - rot
	if rot > 70 and rot < 110 then
		return 270
	elseif rot > 160 and rot < 200 then
		return 180
	elseif rot > 250 and rot < 290 then
		return 90
	elseif rot < 20 then
		return 0
	else
		return nil
	end
end