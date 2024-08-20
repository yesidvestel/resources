local L0_1, L1_1, L2_1, L3_1, L4_1
L0_1 = {}
globalOptionsCache = L0_1
isPlayerCloseToMusic = false
disableMusic = false
function L0_1()
  local L0_2, L1_2
  L0_2 = {}
  L0_2.volume = 1.0
  L0_2.url = ""
  L0_2.id = ""
  L0_2.position = nil
  L0_2.distance = 0
  L0_2.playing = false
  L0_2.paused = false
  L0_2.loop = false
  L0_2.isDynamic = false
  L0_2.timeStamp = 0
  L0_2.maxDuration = 0
  L0_2.destroyOnFinish = true
  return L0_2
end
getDefaultInfo = L0_1
L0_1 = CreateThread
function L1_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L0_2 = Config
  L0_2 = L0_2.RefreshTime
  L1_2 = PlayerPedId
  L1_2 = L1_2()
  L2_2 = GetEntityCoords
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  L3_2 = false
  while true do
    L4_2 = Wait
    L5_2 = L0_2
    L4_2(L5_2)
    L4_2 = disableMusic
    if not L4_2 then
      L4_2 = isPlayerCloseToMusic
      if L4_2 then
        L4_2 = PlayerPedId
        L4_2 = L4_2()
        L1_2 = L4_2
        L4_2 = GetEntityCoords
        L5_2 = L1_2
        L4_2 = L4_2(L5_2)
        L2_2 = L4_2
        L4_2 = SendNUIMessage
        L5_2 = {}
        L5_2.status = "position"
        L6_2 = L2_2.x
        L5_2.x = L6_2
        L6_2 = L2_2.y
        L5_2.y = L6_2
        L6_2 = L2_2.z
        L5_2.z = L6_2
        L4_2(L5_2)
        if L3_2 then
          L4_2 = SendNUIMessage
          L5_2 = {}
          L5_2.status = "unmuteAll"
          L4_2(L5_2)
        end
        L3_2 = false
    end
    else
      if not L3_2 then
        L3_2 = true
        L4_2 = SendNUIMessage
        L5_2 = {}
        L5_2.status = "position"
        L5_2.x = -900000
        L5_2.y = -900000
        L5_2.z = -900000
        L4_2(L5_2)
      end
      L4_2 = SendNUIMessage
      L5_2 = {}
      L5_2.status = "muteAll"
      L4_2(L5_2)
      L4_2 = Wait
      L5_2 = 1000
      L4_2(L5_2)
    end
  end
end
L0_1(L1_1)
L0_1 = CreateThread
function L1_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L0_2 = PlayerPedId
  L0_2 = L0_2()
  L1_2 = GetEntityCoords
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  while true do
    L2_2 = Wait
    L3_2 = 500
    L2_2(L3_2)
    L2_2 = PlayerPedId
    L2_2 = L2_2()
    L0_2 = L2_2
    L2_2 = GetEntityCoords
    L3_2 = L0_2
    L2_2 = L2_2(L3_2)
    L1_2 = L2_2
    isPlayerCloseToMusic = false
    L2_2 = pairs
    L3_2 = soundInfo
    L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
    for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
      L8_2 = L7_2.position
      if nil ~= L8_2 then
        L8_2 = L7_2.isDynamic
        if L8_2 then
          L8_2 = L7_2.position
          L8_2 = L8_2 - L1_2
          L8_2 = #L8_2
          L9_2 = L7_2.distance
          L10_2 = Config
          L10_2 = L10_2.DistanceBeforeUpdate
          L9_2 = L9_2 + L10_2
          if L8_2 < L9_2 then
            isPlayerCloseToMusic = true
            break
          end
        end
      end
    end
  end
