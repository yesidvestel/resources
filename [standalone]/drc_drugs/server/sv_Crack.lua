local onTimeCrack = {}
lib.callback.register('drc_drugs:crack:getitem', function(source, type)
    if type == "CrackProcess" then
        local number = 0
        for _, v in pairs(Config.Crack.Process.RequiredItems) do
            if GetItem(v.item, v.count, source) then
                number = number + 1
            end
        end
        if number == #Config.Crack.Process.RequiredItems then
            return true
        else
            return false
        end
    end
end)

RegisterServerEvent("drc_drugs:crack:giveitems")
AddEventHandler("drc_drugs:crack:giveitems", function(type)
    if onTimeCrack[source] and onTimeCrack[source] > GetGameTimer() then
        Logs(source, "Drugs (Crack, Time): Player Tried to exploit Event")
        BanPlayer(source, "Drugs (Crack, Time): Player Tried to exploit Event")
        if Config.DropPlayer then
            DropPlayer(source, "Drugs: Player Tried to exploit Event")
        end
        return
    end
    local srcCoords = GetEntityCoords(GetPlayerPed(source))
    if type == "CrackProcess" then
        local dist = #(Config.Crack.Process.coords - srcCoords)
        if dist <= 100 then
            local number = 0
            for _, v in pairs(Config.Crack.Process.RequiredItems) do
                if GetItem(v.item, v.count, source) then
                    number = number + 1
                end
            end
            if number == #Config.Crack.Process.RequiredItems then
                for _, v in pairs(Config.Crack.Process.RequiredItems) do
                    if v.remove then
                        RemoveItem(v.item, v.count, source)
                    end
                end
                for _, v in pairs(Config.Crack.Process.AddItems) do
                    AddItem(v.item, v.count, source)
                end
                onTimeCrack[source] = GetGameTimer() + (2 * 1000)
                Logs(source, Config.Crack.Process.Log)
            end
        else
            Logs(source, "Drugs (Crack, coords): Player Tried to exploit Event")
            BanPlayer(source, "Drugs (Crack Coords): Player Tried to exploit Event")
            if Config.DropPlayer then
                DropPlayer(source, "Drugs: Player Tried to exploit Event")
            end
        end
    end
end)
