vehicleElement = {}

pedDatas = {
    -- SkinId, X, Y, Z, INT, DIM, Name, ROT
    ["upper"] = {
        {0,1161.6317138672,-1643.8354492188,13.946002006531, 0, 0, "Michael", 90},
    },
    ["dropDown"] = {
        {1151.7827148438,-1651.2329101562,13.78125, 179}
    },
}

scene1MinPrice = 100
scene1MaxPrice = 500

scene2MinPrice = 200
scene2MaxPrice = 1000

pedRandPositon = {
    -- X, Y, Z, ROT
    ["upper"] = {
        {1161.6317138672,-1643.8354492188,13.946002006531, 87},
        {1148.5532226562,-1630.0036621094,13.78125, 87},
        {1143.7945556641,-1649.4542236328,13.945394515991, 87},
        {1154.8806152344,-1663.6020507812,13.78125, 87},
    },
   ["dropDown"] = {
    {1151.7827148438,-1651.2329101562,13.78125, 179}
   },
}

destinationPoints = {
    {303.75677490234,-1385.3062744141,14.085229873657},
    {523.10131835938,-1285.5445556641,17.2421875},
    {936.60717773438,-1122.6226806641,23.995908737183},
    {1017.9420166016,-1097.7922363281,23.834857940674},
    {1119.0068359375,-1162.7492675781,23.581758499146},
    {1275.8278808594,-1303.2000732422,13.331535339355},
    {1293.0383300781,-1871.7724609375,13.546875},
    {1482.314453125,-1844.8201904297,13.591258049011},
    {1635.2159423828,-1904.9581298828,13.5546875},
    {1896.4300537109,-1868.5416259766,13.563339233398},
    {1803.1770019531,-1931.6099853516,13.386897087097},
    {1777.0524902344,-1929.8314208984,13.387156486511},
    {2158.2958984375,-1795.3969726562,13.361433982849},
    {2426.9934082031,-1772.8409423828,13.546875},
    {2397.6477050781,-2065.2458496094,13.524951934814},
    {2395.9411621094,-2075.2744140625,13.519209861755},
    {2524.7282714844,-2069.5302734375,13.546875},
}

factoryPosition = {
    {2414.9658203125,-2477.0300292969,13.633213043213, 181},
}

factoryMarkerX,factoryMarkerY,factoryMarkerZ  = 2402.48828125,-2467.77734375,13.643414497375

vehicleIds = {
    565,
    426,
    551,
    527,
    405,
    445,
    492,
    547,
    518,
    404,
    467,
    402,
    540,
    536,
    410,
    505,
    585,
    526,
    534,
    529,
    579,
    400,
    516,
    507,
    602,
    562,
    560,
    559,
}

vehicleColor = {
    [1] = {"Piros", 201, 67, 62},
    [2] = {"Fekete", 0, 0, 0},
    [3] = {"Fehér", 255, 255, 255},
    [4] = {"Zöld", 66, 176, 60},
}

factionId = {
    25,
}


core = exports.oCore
color, r, g, b = core:getServerColor()
moneycolor = "#90cc68"
font = exports.oFont
chat = exports.oChat
interface = exports.oInterface
infobox = exports.oInfobox
bone = exports.oBone


text_wait = 15
texts = {
    ["start"] = {
        [1] = "Helló srác! Na figyelj van egy munkám számodra ha érdekel.",
        [2] = "El kéne kötni egy fasza járgányt aminek most az alkatrészei igen csak fontosak számomra.",
        [3] = "El kéne menned érte. Elvállalod?",
        ["success"] = "Remek #s helyen találod hozd el nekem egy #c #a -(o)t!",
        ["decline"] = "Hát, rendben te tudod akkor majd legközelebb!",
        ["canNotSpeak"] = "Bocs, most túl elfoglalt vagyok a hülyeségeddel foglalkozni!\nNa Csá ..", -- noSpeak
        ["backspace"] = "Hát, rendben te tudod akkor majd legközelebb!",
        ["noPermission"] = "Hát te meg ki a faszom vagy, na húzz innen!",
    },
    ["scene1"] = {
        [1] = "Na végre hogy itt vagy. A zsaruk remélem nem követtek!",
        [2] = "Figyelj ha szeretnél nekem segíteni akkor szét szerelhetnéd a kocsit, ha nem akarsz akkor itt a lóvéd.",
        [3] = "Segítesz nekem vagy sem?",
        ["success"] = "Szuper köszi #s helyen találod a garázsomat vidd el ide és szedd szét!",
        ["decline"] = "Hát, jó köszi hogy elhoztad a fizetséged: #F $.",
        ["canNotSpeak"] = "Bocs, most túl elfoglalt vagyok a hülyeségeddel foglalkozni!\nNa Csá ..", -- noSpeak
        ["backspace"] = "Hát, rendben te tudod akkor majd legközelebb!",
        ["noPermission"] = "Hát te meg ki a faszom vagy, na húzz innen!",
    },
    ["sence2"] = {
        [1] = "Sikerült szét szedned a kocsit? Remélem minden bizonyítékot el rejtettél.",
        [2] = "A fizetséged: #F $.",
    },
}