end
L0_1(L1_1)
L0_1 = CreateThread
function L1_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L0_2 = Wait
  L1_2 = 1100
  L0_2(L1_2)
  while true do
    L0_2 = Wait
    L1_2 = 1000
    L0_2(L1_2)
    L0_2 = pairs
    L1_2 = soundInfo
    L0_2, L1_2, L2_2, L3_2 = L0_2(L1_2)
    for L4_2, L5_2 in L0_2, L1_2, L2_2, L3_2 do
      L6_2 = L5_2.playing
      if L6_2 then
        L6_2 = getInfo
        L7_2 = L5_2.id
        L6_2 = L6_2(L7_2)
        L6_2 = L6_2.timeStamp
        if nil ~= L6_2 then
          L6_2 = getInfo
          L7_2 = L5_2.id
          L6_2 = L6_2(L7_2)
          L6_2 = L6_2.maxDuration
          if nil ~= L6_2 then
            L6_2 = getInfo
            L7_2 = L5_2.id
            L6_2 = L6_2(L7_2)
            L6_2 = L6_2.timeStamp
            L7_2 = getInfo
            L8_2 = L5_2.id
            L7_2 = L7_2(L8_2)
            L7_2 = L7_2.maxDuration
            if L6_2 < L7_2 then
              L6_2 = getInfo
              L7_2 = L5_2.id
              L6_2 = L6_2(L7_2)
              L7_2 = getInfo
              L8_2 = L5_2.id
              L7_2 = L7_2(L8_2)
              L7_2 = L7_2.timeStamp
              L7_2 = L7_2 + 1
              L6_2.timeStamp = L7_2
            end
          end
        end
      end
    end
  end
end
L0_1(L1_1)
L0_1 = {}
L1_1 = false
L2_1 = exports
L3_1 = "StartSound"
function L4_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = PlayerPedId
  L2_2 = L2_2()
  L3_2 = GetEntityCoords
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  L4_2 = GetPlayerServerId
  L5_2 = PlayerId
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L5_2()
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  L5_2 = tostring
  L6_2 = L4_2
  L5_2 = L5_2(L6_2)
  L6_2 = L1_1
  if L6_2 then
    L6_2 = TriggerServerEvent
    L7_2 = "qs-sounds:server:StopSound"
    L8_2 = L5_2
    L6_2(L7_2, L8_2)
    L6_2 = false
    L1_1 = L6_2
  end
  L6_2 = L0_1
  L6_2 = #L6_2
  if L6_2 <= 99 then
    if A1_2 then
      L6_2 = TriggerServerEvent
      L7_2 = "qs-sounds:server:StartSound"
      L8_2 = L3_2
      L9_2 = L5_2
      L10_2 = "sounds/"
      L11_2 = A0_2
      L10_2 = L10_2 .. L11_2
      L11_2 = L4_2
      L12_2 = true
      L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
    else
      L6_2 = TriggerServerEvent
      L7_2 = "qs-sounds:server:StartSound"
      L8_2 = L3_2
      L9_2 = L5_2
      L10_2 = "https://www.youtube.com/watch?v="
      L11_2 = A0_2
      L10_2 = L10_2 .. L11_2
      L11_2 = L4_2
      L12_2 = false
      L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
    end
    L6_2 = true
    L1_1 = L6_2
  end
end
L2_1(L3_1, L4_1)
L2_1 = RegisterNetEvent
L3_1 = "qs-sounds:client:StartSound"
L2_1(L3_1)
L2_1 = AddEventHandler
L3_1 = "qs-sounds:client:StartSound"
function L4_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2
  L5_2 = L0_1
  L6_2 = {}
  L5_2[A1_2] = L6_2
  L5_2 = L0_1
  L5_2 = L5_2[A1_2]
  L5_2.duraklat = false
  L5_2 = L0_1
  L5_2 = L5_2[A1_2]
  L5_2.serverId = A3_2
  L5_2 = L0_1
  L5_2 = L5_2[A1_2]
  L5_2.mp3 = A4_2
  if A4_2 then
    L5_2 = PlayUrlPos
    L6_2 = A1_2
    L7_2 = A2_2
    L8_2 = 0.1
    L9_2 = A0_2
    L5_2(L6_2, L7_2, L8_2, L9_2)
    L5_2 = setVolumeMax
    L6_2 = A1_2
    L7_2 = 0.1
    L5_2(L6_2, L7_2)
    L5_2 = Distance
    L6_2 = A1_2
    L7_2 = 10
    L5_2(L6_2, L7_2)
  else
    L5_2 = PlayUrlPos
    L6_2 = A1_2
    L7_2 = A2_2
    L8_2 = 0.15
    L9_2 = A0_2
    L5_2(L6_2, L7_2, L8_2, L9_2)
    L5_2 = setVolumeMax
    L6_2 = A1_2
    L7_2 = 0.15
    L5_2(L6_2, L7_2)
    L5_2 = Distance
    L6_2 = A1_2
    L7_2 = 15
    L5_2(L6_2, L7_2)
  end
