typeName = {
    [1] = "Blood Suckers 2"
}

core = exports.oCore
infobox = exports.oInfobox
font = exports.oFont
color, r, g, b = core:getServerColor()
serverColor, r, g, b = core:getServerColor()

function getSlotMachineTypeName(type)
    return typeName[type] or "Hibás gép"
end