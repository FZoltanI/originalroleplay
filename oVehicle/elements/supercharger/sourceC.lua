txd = engineLoadTXD ( "elements/supercharger/block1.txd" )
engineImportTXD ( txd, 9501 )
dff = engineLoadDFF ( "elements/supercharger/block1.dff" )
engineReplaceModel ( dff, 9501 )

local scpos = {
    [402] = {x = 0, y = 1.75, z = 0.2, rx = -8.92, ry = 0.5, rz = 0},
    [527] = {x = 0, y = 1.61, z = 0.11, rx = -8.92, ry = 0.5, rz = 0},
    [540] = {x = 0, y = 1.665, z = 0.38, rx = -5, ry = 0.5, rz = 0},
    [526] = {x = 0, y = 1.56, z = 0.27, rx = -8.92, ry = 0.5, rz = 0},
    [534] = {x = 0, y = 1.42, z = 0.145, rx = -2.5, ry = 0.5, rz = 0},
}
local cache = {}

addEventHandler( "onClientResourceStart",  getResourceRootElement(getThisResource()),
    function ( )
        local stream = getElementsByType ( 'vehicle',getRootElement(), true)
        for k,source in  pairs(stream) do
            if getElementType( source ) == "vehicle" then
                if scpos[getElementModel(source)] then
                    if getElementData(source,'veh:sc') then
                        cache[getElementData(source,'veh:id')] = createObject(9501,0,0,15000)
                        setElementCollisionsEnabled(cache[getElementData(source,'veh:id')],false)
                        attachElements(cache[getElementData(source,'veh:id')],source,scpos[getElementModel(source)].x,scpos[getElementModel(source)].y,scpos[getElementModel(source)].z, scpos[getElementModel(source)].rx,scpos[getElementModel(source)].ry,scpos[getElementModel(source)].rz)
                    end
                end
            end
        end
    end
);


addEventHandler( "onClientElementStreamIn", root,
    function ( )
        if getElementType( source ) == "vehicle" then
            if scpos[getElementModel(source)] then
                if getElementData(source,'veh:sc') then
                    cache[getElementData(source,'veh:id')] = createObject(9501,0,0,15000)
                    setElementCollisionsEnabled(cache[getElementData(source,'veh:id')],false)
                    attachElements(cache[getElementData(source,'veh:id')],source,scpos[getElementModel(source)].x,scpos[getElementModel(source)].y,scpos[getElementModel(source)].z, scpos[getElementModel(source)].rx,scpos[getElementModel(source)].ry,scpos[getElementModel(source)].rz)
                end
            end
        end
    end
);


addEventHandler( "onClientElementStreamOut", root,
    function ( )
        if getElementType( source ) == "vehicle" then
            if scpos[getElementModel(source)] then
                if getElementData(source,'veh:sc') then
                    if cache[getElementData(source,'veh:id')] then
                        destroyElement(cache[getElementData(source,'veh:id')])
                        cache[getElementData(source,'veh:id')] = false
                    end
                end
            end
        end
    end
);

function scoreChangeTracker(theKey, oldValue, newValue)
    if (getElementType(source) == "vehicle") and (theKey == "veh:sc") then
        if (newValue == true) then
            if scpos[getElementModel(source)] then
                if getElementData(source,'veh:sc') then
                    cache[getElementData(source,'veh:id')] = createObject(9501,0,0,15000)
                    setElementCollisionsEnabled(cache[getElementData(source,'veh:id')],false)
                    attachElements(cache[getElementData(source,'veh:id')],source,scpos[getElementModel(source)].x,scpos[getElementModel(source)].y,scpos[getElementModel(source)].z, scpos[getElementModel(source)].rx,scpos[getElementModel(source)].ry,scpos[getElementModel(source)].rz)
                end
            end
        elseif newValue == false then
            if scpos[getElementModel(source)] then
                --if getElementData(source,'veh:sc') then
                    if cache[getElementData(source,'veh:id')] then
                        destroyElement(cache[getElementData(source,'veh:id')])
                        cache[getElementData(source,'veh:id')] = false
                    end
                --end
            end
        end
    end
end
addEventHandler("onClientElementDataChange", root, scoreChangeTracker)