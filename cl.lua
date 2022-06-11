local QBCore = exports['qb-core']:GetCoreObject()
local showtext = true

CreateThread(function()
    if Config.Option == "qbtarget" then 
        exports['qb-target']:AddTargetModel(Config.CoffeeMachine, {
            options = {
                {
                    type = "client",
                    event = "fp-vending:client:opencoffeemachine",
                    icon = "fa-solid fa-mug-hot",
                    label = "Buy Coffee",
                },
            },
            distance = 2
        })
        exports['qb-target']:AddTargetModel(Config.DrinkMachine, {
            options = {
                {
                    type = "client",
                    event = "fp-vending:client:opensodamachine",
                    icon = "fa-solid fa-wine-bottle",
                    label = "Buy Soda",
                },
            },
            distance = 2
        })
        exports['qb-target']:AddTargetModel(Config.SnackMachine, {
            options = {
                {
                    type = "client",
                    event = "fp-vending:client:opensnackmachine",
                    icon = "fa-solid fa-bread-slice",
                    label = "Buy Snack",
                },
            },
            distance = 2
        })
    else
        while true do
        sleep = 2000
            local ped = GetPlayerPed(-1)
            local pos = GetEntityCoords(ped)
            local inRange = false
            local CoffeeMachine = GetCoffeeMachine()
            local DrinkMachine = GetDrinkMachine()
            local SnackMachine = GetSnackMachine()

        if CoffeeMachine ~= nil then
            local VendingPos = GetEntityCoords(CoffeeMachine)
            local Distance = GetDistanceBetweenCoords(pos, VendingPos.x, VendingPos.y, VendingPos.z, true)
            if Distance < 3 then
                sleep = 5
                if Distance < 1.5 and showtext then
                    QBCore.Functions.DrawText3D(VendingPos.x, VendingPos.y, VendingPos.z +1.0, '~g~E~w~ - Buy coffee')
                    if IsControlJustPressed(0, 38) then
                        TriggerEvent("fp-vending:client:opencoffeemachine")
                    end
                end
            end
        end
        if DrinkMachine ~= nil then
            local VendingPos = GetEntityCoords(DrinkMachine)
            local Distance = GetDistanceBetweenCoords(pos, VendingPos.x, VendingPos.y, VendingPos.z, true)
            if Distance < 3 then
                sleep = 5
                if Distance < 1.5 and showtext then
                    QBCore.Functions.DrawText3D(VendingPos.x, VendingPos.y, VendingPos.z, '~g~E~w~ - Buy soda')
                    if IsControlJustPressed(0, 38) then
                        TriggerEvent("fp-vending:client:opensodamachine")
                    end
                end
            end
        end
        if SnackMachine ~= nil then
            local VendingPos = GetEntityCoords(SnackMachine)
            local Distance = GetDistanceBetweenCoords(pos, VendingPos.x, VendingPos.y, VendingPos.z, true)
            if Distance < 3 then
                sleep = 5
                if Distance < 1.5 and showtext then
                    QBCore.Functions.DrawText3D(VendingPos.x, VendingPos.y, VendingPos.z, '~g~E~w~ - Buy snack')
                    if IsControlJustPressed(0, 38) then
                        TriggerEvent("fp-vending:client:opensnackmachine")
                    end
                end
            end
        end
        Wait(sleep)
    end
    end
end)

function GetCoffeeMachine()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local object = nil
    for _, machine in pairs(Config.CoffeeMachine) do
        local ClosestObject = GetClosestObjectOfType(pos.x, pos.y, pos.z, 0.75, GetHashKey(machine), 0, 0, 0)
        if ClosestObject ~= 0 and ClosestObject ~= nil then
            if object == nil then
                object = ClosestObject
            end
        end
    end
    return object
end

function GetDrinkMachine()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local object = nil
    for _, machine in pairs(Config.DrinkMachine) do
        local ClosestObject = GetClosestObjectOfType(pos.x, pos.y, pos.z, 0.75, GetHashKey(machine), 0, 0, 0)
        if ClosestObject ~= 0 and ClosestObject ~= nil then
            if object == nil then
                object = ClosestObject
            end
        end
    end
    return object
end

