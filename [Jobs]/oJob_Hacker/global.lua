core = exports.oCore
infobox = exports.oInfobox
color, r, g, b = core:getServerColor()

hackTexts = {"ping", "write", "init", "setnewid", "bytes", "get", "count", "mysql", "domain", "username", "generate", "join", "stat", "reset", "size", "xml", "file", "upload", "system", "load", "lua", "html", "php", "javascript"}
companys = {"Bank Of America", "OriginalShop Co.", "Walmart Inc.", "Ford Motorss Co.", "Amazon Inc.", "Apple Inc.", "CVS Health Co.", "AT&T Inc.", "Chevron Co.", "Microsoft Co.", "Dell Technologies Inc.", "IBM Co.", "American Express Co.", "NIKE Inc.", "Publix Super Markets Inc.", "Exelon Co.", "Jabil Inc.", "Visa Inc.", "Netflix Inc.", "Altria Group Inc.", "Salesforce Inc.", "Ecolab Inc.", "BlackRock Inc.", "Uber Technologies", "eBay", "PulteGroup", "Xerox Holdings Co.", "Masco Co.", "JetBlue Airways", "The Clorox Co.", "Cerner Co."}

accessStates = {
    ["granted"] = {"ACCESS \n GRANTED", tocolor(0, 255, 0, 255)},
    ["denied"] = {"ACCESS \n DENIED", tocolor(255, 0, 0, 255)},
}

function generateRandomIP()
    local ip = ""

    for i = 1, 4 do 
        ip = ip .. math.random(1, 255)

        if i < 4 then  
            ip = ip .. "."
        end
    end

    return ip
end

deniedKeyboardLetters = {
    ["arrow_u"] = true,
    ["arrow_d"] = true,
    ["arrow_l"] = true,
    ["arrow_r"] = true,
    ["pgdn"] = true,
}