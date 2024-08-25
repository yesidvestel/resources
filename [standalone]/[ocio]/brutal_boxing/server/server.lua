Areas = {}

Citizen.CreateThread(function()
    for k,v in pairs(Config.Areas) do
        Areas[k] = {
            started = false,
            rounds = 1,
            gloves = true,
            betsetting = false,
            bet = false,
            bets = {},
            bettimer = 0,
            player1 = {id = nil, points = 0, nickname = nil, totalwins = nil, gender = nil},
            player2 = {id = nil, points = 0, nickname = nil, totalwins = nil, gender = nil},
        }
    end
end)

RESCB("brutal_boxing:server:GetAreaTable",function(source,cb,index)
    cb(Areas[index])
end)

RegisterNetEvent("brutal_boxing:server:join")
AddEventHandler("brutal_boxing:server:join", function(index, place, totalwins)
    if Areas[index].player1.id ~= source and Areas[index].player2.id ~= source then
        if place == 1 then
            if Areas[index].player1.id == nil then
                local gender = GetPlayerSex(source)
                if gender == 'm' then
                    gender = Config.Locales.Male
                else 
                    gender = Config.Locales.Female
                end
                Areas[index].player1 = {id = source, points = 0, nickname = GetPlayerNameFunction(source), totalwins = totalwins, gender = gender}
                TriggerClientEvent('brutal_boxing:client:SuccessJoin', source)
            end
        elseif place == 2 then
            if Areas[index].player2.id == nil then
                local gender = GetPlayerSex(source)
                if gender == 'm' then
                    gender = Config.Locales.Male
                else 
                    gender = Config.Locales.Female
                end
                Areas[index].player2 = {id = source, points = 0, nickname = GetPlayerNameFunction(source), totalwins = totalwins, gender = gender}
                TriggerClientEvent('brutal_boxing:client:SuccessJoin', source)
            end
        end

        TriggerClientEvent('brutal_boxing:client:MenuOpenAgain', -1, Areas[index], index)
    else
        TriggerClientEvent('brutal_boxing:client:SendNotify', source, Config.Notify[1][1], Config.Notify[1][2], Config.Notify[1][3], Config.Notify[1][4])
    end
end)

RegisterNetEvent("brutal_boxing:server:leave")
AddEventHandler("brutal_boxing:server:leave", function(index, place)
    if place == 1 then
        Areas[index].player1 = {id = nil, points = 0, nickname = nil, totalwins = nil, gender = nil}
    elseif place == 2 then
        Areas[index].player2 = {id = nil, points = 0, nickname = nil, totalwins = nil, gender = nil}
    end

    TriggerClientEvent('brutal_boxing:client:MenuOpenAgain', -1, Areas[index], index)
end)

RegisterNetEvent("brutal_boxing:server:start")
AddEventHandler("brutal_boxing:server:start", function(index, rounds, gloves, bet)
    if not Areas[index].started then
        Areas[index].started = true
        Areas[index].rounds = rounds
        Areas[index].gloves = gloves
        Areas[index].bet = bet
        Areas[index].betsetting = bet

        if Areas[index].bet then
            Areas[index].bettimer = Config.TimeToBet
            TriggerClientEvent('brutal_boxing:client:startbettimer', -1, Areas[index], index)

            while Areas[index].started and Areas[index].bettimer > 0 do
                Citizen.Wait(1000)
                Areas[index].bettimer -= 1
            end
            Areas[index].bet = false
        end

        TriggerClientEvent('brutal_boxing:client:start', Areas[index].player1.id, Areas[index], 1)
        TriggerClientEvent('brutal_boxing:client:start', Areas[index].player2.id, Areas[index], 2)

        TriggerClientEvent('brutal_boxing:client:MenuOpenAgain', -1, Areas[index], index)
    end
end)

