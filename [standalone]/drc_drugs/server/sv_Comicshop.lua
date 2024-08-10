local onTimerComicShop = {}
lib.callback.register('drc_drugs:comicshop:getitem', function(source, price, amount)
    if GetMoney(price * amount, source) then
        return true
    else
        return false
    end
end)

RegisterServerEvent("drc_drugs:comicshop:giveitems")
AddEventHandler("drc_drugs:comicshop:giveitems", function(item, price, amount)
    if onTimerComicShop[source] and onTimerComicShop[source] > GetGameTimer() then
        Logs(source, "Drugs (ComicShop, Time): Player Tried to exploit Event")
        BanPlayer(source, "Drugs (ComicShop, Time): Player Tried to exploit Event")
        if Config.DropPlayer then
            DropPlayer(source, "Drugs: Player Tried to exploit Event")
        end
        return
    end
    local srcCoords = GetEntityCoords(GetPlayerPed(source))
    for _, v in pairs(Config.ComicShop.Ped) do
        ShopCoords = v.coords
    end
    local dist = #(vec3(ShopCoords) - srcCoords)
    if dist <= 20 then
        for _, v in pairs(Config.ComicShop.Items) do
            if item == v.item and price == v.price and amount >= v.MinAmount and amount <= v.MaxAmount then
                if GetMoney(price * amount, source) then
                    RemoveMoney(price * amount, source)
                    AddItem(item, amount, source)
                    Logs(source, locale("HasBought", amount, item, price * amount))
                    onTimerComicShop[source] = GetGameTimer() + (2 * 1000)
                end
            end
        end
    else
        Logs(source, "Drugs (ComicShop, Coords): Player Tried to exploit Event")
        BanPlayer(source, "Drugs (ComicShop, Coords): Player Tried to exploit Event")
        if Config.DropPlayer then
            DropPlayer(source, "Drugs: Player Tried to exploit Event")
        end
    end
end)
