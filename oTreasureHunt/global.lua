core = exports.oCore
color, r, g, b = core:getServerColor()
inventory = exports.oInventory
chat = exports.oChat

boxModelID, moundModelID = 2969, 16317

digTime = 15000

chances = {
    {min = 0, max = 5, item = 0}, -- 5%
    {min = 6, max = 12, item = 185}, -- 6%
    {min = 13, max = 15, item = 186}, -- 2%
    {min = 16, max = 25, item = 187}, -- 9%
    {min = 26, max = 34, item = 188}, -- 8%
    {min = 35, max = 40, item = 189}, -- 5%
    {min = 41, max = 45, item = 190}, -- 4%
    {min = 46, max = 55, item = 191}, -- 9%
    {min = 56, max = 58, item = 192}, -- 2%
    {min = 59, max = 69, item = 193}, -- 10%
    {min = 70, max = 80, item = 194}, -- 10%
    {min = 81, max = 84, item = 195}, -- 3%
    {min = 85, max = 88, item = 196}, -- 3%
    {min = 89, max = 92, item = 197}, -- 3%
    {min = 93, max = 95, item = 198}, -- 3%
    {min = 96, max = 100, item = 139}, -- 4%
}

antiquePrices = {
    [185] = 1500,
    [186] = 3000,
    [187] = 525,
    [188] = 1350,
    [188] = 1350,
    [189] = 1550,
    [190] = 1750,
    [191] = 825,
    [192] = 4250,

    [230] = 4000,
    [231] = 3800,
    [232] = 4500,
    [233] = 6000,
}

-- skin posx, posy, posz, rot, int, dim
jewelryStorePed = {147, 716.23077392578, -1345.4964599609, 19.921899795532, 180, 0, 0}
antiqueStorePed = {147,  734.91790771484, -1346.24609375, 13.427791595459, 180, 0, 0}
jew2ped = {147, 822.01062011719,1.9976879358292,1004.1796875, 270, 3, 884}