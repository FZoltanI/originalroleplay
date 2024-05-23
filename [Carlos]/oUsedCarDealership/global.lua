-- Exports
core = exports.oCore
color, r, g, b = core:getServerColor()
mysql = exports.oMysql
admin = exports.oAdmin
font = exports.oFont
vehicle = exports.oVehicle

-- Objects
laptopObject = 702
deskObject = 2607

maxCarshopCount = 3
carPositionsPerShop = 15

-- Panel
navbarMenus = {
    {"Kiállító pozíciók kezelése"}, 
    {"Járművek kezelése"}, 
    {"Tagok kezelése"}, 
    {"Pénz kezelése"},
}

panelColors = {
    ["red"] = "#e84c41",
    ["green"] = "#93d94e",
}

carshopRights = {
    {"Jármű felvásárlása", "buyVeh"},
    {"Jármű kiállítása/beárazása", "sellVeh"},
    {"Jármű bezúzatása", "destroyVeh"},
    {"Tagok felvétele", "addMember"},
    {"Tagok kirúgása", "removeMember"},
    {"Tagok fizetésének módosítása", "setPayment"},
    {"Tagok jogainak módosítása", "setRights"},
    {"Pénz kivétele", "takeOutMoney"},
    {"Pénz befizetése", "takeInMoney"},
}