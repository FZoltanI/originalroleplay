--[[function attachTrailer(theTruck)
    setElementData(theTruck,"isTownedTrailer",source)
end
addEventHandler("onTrailerAttach", getRootElement(), attachTrailer)

function detachTrailer(theTruck)
    removeElementData(theTruck,"isTownedTrailer")
end
addEventHandler("OnTrailerDetach", getRootElement(), detachTrailer)]]


