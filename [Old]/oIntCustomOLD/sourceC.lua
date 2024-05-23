local func = {};
local screen = {guiGetScreenSize()};

local sx, sy = guiGetScreenSize()
local myX, myY = 1600, 900
--screen[1], screen[2] = 1920,1080


--[[if screen[1] > 1800 then 
	maxcount = 11
elseif screen[1] < 1800 and screen[1] > 1500 then 
	maxcount = 10 
elseif srceen[1] < 1500 and screen[1] > 1000 then 
	maxcount = 9 
else 
	maxcount = 8 
end]]

local cache = {
	opensans = dxCreateFont("files/fonts/opensans.ttf",12);
	opensans2 = dxCreateFont("files/fonts/opensans.ttf",14);
	OpenSansB = dxCreateFont("files/fonts/OpenSansB.ttf",12);
	OpenSansB2 = dxCreateFont("files/fonts/OpenSansB.ttf",15);
	OpenSansEB = dxCreateFont("files/fonts/OpenSansEB.ttf",12);
	OpenSansEB2 = dxCreateFont("files/fonts/OpenSansEB.ttf",15);
	menu = 1;
	menuPoint = 0;
	menuType = 1;
	selected = 0;
	selectedDoor = 0;
	shader = "";
	models = {
		wall = 16271;
		walldoor = 9104;
		bigwall = 7983;
		floor2 = 11531;
		floor4 = 16010;
		floor8 = 16230;
		halfwall = 8412;
	};
	doors = {
		{1505}; --blue
	};
	hover = {
		door = nil;
		object = nil;
	};
	wheel = 0;
	move = {
		progress = 0;
		door = {
			state = "";
		};
	};
	wall = {
		cash = 0;
	};
};
local objectCache = {};
local interiorObjects = {};
texturedObjects = {};

local specularPower = 10;
local effectMaxDistance = 50;
local isPostAura = true;

local sx, sy = guiGetScreenSize ();
local myRT = dxCreateRenderTarget(sx, sy, true);
local pwEffectEnabled = false;
local wallShader = {};
local shaders = {};
local renderCache = {};
local notTriggered = {};

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

func.start = function()
	setElementFrozen(localPlayer,false)
	engineImportTXD(engineLoadTXD("files/models/floor.txd"), cache.models.floor4)
	engineReplaceModel(engineLoadDFF("files/models/floor.dff", cache.models.floor4), cache.models.floor4)
	engineReplaceCOL(engineLoadCOL ("files/models/floor.col" ), cache.models.floor4)
	
	engineImportTXD(engineLoadTXD("files/models/wall.txd"), cache.models.wall)
	engineReplaceModel(engineLoadDFF("files/models/wall.dff", cache.models.wall), cache.models.wall)
	engineReplaceCOL(engineLoadCOL ("files/models/wall.col" ), cache.models.wall)
	
	engineImportTXD(engineLoadTXD("files/models/wall_door.txd"), cache.models.walldoor)
	engineReplaceModel(engineLoadDFF("files/models/wall_door.dff", cache.models.walldoor), cache.models.walldoor)
	engineReplaceCOL(engineLoadCOL ("files/models/wall_door.col" ), cache.models.walldoor)
	
	engineImportTXD(engineLoadTXD("files/models/wall_half.txd"), cache.models.halfwall)
	engineReplaceModel(engineLoadDFF("files/models/wall_half.dff", cache.models.halfwall), cache.models.halfwall)
	engineReplaceCOL(engineLoadCOL ("files/models/wall_half.col" ), cache.models.halfwall)
	
	--default custom 1 int50
	
	if getElementDimension(localPlayer) > 0 then
		createInteriorObjects(getElementDimension(localPlayer))
	end
	if getElementData(localPlayer,"interior:editing") then
	--	setElementData(localPlayer,"interior:editing",false);
	--	setElementData(localPlayer,"hudVisible",true);
	--	showChat(true);
	end
	
	 
end
addEventHandler("onClientResourceStart",resourceRoot,func.start)

func.stop = function()
	setElementFrozen(localPlayer,true)
end
addEventHandler("onClientResourceStop",resourceRoot,func.stop)

func.streamIn = function()
    if getElementType(source) == "marker" and getElementData(source,"isIntOutMarker") and getElementData(source,"custom") and getElementData(source,"custom") > 0 then
        createInteriorObjects(getElementDimension(source));
    end
	if getElementType(source) == "object" and getElementInterior(source) == getElementInterior(localPlayer) and getElementDimension(source) == getElementDimension(localPlayer) and not objectCache[source] then
		objectCache[source] = true;
    end
end
addEventHandler("onClientElementStreamIn",getRootElement(),func.streamIn)

func.streamOut = function()
    if getElementType(source) == "marker" and getElementData(source,"isIntOutMarker") and getElementData(source,"custom") and getElementData(source,"custom") > 0 then
        destroyInteriorObjects(getElementDimension(source))
    end
	if getElementType(source) == "object" and objectCache[source] then
        objectCache[source] = nil;
    end
end
addEventHandler( "onClientElementStreamOut",getRootElement(),func.streamOut)

func.destroy = function()
    if getElementType(source) == "object" and objectCache[source] then
        objectCache[source] = nil;
    end
end
addEventHandler("onClientElementDestroy", getRootElement(),func.destroy)

func.deleteInteriorObjectSync = function(dimension)
	for v,k in pairs(objectCache) do
		if getElementDimension(v) == dimension then
			destroyElement(v)
		end
	end
end
addEvent("deleteInteriorObjectSync",true)
addEventHandler("deleteInteriorObjectSync",getRootElement(),func.deleteInteriorObjectSync)

func.syncUpdateInteriorObjects = function(data)
	for k,v in pairs(data) do
		if not interiorObjects[v.id] then
			interiorObjects[v.id] = {
				id = tonumber(v.id);
				x = tonumber(v.x);
				y = tonumber(v.y);
				z = tonumber(v.z);
				rx = tonumber(v.rx);
				ry = tonumber(v.ry);
				rz = tonumber(v.rz);
				interior = tonumber(v.interior);
				dimension = tonumber(v.dimension);

				model = tonumber(v.model);
				type = v.type;
				isdefault = false;
				defaultdoor = false;
		
				doorLock = v.doorLock;

				textureDatas = data.textureDatas
			};
			
			local object = createObject(v.model,v.x,v.y,v.z,v.rx,v.ry,v.rz);
			if not objectCache[object] then
				if v.defaultdoor then
					setElementData(object,"custom:default:door",true)
					setElementData(object,"custom:door:model",v.model)
					setElementData(object,"custom:door:pos",{v.x,v.y,v.z});
					setElementCollisionsEnabled(object,false);
				end

				if v.textureDatas then
					for k2, v2 in pairs(v.textureDatas) do 
						local folder = "files/textures/".. v2[1] .. "/" .. v2[2] .. "/" .. v2[3]
	
						setObjectTextureC(object, k2, folder)
					end
				end

				setElementData(object,"isCustom",true)
				setElementData(object,"custom:dbid",v.id)
				
				setElementData(object, "custom:textureDatas", v.textureDatas)

				setElementData(object,"custom:default",v.isdefault)
				setElementData(object,"custom:type",v.type)
				if v.type == "door" then
					local pos1 = object.matrix:transformPosition(Vector3(0.75,-1,1))
					local pos2 = object.matrix:transformPosition(Vector3(0.75,1,1))
					setElementData(object,"custom:matrix1",{pos1.x, pos1.y, pos1.z})
					setElementData(object,"custom:matrix2",{pos2.x, pos2.y, pos2.z})
					setElementFrozen(object,v.doorLock)
					if v.texID > 0 then
						local folder = "files/textures/"..(v.folder1).."/"..(v.folder2).."/"..(v.texID)
						setElementData(object,"custom:folder",folder)
						setObjectTextureC(object,v.texture,folder)
					end
				end
				setElementInterior(object,v.interior)
				setElementDimension(object,v.dimension)
				objectCache[object] = true;
			end
		end
	end
