Koci.Server.RegisterServerCallback("0r-vehicleshop:Server:GetPlayerAccountBalance", function(source, data, cb)
    local src = source
    local xPlayer = Koci.Server.GetPlayerBySource(src)
    local bankBalance = Koci.Server.GetPlayerBalance(data.type, xPlayer)
    cb(bankBalance or 0)
end)

Koci.Server.RegisterServerCallback("0r-vehicle:Server:BuyNewVehicle", function(source, data, cb)
    local src = source
    local xPlayer = Koci.Server.GetPlayerBySource(src)
    local customPlate = data.customPlate
    local checkPlayerMoney = Koci.Server.CheckPlayerMoney(
        xPlayer,
        data.price,
        data.paymentMethod,
        {
            gallery = data.gallery
        }
    )
    if not checkPlayerMoney then
        cb({
            status = false,
            error = _t("purchase.dont_have_enough_money")
        })
        return
    end
    if #customPlate == 0 then
        customPlate = Koci.Server.GenerateCustomPlate()
    else
        local isTaken = Koci.Server.IsPlateTaken(customPlate)
        if isTaken then
            cb({
                status = false,
                error = _t("plate.already_registered")
            })
            return
        end
    end
    local vProps = data.vehicleProps
    if Config.PlayerVehiclesDB == "owned_vehicles" then
        vProps.plate = customPlate
        vProps.model = data.vehicle.name
        Koci.Server.ExecuteSQLQuery(
            "INSERT INTO owned_vehicles (owner, vehicle, plate, type, stored) VALUES (?, ?, ?, ?, ?)",
            {
                xPlayer.identifier,
                json.encode(vProps),
                vProps.plate:upper(),
                data.gallery.type,
                0
            },
            "insert"
        )
    elseif Config.PlayerVehiclesDB == "player_vehicles" then
        vProps.plate = customPlate
        vProps.model = data.vehicle.name
        Koci.Server.ExecuteSQLQuery(
            "INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, state) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
            {
                xPlayer.PlayerData.license,
                xPlayer.PlayerData.citizenid,
                data.vehicle.name,
                GetHashKey(vProps.model),
                json.encode(vProps),
                vProps.plate:upper(),
                data.gallery.deliveryGarage,
                0
            },
            "insert"
        )
    end
    if data.paymentMethod == "bank" then
        Koci.Server.PlayerRemoveMoney(xPlayer, "bank", data.price)
    elseif data.paymentMethod == "cash" then
        if data.gallery.isMoneyAnItem.status then
            Koci.Server.PlayerRemoveItem(xPlayer, data.gallery.isMoneyAnItem.item, data.price)
        else
            Koci.Server.PlayerRemoveMoney(xPlayer, "cash", data.price)
        end
    elseif data.paymentMethod == "black_money" then
        Koci.Server.PlayerRemoveItem(xPlayer, data.gallery.buyWithBlackMoney.item, data.price)
    elseif data.paymentMethod == "coin" then
        Koci.Server.PlayerRemoveItem(xPlayer, data.gallery.buyWithCoin.item, data.price)
    end
    cb({ status = true, plate = customPlate })
end)

