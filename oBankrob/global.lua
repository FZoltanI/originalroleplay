--[[securitys = {
    
    -- Pult mögött
    {pos = Vector3(1316.7962646484, -1331.9437255859, 13.800000190735), rot = 2, name = "Jackson Jhonson", skin = 71, weapon = 24},

    -- Széfterem előtt
    {pos = Vector3(1283.9315185547, -1331.3154296875, 9.1192922592163), rot = 350, name = "Jackson Jhonson", skin = 71, weapon = 25},
    {pos = Vector3(1273.8026123047, -1322.4708251953, 9.1125001907349), rot = 89, name = "Jackson Jhonson", skin = 71, weapon = 25},
    {pos = Vector3(1263.9580078125, -1335.115234375, 9.1125001907349), rot = 265, name = "Jackson Jhonson", skin = 71, weapon = 25},
}

doors = {
    -- Pult melletti ajtók
    {pos = Vector3(1300.05, -1332.4537597656, 12.8), rot = 180, openRot = 50, objID = 1495},
    {pos = Vector3(1315.55, -1332.4537597656, 12.8), rot = 180, openRot = 270, objID = 1495},
}]]

core = exports.oCore
color, r, g, b = core:getServerColor()
infobox = exports.oInfobox

robStartNeededPoliceCount = 3

bankElements = {
    ["palomino"] = {
        -- {"type", pos, rot, modelID, {interactionTypes}, interactedValue, iconPositions},

        ["door"] = {
            {3109, {2316.35, 0.82238471508026, 26.65}, {0, 0, 90}, {"saw", "lockpick"}, 60, {-1.3, 0, 0.2}},
        },

        ["safe"] = {
            {2332, {2312.05, -10.9, 26.1421875}, {0, 0, 270}, {"drill"}, 0, {-0.3, -0.15, 0.2}},
            {2332, {2305.701171875, -10.493295669556, 26.1421875}, {0, 0, 90}, {"drill"}, 180, {0.3, 0.15, 0.2}},
            {2332, {2305.701171875, -5.263295669556, 26.1421875}, {0, 0, 90}, {"drill"}, 180, {0.3, 0.15, 0.2}},
        },

        ["security_gate"] = {
            {1892, {2304.4875488281, -15.7, 25.7421875}, {0, 0, 270}, {}, 0, {0.15, -0.5, 1}},
        },

        ["wall_1"] = {{9491, {2306.9, -6.7, 27.5}, {0, 0, 90}, {}, 0, {0.15, -0.5, 1}}},
        ["wall_2"] = {{9491, {2310.1, -6.7, 27.5}, {0, 0, 90}, {}, 0, {0.15, -0.5, 1}}},
        ["wall_3"] = {{10863, {2312.5, -6.7, 27.5}, {0, 0, 90}, {}, 0, {0.15, -0.5, 1}}},
        ["wall_4"] = {{9762, {2314.9, -6.7, 27.5}, {0, 0, 90}, {}, 0, {0.15, -0.5, 1}}},
        ["wall_5"] = {{9491, {2318.1, -6.7, 27.5}, {0, 0, 90}, {}, 0, {0.15, -0.5, 1}}},
        ["wall_6"] = {{10863, {2320.5, -6.7, 27.5}, {0, 0, 90}, {}, 0, {0.15, -0.5, 1}}},

        ["wall_7"] = {{9491, {2316.9, -5, 27.5}, {0, 0, 0}, {}, 0, {0.15, -0.5, 1}}},
        ["wall_8"] = {{9491, {2316.9, -1.8, 27.5}, {0, 0, 0}, {}, 0, {0.15, -0.5, 1}}},
        ["wall_9"] = {{10863, {2316.89, 0, 27.5}, {0, 0, 0}, {}, 0, {0.15, -0.5, 1}}},

        ["door_1"] = {{1502, {2314.11, -6.6920385360718, 25.7421875}, {0, 0, 0}, {}, 0, {0.15, -0.5, 1}}},

        ["alarm"] = {{1502, {2310.3725585938, -9.1315212249756, 32.53125}, {0, 0, 0}, {}, 0, {0.15, -0.5, 1}}},
    },


    ["market_ls"] = {
        ["wall_bomb"] = {{18310, {1685.7998, -1186.2998, 33.33}, {0, 0, 0}, {"bomb"}, 0, {-1, -13.5, -12.5}}},
        
        ["alarm"] = {{1502, {1687.1727294922, -1186.2037353516, 30.49680519104}, {0, 0, 0}, {}, 0, {0.15, -0.5, 1}}},

        ["door_1"] = {
            {18299, {1671.92, -1200.6, 18.9}, {0, 0, 180}, {"saw"}, 60, {1.3, 0, 1.5}},
        },

        ["door_2"] = {
            {18299, {1674.71, -1175.56, 22.82}, {0, 0, 270}, {"saw", "lockpick"}, 60, {0, 1.4, 1.5}},
        },

        ["safe_door"] = {
            {17143, {1676.9, -1196.525, 20.8}, {0, 0, 0}, {}, -60, {0, -0.8, -2}},
        },

        ["energy_cable"] = {
            {927, {1527.0611572266, -1195.3620605469, 23.858321762085}, {0, 0, 270}, {"pliers"}, 0, {0, 0, 0.3}},
        },
    }
}

