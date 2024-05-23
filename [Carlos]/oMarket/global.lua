fisher_peds = {
    {name = "Jake Robinson", skin = 95, minHour = 22, maxHour = 1, priceMultiplier = 1.5},
    {name = "Steven Guzman", skin = 160, minHour = 15, maxHour = 22, priceMultiplier = 1},
    {name = "Nathan White", skin = 183, minHour = 10, maxHour = 15, priceMultiplier = 1.5},
    {name = "James Butler", skin = 272, minHour = 6, maxHour = 10, priceMultiplier = 1.35},
    {name = "Jackson Bishop", skin = 124, minHour = 0, maxHour = 6, priceMultiplier = 2},
}

fisher_peds2 = {
    {name = "Steven Guzman", skin = 160, minHour = 22, maxHour = 1, priceMultiplier = 1.8},
    {name = "Leo Garza", skin = 124, minHour = 15, maxHour = 22, priceMultiplier = 1.3},
    {name = "Milo Fields", skin = 59, minHour = 10, maxHour = 15, priceMultiplier = 1.7},
    {name = "Steven Guzman", skin = 160, minHour = 6, maxHour = 10, priceMultiplier = 1.8},
    {name = "Matthew Swanson", skin = 95, minHour = 0, maxHour = 6, priceMultiplier = 2.5},
}



mushroom_peds = {
    {name = "James Butler", skin = 272, minHour = 22, priceMultiplier = 1.4},
    {name = "Theo Burns", skin = 60, minHour = 13, priceMultiplier = 1},
    {name = "Thomas George", skin = 22, minHour = 9, priceMultiplier = 0.8},
    {name = "Buddy Walker", skin = 206, minHour = 6, priceMultiplier = 1.15},
    {name = "Lara Wells", skin = 192, minHour = 0, priceMultiplier = 1.5},
}

animal_peds = {
    {name = "Peter Hebert", skin = 272, minHour = 22, priceMultiplier = 0.8},
    {name = "Dylan Jimenez", skin = 60, minHour = 13, priceMultiplier = 1},
    {name = "Louis White", skin = 22, minHour = 9, priceMultiplier = 0.6},
    {name = "Odin Goodman", skin = 206, minHour = 6, priceMultiplier = 0.8},
    {name = "Camilla Hale", skin = 192, minHour = 0, priceMultiplier = 0.9},
}

fishMarket = {pos = Vector3(2164.375, -103.66819763184, 2.75), rot = 34}
fishMarket2 = {pos = Vector3(-2382.6440429688,2217.0773925781,6.5834579467773), rot = 90}
mushroomMarket = {pos = Vector3(820.06408691406, -575.86859130859, 16.536296844482), rot = 270}
animalMarket = {pos = Vector3(1918.111328125, 172.67114257813, 37.257598876953), rot = 346}

fishPrices = {
    [127] = 100,
    [128] = 150,
    [129] = 102,
    [130] = 70,
    [131] = 550,
    [132] = 600,
    [133] = 200,
    [134] = 1550,
    [135] = 3000,
}

mushroomPrices = {
    [156] = 310,
    [157] = 50,
    [158] = 160,
    [159] = 105,
    [160] = 460,
}

animalPrices = {
    [165] = 4500,
    [166] = 2000,
    [167] = 550,
    [168] = 350,
}

core = exports.oCore
inventory = exports.oInventory
infobox = exports.oInfobox

color, r, g, b = core:getServerColor()