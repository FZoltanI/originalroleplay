pages = {
    {"Áttekintés","user.png"},
    {"Vagyon","dollar.png"},
    {"Adminisztrátorok","admins.png"},
    {"Beállítások","options.png"},
    {"Szervezetek","factions.png"},
    {"Prémium","pp.png"},
    {"Napi ajándék és Case Shop","daily.png"},
    --{"Kisállat","pet.png"},
}

charStats = {
    {"Karakter név", "char:name"},
    {"Nem", "char:gender"},
    {"Életkor", "char:age"},
    {"Testsúly", "char:weight"},
    {"Magasság", "char:height"},
    {"Kinézet ID", "nan"},
    {"Munka", "char:job"},
    {"Szervezet", "char:faction"},
    {"Idő a fizetésig", "char:minToPayment"},
    {"Készpénz", "char:money"},
    {"Járművek", "0"},
    {"Ingatlanok", "0"},
}

userStats = {
    {"Felhasználónév", "user:name"},
    {"Account ID", "user:id"},
    {"Karakter ID / Meghívó kód", "char:id"},
    {"Admin rang", "user:admin"},
    {"Admin név", "user:adminnick"},
    {"Regisztráció dátuma", "user:registerDate"},
    {"Ban(ok)", "dashboard:banKickJailCount"},
    {"Kick(ek)", "dashboard:banKickJailCount"},
    {"Jail(ek)", "dashboard:banKickJailCount"},
    {"Játszott idő", "char:playedTime"},
    {"Email", "user:email"},
    {"Serial", "user:serial"},
}

vagyonTargyak = {
    {"Készpénz", "char:money"},
    {"Casino Coin", "char:cc"},
    {"Banki egyenleg", "_bankmoney"},
 --   {"Prémium Pont", "char:pp"},
}

adminPrefix = {"AS","A1","A2","A3","FA","SA","</>","T"}

vehicleDatas = {
    {"Jármű állapota",10},
    {"Motor állapota",4},
    {"Ajtók állapota",3},
    {"Lámpák állapota",11},
    {"Üzemanyagszint",15},
    {"Üzemanyag típusa",16},
    {"Pozíció",9},
    {"Motor", 12, "engine"},
    {"Váltó", 12, "gear"},
    {"Fékek", 12, "brake"},
    {"Turbó", 12, "turbo"},
    {"ECU", 12, "ecu"},
    {"Súlycsökkentés", 12, "wloss"},
    {"Távolság az olajcseréig:", 19, "wloss"},
}

walkingStyles = {0, 54, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138}
talkinkingAnimations = {
    {"misc", "idle_chat_02"},
    {"ped", "idle_chat"},
    {"ghands", "gsign1"},
    {"ghands", "gsign2"},
    {"ghands", "gsign3"},
    {"ghands", "gsign4"},
    {"ghands", "gsign5"},
}

options = {
    ["graphics"] = {
        name = "Grafikai beállítások",
        icon = "graphics.png",
        --- megnevezés, type (1:on/off, 2:csúszka, 3:jobbra-balra gomb), minimum érték, maximum érték, function, state, availableInBeta
        {"Látótávolság", 2, 100, 4000, "setMaxShowDistance", 0, true},
        {"Paletta", 3, 0, 17, "oShader_Palette", 0, true},
        {"Bloom", 1, 1, 1, "oShader_Bloom", false, true}, --dash > shader > toggleBloom
        {"Jármű tükröződés", 1, 0, 0, "oShader_VehicleReflection", false, true},
        {"Mozgási elmosódás", 1, 1, 1, "oShader_MotionBlur", false, true},
        {"Vignette", 1, 1, 1, "oShader_Vignette", false, true},
        {"Kidolgozott víz", 1, 1, 1, "oShader_Water", false, true}, --dash > shader > toggleWater
        {"Kidolgozott textúrák", 1, 1, 1, "oShader_HDTextures", false, true},
        {"Mélységélesség", 1, 1, 1, "oShader_Depth", false, true},
        {"Anti-aliasing (élsimítás)", 1, 1, 1, "oShader_FXAA", true, true}
        --{"Havazás", 1, 1, 1, "snow:state", false, true},
        --{"Kidolgozott fű", 1, 1, 1, "oShader_HDGrass", false},
    },

    ["char"] = {
        name = "Karakter beállítások",
        icon = "char.png",
        --- megnevezés, type (1:on/off, 3:jobbra-balra gomb), minimum érték, maximum érték, function, state, availableInBeta
        {"Harcstílus", 3, 1, 20, "", "char:fightStyle", true},
        {"Sétastílus", 3, 1, 23, "", "char:walkStyle", true},
        {"Beszéd animáció", 3, 0, 10, "", "char:talkAnimation", true},
        {"Avatar", 4, 0, 10, "", 1, true, ":oAccount/avatars/"},
    },

    ["other"] = {
        name = "Egyéb beállítások",
        icon = "settings.png",
        {"Szöveg körvonal", 3, 1, 3, "", 1, true},
        {"Nametag stílus", 3, 1, 3, "", 1, true},

        --v1.0.1 UPDATE
        {"Saját név megjelenítése", 1, 1, 1, "", 0, true},
        {"Tippek", 1, 1, 1, "", 1, true},
    },

    ["crosshair"] = {
        name = "Célkereszt",
        icon = "target.png",
        {"Kinézet", 4, 0, 10, "", 1, true, ":oCrosshair/crosshairs/"},
        {"Szín", 5, 0, 10, "", 1, true},
    },

    ["xmas"] = {
        name = "Karácsony",
        icon = "xmas.png",
        {"Havazás", 1, 1, 1, "oShader_Snow", false, true},
        {"Havazás stílusa", 3, 1, 2, "oShader_Snow", 1, true},
        {"Havazás erőssége", 2, 500, 2000, "oShader_Snow", 2000, true},
        {"Havazás hullámzása", 1, 1, 1, "oShader_Snow", true, true},

    }
}

