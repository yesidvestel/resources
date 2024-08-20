local L0_1, L1_1, L2_1
function L0_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2
  L5_2 = disableMusic
  if L5_2 then
    return
  end
  L5_2 = SendNUIMessage
  L6_2 = {}
  L6_2.status = "url"
  L6_2.name = A0_2
  L6_2.url = A1_2
  L6_2.x = 0
  L6_2.y = 0
  L6_2.z = 0
  L6_2.dynamic = false
  L6_2.volume = A2_2
  L7_2 = A3_2 or L7_2
  if not A3_2 then
    L7_2 = false
  end
  L6_2.loop = L7_2
  L5_2(L6_2)
  L5_2 = soundInfo
  L5_2 = L5_2[A0_2]
  if nil == L5_2 then
    L5_2 = soundInfo
    L6_2 = getDefaultInfo
    L6_2 = L6_2()
    L5_2[A0_2] = L6_2
  end
  L5_2 = soundInfo
  L5_2 = L5_2[A0_2]
  L5_2.volume = A2_2
  L5_2 = soundInfo
  L5_2 = L5_2[A0_2]
  L5_2.url = A1_2
  L5_2 = soundInfo
  L5_2 = L5_2[A0_2]
  L5_2.id = A0_2
  L5_2 = soundInfo
  L5_2 = L5_2[A0_2]
  L5_2.playing = true
  L5_2 = soundInfo
  L5_2 = L5_2[A0_2]
  L6_2 = A3_2 or L6_2
  if not A3_2 then
    L6_2 = false
  end
  L5_2.loop = L6_2
  L5_2 = soundInfo
  L5_2 = L5_2[A0_2]
  L5_2.isDynamic = false
  L5_2 = globalOptionsCache
  L6_2 = A4_2 or L6_2
  if not A4_2 then
    L6_2 = {}
  end
  L5_2[A0_2] = L6_2
end
PlayUrl = L0_1
L0_1 = exports
L1_1 = "PlayUrl"
L2_1 = PlayUrl
L0_1(L1_1, L2_1)
function L0_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2)
  local L6_2, L7_2, L8_2
  L6_2 = disableMusic
  if L6_2 then
    return
  end
  L6_2 = SendNUIMessage
  L7_2 = {}
  L7_2.status = "url"
  L7_2.name = A0_2
  L7_2.url = A1_2
  L8_2 = A3_2.x
  L7_2.x = L8_2
  L8_2 = A3_2.y
  L7_2.y = L8_2
  L8_2 = A3_2.z
  L7_2.z = L8_2
  L7_2.dynamic = true
  L7_2.volume = A2_2
  L8_2 = A4_2 or L8_2
  if not A4_2 then
    L8_2 = false
  end
  L7_2.loop = L8_2
  L6_2(L7_2)
  L6_2 = soundInfo
  L6_2 = L6_2[A0_2]
  if nil == L6_2 then
    L6_2 = soundInfo
    L7_2 = getDefaultInfo
    L7_2 = L7_2()
    L6_2[A0_2] = L7_2
  end
  L6_2 = soundInfo
  L6_2 = L6_2[A0_2]
  L6_2.volume = A2_2
  L6_2 = soundInfo
  L6_2 = L6_2[A0_2]
  L6_2.url = A1_2
  L6_2 = soundInfo
  L6_2 = L6_2[A0_2]
  L6_2.position = A3_2
  L6_2 = soundInfo
  L6_2 = L6_2[A0_2]
  L6_2.id = A0_2
  L6_2 = soundInfo
  L6_2 = L6_2[A0_2]
  L6_2.playing = true
  L6_2 = soundInfo
  L6_2 = L6_2[A0_2]
  L7_2 = A4_2 or L7_2
  if not A4_2 then
    L7_2 = false
  end
  L6_2.loop = L7_2
  L6_2 = soundInfo
  L6_2 = L6_2[A0_2]
  L6_2.isDynamic = true
  L6_2 = globalOptionsCache
  L7_2 = A5_2 or L7_2
  if not A5_2 then
    L7_2 = {}
  end
  L6_2[A0_2] = L7_2
end
PlayUrlPos = L0_1
L0_1 = exports
L1_1 = "PlayUrlPos"
L2_1 = PlayUrlPos
L0_1(L1_1, L2_1)
function L0_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2)
  local L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L6_2 = disableMusic
  if L6_2 then
    return
  end
  L6_2 = string
  L6_2 = L6_2.format
  L7_2 = "https://translate.google.com/translate_tts?ie=UTF-8&q=%s&tl=%s&total=1&idx=0&client=tw-ob"
  L8_2 = A2_2
  L9_2 = A1_2
  L6_2 = L6_2(L7_2, L8_2, L9_2)
  L7_2 = PlayUrl
  L8_2 = A0_2
  L9_2 = L6_2
  L10_2 = A3_2
  L11_2 = A4_2
  L12_2 = A5_2
  L7_2(L8_2, L9_2, L10_2, L11_2, L12_2)
end
TextToSpeech = L0_1
L0_1 = exports
L1_1 = "TextToSpeech"
L2_1 = TextToSpeech
L0_1(L1_1, L2_1)
function L0_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2, A6_2)
  local L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L7_2 = disableMusic
  if L7_2 then
    return
  end
  L7_2 = string
  L7_2 = L7_2.format
  L8_2 = "https://translate.google.com/translate_tts?ie=UTF-8&q=%s&tl=%s&total=1&idx=0&client=tw-ob"
  L9_2 = A2_2
  L10_2 = A1_2
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  L8_2 = PlayUrlPos
  L9_2 = A0_2
  L10_2 = L7_2
  L11_2 = A3_2
  L12_2 = A4_2
  L13_2 = A5_2
  L14_2 = A6_2
  L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
end
TextToSpeechPos = L0_1
L0_1 = exports
L1_1 = "TextToSpeechPos"
L2_1 = TextToSpeechPos
L0_1(L1_1, L2_1)
