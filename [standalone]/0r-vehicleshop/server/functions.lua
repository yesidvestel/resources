--- Function that executes database queries
---
--- @param query: The SQL query to execute
--- @param params: Parameters for the SQL query (in table form)
--- @param type ("insert" | "update" | "query" | "scalar" | "single" | "prepare"): Parameters for the SQL query (in table form)
--- @return query any Results of the SQL query
Koci.Server.ExecuteSQLQuery = function(query, params, type)
    if type == "insert" then
        return MySQL.insert.await(query, params)
    elseif type == "update" then
        return MySQL.update.await(query, params)
    elseif type == "query" then
        return MySQL.query.await(query, params)
    elseif type == "scalar" then
        return MySQL.scalar.await(query, params)
    elseif type == "single" then
        return MySQL.single.await(query, params)
    elseif type == "prepare" then
        return MySQL.prepare.await(query, params)
    else
        error("Invalid queryType: " .. tostring(type or "?"))
    end
end

---@param system ("esx_notify" | "qb_notify" | "custom_notify") System to be used
---@param source number Player source id
---@param type string inform / success / error
---@param title string Notification text
---@param text? string (optional) description, custom notify.
---@param duration? number (optional) Duration in miliseconds, custom notify.
---@param icon? string (optional) icon.
Koci.Server.SendNotify = function(source, type, title, text, duration, icon)
    system = Config.NotifyType
    if not duration then duration = 1000 end
    if system == "qb_notify" then
        if Config.FrameWork == "qb" then
            TriggerClientEvent("QBCore:Notify", source, title, type)
        else
            Utils.Functions.debugPrint("error", "QB not found.")
        end
    elseif system == "esx_notify" then
        if Config.FrameWork == "esx" then
            TriggerClientEvent("esx:showNotification", source, title, type, duration)
        else
            Utils.Functions.debugPrint("error", "ESX not found.")
        end
    elseif system == "custom_notify" then
        Utils.Functions.CustomNotify(source, title, type, text, duration, icon)
    else
        Utils.Functions.debugPrint("error", "An error occurred.")
    end
end

--- Gets a player by their source ID, based on the configured framework.
--- @param source number The source ID of the player.
--- @return table|nil Player The player data if found, or nil if not found.
Koci.Server.GetPlayerBySource = function(source)
    if Config.FrameWork == "esx" then
        return Koci.Framework.GetPlayerFromId(source)
    elseif Config.FrameWork == "qb" then
        return Koci.Framework.Functions.GetPlayer(source)
    end
end

--- Gets the balance of a specific account type for a player, based on the configured framework.
--- @param type string The type of account for which the balance is requested.
--- @param Player table The player data.
--- @return number balance The account balance.
Koci.Server.GetPlayerBalance = function(type, Player)
    if Config.FrameWork == "esx" then
        type = type == "cash" and "money" or type
        return Player.getAccount(type).money
    elseif Config.FrameWork == "qb" then
        return Player.PlayerData.money[type]
    end
end

Koci.Server.PlayerRemoveMoney = function(Player, type, amount)
    local playerSource = Config.FrameWork == "esx" and Player.source or Player.PlayerData.source
    if Config.FrameWork == "qb" then
        local result = Player.Functions.RemoveMoney(type, tonumber(amount), reason)
        return result
    elseif Config.FrameWork == "esx" then
        Player.removeAccountMoney(type, tonumber(amount))
        return true
    end
end

Koci.Server.PlayerHasItem = function(Player, itemName)
    local playerSource = Config.FrameWork == "esx" and Player.source or Player.PlayerData.source
    if Config.InventoryType == "ox_inventory" then
        local itemCount = exports.ox_inventory:GetItemCount(playerSource, itemName)
        return itemCount > 0, itemCount
    elseif Config.InventoryType == "qb_inventory" then
        local items = Player.Functions.GetItemsByName(itemName)
        local itemCount = 0
        for _, item in pairs(items) do
            if item.amount then
                itemCount = itemCount + item.amount
            end
        end
        return itemCount > 0, itemCount
    elseif Config.InventoryType == "custom" then
        local itemCount = CustomInventory.GetItemCount(playerSource, itemName)
        return itemCount > 0, itemCount
    end
end

Koci.Server.ExecuteSQLQuery = function(query, params, type)
    if type == "insert" then
        return MySQL.insert.await(query, params)
    elseif type == "update" then
        return MySQL.update.await(query, params)
    elseif type == "query" then
        return MySQL.query.await(query, params)
    elseif type == "scalar" then
        return MySQL.scalar.await(query, params)
    elseif type == "single" then
        return MySQL.single.await(query, params)
    elseif type == "prepare" then
        return MySQL.prepare.await(query, params)
    else
        error("Invalid queryType: " .. tostring(type or "?"))
    end
end