rareVehicles = {
    [451] = true,
    [409] = true,
    [411] = true,
    [429] = true,
    [525] = true,
}

function getTalkingAnimation(id)
    if id > 0 then 
        return talkinkingAnimations[id]
    else
        return {"", ""}
    end
end

vignetteSetup = {
    {"Áttetszőség", 3, 0.1, 1, "", 0.5, true},
    {"Kiterjedés", 3, 1, 10, "", 5, true},
}

crosshairColors = {
    {255, 255, 255},
    {252, 186, 3},
    {251, 82, 3},
    {250, 3, 3},
    {41, 194, 43},
    {48, 150, 240},
    {207, 64, 195},
}

core = exports.oCore
preview = exports.oPreview
infobox = exports.oInfobox
mysql = exports.oMysql
admin = exports.oAdmin
inventory = exports.oInventory
interface = exports.oInterface
font = exports.oFont
cMarker = exports.oCustomMarker
job = exports.oJob
blur = exports.oBlur
vehicle = exports.oVehicle
color, r, g, b = core:getServerColor()
serverColor, r, g, b = core:getServerColor()
moneyColor = "#7cc576"

--- FRAKCIÓK
factionPages = {
    --{"név", "icon"},
    {"Áttekintés", "home"},
    {"Tagok", "team"},
    {"Járművek", "vehicle"},
    {"Rangok", "ranks"},
    {"Dutyk", "dutys"},
    --{"Raktár", "inventory"},
}

factionHomepageInfos = {
    --{"Leírás", "megnevezése a táblában", háttérR, háttérG, háttérB, textR, textG, textB}
    {"Tagok", 0, r, g, b, 220, 220, 220},
    {"Járművek", 6, r, g, b, 220, 220, 220},
    {"Rangok", 7, r, g, b, 220, 220, 220},
    {"Dutyk", 8, r, g, b, 220, 220, 220},
}

factionMemberInformations = {
    {"Név", 4},
    {"Rang", 2},
    {"Leader", 3},
    {"Szolgálatban", 5},
    {"Utolsó szolgálatba állás", 8},
    {"Utolsó bejelentkezés", 7},
    {"Szolgálatban töltött idő", 9, "perc"},
}

factionLeaderOptions = {
    {"Előléptetés"},
    {"Lefokozás"},
    {"Leader jog adása"},
    {"Kirúgás"},
    {"Szolgálati idő nullázása"},
    {"Jelvény adás"},
}

factionRankInformations = {
    {"Megnevezés", 1},
    {"Fizetés", 2},
    {"Hozzárendelt duty azonosító", 3},
    {"Tagok ezen a rangon", 0},
}

vehicleTypes = {
    ["Automobile"] = "Autó",
    ["Plane"] = "Repülő",
    ["Bike"] = "Motor",
    ["Helicopter"] = "Helikopter",
    ["Boat"] = "Hajó",
    ["Train"] = "Vonat",
    ["Trailer"] = "Trailer",
    ["BMX"] = "BMX",
    ["Monster Truck"] = "Monster Truck",
    ["Quad"] = "Quad",
}

vehicleTunings = {
    ["engine-1"] = "Alap motor",
    ["engine-2"] = "Verseny motor",
    ["engine-3"] = "Profi motor",
    ["engine-4"] = "Prémium motor",
    ["gear-1"] = "Alap váltó",
    ["gear-2"] = "Verseny váltó",
    ["gear-3"] = "Profi váltó",
    ["gear-4"] = "Prémium váltó",
    ["brake-1"] = "Alap fékek",
    ["brake-2"] = "Verseny fékek",
    ["brake-3"] = "Profi fékek",
    ["brake-4"] = "Prémium fékek",
    ["turbo-1"] = "Alap turbó",
    ["turbo-2"] = "Verseny turbó",
    ["turbo-3"] = "Profi turbó",
    ["turbo-4"] = "Prémium turbó",
    ["ecu-1"] = "Alap ECU",
    ["ecu-2"] = "Verseny ECU",
    ["ecu-3"] = "Profi ECU",
    ["ecu-4"] = "Prémium ECU",
}

factionLogMessageColor = "#fc7b03"
factionLogNameColor = "#0d73e0"
factionLogPrefix = "#fc5a03[Frakció - LOG]: "..factionLogMessageColor

