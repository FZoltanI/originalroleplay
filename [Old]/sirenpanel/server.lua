--- A scriptet készitette Anthony
 
function Sirena (car, thePlayer)
	local  car = getPedOccupiedVehicle(source)
	local model = getElementModel(car)
	if (car) and isElement(car) then
		if (model==598) then
			if not getVehicleSirensOn (car) then
				setVehicleSirensOn (car, true) 
				addVehicleSirens(car, 2, 2, false, true, true, true)
				setVehicleSirens(car, 1, 0.4, -0.3, 1.05, 255, 0, 0, 198.9, 198.9)
				setVehicleSirens(car, 2, -0.4, -0.3, 1.05, 0, 0, 255, 198.9, 198.9)
			elseif getVehicleSirensOn (car, true ) then
				setVehicleSirensOn (car, false) 
			end
		elseif (model==596) then
			if not getVehicleSirensOn (car) then
				setVehicleSirensOn (car, true) 
				addVehicleSirens(car, 2, 2, false, true, true, true)
				setVehicleSirens(car, 1, 0.4, -0.25, 0.8, 255, 0, 0, 198.9, 198.9)
				setVehicleSirens(car, 2, -0.4, -0.25, 0.8, 0, 0, 255, 198.9, 198.9)
			elseif getVehicleSirensOn (car, true ) then
				setVehicleSirensOn (car, false) 
			end 
		end 
	end 
end
addEvent("siren", true)
addEventHandler ( "siren",getRootElement(), Sirena )

addEvent("play3DSound",true)
addEventHandler("play3DSound", root,
	function(vehicle,sound_name)
		local siren = getElementData(vehicle,"siren:"..sound_name) or false

		if not siren then
			triggerClientEvent(root,"playSoundOnClient",root,vehicle,sound_name, "on")
			setElementData(vehicle,"siren:"..sound_name, true)
		else
			triggerClientEvent(root,"playSoundOnClient",root,vehicle,sound_name, "off")
			setElementData(vehicle,"siren:"..sound_name, false)
		end
	end 
)