zahl = 0

function isNumeric(value)
    if value == tostring(tonumber(value)) then
        return true
    else
        return false
    end
end

RegisterCommand(Config.Jail, function(source, args, rawCommand)
    ESX.TriggerServerCallback('AdminJail:getGroup', function(group)
        for i, v in pairs(Config.Groups) do
            if group == v.Gruppe then
                if args[3] ~= nil and isNumeric(args[1]) and isNumeric(args[2]) and args[4] == nil then
                        local player = tonumber(args[1])
                        pppp = player
                        local spots = tonumber(args[2])
                        local reason = tostring(args[3])
                        ESX.TriggerServerCallback('AdminJail:getJail', function(result)
                            if result == 0 then
                                check = 0
                                TriggerServerEvent('AdminJail:SendToClean', player, spots - 1, reason)
    
                            elseif result == 1 then
                                ShowNotification(Config.IsAlreadyJailed)
                            end
                        end, player)
                else
                    ShowNotification(Config.FalseSyntax1)
                end
            end
        end
    end)
end)


RegisterCommand(Config.Unjail, function(source, args, rawCommand)
    ESX.TriggerServerCallback('AdminJail:getGroup', function(group)
        for i, v in pairs(Config.Groups) do
            if group == v.Gruppe then
                if args[2] ~= nil and args[3] == nil and isNumeric(args[1]) then
                    local player = tonumber(args[1])
                    local reason = tostring(args[2])
                    TriggerServerEvent('AdminJail:isInJail', player, reason)
                else
                    ShowNotification(Config.FalseSyntax2)
                end
            end
        end
        
    end, player)
end)





RegisterCommand(Config.Log , function(source, args, rawCommand)
    ESX.TriggerServerCallback('AdminJail:getGroup', function(group)
        for i, v in pairs(Config.Groups) do
            if group == v.Gruppe then
                if isNumeric(args[1]) and args[1] ~= nil and args[2] == nil then
                    local player = tonumber(args[1])
                    ESX.TriggerServerCallback('AdminJail:getAufenthalte', function(aufenthalte)
                        if Config.Language == "DE" then
                            ShowNotification("Der Spieler mit der ID: " ..player.. " war bereits " ..aufenthalte.. " mal im Knast.")
                        elseif Config.Language == "EN" then
                            ShowNotification("The Player with the ID: " ..player.. " was already " ..aufenthalte.. " times in Jail.")
                        end
                    end, player)
                else 
                    ShowNotification(Config.FalseSyntax3)
                end
            end
        end
    end)
end)



RegisterCommand(Config.View, function(source, args, rawCommand)
    ESX.TriggerServerCallback('AdminJail:getGroup', function(group)
        for i, v in pairs(Config.Groups) do
            if group == v.Gruppe then
                if view == 1 then
                    view = 0
                    ShowNotification("Du schaust nun nicht mehr im Knast zu!")
                else
                    view = 1
                    ShowNotification("Du schaust nun im Knast zu!")
                    bzzi()
                end
            end
        end
    end)
end)