tiltott_keys = {
    ["backspace"] = true,
    ["enter"] = true,
	["tab"] = true,
	["-"] = true,
	["."] = true,
	[","] = true,
	["lctrl"] = true,
	["rctrl"] = true,
	["lalt"] = true,
	["mouse1"] = true,
	["mouse2"] = true,
	["mouse3"] = true,
	["F1"] = true,
	["F2"] = true,
	["F3"] = true,
	["F4"] = true,
	["F5"] = true,
	["F6"] = true,
	["F7"] = true,
	["F8"] = true,
	["F9"] = true,
	["F10"] = true,
	["F11"] = true,
	["F12"] = true,
	["lshift"] = true, 
	["rshift"] = true,
	["space"] = true,
	["pgdn"] = true,
	["num_div"] = true,
	["num_mul"] = true,
	["num_sub"] = true,
	["num_add"] = true,
	["num_enter"] = true,
	["num_sub"] = true,
	["escape"] = true,
	["insert"] = true,
	["home"] = true,
	["delete"] = true,
	["end"] = true,
	["pgup"] = true,
	["scroll"] = true,
	["pause"] = true,
	["ralt"] = true,
    ["enter"] = true,
    ["mouse_wheel_down"] = true,
    ["mouse_wheel_up"] = true,
    ["capslock"] = true,
    ["arrow_u"] = true,
    ["arrow_d"] = true,
    ["arrow_l"] = true,
    ["arrow_r"] = true,
}

premiumCategories = {
    {name = "Étel & Ital", items = {
        {id = 76, price = 30, count = 1, value = 1}, 
    
    
        {id = 2, price = 5, count = 1, value = 1},    
        {id = 6, price = 5, count = 1, value = 1},    
        {id = 8, price = 2, count = 1, value = 1},    
        {id = 12, price = 2, count = 1, value = 1},    
        {id = 22, price = 1, count = 1, value = 1},    
    }},
    {name = "Fegyverek", items = {
        -- Lőszerek
        {id = 45, price = 200, count = 50, value = 1},    
        {id = 46, price = 100, count = 5, value = 1},    
        {id = 47, price = 100, count = 25, value = 1},    
        {id = 48, price = 100, count = 25, value = 1},    
        {id = 49, price = 100, count = 5, value = 1},    

        {id = 27, price = 5000, count = 1, value = 100},
        {id = 28, price = 6000, count = 1, value = 100},
        {id = 29, price = 4500, count = 1, value = 1},    
        {id = 30, price = 4000, count = 1, value = 100},
        {id = 32, price = 3000, count = 1, value = 1},    
        {id = 34, price = 5000, count = 1, value = 100},    
        {id = 35, price = 6000, count = 1, value = 100},
        --{id = 37, price = 7000, count = 1, value = 100},    
        {id = 38, price = 8000, count = 1, value = 100},    
        {id = 39, price = 6000, count = 1, value = 100},    
        {id = 40, price = 5000, count = 1, value = 100},    
        {id = 42, price = 5500, count = 1, value = 100},  

        -- skines fegyverek
        {id = 27, price = 9000, count = 1, value = 2}, 
        {id = 27, price = 9500, count = 1, value = 3}, 
        {id = 27, price = 9500, count = 1, value = 4}, 
        {id = 27, price = 10000, count = 1, value = 5}, 
        {id = 27, price = 11000, count = 1, value = 6}, 
        {id = 27, price = 9500, count = 1, value = 7}, 
        {id = 27, price = 8000, count = 1, value = 8}, 
        
        {id = 28, price = 9700, count = 1, value = 2}, 
        {id = 28, price = 9500, count = 1, value = 3}, 
        {id = 28, price = 9900, count = 1, value = 4}, 
        {id = 28, price = 10000, count = 1, value = 5}, 
        {id = 28, price = 9500, count = 1, value = 6}, 
        {id = 28, price = 11000, count = 1, value = 7}, 
        {id = 28, price = 8700, count = 1, value = 8}, 
        {id = 28, price = 8000, count = 1, value = 9}, 
    
        {id = 30, price = 6000, count = 1, value = 2}, 
        {id = 30, price = 8000, count = 1, value = 3}, 
        {id = 30, price = 7000, count = 1, value = 4}, 
    
        {id = 32, price = 4700, count = 1, value = 2}, 
        {id = 32, price = 4500, count = 1, value = 3}, 
        {id = 32, price = 4000, count = 1, value = 4}, 
        {id = 32, price = 5000, count = 1, value = 5}, 
        {id = 32, price = 4900, count = 1, value = 6}, 
        {id = 32, price = 5500, count = 1, value = 7}, 
    
        {id = 38, price = 12000, count = 1, value = 2}, 
        {id = 38, price = 11000, count = 1, value = 3}, 
    
        {id = 39, price = 6500, count = 1, value = 2}, 
        {id = 39, price = 6700, count = 1, value = 3}, 
        {id = 39, price = 6400, count = 1, value = 4}, 
        {id = 39, price = 7500, count = 1, value = 5}, 
        {id = 39, price = 8000, count = 1, value = 6}, 
        {id = 39, price = 7900, count = 1, value = 7}, 
        {id = 39, price = 7500, count = 1, value = 8}, 
        {id = 39, price = 6500, count = 1, value = 9}, 
        {id = 39, price = 8200, count = 1, value = 10}, 
    
        {id = 40, price = 6400, count = 1, value = 2}, 
        {id = 40, price = 6500, count = 1, value = 3}, 
        {id = 40, price = 7300, count = 1, value = 4}, 
        {id = 40, price = 7500, count = 1, value = 5}, 
    
        {id = 42, price = 6300, count = 1, value = 2}, 
        {id = 42, price = 6200, count = 1, value = 3}, 
        {id = 42, price = 7300, count = 1, value = 4}, 
        {id = 42, price = 7000, count = 1, value = 5}, 
    }},
    {name = "Egyéb itemek", items = { -- 94, 104, 101, 
        -- Prémium kártyák
        {id = 82, price = 500, count = 1, value = 1},    
        {id = 89, price = 500, count = 1, value = 1},    
        {id = 90, price = 750, count = 1, value = 1},    
        {id = 91, price = 500, count = 1, value = 1}, 
        {id = 115, price = 1500, count = 1, value = 1}, 

        -- Mesyterkönyvek
        {id = 117, price = 4500, count = 1, value = 1}, 
        {id = 118, price = 5000, count = 1, value = 1}, 
        {id = 119, price = 3500, count = 1, value = 1}, 
        {id = 120, price = 4000, count = 1, value = 1}, 
        {id = 121, price = 3000, count = 1, value = 1}, 
        {id = 122, price = 3200, count = 1, value = 1}, 
        {id = 123, price = 3500, count = 1, value = 1}, 
        {id = 125, price = 4000, count = 1, value = 1}, 
        {id = 126, price = 5000, count = 1, value = 1}, 

        -- drogok
        {id = 55, price = 200, count = 1, value = 1},    
        {id = 56, price = 200, count = 1, value = 1},    
        {id = 57, price = 200, count = 1, value = 1},    
        {id = 58, price = 150, count = 1, value = 1},   

        -- egyebek
        {id = 94, price = 500, count = 1, value = 1},
        {id = 101, price = 700, count = 1, value = 1},
        {id = 104, price = 750, count = 1, value = 1},
    }},
    {name = "Pénz", items = {
        -- icon (png), price (pp) count ($)
        {icon = "4", price = 1000, count = 32000},    
        {icon = "5", price = 2500, count = 80000},    
        {icon = "6", price = 5000, count = 160000},    
        {icon = "2", price = 10000, count = 320000},    
        {icon = "3", price = 20000, count = 640000},    
        {icon = "1", price = 30000, count = 1000000},    
    }},
    {name = "Csomagok", items = {

    }},
}

