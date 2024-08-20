local L0_1, L1_1, L2_1
function L0_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = SendNUIMessage
  L3_2 = {}
  L3_2.status = "distance"
  L3_2.name = A0_2
  L3_2.distance = A1_2
  L2_2(L3_2)
  L2_2 = soundInfo
  L2_2 = L2_2[A0_2]
  L2_2.distance = A1_2
end
Distance = L0_1
L0_1 = exports
L1_1 = "Distance"
L2_1 = Distance
L0_1(L1_1, L2_1)
function L0_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = SendNUIMessage
  L3_2 = {}
  L3_2.status = "soundPosition"
  L3_2.name = A0_2
  L4_2 = A1_2.x
  L3_2.x = L4_2
  L4_2 = A1_2.y
  L3_2.y = L4_2
  L4_2 = A1_2.z
  L3_2.z = L4_2
  L2_2(L3_2)
  L2_2 = soundInfo
  L2_2 = L2_2[A0_2]
  L2_2.position = A1_2
  L2_2 = soundInfo
  L2_2 = L2_2[A0_2]
  L2_2.id = A0_2
end
Position = L0_1
L0_1 = exports
L1_1 = "Position"
L2_1 = Position
L0_1(L1_1, L2_1)
function L0_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = SendNUIMessage
  L2_2 = {}
  L2_2.status = "delete"
  L2_2.name = A0_2
  L1_2(L2_2)
  L1_2 = soundInfo
  L1_2[A0_2] = nil
  L1_2 = globalOptionsCache
  L1_2 = L1_2[A0_2]
  if nil ~= L1_2 then
    L1_2 = globalOptionsCache
    L1_2 = L1_2[A0_2]
    L1_2 = L1_2.onPlayEnd
    if nil ~= L1_2 then
      L1_2 = globalOptionsCache
      L1_2 = L1_2[A0_2]
      L1_2 = L1_2.onPlayEnd
      L2_2 = getInfo
      L3_2 = A0_2
      L2_2, L3_2 = L2_2(L3_2)
      L1_2(L2_2, L3_2)
    end
  end
  L1_2 = globalOptionsCache
  L1_2[A0_2] = nil
end
Destroy = L0_1
L0_1 = exports
L1_1 = "Destroy"
L2_1 = Destroy
L0_1(L1_1, L2_1)
function L0_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = SendNUIMessage
  L2_2 = {}
  L2_2.status = "resume"
  L2_2.name = A0_2
  L1_2(L2_2)
  L1_2 = soundInfo
  L1_2 = L1_2[A0_2]
  L1_2.playing = true
  L1_2 = soundInfo
  L1_2 = L1_2[A0_2]
  L1_2.paused = false
  L1_2 = globalOptionsCache
  L1_2 = L1_2[A0_2]
  if nil ~= L1_2 then
    L1_2 = globalOptionsCache
    L1_2 = L1_2[A0_2]
    L1_2 = L1_2.onPlayResume
    if nil ~= L1_2 then
      L1_2 = globalOptionsCache
      L1_2 = L1_2[A0_2]
      L1_2 = L1_2.onPlayResume
      L2_2 = getInfo
      L3_2 = A0_2
      L2_2, L3_2 = L2_2(L3_2)
      L1_2(L2_2, L3_2)
    end
  end
end
Resume = L0_1
L0_1 = exports
L1_1 = "Resume"
L2_1 = Resume
L0_1(L1_1, L2_1)
function L0_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = SendNUIMessage
  L2_2 = {}
  L2_2.status = "pause"
  L2_2.name = A0_2
  L1_2(L2_2)
  L1_2 = soundInfo
  L1_2 = L1_2[A0_2]
  L1_2.playing = false
  L1_2 = soundInfo
  L1_2 = L1_2[A0_2]
  L1_2.paused = true
  L1_2 = globalOptionsCache
  L1_2 = L1_2[A0_2]
  if nil ~= L1_2 then
    L1_2 = globalOptionsCache
    L1_2 = L1_2[A0_2]
    L1_2 = L1_2.onPlayPause
    if nil ~= L1_2 then
      L1_2 = globalOptionsCache
      L1_2 = L1_2[A0_2]
      L1_2 = L1_2.onPlayPause
      L2_2 = getInfo
      L3_2 = A0_2
      L2_2, L3_2 = L2_2(L3_2)
      L1_2(L2_2, L3_2)
    end
  end
