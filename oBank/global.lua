core = exports.oCore
font = exports.oFont
infobox = exports.oInfobox
chat = exports.oChat
color, r, g, b = core:getServerColor()

mainPageTexts = {
    {title = "Üdvözöljük!", texts = {
        "Üdvözlünk az originalRoleplay bankban!",
    }},
}

points = {
    --{"Áttekintés", "bank.png", hasKeyboard?},
    {"Számlák kezelése", "creditcard.png", true, "PIN"},
    {"Tranzakciók", "logs.png", true, "ÖSSZEG"},
    {"Utalás", "transaction.png", true, "ÖSSZEG"},
}

controlPoints = {
    {"PIN kód módosítása", ""}, 
    {"Bankkártya igénylése #72b368(250$)", ""}, 
    {"Beállítás elsődleges számlának", ""}, 
    {"Számla törlése", ""},
}

transactionPoints = {
    {"Kivétel", ""}, 
    {"Befizetés", ""},
    {"Előzmények \ntörlése", ""},
}
transferPoints = {
    {"Utalás", ""}, 
    {"Előzmények \ntörlése", ""},
}

bankPeds = {
    {skin = 147, pos = Vector3(1677.5118408203, -1189.515625, 23.837814331055), rot = 270, name = "Joss Jarvis"}, -- LS
    --{skin = 147, pos = Vector3(1308.7027587891, -1331.2517089844, 13.800000190735), rot = 180, name = "River Patterson"},

    {skin = 187, pos = Vector3(2306.66015625, -1.638267993927, 26.7421875), rot = 280, name = "Hubert Murray"}, -- Palomino

    
}