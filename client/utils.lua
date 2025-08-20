-----------------------
----   Utilities   ----
-----------------------

-- Konverterer rotasjon (kamera) til en retning i verden
function RotationToDirection(rotation)
    local adjustedRotation = {
        x = (math.pi / 180) * rotation.x,
        y = (math.pi / 180) * rotation.y,
        z = (math.pi / 180) * rotation.z
    }

    local direction = {
        x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        y =  math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        z =  math.sin(adjustedRotation.x)
    }

    return direction
end

-- Utfører en raycast fra spillkameraet og returnerer treff
function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
    local cameraCoord    = GetGameplayCamCoord()
    local direction      = RotationToDirection(cameraRotation)

    local destination = {
        x = cameraCoord.x + direction.x * distance,
        y = cameraCoord.y + direction.y * distance,
        z = cameraCoord.z + direction.z * distance
    }

    local _, hit, endCoords, _, _ = GetShapeTestResult(
        StartShapeTestRay(
            cameraCoord.x, cameraCoord.y, cameraCoord.z,
            destination.x, destination.y, destination.z,
            -1, PlayerPedId(), 0
        )
    )

    return hit == 1, endCoords
end

-- Konverterer hex-farge (#FFFFFF) til RGB
function rgbToHex(hex)
    hex = hex:gsub("#", "")
    return tonumber("0x" .. hex:sub(1, 2)),
           tonumber("0x" .. hex:sub(3, 4)),
           tonumber("0x" .. hex:sub(5, 6))
end

-- Tegner enkel 2D-tekst på skjermen
function Draw2DText(content, font, colour, scale, x, y)
    SetTextFont(font)
    SetTextScale(scale, scale)
    SetTextColour(colour[1], colour[2], colour[3], 255)
    SetTextEntry("STRING")

    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()

    AddTextComponentString(content)
    DrawText(x, y)
end
