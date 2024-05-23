tuning_poses = {
   {2483.7600097656, -2395.9025878906, 13.625, 150},
   {2476.4597167969, -2389.2490234375, 13.625, 150},
}

cmarker = exports.oCustomMarker
font = exports.oFont
core = exports.oCore
infobox = exports.oInfobox
color, r, g, b = core:getServerColor()

usedScripts = {"oCustomMarker", "oCore", "oFont", "oVehicle", "oTuning", "oInfobox"}

tuning_modifiers = {
    ["engine-1"] = {{"engineAcceleration", 0.6}, {"maxVelocity", 9.5}},
    ["engine-2"] = {{"engineAcceleration", 0.6*2}, {"maxVelocity", 9.5*2}},
    ["engine-3"] = {{"engineAcceleration", 0.6*3}, {"maxVelocity", 9.5*3}},
    ["engine-4"] = {{"engineAcceleration", 0.61*4}, {"maxVelocity", 9.5*4}},

    ["gear-1"] = {{"maxVelocity", 6}},
    ["gear-2"] = {{"maxVelocity", 6*2}},
    ["gear-3"] = {{"maxVelocity", 6*3}},
    ["gear-4"] = {{"maxVelocity", 6*4}},

    ["brake-1"] = {{"brakeDeceleration", 0.02}, {"brakeBias", 0.08}},
    ["brake-2"] = {{"brakeDeceleration", 0.02*2}, {"brakeBias", 0.08*2}},
    ["brake-3"] = {{"brakeDeceleration", 0.02*3}, {"brakeBias", 0.08*3}},
    ["brake-4"] = {{"brakeDeceleration", 0.02*4}, {"brakeBias", 0.08*4}},

    ["turbo-1"] = {{"engineAcceleration", 0.6}},
    ["turbo-2"] = {{"engineAcceleration", 0.6*2}},
    ["turbo-3"] = {{"engineAcceleration", 0.6*3}},
    ["turbo-4"] = {{"engineAcceleration", 0.6*4}},

    ["wheel-1"] = {{"tractionMultiplier", 0.05}, {"tractionLoss", 0.02}},
    ["wheel-2"] = {{"tractionMultiplier", 0.05*2}, {"tractionLoss", 0.02*2}},
    ["wheel-3"] = {{"tractionMultiplier", 0.05*3}, {"tractionLoss", 0.02*3}},
    ["wheel-4"] = {{"tractionMultiplier", 0.05*4}, {"tractionLoss", 0.02*4}},

    ["ecu-1"] = {{"dragCoeff", -0.2}},
    ["ecu-2"] = {{"dragCoeff", -0.2*2}},
    ["ecu-3"] = {{"dragCoeff", -0.2*3}},
    ["ecu-4"] = {{"dragCoeff", -0.2*4}},

    ["wloss-1"] = {{"maxVelocity", 5}},
    ["wloss-2"] = {{"maxVelocity", 10}},
    ["wloss-3"] = {{"maxVelocity", 13}},
    ["wloss-4"] = {{"maxVelocity", 22}},

    ["driveType-fwd"] = {{"driveType", "fwd"}},
    ["driveType-rwd"] = {{"driveType", "rwd"}},
    ["driveType-awd"] = {{"driveType", "awd"}},
}

camRotations = {
    ["wheel_lf_dummy"] = {1, 1, 0, 2, 0.3, 0},
    ["bonnet_dummy"] = {-0.5, -4, 0, -1, -4, -0.5},
    ["bump_front_dummy"] = {2, -4, 0, 2, -3, -0.5},
    ["bump_rear_dummy"] = {-2, 5, 0, -1.5, 3, -0.5},
    ["door_lf_dummy"] = {2, 1, 0, 2, 0.3, 0}
}

