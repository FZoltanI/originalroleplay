local sx, sy = guiGetScreenSize()
local myX, myY = 1768, 992

local ticket_datas = {
    name = "",
    nplate = "",
    money = "",
    year = "",
    month = "",
    day = "",
    time = "",
    place = "",
}

-- név hossza, rendszám hossza, bírság hossza, rendszám, bírság, dátum, idő, helyszín
local data = "012 6 4 Carlos_White 00aaff 5000 20200530 1816 LittleMexico"
local ticketType = "speed"

local sizes = {
    ["speedTicket"] = 0.5,
}

local fonts = {
    ["desyrel-18"] = exports.oFont:getFont("desyrel", 18),
}

local showing = false

function renderTicket()
    if ticketType == "speed" then 
        dxDrawImage(sx*0.5 - (700/myX*sx*sizes["speedTicket"]/2), sy*0.3, 700/myX*sx*sizes["speedTicket"], 749/myY*sy*sizes["speedTicket"], "files/speedticket.png")
        --dxDrawRectangle(sx*0.5 - (700/myX*sx*sizes["speedTicket"]/2) + sx*0.015, sy*0.56, sx*0.17, sy*0.028)
        dxDrawText(ticket_datas.nplate, sx*0.5 - (700/myX*sx*sizes["speedTicket"]/2) + sx*0.01, sy*0.39, sx*0.5 - (700/myX*sx*sizes["speedTicket"]/2) + sx*0.01+sx*0.108, sy*0.39+sy*0.062, tocolor(11, 133, 189, 255), 1/myX*sx, fonts["desyrel-18"], "center", "center")
        dxDrawText(ticket_datas.name, sx*0.5 - (700/myX*sx*sizes["speedTicket"]/2) + sx*0.015, sy*0.515, sx*0.5 - (700/myX*sx*sizes["speedTicket"]/2) + sx*0.015+sx*0.17, sy*0.515+sy*0.026, tocolor(11, 133, 189, 255), 0.7/myX*sx, fonts["desyrel-18"], "left", "center")
        dxDrawText(ticket_datas.place, sx*0.5 - (700/myX*sx*sizes["speedTicket"]/2) + sx*0.015, sy*0.56, sx*0.5 - (700/myX*sx*sizes["speedTicket"]/2) + sx*0.015+sx*0.17, sy*0.56+sy*0.026, tocolor(11, 133, 189, 255), 0.7/myX*sx, fonts["desyrel-18"], "left", "center")
    
        --dxDrawRectangle(sx*0.5 - (700/myX*sx*sizes["speedTicket"]/2) + sx*0.09, sy*0.475, sx*0.09, sy*0.022)
        dxDrawText(ticket_datas.year, sx*0.5 - (700/myX*sx*sizes["speedTicket"]/2) + sx*0.01, sy*0.475, sx*0.5 - (700/myX*sx*sizes["speedTicket"]/2) + sx*0.01+sx*0.023, sy*0.475+sy*0.022, tocolor(11, 133, 189, 255), 0.55/myX*sx, fonts["desyrel-18"], "center", "center")
        dxDrawText(ticket_datas.month, sx*0.5 - (700/myX*sx*sizes["speedTicket"]/2) + sx*0.033, sy*0.475, sx*0.5 - (700/myX*sx*sizes["speedTicket"]/2) + sx*0.033+sx*0.027, sy*0.475+sy*0.022, tocolor(11, 133, 189, 255), 0.6/myX*sx, fonts["desyrel-18"], "center", "center")
        dxDrawText(ticket_datas.day, sx*0.5 - (700/myX*sx*sizes["speedTicket"]/2) + sx*0.06, sy*0.475, sx*0.5 - (700/myX*sx*sizes["speedTicket"]/2) + sx*0.06+sx*0.023, sy*0.475+sy*0.022, tocolor(11, 133, 189, 255), 0.6/myX*sx, fonts["desyrel-18"], "center", "center")
        
        dxDrawText(ticket_datas.time, sx*0.5 - (700/myX*sx*sizes["speedTicket"]/2) + sx*0.09, sy*0.47, sx*0.5 - (700/myX*sx*sizes["speedTicket"]/2) + sx*0.09+sx*0.09, sy*0.47+sy*0.022, tocolor(11, 133, 189, 255), 0.75/myX*sx, fonts["desyrel-18"], "left", "center")
        
        dxDrawText(ticket_datas.money, sx*0.5 - (700/myX*sx*sizes["speedTicket"]/2) + sx*0.125, sy*0.605, sx*0.5 - (700/myX*sx*sizes["speedTicket"]/2) + sx*0.125+sx*0.061, sy*0.605+sy*0.045, tocolor(11, 133, 189, 255), 0.9/myX*sx, fonts["desyrel-18"], "left", "bottom")
    end
end

function showTicket(value)
    if not showing then 
        local nameLength = tonumber(string.sub(value, 1, 3))-1
        local nPlateLength = tonumber(string.sub(value, 4, 4))
        local moneyLength = tonumber(string.sub(value, 5, 5))

        ticket_datas.name = string.sub(value, 6, 6+nameLength):gsub("_", " ")
        ticket_datas.nplate = string.sub(value, 6+nameLength+1, 6+nameLength+nPlateLength)
        ticket_datas.money = string.sub(value, 6+nameLength+nPlateLength+1, 6+nameLength+nPlateLength+moneyLength)

        local count = 6+nameLength+nPlateLength+moneyLength+1
        ticket_datas.year = string.sub(value, count, count+3)
        count = count+4
        ticket_datas.month = string.sub(value, count, count+2)
        count = count+3
        ticket_datas.day = string.sub(value, count, count+1)
        count = count+2
        ticket_datas.time = string.sub(value, count, count+4)
        count = count+5
        ticket_datas.place = string.sub(value, count):gsub("_", " ")
        addEventHandler("onClientRender", root, renderTicket)
    else
        removeEventHandler("onClientRender", root, renderTicket)
    end 

    showing = not showing
end
--showTicket("01264Carlos_White00aaff50002020MAY3018:16Little_Mexico")