end
addEvent("syncUpdateInteriorObjects",true)
addEventHandler("syncUpdateInteriorObjects",getRootElement(),func.syncUpdateInteriorObjects)

function createInteriorObjects(dimension)
	triggerServerEvent("createInteriorObjectsServer",localPlayer,localPlayer,dimension)
end

function destroyInteriorObjects(dimension)
	if getElementData(localPlayer,"interior:editing") then
		setElementData(localPlayer,"interior:editing",false);
		if cache.hover.object then
			cache.hover.object:destroyOutline();
			cache.hover.object = nil;
		end
		
		cache.selectedDoor = 0;
		cache.move.progress = 0;
		cache.move.door.state = ""
		cache.menu = 1;
		cache.menuPoint = 0;
		cache.menuType = 1;
		if cache.hover.door then
			cache.hover.door = nil;
		end
	
	end
	interiorObjects = {};
	for v,k in pairs(objectCache) do
		if getElementDimension(v) == dimension then
			destroyElement(v)
		end
	end
end

func.syncClientDoorObject = function(data)
	for v,k in pairs(objectCache) do
		if getElementData(v,"custom:default:door") then
			if getElementData(v,"custom:door:model") ~= data.model then
				setElementModel(v,data.model)
				setElementData(v,"custom:door:model",data.model)
			end
			setElementData(v,"custom:door:pos",{data.x,data.y,data.z});
			setElementPosition(v,data.x,data.y,data.z)
		end
	end	
end
addEvent("syncClientDoorObject",true)
addEventHandler("syncClientDoorObject",getRootElement(),func.syncClientDoorObject)

function interiorObjectsSync(data)
	interiorObjects = data
	for k,v in pairs(interiorObjects) do

		local object = createObject(v.model,v.x,v.y,v.z,v.rx,v.ry,v.rz);

		local light = createLight(3, v.x,v.y,v.z, 10, 255, 255, 255, v.x, v.y, v.z)
		setElementInterior(light, v.interior)
		setElementDimension(light, v.dimension)

		if not objectCache[object] then
			if v.defaultdoor then
				setElementData(object,"custom:default:door",true)
				setElementData(object,"custom:door:model",v.model)
				setElementData(object,"custom:door:pos",{v.x,v.y,v.z});
				setElementCollisionsEnabled(object,false);
			end

			if v.textureDatas then
				for k2, v2 in pairs(v.textureDatas) do 
					local folder = "files/textures/".. v2[1] .. "/" .. v2[2] .. "/" .. v2[3]

					setObjectTextureC(object, k2, folder)
				end
			end

			setElementData(object,"isCustom",true)
			setElementData(object,"custom:dbid",v.id)
		
			setElementData(object, "custom:textureDatas", v.textureDatas)

			setElementData(object,"custom:default",v.isdefault)
			setElementData(object,"custom:type",v.type)
			setElementInterior(object,v.interior)
			setElementDimension(object,v.dimension)

			if v.type == "door" then
				local pos1 = object.matrix:transformPosition(Vector3(0.75,-1,1))
				local pos2 = object.matrix:transformPosition(Vector3(0.75,1,1))
				setElementData(object,"custom:matrix1",{pos1.x, pos1.y, pos1.z})
				setElementData(object,"custom:matrix2",{pos2.x, pos2.y, pos2.z})
				setElementFrozen(object,v.doorLock)

				if not bejaratiajtok[getElementModel(object)] then
					local textureID = v.texID or 2
					if textureID > 0 then
						local folder = "files/textures/door/painted/"..(textureID)
						setElementData(object,"custom:folder",folder)
						setObjectTextureC(object,v.texture,folder)
					end
				end
			end
			objectCache[object] = true;
		end
	end
end
addEvent("interiorObjectsSync",true)
addEventHandler("interiorObjectsSync",getRootElement(),interiorObjectsSync)

func.syncWallDoorLock = function(id,state)
	if interiorObjects[id].doorLock ~= state then
		interiorObjects[id].doorLock = state;
		for v,k in pairs(objectCache) do
			if getElementData(v,"custom:type") and getElementData(v,"custom:type") == "door" and getElementData(v,"custom:dbid") == id then
				setElementFrozen(v,state)
				if state then
					setElementRotation(v,getElementRotation(v))
				end
			end
		end
	end
end
addEvent("syncWallDoorLock",true)
addEventHandler("syncWallDoorLock",getRootElement(),func.syncWallDoorLock)

func.getTextureFromDistance = function(object)
	local state = "";	
	local disc = getDistanceBetweenPoints3D(cache.hover.object.matrix:transformPosition(Vector3(1,0,0)),localPlayer.position);
	local disc2 = getDistanceBetweenPoints3D(cache.hover.object.matrix:transformPosition(Vector3(-1,0,0)),localPlayer.position);
	
	if disc > disc2 then
		state = "a"
	end
	
	if disc2 > disc then
		state = "b"
	end
	return state
end

hoverElement = nil

function isElementMoving (theElement )
   if isElement ( theElement ) then                                   -- First check if the given argument is an element
      return Vector3( getElementVelocity( theElement ) ).length ~= 0
   end
   return false
end

