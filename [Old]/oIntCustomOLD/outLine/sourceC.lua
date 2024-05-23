-- //Coded by: Incama
-- Ez az Object Outline, ha lejebb mész ott van a getElementBoundingBox is. By: Botond
--[[local specularPower = 10
local effectMaxDistance = 50
local isPostAura = true

local sx, sy = guiGetScreenSize ()
local effectOn = nil
local myRT = dxCreateRenderTarget(sx, sy, true)
local myShader = nil
local pwEffectEnabled = false
local wallShader = {}
local shaders = {}
local PWTimerUpdate = 110

function lofasz()
	destroyObjectOutline(faszomelement)
end
addCommandHandler('fasz', lofasz)

function Object:createOutline(color)
	if not shaders[self] then
		shaders[self] = DxShader("files/fx/post_edge.fx", 1, effectMaxDistance, true, "object")
	end
	if (shaders[self]) then 
		shaders[self]:setValue("sTex0", myRT)
		shaders[self]:setValue("sRes", sx, sy)

		pwEffectEnabled = true
		if not wallShader[self] then
			wallShader[self] = DxShader("files/fx/outlineMrt.fx", 1, effectMaxDistance, true, "object")
		end

		if not wallShader[self] then
			return false, "hiba -> nincs elég memória shaderre"
		end
		if not myRT then
			return false, "hiba -> nincs rendertarget"
		end
		wallShader[self]:setValue("secondRT", myRT)
		wallShader[self]:setValue("sColorizePed", {color[1]/255, color[2]/255, color[3]/255, color[4]/255})
		wallShader[self]:setValue("sSpecularPower", specularPower)
		wallShader[self]:applyToWorldTexture("*", self)
		-- engineRemoveShaderFromWorldTexture(wallShader[self],"muzzle_texture*", self) -- sztem ide ez nem kell
		return true
	end
end

function Object:destroyOutline()
    if wallShader[self] then
		wallShader[self]:removeFromWorldTexture("*" , self)
		wallShader[self]:destroy()
		wallShader[self] = nil

		local c = 0;
		for i,v in ipairs(wallShader) do
			if v then
				c = c + 1
			end
		end
		if c == 0 then
			pwEffectEnabled = false
			if isElement(myRT) then
				myRT:destroy();
			end
		end
	end
end

addEventHandler( "onClientPreRender", root,
    function()
		if not pwEffectEnabled then return end
		dxSetRenderTarget( myRT, true )
		dxSetRenderTarget()
    end
, true, "high" )

addEventHandler( "onClientHUDRender", root,
    function()
		if not pwEffectEnabled then return end
        for i,v in pairs(shaders) do  
		  dxDrawImage( 0, 0, sx, sy, v )
        end
    end
) 

floor1 = createObject(16010, 755.80828857422,-805.40270996094,74.86873626709):createOutline({210,49,49, 255});
floor2 = createObject(16010, 751.78828857422,-805.40270996094,74.86873626709):createOutline({210,49,49, 255});
floor3 = createObject(16010, 745.376953125,-805.33709716797,75.615608215332):createOutline({210,49,49, 255});]]

--[[local objId = 16010

local temp = Object(objId, localPlayer.position)
local minx, miny, minz, maxx, maxy, maxz = getElementBoundingBox(temp)
temp:destroy()

local maxRows = 3
local maxColumns = 3
local t = {}
for i = 0,maxRows*maxColumns-1 do
    local obj = Object(objId, localPlayer.position.x + i%maxRows*maxx*2, localPlayer.position.y +  math.floor(i/maxColumns)*maxy*2, localPlayer.position.z);
    table.insert(t, obj)
end

addEventHandler("onClientRender", root, function()
    if t and isElement(t[1]) and isElement(t[2]) then
        local pos1 = Vector3(t[2].position.x+minx, t[2].position.y+miny, t[2].position.z + maxz)
        local pos2 = Vector3(t[2].position.x+minx, t[2].position.y+miny - ((minx*2)*maxColumns), t[2].position.z + maxz)
        dxDrawLine3D(pos1, pos2, tocolor(124,197,118), 5)
        local pos1 = Vector3(t[3].position.x+minx, t[3].position.y+miny, t[3].position.z + maxz)
        local pos2 = Vector3(t[3].position.x+minx, t[3].position.y+miny - ((minx*2)*maxColumns), t[3].position.z + maxz)
        dxDrawLine3D(pos1, pos2, tocolor(124,197,118), 5)  
    end
end)]]