-- Define locations: {teleportA = vector4, teleportB = vector4}
local file = LoadResourceFile(GetCurrentResourceName(), "locations.json")
local locations = json.decode(file)

-- To use as vector4:
for _, loc in ipairs(locations) do
    loc.teleportA = vector4(loc.teleportA.x, loc.teleportA.y, loc.teleportA.z, loc.teleportA.w)
    loc.teleportB = vector4(loc.teleportB.x, loc.teleportB.y, loc.teleportB.z, loc.teleportB.w)
end

local teleportDistance = 2.0 -- Distance within which the player can teleport
local key = 38 -- "E" key

-- Check the player's proximity to teleport points
CreateThread(function()
    while true do
        local playerPed = PlayerPedId(-1) -- Get the player's Ped
        local playerCoords = GetEntityCoords(playerPed) -- Get the player's current position

        for _, location in pairs(locations) do
            -- Convert teleportA and teleportB to vector3 for distance calculation
            local teleportA3 = vector3(location.teleportA.x, location.teleportA.y, location.teleportA.z)
            local teleportB3 = vector3(location.teleportB.x, location.teleportB.y, location.teleportB.z)

            local distanceA = #(playerCoords - teleportA3)
            local distanceB = #(playerCoords - teleportB3)

            -- If the player is close to the teleportA point, show help text and wait for key press
            if distanceA <= teleportDistance then
                DrawText3D(location.teleportA.x, location.teleportA.y, location.teleportA.z, "[Press E to teleport]")

                if IsControlJustPressed(0, key) then
                    -- Teleport player to the teleportB location
                    SetEntityCoords(playerPed, location.teleportB.x, location.teleportB.y, location.teleportB.z, false, false, false, true)
                    SetEntityHeading(playerPed, location.teleportB.w) -- Set the heading (direction) of the player
                end
            end

            -- If the player is close to the teleportB point, show help text and wait for key press
            if distanceB <= teleportDistance then
                DrawText3D(location.teleportB.x, location.teleportB.y, location.teleportB.z, "[Press E to teleport]")

                if IsControlJustPressed(0, key) then
                    -- Teleport player to the teleportA location
                    SetEntityCoords(playerPed, location.teleportA.x, location.teleportA.y, location.teleportA.z, false, false, false, true)
                    SetEntityHeading(playerPed, location.teleportA.w) -- Set the heading (direction) of the player
                end
            end
        end

        Wait(0) -- Run every frame
    end
end)

-- Function to display text in 3D space
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEntry("STRING")
    SetTextCentre(1)

    AddTextComponentString(text)
    DrawText(_x, _y)

    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 75)
end