premiumItemPackages = { 
-- állatos csomag: prémium kutyatáp 25 db 90%
-- földes csomag: prémium föld 25db 90%
    {name = "Colt-45 csomag", price = 6100, items = {
        {id = 37, count = 1, value = 100},
        {id = 47, count = 75},
        {id = 123, count = 1, value = 1},

    }},

    {name = "Desert Eagle csomag", price = 7400, items = {
        {id = 30, count = 1, value = 100},
        {id = 47, count = 75},
        {id = 125, count = 1, value = 1},
    }},

    {name = "Shotgun csomag", price = 8500, items = {
        {id = 34, count = 1, value = 100},
        {id = 46, count = 75},
        {id = 121, count = 1, value = 1},

    }},

    {name = "Lefűrészelt csövő puska csomag", price = 9600, items = {
        {id = 35, count = 1, value = 100},
        {id = 46, count = 75},
        {id = 122, count = 1, value = 1},

    }},

    {name = "UZI csomag", price = 7900, items = {
        {id = 40, count = 1, value = 100},
        {id = 48, count = 75},
        {id = 119, count = 1, value = 1},
    }},

    {name = "TEC9 csomag", price = 8100, items = {
        {id = 42, count = 1, value = 100},
        {id = 48, count = 75},
        {id = 119, count = 1, value = 1},
    }},

    {name = "P90 csomag", price = 9200, items = {
        {id = 39, count = 1, value = 100},
        {id = 48, count = 75},
        {id = 120, count = 1, value = 1},
    }},

    {name = "AK-47 csomag", price = 8800, items = {
        {id = 27, count = 1, value = 100},
        {id = 45, count = 75},
        {id = 117, count = 1, value = 1},
    }},

    {name = "M4 csomag", price = 10100, items = {
        {id = 28, count = 1, value = 100},
        {id = 45, count = 75},
        {id = 118, count = 1, value = 1},
    }},

    {name = "Mesterlövész csomag", price = 11900, items = {
        {id = 38, count = 1, value = 100},
        {id = 49, count = 75},
        {id = 126, count = 1, value = 1},
    }},

    {name = "Kiskedvenc csomag", price = 11000, items = {
        {id = 94, count = 25},
    }},

    {name = "Kertész csomag", price = 16500, items = {
        {id = 104, count = 25},
    }},
}

