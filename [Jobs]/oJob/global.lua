jobs = {
    ---név, leírás, elérheő(true/false), dupla fizetés(true/false) <-- frissül mindenhol ha duplán keres(csak itt kell átírni!!!), munkavégzés helye, fontawesome (True = using / false not using), (Icon (ha a fontawesome false akkor tudod használni))
    {"Takarító","Takarítsd ki a házakat és a lakásokat Los Santosban.", true, true, "Los Santos, Red County", "", true},
    {"Pénztáros","Los Santos boltjaiban szolgáld ki a vásálókat!", true, true, "Los Santos, Red County", "",true},
    {"Pizzakészítő","Szolgáld ki a vásárlókat.", true, true, "Los Santos", "",true},
    {"Etikus Hacker","Hackeld meg a megbízóidat.", true, true, "Los Santos", "",true},
    {"Újságos","Hord ki az újságokat Los Santosban.", true, true, "Red County", "",true},
    {"Költöztető", "Szállíts bútorokat a megrendelő lakásai között.", true, true, "Los Santos", "",true},
    {"Kertész", "Gondozd a növényeket Los Santosban.", true, true, "Los Santos, Red County", "",true},
    {"Darukezelő", "Kezeld a darukat a városban található építkezéseken.", true, false, "Los Santos", "",true},
   
    --{"Építő munkás", "Építs házakat Las Venturasban.", true, false, "Las Venturas", ""},
}

core = exports.oCore
color, r, g, b = core:getServerColor()
info = exports.oInfobox
font = exports.oFont
errorcolor = "#CE2A2A"
moneycolor = "#81c442"

redR, redG, redB = 199, 54, 54
greenR, greenG, greenB = 137, 201, 95
blueR, blueG, blueB = 66, 118, 201

function isJobHasDoublePaymant(jobID)
    return jobs[jobID][4]
end

function getJobName(jobID) 
    return jobs[jobID][1]
end