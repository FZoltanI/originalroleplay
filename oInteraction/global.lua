core = exports.oCore
font = exports.oFont
inv = exports.oInventory

strecherElement = {}

color, r, g, b = core:getServerColor()
colorizePed = {r/255, g/255, b/255, 1}

types = {
    ["vehicle"] = {"Jármű",
        {
            {"Csomagtartó nyitása","csomagtarto.png"},
        },
    },

    ["player"] = {"Játékos",
        {
            {"Motozás", "motozas.png"},
            {"Bilincselés","cuff.png"},
            {"Felsegítés","felsegit.png"},
            {"Zsák húzása a fejre.","bag.png"},
        },
    },

    ["ped"] = {"Ped",
        {
            {"Csomagtartó","csomagtarto.png"},
        },
    },
}

policeCars = {
    [427] = {stingerAllowed = true, rbsAllowed = true, }, 
    [596] = {stingerAllowed = true},
    [598] = {stingerAllowed = true}, 
    [599] = {stingerAllowed = true, rbsAllowed = true, },  
    [597] = {stingerAllowed = true}, 
    [490] = {stingerAllowed = true, rbsAllowed = true, },  
    [407] = {rbsAllowed = true},  
    [544] = {rbsAllowed = true},  
}

nonTrunkVehicles = {
    [509] = true, 
    [481] = true,
    [510] = true,
    [611] = true,
}