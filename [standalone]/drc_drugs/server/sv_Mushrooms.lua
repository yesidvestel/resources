local onTimerShrooms = {}
lib.callback.register('drc_drugs:mushroom:getitem', function(source, type)
    if type == "MushroomPickup" then
        local number = 0
        for _, v in pairs(Config.MushroomsField.RequiredItems) do
            if GetItem(v.item, v.count, source) then
                number = number + 1
            end
        end
        if number == #Config.MushroomsField.RequiredItems then
            return true
        else
            return false
        end
    end
end)

RegisterServerEvent("drc_drugs:mushroom:giveitems")
AddEventHandler("drc_drugs:mushroom:giveitems", function(type)
    if onTimerShrooms[source] and onTimerShrooms[source] > GetGameTimer() then
        Logs(source, "Drugs (Mushrooms, Time): Player Tried to exploit Event")
        BanPlayer(source, "Drugs (Mushrooms, Time): Player Tried to exploit Event")
        if Config.DropPlayer then
            DropPlayer(source, "Drugs: Player Tried to exploit Event")
        end
        return
    end
    local srcCoords = GetEntityCoords(GetPlayerPed(source))
    if type == "MushroomPickup" then
        local dist = #(Config.MushroomsField.coords - srcCoords)
        if dist <= 100 then
            local number = 0
            for _, v in pairs(Config.MushroomsField.RequiredItems) do
                if GetItem(v.item, v.count, source) then
                    number = number + 1
                end
            end
            if number == #Config.MushroomsField.RequiredItems then
                for _, v in pairs(Config.MushroomsField.RequiredItems) do
                    if v.remove then
                        RemoveItem(v.item, v.count, source)
                    end
                end
                for _, v in pairs(Config.MushroomsField.AddItems) do
                    AddItem(v.item, v.count, source)
                end
                onTimerShrooms[source] = GetGameTimer() + (2 * 1000)
                Logs(source, Config.MushroomsField.Log)
            end
        else
            Logs(source, "Drugs (Mushrooms, Coords): Player Tried to exploit Event")
            BanPlayer(source, "Drugs (Mushrooms, Coords): Player Tried to exploit Event")
            if Config.DropPlayer then
                DropPlayer(source, "Drugs: Player Tried to exploit Event")
            end
        end
    end
end)