premiumInfos = {
    {title = "Prémium Pont Vásárlásának Módjai", texts = {
        --serverColor.."SMS: #ffffffLehetőség van támogatni a szervert emelt díjas SMS-sel.",
        serverColor.."PayPal: #ffffffLehetőség van a szerver PayPalon keresztül történő támogatására.",
    }},

    {title = "Mit vásárolhatsz prémium pontból?", texts = {
        serverColor.."Prémium itemek: #ffffffA prémium shop kínálatából vásárolhatsz itemeket, akár csomagok formájában is.",
        serverColor.."Játékbeli dollár: #ffffffA prémium shop kínálatából vásárolhatsz különböző pénzcsomagokat.",
        serverColor.."Slotok: #ffffffLehetőséged van a "..serverColor.."'Vagyon' #ffffff fülön ingatlan vagy jármű slot vásárlására.",
        serverColor.."Járműbolt: #ffffffVásárolhatsz prémium pontért járműveket, ekkor az autókereskedés a limitet nem",
        "veszi figyelembe. Csak prémium  pontért elérhető autókat is találhatsz az autóbolt kínálatában.",
        serverColor.."Kapu: #ffffffLehetőséged van kapu vásárlására, melynek árát fórumon megtekintheted. ",
        serverColor.."(forum.originalrp.eu) #ffffffA kapuk lerakását "..serverColor.."SzuperAdmin#ffffff vagy "..serverColor.."ServerManager#ffffff végzi.",
        serverColor.."Amennyiben a listán nem látod azt amit szeretnél, akkor keress fel egy vezetőségi tagot!",
    }},

    {title = "Prémium Pont Csomagok", texts = {
        serverColor.."1000PP #ffffff> 990Ft",
        serverColor.."3500PP #ffffff> 2490Ft", 
        serverColor.."6000PP #ffffff> 4990Ft", 
        serverColor.."12000PP #ffffff> 9500Ft",
        serverColor.."24000PP #ffffff> 18900Ft",

        --"#eb4034Az üzenetben az originalrp és KarakterID között egy szóköz szükséges!",
    }},

    {title = "Prémium Pont vásárlásával kapcsolatos információk", texts = {
        serverColor.."https://originalrp.eu/docs/pp.pdf",

    }},
}

custom_keys = {
    ["["] = "ő",
    ["]"] = "ú",
    ["="] = "ó",
    ["/"] = "ü",
    ["'"] = "ö",
    ["#"] = "á",
    [";"] = "é",
    ["\\"] = "ű",
}

adminTags = {"Adminsegéd", "Adminisztrátor 1", "Adminisztrátor 2", "Adminisztrátor 3", "Adminisztrátor 4", "Adminisztrátor 5", "FőAdmin", "AdminController", "Server Manager", "Fejlesztő", "Tulajdonos"}

function spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

function tableContains(table, element)
    for _, value in pairs(table) do
      if value == element then
        return true
      end
    end
    return false
  end


tuning_categories = {"Alap", "Verseny", "Profi", "Prémium"}

fightingStyles = {4, 5, 6, 15, 16}
walkingStyles = {0, 54, 55, 56, 118, 119, 120, 121, 122, 123, 124, 126, 128, 129, 130, 131, 132, 133, 134, 135, 137}

fuelTypes = {
    ["95"] = "Benzin",
    ["D"] = "Dízel",
    ["electric"] = "Elektromos",
}

