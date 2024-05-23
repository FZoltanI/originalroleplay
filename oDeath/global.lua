core = exports.oCore
color, r, g, b = core:getServerColor()

anim_start_hp = 15

injured_animations = {
    {"sweet", "sweet_injuredloop"}
}

disable_needed_controlls = {"vehicle_fire", "vehicle_left", "vehicle_right", "steer_forward", "steer_back", "accelerate", "brake_reverse", "enter_exit", "forwards", "backwards", "left", "right", "walk", "jump", "sprint", "fire"}

injured_room = {
    {obj = 9505, pos = Vector3(1166, -1346.7, -26.4), scale = 1, rotX = 0, rotY = 90, rotZ = 0},
    {obj = 9505, pos = Vector3(1166, -1346.7, -22.8), scale = 1, rotX = 0, rotY = 90, rotZ = 0},
    {obj = 18323, pos = Vector3(1160.9, -1348.5, -23.8), scale = 1, rotX = 0, rotY = 0, rotZ = 0},
    {obj = 18323, pos = Vector3(1160.9, -1342.6, -23.8), scale = 1, rotX = 0, rotY = 0, rotZ = 0},
    {obj = 18323, pos = Vector3(1168.5, -1348.6, -23.8), scale = 1, rotX = 0, rotY = 0, rotZ = 180},
    {obj = 18323, pos = Vector3(1161.8, -1351.4, -23.8), scale = 1, rotX = 0, rotY = 0, rotZ = 90},
    {obj = 18323, pos = Vector3(1167.7, -1351.4, -23.8), scale = 1, rotX = 0, rotY = 0, rotZ = 90},
    {obj = 1801, pos = Vector3(1164.5, -1348.7, -26.4), scale = 1, rotX = 0, rotY = 0, rotZ = 90},
    {obj = 1801, pos = Vector3(1164.5, -1344.2, -26.4), scale = 1, rotX = 0, rotY = 0, rotZ = 90},
    {obj = 2331, pos = Vector3(1161.3, -1344.9, -26.1), scale = 1, rotX = 0, rotY = 0, rotZ = 90},
    {obj = 2331, pos = Vector3(1161.3, -1349.5, -26.1), scale = 1, rotX = 0, rotY = 0, rotZ = 90},
    {obj = 18323, pos = Vector3(1168.5, -1342.7, -23.8), scale = 1, rotX = 0, rotY = 0, rotZ = 180},
    {obj = 18323, pos = Vector3(1162.2, -1342.1, -23.8), scale = 1, rotX = 0, rotY = 0, rotZ = 270},
    {obj = 18323, pos = Vector3(1168.1, -1342.1, -23.8), scale = 1, rotX = 0, rotY = 0, rotZ = 270},
    {obj = 1533, pos = Vector3(1166.7, -1351.2, -26.4), scale = 1, rotX = 0, rotY = 0, rotZ = 180},
    {obj = 2026, pos = Vector3(1163.4, -1346, -22.9), scale = 1, rotX = 0, rotY = 0, rotZ = 0},
    {obj = 2026, pos = Vector3(1163.4, -1346, -22.9), scale = 1, rotX = 0, rotY = 0, rotZ = 0},
    {obj = 2106, pos = Vector3(1161.3, -1344.8, -25.7), scale = 1, rotX = 0, rotY = 0, rotZ = 22},
    {obj = 2106, pos = Vector3(1161.4, -1349.6, -25.7), scale = 1, rotX = 0, rotY = 0, rotZ = 295},
    {obj = 3034, pos = Vector3(1163, -1342.3, -24.3), scale = 0.56, rotX = 0, rotY = 0, rotZ = 0},
    {obj = 3034, pos = Vector3(1166.7, -1342.3, -24.3), scale = 0.56, rotX = 0, rotY = 0, rotZ = 0},
    {obj = 3034, pos = Vector3(1161.1, -1348.2, -24.1), scale = 0.56, rotX = 0, rotY = 0, rotZ = 90},
    {obj = 2558, pos = Vector3(1162.5, -1342.7, -25.1), scale = 1, rotX = 0, rotY = 0, rotZ = 0},
    {obj = 2559, pos = Vector3(1161.5, -1348.7, -24.9), scale = 1, rotX = 0, rotY = 0, rotZ = 90},
    {obj = 1210, pos = Vector3(1161.4, -1344.7, -26.2), scale = 1, rotX = 0, rotY = 0, rotZ = 14},
    {obj = 10282, pos = Vector3(1162.9, -1347.6, -25.4), scale = 1, rotX = 0, rotY = 0, rotZ = 60},
}