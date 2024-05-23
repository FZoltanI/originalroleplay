function replaceModel()
  txd = engineLoadTXD("em.txd", 16207 )
  engineImportTXD(txd, 16207)
  dff = engineLoadDFF("em.dff", 16207 )
  engineReplaceModel(dff, 16207)
  col= engineLoadCOL ( "em.col" )
  engineReplaceCOL ( col, 16207 )
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

local trafficElements = {
  {1639.9573974609, -1592.4200439453, 13.452882766724 - 1.2, 90},
  {1596.9499511719, -1732.2944335938, 12.1828125, 90},
  {1037.513671875, -1686.5639648438, 12.1828125, 0},
  {1292.8082275391, -1280.943359375, 12.1828125, 270.07635498047},
  {2368.1584472656, -1732.2926025391, 12.1828125, 270},
  {1889.2575683594, -1340.876953125, 12.1828125, 270},
  {2343.916015625, 163.25543212891, 25.1359375, 180},
  {2578.8935546875, 41.655658721924, 25.1359375, 270.28491210938},
  {2431.0981445312, -1545.3553466797, 22.636164474487, 180.64120483398},
  {2212.6577148438, -1511.3365478516, 22.628125, 0},
  {1567.4906005859, -1440.9010009766, 12.1828125, 270.88195800781},
  {1669.3107910156, -979.00689697266, 36.692288208008, 261.86138916016},
  {2303.5578613281, -1276.1988525391, 22.639088439941, 0},
}


function createTrafficElements()
  for k, v in ipairs(trafficElements) do 
    local obj = createObject(16207, v[1], v[2], v[3], 0, 0, v[4])

    local colshape = createColSphere(v[1], v[2], v[3], 5)
    setElementData(colshape, "trafficElement:fekvorendor", obj)
  end
end
createTrafficElements()

--[[bindKey("num_5", "up", function()
  local x, y, z = getElementPosition(localPlayer)
  local rx, ry, rz = getElementRotation(localPlayer)

  setClipboard(x..", "..y..", "..(z - 1.2)..", "..rz)
end)]]

addEventHandler("onClientColShapeHit", resourceRoot, function(player, mdim)
  if player == localPlayer and mdim then 
    local obj = getElementData(source, "trafficElement:fekvorendor")

    if obj then 
      local veh = getPedOccupiedVehicle(localPlayer)

      if veh then 
        if getElementSpeed(veh, "km/h") < 30 then
          setElementCollisionsEnabled(obj, false)
        end
      end
    end
  end
end)

addEventHandler("onClientColShapeLeave", resourceRoot, function(col, mdim)
  if source == localPlayer and mdim then 
    local obj = getElementData(col, "trafficElement:fekvorendor")

    if obj then 
      setElementCollisionsEnabled(obj, true)
    end
  end
end)

function getElementSpeed(theElement, unit)
  -- Check arguments for errors
  assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
  local elementType = getElementType(theElement)
  assert(elementType == "player" or elementType == "ped" or elementType == "object" or elementType == "vehicle" or elementType == "projectile", "Invalid element type @ getElementSpeed (player/ped/object/vehicle/projectile expected, got " .. elementType .. ")")
  assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
  -- Default to m/s if no unit specified and 'ignore' argument type if the string contains a number
  unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
  -- Setup our multiplier to convert the velocity to the specified unit
  local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
  -- Return the speed by calculating the length of the velocity vector, after converting the velocity to the specified unit
  return (Vector3(getElementVelocity(theElement)) * mult).length
end