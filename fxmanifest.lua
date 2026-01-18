fx_version 'cerulean'
game 'gta5'

description 'Custom QBCore Car Check and vMenu'
author 'Gemini'
version '1.0.0'

shared_script 'config.lua'
client_script 'client.lua'
server_script 'server.lua'

local QBCore = exports['qb-core']:GetCoreObject()

-- Open menu with /vmenu or bind a key
RegisterCommand('vmenu', function()
    OpenCarMenu()
end)

function OpenCarMenu()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh == 0 then return QBCore.Functions.Notify("Not in a vehicle", "error") end

    local menu = {
        { header = "?? Vehicle Control", isMenuHeader = true },
        { header = "Toggle Engine", params = { event = "vmenu:client:engine" } },
        { header = "Door Controls", params = { event = "vmenu:client:doors" } },
        { header = "Check Vehicle Info", params = { event = "vmenu:client:check" } },
        { header = "? Close", params = { event = "qb-menu:client:closeMenu" } }
    }
    exports['qb-menu']:openMenu(menu)
end

RegisterNetEvent('vmenu:client:engine', function()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    SetVehicleEngineOn(veh, not GetIsVehicleEngineRunning(veh), false, true)
end)

RegisterNetEvent('vmenu:client:check', function()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    local plate = QBCore.Functions.GetPlate(veh)
    TriggerServerEvent('vmenu:server:checkOwner', plate)
end)

local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('vmenu:server:checkOwner', function(plate)
    local src = source
    MySQL.Async.fetchAll('SELECT * FROM player_vehicles WHERE plate = ?', {plate}, function(result)
        if result[1] then
            local char = json.decode(result[1].charinfo) -- This depends on your DB structure
            TriggerClientEvent('QBCore:Notify', src, "Owner: " .. result[1].citizenid, "primary")
        else
            TriggerClientEvent('QBCore:Notify', src, "Vehicle not registered", "error")
        end
    end)
end)