local onTimerCoke = {}
lib.callback.register('drc_drugs:coke:getitem', function(source, type)
    if type == "CokeBox" then
        local number = 0
        for k, v in pairs(Config.Coke.CokeBox.RequiredItems) do
            if GetItem(v.item, v.count, source) then
                number = number + 1
            end
        end
        if number == #Config.Coke.CokeBox.RequiredItems then
            return true
        else
            return false
        end
    elseif type == "CokePick" then
        local number = 0
        for k, v in pairs(Config.Coke.Field.RequiredItems) do
            if GetItem(v.item, v.count, source) then
                number = number + 1
            end
        end
        if number == #Config.Coke.Field.RequiredItems then
            return true
        else
            return false
        end
    elseif type == "CokeProcess" then
        local number = 0
        for k, v in pairs(Config.Coke.LeafProcess.RequiredItems) do
            if GetItem(v.item, v.count, source) then
                number = number + 1
            end
        end
        if number == #Config.Coke.LeafProcess.RequiredItems then
            return true
        else
            return false
        end
    elseif type == "CokeSoda" then
        local number = 0
        for k, v in pairs(Config.Coke.Soda.RequiredItems) do
            if GetItem(v.item, v.count, source) then
                number = number + 1
            end
        end
        if number == #Config.Coke.Soda.RequiredItems then
            return true
        else
            return false
        end
    elseif type == "BrokenFigure" then
        if GetItem("coke_figurebroken", 1, source) and GetItem("glue", 1, source) then
            return true
        else
            return false
        end
    elseif type == "CokeFigure" then
        local number = 0
        for k, v in pairs(Config.Coke.FigurePackage.RequiredItems) do
            if GetItem(v.item, v.count, source) then
                number = number + 1
            end
        end
        if number == #Config.Coke.FigurePackage.RequiredItems then
            return true
        else
            return false
        end
    end
end)