end
Pause = L0_1
L0_1 = exports
L1_1 = "Pause"
L2_1 = Pause
L0_1(L1_1, L2_1)
function L0_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = SendNUIMessage
  L3_2 = {}
  L3_2.status = "volume"
  L3_2.volume = A1_2
  L3_2.name = A0_2
  L2_2(L3_2)
  L2_2 = soundInfo
  L2_2 = L2_2[A0_2]
  L2_2.volume = A1_2
end
setVolume = L0_1
L0_1 = exports
L1_1 = "setVolume"
L2_1 = setVolume
L0_1(L1_1, L2_1)
function L0_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = SendNUIMessage
  L3_2 = {}
  L3_2.status = "max_volume"
  L3_2.volume = A1_2
  L3_2.name = A0_2
  L2_2(L3_2)
  L2_2 = soundInfo
  L2_2 = L2_2[A0_2]
  L2_2.volume = A1_2
end
setVolumeMax = L0_1
L0_1 = exports
L1_1 = "setVolumeMax"
L2_1 = setVolumeMax
L0_1(L1_1, L2_1)
function L0_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = getInfo
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L2_2.timeStamp = A1_2
  L2_2 = SendNUIMessage
  L3_2 = {}
  L3_2.name = A0_2
  L3_2.status = "timestamp"
  L3_2.timestamp = A1_2
  L2_2(L3_2)
end
setTimeStamp = L0_1
L0_1 = exports
L1_1 = "setTimeStamp"
L2_1 = setTimeStamp
L0_1(L1_1, L2_1)
function L0_1(A0_2, A1_2)
  local L2_2
  L2_2 = soundInfo
  L2_2 = L2_2[A0_2]
  L2_2.destroyOnFinish = A1_2
end
destroyOnFinish = L0_1
L0_1 = exports
L1_1 = "destroyOnFinish"
L2_1 = destroyOnFinish
L0_1(L1_1, L2_1)
function L0_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = SendNUIMessage
  L3_2 = {}
  L3_2.status = "loop"
  L3_2.name = A0_2
  L3_2.loop = A1_2
  L2_2(L3_2)
  L2_2 = soundInfo
  L2_2 = L2_2[A0_2]
  L2_2.loop = A1_2
end
setSoundLoop = L0_1
L0_1 = exports
L1_1 = "setSoundLoop"
L2_1 = setSoundLoop
L0_1(L1_1, L2_1)
function L0_1(A0_2)
  local L1_2, L2_2
  L1_2 = soundExists
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if L1_2 then
    L1_2 = SendNUIMessage
    L2_2 = {}
    L2_2.status = "repeat"
    L2_2.name = A0_2
    L1_2(L2_2)
  end
end
repeatSound = L0_1
L0_1 = exports
L1_1 = "repeatSound"
L2_1 = repeatSound
L0_1(L1_1, L2_1)
function L0_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = soundExists
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if L2_2 then
    L2_2 = soundInfo
    L2_2 = L2_2[A0_2]
    L2_2.isDynamic = A1_2
    L2_2 = SendNUIMessage
    L3_2 = {}
    L3_2.status = "changedynamic"
    L3_2.name = A0_2
    L3_2.bool = A1_2
    L2_2(L3_2)
  end
end
setSoundDynamic = L0_1
L0_1 = exports
L1_1 = "setSoundDynamic"
L2_1 = setSoundDynamic
L0_1(L1_1, L2_1)
function L0_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = soundExists
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if L2_2 then
    L2_2 = soundInfo
    L2_2 = L2_2[A0_2]
    L2_2.url = A1_2
    L2_2 = SendNUIMessage
    L3_2 = {}
    L3_2.status = "changeurl"
    L3_2.name = A0_2
    L3_2.url = A1_2
    L2_2(L3_2)
  end
end
setSoundURL = L0_1
L0_1 = exports
L1_1 = "setSoundURL"
L2_1 = setSoundURL
L0_1(L1_1, L2_1)
