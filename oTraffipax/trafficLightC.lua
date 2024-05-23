local trafficLightCols = {}

local trafficLigthModels = {
    [3855] = true,
    [1283] = true,
    [1352] = true,
    [3516] = true,
    [1315] = true,
    [1284] = true,
    [1350] = true,
    [1351] = true,
}

addEventHandler("onClientResourceStart", resourceRoot, function()
    for k, v in pairs(getElementsByType("object")) do 
        if trafficLigthModels[getElementModel(v)] then 
            local pos = Vector3(getElementPosition(v))
            --local col = createColTube(pos.x, pos.y, pos.z, 10, 10)
        end
    end
end)