end
L2_1(L3_1, L4_1)
L2_1 = exports
L3_1 = "StopSound"
function L4_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = L1_1
  if L1_2 then
    L1_2 = false
    L1_1 = L1_2
    L1_2 = TriggerServerEvent
    L2_2 = "qs-sounds:server:StopSound"
    L3_2 = tostring
    L4_2 = GetPlayerServerId
    L5_2 = PlayerId
    L5_2 = L5_2()
    L4_2, L5_2 = L4_2(L5_2)
    L3_2, L4_2, L5_2 = L3_2(L4_2, L5_2)
    L1_2(L2_2, L3_2, L4_2, L5_2)
  end
end
L2_1(L3_1, L4_1)
L2_1 = RegisterNetEvent
L3_1 = "qs-sounds:client:StopSound"
L2_1(L3_1)
L2_1 = AddEventHandler
L3_1 = "qs-sounds:client:StopSound"
function L4_1(A0_2)
  local L1_2, L2_2
  L1_2 = GetPlayerServerId
  L2_2 = PlayerId
  L2_2 = L2_2()
  L1_2 = L1_2(L2_2)
  if L1_2 ~= A0_2 then
    L1_2 = L0_1
    L1_2[A0_2] = nil
    L1_2 = Destroy
    L2_2 = A0_2
    L1_2(L2_2)
  end
end
L2_1(L3_1, L4_1)
L2_1 = exports
L3_1 = "PauseSound"
function L4_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = tostring
  L2_2 = GetPlayerServerId
  L3_2 = PlayerId
  L3_2, L4_2 = L3_2()
  L2_2, L3_2, L4_2 = L2_2(L3_2, L4_2)
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  L2_2 = TriggerServerEvent
  L3_2 = "qs-sounds:server:PauseSound"
  L4_2 = L1_2
  L2_2(L3_2, L4_2)
end
L2_1(L3_1, L4_1)
L2_1 = RegisterNetEvent
L3_1 = "qs-sounds:client:PauseSound"
L2_1(L3_1)
L2_1 = AddEventHandler
L3_1 = "qs-sounds:client:PauseSound"
function L4_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = tostring
  L2_2 = GetPlayerServerId
  L3_2 = PlayerId
  L3_2 = L3_2()
  L2_2, L3_2 = L2_2(L3_2)
  L1_2 = L1_2(L2_2, L3_2)
  if L1_2 ~= A0_2 then
    L1_2 = L0_1
    L1_2 = L1_2[A0_2]
    L1_2 = L1_2.duraklat
    if false == L1_2 then
      L1_2 = L0_1
      L1_2 = L1_2[A0_2]
      L1_2.duraklat = true
      L1_2 = Pause
      L2_2 = A0_2
      L1_2(L2_2)
    end
  end
end
L2_1(L3_1, L4_1)
L2_1 = exports
L3_1 = "ContinueSound"
function L4_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = tostring
  L2_2 = GetPlayerServerId
  L3_2 = PlayerId
  L3_2, L4_2 = L3_2()
  L2_2, L3_2, L4_2 = L2_2(L3_2, L4_2)
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  L2_2 = TriggerServerEvent
  L3_2 = "qs-sounds:server:ContinueSound"
  L4_2 = L1_2
  L2_2(L3_2, L4_2)
end
L2_1(L3_1, L4_1)
L2_1 = RegisterNetEvent
L3_1 = "qs-sounds:client:ContinueSound"
L2_1(L3_1)
L2_1 = AddEventHandler
L3_1 = "qs-sounds:client:ContinueSound"
function L4_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = tostring
  L2_2 = GetPlayerServerId
  L3_2 = PlayerId
  L3_2 = L3_2()
  L2_2, L3_2 = L2_2(L3_2)
  L1_2 = L1_2(L2_2, L3_2)
  if L1_2 ~= A0_2 then
    L1_2 = L0_1
    L1_2 = L1_2[A0_2]
    L1_2 = L1_2.duraklat
    if true == L1_2 then
      L1_2 = L0_1
      L1_2 = L1_2[A0_2]
      L1_2.duraklat = false
      L1_2 = Resume
      L2_2 = A0_2
      L1_2(L2_2)
    end
  end
