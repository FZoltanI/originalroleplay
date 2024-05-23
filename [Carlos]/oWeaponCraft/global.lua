crafts = {
    -- fragment iron plastic wood
    {item = 32, craftItems = {{211, 0}, {203, 6}, {201, 4}, {202, 0}}, faction = false, count = 1, needPercent = 90}, -- Kés 0 6 4 0
    {item = 34, craftItems = {{211, 7}, {203, 2}, {201, 0}, {202, 3}}, faction = 5, count = 1, needPercent = 25}, -- Sörétes 7 2 0 3
    {item = 37, craftItems = {{211, 4}, {203, 3}, {201, 0}, {202, 0}}, faction = 4, count = 1, needPercent = 25}, -- Colt 4 3 0 0
    {item = 39, craftItems = {{211, 10}, {203, 4}, {201, 0}, {202, 0}}, faction = 5, count = 1, needPercent = 25}, -- P90 10 4 0 0
    {item = 40, craftItems = {{211, 11}, {203, 4}, {201, 0}, {202, 0}}, faction = 4, count = 1, needPercent = 25}, -- UZI 11 4 0 0
    {item = 42, craftItems = {{211, 10}, {203, 4}, {201, 3}, {202, 0}}, faction = 5, count = 1, needPercent = 25}, -- TEC 10 4 3 0
    {item = 27, craftItems = {{211, 20}, {203, 4}, {201, 0}, {202, 3}}, faction = 5, count = 1, needPercent = 25}, -- AK 20 4 0 3
    {item = 28, craftItems = {{211, 25}, {203, 5}, {201, 2}, {202, 0}}, faction = 5, count = 1, needPercent = 25}, -- M4 -- 25 5 2 0

    -- Lőszer
    {item = 45, craftItems = {{211, 1}, {203, 2}, {201, 0}, {202, 0}}, faction = {4, 5}, count = 15, needPercent = 99}, -- Nagykaliber -- 1 2 0 0
    {item = 46, craftItems = {{211, 1}, {203, 1}, {201, 1}, {202, 0}}, faction = {4, 5}, count = 5, needPercent = 99}, -- Sörétes -- 1 1 1 0
    {item = 47, craftItems = {{211, 1}, {203, 1}, {201, 0}, {202, 0}}, faction = false, count = 10, needPercent = 99}, -- Kiskaliber -- 1 1 0 0
    {item = 48, craftItems = {{211, 1}, {203, 1}, {201, 0}, {202, 0}}, faction = {4, 5}, count = 15, needPercent = 99}, -- 5x9 -- 1 1 0 0
    {item = 49, craftItems = {{211, 2}, {203, 2}, {201, 0}, {202, 0}}, faction = {4, 5}, count = 5, needPercent = 99}, -- Sniper -- 2 2 0 0
}

inventory = exports.oInventory
fonts = exports.oFont
core = exports.oCore
dashboard = exports.oDashboard
infobox = exports.oInfobox
chat = exports.oChat
color, r, g, b = core:getServerColor()