func.render = function()
	if cache.hover.object then
		
	end
	if getElementDimension(localPlayer) > 0 and exports["oInteriors"]:isInteriorOwner(getElementDimension(localPlayer)) then
		for v,k in pairs(objectCache) do
			if (getElementModel(v) == 1502 or getElementModel(v) == 1491) and getElementData(v,"custom:type") == "door" then
				local matrix1 = Vector3(unpack(getElementData(v,"custom:matrix1")))
				if matrix1 then
					local disc1 = getDistanceBetweenPoints3D(matrix1,localPlayer.position);
					if disc1 <= 0.4 then
						dxDrawRectangle(screen[1]/2-30,screen[2]-200,60,60,tocolor(0,0,0,160))
						local locked = getElementData(v,"door:locked")
						local lockimage = "open"
						if locked then
							lockimage = "close"
						end
						local lockR,lockG,lockB = 255,255,255
						if core:isInSlot(screen[1]/2-24,screen[2]-194,48,48) then
							lockR,lockG,lockB = 124,197,118
						end
						dxDrawImage(screen[1]/2-24,screen[2]-194,48,48,"files/images/"..lockimage..".png",0,0,0,tocolor(lockR,lockG,lockB))
					end
				end
				
				local matrix2 = Vector3(unpack(getElementData(v,"custom:matrix2")))
				if matrix2 then
					local disc2 = getDistanceBetweenPoints3D(matrix2,localPlayer.position);
					if disc2 <= 0.4 then
						dxDrawRectangle(screen[1]/2-30,screen[2]-200,60,60,tocolor(0,0,0,160))
						local locked = getElementData(v,"door:locked")
						local lockimage = "open"
						if locked then
							lockimage = "close"
						end
						local lockR,lockG,lockB = 255,255,255
						if core:isInSlot(screen[1]/2-24,screen[2]-194,48,48) then
							lockR,lockG,lockB = 124,197,118
						end
						dxDrawImage(screen[1]/2-24,screen[2]-194,48,48,"files/images/"..lockimage..".png",0,0,0,tocolor(lockR,lockG,lockB))
					end
				end
			end
		end
	end
	
	if getElementData(localPlayer,"interior:editing") then
		--showChat(false);

		core:dxDrawRoundedRectangle(sx*0.005, sy*0.01, sx*0.15, sy*0.04, tocolor(30, 30, 30, 150))
		core:dxDrawRoundedRectangle(sx*0.005+2/myX*sx, sy*0.01+2/myX*sx, sx*0.15-4/myX*sx, sy*0.04-4/myY*sy, tocolor(35, 35, 35, 255))

		local startX = sx*0.01
		for k, v in ipairs(toolMenuButtons) do 
			local iconValue = 0 

			if v.event == "setroofshowing" then 
				iconValue = roofState
			end

			local iconAlpha = 200

			if core:isInSlot(startX, sy*0.015, 25/myX*sx, 25/myY*sy) then 
				iconAlpha = 255

				local cx, cy = getCursorPosition()
				cx, cy = cx*sx, cy*sy 

				cx, cy = cx + 10/myX*sx, cy + 10/myY*sy

				local textWidth = dxGetTextWidth(v.tooltip, 1, font:getFont("condensed", 10/myX*sx))
				dxDrawRectangle(cx, cy, textWidth, sy*0.03, tocolor(30, 30, 30, 200), true)
				dxDrawRectangle(cx+2/myX*sx, cy+2/myY*sy, textWidth-4/myX*sx, sy*0.03-4/myY*sy, tocolor(35, 35, 35, 255), true)
				dxDrawText(v.tooltip, cx+2/myX*sx, cy+2/myY*sy, cx+2/myX*sx+textWidth-4/myX*sx, cy+2/myY*sy+sy*0.03-4/myY*sy, tocolor(255, 255, 255, 255), 0.9, font:getFont("condensed", 10/myX*sx), "center", "center", false, false, true)
			end

			dxDrawImage(startX, sy*0.015, 25/myX*sx, 25/myY*sy, "files/icons/"..v.icon[iconValue], 0, 0, 0, tocolor(255, 255, 255, iconAlpha))
		end

		--[[createBlur(screen[1]-195,screen[2]-195-260,195,screen[2],255)
		dxDrawRectangle(screen[1]-195,screen[2]-195-260,195,screen[2],tocolor(22,22,22,220))
		dxDrawImage(screen[1]-168,screen[2]-175,140,140,"files/images/logo.png")
		
		for i = 1,#furnitureMenus do
			local name = furnitureMenus[i].name;
			if core:isInSlot(screen[1]-10 -dxGetTextWidth(name,1,cache.OpenSansEB),screen[2]-195-275+2+(i*28),dxGetTextWidth(name,1,cache.OpenSansEB),16) or cache.menu == i then
				dxDrawText(name,screen[1]-10,screen[2]-195-275+(i*28),screen[1]-10,screen[2]-195-275+(i*28),tocolor(255,255,255,255),1,cache.OpenSansEB,"right","top")
			else
				dxDrawText(name,screen[1]-10,screen[2]-195-275+(i*28),screen[1]-10,screen[2]-195-275+(i*28),tocolor(160,160,160,255),1,cache.OpenSansEB,"right","top")
			end
		end]]
		
		if cache.menu == 1 then
			if cache.menuPoint > 0 and cache.menuType > 0 then
				core:dxDrawRoundedRectangle(sx*0.005, sy*0.85, sx*0.542, sy*0.14, tocolor(30, 30, 30, 150))
				core:dxDrawRoundedRectangle(sx*0.005+2/myX*sx, sy*0.85+2/myX*sx, sx*0.542-4/myX*sx, sy*0.14-4/myY*sy, tocolor(35, 35, 35, 255))
				--createBlur(0,screen[2]-195,screen[1]-195,195,255)
				--dxDrawRectangle(0,screen[2]-195,screen[1]-195,195,tocolor(22,22,22,220))
				--dxDrawRectangle(0,screen[2]-195-46,90,46,tocolor(22,22,22,220))

				--[[if core:isInSlot(8,screen[2]-195-38,30,30) then
					dxDrawImage(8,screen[2]-195-38,30,30,"files/icons/save.png",0,0,0,tocolor(124,197,118,255))
				else
					dxDrawImage(8,screen[2]-195-38,30,30,"files/icons/save.png",0,0,0,tocolor(255,255,255,255))
				end
				
				if core:isInSlot(52,screen[2]-195-38,30,30) then
					dxDrawImage(52,screen[2]-195-38,30,30,"files/icons/close.png",0,0,0,tocolor(210,49,49,255))
				else
					dxDrawImage(52,screen[2]-195-38,30,30,"files/icons/close.png",0,0,0,tocolor(255,255,255,255))
				end
				
				dxDrawRectangle(0,screen[2]-195,32,195,tocolor(24,24,24,100))
				dxDrawRectangle(screen[1]-195-32,screen[2]-195,32,195,tocolor(24,24,24,100))
				
				if core:isInSlot(screen[1]-195-32,screen[2]-195,32,195) then
					dxDrawImage(screen[1]-225,screen[2]-108,28,28,"files/icons/arrow.png",0,0,0,tocolor(124,197,118,255))
				else
					dxDrawImage(screen[1]-225,screen[2]-108,28,28,"files/icons/arrow.png",0,0,0,tocolor(255,255,255,255))
				end
				
				if core:isInSlot(0,screen[2]-195,32,195) then
					dxDrawImage(1,screen[2]-108,28,28,"files/icons/arrow.png",180,0,0,tocolor(124,197,118,255))
				else
					dxDrawImage(1,screen[2]-108,28,28,"files/icons/arrow.png",180,0,0,tocolor(255,255,255,255))
				end]]
			end
			
			--[[for i = 1,#furnitureMenus[cache.menu] do
				local name = furnitureMenus[cache.menu][i].name;
				if core:isInSlot(screen[1]-97 -dxGetTextWidth(name,1,cache.opensans)/2,screen[2]-195-170+(i*22),dxGetTextWidth(name,1,cache.opensans),20) or cache.menuPoint == i then
					dxDrawText(name,screen[1]-97,screen[2]-195-160+(i*22),screen[1]-97,screen[2]-195-160+(i*22),tocolor(124,197,118,255),1,cache.opensans,"center","center")
				else
					dxDrawText(name,screen[1]-97,screen[2]-195-160+(i*22),screen[1]-97,screen[2]-195-160+(i*22),tocolor(255,255,255,255),1,cache.opensans,"center","center")
				end
			end]]

			if cache.menuPoint > 0 and cache.menuType > 0 then
				--dxDrawRectangle(screen[1]-98 -dxGetTextWidth(furnitureMenus[cache.menu][cache.menuPoint][cache.menuType].typeName,1,cache.OpenSansB2)/2,screen[2]-218,dxGetTextWidth(furnitureMenus[cache.menu][cache.menuPoint][cache.menuType].typeName,1,cache.OpenSansB2),1,tocolor(255,255,255,255))
				--dxDrawText(furnitureMenus[cache.menu][cache.menuPoint][cache.menuType].typeName,screen[1]-98,screen[2]-232,screen[1]-98,screen[2]-232,tocolor(255,255,255,255),1,cache.OpenSansB2,"center","center")
				--[[if core:isInSlot(screen[1]-35,screen[2]-248,30,30) then
					dxDrawImage(screen[1]-35,screen[2]-248,30,30,"files/icons/arrow.png",0,0,0,tocolor(124,197,118,255))
				else
					dxDrawImage(screen[1]-35,screen[2]-248,30,30,"files/icons/arrow.png",0,0,0,tocolor(255,255,255,255))
				end
				if core:isInSlot(screen[1]-190,screen[2]-248,30,30) then
					dxDrawImage(screen[1]-190,screen[2]-248,30,30,"files/icons/arrow.png",180,0,0,tocolor(124,197,118,255))
				else
					dxDrawImage(screen[1]-190,screen[2]-248,30,30,"files/icons/arrow.png",180,0,0,tocolor(255,255,255,255))
				end]]

				--local maxcount = (screen[1] / 174) - 1

				--if cache.menuPoint == 4 then
					--[[local folder = "files/images/doors";
					local count = 0
					for i = 1,#furnitureMenus[cache.menu][cache.menuPoint][cache.menuType] do
						if i > cache.wheel and count < maxcount then
							count = count+1
							dxDrawRectangle(-90 +(count*148)-5,screen[2]-170-5,128+10,154+10,tocolor(24,24,24,100))
							dxDrawImage(-90 +(count*148),screen[2]-170,128,128,folder.."/"..i..".png")
							if core:isInSlot(-90 +(count*148),screen[2]-170,128,128) or cache.selected == i then
								func.border(-90 +(count*148),screen[2]-170,128,128,4,tocolor(124,197,118,200))
							end
							dxDrawText(func.formatMoney(furnitureMenus[cache.menu][cache.menuPoint][cache.menuType][i].money).."#ffffff $",-26 +(count*148),screen[2]-25,-26 +(count*148),screen[2]-25,tocolor(124,197,118,255),1,cache.opensans,"center","center",false,false,false,true)
						end
					end]]
				--else
					local folder 
					
					if cache.menuPoint == 4 then
						folder = "files/images/doors"
					else
						folder = "files/textures/" .. furnitureMenus[cache.menu][cache.menuPoint].menu .. "/" .. furnitureMenus[cache.menu][cache.menuPoint][cache.menuType].type
					end
					
					local count = 0

					local startX = sx*0.01
					for i = 1, #furnitureMenus[cache.menu][cache.menuPoint][cache.menuType] do
						if i > cache.wheel and count < 9  then
							count = count + 1

							local hoverAlpha = 220

							if core:isInSlot(startX, sy*0.86, 90/myX*sx, 90/myY*sy) or cache.selected == i then
								dxDrawRectangle(startX-2/myX*sx, sy*0.86-3/myY*sy, 94/myX*sx, 95/myY*sy, tocolor(r, g, b, 255))
								hoverAlpha = 255
							end

							dxDrawImage(startX, sy*0.86, 90/myX*sx, 90/myY*sy, folder.."/"..i..".png", 0, 0, 0, tocolor(255, 255, 255, hoverAlpha))

							local price = func.formatMoney(furnitureMenus[cache.menu][cache.menuPoint][cache.menuType][i]).." $"
							dxDrawRectangle(startX, sy*0.86+70/myX*sx, dxGetTextWidth(price, 0.8, font:getFont("condensed", 10/myX*sx))+7/myX*sx, 20/myY*sy, tocolor(30, 30, 30, hoverAlpha))
							dxDrawText(price, startX+3/myX*sx, sy*0.86+70/myX*sx, startX+73/myX*sx, sy*0.86+90/myY*sy, tocolor(255, 255, 255, hoverAlpha), 0.8, font:getFont("condensed", 10/myX*sx), "left", "center")

							startX = startX + 95/myX*sx
						end
					end
				--end

				dxDrawRectangle(sx*0.01, sy*0.97, sx*0.542-sx*0.01, sy*0.01, tocolor(40, 40, 40, 200))

				local lineWidth = math.min(9/#furnitureMenus[cache.menu][cache.menuPoint][cache.menuType], 1)

				dxDrawRectangle(sx*0.01 + ((sx*0.542-sx*0.01)*(lineWidth*cache.wheel/9)), sy*0.97, (sx*0.542-sx*0.01)*lineWidth, sy*0.01, tocolor(r, g, b, 240))

				core:dxDrawRoundedRectangle(sx*0.005+sx*0.542 - ( (34/myX*sx)*#furnitureMenus[cache.menu][cache.menuPoint]), sy*0.805, (34/myX*sx)*#furnitureMenus[cache.menu][cache.menuPoint], sy*0.04, tocolor(30, 30, 30, 200))
				core:dxDrawRoundedRectangle(sx*0.005+sx*0.542 - ( (34/myX*sx)*#furnitureMenus[cache.menu][cache.menuPoint]) + 2/myX*sx, sy*0.805+2/myY*sy, (34/myX*sx)*#furnitureMenus[cache.menu][cache.menuPoint]-4/myX*sx, sy*0.04-4/myY*sy, tocolor(35, 35, 35, 255))

				local startX = sx*0.005+sx*0.542 - ( (34/myX*sx)*#furnitureMenus[cache.menu][cache.menuPoint]) + 2/myX*sx
				for k, v in ipairs(furnitureMenus[cache.menu][cache.menuPoint]) do 
					if core:isInSlot(startX, sy*0.81, 28/myX*sx, 28/myY*sy) or cache.menuType == k then 
						dxDrawImage(startX, sy*0.81, 28/myX*sx, 28/myY*sy, "files/icons/"..v.type..".png", 0, 0, 0, tocolor(255, 255, 255, 255))
					else
						dxDrawImage(startX, sy*0.81, 28/myX*sx, 28/myY*sy, "files/icons/"..v.type..".png", 0, 0, 0, tocolor(255, 255, 255, 170))
					end

					startX = startX + 32/myX*sx
				end 
			end
		elseif cache.menu == 2 then
			--renderCache = {}
			
			dxDrawRectangle(screen[1]-90,screen[2]/2+39,90,46,tocolor(22,22,22,220))
			if core:isInSlot(screen[1]-81,screen[2]/2+47,30,30) then
				dxDrawImage(screen[1]-81,screen[2]/2+47,30,30,"files/icons/save.png",0,0,0,tocolor(124,197,118,255))
			else
				dxDrawImage(screen[1]-81,screen[2]/2+47,30,30,"files/icons/save.png",0,0,0,tocolor(255,255,255,255))
			end
			
			if core:isInSlot(screen[1]-39,screen[2]/2+47,30,30) then
				dxDrawImage(screen[1]-39,screen[2]/2+47,30,30,"files/icons/close.png",0,0,0,tocolor(210,49,49,255))
			else
				dxDrawImage(screen[1]-39,screen[2]/2+47,30,30,"files/icons/close.png",0,0,0,tocolor(255,255,255,255))
			end
			
			for k,v in pairs(objectCache) do
				if isElement(k) and isElementOnScreen(k) and getElementData(k,"custom:type") == "floor" then
					local x0, y0, z0, x1, y1, z1 = getElementBoundingBox(k)
					local posPlayer = Vector3(getCameraMatrix())--localPlayer.position
					local pos = k.matrix
					local point = {}
					point[4] = pos:transformPosition(x1, y1, z1 + 0.01)
					local pointD = pos:transformPosition(0, y1, z1 + 0.01) -- // ez már jó
					point[4 .. "world"] = pointD
					local pointdoor = pos:transformPosition(0.77, y1+0.03, z1 + 0.01) -- // ez már jó
					point[4 .. "door"] = pointdoor
					local posX, posY = getScreenFromWorldPosition(pointD)
					local lineClear = getDistanceBetweenPoints3D(localPlayer.position, pointD) <= 3 --isLineOfSightClear(posPlayer, pointD, true, false, false, true, false, false, false, localPlayer)
					if posX and posY and lineClear then
						point[4 .. "screen"] = pointD
					end

					point[3] = pos:transformPosition(x1, -y1, z1 + 0.01)
					local pointD = pos:transformPosition(x1, 0, z1 + 0.01)
					point[3 .. "world"] = pointD
					local pointdoor = pos:transformPosition(x1-0.03, 0.77, z1 + 0.01)
					point[3 .. "door"] = pointdoor
					local posX, posY = getScreenFromWorldPosition(pointD)
					local lineClear = getDistanceBetweenPoints3D(localPlayer.position, pointD) <= 3 --isLineOfSightClear(posPlayer, pointD, true, false, false, true, false, false, false, localPlayer)
					if posX and posY and lineClear then
						point[3 .. "screen"] = pointD
					end

					point[2] = pos:transformPosition(-x1, -y1, z1 + 0.01)
					local pointD = pos:transformPosition(0, -y1, z1 + 0.01)
					point[2 .. "world"] = pointD
					local pointdoor = pos:transformPosition(0.77, -y1+0.03, z1 + 0.01)
					point[2 .. "door"] = pointdoor
					local posX, posY = getScreenFromWorldPosition(pointD)
					local lineClear = getDistanceBetweenPoints3D(localPlayer.position, pointD) <= 3 --isLineOfSightClear(posPlayer, pointD, true, false, false, true, false, false, false, localPlayer)
					if posX and posY and lineClear then
						point[2 .. "screen"] = pointD
					end

					point[1] = pos:transformPosition(-x1, y1, z1 + 0.01)
					local pointD = pos:transformPosition(-x1, 0, z1 + 0.01)
					point[1 .. "world"] = pointD
					local pointdoor = pos:transformPosition(-x1-0.03, 0.77, z1 + 0.01)
					point[1 .. "door"] = pointdoor
					local posX, posY = getScreenFromWorldPosition(pointD)
					local lineClear = getDistanceBetweenPoints3D(localPlayer.position, pointD) <= 3 --isLineOfSightClear(posPlayer, pointD, true, false, false, true, false, false, false, localPlayer)
					if posX and posY and lineClear then
						point[1 .. "screen"] = pointD
					end
				
					renderCache[k] = point
				end
			end
			
			for k,v in pairs(renderCache) do
				local point = v
				for i = 1, 4 do
					point["color"..i] = tocolor(100,100,100) 
					if point[i.."screen"] and isLineOfSightClear (Vector3(getElementPosition(localPlayer)),point[i.."world"],true,false,false,true,false,false,false) then
						local pointD = point[i.."world"]
						local posX, posY = getScreenFromWorldPosition(pointD)
						if posX and posY then
							if cache.menuPoint == 1 or cache.menuPoint == 3 then 
								if core:isInSlot(posX - 20/2, posY - 20/2, 25, 25) then
									point["color"..i] = tocolor(124,197,118)
									dxDrawImage(posX - 20/2, posY - 20/2, 30, 30,'files/click.png', 0, 0, 0, tocolor(124,197,118, 255))
								else
									dxDrawImage(posX - 20/2, posY - 20/2, 25, 25,'files/click.png', 0, 0, 0, tocolor(200,200,200, 255))
								end
							end
						end
					end
					local i2 = i + 1
					if i2 > 4 then i2 = 1 end
					dxDrawLine3D(point[i], point[i2], point["color"..i], 1)
				end
			end
			
			for i = 1,#furnitureMenus[cache.menu] do
				local name = furnitureMenus[cache.menu][i].name;
				if core:isInSlot(screen[1]-97 -dxGetTextWidth(name,1,cache.opensans)/2,screen[2]-195-170+(i*22),dxGetTextWidth(name,1,cache.opensans),20) or cache.menuPoint == i then
					dxDrawText(name,screen[1]-97,screen[2]-195-160+(i*22),screen[1]-97,screen[2]-195-160+(i*22),tocolor(124,197,118,255),1,cache.opensans,"center","center")
				else
					dxDrawText(name,screen[1]-97,screen[2]-195-160+(i*22),screen[1]-97,screen[2]-195-160+(i*22),tocolor(255,255,255,255),1,cache.opensans,"center","center")
				end
			end
			
			dxDrawText("Eddig fizetendő:\n#7cc576"..func.formatMoney(cache.wall.cash).."#ffffff $",screen[1]-92,screen[2]-195-10,screen[1]-92,screen[2]-195-10,tocolor(255,255,255,255),1,cache.opensans,"center","center",false,false,false,true)			
		elseif cache.menu == 3 then
			--createBlur(0,screen[2]-195,screen[1]-195,195,255)
			dxDrawRectangle(0,screen[2]-195,screen[1]-195,195,tocolor(22,22,22,220))
			dxDrawRectangle(0,screen[2]-195-46,90,46,tocolor(22,22,22,220))

			dxDrawRectangle(0,screen[2]-195,32,195,tocolor(24,24,24,100))
			dxDrawRectangle(screen[1]-195-32,screen[2]-195,32,195,tocolor(24,24,24,100))
			
			if core:isInSlot(8,screen[2]-195-38,30,30) then
				dxDrawImage(8,screen[2]-195-38,30,30,"files/icons/save.png",0,0,0,tocolor(124,197,118,255))
			else
				dxDrawImage(8,screen[2]-195-38,30,30,"files/icons/save.png",0,0,0,tocolor(255,255,255,255))
			end
			
			if core:isInSlot(52,screen[2]-195-38,30,30) then
				dxDrawImage(52,screen[2]-195-38,30,30,"files/icons/close.png",0,0,0,tocolor(210,49,49,255))
			else
				dxDrawImage(52,screen[2]-195-38,30,30,"files/icons/close.png",0,0,0,tocolor(255,255,255,255))
			end
			
			if core:isInSlot(screen[1]-195-32,screen[2]-195,32,195) then
				dxDrawImage(screen[1]-225,screen[2]-108,28,28,"files/icons/arrow.png",0,0,0,tocolor(124,197,118,255))
			else
				dxDrawImage(screen[1]-225,screen[2]-108,28,28,"files/icons/arrow.png",0,0,0,tocolor(255,255,255,255))
			end
			
			if core:isInSlot(0,screen[2]-195,32,195) then
				dxDrawImage(1,screen[2]-108,28,28,"files/icons/arrow.png",180,0,0,tocolor(124,197,118,255))
			else
				dxDrawImage(1,screen[2]-108,28,28,"files/icons/arrow.png",180,0,0,tocolor(255,255,255,255))
			end
			
			local count = 0
			local folder = "files/images/doors"
			for i = 1,#doors do
				count = count+1
				dxDrawRectangle(-90 +(count*148),screen[2]-42,128,26,tocolor(80,80,80,100))
				dxDrawRectangle(-90 +(count*148),screen[2]-170,128,128,tocolor(100,100,100,100))
				dxDrawImage(-90 +(count*148),screen[2]-170+10,128,128-20,folder.."/"..doors[i].model..".png")
				if core:isInSlot(-90 +(count*148),screen[2]-170,128,128) or cache.selectedDoor == i then
					func.border(-90 +(count*148),screen[2]-170,128,128,1,tocolor(124,197,118,200))
				end
				dxDrawText(func.formatMoney(doors[i].money).."#ffffff $",-26 +(count*148),screen[2]-29,-26 +(count*148),screen[2]-29,tocolor(124,197,118,255),1,cache.opensans,"center","center",false,false,false,true)
			end
			
			local playerX,playerY,playerZ = getElementPosition(localPlayer)
			local objectX,objectY,objectZ = getElementPosition(cache.hover.door)
			
			local scr = {getScreenFromWorldPosition(objectX,objectY-0.74,objectZ+1.4)};
			local distance = getDistanceBetweenPoints3D(objectX,objectY,objectZ,playerX,playerY,playerZ)
			local size = distance/2
			if scr[1] or scr[2] then
				if core:isInSlot(scr[1]+size/2,scr[2]+size/2,50-size,50-size) or cache.move.door.state == "right" then
					dxDrawImage(scr[1]+size/2,scr[2]+size/2,50-size,50-size,"files/icons/move-arrow.png",0,0,0,tocolor(124,197,118,255))
				else
					dxDrawImage(scr[1]+size/2,scr[2]+size/2,50-size,50-size,"files/icons/move-arrow.png",0,0,0,tocolor(255,255,255,255))
				end
				
				if core:isInSlot(scr[1]+size/2-58,scr[2]+size/2,50-size,50-size) or cache.move.door.state == "left" then
					dxDrawImage(scr[1]+size/2-58,scr[2]+size/2,50-size,50-size,"files/icons/move-arrow.png",180,0,0,tocolor(124,197,118,255))
				else
					dxDrawImage(scr[1]+size/2-58,scr[2]+size/2,50-size,50-size,"files/icons/move-arrow.png",180,0,0,tocolor(255,255,255,255))
				end
			end
			
			if not isCursorShowing() then
				if cache.move.door.state ~= "" then
					local pos = cache.hover.door.position
					
					if cache.move.door.state == "right" then
						cache.move.progress = cache.move.progress+0.01
						cache.move.posY = pos.y+0.01
					elseif cache.move.door.state == "left" then
						cache.move.progress = cache.move.progress-0.01
						cache.move.posY = pos.y-0.01
					end
					setElementPosition(cache.hover.door,pos.x,cache.move.posY,pos.z)
				end
			end
		end
	end
end
addEventHandler("onClientRender",getRootElement(),func.render)

func.onKey = function(button,state)
	if button == "mouse1" and not state then
		if cache.menu == 3 and cache.hover.door then
			if cache.move.door.state ~= "" then
				local markerElement = func.findMarkerElement(getElementInterior(localPlayer),getElementDimension(localPlayer));
				if markerElement then
					local x,y,z = getElementPosition(markerElement)
					setElementPosition(markerElement,x,y+cache.move.progress,z)
				end
				cache.move.progress = 0;
				showCursor(true);
				cache.move.door.state = "";
			end
		end
	elseif button == "mouse_wheel_down" and state then 
		if cache.menu == 1 then
			if cache.menuPoint > 0 and cache.menuType > 0 then
				if core:isInSlot(sx*0.005, sy*0.85, sx*0.542, sy*0.14) then
					cache.wheel = cache.wheel + 1
					if cache.wheel > #furnitureMenus[cache.menu][cache.menuPoint][cache.menuType] - 9 then
						cache.wheel = #furnitureMenus[cache.menu][cache.menuPoint][cache.menuType] - 9
					end
				end
			end
		end
	elseif button == "mouse_wheel_up" and state then 
		if cache.menu == 1 then
			if cache.menuPoint > 0 and cache.menuType > 0 then
				if core:isInSlot(sx*0.005, sy*0.85, sx*0.542, sy*0.14) then
					if cache.wheel > 0 then 
						cache.wheel = cache.wheel - 1
					end
				end
			end
		end
	end
end
addEventHandler("onClientKey",getRootElement(),func.onKey)

func.click = function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if button == "left" and state == "down" then
		if getElementDimension(localPlayer) > 0 and exports["oInteriors"]:isInteriorOwner(getElementDimension(localPlayer)) then
			for v,k in pairs(objectCache) do
				if (getElementModel(v) == 1502 or getElementModel(v) == 1491) and getElementData(v,"custom:type") == "door" then
					local matrix1 = Vector3(unpack(getElementData(v,"custom:matrix1")))
					if matrix1 then
						local disc1 = getDistanceBetweenPoints3D(matrix1,localPlayer.position);
						if disc1 <= 0.4 then
							if core:isInSlot(screen[1]/2-24,screen[2]-194,48,48) then
								setElementData(v,"door:locked",not getElementData(v,"door:locked"))
								if getElementData(v,"door:locked") then
									setElementFrozen(v,true)
									setElementRotation(v,getElementRotation(v))
									interiorObjects[getElementData(v,"custom:dbid")].doorLock = true;
									triggerServerEvent("changeWalldoorLock",localPlayer,localPlayer,getElementDimension(localPlayer),getElementData(v,"custom:dbid"),getElementInterior(localPlayer),true)
								else
									setElementFrozen(v,false)
									interiorObjects[getElementData(v,"custom:dbid")].doorLock = false;
									triggerServerEvent("changeWalldoorLock",localPlayer,localPlayer,getElementDimension(localPlayer),getElementData(v,"custom:dbid"),getElementInterior(localPlayer),false)
								end
							end
						end
					end
					
					local matrix2 = Vector3(unpack(getElementData(v,"custom:matrix2")))
					if matrix2 then
						local disc2 = getDistanceBetweenPoints3D(matrix2,localPlayer.position);
						if disc2 <= 0.4 then
							if core:isInSlot(screen[1]/2-24,screen[2]-194,48,48) then
								setElementData(v,"door:locked",not getElementData(v,"door:locked"))
								if getElementData(v,"door:locked") then
									setElementFrozen(v,true)
									setElementRotation(v,getElementRotation(v))
									interiorObjects[getElementData(v,"custom:dbid")].doorLock = true;
									triggerServerEvent("changeWalldoorLock",localPlayer,localPlayer,getElementDimension(localPlayer),getElementData(v,"custom:dbid"),getElementInterior(localPlayer),true)
								else
									setElementFrozen(v,false)
									interiorObjects[getElementData(v,"custom:dbid")].doorLock = false;
									triggerServerEvent("changeWalldoorLock",localPlayer,localPlayer,getElementDimension(localPlayer),getElementData(v,"custom:dbid"),getElementInterior(localPlayer),false)
								end
							end
						end
					end
				end
			end
		end
	end

	if getElementData(localPlayer,"interior:editing") then
		if button == "left" and state == "down" then
			local startX = sx*0.01
			for k, v in ipairs(toolMenuButtons) do 
				local iconValue = 0 

				if v.event == "setroofshowing" then 
					iconValue = roofState
				end

				if core:isInSlot(startX, sy*0.015, 25/myX*sx, 25/myY*sy) then 
					if iconValue == 0 then 
						setOccupiedInteriorRoofShowing(true)
					else
						setOccupiedInteriorRoofShowing(false)
					end
				end
			end

			for i = 1,#furnitureMenus do
				local name = furnitureMenus[i].name;
				if core:isInSlot(screen[1]-10 -dxGetTextWidth(name,1,cache.OpenSansEB),screen[2]-195-275+2+(i*28),dxGetTextWidth(name,1,cache.OpenSansEB),16) then
					if cache.menu ~= i and cache.menu ~= 2 then
						cache.menu = i
						cache.menuPoint = 0;
						cache.menuType = 1;
						cache.wheel = 0;
						if cache.hover.door then
							cache.hover.door = nil;
						end
						if cache.hover.object then
							cache.hover.object:destroyOutline();
							cache.hover.object = nil
							cache.selected = 0;
						end
						if cache.menu == 3 then
							if not cache.hover.door then
								for v,k in pairs(objectCache) do
									if getElementData(v,"custom:default:door") then
										cache.hover.door = v;
									end
								end
							end
						elseif cache.menu == 2 then
							--amikor megnyitja a felhúzást
							cache.menuPoint = 1;
						end
					end
				end
			end
			
			if cache.menu == 1 then
				if cache.menuPoint > 0 and cache.menuType > 0 then
					local startX = sx*0.005+sx*0.542 - ( (34/myX*sx)*#furnitureMenus[cache.menu][cache.menuPoint]) + 2/myX*sx
					for k, v in ipairs(furnitureMenus[cache.menu][cache.menuPoint]) do 
						if core:isInSlot(startX, sy*0.81, 28/myX*sx, 28/myY*sy) then 
							cache.menuType = k
							cache.wheel = 0
						end

						startX = startX + 32/myX*sx
					end 
					
					if cache.hover.object then
						if core:isInSlot(8,screen[2]-195-38,30,30) then
							if cache.selected > 0 then
								if furnitureMenus[cache.menu][cache.menuPoint][cache.menuType][cache.selected] then
									if getElementData(cache.hover.object,"custom:texid") ~= cache.selected then
										local folder1 = furnitureMenus[cache.menu][cache.menuPoint].menu;
										local folder2 = furnitureMenus[cache.menu][cache.menuPoint][cache.menuType].type;
										local texture = cache.shader;
										if texturedObjects[cache.hover.object] then
											removeObjectTextureC(cache.hover.object,texture)
										end

										local eX,eY,eZ = getElementPosition(cache.hover.object)
										local pX,pY,pZ = getElementPosition(localPlayer)
										local rot = func.findRotation(eX,eY,pX,pY)

										local textureDatas = getElementData(cache.hover.object, "custom:textureDatas") or {}

										textureDatas[texture] = {folder1, folder2, cache.selected}
									
										triggerServerEvent("updateInteriorObjectTexture", localPlayer, localPlayer, getElementDimension(localPlayer), tonumber(getElementData(cache.hover.object,"custom:dbid")), textureDatas)
										cache.hover.object:destroyOutline();
										cache.hover.object = nil
										return
									else
										outputChatBox("Ez a fajta már rajta van.")
									end
								end
							end
						elseif core:isInSlot(52,screen[2]-195-38,30,30) then
							if texturedObjects[cache.hover.object] then
								if getElementData(cache.hover.object,"custom:texture") == "" then
									removeObjectTextureC(cache.hover.object,cache.shader)
								else
									setObjectTextureC(cache.hover.object,getElementData(cache.hover.object,"custom:texture"),getElementData(cache.hover.object,"custom:folder"))
								end
							end
							cache.selected = 0;
							cache.hover.object:destroyOutline();
							cache.hover.object = nil
							
							cache.menuPoint = 0
							cache.menuType = 1;
							cache.wheel = 0;
							return
						end
						
						if cache.menuPoint == 4 then
							local folder = "files/textures/"..furnitureMenus[cache.menu][cache.menuPoint].menu.."/"..furnitureMenus[cache.menu][cache.menuPoint][cache.menuType].type;
							local count = 0
							for i = 1,#furnitureMenus[cache.menu][cache.menuPoint][cache.menuType] do
								if i > cache.wheel and count < 11 then
									count = count+1
									if core:isInSlot(-90 +(count*148),screen[2]-170,128,128) then
										if  cache.selected ~= i then
											cache.selected = i
											if cache.hover.object then
												if getElementModel(cache.hover.object) ~= furnitureMenus[cache.menu][cache.menuPoint][cache.menuType][cache.selected].model then
													setElementModel(cache.hover.object,furnitureMenus[cache.menu][cache.menuPoint][cache.menuType][cache.selected].model)
												end
												if furnitureMenus[cache.menu][cache.menuPoint][cache.menuType][cache.selected].isTextured then
													removeObjectTextureC(cache.hover.object)
													setObjectTextureC(cache.hover.object,furnitureMenus[cache.menu][cache.menuPoint][cache.menuType][cache.selected].texname,folder.."/"..cache.selected)
												else
													removeObjectTextureC(cache.hover.object)
												end
											end
										end
									end
								end
							end
						else
							local count = 0
							local startX = sx*0.01

							for i = 1, #furnitureMenus[cache.menu][cache.menuPoint][cache.menuType] do
								if i > cache.wheel and count < 9  then
									count = count + 1

									if core:isInSlot(startX, sy*0.86, 90/myX*sx, 90/myY*sy) or cache.selected == i then
										if cache.selected ~= i then
											if getElementData(cache.hover.object,"isCustom") --[[and getElementData(cache.hover.object,"custom:default")]] then
												cache.selected = i
												folder = "files/textures/" .. furnitureMenus[cache.menu][cache.menuPoint].menu .. "/" .. furnitureMenus[cache.menu][cache.menuPoint][cache.menuType].type .. "/" .. i
												if texturedObjects[cache.hover.object] then
													removeObjectTextureC(cache.hover.object)
												end
												
												local shader = "b"
												if getElementData(cache.hover.object,"custom:type") == furnitureMenus[cache.menu][cache.menuPoint].menu then
													if getElementData(cache.hover.object,"custom:type") == "floor" then
														shader = "a"
													elseif getElementData(cache.hover.object,"custom:type") == "roof" then
														shader = "a"
													elseif getElementData(cache.hover.object,"custom:type") == "wall" then
														shader = func.getTextureFromDistance(cache.hover.object)
													end
													cache.shader = shader
													setObjectTextureC(cache.hover.object, shader,folder)
												end
											end
										end
									end

									startX = startX + 95/myX*sx
								end
							end
						end
					end
					
				end	
				if clickedElement and objectCache[clickedElement] then
					if getElementData(clickedElement,"isCustom") --[[and getElementData(clickedElement,"custom:default")]] then
						if core:isInSlot(screen[1]-195,screen[2]-195-260,195,screen[2]) then
						else
							if core:isInSlot(0,screen[2]-195,screen[1]-195,195) and cache.menuPoint > 0 and cache.menuType > 0 then
							elseif core:isInSlot(0,screen[2]-195-46,90,46) and cache.menuPoint > 0 and cache.menuType > 0 then
							else

								if cache.hover.object then
									cache.selected = 0;
									if texturedObjects[cache.hover.object] then
										if getElementData(cache.hover.object,"custom:texture") == "" then
											removeObjectTextureC(cache.hover.object)
										else
											setObjectTextureC(cache.hover.object,getElementData(cache.hover.object,"custom:texture"),getElementData(cache.hover.object,"custom:folder"))
										end
									end;
									cache.hover.object:destroyOutline()
									cache.hover.object = nil
									cache.menuPoint = 0
									cache.menuType = 1;
									cache.wheel = 0;
								end
								if not cache.hover.object then
									cache.hover.object = clickedElement
									cache.hover.object:createOutline({210,49,49, 255})
									local thisSelected = 0
									if getElementData(clickedElement,"custom:type") == "floor" then
										thisSelected = 1
									elseif getElementData(clickedElement,"custom:type") == "wall" then
										thisSelected = 3
									elseif getElementData(clickedElement,"custom:type") == "roof" then
										thisSelected = 2
									elseif getElementData(clickedElement,"custom:type") == "door" then
										thisSelected = 4
									end
									
									if cache.menuPoint ~= thisSelected then
										cache.menuPoint = thisSelected
										cache.menuType = 1;
										cache.wheel = 0;
									end
								end
							end
						end
					end
				end
			elseif cache.menu == 2 then
				for k,v in pairs(renderCache) do
					local point = v
					for i = 1, 4 do
						if point[i.."screen"] and isLineOfSightClear (Vector3(getElementPosition(localPlayer)),point[i.."world"],true,false,false,true,false,false,false) then
							local pointD = point[i.."world"]
							local posX, posY = getScreenFromWorldPosition(pointD)
							if posX and posY then
								if core:isInSlot(posX - 20/2, posY - 20/2, 20, 20) then
									local newI = i
									if i == 3 then newI = 2 end
									if i == 2 then newI = 1 end
									if i == 1 then newI = 2 end 
									if i == 4 then newI = 1 end
									local _pointD = pointD
									local pointdoor = point[i.."door"]
									--local pointDoor = pointD
									local pointD = point[newI.."world"]
									if pointD then
										local rot = func.findRotation(pointD.x, pointD.y, k.position.x, k.position.y)
										local object = createObject(furnitureMenus[cache.menu][cache.menuPoint].model,_pointD.x,_pointD.y,_pointD.z+1.74)
										setElementRotation(object, 0, 0, rot) 
										setElementInterior(object,localPlayer.interior)
										setElementDimension(object,localPlayer.dimension)
										notTriggered[object] = true;
										local money = 600;
										if cache.menuPoint == 3 then
											money = 820;
											local door = createObject(furnitureMenus[cache.menu][cache.menuPoint][cache.selected].model,pointdoor.x,pointdoor.y,pointdoor.z-0.01)
											setElementRotation(door, 0, 0, rot-90) 
											setElementInterior(door,localPlayer.interior)
											setElementDimension(door,localPlayer.dimension)
											notTriggered[door] = true;
										end
										cache.wall.cash = cache.wall.cash+money;
										return
									end
								end
							end
						end
						local i2 = i + 1
						if i2 > 4 then i2 = 1 end
					end
				end
				
				if core:isInSlot(screen[1]-84,screen[2]/2+47,30,30) then
					if notTriggered then
						outputChatBox("create new wall")
						cache.menu = 1;
						cache.menuPoint = 0;
						cache.menuType = 1;
						cache.wheel = 0;
						
						local serverCache = {};
						for v,k in pairs(notTriggered) do
							if v and getElementModel(v) and getElementModel(v) > 0 then
								local pos = Vector3(getElementPosition(v));
								local rot = Vector3(getElementRotation(v));
								local typ = "wall";
								if getElementModel(v) == 1502 or getElementModel(v) == 1491 then
									typ = "door";
								end
								serverCache[#serverCache+1] = {
									x = pos.x;
									y = pos.y;
									z = pos.z;
									rx = rot.x;
									ry = rot.y;
									rz = rot.z;
									interior = getElementInterior(v);
									dimension = getElementDimension(v);
									model = getElementModel(v);
									type = typ;
								};
							end
						end
						triggerServerEvent("createInteriorWalls",localPlayer,localPlayer,getElementDimension(localPlayer),getElementInterior(localPlayer),serverCache)
						for v,k in pairs(notTriggered) do
							destroyElement(v);
							notTriggered[v] = nil;
						end
						
					end
				end
				
				if core:isInSlot(screen[1]-39,screen[2]/2+47,30,30) then
					cache.menu = 1;
					cache.menuPoint = 0;
					cache.menuType = 1;
					cache.wheel = 0;
					for v,k in pairs(notTriggered) do
						destroyElement(v);
						notTriggered[v] = nil;
					end
				end
				
				for i = 1,#furnitureMenus[cache.menu] do
					local name = furnitureMenus[cache.menu][i].name;
					if core:isInSlot(screen[1]-97 -dxGetTextWidth(name,1,cache.opensans)/2,screen[2]-195-170+(i*22),dxGetTextWidth(name,1,cache.opensans),20) then
						if i ~= 2 then
							if cache.menuPoint ~= i then
								cache.menuPoint = i
								if i == 3 then
									cache.selected = 1;
								end
							end
						else
							cache.menuPoint = 2
						end
					end
				end
				
				if cache.menuPoint == 3 then
					if core:isInSlot(screen[1]-195-32,screen[2]-195,32,195) then
						
					end
					
					if core:isInSlot(0,screen[2]-195,32,195) then
						
					end
				
					local count = 0
					for i = 1,#furnitureMenus[cache.menu][cache.menuPoint] do
						if i > cache.wheel and count < 11 then
							count = count+1
							if core:isInSlot(-90 +(count*148),screen[2]-170,128,128) then
								if cache.selected ~= i then
									cache.selected = i
								end
							end
						end
					end
					
					if core:isInSlot(0,screen[2]-195,32,195) then
						cache.wheel = cache.wheel - 1
						if cache.wheel < 1 then
							cache.wheel = 0
						end
					elseif core:isInSlot(screen[1]-195-32,screen[2]-195,32,195) then
						cache.wheel = cache.wheel + 1
						if cache.wheel > #furnitureMenus[cache.menu][cache.menuPoint] - 11 then
							cache.wheel = #furnitureMenus[cache.menu][cache.menuPoint] - 11
						end
					end
					
				end
				
			elseif cache.menu == 3 then
				local count = 0
				for i = 1,#doors do
					count = count+1
					if core:isInSlot(-90 +(count*148),screen[2]-170,128,128) then
						if cache.selectedDoor ~= i then
							cache.selectedDoor = i;
							setElementModel(cache.hover.door,doors[cache.selectedDoor].model)
						end
					end
				end
			
				if core:isInSlot(8,screen[2]-195-38,30,30) then
					local marker = func.findMarkerElement(getElementInterior(localPlayer),getElementDimension(localPlayer));
					if marker then
						local markerX,markerY,markerZ = getElementPosition(marker);
						local doorX,doorY,doorZ = getElementPosition(cache.hover.door);
						triggerServerEvent("updateDefaultDoor",localPlayer,localPlayer,getElementDimension(localPlayer),getElementData(cache.hover.door,"custom:dbid"),marker,markerX,markerY,markerZ,doorX,doorY,doorZ,getElementModel(cache.hover.door))
					end
				end
				
				if core:isInSlot(52,screen[2]-195-38,30,30) then
					if cache.selectedDoor > 0 then
						cache.selectedDoor = 0;
						setElementModel(cache.hover.door,getElementData(cache.hover.door,"custom:door:model"))
					end
						local x,y,z = unpack(getElementData(cache.hover.door,"custom:door:pos"));
						setElementPosition(cache.hover.door,x,y,z)
						--cache.move.progress
						
						local markerElement = func.findMarkerElement(getElementInterior(localPlayer),getElementDimension(localPlayer));
						if markerElement then
							local x,y,z = getElementData(markerElement,"x"),getElementData(markerElement,"y"),getElementData(markerElement,"z")
							setElementPosition(markerElement,x,y-cache.move.progress,z-1.45)
						end
					cache.move.progress = 0;
					cache.move.door.state = ""
					cache.menu = 1;
					cache.menuPoint = 0;
					cache.menuType = 1;
					cache.hover.door = nil;
					return
				end
			
				local playerX,playerY,playerZ = getElementPosition(localPlayer)
				local objectX,objectY,objectZ = getElementPosition(cache.hover.door)
				
				local scr = {getScreenFromWorldPosition(objectX,objectY-0.74,objectZ+1.4)};
				local distance = getDistanceBetweenPoints3D(objectX,objectY,objectZ,playerX,playerY,playerZ)
				local size = distance/2
				if scr[1] or scr[2] then
					cache.move.door.state = "";
					if core:isInSlot(scr[1]+size/2,scr[2]+size/2,50-size,50-size) then
						cache.move.door.state = "right";
						showCursor(false)
						cache.move.posY = objectY
					end
					
					if core:isInSlot(scr[1]+size/2-58,scr[2]+size/2,50-size,50-size) then
						cache.move.door.state = "left";
						showCursor(false)
						cache.move.posY = objectY
					end
				end
			end
		end
	end
end
addEventHandler("onClientClick",getRootElement(),func.click)

func.editInterior = function()
	if getElementData(localPlayer,"user:loggedin") then

		if getElementInterior(localPlayer) == 23 or getElementDimension(localPlayer) > 0 then

			local state,owner = exports["oInteriors"]:findInteriorOwnerByDbid(getElementDimension(localPlayer));
			if state and owner == getElementData(localPlayer,"char:id") then
				if getElementData(localPlayer,"interior:editing") then
					setFreecamDisabled()
					setElementData(localPlayer,"interior:editing",false)
					triggerEvent("setHudComponentsVisible", localPlayer, true)
					showChat(true)
					exports.oInterface:toggleHud(false)

					setCameraTarget(localPlayer, localPlayer)

					setOccupiedInteriorRoofShowing(true)
				else

					setElementData(localPlayer,"interior:editing",true)
					triggerEvent("setHudComponentsVisible", localPlayer, false)
					showChat(false)
					exports.oInterface:toggleHud(true)

					setFreecamEnabled(getElementPosition(localPlayer))

					setOccupiedInteriorRoofShowing(false)
				end
			else
				outputChatBox("Ezt az interiort te nem tudod szerkeszteni.")
			end

		end
	end
end
addCommandHandler("customizing",func.editInterior)

roofState = 0
function setOccupiedInteriorRoofShowing(state)
	if state then roofState = 1 else roofState = 0 end
	for k, v in pairs(objectCache) do
		if getElementData(k, "custom:type") == "roof" then 
			if state then 
				setElementAlpha(k, 255)
			else
				setElementAlpha(k, 0)
			end

			setElementCollisionsEnabled(k, state)
		end 
	end
end

func.updateInteriorObjectTex = function(data, id, newtable)
	if interiorObjects and interiorObjects[id] then

		interiorObjects[id] = {
			id = data.id;
			x = data.x;
			y = data.y;
			z = data.z;
			rx = data.rx;
			ry = data.ry;
			rz = data.rz;
			interior = data.interior;
			dimension = data.dimension;

			model = data.model;
			type = data.type;
			isdefault = data.isdefault;
			defaultdoor = data.defaultdoor;

			textureDatas = data.textureDatas;
		}

		for v,k in pairs(objectCache) do
			if getElementData(v,"custom:dbid") == id then

				for k2, v2 in pairs(newtable) do 
					local folder = "files/textures/" .. v2[1] .. "/" .. v2[2] .. "/" .. v2[3]

					setObjectTextureC(v,tex,folder)

					setElementData(v, "custom:textureDatas", newtable) -- Új | Új Vége

					--[[setElementData(v,"custom:folder",folder)
					setElementData(v,"custom:texid",data.texID)
					setElementData(v,"custom:texture",data.texture)]]
				end
			end
		end
	end
end
addEvent("updateInteriorObjectTex",true)
addEventHandler("updateInteriorObjectTex",getRootElement(),func.updateInteriorObjectTex)

func.findMarkerElement = function(interior,dimension)
	for k,v in ipairs(getElementsByType("marker")) do
		if getElementData(v,"isIntOutMarker") and getElementData(v,"owner") == getElementData(localPlayer,"accountID") and getElementInterior(v) == interior and getElementDimension(v) == dimension then
			return v;
		end
	end
	return nil;
end

func.formatMoney = function(amount)
    local formatted = amount
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1 %2')
        if (k==0) then
            break
        end
    end
    return formatted
end

func.border = function(x, y, w, h, radius, color)
    dxDrawRectangle(x - radius, y, radius, h, color)
    dxDrawRectangle(x + w, y, radius, h, color)
    dxDrawRectangle(x - radius, y - radius, w + (radius * 2), radius, color)
    dxDrawRectangle(x - radius, y + h, w + (radius * 2), radius, color)
end

func.findRotation = function( x1, y1, x2, y2 ) 
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end