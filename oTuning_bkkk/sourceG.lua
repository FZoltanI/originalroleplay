availableTuningMarkers = {
    {2472.9226074219,-1665.1204833984,13.315125465393}
}

cmarker = exports.oCustomMarker
font = exports.oFont
core = exports.oCore
infobox = exports.oInfobox
color, r, g, b = core:getServerColor()

usedScripts = {"oCustomMarker", "oCore", "oFont", "oVehicle", "oTuning", "oInfobox"}

tuningContainer = {
    [1] = {
        ["categoryName"] = "Teljesítmény tuning",
        ["icon"] = "engine",
        ["subMenu"] = {
            [1] = {
                ["categoryName"] = "Motor",
                ["cameraSettings"] = {"bonnet_dummy", 110, 15, 6, true},
                ["upgradeData"] = "engine",
                ["subMenu"] = {
                    [1] = {["categoryName"] = "Gyári", ["value"] = 0, ["priceType"] = "free", ["price"] = 0, ["tuningData"] = {{"engineAcceleration"}, {"maxVelocity"}}},
                    [2] = {["categoryName"] = "Alap", ["value"] = 1, ["priceType"] = "money", ["price"] = 9000, ["tuningData"] = {{"engineAcceleration", 0.6}, {"maxVelocity", 9.5}}},
                    [3] = {["categoryName"] = "Verseny", ["value"] = 2, ["priceType"] = "money", ["price"] = 15000, ["tuningData"] = {{"engineAcceleration", 0.6*2}, {"maxVelocity", 9.5*2}}},
                    [4] = {["categoryName"] = "Profi", ["value"] = 3, ["priceType"] = "money", ["price"] = 35000, ["tuningData"] = {{"engineAcceleration", 0.6*3}, {"maxVelocity", 9.5*3}}},
                    [5] = {["categoryName"] = "Prémium", ["value"] = 4, ["priceType"] = "premium", ["price"] = 750, ["tuningData"] = {{"engineAcceleration", 0.6*4}, {"maxVelocity", 9.5*4}}},
                },
            },            
            [2] = {
                ["categoryName"] = "Váltó",
                ["cameraSettings"] = {"bonnet_dummy", 110, 15, 6, true},
                ["upgradeData"] = "engine",
                ["subMenu"] = {
                    [1] = {["categoryName"] = "Gyári", ["value"] = 0, ["priceType"] = "free", ["price"] = 0, ["tuningData"] = {{"maxVelocity"}}},
                    [2] = {["categoryName"] = "Alap", ["value"] = 1, ["priceType"] = "money", ["price"] = 9000, ["tuningData"] = {{"maxVelocity", 6}}},
                    [3] = {["categoryName"] = "Verseny", ["value"] = 2, ["priceType"] = "money", ["price"] = 15000, ["tuningData"] = {{"maxVelocity", 6*2}}},
                    [4] = {["categoryName"] = "Profi", ["value"] = 3, ["priceType"] = "money", ["price"] = 35000, ["tuningData"] = {{"maxVelocity", 6*3}}},
                    [5] = {["categoryName"] = "Prémium", ["value"] = 4, ["priceType"] = "premium", ["price"] = 750, ["tuningData"] = {{"maxVelocity", 6*4}}},
                },
            },            
            [3] = {
                ["categoryName"] = "Fékek",
                ["cameraSettings"] = {"bonnet_dummy", 110, 15, 6, true},
                ["upgradeData"] = "engine",
                ["subMenu"] = {
                    [1] = {["categoryName"] = "Gyári", ["value"] = 0, ["priceType"] = "free", ["price"] = 0, ["tuningData"] = {{"brakeDeceleration"}, {"brakeBias"}}},
                    [2] = {["categoryName"] = "Alap", ["value"] = 1, ["priceType"] = "money", ["price"] = 9000, ["tuningData"] = {{"brakeDeceleration", 0.02}, {"brakeBias", 0.08}}},
                    [3] = {["categoryName"] = "Verseny", ["value"] = 2, ["priceType"] = "money", ["price"] = 15000, ["tuningData"] = {{"brakeDeceleration", 0.02*2}, {"brakeBias", 0.08*2}}},
                    [4] = {["categoryName"] = "Profi", ["value"] = 3, ["priceType"] = "money", ["price"] = 35000, ["tuningData"] = {{"brakeDeceleration", 0.02*3}, {"brakeBias", 0.08*3}}},
                    [5] = {["categoryName"] = "Prémium", ["value"] = 4, ["priceType"] = "premium", ["price"] = 750, ["tuningData"] = {{"brakeDeceleration", 0.02*4}, {"brakeBias", 0.08*4}}},
                },
            },            
            [4] = {
                ["categoryName"] = "Turbó",
                ["cameraSettings"] = {"bonnet_dummy", 110, 15, 6, true},
                ["upgradeData"] = "engine",
                ["subMenu"] = {
                    [1] = {["categoryName"] = "Gyári", ["value"] = 0, ["priceType"] = "free", ["price"] = 0, ["tuningData"] = {{"engineAcceleration"}}},
                    [2] = {["categoryName"] = "Alap", ["value"] = 1, ["priceType"] = "money", ["price"] = 9000, ["tuningData"] = {{"engineAcceleration", 0.6}}},
                    [3] = {["categoryName"] = "Verseny", ["value"] = 2, ["priceType"] = "money", ["price"] = 15000, ["tuningData"] = {{"engineAcceleration", 0.6*2}}},
                    [4] = {["categoryName"] = "Profi", ["value"] = 3, ["priceType"] = "money", ["price"] = 35000, ["tuningData"] = {{"engineAcceleration", 0.6*3}}},
                    [5] = {["categoryName"] = "Prémium", ["value"] = 4, ["priceType"] = "premium", ["price"] = 750, ["tuningData"] = {{"engineAcceleration", 0.6*4}}},
                },
            },            
            [5] = {
                ["categoryName"] = "ECU",
                ["cameraSettings"] = {"bonnet_dummy", 110, 15, 6, true},
                ["upgradeData"] = "engine",
                ["subMenu"] = {
                    [1] = {["categoryName"] = "Gyári", ["value"] = 0, ["priceType"] = "free", ["price"] = 0},
                    [2] = {["categoryName"] = "Alap", ["value"] = 1, ["priceType"] = "money", ["price"] = 9000},
                    [3] = {["categoryName"] = "Verseny", ["value"] = 2, ["priceType"] = "money", ["price"] = 15000},
                    [4] = {["categoryName"] = "Profi", ["value"] = 3, ["priceType"] = "money", ["price"] = 35000},
                    [5] = {["categoryName"] = "Prémium", ["value"] = 4, ["priceType"] = "premium", ["price"] = 750},
                },
            },            
            [6] = {
                ["categoryName"] = "Súlycsökkentés",
                ["cameraSettings"] = {"bonnet_dummy", 110, 15, 6, true},
                ["upgradeData"] = "engine",
                ["subMenu"] = {
                    [1] = {["categoryName"] = "Gyári", ["value"] = 0, ["priceType"] = "free", ["price"] = 0},
                    [2] = {["categoryName"] = "Alap", ["value"] = 1, ["priceType"] = "money", ["price"] = 9000},
                    [3] = {["categoryName"] = "Verseny", ["value"] = 2, ["priceType"] = "money", ["price"] = 15000},
                    [4] = {["categoryName"] = "Profi", ["value"] = 3, ["priceType"] = "money", ["price"] = 35000},
                    [5] = {["categoryName"] = "Prémium", ["value"] = 4, ["priceType"] = "premium", ["price"] = 750},
                },
            },            
            [7] = {
                ["categoryName"] = "Kerék fordulás",
                ["cameraSettings"] = {"wheel_rf_dummy", 35, 5, 2, false},
                ["upgradeData"] = "engine",
                ["subMenu"] = {
                    [1] = {["categoryName"] = "Gyári", ["value"] = 0, ["priceType"] = "free", ["price"] = 0},
                    [2] = {["categoryName"] = "Alap", ["value"] = 1, ["priceType"] = "money", ["price"] = 9000},
                    [3] = {["categoryName"] = "Verseny", ["value"] = 2, ["priceType"] = "money", ["price"] = 15000},
                    [4] = {["categoryName"] = "Profi", ["value"] = 3, ["priceType"] = "money", ["price"] = 35000},
                    [5] = {["categoryName"] = "Prémium", ["value"] = 4, ["priceType"] = "premium", ["price"] = 750},
                },
            },
        },
    },
}