local Lobbys = {}

AddEventHandler("BakiTelli_Paintball:NewLobby")
RegisterNetEvent("BakiTelli_Paintball:NewLobby", function (p, pStatus, lobby, mapid, time)
    local insert = {
            password = pStatus,
            name = lobby,
            owner = source,
            password_no = p,
            mapid = mapid, 
            time = time,
            redteam_kill = 0,
            blueteam_kill = 0,
            starttime = 0,
            all = 0,
            red= 0,
            blue = 0,
            players = {
                red = {
                    [1] = 9999,  
                    [2] = 9999,                
                    [3] = 9999,                
                    [4] = 9999,                
                    [5] = 9999,                
                },
                blue = {
                    [1] = 9999,  
                    [2] = 9999,                
                    [3] = 9999,                
                    [4] = 9999,                
                    [5] = 9999,  
                }            
            } 
        }
        insert = json.encode(insert)
        table.insert(Lobbys, insert)
end)

AddEventHandler("BakiTelli_Paintball:getData")
RegisterNetEvent("BakiTelli_Paintball:getData", function ()
    TriggerClientEvent("BakiTelli_Paintball:cl:getData", source, Lobbys)
end)

AddEventHandler("BakiTelli_Paintball:exitLobby")
RegisterNetEvent("BakiTelli_Paintball:exitLobby", function (lobbyname)
    ExitLobby(source,lobbyname)
end)

AddEventHandler("BakiTelli_Paintball:KickAllLobby")
RegisterNetEvent("BakiTelli_Paintball:KickAllLobby", function (lobbyname, lb)
    Citizen.CreateThread(function()
        for k,v in pairs(Lobbys) do
            decode = json.decode(v)
            if decode.name == lobbyname then
                local players = decode.players
                for team, teamData in pairs(players) do
                    for num, value in pairs(teamData) do
                        if tonumber(value) == 9999 then
                    else
                        Earth(tonumber(value),decode.name, true) 
                        TriggerClientEvent("BakiTelli_Paintball:cl:closeMenu", tonumber(value), lb)
                        end
                    end
                end
                table.remove(Lobbys, k)
            end
        end 
    end)
end)

AddEventHandler("BakiTelli_Paintball:checkTeam")
RegisterNetEvent("BakiTelli_Paintball:checkTeam", function (lobbyname ,team, num)
    for k,v in pairs(Lobbys) do
        decode = json.decode(v)
        if lobbyname == decode.name then
        for innerKey, innerValue in pairs(decode.players) do
            if innerKey == team then 
                myTeam = tonumber(innerValue[num])
                if myTeam == 9999 then 
                    UpdatePlayers(source, team, num, k)
                    AddPlayer(source,lobbyname,team,num, k)
                    getallplayers(lobbyname)
                    NewTeamDate(source, k)
                else
                    break
                    end  
                end
            end
        end
    end
end)

RegisterNetEvent("BakiTelli_Paintball:getProfile")
AddEventHandler("BakiTelli_Paintball:getProfile", function(srcy, team, num)
    local srcx = source
    Citizen.CreateThread(function()
        local name = getname(srcy)
        local identifierr = GetPlayerIdentifiers(srcy)[1]
        local id = tonumber(identifierr:gsub("steam:", ""), 16)
        local steamid = id and "http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=" .. Config.apikey .. "&steamids=" .. id or 'null'
        TriggerClientEvent("BakiTelli_Paintball:cl:getProfile", srcx, srcy, name, steamid, team, num)
    end)
end)


AddEventHandler("BakiTelli_Paintball:getPlayers")
RegisterNetEvent("BakiTelli_Paintball:getPlayers", function (name)
    id = getLobbyId(name)
    TriggerClientEvent("BakiTelli_Paintball:cl:UpdatePlayers", source, Lobbys, id)
end)

AddEventHandler("BakiTelli_Paintball:LoginLobby")
RegisterNetEvent("BakiTelli_Paintball:LoginLobby", function (lid)
    local decodedData = json.decode(Lobbys[getLobbyId(lid)])
    if decodedData.password == true then 
        TriggerClientEvent("BakiTelli_Paintball:cl:Login", source, decodedData.time, "password")
    else 
        TriggerClientEvent("BakiTelli_Paintball:cl:Login", source, decodedData.time , "no_password")
    end 
end)

AddEventHandler("BakiTelli_Paintball:checkPassword")
RegisterNetEvent("BakiTelli_Paintball:checkPassword", function (pw, lobbyname)
    local decodedData = json.decode(Lobbys[getLobbyId(lobbyname)])
    if decodedData.password_no == pw then 
        TriggerClientEvent("BakiTelli_Paintball:cl:enterPw",source, true, decodedData.time)
    else 
        TriggerClientEvent("BakiTelli_Paintball:cl:enterPw",source, false)
    end 
end)