dailyGifts = {
    ["small"] = {
        {"PP", 10, "Prémium pont", "files/daily/pp.png"},
        {"$", 2500, "Készpénz", "files/daily/dollar.png"},
        {"CC", 2000, "CasinoCoin", "files/daily/cc.png"},
        {"PP", 25, "Prémium pont", "files/daily/pp.png"},
        {"$", 4000, "Készpénz", "files/daily/dollar.png"},
        {"CC", 1000, "CasinoCoin", "files/daily/cc.png"},
        {"PP", 5, "Prémium pont", "files/daily/pp.png"},
        {"$", 5000, "Készpénz", "files/daily/dollar.png"},
        {"CC", 500, "CasinoCoin", "files/daily/cc.png"},

        {"item", 1, "Gyógyszer", exports.oInventory:getItemImage(76), item = 76},
        {"item", 1, "Vitamin", exports.oInventory:getItemImage(150), item = 150},
        {"item", 1, "Béka", exports.oInventory:getItemImage(135), item = 135},
        {"item", 1, "Béka", exports.oInventory:getItemImage(2), item = 2},
        {"item", 1, "Béka", exports.oInventory:getItemImage(3), item = 3},
        {"item", 1, "Béka", exports.oInventory:getItemImage(4), item = 4},
        {"item", 1, "Béka", exports.oInventory:getItemImage(5), item = 5},
        {"item", 1, "Béka", exports.oInventory:getItemImage(6), item = 6},
        {"item", 1, "Béka", exports.oInventory:getItemImage(7), item = 7},
        {"item", 1, "Béka", exports.oInventory:getItemImage(8), item = 8},
        {"item", 1, "Béka", exports.oInventory:getItemImage(9), item = 9},
        {"item", 1, "Béka", exports.oInventory:getItemImage(10), item = 10},
        {"item", 1, "Béka", exports.oInventory:getItemImage(11), item = 11},
        {"item", 1, "Béka", exports.oInventory:getItemImage(12), item = 12},
        {"item", 1, "Béka", exports.oInventory:getItemImage(13), item = 13},
        {"item", 1, "Béka", exports.oInventory:getItemImage(14), item = 14},
        {"item", 1, "Béka", exports.oInventory:getItemImage(15), item = 15},
        {"item", 1, "Béka", exports.oInventory:getItemImage(16), item = 16},
        {"item", 1, "Béka", exports.oInventory:getItemImage(17), item = 17},
        {"item", 1, "Béka", exports.oInventory:getItemImage(18), item = 18},
        {"item", 1, "Béka", exports.oInventory:getItemImage(19), item = 19},
        {"item", 1, "Béka", exports.oInventory:getItemImage(20), item = 20},
        {"item", 1, "Béka", exports.oInventory:getItemImage(21), item = 21},
        {"item", 1, "Béka", exports.oInventory:getItemImage(22), item = 22},
        {"item", 1, "Béka", exports.oInventory:getItemImage(23), item = 23},
        {"item", 1, "Béka", exports.oInventory:getItemImage(24), item = 24},
        {"item", 1, "Béka", exports.oInventory:getItemImage(25), item = 25},
        {"item", 1, "Béka", exports.oInventory:getItemImage(26), item = 26},
    },

    ["big"] = {
        {"vehicleSlot", 1, "Jármű slot", "files/daily/car.png"},
        {"interiorSlot", 1, "Ingatlan slot", "files/daily/house.png"},
        {"item", 1, "Fix kártya", exports.oInventory:getItemImage(90), item = 90},
        {"item", 1, "Instant tankolás kártya", exports.oInventory:getItemImage(91), item = 91},
        {"item", 1, "Instant gyógyítás kártya", exports.oInventory:getItemImage(89), item = 89},
        {"item", 1, "Unflip kártya", exports.oInventory:getItemImage(82), item = 82},
        {"item", 1, "Díszes váza", exports.oInventory:getItemImage(186), item = 186},
        {"item", 1, "Rubin", exports.oInventory:getItemImage(195), item = 195},
        {"item", 1, "Smaragdt", exports.oInventory:getItemImage(196), item = 196},
        {"item", 1, "Zafír", exports.oInventory:getItemImage(197), item = 197},
        {"item", 1, "Borostyánkő", exports.oInventory:getItemImage(198), item = 198},
    },
}

function getTimestamp(year, month, day, hour, minute, second)
    -- initiate variables
    local monthseconds = { 2678400, 2419200, 2678400, 2592000, 2678400, 2592000, 2678400, 2678400, 2592000, 2678400, 2592000, 2678400 }
    local timestamp = 0
    local datetime = getRealTime()
    year, month, day = year or datetime.year + 1900, month or datetime.month + 1, day or datetime.monthday
    hour, minute, second = hour or datetime.hour, minute or datetime.minute, second or datetime.second
    
    -- calculate timestamp
    for i=1970, year-1 do timestamp = timestamp + (isLeapYear(i) and 31622400 or 31536000) end
    for i=1, month-1 do timestamp = timestamp + ((isLeapYear(year) and i == 2) and 2505600 or monthseconds[i]) end
    timestamp = timestamp + 86400 * (day - 1) + 3600 * hour + 60 * minute + second
    
    timestamp = timestamp - 3600 --GMT+1 compensation
    if datetime.isdst then timestamp = timestamp - 3600 end
    
    return timestamp
end

function isLeapYear(year)
    if year then year = math.floor(year)
    else year = getRealTime().year + 1900 end
    return ((year % 4 == 0 and year % 100 ~= 0) or year % 400 == 0)
end


-- CREATE
-- gift item felépítése 
-- {item = (item id/0), rarity = (1:COMMON, 2:RARE, 3:EPIC, 4:LEGENDARY), money = (pénz/pp/ingatlan slot/jármű slot), type = (1:item, 2:dollár, 3:pp, 4:ingatlan slot, 5:jármű slot), itemvalue = (item value pl. skines fegyvernél skin)}