function GetSnackMachine()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local object = nil
    for _, machine in pairs(Config.SnackMachine) do
        local ClosestObject = GetClosestObjectOfType(pos.x, pos.y, pos.z, 0.75, GetHashKey(machine), 0, 0, 0)
        if ClosestObject ~= 0 and ClosestObject ~= nil then
            if object == nil then
                object = ClosestObject
            end
        end
    end
    return object
end

RegisterNetEvent('fp-vending:client:opencoffeemachine', function()
    exports['qb-menu']:openMenu({
    {
        header = "• Coffee Machine: ",
        isMenuHeader = true, -- Set to true to make a nonclickable title
    },
    {
        header = "<img src=nui://"..Config.img..QBCore.Shared.Items["coffee"].image.." width=30px>".. " • "..QBCore.Shared.Items["coffee"].label.."",
        txt = "Price: "..Config.CoffeePrice,
        params = {
            event = "fp-vending:client:opencoffee",
            args = {
                whatdrink = 'coffee',
                money = Config.CoffeePrice,
            }
        }
    },
    {
        header = "Close (ESC)",
        params = {
            event = exports['qb-menu']:closeMenu()
        }
    },
})
end)

RegisterNetEvent("fp-vending:client:opencoffee", function(data, cb)
    local money = data.money
    local vendingsoda = data.whatdrink
    QBCore.Functions.TriggerCallback('fp-vending:server:haspaidfordrink', function(CanBuy)
    if CanBuy then
        if vendingsoda == "coffee" then
            showtext = false
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 1.0, "vending_machine", 0.50)
            QBCore.Functions.Progressbar("fp_vending", "Vending Coffee..", 10000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "mp_common",
                anim = "givetake1_a",
                flags = 8,
            }, {}, {}, function() -- Done
                TriggerEvent("fp-vending:client:drinkcoffee", data)
            end, function()
                showtext = true
                QBCore.Functions.Notify("Cancelled..", "error")
            end)
        end
    end
end, money)
end)

RegisterNetEvent("fp-vending:client:drinkcoffee", function(data)
    local vendingsoda = data.whatdrink
    local ped = PlayerPedId()
    RequestAnimDict("pickup_object")
    while not HasAnimDictLoaded("pickup_object") do
        Wait(7)
    end
    TaskPlayAnim(ped, "pickup_object" ,"pickup_low" ,8.0, -8.0, -1, 1, 0, false, false, false )
    Wait(2000)
    ClearPedTasks(ped)
    if vendingsoda == "coffee" then
        TriggerEvent('animations:client:EmoteCommandStart', {"drink"})
        QBCore.Functions.Progressbar("fp_vending", "Drinking..", 5000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            showtext = true
            TriggerServerEvent("QBCore:Server:SetMetaData", "thirst", QBCore.Functions.GetPlayerData().metadata["thirst"] + Config.CoffeeConsumeAmount)
        end)
    end
end)



RegisterNetEvent('fp-vending:client:opensodamachine', function()
        exports['qb-menu']:openMenu({
        {
            header = "• Soda Machine: ",
            isMenuHeader = true, -- Set to true to make a nonclickable title
        },
        {
            header = "<img src=nui://"..Config.img..QBCore.Shared.Items["kurkakola"].image.." width=30px>".. " • "..QBCore.Shared.Items["kurkakola"].label.."",
            txt = "Price: "..Config.ColaPrice,
            params = {
                event = "fp-vending:client:opensodaa",
                args = {
                    whatdrink = 'cola',
                    money = Config.ColaPrice,
                }
            }
        },
        {
            header = "<img src=nui://"..Config.img..QBCore.Shared.Items["sprunk"].image.." width=30px>".. " • "..QBCore.Shared.Items["sprunk"].label.."",
            txt = "Price: "..Config.SprunkPrice,
            params = {
                event = "fp-vending:client:opensodaa",
                args = {
                    whatdrink = 'sprunk',
                    money = Config.SprunkPrice,
                }
            }
        },
        {
            header = "Close (ESC)",
            params = {
                event = exports['qb-menu']:closeMenu()
            }
        },
    })
end)

