-- Timing
dirtRefreshFrequency = 2500

debugGrungeTimer = 10000

removeGrungeInWater = 20000
removeGrungeInWaterSpeed = 90

removeGrungeInRain = 25000
removeGrungeInRainSpeed = 80

addGrungeOnRegular = 100000
addGrungeOnRegularSpeed = 50

--[[ Not working currently! ]]
addGrungeOnDirt = 10000
addGrungeOnDirtSpeed = 60
-- [[]]

-- Max shader visible distance (doesn't really need a higher value than this)
shaderVisibleDistance = 100

-- Speed you need at least to get the vehicle dirty
vehicleSpeedLimit = 15

-- Debug
debugEnabled = true
function switchDebug()
	debugEnabled = not debugEnabled
end

-- Vehicle types that can get dirty
allowedVehicleTypes = {
	["Automobile"] = true,
	["Bike"] = true,
	["Trailer"] = true,
	["BMX"] = true,
	["Quad"] = true,
}

-- Weather IDs where it rains
rainyWeathers = {
	[8] = true,
	[16] = true,
	[118] = true,
}

-- Default texture names to replace
replaceTextures = {
	{"vehiclegrunge256"},
	{"grunge"},
}

-- Car wash locations
carwashes = {
	-- x, y, z, rot, garage
	{2454.51343, -1461.01477, 24.00000, 0, false},
	{1911.29041, -1776.22644, 13.38281, 0, false},
	{1017.74756, -917.59283, 42.17969, 0, false},
	{1574.125, -2350, 13.56247, 90, true},
}

--[[ Not working currently! ]]
-- Ground material IDs where vehicles get dirty quicker
materialIDs = {
	-- default
	--[1] = true,
	-- gravel
	[6] = true,
	[85] = true,
	[101] = true,
	[134] = true,
	[140] = true,
	-- grass
	[9] = true,
	[10] = true,
	[11] = true,
	[12] = true,
	[13] = true,
	[14] = true,
	[15] = true,
	[16] = true,
	[17] = true,
	[18] = true,
	[19] = true,
	[20] = true,
	[80] = true,
	[81] = true,
	[82] = true,
	[115] = true,
	[116] = true,
	[117] = true,
	[118] = true,
	[119] = true,
	[120] = true,
	[121] = true,
	[122] = true,
	[125] = true,
	[146] = true,
	[147] = true,
	[148] = true,
	[149] = true,
	[150] = true,
	[151] = true,
	[152] = true,
	[153] = true,
	[160] = true,
	-- dirt
	[19] = true,
	[21] = true,
	[22] = true,
	[24] = true,
	[25] = true,
	[26] = true,
	[27] = true,
	[40] = true,
	[83] = true,
	[84] = true,
	[87] = true,
	[88] = true,
	[100] = true,
	[110] = true,
	[123] = true,
	[124] = true,
	[126] = true,
	[128] = true,
	[129] = true,
	[130] = true,
	[132] = true,
	[133] = true,
	[141] = true,
	[142] = true,
	[145] = true,
	[155] = true,
	[156] = true,
	-- sand
	[28] = true,
	[29] = true,
	[30] = true,
	[31] = true,
	[32] = true,
	[33] = true,
	[74] = true,
	[75] = true,
	[76] = true,
	[77] = true,
	[78] = true,
	[79] = true,
	[86] = true,
	[96] = true,
	[97] = true,
	[98] = true,
	[99] = true,
	[131] = true,
	[143] = true,
	[157] = true,
	-- vegetation
	[23] = true,
	[41] = true,
	[111] = true,
	[112] = true,
	[113] = true,
	[114] = true,
	-- misc
	[178] = true,
}
-- [[]]