core = exports.oCore
bone = exports.oBone
infobox = exports.oInfobox
font = exports.oFont
inventory = exports.oInventory
chat = exports.oChat
color, r, g, b = core:getServerColor()

cursorMovingNumber = 10

fishesTable = {
    {id = 127, multiplier = 5},
    {id = 128, multiplier = 4},
    {id = 129, multiplier = 5},
    {id = 130, multiplier = 6},
    {id = 131, multiplier = 3},
    {id = 132, multiplier = 4},
    {id = 133, multiplier = 3},
    {id = 134, multiplier = 1},
    {id = 135, multiplier = 1},

    {id = 136, multiplier = 3},
    {id = 137, multiplier = 3},
    {id = 138, multiplier = 4},
    {id = 139, multiplier = 5},
    --{id = 140, multiplier = 1},
    --{id = 141, multiplier = 1},
}

fishes = {}

kapasTimes = {240000, 100000}

for k, v in ipairs(fishesTable) do 
    for i = 1, v.multiplier do 
        table.insert(fishes, v.id)
    end
end