lsBankSafeElements = {
    ["safe"] = {
        {2332, {1677.5745849609,-1191.3959960938,19.292501831055}, {0, 0, 90}, {"drill"}, 200, {0.3, 0, 0.2}},
        {2332, {1677.5743408203,-1197.1219482422,19.292501831055}, {0, 0, 90}, {"drill"}, 200, {0.3, 0.15, 0.2}},
    },

    ["safe_2"] = {
        {2332, {1689.8614501953,-1190.4267578125,19.292501831055}, {0, 0, 270}, {"drill"}, 200, {0.3, 0, 0.2}},
        --{2332, {1253.8862304688, -1328.6756591797, 8.65}, {0, 0, 90}, {"drill"}, 200, {0.3, 0.15, 0.2}},
        {2332, {1689.8637695312,-1198.3227539062,19.292501831055}, {0, 0, 270}, {"drill"}, 200, {-0.3, 0.15, 0.2}},
    },

    ["money_bag_1"] = {
        {1550, {1687.6999511719,-1195.8605224609,19.292501831055}, {0, 0, 332}, {"pickup"}, 0, {0, 0, 0}},
        {1550, {1689.8634033203,-1192.5582275391,19.292501831055}, {0, 0, 41}, {"pickup"}, 0, {0, 0, 0}},
    },

    ["money_bag_2"] = {
        {1550, {1682.25390625,-1189.9013671875,19.292501831055}, {0, 0, 91}, {"pickup"}, 0, {0, 0, 0}},
    },

    ["goldbar_1"] = {
        {17080, {1680.98,-1192.15,20.01}, {0, 0, 0}, {"pickup"}, 0, {-0.25, -0.5, 0.2}},
        {18294, {1680.98,-1192.15,20.01}, {0, 0, 0}, {"pickup"}, 0, {-0.25, -0.5, 0.2}},

        {17080, {1684.48,-1196.3,20.01}, {0, 0, 0}, {"pickup"}, 0, {-0.25, -0.5, 0.2}},
        {18294, {1684.48,-1196.3,20.01}, {0, 0, 0}, {"pickup"}, 0, {-0.25, -0.5, 0.2}},
    },

    ["goldbar_2"] = {
        {17080, {1680.98,-1196.3,20.01}, {0, 0, 0}, {"pickup"}, 0, {-0.25, -0.5, 0.2}},
        {18294, {1680.98,-1196.3,20.01}, {0, 0, 0}, {"pickup"}, 0, {-0.25, -0.5, 0.2}},

        {17080, {1687.96,-1192.15,20.01}, {0, 0, 0}, {"pickup"}, 0, {-0.25, -0.5, 0.2}},
        {18294, {1687.96,-1192.15,20.01}, {0, 0, 0}, {"pickup"}, 0, {-0.25, -0.5, 0.2}},
    },

    ["goldbar_4"] = {
        {17080, {1687.96,-1196.3,20.01}, {0, 0, 0}, {"pickup"}, 0, {-0.25, -0.5, 0.2}},
        {18294, {1687.96,-1196.3,20.01}, {0, 0, 0}, {"pickup"}, 0, {-0.25, -0.5, 0.2}},
    },

    ["goldbar_5"] = {
        {17080, {1684.48,-1192.15,20.01}, {0, 0, 0}, {"pickup"}, 0, {-0.25, -0.5, 0.2}},
        {18294, {1684.48,-1192.15,20.01}, {0, 0, 0}, {"pickup"}, 0, {-0.25, -0.5, 0.2}},
    },
}

illegalItems = {27, 28, 29, 30, 34, 35, 37, 38, 39, 40, 41, 42, 70, 169, 170}

bankNames = {
    ["palomino"] = "Bank of Palomino Creek",
    ["market_ls"] = "Bank of San Andreas",
}