Koci.Server.GenerateCustomPlate = function()
    math.randomseed(GetGameTimer())
    local function getRandomElement(list)
        return list[math.random(#list)]
    end
    local function getRandomLetter()
        return getRandomElement(Config.Plate.Letters)
    end
    local function getRandomNumber()
        return tostring(math.random(0, 9))
    end
    local function generatePlate()
        local plateLetters = ""
        for i = 1, Config.Plate.NumberOfLetters do
            plateLetters = plateLetters .. getRandomLetter()
        end
        local plateNumbers = ""
        for i = 1, Config.Plate.NumberOfNumbers do
            plateNumbers = plateNumbers .. getRandomNumber()
        end
        local plate = string.upper(plateLetters .. plateNumbers)
        if #plate > 8 then
            plate = plate:sub(1, 8)
        end
        if Koci.Server.IsPlateTaken(plate) then
            return generatePlate()
        end
        return plate
    end
    return generatePlate()
end
exports("GenerateCustomPlate", Koci.Server.GenerateCustomPlate)

Koci.Server.IsPlateTaken = function(plate)
    local tableName = Config.PlayerVehiclesDB
    local result = Koci.Server.ExecuteSQLQuery("SELECT plate FROM " .. tableName .. " WHERE plate = :plate LIMIT 1", {
        plate = plate
    }, "single")
    if not result then
        return false
    else
        return true
    end
end

Koci.Server.CheckPlayerMoney = function(xPlayer, amount, type, extra)
    if type == "cash" then
        if extra.gallery.isMoneyAnItem.status then
            local s, count = Koci.Server.PlayerHasItem(xPlayer, extra.gallery.isMoneyAnItem.item)
            if s and count >= amount then
                return true
            else
                return false
            end
        else
            local b = Koci.Server.GetPlayerBalance("cash", xPlayer)
            return tonumber(b) >= tonumber(amount)
        end
    elseif type == "bank" then
        local b = Koci.Server.GetPlayerBalance("bank", xPlayer)
        return tonumber(b) >= tonumber(amount)
    elseif type == "black_money" then
        local s, count = Koci.Server.PlayerHasItem(xPlayer, extra.gallery.buyWithBlackMoney.item)
        if s and count >= amount then
            return true
        else
            return false
        end
    elseif type == "coin" then
        local s, count = Koci.Server.PlayerHasItem(xPlayer, extra.gallery.buyWithCoin.item)
        if s and count >= amount then
            return true
        else
            return false
        end
    end
end

Koci.Server.PlayerRemoveItem = function(Player, itemName, itemCount)
    local playerSource = Config.FrameWork == "esx" and Player.source or Player.PlayerData.source
    if Config.InventoryType == "qb_inventory" then
        local result = Player.Functions.RemoveItem(itemName, itemCount)
        return result
    elseif Config.InventoryType == "ox_inventory" then
        local result = exports.ox_inventory:RemoveItem(playerSource, itemName, itemCount)
        return result
    elseif Config.InventoryType == "custom" then
        local result = CustomInventory.RemoveItem(playerSource, itemName, itemCount)
        return result
    end
end

Koci.Server.CheckRemainingRentDay = function(Player, plate)
    plate = string.upper(plate)
    local owner = Config.FrameWork == "esx" and Player.identifier or Player.PlayerData.citizenid
    local row = Koci.Server.ExecuteSQLQuery(
        "SELECT * FROM `0r_rented_vehicles` WHERE owner = ? AND plate = ?",
        { owner, plate },
        "single"
    )
    if not row then
        return {
            message = _t("rent.dont_own")
        }
    end
    local currentTimestamp = os.time()
    local rentalDuration = os.difftime(currentTimestamp, row.created_at / 1000)
    local totalSeconds = row.rented_day * 24 * 60 * 60 - rentalDuration

    local days = math.floor(totalSeconds / (24 * 60 * 60))
    local hours = math.floor((totalSeconds % (24 * 60 * 60)) / 3600)
    local minutes = math.floor((totalSeconds % 3600) / 60)
    return {
        message = _t("rent.remaining_time", days, hours, minutes)
    }
end

Koci.Server.VehicleRentExtend = function(Player, plate, day)
    day = tonumber(day or 1)
    plate = string.upper(plate or "")
    local owner = Config.FrameWork == "esx" and Player.identifier or Player.PlayerData.citizenid
    local row = Koci.Server.ExecuteSQLQuery(
        "SELECT * FROM `0r_rented_vehicles` WHERE owner = ? AND plate = ?",
        { owner, plate },
        "single"
    )
    if not row then
        return {
            message = _t("rent.dont_own")
        }
    end
    local price = math.floor(row.daily_fee * day)
    local checkPlayerMoney = Koci.Server.CheckPlayerMoney(
        Player,
        price,
        "bank"
    )
    if not checkPlayerMoney then
        return {
            message = _t("purchase.dont_have_enough_money")
        }
    end
    local newRentedDay = tonumber(row.rented_day) + day
    Koci.Server.ExecuteSQLQuery(
        "UPDATE `0r_rented_vehicles` SET rented_day = ? WHERE owner = ? AND plate = ?",
        { newRentedDay, owner, plate },
        "update"
    )
    Koci.Server.PlayerRemoveMoney(Player, "bank", price)
    return {
        message = _t("rent.been_extended", day, newRentedDay)
    }
end
