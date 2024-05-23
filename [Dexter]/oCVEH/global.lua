core = exports.oCore
font = exports.oFont
preview = exports.oPreview

circleSize = 35

--[[ COMPONENTEK
    bonnet_dummy <- motorház

    door_lf_dummy <- bal első ajtó 
    door_rf_dummy <- jobb első ajtó 

    door_lr_dummy <- bal hátsó
    door_rr_dummy <- jobb hátsó

    boot_dummy <- csomagtartó
]]

vehicle_doors = {
    [402] = { --Dodge Demon SRT
        {type = "bonnet_dummy", posX = 0.49, posY = 0.32}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.5},
        {type = "door_rf_dummy", posX = 0.536, posY = 0.5},
        {type = "boot_dummy", posX = 0.49, posY = 0.655},
    },
    [411] = { --CCX Koenigsegg
        {type = "bonnet_dummy", posX = 0.49, posY = 0.32},
        {type = "door_lf_dummy", posX = 0.441, posY = 0.5},
        {type = "door_rf_dummy", posX = 0.536, posY = 0.5},
        {type = "boot_dummy", posX = 0.49, posY = 0.655},
    },
    [415] = { --McLaren P1
        {type = "bonnet_dummy", posX = 0.49, posY = 0.32}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.5},
        {type = "door_rf_dummy", posX = 0.536, posY = 0.5},
        {type = "boot_dummy", posX = 0.49, posY = 0.635},
    },
    [445] = { --BMW M5 E60 --Black
        {type = "bonnet_dummy", posX = 0.49, posY = 0.32}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.5},
        {type = "door_rf_dummy", posX = 0.536, posY = 0.5},
        {type = "boot_dummy", posX = 0.49, posY = 0.65},
    },
  	[602] = { --Nissan GT-R
        {type = "bonnet_dummy", posX = 0.49, posY = 0.32}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.5},
        {type = "door_rf_dummy", posX = 0.536, posY = 0.5},
        {type = "boot_dummy", posX = 0.49, posY = 0.65},
    },
    [416] = { --Ambulance
        {type = "bonnet_dummy", posX = 0.49, posY = 0.33}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.41},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.41},
        {type = "boot_dummy", posX = 0.54, posY = 0.5},
        {type = "door_lr_dummy", posX = 0.47, posY = 0.65},
        {type = "door_rr_dummy", posX = 0.51, posY = 0.65},
    },
    [542] = { --Pantiac Firebird
        {type = "bonnet_dummy", posX = 0.49, posY = 0.33}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.5},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.5},
        {type = "boot_dummy", posX = 0.49, posY = 0.65},
    },
    [405] = { --BMW M5 E34
        {type = "bonnet_dummy", posX = 0.49, posY = 0.32}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.48},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.48},
        {type = "door_lr_dummy", posX = 0.441, posY = 0.54},
        {type = "door_rr_dummy", posX = 0.54, posY = 0.54},
        {type = "boot_dummy", posX = 0.49, posY = 0.66},
    },
    [410] = { --1973 Ford Pinto Runabout
        {type = "bonnet_dummy", posX = 0.49, posY = 0.315}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.5},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.5},
        {type = "boot_dummy", posX = 0.49, posY = 0.66},
    },
    [400] = { --Range Rover Sport
        {type = "bonnet_dummy", posX = 0.49, posY = 0.32}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.48},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.48},
        {type = "door_lr_dummy", posX = 0.441, posY = 0.55},
        {type = "door_rr_dummy", posX = 0.54, posY = 0.55},
        {type = "boot_dummy", posX = 0.49, posY = 0.66},
    },
    [507] = { --Mercedes E500
        {type = "bonnet_dummy", posX = 0.49, posY = 0.32},
        {type = "door_lf_dummy", posX = 0.441, posY = 0.46},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.46},
        {type = "door_lr_dummy", posX = 0.441, posY = 0.54},
        {type = "door_rr_dummy", posX = 0.54, posY = 0.54},
        {type = "boot_dummy", posX = 0.49, posY = 0.66},
    },
    [492] = { --BMW M5 F10
        {type = "bonnet_dummy", posX = 0.49, posY = 0.315}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.47},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.47},
        {type = "door_lr_dummy", posX = 0.441, posY = 0.53},
        {type = "door_rr_dummy", posX = 0.54, posY = 0.53},
        {type = "boot_dummy", posX = 0.49, posY = 0.66},
    },
    [415] = { --McLaren P1 (nincsen csomija)
        {type = "bonnet_dummy", posX = 0.49, posY = 0.315}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.47},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.47},
    },
    [585] = { --Ford Crown Victoria
        {type = "bonnet_dummy", posX = 0.49, posY = 0.315}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.47},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.47},
        {type = "door_lr_dummy", posX = 0.441, posY = 0.53},
        {type = "door_rr_dummy", posX = 0.54, posY = 0.53},
        {type = "boot_dummy", posX = 0.49, posY = 0.66},
    },
    [579] = { --Cadilac Esclade
        {type = "bonnet_dummy", posX = 0.49, posY = 0.315}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.47},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.47},
        {type = "door_lr_dummy", posX = 0.441, posY = 0.53},
        {type = "door_rr_dummy", posX = 0.54, posY = 0.53},
        {type = "boot_dummy", posX = 0.49, posY = 0.66},
    },
    [547] = { --Cadilac Fletwood
        {type = "bonnet_dummy", posX = 0.49, posY = 0.315}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.47},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.47},
        {type = "door_lr_dummy", posX = 0.441, posY = 0.53},
        {type = "door_rr_dummy", posX = 0.54, posY = 0.53},
        {type = "boot_dummy", posX = 0.49, posY = 0.66},
    },
    [565] = { --AMC Gremlin X V8
        {type = "bonnet_dummy", posX = 0.49, posY = 0.315}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.47},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.47},
        {type = "boot_dummy", posX = 0.49, posY = 0.65},
    },
    [404] = { --Chevrolet Suburban Z11
        {type = "bonnet_dummy", posX = 0.49, posY = 0.315}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.47},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.47},
        {type = "door_lr_dummy", posX = 0.441, posY = 0.53},
        {type = "door_rr_dummy", posX = 0.54, posY = 0.53},
        {type = "boot_dummy", posX = 0.49, posY = 0.66},
    },
    [483] = { --Barcas
        {type = "bonnet_dummy", posX = 0.49, posY = 0.315}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.41},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.41},
        {type = "door_rr_dummy", posX = 0.54, posY = 0.5},
        {type = "boot_dummy", posX = 0.49, posY = 0.65},
    },
    [598] = { --Ford Crown Victoria Police
        {type = "bonnet_dummy", posX = 0.49, posY = 0.33}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.47},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.47},
        {type = "door_lr_dummy", posX = 0.441, posY = 0.53},
        {type = "door_rr_dummy", posX = 0.54, posY = 0.53},
        {type = "boot_dummy", posX = 0.49, posY = 0.64},
    },
    [596] = { --Dodge Police
        {type = "bonnet_dummy", posX = 0.49, posY = 0.31}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.47},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.47},
        {type = "door_lr_dummy", posX = 0.441, posY = 0.53},
        {type = "door_rr_dummy", posX = 0.54, posY = 0.53},
        {type = "boot_dummy", posX = 0.49, posY = 0.66},
    },
    --[586] = { --Harly Davidson FXSTB
        --{type = "bonnet_dummy", posX = 0.49, posY = 0.315}, 
        --{type = "door_lf_dummy", posX = 0.441, posY = 0.47},
        --{type = "door_rf_dummy", posX = 0.54, posY = 0.47},
        --{type = "door_lr_dummy", posX = 0.441, posY = 0.53},
        --{type = "door_rr_dummy", posX = 0.54, posY = 0.53},
        --{type = "boot_dummy", posX = 0.49, posY = 0.66},
    --}, -- A MOTORNAK BUGOS A CVEH, NEM LEHET VELE MIT KINYITNI
    [479] = { --Volvo XC90 T8
        {type = "bonnet_dummy", posX = 0.49, posY = 0.315}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.47},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.47},
        {type = "door_lr_dummy", posX = 0.441, posY = 0.53},
        {type = "door_rr_dummy", posX = 0.54, posY = 0.53},
        {type = "boot_dummy", posX = 0.49, posY = 0.66},
    },
    [599] = { --Ford Explorer Police
        {type = "bonnet_dummy", posX = 0.49, posY = 0.31}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.47},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.47},
        {type = "door_lr_dummy", posX = 0.441, posY = 0.53},
        {type = "door_rr_dummy", posX = 0.54, posY = 0.53},
        {type = "boot_dummy", posX = 0.49, posY = 0.66},
    },
    [546] = { --Tesla Model S
        {type = "bonnet_dummy", posX = 0.49, posY = 0.31}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.47},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.47},
        {type = "door_lr_dummy", posX = 0.441, posY = 0.53},
        {type = "door_rr_dummy", posX = 0.54, posY = 0.53},
        {type = "boot_dummy", posX = 0.49, posY = 0.66},
    },
    [411] = { --Koenigsegg CCX
        {type = "bonnet_dummy", posX = 0.49, posY = 0.315}, 
        {type = "door_lf_dummy", posX = 0.431, posY = 0.47},
        {type = "door_rf_dummy", posX = 0.55, posY = 0.47},
        {type = "boot_dummy", posX = 0.49, posY = 0.66},
    },
    [496] = { --Tesla Roadster Sport
        {type = "bonnet_dummy", posX = 0.49, posY = 0.315}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.49},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.49},
        {type = "boot_dummy", posX = 0.49, posY = 0.66},
    },
    [550] = { --E250 Mercedes
        {type = "bonnet_dummy", posX = 0.49, posY = 0.33}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.47},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.47},
        {type = "door_lr_dummy", posX = 0.441, posY = 0.53},
        {type = "door_rr_dummy", posX = 0.54, posY = 0.53},
        {type = "boot_dummy", posX = 0.49, posY = 0.66},
    },
    [402] = { --Dodge Demon SRT
        {type = "bonnet_dummy", posX = 0.49, posY = 0.315}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.48},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.48},
        {type = "boot_dummy", posX = 0.49, posY = 0.66},
    },
    [458] = { --Tesla Cybertruck
        {type = "door_lf_dummy", posX = 0.441, posY = 0.47},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.47},
        {type = "door_lr_dummy", posX = 0.441, posY = 0.53},
        {type = "door_rr_dummy", posX = 0.54, posY = 0.53},
        {type = "boot_dummy", posX = 0.49, posY = 0.66},
    },
    [551] = { --Audi A8
        {type = "bonnet_dummy", posX = 0.49, posY = 0.31}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.47},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.47},
        {type = "door_lr_dummy", posX = 0.441, posY = 0.53},
        {type = "door_rr_dummy", posX = 0.54, posY = 0.53},
        {type = "boot_dummy", posX = 0.49, posY = 0.66},
    },
    [451] = { --Ferrari F40
        {type = "bonnet_dummy", posX = 0.49, posY = 0.315}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.48},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.48},
        {type = "boot_dummy", posX = 0.49, posY = 0.66},
    },
    [558] = { --Subaru Impreza 22B STI 1998
        {type = "bonnet_dummy", posX = 0.49, posY = 0.31}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.48},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.48},
        {type = "boot_dummy", posX = 0.49, posY = 0.66},
    },
    [426] = { --Audi RS6 Avant
        {type = "bonnet_dummy", posX = 0.49, posY = 0.31}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.47},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.47},
        {type = "door_lr_dummy", posX = 0.441, posY = 0.53},
        {type = "door_rr_dummy", posX = 0.54, posY = 0.53},
        {type = "boot_dummy", posX = 0.49, posY = 0.66},
    },
    [502] = { --Bugatti Veyron
        {type = "bonnet_dummy", posX = 0.49, posY = 0.315}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.48},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.48},
    },
    [429] = { --Toyota Supra
        {type = "bonnet_dummy", posX = 0.49, posY = 0.315}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.48},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.48},
        {type = "boot_dummy", posX = 0.49, posY = 0.66},
    },
    [562] = { --Nissan Skyline GTR-34
        {type = "bonnet_dummy", posX = 0.49, posY = 0.31}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.48},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.48},
        {type = "boot_dummy", posX = 0.49, posY = 0.66},
    },
    [400] = { --Range Rover Sport
        {type = "bonnet_dummy", posX = 0.49, posY = 0.31}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.47},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.47},
        {type = "door_lr_dummy", posX = 0.441, posY = 0.53},
        {type = "door_rr_dummy", posX = 0.54, posY = 0.53},
        {type = "boot_dummy", posX = 0.49, posY = 0.66},
    },

    [409] = { --Limo
        {type = "bonnet_dummy", posX = 0.49, posY = 0.31}, 
        {type = "door_lf_dummy", posX = 0.45, posY = 0.4},
        {type = "door_rf_dummy", posX = 0.53, posY = 0.4},
        {type = "door_lr_dummy", posX = 0.45, posY = 0.55},
        {type = "door_rr_dummy", posX = 0.53, posY = 0.55},
        {type = "boot_dummy", posX = 0.49, posY = 0.66},
    },

    [422] = { --Bobcat
        {type = "bonnet_dummy", posX = 0.49, posY = 0.31}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.47},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.47},
        {type = "boot_dummy", posX = 0.49, posY = 0.66},
    },

    [440] = { --Bobcat
        {type = "bonnet_dummy", posX = 0.49, posY = 0.31}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.47},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.47},
        {type = "boot_dummy", posX = 0.49, posY = 0.66},
    },

    [442] = { --Mercedes G
        {type = "bonnet_dummy", posX = 0.49, posY = 0.31}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.47},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.47},
        {type = "door_lr_dummy", posX = 0.441, posY = 0.53},
        {type = "door_rr_dummy", posX = 0.54, posY = 0.53},
        {type = "boot_dummy", posX = 0.49, posY = 0.66},
    },

    [467] = { --Chevrolet Impala
        {type = "bonnet_dummy", posX = 0.49, posY = 0.31}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.47},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.47},
        {type = "door_lr_dummy", posX = 0.441, posY = 0.53},
        {type = "door_rr_dummy", posX = 0.54, posY = 0.53},
        {type = "boot_dummy", posX = 0.49, posY = 0.66},
    },

    [478] = { --Chevrolet Silverado
        {type = "bonnet_dummy", posX = 0.49, posY = 0.32}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.45},
        {type = "door_rf_dummy", posX = 0.536, posY = 0.45},
        {type = "boot_dummy", posX = 0.49, posY = 0.655},
    },

    [480] = { --porsche
        {type = "bonnet_dummy", posX = 0.49, posY = 0.31}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.47},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.47},
        {type = "boot_dummy", posX = 0.49, posY = 0.66},
    },

    [505] = { --Ford terepjáró
        {type = "bonnet_dummy", posX = 0.49, posY = 0.31}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.47},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.47},
        {type = "boot_dummy", posX = 0.49, posY = 0.66},
    },

    [516] = { --Mercedes
        {type = "bonnet_dummy", posX = 0.49, posY = 0.31}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.47},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.47},
        {type = "door_lr_dummy", posX = 0.441, posY = 0.53},
        {type = "door_rr_dummy", posX = 0.54, posY = 0.53},
        {type = "boot_dummy", posX = 0.49, posY = 0.66},
    },

    [526] = { --Shelby
        {type = "bonnet_dummy", posX = 0.49, posY = 0.31}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.47},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.47},
        {type = "boot_dummy", posX = 0.49, posY = 0.66},
    },

    [527] = { --Audi Sport Quattro B2
        {type = "bonnet_dummy", posX = 0.49, posY = 0.32}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.5},
        {type = "door_rf_dummy", posX = 0.536, posY = 0.5},
        {type = "boot_dummy", posX = 0.49, posY = 0.655},
    },

    [534] = { --
        {type = "bonnet_dummy", posX = 0.49, posY = 0.31}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.47},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.47},
        {type = "boot_dummy", posX = 0.49, posY = 0.66},
    },

    [536] = { --
        {type = "bonnet_dummy", posX = 0.49, posY = 0.31}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.47},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.47},
        {type = "boot_dummy", posX = 0.49, posY = 0.66},
    },

    [540] = { --
        {type = "bonnet_dummy", posX = 0.49, posY = 0.31}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.47},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.47},
        {type = "door_lr_dummy", posX = 0.441, posY = 0.53},
        {type = "door_rr_dummy", posX = 0.54, posY = 0.53},
        {type = "boot_dummy", posX = 0.49, posY = 0.66},
    },
    
    [559] = { --
        {type = "bonnet_dummy", posX = 0.49, posY = 0.31}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.47},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.47},
        {type = "boot_dummy", posX = 0.49, posY = 0.66},
    },

    [560] = { --
        {type = "bonnet_dummy", posX = 0.49, posY = 0.31}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.47},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.47},
        {type = "door_lr_dummy", posX = 0.441, posY = 0.53},
        {type = "door_rr_dummy", posX = 0.54, posY = 0.53},
        {type = "boot_dummy", posX = 0.49, posY = 0.62},
    },

    [604] = { --Tesla Model S
        {type = "bonnet_dummy", posX = 0.49, posY = 0.31}, 
        {type = "door_lf_dummy", posX = 0.441, posY = 0.47},
        {type = "door_rf_dummy", posX = 0.54, posY = 0.47},
        {type = "door_lr_dummy", posX = 0.441, posY = 0.53},
        {type = "door_rr_dummy", posX = 0.54, posY = 0.53},
        {type = "boot_dummy", posX = 0.49, posY = 0.66},
    },
}

components = {
    ["bonnet_dummy"] = 0,
    ["boot_dummy"] = 1,
    ["door_lf_dummy"] = 2,
    ["door_rf_dummy"] = 3,
    ["door_lr_dummy"] = 4, 
    ["door_rr_dummy"] = 5,
}