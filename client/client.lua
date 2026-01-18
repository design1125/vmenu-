local QBCore = exports['qb-core']:GetCoreObject()

-- Register the Command to open the menu
RegisterCommand('openvmenu', function()
   OpenvMenu()
end, false)

-- Key Mapping (Standard for QB-Core)
RegisterKeyMapping('openvmenu', 'Open Personal vMenu', 'keyboard', 'M') 

function OpenvMenu()
    exports['qb-menu']:openMenu({
        {
            header = "Personal vMenu",
            isMenuHeader = true, -- Set to true to make it a title
        },
        {
            header = "Heal Myself",
            txt = "Restore your health and hunger",
            params = {
                event = "vMenu:client:HealPlayer",
            }
        },
        {
            header = "Vehicle Options",
            txt = "Fix or Clean your current ride",
            params = {
                event = "vMenu:client:VehicleMenu",
            }
        },
        {
            header = "Close Menu",
            txt = "",
            params = {
                event = "qb-menu:closeMenu",
            }
        },
    })
end

-- Events for the Menu Actions
RegisterNetEvent('vMenu:client:HealPlayer', function()
    local ped = PlayerPedId()
    SetEntityHealth(ped, 200)
    TriggerServerEvent("QBCore:Server:SetMetaData", "hunger", 100)
    TriggerServerEvent("QBCore:Server:SetMetaData", "thirst", 100)
    QBCore.Functions.Notify("You have been healed!", "success")
end)

RegisterNetEvent('vMenu:client:VehicleMenu', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle ~= 0 then
        SetVehicleFixed(vehicle)
        SetVehicleDirtLevel(vehicle, 0.0)
        QBCore.Functions.Notify("Vehicle Repaired!", "primary")
    else
        QBCore.Functions.Notify("You aren't in a vehicle!", "error")
    end
end)