Koci.Server.RegisterServerCallback("0r-vehicle:Server:RentNewVehicle", function(source, data, cb)
    local src = source
    local xPlayer = Koci.Server.GetPlayerBySource(src)
    local customPlate = data.customPlate
    local checkPlayerMoney = Koci.Server.CheckPlayerMoney(
        xPlayer,
        data.price,
        data.paymentMethod,
        {
            gallery = data.gallery
        }
    )
    if not checkPlayerMoney then
        cb({
            status = false,
            error = _t("purchase.dont_have_enough_money")
        })
        return
    end
    if #customPlate == 0 then
        customPlate = Koci.Server.GenerateCustomPlate()
    else
        local isTaken = Koci.Server.IsPlateTaken(customPlate)
        if isTaken then
            cb({
                status = false,
                error = _t("plate.already_registered")
            })
            return
        end
    end
    local vProps = data.vehicleProps
    local owner = Config.FrameWork == "esx" and xPlayer.identifier or xPlayer.PlayerData.citizenid
    Koci.Server.ExecuteSQLQuery(
        "INSERT INTO `0r_rented_vehicles` (owner, plate, model, vehicle_price, daily_fee, rented_day, rental_fee) VALUES (?, ?, ?, ?, ?, ?, ?)",
        {
            owner,
            customPlate:upper(),
            data.vehicle.name,
            data.vehicle.price,
            data.daily_fee,
            data.rented_day,
            data.price
        },
        "insert"
    )
    if Config.PlayerVehiclesDB == "owned_vehicles" then
        vProps.plate = customPlate
        vProps.model = data.vehicle.name
        Koci.Server.ExecuteSQLQuery(
            "INSERT INTO owned_vehicles (owner, vehicle, plate, type, stored) VALUES (?, ?, ?, ?, ?)",
            {
                owner,
                json.encode(vProps),
                vProps.plate:upper(),
                data.gallery.type,
                false
            },
            "insert"
        )
    elseif Config.PlayerVehiclesDB == "player_vehicles" then
        vProps.plate = customPlate
        vProps.model = data.vehicle.name
        Koci.Server.ExecuteSQLQuery(
            "INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, state) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
            {
                xPlayer.PlayerData.license,
                owner,
                data.vehicle.name,
                GetHashKey(vProps.model),
                json.encode(vProps),
                vProps.plate:upper(),
                data.gallery.deliveryGarage,
                0
            },
            "insert"
        )
    end
    if data.paymentMethod == "bank" then
        Koci.Server.PlayerRemoveMoney(xPlayer, "bank", data.price)
    elseif data.paymentMethod == "cash" then
        if data.gallery.isMoneyAnItem.status then
            Koci.Server.PlayerRemoveItem(xPlayer, data.gallery.isMoneyAnItem.item, data.price)
        else
            Koci.Server.PlayerRemoveMoney(xPlayer, "cash", data.price)
        end
    elseif data.paymentMethod == "black_money" then
        Koci.Server.PlayerRemoveItem(xPlayer, data.gallery.buyWithBlackMoney.item, data.price)
    end
    cb({ status = true, plate = customPlate })
end)

Koci.Server.RegisterServerCallback("0r-vehicleshop:Server:CheckOverdueRentalCars", function(source, data, cb)
    local src = source
    local xPlayer = Koci.Server.GetPlayerBySource(src)
    local any_action = false
    if xPlayer then
        local owner = Config.FrameWork == "esx" and xPlayer.identifier or xPlayer.PlayerData.citizenid
        local rented_vehicles = Koci.Server.ExecuteSQLQuery("SELECT * FROM `0r_rented_vehicles` WHERE owner = ?",
            { owner },
            "query"
        )
        local expiration_vehicles = {}
        if rented_vehicles then
            local currentTimestamp = os.time()
            for _, v in pairs(rented_vehicles) do
                local rentalDuration = os.difftime(currentTimestamp, v.created_at / 1000)
                local expiration = v.rented_day * 24 * 60 * 60
                if rentalDuration > expiration then
                    any_action = true
                    expiration_vehicles[#expiration_vehicles + 1] = v
                    Koci.Server.ExecuteSQLQuery("DELETE FROM `0r_rented_vehicles` WHERE id = ?", { v.id }, "query")
                end
            end
        end
        if #expiration_vehicles > 0 then
            for _, v in pairs(expiration_vehicles) do
                if Config.PlayerVehiclesDB == "owned_vehicles" then
                    Koci.Server.ExecuteSQLQuery("DELETE FROM `owned_vehicles` WHERE owner = ? AND plate = ?",
                        { owner, v.plate },
                        "query"
                    )
                elseif Config.PlayerVehiclesDB == "player_vehicles" then
                    Koci.Server.ExecuteSQLQuery("DELETE FROM `player_vehicles` WHERE citizenid = ? AND plate = ?",
                        { owner, v.plate },
                        "query"
                    )
                end
            end
        end
    end
    cb({ any_action = any_action })
end)
