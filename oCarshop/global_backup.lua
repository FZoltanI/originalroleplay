components = {
    ["boot_dummy"] = {"Csomagtartó"},
    ["door_rf_dummy"] = {"Jobb első ajtó"},
    {"door_lf_dummy"} = {"Bal első ajtó"},
    {"door_rr_dummy"} = {"Jobb hátsó ajtó"},
    {"door_lr_dummy"} = {"Bal hátsó ajtó"},
    {"bonnet_dummy"} = {"Motorháztető"},
}

carshops = {
    --{posX,posY,posZ,rot,name,skinID,type(1-civil,2-szervezeti,3-bicikli,4-hajó)}
    {1111.9215087891, -1797.1430664063, 16.59375, 90, "Jackson White", 32, 1},
    --{1671.5196533203, 1814.2491455078, 10.8203125, 90, "Mike Smith", 32, 1},
    {1219.3916015625, -1811.7043457031, 16.59375, 180, "Paul Johnson", 33, 2},

    {2722.6069335938,-2323.2058105469, 3, 270, "Jackson Jhonson", 123, 4},
    {1730.6047363281,-2237.5915527344,13.543190002441, 180, "David Williams", 123, 5},
}

vehicle_show_pos = {
    [1] = {1141.09999, -1810.699999, 5.6, 40},
    [2] = {1141.09999, -1810.699999, 5.6, 40},
    [3] = {1677.361328125, -1615.4437255859, 13.546875, 328},
    [4] = {2319.1926269531, 531.00164794922, -0.60577541589737, 100},
    [5] = {1689.7725830078, 1345.8162841797, 21.554616165161, 280},
}

vehicle_show_camera = {
    [1] = {1140.9030761719,-1802.833984375,6.858499526978,1140.9281005859,-1803.8068847656,6.628606796265},
    [2] = {1140.9030761719,-1802.833984375,6.858499526978,1140.9281005859,-1803.8068847656,6.628606796265},
    [3] = {1681.7790527344,-1620.1762695313,14.71010017395,1681.0744628906,-1619.5052490234,14.479385375977},
    [4] = {2308.994140625,517.80950927734,3.2228999137878,2309.4465332031,518.66937255859,2.9861698150635},
    [5] = {1698.6650390625,1357.5826416016,25.507699966431,1698.0935058594,1356.8087158203,25.234882354736},
}

carshop_names = {"Járműkereskedés", "Szervezeti járműkereskedés", "Kerékpár kereskedés", "Hajókereskedés", "Helikopter kereskedés"}
carshopBlipIDs = {8, 8, 33, 32, 61}
testDrives = {"Vidék", "Város", "Tesztpálya"}

testPos = {
    {2374.2170410156, -647.62426757813, 127.42464447021, 262},
    {1077.7437744141, -1772.6419677734, 13.350935935974, 89},
    {1788.9230957031, -1070.2019042969, 23.9609375, 176},
}

