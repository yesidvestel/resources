
local Status = "playerx"
local mapid = 1
local mteam = "red"
local timeri = 0
local enterMenu = 1
local time = 25
local playingPaintball = false
local kills = 0
local Lobbys = {}
local LobbysIdx = nil
local LobbyName = nil
local blipx = {}
local scoord = vector4(1,1,1,1)
local isCooldownActive = false
local totalMapx = 0

Citizen.CreateThread(function()
    totalMap()
	while true do
		local sleep = 500
		local playercoord = GetEntityCoords(PlayerPedId())
		for k,v in pairs(Config.PaintballArea) do
            local dst = #(playercoord - vector3(v.AreaCoord.x,v.AreaCoord.y,v.AreaCoord.z))
                if dst < Config.Distance then
                    sleep = 1
                    enterMenu = k
                    DrawMarker(Config.Markers.PaintBall.Type, v.AreaCoord.x,v.AreaCoord.y,v.AreaCoord.z, 0.0, 0.0,
                    0.0, 0, 0.0, 0.0, Config.Markers.PaintBall.Size.x, Config.Markers.PaintBall.Size.y,
                    Config.Markers.PaintBall.Size.z, Config.Markers.PaintBall.Color.r,
                    Config.Markers.PaintBall.Color.g, Config.Markers.PaintBall.Color.b, 100, false, true, 2, false,
                    false, false, false)
					DrawText3D(playercoord.x, playercoord.y, playercoord.z+0.0, Config.Langs.OpenMenu)
                    if IsControlJustReleased(0,38) then
                        OpenMenu()
                    end
                end
            end
		Citizen.Wait(sleep)
	end
end)

CreateThread(function()
    if Config.Blips.Blips then
        for k, v in pairs(Config.PaintballArea) do
            blip = AddBlipForCoord(v.AreaCoord.x, v.AreaCoord.y, v.AreaCoord.z)
            SetBlipSprite(blip, Config.Blips.PaintBall.Sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, Config.Blips.PaintBall.Scale)
            SetBlipColour(blip, Config.Blips.PaintBall.Colour)
            SetBlipAsShortRange(blip, true)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(Config.Langs.BlipName)
            EndTextCommandSetBlipName(blip)
            table.insert(blipx, blip)
        end
    end
end)

function OpenMenu()
    if playingPaintball == false then
        Status = "playerx"
        SetNuiFocus(1, 1)
        TriggerServerEvent("BakiTelli_Paintball:getData")
        SendNUIMessage({
            action = "OpenPaintBall"
        })
    end
end

function RandomName()
    local code = Config.Namep.."#"
    for i = 1, Config.NameNumber do
      code = code .. tostring(math.random(0, 9))
    end
  return code
end

function addLobby()
    TotalLobbys = 0
    for k, v in pairs(Lobbys) do
        decode = json.decode(v)
        TotalLobbys = TotalLobbys + 1 
        SendNUIMessage({
            action = "loadLobby",
            password = decode.password,
            name = decode.name,
            password_no = decode.password_no,
            mapid = Config.Maps[decode.mapid].MapName,
            time = decode.time,
            TotalLobbys = TotalLobbys,
            totallobby = decode.all,
        })
    end
end

function CreateLobby(p)
    if p == nil then 
        TriggerServerEvent("BakiTelli_Paintball:NewLobby", p, false, LobbyName, mapid, time)
    else 
        TriggerServerEvent("BakiTelli_Paintball:NewLobby", p, true, LobbyName, mapid, time)
    end
    mapUpdate()
    TimeUpdate()
    TriggerServerEvent("BakiTelli_Paintball:checkTeam", LobbyName, "red", 1)
    Status = "owner"
    checkPermission()
end

function totalMap()
    totalMapx = 0
    for k, v in pairs(Config.Maps) do
        totalMapx = totalMapx + 1
    end
end

function LoginTeam(team, num)
    TriggerServerEvent("BakiTelli_Paintball:checkTeam",LobbyName, team, num)
end

function playersUpdate()
    local decodedData = json.decode(Lobbys[LobbysIdx])
    local players = decodedData.players
    SendNUIMessage({
        action = "update-teamp",
        red = decodedData.red,
        blue = decodedData.blue, 
    })
    for team, teamData in pairs(players) do
        for num, value in pairs(teamData) do
            if decodedData.players[team][num] == 9999 then else 
                TriggerServerEvent("BakiTelli_Paintball:getProfile", decodedData.players[team][num], team, num)
            end
        end
    end