RegisterServerEvent("drc_drugs:coke:giveitems")
AddEventHandler("drc_drugs:coke:giveitems", function(type)
    local srcCoords = GetEntityCoords(GetPlayerPed(source))
    if onTimerCoke[source] and onTimerCoke[source] > GetGameTimer() then
        Logs(source, "Drugs (Coke, Timer): Player Tried to exploit Event")
        BanPlayer(source, "Drugs (Coke Timer): Player Tried to exploit Event")
        if Config.DropPlayer then
            DropPlayer(source, "Drugs: Player Tried to exploit Event")
        end
        return
    end
    if type == "CokeBox" then
        local dist = #(Config.Coke.CokeBox.coords - srcCoords)
        if dist <= 20 then
            local number = 0
            for _, v in pairs(Config.Coke.CokeBox.RequiredItems) do
                if GetItem(v.item, v.count, source) then
                    number = number + 1
                end
            end
            if number == #Config.Coke.CokeBox.RequiredItems then
                for _, v in pairs(Config.Coke.CokeBox.RequiredItems) do
                    if v.remove then
                        RemoveItem(v.item, v.count, source)
                    end
                end
                for _, v in pairs(Config.Coke.CokeBox.AddItems) do
                    AddItem(v.item, v.count, source)
                end
                onTimerCoke[source] = GetGameTimer() + (2 * 1000)
                Logs(source, Config.Coke.CokeBox.Log)
            end
        else
            Logs(source, "Drugs (Coke, Coords): Player Tried to exploit Event")
            BanPlayer(source, "Drugs (Coke Coords): Player Tried to exploit Event")
            if Config.DropPlayer then
                DropPlayer(source, "Drugs: Player Tried to exploit Event")
            end
        end
    elseif type == "CokeProcess" then
        local dist = #(Config.Coke.LeafProcess.coords - srcCoords)
        if dist <= 20 then
            local number = 0
            for _, v in pairs(Config.Coke.LeafProcess.RequiredItems) do
                if GetItem(v.item, v.count, source) then
                    number = number + 1
                end
            end
            if number == #Config.Coke.LeafProcess.RequiredItems then
                for _, v in pairs(Config.Coke.LeafProcess.RequiredItems) do
                    if v.remove then
                        RemoveItem(v.item, v.count, source)
                    end
                end
                for _, v in pairs(Config.Coke.LeafProcess.AddItems) do
                    AddItem(v.item, v.count, source)
                end
                onTimerCoke[source] = GetGameTimer() + (2 * 1000)
                Logs(source, Config.Coke.LeafProcess.Log)
            end
        else
            Logs(source, "Drugs (Coke, Coords): Player Tried to exploit Event")
            BanPlayer(source, "Drugs (Coke Coords): Player Tried to exploit Event")
            if Config.DropPlayer then
                DropPlayer(source, "Drugs: Player Tried to exploit Event")
            end
        end
    elseif type == "break" then
        if GetItem("coke_figure", 1, source) then
            onTimerCoke[source] = GetGameTimer() + (2 * 1000)
            RemoveItem("coke_figure", 1, source)
            AddItem("coke_pure", 5, source)
            AddItem("coke_figurebroken", 1, source)
        end
    elseif type == "empty" then
        if GetItem("coke_figureempty", 1, source) then
            onTimerCoke[source] = GetGameTimer() + (2 * 1000)
            RemoveItem("coke_figureempty", 1, source)
            AddItem("coke_figurebroken", 1, source)
        end
    elseif type == "BrokenFigure" then
        if GetItem("coke_figurebroken", 1, source) and GetItem("glue", 1, source) then
            onTimerCoke[source] = GetGameTimer() + (2 * 1000)
            RemoveItem("coke_figurebroken", 1, source)
            RemoveItem("glue", 1, source)
            AddItem("coke_figureempty", 1, source)
        end
    elseif type == "CokePick" then
        local dist = #(Config.Coke.Field.coords - srcCoords)
        if dist <= 300 then
            local number = 0
            for _, v in pairs(Config.Coke.Field.RequiredItems) do
                if GetItem(v.item, v.count, source) then
                    number = number + 1
                end
            end
            if number == #Config.Coke.Field.RequiredItems then
                for _, v in pairs(Config.Coke.Field.RequiredItems) do
                    if v.remove then
                        RemoveItem(v.item, v.count, source)
                    end
                end
                for _, v in pairs(Config.Coke.Field.AddItems) do
                    AddItem(v.item, v.count, source)
                end
                onTimerCoke[source] = GetGameTimer() + (2 * 1000)
                Logs(source, Config.Coke.Field.Log)
            end
        end
    elseif type == "CokeSoda" then
        local dist = #(getClosestCoordsSoda(Config.Coke.SodaTables) - srcCoords)
        if dist <= 20 then
            local number = 0
            for _, v in pairs(Config.Coke.Soda.RequiredItems) do
                if GetItem(v.item, v.count, source) then
                    number = number + 1
                end
            end
            if number == #Config.Coke.Soda.RequiredItems then
                for _, v in pairs(Config.Coke.Soda.RequiredItems) do
                    if v.remove then
                        RemoveItem(v.item, v.count, source)
                    end
                end
                for _, v in pairs(Config.Coke.Soda.AddItems) do
                    AddItem(v.item, v.count, source)
                end
                onTimerCoke[source] = GetGameTimer() + (2 * 1000)
                Logs(source, Config.Coke.Soda.Log)
            end
        else
            Logs(source, "Drugs (Coke, Coords): Player Tried to exploit Event")
            BanPlayer(source, "Drugs (Coke Coords): Player Tried to exploit Event")
            if Config.DropPlayer then
                DropPlayer(source, "Drugs: Player Tried to exploit Event")
            end
        end
    elseif type == "CokeFigure" then
        local dist = #(Config.Coke.FigurePackage.coords - srcCoords)
        if dist <= 20 then
            local number = 0
            for _, v in pairs(Config.Coke.FigurePackage.RequiredItems) do
                if GetItem(v.item, v.count, source) then
                    number = number + 1
                end
            end
            if number == #Config.Coke.FigurePackage.RequiredItems then
                for _, v in pairs(Config.Coke.FigurePackage.RequiredItems) do
                    if v.remove then
                        RemoveItem(v.item, v.count, source)
                    end
                end
                for _, v in pairs(Config.Coke.FigurePackage.AddItems) do
                    AddItem(v.item, v.count, source)
                end
                onTimerCoke[source] = GetGameTimer() + (2 * 1000)
                Logs(source, Config.Coke.FigurePackage.Log)
            end
        else
            Logs(source, "Drugs (Coke, Coords): Player Tried to exploit Event")
            BanPlayer(source, "Drugs (Coke Coords): Player Tried to exploit Event")
            if Config.DropPlayer then
                DropPlayer(source, "Drugs: Player Tried to exploit Event")
            end
        end
    end
end)

function getClosestCoordsSoda(_table)
    local _ClosestCoord = nil
    local _ClosestDistance = 100000
    local _Coord = GetEntityCoords(GetPlayerPed(source))

    for k, v in pairs(_table) do
        local _Distance = #(vec3(v.coords.x, v.coords.y, v.coords.z) - _Coord)
        if _Distance <= _ClosestDistance then
            _ClosestDistance = _Distance
            _ClosestCoord = vec3(v.coords.x, v.coords.y, v.coords.z)
        end
    end

    return _ClosestCoord
end