AddEventHandler("BakiTelli_Paintball:MapUpdate")
RegisterNetEvent("BakiTelli_Paintball:MapUpdate", function (mapid, lk)
    local decodedData = json.decode(Lobbys[getLobbyId(lk)])
    decodedData.mapid = mapid
    Lobbys[getLobbyId(lk)] = json.encode(decodedData)
    MapUpdate(getLobbyId(lk), mapid)
end)

AddEventHandler("BakiTelli_Paintball:TimeEdit")
RegisterNetEvent("BakiTelli_Paintball:TimeEdit", function (time, lk)
    local decodedData = json.decode(Lobbys[getLobbyId(lk)])
    decodedData.time = time
    Lobbys[getLobbyId(lk)] = json.encode(decodedData)
    TimeUpdate(getLobbyId(lk), time)
end)

AddEventHandler("BakiTelli_Paintball:StartGame")
RegisterNetEvent("BakiTelli_Paintball:StartGame", function (lobbyname)
    id = getLobbyId(lobbyname)
    decode = json.decode(Lobbys[id])
    if lobbyname == decode.name then
        for x, innerValue in pairs(decode.players) do
            for num, value in pairs(innerValue) do
                if 9999 == tonumber(value) then else 
                    StartGame(value, tonumber(decode.time), lobbyname)
                    TriggerClientEvent("BakiTelli_Paintball:cl:StartGame", value, x, num)
                end
            end
        end
    end
end)

RegisterServerEvent('BakiTelli_Paintball:killplayer')
AddEventHandler('BakiTelli_Paintball:killplayer', function( lobby, team)
    if team == "red" then
        addKill(lobby, "blue")
    else 
        addKill(lobby, "red")
    end
end)

AddEventHandler("BakiTelli_Paintball:TimeFinish")
RegisterNetEvent("BakiTelli_Paintball:TimeFinish", function (lobbyname)
    id = getLobbyId(lobbyname)
    decode = json.decode(Lobbys[id])
    if lobbyname == decode.name then
        if tonumber(getTime(decode.starttime)) == 0 then
            for x, innerValue in pairs(decode.players) do
                for num, value in pairs(innerValue) do
                    if 9999 == tonumber(value) then else 
                        if x == "red" then 
                            if decode.redteam_kill >= decode.blueteam_kill then 
                                TriggerClientEvent("BakiTelli_Paintball:cl:FinishGame",value, "win")
                            else 
                                TriggerClientEvent("BakiTelli_Paintball:cl:FinishGame",value, "lose")
                            end
                        else 
                            if decode.redteam_kill >= decode.blueteam_kill then 
                                TriggerClientEvent("BakiTelli_Paintball:cl:FinishGame",value, "lose")
                            else 
                                TriggerClientEvent("BakiTelli_Paintball:cl:FinishGame",value, "win")
                            end
                        end
                    end
                end
            end
            TriggerEvent("BakiTelli_Paintball:KickAllLobby", decode.name, false)
        end
    end
end)

function AddPlayer(src, lobbyname, team, num, id)
    local decodedData = json.decode(Lobbys[id])
    decodedData.players[team][num] = src
    Lobbys[id] = json.encode(decodedData)
end

function UpdatePlayers(source, teamx, numi, k)
    local decodedData = json.decode(Lobbys[k])
    local players = decodedData.players
    for team, teamData in pairs(players) do
        for num, value in pairs(teamData) do
            if tonumber(json.encode(value)) == source then
                if tonumber(numi) == tonumber(num) and teamx == team then 
                else
                decodedData.players[team][num] = 9999
                Lobbys[k] = json.encode(decodedData)
                end
            end
        end
    end
end

function NewTeamDate(source, g)
    for k,v in pairs(json.decode(Lobbys[g]).players) do
        for y,x in pairs(v) do
           if  tonumber(x) == 9999 then 
           else
            TriggerClientEvent("BakiTelli_Paintball:cl:UpdatePlayers", tonumber(x), Lobbys, g)
           end
        end
    end
end

function MapUpdate(lk, mid)
    for k,v in pairs(json.decode(Lobbys[lk]).players) do
        for y,x in pairs(v) do
           if  tonumber(x) == 9999 then 
           else
            TriggerClientEvent("BakiTelli_Paintball:cl:UpdateMap", tonumber(x), Lobbys, lk, mid)
           end
        end
    end
end

function TimeUpdate(lk, time)
    for k,v in pairs(json.decode(Lobbys[lk]).players) do
        for y,x in pairs(v) do
           if tonumber(x) == 9999 then 
           else
            TriggerClientEvent("BakiTelli_Paintball:cl:TimeEdit", tonumber(x), Lobbys, lk, time)
           end
        end
    end
end

