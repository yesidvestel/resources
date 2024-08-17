
local QBCore = exports['qb-core']:GetCoreObject()
AddTextEntry("WEAPON_PAINTBALL", "PaintBall Weapon")

-------------------------------- 

function notify(text)
      TriggerEvent('QBCore:Notify',text)
end

-------------------------------- 

function ReviveFunction()
      Citizen.Wait(900)
      TriggerEvent("hospital:client:Revive")
      Citizen.Wait(100)
end

-------------------------------- 

function giveWeapon()
      local playerPed = PlayerPedId()
      GiveWeaponToPed(playerPed, GetHashKey(Config.Weapon ), 500, false, true)
      SetCurrentPedWeapon(playerPed, GetHashKey(Config.Weapon ), true)
end

-------------------------------- 
  
  function DeleteWeapon()
      local playerPed = PlayerPedId()
      RemoveWeaponFromPed(playerPed, GetHashKey(Config.Weapon))
  end

-------------------------------- 

function DrawText3D(x,y,z, text)
      local onScreen,_x,_y=World3dToScreen2d(x,y,z)
      local px,py,pz=table.unpack(GetGameplayCamCoords())
      
      SetTextScale(0.35, 0.35)
      SetTextFont(4)
      SetTextProportional(1)
      SetTextColour(255, 255, 255, 215)
    
      SetTextEntry("STRING")
      SetTextCentre(1)
      AddTextComponentString(text)
      DrawText(_x,_y)
      local factor = (string.len(text)) / 370
      DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
    end