carSpawnPos = {
    --{x,y,z,rot}
    [1] = {
        ["ls"] = {
            {1098.4211425781, -1775.5446777344, 13.344514846802, 90},
            {1098.4211425781, -1772.6749267578, 13.346617698669, 90},
            {1098.4211425781, -1767.6749267578, 13.346617698669, 90},
            {1098.4211425781, -1764.6749267578, 13.346617698669, 90},
            {1098.4211425781, -1761.6749267578, 13.346617698669, 90},
            {1098.4211425781, -1758.6749267578, 13.346617698669, 90},
            {1098.4211425781, -1755.6749267578, 13.346617698669, 90},
            {1083.4211425781, -1775.5446777344, 13.344514846802, 270},
            {1083.4211425781, -1772.6749267578, 13.346617698669, 270},
            {1083.4211425781, -1767.6749267578, 13.346617698669, 270},
            {1083.4211425781, -1764.6749267578, 13.346617698669, 270},
            {1083.4211425781, -1761.6749267578, 13.346617698669, 270},
            {1083.4211425781, -1758.6749267578, 13.346617698669, 270},
            {1083.4211425781, -1755.6749267578, 13.346617698669, 270},
            {1077.4211425781, -1775.5446777344, 13.344514846802, 90},
            {1077.4211425781, -1772.6749267578, 13.346617698669, 90},
            {1077.4211425781, -1767.6749267578, 13.346617698669, 90},
            {1077.4211425781, -1764.6749267578, 13.346617698669, 90},
            {1077.4211425781, -1761.6749267578, 13.346617698669, 90},
            {1077.4211425781, -1758.6749267578, 13.346617698669, 90},
            {1077.4211425781, -1755.6749267578, 13.346617698669, 90},
            {1062.4211425781, -1775.5446777344, 13.344514846802, 270},
            {1062.4211425781, -1772.6749267578, 13.346617698669, 270},
            {1062.4211425781, -1767.6749267578, 13.346617698669, 270},
            {1062.4211425781, -1764.6749267578, 13.346617698669, 270},
            {1062.4211425781, -1761.6749267578, 13.346617698669, 270},
            {1062.4211425781, -1758.6749267578, 13.346617698669, 270},
            {1062.4211425781, -1755.6749267578, 13.346617698669, 270},
            {1062.4211425781, -1752.6749267578, 13.346617698669, 270},
            {1062.4211425781, -1749.6749267578, 13.346617698669, 270},
            {1062.4211425781, -1746.6749267578, 13.346617698669, 270},
            {1062.4211425781, -1743.6749267578, 13.346617698669, 270},
            {1062.4211425781, -1740.6749267578, 13.346617698669, 270},
            {1062.4211425781, -1737.6749267578, 13.346617698669, 270},
        },

        ["lv"] = {
            {1731.4187011719, 1887.3898925781, 10.8203125, 90},
            {1731.4187011719, 1893.3898925781, 10.8203125, 90},
            {1731.4187011719, 1899.3898925781, 10.8203125, 90},
            {1731.4187011719, 1905.3898925781, 10.8203125, 90},
            {1731.4187011719, 1911.3898925781, 10.8203125, 90},
            {1731.4187011719, 1917.3898925781, 10.8203125, 90},
            {1731.4187011719, 1923.3898925781, 10.8203125, 90},
            {1731.4187011719, 1929.3898925781, 10.8203125, 90},
            {1731.4187011719, 1935.3898925781, 10.8203125, 90},
            {1731.4187011719, 1941.3898925781, 10.8203125, 90},
            {1731.4187011719, 1947.3898925781, 10.8203125, 90},
            {1731.4187011719, 1953.3898925781, 10.8203125, 90},
            {1731.4187011719, 1959.3898925781, 10.8203125, 90},
            {1731.4187011719, 1965.3898925781, 10.8203125, 90},
            {1731.4187011719, 1971.3898925781, 10.8203125, 90},
            {1731.4187011719, 1977.3898925781, 10.8203125, 90},
            {1731.4187011719, 1983.3898925781, 10.8203125, 90},
            {1731.4187011719, 1989.3898925781, 10.8203125, 90},
            {1731.4187011719, 1995.3898925781, 10.8203125, 90},
            {1731.4187011719, 2001.3898925781, 10.8203125, 90},
            {1731.4187011719, 2007.3898925781, 10.8203125, 90},
            {1731.4187011719, 2013.3898925781, 10.8203125, 90},
            {1731.4187011719, 2019.3898925781, 10.8203125, 90},
            {1742.4187011719, 1887.3898925781, 10.8203125, 270},
            {1742.4187011719, 1893.3898925781, 10.8203125, 270},
            {1742.4187011719, 1899.3898925781, 10.8203125, 270},
            {1742.4187011719, 1905.3898925781, 10.8203125, 270},
            {1742.4187011719, 1911.3898925781, 10.8203125, 270},
            {1742.4187011719, 1917.3898925781, 10.8203125, 270},
            {1742.4187011719, 1923.3898925781, 10.8203125, 270},
            {1742.4187011719, 1929.3898925781, 10.8203125, 270},
            {1742.4187011719, 1935.3898925781, 10.8203125, 270},
            {1742.4187011719, 1941.3898925781, 10.8203125, 270},
            {1742.4187011719, 1947.3898925781, 10.8203125, 270},
            {1742.4187011719, 1953.3898925781, 10.8203125, 270},
            {1742.4187011719, 1959.3898925781, 10.8203125, 270},
            {1742.4187011719, 1965.3898925781, 10.8203125, 270},
            {1742.4187011719, 1971.3898925781, 10.8203125, 270},
            {1742.4187011719, 1977.3898925781, 10.8203125, 270},
            {1742.4187011719, 1983.3898925781, 10.8203125, 270},
            {1742.4187011719, 1989.3898925781, 10.8203125, 270},
            {1742.4187011719, 1995.3898925781, 10.8203125, 270},
            {1742.4187011719, 2001.3898925781, 10.8203125, 270},
            {1742.4187011719, 2007.3898925781, 10.8203125, 270},
            {1742.4187011719, 2013.3898925781, 10.8203125, 270},
            {1742.4187011719, 2019.3898925781, 10.8203125, 270},
        },
    },

    [2] = {
        {1262.5496826172, -1796.7447509766, 13.417814254761, 180},
        {1268.5496826172, -1796.7447509766, 13.417814254761, 180},
        {1273.5496826172, -1796.7447509766, 13.417814254761, 180},
        {1278.5496826172, -1796.7447509766, 13.417814254761, 180},
        {1262.5496826172, -1809.7447509766, 13.417814254761, 180},
        {1268.5496826172, -1809.7447509766, 13.417814254761, 180},
        {1273.5496826172, -1809.7447509766, 13.417814254761, 180},
        {1278.5496826172, -1809.7447509766, 13.417814254761, 180},
        {1262.5496826172, -1822.7447509766, 13.417814254761, 180},
        {1268.5496826172, -1822.7447509766, 13.417814254761, 180},
        {1273.5496826172, -1822.7447509766, 13.417814254761, 180},
        {1278.5496826172, -1822.7447509766, 13.417814254761, 180},
    },

    [3] = {
        {1670.4813232422, -1609.1826171875, 13.546875, 3},
        {1663.5046386719, -1609.2149658203, 13.546875, 3},
        {1656.4074707031, -1609.2064208984, 13.542793273926, 3},
    },

    [4] = {
        {2696.1716308594,-2284.603515625,-0.55000001192093, 90},
        {2653.6303710938,-2282.9685058594,-0.55000001192093, 90},
        {2797.1867675781,-2284.5773925781,-0.55000001192093, 90},
        {2778.1928710938,-2309.298828125,-0.55000001192093, 90},
    },

    [5] = {
        {1808.0900878906,-2415.048828125,13.5546875, 180},
        {1841.7514648438,-2412.01953125,13.5546875, 180},
        {1986.8690185547,-2383.1110839844,13.546875, 90},
        {1987.2873535156,-2313.9978027344,13.546875, 90},
    },
}

