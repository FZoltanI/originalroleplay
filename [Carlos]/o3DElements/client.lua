local tick = getTickCount()

function dxDrawRoundedLine3D(startX, startY, startZ, endX, endY, endZ, divX, divY, divZ, segments, width, color)

    local diffX, diffY, diffZ = startX-endX, startY-endY, startZ-endZ
    local diffX2, diffY2, diffZ2 = diffX/segments, diffY/segments, diffZ/segments


    local positions = {}

    for i = 1, segments do 

        --print(startX, startY, startZ, endX/segments, endY/segments, endZ/segments)
        table.insert(positions, {startX+diffX2*i, startY+i, startZ+diffZ2*i, startX+diffX2*(i+1), startY, startZ+diffZ2*i})
    end

    for k, v in pairs(positions) do 
        dxDrawLine3D(v[1], v[2], v[3], v[4], v[5], v[6], color, width)
    end
end

function render3DZone(x, y, z, scaleX, scaleY, r, g, b, alpha, segments, width, animated)
    local playerX, playerY, playerZ = getElementPosition(localPlayer)

    if getDistanceBetweenPoints3D(playerX, playerY, playerZ, x, y, z) < 100 then
        dxDrawLine3D(x, y, z, x + scaleX, y, z, tocolor(r, g, b, alpha), width)
        dxDrawLine3D(x, y, z, x, y + scaleY, z, tocolor(r, g, b, alpha), width)
        dxDrawLine3D(x, y + scaleY, z, x + scaleX, y + scaleY, z, tocolor(r, g, b, alpha), width)
        dxDrawLine3D(x + scaleX, y, z, x + scaleX, y + scaleY, z, tocolor(r, g, b, alpha), width)

        if animated then 
            local animValue = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount() - tick) / 2000, "Linear")

            if animValue == 1 then 
                tick = getTickCount()
            end

            dxDrawLine3D(x, y, z + animValue, x + scaleX, y, z + animValue, tocolor(r, g, b, (alpha * (1 - animValue))), width * (1 - animValue))
            dxDrawLine3D(x, y, z + animValue, x, y + scaleY, z + animValue, tocolor(r, g, b, (alpha * (1 - animValue))), width * (1 - animValue))
            dxDrawLine3D(x, y + scaleY, z + animValue, x + scaleX, y + scaleY, z + animValue, tocolor(r, g, b, (alpha * (1 - animValue))), width * (1 - animValue))
            dxDrawLine3D(x + scaleX, y, z + animValue, x + scaleX, y + scaleY, z + animValue, tocolor(r, g, b, (alpha * (1 - animValue))), width * (1 - animValue))
        end

        dxDrawLine3D(x, y, z, x + scaleX, y + scaleY, z, tocolor(r, g, b, alpha * 0.25), width * 0.7)

        for i = 1, segments do 
            dxDrawLine3D(x, y + scaleY - ((scaleY / segments) * (segments - i)), z, x + scaleX - (((scaleX / segments) * i)), y + scaleY, z, tocolor(r, g, b, alpha * 0.25), width * 0.7)
        end

        for i = 1, (segments - 1) do 
            dxDrawLine3D(x  + scaleX - ((scaleX / segments) * (segments - i)), y, z, x + scaleX, y + scaleY - ((scaleY / segments) * i), z, tocolor(r, g, b, alpha * 0.25), width * 0.7)
        end
    end
end

local drops = {
    {value = 0, tick = getTickCount()},
    {value = 0, tick = getTickCount() + 500},
    {value = 0, tick = getTickCount() + 1000},
}

function renderLiquid(x, y, z, colorr, colorg, colorb) 
    for k, v in ipairs(drops) do 
        if v.tick <= getTickCount() then 
            v.value = interpolateBetween(v.value, 0, 0, 1, 0, 0, (getTickCount() - v.tick)/1500, "Linear")

            if v.value == 1 then 
                v.value = 0
                v.tick = getTickCount()
            end

            dxDrawLine3D(x, y, z-(k * 0.1)-(1 * v.value), x, y, z-(k * 0.1)-(1 * v.value)+0.2, tocolor(colorr, colorg, colorb, 150 * (1 - v.value)), 1.5)
        end
    end
end

addEventHandler("onClientRender", root, function()
    --renderLiquid(1784.5245361328,-2061.3234863281,14.569606781006, 40, 189, 235)
end)

function dxDrawCircle3D( x, y, z, radius, color, width )
    local playerX,playerY,playerZ = getElementPosition(localPlayer)
    if getDistanceBetweenPoints3D(playerX,playerY,playerZ,x, y, z) <= 50 then
        segments = segments or 16;
        color = color or tocolor( 248, 126, 136, 200 );  
        width = width or 1; 
        local segAngle = 360 / segments; 
        local fX, fY, tX, tY;  
        local alpha = 20
        for i = 1, segments do 
            fX = x + math.cos( math.rad( segAngle * i ) ) * radius; 
            fY = y + math.sin( math.rad( segAngle * i ) ) * radius; 
            tX = x + math.cos( math.rad( segAngle * (i+1) ) ) * radius;  
            tY = y + math.sin( math.rad( segAngle * (i+1) ) ) * radius; 
            dxDrawLine3D( fX, fY, z, tX, tY, z, color, width);
        end
     end    
end

function dxDrawRectangle3D(x,y,z,r,color,w)
    dxDrawLine3D (x,y,z,x+r,y,z,color,w)
    dxDrawLine3D (x,y,z,x,y+r,z,color,w)
    dxDrawLine3D (x+r,y,z,x+r,y+r,z,color,w)
    dxDrawLine3D (x,y+r,z,x+r,y+r,z,color,w)
end

function dxDrawOctagon3D(x, y, z, radius, width, color)
	if type(x) ~= "number" or type(y) ~= "number" or type(z) ~= "number" then
		return false
	end

	local radius = radius or 1
	local radius2 = radius/math.sqrt(2)
	local width = width or 1
	local color = color or tocolor(255,255,255,150)

	point = {}

		for i=1,8 do
			point[i] = {}
		end

		point[1].x = x
		point[1].y = y-radius
		point[2].x = x+radius2
		point[2].y = y-radius2
		point[3].x = x+radius
		point[3].y = y
		point[4].x = x+radius2
		point[4].y = y+radius2
		point[5].x = x
		point[5].y = y+radius
		point[6].x = x-radius2
		point[6].y = y+radius2
		point[7].x = x-radius
		point[7].y = y
		point[8].x = x-radius2
		point[8].y = y-radius2
		
	for i=1,8 do
		if i ~= 8 then
			x, y, z, x2, y2, z2 = point[i].x,point[i].y,z,point[i+1].x,point[i+1].y,z
		else
			x, y, z, x2, y2, z2 = point[i].x,point[i].y,z,point[1].x,point[1].y,z
		end
		dxDrawLine3D(x, y, z, x2, y2, z2, color, width)
	end
	return true
end