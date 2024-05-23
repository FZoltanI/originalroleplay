local safes = {};

func.safe.start = function()
	for k,v in ipairs(getElementsByType("object")) do
		if getElementData(v,"object:dbid") and getElementDimension(localPlayer) == getElementDimension(v) and getElementInterior(localPlayer) == getElementInterior(v) and getElementModel(v) == 2332 then
            if not safes[v] then
				safes[v] = true;
			end
        end
	end
end
addEventHandler("onClientResourceStart",resourceRoot,func.safe.start)

func.safe.streamOut = function()
    if getElementType(source) == "object" and getElementData(source, "object:dbid") and getElementModel(source) == 2332 then
        safes[source] = nil;
    end
end
addEventHandler("onClientElementStreamOut",getRootElement(),func.safe.streamOut)

func.safe.streamIn = function()
    if getElementType(source) == "object" and getElementData(source, "object:dbid") and getElementDimension(localPlayer) == getElementDimension(source) and getElementInterior(localPlayer) == getElementInterior(source) and getElementModel(source) == 2332 then
        if not safes[source] then
            safes[source] = true;
        end
    end
end
addEventHandler("onClientElementStreamIn",getRootElement(),func.safe.streamIn)

func.safe.destroy = function()
    if getElementType(source) == "object" and getElementData(source, "object:dbid") and getElementDimension(localPlayer) == getElementDimension(source) and getElementInterior(localPlayer) == getElementInterior(source) and getElementModel(source) == 2332 then
        if safes[source] then
            safes[source] = nil;
        end
    end
end
addEventHandler("onClientElementDestroy", getRootElement(),func.safe.destroy)

func.safe.render = function()
	if cache.safe.show then
		local pX,pY,pZ, _, _, _ = getCameraMatrix()
		for v,k in pairs(safes) do
			if isElementStreamedIn(v) then
				local safeX,safeY,safeZ = getElementPosition(v)
				local x,y = getScreenFromWorldPosition(safeX, safeY, safeZ+1)
				local distance = getDistanceBetweenPoints3D(safeX, safeY, safeZ, pX, pY, pZ)
				if distance <= 30 then
					local line = isLineOfSightClear(safeX, safeY, safeZ+1, pX, pY, pZ, true, true, false, true, false, false, false, localPlayer)
					if line then
						if x or y then
							core:dxDrawShadowedText("["..getElementData(v,"object:dbid").."]",x,y,x,y,tocolor(r,g,b,255),tocolor(0,0,0,255),1.3,"default-bold","center","center")
						end
					end
				end
			end
		end
	end
end

func.safe.nearby = function()
	if getElementData(localPlayer,"user:admin") >= 3 then
		cache.safe.show = not cache.safe.show
		if cache.safe.show then
			addEventHandler("onClientRender",getRootElement(),func.safe.render)
			outputChatBox(core:getServerPrefix("server", "Inventory", 3).."Széf információ megjelenítve.",0,0,0,true)
		else
			removeEventHandler("onClientRender",getRootElement(),func.safe.render)
			outputChatBox(core:getServerPrefix("server", "Inventory", 3).."Széf információ eltüntetve.",0,0,0,true)
		end
	end
end
addCommandHandler("nearbysafe",func.safe.nearby)