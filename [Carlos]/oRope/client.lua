function createSpline(points, steps)
	if #points < 3 then
		return points
	end

	local spline = {}

	do
		steps = steps or 3
		steps = 1 / steps

		local count = #points - 1
		local p0, p1, p2, p3, x, y, z

		for i = 1, count do
			if i == 1 then
				p0, p1, p2, p3 = points[i], points[i], points[i + 1], points[i + 2]
			elseif i == count then
				p0, p1, p2, p3 = points[#points - 2], points[#points - 1], points[#points], points[#points]
			else
				p0, p1, p2, p3 = points[i - 1], points[i], points[i + 1], points[i + 2]
			end

			for t = 0, 1, steps do
				x = (1 * ((2 * p1[1]) + (p2[1] - p0[1]) * t + (2 * p0[1] - 5 * p1[1] + 4 * p2[1] - p3[1]) * t * t + (3 * p1[1] - p0[1] - 3 * p2[1] + p3[1]) * t * t * t)) * 0.5
				y = (1 * ((2 * p1[2]) + (p2[2] - p0[2]) * t + (2 * p0[2] - 5 * p1[2] + 4 * p2[2] - p3[2]) * t * t + (3 * p1[2] - p0[2] - 3 * p2[2] + p3[2]) * t * t * t)) * 0.5
				z = (1 * ((2 * p1[3]) + (p2[3] - p0[3]) * t + (2 * p0[3] - 5 * p1[3] + 4 * p2[3] - p3[3]) * t * t + (3 * p1[3] - p0[3] - 3 * p2[3] + p3[3]) * t * t * t)) * 0.5

				local splineId = #spline

				if not (splineId > 0 and spline[splineId][1] == x and spline[splineId][2] == y and spline[splineId][3] == z) then
					spline[splineId + 1] = {x, y, z}
				end
			end
		end
	end

	return spline
end

x2, y2, z = 1724.5080566406,-1868.7619628906,15.564237594604
x3, y3, z2 = 1723.1195068359,-1864.2368164062,14.05
lineData = {
	{
		{x2 + 0.3, y2 + 0.0425, z - 1.45},

	},

	{
		{x3 + 0.3, y3 + 0.0425, z2 - 1.45},

	},
}

function renderRope(startX, startY, startZ, endX, endY, endZ, steps)
	if not steps then 
		steps = 25 
	end

	local ropePosX, ropePosY, ropePosZ = endX, endY, endZ

	local linePos = {startX, startY, startZ}
	local offsetX = (ropePosX - linePos[1]) / 2
	local offsetY = (ropePosY - linePos[2]) / 2

	local splinePositions = {
		{linePos[1], linePos[2], linePos[3]},
		{linePos[1] + offsetX / 2, linePos[2] + offsetY / 2, linePos[3]},
		{ropePosX - offsetX / 2, ropePosY - offsetY / 2, ropePosZ - 0.3},
		{ropePosX, ropePosY, ropePosZ}
	}

	local ropeSpline = createSpline(splinePositions, steps)

	for j = 1, #ropeSpline do
		local k = j + 1

		if ropeSpline[k] then
			dxDrawLine3D(ropeSpline[j][1], ropeSpline[j][2], ropeSpline[j][3], ropeSpline[k][1], ropeSpline[k][2], ropeSpline[k][3], tocolor(5, 5, 5), 1.5)
		end
	end
end