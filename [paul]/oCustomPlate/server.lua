function setVehPlate(veh,text) 
	setVehiclePlateText(veh,text)	
end 
addEvent("setVehPlate",true)
addEventHandler("setVehPlate",root,setVehPlate)

function takePP(element,pp)
	setElementData(element,"char:pp",getElementData(element,"char:pp") - pp)
end
addEvent("takePP",true)
addEventHandler("takePP",root,takePP)  

function takeMoney(element,money)
	setElementData(element,"char:money",getElementData(element,"char:money") - money)
end
addEvent("takeMoney",true)
addEventHandler("takeMoney",root,takeMoney)  