bigSafeLasers = {
    {1679.7680664063, -1189.5012451172, 19.892501831055, 1679.7680664063, -1200, 19.892501831055},
    {1679.7680664063, -1189.5012451172, 20.892501831055, 1679.7680664063, -1200, 20.892501831055},
    {1679.7680664063, -1189.5012451172, 21.892501831055, 1679.7680664063, -1200, 21.892501831055},

    {1685.7680664063, -1189.5012451172, 19.892501831055, 1685.7680664063, -1200, 19.892501831055},
    {1685.7680664063, -1189.5012451172, 20.892501831055, 1685.7680664063, -1200, 20.892501831055},
    {1685.7680664063, -1189.5012451172, 21.892501831055, 1685.7680664063, -1200, 21.892501831055},

    {1690.5, -1198.1903076172, 19.892501831055,  1677, -1198.1903076172, 19.892501831055},
    {1690.5, -1198.1903076172, 20.892501831055,  1677, -1198.1903076172, 20.892501831055},
    {1690.5, -1198.1903076172, 21.892501831055,  1677, -1198.1903076172, 21.892501831055},

    {1690.5, -1191.1903076172, 19.892501831055,  1677, -1191.1903076172, 19.892501831055},
    {1690.5, -1191.1903076172, 20.892501831055,  1677, -1191.1903076172, 20.892501831055},
    {1690.5, -1191.1903076172, 21.892501831055,  1677, -1191.1903076172, 21.892501831055},
}

bigSafeSirenStart = 180 -- Def: 180

function createRandomCode()
    local code = ""

    for i = 1, 5 do 
        code = code .. math.random(0, 9)
    end

    return code
end

-- / Mission /
missionTexts = {
    ["beforeMission"] = {
        ["name"] = "Mindenek előtt...",
        ["start"] = "Beszélj Jackel, a térképen megjelölt helyen.",
    },

    ["startMission"] = {
        ["name"] = "Egy új ismeretség kezdete...",
        ["start"] = "Beszélj Jackel, a térképen megjelölt helyen. És add át neki a 15.000$-t.",
    },

    ["talkWithKlara"] = {
        ["name"] = "Ki vagy te, Klara?",
        ["start"] = "Beszélj Klraraval, a térképen megjelölt helyen. Ő majd elmondja, hogy mire kell figyelni a bankban.",
    },
}

missionCameraPositions = {
    ["beforeMission_jack"] = {1467.5858154297,350.49499511719,19.588499069214,1468.4818115234,350.9352722168,19.531499862671},
    ["startMission_jack"] = {2472.4523925781,-1774.0977783203,14.088800430298,2472.4558105469,-1773.0988769531,14.135898590088},
    ["talkWithKlara"] = {1116.0743408203,-1091.8464355469,26.931699752808,1115.0921630859,-1091.8966064453,26.750825881958},
}

missionTalks = {
    ["beforeMission_jack"] = {
        "Csá tesa.",
        "Úgy hallottam készültök valami nagy dologra, a Los Santos Bank környékén...",
        "Segítek neked, viszont nem ingyen.",
        "15.000$-t kérek a segítségemért cserébe.",
        "Ha kell a segítség, és benne vagy az üzletbe, akkor majd hívj fel.",
        "Most pedig tünés. Nem ismerjük egymást, és sosem beszéltünk. Csá.",
    },

    ["startMission_jack"] = {
        "Csá újra.",
        "Na, akkor megvan amit kértem?",
        "Remek. Akkor mondom mit kell tenned...",
        "... a városban van egy ismerősöm, úgy hívják, hogy Klara.",
        "Beszélj vele. Ő majd elmondja, hogy mire kell figyelni a bankban.",
        "Ha mindennel megvagy, amit mond, akkor majd találkozunk.",
        "Sok sikert. Ha esetleg elkapnának a zsaruk, akkor rólam egy szót se szólj.",
        "Pá tesa.",
    },

    ["talkWithKlara"] = {
        "Szia. Ezek szerint rólad bezért Jack. Nem tűnsz valami profinak...",
        "... mindegy is.",
        "A bankban egy nagyon fejlett két részből álló biztonsági rendszer van.",
        "Elsőnek a széf kezelő asztalához kell eljutnod, ami a széfterem előtt van.",
        "Ahhoz, hogy ide ejuss minimum két ajtót kell feltörni. Ha ügyetlen vagy, akkor még idáig sem jutsz el...",
        "Második lépésben be kell írni egy kódot a széf nyitásához. Ha hibás a kód, akkor bekapcsol a riasztó.",
        "Ha a széf nyitva, még akkor is van mitől félni, de arról majd csak később.",
        "Biztos meg akarod csinálni?",
        "???",
        "Letelt az idő. Most már nem szálhatsz ki!",
        "Menj és nézz szét a bankba. Nézd meg azokat a dolgokat amiről beszéltem és csinálj pár képet.",
        "Lehetőleg ne b@zd el már itt az elején.",
        "Szia.",
    },
}

idg_jackPositions = {
    {2454.4682617188, -1901.9626464844, 13.546875, 353},
    {2438.4377441406, -1894.9343261719, 13.553356170654, 269},
    {2478.0056152344, -1901.9698486328, 13.546875, 357},
    {2519.3264160156, -1965.4665527344, 13.542709350586, 270},
    {2494.96875, -1978.2731933594, 13.433652877808, 176},
    {2441.6665039063, -1962.7121582031, 13.546875, 180},
    {2440.1455078125, -1975.6633300781, 13.546875, 270},
    {2447.3518066406, -1981.6437988281, 13.546875, 0},
}