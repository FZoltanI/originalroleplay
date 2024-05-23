preview = exports.oPreview
core = exports.oCore
color, r, g, b = core:getServerColor()
font = exports.oFont
inventory = exports.oInventory
infobox = exports.oInfobox

menuPoints = {
    {"Személyi Igazolvány kiváltása", 50},
    {"Vezetői Engedély kiváltása", 100},
    {"Horgászengedély kiváltása", 500},
    --{"Üres adásvételi", 100},
}

peds = {
    {"James Roseberry", "Okmányiroda", Vector3(1475.3232421875,-1778.0532226562,25.5234375), 270, 147},
    --{"Ricardo Walker", "Okmányiroda", Vector3(1435.8953857422, -1817.4754638672, 14.5703125), 0, 57},
}

cardOptions = {
    { -- Személyi
        {"Név", "name"},
        {"Életkor", "age"},
        {"Neme", "sex"}, --
        {"Állampolgárság", "nationality"},
        {"Kiállítás dátuma", "createDate"}, --
        {"Érvényes", "expiryDate"}, --
    },

    { -- Vezetői engedély
        {"Név", "name"},
        {"Életkor", "age"}, --
        {"Állampolgárság", "nationality"},
        {"Engedély típusa", "l_type"},
        {"Kiállítás dátuma", "createDate"}, --
        {"Érvényes", "expiryDate"}, --
    },

    { -- fegyvertartási engedély
        {"Név", "name"}, --
        {"Kiállító szerv", "faction"}, --
        {"Engedély", "l_type"},
        {"Kiállítás dátuma", "createDate"}, --
        {"Érvényes", "expiryDate"}, --
    },

    { -- vadászati engedély
        {"Név", "name"}, --
        {"Kiállító szerv", "faction"}, --
        {"Engedély", "l_type"},
        {"Kiállítás dátuma", "createDate"}, --
        {"Érvényes", "expiryDate"}, --
    },

    { -- forglami
        {"VEHICLE TYPE", "veh_type"},
        {"PLATE TEXT", "plate_text"},
        {"VEHICLE NAME", "vehicle_name"},
        {"COLOR", "vehicle_colors"},
        {"ENGINE TUNINGS", "engine_tunings"},
        {"OTHER TUNINGS", "other_tunings"},
        {"OWNER", "owner_name"},
        {"DATE OF EXPIRY", "expiry_date"},
    },

    { -- horgász engedély
        {"Név", "name"},
        {"Életkor", "age"},
        {"Kiállító szerv", "faction"}, --
        {"Terület", "fishingarea"},
        {"Kiállítás dátuma", "createDate"}, --
        {"Érvényes", "expiryDate"}, --
    },
}

engine_tunings = {"Motor", "Sebességváltó", "Fék", "Turbó", "Kerék", "ECU", "Súlycsökkentés"}

colors = {"#bb5710", "#1067ad", "#ac2110", "#6cb30f" ,_, "#16b190"}