components = {
	["door_lf_dummy"] = true,
	["door_rf_dummy"] = true,
	["door_lr_dummy"] = true,
	["door_rr_dummy"] = true,
	["bonnet_dummy"] = true,
	["boot_dummy"] = true,
	["wheel_lf_dummy"] = true,
	["wheel_lb_dummy"] = true,
	["wheel_rf_dummy"] = true,
	["wheel_rb_dummy"] = true,
	["bump_front_dummy"] = true,
	["bump_rear_dummy"] = true,
	["windscreen_dummy"] = true,
}

realComponentNames = {
	["door_lf_dummy"] = "Bal első ajtó",
	["door_rf_dummy"] = "Jobb első ajtó",
	["door_lr_dummy"] = "Bal hátsó ajtó",
	["door_rr_dummy"] = "Jobb hátsó ajtó",
	["bonnet_dummy"] = "Motorháztető",
	["boot_dummy"] = "Csomagtartó",
	["wheel_lf_dummy"] = "Bal első kerék",
	["wheel_lb_dummy"] = "Bal hátsó kerék",
	["wheel_rf_dummy"] = "Jobb első kerék",
	["wheel_rb_dummy"] = "Jobb hátsó kerék",
	["bump_front_dummy"] = "Első lökhárító",
	["bump_rear_dummy"] = "Hátsó lökhárító",
	["windscreen_dummy"] = "Szélvédő",
}

componentPos = {
	["door_lf_dummy"] = {-0.3,-0.2,0,0,0,-90,2},
	["door_rf_dummy"] = {0.3,-0.2,0,0,0,90,3},
	["door_lr_dummy"] = {0.6,-0.2,0,0,0,-90,4},
	["door_rr_dummy"] = {-0.7,-0.2,0,0,0,90,5},
	["bonnet_dummy"] = {0,-0.8,0.2,0,0,0,0},
	["boot_dummy"] = {0,-1.5,0,180,180,0,1},
	["wheel_lf_dummy"] = {-0.7,-0.3,-1.2,90,90,180,0},
	["wheel_lb_dummy"] = {-0.75,0,1.6,90,90,180,0},
	["wheel_rf_dummy"] = {1.55,-0.3,1,0,0,90,0},
	["wheel_rb_dummy"] = {-1.35,-0.3,1,0,0,-270,0},
	["bump_front_dummy"] = {0,-1.75,0.4,0,0,0,5},
	["bump_rear_dummy"] = {0,-1.75,0.4,0,0,-180,6},
	["windscreen_dummy"] = {0,0,0,0,0,0,4},
}

doorsStates = {
	["door_lf_dummy"] = {2},
	["door_rf_dummy"] = {3},
	["door_lr_dummy"] = {4},
	["door_rr_dummy"] = {5},
	["bonnet_dummy"] = {0},
	["boot_dummy"] = {1},
}

wheelStates = {
	["wheel_lf_dummy"] = {1},
	["wheel_rf_dummy"] = {2},
	["wheel_lb_dummy"] = {3},
	["wheel_rb_dummy"] = {4},
}

panelStates = {
	["bump_front_dummy"] = {5},
	["bump_rear_dummy"] = {6},
	["windscreen_dummy"] = {4},
}

function getPositionFromElementOffset(element, offsetX, offsetY, offsetZ)
	local m = getElementMatrix(element)
	return offsetX * m[1][1] + offsetY * m[2][1] + offsetZ * m[3][1] + m[4][1],
          offsetX * m[1][2] + offsetY * m[2][2] + offsetZ * m[3][2] + m[4][2],
          offsetX * m[1][3] + offsetY * m[2][3] + offsetZ * m[3][3] + m[4][3]
end

function getPositionFromOffset(m, offsetX, offsetY, offsetZ)
	return offsetX * m[1][1] + offsetY * m[2][1] + offsetZ * m[3][1] + m[4][1],
          offsetX * m[1][2] + offsetY * m[2][2] + offsetZ * m[3][2] + m[4][2],
          offsetX * m[1][3] + offsetY * m[2][3] + offsetZ * m[3][3] + m[4][3]
end

function rotateAround(angle, offsetX, offsetY, baseX, baseY)
	angle = math.rad(angle)

	offsetX = offsetX or 0
	offsetY = offsetY or 0

	baseX = baseX or 0
	baseY = baseY or 0

	return baseX + offsetX * math.cos(angle) - offsetY * math.sin(angle),
          baseY + offsetX * math.sin(angle) + offsetY * math.cos(angle)
end