vehicles = {
    --{név,modell,ár,limit(false <= nincs limit),végsebesség,üzemanyag típusa, üzemanyag tartáj kapacitása, meghajtás, csomagtartó kapacitás, ajtók száma, gyártási év,gyorsulas,irányíthatóság,féktávolság}, haszonjármű

    [1] = { -- Civil carshop
        {
            category_name = "Ford",
            category_cars = {
                {"", 565, 12000, false, 109, "", _, "Hátsó kerék", _, 3, 1974, 1000},
            },
        },

        {
            category_name = "Audi",
            category_cars = {
                {"", 426, 185000, 30, 177, "", _, "Hátsó kerék", _, 5, 2014, 10000},
                {"", 551, 75000, false, 177, "", _, "Hátsó kerék", _, 5, 2014, 6000},

                {"", 527, 125000, 10, 148, "", _, "Össz. kerék", _, 3, 1983, 8000},
            },
        },

        {
            category_name = "BMW",
            category_cars = {
                {"", 405, 95000, 20, 202, "", _, "Hátsó kerék", _, 5, 1987, 10000},
                {"", 445,--[[ID]] 275000--[[ár]], 30,--[[limit]] 226,--[[végsebesség]] "", _, "Hátsó kerék", _, 5, 2005, 25000},
                {"", 492, 225000, 30, 177, "", _, "Hátsó kerék", _, 5, 2016, 20000},
            },
        },

        {
            category_name = "Bugatti",
            category_cars = {
                {"", 502, 2500000, 5, 373, "", _, "Hátsó kerék", _, 3, 2010, 50000},
            },
        },

        {
            category_name = "Cadilac",
            category_cars = {
                {"", 547, 85000, false, 171, "", _, "Hátsó kerék", _, 5, 1994, 7000},
                {"", 518, 120000, 50, 177, "", _, "Hátsó kerék", _, 3, 1953, 10000},
            },
        },

        {
            category_name = "Chevrolet",
            category_cars = {
                {"", 404, 40000, 150, 154, "", _, "Hátsó kerék", _, 5, 2015, 4000},
                {"", 422, 65000, 200, 177, "", _, "Hátsó kerék", _, 3, 1965, 4000, 4},
                {"", 467, 39500, false, 145, "", _, "Hátsó kerék", _, 5, 2006, 4000},

                {"", 478, 75000, 25, 117, "", _, "Össz. kerék", _, 5, 2014, 5000}, 

                {"", 589, 300000, 20, 117, "", _, "Hátsó kerék", _, 3, 2017, 10000}, 
            },
        },

        {
            category_name = "Dodge",
            category_cars = {
                {"", 402, 300000, 8, 256, "", _, "Hátsó kerék", _, 3, 2018, 20000},
                {"", 540, 195000, 30, 177, "", _, "Hátsó kerék", _, 5, 2014, 9000},
                {"", 536, 73200, 75, 177, "", _, "Hátsó kerék", _, 3, 1970, 6000},
            },
        },

        
        {
            category_name = "Ferrari",
            category_cars = {
                {"", 451, 1800000, 10, 352, "", _, "Hátsó kerék", _, 3, 1992, 35000},
            },
        },

        {
            category_name = "Ford",
            category_cars = {
                {"", 410, 8000, false, 112, "", _, "Hátsó kerék", _, 3, 1975, 1000},

                {"", 505, 56000, false, 165, "", _, "Hátsó kerék", _, 3, 1965, 4000},
                {"", 585, 60000, false, 152, "", _, "Hátsó kerék", _, 5, 2007, 4500},

                {"", 526, 185000, 20, 177, "", _, "Hátsó kerék", _, 3, 2013, 9000},
                {"", 534, 125000, 10, 177, "", _, "Hátsó kerék", _, 3, 1990, 8000},
            },
        },

        {
            category_name = "GMC",
            category_cars = {
                {"", 529, 60000, false, 170, "", _, "Hátsó kerék", _, 5, 2009, 2000},
            },
        },

        {
            category_name = "Grumman",
            category_cars = {
                {"", 498, 110000, 80, 140, "", _, "Hátsó kerék", _, 5, 1994, 2000},
            },
        },

        {
            category_name = "Harley-Davidson",
            category_cars = {
                {"", 586, 65000, 30, 177, "", _, "Hátsó kerék", _, 0, 1999, 2500},
                {"", 463, 50000, 30, 177, "", _, "Hátsó kerék", _, 0, 1983, 1500},
            },
        },

        {
            category_name = "Jeep",
            category_cars = {
                {"", 579, 155000, 35, 185, "", _, "Hátsó kerék", _, 5, 2012, 6000},
            },
        },

        {
            category_name = "Kawasaki",
            category_cars = {
                {"", 521, 80000, 40, 177, "", _, "Hátsó kerék", _, 0, 2019, 3500},        
            },
        },

        {
            category_name = "Koenigsegg",
            category_cars = {
                {"", 411, 2400000, 4, 360, "", _, "Hátsó kerék", _, 3, 2008, 45000},
            },
        },

        {
            category_name = "Land Rover",
            category_cars = {
                {"", 400, 180000, 40, 202, "", _, "Összkerék", _, 5, 2013, 12000},
            },
        },

        {
            category_name = "McLaren",
            category_cars = {
                {"", 415, 2800000, 3, 384, "", _, "Összkerék", _, 3, 2014, 55000},
            },
        },

        {
            category_name = "Mercedes-Benz",
            category_cars = {
                {"", 516, 140000, 100, 177, "", _, "Hátsó kerék", _, 5, 2004, 7000},
                {"", 507, 75000, false, 178, "", _, "Hátsó kerék", _, 5, 1993, 6000},
                {"", 479, 175000, 50, 175, "", _, "Hátsó kerék", _, 5, 2012, 9500},
                {"", 442, 1025500, 5, 177, "", _, "Hátsó kerék", _, 5, 2014, 28000},
            },
        },

        {
            category_name = "Nissan",
            category_cars = {
                {"", 602, 520000, 10, 246, "", _, "Hátsó kerék", _, 3, 2007, 20000},
                {"", 562, 300000, 15, 177, "", _, "Hátsó kerék", _, 3, 2014, 14000},
            },
        },

        
        {
            category_name = "Pontiac",
            category_cars = {
                {"", 542, 142000, 35, 196, "", _, "Hátsó kerék", _, 3, 1967, 6500},
            },
        },

        {
            category_name = "Porsche",
            category_cars = {
                {"", 480, 1000000, 10, 293, "", _, "Hátsó kerék", _, 3, 2006, 30000},
            },
        },

        {
            category_name = "Subaru",
            category_cars = {
                {"", 560, 145000, 30, 177, "", _, "Hátsó kerék", _, 5, 2004, 10500},
            },
        },

        {
            category_name = "Tesla",
            category_cars = {
                {"", 546, 350000, 15, 234, "", _, "Hátsó kerék", _, 5, 2012, 15000},
                {"", 496, 2200000, 3, 377, "", _, "Hátsó kerék", _, 3, 2010, 45000},
            },
        },

        {
            category_name = "Toyota",
            category_cars = {
                {"", 559, 145000, 30, 177, "", _, "Hátsó kerék", _, 3, 2006, 8500},
            },
        },

        {
            category_name = "Egyéb járművek",
            category_cars = {
                {"", 483, 35000, 20, 122, "", _, "Hátsó kerék", _, 5, 1970, 1500},
                {"", 468, 45000, false, 177, "", _, "Hátsó kerék", _, 0, 2000, 2000},
                {"", 409, 3100000, 2, 177, "", _, "Hátsó kerék", _, 5, 2010, 60000},        
            },
        },

        {
            category_name = "Prémium járművek",
            category_cars = {
                {"", 451, 145000, 30, 177, "", _, "Hátsó kerék", _, 3, 2006, 8500},
            },
        },

    },

    [2] = { -- Faction carshop
        {
            category_name = "Összes jármű",
            category_cars = {
                {"", 596, 120000, false, 258, "", _, "Hátsó kerék", _, 5, 2007, 0.9, 0.85, 0.73, allowedFactions = {1}},
                {"", 598, 80000, false, 258, "", _, "Hátsó kerék", _, 5, 2007, 0.9, 0.85, 0.73, allowedFactions = {1, 11}, pj = 2},
                {"", 598, 80000, false, 258, "", _, "Hátsó kerék", _, 5, 2007, 0.9, 0.85, 0.73, allowedFactions = {21}, pj = 1},
                {"", 598, 80000, false, 258, "", _, "Hátsó kerék", _, 5, 2007, 0.9, 0.85, 0.73, allowedFactions = {19}, pj = 3},
        
                {"", 490, 100000, false, 258, "", _, "Hátsó kerék", _, 5, 2007, 0.9, 0.85, 0.73, allowedFactions = {20, 4, 11, 1}}, -- FIRE, meg SWAT
        
                {"", 407, 200000, false, 258, "", _, "Hátsó kerék", _, 5, 2007, 0.9, 0.85, 0.73, allowedFactions = {4}},
                {"", 544, 210000, false, 258, "", _, "Hátsó kerék", _, 5, 2007, 0.9, 0.85, 0.73, allowedFactions = {4}},
                {"", 525, 150000, false, 258, "", _, "Hátsó kerék", _, 5, 2007, 0.9, 0.85, 0.73, allowedFactions = {1, 21, 3, 4}},
        
                {"", 416, 135000, false, 258, "", _, "Hátsó kerék", _, 5, 2007, 0.9, 0.85, 0.73, allowedFactions = {19}},
        
                {"", 599, 135000, false, 258, "", _, "Hátsó kerék", _, 5, 2007, 0.9, 0.85, 0.73, allowedFactions = {21}, pj = 1},
                {"", 599, 135000, false, 258, "", _, "Hátsó kerék", _, 5, 2007, 0.9, 0.85, 0.73, allowedFactions = {1, 11}, pj = 2},
        
                {"", 579, 155000, false, 185, "", _, "Hátsó kerék", _, 5, 2012, 0.3, 0.85, 0.5, allowedFactions = {18, 15, 13, 16, 17, 11, 1, 21, 20, 34}},
                {"", 400, 135000, false, 202, "", _, "Összkerék", _, 5, 2013, 0.4, 0.5, 0.3, allowedFactions = {18, 15, 13, 16, 11, 1, 14, 21, 20, 17, 34}},
                {"", 405, 95000, false, 202, "", _, "Hátsó kerék", _, 5, 1987, 0.2, 0.5, 0.75, allowedFactions = {18, 13, 16, 11, 1, 21, 20, 17, 24, 34}},
                {"", 426, 125000, false, 177, "", _, "Hátsó kerék", _, 5, 2014, 0.4, 0.5, 0.4, allowedFactions = {18, 11, 1, 21, 20, 24, 34}},
                {"", 560, 145000, false, 177, "", _, "Hátsó kerék", _, 5, 2004, 0.6, 0.45, 0.3, allowedFactions = {18, 11, 1, 21, 20, 24, 34}},
                {"", 445, 275000, false, 226, "", _, "Hátsó kerék", _, 5, 2005, 0.30, 0.6, 0.35, allowedFactions = {15, 13, 16, 11, 1, 14, 21, 20, 34}},
                {"", 542, 142000, false, 196, "", _, "Hátsó kerék", _, 3, 1967, 0.25, 0.6, 0.55, allowedFactions = {13, 16, 11, 1, 21, 20, 34}},
                {"", 507, 75000, false, 178, "", _, "Hátsó kerék", _, 5, 1993, 0.25, 0.5, 0.25, allowedFactions = {13, 16, 11, 1, 21, 20, 17, 34}},
                {"", 585, 60000, false, 152, "", _, "Hátsó kerék", _, 5, 2007, 0.1, 0.3, 0.2, allowedFactions = {13, 16, 11, 1, 21, 20, 34}},
                {"", 547, 85000, false, 171, "", _, "Hátsó kerék", _, 5, 1994, 0.35, 0.65, 0.8, allowedFactions = {13, 16, 11, 1, 21, 20, 34}},
                {"", 551, 75000, false, 177, "", _, "Hátsó kerék", _, 5, 2014, 0.4, 0.5, 0.4, allowedFactions = {13, 16, 17, 11, 1, 21, 20, 34}},
                {"", 468, 45000, false, 177, "", _, "Hátsó kerék", _, 0, 2000, 0.6, 0.45, 0.3, allowedFactions = {13, 16, 17, 11, 1, 21, 20, 34}},
                {"", 536, 73200, false, 177, "", _, "Hátsó kerék", _, 3, 1970, 0.6, 0.45, 0.3, allowedFactions = {13, 16, 11, 1, 21, 20, 34}},
                {"", 442, 1025500, false, 177, "", _, "Hátsó kerék", _, 5, 2014, 0.4, 0.5, 0.4, allowedFactions = {17, 11, 1, 14, 21, 20, 24, 34}},
                {"", 404, 40000, false, 154, "", _, "Hátsó kerék", _, 5, 2015, 0.1, 0.3, 0.6, allowedFactions = {17, 11, 1, 21, 20, 34}},
                {"", 505, 56000, false, 165, "", _, "Hátsó kerék", _, 3, 1965, 0.3, 0.7, 0.15, allowedFactions = {17, 11, 1, 21, 20, 34}},
                {"", 546, 290000, false, 234, "", _, "Össz. kerék", _, 5, 2012, 0.7, 0.45, 0.5, allowedFactions = {14, 21, 20, 34}},
                {"", 409, 3100000, false, 177, "", _, "Hátsó kerék", _, 5, 2010, 0.6, 0.45, 0.3, allowedFactions = {11, 21, 20, 34}},
                {"", 492, 225000, false, 177, "", _, "Hátsó kerék", _, 5, 2016, 0.4, 0.5, 0.4, allowedFactions = {11, 14, 1, 21, 20, 24, 34}},
            },
        },
    },

    [3] = { -- Kerékpár kereskedés
        {
            category_name = "Kerékpárok",
            category_cars = {
                {"", 509, 250, false, 25, "", 0, "", 0, "Nincs", 2020, 1000},
                {"", 481, 350, false, 25, "", 0, "", 0, "Nincs", 2020, 1000},
                {"", 510, 450, false, 25, "", 0, "", 0, "Nincs", 2020, 1000},
            },
        },
    },

    [4] = { --Hajó bolt
        {
            category_name = "Hajók",
            category_cars = {
                {"", 454, 850000, 20, 25, "", 0, "", 0, 0, 2014, 9500},
                {"", 473, 40000, 100, 100, "", 0, "", 0, 0, 2020, 2000},
                {"", 453, 56000, false, 100, "", 0, "", 0, 0, 2003, 3000},
            },
        },
    },

    [5] = { --Helikopter bolt
        {
            category_name = "Helikopterek",
            category_cars = {
                {"", 487, 1525000, 20, 200, "", 0, "", 0, 5, 2020, 15000},
                {"", 469, 1800000, 5, 200, "", 0, "", 0, 0, 2018, 17000},
            },
        },
    },
    
}

