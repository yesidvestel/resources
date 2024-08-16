local PlayerData = {}

local disabledNotifySkillInfo = false

local _gymId = nil
local _pointId = nil
local _pointTable = nil

local myProp = nil
local myProp2 = nil

myStatistics = nil
local myStamina = nil

local playerMemberships = {}
local ownedMemberships = {}

conditionBooster = 1.0
strengthBooster = 1.0

if Config.Core == "ESX" then
    ESX = Config.CoreExport()
    
    RegisterNetEvent(Config.PlayerLoaded)
    AddEventHandler(Config.PlayerLoaded, function(xPlayer)
        PlayerData = xPlayer
    end)

    RegisterNetEvent(Config.JobUpdated)
    AddEventHandler(Config.JobUpdated, function(job)
        PlayerData.job = job 
    end)
elseif Config.Core == "QB-Core" then
    QBCore = Config.CoreExport()

    RegisterNetEvent(Config.PlayerLoaded, function()
        PlayerData = QBCore.Functions.GetPlayerData()
    end)

    RegisterNetEvent(Config.JobUpdated, function(JobInfo)
        PlayerData.job = JobInfo
    end)
end

RegisterNetEvent('vms_gym:cl:getMemberships')
AddEventHandler('vms_gym:cl:getMemberships', function(memberships)
	playerMemberships = memberships
    ownedMemberships = {}
    for k, v in pairs(playerMemberships) do
        ownedMemberships[v.name] = true
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    if Config.Core == "ESX" then
        while not ESX do
            Citizen.Wait(200)
        end
        if ESX.IsPlayerLoaded() then
            PlayerData = ESX.GetPlayerData()
            TriggerServerEvent('vms_gym:sv:restartPlayer')
        end
    elseif Config.Core == "QB-Core" then
        while not QBCore do
            Citizen.Wait(200)
        end
        if QBCore.Functions.GetPlayerData() then
            PlayerData = QBCore.Functions.GetPlayerData()
            TriggerServerEvent('vms_gym:sv:restartPlayer')
        end
    end
end)

function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

function requestProp(prop)
    RequestModel(prop)
    while not HasModelLoaded(prop) do
        Citizen.Wait(100)
        RequestModel(prop)
    end
end

Citizen.CreateThread(function()
    for k, v in pairs(Config.Gyms) do
        if v.blipCoords then
            v._createdBlip = AddBlipForCoord(v.blipCoords)
            SetBlipSprite(v._createdBlip, Config.Blip['Sprite'])
            SetBlipDisplay(v._createdBlip, Config.Blip['Display'])
            SetBlipScale(v._createdBlip, Config.Blip['Scale'])
            SetBlipColour(v._createdBlip, Config.Blip['Color'])
            SetBlipAsShortRange(v._createdBlip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.blipName)
            EndTextCommandSetBlipName(v._createdBlip)
        end
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(250)
    if Config.UseTarget and Config.TargetResource == "ox_target" or Config.Menu == "ox_lib" then
        local import = LoadResourceFile('ox_lib', 'init.lua')
        local chunk = assert(load(import, '@@ox_lib/init.lua'))
        chunk()
    end
    if Config.UseTarget then
        for k, v in pairs(Config.Gyms) do
            for _k, _v in pairs(v.points) do
                Config.Target(_v, function()
                    startAction(k, _k, _v)
                end)
            end
        end
    end
end)

Citizen.CreateThread(function()
    local inRange = false
    local shown = false
    local sleep = true
    while not Config.UseTarget do
        inRange = false
        sleep = true
        local myPed = PlayerPedId()
        local myCoords = GetEntityCoords(myPed)
        for k, v in pairs(Config.Gyms) do
            local distance = #(myCoords - v.blipCoords)
            if distance < 45.0 then
                sleep = false
                for _k, _v in pairs(v.points) do
                    if not _v.taken then
                        local _distance = #(myCoords - vec(_v.position.x, _v.position.y, _v.position.z))
                        if _distance < Config.DistanceView then
                            if Config.UseMarkers then
                                DrawMarker(Config.Markers['FreeSeat'].id, vec(_v.position.x, _v.position.y, _v.position.z), 0, 0, 0, Config.Markers['FreeSeat'].rotation[1], Config.Markers['FreeSeat'].rotation[2], Config.Markers['FreeSeat'].rotation[3], Config.Markers['FreeSeat'].size, Config.Markers['FreeSeat'].color[1], Config.Markers['FreeSeat'].color[2], Config.Markers['FreeSeat'].color[3], Config.Markers['FreeSeat'].color[4], Config.Markers['FreeSeat'].bobUpAndDown, false, false, Config.Markers['FreeSeat'].rotate, false, false, false)
                            end
                            if Config.Use3DText then
                                DrawText3D(_v.position.x, _v.position.y, _v.position.z, Config.Translate[Config.Language]['action.'.._v.name])
                            end
                            if _distance < 1.25 then
                                inRange = Config.Translate[Config.Language]['action.'.._v.name]
                                if Config.Core == "ESX" and not Config.TextUI.Enabled and Config.UseHelpNotify then
                                    ESX.ShowHelpNotification(inRange)
                                end
                                if IsControlJustPressed(0, Config.Keys['enter']) then
                                    startAction(k, _k, _v)
                                    inRange = false
                                end
                            end
                        end
                    end
                end
            end
        end
        if Config.TextUI.Enabled then
            if inRange and not shown then
                shown = true
                Config.TextUI.Open(inRange)
            elseif not inRange and shown then
                shown = false
                Config.TextUI.Close()
            end
        end
        Citizen.Wait(sleep and 2000 or 1)
    end
end)