RegisterNetEvent("brutal_boxing:server:roundover")
AddEventHandler("brutal_boxing:server:roundover", function(index, winner)
    if Areas[index].started then
        Areas[index].rounds -= 1

        if winner == 1 then
            Areas[index].player1.points += 1
        elseif winner == 2 then
            Areas[index].player2.points += 1
        end

        if Areas[index].rounds > 0 then
            TriggerClientEvent('brutal_boxing:client:start', Areas[index].player1.id, Areas[index], 1)
            TriggerClientEvent('brutal_boxing:client:start', Areas[index].player2.id, Areas[index], 2)
        else
            local winner
            if Areas[index].player1.points > Areas[index].player2.points then
                winner = 1
            elseif Areas[index].player2.points > Areas[index].player1.points then
                winner = 2
            else
                winner = false
            end

            TriggerClientEvent('brutal_boxing:client:finish', Areas[index].player1.id, 1, Areas[index], winner)
            TriggerClientEvent('brutal_boxing:client:finish', Areas[index].player2.id, 2, Areas[index], winner)

            Areas[index] = {
                started = false,
                rounds = 1,
                gloves = true,
                betsetting = false,
                bet = false,
                bets = {},
                bettimer = 0,
                player1 = {id = nil, points = 0, nickname = nil, totalwins = nil, gender = nil},
                player2 = {id = nil, points = 0, nickname = nil, totalwins = nil, gender = nil},
            }
        end
    end
end)

RegisterNetEvent("brutal_boxing:server:removejoin")
AddEventHandler("brutal_boxing:server:removejoin", function()
    RemoveJoin(source)
end)

AddEventHandler('playerDropped', function()
    RemoveJoin(source)
end)

function RemoveJoin(src)
    local source = src
    for k,v in pairs(Areas) do
        for kk, vv in pairs(v) do
            if v.player1.id == source then
                if v.started == false then
                    Areas[k].player1 = {id = nil, points = 0, nickname = nil, totalwins = nil, gender = nil}
                    TriggerClientEvent('brutal_boxing:client:MenuOpenAgain', -1, Areas[k], k)
                else
                    TriggerClientEvent('brutal_boxing:client:SendNotify', Areas[k].player2.id, Config.Notify[2][1], Config.Notify[2][2], Config.Notify[2][3], Config.Notify[2][4])
                    TriggerClientEvent('brutal_boxing:client:finish', Areas[k].player2.id, 2, Areas[k], false)

                    Areas[k] = {
                        started = false,
                        rounds = 1,
                        gloves = true,
                        betsetting = false,
                        bet = false,
                        bets = {},
                        bettimer = 0,
                        player1 = {id = nil, points = 0, nickname = nil, totalwins = nil, gender = nil},
                        player2 = {id = nil, points = 0, nickname = nil, totalwins = nil, gender = nil},
                    }
                end
            elseif v.player2.id == source then
                if v.started == false then
                    Areas[k].player2 = {id = nil, points = 0, nickname = nil, totalwins = nil, gender = nil}
                    TriggerClientEvent('brutal_boxing:client:MenuOpenAgain', -1, Areas[k], k)
                else
                    TriggerClientEvent('brutal_boxing:client:SendNotify', Areas[k].player1.id, Config.Notify[2][1], Config.Notify[2][2], Config.Notify[2][3], Config.Notify[2][4])
                    TriggerClientEvent('brutal_boxing:client:finish', Areas[k].player1.id, 1, Areas[k], false)

                    Areas[k] = {
                        started = false,
                        rounds = 1,
                        gloves = true,
                        betsetting = false,
                        bet = false,
                        bets = {},
                        bettimer = 0,
                        player1 = {id = nil, points = 0, nickname = nil, totalwins = nil, gender = nil},
                        player2 = {id = nil, points = 0, nickname = nil, totalwins = nil, gender = nil},
                    }
                end
            end
        end
    end
end