end
L2_1(L3_1, L4_1)
L2_1 = 100
L3_1 = Citizen
L3_1 = L3_1.CreateThread
function L4_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  while true do
    L0_2 = Citizen
    L0_2 = L0_2.Wait
    L1_2 = L2_1
    L0_2(L1_2)
    L0_2 = pairs
    L1_2 = L0_1
    L0_2, L1_2, L2_2, L3_2 = L0_2(L1_2)
    for L4_2, L5_2 in L0_2, L1_2, L2_2, L3_2 do
      L6_2 = GetPlayerFromServerId
      L7_2 = L0_1
      L7_2 = L7_2[L4_2]
      L7_2 = L7_2.serverId
      L6_2 = L6_2(L7_2)
      if -1 ~= L6_2 then
        L7_2 = GetPlayerPed
        L8_2 = L6_2
        L7_2 = L7_2(L8_2)
        L8_2 = GetEntityCoords
        L9_2 = L7_2
        L8_2 = L8_2(L9_2)
        L9_2 = GetEntityCoords
        L10_2 = PlayerPedId
        L10_2, L11_2, L12_2, L13_2, L14_2 = L10_2()
        L9_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2)
        L10_2 = L9_2 - L8_2
        L10_2 = #L10_2
        L11_2 = 200
        if L10_2 < L11_2 then
          L11_2 = 100
          L2_1 = L11_2
          L11_2 = Position
          L12_2 = L4_2
          L13_2 = L8_2
          L11_2(L12_2, L13_2)
          L11_2 = L0_1
          L11_2 = L11_2[L4_2]
          L11_2 = L11_2.mp3
          if L11_2 then
            L11_2 = IsPedInAnyVehicle
            L12_2 = L7_2
            L13_2 = true
            L11_2 = L11_2(L12_2, L13_2)
            if 1 == L11_2 then
              L11_2 = GetVehiclePedIsIn
              L12_2 = L7_2
              L13_2 = false
              L11_2 = L11_2(L12_2, L13_2)
              L12_2 = GetEntitySpeed
              L13_2 = L11_2
              L12_2 = L12_2(L13_2)
              L12_2 = L12_2 * 3.6
              L13_2 = 200.0
              if L12_2 > L13_2 then
                L12_2 = Distance
                L13_2 = L4_2
                L14_2 = 140
                L12_2(L13_2, L14_2)
              else
                L12_2 = GetEntitySpeed
                L13_2 = L11_2
                L12_2 = L12_2(L13_2)
                L12_2 = L12_2 * 3.6
                L13_2 = 150.0
                if L12_2 > L13_2 then
                  L12_2 = Distance
                  L13_2 = L4_2
                  L14_2 = 125
                  L12_2(L13_2, L14_2)
                else
                  L12_2 = GetEntitySpeed
                  L13_2 = L11_2
                  L12_2 = L12_2(L13_2)
                  L12_2 = L12_2 * 3.6
                  if L12_2 > 110.0 then
                    L12_2 = Distance
                    L13_2 = L4_2
                    L14_2 = 100
                    L12_2(L13_2, L14_2)
                  else
                    L12_2 = GetEntitySpeed
                    L13_2 = L11_2
                    L12_2 = L12_2(L13_2)
                    L12_2 = L12_2 * 3.6
                    if L12_2 > 90.0 then
                      L12_2 = Distance
                      L13_2 = L4_2
                      L14_2 = 80
                      L12_2(L13_2, L14_2)
                    else
                      L12_2 = GetEntitySpeed
                      L13_2 = L11_2
                      L12_2 = L12_2(L13_2)
                      L12_2 = L12_2 * 3.6
                      if L12_2 > 60.0 then
                        L12_2 = Distance
                        L13_2 = L4_2
                        L14_2 = 65
                        L12_2(L13_2, L14_2)
                      else
                        L12_2 = GetEntitySpeed
                        L13_2 = L11_2
                        L12_2 = L12_2(L13_2)
                        L12_2 = L12_2 * 3.6
                        if L12_2 > 30.0 then
                          L12_2 = Distance
                          L13_2 = L4_2
                          L14_2 = 40
                          L12_2(L13_2, L14_2)
                        else
                          L12_2 = Distance
                          L13_2 = L4_2
                          L14_2 = 25
                          L12_2(L13_2, L14_2)
                        end
                      end
                    end
                  end
                end
              end
            else
              L11_2 = Distance
              L12_2 = L4_2
              L13_2 = 10
              L11_2(L12_2, L13_2)
            end
          else
            L11_2 = IsPedInAnyVehicle
            L12_2 = L7_2
            L13_2 = true
            L11_2 = L11_2(L12_2, L13_2)
            if 1 == L11_2 then
              L11_2 = GetVehiclePedIsIn
              L12_2 = L7_2
              L13_2 = false
              L11_2 = L11_2(L12_2, L13_2)
              L12_2 = GetEntitySpeed
              L13_2 = L11_2
              L12_2 = L12_2(L13_2)
              L12_2 = L12_2 * 3.6
              L13_2 = 200.0
              if L12_2 > L13_2 then
                L12_2 = Distance
                L13_2 = L4_2
                L14_2 = 140
                L12_2(L13_2, L14_2)
              else
                L12_2 = GetEntitySpeed
                L13_2 = L11_2
                L12_2 = L12_2(L13_2)
                L12_2 = L12_2 * 3.6
                L13_2 = 150.0
                if L12_2 > L13_2 then
                  L12_2 = Distance
                  L13_2 = L4_2
                  L14_2 = 125
                  L12_2(L13_2, L14_2)
                else
                  L12_2 = GetEntitySpeed
                  L13_2 = L11_2
                  L12_2 = L12_2(L13_2)
                  L12_2 = L12_2 * 3.6
                  if L12_2 > 110.0 then
                    L12_2 = Distance
                    L13_2 = L4_2
                    L14_2 = 100
                    L12_2(L13_2, L14_2)
                  else
                    L12_2 = GetEntitySpeed
                    L13_2 = L11_2
                    L12_2 = L12_2(L13_2)
                    L12_2 = L12_2 * 3.6
                    if L12_2 > 90.0 then
                      L12_2 = Distance
                      L13_2 = L4_2
                      L14_2 = 80
                      L12_2(L13_2, L14_2)
                    else
                      L12_2 = GetEntitySpeed
                      L13_2 = L11_2
                      L12_2 = L12_2(L13_2)
                      L12_2 = L12_2 * 3.6
                      if L12_2 > 60.0 then
                        L12_2 = Distance
                        L13_2 = L4_2
                        L14_2 = 65
                        L12_2(L13_2, L14_2)
                      else
                        L12_2 = GetEntitySpeed
                        L13_2 = L11_2
                        L12_2 = L12_2(L13_2)
                        L12_2 = L12_2 * 3.6
                        if L12_2 > 30.0 then
                          L12_2 = Distance
                          L13_2 = L4_2
                          L14_2 = 40
                          L12_2(L13_2, L14_2)
                        else
                          L12_2 = Distance
                          L13_2 = L4_2
                          L14_2 = 25
                          L12_2(L13_2, L14_2)
                        end
                      end
                    end
                  end
                end
              end
            else
              L11_2 = Distance
              L12_2 = L4_2
              L13_2 = 15
              L11_2(L12_2, L13_2)
            end
          end
        else
          L11_2 = 2000
          L2_1 = L11_2
          L11_2 = Position
          L12_2 = L4_2
          L13_2 = L8_2
          L11_2(L12_2, L13_2)
        end
      else
        L7_2 = tostring
        L8_2 = L0_1
        L8_2 = L8_2[L4_2]
        L8_2 = L8_2.serverId
        L7_2 = L7_2(L8_2)
        L8_2 = L0_1
        L8_2[L7_2] = nil
        L8_2 = Destroy
        L9_2 = L7_2
        L8_2(L9_2)
      end
    end
  end
end
L3_1(L4_1)
