local wallObjects = {
    9732,
    9491,
    9733,
    9516,
    9522,
    9511,
    9509,
    9731,
    9508,
    9510,
    9497,
    9747,
    9708,
    9734,
    9555,
    9601,
    9891,
    9485,
    9490,
    9493,
    9710,
    9504,
    9547,
    9893,
    9505,
    9486,
    9575,
    9827,
    9556,
    9709,
    9725,
    9762,
    9615,
    9763,
    9728,
    9889,
    9751,
    9749,
    9592,
    9836,
    9613,
    9652,
    9699,
    9715,
    10111,
    10112,
    9610,
    9717,
    9597,
    9700,
    9743,
    10036,
    10614,
    10076,
    10265,
    10145,
    11100,
    10132,
    10034,
    10870,
    10860,
    10857,
    10139,
    11301,
    10134,
    11071,
    10863,
    10864,
    11127,
    11126,
    10131,
    10133,
    10820,
    9860,
    10973,
    10858,
    11387,
    10247,
    10483,
    10189,
    10075,
    11285,
    10185,
    11003,
    10077,
    9652,
    11228,
    9739,
    9738,
    9572,
    4439,
    9492,
    10457,
    18321,
    18331,
    18381,
    18322,
    18332,
    18615,
    18320,
    6882,
    18330,
    18339,
    18323,
    7049,
}

local signsObject = {
    18275, 
    18333, 
    18340, 
}

local planeObjects = {
    ["plane_grass_1"] = 18338, 
    ["plane_grass_2"] = 17081, 
    ["plane_grass_3"] = 17084,
}

local TXDs = {}
local DFFs = {}
local COLs = {}

function loadSAMPPlanes()

    TXDs["planes"] = {}
    DFFs["planes"] = {}
    COLs["planes"] = {} 

    for k, v in pairs(planeObjects) do
        print( k .. " " .. v)
        COLs["planes"][k] = engineLoadCOL("plane/" .. k .. ".col")
        engineReplaceCOL(COLs["planes"][k], v)
        TXDs["planes"][k] = engineLoadTXD("plane/planes.txd")
        engineImportTXD(TXDs["planes"][k], v)
        DFFs["planes"][k] = engineLoadDFF("plane/" .. k .. ".dff") -- 
        engineReplaceModel(DFFs["planes"][k], v)
    end
end

function loadSAMPWalls()

    TXDs["walls"] = {}
    DFFs["walls"] = {}
    COLs["walls"] = {} 

    for k, v in ipairs(wallObjects) do
        if v > 0 then
            if k < 10 then
                rk = "00" .. k
            end

            if k < 100 and k > 10 then
                rk = "0" .. k
            end

            if k > 99 then
                rk = k
            end

            COLs["walls"][k] = engineLoadCOL("walls/wall" .. rk .. ".col")
            engineReplaceCOL(COLs["walls"][k], v)
            TXDs["walls"][k] = engineLoadTXD("walls/all_walls.txd")
            engineImportTXD(TXDs["walls"][k], v)
            DFFs["walls"][k] = engineLoadDFF("walls/wall" .. rk .. ".dff") -- 
            engineReplaceModel(DFFs["walls"][k], v)
        end
    end
end

function loadSAMPSigns()

    TXDs["signs"] = {}
    DFFs["signs"] = {}
    COLs["signs"] = {} 

    for k, v in ipairs(signsObject) do
        
        --if fileExists("roadsigns/SAMPRoadSign" .. k .. ".col") then
            COLs["signs"][k] = engineLoadCOL("roadsigns/SAMPRoadSign" .. k .. ".col")
            engineReplaceCOL(COLs["signs"][k], v)
        --end

        --if fileExists("roadsigns/SAMPRoadSigns.txd") then
            TXDs["signs"][k] = engineLoadTXD("roadsigns/SAMPRoadSigns.txd")
            engineImportTXD(TXDs["signs"][k], v)
        --end

        --if fileExists("roadsigns/SAMPRoadSign" .. k .. ".dff") then
            DFFs["signs"][k] = engineLoadDFF("roadsigns/SAMPRoadSign" .. k .. ".dff") -- 
            engineReplaceModel(DFFs["signs"][k], v)
        --end
        end
    
end

addEventHandler( "onClientResourceStart", getResourceRootElement(), function()
    loadSAMPWalls()
    loadSAMPSigns()
    loadSAMPPlanes()
end)