end

function mapUpdate()
    SendNUIMessage({
        action = "mapupdate",
        name = LobbyName,
        LobbyName = Config.Maps[mapid].MapName,
        LobbyImg = Config.Maps[mapid].map_img,
        LobbyInformation = Config.Maps[mapid].information,
    })
end

function TimeUpdate()
    SendNUIMessage({
        action = "timeupdate",
        time = tonumber(time),
    })
end

function checkPermission()
    if Status == "owner" then
        SendNUIMessage({
            action = "perm",
            tx = "owner"
        })
    else 
        SendNUIMessage({
            action = "perm",
            tx = "player"
        })
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

RegisterNUICallback("close", function (data)
    SetNuiFocus(0, 0)
        if Status == "owner" and playingPaintball == false then
            Status = "playerx"
            TriggerServerEvent("BakiTelli_Paintball:KickAllLobby", LobbyName, true)
        elseif Status == "player" and playingPaintball == false then
            Status = "playerx"
            TriggerServerEvent("BakiTelli_Paintball:exitLobby", LobbyName)
        end
        time = 25 
        mapid = 1
end)

RegisterNUICallback("nui", function ()
    SetNuiFocus(1, 1)
end)

RegisterNUICallback("addname", function()
    if not isCooldownActive then
        isCooldownActive = true
        LobbyName = RandomName()
        SendNUIMessage({
            action = "update-name",
            name = LobbyName
        })
        Citizen.SetTimeout(Config.LobbyCoolDown, function()
            isCooldownActive = false
        end)
    else
        SendNUIMessage({
            action = "closeAllMenu",
        })
        notify(Config.Langs.LobbyCoolDown)
    end
end)

RegisterNUICallback("LoginLobby", function (data)
    LobbyName = data.name
    TriggerServerEvent("BakiTelli_Paintball:LoginLobby", data.name)
end)

RegisterNUICallback("NewLobby", function (data)
    SendNUIMessage({
        action = "timer"
    })    
    if data.password then 
            Password = tonumber(data.password)
            CreateLobby(Password)
        else
            CreateLobby("NoPassword") 
    end
end)

RegisterNUICallback("Previous", function ()
    if Status == "owner" then
        SendNUIMessage({
            action = "timer"
        })
        if 1 == mapid then
            mapid = totalMapx
        else 
            mapid = mapid-1
        end
        TriggerServerEvent("BakiTelli_Paintball:MapUpdate", tonumber(mapid), LobbyName)
    end
end)

RegisterNUICallback("Next", function ()
    if Status == "owner" then
        SendNUIMessage({
            action = "timer"
        })
        if totalMapx == mapid then
            mapid = 1
        else 
            mapid = mapid+1
        end
        TriggerServerEvent("BakiTelli_Paintball:MapUpdate", tonumber(mapid), LobbyName)
    end
end)

RegisterNUICallback("showLobby", function (data)
    n = data.name
    ix = getLobbyId(n) 
    decodedData = json.decode(Lobbys[ix])
    mname = Config.Maps[tonumber(decodedData.mapid)].MapName
    minfo = Config.Maps[tonumber(decodedData.mapid)].information
    mimg = Config.Maps[tonumber(decodedData.mapid)].map_img
    mn = decodedData.name
    time = tonumber(decodedData.time)
    TimeUpdate()
    SendNUIMessage({
        action = "mapupdate",
        LobbyName = mname,
        name = mn, 
        LobbyInformation = minfo, 
        LobbyImg = mimg,
    })
end)

RegisterNUICallback("LoginTeam", function (data)
    SendNUIMessage({
        action = "timer"
    })
    team = data.team 
    num = tonumber(data.num)
    LoginTeam(team,num)
end)

RegisterNUICallback("Time", function (data)
    timre = tonumber(data.time)
    if Status == "owner" then 
        TriggerServerEvent("BakiTelli_Paintball:TimeEdit",timre, LobbyName)
    end
end)

RegisterNUICallback("Disband", function ()
    if Status == "owner" then 
        TriggerServerEvent("BakiTelli_Paintball:KickAllLobby", LobbyName, true)
    end
end)

RegisterNUICallback("Start", function ()
    if Status == "owner" then 
        TriggerServerEvent("BakiTelli_Paintball:StartGame", LobbyName)
    end
end)


RegisterNUICallback("checkPassword", function (data)
    pw = tonumber(data.password)
    TriggerServerEvent("BakiTelli_Paintball:checkPassword", pw , LobbyName)
end)

