actionBarSlotCount = 6

widgets = {
    --{"név",defaultX,defaultY,hossz,magassag,meretezheto,megjelenik, eltüntethető, maxW, maxH, minW, minH}
    {},
}

defaultWidgets = {
    --{"név",defaultX,defaultY,hossz,magassag,meretezheto,megjelenik, eltüntethető, maxW, maxH, minW, minH, meretezheto2 (true - letiltas)}
    {"Radar", 0.005,0.74,0.2,0.25,true,true,true,0.4,0.6,0.1,0.15},
    {"Infobox", 0.005,0.45,0.2,0.05,false,true,false,0,0,0,0},
    {"Actionbar", 0.42,0.93,0.024,0.046,false,true,true,0,0,0,0},
    {"Játékos Adatok", 0.76,0.009,0.24, 0.125,true,true,true,0.5,0.193,0.05,0.193, 2},
    {"Speedo", 0.86, 0.74, 0.145, 0.269, false, true, true, 0, 0, 0, 0},
    {"FPS", 0.8,0.11+0.02,0.04,0.03,false,false,true,0,0,0,0},
    {"Ping", 0.85,0.11+0.02,0.06,0.03,false,false,true,0,0,0,0},
    {"Sziréna panel", 0.41,0.8,0.17,0.09,false,true,true,0,0,0,0},
    {"Játékos név", 0.41,0.895,0.17,0.03,false,false,true,0,0,0,0},
    {"Videókártya információ", 0.21,0.74,0.150,0.150,false,false,true,0,0,0,0},
    --{"Idő", 0.8,0.09+0.02,0.045,0.03,false,false,true,0,0,0,0},
    {"Telefon", 0.85,0.25,0.145,0.51,false,true,true,0,0,0,0},
    --{"Fegyver", 0.87,0.14,0.128,0.115,false,true,true,0,0,0,0},
    {"Lőszer", 0.87,0.14+0.02,0.128,0.150,false,true,true,0,0,0,0},
    {"OOC Chat", 0.015, 0.39, 0.2, 0.25, true, true, false, 0.3, 0.3, 0.05, 0.06},
    --{"Pénz", 0.865, 0.09+0.02, 0.128, 0.03, false, true, true, 0.3, 0.3, 0.05, 0.06},
    --{"Prémium Pont", 0.79, 0.09+0.02, 0.128, 0.03, false, false, true, 0.3, 0.3, 0.05, 0.06},
    {"Oxigén szint", 0.7,0.01,0.04, 0.05, false, false, true, 0.3, 0.3, 0.05, 0.06},
    --{"Csontozat", 0.782, 0.02, 0.0135, 0.056, false, true, true, 0.3, 0.3, 0.05, 0.06},
    --{"Casino Coin", 0.865, 0.12+0.02, 0.128, 0.03, false, false, true, 0.3, 0.3, 0.05, 0.06},

    --{"Tempomat", 0.82, 0.68, 0.173, 0.03, false, true, true, 0.3, 0.3, 0.05, 0.06},
    {"Üzemanyag szint", 0.795, 0.865, 0.0725, 0.135, false, true, true, 0, 0, 0, 0},

    --{"HP", 0.804,0.009,0.193, 0.025,true,true,true,0.5,0.013,0.05,0.013, 1, true},
    --{"Armor", 0.804,0.029,0.193, 0.025,true,true,true,0.5,0.013,0.05,0.013, 1, true},
    --{"Étel/Ital", 0.804,0.049,0.193, 0.025,true,true,true,0.5,0.013,0.05,0.013, 1, true},
    --{"Stamina", 0.804,0.069,0.193, 0.025,true,true,true,0.5,0.013,0.05,0.013, 1, true},
    {"Alkohol szint", 0.73,0.01,0.04, 0.05,false,true,true,0.5,0.013,0.05,0.013, 1, true},

}

core = exports.oCore
color, r, g, b = core:getServerColor()
serverName = core:getServerName() 
chatPrefix = color.."[Interface]: #ffffff"

redR, redG, redB = 181, 74, 74
blueR, blueG, blueB = 80, 167, 222
greenR, greenG, greenB = 132, 217, 142