-- legolcsóbbtól kicsit olcsóbb kivéve mesterkönyv
creates = {
    {name = "REBOOT BOX", price = 0, money_type = "$", icon = "reboot", specialtag = "REBOOT", tagcolor = {247, 60, 47}, expire = 1673218740, gifts = {
        {item = 89, rarity = 3, money = 0, type = 1, itemvalue = 1},
        {item = 90, rarity = 3, money = 0, type = 1, itemvalue = 1},
        {item = 91, rarity = 3, money = 0, type = 1, itemvalue = 1},
        {item = 32, rarity = 4, money = 0, type = 1, itemvalue = 2},
        {item = 115, rarity = 4, money = 0, type = 1, itemvalue = 1},
        {item = 119, rarity = 4, money = 0, type = 1, itemvalue = 1},
        {item = 122, rarity = 4, money = 0, type = 1, itemvalue = 1},
        {item = 135, rarity = 2, money = 0, type = 1, itemvalue = 1},
        {item = 81, rarity = 1, money = 0, type = 1, itemvalue = 1},
        {item = 43, rarity = 2, money = 0, type = 1, itemvalue = 1},
        {item = 200, rarity = 2, money = 0, type = 1, itemvalue = 1},
        {item = 150, rarity = 1, money = 0, type = 1, itemvalue = 1},
        {item = 157, rarity = 1, money = 0, type = 1, itemvalue = 1},
        {item = 104, rarity = 2, money = 0, type = 1, itemvalue = 1},
        {item = 94, rarity = 2, money = 0, type = 1, itemvalue = 1},

        {item = 243, rarity = 2, money = 0, type = 1, itemvalue = 1},
        {item = 244, rarity = 2, money = 0, type = 1, itemvalue = 1},
        {item = 245, rarity = 2, money = 0, type = 1, itemvalue = 1},
        {item = 246, rarity = 2, money = 0, type = 1, itemvalue = 1},
        {item = 247, rarity = 2, money = 0, type = 1, itemvalue = 1},

        {item = 0, rarity = 1, money = 6000, type = 2, itemvalue = 1},
        {item = 0, rarity = 2, money = 12000, type = 2, itemvalue = 1},
        {item = 0, rarity = 3, money = 24000, type = 2, itemvalue = 1},
        {item = 0, rarity = 4, money = 40000, type = 2, itemvalue = 1},

        {item = 0, rarity = 1, money = 100, type = 3, itemvalue = 1},
        {item = 0, rarity = 2, money = 500, type = 3, itemvalue = 1},
        {item = 0, rarity = 3, money = 1000, type = 3, itemvalue = 1},
        {item = 0, rarity = 4, money = 2500, type = 3, itemvalue = 1},
    }},

    {name = "GOLDEN CASE", price = 9000, money_type = "$", icon = "gold", specialtag = "", tagcolor = {247, 60, 47}, gifts = {
        {item = 27, rarity = 3, money = 0, type = 1, itemvalue = 6},
        {item = 27, rarity = 3, money = 0, type = 1, itemvalue = 5},
        {item = 28, rarity = 4, money = 0, type = 1, itemvalue = 5},
        {item = 30, rarity = 2, money = 0, type = 1, itemvalue = 3},
        {item = 40, rarity = 1, money = 0, type = 1, itemvalue = 4},
        {item = 42, rarity = 1, money = 0, type = 1, itemvalue = 4},
    }},

    {name = "WINTER CASE", price = 9500, money_type = "$", icon = "winter", specialtag = "", tagcolor = {247, 60, 47}, gifts = {
        {item = 27, rarity = 3, money = 0, type = 1, itemvalue = 2},
        {item = 28, rarity = 3, money = 0, type = 1, itemvalue = 3},
        {item = 28, rarity = 2, money = 0, type = 1, itemvalue = 6},
        {item = 39, rarity = 3, money = 0, type = 1, itemvalue = 3},
        {item = 40, rarity = 1, money = 0, type = 1, itemvalue = 5},
        {item = 42, rarity = 1, money = 0, type = 1, itemvalue = 5},
        {item = 38, rarity = 4, money = 0, type = 1, itemvalue = 2},
    }},

    {name = "PINK CASE", price = 7500, money_type = "$", icon = "pink", specialtag = "", tagcolor = {247, 60, 47}, gifts = {
        {item = 27, rarity = 3, money = 0, type = 1, itemvalue = 7},
        {item = 28, rarity = 4, money = 0, type = 1, itemvalue = 7},
        {item = 30, rarity = 2, money = 0, type = 1, itemvalue = 4},
        {item = 119, rarity = 1, money = 0, type = 1, itemvalue = 1},
        {item = 123, rarity = 1, money = 0, type = 1, itemvalue = 1},
    }},

    {name = "MESTERKÖNYVEK", price = 4500, money_type = "$", icon = "mesterkonyvek", specialtag = "", tagcolor = {247, 60, 47}, gifts = {
        {item = 117, rarity = 3, money = 0, type = 1, itemvalue = 1},
        {item = 118, rarity = 4, money = 0, type = 1, itemvalue = 1},
        {item = 119, rarity = 3, money = 0, type = 1, itemvalue = 1},
        {item = 120, rarity = 3, money = 0, type = 1, itemvalue = 1},
        {item = 121, rarity = 2, money = 0, type = 1, itemvalue = 1},
        {item = 122, rarity = 2, money = 0, type = 1, itemvalue = 1},
        {item = 123, rarity = 1, money = 0, type = 1, itemvalue = 1},
        {item = 125, rarity = 4, money = 0, type = 1, itemvalue = 1},
        {item = 126, rarity = 4, money = 0, type = 1, itemvalue = 1},
    }},

    {name = "KNIFE CASE", price = 5000, money_type = "$", icon = "knives", specialtag = "", tagcolor = {247, 60, 47}, gifts = {
        {item = 32, rarity = 1, money = 0, type = 1, itemvalue = 1},
        {item = 32, rarity = 2, money = 0, type = 1, itemvalue = 2},
        {item = 32, rarity = 2, money = 0, type = 1, itemvalue = 3},
        {item = 32, rarity = 2, money = 0, type = 1, itemvalue = 4},
        {item = 32, rarity = 4, money = 0, type = 1, itemvalue = 5},
        {item = 32, rarity = 3, money = 0, type = 1, itemvalue = 6},
        {item = 32, rarity = 3, money = 0, type = 1, itemvalue = 7},
    }},

}

