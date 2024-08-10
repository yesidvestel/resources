local onTimePeyote = {}
lib.callback.register('drc_drugs:peyote:getitem', function(source, type)
    if type == "PeyotePickup" then
        local number = 0
        for _, v in pairs(Config.PeyoteField.RequiredItems) do
            if GetItem(v.item, v.count, source) then
                number = number + 1
            end
        end
        if number == #Config.PeyoteField.RequiredItems then
            return true
        else
            return false
        end
    end
end)

RegisterServerEvent("drc_drugs:peyote:giveitems")
AddEventHandler("drc_drugs:peyote:giveitems", function(type)
    local srcCoords = GetEntityCoords(GetPlayerPed(source))
    if onTimePeyote[source] and onTimePeyote[source] > GetGameTimer() then
        Logs(source, "Drugs (peyote, Time): Player Tried to exploit Event")
        BanPlayer(source, "Drugs (peyote, Time): Player Tried to exploit Event")
        if Config.DropPlayer then
            DropPlayer(source, "Drugs: Player Tried to exploit Event")
        end
        return
    end
    if type == "PeyotePickup" then
        local dist = #(Config.PeyoteField.coords - srcCoords)
        if dist <= 100 then
            local number = 0
            for _, v in pairs(Config.PeyoteField.RequiredItems) do
                if GetItem(v.item, v.count, source) then
                    number = number + 1
                end
            end
            if number == #Config.PeyoteField.RequiredItems then
                for _, v in pairs(Config.PeyoteField.RequiredItems) do
                    if v.remove then
                        RemoveItem(v.item, v.count, source)
                    end
                end
                for _, v in pairs(Config.PeyoteField.AddItems) do
                    AddItem(v.item, v.count, source)
                end
                onTimePeyote[source] = GetGameTimer() + (2 * 1000)
                Logs(source, Config.PeyoteField.Log)
            end
        else
            Logs(source, "Drugs (peyote, coords): Player Tried to exploit Event")
            BanPlayer(source, "Drugs (peyote, Coords): Player Tried to exploit Event")
            if Config.DropPlayer then
                DropPlayer(source, "Drugs: Player Tried to exploit Event")
            end
        end
    end
end)