Citizen.CreateThread(function()
    local inRange = false
    local shown = false
    while true do
        inRange = false
        local myPed = PlayerPedId()
        local myCoords = GetEntityCoords(myPed)
        local sleep = 2000
        for k, v in pairs(Config.Gyms) do
            if v.jobMenuPos and v.requiredMembership then
                local distance = #(myCoords - v.jobMenuPos)
                if v.ownerJob and (PlayerData and PlayerData.job and PlayerData.job.name == v.ownerJob) then
                    if v.bossMenuGrades then
                        v.hasAccessToBoss = false
                        if type(v.bossMenuGrades) == "table" then
                            for gradeK, gradeV in ipairs(v.bossMenuGrades) do
                                if Config.Core == "ESX" and (PlayerData.job.grade_name == gradeV) or Config.Core == "QB-Core" and (PlayerData.job.grade.name == gradeV) then
                                    v.hasAccessToBoss = true
                                end
                            end
                        else
                            if Config.Core == "ESX" and (PlayerData.job.grade_name == v.bossMenuGrades) or Config.Core == "QB-Core" and (PlayerData.job.grade.name == v.bossMenuGrades) then
                                v.hasAccessToBoss = true
                            end
                        end
                    end
                    if v.menuGrades then
                        v.hasAccessToMemberships = false
                        if type(v.menuGrades) == "table" then
                            for gradeK, gradeV in ipairs(v.menuGrades) do
                                if Config.Core == "ESX" and (PlayerData.job.grade_name == gradeV) or Config.Core == "QB-Core" and (PlayerData.job.grade.name == gradeV) then
                                    v.hasAccessToMemberships = true
                                end
                            end
                        else
                            if Config.Core == "ESX" and (PlayerData.job.grade_name == v.menuGrades) or Config.Core == "QB-Core" and (PlayerData.job.grade.name == v.menuGrades) then
                                v.hasAccessToMemberships = true
                            end
                        end
                    else
                        v.hasAccessToMemberships = true
                    end
                elseif not v.ownerJob then
                    v.hasAccessToBuyMemberships = true
                end
                if (v.hasAccessToBoss or v.hasAccessToMemberships) and distance < Config.DistanceView then
                    sleep = 1
                    if PlayerData and PlayerData.job and PlayerData.job.name == v.ownerJob then
                        if Config.UseMarkers then
                            DrawMarker(Config.Markers['BossMenu'].id, v.jobMenuPos.x, v.jobMenuPos.y, v.jobMenuPos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Markers['BossMenu'].size, Config.Markers['BossMenu'].color[1], Config.Markers['BossMenu'].color[2], Config.Markers['BossMenu'].color[3], Config.Markers['BossMenu'].color[4], Config.Markers['BossMenu'].bobUpAndDown, false, false, Config.Markers['BossMenu'].rotate, false, false, false)
                        end
                        if Config.Use3DText then
                            DrawText3D(v.jobMenuPos.x, v.jobMenuPos.y, v.jobMenuPos.z, Config.Translate[Config.Language]["action.open_jobmenu"])
                        end
                        if distance < Config.DistanceAccess then
                            if v.business then
                                if Config.TextUI.Enabled then
                                    inRange = Config.Translate[Config.Language]["action.open_jobmenu"]
                                else
                                    if Config.Core == "ESX" and not Config.TextUI.Enabled and Config.UseHelpNotify then
                                        ESX.ShowHelpNotification(Config.Translate[Config.Language]["action.open_jobmenu"])
                                    end
                                end
                                if IsControlJustPressed(0, 38) then
                                    if Config.EnableGiveMembership then
                                        if v.requiredMembership and v.hasAccessToMemberships then
                                            if not v.menuGrades then
                                                openJobMenu(v, v.hasAccessToMemberships, v.hasAccessToBoss)
                                            elseif v.menuGrades and type(v.menuGrades) == "table" then
                                                for _gradeK, _gradeV in ipairs(v.menuGrades) do
                                                    if Config.Core == "ESX" and (PlayerData.job.grade_name == _gradeV) or Config.Core == "QB-Core" and (PlayerData.job.grade.name == _gradeV) then
                                                        openJobMenu(v, v.hasAccessToMemberships, v.hasAccessToBoss)
                                                    end
                                                end
                                            else
                                                if Config.Core == "ESX" and (PlayerData.job.grade_name == v.menuGrades) or Config.Core == "QB-Core" and (PlayerData.job.grade.name == v.menuGrades) then
                                                    openJobMenu(v, v.hasAccessToMemberships, v.hasAccessToBoss)
                                                end
                                            end
                                        elseif v.hasAccessToBoss then
                                            Config.BossMenu(PlayerData.job.name)
                                        end
                                    elseif v.hasAccessToBoss then
                                        Config.BossMenu(PlayerData.job.name)
                                    end
                                end
                            end
                        end
                    end
                end
                if v.hasAccessToBuyMemberships and distance < Config.DistanceView then
                    sleep = 1
                    if Config.UseMarkers then
                        DrawMarker(Config.Markers['BossMenu'].id, v.jobMenuPos.x, v.jobMenuPos.y, v.jobMenuPos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Markers['BossMenu'].size, Config.Markers['BossMenu'].color[1], Config.Markers['BossMenu'].color[2], Config.Markers['BossMenu'].color[3], Config.Markers['BossMenu'].color[4], Config.Markers['BossMenu'].bobUpAndDown, false, false, Config.Markers['BossMenu'].rotate, false, false, false)
                    end
                    if Config.Use3DText then
                        DrawText3D(v.jobMenuPos.x, v.jobMenuPos.y, v.jobMenuPos.z, Config.Translate[Config.Language]["action.open_buymembership"])
                    end
                    if distance < Config.DistanceAccess then
                        if Config.TextUI.Enabled then
                            inRange = Config.Translate[Config.Language]["action.open_buymembership"]
                        else
                            if Config.Core == "ESX" and not Config.TextUI.Enabled and Config.UseHelpNotify then
                                ESX.ShowHelpNotification(Config.Translate[Config.Language]["action.open_buymembership"])
                            end
                        end
                        if IsControlJustPressed(0, 38) then
                            openBuyMembership(v)
                        end
                    end
                end
            end
        end
        if Config.TextUI.Enabled then
            if inRange and not shown then
                shown = true
                Config.TextUI.Open(inRange)
            elseif not inRange and shown then
                shown = false
                Config.TextUI.Close()
            end
        end
        Citizen.Wait(sleep)
    end
end)

