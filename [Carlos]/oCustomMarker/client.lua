if fileExists("client.lua") then 
    fileDelete("client.lua")
end

local animTime = 0

local folder = "files/"

local textures = {
    ["fire"] = dxCreateTexture(folder.."fire.png"),
    ["water"] = dxCreateTexture(folder.."water.png"),
    ["plant"] = dxCreateTexture(folder.."leaf.png"),
    ["newspaper"] = dxCreateTexture(folder.."newspaper.png"),
    ["bike"] = dxCreateTexture(folder.."bike.png"),
    ["jobvehicle"] = dxCreateTexture(folder.."jobvehicle.png"),
    ["home"] = dxCreateTexture(folder.."home.png"),
    ["traffic_light"] = dxCreateTexture(folder.."traffic_light.png"),
    ["forklift"] = dxCreateTexture(folder.."forklift.png"),
    ["shirt"] = dxCreateTexture(folder.."shirt.png"),
    ["trashbag"] = dxCreateTexture(folder.."trashbag.png"),
    ["burger"] = dxCreateTexture(folder.."burger.png"),
    ["oven"] = dxCreateTexture(folder.."oven.png"),
    ["pizza"] = dxCreateTexture(folder.."pizza.png"),
    ["cashmachine"] = dxCreateTexture(folder.."cashmachine.png"),

    ["manClothes"] = dxCreateTexture(folder.."manClothes.png"),
    ["girlClothes"] = dxCreateTexture(folder.."girlClothes.png"),
    ["gangClothes"] = dxCreateTexture(folder.."gangClothes.png"),
    ["race"] = dxCreateTexture(folder.."race.png"),

    ["arrow"] = dxCreateTexture(folder.."arrow.png"), -- default icon
}

local marker_icon_size = 0.5

local icon_animation_duration = 2500
local icon_animation_type = "CosineCurve"

addEventHandler("onClientRender",root,
    function()
        for k,v in ipairs(getElementsByType("marker", root, true)) do 
            if getElementData(v,"isCustomMarker") then 
                if getElementData(v,"showCustomMarker") then
                    if ((getElementDimension(v) == getElementDimension(localPlayer)) and (getElementInterior(v) == getElementInterior(localPlayer))) then 
                        local pX,pY,pZ = getElementPosition(localPlayer)
                        local mX,mY,mZ = getElementPosition(v)
                        local mR, mG, mB = getMarkerColor(v)
                        local mS = getMarkerSize(v) 
                        local mT = getElementData(v, "customMarkerType")
                        local mOT = getElementData(v, "customMarkerOutline") or "octagon"

                        mZ = mZ + 0.01


                        if getDistanceBetweenPoints3D(pX,pY,pZ,mX,mY,mZ) < 60 then 

                            local radius = interpolateBetween(1,0,0,0,0,0,(getTickCount() - animTime) / icon_animation_duration, "CosineCurve")
                            local icon_alpha = interpolateBetween(1,0,0,0.7,0,0,(getTickCount() - animTime) / icon_animation_duration, "CosineCurve")

                            if mOT == "octagon" then 
                                dxDrawOctagon3D(mX, mY, mZ, mS/2*radius, 2, tocolor(mR, mG, mB, 255*radius))
                            elseif mOT == "circle" then 
                                dxDrawCircle3D(mX, mY, mZ, mS/2*radius, tocolor(mR, mG, mB, 255*radius), 2, 40)
                            elseif mOT == "rectangle" then 
                                dxDrawBox3D(mX-mS/4*radius, mY-mS/4*radius, mZ, mS/2*radius, tocolor(mR, mG, mB, 255*radius), 2)
                            end

                            local progress = (getTickCount() - animTime) / icon_animation_duration
                            position = math.floor(interpolateBetween(0, 0, 0, 300, 0, 0, progress, icon_animation_type))

                            dxDrawMaterialLine3D(mX, mY, mZ+0.9+marker_icon_size+(position/1000),mX, mY, mZ+0.9+(position/1000),textures[mT], marker_icon_size, tocolor( mR, mG, mB, 250*icon_alpha))
                        end
                    end
                end
            end
        end
    end 
)

function createCustomMarker(x, y, z, size, r, g, b, a, type, outlineType)

    if not outlineType then 
        outlineType = "octagon"
    end

    if not type then 
        type = "arrow"
    end

    if not size then 
        size = 2.0
    end

    local marker = createMarker(x, y, z-1, "cylinder", size/2, r, g, b, a)

    setElementData(marker, "isCustomMarker", true)
    setElementData(marker, "customMarkerType", type)
    setElementData(marker, "customMarkerOutline", outlineType)
    setElementData(marker,"showCustomMarker",true)
    setElementAlpha(marker, 0)
    


    return marker
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

function dxDrawCircle3D( x, y, z, radius, color, width, segments)
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

function dxDrawBox3D(x,y,z,r,color,w)
    dxDrawLine3D (x,y,z,x+r,y,z,color,w)
    dxDrawLine3D (x,y,z,x,y+r,z,color,w)
    dxDrawLine3D (x+r,y,z,x+r,y+r,z,color,w)
    dxDrawLine3D (x,y+r,z,x+r,y+r,z,color,w)
end