local screenX, screenY = guiGetScreenSize()
function _s(_n)
	return _n
end; local respc = _s; local resp = respc
function _sr(_n)
	return _n
end

local preview = exports.oPreview
local dxfont0_montserrat = exports.oFont:getFont("condensed", 11)
local dxfont1_roboto = exports.oFont:getFont("condensed", 10)
local dxfont0_roboto = exports.oFont:getFont("condensed", 13)
local dxfont2_roboto = exports.oFont:getFont("condensed", 29)
local dxfont3_roboto = exports.oFont:getFont("condensed", 22)
local guiSizeX, guiSizeY = _sr(screenX), 250
local theX, theY = _s(guiSizeX)/2, screenY-_s(guiSizeY)/2
local headerSize = 60

_engineLoadCOL = engineLoadCOL
_engineLoadDFF = engineLoadDFF
_engineLoadTXD = engineLoadTXD
engineLoadCOL = function(name)
	local file = fileOpen(name..".eff")
    if not file then
        return false
    end
    local count = fileGetSize(file)
    local data = fileRead(file, count)
	fileClose(file)
	data = teaDecode(data, "avrp4refsd")
	return _engineLoadCOL(base64Decode(data))
end
engineLoadDFF = function(name)
	local file = fileOpen(name..".eff")
    if not file then
        return false
    end
    local count = fileGetSize(file)
    local data = fileRead(file, count)
	fileClose(file)
	data = teaDecode(data, "avrp4refsd")
	return _engineLoadDFF(base64Decode(data))
end
engineLoadTXD = function(name)
	local file = fileOpen(name..".eff")
    if not file then
        return false
    end
    local count = fileGetSize(file)
    local data = fileRead(file, count)
	fileClose(file)
	data = teaDecode(data, "avrp4refsd")
	return _engineLoadTXD(base64Decode(data))
end

local needsReset = false


local global = {
	['hoveringBottomMenu'] = function()
		if isCursorShowing() then
			local cx, cy = getCursorPosition(); cx, cy = cx*screenX, cy*screenY;
			if cy >= theY-_s(guiSizeY)/2 then
				return true;
			end
		end
	end,
	['rectangles'] = 0,
	['objectPreviews'] = {},
	['showObjects'] = {},
	['oPreview'] = {}
}

global.findNewID = function(table)
	local i = 1
	while table[i] do
		i = i + 1
	end
	return i
end

global.checkForObjectPreviewsUnload = function()
	if global.oPreviewsOn then
		global.oPreviewsOn = nil
		for k, v in pairs(global.oPreview) do
			preview:destroyObjectPreview(v[2])
			if isElement(v[2]) then
				destroyElement(v[2])
			end
			if isElement(v[3]) then
				destroyElement(v[3])
			end
			global.oPreview[k] = nil
		end
	end
end

local wallModellID = {
	["straight"] = 9003,
	["door"] = 9016,
	["door2"] = 8979,
	["window"] = 8980,
	["base"] = 8973,
	["four"] = 8982,
	["three"] = 9000,
	["two"] = 9001,
	["half"] = 8969,
	["floor"] = 9002,
}

--createObject(9003, 1917.6474609375+0*30, -2492.875, 13.53911781311)
--createObject(9016, 1917.6474609375+1*30, -2492.875, 13.53911781311)
--createObject(8979, 1917.6474609375+2*30, -2492.875, 13.53911781311)
--createObject(8980, 1917.6474609375+3*30, -2492.875, 13.53911781311)
--createObject(8973, 1917.6474609375+4*30, -2492.875, 13.53911781311)
--createObject(8982, 1917.6474609375+5*30, -2492.875, 13.53911781311)
--createObject(9000, 1917.6474609375+6*30, -2492.875, 13.53911781311)
--createObject(9001, 1917.6474609375+7*30, -2492.875, 13.53911781311)
--createObject(8969, 1917.6474609375+8*30, -2492.875, 13.53911781311)
--createObject(9002, 1917.6474609375+9*30, -2492.875, 13.53911781311)

function loadColAndDff(id, name, txd)
	engineImportTXD(txd, id)

	local col = engineLoadCOL(name .. ".col")
	engineReplaceCOL(col, id)
	local dff = engineLoadDFF(name .. ".dff")
	engineReplaceModel(dff, id)
end

local txd = engineLoadTXD("files/models/w1.txd")

loadColAndDff(wallModellID["floor"], "files/models/w8", txd)
loadColAndDff(wallModellID["door"], "files/models/d1", txd)
loadColAndDff(wallModellID["two"], "files/models/w1", txd)
loadColAndDff(wallModellID["straight"], "files/models/w2", txd)
loadColAndDff(wallModellID["four"], "files/models/w3", txd)
loadColAndDff(wallModellID["three"], "files/models/w4", txd)
loadColAndDff(wallModellID["base"], "files/models/w5", txd)
loadColAndDff(wallModellID["half"], "files/models/w6", txd)
loadColAndDff(wallModellID["window"], "files/models/w7", txd)
loadColAndDff(wallModellID["door2"], "files/models/d2", txd)

--local col = engineLoadCOL("files/models/frame.col")
--engineReplaceCOL(col, 2257)

local objectLimit = 400

local editingInteriorID = false
local lastRot = 0

function setElementInteriorAndDimension(el, int)
	setElementInterior(el, int)
	setElementDimension(el, editingInteriorID)
end

local screenX, screenY = guiGetScreenSize()

function reMap(x, in_min, in_max, out_min, out_max)
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
end

responsiveMultipler = reMap(screenX, 1024, 1920, 0.75, 1)

function resp(v)
	return v * responsiveMultipler
end

function respc(v)
	return math.ceil(v * responsiveMultipler)
end

local infoWidth = respc(320)
local infoP = respc(16)
local infoS = respc(24)

--local hasBilliard = false

local currentInfoPage = {
	["walls"] = 1,
	["floors"] = 1,
	["doors"] = 1,
	["furnitures"] = 1,
}

local infoTexts = {}

--createObject(6292, 37.9, 1993.5, 18.4, 0, 0, 0)
--createObject(wallModellID["straight"], 37.9, 1984.2, 18.4, 0, 0, 0)
--createObject(6501, 37.9, 1988.6, 18.4, 0, 0, 0)
--createObject(wallModellID["floor"], 37.9, 1980, 18.4, 0, 0, 0)
--
--local walls = {}
--
--table.insert(walls, createObject(6292, 37.9, 2004.5, 18.4, 0, 0, 0))
--table.insert(walls, createObject(wallModellID["straight"], 37.9, 2001.3, 18.4, 0, 0, 0))
--table.insert(walls, createObject(wallModellID["straight"], 37.9, 2007.7, 18.4, 0, 0, 0))
--table.insert(walls, createObject(6501, 37.9, 2010.9, 18.4, 0, 0, 0))
--table.insert(walls, createObject(wallModellID["straight"], 37.9, 2014.1, 18.4, 0, 0, 0))
--
--local floor = {}
--
--table.insert(floor, createObject(wallModellID["straight"], 39.7, 2014.1, 16.6, 0, 90, 0))
--table.insert(floor, createObject(wallModellID["straight"], 39.7, 2001.3, 16.6, 0, 90, 0))
--table.insert(floor, createObject(wallModellID["straight"], 39.7, 2004.5, 16.6, 0, 90, 0))
--table.insert(floor, createObject(wallModellID["straight"], 39.7, 2007.7, 16.6, 0, 90, 0))
--table.insert(floor, createObject(wallModellID["straight"], 39.7, 2010.9, 16.6, 0, 90, 0))
--
--local ceil = {}
--
--table.insert(ceil, createWallateObject(wallModellID["straight"], 39.7, 2014.1, 16.6+3.5, 0, 90, 0))
--table.insert(ceil, createObject(wallModellID["straight"], 39.7, 2001.3, 16.6+3.5, 0, 90, 0))
--table.insert(ceil, createObject(wallModellID["straight"], 39.7, 2004.5, 16.6+3.5, 0, 90, 0))
--table.insert(ceil, createObject(wallModellID["straight"], 39.7, 2007.7, 16.6+3.5, 0, 90, 0))
--table.insert(ceil, createObject(wallModellID["straight"], 39.7, 2010.9, 16.6+3.5, 0, 90, 0))
--
----0.089388236403465, -1.6039658784866, -1.7502431869507, 0.089388236403465, 1.6111780405045, 1.7502431869507
--
--
--for k=1, #floor do
--	engineApplyShaderToWorldTexture(floorShader, "la_carp3", floor[k])
--end
--
--for k=1, #walls do
--	engineApplyShaderToWorldTexture(wallShader, "la_carp3", walls[k])
--end
--
--for k=1, #ceil do
--	engineApplyShaderToWorldTexture(ceilShader, "la_carp3", ceil[k])
--end

--la_carp3


local currentDoor = false
local doorLocked = {}
local lightState = false

local currentPlacingTexture = false
local cam = {}--{grid[1]+grid[4]/2*floorBaseSize, grid[2]+grid[5]/2*floorBaseSize, grid[3]-0.1}
local dist = 40
local lineThickness = (2*dist)/25
local grid = {700, 1700, 400, 10, 10} --local grid = {37.9, 2034.5, 50, 10, 10}

local yaw = math.rad(45+180)
local pitch = math.rad(45-10)

local mouseIntensity = 25

local boughtFromPP = {}
local ppCount = {}

local furnitureList = 
{	
	["Háló"] = {
		1416,
		1417,
		1700,
		1701,
		1740,
		1741,
		1745,
		1793,
		1794,
		1795,
		1796,
		1797,
		1798,
		1799,
		1800,
		1801,
		1802,
		1803,
		1812,
		1816,
		2023,
		2025,
		2069,
		2087,
		2088,
		2089,
		2090,
		2094,
		2095,
		2200,
		2298,
		2299,
		2300,
		2301,
		2302,
		2307,
		2323,
		2328,
		2329,
		2330,
		2331,
		2333,
		2563,
		2564,
		2565,
		2566,
		2575,
		2576,
		2708,
		14446,
	},
	["Nappali"] = {
		1235,
		1663,
		1671,
		1702,
		1703,
		1704,
		1705,
		1706,
		1707,
		1708,
		1709,
		1710,
		1711,
		1712,
		1713,
		1723,
		1724,
		1726,
		1735,
		1742,
		1743,
		1744,
		1753,
		1754,
		1755,
		1756,
		1757,
		1758,
		1759,
		1760,
		1761,
		1762,
		1763,
		1764,
		1765,
		1766,
		1767,
		1768,
		1769,
		1806,
		1811,
		1814,
		1815,
		1817,
		1818,
		1819,
		1820,
		1822,
		1823,
		1998,
		1999,
		2024,
		2046,
		2078,
		2081,
		2082,
		2083,
		2084,
		2096,
		2108,
		2109,
		2111,
		2112,
		2115,
		2116,
		2117,
		2118,
		2119,
		2161,
		2162,
		2163,
		2164,
		2167,
		2173,
		2180,
		2184,
		2191,
		2199,
		2200,
		2204,
		2206,
		2234,
		2235,
		2239,
		2290,
		2291,
		2292,
		2295,
		2311,
		2313,
		2314,
		2315,
		2319,
		2321,
		2346,
		2357,
		2370,
		2462,
		2571,
		2699,
		11665,
	},
	["Fürdő"] = {
		1778,
		2516,
		2517,
		2518,
		2519,
		2520,
		2521,
		2522,
		2523,
		2524,
		2525,
		2526,
		2527,
		2528,
	},
	["Konyha"] = {
		936,
		937,
		941,
		1432,
		1433,
		1594,
		1720,
		1721,
		1770,
		1805,
		1810,
		1821,
		2014,
		2015,
		2016,
		2018,
		2019,
		2020,
		2021,
		2022,
		2029,
		2030,
		2031,
		2079,
		2109,
		2111,
		2112,
		2120,
		2121,
		2124,
		2125,
		2127,
		2128,
		2129,
		2131,
		2132,
		2133,
		2134,
		2135,
		2136,
		2137,
		2138,
		2139,
		2140,
		2141,
		2142,
		2143,
		2145,
		2147,
		2151,
		2152,
		2153,
		2154,
		2155,
		2156,
		2157,
		2158,
		2159,
		2160,
		2294,
		2303,
		2304,
		2305,
		2334,
		2335,
		2336,
		2337,
		2338,
		2339,
		2340,
		2341,
		2350,
		2636,
		2637,
		2644,
		2762,
		2763,
		2764,
		2788,
		2802,
		15036,
	},
	["Elektronika"] = {
		--14886,
		1429,
		1719,
		1747,
		1748,
		1749,
		1750,
		1751,
		1752,
		1781,
		1782,
		1783,
		1785,
		1787,
		1790,
		1791,
		1792,
		2028,
		2099,
		2100,
		2101,
		2149,
		2190,
		2196,
		2225,
		2226,
		2227,
		2229,
		2230,
		2231,
		2232,
		2233,
		2238,
		2296,
		2297,
		2421,
		2726,
		14532,

		-- tvk
		2648,
		14772,
		1786,
	},
	["Dekoráció"] = {
		2332,
		630,
		631,
		632,
		633,
		638,
		646,
		948,
		949,
		950,
		1361,
		1369,
		1583,
		1584,
		1585,
		1775,
		1776,
		1829,
		1985,
		2001,
		2010,
		2011,
		2194,
		2195,
		2224,
		2240,
		2241,
		2244,
		2251,
		2252,
		2253,
		2452,
		2484,
		2489,
		2490,
		2491,
		2500,
		2581,
		2584,
		2627,
		2628,
		2629,
		2630,
		2724,
		2725,
		2743,
		2778,
		2779,
		2811,
		2872,
		2915,
		2916,
		2976,
		3065,
		3383,
		3385,
		--3461,
		--3534,
		--7027,
		--14834,
		16151,
	},
}

addEventHandler("onClientResourceStart", resourceRoot, function()
	if getElementData(localPlayer, "user:loggedin") then 
		if getElementDimension(localPlayer) > 0 and getElementInterior(localPlayer) == 1 then 
		end
	end
end)

for k, v in pairs(furnitureList) do
	for k2=1, #v do
		engineSetModelLODDistance(v[k2], 300)
	end
end

local furnitureCategories = {
	"Háló",
	"Nappali",
	"Fürdő",
	"Konyha",
	"Elektronika",
	"Dekoráció",
	--"Interakció",
}

local placingPrompt = false
local placingFurniture = false
local activeFurniture = false

local canPlaceFurniture = false
local furnitures = {}

local destroy = destroyElement

function destroyElement(element)
	if isElement(element) then
		destroy(element)
	end
end


local editMode = false
local doorColShapes = {}
local doorColShapeIndex = {}

local doors = {}
local doorRots = {}
local doorIndexes = {}

local wasGrid = false
local canGrid = true


local compress = "DXT1" -- TODO: DXT1!!!!!!!!!!!!!!!!!!!

local scrollOffset = {
	
}

local doorModels = {
	[1] = 1494,
	[2] = 1492,
	[3] = 1491,
	[4] = 1502,
}

local doorReverse = {
	[1494] = "1",
	[1492] = "2",
	[1491] = "3",
	[1502] = "4",
}

local doorTextures = {
	[1494] = "CJ_SCOR_DOOR",
	[1492] = "CJ_WOODDOOR1",
	[1491] = "CJ_WOODDOOR2",
	[1502] = "CJ_WOODDOOR5",
}

local textures = {
	["wall"] = {
		["paint"] = 20,
		["tile"] = 20,
		["wallpaper"] = 68,
	},
	["floor"] = {
		["carpet"] = 21,
		["tile"] = 49,
		["wood"] = 32,
	},
	["window"] = {
		["normal"] = 10,
		--["wide"] = 1,
	},
	["ceil"] = {
		["normal"] = 25,
		--["wide"] = 1,
	},
	["doors"] = {
		["1"] = 5,
		["2"] = 2,
		["3"] = 5,
		["4"] = 7,
	}
}

local textureIDs = {}
local textureNameFromIDs = {}

for k2, v2 in pairs(textures) do
	scrollOffset[k2] = {}

	for k, v in pairs(textures[k2]) do
		scrollOffset[k2][k] = 0
		local num = v


		textures[k2][k] = {}

		for j=1, num do
			textures[k2][k][j] = dxCreateTexture("files/" .. k2 .. "/" .. k .. "/" .. j .. ".png", compress)
		end
	end
end

local textureIDList = {
	--"wall/paint/1/20", -- wall,paint 1-től 20-ig
	
	"ceil/normal/1/25",
	"floor/wood/1/32",
	"floor/carpet/1/21",
	"floor/tile/1/49",
	"wall/paint/1/20",
	"wall/wallpaper/1/68",
	"wall/tile/1/20",
	"window/normal/1/10",
	"doors/1/1/5",
	"doors/4/1/7",
	"doors/3/1/5",
	"doors/2/1/2",
}

local id = 1

for k, v in ipairs(textureIDList) do
	local dat = split(v, "/")

	for j=dat[3], dat[4] do
		local path = dat[1] .. "," .. dat[2] .. "," .. j
		
		textureNameFromIDs[id] = path
		textureIDs[path] = id

		id = id + 1
	end
end

scrollOffset["furnitures"] = {}

for k=1, #furnitureCategories do
	scrollOffset["furnitures"][furnitureCategories[k]] = 0
end

function smallTextureName(name)
	return utf8.sub(name, 8)
end

function bigTextureName(id)
	return "la_carp" .. id
end

function smallPathName(name)
	return textureIDs[name]
end

function bigPathName(id)
	return textureNameFromIDs[tonumber(id)]
end

local floorOnCoordinates = {}
local floorCoordinates = {}
local baseFloors = {}

local ceilOnCoordinates = {}
local ceilCoordinates = {}
local baseCeils = {}

local baseWalls = {}
local baseDoor = false
local baseDoorCol = false
local currentBaseDoor = false

local windows = {}
local windowCoordiantes = {}
local windowOnCoordiante = {}

local walls = {}
local wallCoordiantes = {}
local wallOnCoordiante = {}

local testMode = false

local bcgMusic = math.random(7)
local bcgMusicElement = false
local soundsEnabled = true

local floorBaseSize = 2
local thickness = 0

local borders = {}

local windowHover = false
local windowHoverBaseModel = false
local windowHoverTexture = false
local windowHoverRotation = false
local doorDefaultState = false

function getBorders()
	borders[1] = grid[1]
	borders[2] = grid[2]
	borders[3] = grid[1]+grid[4]*floorBaseSize
	borders[4] = grid[2]+grid[5]*floorBaseSize
end

function createBaseFloors()
	--floorBaseSize = floorBaseSize + 1
	for x=1, grid[4] do
		for y=1, grid[5] do
			local obj = createObject(wallModellID["floor"], grid[1]+(x-1+0.5)*floorBaseSize, grid[2]+(y-1+0.5)*floorBaseSize, grid[3], 0, 90, 0)
			setElementInteriorAndDimension(obj, 1)
			--setElementFrozen(obj, true)
			--setElementCollisionsEnabled(obj, false)
			
			table.insert(baseFloors, obj)
			floorCoordinates[obj] = {x, y}
			floorOnCoordinates[x..","..y] = obj
		end
	end
end

function createBaseCeil()
	for x=1, grid[4] do
		for y=1, grid[5] do
			local obj = createObject(wallModellID["floor"], grid[1]+(x-1+0.5)*floorBaseSize, grid[2]+(y-1+0.5)*floorBaseSize, grid[3]+3.5, 180, 90, 90)
			--setElementInteriorAndDimension(obj, 1)
			--setElementFrozen(obj, true)
			
			setElementCollisionsEnabled(obj, false)
			setElementInteriorAndDimension(obj, 2)

			table.insert(baseCeils, obj)
			ceilCoordinates[obj] = {x, y}
			ceilOnCoordinates[x..","..y] = obj
		end
	end
end

local baseWallCoordinates = {}
local baseWallOnCoordinates = {}

function createBaseWalls()
	--outputDebugString("baseWalls")
	grid[5] = grid[4] 
	for x=1, grid[4] do
		local obj = createObject(wallModellID["base"], grid[1]+(x-1+0.5)*floorBaseSize, grid[2], grid[3]+3.5/2, 0, 0, 270)
		setElementInteriorAndDimension(obj, 1)
		
		--applyTextureToElement(obj, "la_carp3", "wall", "paint", 1)
		--applyTextureToElement(obj, "la_carp5", "wall", "paint", 1)
		----applyTextureToElement(obj, "la_carp4", "window", "normal", 1)

		table.insert(baseWalls, obj)
		baseWallCoordinates[obj] = {x, 0, 1}
		baseWallOnCoordinates[x .. "," .. 0 .. "," .. 1] = obj
	end

	for x=1, grid[4] do
		--print(floorBaseSize, grid[1], grid[2], grid[3], grid[5])
		local obj = createObject(wallModellID["base"], grid[1]+(x-1+0.5)*floorBaseSize, grid[2]+(grid[5])*floorBaseSize, grid[3]+3.5/2, 0, 0, 90)
		setElementInteriorAndDimension(obj, 1)
		
		--applyTextureToElement(obj, "la_carp3", "wall", "paint", 1)
		--applyTextureToElement(obj, "la_carp5", "wall", "paint", 1)
		----applyTextureToElement(obj, "la_carp4", "window", "normal", 1)

		table.insert(baseWalls, obj)
		baseWallCoordinates[obj] = {x, grid[5], 2}
		baseWallOnCoordinates[x .. "," .. grid[5] .. "," .. 2] = obj
	end

	for y=1, grid[5] do
		local obj = createObject(wallModellID["base"], grid[1], grid[2]+(y-1+0.5)*floorBaseSize, grid[3]+3.5/2, 0, 0, 180)
		setElementInteriorAndDimension(obj, 1)
		
		--applyTextureToElement(obj, "la_carp3", "wall", "paint", 1)
		--applyTextureToElement(obj, "la_carp5", "wall", "paint", 1)
		----applyTextureToElement(obj, "la_carp4", "window", "normal", 1)

		table.insert(baseWalls, obj)
		baseWallCoordinates[obj] = {0, y, 3}
		baseWallOnCoordinates[0 .. "," .. y .. "," .. 3] = obj
	end

	for y=1, grid[5] do
		local obj = createObject(wallModellID["base"], grid[1]+(grid[4])*floorBaseSize, grid[2]+(y-1+0.5)*floorBaseSize, grid[3]+3.5/2, 0, 0, 0)
		setElementInteriorAndDimension(obj, 1)
		
		--applyTextureToElement(obj, "la_carp3", "wall", "paint", 1)
		--applyTextureToElement(obj, "la_carp5", "wall", "paint", 1)
		----applyTextureToElement(obj, "la_carp4", "window", "normal", 1)

		table.insert(baseWalls, obj)
		baseWallCoordinates[obj] = {grid[4], y, 4}
		baseWallOnCoordinates[grid[4] .. "," .. y .. "," .. 4] = obj
	end

	createBaseFloors()
	createBaseCeil()
end

function getSize()
	local obj = createObject(wallModellID["floor"], 0, 0, 0)

	local x1, y1, z1, x2, y2, z2 = getElementBoundingBox(obj)

	--outputDebugString((math.abs(y1)+math.abs(y2)+math.abs(z1)+math.abs(z2))/2)
	floorBaseSize = (math.abs(y1)+math.abs(y2)+math.abs(z1)+math.abs(z2))/2
	thickness = math.abs(x1)+math.abs(x2)

	createBaseWalls()

	getBorders()
end
--createWall(3, 2, 2)
--createWall(3, 1, 2)
--createWall(3, 3, 2)

--createWall(1, 3, 1)
--createWall(2, 3, 1)
--createWall(3, 3, 1)
--createWall(4, 3, 1)
--createWall(5, 3, 1)
--createWall(6, 3, 1)
--createWall(7, 3, 1)
--createWall(8, 3, 1)



local cameraReversed = false

function orbitCamera()
	local tmp = pitch
	local tmp2 = yaw

	if cameraReversed then
		tmp = pitch-math.rad(180)
		tmp2 = yaw+math.rad(180)
	end

	cam[4] = math.cos(tmp2)*math.cos(tmp)
	cam[5] = math.sin(tmp2)*math.cos(tmp)
	cam[6] = math.sin(tmp)

	cam[4] = cam[1] + cam[4]*dist
	cam[5] = cam[2] + cam[5]*dist
	cam[6] = cam[3] + cam[6]*dist
end

local lineDraw = 0.15
local lineDraw2 = -0.15

function reverseCamera(state)
	setActiveFurniture(false)
	cameraReversed = state

	if state then
		lineDraw = 3.5-0.15
		lineDraw2 = 3.5+0.15
	else
		lineDraw = 0.15
		lineDraw2 = -0.15
	end

	orbitCamera()
end

--orbitCamera()

local sx, sy = guiGetScreenSize()


local leftPosition = false


local startTileX, startTileY = false, false
local startTileFace = false
local tileX, tileY = false, false
local tileFace = 3
local selectedWall = false
local activeTile = {}
local activeColor = tocolor(r, g, b)
--X = {}
--local activeTileY = {}

local doorWalls = {}
--local placedDoor = false

local mode = "looking"

local wallMode = "full" -- full/half/none

local paintHover = false

local lightHeight

local smallRectSize = respc(34)
local mainRectSize = respc(136)


local sideState = true


local sideIconSize = respc(30)
local furnitureIconSize = respc(32)
local sideIconBorder = respc(12)

local testSideIcons = 1
local normalSideIcons = 4
local sideIcons = normalSideIcons

local sideWidth = sideIconSize*sideIcons+sideIconBorder*(sideIcons+2)
local sideHeight = sideIconSize+sideIconBorder*2 + respc(15)

local sideX = sx*0.01
local sideY = respc(3)


local maxItems = 13
local smallSizeDiff = respc(2)
local itemBorder = respc(5)
local itemBorderY = respc(5)
local imageBorder = respc(5)
local itemPlusY = -respc(15)
local yMinus = -respc(30)
local oneItemWidth = respc(120)
mainRectSize = oneItemWidth+itemBorderY

local mainSelection = "walls" 
local subSelection = "drawing"

function first(table)
	for k in pairs(table) do
		return k
	end
end

local defaultSubs = {
	["walls"] = "drawing",
	["floors"] = "wood",
	["doors"] = "doors",
	["furnitures"] = furnitureCategories[1],
}

local cx, cy = -1, -1
local activeButton = false


local day = false
local gridState = true

function setDaytime(state)
	if state ~= nil then
		day = state
	else
		day = not day
	end

	resetSkyGradient()
	keepDaytime()
end

function keepDaytime()
	--[[setWeather(4)

	if day then
		setSkyGradient(125*0.75, 145*0.75, 151*0.75, 125*0.75, 145*0.75, 151*0.75)
		setTime(12,0)
	else
		setSkyGradient(125*0.5, 145*0.5, 151*0.5, 125*0.5, 145*0.5, 151*0.5)
		setTime(0,0)
	end]]
end

--[[
Day Sky gradient colors are R: 125 G: 145 B: 151 and R: 125 G: 145 B: 151
Night Sky gradient colors are R: 10 G: 10 B: 10 and R: 10 G: 22 B: 33
weather: 4
]]

local shaderForTexture = {}
local shadersOnElements = {}
local pathOnElements = {}
local useNums = {}
local cashCosts = 0
local paidCashCosts = 0
local cashCostsFormatted = "0"



function setWallAlphas(forceon)
	--if forceon or wallMode == "full" then
	--	for i=1, 4 do
	--		for k=1, #baseWalls[i] do
	--			setElementAlpha(baseWalls[i][k], 255)
	--		end
	--	end
--
	--	for k=1, #walls do
	--		setElementAlpha(walls[k], 255)
	--	end
	--elseif wallMode == "none" then
	--	for i=1, 4 do
	--		for k=1, #baseWalls[i] do
	--			setElementAlpha(baseWalls[i][k], 0)
	--		end
	--	end
--
	--	for k=1, #walls do
	--		setElementAlpha(walls[k], 0)
	--	end
	--end
end



local arrowDistance = 1.5
local move = dxCreateTexture("files/icons/move.png")
local rotate = dxCreateTexture("files/icons/rotate.png")

local arrowSize = 1
local movingFurniture = false
local rotateMode = false
local snapping = false
local snappingR = 10
local infoState = true

local lastCursor = {}

global.getMax = function()
	local maxObjs = #textures["doors"]["1"]+#textures["doors"]["2"]+#textures["doors"]["3"]+#textures["doors"]["4"]+4+1
	if subSelection == "ceil" then
		return #textures["ceil"]["normal"]-maxItems
	elseif mainSelection == "walls" and subSelection ~= "drawing" then
		return #textures["wall"][subSelection]-maxItems
	elseif mainSelection == "furnitures" then
		return #furnitureList[subSelection]-maxItems
	elseif mainSelection == "floors" then
		return #textures["floor"][subSelection]-maxItems
	elseif subSelection == "windows" then
		return #textures["window"]["normal"]-maxItems
	elseif subSelection == "doors" then
		return maxObjs-maxItems
	end
end

function onClientKey(key, por)
	--[[if key == "mouse1" then
		if mode == "wallDrawing" then
			if por then
				if tileX then
					startTileX, startTileY =  tileX, tileY
				end
			else
				if tileX and startTileX then
					local minX = math.min(startTileX, tileX)
					local minY = math.min(startTileY, tileY)
					local maxX = math.max(startTileX, tileX)
					local maxY = math.max(startTileY, tileY)

					if minY-1 > 0 then
						for x=minX, maxX do
							createWall(x, minY-1, 1, 180)
						end
					end

					if maxY < grid[5] then
						for x=minX, maxX do
							createWall(x, maxY, 1, 0)
						end
					end

					if minX-1 > 0 then
						for y=minY, maxY do
							createWall(minX-1, y, 2, 180)
						end
					end

					if maxX < grid[4] then
						for y=minY, maxY do
							createWall(maxX, y, 2, 0)
						end
					end

					corrigateY()
				end

				startTileX, startTileY = false, false
				
				activeTileX = {}
				activeTileY = {}

				if tileX then
					activeTileX[tileX] = true
					activeTileY[tileY] = true
				end
			end
		elseif mode == "addDoor" then
			if por then
				doorWalls[selectedWall] = not doorWalls[selectedWall]
				--setElementModel(selectedWall, (doorWalls[selectedWall] and 6503 or wallModellID["straight"]))
				--placedDoor = selectedWall
				--selectedWall = false
				--outputDebugString("placedoor")
				setMode("looking")
			end
		end
	else--]]
	if key == "mouse1" and not por and movingFurniture and movingFurniture[8] == true then
		local x, y = movingFurniture[9], movingFurniture[10]
		if x then
			lastCursor = false
			setCursorPosition(x+movingFurniture[1], y+movingFurniture[2])
		end

		setCursorAlpha(255)
	elseif mode ~= "test" then
		if cy > screenY-mainRectSize-smallRectSize then
			if subSelection == "ceil" then
				if #textures["ceil"]["normal"] > maxItems then
					if key == "mouse_wheel_up" then
						scrollOffset["ceil"]["normal"] = scrollOffset["ceil"]["normal"] - 1

						if scrollOffset["ceil"]["normal"] < 0 then
							scrollOffset["ceil"]["normal"] = 0
						end
					elseif key == "mouse_wheel_down" then
						scrollOffset["ceil"]["normal"] = scrollOffset["ceil"]["normal"] + 1

						if scrollOffset["ceil"]["normal"] > #textures["ceil"]["normal"]-maxItems then
							scrollOffset["ceil"]["normal"] = #textures["ceil"]["normal"]-maxItems
						end
					end
				end
			elseif mainSelection == "walls" and subSelection ~= "drawing" then
				if #textures["wall"][subSelection] > maxItems then
					if key == "mouse_wheel_up" then
						scrollOffset["wall"][subSelection] = scrollOffset["wall"][subSelection] - 1

						if scrollOffset["wall"][subSelection] < 0 then
							scrollOffset["wall"][subSelection] = 0
						end
					elseif key == "mouse_wheel_down" then
						scrollOffset["wall"][subSelection] = scrollOffset["wall"][subSelection] + 1

						if scrollOffset["wall"][subSelection] > #textures["wall"][subSelection]-maxItems then
							scrollOffset["wall"][subSelection] = #textures["wall"][subSelection]-maxItems
						end
					end
				end
			elseif mainSelection == "furnitures" then
				if #furnitureList[subSelection] > maxItems then
					if key == "mouse_wheel_up" then
						scrollOffset["furnitures"][subSelection] = scrollOffset["furnitures"][subSelection] - 1

						if scrollOffset["furnitures"][subSelection] < 0 then
							scrollOffset["furnitures"][subSelection] = 0
						end
					elseif key == "mouse_wheel_down" then
						scrollOffset["furnitures"][subSelection] = scrollOffset["furnitures"][subSelection] + 1

						if scrollOffset["furnitures"][subSelection] > #furnitureList[subSelection]-maxItems then
							scrollOffset["furnitures"][subSelection] = #furnitureList[subSelection]-maxItems
						end
					end
				end
			elseif mainSelection == "floors" then
				if #textures["floor"][subSelection] > maxItems then
					if key == "mouse_wheel_up" then
						scrollOffset["floor"][subSelection] = scrollOffset["floor"][subSelection] - 1

						if scrollOffset["floor"][subSelection] < 0 then
							scrollOffset["floor"][subSelection] = 0
						end
					elseif key == "mouse_wheel_down" then
						scrollOffset["floor"][subSelection] = scrollOffset["floor"][subSelection] + 1

						if scrollOffset["floor"][subSelection] > #textures["floor"][subSelection]-maxItems then
							scrollOffset["floor"][subSelection] = #textures["floor"][subSelection]-maxItems
						end
					end
				end
			elseif subSelection == "windows" then
				if #textures["window"]["normal"] > maxItems then
					if key == "mouse_wheel_up" then
						scrollOffset["window"]["normal"] = scrollOffset["window"]["normal"] - 1

						if scrollOffset["window"]["normal"] < 0 then
							scrollOffset["window"]["normal"] = 0
						end
					elseif key == "mouse_wheel_down" then
						scrollOffset["window"]["normal"] = scrollOffset["window"]["normal"] + 1

						if scrollOffset["window"]["normal"] > #textures["window"]["normal"]-maxItems then
							scrollOffset["window"]["normal"] = #textures["window"]["normal"]-maxItems
						end
					end
				end
			elseif subSelection == "doors" then
				local maxObjs = #textures["doors"]["1"]+#textures["doors"]["2"]+#textures["doors"]["3"]+#textures["doors"]["4"]+4+1

				if maxObjs > maxItems then
					if key == "mouse_wheel_up" then
						scrollOffset["doors"]["1"] = scrollOffset["doors"]["1"] - 1

						if scrollOffset["doors"]["1"] < 0 then
							scrollOffset["doors"]["1"] = 0
						end
					elseif key == "mouse_wheel_down" then
						scrollOffset["doors"]["1"] = scrollOffset["doors"]["1"] + 1

						if scrollOffset["doors"]["1"] > maxObjs-maxItems then
							scrollOffset["doors"]["1"] = maxObjs-maxItems
						end
					end

					----outputDebugString("oa: " .. scrollOffset["doors"]["1"] )
				end
			end
		else
			if key == "mouse_wheel_up" then
				dist = dist - 1
				if dist < 3 then
					dist = 3
				end
				
				lineThickness = (2*dist)/25

				orbitCamera()
			elseif key == "mouse_wheel_down" then
				dist = dist + 1
				if dist > 75 then
					dist = 75
				end

				lineThickness = (2*dist)/25
				
				orbitCamera()
			elseif (key == "mouse2" or key == "mouse3" or (key == "mouse1" and getKeyState("lshift"))) and por then
				setCursorAlpha(0)
				local x, y = getCursorPosition()
				lastCursor = {x, y}
				leftPosition = {x*screenX, y*screenY}

					--setCursorPosition(screenX/2, screenY/2)
			elseif (key == "mouse2" or key == "mouse3" or key == "mouse1" or key == "lshift") and not por then
				if leftPosition and not getKeyStateEx() then
					----outputDebugString("end: " .. keys)
					setCursorAlpha(255)
					lastCursor = false
					setCursorPosition(unpack(leftPosition))
					leftPosition = false
				end
			end
		end
	end
end

local lineAxis = false
local startCoord = 0

function coordToTile(x, y, f)
	x = x*2
	y = y*2

	if f == 4 or f == 5 then
		x = x + 1
	end

	if f == 6 or f == 5 then
		y = y + 1
	end

	return x, y
end

function tileToCoord(x, y)
	local dx = x%2
	local dy = y%2
	local f = 3

	if dx == 1 and dy == 1 then
		f = 5
	elseif dx == 1 then
		f = 4
	elseif dy == 1 then
		f = 6
	end

	x = math.floor(x/2)
	y = math.floor(y/2)

	return x, y, f
end

function loopTiles(cb)
	if tileX == startTileX and tileY == startTileY and tileFace == startTileFace then
		cb(tileX, tileY, tileFace)
	else
		local x, y = coordToTile(tileX, tileY, tileFace)
		local x2, y2 = coordToTile(startTileX, startTileY, startTileFace)

		----outputDebugString(x .. "->".. x2)
		----outputDebugString(y .. "->".. y2)
		----outputDebugString("-------------")

		local minX = math.min(x, x2)
		local minY = math.min(y, y2)
		local maxX = math.max(x, x2)
		local maxY = math.max(y, y2)

		for x=minX, maxX do
			for y=minY, maxY do
				local x2, y2, f = tileToCoord(x, y)
				cb(x2, y2, f)
			end
		end
	--
		----outputDebugString("sf: " .. startTileFace .. " -> f" .. tileFace)
	--
		--if startTileFace == 5 then
		--	for y=minY+1, maxY-1 do
		--		cb(minX, y, 5)
		--		cb(minX, y, 4)
		--	end
		--end
	end
end

function coordToTile2(x, f)
	x = x*2

	if f == 3 or f == 4 then
		x = x + 1
	end

	return x
end

function tileToCoord2(x, lineAxis)
	local dx = x%2

	if lineAxis == "x" then
		if dx == 1 then
			dx = 3
		else
			dx = 1
		end
	else
		if dx == 1 then
			dx = 4
		else
			dx = 2
		end
	end

	x = math.floor(x/2)
	return x, dx
end

function loopTiles2(cb)
	if tileX == startTileX and tileY == startTileY and tileFace == startTileFace then
		--outputDebugString("same")
		cb(tileX, tileX)
	else
		local tile = tileX
		local stile = startTileX

		if lineAxis == "y" then
			tile = tileY
			stile = startTileY
		end

		local x = coordToTile2(tile, tileFace)
		local x2 = coordToTile2(stile, startTileFace)

		----outputDebugString(x .. "->".. x2)
		----outputDebugString(y .. "->".. y2)
		----outputDebugString("-------------")

		local min = math.min(x, x2)
		local max = math.max(x, x2)

		--outputDebugString(min .. "->" .. max)

		cb(min, max)
		--for x=minX, maxX do
		--	for y=minY, maxY do
		--		local x2, y2, f = tileToCoord(x, y)
		--		cb(x2, y2, f)
		--	end
		--end
	--
		----outputDebugString("sf: " .. startTileFace .. " -> f" .. tileFace)
	--
		--if startTileFace == 5 then
		--	for y=minY+1, maxY-1 do
		--		cb(minX, y, 5)
		--		cb(minX, y, 4)
		--	end
		--end
	end
end

function activizeTile(x,y,f)
	--if not activeTile[x..","..y..","..f] then
	--	--playSoundEx("sounds/greenline.mp3")
	--end

	activeTile[x..","..y..","..f] = true
end