AddEventHandler("BakiTelli_Paintball:cl:getData")
RegisterNetEvent("BakiTelli_Paintball:cl:getData", function (l_lobbys)
    Lobbys = l_lobbys
    addLobby()
end)

AddEventHandler("BakiTelli_Paintball:cl:UpdatePlayer")
RegisterNetEvent("BakiTelli_Paintball:cl:UpdatePlayer", function (l_lobbys)
    Lobbys = l_lobbys
    addLobby()
end)

AddEventHandler("BakiTelli_Paintball:cl:enterPw")
RegisterNetEvent("BakiTelli_Paintball:cl:enterPw", function (lgn, tm)
    if lgn then 
        Status = "player"
        SendNUIMessage({
            action = "closeAllMenu"
        })
        Citizen.Wait(350)
        TriggerServerEvent("BakiTelli_Paintball:getPlayers", LobbyName)
          SendNUIMessage({
            action = "get-px",
          })
          time = tm
          TimeUpdate()
          checkPermission()
    else
        SendNUIMessage({
            action = "closeAllMenu"
        })
    end
end)

AddEventHandler("BakiTelli_Paintball:TimeStart")
RegisterNetEvent("BakiTelli_Paintball:TimeStart", function (lgn, tm,feture)
    playingPaintball = true
    timeri = tonumber(lgn)
    lobbyid = getLobbyId(tm) 
    local decodedData = json.decode(Lobbys[lobbyid])
    decodedData.starttime = feture
    Lobbys[lobbyid] = json.encode(decodedData)
end)

AddEventHandler("BakiTelli_Paintball:cl:UpdatePlayers")
RegisterNetEvent("BakiTelli_Paintball:cl:UpdatePlayers", function (lb, k)
        SendNUIMessage({
            action = "playersDefault",
            typ = "reset",
        })
        Citizen.Wait(250)
        Lobbys = lb 
        LobbysIdx = tonumber(k)
        playersUpdate()
end)

AddEventHandler("BakiTelli_Paintball:cl:closeMenu")
RegisterNetEvent("BakiTelli_Paintball:cl:closeMenu", function (lb)
    playingPaintball = false
    if lb then 
        SendNUIMessage({
            action = "closeAllMenu",
        })
        Status = "playerx"
    end
end)

AddEventHandler("BakiTelli_Paintball:cl:UpdateMap")
RegisterNetEvent("BakiTelli_Paintball:cl:UpdateMap", function (lb, k, mid)
    Lobbys = lb 
    LobbysIdx = tonumber(k)    
    mapid = mid
    mapUpdate()
end)

AddEventHandler("BakiTelli_Paintball:cl:TimeEdit")
RegisterNetEvent("BakiTelli_Paintball:cl:TimeEdit", function (lb, k, timex)
    Lobbys = lb 
    LobbysIdx = tonumber(k)    
    time = timex
    TimeUpdate()
end)

AddEventHandler("BakiTelli_Paintball:cl:Login")
RegisterNetEvent("BakiTelli_Paintball:cl:Login", function (tm, ps)
    if ps == "password" then 
        SendNUIMessage({
            action = "update-name",
            name = LobbyName
        })
    else
        TriggerServerEvent("BakiTelli_Paintball:getPlayers", LobbyName)
        SendNUIMessage({
            action = "closeAllMenu"
        })
        Citizen.Wait(350)
        SendNUIMessage({
            action = "get-px",
          })

        Status = "player"
          time = tm
          TimeUpdate()
          checkPermission()
    end
end)

AddEventHandler("BakiTelli_Paintball:cl:getProfile")
RegisterNetEvent("BakiTelli_Paintball:cl:getProfile", function (src, name, profile, team, num)
    SendNUIMessage({
            action = "playersDefault",
            typ = "add",
            src = src, 
            name = name,
            profile = profile, 
            team = team,
            num = num
        })
end)

