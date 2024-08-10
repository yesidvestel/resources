lib.locale()

local onTimerFlowerShop = {}
lib.callback.register('drc_drugs:flowershop:getitem', function(source, price, amount)
    if GetMoney(price * amount, source) then
        return true
    else
        return false
    end
end)

RegisterServerEvent("drc_drugs:flowershop:giveitems")
AddEventHandler("drc_drugs:flowershop:giveitems", function(item, price, amount)
    if onTimerFlowerShop[source] and onTimerFlowerShop[source] > GetGameTimer() then
        Logs(source, "Drugs (FlowerShop, Timer): Player Tried to exploit Event")
        BanPlayer(source, "Drugs (FlowerShop, Timer): Player Tried to exploit Event")
        if Config.DropPlayer then
            DropPlayer(source, "Drugs: Player Tried to exploit Event")
        end
        return
    end
    local srcCoords = GetEntityCoords(GetPlayerPed(source))
    for _, v in pairs(Config.FlowerShop.Ped) do
        ShopCoords = v.coords
    end
    local dist = #(vec3(ShopCoords) - srcCoords)
    if dist <= 20 then
        for _, v in pairs(Config.FlowerShop.Items) do
            if item == v.item and price == v.price and amount >= v.MinAmount and amount <= v.MaxAmount then
                if GetMoney(price * amount, source) then
                    onTimerFlowerShop[source] = GetGameTimer() + (2 * 1000)
                    RemoveMoney(price * amount, source)
                    AddItem(item, amount, source)
                    Logs(source, locale("HasBought", amount, item, price * amount))
                end
            end
        end
    else
        Logs(source, "Drugs (FlowerShop, Coords): Player Tried to exploit Event")
        BanPlayer(source, "Drugs (FlowerShop, Coords): Player Tried to exploit Event")
        if Config.DropPlayer then
            DropPlayer(source, "Drugs: Player Tried to exploit Event")
        end
    end
end)
