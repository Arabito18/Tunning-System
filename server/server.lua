QBCore = exports['qb-core']:GetCoreObject()

if Config.WebHook and Config.WebHook ~= "" then
    function sendToDiscord(name, message, color)
        local DiscordWebHook = Config.WebHook

        local embeds = {
            {
                ["title"] = message,
                ["type"] = "rich",
                ["color"] = color,
            }
        }

        if message == nil or message == '' then return false end
        PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name, embeds = embeds }), { ['Content-Type'] = 'application/json' })
    end
end

RegisterServerEvent('TunningSystem3hu:Used')
AddEventHandler('TunningSystem3hu:Used', function(id)
    local _source = source
    if Config.TunningLocations[id].used == _source then
        if SendUsed then
            SendUsed(id, false)
        else
            print("TunningSystem3hu: READ README, YOUR TRANSID IS INVALID, SCRIPT WON'T WORK")
        end
    else
        -- cheateeer
    end
end)

QBCore.Functions.CreateCallback('TunningSystem3hu:Used', function(source, cb, id, netid)
    local enviar = false
    if not Config.TunningLocations[id].used then
        enviar = true
        if SendUsed then
            SendUsed(id, source)
        else
            print("TunningSystem3hu: READ README, YOUR TRANSID IS INVALID, SCRIPT WON'T WORK")
        end
    end
    cb(enviar)
    while Config.TunningLocations[id].used do
        Wait(10000)
        if GetPlayerPing(source) <= 0 then
            DeleteEntity(NetworkGetEntityFromNetworkId(netid))
            if SendUsed then
                SendUsed(id, false)
            else
                print("TunningSystem3hu: READ README, YOUR TRANSID IS INVALID, SCRIPT WON'T WORK")
            end
        end
    end
end)

RegisterServerEvent('TunningSystem3hu:PayModifications')
AddEventHandler('TunningSystem3hu:PayModifications', function(preco, id, vehprops)
    local config = Config.TunningLocations[id]
    local _source = source
    local pago = false
    local Player = QBCore.Functions.GetPlayer(_source)
    local whyisitasync = false
    if config.used == _source then
        local permitido = true
        if config.job then
            permitido = false
            if Player.PlayerData.job.name == config.job then
                permitido = true
            end
        end
        if permitido then
            if config.society and config.job then
                local societyAccount = QBCore.Functions.GetSocietyAccount(config.job)
                if societyAccount then
                    if societyAccount.money >= preco then
                        societyAccount.money = societyAccount.money - preco
                        if config.societypercentage then
                            if config.societypercentage >= 0 and config.societypercentage < 100 then
                                local playerpercentage = 1.0 - (config.societypercentage / 100)
                                local playerwin = playerpercentage * preco
                                if playerwin > 0 then
                                    Player.Functions.AddMoney("bank", playerwin)
                                    -- you won playerwin €
                                end
                            end
                        end
                        pago = true
                        whyisitasync = true
                    else
                        -- The society don't have money
                        whyisitasync = true
                    end
                else
                    -- Society account not found
                    whyisitasync = true
                end
            else
                if Player.PlayerData.money.bank >= preco then
                    pago = true
                    Player.Functions.RemoveMoney("bank", preco)
                    whyisitasync = true
                else
                    -- You don't have moneyyyyy
                    whyisitasync = true
                end
            end
        else
            -- cheater
            whyisitasync = true
        end
    else
        whyisitasync = true
        -- cheater probably
    end
    while not whyisitasync do
        Wait(100)
    end
    if pago then
        SaveVehicle(vehprops)
        if Config.WebHook and Config.WebHook ~= "" then
            sendToDiscord('Mechanic Upgrade/Tuning Logs', "[Upgrade/Tuning Logs]\n\nTotal: " .. preco .. "\n\nVehicle Plate Number: [" .. vehprops.plate .. "]\nMechanic that worked on the vehicle: " .. Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname, 11750815)
        end
    end
    TriggerClientEvent("TunningSystem3hu:PayAfter", _source, pago)
end)

if Config.MysqlAsync then
    function SaveVehicle(vehprops)
        MySQL.Async.fetchAll('SELECT vehicle FROM owned_vehicles WHERE plate = @plate', {
            ['@plate'] = vehprops.plate
        }, function(result)
            if result[1] then
                local vehicle = json.decode(result[1].vehicle)

                if vehprops.model == vehicle.model then
                    MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehicle WHERE plate = @plate', {
                        ['@plate'] = vehprops.plate,
                        ['@vehicle'] = json.encode(vehprops)
                    })
                    TriggerEvent("esx_lscustom:refreshOwnedVehicle", vehprops)
                else
                    -- cheateeeer
                end
            end
        end)
    end
else
    function SaveVehicle(vehprops)
        exports.ghmattimysql:execute('SELECT vehicle FROM owned_vehicles WHERE plate = @plate', {
            ['@plate'] = vehprops.plate
        }, function(result)
            if result[1] then
                local vehicle = json.decode(result[1].vehicle)

                if vehprops.model == vehicle.model then
                    exports.ghmattimysql:execute('UPDATE owned_vehicles SET vehicle = @vehicle WHERE plate = @plate', {
                        ['@plate'] = vehprops.plate,
                        ['@vehicle'] = json.encode(vehprops)
                    })
                    TriggerEvent("esx_lscustom:refreshOwnedVehicle", vehprops)
                else
                    -- cheateeeer
                end
            end
        end)
    end
end

function SendUsed(id, type)
    Config.TunningLocations[id].used = type
    TriggerClientEvent("TunningSystem3hu:Used", -1, id, type)
end