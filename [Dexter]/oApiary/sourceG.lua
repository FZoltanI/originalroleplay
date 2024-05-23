honeyType = {
    {"Akácméz", 6},
    {"Hársméz", 5},
    {"Vegyes virágméz", 4},
    {"Erdei vegyes méz", 4},
}

core = exports.oCore
info = exports.oInfobox
font = exports.oFont


characterIDElementData = "char:id"
moneyElementData = "char:money"
premiumElementData = "char:pp"
playerNameElementData = "char:name"

-- # Times
openTime = 20*60*60*1000 -- 20 óráig maradhat nyitva
closeTime = 20*60*60*1000 -- 20 óráig maradhat zárva
cleaningTime = 1000 --60*60*60*1000 -- 12 óránként kell tisztítani
gettingHoney = 5000


-- # Item functions