function ExitLobby(pid,lobbyname)
    for k,v in pairs(Lobbys) do
        decode = json.decode(v)
        if lobbyname == decode.name then
        for x, innerValue in pairs(decode.players) do
            for num, value in pairs(innerValue) do
                myTeam = tonumber(value)
                if myTeam == pid then 
                    decode.players[x][num] = 9999
                    Lobbys[k] = json.encode(decode)
                    id = getLobbyId(lobbyname)
                    for k,v in pairs(json.decode(Lobbys[id]).players) do
                        for y,x in pairs(v) do
                           if  tonumber(x) == 9999 then 
                           else
                            getallplayers(lobbyname)
                            TriggerClientEvent("BakiTelli_Paintball:cl:UpdatePlayers", tonumber(x), Lobbys, id)
                            end
                        end
                    end
                    end  
                end
            end
        end
    end
end

function getallplayers(lobbyname)
    allp = 0
    redp = 0
    bluep = 0
    for k,v in pairs(Lobbys) do
        decode = json.decode(v)
        if lobbyname == decode.name then
        for x, innerValue in pairs(decode.players) do
            for num, value in pairs(innerValue) do
                if 9999 == tonumber(value) then else 
                    allp = allp + 1
                end
                end
            end
                for num, value in pairs(decode.players.red) do
                    if 9999 == tonumber(value) then else 
                        redp = redp + 1
                    end
                end
                for num, value in pairs(decode.players.blue) do
                    if 9999 == tonumber(value) then else 
                        bluep = bluep + 1
                    end
                end
            end
    end
    savePlayers(lobbyname, allp, redp, bluep)
end

function savePlayers(lobbyname,all,red, blue)
    local decodedData = json.decode(Lobbys[getLobbyId(lobbyname)])
    decodedData.red = red
    decodedData.blue = blue
    decodedData.all = all
    Lobbys[getLobbyId(lobbyname)] = json.encode(decodedData)
end 

function StartGame(pid, time, lobbyname)
    Citizen.CreateThread(function()
        futureTime = os.time() + time * 60 
        lobbyid = getLobbyId(lobbyname) 
        local decodedData = json.decode(Lobbys[getLobbyId(lobbyname)])
        decodedData.starttime = futureTime
        Lobbys[lobbyid] = json.encode(decodedData)
        Earth(tonumber(pid),decodedData.name, false) 
        TriggerClientEvent("BakiTelli_Paintball:TimeStart",pid, getTime(futureTime),lobbyname,futureTime)
    end)
end

function addKill(lobby,team)
    if team == "red" then
    local decodedData = json.decode(Lobbys[getLobbyId(lobby)])
    k = decodedData.redteam_kill
    decodedData.redteam_kill = k + 1
    Lobbys[getLobbyId(lobby)] = json.encode(decodedData)
    else   
        local decodedData = json.decode(Lobbys[getLobbyId(lobby)])
        k = decodedData.blueteam_kill
        decodedData.blueteam_kill = k + 1
        Lobbys[getLobbyId(lobby)] = json.encode(decodedData) 
    end
    SendKill(lobby,team)
end

function SendKill(lobby,team)
    for k,v in pairs(json.decode(Lobbys[getLobbyId(lobby)]).players) do
        for y,x in pairs(v) do
           if  tonumber(x) == 9999 then 
           else
            local decodedData = json.decode(Lobbys[getLobbyId(lobby)])
            TriggerClientEvent("BakiTelli_Paintball:cl:UpdateScore", tonumber(x), decodedData.blueteam_kill, decodedData.redteam_kill)
            end
        end
    end
end

function Earth(id,code, cancel) 
    earth = string.gsub(code, Config.Namep.."#", "")
    if cancel then
        SetPlayerRoutingBucket(tonumber(id), 0)
        else
        SetPlayerRoutingBucket(tonumber(id), tonumber(earth))
    end
end

function getTime(futureTimex)
        local currentTime = os.time()
        local remainingTime = futureTimex - currentTime
    
        if remainingTime > 0 then
            return tostring(remainingTime)
        else
            return 0
        end
end

function getLobbyId(lobbyname)
    for k,v in pairs(Lobbys) do
        decode = json.decode(v)
        if decode.name == lobbyname then 
            return tonumber(k)
        end
    end
end

AddEventHandler("playerDropped", function(reason)
    local playerId = source
    for k,v in pairs(Lobbys) do
    decode = json.decode(v)
        local players = decode.players
        for team, teamData in pairs(players) do
            for num, value in pairs(teamData) do
                if tonumber(value) == playerId then
                    if decode.owner == source then 
                        TriggerEvent("BakiTelli_Paintball:KickAllLobby", decode.name, true)
                    else 
                        ExitLobby(playerId,decode.name)
                    end
                end
            end
        end
    end 
end)