RegisterNetEvent("fp-vending:client:opensodaa", function(data, cb)
    local money = data.money
    local vendingsoda = data.whatdrink
    QBCore.Functions.TriggerCallback('fp-vending:server:haspaidfordrink', function(CanBuy)
    if CanBuy then
        if vendingsoda == "cola" then
            showtext = false
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 1.0, "vending_machine", 0.50)
            QBCore.Functions.Progressbar("fp_vending", "Vending Soda..", 10000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "mp_common",
                anim = "givetake1_a",
                flags = 8,
            }, {}, {}, function() -- Done
                TriggerEvent("fp-vending:client:drinksoda", data)
            end, function()
                showtext = true
                QBCore.Functions.Notify("Cancelled..", "error")
            end)
        elseif vendingsoda == "sprunk" then
            showtext = false
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 1.0, "vending_machine", 0.50)
            QBCore.Functions.Progressbar("fp_vending", "Vending Soda..", 10000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "mp_common",
                anim = "givetake1_a",
                flags = 8,
            }, {}, {}, function() -- Done
                TriggerEvent("fp-vending:client:drinksoda", data)
            end, function()
                showtext = true
                QBCore.Functions.Notify("Cancelled..", "error")
            end)
        end
    end
end, money)
end)

RegisterNetEvent("fp-vending:client:drinksoda", function(data)
    local vendingsoda = data.whatdrink
    local ped = PlayerPedId()
    RequestAnimDict("pickup_object")
    while not HasAnimDictLoaded("pickup_object") do
        Wait(7)
    end
    TaskPlayAnim(ped, "pickup_object" ,"pickup_low" ,8.0, -8.0, -1, 1, 0, false, false, false )
    Wait(2000)
    ClearPedTasks(ped)
    if vendingsoda == "cola" then
        TriggerEvent('animations:client:EmoteCommandStart', {"drink"})
        QBCore.Functions.Progressbar("fp_vending", "Drinking..", 5000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            showtext = true
            TriggerServerEvent("QBCore:Server:SetMetaData", "thirst", QBCore.Functions.GetPlayerData().metadata["thirst"] + Config.ColaConsumeAmount)
        end)
    elseif vendingsoda == "sprunk" then
        TriggerEvent('animations:client:EmoteCommandStart', {"drink"})
        QBCore.Functions.Progressbar("fp_vending", "Drinking..", 5000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            showtext = true
            TriggerServerEvent("QBCore:Server:SetMetaData", "thirst", QBCore.Functions.GetPlayerData().metadata["thirst"] + Config.SprunkConsumeAmount)
        end)
    end
end)

RegisterNetEvent('fp-vending:client:opensnackmachine', function()
    exports['qb-menu']:openMenu({
    {
        header = "• Snack Machine: ",
        isMenuHeader = true,
    },
    {
        header = "<img src=nui://"..Config.img..QBCore.Shared.Items["tosti"].image.." width=30px>".. " • "..QBCore.Shared.Items["tosti"].label.."",
        txt = "Price: "..Config.TostiPrice,
        params = {
            event = "fp-vending:client:opensnackk",
            args = {
                whatdrink = 'tosti',
                money = Config.TostiPrice,
            }
        }
    },
    {
        header = "<img src=nui://"..Config.img..QBCore.Shared.Items["twerks_candy"].image.." width=30px>".. " • "..QBCore.Shared.Items["twerks_candy"].label.."",
        txt = "Price: "..Config.TwerksPrice,
        params = {
            event = "fp-vending:client:opensnackk",
            args = {
                whatdrink = 'twerks_candy',
                money = Config.TwerksPrice,
            }
        }
    },
    {
        header = "<img src=nui://"..Config.img..QBCore.Shared.Items["snikkel_candy"].image.." width=30px>".. " • "..QBCore.Shared.Items["snikkel_candy"].label.."",
        txt = "Price: "..Config.SnikkelPrice,
        params = {
            event = "fp-vending:client:opensnackk",
            args = {
                whatdrink = 'snikkel_candy',
                money = Config.SnikkelPrice,
            }
        }
    },
    {
        header = "<img src=nui://"..Config.img..QBCore.Shared.Items["sandwich"].image.." width=30px>".. " • "..QBCore.Shared.Items["sandwich"].label.."",
        txt = "Price: "..Config.SandwichPrice,
        params = {
            event = "fp-vending:client:opensnackk",
            args = {
                whatdrink = 'sandwich',
                money = Config.SandwichPrice,
            }
        }
    },
    {
        header = "Close (ESC)",
        params = {
            event = exports['qb-menu']:closeMenu()
        }
    },
})
end)

