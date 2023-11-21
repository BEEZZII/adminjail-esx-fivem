ESX = nil
pppp = nil
view = 0
check = 1
isInJail = false
c = 1
v = 1
a = 0

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)




local adminJailCoords = {
    x = Config.AdminJailCoords.X,
    y = Config.AdminJailCoords.Y,
    z = Config.AdminJailCoords.Z,
    rot = 0
}

local releaseCoords = {
    x = Config.ReleaseCoords.X,
    y = Config.ReleaseCoords.Y,
    z = Config.ReleaseCoords.Z,
    rot = 0
}




Citizen.CreateThread(function()
    while check == 1 do
        Citizen.Wait(10000)
        if check == 1 then
            ESX.TriggerServerCallback('AdminJail:getJail', function(result, src)
                if result == 1 and check == 1 then
                    ESX.TriggerServerCallback('AdminJail:getAAA', function(spots)
                        TriggerServerEvent('AdminJail:SendToClean', src, spots, "Rejoined", 0)
                        check = 0
                    end)
                else
                end
            end)
        else
            check = 0
        end
    end
end)


RegisterNetEvent('AdminJail:release')
AddEventHandler('AdminJail:release', function(result)
    release(result)
end)

function release(result)
    local playerPed = PlayerPedId()
    if result == 1 then
        ShowNotification(Config.IsNotAnymoreJailed)
        isInJail = false
        SetEntityCoords(playerPed, releaseCoords.x, releaseCoords.y, releaseCoords.z, releaseCoords.rot)
    else
        ShowNotification(Config.IsNotJailed)
    end
    
end

RegisterNetEvent('AdminJail:goToClean')
AddEventHandler('AdminJail:goToClean', function(spots, reason, player)
    goToClean(spots, reason)
    pppp = player
end)

function goToClean(spots, reason)
    local playerPed = PlayerPedId()
    spotss = spots + 1
    SetEntityCoords(playerPed, adminJailCoords.x, adminJailCoords.y, adminJailCoords.z, adminJailCoords.rot)


    if Config.Language == "DE" then
        ShowNotification("Du bist nun im Admin Knast räume " ..spotss.. " Tüten weg. \nDer Grund ist: " ..reason)
    elseif Config.Language == "EN" then
        ShowNotification("You are now in the Admin Jail clean " ..spotss.. " spots. \nThe reason is: " ..reason)
    end
    
    isInJail = true
    local sppt = 0
    sppt = math.random(0, #Config.Groups)

    checker = sppt

    l = 0
    t = 0
    Citizen.CreateThread(function()
        while isInJail do
            DrawMarker(28, adminJailCoords.x, adminJailCoords.y, adminJailCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.AdminJailRange, Config.AdminJailRange, Config.AdminJailRange, Config.AdminJailColor.r, Config.AdminJailColor.g, Config.AdminJailColor.b, Config.AdminJailColor.a, false, true, 2, false, false, false)
            DrawMarker(2, Config.Spots[sppt].X, Config.Spots[sppt].Y, Config.Spots[sppt].Z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.9, 0.9, 0.9, Config.AdminJailColor.r, Config.AdminJailColor.g, Config.AdminJailColor.b, Config.AdminJailColor.a, false, true, 2, false, false, false)
            if t == 0 then
                ESX.TriggerServerCallback('AdminJail:getAAA', function(spots)
                    if playerPed == playerPed then
                            
                        local playerCoord = GetEntityCoords(playerPed, false)
                        local locVector = vector3(Config.Spots[sppt].X, Config.Spots[sppt].Y, Config.Spots[sppt].Z)
                        SetEntityHealth(playerPed, 200)
                            
                        if l == 0 then
                            blip = AddBlipForCoord(Config.Spots[sppt].X, Config.Spots[sppt].Y)
                            l=1
                        end
                        if Vdist(playerCoord, locVector) < 2 * 1.12 then
                            RemoveBlip(blip)
                            sppt = math.random(0, #Config.Groups)

                            if checker == sppt then
                                sppt = math.random(0, #Config.Groups)
                            end

                            checker = sppt 

                            if spots <= 0 then
                                ShowNotification(Config.ReleaseMessage)
                                isInJail = false
                                SetEntityCoords(playerPed, releaseCoords.x, releaseCoords.y, releaseCoords.z, releaseCoords.rot)
                                TriggerServerEvent('AdminJail:rdy', pppp)
                            else
                                if Config.Language == "DE" then
                                    ShowNotification("Du hast eine Tüte aufgehoben. \nDu brauchst noch: " ..spots)
                                elseif Config.Language == "EN" then
                                    ShowNotification("You cleaned one spot. \nYou need to clean: " ..spots.. " spots more")
                                end
                                TriggerServerEvent('AdminJail:GetSpot', pppp)
                                blip = AddBlipForCoord(Config.Spots[sppt].X, Config.Spots[sppt].Y)
                            end
                        elseif Vdist(playerCoord, vector3(adminJailCoords.x, adminJailCoords.y, adminJailCoords.z)) > 93 * 1.12 then
                                
                            SetEntityCoords(playerPed, adminJailCoords.x, adminJailCoords.y, adminJailCoords.z, adminJailCoords.rot)
                            ShowNotification(Config.LeftTheArea)
                        end
                    end
                end)
                t = t + 1
            elseif t >= 50 then
                t = 0
            else
                t = t + 1
            end
            Citizen.Wait(1)
        end
    end)
end


function bzzi()
    Citizen.CreateThread(function()
        local playerPed = PlayerPedId()
        TriggerServerEvent('AdminJail:View', pppp, view)
        SetEntityCoords(playerPed, adminJailCoords.x, adminJailCoords.y, adminJailCoords.z, adminJailCoords.rot)
        while view == 1 do
            DrawMarker(28, adminJailCoords.x, adminJailCoords.y, adminJailCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.AdminJailRange, Config.AdminJailRange, Config.AdminJailRange, Config.AdminJailColor.r, Config.AdminJailColor.g, Config.AdminJailColor.b, Config.AdminJailColor.a, false, true, 2, false, false, false)

            local playerCoord = GetEntityCoords(playerPed, false)
            if Vdist(playerCoord, vector3(adminJailCoords.x, adminJailCoords.y, adminJailCoords.z)) > 93 * 1.12 then
                                
                SetEntityCoords(playerPed, adminJailCoords.x, adminJailCoords.y, adminJailCoords.z, adminJailCoords.rot)
                ShowNotification(Config.LeftTheArea)
            end
            Citizen.Wait(1)
        end
    end)
end




function ShowNotification(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, true)
end

