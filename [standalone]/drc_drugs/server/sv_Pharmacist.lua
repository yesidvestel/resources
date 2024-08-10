local onTimerPharmacist = {}
lib.callback.register('drc_drugs:pharmacist:getitem', function(source, price, amount)
    if GetMoney(price * amount, source) then
        return true
    else
        return false
    end
end)

RegisterServerEvent("drc_drugs:pharmacist:giveitems")
AddEventHandler("drc_drugs:pharmacist:giveitems", function(item, price, amount)
    if onTimerPharmacist[source] and onTimerPharmacist[source] > GetGameTimer() then
        Logs(source, "Drugs (Pharmacist, Time): Player Tried to exploit Event")
        BanPlayer(source, "Drugs (Pharmacist, Time): Player Tried to exploit Event")
        if Config.DropPlayer then
            DropPlayer(source, "Drugs: Player Tried to exploit Event")
        end
        return
    end
    local srcCoords = GetEntityCoords(GetPlayerPed(source))
    for _, v in pairs(Config.Pharmacist.Ped) do
        ShopCoords = v.coords
    end
    local dist = #(vec3(ShopCoords) - srcCoords)
    if dist <= 20 then
        onTimerPharmacist[source] = GetGameTimer() + (2 * 1000)
        for _, v in pairs(Config.Pharmacist.Items) do
            if item == v.item and price == v.price and amount >= v.MinAmount and amount <= v.MaxAmount then
                if GetMoney(price * amount, source) then
                    RemoveMoney(price * amount, source)
                    AddItem(item,  amount, source)
                    Logs(source, locale("HasBought", amount, item, price * amount))
                end
            end
        end
    else
        Logs(source, "Drugs (Pharmacist, Coords): Player Tried to exploit Event")
        BanPlayer(source, "Drugs (Pharmacist, Coords): Player Tried to exploit Event")
        if Config.DropPlayer then
            DropPlayer(source, "Drugs: Player Tried to exploit Event")
        end
    end
end)