openBuyMembership = function(gymTable)
    local _gymTable = gymTable
    if Config.Menu == 'esx_menu_default' then
        local elements3 = {}
        for k, v in pairs(_gymTable.memberships) do
            elements3[#elements3 + 1] = {label = Config.Translate[Config.Language]['menu.element.membership']:format(v.days, v.price), days = v.days, price = v.price}
        end
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'select_membership', {
            title = Config.Translate[Config.Language]['menu.title.select_membership_time'], 
            elements = elements3, 
            align = Config.ESXMenuDefault_Align
        }, function(data3, menu3)
            if data3.current.days then
                TriggerServerEvent('vms_gym:sv:acceptMembership', nil, _gymTable.requiredMembership, data3.current.days, data3.current.price)
                menu3.close()
            end
        end, function(data3, menu3)
            menu3.close()
        end)
    elseif Config.Menu == 'esx_context' then
        local elements3 = {
            {unselectable = true, title = Config.Translate[Config.Language]['menu.title.select_membership_time']}
        }
        for k, v in pairs(_gymTable.memberships) do
            elements3[#elements3 + 1] = {title = Config.Translate[Config.Language]['menu.element.membership']:format(v.days, v.price), days = v.days, price = v.price}
        end
        ESX.OpenContext(Config.ESXContext_Align, elements3, function(menu, element)
            if element.days then
                ESX.CloseContext()
                TriggerServerEvent('vms_gym:sv:acceptMembership', nil, _gymTable.requiredMembership, element.days, element.price)
            end
        end, function(menu)

        end)
    elseif Config.Menu == 'qb-menu' then
        local elements3 = {
            {header = Config.Translate[Config.Language]['menu.title.select_membership_time'], isMenuHeader = true},
        }
        for _k, _v in pairs(_gymTable.memberships) do
            elements3[#elements3 + 1] = {
                header = Config.Translate[Config.Language]['menu.element.membership']:format(_v.days, _v.price), 
                params = {
                    isAction = true,
                    event = function()
                        TriggerServerEvent('vms_gym:sv:acceptMembership', nil, _gymTable.requiredMembership, _v.days, _v.price)
                    end
                }
            }
        end
        exports['qb-menu']:openMenu(elements3)
    elseif Config.Menu == 'ox_lib' then
        local elements3 = {}
        for _k, _v in pairs(_gymTable.memberships) do
            elements3[#elements3 + 1] = {
                title = Config.Translate[Config.Language]['menu.element.membership']:format(_v.days, _v.price), 
                onSelect = function()
                    TriggerServerEvent('vms_gym:sv:acceptMembership', nil, _gymTable.requiredMembership, _v.days, _v.price)
                end
            }
        end
        lib.registerContext({
            id = "vms_gym-select_membership_time",
            title = Config.Translate[Config.Language]['menu.title.select_membership_time'],
            options = elements3
        })
        lib.showContext('vms_gym-select_membership_time')
    end
end

openJobMenu = function(gymTable, accessToGiveMembership, accessToBossMenu)
    local _gymTable = gymTable
    if Config.Menu == 'esx_menu_default' then
        local elements = {}
        if accessToGiveMembership then
            elements[#elements + 1] = {label = Config.Translate[Config.Language]['menu.element.grant_membership'], value = 'grant_membership'}
        end
        if accessToBossMenu then
            elements[#elements + 1] = {label = Config.Translate[Config.Language]['menu.element.boss_menu'], value = 'boss_menu'}
        end
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'job_menu', {
            title = Config.Translate[Config.Language]['menu.title.job_menu'], 
            elements = elements, 
            align = Config.ESXMenuDefault_Align
        }, function(data, menu)
            if data.current.value == 'grant_membership' then
                local elements2 = {}
                local playersIsAround = false
                local playerInArea = Config.GetClosestPlayersFunction()
                for k, v in pairs(playerInArea) do
                    if v then
                        elements2[#elements2 + 1] = {label = Config.Translate[Config.Language]['menu.element.grant_membership_to_player']:format(GetPlayerServerId(v)), playerid = GetPlayerServerId(v)}
                        playersIsAround = true
                    end
                end
                if playersIsAround then
                    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'select_player', {
                        title = Config.Translate[Config.Language]['menu.title.select_player'], 
                        elements = elements2,
                        align = Config.ESXMenuDefault_Align
                    }, function(data2, menu2)
                        if data2.current.playerid then
                            local playerId = data2.current.playerid
                            local elements3 = {}
                            for k, v in pairs(_gymTable.memberships) do
                                elements3[#elements3 + 1] = {label = Config.Translate[Config.Language]['menu.element.membership']:format(v.days, v.price), days = v.days, price = v.price}
                            end
                            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'select_membership', {
                                title = Config.Translate[Config.Language]['menu.title.select_membership_time'], 
                                elements = elements3, 
                                align = Config.ESXMenuDefault_Align
                            }, function(data3, menu3)
                                if data3.current.days then
                                    TriggerServerEvent('vms_gym:sv:sendRequestOfMembership', playerId, _gymTable.requiredMembership, data3.current.days, data3.current.price)
                                    menu3.close()
                                    isMenuOpened = false
                                end
                            end, function(data3, menu3)
                                menu3.close()
                                isMenuOpened = false
                            end)
                        end
                    end, function(data2, menu2)
                        menu2.close()
                        isMenuOpened = false
                    end)
                else
                    Config.Notification(Config.Translate[Config.Language]['notify.title.gym'], Config.Translate[Config.Language]['no_players_around'], 3500, "fa-solid fa-dumbbell", 'error')
                end
            elseif data.current.value == 'boss_menu' then
                menu.close()
                Config.BossMenu(PlayerData.job.name)
            end
        end, function(data, menu)
            isMenuOpened = false
            menu.close()
        end)
    elseif Config.Menu == 'esx_context' then
        local elements = {
            {unselectable = true, title = Config.Translate[Config.Language]['menu.title.job_menu']}
        }
        if accessToGiveMembership then
            elements[#elements + 1] = {title = Config.Translate[Config.Language]['menu.element.grant_membership'], value = 'grant_membership'}
        end
        if accessToBossMenu then
            elements[#elements + 1] = {title = Config.Translate[Config.Language]['menu.element.boss_menu'], value = 'boss_menu'}
        end
        ESX.OpenContext(Config.ESXContext_Align, elements, function(menu, element)
            if element.value == 'grant_membership' then
                ESX.CloseContext()
                local elements2 = {
                    {unselectable = true, title = Config.Translate[Config.Language]['menu.title.select_player']}
                }
                local playersIsAround = false
                local playerInArea = Config.GetClosestPlayersFunction()
                for k, v in pairs(playerInArea) do
                    if v then
                        elements2[#elements2 + 1] = {title = Config.Translate[Config.Language]['menu.element.grant_membership_to_player']:format(GetPlayerServerId(v)), playerid = GetPlayerServerId(v)}
                        playersIsAround = true
                    end
                end
                if playersIsAround then
                    ESX.OpenContext(Config.ESXContext_Align, elements2, function(menu, element)
                        local playerId = element.playerid
                        local elements3 = {
                            {unselectable = true, title = Config.Translate[Config.Language]['menu.title.select_membership_time']}
                        }
                        for k, v in pairs(_gymTable.memberships) do
                            elements3[#elements3 + 1] = {title = Config.Translate[Config.Language]['menu.element.membership']:format(v.days, v.price), days = v.days, price = v.price}
                        end
                        ESX.OpenContext(Config.ESXContext_Align, elements3, function(menu, element)
                            if element.days then
                                ESX.CloseContext()
                                TriggerServerEvent('vms_gym:sv:sendRequestOfMembership', playerId, _gymTable.requiredMembership, element.days, element.price)
                                isMenuOpened = false
                            end
                        end, function(menu)
                            isMenuOpened = false
                        end)
                    end, function(menu)
                        isMenuOpened = false
                    end)
                else
                    Config.Notification(Config.Translate[Config.Language]['notify.title.gym'], Config.Translate[Config.Language]['no_players_around'], 3500, "fa-solid fa-dumbbell", 'error')
                end
            elseif element.value == 'boss_menu' then
                ESX.CloseContext()
                Config.BossMenu(PlayerData.job.name)
            end
        end, function(menu)
            isMenuOpened = false
        end)
    elseif Config.Menu == 'qb-menu' then
        local elements = {
            {header = Config.Translate[Config.Language]['menu.title.job_menu'], isMenuHeader = true},
        }
        if accessToGiveMembership then
            elements[#elements + 1] = {
                header = Config.Translate[Config.Language]['menu.element.grant_membership'], 
                params = {
                    isAction = true,
                    event = function()
                        local elements2 = {
                            {header = Config.Translate[Config.Language]['menu.title.select_player'], isMenuHeader = true},
                        }
                        local playersIsAround = false
                        local playerInArea = Config.GetClosestPlayersFunction()
                        for k, v in pairs(playerInArea) do
                            if v then
                                elements2[#elements2 + 1] = {
                                    header = Config.Translate[Config.Language]['menu.element.grant_membership_to_player']:format(GetPlayerServerId(v)), 
                                    params = {
                                        isAction = true,
                                        event = function()
                                            local elements3 = {
                                                {header = Config.Translate[Config.Language]['menu.title.select_membership_time'], isMenuHeader = true},
                                            }
                                            for _k, _v in pairs(_gymTable.memberships) do
                                                elements3[#elements3 + 1] = {
                                                    title = Config.Translate[Config.Language]['menu.element.membership']:format(_v.days, _v.price), 
                                                    params = {
                                                        isAction = true,
                                                        event = function()
                                                            TriggerServerEvent('vms_gym:sv:sendRequestOfMembership', GetPlayerServerId(v), _gymTable.requiredMembership, _v.days, _v.price)
                                                        end
                                                    }
                                                }
                                            end
                                            exports['qb-menu']:openMenu(elements3)
                                        end
                                    }
                                }
                                playersIsAround = true
                            end
                        end
                        if playersIsAround then
                            exports['qb-menu']:openMenu(elements2)
                        else
                            Config.Notification(Config.Translate[Config.Language]['notify.title.gym'], Config.Translate[Config.Language]['no_players_around'], 3500, "fa-solid fa-dumbbell", 'error')
                        end
                    end,
                }
            }
        end
        if accessToBossMenu then
            elements[#elements + 1] = {
                header = Config.Translate[Config.Language]['menu.element.boss_menu'], 
                params = {
                    isAction = true,
                    event = function()
                        Config.BossMenu(PlayerData.job.name)
                    end
                }
            }
        end
        exports['qb-menu']:openMenu(elements)
    elseif Config.Menu == 'ox_lib' then
        local elements = {}
        if accessToGiveMembership then
            elements[#elements + 1] = {
                title = Config.Translate[Config.Language]['menu.element.grant_membership'], 
                onSelect = function()
                    local elements2 = {}
                    local playersIsAround = false
                    local playerInArea = Config.GetClosestPlayersFunction()
                    for k, v in pairs(playerInArea) do
                        if v then
                            elements2[#elements2 + 1] = {
                                title = Config.Translate[Config.Language]['menu.element.grant_membership_to_player']:format(GetPlayerServerId(v)), 
                                onSelect = function()
                                    local elements3 = {}
                                    for _k, _v in pairs(_gymTable.memberships) do
                                        elements3[#elements3 + 1] = {
                                            title = Config.Translate[Config.Language]['menu.element.membership']:format(_v.days, _v.price), 
                                            onSelect = function()
                                                TriggerServerEvent('vms_gym:sv:sendRequestOfMembership', GetPlayerServerId(v), _gymTable.requiredMembership, _v.days, _v.price)
                                            end
                                        }
                                    end
                                    lib.registerContext({
                                        id = "vms_gym-select_membership_time",
                                        title = Config.Translate[Config.Language]['menu.title.select_membership_time'],
                                        options = elements3
                                    })
                                    lib.showContext('vms_gym-select_membership_time')
                                end
                            }
                            playersIsAround = true
                        end
                    end
                    if playersIsAround then
                        lib.registerContext({
                            id = "vms_gym-select_player",
                            title = Config.Translate[Config.Language]['menu.title.select_player'],
                            options = elements2
                        })
                        lib.showContext('vms_gym-select_player')
                    else
                        Config.Notification(Config.Translate[Config.Language]['notify.title.gym'], Config.Translate[Config.Language]['no_players_around'], 3500, "fa-solid fa-dumbbell", 'error')
                    end
                end
            }
        end
        if accessToBossMenu then
            elements[#elements + 1] = {
                title = Config.Translate[Config.Language]['menu.element.boss_menu'], 
                onSelect = function()
                    Config.BossMenu(PlayerData.job.name)
                end
            }
        end
        lib.registerContext({
            id = "vms_gym-job_menu",
            title = Config.Translate[Config.Language]['menu.title.job_menu'],
            options = elements
        })
        lib.showContext('vms_gym-job_menu')
    end
end

startAction = function(gymId, pointId, pointTable)
    _gymId = gymId
    _pointId = pointId
    _pointTable = pointTable
    if Config.Gyms[_gymId].requiredMembership and not ownedMemberships[Config.Gyms[_gymId].requiredMembership] then
        if Config.AutoMembershipForEmployees and PlayerData.job.name == Config.Gyms[_gymId].ownerJob then
            goto jobAccess
        else
            return Config.Notification(Config.Translate[Config.Language]['notify.title.gym'], Config.Translate[Config.Language]['no_membership'], 3500, "fa-solid fa-dumbbell", 'error')
        end
    end
    ::jobAccess::
    if pointTable.taken then
        return Config.Notification(Config.Translate[Config.Language]['notify.title.gym'], Config.Translate[Config.Language]['place_taken'], 3500, "fa-solid fa-dumbbell", 'error')
    end
    if pointTable.activityCoord.w then
        SetEntityHeading(PlayerPedId(), _pointTable.activityCoord.w)
    end
    if pointTable.activityCoord.x and pointTable.activityCoord.y and pointTable.activityCoord.z then
        SetEntityCoords(PlayerPedId(), vec(pointTable.activityCoord.x, pointTable.activityCoord.y, pointTable.activityCoord.z))
    end
    FreezeEntityPosition(PlayerPedId(), true)
    SetEntityCollision(PlayerPedId(), false, false)
    for k, v in pairs(Config.Animations[pointTable.name]) do
        loadAnimDict(v[1])
    end
    TriggerServerEvent('vms_gym:sv:setTaken', _gymId, _pointId, true)
    SendNUIMessage({action = 'openHelpKeys', stamina = GetPlayerStamina(PlayerId())})
    if Config.Animations[pointTable.name].enter then
        TaskPlayAnim(PlayerPedId(), Config.Animations[pointTable.name].enter[1], Config.Animations[pointTable.name].enter[2], 8.0, -8.0, Config.Animations[pointTable.name].enter[3], 0, 0.0, 0, 0, 0)
        Citizen.Wait(Config.Animations[pointTable.name].enter[3])
    end
    Citizen.CreateThread(function()
        TaskPlayAnim(PlayerPedId(), Config.Animations[_pointTable.name].idle[1], Config.Animations[_pointTable.name].idle[2], 8.0, -8.0, Config.Animations[_pointTable.name].idle[3], 1, 0.0, 0, 0, 0)
        if _pointTable.prop then
            requestProp(GetHashKey(_pointTable.prop.name))
            local myCoords = GetEntityCoords(PlayerPedId())
            myProp = CreateObject(GetHashKey(_pointTable.prop.name), myCoords, true, true, true)
            AttachEntityToEntity(myProp, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), _pointTable.prop.attachBone), _pointTable.prop.placement[1] + 0.0, _pointTable.prop.placement[2] + 0.0, _pointTable.prop.placement[3] + 0.0, _pointTable.prop.placement[4] + 0.0, _pointTable.prop.placement[5] + 0.0, _pointTable.prop.placement[6] + 0.0, true, true, false, false, 1, true)
            SetModelAsNoLongerNeeded(myProp)
        end
        if _pointTable.prop2 then
            requestProp(GetHashKey(_pointTable.prop2.name))
            local myCoords = GetEntityCoords(PlayerPedId())
            myProp2 = CreateObject(GetHashKey(_pointTable.prop2.name), myCoords, true, true, true)
            AttachEntityToEntity(myProp2, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), _pointTable.prop2.attachBone), _pointTable.prop2.placement[1] + 0.0, _pointTable.prop2.placement[2] + 0.0, _pointTable.prop2.placement[3] + 0.0, _pointTable.prop2.placement[4] + 0.0, _pointTable.prop2.placement[5] + 0.0, _pointTable.prop2.placement[6] + 0.0, true, true, false, false, 1, true)
            SetModelAsNoLongerNeeded(myProp2)
        end
        while _pointTable do
            if IsControlJustPressed(0, Config.Keys['train']) then
                myStamina = GetPlayerStamina(PlayerId())
                local crashedSkillbar = false
                if myStamina > (getSkill('condition') >= 10.0 and ((_pointTable.removeStamina * 100) / getSkill('condition')) or getSkill('condition') < 10.0 and ((_pointTable.removeStamina*10.0))) then
                    if Config.UseSkillbar then
                        Config.Skillbar(_pointTable.name, function(isDone)
                            crashedSkillbar = false
                            if not isDone then
                                crashedSkillbar = true
                            end
                        end)
                    end
                    if not crashedSkillbar then
                        if Config.UseProgressbar then
                            Config.Progressbar(_pointTable.name, Config.Animations[_pointTable.name].training[3])
                        end
                        TaskPlayAnim(PlayerPedId(), Config.Animations[_pointTable.name].training[1], Config.Animations[_pointTable.name].training[2], 8.0, -8.0, Config.Animations[_pointTable.name].training[3], 0, 0.0, 0, 0, 0)
                        Citizen.Wait(Config.Animations[_pointTable.name].training[3])
                        TaskPlayAnim(PlayerPedId(), Config.Animations[_pointTable.name].idle[1], Config.Animations[_pointTable.name].idle[2], 8.0, -8.0, Config.Animations[_pointTable.name].idle[3], 1, 0.0, 0, 0, 0)
                        SetPlayerStamina(PlayerId(), myStamina - (getSkill('condition') >= 10.0 and ((_pointTable.removeStamina * 100) / getSkill('condition')) or getSkill('condition') < 10.0 and ((_pointTable.removeStamina*10.0))))
                        if _pointTable.addSkill and _pointTable.addSkill.skill and _pointTable.addSkill.value then
                            if type(_pointTable.addSkill.value) == 'number' then
                                addSkill(_pointTable.addSkill.skill, (_pointTable.addSkill.value/10)*strengthBooster)
                            else
                                addSkill(_pointTable.addSkill.skill, (math.random(_pointTable.addSkill.value[1], _pointTable.addSkill.value[2])/10)*strengthBooster)
                            end
                        end
                    end
                else
                    Config.Notification(Config.Translate[Config.Language]['notify.title.gym'], Config.Translate[Config.Language]['out_of_breath'], 3850, "fa-solid fa-dumbbell", 'info')
                    Citizen.Wait(1000)
                end
            end
            if IsControlJustPressed(0, Config.Keys['stop']) then
                stopAction()
            end
            Citizen.Wait(1)
        end
    end)
    Citizen.CreateThread(function()
        while _pointTable do
            SendNUIMessage({action = 'update', stamina = GetPlayerStamina(PlayerId())})
            Citizen.Wait(800)
        end
    end)
end

stopAction = function()
    if Config.Animations[_pointTable.name].exit then
        TaskPlayAnim(PlayerPedId(), Config.Animations[_pointTable.name].exit[1], Config.Animations[_pointTable.name].exit[2], 8.0, -8.0, Config.Animations[_pointTable.name].exit[3], 0, 0.0, 0, 0, 0)
        Citizen.Wait(Config.Animations[_pointTable.name].exit[3])
    else
        ClearPedTasks(PlayerPedId())
    end
    FreezeEntityPosition(PlayerPedId(), false)
    SetEntityCollision(PlayerPedId(), true, true)
    TriggerServerEvent('vms_gym:sv:setTaken', _gymId, _pointId, false)
    SendNUIMessage({action = 'closeHelpKeys'})
    if myProp then
        DeleteObject(myProp)
    end
    if myProp2 then
        DeleteObject(myProp2)
    end
    _gymId, _pointId, _pointTable = nil, nil, nil
    myProp = nil
    myProp2 = nil
end

addSkill = function(name, value)
    TriggerServerEvent('vms_gym:sv:addValue', name, value)
end

exports('addSkill', addSkill)

getSkill = function(name)
    return myStatistics[name]
end

exports('getSkill', getSkill)

removeSkill = function(name, value)
    TriggerServerEvent('vms_gym:sv:removeValue', name, value)
end

exports('removeSkill', removeSkill)

openStatisticsMenu = function()
    SetNuiFocus(true, true)
    SendNUIMessage({action = 'openMenu', stats = myStatistics})
end

RegisterNUICallback('action', function(data, cb)
    if data.action == "load" then
        SendNUIMessage({action = 'load', statisticsmenu = Config.StatisticsMenu})
    elseif data.action == "closeMenu" then
        SetNuiFocus(false, false)
        SendNUIMessage({action = 'closeMenu'})
    elseif data.action == "notifyStatus" then
        disabledNotifySkillInfo = tonumber(data.status)
    end
end)

RegisterNetEvent('vms_gym:cl:setTaken', function(gymId, pointId, boolean)
    Config.Gyms[gymId].points[pointId].taken = boolean
end)

RegisterNetEvent('vms_gym:cl:updateStatistic', function(statistics)
    myStatistics = statistics
    SendNUIMessage({action = 'updateMenu', stats = myStatistics})
end)

RegisterNetEvent('vms_gym:cl:sendRequestOfMembership', function(sellerId, membershipName, days, price)
    if Config.UseCustomQuestionMenu then
        Config.CustomQuestionMenu(sellerId, membershipName, days, price)
    else
        local _sellerId, _membershipName = sellerId, membershipName
        if Config.Menu == 'esx_menu_default' then
            local elements = {
                {label = Config.Translate[Config.Language]['menu.element.accept_membership']:format(price, days), days = days, price = price},
                {label = Config.Translate[Config.Language]['menu.element.reject_membership']}
            }
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'buy_membership', {
                title = Config.Translate[Config.Language]['menu.title.buy_membership'], 
                elements = elements, 
                align = Config.ESXMenuDefault_Align
            }, function(data, menu)
                if data.current.days then
                    TriggerServerEvent("vms_gym:sv:acceptMembership", _sellerId, _membershipName, data.current.days, data.current.price)
                    menu.close()
                else
                    TriggerServerEvent("vms_gym:sv:rejectMembership", _sellerId)
                    menu.close()
                end
            end, function(data, menu)
                TriggerServerEvent("vms_gym:sv:rejectMembership", _sellerId)
                menu.close()
            end)
        elseif Config.Menu == 'esx_context' then
            local elements = {
                {unselectable = true, title = Config.Translate[Config.Language]['menu.title.buy_membership']},
                {title = Config.Translate[Config.Language]['menu.element.accept_membership']:format(price, days), days = days, price = price},
                {title = Config.Translate[Config.Language]['menu.element.reject_membership']}
            }
            ESX.OpenContext(Config.ESXContext_Align, elements, function(menu, element)
                if element.days then
                    TriggerServerEvent("vms_gym:sv:acceptMembership", _sellerId, _membershipName, element.days, element.price)
                    ESX.CloseContext()
                else
                    TriggerServerEvent("vms_gym:sv:rejectMembership", _sellerId)
                    ESX.CloseContext()
                end
            end, function(menu)
                TriggerServerEvent("vms_gym:sv:rejectMembership", _sellerId)
            end)
        elseif Config.Menu == 'qb-menu' then
            local elements = {
                {header = Config.Translate["menu.title.buy_membership"], isMenuHeader = true},
                {
                    header = Config.Translate[Config.Language]['menu.element.accept_membership']:format(price, days),
                    params = {
                        isAction = true,
                        event = function()
                            TriggerServerEvent("vms_gym:sv:acceptMembership", _sellerId, _membershipName, days, price)
                        end,
                    }
                },
                {
                    header = Config.Translate[Config.Language]['menu.element.reject_membership'],
                    params = {
                        isAction = true,
                        event = function()
                            TriggerServerEvent("vms_gym:sv:rejectMembership", _sellerId)
                        end,
                    }
                }
            }
            exports['qb-menu']:openMenu(elements)
        elseif Config.Menu == 'ox_lib' then
            lib.registerContext({
                id = "vms_gym-buy_membership",
                title = Config.Translate["menu.title.buy_membership"],
                options = {
                    {
                        title = Config.Translate[Config.Language]['menu.element.accept_membership']:format(price, days), 
                        onSelect = function()
                            TriggerServerEvent("vms_gym:sv:acceptMembership", _sellerId, _membershipName, days, price)
                        end
                    },
                    {
                        title = Config.Translate[Config.Language]['menu.element.reject_membership'], 
                        onSelect = function()
                            TriggerServerEvent("vms_gym:sv:rejectMembership", _sellerId)
                        end
                    },
                },
                onExit = function()
                    TriggerServerEvent("vms_gym:sv:rejectMembership", _sellerId)
                end
            })
            lib.showContext('vms_gym-buy_membership')
        end
    end
end)

RegisterNetEvent('vms_gym:runConditionBooster')
AddEventHandler('vms_gym:runConditionBooster', function(multiplier, time)
    if conditionBooster == 1.0 then
        if multiplier and tonumber(multiplier) and time and tonumber(time) then
            conditionBooster = multiplier
            Citizen.CreateThread(function()
                Citizen.Wait(time)
                conditionBooster = 1.0
            end)
        end
    end
end)

RegisterNetEvent('vms_gym:runStrengthBooster')
AddEventHandler('vms_gym:runStrengthBooster', function(multiplier, time)
    if strengthBooster == 1.0 then
        if multiplier and tonumber(multiplier) and time and tonumber(time) then
            strengthBooster = multiplier
            Citizen.CreateThread(function()
                Citizen.Wait(time)
                strengthBooster = 1.0
            end)
        end
    end
end)

RegisterNetEvent('vms_gym:notification', function(title, message, time, icon, type, isSkillInfo)
    if isSkillInfo and (disabledNotifySkillInfo == 1) then
        return
    end
    Config.Notification(title, message, time, icon, type)
end)

if Config.StatisticCommand and Config.StatisticCommand ~= '' then
    RegisterCommand(Config.StatisticCommand, function()
        openStatisticsMenu()
    end)
    if Config.StatisticDescription and Config.StatisticKey and Config.StatisticKey ~= '' then
        RegisterKeyMapping(Config.StatisticCommand, Config.StatisticDescription, 'keyboard', Config.StatisticKey)
    end
end