tunings = {
    {title = "Teljesítmény tuning", icon = "engine", tunings = {
        {title = "Motor", icon = "engine", options = {
            {title = "Alap", icon = "engine", price = {1, 9000}, tuningID = "engine-1"},
            {title = "Verseny", icon = "engine", price = {1, 15000}, tuningID = "engine-2"},
            {title = "Profi", icon = "engine", price = {1, 35000}, tuningID = "engine-3"},
            {title = "Prémium", icon = "premium", price = {2, 750}, tuningID = "engine-4"},
        }, component = "bonnet_dummy", toogleNeeded = true},

        {title = "Váltó", icon = "gear", options = {
            {title = "Alap", icon = "gear", price = {1, 9000}, tuningID = "gear-1"},
            {title = "Verseny", icon = "gear", price = {1, 15000}, tuningID = "gear-2"},
            {title = "Profi", icon = "gear", price = {1, 35000}, tuningID = "gear-3"},
            {title = "Prémium", icon = "premium", price = {2, 750}, tuningID = "gear-4"},
        }, component = "bonnet_dummy", toogleNeeded = true, disabledForMotors = true},

        {title = "Fékek", icon = "brake", options = {
            {title = "Alap", icon = "brake", price = {1, 7500}, tuningID = "brake-1"},
            {title = "Verseny", icon = "brake", price = {1, 12500}, tuningID = "brake-2"},
            {title = "Profi", icon = "brake", price = {1, 23500}, tuningID = "brake-3"},
            {title = "Prémium", icon = "premium", price = {2, 750}, tuningID = "brake-4"},
        }, component = "wheel_lf_dummy", toogleNeeded = true},

        {title = "Turbó", icon = "turbo", options = {
            {title = "Alap", icon = "turbo", price = {1, 12000}, tuningID = "turbo-1"},
            {title = "Verseny", icon = "turbo", price = {1, 25000}, tuningID = "turbo-2"},
            {title = "Profi", icon = "turbo", price = {1, 45000}, tuningID = "turbo-3"},
            {title = "Prémium", icon = "premium", price = {2, 800}, tuningID = "turbo-4"},
        }, component = "bonnet_dummy", toogleNeeded = true, disabledForMotors = true},

        {title = "ECU", icon = "ecu", options = {
            {title = "Alap", icon = "ecu", price = {1, 12000}, tuningID = "ecu-1"},
            {title = "Verseny", icon = "ecu", price = {1, 25000}, tuningID = "ecu-2"},
            {title = "Profi", icon = "ecu", price = {1, 45000}, tuningID = "ecu-3"},
            {title = "Prémium", icon = "premium", price = {2, 800}, tuningID = "ecu-4"},
        }, component = "bonnet_dummy", disabledForMotors = true},

        {title = "Súlycsökkentés", icon = "weight", options = {
            {title = "Alap", icon = "weight", price = {1, 9000}, tuningID = "wloss-1"},
            {title = "Verseny", icon = "weight", price = {1, 15000}, tuningID = "wloss-2"},
            {title = "Profi", icon = "weight", price = {1, 35000}, tuningID = "wloss-3"},
            {title = "Prémium", icon = "premium", price = {2, 750}, tuningID = "wloss-4"},
        }, component = "bonnet_dummy", disabledForMotors = true},

        {title = "Kerék fordulás", icon = "wheel", options = {
            {title = "Alap", icon = "wheel", price = {1, 7500}, tuningID = "wheel-1"},
            {title = "Verseny", icon = "wheel", price = {1, 12500}, tuningID = "wheel-2"},
            {title = "Profi", icon = "wheel", price = {1, 33000}, tuningID = "wheel-3"},
            {title = "Prémium", icon = "premium", price = {2, 700}, tuningID = "wheel-4"},
        }, component = "wheel_lf_dummy", disabledForMotors = true},
    },},

    {title = "Optikai tuning", icon = "paint", tunings = {
        {title = "Fényezés", icon = "paint", options = {
            {title = "Szín 1", icon = "paint", price = {1, 20000}},
            {title = "Szín 2", icon = "paint", price = {1, 15000}},
            {title = "Szín 3", icon = "paint", price = {1, 10000}},
            {title = "Szín 4", icon = "paint", price = {1, 5000}},
            {title = "Fényszóró", icon = "lamp", price = {1, 17500}},
        },},

        {title = "Kerekek", icon = "wheel", options = {
            {title = "Gyári", icon = "wheel", price = {1, 0}, upID = 0},
            {title = "Kerék 1", icon = "wheel", price = {1, 20000}, upID = 1025},
            {title = "Kerék 2", icon = "wheel", price = {1, 20000}, upID = 1073},
            {title = "Kerék 3", icon = "wheel", price = {1, 20000}, upID = 1074},
            {title = "Kerék 4", icon = "wheel", price = {1, 20000}, upID = 1075},
            {title = "Kerék 5", icon = "wheel", price = {1, 20000}, upID = 1076},
            {title = "Kerék 6", icon = "wheel", price = {1, 20000}, upID = 1077},
            {title = "Kerék 7", icon = "wheel", price = {1, 20000}, upID = 1078},
            {title = "Kerék 8", icon = "wheel", price = {1, 20000}, upID = 1079},
            {title = "Kerék 9", icon = "wheel", price = {1, 20000}, upID = 1080},
            {title = "Kerék 10", icon = "wheel", price = {1, 20000}, upID = 1081},
            {title = "Kerék 11", icon = "wheel", price = {1, 20000}, upID = 1082},
            {title = "Kerék 12", icon = "wheel", price = {1, 20000}, upID = 1083},
            {title = "Kerék 13", icon = "wheel", price = {1, 20000}, upID = 1084},
            {title = "Kerék 14", icon = "wheel", price = {1, 20000}, upID = 1085},
            {title = "Kerék 15", icon = "wheel", price = {1, 20000}, upID = 1096},
            {title = "Kerék 16", icon = "wheel", price = {1, 20000}, upID = 1097},
            {title = "Kerék 17", icon = "wheel", price = {1, 20000}, upID = 1098},
        }, component = "wheel_lf_dummy", toogleNeeded = true},

        {title = "Kipufogó", icon = "exhaust", isCustomTuning = true, customTuningID = "exhaust", component = "bump_rear_dummy"},
        {title = "Motorháztető", icon = "roof", isCustomTuning = true, customTuningID = "roof", component = "bonnet_dummy", toogleNeeded = false},
        {title = "Küszöb", icon = "logo", isCustomTuning = true, customTuningID = "skirt"},
        --{title = "Spoiler", icon = "spoiler", isCustomTuning = true, customTuningID = "spoiler"},
        {title = "Spoiler", icon = "spoiler", options = {
            {title = "Nincs", icon = "spoiler", price = {1, 0}, upID = 0},
            {title = "Spoiler 1", icon = "spoiler", price = {1, 20000}, upID = 1000},
            {title = "Spoiler 2", icon = "spoiler", price = {1, 20000}, upID = 1001},
            {title = "Spoiler 3", icon = "spoiler", price = {1, 20000}, upID = 1002},
            {title = "Spoiler 4", icon = "spoiler", price = {1, 20000}, upID = 1003},
            {title = "Spoiler 5", icon = "spoiler", price = {1, 20000}, upID = 1014},
            {title = "Spoiler 6", icon = "spoiler", price = {1, 20000}, upID = 1015},
            {title = "Spoiler 7", icon = "spoiler", price = {1, 20000}, upID = 1016},
            {title = "Spoiler 8", icon = "spoiler", price = {1, 20000}, upID = 1023},
            {title = "Spoiler 9", icon = "spoiler", price = {1, 20000}, upID = 1049},
            {title = "Spoiler 10", icon = "spoiler", price = {1, 20000}, upID = 1050},
            {title = "Spoiler 11", icon = "spoiler", price = {1, 20000}, upID = 1058},
            {title = "Spoiler 12", icon = "spoiler", price = {1, 20000}, upID = 1060},
            {title = "Spoiler 13", icon = "spoiler", price = {1, 20000}, upID = 1138},
            {title = "Spoiler 14", icon = "spoiler", price = {1, 20000}, upID = 1139},
            {title = "Spoiler 15", icon = "spoiler", price = {1, 20000}, upID = 1146},
            {title = "Spoiler 16", icon = "spoiler", price = {1, 20000}, upID = 1147},
            {title = "Spoiler 17", icon = "spoiler", price = {1, 20000}, upID = 1158},
            {title = "Spoiler 18", icon = "spoiler", price = {1, 20000}, upID = 1162},
            {title = "Spoiler 19", icon = "spoiler", price = {1, 20000}, upID = 1163},
            {title = "Spoiler 20", icon = "spoiler", price = {1, 20000}, upID = 1164},
        }, component = "bump_rear_dummy"},

        {title = "Első lökhárító", icon = "bumper", isCustomTuning = true, customTuningID = "front_bumper", component = "bump_front_dummy"},
        {title = "Hátsó lökhárító", icon = "bumper", isCustomTuning = true, customTuningID = "rear_bumper", component = "bump_rear_dummy"},
        {title = "Matricák", icon = "sticker", isCustomTuning = true, customTuningID = "paintjob"},

        {title = "Neon", icon = "neon", options = {
            {title = "Nincs", icon = "neon", price = {1, 0}, upID = 0},
            {title = "Piros", icon = "neon", price = {2, 250}, upID = 1},
            {title = "Kék", icon = "neon", price = {2, 250}, upID = 2},
            {title = "Zöld", icon = "neon", price = {2, 250}, upID = 3},
            {title = "Sárga", icon = "neon", price = {2, 250}, upID = 4},
            {title = "Rózsaszín", icon = "neon", price = {2, 250}, upID = 5},
            {title = "Fehér", icon = "neon", price = {2, 250}, upID = 6},
            {title = "Jég kék", icon = "neon", price = {2, 250}, upID = 7},
            {title = "Világoskék", icon = "neon", price = {2, 250}, upID = 8},
            {title = "Narancssárga", icon = "neon", price = {2, 250}, upID = 9},
            {title = "Szivárvány", icon = "neon", price = {2, 300}, upID = 10},
        }},
    },},

    {title = "Egyéb", icon = "logo", tunings = {
        {title = "Meghajtás", icon = "drive_all", options = {
            {title = "Elsőkerék", icon = "drive_front", price = {1, 7500}, tuningID = "driveType-fwd"},
            {title = "Hátsókerék", icon = "drive_back", price = {1, 7500}, tuningID = "driveType-rwd"},
            {title = "Összkerék", icon = "drive_all", price = {1, 12500}, tuningID = "driveType-awd"},
        },},

        {title = "Airride", icon = "logo", options = {
            {title = "Kiszerelve", icon = "logo", price = {1, 0}, upID = 0},
            {title = "Beszerelve", icon = "logo", price = {2, 1500}, upID = 1},
        },},

        {title = "Variáns", icon = "variant", options = {
            {title = "Nincs", icon = "variant", price = {1, 0}, upID = {255, 255}},
            {title = "1", icon = "variant", price = {2, 1500}, upID = {0, 255}},
            {title = "2", icon = "variant", price = {2, 1500}, upID = {1, 255}},
            {title = "3", icon = "variant", price = {2, 1500}, upID = {2, 255}},
            {title = "4", icon = "variant", price = {2, 1500}, upID = {3, 255}},
            {title = "5", icon = "variant", price = {2, 1500}, upID = {4, 255}},
            {title = "6", icon = "variant", price = {2, 1500}, upID = {5, 255}},
        },},

        {title = "Egyedi duda", icon = "horn", options = {
            {title = "Nincs", icon = "horn", price = {1, 0}, upID = 0},
            {title = "Party", icon = "horn", price = {1, 12000}, upID = 1},
            {title = "Party 2", icon = "horn", price = {1, 10000}, upID = 2},
            {title = "Loud", icon = "horn", price = {1, 5000}, upID = 3},
            {title = "Cow", icon = "horn", price = {2, 500}, upID = 4},
            {title = "Bycicle", icon = "horn", price = {1, 10000}, upID = 5},
            {title = "Horn 6x", icon = "horn", price = {1, 12500}, upID = 6},
            {title = "Horn 7x", icon = "horn", price = {2, 200}, upID = 7},
            {title = "Bycicle 2", icon = "horn", price = {1, 6000}, upID = 8},
            {title = "Horn 9x", icon = "horn", price = {2, 200}, upID = 9},
            {title = "Horn 10x", icon = "horn", price = {2, 200}, upID = 10},
            {title = "Horn 11x", icon = "horn", price = {2, 200}, upID = 11},
            {title = "Horn 12x", icon = "horn", price = {2, 200}, upID = 12},
            {title = "Horn 13x", icon = "horn", price = {2, 200}, upID = 13},
            {title = "Turck", icon = "horn", price = {1, 6500}, upID = 14},
        },},

        {title = "Supercharger", icon = "supercharger", isCustomTuning = true, customTuningID = "supercharger", component = "bonnet_dummy"},

        {title = "Egyedi rendszám", icon = "plate"},

        {title = "Első kerék szélesítés", icon = "width", options = {
            {title = "Extra Vékony", icon = "width", price = {2, 1500}, wheelScale = "verynarrow", scale = "front"},
            {title = "Vékony", icon = "width", price = {2, 1500}, wheelScale = "narrow", scale = "front"},
            {title = "Alap", icon = "width", price = {1, 0}, wheelScale = "default", scale = "front"},
            {title = "Széles", icon = "width", price = {2, 1500}, wheelScale = "wide", scale = "front"},
            {title = "Extra Széles", icon = "width", price = {2, 1500}, wheelScale = "verywide", scale = "front"},
        }, component = "bump_front_dummy"},

        {title = "Hátsó kerék szélesítés", icon = "width", options = {
            {title = "Extra Vékony", icon = "width", price = {2, 1500}, wheelScale = "verynarrow", scale = "rear"},
            {title = "Vékony", icon = "width", price = {2, 1500}, wheelScale = "narrow", scale = "rear"},
            {title = "Alap", icon = "width", price = {1, 0}, wheelScale = "default", scale = "rear"},
            {title = "Széles", icon = "width", price = {2, 1500}, wheelScale = "wide", scale = "rear"},
            {title = "Extra Széles", icon = "width", price = {2, 1500}, wheelScale = "verywide", scale = "rear"},
        }, component = "bump_rear_dummy"},

        --[[{title = "Nitro", icon = "nitro", options = {
            {title = "Kiszerelve", icon = "nitro", price = {1, 0}, upID = 0},
            {title = "Beszerelve", icon = "nitro", price = {2, 7500}, upID = 1},
        },},]]



        --[[{title = "Hidraulika", icon = "logo", options = {
            {title = "Kiszerelve", icon = "logo", price = {1, 0}, upID = 0},
            {title = "Beszerelve", icon = "logo", price = {2, 1500}, upID = 1},
        },},

        {title = "Nitro", icon = "logo", options = {
            {title = "Kiszerelve", icon = "logo", price = {1, 0}, upID = 0},
            {title = "Beszerelve", icon = "logo", price = {2, 1500}, upID = 1},
        },},]]
    },},
}

