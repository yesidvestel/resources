local onTimerMedicaments = {}
lib.callback.register('drc_drugs:medicaments:getitem', function(source, price, amount)
    if GetMoney(price * amount, source) then
        return true
    else
        return false
    end
end)

RegisterServerEvent("drc_drugs:medicaments:giveitems")
AddEventHandler("drc_drugs:medicaments:giveitems", function(item, price, amount)
    if onTimerMedicaments[source] and onTimerMedicaments[source] > GetGameTimer() then
        Logs(source, "Drugs (Medicaments, Timer): Player Tried to exploit Event")
        BanPlayer(source, "Drugs (Medicaments, Timer): Player Tried to exploit Event")
        if Config.DropPlayer then
            DropPlayer(source, "Drugs: Player Tried to exploit Event")
        end
        return
    end
    local srcCoords = GetEntityCoords(GetPlayerPed(source))
    for _, v in pairs(Config.MedicamentsShop.Ped) do
        ShopCoords = v.coords
    end
    local dist = #(vec3(ShopCoords) - srcCoords)
    if dist <= 20 then
        for _, v in pairs(Config.MedicamentsShop.Items) do
            if item == v.item and price == v.price and amount >= v.MinAmount and amount <= v.MaxAmount then
                if GetMoney(price * amount, source) then
                    onTimerMedicaments[source] = GetGameTimer() + (2 * 1000)
                    RemoveMoney(price * amount, source)
                    if item == "lsd" then
                        local random = math.random(1, 5)
                        item = "lsd" .. random
                    elseif item == "ecstasy" then
                        local random = math.random(1, 5)
                        item = "ecstasy" .. random
                    end
                    Logs(source, locale("HasBought", amount, item, price * amount))
                    AddItem(item, amount, source)
                end
            end
        end
    else
        Logs(source, "Drugs (Medicaments, Coords): Player Tried to exploit Event")
        BanPlayer(source, "Drugs (Medicaments, Coords): Player Tried to exploit Event")
        if Config.DropPlayer then
            DropPlayer(source, "Drugs: Player Tried to exploit Event")
        end
    end
end)