RegisterNetEvent("brutal_boxing:server:bet")
AddEventHandler("brutal_boxing:server:bet", function(index, place, amount)
    if Areas[index].started and Areas[index].bet then
        if Areas[index].bets[source] == nil then
            if GetAccountMoney(source,'money') >= amount then
                if place == 1 then
                    if Areas[index].bets.player1 == nil then Areas[index].bets.player1 = 0 end
                    if Areas[index].bets.player2 == nil then Areas[index].bets.player2 = 0 end

                    Areas[index].bets.player1 += amount
                elseif place == 2 then
                    if Areas[index].bets.player1 == nil then Areas[index].bets.player1 = 0 end
                    if Areas[index].bets.player2 == nil then Areas[index].bets.player2 = 0 end

                    Areas[index].bets.player2 += amount
                end

                Areas[index].bets[source] = {place = place, amount = amount}
                RemoveAccountMoney(source, 'money', amount)
                TriggerClientEvent('brutal_boxing:client:SendNotify', source, Config.Notify[4][1], Config.Notify[4][2]..' '..amount..''..Config.MoneyForm, Config.Notify[4][3], Config.Notify[4][4])
            else
                TriggerClientEvent('brutal_boxing:client:SendNotify', source, Config.Notify[6][1], Config.Notify[6][2], Config.Notify[6][3], Config.Notify[6][4])
            end
        else
            TriggerClientEvent('brutal_boxing:client:SendNotify', source, Config.Notify[3][1], Config.Notify[3][2], Config.Notify[3][3], Config.Notify[3][4])
        end
    end
end)

RegisterNetEvent("brutal_boxing:server:endofbet")
AddEventHandler("brutal_boxing:server:endofbet", function(Table, Winner)
    if Winner ~= false then
        if Winner == 1 then
            for k,v in pairs(Table.bets) do
                local ping = GetPlayerPing(k)
                if ping > 0 then
                    if Table.bets.player1 > 0 and Table.bets.player2 > 0 then
                        if v.place == 1 then
                            local percent = v.amount/Table.bets.player1
                            local prize = math.floor(percent*Table.bets.player2)
                            AddMoneyFunction(k, 'money', v.amount+prize)
                            TriggerClientEvent('brutal_boxing:client:SendNotify', k, Config.Notify[7][1], Config.Notify[7][2]..' '..v.amount+prize..''..Config.MoneyForm, Config.Notify[7][3], Config.Notify[7][4])
                        else
                            TriggerClientEvent('brutal_boxing:client:SendNotify', k, Config.Notify[8][1], Config.Notify[8][2], Config.Notify[8][3], Config.Notify[8][4])
                        end
                    else
                        local prize = 0
                        AddMoneyFunction(k, 'money', v.amount)
                        TriggerClientEvent('brutal_boxing:client:SendNotify', k, Config.Notify[5][1], Config.Notify[5][2]..' '..v.amount..''..Config.MoneyForm, Config.Notify[5][3], Config.Notify[5][4])
                    end
                end
            end
        elseif Winner == 2 then
            for k,v in pairs(Table.bets) do
                local ping = GetPlayerPing(k)
                if ping > 0 then
                    if Table.bets.player1 > 0 and Table.bets.player2 > 0 then
                        if v.place == 2 then
                            local percent = v.amount/Table.bets.player2
                            local prize = math.floor(percent*Table.bets.player1)
                            AddMoneyFunction(k, 'money', v.amount+prize)
                            TriggerClientEvent('brutal_boxing:client:SendNotify', k, Config.Notify[7][1], Config.Notify[7][2]..' '..v.amount+prize..''..Config.MoneyForm, Config.Notify[7][3], Config.Notify[7][4])
                        else
                            TriggerClientEvent('brutal_boxing:client:SendNotify', k, Config.Notify[8][1], Config.Notify[8][2], Config.Notify[8][3], Config.Notify[8][4])
                        end
                    else
                        local prize = 0
                        AddMoneyFunction(k, 'money', v.amount)
                        TriggerClientEvent('brutal_boxing:client:SendNotify', k, Config.Notify[5][1], Config.Notify[5][2]..' '..v.amount..''..Config.MoneyForm, Config.Notify[5][3], Config.Notify[5][4])
                    end
                end
            end
        end
    else
        for k,v in pairs(Table.bets) do
            local ping = GetPlayerPing(k)
            if ping > 0 then
                AddMoneyFunction(k, 'money', v.amount)
                TriggerClientEvent('brutal_boxing:client:SendNotify', k, Config.Notify[5][1], Config.Notify[5][2]..' '..v.amount..''..Config.MoneyForm, Config.Notify[5][3], Config.Notify[5][4])
            end
        end
    end
end)