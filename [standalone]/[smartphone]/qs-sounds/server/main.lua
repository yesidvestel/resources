local L0_1, L1_1, L2_1
function L0_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2
  L5_2 = TriggerClientEvent
  L6_2 = "qs-sounds:client:stateSound"
  L7_2 = A0_2
  L8_2 = "play"
  L9_2 = {}
  L9_2.soundId = A1_2
  L9_2.url = A2_2
  L9_2.volume = A3_2
  L9_2.loop = A4_2
  L5_2(L6_2, L7_2, L8_2, L9_2)
end
PlayUrl = L0_1
L0_1 = exports
L1_1 = "PlayUrl"
L2_1 = PlayUrl
L0_1(L1_1, L2_1)
function L0_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2)
  local L6_2, L7_2, L8_2, L9_2, L10_2
  L6_2 = TriggerClientEvent
  L7_2 = "qs-sounds:client:stateSound"
  L8_2 = A0_2
  L9_2 = "playpos"
  L10_2 = {}
  L10_2.soundId = A1_2
  L10_2.position = A4_2
  L10_2.url = A2_2
  L10_2.volume = A3_2
  L10_2.loop = A5_2
  L6_2(L7_2, L8_2, L9_2, L10_2)
end
PlayUrlPos = L0_1
L0_1 = exports
L1_1 = "PlayUrlPos"
L2_1 = PlayUrlPos
L0_1(L1_1, L2_1)
function L0_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2)
  local L6_2, L7_2, L8_2, L9_2, L10_2
  L6_2 = TriggerClientEvent
  L7_2 = "qs-sounds:client:stateSound"
  L8_2 = A0_2
  L9_2 = "texttospeech"
  L10_2 = {}
  L10_2.soundId = A1_2
  L10_2.url = A3_2
  L10_2.lang = A2_2
  L10_2.volume = A4_2
  L10_2.loop = A5_2
  L6_2(L7_2, L8_2, L9_2, L10_2)
end
TextToSpeech = L0_1
L0_1 = exports
L1_1 = "TextToSpeech"
L2_1 = TextToSpeech
L0_1(L1_1, L2_1)
function L0_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2, A6_2)
  local L7_2, L8_2, L9_2, L10_2, L11_2
  L7_2 = TriggerClientEvent
  L8_2 = "qs-sounds:client:stateSound"
  L9_2 = A0_2
  L10_2 = "texttospeechpos"
  L11_2 = {}
  L11_2.soundId = A1_2
  L11_2.lang = A2_2
  L11_2.position = A5_2
  L11_2.url = A3_2
  L11_2.volume = A4_2
  L11_2.loop = A6_2
  L7_2(L8_2, L9_2, L10_2, L11_2)
end
TextToSpeechPos = L0_1
L0_1 = exports
L1_1 = "TextToSpeechPos"
L2_1 = TextToSpeechPos
L0_1(L1_1, L2_1)
