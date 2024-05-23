points = {
    {
        obj = 13028,
        close = {720.00311279297, -462.52, 16.85, 90},
        open = {720.00311279297, -460.52, 18.8},
        col = {720.07397460938, -455.82891845703, 16.3359375},
    },

    {
        obj = 5422,
        close = {2071.4506835938, -1831.4, 14.546875, 180},
        open = {2069.4506835938, -1831.4, 16.559896392822},
        col = {2063.1943359375, -1831.466796875, 13.546875},
    },

    {
        obj = 5856,
        close = {1024.99, -1029.3741455078, 33.3015625, 90},
        open = {1024.99, -1027.3741455078, 35.3015625},
        col = {1024.7329101563, -1023.4033203125, 32.1015625},
    },

    --[[{
        obj = 7891,
        close = {1968.3612060547, 2162.5014648438, 12, 360},
        open = {1971.314453125, 2162.4384765625, 14.5703125},
        col = {1976.7058105469, 2162.5131835938, 11.0703125},
    },

    {
        obj = 3294,
        close = {-1420.5403564453, 2590.7270507812, 57.6, 270},
        open = {-1420.543769531, 2587.7937011719, 60.84326171875},
        col = {-1420.5886230469, 2584.2048339844, 55.84326171875},
    },]]
}

core = exports.oCore
color, r, g, b = core:getServerColor()

vehicleMechanicComponents = {
    {gtaName = "door_lf_dummy", name = "Bal első ajtó", componentVisible = true, doorID = 2, price = 400},
    {gtaName = "door_rf_dummy", name = "Jobb első ajtó", componentVisible = true, doorID = 3, price = 400},
    {gtaName = "door_lr_dummy", name = "Bal hátsó ajtó", componentVisible = true, doorID = 4, price = 400},
    {gtaName = "door_rr_dummy", name = "Jobb hátsó ajtó", componentVisible = true, doorID = 5, price = 400},
    {gtaName = "windscreen_dummy", name = "Szélvédő", componentVisible = true, panelID = 4, price = 700},
    {gtaName = "bump_front_dummy", name = "Első lökhárító", componentVisible = true, panelID = 5, price = 200},
    {gtaName = "bump_rear_dummy", name = "Hátsó lökhárító", componentVisible = true, panelID = 6, price = 200},
    {gtaName = "boot_dummy", name = "Csomagtartó", componentVisible = true, doorID = 1, price = 350},
    {gtaName = "bonnet_dummy", name = "Motorháztető", componentVisible = true, doorID = 0, price = 400},

    {gtaName = "wheel_rf_dummy", name = "Jobb első kerék", componentVisible = true, wheelID = 3, price = 750},
    {gtaName = "wheel_lf_dummy", name = "Bal első kerék", componentVisible = true, wheelID = 1, price = 750},
    {gtaName = "wheel_rb_dummy", name = "Jobb hátsó kerék", componentVisible = true, wheelID = 4, price = 750},
    {gtaName = "wheel_lb_dummy", name = "Bal hátsó kerék", componentVisible = true, wheelID = 2, price = 750},
}