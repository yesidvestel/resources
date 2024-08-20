local L0_1, L1_1, L2_1
L0_1 = {}
soundInfo = L0_1
function L0_1(A0_2)
  local L1_2
  L1_2 = soundInfo
  L1_2 = L1_2[A0_2]
  L1_2 = L1_2.url
  return L1_2
end
getLink = L0_1
L0_1 = exports
L1_1 = "getLink"
L2_1 = getLink
L0_1(L1_1, L2_1)
function L0_1(A0_2)
  local L1_2
  L1_2 = soundInfo
  L1_2 = L1_2[A0_2]
  L1_2 = L1_2.position
  return L1_2
end
getPosition = L0_1
L0_1 = exports
L1_1 = "getPosition"
L2_1 = getPosition
L0_1(L1_1, L2_1)
function L0_1(A0_2)
  local L1_2
  L1_2 = soundInfo
  L1_2 = L1_2[A0_2]
  L1_2 = L1_2.loop
  return L1_2
end
isLooped = L0_1
L0_1 = exports
L1_1 = "isLooped"
L2_1 = isLooped
L0_1(L1_1, L2_1)
function L0_1(A0_2)
  local L1_2
  L1_2 = soundInfo
  L1_2 = L1_2[A0_2]
  return L1_2
end
getInfo = L0_1
L0_1 = exports
L1_1 = "getInfo"
L2_1 = getInfo
L0_1(L1_1, L2_1)
function L0_1(A0_2)
  local L1_2
  L1_2 = soundInfo
  L1_2 = L1_2[A0_2]
  if nil == L1_2 then
    L1_2 = false
    return L1_2
  end
  L1_2 = true
  return L1_2
end
soundExists = L0_1
L0_1 = exports
L1_1 = "soundExists"
L2_1 = soundExists
L0_1(L1_1, L2_1)
function L0_1(A0_2)
  local L1_2
  L1_2 = soundInfo
  L1_2 = L1_2[A0_2]
  L1_2 = L1_2.playing
  return L1_2
end
isPlaying = L0_1
L0_1 = exports
L1_1 = "isPlaying"
L2_1 = isPlaying
L0_1(L1_1, L2_1)
function L0_1(A0_2)
  local L1_2
  L1_2 = soundInfo
  L1_2 = L1_2[A0_2]
  L1_2 = L1_2.paused
  return L1_2
end
isPaused = L0_1
L0_1 = exports
L1_1 = "isPaused"
L2_1 = isPaused
L0_1(L1_1, L2_1)
function L0_1(A0_2)
  local L1_2
  L1_2 = soundInfo
  L1_2 = L1_2[A0_2]
  L1_2 = L1_2.distance
  return L1_2
end
getDistance = L0_1
L0_1 = exports
L1_1 = "getDistance"
L2_1 = getDistance
L0_1(L1_1, L2_1)
function L0_1(A0_2)
  local L1_2
  L1_2 = soundInfo
  L1_2 = L1_2[A0_2]
  L1_2 = L1_2.volume
  return L1_2
end
getVolume = L0_1
L0_1 = exports
L1_1 = "getVolume"
L2_1 = getVolume
L0_1(L1_1, L2_1)
function L0_1(A0_2)
  local L1_2
  L1_2 = soundInfo
  L1_2 = L1_2[A0_2]
  L1_2 = L1_2.isDynamic
  return L1_2
end
isDynamic = L0_1
L0_1 = exports
L1_1 = "isDynamic"
L2_1 = isDynamic
L0_1(L1_1, L2_1)
function L0_1(A0_2)
  local L1_2
  L1_2 = soundInfo
  L1_2 = L1_2[A0_2]
  L1_2 = L1_2.timeStamp
  if not L1_2 then
    L1_2 = -1
  end
  return L1_2
end
getTimeStamp = L0_1
L0_1 = exports
L1_1 = "getTimeStamp"
L2_1 = getTimeStamp
L0_1(L1_1, L2_1)
function L0_1(A0_2)
  local L1_2
  L1_2 = soundInfo
  L1_2 = L1_2[A0_2]
  L1_2 = L1_2.maxDuration
  if not L1_2 then
    L1_2 = -1
  end
  return L1_2
end
getMaxDuration = L0_1
L0_1 = exports
L1_1 = "getMaxDuration"
L2_1 = getMaxDuration
L0_1(L1_1, L2_1)
function L0_1()
  local L0_2, L1_2
  L0_2 = disableMusic
  return L0_2
end
isPlayerInStreamerMode = L0_1
L0_1 = exports
L1_1 = "isPlayerInStreamerMode"
L2_1 = isPlayerInStreamerMode
L0_1(L1_1, L2_1)
function L0_1()
  local L0_2, L1_2
  L0_2 = soundInfo
  return L0_2
end
getAllAudioInfo = L0_1
L0_1 = exports
L1_1 = "getAllAudioInfo"
L2_1 = getAllAudioInfo
L0_1(L1_1, L2_1)
function L0_1()
  local L0_2, L1_2
  L0_2 = isPlayerCloseToMusic
  return L0_2
end
isPlayerCloseToAnySound = L0_1
L0_1 = exports
L1_1 = "isPlayerCloseToAnySound"
L2_1 = isPlayerCloseToAnySound
L0_1(L1_1, L2_1)
