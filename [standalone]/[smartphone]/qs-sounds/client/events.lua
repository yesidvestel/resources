local L0_1, L1_1, L2_1
L0_1 = RegisterNUICallback
L1_1 = "data_status"
function L2_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = soundInfo
  L2_2 = A0_2.id
  L1_2 = L1_2[L2_2]
  if nil ~= L1_2 then
    L1_2 = A0_2.type
    if "finished" == L1_2 then
      L1_2 = soundInfo
      L2_2 = A0_2.id
      L1_2 = L1_2[L2_2]
      L1_2 = L1_2.loop
      if not L1_2 then
        L1_2 = soundInfo
        L2_2 = A0_2.id
        L1_2 = L1_2[L2_2]
        L1_2.playing = false
      end
      L1_2 = TriggerEvent
      L2_2 = "qs-sounds:client:soundStopPlaying"
      L3_2 = A0_2.id
      L1_2(L2_2, L3_2)
    end
    L1_2 = A0_2.type
    if "maxDuration" == L1_2 then
      L1_2 = soundInfo
      L2_2 = A0_2.id
      L1_2 = L1_2[L2_2]
      L1_2.timeStamp = 0
      L1_2 = soundInfo
      L2_2 = A0_2.id
      L1_2 = L1_2[L2_2]
      L2_2 = A0_2.time
      L1_2.maxDuration = L2_2
    end
  end
end
L0_1(L1_1, L2_1)
L0_1 = RegisterNUICallback
L1_1 = "events"
function L2_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = A0_2.id
  L2_2 = A0_2.type
  if "resetTimeStamp" == L2_2 then
    L3_2 = soundInfo
    L3_2 = L3_2[L1_2]
    if L3_2 then
      L3_2 = soundInfo
      L3_2 = L3_2[L1_2]
      L3_2.timeStamp = 0
      L3_2 = soundInfo
      L3_2 = L3_2[L1_2]
      L4_2 = A0_2.time
      L3_2.maxDuration = L4_2
      L3_2 = soundInfo
      L3_2 = L3_2[L1_2]
      L3_2.playing = true
    end
  end
  if "onPlay" == L2_2 then
    L3_2 = globalOptionsCache
    L3_2 = L3_2[L1_2]
    if L3_2 then
      L3_2 = globalOptionsCache
      L3_2 = L3_2[L1_2]
      L3_2 = L3_2.onPlayStart
      if L3_2 then
        L3_2 = globalOptionsCache
        L3_2 = L3_2[L1_2]
        L3_2 = L3_2.onPlayStart
        L4_2 = getInfo
        L5_2 = L1_2
        L4_2, L5_2 = L4_2(L5_2)
        L3_2(L4_2, L5_2)
      end
    end
  end
  if "onEnd" == L2_2 then
    L3_2 = globalOptionsCache
    L3_2 = L3_2[L1_2]
    if L3_2 then
      L3_2 = globalOptionsCache
      L3_2 = L3_2[L1_2]
      L3_2 = L3_2.onPlayEnd
      if L3_2 then
        L3_2 = globalOptionsCache
        L3_2 = L3_2[L1_2]
        L3_2 = L3_2.onPlayEnd
        L4_2 = getInfo
        L5_2 = L1_2
        L4_2, L5_2 = L4_2(L5_2)
        L3_2(L4_2, L5_2)
      end
    end
    L3_2 = soundInfo
    L3_2 = L3_2[L1_2]
    if L3_2 then
      L3_2 = soundInfo
      L3_2 = L3_2[L1_2]
      L3_2 = L3_2.loop
      if L3_2 then
        L3_2 = soundInfo
        L3_2 = L3_2[L1_2]
        L3_2.timeStamp = 0
      end
      L3_2 = soundInfo
      L3_2 = L3_2[L1_2]
      L3_2 = L3_2.destroyOnFinish
      if L3_2 then
        L3_2 = soundInfo
        L3_2 = L3_2[L1_2]
        L3_2 = L3_2.loop
        if not L3_2 then
          L3_2 = Destroy
          L4_2 = L1_2
          L3_2(L4_2)
        end
      end
    end
  end
  if "onLoading" == L2_2 then
    L3_2 = globalOptionsCache
    L3_2 = L3_2[L1_2]
    if L3_2 then
      L3_2 = globalOptionsCache
      L3_2 = L3_2[L1_2]
      L3_2 = L3_2.onLoading
      if L3_2 then
        L3_2 = globalOptionsCache
        L3_2 = L3_2[L1_2]
        L3_2 = L3_2.onLoading
        L4_2 = getInfo
        L5_2 = L1_2
        L4_2, L5_2 = L4_2(L5_2)
        L3_2(L4_2, L5_2)
      end
    end
  end
