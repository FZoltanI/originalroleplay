_dxDrawText = dxDrawText
local dxDrawText = function(text, position, size, ...)
    return _dxDrawText(text, position.x, position.y, position.x + size.x, position.y + size.y, ...)
end