-----------------------
----   Variabler   ----
-----------------------

local QBCore = exports['qb-core']:GetCoreObject()
local scenes = {}


-----------------------
----    Tråder    ----
-----------------------

-- Sjekker jevnlig for utløpte scener
CreateThread(function()
    UpdateAllScenes()
    while true do
        DeleteExpiredScenes()
        Wait(Config.AuditInterval)
    end
end)


-----------------------
---- Server-Events ----
-----------------------

-- Henter alle scener (callback til klient)
QBCore.Functions.CreateCallback("qbx_scenes:server:GetScenes", function(_, cb)
    cb(scenes)
end)

-- Slett scene manuelt
RegisterNetEvent("qbx_scenes:server:DeleteScene", function(id)
    MySQL.Async.execute("DELETE FROM scenes WHERE id = ?", { id }, function()
        UpdateAllScenes()
    end)
end)

-- Opprett ny scene
RegisterNetEvent("qbx_scenes:server:CreateScene", function(sceneData)
    local src    = source
    local Player = QBCore.Functions.GetPlayer(src)

    -- Logging
    TriggerEvent(
        "qb-log:server:CreateLog",
        "scenes",
        "Ny Scene Opprettet",
        "red",
        "**" .. GetPlayerName(src) ..
        "** (citizenid: *" .. Player.PlayerData.citizenid ..
        "* | id: *" .. src .. "*) opprettet en ny scene; scene: **" ..
        sceneData.text .. "**, hvor: **" .. sceneData.coords .. "**"
    )

    -- Lagre i database
    MySQL.Async.insert(
        "INSERT INTO scenes (creator, text, color, viewdistance, expiration, fontsize, fontstyle, coords, date_creation, date_deletion) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW(), DATE_ADD(NOW(), INTERVAL ? HOUR))",
        {
            Player.PlayerData.citizenid,
            sceneData.text,
            sceneData.color,
            sceneData.viewdistance,
            sceneData.expiration,
            sceneData.fontsize,
            sceneData.fontstyle,
            json.encode(sceneData.coords),
            sceneData.expiration
        },
        function()
            UpdateAllScenes()
        end
    )
end)


-----------------------
----   Funksjoner  ----
-----------------------

-- Oppdaterer alle scener fra databasen
function UpdateAllScenes()
    scenes = {}

    MySQL.Async.fetchAll("SELECT * FROM scenes", {}, function(result)
        if result[1] then
            for _, v in pairs(result) do
                local newCoords = json.decode(v.coords)

                scenes[#scenes + 1] = {
                    id          = v.id,
                    text        = v.text,
                    color       = v.color,
                    viewdistance= v.viewdistance,
                    expiration  = v.expiration,
                    fontsize    = v.fontsize,
                    fontstyle   = v.fontstyle,
                    coords      = vector3(newCoords.x, newCoords.y, newCoords.z),
                }
            end
        end

        TriggerClientEvent("qbx_scenes:client:UpdateAllScenes", -1, scenes)
    end)
end

-- Sletter alle utløpte scener
function DeleteExpiredScenes()
    MySQL.Async.execute("DELETE FROM scenes WHERE date_deletion < NOW()", {}, function(result)
        if result > 0 then
            print("🗑️ Slettet " .. result .. " utløpte scener fra databasen.")
            UpdateAllScenes()
        end
    end)
end