faction_vehicles = {
    {},
}

function createAllVehicleTable()
    local deliveryVehicles = {
        category_name = "Áruszállításra alkalmas járművek",
        category_cars = {},
    }

    for k, v in ipairs(vehicles[1]) do
        for k2, v2 in ipairs(v.category_cars) do 
            if v2[13] then
                table.insert(deliveryVehicles.category_cars, v2)
            end
        end 
    end

    table.insert(vehicles[1], 1, deliveryVehicles)

    local allVehicles = {
        category_name = "Összes jármű",
        category_cars = {},
    }

    for k, v in ipairs(vehicles[1]) do
        if not (v.category_name == "Áruszállításra alkalmas járművek") then
            for k2, v2 in ipairs(v.category_cars) do 
                table.insert(allVehicles.category_cars, v2)
            end 
        end
    end

    table.insert(vehicles[1], 1, allVehicles)

end
createAllVehicleTable()

vehicle_default_colors = {
    {255,255,255},
    {0,0,0},
    {201, 67, 62},
    {66, 176, 60},
    {69, 175, 214},
    {23, 74, 163},
    {201, 131, 50},
    {179, 68, 156},
}

vehicleDataPoints = {"Végsebesség", "Üzemanyag típusa", "Üzemanyag tartály kapacitása", "Meghajtás", "Csomagtartó kapacitása", "Ajtók száma", "Gyártási év", "Áruszállítás"}
vehicleDataLineNames = {"Gyorsulás", "Irányíthatóság", "Fékezés"}