local ltx, lty = false, false
function activizeTile2(min, max)
	if min == max then
		activizeTile(startTileX, startTileY, tileFace)

		if tileX ~= ltx or tileY ~= lty then
			playSoundEx("sounds/greenline.mp3")

			ltx = tileX
			lty = tileY
		end
	else
		if min ~= ltx or max ~= lty then
			playSoundEx("sounds/greenline.mp3")

			ltx = min
			lty = max
		end

		for x=min, max do
			local x2, f = tileToCoord2(x, lineAxis)

			if lineAxis == "x" then
				activizeTile(x2, startTileY, f)
			else
				activizeTile(startTileX, x2, f)
			end
		end
	end
end

function placeLineWalls(min, max)
	if min == max then
		if tileFace == 3 then
			createWall(tileX, tileY, 270, true)
		elseif tileFace == 1 then
			createWall(tileX, tileY, 90, true)
		elseif tileFace == 2 then
			createWall(tileX, tileY, 180, true)
		elseif tileFace == 4 then
			createWall(tileX, tileY, 0, true)
		end

		playSoundEx("sounds/construct" .. math.random(2) .. ".mp3")
	else
		local x1, fmax = tileToCoord2(min, lineAxis)
		local x2, fmin = tileToCoord2(max, lineAxis)

		--outputDebugString("fmin: " .. fmin .. " (" .. min .. ")")
		--outputDebugString("fmax: " .. fmax .. " (" .. max .. ")")

		if fmin == 1 or fmin == 2 then
			max = max-1
			--outputDebugString("halfwallmax: " .. x2)

			if lineAxis == "x" then
				createWall(x2, startTileY, 90, true)
			else
				createWall(startTileX, x2, 180, true)
			end
		end

		if fmax == 3 or fmax == 4 then
			min = min+1
			--outputDebugString("halfwallmin")

			if lineAxis == "x" then
				createWall(x1, startTileY, 270, true)
			else
				createWall(startTileX, x1, 0, true)
			end
		end

		for k=min/2, max/2 do
			if lineAxis == "x" then
				createWall(k, startTileY, 90)
			else
				createWall(startTileX, k, 0)
			end

			--outputDebugString("wall: " .. k)
		end

		--createWall(x, minY, 90)

		playSoundEx("sounds/construct" .. math.random(2) .. ".mp3")
	end
end

function applyTileTexture(x,y,f)
	local sub, id = unpack(split(currentPlacingTexture, "/"))
	applyTextureToElement(floorOnCoordinates[x..","..y], "la_carp" .. f, "floor", sub, id)
end

function applyCeilTexture(x,y,f)
	--local sub, id = unpack(split(currentPlacingTexture, "/"))
	if f == 6 then
		f = 4
	elseif f == 4 then
		f = 6
	end

	----outputDebugString("f: " .. f)

	applyTextureToElement(ceilOnCoordinates[x..","..y], "la_carp" .. f, "ceil", "normal", tonumber(currentPlacingTexture))
end

function getKeyStateEx()
	return (getKeyState("mouse1") and getKeyState("lshift")) or getKeyState("mouse3")
end

function onClientCursorMove(x, y)
	if x and y then
		if getKeyState("mouse1") and not global.hoveringBottomMenu() then 
			if mode == "setWallpaper" then
				if paintHover then
					textureSide()
				end
			elseif mode == "setFloor" then
				activeTile = {}

				if startTileX and tileX then
					loopTiles(activizeTile)

					if tileX ~= ltx or tileY ~= lty then
						playSoundEx("sounds/greenline.mp3")

						ltx = tileX
						lty = tileY
					end
				end
			elseif mode == "setCeil" then
				activeTile = {}

				if startTileX and tileX then
					loopTiles(activizeTile)

					if tileX ~= ltx or tileY ~= lty then
						playSoundEx("sounds/greenline.mp3")

						ltx = tileX
						lty = tileY
					end
				end
			elseif ((mode == "drawWall_line" and lineAxis) or mode == "drawWall_rect" or (mode == "deleteWall_line" and lineAxis) or mode == "deleteWall_rect") then
				activeTile = {}
				
				if startTileX and tileX then
					local minX = math.min(startTileX, tileX)
					local minY = math.min(startTileY, tileY)
					local maxX = math.max(startTileX, tileX)
					local maxY = math.max(startTileY, tileY)
					
					if mode == "drawWall_rect" then
						if tileX ~= ltx or tileY ~= lty then
							playSoundEx("sounds/greenline.mp3")

							ltx = tileX
							lty = tileY
						end

						if tileX == startTileX or tileY == startTileY then
							for f=1,4 do
								activeTile[startTileX..","..startTileY..","..f] = true
							end
						else
							if minY-1 > 0 then
								for x=minX, maxX do
									activeTile[x..","..minY..","..1] = true
									activeTile[x..","..minY..","..3] = true
								end
							end

							if maxY < grid[5] then
								for x=minX, maxX do
									activeTile[x..","..maxY..","..1] = true
									activeTile[x..","..maxY..","..3] = true
								end
							end

							if minX-1 > 0 then
								for y=minY, maxY do
									activeTile[minX..","..y..","..2] = true
									activeTile[minX..","..y..","..4] = true
								end
							end

							if maxX < grid[4] then
								for y=minY, maxY do
									activeTile[maxX..","..y..","..2] = true
									activeTile[maxX..","..y..","..4] = true
								end
							end

							activeTile[maxX..","..maxY..","..4] = false
							activeTile[maxX..","..maxY..","..3] = false

							activeTile[minX..","..minY..","..1] = false
							activeTile[minX..","..minY..","..2] = false

							activeTile[minX..","..maxY..","..4] = false
							activeTile[minX..","..maxY..","..1] = false
							
							activeTile[maxX..","..minY..","..3] = false
							activeTile[maxX..","..minY..","..2] = false

							if minY-1 <= 0 then
								if minX-1 > 0 then
									activeTile[minX..","..minY..","..2] = true
									activeTile[minX..","..minY..","..4] = true
								end

								if maxX < grid[4] then
									activeTile[maxX..","..minY..","..2] = true
									activeTile[maxX..","..minY..","..4] = true
								end
							end

							if maxY >= grid[5] then
								if minX-1 > 0 then
									activeTile[minX..","..maxY..","..2] = true
									activeTile[minX..","..maxY..","..4] = true
								end

								if maxX < grid[4] then
									activeTile[maxX..","..maxY..","..2] = true
									activeTile[maxX..","..maxY..","..4] = true
								end
							end

							if minX-1 <= 0 then
								if minY-1 > 0 then
									activeTile[minX..","..minY..","..3] = true
									activeTile[minX..","..minY..","..1] = true
								end

								if maxY < grid[5] then
									activeTile[minX..","..maxY..","..3] = true
									activeTile[minX..","..maxY..","..1] = true
								end
							end

							if maxX >= grid[4] then
								if minY-1 > 0 then
									activeTile[maxX..","..minY..","..3] = true
									activeTile[maxX..","..minY..","..1] = true
								end

								if maxY < grid[5] then
									activeTile[maxX..","..maxY..","..3] = true
									activeTile[maxX..","..maxY..","..1] = true
								end
							end
						end
					elseif mode == "deleteWall_rect" then
						if tileX ~= ltx or tileY ~= lty then
							playSoundEx("sounds/greenline.mp3")

							ltx = tileX
							lty = tileY
						end

						for x=minX, maxX do
							for y=minY, maxY do
								for f=1, 4 do
									activeTile[x..","..y..","..f] = true
								end
							end
						end
					else
						loopTiles2(activizeTile2)
						--if lineAxis == "x" then
						--	local face = 1
	--
						--	if startTileX > tileX then
						--		face = 1
						--	else
						--		face = 3
						--	end
						--	activeTile[startTileX..","..startTileY..","..face] = true
	--
						--else
						--	local face = 1
	--
						--	if startTileY > tileY then
						--		face = 2
						--	else
						--		face = 4
						--	end
						--	activeTile[startTileX..","..startTileY..","..face] = true
						--end
						--if lineAxis == "x" then
						--	for x=minX, maxX do
						--		activeTile[x..","..startCoord..","..tileFace] = true
						--	end
						--else
						--	for y=minY, maxY do
						--		activeTile[startCoord..","..y..","..tileFace] = true
						--	end
						--end
					end
				end
			end
		end

		if movingFurniture and movingFurniture[8] and activeFurniture and lastCursor and lastCursor[2] then
			y = y-lastCursor[2]

			setCursorPosition(screenX/2, screenY/2)
			lastCursor = {0.5, 0.5}

			--y = y-0.5

			--outputDebugString(y)

			local pz = movingFurniture[7] --getElementPosition(activeFurniture)

			local z = pz-y*mouseIntensity*0.75

			if z < grid[3]-3.5 then
				z = grid[3]-3.5
			end

			if z > grid[3]+7 then
				z = grid[3]+7
			end

			movingFurniture[7] = z
			--movingFurniture = {cx, cy, x, y, px, py, pz, true}
			--setCursorAlpha(0)
	--
			--
			--local x, y = getCursorPosition()
			--lastCursor = {x, y}
			--leftPosition = {x*screenX, y*screenY}
		elseif (getKeyState("mouse2") or getKeyStateEx()) and lastCursor and lastCursor[1] then
			x = x-lastCursor[1]
			y = y-lastCursor[2]

			x = x*(screenX/screenY)

			if cameraReversed then
				if not getKeyState("mouse2") then
					x = -x
				end

				y = -y
			end
			
			setCursorPosition(screenX/2, screenY/2)
			lastCursor = {0.5, 0.5}

			if getKeyStateEx() then
				yaw = math.deg(yaw)+x*mouseIntensity
				pitch = math.deg(pitch)+y*(-mouseIntensity)

				if pitch >= 89.9 then
					pitch = 89.9
				end
				
				if pitch <= 0 then
					pitch = 0
				end

				----outputDebugString(pitch)
				----outputDebugString(yaw)

				yaw = math.rad(yaw)
				pitch = math.rad(pitch)

				orbitCamera()
			else
				local int = (mouseIntensity*dist)/100

				cam[1] = cam[1] + (y*int) * math.cos(yaw) - (x*int) * math.sin(yaw)
				cam[2] = cam[2] + (y*int) * math.sin(yaw) + (x*int) * math.cos(yaw)

				if not photoMode then
					if cam[1] < borders[1] then
						cam[1] = borders[1]
					end
					
					if cam[2] < borders[2] then
						cam[2] = borders[2]
					end

					if cam[1] > borders[3] then
						cam[1] = borders[3]
					end

					if cam[2] > borders[4] then
						cam[2] = borders[4]
					end
				end

				orbitCamera()
			end
		end
	end
end

function getCursorPositionEx()
	if leftPosition then
		return unpack(leftPosition)
	else
		local x, y = getCursorPosition()

		if x then
			return x*screenX, y*screenY
		else
			return -1, -1
		end
	end
end

function floorMode(state)
	for k=1, #walls do
		setElementCollisionsEnabled(walls[k], not state)
	end
	for k=1, #baseWalls do
		setElementCollisionsEnabled(baseWalls[k], not state)
	end
	for k, v in pairs(furnitures) do
		setElementCollisionsEnabled(k, not state)
	end
	for k, v in pairs(doors) do
		setElementCollisionsEnabled(v, not state)
	end
end

