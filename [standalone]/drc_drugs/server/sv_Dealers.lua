local onTimerDealers = {}
lib.callback.register('drc_drugs:dealersshop:getitem', function(source, price, amount)
    if GetMoney(price * amount, source) then
        return true
    else
        return false
    end
end)

RegisterServerEvent("drc_drugs:dealersshop:giveitems")
AddEventHandler("drc_drugs:dealersshop:giveitems", function(item, price, amount)
    if onTimerDealers[source] and onTimerDealers[source] > GetGameTimer() then
        Logs(source, "Drugs (Dealer, Time): Player Tried to exploit Event")
        BanPlayer(source, "Drugs (Dealer, Time): Player Tried to exploit Event")
        if Config.DropPlayer then
            DropPlayer(source, "Drugs: Player Tried to exploit Event")
        end
        return
    end
    local srcCoords = GetEntityCoords(GetPlayerPed(source))
    for _, v in pairs(Config.Dealer.Ped) do
        ShopCoords = v.coords
    end
    local dist = #(vec3(ShopCoords) - srcCoords)
    if dist <= 20 then
        for _, v in pairs(Config.Dealer.Items) do
            if item == v.item and price == v.price and amount >= v.MinAmount and amount <= v.MaxAmount then
                if GetMoney(price * amount, source) then
                    onTimerDealers[source] = GetGameTimer() + (2 * 1000)
                    RemoveMoney(price * amount, source)
                    AddItem(item, amount, source)
                    Logs(source, locale("HasBought", amount, item, price * amount))
                end
            end
        end
    else
        Logs(source, "Drugs (Dealer, Coords): Player Tried to exploit Event")
        BanPlayer(source, "Drugs (Dealer, Coords): Player Tried to exploit Event")
        if Config.DropPlayer then
            DropPlayer(source, "Drugs: Player Tried to exploit Event")
        end
    end
end)

lib.callback.register('drc_drugs:dealers:getitem', function(source, type)
    if type == "GeraldShop" then
        local number = 0
        for k, v in pairs(Config.Gerald.RequiredItems) do
            if GetItem(v.item, v.count, source) then
                number = number + 1
            end
        end
        if number == #Config.Gerald.RequiredItems then
            return true
        else
            return false
        end
    elseif type == "LocateDealer1" then
        local number = 0
        for k, v in pairs(Config.LocateDealer.RequiredItems) do
            if GetItem(v.item, v.count, source) then
                number = number + 1
            end
        end
        if number == #Config.LocateDealer.RequiredItems then
            for k, v in pairs(Config.LocateDealer.RequiredItems) do
                if v.remove then
                    RemoveItem(v.item, v.count, source)
                end
            end
            return true
        else
            return false
        end
    elseif type == "MadrazoTrade" then
        local number = 0
        for k, v in pairs(Config.Madrazo.RequiredItems) do
            if GetItem(v.item, v.count, source) then
                number = number + 1
            end
        end
        if number == #Config.Madrazo.RequiredItems then
            return true
        else
            return false
        end
    end
end)

RegisterServerEvent("drc_drugs:dealers:giveitems")
AddEventHandler("drc_drugs:dealers:giveitems", function(type)
    local srcCoords = GetEntityCoords(GetPlayerPed(source))
    if onTimerDealers[source] and onTimerDealers[source] > GetGameTimer() then
        Logs(source, "Drugs (Madrazo or Gerald, Time): Player Tried to exploit Event")
        BanPlayer(source, "Drugs (Madrazo or Gerald, Time): Player Tried to exploit Event")
        if Config.DropPlayer then
            DropPlayer(source, "Drugs: Player Tried to exploit Event")
        end
        return
    end
    if type == "GeraldShop" then
        local dist = #(Config.Gerald.Location.Coords - srcCoords)
        if dist <= 50 then
            local number = 0
            for k, v in pairs(Config.Gerald.RequiredItems) do
                if GetItem(v.item, v.count, source) then
                    number = number + 1
                end
            end
            if number == #Config.Gerald.RequiredItems then
                for k, v in pairs(Config.Gerald.RequiredItems) do
                    if v.remove then
                        RemoveItem(v.item, v.count, source)
                    end
                end
                for k, v in pairs(Config.Gerald.AddItems) do
                    AddItem(v.item, v.count, source)
                end
                onTimerDealers[source] = GetGameTimer() + (2 * 1000)
                Logs(source, Config.Gerald.Log)
            end
        else
            Logs(source, "Drugs (Gerald, Coords): Player Tried to exploit Event")
            BanPlayer(source, "Drugs (Gerald Coords): Player Tried to exploit Event")
            if Config.DropPlayer then
                DropPlayer(source, "Drugs: Player Tried to exploit Event")
            end
        end
    elseif type == "MadrazoTrade" then
        local dist = #(Config.Madrazo.Location.Coords - srcCoords)
        if dist <= 50 then
            local number = 0
            for k, v in pairs(Config.Madrazo.RequiredItems) do
                if GetItem(v.item, v.count, source) then
                    number = number + 1
                end
            end
            if number == #Config.Madrazo.RequiredItems then
                for k, v in pairs(Config.Madrazo.RequiredItems) do
                    if v.remove then
                        RemoveItem(v.item, v.count, source)
                    end
                end
                for k, v in pairs(Config.Madrazo.AddItems) do
                    AddItem(v.item, v.count, source)
                end
                onTimerDealers[source] = GetGameTimer() + (2 * 1000)
                Logs(source, Config.Madrazo.Log)
            end
        else
            Logs(source, "Drugs (Madrazo, Coords): Player Tried to exploit Event")
            BanPlayer(source, "Drugs (Madrazo, Coords): Player Tried to exploit Event")
            if Config.DropPlayer then
                DropPlayer(source, "Drugs: Player Tried to exploit Event")
            end
        end
    end
end)
