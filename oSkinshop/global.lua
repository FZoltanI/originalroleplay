core = exports.oCore
color, r, g, b = core:getServerColor()
info = exports.oInfobox
dashboard = exports.oDashboard

skinshops = {
        -- {név, int, dim, skins, elado {skin,x,y,z,rot}}
    {"Victim", 5, 3, 
        {
            --{skin id, money, x, y, z, rot}
            {2, 250, 214.94157409668, -3.522362947464, 1001.2109375, 187},
            {7, 200, 219.72929382324, -4.3907089233398, 1001.2109375, 85},
            {9, 200, 219.34219360352, -12.817681312561, 1001.2109375, 3},
            {12, 150, 214.5228729248, -12.819253921509, 1001.2109375, 3},
            {13, 200, 211.13819885254, -12.82079410553, 1001.2109375, 3},
            {14, 180, 206.94081115723, -3.5236961841583, 1005.2109375, 178},
            {16, 180, 208.23529052734, -12.818222045898, 1005.2109375, 355},
            {19, 200, 204.25889587402, -9.7865133285522, 1005.2109375, 268},
            {21, 188, 204.25836181641, -6.6134257316589, 1005.2109375, 268},
            {32, 200, 210.35415649414, -12.820506095886, 1005.2109375, 0},
            {60, 150, 205.78921508789, -12.819574356079, 1005.2109375, 0},
            {83, 173, 209.72186279297, -3.5233976840973, 1005.2109375, 180},
            {84, 180, 204.2568359375, -4.309901714325, 1005.2109375, 270},
            {87, 195, 204.25032043457, -5.7025675773621, 1001.2109375, 270},
            --{92, 270, 204.24922180176, -10.56188583374, 1001.2109375, 270},
            {187, 200, 217.44734191895, -6.5392026901245, 1001.2109375, 270},
            {25, 100, 217.44912719727, -11.573831558228, 1001.2109375, 270},
            {216, 210, 211.64640808105, -6.2397475242615, 1001.2109375, 90},
            {231, 85, 212.25840759277, -10.630850791931, 1001.2109375, 360},
        },
        {91,204.85375976563, -8.2301549911499, 1001.2109375,269},
    },

    {"ZIP", 3, 1, 
        {
            --{skin id, money, x, y, z, rot}
            {23, 135, 197.12049865723, -134.5007019043, 1003.5078125, 270},
            {25, 170, 198.37286376953, -138.02905273438, 1003.5151977539, 313},
            {26, 200,  200.02317810059, -139.02784545898, 1003.5078125, 0},
            {27, 150, 202.35856628418, -139.02807617188, 1003.5078125, 0},
            {72, 200, 204.41114807129, -140.14717102051, 1003.5078125, 0},
            {80, 180, 209.33508300781, -140.1471862793, 1003.5151977539, 0},
            {81, 180, 211.86999511719, -139.11111450195, 1003.5078125, 0},
            {123, 200, 215.35682678223, -139.04048156738, 1003.5078125, 0},
            {147, 188, 217.10818725586, -134.76704406738, 1003.5151977539, 90},
            {170, 200, 217.10963439941, -131.16931152344, 1003.5151977539, 90},
            {186, 150, 215.08068847656, -126.36038970947, 1003.5078125, 180},
            {230, 173,  210.6826171875, -126.97982788086, 1003.5151977539, 180},
            {234, 180,  204.4561920166, -126.48434448242, 1003.5078125, 180},
            {17, 195, 203.78099060059, -130.06803894043, 1003.5078125, 270},
            {40, 270, 200.55027770996, -131.00746154785, 1003.5078125, 180},
            --{51, 200, 197.36933898926, -131.00726318359, 1003.5078125, 180},
            {56, 100, 203.98867797852, -134.68580627441, 1002.8671875, 218},
            {91, 210, 200.34004211426, -135.62121582031, 1002.8743896484, 60},
            {93, 85, 210.40466308594, -133.97972106934, 1002.8671875, 99},
            {193, 85,  216.60632324219, -132.86038208008, 1003.5078125, 90},
        },
        {27,207.09507751465, -127.80680847168, 1003.5078125,180},
    },

    {"Binco", 15, 4, 
        {
            --{skin id, money, x, y, z, rot}
            {15, 135, 212.50764465332, -95.124053955078, 1005.2578125, 180},
            {20, 170, 202.7202911377, -95.124099731445, 1005.2578125, 180},
            {22, 200,   200.45263671875, -96.772392272949, 1005.2578125, 270},
            {24, 150, 200.48239135742, -99.518653869629, 1005.2578125, 270},
            {29, 200, 200.48561096191, -102.18352508545, 1005.2578125, 270},
            {30, 180, 200.50607299805, -105.27601623535, 1005.1328125, 270},
            {35, 180, 200.52401733398, -109.32926940918, 1005.1328125, 270},
            {44, 200, 200.52284240723, -107.45676422119, 1005.1328125, 270},
            {66, 188, 214.8084564209, -105.4331817627, 1005.1328125, 90},
            {67, 200, 214.80708312988, -107.79953765869, 1005.1328125, 90},
            {82, 150, 214.74963378906, -110.75579833984, 1005.1328125, 90},
            {90, 173, 212.40000915527, -112.53078460693, 1005.2578125, 0},
            {182, 180, 210.47784423828, -110.92185974121, 1005.1328125, 0},
            {183, 195, 204.43295288086, -110.91924285889, 1005.1328125, 0},
            {206, 270,  202.84568786621, -112.52194976807, 1005.2578125, 0},
            {210, 200, 214.74812316895, -103.72365570068, 1005.2578125, 90},
            {10, 100, 217.59268188477, -102.72636413574, 1005.2578125, 360},
            {18, 210, 217.9271697998, -100.60350036621, 1005.2578125, 90},
            {19, 85,  216.05212402344, -97.755615234375, 1005.2578125, 180},
            {148, 90,  210.59718322754, -103.08365631104, 1005.2578125, 0},
            {190, 85,  204.99388122559, -103.08657073975, 1005.2578125, 0},
            {191, 105,  208.75601196289, -107.59132385254, 1005.1328125, 90},
            {192, 170,   206.47218322754, -107.80644226074, 1005.140625, 270},
            {195, 160,  209.91084289551, -96.95866394043, 1005.2578125, 180},
        },
        {148,207.67976379395, -98.705490112305, 1005.2578125,180},
    },

    {"Pláza - Binco", 0, 0, 
        {
            --{skin id, money, x, y, z, rot}
            {15, 135,697.23480224609, -1345.0620117188, 20.710962295532, 270},
            {31, 170, 696.25457763672, -1345.0476074219, 20.710962295532, 80},
            {33, 200, 696.71063232422, -1345.8560791016, 20.710962295532, 180},
            {24, 150, 696.73278808594, -1344.2222900391, 20.710962295532, 0},
            {29, 300,697.74731445312, -1349.1684570312, 21.007837295532, 90},
            {28, 290, 703.03259277344, -1348.95703125, 21.015581130981, 270},
            {23, 135, 692.13348388672, -1345.0520019531, 20.710962295532, 270},
            {25, 170, 691.84948730469, -1345.8999023438, 20.710962295532, 180},
            {26, 200, 691.26696777344, -1345.0100097656, 20.710962295532, 90},
            {27, 150, 691.84527587891, -1344.1312255859, 20.710962295532, 0},

            {2, 250, 687.49664306641, -1344.9788818359, 20.710962295532, 270},
            {7, 200, 686.421875, -1345.0693359375, 20.710962295532, 90},
            {9, 200, 686.92041015625, -1346.0153808594, 20.710962295532, 180},
            {12, 150, 686.99993896484, -1344.1541748047, 20.710962295532, 0},
        },
        {148,705.91864013672, -1342.8791503906, 19.921899795532,180},
    },

    {"Pláza - ZIP", 0, 0, 
        {
            --{skin id, money, x, y, z, rot}
            {24, 200, 745.15710449219, -1350.025390625, 14.210962295532, 270},
            {22, 220, 738.96307373047, -1349.0721435547, 14.210962295532, 0},
            {20, 160, 744.06091308594, -1349.9650878906, 14.210962295532, 90},
            {13, 175, 743.18176269531, -1356.1695556641, 14.210962295532, 180},
            {11, 120, 743.24176025391, -1354.40234375, 14.210962295532, 0},
            {1, 200, 739.04486083984, -1350.9721679688, 14.210962295532, 180},
            {56, 100, 739.67962646484, -1349.9553222656, 14.210962295532, 270},
            {91, 210, 743.01831054688, -1355.3234863281, 14.210962295532, 270},
            {93, 85, 744.69256591797, -1349.3059082031, 14.210962295532, 0},
            {193, 85, 744.61608886719, -1350.6086425781, 14.210962295532, 180},
        },
        {148,741.68664550781, -1346.2459716797, 13.427791595459,180},
    },

    {"Frakció", 3, 60, -- INTERIORID: 38
        {
            --{skin id, money, x, y, z, rot, factionID}
            -- 83 HOOVER CRIMINALS GANG
            {49, 135, 217.10850524902, -131.0062713623, 1003.5151977539, 90, 16},
            {51, 170, 217.10400390625, -134.74081420898, 1003.5151977539, 90, 16},
            {52, 200, 215.74871826172, -137.42691040039, 1003.5078125, 90, 16},
            {92, 150, 215.80763244629, -128.4853515625, 1003.5078125, 90, 16},
            {301, 200, 216.30233764648, -126.48948669434, 1003.5078125, 90, 16},
            {302, 180, 212.99066162109, -126.98980712891, 1003.5151977539, 180, 16},
            {61, 180, 210.77502441406, -126.95442962646, 1003.5151977539, 180, 16},

            --leptoy Hangsayha
            {213, 200, 204.33279418945, -126.48745727539, 1003.5078125, 180, 25},
            {201, 150, 203.13804626465, -131.00819396973, 1003.5078125, 180, 25},
            {181, 173, 200.70346069336, -131.00848388672, 1003.5078125, 180, 25},
            {159, 110, 197.71104431152, -131.00823974609, 1003.5078125, 180, 25},
            {157, 140, 199.30912780762, -126.4845199585, 1003.5151977539, 180, 25},
            {156, 135, 208.84251403809, -136.07473754883, 1002.8743896484, 75, 25},

            --46 Neighborhood Crips
            {221, 200, 216.60595703125, -133.07078552246, 1003.5078125, 90, 36},
            {222, 230, 211.88026428223, -139.37344360352, 1003.5078125, 0, 36},
            {235, 132, 214.18112182617, -138.48188781738, 1003.5078125, 0, 36},
            {249, 190, 209.45365905762, -140.14753723145, 1003.5078125, 0, 36},
            {253, 170, 204.1057434082, -140.14540100098, 1003.5078125, 0, 36},
            {255, 200, 202.48956298828, -139.61611938477, 1003.5078125, 0, 36},
            {212, 110, 200.64964294434, -139.43249511719, 1003.5078125, 0, 36},

            --Catel de Tijuana
            {63, 210, 197.11888122559, -134.88725280762, 1003.5078125, 270, 17},
            {64, 205, 196.81761169434, -132.55342102051, 1003.5078125, 270, 17},
            {73, 150, 197.92764282227, -138.64324951172, 1003.5151977539, 300, 17},
            {75, 135, 197.27101135254, -136.66781616211, 1003.5078125, 270, 17},
            {78, 170, 202.37928771973, -135.90380859375, 1002.8743896484, 270, 17},
            {79, 165, 201.86431884766, -133.36943054199, 1002.8671875, 70, 17},
            {85, 140, 210.40516662598, -134.21667480469, 1002.8671875, 90, 17},
            {283, 165, 209.1028137207, -127.59359741211, 1003.5078125, 270, 17},
            {298, 140, 208.65615844727, -133.55632019043, 1002.8671875, 180, 17},

            --Sacra Corona Unita
            {281, 200, 205.32847595215, -133.55657958984, 1002.8671875, 180, 18},
            {238, 150, 212.29275512695, -130.25297546387, 1003.5078125, 180, 18},
            {282, 173, 212.7321472168, -133.6369934082, 1002.8671875, 290, 18},
            {303, 110, 211.03607177734, -136.42596435547, 1002.8671875, 266, 18},
            {307, 140, 203.96672058105, -129.51863098145, 1003.5078125, 270, 18},
        },
        {148,206.97016906738, -127.80631256104, 1003.5078125,180},
    },
}