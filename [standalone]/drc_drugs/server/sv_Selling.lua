local onTimerSelling = {}
RegisterServerEvent('drc_drugs:selling:pay')
AddEventHandler('drc_drugs:selling:pay', function(price, sellingDrug, amount, label, oldprice)
    if Config.Debug then
        print(price, sellingDrug, amount, label)
    end
    if onTimerSelling[source] and onTimerSelling[source] > GetGameTimer() then
        Logs(source, "Drugs (Selling, Timer): Player Tried to exploit Event")
        BanPlayer(source, "Drugs (Selling, Timer): Player Tried to exploit Event")
        if Config.DropPlayer then
            DropPlayer(source, "Drugs (Selling, Timer): Player Tried to exploit Event")
        end
        return
    end
    local srcCoords = GetEntityCoords(GetPlayerPed(source))
    local dist = #(getClosestCoords(ClientCoords) - srcCoords)
    if dist <= 10 then
        onTimerSelling[source] = GetGameTimer() + (2 * 1000)
        for k, v in pairs(Config.Drugs) do
            if Config.Debug then
                print(k, sellingDrug)
                print(oldprice / 2)
            end
            if k == sellingDrug then
                local PiecePrice = price / amount
                if PiecePrice >= v.MinPrice and PiecePrice <= v.MaxPrice or
                    PiecePrice - math.ceil(oldprice / 2 / amount) >= v.MinPrice and
                    PiecePrice - math.floor(oldprice / 2 / amount) <= v.MaxPrice then
                    if amount >= v.MinCount and amount <= v.MaxCount then
                        if GetItem(sellingDrug, amount, source) then
                            RemoveItem(sellingDrug, amount, source)
                            AddMoney(price, source, Config.SellingMoneyType)
                            Logs(source, locale("HasSold", amount, sellingDrug, price))
                        end
                    else
                        Logs(source, "Drugs (Selling, Wrong Amount): Player Tried to exploit Event")
                        BanPlayer(source, "Drugs (Selling, Wrong Amount): Player Tried to exploit Event")
                        if Config.DropPlayer then
                            DropPlayer(source, "Drugs (Selling, Wrong Amount): Player Tried to exploit Event")
                        end
                    end
                else
                    Logs(source, "Drugs (Selling, Wrong Price): Player Tried to exploit Event")
                    BanPlayer(source, "Drugs (Selling, Wrong Price): Player Tried to exploit Event")
                    if Config.DropPlayer then
                        DropPlayer(source, "Drugs (Selling, Wrong Price): Player Tried to exploit Event")
                    end
                end
            end
        end
    else
        Logs(source, "Drugs (Selling, Coords): Player Tried to exploit Event")
        BanPlayer(source, "Drugs (Selling, Coords): Player Tried to exploit Event")
        if Config.DropPlayer then
            DropPlayer(source, "Drugs (Selling, Coords): Player Tried to exploit Event")
        end
    end
end)

lib.callback.register('drc_drugs:selling:getitem', function(source, sellingDrug, amount)
    if GetItem(sellingDrug, amount, source) then
        return true
    else
        return false
    end
end)

function getClosestCoords(_table)
    local _ClosestCoord = nil
    local _ClosestDistance = 100000
    local _Coord = GetEntityCoords(GetPlayerPed(source))

    for k, v in pairs(_table) do
        local _Distance = #(vec3(v.x, v.y, v.z) - _Coord)
        if _Distance <= _ClosestDistance then
            _ClosestDistance = _Distance
            _ClosestCoord = vec3(v.x, v.y, v.z)
        end
    end

    return _ClosestCoord
end
