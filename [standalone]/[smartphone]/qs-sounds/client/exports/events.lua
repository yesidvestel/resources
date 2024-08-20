local L0_1, L1_1, L2_1
function L0_1(A0_2, A1_2)
  local L2_2
  L2_2 = globalOptionsCache
  L2_2 = L2_2[A0_2]
  L2_2.onPlayStart = A1_2
end
onPlayStart = L0_1
L0_1 = exports
L1_1 = "onPlayStart"
L2_1 = onPlayStart
L0_1(L1_1, L2_1)
function L0_1(A0_2, A1_2)
  local L2_2
  L2_2 = globalOptionsCache
  L2_2 = L2_2[A0_2]
  L2_2.onPlayEnd = A1_2
end
onPlayEnd = L0_1
L0_1 = exports
L1_1 = "onPlayEnd"
L2_1 = onPlayEnd
L0_1(L1_1, L2_1)
function L0_1(A0_2, A1_2)
  local L2_2
  L2_2 = globalOptionsCache
  L2_2 = L2_2[A0_2]
  L2_2.onLoading = A1_2
end
onLoading = L0_1
L0_1 = exports
L1_1 = "onLoading"
L2_1 = onLoading
L0_1(L1_1, L2_1)
function L0_1(A0_2, A1_2)
  local L2_2
  L2_2 = globalOptionsCache
  L2_2 = L2_2[A0_2]
  L2_2.onPlayPause = A1_2
end
onPlayPause = L0_1
L0_1 = exports
L1_1 = "onPlayPause"
L2_1 = onPlayPause
L0_1(L1_1, L2_1)
function L0_1(A0_2, A1_2)
  local L2_2
  L2_2 = globalOptionsCache
  L2_2 = L2_2[A0_2]
  L2_2.onPlayResume = A1_2
end
onPlayResume = L0_1
L0_1 = exports
L1_1 = "onPlayResume"
L2_1 = onPlayResume
L0_1(L1_1, L2_1)
