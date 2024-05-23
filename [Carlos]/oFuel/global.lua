core = exports.oCore
color, r, g, b = core:getServerColor()
font = exports.oFont
bone = exports.oBone
chat = exports.oChat
infobox = exports.oInfobox

fuelGunAttachPositions = {
    {"95", -0.15, 0.32, 1.4, 0, 100, 90, -0.15, 0.37, 1.4, 0, 100, 90},
    {"D", -0.44, 0.32, 1.4, 0, 100, 90, -0.44, 0.37, 1.4, 0, 100, 90},

    {"95", -0.15, -0.3, 1.4, 0, 100, -90, -0.15, -0.37, 1.4, 0, 100, -90},
    {"D", -0.44, -0.3, 1.4, 0, 100, -90, -0.44, -0.37, 1.4, 0, 100, -90},
}

gasPumpPipePositions = {
    {-0.15, 0.23, 0.2},
    {-0.44, 0.23, 0.2},

    {-0.15, -0.23, 0.2},
    {-0.44, -0.23, 0.2},
}

vehicleFuelPositions = {
    [445] = "wheel_rb_dummy",
    [602] = "wheel_rb_dummy",
    [405] = "wheel_rb_dummy",
    [507] = "wheel_rb_dummy",
    [492] = "wheel_rb_dummy",
    [483] = "wheel_rb_dummy",
    [411] = "wheel_rb_dummy",
    [551] = "wheel_rb_dummy",
    [426] = "wheel_rb_dummy",
    [559] = "wheel_rb_dummy",
    [516] = "wheel_rb_dummy",
    [560] = "wheel_rb_dummy",
    [518] = "wheel_rb_dummy",

    [581] = "wheel_rear",
    [462] = "wheel_rear",
    [521] = "wheel_rear",

    [463] = "wheel_rear",
    [522] = "wheel_rear",
    [461] = "wheel_rear",

    [448] = "wheel_rear",
    [468] = "wheel_rear",
    [586] = "wheel_rear",
}