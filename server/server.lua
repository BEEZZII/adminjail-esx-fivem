ESX = nil
MySQL = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


function sendDiscord(author, title, text)

    url = server_Config.Webhook

    local embeds = {
        {
            ["title"] = title,
            ["type"] = "rich",
            ["color"] = 16711680,
            ["description"] = text,
            ["footer"] = {
                ["text"] = server_Config.ServerName
            }
        }
    }

    PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({username = server_Config.ServerName, embeds = embeds}), { ['Content-Type'] = 'application/json'})
end


ESX.RegisterServerCallback('AdminJail:getGroup', function(src, cb)

    local xPlayer = ESX.GetPlayerFromId(src)
    cb(xPlayer.getGroup())
end)

ESX.RegisterServerCallback('AdminJail:getAufenthalte', function(src, cb, player)
    local xPlayer = ESX.GetPlayerFromId(player)

    local aufenthalte = MySQL.Sync.fetchScalar("SELECT aufenthalteAdmin FROM users WHERE identifier = @identifier", {
        ['@identifier'] = xPlayer.getIdentifier()
    })
   cb(aufenthalte)
end)

ESX.RegisterServerCallback('AdminJail:getAAA', function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)

    local spots = MySQL.Sync.fetchScalar("SELECT spots FROM users WHERE identifier = @identifier", {
        ['@identifier'] = xPlayer.getIdentifier()
    })
   cb(spots)
end)

ESX.RegisterServerCallback('AdminJail:getJail', function(src, cb, player)
    if player ~= nil then
        local xPlayer = ESX.GetPlayerFromId(player)
        if xPlayer ~= nil then
            local result = MySQL.Sync.fetchScalar("SELECT adminJail FROM users WHERE identifier = @identifier", {
                ['@identifier'] = xPlayer.getIdentifier()
            })
            cb(result)
        end
    else
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer ~= nil then
            local result = MySQL.Sync.fetchScalar("SELECT adminJail FROM users WHERE identifier = @identifier", {
                ['@identifier'] = xPlayer.getIdentifier()
            })
            cb(result, src)
        end
    end
end)

ESX.RegisterServerCallback('AdminJail:St', function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)

    local spt = MySQL.Sync.fetchScalar("SELECT spots FROM users WHERE identifier = @identifier", {
        ['@identifier'] = xPlayer.getIdentifier()
    })
   cb(spt)
end)

RegisterNetEvent('AdminJail:SendToClean')
AddEventHandler('AdminJail:SendToClean', function(player, spots, reason)

    local xPlayer = ESX.GetPlayerFromId(player)
    if xPlayer ~= nil then
        TriggerClientEvent('AdminJail:goToClean', xPlayer.source, spots, reason, player)

        local aufenthalte = MySQL.Sync.fetchScalar("SELECT aufenthalteAdmin FROM users WHERE identifier = @identifier", {
            ['@identifier'] = xPlayer.getIdentifier()
        })
        SetPlayerRoutingBucket(player, 435)

        local first = MySQL.Sync.fetchScalar("SELECT firstname FROM users WHERE identifier = @identifier", {['@identifier'] = xPlayer.getIdentifier()})
        local last = MySQL.Sync.fetchScalar("SELECT lastname FROM users WHERE identifier = @identifier", {['@identifier'] = xPlayer.getIdentifier()})

        local name = first .." ".. last

        local bezzi = spots + 1
        sendDiscord("nmt_adminjail", "In Gefängniss gebracht", "Der Spieler " ..name.. " ist nun im Gefängniss.\n\nGrund: " ..reason.. "\nSpots: " ..bezzi)

        MySQL.Async.execute('UPDATE users SET adminJail = 1, spots = @spots, reason = @reason, aufenthalteAdmin = @aufenthalte WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.getIdentifier(),
            ['@spots'] = spots,
            ['@reason'] = reason,
            ['@aufenthalte'] = aufenthalte + 1
          })

    end
end)

RegisterNetEvent('AdminJail:isInJail')
AddEventHandler('AdminJail:isInJail', function(player, reason)

    local xPlayer = ESX.GetPlayerFromId(player)

    if xPlayer ~= nil then
        local result = MySQL.Sync.fetchScalar("SELECT adminJail FROM users WHERE identifier = @identifier", {
            ['@identifier'] = xPlayer.getIdentifier()
        })

        TriggerClientEvent('AdminJail:release', xPlayer.source, result)
        MySQL.Async.execute('UPDATE users SET adminJail = 0, spots = 0 WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.getIdentifier()
          })
        SetPlayerRoutingBucket(player, 0)
        local first = MySQL.Sync.fetchScalar("SELECT firstname FROM users WHERE identifier = @identifier", {['@identifier'] = xPlayer.getIdentifier()})
        local last = MySQL.Sync.fetchScalar("SELECT lastname FROM users WHERE identifier = @identifier", {['@identifier'] = xPlayer.getIdentifier()})
        local name = first .." ".. last
        sendDiscord("nmt_adminjail", "Aus Gefängniss", "Der Spieler " ..name.. " ist nun aus dem Gefängniss.\n\nReason: " ..reason)
    end
end)


RegisterNetEvent('AdminJail:rdy')
AddEventHandler('AdminJail:rdy', function(player)

    local xPlayer = ESX.GetPlayerFromId(player)

    if xPlayer ~= nil then
        local result = MySQL.Sync.fetchScalar("SELECT adminJail FROM users WHERE identifier = @identifier", {
            ['@identifier'] = xPlayer.getIdentifier()
        })
        SetPlayerRoutingBucket(player, 0)
        TriggerClientEvent('AdminJail:release', xPlayer.source, result)
        MySQL.Async.execute('UPDATE users SET adminJail = 0, spots = 0 WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.getIdentifier()
          })
    end
end)






RegisterNetEvent('AdminJail:GetSpot')
AddEventHandler('AdminJail:GetSpot', function(player)

    local xPlayer = ESX.GetPlayerFromId(player)
    local result = MySQL.Sync.fetchScalar("SELECT spots FROM users WHERE identifier = @identifier", {
        ['@identifier'] = xPlayer.getIdentifier()
    })
        MySQL.Async.execute('UPDATE users SET spots = @spots WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.getIdentifier(),
            ['@spots'] = result - 1
            })

    
end)


RegisterNetEvent('AdminJail:View')
AddEventHandler('AdminJail:View', function(player, nummer)

    local xPlayer = ESX.GetPlayerFromId(player)
    if nummer == 1 then
        SetPlayerRoutingBucket(player, 435)
        local first = MySQL.Sync.fetchScalar("SELECT firstname FROM users WHERE identifier = @identifier", {['@identifier'] = xPlayer.getIdentifier()})
        local last = MySQL.Sync.fetchScalar("SELECT lastname FROM users WHERE identifier = @identifier", {['@identifier'] = xPlayer.getIdentifier()})
        local name = first .." ".. last
        sendDiscord("nmt_adminjail","Schaut zu", "Der Spieler " ..name.. " schaut nun zu.")
    else
        SetPlayerRoutingBucket(player, 0)
        local first = MySQL.Sync.fetchScalar("SELECT firstname FROM users WHERE identifier = @identifier", {['@identifier'] = xPlayer.getIdentifier()})
        local last = MySQL.Sync.fetchScalar("SELECT lastname FROM users WHERE identifier = @identifier", {['@identifier'] = xPlayer.getIdentifier()})
        local name = first .." ".. last
        sendDiscord("nmt_adminjail","Schaut nicht mehr zu", "Der Spieler " ..name.. " schaut nun nicht mehr zu.")
    end
end)