dailyBoxRewards = {
    ["normal"] = {
        {item = 2, rarity = 1, money = 0, type = 1, itemvalue = 1},
        {item = 88, rarity = 1, money = 0, type = 1, itemvalue = 1},
        {item = 13, rarity = 1, money = 0, type = 1, itemvalue = 1},
        {item = 18, rarity = 1, money = 0, type = 1, itemvalue = 1},
        {item = 22, rarity = 1, money = 0, type = 1, itemvalue = 1},
        {item = 212, rarity = 2, money = 0, type = 1, itemvalue = 1},
        {item = 214, rarity = 2, money = 0, type = 1, itemvalue = 1},
        {item = 159, rarity = 2, money = 0, type = 1, itemvalue = 1},
        {item = 76, rarity = 3, money = 0, type = 1, itemvalue = 1},
        {item = 135, rarity = 4, money = 0, type = 1, itemvalue = 1},
        {item = 195, rarity = 4, money = 0, type = 1, itemvalue = 1},
        {item = 0, rarity = 2, money = 3000, type = 2, itemvalue = 1},
        {item = 0, rarity = 3, money = 5000, type = 2, itemvalue = 1},
        {item = 0, rarity = 4, money = 7500, type = 2, itemvalue = 1},
        {item = 0, rarity = 3, money = 70, type = 3, itemvalue = 1},
        {item = 0, rarity = 4, money = 120, type = 3, itemvalue = 1},
        {item = 95, rarity = 1, money = 0, type = 1, itemvalue = 1},
        {item = 97, rarity = 1, money = 0, type = 1, itemvalue = 1},
        {item = 103, rarity = 1, money = 0, type = 1, itemvalue = 1},
        {item = 236, rarity = 3, money = 0, type = 1, itemvalue = 1},
        {item = 237, rarity = 3, money = 0, type = 1, itemvalue = 1},
    },

    ["super"] = {
        {item = 188, rarity = 1, money = 0, type = 1, itemvalue = 1},
        {item = 186, rarity = 1, money = 0, type = 1, itemvalue = 1},
        {item = 196, rarity = 1, money = 0, type = 1, itemvalue = 1},
        {item = 31, rarity = 1, money = 0, type = 1, itemvalue = 1},
        {item = 89, rarity = 2, money = 0, type = 1, itemvalue = 1},
        {item = 90, rarity = 3, money = 0, type = 1, itemvalue = 1},
        {item = 82, rarity = 3, money = 0, type = 1, itemvalue = 1},
        {item = 91, rarity = 2, money = 0, type = 1, itemvalue = 1},
        {item = 0, rarity = 1, money = 4000, type = 2, itemvalue = 1},
        {item = 0, rarity = 2, money = 7500, type = 2, itemvalue = 1},
        {item = 0, rarity = 3, money = 15000, type = 2, itemvalue = 1},
        {item = 0, rarity = 4, money = 30000, type = 2, itemvalue = 1},
        {item = 0, rarity = 1, money = 70, type = 3, itemvalue = 1},
        {item = 0, rarity = 2, money = 120, type = 3, itemvalue = 1},
        {item = 0, rarity = 3, money = 200, type = 3, itemvalue = 1},
        {item = 0, rarity = 4, money = 800, type = 3, itemvalue = 1},
        {item = 0, rarity = 4, money = 1, type = 4, itemvalue = 1}, -- ingatlan slot
        {item = 0, rarity = 4, money = 1, type = 5, itemvalue = 1}, -- jármű slot
        {item = 94, rarity = 1, money = 0, type = 1, itemvalue = 1},
        {item = 104, rarity = 1, money = 0, type = 1, itemvalue = 1},
        {item = 236, rarity = 2, money = 0, type = 1, itemvalue = 1},
        {item = 237, rarity = 2, money = 0, type = 1, itemvalue = 1},
    },
}

function getTimestamp(year, month, day, hour, minute, second)
    -- initiate variables
    local monthseconds = { 2678400, 2419200, 2678400, 2592000, 2678400, 2592000, 2678400, 2678400, 2592000, 2678400, 2592000, 2678400 }
    local timestamp = 0
    local datetime = getRealTime()
    year, month, day = year or datetime.year + 1900, month or datetime.month + 1, day or datetime.monthday
    hour, minute, second = hour or datetime.hour, minute or datetime.minute, second or datetime.second
    
    -- calculate timestamp
    for i=1970, year-1 do timestamp = timestamp + (isLeapYear(i) and 31622400 or 31536000) end
    for i=1, month-1 do timestamp = timestamp + ((isLeapYear(year) and i == 2) and 2505600 or monthseconds[i]) end
    timestamp = timestamp + 86400 * (day - 1) + 3600 * hour + 60 * minute + second
    
    timestamp = timestamp - 3600 --GMT+1 compensation
    if datetime.isdst then timestamp = timestamp - 3600 end
    
    return timestamp
end