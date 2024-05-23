core = exports.cl_core
fontS = exports.cl_font
color, r, g, b = core:getServerColor()
bone = exports.cl_bone

skins = {
    [1] = { --ferfi
        {"Bőrkabát szürke farmerral", 2, 3500},
        {"Hawai mintás ing, barna nadrág", 14, 2500},
        {"Sportöltözék", 16, 4000},
        {"Öltöny #1", 26, 3500},
        {"Sportruházat", 27, 3000},
        {"Szürke ing, sárga nadrág", 30, 2500},
        {"Rózsaszín ing, kalap, rövidnadrág", 35, 2000},
        {"Fehér ing, basketball sapka, rövidnadrág", 36, 2000},
        {"Kék ing, basketball sapka, rövidnadrág", 37, 2000},
        {"Virágmintás ing", 40, 4000},
        {"Fehér ing, farmer", 46, 3500},
        {"Kockás ing, farmer", 58, 2000},
        {"Barna póló, farmer", 60, 1500},
        {"Virágmintás ing, barna nadrág", 80, 3500},
        {"Sportruházat #2", 82, 2000},
        {"Sötétkék farmer, fehér póló, barna ing", 101, 2000},
    },
    [2] = { --noi
        {"Fekete pulóver, sötétszürke farmerral", 7, 3000},
        {"Rövidnadrág, basketball sapka, rövidujjú", 9, 2500},
        {"Alkalmi öltözék #1", 12, 3500},
        {"Rövidujjú, farmer", 13, 1500},
        {"Fehér ing, farmer, fekete cipő", 17, 3000},
        {"Rövidujjú, farmer", 19, 2500},
        {"Alkalmi öltözék #2", 24, 4000},
        {"Fekete pulóver, farmer", 28, 2500},
        {"Fehér pulóver, farmer", 29, 2500},
        {"Kalap, kék sportöltözék", 41, 2500},
        {"Kék felső, szoknya", 56, 2000},
    },
}

skinTables = {
    {1,1316.3903808594, -891.22521972656, 45.2265625,221},
    {2,1310.3489990234, -889.10192871094, 45.2265625,170},
}

counters = {
    {1315.3602294922, -884.44940185547, 45.2265625, 350, 157}
}

testRooms = {
    {1322.6462402344, -881.79644775391, 45.2265625},
}

eladoSkins = {25, 33, 99, 45}

skinObject = {2384, 2386}