end
L0_1(L1_1, L2_1)
L0_1 = RegisterNetEvent
L1_1 = "qs-sounds:client:stateSound"
L0_1(L1_1)
L0_1 = AddEventHandler
L1_1 = "qs-sounds:client:stateSound"
function L2_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = A1_2.soundId
  if "destroyOnFinish" == A0_2 then
    L3_2 = soundExists
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if L3_2 then
      L3_2 = destroyOnFinish
      L4_2 = L2_2
      L5_2 = A1_2.value
      L3_2(L4_2, L5_2)
    end
  end
  if "timestamp" == A0_2 then
    L3_2 = soundExists
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if L3_2 then
      L3_2 = setTimeStamp
      L4_2 = L2_2
      L5_2 = A1_2.time
      L3_2(L4_2, L5_2)
    end
  end
  if "texttospeech" == A0_2 then
    L3_2 = TextToSpeech
    L4_2 = L2_2
    L5_2 = A1_2.lang
    L6_2 = A1_2.url
    L7_2 = A1_2.volume
    L8_2 = A1_2.loop
    if not L8_2 then
      L8_2 = false
    end
    L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
  end
  if "texttospeechpos" == A0_2 then
    L3_2 = TextToSpeechPos
    L4_2 = L2_2
    L5_2 = A1_2.lang
    L6_2 = A1_2.url
    L7_2 = A1_2.volume
    L8_2 = A1_2.position
    L9_2 = A1_2.loop
    if not L9_2 then
      L9_2 = false
    end
    L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2)
  end
  if "play" == A0_2 then
    L3_2 = PlayUrl
    L4_2 = L2_2
    L5_2 = A1_2.url
    L6_2 = A1_2.volume
    L7_2 = A1_2.loop
    if not L7_2 then
      L7_2 = false
    end
    L3_2(L4_2, L5_2, L6_2, L7_2)
  end
  if "playpos" == A0_2 then
    L3_2 = PlayUrlPos
    L4_2 = L2_2
    L5_2 = A1_2.url
    L6_2 = A1_2.volume
    L7_2 = A1_2.position
    L8_2 = A1_2.loop
    if not L8_2 then
      L8_2 = false
    end
    L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
  end
  if "position" == A0_2 then
    L3_2 = soundExists
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if L3_2 then
      L3_2 = Position
      L4_2 = L2_2
      L5_2 = A1_2.position
      L3_2(L4_2, L5_2)
    end
  end
  if "distance" == A0_2 then
    L3_2 = soundExists
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if L3_2 then
      L3_2 = Distance
      L4_2 = L2_2
      L5_2 = A1_2.distance
      L3_2(L4_2, L5_2)
    end
  end
  if "destroy" == A0_2 then
    L3_2 = soundExists
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if L3_2 then
      L3_2 = Destroy
      L4_2 = L2_2
      L3_2(L4_2)
    end
  end
  if "pause" == A0_2 then
    L3_2 = soundExists
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if L3_2 then
      L3_2 = Pause
      L4_2 = L2_2
      L3_2(L4_2)
    end
  end
  if "resume" == A0_2 then
    L3_2 = soundExists
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if L3_2 then
      L3_2 = Resume
      L4_2 = L2_2
      L3_2(L4_2)
    end
  end
  if "volume" == A0_2 then
    L3_2 = soundExists
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if L3_2 then
      L3_2 = isDynamic
      L4_2 = L2_2
      L3_2 = L3_2(L4_2)
      if L3_2 then
        L3_2 = setVolumeMax
        L4_2 = L2_2
        L5_2 = A1_2.volume
        L3_2(L4_2, L5_2)
      else
        L3_2 = setVolume
        L4_2 = L2_2
        L5_2 = A1_2.volume
        L3_2(L4_2, L5_2)
      end
    end
  end
end
L0_1(L1_1, L2_1)