AddEventHandler("BakiTelli_Paintball:cl:FinishGame")
RegisterNetEvent("BakiTelli_Paintball:cl:FinishGame", function (win)
    local playerPed = PlayerPedId()
    local playerId = PlayerId()
    FreezeEntityPosition(playerPed, false)
    SetEntityAlpha(playerPed, 255, false)
    SetPlayerInvincible(playerId, false)
    SendNUIMessage({
        action = "win-lose",
        typ = win
    })
    ClearPedBloodDamage(PlayerPedId())
    DeleteWeapon()
    playingPaintball = false
    Citizen.Wait(4000)
    if Config.GameFinishRevive then 
        ReviveFunction()
    end
    SendNUIMessage({
        action = "closeAllMenu",
    })
    SetEntityCoords(PlayerPedId(), Config.PaintballArea[enterMenu].AreaCoord.x, Config.PaintballArea[enterMenu].AreaCoord.y, Config.PaintballArea[enterMenu].AreaCoord.z)
    TriggerEvent("RemoveRelationShip")

end)

AddEventHandler("BakiTelli_Paintball:cl:StartGame")
RegisterNetEvent("BakiTelli_Paintball:cl:StartGame", function (teami, slot)
    id = getLobbyId(LobbyName)
    decode = json.decode(Lobbys[id])
    mteam = teami
    TriggerEvent("AddRelationShip", mteam)
    if teami == "red" then  
        scoord = Config.Maps[decode.mapid].red[slot]
    else
        scoord = Config.Maps[decode.mapid].blue[slot]
    end
    SendNUIMessage({
        action = "closeAllMenu"
    })
    StartGame()
end)

AddEventHandler("BakiTelli_Paintball:cl:UpdateScore")
RegisterNetEvent("BakiTelli_Paintball:cl:UpdateScore", function (red, blue)
    SendNUIMessage({
        action = "score-update",
        red = blue,
        blue = red
    })
end)

function StartGame()
    local playerPed = PlayerPedId()
    local playerId = PlayerId()
    playingPaintball = true
    SetEntityCoords(playerPed, scoord.x, scoord.y, scoord.z)
    SetEntityHeading(playerPed, scoord.w)
    FreezeEntityPosition(playerPed, true)
    SetEntityAlpha(playerPed, 150, false)
    giveWeapon()
    Citizen.Wait(2500)
    SendNUIMessage({
        action = "saytime",
        time = 3
    })    
    Citizen.Wait(1500)
    SendNUIMessage({
        action = "saytime",
        time = 2
    }) 
    Citizen.Wait(1500)
    SendNUIMessage({
        action = "saytime",
        time = 1
    }) 
    Citizen.Wait(1500)
    SendNUIMessage({
        action = "saytime",
        time = 0
    }) 
    SetEntityAlpha(playerPed, 255, false)
    FreezeEntityPosition(playerPed, false)
    openScoreboard()
end

function openScoreboard()
    SendNUIMessage({
        action = "scoreboard",
        display = true,
    }) 
end

function FormatTime(seconds)
    if seconds <= 0 then
        return 0
    else
    local minutes = math.floor(seconds / 60)
    local remainingSeconds = seconds % 60 
    local formattedTime = string.format("%02d:%02d", minutes, remainingSeconds)
    return formattedTime
    end
end

function RevivePlayer()
    SendNUIMessage({
        action = "closeAllMenu",
    })   
    Citizen.Wait(3000)
    SendNUIMessage({
        action = "saytime",
        time = 3
    })    
    Citizen.Wait(1500)
    SendNUIMessage({
        action = "saytime",
        time = 2
    }) 
    Citizen.Wait(1500)
    SendNUIMessage({
        action = "saytime",
        time = 1
    }) 
    Citizen.Wait(1500)
    SendNUIMessage({
        action = "saytime",
        time = 0
    }) 
    openScoreboard()
    ReviveFunction()
    giveWeapon()
    playerPed = PlayerPedId()
    playerId = PlayerId()
    SetEntityCoords(playerPed, scoord.x, scoord.y, scoord.z)
    SetEntityHeading(playerPed, scoord.w)
    SetEntityAlpha(playerPed, 150, false)
    SetPlayerInvincible(playerId, true)
    Citizen.Wait(3500)
    SetEntityAlpha(playerPed, 255, false)
    SetPlayerInvincible(playerId, false)
end

Citizen.CreateThread(function()
	while true do
        sleep = 750
		if  playingPaintball then
            sleep = 10
            SetPedInfiniteAmmo(PlayerPedId(), true, GetHashKey(Config.Weapon))
            if GetSelectedPedWeapon(PlayerPedId()) ~= GetHashKey(Config.Weapon) then
                SetCurrentPedWeapon(PlayerPedId(), GetHashKey(Config.Weapon ), true)
            end
            if IsPedArmed(PlayerPedId(), 6) then
                DisableControlAction(1, 140, true)
                DisableControlAction(1, 141, true)
                DisableControlAction(1, 142, true)
            end
        end
			Citizen.Wait(sleep)
	end
end)

