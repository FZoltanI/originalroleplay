local obj = createObject(3997, 1479.3496, -1802.2998, 12.56)
local lowLOD = createObject(3997, 1479.3496, -1802.2998, 12.56, 0, 0, 0, true)
setLowLODElement(obj, lowLOD)
engineSetModelLODDistance(3997, 4000)