borderWalls = {
    {1164.7900390625, -1777.5139160156, 14.5, 0},
    {1164.7900390625, -1768.5139160156, 14.5, 0},
    {1164.7900390625, -1759.5139160156, 14.5, 0},
    {1164.7900390625, -1750.5139160156, 14.5, 0},
    {1164.7900390625, -1741.5139160156, 14.5, 0},
    {1164.7900390625, -1732.5139160156, 14.5, 0},
    {1164.7900390625, -1723.5139160156, 14.5, 0},
    {1164.7900390625, -1714.5139160156, 14.5, 0},
    {1164.7900390625, -1705.5139160156, 14.5, 0},
    {1164.7900390625, -1705.5139160156, 14.5, 0},

    {1164.7900390625, -1565.5139160156, 14.5, 0},
    {1164.7900390625, -1574.5139160156, 14.5, 0},
    {1164.7900390625, -1583.5139160156, 14.5, 0},

    {1042.6083984375, -1560.6728515625, 14.5, 90},
    {1033.6083984375, -1560.6728515625, 14.5, 90},
    {1024.6083984375, -1560.6728515625, 14.5, 90},
    {1015.6083984375, -1560.6728515625, 14.5, 90},

    {1128.3807373047, -1561.8732910156, 14.5, 90},

    {1010.7900390625, -1565.5139160156, 14.5, 0},
    {1010.7900390625, -1574.5139160156, 14.5, 0},
    {1010.7900390625, -1583.5139160156, 14.5, 0},

    {1030.2021484375, -1773.6691894531, 14.5, 45},
    {1040.2021484375, -1784.6691894531, 14.5, 45},
    {1035.3695068359, -1779.4095458984, 14.5, 45},
    {1046.5555419922, -1791.3309326172, 14.5, 45},
    {1053.4653320313, -1799.0289306641, 14.5, 45},
    {1061.2808837891, -1806.4425048828, 14.5, 45},
    {1068.1418457031, -1813.8162841797, 14.5, 45},
    {1075.5808105469, -1821.6872558594, 14.5, 45},
    {1082.5135498047, -1828.2896728516, 14.5, 45},

    {1087.1958007813, -1821.1981201172, 17.5, 90},
}

shortCityNames = {
    ["Las Venturas"] = "lv",
    ["Los Santos"] = "ls",
    ["San Fierro"] = "sf",
}

font = exports.oFont
core = exports.oCore
color, r, g, b = core:getServerColor()
interface = exports.oInterface
blur = exports.oBlur
vehicle = exports.oVehicle
infobox = exports.oInfobox
inventory = exports.oInventory

greenR, greenG, greenB = 135, 186, 93
blueR, blueG, blueB = 93, 138, 186
redR, redG, redB = 194, 103, 97

function comma_value(amount)
    local formatted = amount
    while true do  
      formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')
      if (k==0) then
        break
      end
    end
    return formatted
end


function tableContains (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function getVehiclePriceInCarshop(modelID, carshopType)
    if not carshopType then carshopType = 1 end 

    for k, v in pairs(vehicles[carshopType][1].category_cars) do 
        if v[2] == modelID then 
            return v[3]
        end
    end

    return false
end