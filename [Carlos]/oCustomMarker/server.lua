function createCustomMarkerServer(x, y, z, size, r, g, b, a, type, outlineType)

    if not outlineType then 
        outlineType = "octagon"
    end

    if not type then 
        type = "arrow"
    end

    if not size then 
        size = 2.0
    end

    local marker = createMarker(x, y, z-1, "cylinder", size/2, r, g, b, a)

    setElementData(marker, "isCustomMarker", true)
    setElementData(marker, "customMarkerType", type)
    setElementData(marker, "customMarkerOutline", outlineType)
    setElementData(marker,"showCustomMarker",true)

    setElementAlpha(marker, 0)

    return marker
end 