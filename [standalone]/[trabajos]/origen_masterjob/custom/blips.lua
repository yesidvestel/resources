function UpdateBlips(locations)
  for i = 1, #blips do
      RemoveBlip(blips[i])
  end
  for i = 1, #locations do
      local blip = AddBlipForCoord(locations[i].coords)

      SetBlipSprite(blip, Config.BusinessTypes[locations[i].type].blip.sprite)
      SetBlipColour(blip, Config.BusinessTypes[locations[i].type].blip.color)
      SetBlipScale(blip, 0.7)
      SetBlipAsShortRange(blip, true)

      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(locations[i].business_name)
      EndTextCommandSetBlipName(blip)

      table.insert(blips, blip)
  end
end