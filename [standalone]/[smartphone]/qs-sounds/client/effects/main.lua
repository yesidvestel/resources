local L0_1, L1_1, L2_1
function L0_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L3_2 = soundExists
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if L3_2 then
    L3_2 = volumeType
    L4_2 = A0_2
    L5_2 = 0
    L3_2(L4_2, L5_2)
    L3_2 = A2_2 / A1_2
    L3_2 = L3_2 * 100
    L4_2 = 0
    L5_2 = A2_2
    while true do
      L5_2 = L5_2 - L3_2
      if L5_2 < 0 then
        L5_2 = 0
      end
      if 0 == L5_2 then
        break
      end
      L4_2 = L4_2 + 1
    end
    L6_2 = getVolume
    L7_2 = A0_2
    L6_2 = L6_2(L7_2)
    L5_2 = L6_2
    while true do
      L6_2 = Citizen
      L6_2 = L6_2.Wait
      L7_2 = A1_2 / L4_2
      L6_2(L7_2)
      L5_2 = L5_2 + L3_2
      if A2_2 < L5_2 then
        L5_2 = A2_2
        L6_2 = volumeType
        L7_2 = A0_2
        L8_2 = L5_2
        L6_2(L7_2, L8_2)
        break
      end
      L6_2 = volumeType
      L7_2 = A0_2
      L8_2 = L5_2
      L6_2(L7_2, L8_2)
    end
  end
end
fadeIn = L0_1
L0_1 = exports
L1_1 = "fadeIn"
L2_1 = fadeIn
L0_1(L1_1, L2_1)
function L0_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = soundExists
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if L2_2 then
    L2_2 = getVolume
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
    L3_2 = L2_2 / A1_2
    L3_2 = L3_2 * 100
    L4_2 = 0
    while true do
      L2_2 = L2_2 - L3_2
      if L2_2 < 0 then
        L2_2 = 0
      end
      if 0 == L2_2 then
        break
      end
      L4_2 = L4_2 + 1
    end
    L5_2 = getVolume
    L6_2 = A0_2
    L5_2 = L5_2(L6_2)
    L2_2 = L5_2
    while true do
      L5_2 = Citizen
      L5_2 = L5_2.Wait
      L6_2 = A1_2 / L4_2
      L5_2(L6_2)
      L2_2 = L2_2 - L3_2
      if L2_2 < 0 then
        L2_2 = 0
        L5_2 = volumeType
        L6_2 = A0_2
        L7_2 = L2_2
        L5_2(L6_2, L7_2)
        break
      end
      L5_2 = volumeType
      L6_2 = A0_2
      L7_2 = L2_2
      L5_2(L6_2, L7_2)
    end
  end
end
fadeOut = L0_1
L0_1 = exports
L1_1 = "fadeOut"
L2_1 = fadeOut
L0_1(L1_1, L2_1)
function L0_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = isDynamic
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if L2_2 then
    L2_2 = setVolumeMax
    L3_2 = A0_2
    L4_2 = A1_2
    L2_2(L3_2, L4_2)
    L2_2 = setVolume
    L3_2 = A0_2
    L4_2 = A1_2
    L2_2(L3_2, L4_2)
  else
    L2_2 = setVolume
    L3_2 = A0_2
    L4_2 = A1_2
    L2_2(L3_2, L4_2)
  end
end
volumeType = L0_1
