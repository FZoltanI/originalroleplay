core = exports.oCore
color, r, g, b = core:getServerColor()

gateMoveingTime = 3000

gates = {
    {969, "Elektromos kapu"},
    {975, "Gurulós kapu"},
    {980, "Nagy kapu"},
    {968, "Sorompó"},
    {988, "Négyzet alakú gurulós kapu"},
    {2930, "Kicsi kapu"},
    {994, "Kicsi kapu"},
    {970, "Kicsi kapu"},
    {1553, "Kicsi kapu"},
    {3089, "Ajtó"},
}

function getAllGates() 
    local gates = {}

    for k, v in ipairs(getElementsByType("object")) do 
        if getElementData(v, "isGate") then 
            table.insert(gates, #gates+1, v)
        end
    end

    return gates
end

function getNearestGate(player, distance)
    local tempTable = {}
	local lastMinDis = distance-0.0001
    local nearestGate = false
    
	local pint = getElementInterior(player)
    local pdim = getElementDimension(player)
    
    local allGate = getAllGates()

    for _,v in pairs(getElementsByType("object")) do
        if getElementData(v, "isGate") then 
            local vint,vdim = getElementInterior(v),getElementDimension(v)
            if vint == pint and vdim == pdim then
                local model = getElementModel(v)

                local dis = distance


                if model == 968 then 
                    local px, py, pz = getElementPosition(player)
                    local gatex, gatey, gatez = core:getPositionFromElementOffset(v, 0, 0, 4)
                    dis = getDistanceBetweenPoints3D(px, py, pz, gatex, gatey, gatez)  
                else
                    dis = core:getDistance(player, v)
                end

                if tonumber(dis) < tonumber(distance) then
                    if dis < lastMinDis then 
                        lastMinDis = dis
                        nearestGate = v
                    end
                end
            end
        end
	end
	
	return nearestGate
end 