Citizen.CreateThread(function()
	local DeathReason, Killer, DeathCauseHash, Weapon

	while true do
		Citizen.Wait(0)
		if IsEntityDead(PlayerPedId()) and playingPaintball then
			Citizen.Wait(500)
			local PedKiller = GetPedSourceOfDeath(PlayerPedId())
			DeathCauseHash = GetPedCauseOfDeath(PlayerPedId())

			if IsEntityAPed(PedKiller) and IsPedAPlayer(PedKiller) then
				Killer = NetworkGetPlayerIndexFromPed(PedKiller)
			elseif IsEntityAVehicle(PedKiller) and IsEntityAPed(GetPedInVehicleSeat(PedKiller, -1)) and IsPedAPlayer(GetPedInVehicleSeat(PedKiller, -1)) then
				Killer = NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(PedKiller, -1))
			end
			
			if (Killer == PlayerId()) then
				DeathReason = 'committed suicide'
			elseif (Killer == nil) then
				DeathReason = 'died'
			else
				DeathReason = "weapon_kill"
			end
            RevivePlayer()
			if DeathReason == 'weapon_kill'then
                TriggerServerEvent('BakiTelli_Paintball:killplayer',LobbyName, mteam)
            end
			Killer = nil
			DeathReason = nil
			Weapon = nil
        end
		while IsEntityDead(PlayerPedId()) do
			Citizen.Wait(0)
		end
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        if playingPaintball then
            if timeri <= 7 and timeri >= 0 then
                timeri = timeri - 1
                SendNUIMessage({
                    action = "time-update",
                    timeri = FormatTime(timeri - 7)
                })
                local playerPed = PlayerPedId()
                local playerId = PlayerId()
                DeleteWeapon()
                FreezeEntityPosition(playerPed, true)
                SetEntityAlpha(playerPed, 150, false)
                SetPlayerInvincible(playerId, true)
            elseif timeri >= 0 then
                timeri = timeri - 1
                SendNUIMessage({
                    action = "time-update",
                    timeri = FormatTime(timeri - 7)
                })
            else
                local playerPed = PlayerPedId()
                local playerId = PlayerId()
                FreezeEntityPosition(playerPed, false)
                SetEntityAlpha(playerPed, 255, false)
                SetPlayerInvincible(playerId, false)
                TriggerServerEvent("BakiTelli_Paintball:TimeFinish", LobbyName)
            end
        end
    end
end)


RegisterNetEvent("AddRelationShip")
AddEventHandler("AddRelationShip", function(id)
    StartRelationLoop(id)
end)

RegisterNetEvent("RemoveRelationShip")
AddEventHandler("RemoveRelationShip", function()
    if DoesRelationshipGroupExist(mySquadHash) then
        SetPedRelationshipGroupHash(PlayerPedId(), 0x6F0783F5)
        SetEntityCanBeDamagedByRelationshipGroup(PlayerPedId(), true,  mySquadHash)
        RemoveRelationshipGroup(mySquadHash)
        mySquadHash = nil
    end
end)
function SetRelationDamage(id)
    if id and (mySquadHash == nil or not DoesRelationshipGroupExist(mySquadHash)) then
        local retval, hash = AddRelationshipGroup(id)
        SetPedRelationshipGroupHash(PlayerPedId(), hash)
        SetEntityCanBeDamagedByRelationshipGroup(PlayerPedId(), false,  hash)
        mySquadHash = hash
    else
        SetPedRelationshipGroupHash(PlayerPedId(), mySquadHash)
        SetEntityCanBeDamagedByRelationshipGroup(PlayerPedId(), false,  mySquadHash)
    end
    return mySquadHash
end

function StartRelationLoop(id)
    Citizen.CreateThread(function()
        local hash = SetRelationDamage(id)
        while mySquadHash ~= nil do
            Citizen.Wait(2000)
            SetRelationDamage()
        end
        if DoesRelationshipGroupExist(mySquadHash) then
            SetPedRelationshipGroupHash(PlayerPedId(), 0x6F0783F5)
            SetEntityCanBeDamagedByRelationshipGroup(PlayerPedId(), true,  mySquadHash)
            RemoveRelationshipGroup(mySquadHash)
            mySquadHash = nil
        end
    end)
end

local function inGameStatus(status)
    return playingPaintball
end

exports('inGameStatus', inGameStatus)