customTunings = {
    [402] = {
        ["supercharger"] = {
            {title = "Nincs", icon = "supercharger", price = {1, 0}, upID = false},
            {title = "Beszerelve", icon = "supercharger", price = {2, 2500}, upID = true},
        },
    },

    [526] = {
        ["supercharger"] = {
            {title = "Nincs", icon = "supercharger", price = {1, 0}, upID = false},
            {title = "Beszerelve", icon = "supercharger", price = {2, 2500}, upID = true},
        },
    },

    [562] = {
        ["exhaust"] = {
            {title = "Gyári", icon = "exhaust", price = {1, 0}, upID = 0},
            {title = "Kipufogó 1", icon = "exhaust", price = {1, 20000}, upID = 1034},
            {title = "Kipufogó 2", icon = "exhaust", price = {1, 20000}, upID = 1037},
        },

        ["roof"] = {
            {title = "Gyári", icon = "roof", price = {1, 0}, upID = 0},
            {title = "Motorháztető 1", icon = "roof", price = {1, 20000}, upID = 1035},
            {title = "Motorháztető 2", icon = "roof", price = {1, 20000}, upID = 1038},
        },

        ["skirt"] = {
            {title = "Gyári", icon = "wheel", price = {1, 0}, upID = 0},
            {title = "Küszöb 1", icon = "wheel", price = {1, 20000}, upID = 1036},
            {title = "Küszöb 2", icon = "wheel", price = {1, 20000}, upID = 1039},
            {title = "Küszöb 3", icon = "wheel", price = {1, 20000}, upID = 1040},
            {title = "Küszöb 4", icon = "wheel", price = {1, 20000}, upID = 1041},
        },

        ["spoiler"] = {
            {title = "Gyári", icon = "spoiler", price = {1, 0}, upID = 0},
            {title = "Spoiler 1", icon = "spoiler", price = {1, 20000}, upID = 1146},
            {title = "Spoiler 2", icon = "spoiler", price = {1, 20000}, upID = 1147},
        },

        ["rear_bumper"] = {
            {title = "Gyári", icon = "bumper", price = {1, 0}, upID = 0},
            {title = "Hátsó lökhárító 1", icon = "bumper", price = {1, 20000}, upID = 1148},
            {title = "Hátsó lökhárító 2", icon = "bumper", price = {1, 20000}, upID = 1149},
        },

        ["front_bumper"] = {
            {title = "Gyári", icon = "bumper", price = {1, 0}, upID = 0},
            {title = "Első lökhárító 1", icon = "bumper", price = {1, 20000}, upID = 1171},
            {title = "Első lökhárító 2", icon = "bumper", price = {1, 20000}, upID = 1172},
        },
    },

    [559] = {
        --[[["exhaust"] = {
            {title = "Gyári", icon = "exhaust", price = {1, 0}, upID = 0},
            {title = "Kipufogó 1", icon = "exhaust", price = {1, 20000}, upID = 1065},
            {title = "Kipufogó 2", icon = "exhaust", price = {1, 20000}, upID = 1066},
        },]]

        ["roof"] = {
            {title = "Gyári", icon = "roof", price = {1, 0}, upID = 0},
            {title = "Motorháztető 1", icon = "roof", price = {1, 20000}, upID = 1067},
            {title = "Motorháztető 2", icon = "roof", price = {1, 20000}, upID = 1068},
        },

        ["skirt"] = {
            {title = "Gyári", icon = "wheel", price = {1, 0}, upID = 0},
            {title = "Küszöb 1", icon = "wheel", price = {1, 20000}, upID = 1069},
            {title = "Küszöb 2", icon = "wheel", price = {1, 20000}, upID = 1070},
            {title = "Küszöb 3", icon = "wheel", price = {1, 20000}, upID = 1071},
            {title = "Küszöb 4", icon = "wheel", price = {1, 20000}, upID = 1072},
        },

        ["spoiler"] = {
            {title = "Gyári", icon = "spoiler", price = {1, 0}, upID = 0},
            {title = "Spoiler 1", icon = "spoiler", price = {1, 20000}, upID = 1158},
            {title = "Spoiler 2", icon = "spoiler", price = {1, 20000}, upID = 1162},
        },

        ["rear_bumper"] = {
            {title = "Gyári", icon = "bumper", price = {1, 0}, upID = 0},
            {title = "Hátsó lökhárító 1", icon = "bumper", price = {1, 20000}, upID = 1159},
            {title = "Hátsó lökhárító 2", icon = "bumper", price = {1, 20000}, upID = 1161},
        },

        ["front_bumper"] = {
            {title = "Gyári", icon = "bumper", price = {1, 0}, upID = 0},
            {title = "Első lökhárító 1", icon = "bumper", price = {1, 20000}, upID = 1160},
            {title = "Első lökhárító 2", icon = "bumper", price = {1, 20000}, upID = 1173},
        },

        ["paintjob"] = {
            {title = "Nincs", icon = "paint", price = {1, 0}, upID = 0},
            {title = "Matrica 1", icon = "paint", price = {2, 300}, upID = 1},
            {title = "Matrica 2", icon = "paint", price = {2, 250}, upID = 2},
            {title = "Matrica 3", icon = "paint", price = {2, 300}, upID = 3},
            {title = "Matrica 4", icon = "paint", price = {2, 350}, upID = 4},
            {title = "Matrica 4", icon = "paint", price = {1, 12500}, upID = 5},
        }
    },

    [536] = {
        ["paintjob"] = {
            {title = "Nincs", icon = "paint", price = {1, 0}, upID = 0},
            {title = "Matrica 1", icon = "paint", price = {1, 10000}, upID = 1},
            {title = "Matrica 2", icon = "paint", price = {1, 20000}, upID = 2},
            {title = "Matrica 3", icon = "paint", price = {2, 200}, upID = 3},
            {title = "Matrica 4", icon = "paint", price = {2, 400}, upID = 4},
        }
    },

    [529] = {
        ["paintjob"] = {
            {title = "Nincs", icon = "paint", price = {1, 0}, upID = 0},
            {title = "Matrica 1", icon = "paint", price = {1, 10000}, upID = 1},
            {title = "Matrica 2", icon = "paint", price = {2, 150}, upID = 2},
            {title = "Matrica 3", icon = "paint", price = {2, 200}, upID = 3},
        }
    },

    [604] = {
        ["paintjob"] = {
            {title = "Karosszéria javítása", icon = "paint", price = {1, 35000}, upID = 0},
            {title = "Matrica 1", icon = "paint", price = {1, 60000}, upID = 2},
            {title = "Matrica 2", icon = "paint", price = {2, 1500}, upID = 3},
            {title = "Matrica 3", icon = "paint", price = {2, 1100}, upID = 4},
        }
    },

    [483] = {
        ["paintjob"] = {
            {title = "Nincs", icon = "paint", price = {1, 0}, upID = 0},
            {title = "Matrica 1", icon = "paint", price = {2, 300}, upID = 1},
            {title = "Matrica 2", icon = "paint", price = {2, 300}, upID = 2},
            {title = "Matrica 3", icon = "paint", price = {1, 25000}, upID = 3},
        }
    },

    [540] = {
        ["paintjob"] = {
            {title = "Nincs", icon = "paint", price = {1, 0}, upID = 0},
            {title = "Matrica 1", icon = "paint", price = {1, 15000}, upID = 1},
            {title = "Matrica 2", icon = "paint", price = {2, 500}, upID = 2},
            {title = "Matrica 3", icon = "paint", price = {1, 12500}, upID = 3},
            {title = "Matrica 4", icon = "paint", price = {2, 150}, upID = 4},
        },

        ["supercharger"] = {
            {title = "Nincs", icon = "supercharger", price = {1, 0}, upID = false},
            {title = "Beszerelve", icon = "supercharger", price = {2, 2500}, upID = true},
        },
    },

    [534] = {
        ["exhaust"] = {
            {title = "Gyári", icon = "exhaust", price = {1, 0}, upID = 0},
            {title = "Kipufogó 1", icon = "exhaust", price = {1, 20000}, upID = 1126},
            {title = "Kipufogó 2", icon = "exhaust", price = {1, 20000}, upID = 1127},
        },

        ["roof"] = {
            {title = "Gyári", icon = "roof", price = {1, 0}, upID = 0},
            {title = "Motorháztető 1", icon = "roof", price = {1, 20000}, upID = 1100},
            {title = "Motorháztető 2", icon = "roof", price = {1, 20000}, upID = 1123},
            {title = "Motorháztető 2", icon = "roof", price = {1, 20000}, upID = 1125},
        },

        ["skirt"] = {
            {title = "Gyári", icon = "wheel", price = {1, 0}, upID = 0},
            {title = "Küszöb 1", icon = "wheel", price = {1, 20000}, upID = 1122},
            {title = "Küszöb 2", icon = "wheel", price = {1, 20000}, upID = 1106},
            {title = "Küszöb 3", icon = "wheel", price = {1, 20000}, upID = 1101},
            {title = "Küszöb 4", icon = "wheel", price = {1, 20000}, upID = 1124},
        },

        ["rear_bumper"] = {
            {title = "Gyári", icon = "bumper", price = {1, 0}, upID = 0},
            {title = "Hátsó lökhárító 1", icon = "bumper", price = {1, 20000}, upID = 1180},
            {title = "Hátsó lökhárító 2", icon = "bumper", price = {1, 20000}, upID = 1178},
        },

        ["front_bumper"] = {
            {title = "Gyári", icon = "bumper", price = {1, 0}, upID = 0},
            {title = "Első lökhárító 1", icon = "bumper", price = {1, 20000}, upID = 1179},
            {title = "Első lökhárító 2", icon = "bumper", price = {1, 20000}, upID = 1185},
        },

        ["paintjob"] = {
            {title = "Nincs", icon = "paint", price = {1, 0}, upID = 0},
            {title = "Matrica 1", icon = "paint", price = {2, 400}, upID = 1},
            {title = "Matrica 2", icon = "paint", price = {2, 600}, upID = 2},
            {title = "Matrica 3", icon = "paint", price = {2, 600}, upID = 3},
            {title = "Matrica 4", icon = "paint", price = {1, 10000}, upID = 4},
        },

        ["supercharger"] = {
            {title = "Nincs", icon = "supercharger", price = {1, 0}, upID = false},
            {title = "Beszerelve", icon = "supercharger", price = {2, 2500}, upID = true},
        },
    },

    [480] = {
        ["paintjob"] = {
            {title = "Nincs", icon = "paint", price = {1, 0}, upID = 0},
            {title = "Matrica 1", icon = "paint", price = {1, 10000}, upID = 1},
            {title = "Matrica 2", icon = "paint", price = {1, 20000}, upID = 2},
            {title = "Matrica 3", icon = "paint", price = {2, 200}, upID = 3},
            {title = "Matrica 4", icon = "paint", price = {2, 400}, upID = 4},
            {title = "Matrica 5", icon = "paint", price = {1, 20000}, upID = 5},
            {title = "Matrica 6", icon = "paint", price = {2, 200}, upID = 6},
            {title = "Matrica 7", icon = "paint", price = {2, 400}, upID = 7},
        }
    },

    
    [579] = {
        ["paintjob"] = {
            {title = "Nincs", icon = "paint", price = {1, 0}, upID = 0},
            {title = "Matrica 1", icon = "paint", price = {1, 10000}, upID = 1},
            {title = "Matrica 2", icon = "paint", price = {1, 14500}, upID = 2},
            {title = "Matrica 3", icon = "paint", price = {1, 17500}, upID = 3},
        }
    },

    [479] = {
        ["paintjob"] = {
            {title = "Nincs", icon = "paint", price = {1, 0}, upID = 0},
            {title = "Matrica 1", icon = "paint", price = {2, 250}, upID = 1},
            {title = "Matrica 2", icon = "paint", price = {2, 300}, upID = 2},
            {title = "Matrica 3", icon = "paint", price = {1, 12500}, upID = 3},
            {title = "Matrica 4", icon = "paint", price = {1, 15000}, upID = 4},
            {title = "Matrica 5", icon = "paint", price = {1, 17500}, upID = 5},
            {title = "Matrica 6", icon = "paint", price = {1, 12000}, upID = 6},
            {title = "Matrica 7", icon = "paint", price = {2, 300}, upID = 7},
            {title = "Matrica 8", icon = "paint", price = {2, 400}, upID = 8},
        }
    },

    [445] = {
        ["paintjob"] = {
            {title = "Nincs", icon = "paint", price = {1, 0}, upID = 0},
            {title = "Matrica 1", icon = "paint", price = {1, 15000}, upID = 1},
            {title = "Matrica 2", icon = "paint", price = {2, 300}, upID = 2},
            {title = "Matrica 3", icon = "paint", price = {2, 350}, upID = 3},
            {title = "Matrica 4", icon = "paint", price = {2, 250}, upID = 4},
            {title = "Matrica 5", icon = "paint", price = {2, 400}, upID = 5},
            {title = "Matrica 6", icon = "paint", price = {1, 150000}, upID = 6},
            {title = "Matrica 7", icon = "paint", price = {1, 35000}, upID = 7},
            {title = "Matrica 8", icon = "paint", price = {1, 150000}, upID = 8},
            {title = "Matrica 9", icon = "paint", price = {1, 25000}, upID = 9},
            {title = "Matrica 10", icon = "paint", price = {1, 50000}, upID = 10},
        }
    },
    
    [451] = {
        ["paintjob"] = {
            {title = "Nincs", icon = "paint", price = {1, 0}, upID = 0},
            {title = "Matrica 1", icon = "paint", price = {2, 400}, upID = 1},
            {title = "Matrica 2", icon = "paint", price = {2, 300}, upID = 2},
            {title = "Matrica 3", icon = "paint", price = {2, 250}, upID = 3},
            {title = "Matrica 4", icon = "paint", price = {2, 400}, upID = 4},
        }
    },

    [527] = {
        ["paintjob"] = {
            {title = "Nincs", icon = "paint", price = {1, 0}, upID = 0},
            {title = "Matrica 1", icon = "paint", price = {1, 15000}, upID = 1},
            {title = "Matrica 2", icon = "paint", price = {2, 350}, upID = 2},
            {title = "Matrica 3", icon = "paint", price = {2, 350}, upID = 3},
            {title = "Matrica 4", icon = "paint", price = {2, 300}, upID = 4},
        },

        ["supercharger"] = {
            {title = "Nincs", icon = "supercharger", price = {1, 0}, upID = false},
            {title = "Beszerelve", icon = "supercharger", price = {2, 2500}, upID = true},
        },
    },

    [411] = {
        ["paintjob"] = {
            {title = "Nincs", icon = "paint", price = {1, 0}, upID = 0},
            {title = "Matrica 1", icon = "paint", price = {1, 150000}, upID = 1},
        }
    },

    [602] = {
        ["paintjob"] = {
            {title = "Nincs", icon = "paint", price = {1, 0}, upID = 0},
            {title = "Matrica 1", icon = "paint", price = {1, 150000}, upID = 1},
            {title = "Matrica 2", icon = "paint", price = {1, 75000}, upID = 2},
            {title = "Matrica 3", icon = "paint", price = {1, 50000}, upID = 3},
        }
    },

    [560] = {
        ["exhaust"] = {
            {title = "Gyári", icon = "exhaust", price = {1, 0}, upID = 0},
            {title = "Kipufogó 1", icon = "exhaust", price = {1, 20000}, upID = 1028},
            {title = "Kipufogó 2", icon = "exhaust", price = {1, 20000}, upID = 1029},
        },

        ["roof"] = {
            {title = "Gyári", icon = "roof", price = {1, 0}, upID = 0},
            {title = "Motorháztető 1", icon = "roof", price = {1, 20000}, upID = 1032},
            {title = "Motorháztető 2", icon = "roof", price = {1, 20000}, upID = 1033},
        },

        ["skirt"] = {
            {title = "Gyári", icon = "wheel", price = {1, 0}, upID = 0},
            {title = "Küszöb 1", icon = "wheel", price = {1, 20000}, upID = 1026},
            {title = "Küszöb 2", icon = "wheel", price = {1, 20000}, upID = 1031},
            {title = "Küszöb 3", icon = "wheel", price = {1, 20000}, upID = 1027},
            {title = "Küszöb 4", icon = "wheel", price = {1, 20000}, upID = 1030},
        },

        ["rear_bumper"] = {
            {title = "Gyári", icon = "bumper", price = {1, 0}, upID = 0},
            {title = "Hátsó lökhárító 1", icon = "bumper", price = {1, 20000}, upID = 1141},
            {title = "Hátsó lökhárító 2", icon = "bumper", price = {1, 20000}, upID = 1140},
        },

        ["front_bumper"] = {
            {title = "Gyári", icon = "bumper", price = {1, 0}, upID = 0},
            {title = "Első lökhárító 1", icon = "bumper", price = {1, 20000}, upID = 1169},
            {title = "Első lökhárító 2", icon = "bumper", price = {1, 20000}, upID = 1170},
        },

        ["paintjob"] = {
            {title = "Nincs", icon = "paint", price = {1, 0}, upID = 0},
            {title = "Matrica 1", icon = "paint", price = {2, 200}, upID = 1},
            {title = "Matrica 2", icon = "paint", price = {2, 400}, upID = 2},
            {title = "Matrica 3", icon = "paint", price = {2, 300}, upID = 3},
            {title = "Matrica 4", icon = "paint", price = {2, 200}, upID = 4},
        }
        
    },
}

keysHelp = {
    {"Backspace", "Visszalépés"},
    {"Enter", "Továbblépés"},
    {"Nyilak", "Navigálás"},
}

toggledControlls = {"enter_exit", "vehicle_left", "vehicle_right", "accelerate", "brake_reverse", "vehicle_mouse_look"}

priceTypes = {"char:money", "char:pp"}

disallowedPlateTexts = {"asd", "see", "mta", "external", "szar", "fos", "szerver", "fasz", ".hu", ".com", ".eu", "flymta", "geci", "kurva", "hl", "buzi"}

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