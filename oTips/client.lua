local hints = {
    {"Tetszik szerverünk? Ne tartsd magadban, hívd a barátaidat is!"},
    {"Ha munkát szeretnél felvenni, menj a városházára!"},
    {"Vigyázz, mert ha az életerőd 10 hp pont alá csökken, akkor animba esel! "},
    {"Ha buggot találsz akkor jelezd egy fejlesztő felé, Discord-on vagy a dashboardon keresztül. (dc.originalrp.eu)"},
    {"Ha panaszt szeretnél tenni egy játékosra, akkor azt fórumon megteheted. (https://www.originalrp.eu/forum/)"},
    {"Discord Szerverünk elérhetősége: https://dc.originalrp.eu"},
    {"Fórumunk elérhetősége: www.originalrp.eu/forum/"},
    {"Weboldalunk elérhetősége: www.originalrp.eu"},
} 

function printTip()
    if (exports.oDashboard:getDashboardSettingsValue("other", 4) or true) == true then
        outputChatBox(exports.oCore:getServerPrefix("server", "Tipp", 3)..hints[math.random(#hints)][1],255,255,255,true)
    end
end
setTimer(printTip, exports.oCore:minToMilisec(15), 0)