RegisterNetEvent("fp-vending:client:opensnackk", function(data, cb)
    local money = data.money
    local vendingsoda = data.whatdrink
    QBCore.Functions.TriggerCallback('fp-vending:server:haspaidfordrink', function(CanBuy)
    if CanBuy then
        if vendingsoda == "tosti" then
            showtext = false
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 1.0, "vending_machine", 0.50)
            QBCore.Functions.Progressbar("fp_vending", "Vending Snack..", 10000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "mp_common",
                anim = "givetake1_a",
                flags = 8,
            }, {}, {}, function() -- Done
                TriggerEvent("fp-vending:client:eatsnack", data)
            end, function()
                showtext = true
                QBCore.Functions.Notify("Cancelled..", "error")
            end)
        elseif vendingsoda == "twerks_candy" then
            showtext = false
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 1.0, "vending_machine", 0.50)
            QBCore.Functions.Progressbar("fp_vending", "Vending Snack..", 10000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "mp_common",
                anim = "givetake1_a",
                flags = 8,
            }, {}, {}, function() -- Done
                TriggerEvent("fp-vending:client:eatsnack", data)
            end, function()
                showtext = true
                QBCore.Functions.Notify("Cancelled..", "error")
            end)
        elseif vendingsoda == "snikkel_candy" then
            showtext = false
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 1.0, "vending_machine", 0.50)
            QBCore.Functions.Progressbar("fp_vending", "Vending Snack..", 10000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "mp_common",
                anim = "givetake1_a",
                flags = 8,
            }, {}, {}, function() -- Done
                TriggerEvent("fp-vending:client:eatsnack", data)
            end, function()
                showtext = true
                QBCore.Functions.Notify("Cancelled..", "error")
            end)
        elseif vendingsoda == "sandwich" then
            showtext = false
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 1.0, "vending_machine", 0.50)
            QBCore.Functions.Progressbar("fp_vending", "Vending Snack..", 10000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "mp_common",
                anim = "givetake1_a",
                flags = 8,
            }, {}, {}, function() -- Done
                TriggerEvent("fp-vending:client:eatsnack", data)
            end, function()
                showtext = true
                QBCore.Functions.Notify("Cancelled..", "error")
            end)
        end
    end
end, money)
end)

RegisterNetEvent("fp-vending:client:eatsnack", function(data)
    local vendingsoda = data.whatdrink
    local ped = PlayerPedId()
    RequestAnimDict("pickup_object")
    while not HasAnimDictLoaded("pickup_object") do
        Wait(7)
    end
    TaskPlayAnim(ped, "pickup_object" ,"pickup_low" ,8.0, -8.0, -1, 1, 0, false, false, false )
    Wait(2000)
    ClearPedTasks(ped)
    if vendingsoda == "tosti" then
        TriggerEvent('animations:client:EmoteCommandStart', {"eat"})
        QBCore.Functions.Progressbar("fp_vending", "Eating..", 5000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            showtext = true
            TriggerServerEvent("QBCore:Server:SetMetaData", "hunger", QBCore.Functions.GetPlayerData().metadata["hunger"] + Config.TostiConsumeAmount)
        end)
    elseif vendingsoda == "twerks_candy" then
        TriggerEvent('animations:client:EmoteCommandStart', {"eat"})
        QBCore.Functions.Progressbar("fp_vending", "Eating..", 5000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            showtext = true
            TriggerServerEvent("QBCore:Server:SetMetaData", "hunger", QBCore.Functions.GetPlayerData().metadata["hunger"] + Config.TwerksConsumeAmount)
        end)
    elseif vendingsoda == "snikkel_candy" then
        TriggerEvent('animations:client:EmoteCommandStart', {"eat"})
        QBCore.Functions.Progressbar("fp_vending", "Eating..", 5000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            showtext = true
            TriggerServerEvent("QBCore:Server:SetMetaData", "hunger", QBCore.Functions.GetPlayerData().metadata["hunger"] + Config.SnikkelConsumeAmount)
        end)
    elseif vendingsoda == "sandwich" then
        TriggerEvent('animations:client:EmoteCommandStart', {"eat"})
        QBCore.Functions.Progressbar("fp_vending", "Eating..", 5000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            showtext = true
            TriggerServerEvent("QBCore:Server:SetMetaData", "hunger", QBCore.Functions.GetPlayerData().metadata["hunger"] + Config.SandwichConsumeAmount)
        end)
    end
end)