function setMode(newmode)
	if newmode == "drawWall_line" or newmode == "drawWall_rect" or newmode == "setWindow" or newmode == "setDoor" then
		local num = math.max(0, #getElementsByType("object", getRootElement(), true)-394)
		
		if num >= objectLimit then
			exports.oInfobox:outputInfoBox("Elérted a maximális objektumszámot! (" .. num .. "/" .. objectLimit .. " db)", "error")
			return
		end
	end

	if newmode ~= mode then
		setActiveFurniture(false)
		placingPrompt = false
	end

	if mode == "drawWall_line" or mode == "drawWall_rect" then
		tileX, tileY = false, false
		startTileFace = false
		startTileX, startTileY = false, false
							
		activeTile = {}
		lineAxis = false

		setWallAlphas()
		gridState = wasGrid
		wasGrid = false
		canGrid = true
		floorMode(false)
	elseif mode == "deleteWall_line" or mode == "deleteWall_rect" then
		tileX, tileY = false, false
		startTileFace = false
		startTileX, startTileY = false, false
							
		activeTile = {}
		lineAxis = false

		setWallAlphas()
		gridState = wasGrid
		wasGrid = false
		canGrid = true
		floorMode(false)
	elseif mode == "setWallpaper" then
		for k=1, #baseFloors do
			setElementCollisionsEnabled(baseFloors[k], true)
		end

		placedDoor = false

		setWallAlphas()

		paintHover = false
		currentPlacingTexture = false
	elseif mode == "setWindow" then
		for k=1, #walls do
			setElementCollisionsEnabled(walls[k], true)
		end

		placedDoor = false

		setWallAlphas()

		unuseWindowHover()

		currentPlacingTexture = false
	elseif mode == "deleteWindow" then
		for k=1, #walls do
			setElementCollisionsEnabled(walls[k], true)
		end

		placedDoor = false

		setWallAlphas()

		unuseWindowHover()
	elseif mode == "deleteDoor" then
		for k=1, #baseWalls do
			setElementCollisionsEnabled(baseWalls[k], true)
		end

		placedDoor = false

		setWallAlphas()

		unuseWindowHover()
	elseif mode == "setDoor" then
		--for k=1, #baseWalls do
		--	setElementCollisionsEnabled(baseWalls[k], true)
		--end

		placedDoor = false

		setWallAlphas()

		unuseDoorHover()

		currentPlacingTexture = false
	elseif mode == "setFloor" then
		startTileX, startTileY = false, false
		startTileFace = false
		tileX, tileY = false, false
							
		tileFace = 3
		placedDoor = false

		setWallAlphas()

		activeTile = {}

		paintHover = false
		currentPlacingTexture = false
		gridState = wasGrid
		wasGrid = false
		canGrid = true
		floorMode(false)
	elseif mode == "placeFurniture" then
		
		destroyElement(placingFurniture)

		placingFurniture = false
		canPlaceFurniture = false
		
		sideIcons = normalSideIcons
		sideWidth = sideIconSize*sideIcons+sideIconBorder*(sideIcons+2)
	elseif mode == "setCeil" then
		--showCeil(false)
		--showFloor(true)

		startTileX, startTileY = false, false
		startTileFace = false
		tileX, tileY = false, false
							
		tileFace = 3
		placedDoor = false

		setWallAlphas()

		activeTile = {}

		paintHover = false
		currentPlacingTexture = false
		gridState = wasGrid
		wasGrid = false
		canGrid = true
		floorMode(false)
	end
	
	----------------------------
	----------------------------

	if newmode == "drawWall_line" or newmode == "drawWall_rect" then
		activeColor = tocolor(r, g, b)
		setWallAlphas(true)
		wasGrid = gridState
		canGrid = false
		gridState = true
		floorMode(true)
	elseif newmode == "deleteWall_line" or newmode == "deleteWall_rect" then
		activeColor = tocolor(215, 89, 89)
		setWallAlphas(true)
		wasGrid = gridState
		canGrid = false
		gridState = true
		floorMode(true)
	elseif newmode == "setWallpaper" then
		for k=1, #baseFloors do
			setElementCollisionsEnabled(baseFloors[k], false)
		end

		setWallAlphas(true)
	elseif newmode == "setWindow" then
		for k=1, #walls do
			setElementCollisionsEnabled(walls[k], false)
		end

		setWallAlphas(true)
	elseif newmode == "deleteWindow" then
		for k=1, #walls do
			setElementCollisionsEnabled(walls[k], false)
		end

		setWallAlphas(true)
	elseif newmode == "deleteDoor" then
		for k=1, #walls do
			setElementCollisionsEnabled(baseWalls[k], false)
		end

		setWallAlphas(true)
	elseif newmode == "setDoor" then
		--for k=1, #baseWalls do
		--	setElementCollisionsEnabled(baseWalls[k], false)
		--end

		setWallAlphas(true)
	elseif newmode == "placeFurniture" then
		--floorMode(true)
		sideIcons = normalSideIcons+2
		sideWidth = sideIconSize*sideIcons+sideIconBorder*(sideIcons+2)
	elseif newmode == "setCeil" then
		--showCeil(true)
		--showFloor(false)

		activeColor = tocolor(r, g, b)
		setWallAlphas(true)
		wasGrid = gridState
		canGrid = false
		gridState = true
		floorMode(true)
	elseif newmode == "setFloor" then
		activeColor = tocolor(r, g, b)
		setWallAlphas(true)
		wasGrid = gridState
		canGrid = false
		gridState = true
		floorMode(true)
	end

	mode = newmode
	----outputDebugString(mode)
end

function removeAllTexturesFromElement(element)
	if shadersOnElements[element] then
		for k, v in pairs(shadersOnElements[element]) do
			engineRemoveShaderFromWorldTexture(shadersOnElements[element][k], k, element)
		end
	end

	if pathOnElements[element] then
		for k, v in pairs(pathOnElements[element]) do
			removeTexture(v)
		end
	end

	pathOnElements[element] = {}
	shadersOnElements[element] = {}
end

function setElementModelEx(element, model, tileX, tileY)
	local got = getElementModel(element)
	if got ~= model then
		setElementModel(element, model)

		removeAllTexturesFromElement(element)


		if model == wallModellID["four"] then
			setElementRotation(element, 0, 0, 0)
		elseif model == wallModellID["straight"] and tileX then
			if wallOnCoordiante[tileX-1 .. "," .. tileY] and wallOnCoordiante[tileX+1 .. "," .. tileY] then
				setElementRotation(element, 0, 0, 90)
			elseif wallOnCoordiante[tileX .. "," .. tileY-1] and wallOnCoordiante[tileX .. "," .. tileY+1] then
				setElementRotation(element, 0, 0, 0)
			end
		end

		return true
	else
		return false
	end
end

function checkRotation(element, rotation)
	if element then
		if getElementModel(element) == wallModellID["three"] then
			return true
		elseif getElementModel(element) == wallModellID["two"] then
			return true
		elseif getElementModel(element) == wallModellID["half"] then
			return true
		elseif getElementModel(element) == wallModellID["four"] then
			return false
		else
			local x, y, rot = getElementRotation(element)
			
			if rot > 180 then
				rot = rot - 180
			end

			----outputDebugString("check: " .. rot .. "," .. rotation)

			--return rot == rotation

			return true
		end
	else
		return false
	end
end

function makeCorner(x, y, rot)
	local el = wallOnCoordiante[x .. "," .. y]

	if el then
		if getElementModel(el) == wallModellID["three"] then
			setElementModelEx(el, wallModellID["four"])
			setElementRotation(el, 0, 0, 0)

			addCashCosts(prices["wall"])
		elseif getElementModel(el) == wallModellID["two"] then
			setElementModelEx(el, wallModellID["three"])

			addCashCosts(prices["wall"])

			local rx, ry, rz = getElementRotation(el)

			local d2 = rz-rot

			--outputDebugString(d2)

			setElementModelEx(el, wallModellID["three"])

			if d2 == 90 then
				setElementRotation(el, 0, 0, rz)
			elseif d2 == -90 then
				setElementRotation(el, 0, 0, rz+90)
			elseif d2 == -270 then
				setElementRotation(el, 0, 0, rz)
			elseif d2 == 270 then
				setElementRotation(el, 0, 0, rz+90)
			end
		else
			setElementModelEx(el, wallModellID["two"])
			setElementRotation(el, 0, 0, rot)
		end
	end
end

function deleteWall(tx, ty)
	local obj = wallOnCoordiante[tx .. "," .. ty]

	if obj then
		local model = getElementModel(obj)

		if pathOnElements[obj] then
			for k, v in pairs(pathOnElements[obj]) do
				removeTexture(v)
			end
		end

		pathOnElements[obj] = nil
		shadersOnElements[obj] = nil

		destroyElement(obj)

		wallCoordiantes[obj] = nil

		for k=1, #walls do
			if walls[k] == obj then
				table.remove(walls, k)
				break
			end
		end

		wallOnCoordiante[tx .. "," .. ty] = nil

		
		local num = 1

		if model == wallModellID["straight"] then
			num = 2
		elseif model == wallModellID["two"] then
			num = 2
		elseif model == wallModellID["three"] then
			num = 3
		elseif model == wallModellID["four"] then
			num = 4
		end

		addCashCosts(-prices["wall"]*num)
	end

	if doors[tx..","..ty] then
		doorRots[doors[tx..","..ty]] = nil
		deleteDoor(doors[tx..","..ty])
		destroyElement(doors[tx..","..ty])
		doors[tx..","..ty] = nil
	end
end

function destroyWindow(tx, ty)
	if windowOnCoordiante[tx .. "," .. ty] then
		destroyElement(windowOnCoordiante[tx .. "," .. ty])
		windowCoordiantes[windowOnCoordiante[tx .. "," .. ty]] = nil
		windowOnCoordiante[tx .. "," .. ty] = nil
		addCashCosts(-prices["window"])
	end
end


function createWall(tx, ty, rot, half, reModel)
	if not wallOnCoordiante[tx .. "," .. ty] then
		local x, y, z, rz = grid[1]+(tx-0.5)*floorBaseSize, grid[2]+(ty-0.5)*floorBaseSize-thickness/2, grid[3]+3.5/2, rot

		local theType = "straight"

		if half then
			theType = "half"
			--outputDebugString("createHalfWall")
		end

		--outputDebugString("wall: " .. (reModel or wallModellID[theType]) .. "-" .. theType)

		local obj = createObject((reModel or wallModellID[theType]), x, y, z, 0, 0, rot)
		--local obj = createObject(wallModellID["base"], x, y, z, 0, 0, rot)
		setElementInteriorAndDimension(obj, 1)
			
		--applyTextureToElement(obj, "la_carp3", "wall", "wallpaper", 58)	
		--applyTextureToElement(obj, "la_carp4", "wall", "wallpaper", 59)	
		--applyTextureToElement(obj, "la_carp5", "wall", "wallpaper", 60)	
		--applyTextureToElement(obj, "la_carp6", "wall", "wallpaper", 61)	


		table.insert(walls, obj)
		wallCoordiantes[obj] = {tx, ty}
		wallOnCoordiante[tx .. "," .. ty] = obj

		if not reModel then
			if half then
				addCashCosts(prices["wall"], true)
			else
				addCashCosts(prices["wall"]*2, true)
			end
		end

		return obj
	elseif half then
		local el = wallOnCoordiante[tx .. "," .. ty]
		local rx, ry, rz = getElementRotation(el)

		if getElementModel(el) == wallModellID["half"] then
			local rdiff = math.abs(rot-rz)
			
			if rdiff ~= 0 then
				if rdiff == 180 then
					setElementModelEx(el, wallModellID["straight"])

					if rot == 90 or rot == 270 then
						setElementRotation(el, 0, 0, 90)
					else
						setElementRotation(el, 0, 0, 0)
					end
				else
					setElementModelEx(el, wallModellID["two"])

					local d2 = rz-rot 
					
					if d2 < 0 then
						d2 = d2 +360
					end

					if d2 ~= 90 then
						setElementRotation(el, 0, 0, rz+180)
					else
						setElementRotation(el, 0, 0, rz+90)
					end
				end

				--syncWall(tx .. "," .. ty, el)
				addCashCosts(prices["wall"], true)
			end
		elseif getElementModel(el) == wallModellID["two"] then
			--setElementModelEx(el, wallModellID["three"])
			local d2 = rot-rz

			if d2 ~= -90 and d2 ~= -180 and d2 ~= 180 and d2 ~= 270 then
				setElementModelEx(el, wallModellID["three"])
				
				if d2 < 0 then
					d2 = d2 +360
				end

				if d2 ~= 90 then
					setElementRotation(el, 0, 0, rz+90)
				else
					setElementRotation(el, 0, 0, rz)
				end

				----outputDebugString(d2)

				--syncWall(tx .. "," .. ty, el)
				addCashCosts(prices["wall"], true)
			end
			--if rdiff >= 180 then
			--	rdiff = rdiff-180
			--end

			--setElementRotation(el, 0, 0, rdiff)
		elseif getElementModel(el) == wallModellID["straight"] then
			local d2 = rot-rz

			--outputDebugString(d2)

			setElementModelEx(el, wallModellID["three"])

			if d2 == 90 then
				setElementRotation(el, 0, 0, rz+270)
			elseif d2 == -90 then
				setElementRotation(el, 0, 0, rz+90)
			elseif d2 == -270 then
				setElementRotation(el, 0, 0, rz)
			elseif d2 == 270 then
				setElementRotation(el, 0, 0, rz+90)
			end

			--syncWall(tx .. "," .. ty, el)
			addCashCosts(prices["wall"], true)
		elseif getElementModel(el) == wallModellID["three"] then
			local d2 = rot-rz

			if d2 == 0 then
				setElementModelEx(el, wallModellID["four"])
				setElementRotation(el, 0, 0, 0)

				--syncWall(tx .. "," .. ty, el)
				addCashCosts(prices["wall"], true)
			end
		end
	else
		local el = wallOnCoordiante[tx .. "," .. ty]
		local rx, ry, rz = getElementRotation(el)

		if getElementModel(el) == wallModellID["straight"] then
			local d2 = rot-rz

			if d2 == 90 then
				setElementModelEx(el, wallModellID["four"])
				setElementRotation(el, 0, 0, 0)
				addCashCosts(prices["wall"]*2, true)
			end
		end
	end 
end

function getPositionFromElementOffset(element,offX,offY,offZ)
	local m = getElementMatrix ( element )  -- Get the matrix
	local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
	local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
	local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
	return x, y, z                               -- Return the transformed point
end


function createDoor(tx, ty, door, rot, texture, rePlace)
	local el = false
	local index = false

	--if isElement(tx) then
	--	el = tx
	--	index = tx
	--else
	----outputDebugString(tostring(tx))

	index = tx .. "," .. ty

	el = wallOnCoordiante[index]

	if not rePlace then
		setElementModel(el, wallModellID["door2"])
	end

	--outputDebugString("index: " .. tostring(index))

	local rx, ry, rz = getElementRotation(el)

	if not editMode then
		local x, y, z = getElementPosition(el)

		--doorColShapes[index] = createColSphere(x, y, z, 1.5)
		doorColShapes[index] = createColRectangle(x-floorBaseSize/2, y-floorBaseSize/2, floorBaseSize, floorBaseSize)
		doorColShapeIndex[doorColShapes[index]] = index
	end

	local x, y, z = -0.025, 0.785, -1.765
	
	if rot > 0 then
		x = 0.025
		y = -0.75
	end

	local x, y, z = getPositionFromElementOffset(el, x, y, z)

	doors[index] = createObject(door, x, y, z, 0, 0, rz+rot)
	doorRots[doors[index]] = rot
	doorIndexes[doors[index]] = index

	setElementInteriorAndDimension(doors[index], 1)

	if door == 1491 then
		setObjectScale(doors[index], 1.005)
	end
	setElementCollisionsEnabled(doors[index], false)

	texture = tonumber(texture)

	if not rePlace then
		addCashCosts(prices["door"][tonumber(doorReverse[door])], true)
	end

	if texture > 0 then
		applyTextureToElement(doors[index], doorTextures[door], "door", doorReverse[door], texture)	
	end
	--applyTextureToElement(el, "la_carp4", "wall", "wallpaper", 61)	
end

function resursiveSetOther(x, y, xs, ys, rot)
	if wallOnCoordiante[x .. "," .. y] then
		local rx, ry, rz = getElementRotation(wallOnCoordiante[x .. "," .. y])

		if rz ~= rot then
			setElementRotation(wallOnCoordiante[x .. "," .. y], 0, 0, rot)
			removeAllTexturesFromElement(wallOnCoordiante[x .. "," .. y])

			resursiveSetOther(x+xs, y+ys, xs, ys, rot)
		end
	end
end

function removeTexture(path)
	useNums[path] = (useNums[path] or 0) - 1

	----outputDebugString("use of " .. path .. ": " .. (useNums[path] or 0))

	if prices["texture"][path] then
		addCashCosts(-prices["texture"][path])
	end

	if useNums[path] <= 0 then

		useNums[path] = nil

		destroyElement(shaderForTexture[path])

		shaderForTexture[path] = nil

		----outputDebugString("destroy " .. path)
	end
end

function getShaderForTexture(path, theType, sub, id)
	useNums[path] = (useNums[path] or 0) + 1
	----outputDebugString("use of " .. path .. ": " .. useNums[path])

	if not shaderForTexture[path] then
		----outputDebugString("create " .. path)

		shaderForTexture[path] = dxCreateShader("files/texturechanger.fx")

		if theType == "door" then 
			theType = "doors"
		end

		dxSetShaderValue(shaderForTexture[path], "gTexture", textures[theType][sub][id])
	end

	return shaderForTexture[path]
end

function applyTextureToElement(element, texture, theType, sub, id, replace, nosound)
	if not shadersOnElements[element] then
		shadersOnElements[element] = {}
	end
	
	if not pathOnElements[element] then
		pathOnElements[element] = {}
	end

	id = tonumber(id)
	local path = table.concat({theType, sub, id}, ",")

	if pathOnElements[element][texture] ~= path then
		----outputDebugString("change " .. texture .. ": " .. path)
		local newShader = getShaderForTexture(path, theType, sub, id)

		if shadersOnElements[element][texture] ~= newShader then
			if shadersOnElements[element][texture] then
				engineRemoveShaderFromWorldTexture(shadersOnElements[element][texture], texture, element)
				removeTexture(pathOnElements[element][texture])
			end

			if prices["texture"][path] and not replace then
				--outputDebugString(theType .. "," ..  sub .. "," ..  id .. "," ..   prices["texture"][path] )
				addCashCosts(prices["texture"][path], (theType == "floor" or theType == "ceil" or nosound))
			end

			engineApplyShaderToWorldTexture(newShader, texture, element)

			shadersOnElements[element][texture] = newShader
			pathOnElements[element][texture] = path
		end
	end
end

function removeTextureFromElement(element, texture)
	if not shadersOnElements[element] then
		shadersOnElements[element] = {}
	end
	
	if not pathOnElements[element] then
		pathOnElements[element] = {}
	end

	if shadersOnElements[element][texture] and pathOnElements[element][texture] then
		engineRemoveShaderFromWorldTexture(shadersOnElements[element][texture], texture, element)
		removeTexture(pathOnElements[element][texture])

		shadersOnElements[element][texture] = nil
		pathOnElements[element][texture] = nil
	end
end

function textureSide()
	local sub, id = unpack(split(currentPlacingTexture, "/"))

	local element, px, py = unpack(paintHover)
	local ox, oy = getElementPosition(element)
	local rx, ry, rz = getElementRotation(element)
	local rot = math.atan2(py-oy, px-ox)
	
	local model = getElementModel(element)

	if model == wallModellID["base"] or model == wallModellID["window"] then
		if rz == 0 then
			if rot < 0 then
				applyTextureToElement(element, "la_carp5", "wall", sub, id)
			else
				applyTextureToElement(element, "la_carp3", "wall", sub, id)
			end
		elseif rz == 180 then
			if rot < 0 then
				applyTextureToElement(element, "la_carp3", "wall", sub, id)
			else
				applyTextureToElement(element, "la_carp5", "wall", sub, id)
			end
		elseif rz == 90 then
			if rot < -2 then
				applyTextureToElement(element, "la_carp3", "wall", sub, id)
			else
				applyTextureToElement(element, "la_carp5", "wall", sub, id)
			end
		elseif rz == 270 then
			if rot < 1 then
				applyTextureToElement(element, "la_carp3", "wall", sub, id)
			else
				applyTextureToElement(element, "la_carp5", "wall", sub, id)
			end
		end
	elseif model == wallModellID["two"] then
		if rz == 0 then
			if rot < 0 and rot >= -1 then
				applyTextureToElement(element, "la_carp6", "wall", sub, id)
			elseif rot < -1 and rot > -1.6 then
				applyTextureToElement(element, "la_carp5", "wall", sub, id)
			elseif rot > 0 then
				applyTextureToElement(element, "la_carp4", "wall", sub, id)
			else
				applyTextureToElement(element, "la_carp3", "wall", sub, id)
			end
		elseif rz == 90 then
			if rot > 0 and rot <= 0.5 then
				applyTextureToElement(element, "la_carp5", "wall", sub, id)
			elseif rot > 0.5 and rot < 1.6 then
				applyTextureToElement(element, "la_carp6", "wall", sub, id)
			elseif rot > 0 then
				applyTextureToElement(element, "la_carp4", "wall", sub, id)
			else
				applyTextureToElement(element, "la_carp3", "wall", sub, id)
			end
		elseif rz == 180 then
			if rot > 1.6 and rot <= 2.3 then
				applyTextureToElement(element, "la_carp5", "wall", sub, id)
			elseif rot > 2.3 and rot < 3.1 then
				applyTextureToElement(element, "la_carp6", "wall", sub, id)
			elseif rot < -0.8 then
				applyTextureToElement(element, "la_carp4", "wall", sub, id)
			else
				applyTextureToElement(element, "la_carp3", "wall", sub, id)
			end
		elseif rz == 270 then
			if rot < -1.6 and rot >= -2.3 then
				applyTextureToElement(element, "la_carp6", "wall", sub, id)
			elseif rot < -2.3 and rot > -3.1 then
				applyTextureToElement(element, "la_carp5", "wall", sub, id)
			elseif rot > 0.7 then
				applyTextureToElement(element, "la_carp3", "wall", sub, id)
			else
				applyTextureToElement(element, "la_carp4", "wall", sub, id)
			end
		end
	elseif model == wallModellID["four"] then
		if rot > -3.1 and rot <= -2.4 then
			applyTextureToElement(element, "la_carp9", "wall", sub, id)
		elseif rot > -2.4 and rot <= -1.6 then
			applyTextureToElement(element, "la_carp10", "wall", sub, id)
		elseif rot > -1.6  and rot <= -0.9 then
			applyTextureToElement(element, "la_carp6", "wall", sub, id)
		elseif rot > -0.9  and rot <= 0 then
			applyTextureToElement(element, "la_carp4", "wall", sub, id)
		elseif rot > 0  and rot <= 0.7 then
			applyTextureToElement(element, "la_carp5", "wall", sub, id)
		elseif rot > 0.7  and rot <= 1.6 then
			applyTextureToElement(element, "la_carp3", "wall", sub, id)
		elseif rot > 1.6  and rot <= 2.3 then
			applyTextureToElement(element, "la_carp7", "wall", sub, id)
		else
			applyTextureToElement(element, "la_carp8", "wall", sub, id)
		end
	elseif model == wallModellID["three"] then
		if rz == 0 then
			if rot > -3.1 and rot <= -2.4 then
				applyTextureToElement(element, "la_carp5", "wall", sub, id)
			elseif rot > -2.4 and rot <= -1.6 then
				applyTextureToElement(element, "la_carp6", "wall", sub, id)
			elseif rot > -1.6  and rot <= -1 then
				applyTextureToElement(element, "la_carp7", "wall", sub, id)
			elseif rot > -1  and rot <= 0 then
				applyTextureToElement(element, "la_carp8", "wall", sub, id)
			elseif rot > 1.6 then
				applyTextureToElement(element, "la_carp10", "wall", sub, id)
			else
				applyTextureToElement(element, "la_carp4", "wall", sub, id)
			end
		elseif rz == 270 then
			if rot > -3.1 and rot <= -2.4 then
				applyTextureToElement(element, "la_carp7", "wall", sub, id)
			elseif rot > -2.4 and rot <= -1.6 then
				applyTextureToElement(element, "la_carp8", "wall", sub, id)
			elseif rot > 1.6  and rot <= 2.4 then
				applyTextureToElement(element, "la_carp5", "wall", sub, id)
			elseif rot > 2.4  and rot <= 3.1 then
				applyTextureToElement(element, "la_carp6", "wall", sub, id)
			elseif rot > 0 then
				applyTextureToElement(element, "la_carp10", "wall", sub, id)
			else
				applyTextureToElement(element, "la_carp4", "wall", sub, id)
			end
		elseif rz == 180 then
			if rot > 0 and rot <= 0.7 then
				applyTextureToElement(element, "la_carp5", "wall", sub, id)
			elseif rot > 0.7 and rot <= 1.6 then
				applyTextureToElement(element, "la_carp6", "wall", sub, id)
			elseif rot > 1.6  and rot <= 2.1 then
				applyTextureToElement(element, "la_carp7", "wall", sub, id)
			elseif rot > 2.1  and rot <= 3.1 then
				applyTextureToElement(element, "la_carp8", "wall", sub, id)
			elseif rot > -1.6 then
				applyTextureToElement(element, "la_carp10", "wall", sub, id)
			else
				applyTextureToElement(element, "la_carp4", "wall", sub, id)
			end
		elseif rz == 90 then
			if rot > -1.6 and rot <= -1 then
				applyTextureToElement(element, "la_carp5", "wall", sub, id)
			elseif rot > -1 and rot <= 0 then
				applyTextureToElement(element, "la_carp6", "wall", sub, id)
			elseif rot > 0  and rot <= 0.6 then
				applyTextureToElement(element, "la_carp7", "wall", sub, id)
			elseif rot > 0.6  and rot <= 1.6 then
				applyTextureToElement(element, "la_carp8", "wall", sub, id)
			elseif rot < 0 then
				applyTextureToElement(element, "la_carp10", "wall", sub, id)
			else
				applyTextureToElement(element, "la_carp4", "wall", sub, id)
			end
		end
	elseif model == wallModellID["straight"] then
		if rz == 90 then
			if rot > -3.1 and rot <= -1.6 then
				applyTextureToElement(element, "la_carp3", "wall", sub, id)
			elseif rot > -1.6 and rot < 0 then
				applyTextureToElement(element, "la_carp4", "wall", sub, id)
			elseif rot < 1.5 then
				applyTextureToElement(element, "la_carp5", "wall", sub, id)
			else
				applyTextureToElement(element, "la_carp6", "wall", sub, id)
			end
		else
			if rot > 1.7 and rot <= 3.1 then
				applyTextureToElement(element, "la_carp3", "wall", sub, id)
			elseif rot > -3.1 and rot < -1.6 then
				applyTextureToElement(element, "la_carp4", "wall", sub, id)
			elseif rot > -1.6 and rot < 0 then
				applyTextureToElement(element, "la_carp5", "wall", sub, id)
			elseif rot > 0 and rot < 1.6 then
				applyTextureToElement(element, "la_carp6", "wall", sub, id)
			end
		end
	elseif model == wallModellID["half"] then
		if rz == 90 then
			if rot < 0 then
				applyTextureToElement(element, "la_carp3", "wall", sub, id)
			else 
				applyTextureToElement(element, "la_carp4", "wall", sub, id)
			end
		elseif rz == 270 then
			if rot < 0 then
				applyTextureToElement(element, "la_carp4", "wall", sub, id)
			else 
				applyTextureToElement(element, "la_carp3", "wall", sub, id)
			end
		elseif rz == 0 then
			if rot > 1.6 then
				applyTextureToElement(element, "la_carp3", "wall", sub, id)
			else 
				applyTextureToElement(element, "la_carp4", "wall", sub, id)
			end
		elseif rz == 180 then
			if rot < -1.6 then
				applyTextureToElement(element, "la_carp4", "wall", sub, id)
			else
				applyTextureToElement(element, "la_carp3", "wall", sub, id)
			end
		end
	elseif model == wallModellID["door"] or model == wallModellID["door2"] then
		if rz == 90 then
			if rot > 0 then
				if baseDoor[2] ~= element then
					--outputDebugString(rz .. "=" .. "la_carp3")
					applyTextureToElement(element, "la_carp3", "wall", sub, id)
				end
			else 
				--outputDebugString(rz .. "=" .. "la_carp5")
				applyTextureToElement(element, "la_carp5", "wall", sub, id)
			end
		elseif rz == 0 then
			if rot < 1.6 and rot > -1.6 then
				if baseDoor[2] ~= element then
					--outputDebugString(rz .. "=" .. "la_carp3")
					applyTextureToElement(element, "la_carp3", "wall", sub, id)
				end
			else 
				--outputDebugString(rz .. "=" .. "la_carp5")
				applyTextureToElement(element, "la_carp5", "wall", sub, id)
			end
		elseif rz == 270 then
			if rot > 0 then
				--outputDebugString(rz .. "=" .. "la_carp5")
				applyTextureToElement(element, "la_carp5", "wall", sub, id)
			else
				if baseDoor[2] ~= element then
					--outputDebugString(rz .. "=" .. "la_carp3")
					applyTextureToElement(element, "la_carp3", "wall", sub, id)
				end
			end
		elseif rz == 180 then
			if rot < 1.6 and rot > -1.6 then
				--outputDebugString(rz .. "=" .. "la_carp5")
				applyTextureToElement(element, "la_carp5", "wall", sub, id)
			else 
				if baseDoor[2] ~= element then
					--outputDebugString(rz .. "=" .. "la_carp3")
					applyTextureToElement(element, "la_carp3", "wall", sub, id)
				end
			end
		end
	end

	----outputDebugString(rz .. ", " .. rot)
end

function showCeil(state)
	for k=1, #baseCeils do
		setElementInteriorAndDimension(baseCeils[k], (state and 1 or 2))
		setElementCollisionsEnabled(baseCeils[k], state)
	end
end

function showFloor(state)
	for k=1, #baseFloors do
		setElementInteriorAndDimension(baseFloors[k], (state and 1 or 2))
		setElementCollisionsEnabled(baseFloors[k], state)
	end
end

function setTest()
	activeButton = false
	setMode("looking")
	testMode = not testMode

	--playSoundEx("sounds/testmode.mp3")

	if testMode then

		showCursor(false)
		setCameraTarget(localPlayer)

		local x = cam[1]
		local y = cam[2]


		if x < borders[1]+1 then
			x = borders[1]+1
		end
		
		if y < borders[2]+1 then
			y = borders[2]+1
		end

		if x > borders[3]-1 then
			x = borders[3]-1
		end

		if y > borders[4]-1 then
			y = borders[4]-1
		end

		setElementPosition(localPlayer, x, y, cam[3]+0.5)
		setElementFrozen(localPlayer, false)
		setMode("test")

		sideIcons = testSideIcons
		sideWidth = sideIconSize*sideIcons+sideIconBorder*(sideIcons+2)

		showCeil(true)

		for k, v in pairs(doors) do
			setElementCollisionsEnabled(v, true)
			setElementModel(wallOnCoordiante[k], wallModellID["door"])
		end
	else

		showCursor(true)

		setCameraMatrix(cam[4], cam[5], cam[6], cam[1], cam[2], cam[3])
		setElementPosition(localPlayer, 0, 0, 0)
		setElementFrozen(localPlayer, true)
		setMode("looking")

		sideIcons = normalSideIcons
		sideWidth = sideIconSize*sideIcons+sideIconBorder*(sideIcons+2)

		showCeil(false)

		for k, v in pairs(doors) do
			setElementCollisionsEnabled(v, false)

			local rx, ry, rz = getElementRotation(wallOnCoordiante[k])

			setElementRotation(v, 0, 0, doorRots[v]+rz)
			setElementModel(wallOnCoordiante[k], wallModellID["door2"])
		end
	end

	if cameraReversed and testMode then
		--showCeil(false)
		showFloor(true)
		--reverseCamera(false)
	elseif cameraReversed and not testMode then
		showCeil(true)
		showFloor(false)
		--reverseCamera(true)
	end
end


function fromString(data)
	local proc = split(data, ";")

	local tmp = {}

	---*************************************************--
	
	tmp["costs"] = tonumber(proc[1])
	
	---*************************************************--

	if proc[2] ~= "-" and proc[2] then
		tmp["walls"] = {}

		local walls = split(proc[2], "|")

		for k=1, #walls do
			local dat = split(walls[k], "-")

			if dat[4] then
				local dat2 = split(dat[4], "/")

				dat[4] = {}

				for k=1, #dat2, 2 do
					dat[4][dat2[k]] = dat2[k+1]
				end
			end

			table.insert(tmp["walls"], dat)
		end
	end

	---*************************************************--

	tmp["baseWalls"] = {}

	if proc[3] ~= "-" and proc[3] then
		local dat = split(proc[3], "/")

		for k=1, #dat, 3 do
			table.insert(tmp["baseWalls"], {dat[k], dat[k+1], dat[k+2]})
		end
	end

	---*************************************************--

	tmp["baseFloors"] = {}

	if proc[4] ~= "-" and proc[4] then
		local dat = split(proc[4], "/")

		for k=1, #dat, 3 do
			table.insert(tmp["baseFloors"], {dat[k], dat[k+1], dat[k+2]})
		end
	end

	---*************************************************--

	tmp["baseCeils"] = {}

	if proc[5] ~= "-" and proc[5] then
		local dat = split(proc[5], "/")

		for k=1, #dat, 3 do
			table.insert(tmp["baseCeils"], {dat[k], dat[k+1], dat[k+2]})
		end
	end

	---*************************************************--

	tmp["windows"] = {}

	if proc[6] ~= "-" and proc[6] then
		local dat = split(proc[6], "/")

		for k=1, #dat, 3 do
			table.insert(tmp["windows"], {dat[k], dat[k+1], dat[k+2]})
		end
	end

	---*************************************************--
	
	tmp["doors"] = {}

	if proc[7] ~= "-" and proc[7] then
		local dat = split(proc[7], "/")

		for k=1, #dat, 4 do
			table.insert(tmp["doors"], {dat[k], dat[k+1], dat[k+2], dat[k+3]})
		end
	end

	---*************************************************--
	
	tmp["furnitures"] = {}

	if proc[8] ~= "-" and proc[8] then
		local dat = split(proc[8], "/")

		for k=1, #dat, 5 do
			table.insert(tmp["furnitures"], {dat[k], dat[k+1], dat[k+2], dat[k+3], dat[k+4]})
		end
	end

	---*************************************************--

	tmp["baseDoor"] = {}

	if proc[9] ~= "-" and proc[9] then
		local dat = split(proc[9], "/")

		tmp["baseDoor"][2] = dat[1]
		tmp["baseDoor"][3] = dat[2]
		tmp["baseDoor"][4] = dat[3]
		tmp["baseDoor"][5] = dat[4]
	end

	---*************************************************--

	return tmp
end

function toString(data)
	local str = ""
	
	---*************************************************--

	str = str .. data["costs"] .. ";"

	---*************************************************--

	if data["walls"] and #data["walls"] > 0 then
		local walls = {}

		for k=1, #data["walls"] do
			local wallStr = data["walls"][k][1] .. "-"
			wallStr = wallStr .. data["walls"][k][2] .. "-"
			wallStr = wallStr .. data["walls"][k][3]

			if data["walls"][k][4] then
				local txt = {}
				for k, v in pairs(data["walls"][k][4]) do
					table.insert(txt, k)
					table.insert(txt, v)
				end

				wallStr = wallStr .. "-" .. table.concat(txt, "/")
			end

			table.insert(walls, wallStr)
		end

		str = str .. table.concat(walls, "|")
	else
		str = str .. "-"
	end
	
	---*************************************************--

	str = str .. ";"


	if data["baseWalls"] and #data["baseWalls"] > 0 then
		for k=1, #data["baseWalls"] do
			--print(toJSON(data["baseWalls"][k]))

			str = str .. data["baseWalls"][k][1] .. "/"
			str = str .. data["baseWalls"][k][2] .. "/"
			str = str .. data["baseWalls"][k][3] .. "/"
		end
	else
		str = str .. "-"
	end

	---*************************************************--

	str = str .. ";"

	if data["baseFloors"] and #data["baseFloors"] > 0 then
		for k=1, #data["baseFloors"] do
			str = str .. data["baseFloors"][k][1] .. "/"
			str = str .. data["baseFloors"][k][2] .. "/"
			str = str .. data["baseFloors"][k][3] .. "/"
		end
	else
		str = str .. "-"
	end

	---*************************************************--

	str = str .. ";"

	if data["baseCeils"] and #data["baseCeils"] > 0 then
		for k=1, #data["baseCeils"] do
			str = str .. data["baseCeils"][k][1] .. "/"
			str = str .. data["baseCeils"][k][2] .. "/"
			str = str .. data["baseCeils"][k][3] .. "/"
		end
	else
		str = str .. "-"
	end

	---*************************************************--

	str = str .. ";"

	if data["windows"] and #data["windows"] > 0 then
		for k=1, #data["windows"] do
			str = str .. data["windows"][k][1] .. "/"
			str = str .. data["windows"][k][2] .. "/"
			str = str .. data["windows"][k][3] .. "/"
		end
	else
		str = str .. "-"
	end

	---*************************************************--

	str = str .. ";"

	if data["doors"] and #data["doors"] > 0 then
		for k=1, #data["doors"] do
			str = str .. data["doors"][k][1] .. "/"
			str = str .. data["doors"][k][2] .. "/"
			str = str .. data["doors"][k][3] .. "/"
			str = str .. data["doors"][k][4] .. "/"
		end
	else
		str = str .. "-"
	end

	---*************************************************--

	str = str .. ";"

	if data["furnitures"] and #data["furnitures"] > 0 then
		for k=1, #data["furnitures"] do
			str = str .. data["furnitures"][k][1] .. "/"
			str = str .. data["furnitures"][k][2] .. "/"
			str = str .. data["furnitures"][k][3] .. "/"
			str = str .. data["furnitures"][k][4] .. "/"
			str = str .. data["furnitures"][k][5] .. "/"
			--str = str .. data["furnitures"][k][6] .. "/"
			--str = str .. data["furnitures"][k][7] .. "/"
		end
	else
		str = str .. "-"
	end

	---*************************************************--

	str = str .. ";"

	if data["baseDoor"] then
		str = str .. table.concat(baseWallCoordinates[data["baseDoor"][2]], ",") .. "/"
		str = str .. data["baseDoor"][3] .. "/"
		str = str .. data["baseDoor"][4] .. "/"
		str = str .. data["baseDoor"][5]
	else
		str = str .. "-"
	end

	---*************************************************--

	return str
end

local devModelId = false
local lastSafeSelect = 0

function toggleInfoState()
	infoState = not infoState
end

function toggleBcgMusic()
	if bcgMusicElement then
		destroyElement(bcgMusicElement)
		bcgMusicElement = false
	else
		bcgMusicElement = playSound("sounds/bgMusic/"..math.random(1,4)..".mp3", true)
	end
end

local canSave = false
local lastSave = 0

function onClientClick(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if button == "left" and activeFurniture and (not clickedElement or not furnitures[clickedElement]) then
		----outputDebugString(activeButton)
		if not activeButton and state == "down" then
			setActiveFurniture(false)
			return
		end
	end

	if not activeButton then
		if button == "left" and clickedElement and furnitures[clickedElement] and state == "down" and mode == "looking" then
			setActiveFurniture(clickedElement)
			return
		elseif button == "left" and clickedElement and getElementModel(clickedElement) == 2332 and getElementData(clickedElement, "safeId") and state == "down" and mode == "looking" and getTickCount()-lastSafeSelect > 1000 then
			setActiveFurniture(clickedElement)
			lastSafeSelect = getTickCount()
		elseif button == "left" and clickedElement and getElementModel(clickedElement) == 2964 and getElementData(clickedElement, "poolTableID") and state == "down" and mode == "looking" and getTickCount()-lastSafeSelect > 1000 then
			setActiveFurniture(clickedElement)
			lastSafeSelect = getTickCount()
			return
		end
	end

	if activeButton and state == "down" then
		if button == "left" then
			local cmd = split(activeButton, ":")

			if cmd[#cmd] == "selectSound" then
				playSoundEx("sounds/show.mp3")
			end

			--outputDebugString("act btn: " .. activeButton)
			--outputDebugString("cmd last: " .. cmd[#cmd])

			if cmd[1] == "music" then
				toggleBcgMusic()
			elseif cmd[1] == "test" then
				setTest()
			elseif cmd[1] == "promptYes" then
				if placingPrompt[1] == "billiard" then
					triggerServerEvent("intiEdit:placeBilliard", localPlayer, placingPrompt)
				elseif placingPrompt[1] == "safe" then
					triggerServerEvent("intiEdit:placeSafe", localPlayer, placingPrompt)
				elseif placingPrompt[1] == "buyPPFurniture" then
					triggerServerEvent("intiEdit:buyPPFurniture", localPlayer, editingInteriorID, placingPrompt[2])
				elseif placingPrompt[1] == "exit" then
					triggerServerEvent("intiEdit:exitInterior", localPlayer)
				end
				
				placingPrompt = false
			elseif cmd[1] == "promptNo" then
				placingPrompt = false
			elseif cmd[1] == "exit" then
				placingPrompt = {"exit"}
			elseif cmd[1] == "infoState" then
				toggleInfoState()
			elseif cmd[1] == "infoPage" then
				currentInfoPage[mainSelection] = tonumber(cmd[2]) or 1
			elseif cmd[1] == "save" then
				if canSave then
					canSave = false
					setMode("looking")

					local cDiff = cashCosts-paidCashCosts

					--print(cDiff)

					if cDiff > 0 then
						if getElementData(localPlayer, "char:money") < cDiff then
							exports.oInfobox:outputInfoBox("Nincs elég pénzed!", "error")
							canSave = true
							return
						end
					else
						canSave = true
					end

					local data = {}

					data["walls"] = {}
					for k, v in pairs(wallOnCoordiante) do
						local x, y, z = getElementRotation(v)

						----outputDebugString(k .. "," .. z .. "," .. getElementModel(v))

						local tbl = {k, z, getElementModel(v)}

						if pathOnElements[v] then
							tbl[4] = {}
							local sum = 0
							--pathOnElements[element][texture]

							for k, v in pairs(pathOnElements[v]) do
								tbl[4][smallTextureName(k)] = smallPathName(v)
								sum = sum + 1
							end

							if sum < 1 then
								tbl[4] = nil
							end
						end

						table.insert(data["walls"], tbl)
					end

					data["baseWalls"] = {}

					for k1=1, #baseWalls do
						if pathOnElements[baseWalls[k1]] then
							for k, v in pairs(pathOnElements[baseWalls[k1]]) do
								--if v ~= "wall,paint,1" then
									table.insert(data["baseWalls"], {table.concat(baseWallCoordinates[baseWalls[k1]], ","), smallTextureName(k), smallPathName(v)})
								--end
							end
						end
					end

					data["baseFloors"] = {}

					for k1=1, #baseFloors do
						if pathOnElements[baseFloors[k1]] then
							for k, v in pairs(pathOnElements[baseFloors[k1]]) do
								table.insert(data["baseFloors"], {table.concat(floorCoordinates[baseFloors[k1]], ","), smallTextureName(k), smallPathName(v)})
							end
						end
					end

					data["baseCeils"] = {}

					for k1=1, #baseCeils do
						if pathOnElements[baseCeils[k1]] then
							for k, v in pairs(pathOnElements[baseCeils[k1]]) do
								table.insert(data["baseCeils"], {table.concat(ceilCoordinates[baseCeils[k1]], ","), smallTextureName(k), smallPathName(v)})
							end
						end
					end

					data["windows"] = {}

					for k, v in pairs(windowOnCoordiante) do
						--window,normal,
						local texture = utf8.sub(pathOnElements[v]["la_carp4"], 15) 
						local x, y, rot = getElementRotation(v)

						table.insert(data["windows"], {k, texture, rot})
					end
					
					data["doors"] = {}

					for k, v in pairs(doors) do
						--door,1,
						--door,2,
						--door,3,
						--door,4,

						local door = getElementModel(v)

						local texture = 0

						if pathOnElements[v] and pathOnElements[v][doorTextures[door]] then
							texture = utf8.sub(pathOnElements[v][doorTextures[door]], 8)
						end

						table.insert(data["doors"], {k, door, texture, doorRots[v]})
					end

					data["furnitures"] = {}

					for k, v in pairs(furnitures) do
						local x, y, z = getElementPosition(k)
						local rx, ry, rz = getElementRotation(k)

						table.insert(data["furnitures"], {getElementModel(k), x, y, z, rz})
					end

					data["costs"] = cashCosts

					data["baseDoor"] = currentBaseDoor

					local doorFixed = false

					for k, v in pairs(doorLocked) do
						if v == "inservice" or v == "unlocked" then
							doorLocked[k] = nil
							doorFixed = true
						end
					end

					if doorFixed then
						saveDynamicData()
					end

					showChat(true)
					exports.oInterface:toggleHud(false)
					triggerServerEvent("intiEdit:saveInterior", localPlayer, editingInteriorID, toString(data), cashCosts)
				end
			elseif cmd[1] == "deleteFurniture" then
				if isElement(activeFurniture) then
					local model = getElementModel(activeFurniture)

					if useableTvs[model] then
						setElementData(localPlayer, "char:pp", getElementData(localPlayer, "char:pp") + prices["furnitures"][model])
						ppCount[model] = (ppCount[model] or 0) - 1
					else
						addCashCosts(-prices["furnitures"][model])
					end

					furnitures[activeFurniture] = nil
					destroyElement(activeFurniture)

					setActiveFurniture(false)

					--playSoundEx("sounds/deletebasic.mp3")
				end
			elseif cmd[1] == "placeOnFloor" then
				local x, y, z = getElementPosition(activeFurniture)

				z = grid[3]+getElementDistanceFromCentreOfMassToBaseOfModel(activeFurniture)+thickness/2

				setElementPosition(activeFurniture, x, y, z)
			elseif cmd[1] == "rotateMode" then
				if cmd[2] == "on" then
					rotateMode = true
				else
					rotateMode = false
				end
			elseif cmd[1] == "snap" then
				if cmd[2] == "0" then
					snapping = false
				else
					snapping = tonumber(cmd[2])
				end
			elseif cmd[1] == "snapr" then
				if cmd[2] == "0" then
					snappingR = false
				else
					snappingR = tonumber(cmd[2])
				end

				if snappingR then
					local s = 0

					if snappingR < 10 then
						s = 10
					else
						s = 5
					end
					
					lastRot = math.ceil(lastRot/s)*s
				end
			elseif cmd[1] == "day" then
				setDaytime()
				playSound("sounds/switch.mp3")
			elseif cmd[1] == "grid" then
				--outputDebugString(tostring(canGrid))
				if canGrid then
					gridState = not gridState
				end
			elseif cmd[1] == "sub" then
				setMode("looking")
				
				if cmd[2] == "ceil" then
					showCeil(true)
					showFloor(false)
					reverseCamera(true)
				elseif subSelection == "ceil" then
					showCeil(false)
					showFloor(true)
					reverseCamera(false)
				end

				subSelection = cmd[2]

				if subSelection == "premium" then
					playSoundEx("sounds/show.mp3")
					--playSoundEx("sounds/categorypremium.mp3")
				else
					playSoundEx("sounds/show.mp3")
					--playSoundEx("sounds/category.mp3")
				end
			elseif cmd[1] == "main" then
				setMode("looking")
				
				if subSelection == "ceil" then
					showCeil(false)
					showFloor(true)
					reverseCamera(false)
				end

				mainSelection = cmd[2]
				subSelection = defaultSubs[mainSelection]
				--scrollOffset = 0
				--playSoundEx("sounds/category.mp3")
			elseif cmd[1] == "mode" then
				modeClick(cmd)
			end
		end
	else
		if not global.hoveringBottomMenu() then
			if mode ~= "looking" and button == "right" then
				if state == "down" then
					if startTileX then
						startTileX, startTileY = false
						startTileFace = false
						activeTile = {}
					--else
					--	setMode("looking")
					end
				end
			else
				if mode == "placeFurniture" then
					if canPlaceFurniture and button == "left" and state == "down" then
						local model = getElementModel(placingFurniture)

						if getElementModel(placingFurniture) == 2332 then 
							local x, y, z = getElementPosition(placingFurniture)
							local rx, ry, rz = getElementRotation(placingFurniture)
							triggerServerEvent("intiEdit:placeSafe", localPlayer, {_, x, y, z + 0.5, rx, ry, rz})
							destroyElement(placingFurniture)
						else
							local obj = placingFurniture
							furnitures[placingFurniture] = true
							setElementCollisionsEnabled(placingFurniture, true)
						end
						--table.insert(furnitures, placingFurniture)

						if useableTvs[model] then
							if getElementData(localPlayer, "char:pp") >= prices["furnitures"][model] then
								setElementData(localPlayer, "char:pp", getElementData(localPlayer, "char:pp") - prices["furnitures"][model])
								ppCount[model] = (ppCount[model] or 0) + 1
							else
								exports.oInfobox:outputInfoBox("Nincs elég prémium pontod! ("..prices["furnitures"][model].."PP)", "error")
								furnitures[placingFurniture] = nil
								destroyElement(placingFurniture)
							end
						elseif model == 2332 then
						else
							addCashCosts(prices["furnitures"][model])
						end

						placingFurniture = false

						setMode("looking")
					end
				elseif mode == "setWallpaper" then
					if button == "left" and state == "down" then
						if paintHover then
							textureSide()
						end
					end
				elseif mode == "deleteDoor" then
					if button == "left" and state == "down" then
						if wallCoordiantes[windowHover] then
							local coord = table.concat(wallCoordiantes[windowHover], ",")
							if doorLocked[coord] then
								if doorLocked[coord] == "damaged" then
									addCashCosts(prices["lock"])
									
									doorLocked[coord] = "inservice"
								else
									doorLocked[coord] = "unlocked"
								end
							end
						end

						windowHover = false
						windowHoverBaseModel = false
						windowHoverTexture = false
						windowHoverRotation = false

						--playSoundEx("sounds/deletebasic.mp3")
					end
				elseif mode == "deleteWindow" then
					if button == "left" and state == "down" then
						windowHover = false
						windowHoverBaseModel = false
						windowHoverTexture = false
						windowHoverRotation = false

						--playSoundEx("sounds/deletebasic.mp3")
					end
				elseif mode == "setWindow" then
					if button == "left" and state == "down" then
						windowHover = false
						windowHoverBaseModel = false
						windowHoverTexture = false
						windowHoverRotation = false

						playSoundEx("sounds/chipdrop.mp3")
					end
				elseif mode == "setDoor" then
					if button == "left" and state == "down" then
						if baseWallCoordinates[windowHover] then
							setCurrentBaseDoor()
						end

						if wallCoordiantes[windowHover] then
							local coord = table.concat(wallCoordiantes[windowHover], ",")
							--outputDebugString("wall coord: " .. tostring(coord) .. ", locked: " .. tostring(doorLocked[coord]))
							if doorLocked[coord] == "damaged" then
								addCashCosts(prices["lock"])

								doorLocked[coord] = "inservice"
							else
								doorLocked[coord] = "unlocked"
							end
						end

						windowHover = false
						windowHoverBaseModel = false
						windowHoverTexture = false
						windowHoverRotation = false
						doorDefaultState = false

						playSoundEx("sounds/chipdrop.mp3")
					end
				elseif mode == "setFloor" then
					if button == "left" then
						--if paintHover then
						--	local sub, id = unpack(split(currentPlacingTexture, "/"))
						--	applyTextureToElement(paintHover[1], "la_carp" .. tileFace, "floor", sub, id)
						--end

						----outputDebugString("sf: " .. tileFace)

						if state == "down"  then
							if tileX then
								startTileX, startTileY, startTileFace = tileX, tileY, tileFace
							end
						else
							if startTileX then
								playSoundEx("sounds/chipdrop.mp3")
								loopTiles(applyTileTexture)
								activeTile = {}
								startTileX, startTileY = false, false
								startTileFace = false
							end
						end
					end
				elseif mode == "setCeil" then
					if button == "left" then
						--if paintHover then
						--	local sub, id = unpack(split(currentPlacingTexture, "/"))
						--	applyTextureToElement(paintHover[1], "la_carp" .. tileFace, "floor", sub, id)
						--end

						----outputDebugString("sf: " .. tileFace)

						if state == "down"  then
							if tileX then
								startTileX, startTileY, startTileFace = tileX, tileY, tileFace
							end
						else
							if startTileX then
								playSoundEx("sounds/chipdrop.mp3")
								loopTiles(applyCeilTexture)
								activeTile = {}
								startTileX, startTileY = false, false
								startTileFace = false
							end
						end
					end
				elseif mode == "drawWall_line" or mode == "drawWall_rect" or mode == "deleteWall_line" or mode == "deleteWall_rect" then
					if button == "left" then
						if state == "down" then
							if tileX then
								startTileX, startTileY = tileX, tileY

								if mode == "drawWall_line" or mode == "deleteWall_line" then
									startTileFace = tileFace

									if tileFace == 1 or tileFace == 3 then
										lineAxis = "x"
									else
										lineAxis = "y"
									end
								end
							end
						else
							--[[
							if tileX and startTileX then
								local minX = math.min(startTileX, tileX)
								local minY = math.min(startTileY, tileY)
								local maxX = math.max(startTileX, tileX)
								local maxY = math.max(startTileY, tileY)

								if minY-1 > 0 then
									for x=minX, maxX do
										createWall(x, minY-1, 1, 180)
									end
								end

								if maxY < grid[5] then
									for x=minX, maxX do
										createWall(x, maxY, 1, 0)
									end
								end

								if minX-1 > 0 then
									for y=minY, maxY do
										createWall(minX-1, y, 2, 180)
									end
								end

								if maxX < grid[4] then
									for y=minY, maxY do
										createWall(maxX, y, 2, 0)
									end
								end

								--corrigateY()
							end
							--]]

							if startTileX and tileX then
								local minX = math.min(startTileX, tileX)
								local minY = math.min(startTileY, tileY)
								local maxX = math.max(startTileX, tileX)
								local maxY = math.max(startTileY, tileY)

								if (minX == maxX or minY == maxY) and (mode == "drawWall_rect") then
									--if wallOnCoordiante[tileX-1 .. "," .. tileY] and wallOnCoordiante[tileX+1 .. "," .. tileY] then
									--	createWall(tileX, tileY, 90)
									--elseif wallOnCoordiante[tileX .. "," .. tileY-1] and wallOnCoordiante[tileX .. "," .. tileY+1] then
									--	createWall(tileX, tileY, 0)
									--elseif wallOnCoordiante[tileX-1 .. "," .. tileY] then
									--	createWall(tileX, tileY, 90)
	--
									--	resursiveSetOther(tileX-1, tileY, -1, 0, 90)
									--	resursiveSetOther(tileX+1, tileY, 1, 0, 90)
									--elseif wallOnCoordiante[tileX+1 .. "," .. tileY] then
									--	createWall(tileX, tileY, 90)
	--
									--	resursiveSetOther(tileX-1, tileY, -1, 0, 90)
									--	resursiveSetOther(tileX+1, tileY, 1, 0, 90)
									--elseif wallOnCoordiante[tileX .. "," .. tileY-1] then
									--	createWall(tileX, tileY, 0)
	--
									--	resursiveSetOther(tileX, tileY-1, 0, -1, 0)
									--	resursiveSetOther(tileX, tileY+1, 0, 1, 0)
									--elseif wallOnCoordiante[tileX .. "," .. tileY+1] then
									--	createWall(tileX, tileY, 0)
	--
									--	resursiveSetOther(tileX, tileY-1, 0, -1, 0)
									--	resursiveSetOther(tileX, tileY+1, 0, 1, 0)
									--else
									--	createWall(tileX, tileY, 0)
									--end
								elseif mode == "drawWall_line" then--or ((maxX == minX or maxY == minY) and mode == "drawWall_rect") then
									--if not lineAxis then
									--	if minX == maxX then
									--		lineAxis = "y"
									--	elseif minY == maxY then
									--		lineAxis = "x"
									--	end
									--end
	--
									--if lineAxis == "x" then
									--	for x=minX, maxX-1 do
									--		createWall(x, startCoord, 90)
									--	end
									--elseif lineAxis == "y" then
									--	for y=minY, maxY-1 do
									--		createWall(startCoord, y, 0)
									--	end
									--end

									loopTiles2(placeLineWalls)
								elseif mode == "drawWall_rect" then
									if minY-1 > 0 then
										for x=minX, maxX do
											createWall(x, minY, 90)
										end
									end

									if maxY < grid[5] then
										for x=minX, maxX do
											createWall(x, maxY, 90)
										end
									end

									if minX-1 > 0 then
										for y=minY, maxY do
											createWall(minX, y, 0)
										end
									end

									if maxX < grid[4] then
										for y=minY, maxY do
											createWall(maxX, y, 0)
										end
									end

									if maxY < grid[5] and maxX < grid[4] then
										makeCorner(maxX, maxY, 270)
									end
									
									if minY-1 > 0 and minX-1 > 0 then
										makeCorner(minX, minY, 90)
									end

									if minX-1 > 0 and maxY < grid[5] then
										makeCorner(minX, maxY, 0)
									end

									if minY-1 > 0 and maxX < grid[4] then
										makeCorner(maxX, minY, 180)
									end

									playSoundEx("sounds/construct" .. math.random(2) .. ".mp3")
								elseif mode == "deleteWall_line" then
									if lineAxis == "x" then
										for x=minX, maxX do
											deleteWall(x, startCoord)
										end
									elseif lineAxis == "y" then
										for y=minY, maxY do
											deleteWall(startCoord, y)
										end
									else
										deleteWall(tileX, tileY)
									end

									playSoundEx("sounds/deletewall.mp3")
								elseif mode == "deleteWall_rect" then
									for x=minX, maxX do
										for y=minY, maxY do
											deleteWall(x, y)
										end
									end

									playSoundEx("sounds/deletewall.mp3")
								end

								--checkCorners()
							end

							lineAxis = false
							startTileX, startTileY = false, false
							
							activeTile = {}
						end
					end
				end
			end
		end
	end
end

function modeClick(cmd)
	if cmd[2] == "setWallpaper" then
		if currentPlacingTexture == cmd[3] then
			setMode("looking")
		else
			currentPlacingTexture = cmd[3]

			if mode ~= "setWallpaper" then
				setMode("setWallpaper")
			end
		end
	elseif cmd[2] == "placeFurniture" then
		if placingFurniture and getElementModel(placingFurniture) == cmd[3] then
			setMode("looking")
		else
			--currentPlacingTexture = cmd[3]
			local model = tonumber(cmd[3])

			if model == 2332 then
				lastRot = 0

				local objs = getElementsByType("object", getRootElement(), true)

				for k=1, #objs do
					if getElementModel(objs[k]) == 2332 then
						if not getElementData(objs[k], "opreview") then
							exports.oInfobox:outputInfoBox("Már van egy széf ebben az interiorban.", "error")
							return
						end
					end
				end
			end

			if mode ~= "placeFurniture" then
				local num = math.max(0, #getElementsByType("object", getRootElement(), true)-394)
				
				if num >= objectLimit then
					exports.oInfobox:outputInfoBox("Elérted a maximális objektumszámot! (" .. num .. "/" .. objectLimit .. " db)", "error")
					return
				end

				setMode("placeFurniture")

				placingFurniture = createObject(model, 0, 0, 0, 0, 0, lastRot)
				setObjectBreakable(placingFurniture, false)
				setElementDoubleSided(placingFurniture, true)
				setElementCollisionsEnabled(placingFurniture, false)
				setElementInteriorAndDimension(placingFurniture, 1)
			else
				setElementModel(placingFurniture, model)
			end
		end
	elseif cmd[2] == "setCeil" then
		if currentPlacingTexture == cmd[3] then
			setMode("looking")
		else
			currentPlacingTexture = cmd[3]

			if mode ~= "setCeil" then
				setMode("setCeil")
			end
		end
	elseif cmd[2] == "setFloor" then
		if currentPlacingTexture == cmd[3] then
			setMode("looking")
		else
			currentPlacingTexture = cmd[3]

			if mode ~= "setFloor" then
				setMode("setFloor")
			end
		end
	elseif cmd[2] == "setWindow" then
		if currentPlacingTexture == cmd[3] then
			setMode("looking")
		else
			currentPlacingTexture = cmd[3]

			if mode ~= "setWindow" then
				setMode("setWindow")
			end
		end
	elseif cmd[2] == "setDoor" then
		if currentPlacingTexture == cmd[3] then
			setMode("looking")
		else
			currentPlacingTexture = cmd[3]

			if mode ~= "setDoor" then
				setMode("setDoor")
			end
		end
	else
		if mode == cmd[2] then
			setMode("looking")
		else
			setMode(cmd[2])
		end
	end
end

function drawItemRectangle(x, icon, text, name, active, size, stretch, tText)
	local icon = icon
	local modelType
	local modelID
	if type(icon) == 'table' then
		modelType = icon[1]
		modelID = icon[2]
		icon = nil
	end
	global.rectangles = global.rectangles+1
	local hover = (cx >= oneItemWidth*(x-1)+itemBorder and cy >= screenY-mainRectSize+itemBorderY+yMinus+itemPlusY and cx <= oneItemWidth*x and cy <= screenY-mainRectSize+itemBorderY+yMinus+itemPlusY+mainRectSize-itemBorderY*2)

	x = x + 0.005
	if active then
		dxDrawRectangle(oneItemWidth*(x-1)+itemBorder, screenY-mainRectSize+itemBorderY+yMinus+itemPlusY, oneItemWidth-itemBorder, mainRectSize-itemBorderY*2, tocolor(r, g, b, 150))
		
		if hover then
			activeButton = name
			dxDrawRectangle(oneItemWidth*(x-1)+itemBorder+2, screenY-mainRectSize+itemBorderY+yMinus+itemPlusY+2, oneItemWidth-itemBorder-4, mainRectSize-itemBorderY*2-4, tocolor(30, 30, 30, 200))
		else
			dxDrawRectangle(oneItemWidth*(x-1)+itemBorder+2, screenY-mainRectSize+itemBorderY+yMinus+itemPlusY+2, oneItemWidth-itemBorder-4, mainRectSize-itemBorderY*2-4, tocolor(30, 30, 30, 250))
		end
	elseif hover then
		activeButton = name
		dxDrawRectangle(oneItemWidth*(x-1)+itemBorder, screenY-mainRectSize+itemBorderY+yMinus+itemPlusY, oneItemWidth-itemBorder, mainRectSize-itemBorderY*2, tocolor(30, 30, 30, 250))
	else
		dxDrawRectangle(oneItemWidth*(x-1)+itemBorder, screenY-mainRectSize+itemBorderY+yMinus+itemPlusY, oneItemWidth-itemBorder, mainRectSize-itemBorderY*2, tocolor(30, 30, 30, 200))
	end



	if icon then
		if size then
			if stretch == "door" then
				dxDrawImage(oneItemWidth*(x-1)+itemBorder+smallSizeDiff+respc(16), screenY-mainRectSize+itemBorderY+yMinus+itemPlusY+smallSizeDiff, oneItemWidth-itemBorder-smallSizeDiff*2-respc(32), oneItemWidth-itemBorder-smallSizeDiff*2, "files/" .. icon .. ".png")
			elseif stretch then
				dxDrawImageSection(oneItemWidth*(x-1)+itemBorder+smallSizeDiff, screenY-mainRectSize+itemBorderY+yMinus+itemPlusY+smallSizeDiff, oneItemWidth-itemBorder-smallSizeDiff*2, oneItemWidth-itemBorder-smallSizeDiff*2, 32, 32, 64, 64, "files/" .. icon .. ".png")
			else
				dxDrawImage(oneItemWidth*(x-1)+itemBorder+smallSizeDiff, screenY-mainRectSize+itemBorderY+yMinus+itemPlusY+smallSizeDiff, oneItemWidth-itemBorder-smallSizeDiff*2, oneItemWidth-itemBorder-smallSizeDiff*2, "files/" .. icon .. ".png")
			end
		else
			dxDrawImage(oneItemWidth*(x-1)+itemBorder, screenY-mainRectSize+itemBorderY+yMinus+itemPlusY, oneItemWidth-itemBorder, oneItemWidth-itemBorder, "files/" .. icon .. ".png")
		end
	else
		if modelType == 'furniture' then
			global.showObjects[modelID] = x
			--[[if modified then
				global.showObjects[modelID] = nil
				local v = global.objectPreviews[model]
				if v then
					exports.object_preview:destroyObjectPreview(v[2])
					if isElement(v[2]) then
						destroyElement(v[2])
					end
					local obj = global.objectPreviews[modelID][1]
					global.objectPreviews[modelID][3] = x
					local pObj = exports.object_preview:createObjectPreview(obj, 0, 0, 0, oneItemWidth*(x-1)+itemBorder, screenY-mainRectSize+itemBorderY+yMinus+itemPlusY, oneItemWidth-itemBorder, oneItemWidth-itemBorder, false, true, true)
					global.objectPreviews[model][2] = pObj
				end
			elseif not global.objectPreviews[model] then
				local _x, _y, _z = getElementPosition(localPlayer)
				_z = _z + 400
				local obj = createObject(model, _x, _y, _z, 0, 0, 0)
				setElementDimension(obj, getElementDimension(localPlayer))
				setElementInterior(obj, getElementInterior(localPlayer))
				local pObj = exports.object_preview:createObjectPreview(obj, 0, 0, 0, oneItemWidth*(x-1)+itemBorder, screenY-mainRectSize+itemBorderY+yMinus+itemPlusY, oneItemWidth-itemBorder, oneItemWidth-itemBorder, false, true, true)
				global.objectPreviews[model] = {obj, pObj, x}
			end]]
		end
	end

	local textWidth = dxGetTextWidth(text, 0.75, dxfont0_roboto, true)
	local textHeight = dxGetFontHeight(0.75, dxfont0_roboto)
	local margin = _s(8)
	local rectW, rectH = oneItemWidth-itemBorder-smallSizeDiff*2, textHeight+margin*2
	local startX, startY = oneItemWidth*(x-1)+itemBorder+smallSizeDiff, screenY-mainRectSize+itemBorderY+yMinus+itemPlusY+2+mainRectSize-itemBorderY*2-4-rectH
	dxDrawRectangle(startX, startY, rectW, rectH, tocolor(30, 30, 30, 220))

	if string.find(text, "PP") then 
		dxDrawText(text, startX, startY, startX+rectW, startY+rectH, tocolor(r, g, b), 0.75, dxfont0_roboto, "center", "center", false, false, false, true)
	else
		dxDrawText(text, startX, startY, startX+rectW, startY+rectH, tocolor(255, 255, 255), 0.75, dxfont0_roboto, "center", "center", false, false, false, true)
	end

	return x+1
end

function drawIconText(x, y, icon, text, line, name, last)
	if line then
		dxDrawLine(x+imageBorder, y+imageBorder, x+imageBorder, y+smallRectSize-imageBorder, tocolor(255, 255, 255), 2)
		x = x + imageBorder*3
	end

	local w = dxGetTextWidth(text, 1, Roboto)

	dxDrawImage(x+imageBorder, y+imageBorder, smallRectSize-imageBorder*2, smallRectSize-imageBorder*2, "files/icons/" .. icon .. ".png")
	dxDrawText(text, x+smallRectSize+imageBorder, y, 0, y+smallRectSize, tocolor(255, 255, 255), 1, Roboto, "left", "center")

	if mainSelection == name then
		dxDrawLine(x+imageBorder, y-1+smallRectSize, x+smallRectSize+w+imageBorder, y-1+smallRectSize, tocolor(r, g, b), 2)
	elseif cx >= x+imageBorder and cx <= x+smallRectSize+w+imageBorder and cy >= y and cy <= y+smallRectSize then
		activeButton = "main:" .. name
		dxDrawLine(x+imageBorder, y-1+smallRectSize, x+smallRectSize+w+imageBorder, y-1+smallRectSize, tocolor(r, g, b, 200), 2)
	end

	
	return x+smallRectSize+w+itemBorder
end

local separatorSize = 0--dxGetTextWidth(" / ", 1, dxfont0_roboto)

function drawText(x, y, text, name, last)
	local w = dxGetTextWidth(text, 1, dxfont0_roboto)--+separatorSize
	
	if not last then
		--text = text .. "#ffffff / "
		dxDrawText(" / ", x+w, y, 0, y+smallRectSize, tocolor(160, 160, 160), 1, dxfont0_roboto, "left", "center", false, false, false, true)
	end


	if last then
		w = w + imageBorder*2
	else
		w = w + separatorSize
	end

	if subSelection == name then
		dxDrawText(text, x, y, 0, y+smallRectSize, tocolor(r, g, b), 1, dxfont0_roboto, "left", "center", false, false, false, true)
	elseif cx >= x and cx <= x+w and cy >= y and cy <= y+smallRectSize then
		activeButton = "sub:" .. name
		dxDrawText(text, x, y, 0, y+smallRectSize, tocolor(255, 255, 255), 1, dxfont0_roboto, "left", "center", false, false, false, true)
	else
		dxDrawText(text, x, y, 0, y+smallRectSize, tocolor(140, 140, 140), 1, dxfont0_roboto, "left", "center", false, false, false, true)
	end
	
	return x+w--+imageBorder*2
end

function drawSideIcon(x, activeIcon, icon, command, active, tooltip)
	if cx >= sideX+sideIconBorder/2+sideIconBorder*x+sideIconSize*(x-1) and cy >= sideY+sideIconBorder+respc(22) and cx <= sideX+sideIconBorder/2+sideIconBorder*x+sideIconSize*x and cy <= sideY+sideIconBorder+sideIconSize+respc(22) then
		activeButton = command
		dxDrawImage(sideX+sideIconBorder/2+sideIconBorder*x+sideIconSize*(x-1), sideY+sideIconBorder+respc(22), sideIconSize, sideIconSize, "files/icons/" .. (active and activeIcon or icon) .. ".png", 0, 0, 0, tocolor(r, g, b))

		local w = dxGetTextWidth(tooltip, 1, dxfont0_roboto)+respc(20)

		local imgCenterX = sideX+sideIconBorder/2+sideIconBorder*x+sideIconSize*(x-1)+sideIconSize/2
		local imgCenterY = sideY+sideIconBorder+respc(15)+sideIconSize/2
		dxDrawRectangle(imgCenterX-w/2, imgCenterY+respc(30), w, (lightHeight*1.25), tocolor(0, 0, 0, 125))
		dxDrawText(tooltip, imgCenterX-w/2, imgCenterY+respc(30), imgCenterX+w/2, imgCenterY+respc(30)+(lightHeight*1.25), tocolor(255, 255, 255), 1, dxfont0_roboto, "center", "center", false, false, false, true)
	else
		dxDrawImage(sideX+sideIconBorder/2+sideIconBorder*x+sideIconSize*(x-1), sideY+sideIconBorder+respc(22), sideIconSize, sideIconSize, "files/icons/" .. (active and activeIcon or icon) .. ".png", 0, 0, 0, tocolor(255, 255, 255))
	end

	return x+1
end

function drawSideGUI()
	core:drawWindow(sideX, sideY+sideIconBorder, sideWidth, sideHeight-sideIconBorder, "Kezelés")

	if sideState then
		local x = 1

		if testMode then
			--x = drawSideIcon(x, "sun", "moon", "day", day)
			--x = drawSideIcon(x, "light1", "light0", "day", day, "Lámpa: " .. (day and "be" or "ki"))
			x = drawSideIcon(x, "test", "test", "test", true, "Kilépés tesztelésből")
		else
			if activeFurniture or mode == "placeFurniture" then
				if not snapping then
					x = drawSideIcon(x, "help0", "help0", "snap:5:selectSound", false, "Mozgatási segítség: ki")
				elseif snapping == 5 then
					x = drawSideIcon(x, "help1", "help1", "snap:10:selectSound", false, "Mozgatási segítség: nagy")
				else
					x = drawSideIcon(x, "help2", "help2", "snap:0:selectSound", false, "Mozgatási segítség: kicsi")
				end

				if not snappingR then
					x = drawSideIcon(x, "help0r", "help0r", "snapr:5:selectSound", false, "Forgatási fokszám: alap")
				elseif snappingR == 5 then
					x = drawSideIcon(x, "help1r", "help1r", "snapr:10:selectSound", false, "Forgatási fokszám: 10°")
				else
					x = drawSideIcon(x, "help2r", "help2r", "snapr:0:selectSound", false, "Forgatási fokszám: 5°")
				end
			end
			
			--x = drawSideIcon(x, "sun", "moon", "day", day)
			--x = drawSideIcon(x, "light1", "light0", "day", day, "Lámpák: " .. (day and "be" or "ki"))
			x = drawSideIcon(x, "test", "test", "test", false, "Tesztelés")
			x = drawSideIcon(x, "grid1", "grid0", "grid:selectSound", gridState, "Rács: " .. (gridState and "be" or "ki"))
			x = drawSideIcon(x, "musicon", "musicoff", "music", bcgMusicElement, "Háttér zene")
			x = drawSideIcon(x, "save", "save", "save:selectSound", false, "Mentés, kilépés")
		end
	end
end

function addCashCosts(cost, nosound)
	if editMode and cost >= 0 and not nosound then
		playSoundEx("sounds/chipdrop.mp3")
	end

	--outputDebugString("addCashCost: " .. cost)

	cashCosts = cashCosts + cost

	cashCostsFormatted = thousandsStepper(math.max(0, cashCosts-paidCashCosts))
end

local currentCategory = 1
local currentSubcategory = {}
local currentSub = function() return tonumber(currentSubcategory[currentCategory] or 1) or 1 end


for k, v in pairs(furnitureCategories) do
	local table = mainCategories[4][3]
	mainCategories[4][3][#table+1] = {v, v}
end

local categoriesOpened = false
local clicks = ""

myX, myY = 1768, 992

function drawBottomGUI()
	local cx, cy
	if isCursorShowing() then
		cx, cy = getCursorPosition(); cx, cy = cx*screenX, cy*screenY;
	end

	text = mainCategories[currentCategory][2]

	core:drawWindow(sx*0.11, sy*0.8, sx*0.88, sy*0.185, "Interior szerkesztés "..color.."("..text..")", 1)
	core:drawWindow(sx*0.01, sy*0.8, sx*0.098, sy*0.185, "Navigáció", 1)

	local logoSize, logoSpacer = 40, 10

	local ctC = tocolor(255, 255, 255, 255)
	local fontSize = 1
	local textWidth = dxGetTextWidth(text, fontSize, Roboto)
	local textHeight = dxGetFontHeight(fontSize, Roboto)
	local spacerX = _s(10)
	local spacerRight = _s(40)
	local ctXs = theX-_s(guiSizeX)/2+_s(logoSpacer)+_s(logoSize)+_s(logoSpacer)+_s(10)
	local ctXe = ctXs+textWidth
	local ctYs, ctYe = theY-_s(guiSizeY)/2, theY-_s(guiSizeY)/2+_s(headerSize)

	local startX = sx*0.028
	for k, v in ipairs(mainCategories) do 
		local currentUUID = "category."..tostring(categoriesOpened).."."..currentCategory.."."..k

		if core:isInSlot(startX, sy*0.83, 25/myX*sx, 25/myY*sy) then 
			activeButton = "sub:" .. v[1]

			if clicks ~= currentUUID and getKeyState("mouse1") then
				clicks = currentUUID
			elseif clicks == currentUUID and not getKeyState("mouse1") then
				if not (currentCategory == k) then
					playSound("sounds/menu.mp3")
					currentCategory = k
					clicks = ""
				end
			end
		elseif clicks == currentUUID then
			clicks = ""
		end

		if core:isInSlot(startX, sy*0.83, 25/myX*sx, 25/myY*sy) or k == currentCategory then 
			dxDrawImage(startX, sy*0.83, 25/myX*sx, 25/myY*sy, "files/icons/menu/"..v[4]..".png", 0, 0, 0, tocolor(r, g, b, 255))
		else
			dxDrawImage(startX, sy*0.83, 25/myX*sx, 25/myY*sy, "files/icons/menu/"..v[4]..".png")
		end

		startX = startX + 30/myX*sx
	end


	local table
	local tmpCurrent
	if not categoriesOpened then
		table = mainCategories[currentCategory][3]
		tmpCurrent = currentSub()
	else
		table = mainCategories
		tmpCurrent = currentCategory
	end

	local startY = sy*0.86
	for k, v in ipairs(table) do
		if core:isInSlot(sx*0.01, startY, sx*0.098, sy*0.02) then
			activeButton = "sub:" .. v[1]

			if getKeyState("mouse1") then 
				if not ((currentSubcategory[currentCategory] or 1) == k) then
					--print(activeButton)
					currentSubcategory[currentCategory] = k
					playSound("sounds/menu.mp3")
					playSound("sounds/show.mp3")
				end
			end
		end 

		if core:isInSlot(sx*0.01, startY, sx*0.098, sy*0.02) or ((currentSubcategory[currentCategory] or 1) == k) then 
			dxDrawText(v[2], sx*0.01, startY, sx*0.01 + sx*0.098, startY + sy*0.02, tocolor(r, g, b), 1, dxfont1_roboto, "center", "center", false, false, false, true)
		else
			dxDrawText(v[2], sx*0.01, startY, sx*0.01 + sx*0.098, startY + sy*0.02, tocolor(255, 255, 255), 1, dxfont1_roboto, "center", "center", false, false, false, true)
		end
		startY = startY + sy*0.02
	end

	core:drawWindow(sx - sx*0.21, sideY + sideIconBorder, sx*0.2, sideHeight-sideIconBorder, "Költségek")
	dxDrawText("Költség: "..serverColor.."$" .. cashCostsFormatted .. " #ffffff| Készpénz: #87de6a$" .. currentBalance, sx - sx*0.21, sideY + sideIconBorder, sx - sx*0.21 + sx*0.2,  sideY + sideIconBorder + sideHeight-sideIconBorder - respc(10), tocolor(255, 255, 255, 255), 0.8, dxfont0_roboto, "center", "bottom", false, false, false, true, false)

	if global.rectangles > 0 then
		local _max = global.getMax() or -1
		local spacer = _s(40)
		local spacerY = _s(30)
		local scrollHeight = _s(5)
		local scrollO = -1
		local scrollM
		local addPercent, widthPercent
		local sOffset = global.getScrollOffset()
		if sOffset then
			scrollO = sOffset
			scrollM = _max+maxItems
			addPercent = scrollO/scrollM
			widthPercent = maxItems/scrollM
		end
		local tWidth = _s(guiSizeX)-spacer*2 - sx*0.1
		local scrollX, scrollY, scrollW, scrollH = theX-_s(guiSizeX)/2+spacer + sx*0.1, theY-_s(guiSizeY)/2+_s(guiSizeY)-scrollHeight-spacerY, tWidth, scrollHeight
		dxDrawRectangle(scrollX, scrollY, scrollW, scrollH, tocolor(30, 30, 30, 255))
		if _max >= 0 then
			local hsX, hsY, hsW, hsH = scrollX+addPercent*tWidth, scrollY, tWidth*widthPercent, scrollHeight
			local hsC = tocolor(r, g, b, 200)
			if cx and cy then
				if global.scrolling and cx >= scrollX and cx <= scrollX+scrollW and cy >= scrollY-_s(50) and cy <= scrollY+scrollH+_s(50) then
					if getKeyState("mouse1") then
						hsX = global.hsX+cx-global.scrollX
						if hsX > scrollX+scrollW-hsW then
							hsX = scrollX+scrollW-hsW
						end
						if hsX < scrollX then
							hsX = scrollX
						end
						local currentX = hsX-scrollX
						local _addPercent = currentX/tWidth
						local _scrollO = math.round(_addPercent*scrollM)
						hsC = tocolor(r, g, b, 230)
						global.setScrollOffset(_scrollO)
					else
						global.scrolling = nil
					end
				elseif cx >= hsX and cx <= hsX+hsW and cy >= hsY and cy <= hsY+hsH then
					hsC = tocolor(r, g, b, 230)
					if getKeyState("mouse1") then
						global.scrolling = true
						global.scrollPlusX = cx-hsX
						global.scrollX = cx
						global.hsX = hsX
					end
				else
					global.scrolling = false
				end
			end
			dxDrawRectangle(hsX, hsY, hsW, hsH, hsC)
		else
			dxDrawRectangle(scrollX, scrollY, scrollW, scrollH, tocolor(r, g, b, 200))
		end
	end
end

global.getScrollOffset = function()
	if subSelection == "ceil" then
		return scrollOffset["ceil"]["normal"]
	elseif mainSelection == "walls" then
		return scrollOffset["wall"][subSelection]
	elseif mainSelection == "furnitures" then
		return scrollOffset["furnitures"][subSelection]
	elseif mainSelection == "floors" then
		return scrollOffset["floor"][subSelection]
	elseif subSelection == "windows" then
		return scrollOffset["window"]["normal"]
	elseif subSelection == "doors" then
		return scrollOffset["doors"]["1"]
	end
end

global.setScrollOffset = function(num)
	if subSelection == "ceil" then
		scrollOffset["ceil"]["normal"] = math.max(0, num)
	elseif mainSelection == "walls" then
		scrollOffset["wall"][subSelection] = math.max(0, num)
	elseif mainSelection == "furnitures" then
		scrollOffset["furnitures"][subSelection] = math.max(0, num)
	elseif mainSelection == "floors" then
		scrollOffset["floor"][subSelection] = math.max(0, num)
	elseif subSelection == "windows" then
		scrollOffset["window"]["normal"] = math.max(0, num)
	elseif subSelection == "doors" then
		scrollOffset["doors"]["1"] = math.max(0, num)
	end
	if global.getScrollOffset() > global.getMax() then
		global.setScrollOffset(global.getMax())
	end
end

function drawGUI()
	mainSelection = mainCategories[currentCategory][1]
	subSelection = mainCategories[currentCategory][3][currentSub()][1]
	drawBottomGUI()

	drawSideGUI()


	local y = screenY-mainRectSize-smallRectSize

	global.rectangles = 0
	local x = 2.9

	if subSelection == "ceil" then
		for k=1+scrollOffset["ceil"]["normal"], math.min(maxItems, #textures["ceil"]["normal"])+scrollOffset["ceil"]["normal"] do
			x = drawItemRectangle(x, "ceil/" .. "normal" .. "/" .. k, "$"..pricesForDraw["texture"]["ceil," .. "normal" .. "," .. k] .. (devModelId and (" / " .. subSelection .. "," .. k) or ""), "mode:setCeil:" .. k .. ":selectSound", (mode == "setCeil" and tostring(currentPlacingTexture) == tostring(k)), true)
		end
	elseif mainSelection == "walls" then
		if subSelection == "drawing" then
			x = drawItemRectangle(x, "icons/line", "Vonal "..color.."($" .. pricesForDraw["wall"] .. ")", "mode:drawWall_line:selectSound", (mode == "drawWall_line"))
			x = drawItemRectangle(x, "icons/rect", "Téglalap "..color.."($" .. pricesForDraw["wall"] .. ")", "mode:drawWall_rect:selectSound", (mode == "drawWall_rect"))
			x = drawItemRectangle(x, "icons/deletewall", "Törlés", "mode:deleteWall_rect:selectSound", (mode == "deleteWall_rect"))
		else
			for k=1+scrollOffset["wall"][subSelection], math.min(maxItems, #textures["wall"][subSelection])+scrollOffset["wall"][subSelection] do
				x = drawItemRectangle(x, "wall/" .. subSelection .. "/" .. k, "$"..pricesForDraw["texture"]["wall," .. subSelection .. "," .. k] .. (devModelId and (" / " .. subSelection .. "," .. k) or ""), "mode:setWallpaper:" .. subSelection .. "/" .. k .. ":selectSound", (mode == "setWallpaper" and currentPlacingTexture == subSelection .. "/" .. k), true)
			end
		end
	elseif mainSelection == "furnitures" then
		global.showObjects = {}
		for k=1+scrollOffset["furnitures"][subSelection], math.min(maxItems, #furnitureList[subSelection])+scrollOffset["furnitures"][subSelection] do
			local model = furnitureList[subSelection][k]

			if model then
				--x = drawItemRectangle(x, {"furniture", model}, "$"..pricesForDraw["furnitures"][model] .. (devModelId and ("\n" .. model) or ""), "mode:placeFurniture:" ..model .. ":selectSound", (mode == "placeFurniture" and getElementModel(placingFurniture) == model))
				if ppObjects[model] then 
					x = drawItemRectangle(x, "furniture/" .. model, pricesForDraw["furnitures"][model] .. "PP" .. (devModelId and ("\n" .. model) or ""), "mode:placeFurniture:" ..model .. ":selectSound", (mode == "placeFurniture" and getElementModel(placingFurniture) == model))
				else
					x = drawItemRectangle(x, "furniture/" .. model, "$"..pricesForDraw["furnitures"][model] .. (devModelId and ("\n" .. model) or ""), "mode:placeFurniture:" ..model .. ":selectSound", (mode == "placeFurniture" and getElementModel(placingFurniture) == model))
				end
			end
		end
		--[[for modelID, v in pairs(global.objectPreviews) do
			if not global.showObjects[modelID] then
				exports.object_preview:destroyObjectPreview(v[2])
				destroyElement(v[1])
				if isElement(v[2]) then
					destroyElement(v[2])
				end
				global.objectPreviews[modelID] = nil
			end
		end]]
		local unused = {}
		local changed = {}
		for k, v in pairs(global.oPreview) do
			if not global.showObjects[v[1]] then
				unused[k] = true
			elseif global.showObjects[v[1]] ~= v[4] then
				changed[v[1]] = k
			end
		end
		for model, show in pairs(global.showObjects) do
			local showed = false
			for k, v in pairs(global.oPreview) do
				if v[1] == model then
					showed = true
					break
				end
			end
			if not showed then
				local first = false
				for k, v in pairs(unused) do
					first = k
					break
				end
				if first then
					local v = global.oPreview[first]
					unused[first] = nil
					local obj = global.oPreview[first][3]
					setElementModel(obj, model)
					local x = global.showObjects[model]
					preview:setProjection(v[2], oneItemWidth*(x-1)+itemBorder, screenY-mainRectSize+itemBorderY+yMinus+itemPlusY, oneItemWidth-itemBorder, oneItemWidth-itemBorder, false, true)
					global.oPreview[first][1] = model
					global.oPreview[first][4] = global.showObjects[model]
				else
					local newID = global.findNewID(global.oPreview)
					global.oPreviewsOn = true
					global.oPreview[newID] = {model}
					local _x, _y, _z = getElementPosition(localPlayer)
					_z = _z + 400
					local obj = createObject(model, _x, _y, _z, 0, 0, 0)
					setElementData(obj, "opreview", true, false)
					global.oPreview[newID][3] = obj
					setElementDimension(obj, getElementDimension(localPlayer))
					setElementInterior(obj, getElementInterior(localPlayer))
					local x = global.showObjects[model]
					local pObj = preview:createObjectPreview(obj, 10, 0, 0, oneItemWidth*(x-1)+itemBorder, screenY-mainRectSize+itemBorderY+yMinus+itemPlusY, oneItemWidth-itemBorder, oneItemWidth-itemBorder, false, true)
					global.oPreview[newID][2] = pObj
					global.oPreview[newID][4] = global.showObjects[model]
				end
				--[[if modified then
					global.showObjects[modelID] = nil
					local v = global.objectPreviews[model]
					if v then
						exports.object_preview:destroyObjectPreview(v[2])
						if isElement(v[2]) then
							destroyElement(v[2])
						end
						local obj = global.objectPreviews[modelID][1]
						global.objectPreviews[modelID][3] = x
						local pObj = exports.object_preview:createObjectPreview(obj, 0, 0, 0, oneItemWidth*(x-1)+itemBorder, screenY-mainRectSize+itemBorderY+yMinus+itemPlusY, oneItemWidth-itemBorder, oneItemWidth-itemBorder, false, true, true)
						global.objectPreviews[model][2] = pObj
					end
				elseif not global.objectPreviews[model] then
					local _x, _y, _z = getElementPosition(localPlayer)
					_z = _z + 400
					local obj = createObject(model, _x, _y, _z, 0, 0, 0)
					setElementDimension(obj, getElementDimension(localPlayer))
					setElementInterior(obj, getElementInterior(localPlayer))
					local pObj = exports.object_preview:createObjectPreview(obj, 0, 0, 0, oneItemWidth*(x-1)+itemBorder, screenY-mainRectSize+itemBorderY+yMinus+itemPlusY, oneItemWidth-itemBorder, oneItemWidth-itemBorder, false, true, true)
					global.objectPreviews[model] = {obj, pObj, x}
				end]]
			elseif changed[model] then
				local first = changed[model]
				local v = global.oPreview[first]
				changed[model] = nil
				local obj = global.oPreview[first][3]
				setElementModel(obj, model)
				local x = global.showObjects[model]
				preview:setProjection(v[2], oneItemWidth*(x-1)+itemBorder, screenY-mainRectSize+itemBorderY+yMinus+itemPlusY, oneItemWidth-itemBorder, oneItemWidth-itemBorder, false, true)
				global.oPreview[first][1] = model
				global.oPreview[first][4] = global.showObjects[model]
			end
		end
		for k, v in pairs(unused) do
			unused[k] = nil
			local first = k
			local v = global.oPreview[first]
			preview:destroyObjectPreview(v[2])
			if isElement(v[2]) then
				destroyElement(v[2])
			end
			local obj = global.oPreview[first][3]
			destroyElement(obj)
			global.oPreview[first] = nil
		end
	elseif mainSelection == "floors" then
		for k=1+scrollOffset["floor"][subSelection], math.min(maxItems, #textures["floor"][subSelection])+scrollOffset["floor"][subSelection] do
			x = drawItemRectangle(x, "floor/" .. subSelection .. "/" .. k, "$"..pricesForDraw["texture"]["floor," .. subSelection .. "," .. k] .. (devModelId and (" / " .. subSelection .. "," .. k) or ""), "mode:setFloor:" .. subSelection .. "/" .. k .. ":selectSound", (mode == "setFloor" and currentPlacingTexture == subSelection .. "/" .. k), true)
		end
	elseif subSelection == "windows" then
		local offset = scrollOffset["window"]["normal"]

		if offset == 0 then
			x = drawItemRectangle(x, "icons/delete2", "Törlés", "mode:deleteWindow:selectSound", (mode == "3dow"), true)
		else
			offset = offset - 1
		end

		for k=1+offset, math.min(maxItems, #textures["window"]["normal"])+offset do
			x = drawItemRectangle(x, "window/" .. "normal" .. "/" .. k, "$"..pricesForDraw["window"], "mode:setWindow:" .. k .. ":selectSound", (mode == "setWindow" and tonumber(currentPlacingTexture) == k), true, true)
		end
	elseif subSelection == "doors" then
		local offset = scrollOffset["doors"]["1"]

		if offset == 0 then
			x = drawItemRectangle(x, "icons/delete2", "Törlés", "mode:deleteDoor:selectSound", (mode == "deleteDoor"), true)
		else
			offset = offset - 1
		end

		----outputDebugString("offgeci: " .. offset)

		local sub = 1
		local item = -1

		if scrollOffset["doors"]["1"] >= 1 then
			item = item + (offset)

			while item > #textures["doors"][tostring(sub)] do
				item = item-#textures["doors"][tostring(sub)]-1
				sub = sub + 1
			end
		end

		for k=1, maxItems do
			item = item + 1

			if item > #textures["doors"][tostring(sub)] then
				item = 0
				sub = sub + 1
			end

			x = drawItemRectangle(x, "doors/" .. sub .. "/" .. item, "$"..pricesForDraw["door"][sub], "mode:setDoor:" .. sub .. "/" ..(item) .. ":selectSound", (mode == "setDoor" and currentPlacingTexture == sub .."/" .. (item)), true, "door")
		end
	end

	if placingPrompt then
		if placingPrompt[1] == "exit" then
			--exports.oInfobox:outputInfoBox("Biztosan szeretnél kilépni mentés nélkül?", "info")
		else
			placingPrompt = false
		end
	end
end

addEvent("interiorbuilding:exitYes", true)
addEventHandler("interiorbuilding:exitYes", root, function()
    if placingPrompt[1] == "billiard" then
		triggerServerEvent("intiEdit:placeBilliard", localPlayer, placingPrompt)
	elseif placingPrompt[1] == "safe" then
		triggerServerEvent("intiEdit:placeSafe", localPlayer, placingPrompt)
	elseif placingPrompt[1] == "buyPPFurniture" then
		triggerServerEvent("intiEdit:buyPPFurniture", localPlayer, editingInteriorID, placingPrompt[2])
	elseif placingPrompt[1] == "exit" then
		triggerServerEvent("intiEdit:exitInterior", localPlayer)
	end
	placingPrompt = false
end)

addEvent("interiorbuilding:exitNo", true)
addEventHandler("interiorbuilding:exitNo", root, function()
	placingPrompt = false
end)

function deleteDoor(door)
	if door then
		door = getElementModel(door)
		addCashCosts(-prices["door"][tonumber(doorReverse[door])])
	end
end

--local data = {
	--false,
	--windowHover,
	--base, 
	--texture,
	--rot,
	--door,
--}

function createBaseDoor(data, rePlace, new)
	if currentBaseDoor and not currentBaseDoor[7] then
		local text = {}

		if pathOnElements[currentBaseDoor[2]] then
			if pathOnElements[currentBaseDoor[2]]["la_carp3"] then
				text[3] = pathOnElements[currentBaseDoor[2]]["la_carp3"]
			end

			if pathOnElements[currentBaseDoor[2]]["la_carp5"] then
				text[5] = pathOnElements[currentBaseDoor[2]]["la_carp5"]
			end
		end

		removeTextureFromElement(currentBaseDoor[2], "la_carp3")
		removeTextureFromElement(currentBaseDoor[2], "la_carp5")
		currentBaseDoor[7] = text
	end

	deleteBaseDoor()

	if data then
		if not new then
			if currentBaseDoor and data[2] == currentBaseDoor[2] then
				local text = currentBaseDoor[7]
				
				if text[3] then
					local sub = split(text[3], ",")
					applyTextureToElement(data[2], "la_carp3", "wall", sub[2], tonumber(sub[3]))
				end

				if text[5] then
					local sub = split(text[5], ",")
					applyTextureToElement(data[2], "la_carp5", "wall", sub[2], tonumber(sub[3]))
				end
			else
				removeTextureFromElement(data[2], "la_carp3")
				removeTextureFromElement(data[2], "la_carp5")
			end
		end

		setElementModel(data[2], wallModellID["door2"])

		local rx, ry, rz = getElementRotation(data[2])

		--setElementRotation(data[2], 0, 0, rz%180)

		local x, y, z = -0.025, 0.785, -1.765
			
		local rot = data[4]
		local door = data[5]
		local texture = data[3]

		if rot > 0 then
			x = 0.025
			y = -0.75
		end


		if not editMode then
			local x, y, z = getElementPosition(data[2])

			baseDoorCol = createColRectangle(x-floorBaseSize/2, y-floorBaseSize/2, floorBaseSize, floorBaseSize)
		end

		local x, y, z = getPositionFromElementOffset(data[2], x, y, z)

		data[1] = createObject(door, x, y, z, 0, 0, rz+rot)
		doorRots[data[1]] = rot

		setElementInteriorAndDimension(data[1], 1)

		if door == 1491 then
			setObjectScale(data[1], 1.005)
		end
		setElementCollisionsEnabled(data[1], false)

		texture = tonumber(texture)

		if not rePlace then
			addCashCosts(prices["door"][tonumber(doorReverse[door])], true)
			--outputDebugString("price: " .. prices["door"][tonumber(doorReverse[door])])
		end

		if texture > 0 then
			--print(door)
			applyTextureToElement(data[1], doorTextures[door], "door", doorReverse[door], texture)	
		end

		--outputDebugString("Data[6]: " .. data[6])

		baseDoor = data

		return data[2]
	end
end

function deleteBaseDoor()
	if baseDoor then
		destroyElement(baseDoor[1])

		setElementRotation(baseDoor[2], 0, 0, baseDoor[6])
		setElementModel(baseDoor[2], wallModellID["base"])

		--removeTextureFromElement(baseDoor[2], "la_carp3")
		--removeTextureFromElement(baseDoor[2], "la_carp5")

		addCashCosts(-prices["door"][tonumber(doorReverse[baseDoor[5]])])
	end

	baseDoor = false
end

function unuseDoorHover(element)
	if mode == "deleteDoor" then
		if doorDefaultState and windowHoverTexture then
			createDoor(unpack(doorDefaultState))

			local sub = split(windowHoverTexture, ",")
			
			if tonumber(sub[3]) then
				applyTextureToElement(windowHover, "la_carp3", "wall", sub[2], tonumber(sub[3]), false, true)
			end

			if tonumber(sub[6]) then
				applyTextureToElement(windowHover, "la_carp4", "wall", sub[5], tonumber(sub[6]), false, true)
			end

			if tonumber(sub[9]) then
				applyTextureToElement(windowHover, "la_carp5", "wall", sub[8], tonumber(sub[9]), false, true)
			end

			if tonumber(sub[12]) then
				applyTextureToElement(windowHover, "la_carp6", "wall", sub[11], tonumber(sub[12]), false, true)
			end

			setElementModel(windowHover, wallModellID["door2"])
		end
	else
		--outputDebugString("windowHover: " .. tostring(windowHover))
		if baseWallCoordinates[windowHover] then 
			--outputDebugString("unuseBaseWall")

			if currentBaseDoor and baseDoor[2] ~= currentBaseDoor[2] then 
				setElementRotation(windowHover, 0, 0, windowHoverTexture[1])
				setElementModel(windowHover, wallModellID["base"])

				local text = windowHoverTexture[2]

				if text[3] then
					local sub = split(text[3], ",")
					applyTextureToElement(windowHover, "la_carp3", "wall", sub[2], tonumber(sub[3]), false, true)
				end

				if text[5] then
					local sub = split(text[5], ",")
					applyTextureToElement(windowHover, "la_carp5", "wall", sub[2], tonumber(sub[3]), false, true)
				end
			end

			if (not element or not baseWallCoordinates[element]) and currentBaseDoor then
				local el = createBaseDoor(currentBaseDoor, false , true)

				local text = currentBaseDoor[7]
				
				if text[3] then
					local sub = split(text[3], ",")
					applyTextureToElement(el, "la_carp3", "wall", sub[2], tonumber(sub[3]), false, true)
				end

				if text[5] then
					local sub = split(text[5], ",")
					applyTextureToElement(el, "la_carp5", "wall", sub[2], tonumber(sub[3]), false, true)
				end

				currentBaseDoor[7] = false
			end
		elseif windowHover and wallCoordiantes[windowHover] then
			local tx, ty = unpack(wallCoordiantes[windowHover])

			if doorDefaultState then
				if doors[tx..","..ty] then
					doorRots[doors[tx..","..ty]] = nil
					deleteDoor(doors[tx..","..ty])
					destroyElement(doors[tx..","..ty])
					doors[tx..","..ty] = nil
				end

				createDoor(unpack(doorDefaultState))

				--outputDebugString("defstate: " .. tostring(doorDefaultState) .. ", " .. table.concat(doorDefaultState, ","))
			elseif windowHoverTexture then
				--outputDebugString("starightres")

				if doors[tx..","..ty] then
					doorRots[doors[tx..","..ty]] = nil
					deleteDoor(doors[tx..","..ty])
					destroyElement(doors[tx..","..ty])
					doors[tx..","..ty] = nil
				end

				local sub = split(windowHoverTexture, ",")

				if tonumber(sub[3]) then
					applyTextureToElement(windowHover, "la_carp3", "wall", sub[2], tonumber(sub[3]), false, true)
				end

				if tonumber(sub[6]) then
					applyTextureToElement(windowHover, "la_carp4", "wall", sub[5], tonumber(sub[6]), false, true)
				end

				if tonumber(sub[9]) then
					applyTextureToElement(windowHover, "la_carp5", "wall", sub[8], tonumber(sub[9]), false, true)
				end

				if tonumber(sub[12]) then
					applyTextureToElement(windowHover, "la_carp6", "wall", sub[11], tonumber(sub[12]), false, true)
				end


				setElementModel(windowHover, wallModellID["straight"])
			end
		elseif wallCoordiantes[windowHover] then
			local tx, ty = unpack(wallCoordiantes[windowHover])

			if doors[tx..","..ty] then
				doorRots[doors[tx..","..ty]] = nil
				deleteDoor(doors[tx..","..ty])
				destroyElement(doors[tx..","..ty])
				doors[tx..","..ty] = nil
			end
		end
	end

	windowHover = false
	windowHoverBaseModel = false
	windowHoverTexture = false
	windowHoverRotation = false
	doorDefaultState = false
end


--windowHover
function unuseWindowHover()
	if mode == "deleteWindow" then 
		if windowHoverBaseModel then
			--outputDebugString("t:" .. windowHoverTexture)

			local tx, ty, rz = unpack(windowHoverBaseModel)
			local sub = split(windowHoverTexture, ",")

			--outputDebugString("tx:" .. tx)
			--outputDebugString("ty:" .. ty)
			--outputDebugString("rz:" .. rz)

			createWindow(tx, ty, rz, sub[3])
		end
	else
		if windowHover and windowHoverBaseModel then
			if not windowHoverTexture then
				local tx, ty = unpack(windowHoverBaseModel)
				
				destroyWindow(tx, ty)
			else
				local tx, ty = unpack(windowHoverBaseModel)
				local sub = split(windowHoverTexture, ",")

				applyTextureToElement(windowOnCoordiante[tx .. "," .. ty], "la_carp4", "window", "normal", tonumber(sub[3]))
			end
		end
	end

	windowHover = false
	windowHoverBaseModel = false
	windowHoverTexture = false
	windowHoverRotation = false
end

function createWindow(tx, ty, rot, text, rePlace)
	if not windowOnCoordiante[tx .. "," .. ty] then
		local x, y, z = grid[1]+(tx/2-0.5)*floorBaseSize, grid[2]+(ty/2-0.5)*floorBaseSize, grid[3]+3.5/2

		--outputDebugString("rot: " .. rot)

		local obj = createObject(wallModellID["window"], x, y, z, 0, 0, rot)
		setElementInteriorAndDimension(obj, 1)
		setElementCollisionsEnabled(obj, false)

		windowCoordiantes[obj] = {tx, ty}
		windowOnCoordiante[tx .. "," .. ty] = obj

		applyTextureToElement(obj, "la_carp4", "window", "normal", tonumber(text))

		if not rePlace then
			addCashCosts(prices["window"], true)
		end
	end
end

--local furniture = createObject(furnitureModels[2], 53.2099609375, 2046.6201171875, 51.0859375-1)
--table.insert(furnitures, furniture)

local modelBigRotate = {
	[2239] = 1.5,
}

local modelOffsets = {
	--[14446] = {0.0086717033385489, -0.026328296661451, -1.8263282966615, -1.7363282966615, 1.8436717033386, 1.6836717033386},
	--[2090] = {0.52831775665278, 2.2383177566528, -0.38168224334722, 0.98831775665278, 1.4383177566528, 3.4883177566527},
	--[2296] = {0.99474377632137, -0.095256223678629, -0.48525622367863, -0.48525622367863, 2.4747437763214, 0.29474377632137},

	--[14446] = {0.0086717033385489, -0.026328296661451, -1.8263282966615, -1.7363282966615, 1.8436717033386, 1.6836717033386, -0.23132829666145, -0.58632829666145, 0.12367170333855},
	--[2090] = {0.52831775665278, 2.2383177566528, -0.38168224334722, 0.98831775665278, 1.4383177566528, 3.4883177566527, 0.73331775665278, 0.13831775665278, 1.3283177566528},
	--[2296] = {0.99474377632137, -0.095256223678629, -0.48525622367863, -0.48525622367863, 2.4747437763214, 0.29474377632137, 1.3097437763214, 0.13474377632137, 2.4847437763214},

	[2109] = {0.0052578830718897, 0.0052578830718897, -0.84474211692811, -0.83474211692811, 0.85525788307189, 0.84525788307189, 0.01525788307189, -0.38474211692811, 0.41525788307189},
	[2111] = {0.0078578567504782, 0.0028578567504782, -0.84214214324952, -0.83214214324952, 0.85785785675048, 0.83785785675048, 0.042857856750478, -0.38214214324952, 0.46785785675048},
	[2112] = {0.0021652317047103, 0.0021652317047103, -0.69783476829529, -0.68783476829529, 0.70216523170471, 0.69216523170471, 0.04216523170471, -0.38783476829529, 0.47216523170471},
	[2200] = {0.63448942184446, -0.16051057815554, -0.47551057815554, -0.47551057815554, 1.7444894218445, 0.15448942184446, 0.94948942184446, 0.004489421844463, 1.8944894218445},
	[1416] = {0.011026129722597, 0.011026129722597, -0.6939738702774, -0.3539738702774, 0.7160261297226, 0.3760261297226, 0.0060261297225968, -0.5639738702774, 0.5760261297226},
	[1417] = {0.019425935745241, 0.014425935745241, -0.50057406425476, -0.28057406425476, 0.53942593574524, 0.30942593574524, 0.39942593574524, -0.26057406425476, 1.0594259357452},
	[1429] = {0.015613107681275, 0.015613107681275, -0.33438689231872, -0.23438689231872, 0.36561310768128, 0.26561310768128, 0.0056131076812752, -0.24438689231872, 0.25561310768128},
	[1432] = {0.024647026061992, 0.21464702606199, -1.065352973938, -0.75535297393801, 1.114647026062, 1.184647026062, 0.31964702606199, -0.12535297393801, 0.76464702606199},
	[1433] = {0.015186829566957, 0.005186829566957, -0.55981317043304, -0.56981317043304, 0.59018682956696, 0.58018682956696, 0.16518682956696, -0.16981317043304, 0.50018682956696},
	[1594] = {0.0013999462127554, 0.0063999462127554, -1.1586000537872, -1.0486000537872, 1.1613999462128, 1.0613999462128, 0.0013999462127555, -0.46860005378724, 0.47139994621276},
	[1663] = {0.012761363983155, 0.027761363983155, -0.28723863601684, -0.30723863601684, 0.31276136398316, 0.36276136398316, -0.057238636016845, -0.45723863601685, 0.34276136398316},
	[1671] = {0.0018198490142832, 0.031819849014283, -0.33818015098572, -0.30818015098572, 0.34181984901428, 0.37181984901428, -0.048180150985717, -0.45818015098572, 0.36181984901428},
	[1702] = {1.0001325130462, 0.025132513046241, -0.049867486953759, -0.45986748695376, 2.0501325130462, 0.51013251304624, 0.49513251304624, 0.12013251304624, 0.87013251304624},
	[1703] = {1.0172599029541, 0.022259902954068, -0.24774009704593, -0.45774009704593, 2.2822599029541, 0.50225990295407, 0.49725990295407, 0.0022599029540676, 0.99225990295407},
	[1704] = {0.45848893165588, 0.0084889316558795, -0.10151106834412, -0.48151106834412, 1.0184889316559, 0.49848893165588, 0.51848893165588, 0.0084889316558795, 1.0284889316559},
	[1705] = {0.5035131072998, 0.013513107299801, -0.056486892700199, -0.4764868927002, 1.0635131072998, 0.5035131072998, 0.4385131072998, 0.003513107299801, 0.8735131072998},
	[1706] = {0.5077992725372, 0.0077992725372039, -0.5722007274628, -0.4622007274628, 1.5877992725372, 0.4777992725372, 0.4777992725372, 0.0077992725372039, 0.9477992725372},
	[1707] = {0.79441818237303, 0.059418182373032, -0.47558181762697, -0.48558181762697, 2.064418182373, 0.60441818237303, 0.50441818237303, 0.054418182373032, 0.95441818237303},
	[1708] = {0.49476222991943, 0.0097622299194261, -0.21023777008057, -0.48023777008057, 1.1997622299194, 0.49976222991943, 0.49976222991943, 0.0097622299194261, 0.98976222991943},
	[1709] = {2.7669393920897, 0.52193939208975, -0.47806060791025, -0.48806060791025, 6.0119393920897, 1.5319393920897, 0.55193939208975, 0.10193939208975, 1.0019393920897},
	[1710] = {1.8592019653319, 0.039201965331962, -0.38579803466804, -0.42579803466804, 4.1042019653319, 0.50420196533196, 0.49920196533196, 0.0042019653319621, 0.99420196533196},
	[1711] = {0.17854343891144, 0.013543438911439, -0.49145656108856, -0.48145656108856, 0.84854343891144, 0.50854343891144, 0.51354343891144, 0.0085434389114392, 1.0185434389114},
	[1712] = {0.73387892723081, 0.0088789272308133, -0.46612107276919, -0.48612107276919, 1.9338789272308, 0.50387892723081, 0.50887892723081, 0.0038789272308134, 1.0138789272308},
	[1713] = {0.80675628662106, 0.011756286621061, -0.46824371337894, -0.47824371337894, 2.0817562866211, 0.50175628662106, 0.58175628662106, 0.18175628662106, 0.98175628662106},
	[1720] = {0.010311751365663, 0.18031175136566, -0.22968824863434, -0.11968824863434, 0.25031175136566, 0.48031175136566, 0.50531175136566, 0.010311751365663, 1.0003117513657},
	[1721] = {0.016971402168275, 0.15197140216828, -0.26302859783173, -0.12302859783172, 0.29697140216828, 0.42697140216828, 0.24197140216828, -0.013028597831725, 0.49697140216828},
	[1723] = {1.0108775520324, 0.010877552032434, -0.45412244796757, -0.47412244796757, 2.4758775520324, 0.49587755203243, 0.52087755203243, 0.18587755203243, 0.85587755203243},
	[1724] = {0.51764683723449, 0.0026468372344927, -0.042353162765507, -0.48235316276551, 1.0776468372345, 0.48764683723449, 0.44764683723449, 0.0076468372344927, 0.88764683723449},
	[1726] = {1.0035367202758, 0.018536720275848, -0.16646327972415, -0.46646327972415, 2.1735367202758, 0.50353672027585, 0.55353672027585, 0.18353672027585, 0.92353672027585},
	[1735] = {0.012982792854311, -0.0070172071456895, -0.41701720714569, -0.46701720714569, 0.44298279285431, 0.45298279285431, 0.63798279285431, 0.0029827928543106, 1.2729827928543},
	[1740] = {-0.010995006561278, 1.1140049934387, -0.30099500656128, 0.81900499343872, 0.27900499343872, 1.4090049934387, 0.53900499343872, 0.0090049934387218, 1.0690049934387},
	[1741] = {0.51198711395263, 1.1069871139526, -0.45801288604737, 0.72198711395263, 1.4819871139526, 1.4919871139526, 0.57698711395263, 0.01198711395263, 1.1419871139526},
	[1742] = {0.23239231109618, -0.30260768890382, -0.47760768890382, -0.47760768890382, 0.94239231109618, -0.12760768890382, 1.0223923110962, 0.012392311096182, 2.0323923110962},
	[1743] = {0.51640970230102, 1.081409702301, -0.42859029769898, 0.69140970230102, 1.461409702301, 1.471409702301, 0.63140970230102, 0.011409702301018, 1.251409702301},
	[1744] = {0.47946271896363, -0.32553728103638, -0.48553728103638, -0.49553728103638, 1.4444627189636, -0.15553728103638, 0.16946271896362, 0.0044627189636249, 0.33446271896363},
	[1753] = {1.0211975288391, 0.0011975288390742, -0.42380247116093, -0.48380247116093, 2.4661975288391, 0.48619752883907, 0.48119752883907, 0.026197528839074, 0.93619752883907},
	[1754] = {0.00057060241699378, 0.00057060241699378, -0.49442939758301, -0.49442939758301, 0.49557060241699, 0.49557060241699, 0.48057060241699, 0.0055706024169938, 0.95557060241699},
	[1755] = {0.51306317329406, 0.0080631732940645, -0.036936826705935, -0.48693682670594, 1.0630631732941, 0.50306317329406, 0.54806317329406, 0.013063173294065, 1.0830631732941},
	[1756] = {0.8751965808868, 0.050196580886805, -0.4748034191132, -0.4848034191132, 2.2251965808868, 0.58519658088681, 0.57519658088681, 0.045196580886805, 1.1051965808868},
	[1757] = {1.0105776309967, 0.010577630996672, -0.36442236900333, -0.47442236900333, 2.3855776309967, 0.49557763099667, 0.51057763099667, 0.0055776309966725, 1.0155776309967},
	[1758] = {0.50186296463013, -0.0081370353698731, -0.18313703536987, -0.47313703536987, 1.1868629646301, 0.45686296463013, 0.49686296463013, 0.0068629646301269, 0.98686296463013},
	[1759] = {0.49603256225586, 0.096032562255861, -0.10396743774414, -0.30396743774414, 1.0960325622559, 0.49603256225586, 0.52603256225586, 0.0060325622558609, 1.0460325622559},
	[1760] = {1.0115927505493, -0.028407249450719, -0.41340724945072, -0.47340724945072, 2.4365927505493, 0.41659275054928, 0.51659275054928, 0.006592750549281, 1.0265927505493},
	[1761] = {1.0000518226623, 0.010051822662319, -0.39494817733768, -0.46494817733768, 2.3950518226623, 0.48505182266232, 0.51505182266232, 0.0050518226623187, 1.0250518226623},
	[1762] = {0.49569108963012, 0.0056910896301201, -0.18930891036988, -0.47930891036988, 1.1806910896301, 0.49069108963012, 0.50569108963012, 0.00069108963012008, 1.0106910896301},
	[1763] = {0.62426556587217, 0.10426556587217, -0.46573443412783, -0.29573443412783, 1.7142655658722, 0.50426556587217, 0.52426556587217, 0.0042655658721725, 1.0442655658722},
	[1764] = {1.0134077167511, 0.018407716751079, -0.12659228324892, -0.47659228324892, 2.1534077167511, 0.51340771675108, 0.50340771675108, 0.013407716751079, 0.99340771675108},
	[1765] = {0.51904519081116, 0.019045190811158, -0.060954809188842, -0.47095480918884, 1.0990451908112, 0.50904519081116, 0.48904519081116, -0.00095480918884241, 0.97904519081116},
	[1766] = {1.0253976154327, 0.015397615432708, -0.33460238456729, -0.46460238456729, 2.3853976154327, 0.49539761543271, 0.51539761543271, 0.015397615432708, 1.0153976154327},
	[1767] = {0.51391859054565, 0.0089185905456468, -0.20608140945435, -0.47608140945435, 1.2339185905456, 0.49391859054565, 0.54391859054565, 0.0039185905456468, 1.0839185905456},
	[1768] = {1.0134939861297, 0.013493986129731, -0.37650601387027, -0.46650601387027, 2.4034939861297, 0.49349398612973, 0.50349398612973, 0.0034939861297315, 1.0034939861297},
	[1769] = {0.48672757148742, 0.021727571487423, -0.18827242851258, -0.45827242851258, 1.1617275714874, 0.50172757148742, 0.50172757148742, 0.0017275714874235, 1.0017275714874},
	[1770] = {0.51094171524047, 0.0059417152404731, -0.46405828475953, -0.48405828475953, 1.4859417152405, 0.49594171524047, 0.40094171524047, 0.0059417152404731, 0.79594171524047},
	[1814] = {0.48413180351258, 0.51413180351258, -0.36586819648743, 0.054131803512575, 1.3341318035126, 0.97413180351258, 0.25913180351258, 0.014131803512575, 0.50413180351258},
	[1815] = {0.52101717472077, 0.50101717472077, -0.058982825279234, -0.068982825279234, 1.1010171747208, 1.0710171747208, 0.24601717472077, 0.0010171747207655, 0.49101717472077},
	[1816] = {0.50584974765778, 0.51084974765778, 0.11084974765778, 0.19084974765778, 0.90084974765778, 0.83084974765778, 0.25584974765778, 0.010849747657777, 0.50084974765778},
	[1817] = {0.48302840232849, 0.52302840232849, -0.36697159767151, 0.063028402328493, 1.3330284023285, 0.98302840232849, 0.25802840232849, 0.013028402328493, 0.50302840232849},
	[1818] = {0.49355716705322, 0.52355716705322, -0.25644283294678, -0.23644283294678, 1.2435571670532, 1.2835571670532, 0.26355716705322, 0.02355716705322, 0.50355716705322},
	[1819] = {0.51375162601471, 0.51875162601471, -0.066248373985289, -0.066248373985289, 1.0937516260147, 1.1037516260147, 0.25875162601471, 0.0037516260147109, 0.51375162601471},
	[1820] = {0.49665781497955, 0.50665781497955, -0.033342185020446, -0.023342185020446, 1.0266578149796, 1.0366578149796, 0.25665781497955, 0.016657814979554, 0.49665781497955},
	[1821] = {0.49603131294251, 0.51103131294251, -0.038968687057494, 0.24103131294251, 1.0310313129425, 0.78103131294251, 0.36103131294251, 0.011031312942506, 0.71103131294251},
	[1822] = {0.50992394924164, 0.51992394924164, -0.040076050758361, -0.020076050758361, 1.0599239492416, 1.0599239492416, 0.24992394924164, 0.0099239492416395, 0.48992394924164},
	[1823] = {0.51182672977448, 0.50682672977448, -0.068173270225524, 0.031826729774476, 1.0918267297745, 0.98182672977448, 0.25682672977448, 0.021826729774476, 0.49182672977448},
	[2014] = {-0.00020153045655305, -0.00020153045655305, -0.49520153045655, -0.49520153045655, 0.49479846954345, 0.49479846954345, 1.2247984695434, 0.15479846954345, 2.2947984695434},
	[2015] = {0.0031393146514764, 0.0031393146514764, -0.49186068534852, -0.49186068534852, 0.49813931465148, 0.49813931465148, 1.1481393146515, 0.0081393146514764, 2.2881393146515},
	[2016] = {0.0023468112945428, 0.0023468112945428, -0.49265318870546, -0.49265318870546, 0.49734681129454, 0.49734681129454, 1.1473468112945, 0.0073468112945428, 2.2873468112945},
	[2018] = {0.0022774314880243, 0.0022774314880243, -0.49272256851198, -0.49272256851198, 0.49727743148802, 0.49727743148802, 1.147277431488, 0.0072774314880242, 2.287277431488},
	[2019] = {0.0023213005065789, 0.0023213005065789, -0.49267869949342, -0.49267869949342, 0.49732130050658, 0.49732130050658, 1.1473213005066, 0.0073213005065789, 2.2873213005066},
	[2020] = {0.50336163520812, 0.73836163520812, -0.46663836479188, 0.49336163520812, 1.4733616352081, 0.98336163520812, 0.67836163520812, 0.0033616352081226, 1.3533616352081},
	[2021] = {-0.001702046394347, 1.1982979536057, -0.47170204639435, 0.99829795360565, 0.46829795360565, 1.3982979536057, 0.45329795360565, 0.008297953605653, 0.89829795360565},
	[2022] = {-0.0015874576568704, -0.0015874576568704, -0.49658745765687, -0.49658745765687, 0.49341254234313, 0.49341254234313, 1.2234125423431, 0.15341254234313, 2.2934125423431},
	[2023] = {0.0078257942199685, 0.0078257942199685, -0.36217420578003, -0.36217420578003, 0.37782579421997, 0.37782579421997, 1.04282579422, 0.0078257942199685, 2.07782579422},
	[2024] = {0.50662997245788, 0.50162997245788, -0.48337002754212, -0.22337002754212, 1.4966299724579, 1.2266299724579, 0.26662997245788, 0.0066299724578763, 0.52662997245788},
	[2025] = {0.49560626029966, 0.0056062602996559, -0.48439373970034, -0.46439373970034, 1.4756062602997, 0.47560626029966, 1.2606062602997, 0.0056062602996559, 2.5156062602996},
	[2029] = {0.51460193634033, 0.0046019363403262, -0.47039806365967, -0.48039806365967, 1.4996019363403, 0.48960193634033, 0.39960193634033, -0.00039806365967379, 0.79960193634033},
	[2030] = {0.0054982089996241, 0.00049820899962411, -0.84450179100038, -0.83450179100038, 0.85549820899962, 0.83549820899962, 0.0054982089996241, -0.39450179100038, 0.40549820899962},
	[2031] = {0.5112674999237, 0.0062674999237011, -0.4587325000763, -0.4687325000763, 1.4812674999237, 0.4812674999237, 0.4012674999237, 0.011267499923701, 0.7912674999237},
	[2046] = {0.010048661231996, 0.010048661231996, -0.409951338768, -0.139951338768, 0.430048661232, 0.160048661232, 4.8661231995706e-05, -0.529951338768, 0.530048661232},
	[2069] = {0.029640274047844, 0.0096402740478443, -0.16535972595216, -0.18535972595216, 0.22464027404784, 0.20464027404784, 1.0246402740478, -0.045359725952156, 2.0946402740478},
	[2078] = {0.49777875900267, -0.11722124099733, -0.48722124099733, -0.48722124099733, 1.4827787590027, 0.25277875900267, 1.0527787590027, 0.0027787590026663, 2.1027787590027},
	[2081] = {0.5062371969223, 0.5062371969223, -0.1187628030777, 0.021237196922304, 1.1312371969223, 0.9912371969223, 0.2612371969223, 0.021237196922304, 0.5012371969223},
	[2082] = {0.49890812397003, 0.51390812397003, 0.0089081239700329, 0.038908123970033, 0.98890812397003, 0.98890812397003, 0.25890812397003, 0.018908123970033, 0.49890812397003},
	[2083] = {0.50525979518891, 0.50525979518891, 0.030259795188905, 0.1602597951889, 0.98025979518891, 0.85025979518891, 0.2452597951889, 0.00025979518890482, 0.49025979518891},
	[2084] = {0.21942370891571, -0.14057629108429, -0.49057629108429, -0.49057629108429, 0.92942370891571, 0.20942370891571, 0.46442370891571, 0.0094237089157119, 0.91942370891571},
	[2087] = {0.53230485916137, -0.14769514083863, -0.48269514083863, -0.48269514083863, 1.5473048591614, 0.18730485916137, 0.58230485916137, 0.0073048591613692, 1.1573048591614},
	[2088] = {0.50291021347045, 1.0729102134704, -0.25708978652955, 0.68291021347045, 1.2629102134704, 1.4629102134704, 0.96791021347045, 0.012910213470448, 1.9229102134704},
	[2089] = {0.41832765579223, -0.12167234420777, -0.48667234420777, -0.48667234420777, 1.3233276557922, 0.24332765579223, 0.59832765579223, 0.013327655792232, 1.1833276557922},
	[2094] = {0.51011938095092, 1.1801193809509, -0.47488061904908, 0.86511938095092, 1.4951193809509, 1.4951193809509, 0.50011938095092, 0.005119380950923, 0.99511938095092},
	[2095] = {0.0095788860321056, 1.0795788860321, -0.36042111396789, 0.72957888603211, 0.37957888603211, 1.4295788860321, 0.47457888603211, 0.0095788860321056, 0.93957888603211},
	[2108] = {0.015927915573112, 0.025927915573112, -0.17907208442689, -0.16907208442689, 0.21092791557311, 0.22092791557311, 1.0209279155731, 0.00092791557311154, 2.0409279155731},
	[2115] = {0.51095542907714, 0.0059554290771431, -0.46904457092286, -0.47904457092286, 1.4909554290771, 0.49095542907714, 0.40095542907714, 0.00095542907714305, 0.80095542907714},
	[2116] = {0.51673721313476, 0.00673721313476, -0.46826278686524, -0.47826278686524, 1.5017372131348, 0.49173721313476, 0.40173721313476, 0.01173721313476, 0.79173721313476},
	[2117] = {0.50732481002807, 0.0073248100280701, -0.48267518997193, -0.48267518997193, 1.4973248100281, 0.49732481002807, 0.40232481002807, 0.0073248100280701, 0.79732481002807},
	[2118] = {0.51473176002502, 0.0097317600250186, -0.47526823997498, -0.47526823997498, 1.504731760025, 0.49473176002502, 0.39973176002502, 0.014731760025019, 0.78473176002502},
	[2119] = {0.50624905586242, 0.0062490558624209, -0.48375094413758, -0.48375094413758, 1.4962490558624, 0.49624905586242, 0.40124905586242, 0.016249055862421, 0.78624905586242},
	[2128] = {0.0048002338409327, 0.12480023384093, -0.49019976615907, -0.25019976615907, 0.49980023384093, 0.49980023384093, 1.0998002338409, 0.0098002338409327, 2.1898002338409},
	[2129] = {0.005926523208598, 0.1259265232086, -0.4890734767914, -0.2490734767914, 0.5009265232086, 0.5009265232086, 1.1059265232086, 0.010926523208598, 2.2009265232086},
	[2133] = {0.013075757026674, 0.10807575702667, -0.48192424297333, -0.29192424297333, 0.50807575702667, 0.50807575702667, 0.52807575702667, 0.0080757570266737, 1.0480757570267},
	[2134] = {0.0030527496337904, 0.09805274963379, -0.49194725036621, -0.30194725036621, 0.49805274963379, 0.49805274963379, 0.52805274963379, 0.0080527496337904, 1.0480527496338},
	[2137] = {0.019112892150858, 0.14911289215086, -0.47088710784914, -0.20088710784914, 0.50911289215086, 0.49911289215086, 1.3991128921509, 0.0091128921508582, 2.7891128921508},
	[2138] = {0.0091090774535925, 0.14910907745359, -0.48089092254641, -0.20089092254641, 0.49910907745359, 0.49910907745359, 1.3991090774536, 0.0091090774535925, 2.7891090774536},
	[2139] = {0.017688040733339, 0.15768804073334, -0.47231195926666, -0.19231195926666, 0.50768804073334, 0.50768804073334, 0.53768804073334, 0.017688040733339, 1.0576880407333},
	[2140] = {0.020981025695756, 0.15598102569576, -0.46901897430424, -0.18901897430424, 0.51098102569576, 0.50098102569576, 1.9859810256957, -0.0090189743042438, 3.9809810256957},
	[2141] = {0.0032287406920934, 0.098228740692094, -0.49177125930791, -0.30177125930791, 0.49822874069209, 0.49822874069209, 1.9832287406921, -0.011771259307907, 3.9782287406921},
	[2142] = {0.19361371517182, -0.12638628482818, -0.48638628482818, -0.48638628482818, 0.87361371517182, 0.23361371517182, 0.52361371517182, 0.0036137151718155, 1.0436137151718},
	[2143] = {0.2658323097229, -0.1241676902771, -0.4891676902771, -0.4791676902771, 1.0208323097229, 0.2308323097229, 0.5308323097229, 0.010832309722902, 1.0508323097229},
	[2145] = {-0.13731399536135, -0.12731399536135, -0.48731399536135, -0.48731399536135, 0.21268600463865, 0.23268600463865, 1.3976860046386, 0.0026860046386528, 2.7926860046386},
	[2148] = {0.19361359596253, -0.12638640403747, -0.48638640403747, -0.48638640403747, 0.87361359596253, 0.23361359596253, 0.52361359596253, 0.0036135959625259, 1.0436135959625},
	[2151] = {0.19632440567014, -0.12867559432986, -0.48867559432986, -0.48867559432986, 0.88132440567014, 0.23132440567014, 0.52632440567014, 0.0013244056701414, 1.0513244056701},
	[2152] = {0.19565898895264, -0.12934101104736, -0.48434101104736, -0.48434101104736, 0.87565898895264, 0.22565898895264, 0.52565898895264, 0.0056589889526382, 1.0456589889526},
	[2153] = {-0.13877655982972, -0.12877655982972, -0.48877655982972, -0.48877655982972, 0.21122344017028, 0.23122344017028, 1.2062234401703, 0.0012234401702767, 2.4112234401703},
	[2154] = {0.19387804031372, -0.12612195968628, -0.49112195968628, -0.48112195968628, 0.87887804031372, 0.22887804031372, 0.52887804031372, 0.0088780403137215, 1.0488780403137},
	[2155] = {-0.082284984588622, -0.12728498458862, -0.49228498458862, -0.48228498458862, 0.32771501541138, 0.22771501541138, 0.52771501541138, 0.0077150154113782, 1.0477150154114},
	[2156] = {0.19532179832459, -0.13467820167541, -0.48967820167541, -0.48967820167541, 0.88032179832459, 0.22032179832459, 0.58032179832459, 0.010321798324587, 1.1503217983246},
	[2157] = {0.1953216791153, -0.1346783208847, -0.4896783208847, -0.4896783208847, 0.8803216791153, 0.2203216791153, 0.5803216791153, 0.010321679115297, 1.1503216791153},
	[2158] = {0.011330909728959, 0.15633090972896, -0.48366909027104, -0.19366909027104, 0.50633090972896, 0.50633090972896, 2.0013309097289, 0.0063309097289591, 3.9963309097289},
	[2159] = {0.19273722171784, -0.13226277828216, -0.49226277828216, -0.48226277828216, 0.87773722171784, 0.21773722171784, 0.57773722171784, 0.0077372217178361, 1.1477372217178},
	[2160] = {0.19354099273682, -0.13645900726318, -0.48645900726318, -0.48645900726318, 0.87354099273682, 0.21354099273682, 0.57354099273682, 0.0035409927368183, 1.1435409927368},
	[2161] = {0.17958070278168, -0.22541929721832, -0.48041929721832, -0.47041929721832, 0.83958070278168, 0.019580702781679, 0.67958070278168, 0.0095807027816789, 1.3495807027817},
	[2162] = {0.39758460998534, -0.23241539001466, -0.48741539001466, -0.47741539001466, 1.2825846099853, 0.012584609985345, 0.69258460998535, 0.012584609985345, 1.3725846099853},
	[2163] = {0.40338095664978, -0.22661904335022, -0.48161904335022, -0.47161904335022, 1.2883809566498, 0.018380956649781, 0.46338095664978, 0.0083809566497806, 0.91838095664978},
	[2164] = {0.39912188529967, -0.22087811470033, -0.48587811470033, -0.46587811470033, 1.2841218852997, 0.024121885299671, 0.92912188529967, 0.014121885299671, 1.8441218852997},
	[2167] = {-0.028225836753844, -0.22322583675384, -0.48322583675384, -0.47322583675384, 0.42677416324616, 0.026774163246156, 0.76177416324616, 0.0067741632461563, 1.5167741632462},
	[2191] = {0.24783970832824, 0.20783970832824, -0.46716029167176, -0.08716029167176, 0.96283970832824, 0.50283970832824, 0.90783970832824, 0.0028397083282404, 1.8128397083282},
	[2199] = {0.20575176239012, -0.20424823760988, -0.47924823760988, -0.47924823760988, 0.89075176239012, 0.070751762390122, 0.91575176239012, 0.010751762390122, 1.8207517623901},
	[2204] = {0.98711989402768, -0.20788010597232, -0.48288010597232, -0.48288010597232, 2.4571198940277, 0.06711989402768, 0.90211989402768, 0.01711989402768, 1.7871198940277},
	[2234] = {0.50904319763184, 0.51404319763184, -0.44595680236816, 0.18404319763184, 1.4640431976318, 0.84404319763184, 0.26404319763184, 0.014043197631836, 0.51404319763184},
	[2235] = {0.51296558380127, 0.50796558380127, -0.24203441619873, 0.13796558380127, 1.2679655838013, 0.87796558380127, 0.25796558380127, 0.007965583801271, 0.50796558380127},
	[2239] = {0.013545389175409, 0.0035453891754092, -0.076454610824591, -0.076454610824591, 0.10354538917541, 0.083545389175409, 1.1535453891754, 0.0035453891754092, 2.3035453891754},
	[2290] = {0.99966390609737, 0.0096639060973747, -0.49033609390263, -0.48033609390263, 2.4896639060974, 0.49966390609738, 0.46466390609738, -0.00033609390262526, 0.92966390609738},
	[2291] = {0.49923076152802, 0.0092307615280167, 0.014230761528017, -0.47576923847198, 0.98423076152802, 0.49423076152802, 0.46923076152802, 0.014230761528017, 0.92423076152802},
	[2292] = {0.0053242826461807, 0.0053242826461808, -0.48967571735382, -0.47967571735382, 0.50032428264618, 0.49032428264618, 0.45032428264618, 0.010324282646181, 0.89032428264618},
	[2295] = {0.0011471986770641, 0.0061471986770641, -0.44385280132294, -0.47385280132294, 0.44614719867706, 0.48614719867706, 0.26614719867706, 0.0061471986770641, 0.52614719867706},
	[2303] = {0.017688040733339, 0.14268804073334, -0.47231195926666, -0.21231195926666, 0.50768804073334, 0.49768804073334, 0.52768804073334, 0.0076880407333387, 1.0476880407333},
	[2304] = {5.3501129038958e-06, 5.3501129038958e-06, -0.4899946498871, -0.4899946498871, 0.4900053501129, 0.4900053501129, 1.1000053501129, 0.010005350112904, 2.1900053501129},
	[2305] = {0.012310876846291, 0.012310876846291, -0.47768912315371, -0.47768912315371, 0.50231087684629, 0.50231087684629, 1.3973108768463, 0.0023108768462913, 2.7923108768463},
	[2307] = {0.50697229385374, 1.1969722938537, -0.47802770614626, 0.88197229385374, 1.4919722938537, 1.5119722938537, 1.1469722938537, 0.0019722938537382, 2.2919722938537},
	[2323] = {0.49867220878601, 1.113672208786, -0.47632779121399, 0.73367220878601, 1.473672208786, 1.493672208786, 0.50867220878601, 0.013672208786005, 1.003672208786},
	[2328] = {0.014325599670411, 1.0943255996704, -0.45567440032959, 0.72432559967041, 0.48432559967041, 1.4643255996704, 0.39932559967041, 0.0043255996704113, 0.79432559967041},
	[2329] = {0.51140883445738, 1.0914088344574, -0.47359116554263, 0.67640883445738, 1.4964088344574, 1.5064088344574, 1.1514088344574, 0.0064088344573748, 2.2964088344574},
	[2330] = {0.49848925590513, 1.1184892559051, -0.48151074409487, 0.73848925590513, 1.4784892559051, 1.4984892559051, 1.1584892559051, 0.018489255905129, 2.2984892559051},
	[2334] = {0.012940530776979, 0.15794053077698, -0.48205946922302, -0.19205946922302, 0.50794053077698, 0.50794053077698, 0.52794053077698, -0.0020594692230211, 1.057940530777},
	[2335] = {0.0078390693664565, 0.15783906936646, -0.48716093063354, -0.19716093063354, 0.50283906936646, 0.51283906936646, 0.53283906936646, 0.012839069366456, 1.0528390693665},
	[2338] = {0.00018151283264309, 0.00018151283264309, -0.48981848716736, -0.48981848716736, 0.49018151283264, 0.49018151283264, 0.59018151283264, 0.010181512832643, 1.1701815128326},
	[2341] = {0.012293362617494, 0.0022933626174941, -0.48270663738251, -0.49270663738251, 0.50729336261749, 0.49729336261749, 0.52729336261749, 0.0072933626174941, 1.0472933626175},
	[2357] = {-9.7599029593498e-05, -9.7599029593332e-05, -2.1250975990296, -0.65509759902959, 2.1249024009704, 0.65490240097041, 0.0049024009704067, -0.39509759902959, 0.40490240097041},
	[2462] = {-0.11705463409425, -0.19205463409425, -0.48705463409425, -0.47705463409425, 0.25294536590575, 0.092945365905754, 1.1229453659058, 0.0029453659057542, 2.2429453659058},
	[2571] = {1.5177131938934, 0.8477131938934, 1.0627131938934, 0.4027131938934, 1.9727131938934, 1.2927131938934, 0.2427131938934, 0.0027131938933974, 0.4827131938934},
	[2576] = {1.627479019165, 0.087479019164994, 0.18247901916499, -0.29752098083501, 3.072479019165, 0.47247901916499, 1.082479019165, 0.012479019164994, 2.152479019165},
	[2708] = {0.71490790367123, -0.095092096328767, -0.47509209632877, -0.49509209632877, 1.9049079036712, 0.30490790367123, 1.2499079036712, 0.0049079036712333, 2.4949079036712},
	[2803] = {0.0030433225631726, 0.0030433225631726, -0.54695667743683, -0.54695667743683, 0.55304332256317, 0.55304332256317, -0.10195667743683, -0.64695667743683, 0.44304332256317},
	[936] = {0.012716693878167, 0.022716693878167, -0.92728330612183, -0.54728330612183, 0.95271669387817, 0.59271669387817, 0.0027166938781669, -0.46728330612183, 0.47271669387817},
	[937] = {0.010314769744866, 0.015314769744866, -0.92468523025514, -0.58468523025513, 0.94531476974487, 0.61531476974487, 0.00031476974486552, -0.47468523025513, 0.47531476974487},
	[941] = {0.25575656890868, 0.015756568908676, -0.91924343109132, -0.57924343109132, 1.4307565689087, 0.61075656890868, 0.00075656890867579, -0.46924343109132, 0.47075656890868},

	[2078] = {0.49777875900267, -0.11722124099733, -0.48722124099733, -0.48722124099733, 1.4827787590027, 0.25277875900267, 1.0527787590027, 0.0027787590026663, 2.1027787590027},
	[1700] = {0.51477045059199, 2.299770450592, -0.34522954940801, 1.144770450592, 1.374770450592, 3.454770450592, 0.37477045059199, 0.014770450591991, 0.73477045059199},
	[1701] = {0.5034101772308, 2.2484101772308, -0.4765898227692, 1.0034101772308, 1.4834101772308, 3.4934101772308, 0.4134101772308, 0.073410177230798, 0.7534101772308},
	[1745] = {0.50872208595272, 2.1237220859527, -0.40127791404728, 0.81872208595272, 1.4187220859527, 3.4287220859527, 0.34872208595272, 0.0087220859527229, 0.68872208595272},
	[1793] = {0.46807832717893, 2.1130783271789, -0.50192167282108, 0.74807832717893, 1.4380783271789, 3.4780783271789, 0.32307832717893, 0.0080783271789252, 0.63807832717893},
	[1794] = {0.46503040313716, 2.3200304031371, -0.46996959686284, 1.1500304031372, 1.4000304031372, 3.4900304031371, 0.32503040313716, -0.019969596862842, 0.67003040313716},
	[1795] = {0.48549191474912, 2.0754919147491, -0.46950808525088, 0.85049191474912, 1.4404919147491, 3.3004919147491, 0.24049191474912, 0.010491914749119, 0.47049191474912},
	[1796] = {0.11714859008787, 2.1071485900879, -0.48285140991213, 1.1371485900879, 0.71714859008787, 3.0771485900878, 0.33214859008787, 0.017148590087869, 0.64714859008787},
	[1797] = {0.49049195289609, 2.2904919528961, -0.39950804710391, 1.2404919528961, 1.3804919528961, 3.3404919528961, 0.33049195289609, 0.17049195289609, 0.49049195289609},
	[1798] = {0.50417597770687, 2.1141759777069, -0.49082402229313, 0.73917597770688, 1.4991759777069, 3.4891759777068, 0.25417597770687, 0.0091759777068746, 0.49917597770687},
	[1799] = {0.48205096244809, 2.1070509624481, -0.45794903755191, 0.88205096244809, 1.4220509624481, 3.3320509624481, 0.39205096244809, 0.16205096244809, 0.62205096244809},
	[1800] = {0.14743659973142, 2.1524365997314, -0.45756340026858, 1.1024365997314, 0.75243659973142, 3.2024365997314, 0.38243659973142, 0.0024365997314214, 0.76243659973142},
	[1801] = {0.49556846618649, 2.2505684661865, -0.33443153381351, 1.0555684661865, 1.3255684661865, 3.4455684661865, 0.32056846618649, 0.0055684661864942, 0.63556846618649},
	[1802] = {0.53240416526791, 2.2174041652679, -0.30259583473209, 0.96740416526791, 1.3674041652679, 3.4674041652679, 0.36740416526791, 0.027404165267913, 0.70740416526791},
	[1803] = {0.5041089725494, 2.2391089725494, -0.4308910274506, 0.9891089725494, 1.4391089725494, 3.4891089725494, 0.9891089725494, 0.019108972549404, 1.9591089725494},
	[1812] = {-0.011467390060441, 1.3135326099396, -0.48146739006044, 0.14853260993956, 0.45853260993956, 2.4785326099396, 0.25353260993956, 0.038532609939559, 0.46853260993956},
	[2090] = {0.52831775665278, 2.2383177566528, -0.38168224334722, 0.98831775665278, 1.4383177566528, 3.4883177566527, 0.67331775665278, 0.01831775665278, 1.3283177566528},
	[2298] = {1.3294121170043, 2.5644121170043, -0.46558788299569, 1.1644121170043, 3.1244121170043, 3.9644121170043, 0.27441211700431, 0.014412117004312, 0.53441211700431},
	[2299] = {0.49656919479367, 2.2365691947937, -0.39843080520633, 0.98156919479367, 1.3915691947937, 3.4915691947936, 0.35156919479367, 0.011569194793667, 0.69156919479367},
	[2300] = {1.3327723121642, 2.8727723121642, -0.42722768783579, 1.2627723121642, 3.0927723121642, 4.4827723121642, 1.1377723121642, 0.0027723121642077, 2.2727723121642},
	[2301] = {0.48962863922113, 2.0446286392211, -0.47537136077887, 0.58462863922113, 1.4546286392211, 3.5046286392211, 0.77962863922113, 0.01462863922113, 1.5446286392211},
	[2302] = {0.49461001396176, 2.0796100139617, -0.41538998603824, 0.80461001396176, 1.4046100139618, 3.3546100139617, 0.48461001396176, 0.26461001396176, 0.70461001396176},
	[2331] = {0.0056266593933114, 0.0056266593933114, -0.31937334060669, -0.26937334060669, 0.33062665939331, 0.28062665939331, 0.090626659393311, -0.23937334060669, 0.42062665939331},
	[2333] = {0.51480011940002, 1.0548001194, -0.42519988059998, 0.62480011940002, 1.4548001194, 1.4848001194, 0.48980011940002, 0.01480011940002, 0.96480011940002},
	[2563] = {1.5107198524474, 1.2657198524474, -0.41428014755258, 0.055719852447417, 3.4357198524474, 2.4757198524474, 0.66071985244742, 0.015719852447417, 1.3057198524474},
	[2564] = {2.5204440689085, 1.2504440689086, -0.26955593109144, 0.020444068908562, 5.3104440689085, 2.4804440689086, 0.66044406890856, 0.010444068908562, 1.3104440689086},
	[2565] = {2.4961133766173, 1.2761133766173, -0.33388662338269, 0.056113376617314, 5.3261133766172, 2.4961133766173, -0.26388662338269, -0.57388662338269, 0.046113376617314},
	[2566] = {1.5130203628539, 1.2680203628539, -0.32197963714605, 0.048020362853948, 3.3480203628539, 2.4880203628539, -0.22697963714605, -0.57197963714605, 0.11802036285395},
	[2575] = {1.5021459960937, 1.2921459960937, -0.14285400390632, 0.09714599609368, 3.1471459960937, 2.4871459960937, -0.04785400390632, -0.37285400390632, 0.27714599609368},
	[14446] = {0.0086717033385489, -0.026328296661451, -1.8263282966615, -1.7363282966615, 1.8436717033386, 1.6836717033386, -0.23132829666145, -0.58632829666145, 0.12367170333855},
	[1724] = {0.51764683723449, 0.0026468372344927, -0.042353162765507, -0.48235316276551, 1.0776468372345, 0.48764683723449, 0.44764683723449, 0.0076468372344927, 0.88764683723449},
	[1726] = {1.0035367202758, 0.018536720275848, -0.16646327972415, -0.46646327972415, 2.1735367202758, 0.50353672027585, 0.55353672027585, 0.18353672027585, 0.92353672027585},
	[1735] = {0.012982792854311, -0.0070172071456895, -0.41701720714569, -0.46701720714569, 0.44298279285431, 0.45298279285431, 0.63798279285431, 0.0029827928543106, 1.2729827928543},
	[1806] = {0.0084851932525647, 0.14348519325256, -0.26651480674744, -0.12651480674744, 0.28348519325256, 0.41348519325256, 0.23848519325256, -0.016514806747435, 0.49348519325256},
	[1811] = {0.0063194131851209, 0.0063194131851209, -0.36868058681488, -0.32868058681488, 0.38131941318512, 0.34131941318512, 0.011319413185121, -0.61868058681488, 0.64131941318512},
	[1998] = {0.51704807281492, 0.50204807281492, -0.47795192718508, -0.48795192718508, 1.5120480728149, 1.4920480728149, 0.63204807281492, 0.0020480728149207, 1.2620480728149},
	[1999] = {0.50389379501342, 0.16389379501342, -0.49110620498658, -0.16110620498658, 1.4988937950134, 0.48889379501342, 0.75389379501342, 0.37889379501342, 1.1288937950134},
	[2096] = {0.0019891738891612, 0.096989173889161, -0.23801082611084, -0.25801082611084, 0.24198917388916, 0.45198917388916, 0.47698917388916, 0.0019891738891612, 0.95198917388916},
	[2173] = {0.51060373306274, 0.19060373306274, -0.46439626693726, -0.074396266937263, 1.4856037330627, 0.45560373306274, 0.40060373306274, 0.0056037330627366, 0.79560373306274},
	[2180] = {0.48692348480224, -0.053076515197758, -0.49307651519776, -0.48307651519776, 1.4669234848022, 0.37692348480224, 0.40192348480224, 0.0069234848022415, 0.79692348480224},
	[2184] = {1.0436303424835, 0.33863034248349, -0.48136965751651, -0.48136965751651, 2.5686303424835, 1.1586303424835, 0.38863034248349, 0.0086303424834889, 0.76863034248349},
	[2206] = {0.93590042114255, 0.010900421142555, -0.48909957885745, -0.47909957885745, 2.3609004211425, 0.50090042114256, 0.47090042114256, 0.010900421142555, 0.93090042114256},
	[2311] = {0.75816431999205, 0.0081643199920532, -0.45183568000795, -0.46183568000795, 1.9681643199921, 0.47816431999205, 0.25316431999205, 0.0081643199920532, 0.49816431999205},
	[2313] = {0.6905816745758, 0.0055816745757956, -0.4644183254242, -0.4644183254242, 1.8455816745758, 0.4755816745758, 0.2505816745758, 0.0055816745757956, 0.4955816745758},
	[2314] = {0.76413475990294, 0.014134759902943, -0.43586524009706, -0.40586524009706, 1.9641347599029, 0.43413475990294, 0.24913475990294, 0.004134759902943, 0.49413475990294},
	[2315] = {0.74602510452269, 0.011025104522693, -0.45897489547731, -0.45897489547731, 1.9510251045227, 0.48102510452269, 0.25102510452269, 0.011025104522693, 0.49102510452269},
	[2319] = {0.77923316955565, 0.0092331695556489, -0.42576683044435, -0.45576683044435, 1.9842331695557, 0.47423316955565, 0.27423316955565, 0.054233169555649, 0.49423316955565},
	[2321] = {0.77084794998168, 0.015847949981678, -0.42915205001832, -0.45915205001832, 1.9708479499817, 0.49084794998168, 0.25084794998168, 0.010847949981678, 0.49084794998168},
	[2346] = {0.50786309719086, 0.047863097190858, -0.15213690280914, -0.39213690280914, 1.1678630971909, 0.48786309719086, 0.24786309719086, 0.0078630971908583, 0.48786309719086},
	[2370] = {0.32448084831237, 0.35948084831237, -0.48551915168763, -0.48551915168763, 1.1344808483124, 1.2044808483124, 0.42948084831237, 0.014480848312369, 0.84448084831237},
	[11665] = {-0.00025661468512717, 0.0047433853148728, -1.5852566146851, -1.4952566146851, 1.5847433853149, 1.5047433853149, 0.0097433853148729, -0.68525661468513, 0.70474338531487},
	[2699] = {0.004355278015126, 0.009355278015126, -0.73564472198487, -0.76564472198487, 0.74435527801513, 0.78435527801513, 0.004355278015126, -0.61564472198487, 0.62435527801513},
	[1235] = {0.00034210681915389, 0.025342106819154, -0.31965789318085, -0.27965789318085, 0.32034210681915, 0.33034210681915, -0.019657893180846, -0.49965789318085, 0.46034210681915},
	[2516] = {0.64305891990661, 0.0080589199066072, -0.46694108009339, -0.47694108009339, 1.7530589199066, 0.49305891990661, 0.29305891990661, 0.0030589199066072, 0.58305891990661},
	[2517] = {0.087848901748645, 0.94784890174865, -0.46215109825136, 0.39784890174865, 0.63784890174865, 1.4978489017486, 1.0828489017486, 0.0078489017486448, 2.1578489017486},
	[2518] = {0.51415793895722, 0.27915793895722, 0.19915793895722, 0.049157938957215, 0.82915793895722, 0.50915793895722, 0.78915793895722, 0.41915793895722, 1.1591579389572},
	[2519] = {0.64700010299682, 0.0070001029968172, -0.46799989700318, -0.47799989700318, 1.7620001029968, 0.49200010299682, 0.29200010299682, 0.0020001029968172, 0.58200010299682},
	[2520] = {0.086476745605455, 0.95147674560546, -0.44852325439455, 0.41147674560546, 0.62147674560546, 1.4914767456055, 1.1364767456055, 0.011476745605455, 2.2614767456055},
	[2521] = {0.010598125457765, 0.18059812545776, -0.19440187454224, -0.14440187454224, 0.21559812545776, 0.50559812545776, 0.53059812545776, 0.015598125457765, 1.0455981254578},
	[2522] = {0.65980397224424, 0.0098039722442388, -0.48019602775576, -0.48019602775576, 1.7998039722442, 0.49980397224424, 0.99980397224424, 0.0098039722442388, 1.9898039722442},
	[2523] = {0.50805683135986, 0.23305683135986, 0.21305683135986, -0.046943168640136, 0.80305683135986, 0.51305683135986, 0.51305683135986, 0.0030568313598643, 1.0230568313599},
	[2524] = {0.4890206861496, 0.3040206861496, 0.2090206861496, 0.1090206861496, 0.7690206861496, 0.4990206861496, 0.5140206861496, 0.0090206861495981, 1.0190206861496},
	[2525] = {0.013511409759523, 0.18851140975952, -0.23148859024048, -0.12148859024048, 0.25851140975952, 0.49851140975952, 0.54351140975952, 0.0085114097595225, 1.0785114097595},
	[2526] = {0.63336135864257, 0.018361358642569, -0.46163864135743, -0.46163864135743, 1.7283613586426, 0.49836135864257, 0.36336135864257, 0.0083613586425689, 0.71836135864257},
	[2527] = {0.069853305816643, 0.94485330581664, -0.47014669418336, 0.39985330581664, 0.60985330581664, 1.4898533058166, 0.94485330581664, 0.0098533058166429, 1.8798533058166},
	[2528] = {0.0067334604263317, 0.066733460426332, -0.28326653957367, -0.36326653957367, 0.29673346042633, 0.49673346042633, 0.47173346042633, 0.0067334604263317, 0.93673346042633},
	[2109] = {0.0052578830718897, 0.0052578830718897, -0.84474211692811, -0.83474211692811, 0.85525788307189, 0.84525788307189, 0.01525788307189, -0.38474211692811, 0.41525788307189},
	[2111] = {0.0078578567504782, 0.0028578567504782, -0.84214214324952, -0.83214214324952, 0.85785785675048, 0.83785785675048, 0.042857856750478, -0.38214214324952, 0.46785785675048},
	[1594] = {0.0013999462127554, 0.0063999462127554, -1.1586000537872, -1.0486000537872, 1.1613999462128, 1.0613999462128, 0.0013999462127555, -0.46860005378724, 0.47139994621276},
	[1720] = {0.010311751365663, 0.18031175136566, -0.22968824863434, -0.11968824863434, 0.25031175136566, 0.48031175136566, 0.50531175136566, 0.010311751365663, 1.0003117513657},
	[1721] = {0.016971402168275, 0.15197140216828, -0.26302859783173, -0.12302859783172, 0.29697140216828, 0.42697140216828, 0.24197140216828, -0.013028597831725, 0.49697140216828},
	[1805] = {0.0045091629028326, 0.0095091629028326, -0.22049083709717, -0.21049083709717, 0.22950916290283, 0.22950916290283, 0.0095091629028326, -0.24049083709717, 0.25950916290283},
	[1810] = {-0.23093074798584, 0.19906925201416, -0.45593074798584, -0.075930747985839, -0.0059307479858389, 0.47406925201416, 0.45906925201416, 0.0040692520141611, 0.91406925201416},
	[2079] = {0.0094979906082165, 0.0094979906082165, -0.25050200939178, -0.24050200939178, 0.26949799060822, 0.25949799060822, 0.0044979906082165, -0.63050200939178, 0.63949799060822},
	[2120] = {0.014405832290651, 0.0044058322906507, -0.34559416770935, -0.29559416770935, 0.37440583229065, 0.30440583229065, 0.0044058322906507, -0.63559416770935, 0.64440583229065},
	[2121] = {0.011146626472474, 0.0061466264724742, -0.24385337352753, -0.30385337352753, 0.26614662647247, 0.31614662647247, 0.0061466264724742, -0.50385337352753, 0.51614662647247},
	[2124] = {0.0058631467819229, 0.00086314678192287, -0.23413685321808, -0.27413685321808, 0.24586314678192, 0.27586314678192, 0.00086314678192284, -0.82413685321808, 0.82586314678192},
	[2125] = {0.016108837127686, 0.011108837127686, -0.22889116287231, -0.23889116287231, 0.26110883712769, 0.26110883712769, 0.0011088371276863, -0.30889116287231, 0.31110883712769},
	[2350] = {0.0092449784278877, 0.0042449784278877, -0.21075502157211, -0.22075502157211, 0.22924497842789, 0.22924497842789, 0.0042449784278877, -0.37075502157211, 0.37924497842789},
	[2636] = {0.017109503746034, 0.027109503746034, -0.20789049625397, -0.22789049625397, 0.24210950374603, 0.28210950374603, -0.36289049625397, -0.61789049625397, -0.10789049625397},
	[2637] = {0.012123680114735, 0.022123680114735, -1.0278763198853, -0.59787631988527, 1.0521236801147, 0.64212368011474, 0.0021236801147354, -0.39787631988526, 0.40212368011474},
	[2644] = {0.02483422279358, 0.01983422279358, -0.47016577720642, -0.50016577720642, 0.51983422279358, 0.53983422279358, 0.0098342227935805, -0.40016577720642, 0.41983422279358},
	[2762] = {0.021200428009025, 0.021200428009025, -1.018799571991, -0.50879957199098, 1.061200428009, 0.55120042800902, 0.0062004280090246, -0.39879957199098, 0.41120042800902},
	[2763] = {0.021883115768434, 0.026883115768434, -0.50311688423157, -0.50311688423157, 0.54688311576843, 0.55688311576843, 0.006883115768434, -0.40311688423157, 0.41688311576843},
	[2764] = {0.021073236465456, 0.016073236465455, -0.50392676353454, -0.53392676353454, 0.54607323646546, 0.56607323646546, 0.0060732364654555, -0.40392676353454, 0.41607323646546},
	[2788] = {-0.042253117561339, -0.0022531175613392, -0.28725311756134, -0.24725311756134, 0.20274688243866, 0.24274688243866, -0.26725311756134, -0.52725311756134, -0.0072531175613392},
	[2802] = {0.09527736663817, 0.01027736663817, -0.58472263336183, -1.1947226333618, 0.77527736663817, 1.2152773666382, -0.26725311756134, -0.52725311756134, -0.0072531175613392},
	[15036] = {0.0052476310728735, 0.0052476310728738, -2.4897523689271, -1.4897523689271, 2.5002476310729, 1.5002476310729, 0.0052476310728738, -1.1397523689271, 1.1502476310729},
	[2294] = {0.0036561775207318, 0.11865617752073, -0.49634382247927, -0.26634382247927, 0.50365617752073, 0.50365617752073, 1.1036561775207, 0.013656177520732, 2.1936561775207},
	[2336] = {0.51103204727172, 0.15103204727172, -0.48396795272828, -0.20396795272828, 1.5060320472717, 0.50603204727172, 0.53103204727172, 0.0060320472717184, 1.0560320472717},
	[2337] = {0.013031973838808, 0.13303197383881, -0.48196802616119, -0.24196802616119, 0.50803197383881, 0.50803197383881, 0.53303197383881, 0.018031973838808, 1.0480319738388},
	[2339] = {0.0030501270294203, 0.09805012702942, -0.49194987297058, -0.30194987297058, 0.49805012702942, 0.49805012702942, 0.52805012702942, 0.0080501270294203, 1.0480501270294},
	[2340] = {0.0030461931228651, 0.098046193122865, -0.49195380687714, -0.30195380687714, 0.49804619312287, 0.49804619312287, 0.52804619312287, 0.0080461931228651, 1.0480461931229},
	[2127] = {0.50309545516966, 0.12309545516966, -0.48690454483034, -0.25690454483034, 1.4930954551697, 0.50309545516966, 1.0980954551697, 0.0030954551696568, 2.1930954551697},
	[2131] = {0.51483434677119, 0.099834346771188, -0.48016565322881, -0.30016565322881, 1.5098343467712, 0.49983434677119, 2.0048343467712, 0.0098343467711875, 3.9998343467711},
	[2132] = {0.50693999290466, 0.10693999290465, -0.48806000709535, -0.28806000709535, 1.5019399929047, 0.50193999290465, 0.60693999290466, 0.0019399929046547, 1.2119399929047},
	[2135] = {0.0083947753906043, 0.1433947753906, -0.4816052246094, -0.2116052246094, 0.4983947753906, 0.4983947753906, 1.3983947753906, 0.0083947753906043, 2.7883947753906},
	[2136] = {0.51403138160705, 0.14403138160705, -0.47096861839296, -0.21096861839296, 1.499031381607, 0.49903138160705, 0.52403138160705, -0.00096861839295506, 1.049031381607},
	[2147] = {0.0087627983092809, 0.088762798309281, -0.47123720169072, -0.32123720169072, 0.48876279830928, 0.49876279830928, 2.0037627983093, 0.0087627983092809, 3.9987627983092},
	[1429] = {0.015613107681275, 0.015613107681275, -0.33438689231872, -0.23438689231872, 0.36561310768128, 0.26561310768128, 0.0056131076812752, -0.24438689231872, 0.25561310768128},
	[1747] = {-0.19625059843063, -0.25625059843063, -0.48125059843063, -0.47125059843063, 0.088749401569367, -0.041250598430633, 0.21874940156937, 0.0087494015693671, 0.42874940156937},
	[1748] = {-0.1709220290184, -0.3159220290184, -0.4909220290184, -0.4809220290184, 0.1490779709816, -0.1509220290184, 0.2340779709816, 0.0090779709815985, 0.4590779709816},
	[1749] = {-0.19761661529541, -0.17761661529541, -0.49261661529541, -0.48261661529541, 0.097383384704591, 0.12738338470459, 0.28738338470459, 0.0073833847045906, 0.56738338470459},
	[1750] = {-0.1382132601738, -0.2782132601738, -0.4882132601738, -0.4782132601738, 0.2117867398262, -0.078213260173797, 0.2667867398262, 0.011786739826203, 0.5217867398262},
	[1751] = {-0.13099849224091, -0.28099849224091, -0.48599849224091, -0.48599849224091, 0.2240015077591, -0.075998492240905, 0.2790015077591, 0.004001507759095, 0.5540015077591},
	[1752] = {-0.05824749469757, -0.21324749469757, -0.48824749469757, -0.48824749469757, 0.37175250530243, 0.06175250530243, 0.36675250530243, 0.01175250530243, 0.72175250530243},
	[1781] = {-0.14799349069595, -0.30799349069595, -0.49299349069595, -0.48299349069595, 0.19700650930405, -0.13299349069595, 0.23700650930405, 0.0070065093040473, 0.46700650930405},
	[1786] = {0.095155315399171, -0.20984468460083, -0.48484468460083, -0.48484468460083, 0.67515531539917, 0.065155315399171, 0.36515531539917, 0.015155315399171, 0.71515531539917},
	[1791] = {-0.093639411926269, -0.19363941192627, -0.39863941192627, -0.38863941192627, 0.21136058807373, 0.0013605880737312, 0.28136058807373, 0.0013605880737312, 0.56136058807373},
	[1792] = {0.089542393684388, -0.26045760631561, -0.49045760631561, -0.48045760631561, 0.66954239368439, -0.040457606315612, 0.44954239368439, 0.0095423936843884, 0.88954239368439},
	[2296] = {0.99474377632137, -0.095256223678629, -0.48525622367863, -0.48525622367863, 2.4747437763214, 0.29474377632137, 1.2447437763214, 0.0047437763213712, 2.4847437763214},
	[2297] = {0.5116965484619, 0.5166965484619, -0.4633034515381, -0.4633034515381, 1.4866965484619, 1.4966965484619, 0.8566965484619, 0.016696548461898, 1.6966965484619},
	[14532] = {0.0049950027465781, -0.0050049972534219, -0.41000499725342, -0.36000499725342, 0.41999500274658, 0.34999500274658, -4.9972534219012e-06, -0.98000499725342, 0.97999500274658},
	[1719] = {0.0098969697952276, 0.014896969795228, -0.27510303020477, -0.17510303020477, 0.29489696979523, 0.20489696979523, 0.029896969795228, -0.045103030204772, 0.10489696979523},
	[2028] = {0.00082397937774711, 0.015823979377747, -0.23417602062225, -0.24417602062225, 0.23582397937775, 0.27582397937775, 0.0058239793777471, -0.074176020622253, 0.085823979377747},
	[2421] = {-0.15160115718841, -0.21160115718841, -0.47160115718842, -0.47160115718842, 0.16839884281159, 0.048398842811585, 0.22339884281159, 0.0083988428115852, 0.43839884281159},
	[2149] = {0.019718816280366, 0.014718816280366, -0.23028118371963, -0.17028118371963, 0.26971881628037, 0.19971881628037, 0.0097188162803655, -0.15028118371963, 0.16971881628037},
	[2226] = {0.013798546791077, 0.0087985467910774, -0.39620145320892, -0.12620145320892, 0.42379854679108, 0.14379854679108, 0.16379854679108, 0.0037985467910774, 0.32379854679108},
	[2227] = {-0.27012630462646, -0.35512630462646, -0.48512630462646, -0.48512630462646, -0.055126304626464, -0.22512630462646, 0.52987369537354, 0.0048736953735361, 1.0548736953735},
	[2229] = {-0.30439903259277, -0.24439903259277, -0.48439903259277, -0.49439903259277, -0.12439903259277, 0.0056009674072278, 0.70060096740723, 0.0056009674072278, 1.3956009674072},
	[2230] = {-0.30502093315124, -0.26502093315124, -0.48502093315124, -0.49502093315124, -0.12502093315124, -0.035020933151244, 0.64997906684876, 0.004979066848756, 1.2949790668488},
	[2231] = {-0.24650215148926, -0.26650215148926, -0.49150215148926, -0.49150215148926, -0.0015021514892569, -0.041502151489257, 0.45349784851074, 0.0084978485107431, 0.89849784851074},
	[2232] = {0.011411256790162, 0.0064112567901624, -0.33858874320984, -0.33858874320984, 0.36141125679016, 0.35141125679016, 0.0064112567901624, -0.58858874320984, 0.60141125679016},
	[2233] = {-0.37640189647674, -0.37140189647674, -0.49640189647674, -0.48640189647674, -0.25640189647674, -0.25640189647674, 0.60359810352326, 0.0035981035232554, 1.2035981035233},
	[1782] = {0.0032463836669928, 0.013246383666993, -0.31675361633301, -0.21675361633301, 0.32324638366699, 0.24324638366699, 0.0032463836669928, -0.076753616333007, 0.083246383666993},
	[1783] = {0.0081172013282782, 0.013117201328278, -0.31688279867172, -0.20688279867172, 0.33311720132828, 0.23311720132828, 0.0031172013282782, -0.066882798671722, 0.073117201328278},
	[1785] = {0.011628525257111, 0.011628525257111, -0.30837147474289, -0.20837147474289, 0.33162852525711, 0.23162852525711, 0.0066285252571112, -0.098371474742889, 0.11162852525711},
	[1787] = {0.0038495087623602, 0.01384950876236, -0.32115049123764, -0.21115049123764, 0.32884950876236, 0.23884950876236, 0.0038495087623602, -0.06115049123764, 0.06884950876236},
	[1790] = {0.0081222677230841, 0.013122267723084, -0.31687773227692, -0.20687773227692, 0.33312226772308, 0.23312226772308, 0.0031222677230841, -0.066877732276916, 0.073122267723084},
	[2190] = {-0.22216149330139, -0.26216149330139, -0.48716149330139, -0.47716149330139, 0.042838506698609, -0.047161493301391, 0.27783850669861, 0.012838506698609, 0.54283850669861},
	[2238] = {-0.00052627086639337, 0.0094737291336066, -0.13552627086639, -0.12552627086639, 0.13447372913361, 0.14447372913361, 0.0044737291336066, -0.40552627086639, 0.41447372913361},
	[2196] = {-0.32094552993774, -0.41094552993774, -0.49094552993774, -0.48094552993774, -0.15094552993774, -0.34094552993774, 0.19405447006226, 0.0090544700622562, 0.37905447006226},
	[2726] = {0.0013132095336919, 0.011313209533692, -0.098686790466308, -0.088686790466308, 0.10131320953369, 0.11131320953369, 0.0013132095336919, -0.33868679046631, 0.34131320953369},
	[2724] = {0.0064032363891615, 0.0064032363891615, -0.30859676361084, -0.35859676361084, 0.32140323638916, 0.37140323638916, 0.0064032363891615, -0.53859676361084, 0.55140323638916},
	[2725] = {0.0076269340515147, 0.012626934051515, -0.33737306594849, -0.30737306594849, 0.35262693405151, 0.33262693405151, 0.0026269340515147, -0.42737306594849, 0.43262693405151},
	[3383] = {0.0060430335997977, 0.0060430335997978, -1.9789569664002, -0.8289569664002, 1.9910430335998, 0.8410430335998, 1.0610430335998, 0.0010430335997978, 2.1210430335998},
	[16151] = {-0.51547962188735, 0.29452037811264, -2.1554796218874, -3.6854796218873, 1.1245203781126, 4.2745203781126, 0.56952037811265, -0.38547962188735, 1.5245203781126},
	[2224] = {0.1759436416626, 0.8859436416626, -0.2190563583374, 0.4909436416626, 0.5709436416626, 1.2809436416626, 0.8859436416626, 0.4909436416626, 1.2809436416626},
	[2452] = {0.29825969696043, -0.056740303039571, -0.48674030303957, -0.48674030303957, 1.0832596969604, 0.37325969696043, 1.2282596969604, 0.013259696960429, 2.4432596969604},
	[2627] = {0.012066030502292, -0.012933969497709, -0.37793396949771, -1.0579339694977, 0.40206603050229, 1.0320660305023, 0.087066030502292, 0.0020660305022916, 0.17206603050229},
	[2630] = {0.0079365634918212, 0.012936563491821, -0.15206343650818, -0.73206343650818, 0.16793656349182, 0.75793656349182, 0.63793656349182, 0.0079365634918212, 1.2679365634918},
	[2628] = {0.0077286911010468, -0.092271308898953, -0.49227130889895, -0.90227130889895, 0.50772869110105, 0.71772869110105, 1.197728691101, 0.0077286911010469, 2.387728691101},
	[2629] = {0.015283660888656, 0.025283660888656, -0.54471633911134, -0.69471633911134, 0.57528366088866, 0.74528366088866, 0.56028366088866, 0.0052836608886562, 1.1152836608887},
	[2916] = {0.015051587820053, 5.1587820053406e-05, -0.19994841217995, -0.10994841217995, 0.23005158782005, 0.11005158782005, 0.010051587820053, -0.099948412179947, 0.12005158782005},
	[2915] = {-0.21686764478683, 0.003132355213166, -0.64686764478683, -0.10686764478683, 0.21313235521317, 0.11313235521317, -0.001867644786834, -0.10686764478683, 0.10313235521317},
	[1585] = {0.072810678482053, -0.047189321517947, -0.51718932151795, -0.077189321517947, 0.66281067848205, -0.017189321517947, 0.93281067848205, 0.012810678482053, 1.8528106784821},
	[1584] = {-0.071953535079956, -0.046953535079956, -0.61195353507996, -0.081953535079956, 0.46804646492004, -0.011953535079956, 0.93304646492004, 0.0080464649200441, 1.85804646492},
	[1583] = {0.066046400070187, -0.038953599929813, -0.55895359992981, -0.058953599929813, 0.69104640007019, -0.018953599929813, 0.93104640007019, 0.011046400070187, 1.8510464000702},
	[2484] = {0.0074222755432079, 0.0074222755432079, -0.76257772445679, -0.16257772445679, 0.77742227554321, 0.17742227554321, 0.0024222755432079, -0.83257772445679, 0.83742227554321},
	[2491] = {-0.24450932502746, -0.23450932502746, -0.48950932502746, -0.47950932502746, 0.00049067497253583, 0.010490674972536, 0.94549067497254, 0.010490674972536, 1.8804906749725},
	[2489] = {0.0028954958915715, 0.012895495891572, -0.29710450410843, -0.097104504108428, 0.30289549589157, 0.12289549589157, 0.0028954958915715, -0.12710450410843, 0.13289549589157},
	[2490] = {0.0028954958915715, 0.012895495891572, -0.29710450410843, -0.097104504108428, 0.30289549589157, 0.12289549589157, 0.0028954958915715, -0.12710450410843, 0.13289549589157},
	[2500] = {-0.2121640586853, -0.1921640586853, -0.4721640586853, -0.4721640586853, 0.047835941314698, 0.087835941314698, 0.3678359413147, 0.0078359413146981, 0.7278359413147},
	[2581] = {0.01583096504209, 0.02083096504209, -1.0641690349579, -0.19416903495791, 1.0958309650421, 0.23583096504209, 0.0058309650420902, -1.1441690349579, 1.1558309650421},
	[2584] = {0.017387208938599, 0.017387208938599, -0.4026127910614, -0.4026127910614, 0.4373872089386, 0.4373872089386, 0.0073872089385994, -0.8126127910614, 0.8273872089386},
	[1775] = {0.014416990280139, 0.029416990280139, -0.58058300971986, -0.43058300971986, 0.60941699028014, 0.48941699028014, 0.0044169902801386, -1.0905830097199, 1.0994169902801},
	[1776] = {0.010206956863392, 0.010206956863392, -0.58479304313661, -0.38479304313661, 0.60520695686339, 0.40520695686339, 0.00020695686339145, -1.0947930431366, 1.0952069568634},
	[2743] = {0.0031675720214662, -0.0018324279785338, -0.44683242797853, -0.44683242797853, 0.45316757202147, 0.44316757202147, -0.99683242797853, -1.3468324279785, -0.64683242797853},
	[1369] = {0.0086160087585464, 0.013616008758546, -0.36138399124145, -0.41138399124145, 0.37861600875855, 0.43861600875855, -0.17138399124145, -0.59138399124145, 0.24861600875855},
	[3065] = {0.020596358776093, 0.010596358776093, -0.11440364122391, -0.12440364122391, 0.15559635877609, 0.14559635877609, 0.00059635877609263, -0.13440364122391, 0.13559635877609},
	[2898] = {0.0084352874754854, 0.013435287475485, -2.0315647125245, -2.6915647125245, 2.0484352874755, 2.7184352874755, 0.0034352874754857, -0.021564712524514, 0.028435287475486},
	[1985] = {0.0037844085693274, 0.0037844085693274, -0.29621559143067, -0.29621559143067, 0.30378440856933, 0.30378440856933, -1.4512155914307, -2.4162155914307, -0.48621559143067},
	[3461] = {0.0080849170684562, 0.0080849170684562, -0.28691508293154, -0.28691508293154, 0.30308491706846, 0.30308491706846, 0.0030849170684561, -1.5669150829315, 1.5730849170685},
	[3534] = {0.0042488670349132, 0.0042488670349132, -0.59075113296509, -0.59075113296509, 0.59924886703491, 0.59924886703491, -0.55575113296509, -1.3007511329651, 0.18924886703491},
	[3385] = {0.0045338082313544, 0.0045338082313544, -0.29046619176865, -0.29046619176865, 0.29953380823135, 0.29953380823135, 0.029533808231354, 0.0095338082313544, 0.049533808231354},
	[2976] = {0.0060849046707161, 0.0060849046707161, -0.20891509532928, -0.20891509532928, 0.22108490467072, 0.22108490467072, 0.39108490467072, 0.011084904670716, 0.77108490467072},
	[1829] = {0.00089489936828266, 0.010894899368283, -0.42410510063172, -0.72410510063172, 0.42589489936828, 0.74589489936828, 0.010894899368283, -0.45410510063172, 0.47589489936828},
	[2778] = {0.02319259643554, 0.02319259643554, -0.36680740356446, -0.45680740356446, 0.41319259643554, 0.50319259643554, 1.0481925964355, 0.01319259643554, 2.0831925964355},
	[2779] = {0.02319259643554, 0.02319259643554, -0.36680740356446, -0.45680740356446, 0.41319259643554, 0.50319259643554, 1.0481925964355, 0.01319259643554, 2.0831925964355},
	[2872] = {0.023724632263176, 0.013724632263176, -0.36127536773682, -0.47127536773682, 0.40872463226318, 0.49872463226318, 1.0487246322632, 0.0087246322631761, 2.0887246322632},


	[2099] = {0.12412501335144, -0.24587498664856, -0.49087498664856, -0.49087498664856, 0.73912501335144, -0.00087498664855814, 0.47912501335144, 0.0091250133514419, 0.94912501335144},
	[2100] = {0.23316751480102, -0.19183248519898, -0.48683248519898, -0.48683248519898, 0.95316751480102, 0.10316751480102, 0.53816751480102, 0.0031675148010192, 1.073167514801},
	--[2103] = {0.018587622642518, 0.028587622642518, -0.52641237735748, -0.15641237735748, 0.56358762264252, 0.21358762264252, 0.23358762264252, 0.0035876226425181, 0.46358762264252},
	[2225] = {-0.14395435810089, -0.27395435810089, -0.48395435810089, -0.48395435810089, 0.19604564189911, -0.06395435810089, 0.43104564189911, 0.0060456418991098, 0.85604564189911},
	[2101] = {-0.002871713638305, 0.012128286361695, -0.27787171363831, -0.21787171363831, 0.2721282863617, 0.2421282863617, 0.2721282863617, 0.002128286361695, 0.5421282863617},

	[1778] = {-0.16742806911468, -0.24242806911468, -0.37742806911468, -0.35742806911468, 0.042571930885316, -0.12742806911468, 0.12757193088532, 0.0025719308853161, 0.25257193088532},

	[630] = {-0.02053773880005, 0.01946226119995, -0.21053773880005, -0.17053773880005, 0.16946226119995, 0.20946226119995, -0.13553773880005, -0.85053773880005, 0.57946226119995},
	[631] = {-0.02053773880005, 0.01946226119995, -0.21053773880005, -0.17053773880005, 0.16946226119995, 0.20946226119995, -0.13553773880005, -0.85053773880005, 0.57946226119995},
	[632] = {-0.89268731117252, -0.0026873111725214, -1.2876873111725, -0.39768731117252, -0.49768731117252, 0.39231268882748, 0.93231268882748, -0.43768731117252, 2.3023126888275},
	[633] = {-0.01730917930604, 0.0026908206939603, -0.32730917930604, -0.30730917930604, 0.29269082069396, 0.31269082069396, -0.35730917930604, -0.98730917930604, 0.27269082069396},
	[638] = {0.016261806488, 0.011261806487999, -0.338738193512, -1.328738193512, 0.371261806488, 1.351261806488, -0.493738193512, -0.688738193512, -0.298738193512},
	[646] = {0.090436248779263, -0.12956375122074, -0.13956375122074, -0.35956375122074, 0.32043624877926, 0.10043624877926, -1.1795637512207, -1.4095637512207, -0.94956375122074},
	[948] = {0.0085707950592056, 0.018570795059206, -0.25142920494079, -0.24142920494079, 0.26857079505921, 0.27857079505921, 0.34357079505921, 0.0085707950592056, 0.67857079505921},
	[949] = {0.015556511878969, 0.020556511878969, -0.21944348812103, -0.21944348812103, 0.25055651187897, 0.26055651187897, -0.42444348812103, -0.62944348812103, -0.21944348812103},
	[950] = {0.032275762557985, 0.042275762557985, -0.41772423744202, -0.23772423744202, 0.48227576255799, 0.32227576255799, -0.30272423744202, -0.53772423744202, -0.067724237442015},
	[1361] = {0.0085307979583746, 0.0085307979583746, -0.48646920204163, -0.48646920204163, 0.50353079795837, 0.50353079795837, 0.0035307979583746, -0.73646920204163, 0.74353079795838},
	[2001] = {-0.052863979339598, 0.062136020660402, -0.2378639793396, -0.1678639793396, 0.1321360206604, 0.2921360206604, 0.8871360206604, 0.0021360206604016, 1.7721360206604},
	[2010] = {-0.004333486557024, 0.0056665134429761, -0.45933348655702, -0.45933348655702, 0.45066651344298, 0.47066651344298, 0.00066651344297602, -0.89933348655702, 0.90066651344298},
	[2011] = {0.03057581901548, 0.0055758190154798, -0.26442418098452, -0.47442418098452, 0.32557581901548, 0.48557581901548, 0.00057581901547982, -0.99442418098452, 0.99557581901548},
	[2194] = {8.8329315186181e-05, 0.010088329315186, -0.16991167068481, -0.15991167068481, 0.17008832931519, 0.18008832931519, -0.15491167068481, -0.32991167068481, 0.020088329315186},
	[2195] = {0.010304160118105, 0.020304160118105, -0.3446958398819, -0.3346958398819, 0.3653041601181, 0.3753041601181, -0.4296958398819, -0.6146958398819, -0.2446958398819},
	[2240] = {0.0068544960021986, 0.0068544960021986, -0.3531455039978, -0.3331455039978, 0.3668544960022, 0.3468544960022, -0.2531455039978, -0.5931455039978, 0.086854496002199},
	[2241] = {0.0037568950653088, 0.0037568950653088, -0.35124310493469, -0.30124310493469, 0.35875689506531, 0.30875689506531, -0.19624310493469, -0.47124310493469, 0.078756895065309},
	[2244] = {0.023500423431397, 0.0035004234313971, -0.1414995765686, -0.1614995765686, 0.1885004234314, 0.1685004234314, -0.071499576568603, -0.2714995765686, 0.1285004234314},
	[2251] = {0.0095078945159927, 0.0045078945159927, -0.31549210548401, -0.18549210548401, 0.33450789451599, 0.19450789451599, 0.0095078945159927, -0.83549210548401, 0.85450789451599},
	[2252] = {0.026554279327393, -0.0034457206726067, -0.30844572067261, -0.33844572067261, 0.36155427932739, 0.33155427932739, -0.14844572067261, -0.31844572067261, 0.021554279327393},
	[2253] = {0.024956755638123, -4.3244361876887e-05, -0.14004324436188, -0.17004324436188, 0.18995675563812, 0.16995675563812, -0.085043244361877, -0.28004324436188, 0.10995675563812},
	[2811] = {0.0071498584747329, 0.0071498584747329, -0.18785014152527, -0.18785014152527, 0.20214985847473, 0.20214985847473, 0.20714985847473, 0.012149858474733, 0.40214985847473},
	[14834] = {0.015141649246196, 0.00014164924619572, -0.3498583507538, -0.3598583507538, 0.3801416492462, 0.3601416492462, 1.0151416492462, -0.2698583507538, 2.3001416492462},

	[2332] = {0.0081329679489148, 0.013132967948915, -0.41686703205109, -0.40686703205109, 0.43313296794892, 0.43313296794892, 0.0031329679489148, -0.45686703205109, 0.46313296794892},

	[2648] = {0.00043422698974113, -0.0045657730102589, -0.11956577301026, -0.99956577301026, 0.12043422698974, 0.99043422698974, -0.0045657730102589, -0.56956577301026, 0.56043422698974},
	[14772] = {0.00059556007384929, -0.0044044399261507, -0.059404439926151, -0.99940443992615, 0.060595560073849, 0.99059556007385, -0.0044044399261507, -0.49940443992615, 0.49059556007385},

	[2964] = {0.0083254146575743, 0.013325414657574, -1.1166745853424, -0.65667458534243, 1.1333254146576, 0.68332541465757, 0.47832541465757, 0.013325414657574, 0.94332541465758},

	[1786] = {-0.0022890853882745, 0.0027109146117252, -0.067289085388274, -2.8672890853883, 0.062710914611726, 2.8727109146117, 0.0027109146117255, -1.3272890853883, 1.3327109146117},

	[7027] = {0.0030339241027385, -0.0019660758972615, -1.1119660758973, -1.0619660758973, 1.1180339241027, 1.0580339241027, 1.3880339241027, 0.0080339241027386, 2.7680339241027},
}

local activeFurnitureModel = false

function setActiveFurniture(obj)
	if activeFurniture ~= obj then
		if obj then
			rotateMode = false
			activeFurniture = obj
			activeFurnitureModel = getElementModel(obj)

			setElementCollisionsEnabled(activeFurniture, false)

			sideIcons = normalSideIcons+2
			sideWidth = sideIconSize*sideIcons+sideIconBorder*(sideIcons+2)
		else
			if isElement(activeFurniture) then
				if getElementModel(activeFurniture) == 2964 then
					local billiardId = getElementData(activeFurniture, "poolTableID")
					if billiardId then
						--outputDebugString("saveBilliard: " .. billiardId)

						local sourcePosX, sourcePosY, sourcePosZ = getElementPosition(activeFurniture)
						local sourceRotX, sourceRotY, sourceRotZ = getElementRotation(activeFurniture)

						triggerServerEvent("moveBilliardFurniture", localPlayer, billiardId, sourcePosX, sourcePosY, sourcePosZ, sourceRotZ)
					end
				elseif getElementModel(activeFurniture) == 2332 then
					local safeId = getElementData(activeFurniture, "safeId")
					if safeId then
						--outputDebugString("saveSafe: " .. safeId)

						local sourcePosX, sourcePosY, sourcePosZ = getElementPosition(activeFurniture)
						local sourceRotX, sourceRotY, sourceRotZ = getElementRotation(activeFurniture)

						triggerServerEvent("moveSafeFurniture", localPlayer, safeId, sourcePosX, sourcePosY, sourcePosZ, sourceRotX, sourceRotY, sourceRotZ)
					end
				end

				setElementCollisionsEnabled(activeFurniture, true)
			end

			activeFurniture = false
			activeFurnitureModel = false

			sideIcons = normalSideIcons
			sideWidth = sideIconSize*sideIcons+sideIconBorder*(sideIcons+2)
		end

		floorMode(obj)
	end
end

local objectsToTest = false

--[[
objectsToTest = {
	631,
}
--]]

if objectsToTest then
	local c = 1

	function testElem(elem)
		----outputDebugString("test")

		local rad = getElementRadius(elem)*2
		local minX = 999
		local minY = 999
		local maxX = -999
		local maxY = -999

		local wasX, wasY = 0, 0

		for y2=-rad,rad,0.01 do
			for x2=-rad,rad,0.01 do
				local hit, xe, ye, ze, el = processLineOfSight(x2, y2, 4, x2, y2, -4, false, false, false, true)

				if hit and el == elem then
					--dxDrawLine3D(x+x2, y+y2, z-4, x+x2, y+y2, 4, tocolor(0, 255, 0), 5)

					----outputDebugString("hit")

					if x2 < minX then
						minX = x2
					end

					if x2 > maxX then
						maxX = x2
					end

					if y2 < minY then
						minY = y2
					end

					if y2 > maxY then
						maxY = y2
					end
				end
			end
		end

		if minX ~= 999 then
			local minZ = 999
			local maxZ = -999

			for z=-rad,rad,0.01 do
				local hit, xe, ye, ze, el = processLineOfSight(minX-1, minY-1, z, maxX+1, maxY+1, z, false, false, false, true)

				if hit and el == elem then
					--dxDrawLine3D(x+x2, y+y2, z-4, x+x2, y+y2, 4, tocolor(0, 255, 0), 5)

					----outputDebugString("hit")

					if z < minZ then
						minZ = z
					end

					if z > maxZ then
						maxZ = z
					end
				end
			end

			modelOffsets[getElementModel(elem)] = {(minX+maxX)/2, (minY+maxY)/2, minX, minY, maxX, maxY, (minZ+maxZ)/2, minZ, maxZ}
		end

		destroyElement(elem)

		if c < #objectsToTest then
			c = c +1

			--outputDebugString("test: " .. objectsToTest[c])

			local testElement = createObject(objectsToTest[c], 0, 0, 0)
			setElementInteriorAndDimension(testElement, 1)
			setElementStreamable(testElement, false)

			setTimer(testElem, 500, 1, testElement)
		end
	end

	local testElement = createObject(objectsToTest[c], 0, 0, 0)
	setElementInteriorAndDimension(testElement, 1)
	setElementStreamable(testElement, false)

	setTimer(testElem, 500, 1, testElement)
end

function screenFromObj(obj, x, y, z)
	local ox, oy, oz = getElementPosition(obj)

	local sx, sy = getScreenFromWorldPosition(x+ox, y+oy, z+oz)

	return sx, sy
end

function rotateAround(angle, centerX, centerY, x, y)
	local pointX = x
	local pointY = y

	local drawX = centerX + (pointX - centerX) * math.cos(angle) - (pointY - centerY) * math.sin(angle)
	local drawY = centerY + (pointX - centerX) * math.sin(angle) + (pointY - centerY) * math.cos(angle)

	return drawX, drawY
end

local lastRotateSound = 0

function moveFurniture(cx, cy, x, y, z)
	if getKeyState("mouse1") then
		if rotateMode then
			if not movingFurniture then
				local x, y, z = getElementPosition(activeFurniture)
				local ox, oy = x, y
				local rx, ry, rz = getElementRotation(activeFurniture)

				if modelOffsets[activeFurnitureModel] then
					local x2, y2 = rotateAround(math.rad(rz), 0, 0, modelOffsets[activeFurnitureModel][1], modelOffsets[activeFurnitureModel][2])

					x = x + x2
					y = y + y2
				end

				local rot = math.atan2(cy-y, cx-x)+math.rad(90)-math.rad(rz)

				movingFurniture = {cx, cy, x, y, rz, ox, oy, z, rot} --8as param rotatenel bugol!
			end

			if cx ~= -1000 then
				local rot = math.atan2(cy-movingFurniture[4], cx-movingFurniture[3])+math.rad(90)-movingFurniture[9]

				if snappingR then
					local s = 0

					if snappingR < 10 then
						s = 10
					else
						s = 5
					end

					s = math.rad(s)

					rot = math.ceil(rot/s)*s
				end

				rot = math.deg(rot)

				if activeFurnitureModel == 2964 then
					rot = math.floor(rot/90)

					if rot % 2 == 0 then
						rot = 0
					else
						rot = 90
					end

					--rot =
				end

				setElementRotation(activeFurniture, 0, 0, rot)

				if math.floor(lastRot) ~= math.floor(rot) and getTickCount()-lastRotateSound >= 175 then
					--playSoundEx("sounds/rotate.mp3")
					lastRotateSound = getTickCount()
				end

				lastRot = rot

				rot = math.rad(rot)

				local x, y, z = movingFurniture[6], movingFurniture[7], movingFurniture[8]

				local x2, y2 = rotateAround(rot-math.rad(movingFurniture[5]), movingFurniture[3], movingFurniture[4], x, y)

				--x = x + x2
				--y = y + y2

				setElementPosition(activeFurniture, x2, y2, z)
			end
		else
			if z then
				if not movingFurniture then
					local px, py, pz = getElementPosition(activeFurniture)
					movingFurniture = {cx-x, cy-y, x, y, px, py, pz, true}
					setCursorAlpha(0)

					local x, y = getCursorPosition()
					lastCursor = {x, y}
					--leftPosition = {x*screenX, y*screenY}
				end

				movingFurniture[9], movingFurniture[10] = x, y
			else
				if not movingFurniture then
					local px, py, pz = getElementPosition(activeFurniture)
					movingFurniture = {cx, cy, x, y, px, py, pz}
				end

				if cx ~= -1000 then
					cx = movingFurniture[5]+(cx-movingFurniture[1])*math.abs(movingFurniture[3])
					cy = movingFurniture[6]+(cy-movingFurniture[2])*math.abs(movingFurniture[4])

					if snapping then
						if movingFurniture[3] ~= 0 then
							cx = math.floor(cx*snapping)/snapping
						else
							cy = math.floor(cy*snapping)/snapping
						end
					end

					setElementPosition(activeFurniture, cx, cy, movingFurniture[7])
				else
					--outputDebugString("nocx")
				end
			end
		end
	elseif movingFurniture then

		movingFurniture = false
	end
end

if not photoMode then
	
	function onClientPreRender(delta)
		local x, y = false, false

		if getKeyState("w") or getKeyState("arrow_u") then
			y = 0 - delta/1000
		elseif getKeyState("s") or getKeyState("arrow_d") then
			y = 0 + delta/1000
		end

		if getKeyState("a") or getKeyState("arrow_l") then
			x = 0 - delta/1000
		elseif getKeyState("d") or getKeyState("arrow_r") then
			x = 0 + delta/1000
		end

		if x or y then
			x = x or 0
			y = y or 0

			if getKeyState("lshift") then
				if cameraReversed then
					x = -x
					y = -y
				end

				yaw = math.deg(yaw)+x*mouseIntensity
				pitch = math.deg(pitch)+y*(-mouseIntensity)

				if pitch >= 89.9 then
					pitch = 89.9
				end
				
				if pitch <= 0 then
					pitch = 0
				end

				----outputDebugString(pitch)
				----outputDebugString(yaw)

				yaw = math.rad(yaw)
				pitch = math.rad(pitch)

				orbitCamera()
			else
				if cameraReversed then
					y = -y
				end

				local int = (mouseIntensity*dist)/100

				cam[1] = cam[1] + (y*int) * math.cos(yaw) - (x*int) * math.sin(yaw)
				cam[2] = cam[2] + (y*int) * math.sin(yaw) + (x*int) * math.cos(yaw)

				if cam[1] < borders[1] then
					cam[1] = borders[1]
				end
				
				if cam[2] < borders[2] then
					cam[2] = borders[2]
				end

				if cam[1] > borders[3] then
					cam[1] = borders[3]
				end

				if cam[2] > borders[4] then
					cam[2] = borders[4]
				end

				orbitCamera()
			end
		end
	end
else
	function onClientPreRender(delta)

	end
end

local lastActiveButton = false

function onClientRender()
	if testMode or mainSelection ~= "furnitures" then
		global.checkForObjectPreviewsUnload()
	end
	cx, cy = getCursorPositionEx()
	lastActiveButton = activeButton
	activeButton = false

	
	if activeFurniture then
		local x, y, z = getWorldFromScreenPosition(cx, cy, 1000)
		local hit, px, py, pz, element = processLineOfSight(cam[4], cam[5], cam[6], x, y, z, false, false, false, true, false)

		local cxd, cyd = -1000, -1000

		if hit and floorCoordinates[element] then
			cxd, cyd = px, py
		end

		local x1, y1, x2, y2, x3, y3, x4, y4, z, z2, z3 = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		local x, y, z = getElementPosition(activeFurniture)
		local rx, ry, rz = getElementRotation(activeFurniture)

		if modelOffsets[activeFurnitureModel] then
			local rot = math.rad(rz)
			local xe3, ye3 = rotateAround(rot, 0, 0, modelOffsets[activeFurnitureModel][1], modelOffsets[activeFurnitureModel][2])

			x = x + xe3
			y = y + ye3

			z2 = z + modelOffsets[activeFurnitureModel][8]
			z3 = z + modelOffsets[activeFurnitureModel][9]
			z = z + modelOffsets[activeFurnitureModel][7]

			local xe1 = x + modelOffsets[activeFurnitureModel][3]-modelOffsets[activeFurnitureModel][1]
			local ye1 = y + modelOffsets[activeFurnitureModel][4]-modelOffsets[activeFurnitureModel][2]
--local 
			local xe2 = x + modelOffsets[activeFurnitureModel][5]-modelOffsets[activeFurnitureModel][1]
			local ye2 = y + modelOffsets[activeFurnitureModel][6]-modelOffsets[activeFurnitureModel][2]
			
			x1, y1 = rotateAround(rot, x, y, xe1, ye1)

			x2, y2 = rotateAround(rot, x, y, xe2, ye2)

			x3, y3 = rotateAround(rot, x, y, xe1, ye2)

			x4, y4 = rotateAround(rot, x, y, xe2, ye1)


			--dxDrawLine3D(x1, y1, z2, x1, y1, z3, tocolor(255, 255, 0), 10)
			--dxDrawLine3D(x2, y2, z2, x2, y2, z3, tocolor(255, 255, 0), 10)
			--dxDrawLine3D(x3, y3, z2, x3, y3, z3, tocolor(255, 255, 0), 10)
			--dxDrawLine3D(x4, y4, z2, x4, y4, z3, tocolor(255, 255, 0), 10)

			x1 = math.min(x1, x2, x3, x4)
			x2 = math.max(x1, x2, x3, x4)

			y1 = math.min(y1, y2, y3, y4)
			y2 = math.max(y1, y2, y3, y4)
		end

		if movingFurniture and movingFurniture[8] == true then
			local px, py, z = movingFurniture[5], movingFurniture[6], movingFurniture[7]

			if snapping then
				local gr = grid[3]+getElementDistanceFromCentreOfMassToBaseOfModel(activeFurniture)+thickness/2
				z = z - gr
				
				z = math.ceil(z*snapping)/snapping
				
				z = z + gr
			end

			setElementPosition(activeFurniture, px, py, z)
		end

		local sx, sy = getScreenFromWorldPosition(x, y, z3+0.25)

		if sx then
			local width = furnitureIconSize*3

			if not rotateMode then
				width = width+furnitureIconSize*2
			end

			local x = sx-width/2
			local y = sy-furnitureIconSize

			dxDrawRectangle(x, y, width, furnitureIconSize, tocolor(0, 0, 0, 150))
			
			if cy >= y and cy <= y+furnitureIconSize and cx >= x and cx <= x+furnitureIconSize then
				activeButton = "rotateMode:on"
				dxDrawImage(x, y, furnitureIconSize, furnitureIconSize, "files/icons/rotateicon.png", 0, 0, 0, tocolor(r, g, b))
			elseif rotateMode then
				dxDrawImage(x, y, furnitureIconSize, furnitureIconSize, "files/icons/rotateicon.png", 0, 0, 0, tocolor(r, g, b))
			else
				dxDrawImage(x, y, furnitureIconSize, furnitureIconSize, "files/icons/rotateicon.png")
			end

			x = x + furnitureIconSize

			if cy >= y and cy <= y+furnitureIconSize and cx >= x and cx <= x+furnitureIconSize then
				activeButton = "rotateMode:off"
				dxDrawImage(x, y, furnitureIconSize, furnitureIconSize, "files/icons/moveicon.png", 0, 0, 0, tocolor(r, g, b))
			elseif not rotateMode then
				dxDrawImage(x, y, furnitureIconSize, furnitureIconSize, "files/icons/moveicon.png", 0, 0, 0, tocolor(r, g, b))
			else
				dxDrawImage(x, y, furnitureIconSize, furnitureIconSize, "files/icons/moveicon.png")
			end

			if not rotateMode then
				x = x + furnitureIconSize

				if cy >= y and cy <= y+furnitureIconSize and cx >= x and cx <= x+furnitureIconSize then
					activeButton = "placeOnFloor"
					dxDrawImage(x, y, furnitureIconSize, furnitureIconSize, "files/icons/movedown.png", 0, 0, 0, tocolor(r, g, b))
				else
					dxDrawImage(x, y, furnitureIconSize, furnitureIconSize, "files/icons/movedown.png")
				end

				x = x + furnitureIconSize

				if (cy >= y and cy <= y+furnitureIconSize and cx >= x and cx <= x+furnitureIconSize) or (movingFurniture and movingFurniture[8]) then
					activeButton = "upDownFurnitre"
					dxDrawImage(x, y, furnitureIconSize, furnitureIconSize, "files/icons/updown.png", 0, 0, 0, tocolor(r, g, b))

					moveFurniture(cx, cy, x, y, true)
				else
					dxDrawImage(x, y, furnitureIconSize, furnitureIconSize, "files/icons/updown.png")
				end
			end

			x = x + furnitureIconSize

			if cy >= y and cy <= y+furnitureIconSize and cx >= x and cx <= x+furnitureIconSize then
				activeButton = "deleteFurniture"
				dxDrawImage(x, y, furnitureIconSize, furnitureIconSize, "files/icons/delete.png", 0, 0, 0, tocolor(r, g, b))
			else
				dxDrawImage(x, y, furnitureIconSize, furnitureIconSize, "files/icons/delete.png")
			end

		elseif movingFurniture and movingFurniture[8] == true then
			moveFurniture(cx, cy, false, false, true)
		end

		--dxDrawLine3D(x, y, z2, x, y, z3, tocolor(0, 255, 0), 10)
		--dxDrawLine3D(x+10, y, z, x, y, z, tocolor(0, 255, 0), 10)

		--dxDrawLine3D(x, y, z, x, y, z+10, tocolor(0, 255, 0), 10)

		----outputDebugString(x1)
		----outputDebugString(x2)

		--dxDrawLine3D(x1, y1, z, x1, y1, z+10, tocolor(0, 255, 0), 10)
		--dxDrawLine3D(x2, y2, z, x2, y2, z+10, tocolor(0, 255, 0), 10)
----
		--dxDrawLine3D(x2, y1, z, x2, y1, z+10, tocolor(0, 255, 0), 10)
		--dxDrawLine3D(x1, y2, z, x1, y2, z+10, tocolor(0, 255, 0), 10)

		z = grid[3]+lineDraw

	
		if rotateMode then
			local sizeX = modelOffsets[activeFurnitureModel][5]-modelOffsets[activeFurnitureModel][3]
			local sizeY = modelOffsets[activeFurnitureModel][6]-modelOffsets[activeFurnitureModel][4]

			local size = math.max(sizeX, sizeY)*(modelBigRotate[activeFurnitureModel] or 0.75)

			if (not movingFurniture and not activeButton and cxd >= x-size and cxd <= x+size and cyd >= y-size and cyd <= y+size) or movingFurniture then
				dxDrawMaterialLine3D(x-size, y, z, x+size, y, z, rotate, size*2, tocolor(r, g, b), x, y, z+10)

				activeButton = "moveFurniture"

				moveFurniture(cxd, cyd, 0, 0)
			else
				dxDrawMaterialLine3D(x-size, y, z, x+size, y, z, rotate, size*2, tocolor(255, 255, 255), x, y, z+10)
			end

			if sx then
				local rot = math.floor(rz*10)/10
				local width = dxGetTextWidth(rot .. "°", 1, dxfont0_roboto)+respc(6)

				dxDrawRectangle(sx-width/2, sy-furnitureIconSize-respc(4)-lightHeight-respc(2), width, lightHeight+respc(4), tocolor(0, 0, 0, 150))
				dxDrawText(rot .. "°", sx, 0, sx, sy-furnitureIconSize-respc(4), tocolor(255, 255, 255), 1, dxfont0_roboto, "center", "bottom", false, false, false, true)
			end
		else
			if (not movingFurniture and not activeButton and cxd >= x1-arrowSize and cxd <= x1 and cyd >= y-arrowSize/2 and cyd <= y+arrowSize/2) or (movingFurniture and movingFurniture[3] == -1) then
				dxDrawMaterialLine3D(x1-arrowSize, y, z, x1, y, z, move, arrowSize, tocolor(r, g, b), x1-0.5, y, z+10)
				activeButton = "moveFurniture"

				moveFurniture(cxd, cyd, -1, 0)
			else
				dxDrawMaterialLine3D(x1-arrowSize, y, z, x1, y, z, move, arrowSize, tocolor(255, 255, 255), x1-0.5, y, z+10)
			end

			if (not movingFurniture and not activeButton and cxd >= x2 and cxd <= x2+arrowSize and cyd >= y-arrowSize/2 and cyd <= y+arrowSize/2) or (movingFurniture and movingFurniture[3] == 1) then
				dxDrawMaterialLine3D(x2+arrowSize, y, z, x2, y, z, move, arrowSize, tocolor(r, g, b), x2+0.5, y, z+10)
				activeButton = "moveFurniture"

				moveFurniture(cxd, cyd, 1, 0)
			else
				dxDrawMaterialLine3D(x2+arrowSize, y, z, x2, y, z, move, arrowSize, tocolor(255, 255, 255), x2+0.5, y, z+10)
			end

			if (not movingFurniture and not activeButton and cxd >= x-arrowSize/2 and cxd <= x+arrowSize/2 and cyd >= y1-arrowSize and cyd <= y1) or (movingFurniture and movingFurniture[4] == -1) then
				dxDrawMaterialLine3D(x, y1-arrowSize, z, x, y1, z, move, arrowSize, tocolor(r, g, b), x, y1-0.5, z+10)
				activeButton = "moveFurniture"

				moveFurniture(cxd, cyd, 0, -1)
			else
				dxDrawMaterialLine3D(x, y1-arrowSize, z, x, y1, z, move, arrowSize, tocolor(255, 255, 255), x, y1-0.5, z+10)
			end

			if (not movingFurniture and not activeButton and cxd >= x-arrowSize/2 and cxd <= x+arrowSize/2 and cyd >= y2 and cyd <= y2+arrowSize) or (movingFurniture and movingFurniture[4] == 1) then
				dxDrawMaterialLine3D(x, y2+arrowSize, z, x, y2, z, move, arrowSize, tocolor(r, g, b), x, y2+0.5, z+10)
				activeButton = "moveFurniture"

				moveFurniture(cxd, cyd, 0, 1)
			else
				dxDrawMaterialLine3D(x, y2+arrowSize, z, x, y2, z, move, arrowSize, tocolor(255, 255, 255), x, y2+0.5, z+10)
			end
		end
	end

	--dxDrawLine3D(x1, y1, z-10, x1, y1, z+10, tocolor(255, 0, 0), 10)
	--dxDrawLine3D(x2, y2, z-10, x2, y2, z+10, tocolor(255, 0, 0), 10)
	--dxDrawLine3D(x1, y2, z-10, x1, y2, z+10, tocolor(255, 0, 0), 10)
	--dxDrawLine3D(x2, y1, z-10, x2, y1, z+10, tocolor(255, 0, 0), 10)

	if testMode then
		local x, y, z = getElementPosition(localPlayer)

		if z < grid[3]-1 then
			setTest()
		end

		--dxDrawRectangle(itemBorder-4, screenY-mainRectSize+itemBorderY+itemPlusY-4, oneItemWidth-itemBorder+8, mainRectSize-itemBorderY*2+8, tocolor(0, 0, 0, 175))
		--drawItemRectangle(1, "icons2/testleave", "Szerkesztés", "test", false)
		drawSideGUI()
	else
		setCameraMatrix(cam[4], cam[5], cam[6], cam[1], cam[2], cam[3])

		if mode == "setWallpaper" then
			local x, y = cx, cy
			local x, y, z = getWorldFromScreenPosition(x, y, 1000)

			--dxDrawLine3D(cam[4], cam[5], cam[6], x, y, z)

			local hit, px, py, pz, element = processLineOfSight(cam[4], cam[5], cam[6], x, y, z, false, false, false, true, false)

			paintHover = false

			if hit and element then
				--setElementPosition(marker, px, py, pz)
				paintHover = {element, px, py}
			end
		elseif mode == "deleteWindow" then
			local x, y = cx, cy
			local x, y, z = getWorldFromScreenPosition(x, y, 1000)

			--dxDrawLine3D(cam[4], cam[5], cam[6], x, y, z)

			local hit, px, py, pz, element = processLineOfSight(cam[4], cam[5], cam[6], x, y, z, false, false, false, true, false)


			--applyTextureToElement(element, "la_carp4", "window", "normal", 1)

			local coord = 0
			local rx, ry, rz = 0, 0, 0

			if element then
				if getElementModel(element) == wallModellID["base"] then
					rx, ry, rz = getElementRotation(element)

					if rz == 0 or rz == 180 then
						coord = math.floor((py-grid[2])/floorBaseSize*2)+1.5
					else
						coord = math.floor((px-grid[1])/floorBaseSize*2)+1.5
					end
				end
			end

			if element ~= windowHover or coord ~= windowHoverRotation then
				--outputDebugString("windowhoverchange")
				unuseWindowHover()

				if element then
					if getElementModel(element) == wallModellID["base"] then
						----outputDebugString("addbase")
						local tx, ty = unpack(baseWallCoordinates[element])

						----outputDebugString(py)

						if rz == 0 or rz == 180 then
							tx = tx*2+1
							ty = coord
						else
							tx = coord
							ty = ty*2+1
						end

						if windowOnCoordiante[tx .. "," .. ty] then
							windowHoverBaseModel = {tx, ty, rz}
							windowHoverTexture = pathOnElements[windowOnCoordiante[tx .. "," .. ty]]["la_carp4"]

							----outputDebugString(tostring(windowHoverTexture))
								
							destroyWindow(tx, ty)
						end
					end
				end

				windowHover = element
				windowHoverRotation = coord
			end
		elseif mode == "setWindow" then
			local x, y = cx, cy
			local x, y, z = getWorldFromScreenPosition(x, y, 1000)

			--dxDrawLine3D(cam[4], cam[5], cam[6], x, y, z)

			local hit, px, py, pz, element = processLineOfSight(cam[4], cam[5], cam[6], x, y, z, false, false, false, true, false)


			--applyTextureToElement(element, "la_carp4", "window", "normal", 1)

			local coord = 0
			local rx, ry, rz = 0, 0, 0

			if element then
				if getElementModel(element) == wallModellID["base"] then
					rx, ry, rz = getElementRotation(element)

					if rz == 0 or rz == 180 then
						coord = math.floor((py-grid[2])/floorBaseSize*2)+1.5
					else
						coord = math.floor((px-grid[1])/floorBaseSize*2)+1.5
					end
				end
			end

			if element ~= windowHover or coord ~= windowHoverRotation then
				--outputDebugString("windowhoverchange")
				unuseWindowHover()

				if element then
					if getElementModel(element) == wallModellID["base"] then
						----outputDebugString("addbase")
						local tx, ty = unpack(baseWallCoordinates[element])

						----outputDebugString(py)

						if rz == 0 or rz == 180 then
							tx = tx*2+1
							ty = coord
						else
							tx = coord
							ty = ty*2+1
						end
						windowHoverBaseModel = {tx, ty, rz}

						if not windowOnCoordiante[tx .. "," .. ty] then
							createWindow(tx, ty, rz, currentPlacingTexture)
							--setElementModel(element, wallModellID["window"])
							--applyTextureToElement(element, "la_carp4", "window", "normal", tonumber(currentPlacingTexture))

							windowHover = element
						else
							windowHoverTexture = pathOnElements[windowOnCoordiante[tx .. "," .. ty]]["la_carp4"]
							applyTextureToElement(windowOnCoordiante[tx .. "," .. ty], "la_carp4", "window", "normal", tonumber(currentPlacingTexture))
						end
					end
				end

				windowHover = element
				windowHoverRotation = coord
			end
		elseif mode == "deleteDoor" then
			local x, y = cx, cy
			local x, y, z = getWorldFromScreenPosition(x, y, 1000)

			--dxDrawLine3D(cam[4], cam[5], cam[6], x, y, z)

			local hit, px, py, pz, element = processLineOfSight(cam[4], cam[5], cam[6], x, y, z, false, false, false, true, false)

			local base = false

			if element ~= windowHover or base ~= windowHoverBaseModel then
				if element ~= windowHover then
					unuseDoorHover()

					if element then
						if getElementModel(element) == wallModellID["door2"] then
							local tx, ty = unpack(wallCoordiantes[element])
							----outputDebugString(tostring(tx))

							local el = doors[tx..","..ty]

							local text = 0

							local model2 = getElementModel(el)

							if pathOnElements[el] and pathOnElements[el][doorTextures[model2]] then
								local dat = split(pathOnElements[el][doorTextures[model2]], ",")
								text = dat[3]
							end

							doorDefaultState = {tx, ty, getElementModel(el), doorRots[el], text}

							deleteDoor(el)
							destroyElement(el)
							
							doorRots[el] = nil
							doors[tx..","..ty] = nil

							windowHoverTexture = ""

							--createDoor(tx, ty, model, base, texture)
							for k=3,6 do
								local text = "n,n,n"

								if pathOnElements[element] and pathOnElements[element]["la_carp"..k] then
									text = pathOnElements[element]["la_carp"..k]
								end

								windowHoverTexture = windowHoverTexture .. text..","
								removeTextureFromElement(element, "la_carp" .. k)
							end

							setElementModel(element, wallModellID["straight"])


							--setElementModel(element, wallModellID["door2"])

							--applyTextureToElement(element, "la_carp4", "window", "normal", tonumber(currentPlacingTexture))
						end
					end

					windowHover = element
				end
			end
		elseif mode == "setDoor" then
			local x, y = cx, cy
			local x, y, z = getWorldFromScreenPosition(x, y, 1000)

			--dxDrawLine3D(cam[4], cam[5], cam[6], x, y, z)

			local hit, px, py, pz, element = processLineOfSight(cam[4], cam[5], cam[6], x, y, z, false, false, false, true, false)

			local base = false

			if element then
				if getElementModel(element) == wallModellID["straight"] or getElementModel(element) == wallModellID["door2"] then
					local rx, ry, rz = getElementRotation(element)
					local ox, oy = getElementPosition(element)
					local rot = math.atan2(py-oy, px-ox)-math.rad(rz)

					----outputDebugString(rot)

					if rot < -math.pi then
						rot = -rot
					end

					if rot > 0 then
						base = 90
					else
						base = -90
					end
				elseif getElementModel(element) == wallModellID["base"] then
					local ox, oy = getElementPosition(element)
					local rx, ry, rz = getElementRotation(element)
					local rot = math.atan2(py-oy, px-ox)

					if rz == 0 then
						if rot < 0 then
							base = -90
						else
							base = 90
						end
					elseif rz == 180 then
						if rot < 0 then
							base = 90
						else
							base = -90
						end
					elseif rz == 90 then
						if rot < -2 then
							base = 90
						else
							base = -90
						end
					elseif rz == 270 then
						if rot < 1 then
							base = 90
						else
							base = -90
						end
					end					
				end
			end

			if element ~= windowHover or base ~= windowHoverBaseModel then
				local dat = split(currentPlacingTexture, "/")
				local texture = dat[2]
				local model = doorModels[tonumber(dat[1])]

				if element ~= windowHover then
					unuseDoorHover(element)
				elseif getElementModel(element) == wallModellID["door2"] and not baseWallCoordinates[element] then
					local tx, ty = unpack(wallCoordiantes[element])

					if doors[tx..","..ty] then
						doorRots[doors[tx..","..ty]] = nil
						deleteDoor(doors[tx..","..ty])
						destroyElement(doors[tx..","..ty])
						doors[tx..","..ty] = nil
					end
					
					createDoor(tx, ty, model, base, texture)
				end

				if base ~= windowHoverBaseModel then
					windowHoverBaseModel = base

					if baseWallCoordinates[element] then
						local rx, ry, rz = getElementRotation(element)

						if not windowHoverTexture then
							local text = {}

							if pathOnElements[element] then
								if pathOnElements[element]["la_carp3"] then
									text[3] = pathOnElements[element]["la_carp3"]
								end

								if pathOnElements[element]["la_carp5"] then
									text[5] = pathOnElements[element]["la_carp5"]
								end
							end

							--outputDebugString("Text: " .. tostring(text[3]) .. ", " .. tostring(text[5]))
							windowHoverTexture = {rz, text, baseDoor}

							----outputDebugString("recreate windowHoverTexture")
						end

						local data = {
							false,
							element,
							texture,
							base,
							model,
							windowHoverTexture[1],
							false, 
						}

						--outputDebugString("base: " .. base)

						createBaseDoor(data)
					end
				end

				if element ~= windowHover then
					if element then
						if baseWallCoordinates[element] then
							if not windowHoverTexture then
								local text = {}

								if pathOnElements[element] then
									if pathOnElements[element]["la_carp3"] then
										text[3] = pathOnElements[element]["la_carp3"]
									end

									if pathOnElements[element]["la_carp5"] then
										text[5] = pathOnElements[element]["la_carp5"]
									end
								end

								--outputDebugString("Text: " .. tostring(text[3]) .. ", " .. tostring(text[5]))
								windowHoverTexture = {rz, text, baseDoor}
							end

							local rx, ry, rz = getElementRotation(element)

							local data = {
								false,
								element,
								texture,
								base,
								model,
								rz,
								false,
							}

							--outputDebugString("base: " .. base)

							createBaseDoor(data)
						else
							if getElementModel(element) == wallModellID["straight"] then
								----outputDebugString("addwindow")
								
								windowHoverTexture = ""

								for k=3,6 do
									local text = "n,n,n"

									if pathOnElements[element] and pathOnElements[element]["la_carp"..k] then
										text = pathOnElements[element]["la_carp"..k]
									end

									windowHoverTexture = windowHoverTexture .. text..","
									removeTextureFromElement(element, "la_carp" .. k)
								end
								
								----outputDebugString(windowHoverTexture)
								--outputDebugString("base: " .. base)

								local tx, ty = unpack(wallCoordiantes[element])

								createDoor(tx, ty, model, base, texture)

								setElementModel(element, wallModellID["door2"])

								--applyTextureToElement(element, "la_carp4", "window", "normal", tonumber(currentPlacingTexture))
							elseif getElementModel(element) == wallModellID["door2"] then
								local tx, ty = unpack(wallCoordiantes[element])
								----outputDebugString(tostring(tx))

								local el = doors[tx..","..ty]

								local text = 0

								local model2 = getElementModel(el)

								if pathOnElements[el] and pathOnElements[el][doorTextures[model2]] then
									local dat = split(pathOnElements[el][doorTextures[model2]], ",")
									text = dat[3]
								end

								doorDefaultState = {tx, ty, getElementModel(el), doorRots[el], text}

								deleteDoor(el)
								destroyElement(el)
								
								doorRots[el] = nil

								createDoor(tx, ty, model, base, texture)


								--setElementModel(element, wallModellID["door2"])

								--applyTextureToElement(element, "la_carp4", "window", "normal", tonumber(currentPlacingTexture))
							end
						end
					end

					windowHover = element
				end
			end
		elseif mode == "placeFurniture" then
			local x, y = cx, cy
			local x, y, z = getWorldFromScreenPosition(x, y, 1000)

			--dxDrawLine3D(cam[4], cam[5], cam[6], x, y, z)

			local hit, px, py, pz, element = processLineOfSight(cam[4], cam[5], cam[6], x, y, z, false, false, false, true, false)

			if hit and floorCoordinates[element] then
				local offsets = modelOffsets[getElementModel(placingFurniture)]
				--if offsets then
				--	px = px - offsets[1]
				--	py = py - offsets[2]
				--end

				if offsets then
					local x2, y2 = rotateAround(math.rad(lastRot), 0, 0, offsets[1], offsets[2])

					px = px - x2
					py = py - y2
				end

				if snapping then
					px = math.floor(px*snapping)/snapping
					py = math.floor(py*snapping)/snapping
				end

				setElementPosition(placingFurniture, px, py, grid[3]+getElementDistanceFromCentreOfMassToBaseOfModel(placingFurniture)+thickness/2)
				canPlaceFurniture = true
			else
				setElementPosition(placingFurniture, 0, 0, 0)
				canPlaceFurniture = false
			end
		elseif mode == "setFloor" then
			local x, y = cx, cy
			local x, y, z = getWorldFromScreenPosition(x, y, 1000)

			--dxDrawLine3D(cam[4], cam[5], cam[6], x, y, z)

			local hit, px, py, pz, element = processLineOfSight(cam[4], cam[5], cam[6], x, y, z, false, false, false, true, false)

			paintHover = false

			if hit and floorCoordinates[element] then
				paintHover = {element, px, py}

				if tileX and not startTileX then
					activeTile[tileX..","..tileY..","..tileFace] = false
				end

				local ox, oy = getElementPosition(element)
				local rot = math.atan2(py-oy, px-ox)

				if rot > -1.5 and rot <= 0 then
					tileFace = 4
				elseif rot > 0 and rot <= 1.5 then
					tileFace = 5
				elseif rot > 1.5 and rot <= 3 then
					tileFace = 6
				else
					tileFace = 3
				end

				tileX, tileY = floorCoordinates[element][1], floorCoordinates[element][2]

				if not startTileX then
					activeTile[tileX..","..tileY..","..tileFace] = true
				end
			end
		elseif mode == "setCeil" then
			local x, y = cx, cy
			local x, y, z = getWorldFromScreenPosition(x, y, 1000)

			--dxDrawLine3D(cam[4], cam[5], cam[6], x, y, z)

			local hit, px, py, pz, element = processLineOfSight(cam[4], cam[5], cam[6], x, y, z, false, false, false, true, false)

			paintHover = false

			if hit and ceilCoordinates[element] then
				paintHover = {element, px, py}

				if tileX and not startTileX then
					activeTile[tileX..","..tileY..","..tileFace] = false
				end

				local ox, oy = getElementPosition(element)
				local rot = math.atan2(py-oy, px-ox)

				if rot > -1.5 and rot <= 0 then
					tileFace = 4
				elseif rot > 0 and rot <= 1.5 then
					tileFace = 5
				elseif rot > 1.5 and rot <= 3 then
					tileFace = 6
				else
					tileFace = 3
				end

				tileX, tileY = ceilCoordinates[element][1], ceilCoordinates[element][2]

				if not startTileX then
					activeTile[tileX..","..tileY..","..tileFace] = true
				end
			end
		elseif mode == "drawWall_line" or mode == "drawWall_rect" or mode == "deleteWall_line" or mode == "deleteWall_rect" then
			local x, y = cx, cy
			local x, y, z = getWorldFromScreenPosition(x, y, 1000)

			--dxDrawLine3D(cam[4], cam[5], cam[6], x, y, z)

			local hit, px, py, pz, element = processLineOfSight(cam[4], cam[5], cam[6], x, y, z, false, false, false, true, false)

			if hit and element and floorCoordinates[element] then
				----outputDebugString(floorCoordinates[element][1] .. ", " .. floorCoordinates[element][2])
				----outputDebugString("hit")
				--destroyElement(element)

				--if (mode == "drawWall_line" or mode == "deleteWall_line") and tileFace and startTileFace and startTileX and tileX then
				--	local tx = coordToTile2(tileX, tileFace)
				--	local stx = coordToTile2(startTileX, startTileFace)
				--	local ty = coordToTile2(tileY, tileFace)
				--	local sty = coordToTile2(startTileY, startTileFace)
--
				--	if  (tx == stx and ty == sty) or
				--		(tx == stx and lineAxis == "x") or
				--		(ty == sty and lineAxis == "y")
				--	 then
				--		--lineAxis = false
				--		--activeTile = {}
				--	end
--
				--	if not lineAxis then
				--		if stx then
				--			if tx ~= stx then
				--				lineAxis = "x"
				--				startCoord = floorCoordinates[element][2]
				--			elseif ty ~= sty then
				--				lineAxis = "y"
				--				startCoord = floorCoordinates[element][1]
				--			end
--
				--			----outputDebugString(lineAxis)
				--		end
				--	end
				--end

				if startTileX then
					if mode == "drawWall_line" or mode == "deleteWall_line" then
						local ox, oy = getElementPosition(element)
						local rot = math.atan2(py-oy, px-ox)+math.rad(45)

						if rot > math.pi*2 then
							rot = rot-math.pi*2
						end

						if rot > -1.5 and rot <= 0 then
							if lineAxis == "y" or not lineAxis then
								tileFace = 2
							end
						elseif rot > 0 and rot <= 1.5 then
							if lineAxis == "x" or not lineAxis then
								tileFace = 3
							end
						elseif rot > 1.5 and rot <= 3 then
							if lineAxis == "y" or not lineAxis then
								tileFace = 4
							end
						else
							if lineAxis == "x" or not lineAxis then
								tileFace = 1
							end
						end

						----outputDebugString("StarttileFaceE: " .. startTileFace)
						----outputDebugString("tileFaceE: " .. tileFace)

						tileX, tileY = floorCoordinates[element][1], floorCoordinates[element][2]
						--activeTile[tileX..","..tileY..","..tileFace] = true
					else
						tileX, tileY = floorCoordinates[element][1], floorCoordinates[element][2]
						activeTile[startTileX..","..startTileY] = true
					end
				else
					if mode == "drawWall_line" or mode == "deleteWall_line" then
						if tileX then
							activeTile[tileX..","..tileY..","..tileFace] = false
						end

						tileX, tileY = floorCoordinates[element][1], floorCoordinates[element][2]

						local ox, oy = getElementPosition(element)
						local rot = math.atan2(py-oy, px-ox)+math.rad(45)

						if rot > math.pi*2 then
							rot = rot-math.pi*2
						end

						if rot > -1.5 and rot <= 0 then
							if lineAxis == "y" or not lineAxis then
								tileFace = 2
							end
						elseif rot > 0 and rot <= 1.5 then
							if lineAxis == "x" or not lineAxis then
								tileFace = 3
							end
						elseif rot > 1.5 and rot <= 3 then
							if lineAxis == "y" or not lineAxis then
								tileFace = 4
							end
						else
							if lineAxis == "x" or not lineAxis then
								tileFace = 1
							end
						end

						----outputDebugString("tileFace: " .. tileFace)

						activeTile[tileX..","..tileY..","..tileFace] = true
					else
						if tileX then
							for f=1,4 do
								activeTile[tileX..","..tileY..","..f] = false
							end
						end
						
						tileX, tileY = floorCoordinates[element][1], floorCoordinates[element][2]
						
						for f=1,4 do
							activeTile[tileX..","..tileY..","..f] = true
						end
					end
				end
			else
				----outputDebugString("nohit")
				activeTile = {}

				tileX, tileY = false, false
			end
		end

		for x=-10, grid[4]+10 do
			for y=-10, grid[5]+10 do
				if x >= 1 and x <= grid[4] and y >= 1 and y <= grid[5] then
					if mode == "setFloor" or mode == "setCeil" or activeFurniture or mode == "placeFurniture" then
						local color = tocolor(255, 255, 255, 125) -- r, g, b
						local mult = 1

						if (activeTile[x..","..y..","..3]) or (activeTile[x..","..(y-1)..","..6]) then --5
							color = activeColor --89, 142, 215
							mult = 1.5
						end

						dxDrawLine3D(grid[1]+(x-1)*floorBaseSize, grid[2]+(y-1)*floorBaseSize, grid[3]+lineDraw, grid[1]+(x-0.5)*floorBaseSize, grid[2]+(y-1)*floorBaseSize, grid[3]+lineDraw, color, lineThickness*mult)
						
						local color = tocolor(255, 255, 255, 125) -- r, g, b
						local mult = 1

						if (activeTile[x..","..(y-1)..","..5]) or (activeTile[x..","..y..","..4]) then
							color = activeColor --89, 142, 215
							mult = 1.5
						end

						dxDrawLine3D(grid[1]+(x-0.5)*floorBaseSize, grid[2]+(y-1)*floorBaseSize, grid[3]+lineDraw, grid[1]+x*floorBaseSize, grid[2]+(y-1)*floorBaseSize, grid[3]+lineDraw, color, lineThickness*mult)

						local color = tocolor(255, 255, 255, 125) -- r, g, b
						local mult = 1

						if (activeTile[x..","..y..","..3]) or (activeTile[(x-1)..","..y..","..4]) then --5
							color = activeColor --89, 142, 215
							mult = 1.5
						end
						
						dxDrawLine3D(grid[1]+(x-1)*floorBaseSize, grid[2]+(y-1)*floorBaseSize, grid[3]+lineDraw, grid[1]+(x-1)*floorBaseSize, grid[2]+(y-0.5)*floorBaseSize, grid[3]+lineDraw, color, lineThickness*mult)

						local color = tocolor(255, 255, 255, 125) -- r, g, b
						local mult = 1

						if (activeTile[(x-1)..","..y..","..5]) or (activeTile[x..","..y..","..6]) then
							color = activeColor --89, 142, 215
							mult = 1.5
						end
						
						dxDrawLine3D(grid[1]+(x-1)*floorBaseSize, grid[2]+(y-0.5)*floorBaseSize, grid[3]+lineDraw, grid[1]+(x-1)*floorBaseSize, grid[2]+y*floorBaseSize, grid[3]+lineDraw, color, lineThickness*mult)

						local color = tocolor(255, 255, 255, 125) -- r, g, b
						local mult = 1

						if (activeTile[x..","..y..","..3]) or (activeTile[x..","..y..","..6]) then --5
							color = activeColor --89, 142, 215
							mult = 1.5
						end

						dxDrawLine3D(grid[1]+(x-1)*floorBaseSize, grid[2]+(y-0.5)*floorBaseSize, grid[3]+lineDraw, grid[1]+(x-0.5)*floorBaseSize, grid[2]+(y-0.5)*floorBaseSize, grid[3]+lineDraw, color, lineThickness*mult)
						
						local color = tocolor(255, 255, 255, 125) -- r, g, b
						local mult = 1

						if (activeTile[x..","..y..","..5]) or (activeTile[x..","..y..","..4]) then --3
							color = activeColor --89, 142, 215
							mult = 1.5
						end

						dxDrawLine3D(grid[1]+(x-0.5)*floorBaseSize, grid[2]+(y-0.5)*floorBaseSize, grid[3]+lineDraw, grid[1]+x*floorBaseSize, grid[2]+(y-0.5)*floorBaseSize, grid[3]+lineDraw, color, lineThickness*mult)
						
						local color = tocolor(255, 255, 255, 125) -- r, g, b
						local mult = 1

						if (activeTile[x..","..y..","..3]) or (activeTile[x..","..y..","..4]) then --5
							color = activeColor --89, 142, 215
							mult = 1.5
						end

						dxDrawLine3D(grid[1]+(x-0.5)*floorBaseSize, grid[2]+(y-1)*floorBaseSize, grid[3]+lineDraw, grid[1]+(x-0.5)*floorBaseSize, grid[2]+(y-0.5)*floorBaseSize, grid[3]+lineDraw, color, lineThickness*mult)local color = tocolor(255, 255, 255, 125) -- r, g, b
						
						local mult = 1

						if (activeTile[x..","..y..","..5]) or (activeTile[x..","..y..","..6]) then --3
							color = activeColor --89, 142, 215
							mult = 1.5
						end

						dxDrawLine3D(grid[1]+(x-0.5)*floorBaseSize, grid[2]+(y-0.5)*floorBaseSize, grid[3]+lineDraw, grid[1]+(x-0.5)*floorBaseSize, grid[2]+y*floorBaseSize, grid[3]+lineDraw, color, lineThickness*mult)
					elseif gridState then
						local color = tocolor(255, 255, 255, 125) -- r, g, b
						local mult = 1

						if (activeTile[x..","..y..","..1]) then-- or (activeTile[(x-1)..","..y]) then
							color = activeColor --89, 142, 215
							mult = 1.5
						end

						dxDrawLine3D(grid[1]+(x-1)*floorBaseSize, grid[2]+(y-0.5)*floorBaseSize, grid[3]+lineDraw, grid[1]+(x-0.5)*floorBaseSize, grid[2]+(y-0.5)*floorBaseSize, grid[3]+lineDraw, color, lineThickness*mult)

						local color = tocolor(255, 255, 255, 125) -- r, g, b
						local mult = 1

						if (activeTile[x..","..y..","..2]) then-- or (activeTile[(x-1)..","..y]) then
							color = activeColor --89, 142, 215
							mult = 1.5
						end

						dxDrawLine3D(grid[1]+(x-0.5)*floorBaseSize, grid[2]+(y-1)*floorBaseSize, grid[3]+lineDraw, grid[1]+(x-0.5)*floorBaseSize, grid[2]+(y-0.5)*floorBaseSize, grid[3]+lineDraw, color, lineThickness*mult)

						local color = tocolor(255, 255, 255, 125) -- r, g, b
						local mult = 1

						if (activeTile[x..","..y..","..3]) then-- or (activeTile[(x-1)..","..y]) then
							color = activeColor --89, 142, 215
							mult = 1.5
						end

						dxDrawLine3D(grid[1]+(x-0.5)*floorBaseSize, grid[2]+(y-0.5)*floorBaseSize, grid[3]+lineDraw, grid[1]+x*floorBaseSize, grid[2]+(y-0.5)*floorBaseSize, grid[3]+lineDraw, color, lineThickness*mult)

						local color = tocolor(255, 255, 255, 125) -- r, g, b
						local mult = 1

						if (activeTile[x..","..y..","..4]) then-- or (activeTile[(x-1)..","..y]) then
							color = activeColor --89, 142, 215
							mult = 1.5
						end

						dxDrawLine3D(grid[1]+(x-0.5)*floorBaseSize, grid[2]+(y-0.5)*floorBaseSize, grid[3]+lineDraw, grid[1]+(x-0.5)*floorBaseSize, grid[2]+y*floorBaseSize, grid[3]+lineDraw, color, lineThickness*mult)
					end
				else
					if gridState then
						dxDrawLine3D(grid[1]+(x-1)*floorBaseSize, grid[2]+(y-1)*floorBaseSize, grid[3]+lineDraw2, grid[1]+x*floorBaseSize, grid[2]+(y-1)*floorBaseSize, grid[3]+lineDraw2, tocolor(255, 255, 255, 175), lineThickness)
						dxDrawLine3D(grid[1]+(x-1)*floorBaseSize, grid[2]+(y-1)*floorBaseSize, grid[3]+lineDraw2, grid[1]+(x-1)*floorBaseSize, grid[2]+y*floorBaseSize, grid[3]+lineDraw2, tocolor(255, 255, 255, 175), lineThickness)
					end
				end
			end
		end

		if gridState then
			dxDrawLine3D(grid[1]+(-11)*floorBaseSize, grid[2]+(grid[5]+10)*floorBaseSize, grid[3]+lineDraw2, grid[1]+(grid[4]+10)*floorBaseSize, grid[2]+(grid[5]+10)*floorBaseSize, grid[3]+lineDraw2, tocolor(255, 255, 255, 175), lineThickness)
			dxDrawLine3D(grid[1]+(grid[4]+10)*floorBaseSize, grid[2]+(-11)*floorBaseSize, grid[3]+lineDraw2, grid[1]+(grid[4]+10)*floorBaseSize, grid[2]+(grid[5]+10)*floorBaseSize, grid[3]+lineDraw2, tocolor(255, 255, 255, 175), lineThickness)
		end

		drawGUI()

	end

	if activeButton ~= lastActiveButton then
		if activeButton then
			--playSoundEx("sounds/highlight.mp3")
		end
	end
end	

function onClientElementDataChange(data)
	if data == "char:money" then
		currentBalance = thousandsStepper(getElementData(localPlayer, "char:money") or 0)
	elseif data == "user:aduty" then
		checkOwnership()
	end
end

function unloadInterior()
	triggerServerEvent("intiEdit:exitInterior2", localPlayer)
	setMode("looking")

	removeEventHandler("onClientRender", getRootElement(), checkForUnload)
	--outputDebugString("unloading")

	if editMode then
		removeEventHandler("onClientCursorMove", getRootElement(), onClientCursorMove, true, "low-999999")
		removeEventHandler("onClientClick", getRootElement(), onClientClick)
		removeEventHandler("onClientKey", getRootElement(), onClientKey, true, "high+999999")
		removeEventHandler("onClientRender", getRootElement(), onClientRender)
		global.checkForObjectPreviewsUnload()
		removeEventHandler("onClientElementDataChange", localPlayer, onClientElementDataChange)
		removeEventHandler("onClientPreRender", getRootElement(), onClientPreRender)

		showCursor(false)
	else
		removeEventHandler("onClientColShapeHit", getRootElement(), onClientColShapeHit)
		removeEventHandler("onClientClick", getRootElement(), onClientClickNoEdit)
		removeEventHandler("onClientKey", getRootElement(), onClientKeyNoEdit)
		removeEventHandler("onClientPlayerWeaponFire", getRootElement(), onClientPlayerWeaponFire)
		removeEventHandler("onClientElementDataChange", localPlayer, onClientElementDataChange)
		removeEventHandler("onClientColShapeLeave", getRootElement(), onClientColShapeLeave)
	end

	for k, v in pairs(shaderForTexture) do
		destroyElement(v)
	end

	for k=1, #baseWalls do
		destroyElement(baseWalls[k])
	end

	for k=1, #baseCeils do
		destroyElement(baseCeils[k])
	end

	for k=1, #baseFloors do
		destroyElement(baseFloors[k])
	end

	for k=1, #walls do
		destroyElement(walls[k])
	end

	for k, v in pairs(windowCoordiantes) do
		destroyElement(k)
	end

	for k, v in pairs(furnitures) do
		destroyElement(k)
	end

	for k, v in pairs(doors) do
		destroyElement(v)
	end

	for k, v in pairs(doorColShapes) do
		destroyElement(v)
	end

	destroyElement(baseDoor[1])

	baseDoor = false

	destroyElement(baseDoorCol)

	baseDoorCol = false
	currentDoor = false
	doorLocked = false
	editingInteriorID = false
	walls = {}
	floor = {}
	ceil = {}
	currentPlacingTexture = false
	x, y = false, false
	placingFurniture = false
	placingPrompt = false
	activeFurniture = false
	canPlaceFurniture = false
	furnitures = {}
	doorColShapes = {}
	doorColShapeIndex = {}
	doors = {}
	doorRots = {}
	doorIndexes = {}
	wasGrid = false
	canGrid = true
	floorOnCoordinates = {}
	floorCoordinates = {}
	baseFloors = {}
	resetVars2()


	editingInteriorID = false
	editMode = false


	--triggerServerEvent("requestWeather", localPlayer)

	resetSkyGradient()
end


local tvBrowsers = {}
local tvShaders = {}
local tvElements = {}
local tvMovies = {}

local lastSwitch = 0
local selectedTV = false
local tvScroll = 0




function resetVars2()
	tvElements = {}

	snapping = false
	snappingR = 10
	infoState = true

	lastRot = 0
	ceilOnCoordinates = {}
	ceilCoordinates = {}
	baseCeils = {}
	baseWalls = {}
	lightState = false
	baseDoor = false
	currentBaseDoor = false
	windows = {}
	windowCoordiantes = {}
	windowOnCoordiante = {}
	walls = {}
	wallCoordiantes = {}
	wallOnCoordiante = {}
	testMode = false
	windowHover = false
	windowHoverBaseModel = false
	windowHoverTexture = false
	windowHoverRotation = false
	doorDefaultState = false
	startTileX, startTileY = false, false
	startTileFace = false
	tileX, tileY = false, false
	tileFace = 3
	selectedWall = false
	activeTile = {}
	activeTileY = {}
	doorWalls = {}
	cx, cy = -1, -1
	activeButton = false
	day = false
	gridState = true
	shaderForTexture = {}
	shadersOnElements = {}
	pathOnElements = {}
	useNums = {}
	cashCosts = 0
	cashCostsFormatted = "0"
	lastCursor = {}

	lastSwitch = 0
	tvScroll = 0

	selectedTV = false

	destroyElement(bcgMusicElement)
	bcgMusicElement = false

	--for k in pairs(tvBrowsers) do
	--	destroyElement(tvBrowsers[k])
	--end
--
	--for k in pairs(tvShaders) do
	--	destroyElement(tvShaders[k])
	--end
--
	--tvBrowsers = {}
	--tvShaders = {}
end

function setCurrentBaseDoor()
	--outputDebugString("setCurrentBaseDoor")

	currentBaseDoor = baseDoor

	local px, py, pz = getElementPosition(baseDoor[2])
	local rx, ry, rz = getElementRotation(baseDoor[2])

	local x, y = rotateAround(math.rad(rz), 0, 0, -floorBaseSize/2, 0)

	x, y = px+x, py+y
	x2, y2 = px+x, py+y

	local tx2, ty2 = math.floor(x2*10)/10, math.floor(y2*10)/10
	local tx, ty = math.floor(x*10)/10, math.floor(y*10)/10

	if tx2 ~= tx or ty2 ~= ty then
		--outputDebugString("refreshInteriorExit")

		if not editMode then
			setElementPosition(localPlayer, x, y, pz-0.75)

			local idnow = getElementData(localPlayer, "currentCustomInterior")

			for k, v in ipairs(getElementsByType("marker")) do 
				if getElementData(v, "dbid") == idnow then 
					if getElementData(v, "isIntOutMarker") then 
						setElementData(v, "x", x)
						setElementData(v, "y", y)
						setElementData(v, "z", pz - 0.75)
						setElementPosition(v, x, y, pz - 2.2)
						break
					end
				end
			end
		end
	end
end


registerEvent("intiEdit:gotPPThings", getRootElement(),
	function (dat)
		boughtFromPP = dat
	end)

function playSoundEx(url)
	--if soundsEnabled then
		playSound(url)
	--end
end

function isUseableTV(el)
	return useableTvs[getElementModel(el)] and getElementData(el, "tvFurniture")
end

addEventHandler("onClientElementStreamIn", getResourceRootElement(),
	function ()
		if isUseableTV(source) then
			table.insert(tvElements, source)

			--outputDebugString("tv els: " .. #tvElements)

			triggerServerEvent("intiEdit:requestTV", source)
		end
	end)

function tvStreamOut()
	if isUseableTV(source) then
		for k=1, #tvElements do
			if tvElements[k] == source then
				table.remove(tvElements, k)
				break
			end
		end

		destroyElement(tvBrowsers[source])
		tvBrowsers[source] = nil

		destroyElement(tvShaders[source])
		tvShaders[source] = nil
		
		tvMovies[source] = nil


		--outputDebugString("tv els: " .. #tvElements)
	end
end
addEventHandler("onClientElementDestroy", getResourceRootElement(), tvStreamOut)
addEventHandler("onClientElementStreamOut", getResourceRootElement(), tvStreamOut)

function onClientPlayerWeaponFire(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement, sx, sy, sz)
	if hitElement then
		if doorIndexes[hitElement] then
			if doorLocked[doorIndexes[hitElement]] ~= "damaged" then
				doorLocked[doorIndexes[hitElement]] = "damaged"
				saveDynamicData()
			end
		elseif wallCoordiantes[hitElement] and getElementModel(hitElement) == wallModellID["door2"] then
			local c = table.concat(wallCoordiantes[hitElement], ",")
			
			setElementCollisionsEnabled(doors[c], true)

			local hitX = (hitX-sx)*2+sx
			local hitY = (hitY-sy)*2+sy
			local hitZ = (hitZ-sz)*2+sz

			local hit, x, y, z, he = processLineOfSight(sx, sy, sz, hitX, hitY, hitZ, false, false, false, true, false, false, false, false, hitElement)

			if hit and he == doors[c] then
				doorLocked[c] = "damaged"
				setElementModel(hitElement, wallModellID["door"])
				saveDynamicData()
			else
				setElementCollisionsEnabled(doors[c], false)
			end
		end
	end
end

function updateDynamicData(dynamicData, load)
	if source ~= localPlayer or load then
		local dat = split(dynamicData, ";")

		if dat[1] then
			if dat[1] == "on" then
				lightState = true
			else
				lightState = false
			end

			setDaytime(lightState)
		end

		if not doorLocked then
			doorLocked = {}
		end

		for k, v in pairs(doorLocked) do
			if v ~= "inservice" then
				doorLocked[k] = nil
			end
		end

		if not editMode then
			for k, v in pairs(doors) do
				setElementCollisionsEnabled(v, true)
				setElementModel(wallOnCoordiante[k], wallModellID["door"])
			end
		end

		if dat[2] then
			local locked = split(dat[2], "|")

			for k2=1, #locked do
				if locked[k2] ~= "-" then
					local k = locked[k2]

					if utf8.sub(k, 1, 1) == "d" then
						k = utf8.sub(k, 2)

						doorLocked[k] = "damaged"
					else
						local v = doors[k]

						if v then
							doorLocked[k] = true

							if not editMode then
								local rx, ry, rz = getElementRotation(wallOnCoordiante[k])

								setElementRotation(v, 0, 0, doorRots[v]+rz)
								setElementCollisionsEnabled(v, false)
								setElementModel(wallOnCoordiante[k], wallModellID["door2"])
							end
						end
					end
				end
			end 
		end
	end
end
registerEvent("intiEdit:updateDynamicData", getRootElement(), updateDynamicData)

function saveDynamicData()
	local data = ""

	if lightState then
		data = "on;"
	else
		data = "off;"
	end

	for k, v in pairs(doorLocked) do
		if v then
			if v == "damaged" then
				data = data .. "d" .. k .. "|"
			else
				data = data .. k .. "|"
			end
		end
	end

	data = data .. "-"

	triggerServerEvent("intiEdit:updateDynamicData", localPlayer, editingInteriorID, data, getElementsByType("player", getRootElement(), true))
end

addEventHandler("onClientResourceStop", resourceRoot, function()
	interiorId = tonumber(getElementData(localPlayer, "currentCustomInterior"))
	
	if interiorId and interiorId > 0 then

		setElementFrozen(localPlayer, true)
		--triggerServerEvent("requestWeather", localPlayer)
	end
end)


addEventHandler("onClientResourceStart", resourceRoot, function()
	interiorId = tonumber(getElementData(localPlayer, "currentCustomInterior"))

	if interiorId and interiorId > 0 then

		local size = 0
		for k, v in ipairs(getElementsByType("marker")) do 
			if getElementData(v, "isIntMarker") then 
				if getElementData(v, "dbid") == interiorId then 
					size = getElementData(v, "custom")
					break
				end
			end
		end

		setTimer(function()
			triggerServerEvent("intiEdit:loadInterior", getRootElement(), localPlayer, interiorId, false, size)
		end, 200, 1)
	end

	setElementData(localPlayer,"currentCustomInterior",0)
end)

addEventHandler("onClientElementDataChange", root, function(data, old, new)
	if source == localPlayer then 
		if data == "user:loggedin" and new == true then
			interiorId = getElementDimension(localPlayer) 

			if getElementInterior(localPlayer) == 1 and interiorId > 0 then 
				if interiorId and interiorId > 0 then

					local size = 0
					for k, v in ipairs(getElementsByType("marker")) do 
						if getElementData(v, "isIntMarker") then 
							if getElementData(v, "dbid") == interiorId then 
								size = getElementData(v, "custom")
								break
							end
						end
					end
			
					setTimer(function()
						if size > 0 then
							triggerServerEvent("intiEdit:loadInterior", getRootElement(), localPlayer, interiorId, false, size)
						end
					end, 200, 1)
				end
			end
		end
	end
end)

local ownership = false

function checkOwnership()
	if editingInteriorID then
		ownership = false

		local charid = getElementData(localPlayer, "char:id")
		for k, v in ipairs(getElementsByType("marker")) do 
			if getElementData(v, "dbid") == editingInteriorID then 
				if getElementData(v, "isIntOutMarker") then 
					if getElementData(v, "owner") == charid then 
						ownership = true 
						break
					end
				end
			end
		end

		--[[if (tonumber(getElementData(localPlayer, "user:admin") or 0) or 0) >= 6 then
			ownership = true
		end]]
	end
end
addEventHandler("movedItemInInv", localPlayer, checkOwnership)


local tvLinks = {
	{"Babysitting - A felvigyázó", "05r8tnR7WSU", "HD"},
	{"Csak egy átlagos suli", "tmI7jGVIp90", "HD"},
	{"Átnevelőtábor", "-aqBH977keQ", "SD"},
	{"Brazilok", "V07GQMKwh14", "SD"},
	{"Cserebere szerencse", "-5zPy0HcvD0", "SD"},
	{"Haláli Iramban", "28O7WFq_ids", "SD"},
	{"Halálos sebesség", "OstcimxqfXg", "SD"},
	{"Pókerpárbaj", "_H10Cn1cawI", "SD"},
	{"Sétáló agyhalottak", "CHGywcA--Wc", "SD"},
	{"Superhero - A film", "QlhoR8pdq4Y", "SD"},
	{"Taxi 1", "BNpPBoZQ2iY", "SD"},
	{"Vadócka", "7pJghU8IEYM", "SD"},
	{"Kegyenc fegyenc", "lzCR4gIu4As", "SD"},
	{"Szemfényvesztők", "kk8wXfVnjRU", "SD"},
	{"Kém a szomszédban", "h1bQHGwXVzc", "HD"},
	{"A börtön", "lY2E0dRcLto", "HD"},
	{"Csempészek", "JU5laliUrw0", "HD"},
	{"A halhatatlan viking", "MpisscPqGGM", "HD"},
}

local tableAccents = {}
tableAccents["à"] = "a"
tableAccents["á"] = "a"
tableAccents["â"] = "a"
tableAccents["ã"] = "a"
tableAccents["ä"] = "a"
tableAccents["ç"] = "c"
tableAccents["è"] = "e"
tableAccents["é"] = "e"
tableAccents["ê"] = "e"
tableAccents["ë"] = "e"
tableAccents["ì"] = "i"
tableAccents["í"] = "i"
tableAccents["î"] = "i"
tableAccents["ï"] = "i"
tableAccents["ñ"] = "n"
tableAccents["ò"] = "o"
tableAccents["ó"] = "o"
tableAccents["ô"] = "o"
tableAccents["õ"] = "o"
tableAccents["ö"] = "o"
tableAccents["ù"] = "u"
tableAccents["ú"] = "u"
tableAccents["û"] = "u"
tableAccents["ü"] = "u"
tableAccents["ý"] = "y"
tableAccents["ÿ"] = "y"
tableAccents["À"] = "A"
tableAccents["Á"] = "A"
tableAccents["Â"] = "A"
tableAccents["Ã"] = "A"
tableAccents["Ä"] = "A"
tableAccents["Ç"] = "C"
tableAccents["È"] = "E"
tableAccents["É"] = "E"
tableAccents["Ê"] = "E"
tableAccents["Ë"] = "E"
tableAccents["Ì"] = "I"
tableAccents["Í"] = "I"
tableAccents["Î"] = "I"
tableAccents["Ï"] = "I"
tableAccents["Ñ"] = "N"
tableAccents["Ò"] = "O"
tableAccents["Ó"] = "O"
tableAccents["Ô"] = "O"
tableAccents["Õ"] = "O"
tableAccents["Ö"] = "O"
tableAccents["Ù"] = "U"
tableAccents["Ú"] = "U"
tableAccents["Û"] = "U"
tableAccents["Ü"] = "U"
tableAccents["Ý"] = "Y"

function stripAccents( str )
	local normalizedString = ""

	for strChar in string.gfind(str, "([%z\1-\127\194-\244][\128-\191]*)") do
		if tableAccents[strChar] ~= nil then
			normalizedString = normalizedString..tableAccents[strChar]
		else
			normalizedString = normalizedString..strChar
		end
	end

	return normalizedString
end

function youtubeLinkCompare(a,b)
	local str = stripAccents(a[1])
	local str2 = stripAccents(b[1])

	return str < str2
end

table.sort(tvLinks, youtubeLinkCompare)

function checkForUnload()	

	keepDaytime()

	if getElementDimension(localPlayer) ~= editingInteriorID then
		unloadInterior()
	end

	if not editMode then
		local cx, cy = getCursorPositionEx()
		activeButton = false

		if currentDoor then
			--[[if currentDoor == "base" then
				local x = math.ceil(screenX/2-sideIconSize)
				local y = math.ceil(screenY-sideIconSize*2-sideIconBorder*4)

				dxDrawRectangle(x-sideIconBorder, y-sideIconBorder, sideIconSize+sideIconBorder*2, sideIconSize+sideIconBorder*2, tocolor(0, 0, 0, 125))

				if cx > x and cx < x+sideIconSize and cy > y and cy < y+sideIconSize then 
					activeButton = "switchLight"
					dxDrawImage(x, y, sideIconSize, sideIconSize, "files/icons/" .. (lightState and "light1" or "light0") .. ".png", 0, 0, 0, tocolor(r, g, b))
				else
					dxDrawImage(x, y, sideIconSize, sideIconSize, "files/icons/" .. (lightState and "light1" or "light0") .. ".png")
				end]]
			if not (currentDoor == "base") then
				if ownership then
					local x = math.ceil(screenX/2-sideIconSize)
					local y = math.ceil(screenY-sideIconSize*2-sideIconBorder*4)

					dxDrawRectangle(x-sideIconBorder - 2/myX*sx, y-sideIconBorder - 2/myY*sy, sideIconSize+sideIconBorder*2 + 4/myX*sx, sideIconSize+sideIconBorder*2 + 4/myY*sy, tocolor(30, 30, 30, 125))
					dxDrawRectangle(x-sideIconBorder, y-sideIconBorder, sideIconSize+sideIconBorder*2, sideIconSize+sideIconBorder*2, tocolor(35, 35, 35, 255))

					local icon = (doorLocked[currentDoor] and "lock" or "unlock")

					if doorLocked[currentDoor] == "damaged" then
						icon = "flock"
					end

					if cx > x and cx < x+sideIconSize and cy > y and cy < y+sideIconSize then 
						activeButton = "doorLock"
						dxDrawImage(x, y, sideIconSize, sideIconSize, "files/icons/" .. icon .. ".png", 0, 0, 0, tocolor(r, g, b))
					else
						dxDrawImage(x, y, sideIconSize, sideIconSize, "files/icons/" .. icon .. ".png")
					end
				end
			end
		end

		if selectedTV then
			local width = respc(365)
			local height = respc(350)/10

			core:drawWindow(screenX/2-width/2, screenY/2-(respc(400)/2), width, respc(380) + 2/myY*sy, "Filmek", 1)

			for i=1, 10 do
				local k = i+tvScroll

				dxDrawRectangle(screenX/2-width/2 + 4/myX*sx, screenY/2-(height*10)/2+height*(i-1) + sy*0.0025, width - 28/myX*sx, height, tocolor(40, 40, 40, (k%2==0 and 125 or 175)))

				if tvLinks[k] then
					if tvMovies[selectedTV] == tvLinks[k][2] then
						if core:isInSlot(screenX/2+width/2-respc(96) - 24/myX*sx, screenY/2-(height*10)/2+height*(i-1)+respc(4) + sy*0.0025 , respc(96-8), height-respc(8)) then
							activeButton = "stopMovie"
						end

						core:dxDrawButton(screenX/2+width/2-respc(96) - 24/myX*sx, screenY/2-(height*10)/2+height*(i-1)+respc(4)+ sy*0.0025, respc(96-8), height-respc(8), 235, 61, 61, 200, "Leállítás", tocolor(255, 255, 255), 0.7, dxfont0_roboto, true, tocolor(0, 0, 0, 100))
					else
						if core:isInSlot(screenX/2+width/2-respc(96) - 24/myX*sx, screenY/2-(height*10)/2+height*(i-1)+respc(4)+ sy*0.0025, respc(96-8), height-respc(8)) then
							activeButton = "playMovie:" .. tvLinks[k][2]
						end

						core:dxDrawButton(screenX/2+width/2-respc(96) - 24/myX*sx, screenY/2-(height*10)/2+height*(i-1)+respc(4)+ sy*0.0025, respc(96-8), height-respc(8), r, g, b, 200, "Indítás", tocolor(255, 255, 255), 0.7, dxfont0_roboto, true, tocolor(0, 0, 0, 100))
					end

					dxDrawText(tvLinks[k][1] .. color .. " ["..tvLinks[k][3].."]", screenX/2-width/2+respc(8), screenY/2-(height*10)/2+height*(i-1) + sy*0.0025, 0, screenY/2-(height*10)/2+height*i + sy*0.0025, tocolor(255, 255, 255), 0.8, dxfont0_roboto, "left", "center", false, false, false, true)
				end
			end

			dxDrawRectangle(screenX/2 + width/2 - 15/myX*sx, screenY/2-(height*10)/2 + sy*0.0025, sx*0.002, respc(345), tocolor(r, g, b, 100))

			local lineHeight = math.min(10 / #tvLinks, 1)
			dxDrawRectangle(screenX/2 + width/2 - 15/myX*sx, screenY/2-(height*10)/2 + sy*0.0025 + (respc(345) * (lineHeight * tvScroll/10)), sx*0.002, respc(345) * lineHeight, tocolor(r, g, b, 200))

			if core:getDistance(localPlayer, selectedTV) >= 10 or getKeyState("backspace") then
				core:destroyOutline(selectedTV)
				selectedTV = false
			end
		end

		local x, y, z = getCameraMatrix(localPlayer)

		for k=1, #tvElements do
			if isElement(tvElements[k]) and isElement(tvBrowsers[tvElements[k]]) then
				local x2, y2, z2 = getElementPosition(tvElements[k])

				local dist = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
				local vol = 1-dist/15

				if vol < 0 then
					vol = 0
				end

				setBrowserVolume(tvBrowsers[tvElements[k]], vol)
			end
		end
	end
end

registerEvent("intiEdit:playMovieC", getRootElement(), 
	function (url, time)
		if isElement(source) then
			if url then
				if not isElement(tvBrowsers[source]) or not isElement(tvShaders[source]) then
					destroyElement(tvShaders[source])
					destroyElement(tvBrowsers[source])

					tvShaders[source] = dxCreateShader("files/texturechanger.fx")
					tvBrowsers[source] = createBrowser(512, 256, false, true)
					engineApplyShaderToWorldTexture(tvShaders[source], "tv", source)

					dxSetShaderValue(tvShaders[source], "gTexture", tvBrowsers[source])
				end

				local sec = tonumber(time)
				if sec and tonumber(sec) then
					sec = "&start=" .. sec
				else
					sec = ""
				end

				tvMovies[source] = url

				setElementData(tvBrowsers[source], "URL", "https://www.youtube.com/embed/" .. url .. "?autoplay=true&controls=0&showinfo=0&autohide=1" .. sec)
				loadBrowserURL(tvBrowsers[source], "https://www.youtube.com/embed/" .. url .. "?autoplay=true&controls=0&showinfo=0&autohide=1" .. sec)
			else
				destroyElement(tvBrowsers[source])
				tvBrowsers[source] = nil

				destroyElement(tvShaders[source])
				tvShaders[source] = nil
				
				tvMovies[source] = nil
			end
		end
	end)

addEventHandler("onClientBrowserCreated", getResourceRootElement(),
	function ()
		loadBrowserURL(source, getElementData(source, "URL"))
	end)

function onClientKeyNoEdit(key, por)
	if selectedTV then
		if key == "mouse_wheel_up" then
			tvScroll = tvScroll - 1
			
			if tvScroll < 0 then
				tvScroll = 0
			else
				--playSound("sounds/scrollmenu.mp3")
			end
		elseif key == "mouse_wheel_down" then
			tvScroll = tvScroll + 1

			if tvScroll > #tvLinks-10 then
				tvScroll = #tvLinks-10
			else
				--playSound("sounds/scrollmenu.mp3")
			end
		end
	end
end

function onClientClickNoEdit(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if state == "down" then
		if activeButton and button == "left" then
			if getTickCount()-lastSwitch > 1000 then
				lastSwitch = getTickCount()

				if activeButton == "switchLight" then
					lightState = not lightState
					setDaytime(lightState)

					playSound("sounds/switch.mp3")

					saveDynamicData()
				elseif activeButton == "doorLock" then
					checkOwnership()
					if currentDoor and ownership then
						if doorLocked[currentDoor] ~= "inservice" and doorLocked[currentDoor] ~= "damaged" then
							doorLocked[currentDoor] = not doorLocked[currentDoor]

							local k = currentDoor
							local v = doors[k]

							local rx, ry, rz = getElementRotation(wallOnCoordiante[k])

							setElementRotation(v, 0, 0, doorRots[v]+rz)

							if doorLocked[currentDoor] then
								setElementCollisionsEnabled(v, false)
								setElementModel(wallOnCoordiante[k], wallModellID["door2"])
								playSound(":oInteriors/files/sounds/locked.mp3")
							else
								setElementCollisionsEnabled(v, true)
								setElementModel(wallOnCoordiante[k], wallModellID["door"])
								playSound(":oInteriors/files/sounds/locked.mp3")
							end


							saveDynamicData()
						end
					end
				elseif utf8.find(activeButton, "playMovie") and selectedTV then
					local cmd = split(activeButton, ":")

					triggerServerEvent("intiEdit:playMovie", selectedTV, cmd[2], editingInteriorID)

					playSound("sounds/switch.mp3")
				elseif activeButton == "stopMovie" then
					local cmd = split(activeButton, ":")

					triggerServerEvent("intiEdit:stopMovie", selectedTV, editingInteriorID)

					playSound("sounds/switch.mp3")
				end
			end
		elseif clickedElement then
			if isUseableTV(clickedElement) and not selectedTV then
				local x, y, z = getElementPosition(localPlayer)
				local x2, y2, z2 = getElementPosition(clickedElement)

				if getDistanceBetweenPoints2D(x, y, x2, y2) < 10 then
					selectedTV = clickedElement
					core:createOutline(clickedElement, {r, g, b})
				end
			end
		end
	end
end

function onClientColShapeHit(theElement, matchingDimension)
	if theElement == localPlayer then
		if doorColShapeIndex[source] then
			currentDoor = doorColShapeIndex[source]
		elseif source == baseDoorCol then
			currentDoor = "base"
		end
	end
end

function onClientColShapeLeave(theElement, matchingDimension)
	if theElement == localPlayer then
		if doorColShapeIndex[source] then
			currentDoor = false
		elseif source == baseDoorCol then
			currentDoor = false
		end
	end
end

registerEvent("intiEdit:onInteriorLoaded", getRootElement(),
	function (id, data, edit, size, paidCash, dynamicData, ppDat)
		ppCount = {}
		boughtFromPP = ppDat

		paidCashCosts = paidCash
		local x, y = unpack(split(size, "x"))

		grid[4] = tonumber(x)
		grid[5] = tonumber(y)

		editingInteriorID = id
		editMode = edit


		if edit then
			canSave = true

			Roboto = dxCreateFont("files/Roboto.ttf", respc(15), false, "cleartype")

			lightHeight = dxGetFontHeight(1, dxfont0_roboto)

			separatorSize = dxGetTextWidth(" / ", 1, dxfont0_roboto)

			showCursor(true)

			setElementPosition(localPlayer, 0, 0, 0)
			setElementInteriorAndDimension(localPlayer, 1)
			setElementFrozen(localPlayer, true)

			showChat(false)
			exports.oInterface:toggleHud(true)

			currentBalance = thousandsStepper(getElementData(localPlayer, "char:money") or 0)
		end

	

		getSize()

		mainSelection = "walls" 
		subSelection = "drawing"

		dist = 40
		lineThickness = (2*dist)/25
		yaw = math.rad(45+180)
		pitch = math.rad(45-10)
		cam = {grid[1]+grid[4]/2*floorBaseSize, grid[2]+grid[5]/2*floorBaseSize, grid[3]-0.1}

		if edit then
			orbitCamera()
			setDaytime(true)
		end

		reverseCamera(false)

		local baseDoorCreated = false

		if data then
			data = fromString(data)

			if data["walls"] then
				for k=1, #data["walls"] do
					local tx, ty = unpack(split(data["walls"][k][1], ","))

					local obj = createWall(tonumber(tx), tonumber(ty), data["walls"][k][2], false, data["walls"][k][3])

					if data["walls"][k][4] then
						for t, path in pairs(data["walls"][k][4]) do
							local p1, p2, p3 = unpack(split(bigPathName(path), ","))

							applyTextureToElement(obj, bigTextureName(t), p1, p2, p3, true)
						end
					end
				end
			end

			if data["baseWalls"] then
				for k=1, #data["baseWalls"] do
					local p1, p2, p3 = unpack(split(bigPathName(data["baseWalls"][k][3]), ","))

					applyTextureToElement(baseWallOnCoordinates[data["baseWalls"][k][1]], bigTextureName(data["baseWalls"][k][2]), p1, p2, p3, true)
				end
			end

			if data["baseFloors"] then
				for k=1, #data["baseFloors"] do
					local p1, p2, p3 = unpack(split(bigPathName(data["baseFloors"][k][3]), ","))
			
					applyTextureToElement(floorOnCoordinates[data["baseFloors"][k][1]], bigTextureName(data["baseFloors"][k][2]), p1, p2, p3, true)
				end
			end

			if data["baseCeils"] then
				for k=1, #data["baseCeils"] do
					local p1, p2, p3 = unpack(split(bigPathName(data["baseCeils"][k][3]), ","))
			
					applyTextureToElement(ceilOnCoordinates[data["baseCeils"][k][1]], bigTextureName(data["baseCeils"][k][2]), p1, p2, p3, true)
				end
			end

			if data["windows"] then
				for k=1, #data["windows"] do
					local tx, ty = unpack(split(data["windows"][k][1], ","))

					createWindow(tx, ty, data["windows"][k][3], tonumber(data["windows"][k][2]), true)
				end
			end

			if data["doors"] then
				for k=1, #data["doors"] do
					local tx, ty = unpack(split(data["doors"][k][1], ","))

					createDoor(tx, ty, tonumber(data["doors"][k][2]), tonumber(data["doors"][k][4]), data["doors"][k][3], true)
				end
			end

			if data["furnitures"] then
				for k=1, #data["furnitures"] do
					local dat = data["furnitures"][k]
					local model = tonumber(dat[1])

					if useableTvs[model] then
						ppCount[model] = (ppCount[model] or 0) + 1
					end

					if (not hiFis[model] and not useableTvs[model]) or editMode then
						local skip = false

						for k, v in pairs(wallModellID) do
							if v == model then
								skip = true
							end
						end

						if not skip then
							local obj = createObject(model, dat[2], dat[3], dat[4], 0, 0, dat[5])

							if model == 2332 and not editMode then
								setElementData(obj, "build.safe", id, false)
							end
							
							setElementDoubleSided(obj, true)					
							setObjectBreakable(obj, false)
							setElementInteriorAndDimension(obj, 1)
							--setElementCollisionsEnabled(obj, false)

							furnitures[obj] = true
						end
					end
				end
			end

			if data["baseDoor"] and #data["baseDoor"] > 0 then
				data["baseDoor"][2] = baseWallOnCoordinates[data["baseDoor"][2]]
				local rx, ry, rz = getElementRotation(data["baseDoor"][2])
				data["baseDoor"][6] = rz

				data["baseDoor"][4] = tonumber(data["baseDoor"][4])
				data["baseDoor"][5] = tonumber(data["baseDoor"][5])
				data["baseDoor"][3] = tonumber(data["baseDoor"][3])

				createBaseDoor(data["baseDoor"], true, true)
				setCurrentBaseDoor()

				baseDoorCreated = true
			end

			if data["costs"] then
				cashCosts = tonumber(data["costs"])
				local tMoney = math.max(0, cashCosts-paidCashCosts)
				cashCostsFormatted = tMoney
			end
		end

		if not baseDoorCreated then
			local x = math.ceil(grid[4]/2)
			local el = baseWallOnCoordinates[x .. "," .. 0 .. "," .. 1]
			local rx, ry, rz = getElementRotation(el)

			local dat = {
				false,
				el,
				0,
				90,
				doorModels[1],
				rz
			}
			
			createBaseDoor(dat)
			setCurrentBaseDoor()
		end

		--for k, v in pairs(furnitureList) do
		--	for k2=1, #v do
		--		engineSetModelLODDistance(v[k2], 300)
		--	end
		--end

		addEventHandler("onClientRender", getRootElement(), checkForUnload)

		if edit then
			addEventHandler("onClientCursorMove", getRootElement(), onClientCursorMove, true, "low-999999")
			addEventHandler("onClientClick", getRootElement(), onClientClick)
			addEventHandler("onClientKey", getRootElement(), onClientKey, true, "high+999999")
			addEventHandler("onClientRender", getRootElement(), onClientRender)
			addEventHandler("onClientElementDataChange", localPlayer, onClientElementDataChange)

			
			addEventHandler("onClientPreRender", getRootElement(), onClientPreRender)

		else
			showCeil(true)

			for k, v in pairs(doors) do
				setElementCollisionsEnabled(v, true)
				setElementModel(wallOnCoordiante[k], wallModellID["door"])
			end

			setElementFrozen(localPlayer, false)

			addEventHandler("onClientColShapeHit", getRootElement(), onClientColShapeHit)
			addEventHandler("onClientClick", getRootElement(), onClientClickNoEdit)
			addEventHandler("onClientKey", getRootElement(), onClientKeyNoEdit)
			addEventHandler("onClientPlayerWeaponFire", getRootElement(), onClientPlayerWeaponFire)
			addEventHandler("onClientColShapeLeave", getRootElement(), onClientColShapeLeave)
			addEventHandler("onClientElementDataChange", localPlayer, onClientElementDataChange)

			--doorLocked = {}
			lightState = false

			setDaytime(lightState)

			checkOwnership()
		end


		updateDynamicData(dynamicData, true)

		--setTimer(floorMode, 2000, 1, false)
	end)

local _time = 3000
function getLogoRot()
	local rot = 0
	local max = 15000
	local current = getTickCount()%15000
	local state = math.ceil(current/5000)
	local currentC = current-(state-1)*5000
	local rot = getEasingValue( currentC/5000, "InOutElastic" )*120+(state-1)*120
	return rot
end

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end