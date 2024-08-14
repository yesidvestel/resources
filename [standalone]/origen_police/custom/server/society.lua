function AddMoneyToSociety(money, account)
    if not account then 
        return print("Invalid account name to add money to society: ", account)
    end
    if Config.Framework == "esx" then 
        TriggerEvent('esx_addonaccount:getSharedAccount', "society_"..account, function(accountData)
            if not accountData then 
                return print("Can't get the account data of: ", "society_"..account)
            end
            accountData.addMoney(money)
        end)
    else
        -- We use pcall to prevent the script from crashing if the qb-management resource is with a update that miss the AddMoney function
        local success, result = pcall(function()
            exports["qb-management"]:AddMoney(account, money)
        end)
        if not success then
            success, result = pcall(function()
                exports["qb-banking"]:AddMoney(account, money, "Pay police bill")
            end)
            if not success then
                print("Failed to add money to society: ", result)
            end
        end
    end
end