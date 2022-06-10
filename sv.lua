local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('fp-vending:server:haspaidfordrink', function(source, cb, money)
    print(money)
    local Player = QBCore.Functions.GetPlayer(source)
    local CanBuy = false


    if Player.PlayerData.money.cash >= money then
        Player.Functions.RemoveMoney('cash', money)
        CanBuy = true
    elseif Player.PlayerData.money.bank >= money then
        Player.Functions.RemoveMoney('bank', money)
        CanBuy = true
    else
        CanBuy = false
    end

    cb(CanBuy)
end)

-- QBCore.Functions.CreateCallback('repentzfw-autocustoms:server:CanPurchase', function(source, cb, price)
--     local Player = QBCore.Functions.GetPlayer(source)
--     local CanBuy = false


--     if Player.PlayerData.money.cash >= price then
--         Player.Functions.RemoveMoney('cash', price)
--         CanBuy = true
--     elseif Player.PlayerData.money.bank >= price then
--         Player.Functions.RemoveMoney('bank', price)
--         CanBuy = true
--     else
--         CanBuy = false
--     end

--     cb(CanBuy)
-- end)