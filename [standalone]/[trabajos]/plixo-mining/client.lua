local QBCore = exports['qb-core']:GetCoreObject()
function CreateBlips()
	for k, v in pairs(Config.Locations) do
		if Config.Locations[k].blipTrue then
			local blip = AddBlipForCoord(v.location)
			SetBlipAsShortRange(blip, true)
			SetBlipSprite(blip, 618)
			SetBlipColour(blip, 46)
			SetBlipScale(blip, 0.5)
			SetBlipDisplay(blip, 6)

			BeginTextCommandSetBlipName('STRING')
			if Config.BlipNamer then
				AddTextComponentString(Config.Locations[k].name)
			else
				AddTextComponentString("Mining")
			end
			EndTextCommandSetBlipName(blip)
		end
	end
end

Citizen.CreateThread(function()
	--Hide the mineshaft doors
	CreateModelHide(vector3(-596.04, 2089.01, 131.41), 10.5, -1241212535, true)

    if Config.Blips == true then
		CreateBlips()
	end
end)
Citizen.CreateThread(function()
	if Config.PropSpawn == true then
		CreateProps()
	end
end)
Citizen.CreateThread(function()
	if Config.Pedspawn == true then
		CreatePeds()
	end
end)
-----------------------------------------------------------

local peds = {}
local shopPeds = {}
function CreatePeds()
	while true do
		Citizen.Wait(500)
		for k = 1, #Config.PedList, 1 do
			v = Config.PedList[k]
			local playerCoords = GetEntityCoords(PlayerPedId())
			local dist = #(playerCoords - v.coords)
			if dist < Config.Distance and not peds[k] then
				local ped = nearPed(v.model, v.coords, v.heading, v.gender, v.animDict, v.animName, v.scenario)
				peds[k] = {ped = ped}
			end
			if dist >= Config.Distance and peds[k] then
				if Config.Fade then
					for i = 255, 0, -51 do
						Citizen.Wait(50)
						SetEntityAlpha(peds[k].ped, i, false)
					end
				end
				DeletePed(peds[k].ped)
				peds[k] = nil
			end
		end
	end
end

function nearPed(model, coords, heading, gender, animDict, animName, scenario)
	RequestModel(GetHashKey(model))
	while not HasModelLoaded(GetHashKey(model)) do
		Citizen.Wait(1)
	end
	if gender == 'male' then
		genderNum = 4
	elseif gender == 'female' then 
		genderNum = 5
	else
		print("Gender not specified! Check your configuration!")
	end
	if Config.MinusOne then 
		local x, y, z = table.unpack(coords)
		ped = CreatePed(genderNum, GetHashKey(model), x, y, z - 1, heading, false, true)
		table.insert(shopPeds, ped)
	else
		ped = CreatePed(genderNum, GetHashKey(v.model), coords, heading, false, true)
		table.insert(shopPeds, ped)
	end
	SetEntityAlpha(ped, 0, false)
	if Config.Frozen then
		FreezeEntityPosition(ped, true) --Don't let the ped move.
	end
	if Config.Invincible then
		SetEntityInvincible(ped, true) --Don't let the ped die.
	end
	if Config.Stoic then
		SetBlockingOfNonTemporaryEvents(ped, true) --Don't let the ped react to his surroundings.
	end
	--Add an animation to the ped, if one exists.
	if animDict and animName then
		RequestAnimDict(animDict)
		while not HasAnimDictLoaded(animDict) do
			Citizen.Wait(1)
		end
		TaskPlayAnim(ped, animDict, animName, 8.0, 0, -1, 1, 0, 0, 0)
	end
	if scenario then
		TaskStartScenarioInPlace(ped, scenario, 0, true) -- begins peds animation
	end
	if Config.Fade then
		for i = 0, 255, 51 do
			Citizen.Wait(50)
			SetEntityAlpha(ped, i, false)
		end
	end
	return ped
end

-----------------------------------------------------------

function CreateProps()

	--Quickly add outside lighting
		if minelight1 == nil then
			RequestModel(GetHashKey("prop_worklight_03a"))
			Wait(100)
			local minelight1 = CreateObject(GetHashKey("prop_worklight_03a"),-593.29, 2093.22, 131.7-1.05,false,false,false)
			SetEntityHeading(minelight1,GetEntityHeading(minelight1)-80)
			FreezeEntityPosition(minelight1, true)
		end		
		if minelight2 == nil then
			RequestModel(GetHashKey("prop_worklight_03a"))
			Wait(100)
			local minelight2 = CreateObject(GetHashKey("prop_worklight_03a"),-604.55, 2089.74, 131.15-1.05,false,false,false)
			SetEntityHeading(minelight2,GetEntityHeading(minelight2)-260)
			FreezeEntityPosition(minelight2, true)
		end

	local prop = 0
	for k,v in pairs(Config.OrePositions) do
		prop = prop+1
		local prop = CreateObject(GetHashKey("cs_x_rubweec"),v.coords.x, v.coords.y, v.coords.z+1.03,false,false,false)
		SetEntityHeading(prop,GetEntityHeading(prop)-90)
		FreezeEntityPosition(prop, true)           
    end
	for k,v in pairs(Config.MineLights) do
		prop = prop+1
		local prop = CreateObject(GetHashKey("xs_prop_arena_lights_ceiling_l_c"),v.coords.x, v.coords.y, v.coords.z+1.03,false,false,false)
		--SetEntityHeading(prop,GetEntityHeading(prop)-90)
		FreezeEntityPosition(prop, true)           
    end
	--Jewel Cutting Bench
	local bench = CreateObject(GetHashKey("gr_prop_gr_bench_04b"),Config.Locations['JewelCut'].location,false,false,false)
	SetEntityHeading(bench,GetEntityHeading(bench)-Config.Locations['JewelCut'].heading)
	FreezeEntityPosition(bench, true)

	--Stone Cracking Bench
	local bench2 = CreateObject(GetHashKey("prop_tool_bench02"),Config.Locations['Cracking'].location,false,false,false)
	SetEntityHeading(bench2,GetEntityHeading(bench2)-Config.Locations['Cracking'].heading)
	FreezeEntityPosition(bench2, true)
	--Stone Prop for bench
	local bench2prop = CreateObject(GetHashKey("cs_x_rubweec"),Config.Locations['Cracking'].location.x, Config.Locations['Cracking'].location.y, Config.Locations['Cracking'].location.z+0.83,false,false,false)
	SetEntityHeading(bench2prop,GetEntityHeading(bench2prop)-Config.Locations['Cracking'].heading+90)
	FreezeEntityPosition(bench2prop, true)
	local bench2prop2 = CreateObject(GetHashKey("prop_worklight_03a"),Config.Locations['Cracking'].location.x-1.4, Config.Locations['Cracking'].location.y+1.08, Config.Locations['Cracking'].location.z,false,false,false)
	SetEntityHeading(bench2prop2,GetEntityHeading(bench2prop2)-Config.Locations['Cracking'].heading+180)
	FreezeEntityPosition(bench2prop2, true)
end

-----------------------------------------------------------

Citizen.CreateThread(function()
	exports['qb-target']:AddCircleZone("MineShaft", Config.Locations['Mine'].location, 2.0, { name="MineShaft", debugPoly=false, useZ=true, }, 
	{ options = { { event = "row-mining:openShop", icon = "fas fa-certificate", label = "browse store", }, },
		distance = 2.0
	})
	exports['qb-target']:AddCircleZone("Quarry", Config.Locations['Quarry'].location, 2.0, { name="Quarry", debugPoly=false, useZ=true, }, 
	{ options = { { event = "row-mining:openShop", icon = "fas fa-certificate", label = "browse store", }, },
		distance = 2.0
	})
	--Smelter to turn stone into ore
	exports['qb-target']:AddCircleZone("Smelter", Config.Locations['Smelter'].location, 3.0, { name="Smelter", debugPoly=false, useZ=true, }, 
	{ options = { { event = "row-mining:SmeltMenu", icon = "fas fa-certificate", label = "melt ore", }, },
		distance = 10.0
	})
	--Ore Buyer
	exports['qb-target']:AddCircleZone("Buyer", Config.Locations['Buyer'].location, 2.0, { name="Buyer", debugPoly=false, useZ=true, }, 
	{ options = { { event = "row-mining:SellOre", icon = "fas fa-certificate", label = "sell ore", },	},
		distance = 2.0
	})
	--Jewel Cutting Bench
	exports['qb-target']:AddCircleZone("JewelCut", Config.Locations['JewelCut'].location, 2.0, { name="JewelCut", debugPoly=false, useZ=true, }, 
	{ options = { { event = "row-mining:JewelCut", icon = "fas fa-certificate", label = "use jewelery cutting machine", },	},
		distance = 2.0
	})
	--Jewel Buyer
	exports['qb-target']:AddCircleZone("JewelBuyer", Config.Locations['Buyer2'].location, 2.0, { name="JewelBuyer", debugPoly=false, useZ=true, }, 
	{ options = { { event = "row-mining:JewelSell", icon = "fas fa-certificate", label = "talk to the jewelry buyer", },	},
		distance = 2.0
	})
	--Cracking Bench
	exports['qb-target']:AddCircleZone("CrackingBench", Config.Locations['Cracking'].location, 2.0, { name="CrackingBench", debugPoly=false, useZ=true, }, 
	{ options = { { event = "row-mining:CrackStart", icon = "fas fa-certificate", label = "Start Cracking", },	},
		distance = 2.0
	})
	local ore = 0
	for k,v in pairs(Config.OrePositions) do
		ore = ore+1
		exports['qb-target']:AddCircleZone(ore, v.coords, 2.0, { name=ore, debugPoly=false, useZ=true, }, 
		{ options = { { event = "row-mining:MineOre", icon = "fas fa-certificate", label = "collect stones", },	},
			distance = 2.5
		})
	end
end)

-----------------------------------------------------------
--Mining Store Opening
RegisterNetEvent('row-mining:openShop')
AddEventHandler('row-mining:openShop', function ()
	TriggerServerEvent("inventory:server:OpenInventory", "shop", "mine", Config.Items)
end)
------------------------------------------------------------
-- Mine Ore Command / Animations

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

RegisterNetEvent('row-mining:MineOre')
AddEventHandler('row-mining:MineOre', function ()
QBCore.Functions.TriggerCallback("QBCore:HasItem", function(item) 
		if item then 
			local pos = GetEntityCoords(PlayerPedId())
			loadAnimDict("anim@heists@fleeca_bank@drilling")
			TaskPlayAnim(PlayerPedId(), 'anim@heists@fleeca_bank@drilling', 'drill_straight_idle' , 3.0, 3.0, -1, 1, 0, false, false, false)
			local pos = GetEntityCoords(PlayerPedId(), true)
			local DrillObject = CreateObject(GetHashKey("hei_prop_heist_drill"), pos.x, pos.y, pos.z, true, true, true)
			AttachEntityToEntity(DrillObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.14, 0, -0.01, 90.0, -90.0, 180.0, true, true, false, true, 1, true)
			QBCore.Functions.Progressbar("open_locker_drill", "collecting stones", math.random(10000,15000), false, true, {
				disableMovement = true,	disableCarMovement = true, disableMouse = false, disableCombat = true, }, {}, {}, {}, function() -- Done
				StopAnimTask(PlayerPedId(), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
				DetachEntity(DrillObject, true, true)
				DeleteObject(DrillObject)
					TriggerServerEvent('row-mining:MineReward')
					IsDrilling = false
			end, function() -- Cancel
				StopAnimTask(PlayerPedId(), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
				DetachEntity(DrillObject, true, true)
				DeleteObject(DrillObject)
				IsDrilling = false
			end)
		else
			TriggerEvent('QBCore:Notify', "You don't have a drill!", 'error')
		end 
	end, "handdrill")
end)

------------------------------------------------------------

-- Cracking Command / Animations
-- Command Starts here where it calls to being the stone inv checking


RegisterNetEvent('row-mining:CrackStart')
AddEventHandler('row-mining:CrackStart', function ()
	QBCore.Functions.TriggerCallback("QBCore:HasItem", function(item) 
		if item then 
			local pos = GetEntityCoords(PlayerPedId())
			loadAnimDict('amb@prop_human_parking_meter@male@idle_a')
			TaskPlayAnim(PlayerPedId(), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a' , 3.0, 3.0, -1, 1, 0, false, false, false)
			QBCore.Functions.Progressbar("open_locker_drill", "the stone crumbles", math.random(10000,15000), false, true, {
				disableMovement = true,	disableCarMovement = true, disableMouse = false, disableCombat = true, }, {}, {}, {}, function() -- Done
				StopAnimTask(PlayerPedId(), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a', 1.0)
				TriggerServerEvent('row-mining:CrackReward')
				IsDrilling = false
			end, function() -- Cancel
				StopAnimTask(PlayerPedId(), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a', 1.0)
				IsDrilling = false
			end)
		else 
			TriggerEvent('QBCore:Notify', "There are no stones on it.", 'error')
		end 
	end, "stone")
end)

-- Cut Command / Animations
-- Requires a drill
RegisterNetEvent('row-mining:Cutting:Begin')
AddEventHandler('row-mining:Cutting:Begin', function (data)
	QBCore.Functions.TriggerCallback("row-mining:Cutting:Check:Tools",function(hasTools)
		if hasTools then
			QBCore.Functions.TriggerCallback("row-mining:Cutting:Check:"..data,function(hasReq) 
				if hasReq then 
					local pos = GetEntityCoords(PlayerPedId())
					loadAnimDict('amb@prop_human_parking_meter@male@idle_a')
					TaskPlayAnim(PlayerPedId(), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a' , 3.0, 3.0, -1, 1, 0, false, false, false)
					QBCore.Functions.Progressbar("open_locker_drill", "kesiliyor", math.random(10000,15000), false, true, {
						disableMovement = true, disableCarMovement = true,disableMouse = false,	disableCombat = true, }, {}, {}, {}, function() -- Done
						StopAnimTask(PlayerPedId(), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a', 1.0)
							TriggerServerEvent('row-mining:Cutting:Reward', data)
							IsDrilling = false
							if data >= 1 and data <= 4 then TriggerEvent('row-mining:JewelCut:Gem')
							elseif data >= 5 and data <= 9 then TriggerEvent('row-mining:JewelCut:Ring')
							elseif data >= 10 and data <= 15 then TriggerEvent('row-mining:JewelCut:Necklace') end
					end, function() -- Cancel
						StopAnimTask(PlayerPedId(), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a', 1.0)
						IsDrilling = false
						if data >= 1 and data <= 4 then TriggerEvent('row-mining:JewelCut:Gem')
						elseif data >= 5 and data <= 9 then TriggerEvent('row-mining:JewelCut:Ring')
						elseif data >= 10 and data <= 15 then TriggerEvent('row-mining:JewelCut:Necklace') end
					end)
				else
					TriggerEvent('QBCore:Notify', "You don't have all the ingredients!", 'error')
					if data >= 1 and data <= 4 then TriggerEvent('row-mining:JewelCut:Gem')
					elseif data >= 5 and data <= 9 then TriggerEvent('row-mining:JewelCut:Ring')
					elseif data >= 10 and data <= 15 then TriggerEvent('row-mining:JewelCut:Necklace') end
				end
			end)
		else
			TriggerEvent('QBCore:Notify', "You don't have a Hand Drill or Drill Bit", 'error')
			if data >= 1 and data <= 4 then TriggerEvent('row-mining:JewelCut:Gem')
			elseif data >= 5 and data <= 9 then TriggerEvent('row-mining:JewelCut:Ring')
			elseif data >= 10 and data <= 15 then TriggerEvent('row-mining:JewelCut:Necklace') end
		end
	end)
end)

-- I'm proud of this whole trigger command here
-- I was worried I'd have to do loads of call backs, back and forths in the this command
-- I had a theory that (like with notifications) I'd be able to add in a dynamic variable with the trigger being called
-- IT WORKED, and here we have it calling a item check callback via the ID it recieves from the menu buttons

-- Smelt Command / Animations
RegisterNetEvent('row-mining:Smelting:Begin')
AddEventHandler('row-mining:Smelting:Begin', function (data)
	QBCore.Functions.TriggerCallback("row-mining:Smelting:Check:"..data,function(hasReq) 
		if hasReq then 
			local pos = GetEntityCoords(PlayerPedId())
			loadAnimDict('amb@prop_human_parking_meter@male@idle_a')
			TaskPlayAnim(PlayerPedId(), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a' , 3.0, 3.0, -1, 1, 0, false, false, false)
			QBCore.Functions.Progressbar("open_locker_drill", "eritiliyor", math.random(5000,8000), false, true, {
				disableMovement = true, disableCarMovement = true,disableMouse = false,	disableCombat = true, }, {}, {}, {}, function() -- Done
				StopAnimTask(PlayerPedId(), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a', 1.0)
	
					TriggerServerEvent('row-mining:Smelting:Reward', data) -- When animations finished this is called and does the correct reward command via the ID it received from the menu
					TriggerEvent('row-mining:SmeltMenu')
					IsDrilling = false
			end, function() -- Cancel
				StopAnimTask(PlayerPedId(), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a', 1.0)
				IsDrilling = false
			end)
		else
			TriggerEvent('row-mining:SmeltMenu')
			TriggerEvent('QBCore:Notify', "You don't have all the ingredients!", 'error')
		end
	end)
end)


------------------------------------------------------------
--These also lead to the actual selling commands

--Selling animations are simply a pass item to seller animation
--Sell Ore Animation
--Sell Anim small Test
RegisterNetEvent('row-mining:SellAnim')
AddEventHandler('row-mining:SellAnim', function(data)
	if data == -2 then
		exports['qb-menu']:closeMenu()
		return
	end
	local pid = PlayerPedId()
	loadAnimDict("mp_common")
	TriggerServerEvent('row-mining:Selling', data) -- Had to slip in the sell command during the animation command
	for k,v in pairs (shopPeds) do
        pCoords = GetEntityCoords(PlayerPedId())
        ppCoords = GetEntityCoords(v)
		ppRot = GetEntityRotation(v)
        dist = #(pCoords - ppCoords)
        if dist < 2 then 
			TaskPlayAnim(pid, "mp_common", "givetake2_a", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
            TaskPlayAnim(v, "mp_common", "givetake2_a", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
            Wait(1500)
            StopAnimTask(pid, "mp_common", "givetake2_a", 1.0)
            StopAnimTask(v, "mp_common", "givetake2_a", 1.0)
            RemoveAnimDict("mp_common")
			SetEntityRotation(v, 0,0,ppRot.z,0,0,false)		
			break
		end
	end
	TriggerEvent('row-mining:SellOre')
end)


--Sell Anim small Test
RegisterNetEvent('row-mining:SellAnim:Jewel')
AddEventHandler('row-mining:SellAnim:Jewel', function(data)
	if data == -2 then
		exports['qb-menu']:closeMenu()
		return
	end	
	local pid = PlayerPedId()
	loadAnimDict("mp_common")
	TriggerServerEvent('row-mining:SellJewel', data) -- Had to slip in the sell command during the animation command
	for k,v in pairs (shopPeds) do
        pCoords = GetEntityCoords(PlayerPedId())
        ppCoords = GetEntityCoords(v)
		ppRot = GetEntityRotation(v)
        dist = #(pCoords - ppCoords)
        if dist < 2 then 
			TaskPlayAnim(pid, "mp_common", "givetake2_a", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
            TaskPlayAnim(v, "mp_common", "givetake2_a", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
            Wait(1500)
            StopAnimTask(pid, "mp_common", "givetake2_a", 1.0)
            StopAnimTask(v, "mp_common", "givetake2_a", 1.0)
            RemoveAnimDict("mp_common")
			SetEntityRotation(v, 0,0,ppRot.z,0,0,false)
			break
		end
	end	
	if string.find(data, "ring") then TriggerEvent('row-mining:JewelSell:Rings')
	elseif string.find(data, "chain") or string.find(data, "necklace") then TriggerEvent('row-mining:JewelSell:Necklace')
	elseif string.find(data, "emerald") then TriggerEvent('row-mining:JewelSell:Emerald')
	elseif string.find(data, "ruby") then TriggerEvent('row-mining:JewelSell:Ruby')
	elseif string.find(data, "diamond") then TriggerEvent('row-mining:JewelSell:Diamond')
	elseif string.find(data, "sapphire") then TriggerEvent('row-mining:JewelSell:Sapphire') end
end)


------------------------------------------------------------
--Context Menus
--Selling Ore
RegisterNetEvent('row-mining:SellOre', function()
	exports['qb-menu']:openMenu({
		{ header = "Sell ​​Ores", isMenuHeader = true },
		{ header = "", txt = "✘ Close", params = { event = "row-mining:SellAnim", args = -2 } },
		{ header = "Copper Ore", txt = "Sell ​​All. Piece Price: $"..Config.SellItems['copperore'], params = { event = "row-mining:SellAnim", args = 'copperore' } },
		{ header = "Iron", txt = "Sell ​​All. Piece Price: $"..Config.SellItems['ironore'], params = { event = "row-mining:SellAnim", args = 'ironore' } },
		{ header = "Gold", txt = "Sell ​​All. Piece Price: $"..Config.SellItems['goldore'], params = { event = "row-mining:SellAnim", args = 'goldore' } },
		{ header = "Carbon", txt = "Sell ​​All. Piece Price: $"..Config.SellItems['carbon'], params = { event = "row-mining:SellAnim", args = 'carbon' } }, 
	})
end)
------------------------
--Jewel Selling Main Menu
RegisterNetEvent('row-mining:JewelSell', function()
    exports['qb-menu']:openMenu({
		{ header = "Jewelry Buyer", txt = "Sell ​​your jewelry here", isMenuHeader = true }, 
		{ header = "", txt = "✘ Close", params = { event = "row-mining:SellAnim:Jewel", args = -2 } },
		{ header = "Emeralds", txt = "See all Emerald selling options", params = { event = "row-mining:JewelSell:Emerald", } },
		{ header = "Rubys", txt = "See all Ruby selling options", params = { event = "row-mining:JewelSell:Ruby", } },
		{ header = "Diamonds", txt = "See all Diamond selling options", params = { event = "row-mining:JewelSell:Diamond", } },
		{ header = "Sapphires", txt = "See all Sapphire selling options", params = { event = "row-mining:JewelSell:Sapphire", } },
		{ header = "Rings", txt = "See all Ring Options", params = { event = "row-mining:JewelSell:Rings", } },
		{ header = "Necklaces", txt = "See all Necklace Options", params = { event = "row-mining:JewelSell:Necklace", } },
	})
end)
--Jewel Selling - Emerald Menu
RegisterNetEvent('row-mining:JewelSell:Emerald', function()
    exports['qb-menu']:openMenu({
		{ header = "Jewelry Buyer", txt = "Sell ​​your jewelry here", isMenuHeader = true }, 
		{ header = "", txt = "⬅ Back", params = { event = "row-mining:JewelSell", } },
		{ header = "Emeralds", txt = "Sell ​​All. Piece Price: $"..Config.SellItems['emerald'], params = { event = "row-mining:SellAnim:Jewel", args = 'emerald' } },
		{ header = "Uncut Emeralds", txt = "Sell ​​All. Piece Price: $"..Config.SellItems['uncut_emerald'], params = { event = "row-mining:SellAnim:Jewel", args = 'uncut_emerald' } }, 
	})
end)
--Jewel Selling - Ruby Menu
RegisterNetEvent('row-mining:JewelSell:Ruby', function()
    exports['qb-menu']:openMenu({
		{ header = "Jewelry Buyer", txt = "Sell ​​your jewelry here", isMenuHeader = true }, 
		{ header = "", txt = "⬅ Back", params = { event = "row-mining:JewelSell", } },
		{ header = "Rubys", txt = "Sell ​​All. Piece Price: $"..Config.SellItems['ruby'], params = { event = "row-mining:SellAnim:Jewel", args = 'ruby' } },
		{ header = "Uncut Rubys", txt = "Sell ​​All. Piece Price: $"..Config.SellItems['uncut_ruby'], params = { event = "row-mining:SellAnim:Jewel", args = 'uncut_ruby' } },
	})
end)
--Jewel Selling - Diamonds Menu
RegisterNetEvent('row-mining:JewelSell:Diamond', function()
    exports['qb-menu']:openMenu({
		{ header = "Jewelry Buyer", txt = "Sell ​​your jewelry here", isMenuHeader = true }, 
		{ header = "", txt = "⬅ Back", params = { event = "row-mining:JewelSell", } },
		{ header = "Diamonds", txt = "Sell ​​All. Piece Price: $"..Config.SellItems['diamond'], params = { event = "row-mining:SellAnim:Jewel", args = 'diamond' } },
		{ header = "Uncut Diamonds", txt = "Sell ​​All. Piece Price: $"..Config.SellItems['uncut_diamond'], params = { event = "row-mining:SellAnim:Jewel", args = 'uncut_diamond' } },
	})
end)
--Jewel Selling - Sapphire Menu
RegisterNetEvent('row-mining:JewelSell:Sapphire', function()
    exports['qb-menu']:openMenu({
		{ header = "Jewelry Buyer", txt = "Sell ​​your jewelry here", isMenuHeader = true }, 
		{ header = "", txt = "⬅ Back", params = { event = "row-mining:JewelSell", } },
		{ header = "Sapphires", txt = "Sell ​​All. Piece Price: $"..Config.SellItems['sapphire'], params = { event = "row-mining:SellAnim:Jewel", args = 'sapphire' } },
		{ header = "Uncut Sapphires", txt = "Sell ​​All. Piece Price: $"..Config.SellItems['uncut_sapphire'], params = { event = "row-mining:SellAnim:Jewel", args = 'uncut_sapphire' } },
	})
end)

--Jewel Selling - Jewellry Menu
RegisterNetEvent('row-mining:JewelSell:Rings', function()
    exports['qb-menu']:openMenu({
		{ header = "Jewelry Buyer", txt = "Sell ​​your jewelry here", isMenuHeader = true }, 
		{ header = "", txt = "⬅ Back", params = { event = "row-mining:JewelSell", } },
		{ header = "Gold Rings", txt = "Sell ​​All. Piece Price: $"..Config.SellItems['gold_ring'], params = { event = "row-mining:SellAnim:Jewel", args = 'gold_ring' } },
		{ header = "Diamond Rings", txt = "Sell ​​All. Piece Price: $"..Config.SellItems['diamond_ring'], params = { event = "row-mining:SellAnim:Jewel", args = 'diamond_ring'} },
		{ header = "Emerald Rings", txt = "Sell ​​All. Piece Price: $"..Config.SellItems['emerald_ring'], params = { event = "row-mining:SellAnim:Jewel", args = 'emerald_ring' } },
		{ header = "Ruby Rings", txt = "Sell ​​All. Piece Price: $"..Config.SellItems['ruby_ring'], params = { event = "row-mining:SellAnim:Jewel", args = 'ruby_ring' } },	
		{ header = "Sapphire Rings", txt = "Sell ​​All. Piece Price: $"..Config.SellItems['sapphire_ring'], params = { event = "row-mining:SellAnim:Jewel", args = 'sapphire_ring' } },
	})
end)
--Jewel Selling - Jewellery Menu
RegisterNetEvent('row-mining:JewelSell:Necklace', function()
    exports['qb-menu']:openMenu({
		{ header = "Jewelry Buyer", txt = "Sell ​​your jewelry here", isMenuHeader = true }, 
		{ header = "", txt = "⬅ Back", params = { event = "row-mining:JewelSell", } },
		{ header = "Gold Chains",	txt = "Sell ​​All. Piece Price: $"..Config.SellItems['goldchain'], params = { event = "row-mining:SellAnim:Jewel", args = 'goldchain' } },
		{ header = "Gold Chains", txt = "Sell ​​All. Piece Price: $"..Config.SellItems['10kgoldchain'], params = { event = "row-mining:SellAnim:Jewel", args = '10kgoldchain' } },
		{ header = "Diamond Necklace", txt = "Sell ​​All. Piece Price: $"..Config.SellItems['diamond_necklace'], params = { event = "row-mining:SellAnim:Jewel", args = 'diamond_necklace' } },
		{ header = "Emerald Necklace", txt = "Sell ​​All. Piece Price: $"..Config.SellItems['emerald_necklace'], params = { event = "row-mining:SellAnim:Jewel", args = 'emerald_necklace' } },
		{ header = "Ruby Necklace", txt = "Sell ​​All. Piece Price: $"..Config.SellItems['ruby_necklace'], params = { event = "row-mining:SellAnim:Jewel", args = 'ruby_necklace' } },	
		{ header = "Sapphire Necklace", txt = "Sell ​​All. Piece Price: $"..Config.SellItems['sapphire_necklace'], params = { event = "row-mining:SellAnim:Jewel", args = 'sapphire_necklace' } },
	})
end)
------------------------

--Smelting
RegisterNetEvent('row-mining:SmeltMenu', function()
    exports['qb-menu']:openMenu({
	{ header = "Ore Melt", isMenuHeader = true }, 
	{ header = "", txt = "✘ Close", params = { event = "row-mining:SellAnim", args = -2 } },
	{ header = QBCore.Shared.Items["copper"].label, txt = "1x "..QBCore.Shared.Items["copperore"].label, params = { event = "row-mining:Smelting:Begin", args = 1 } },
	{ header = QBCore.Shared.Items["goldbar"].label, txt = "4x "..QBCore.Shared.Items["goldore"].label, params = { event = "row-mining:Smelting:Begin", args = 2 } },
	{ header = QBCore.Shared.Items["iron"].label, txt = "1x "..QBCore.Shared.Items["ironore"].label, params = { event = "row-mining:Smelting:Begin", args = 3 } },
	{ header = QBCore.Shared.Items["steel"].label, txt = "1x "..QBCore.Shared.Items["ironore"].label.."<br>1x "..QBCore.Shared.Items["carbon"].label, params = { event = "row-mining:Smelting:Begin", args = 4 } },
	--{ header = "Melt Bottle", txt = "Melt down a glass bottle", params = { event = "row-mining:Smelting:Begin", args = 5 } },
	--{ header = "Melt Can", txt = "Melt down an empty can", params = { event = "row-mining:Smelting:Begin", args = 6 } },
	})
end)


------------------------

--Cutting Jewels
RegisterNetEvent('row-mining:JewelCut', function()
    exports['qb-menu']:openMenu({
	{ header = "Jewelry Making Machine", txt = "Requires Hand Drill and Drill Bit", isMenuHeader = true },
	{ header = "", txt = "✘ Close", params = { event = "row-mining:SellAnim", args = -2 } },
	{ header = "Go to Cutting Section", params = { event = "row-mining:JewelCut:Gem", } },
	{ header = "Go to Ring Section", params = { event = "row-mining:JewelCut:Ring", } },
	{ header = "Go to Necklace Section", params = { event = "row-mining:JewelCut:Necklace", } },
	})
end)
--Gem Section
RegisterNetEvent('row-mining:JewelCut:Gem', function()
    exports['qb-menu']:openMenu({
	{ header = "Jewelry Making Machine", txt = "Requires Hand Drill and Drill Bit", isMenuHeader = true },
	{ header = "", txt = "⬅ Back", params = { event = "row-mining:JewelCut", } },
	{ header = "Emerald", params = { event = "row-mining:Cutting:Begin", args = 1 } },
	{ header = "Ruby", params = { event = "row-mining:Cutting:Begin", args = 2 } },
	{ header = "Diamond", params = { event = "row-mining:Cutting:Begin", args = 3 } },
	{ header = "Sapphire", params = { event = "row-mining:Cutting:Begin", args = 4 } },
	})
end)
-- Ring Section
RegisterNetEvent('row-mining:JewelCut:Ring', function()
    exports['qb-menu']:openMenu({
	{ header = "Jewelry Making Machine", txt = "Requires Hand Drill and Drill Bit", isMenuHeader = true },
	{ header = "", txt = "⬅ Back", params = { event = "row-mining:JewelCut", } },
	{ header = "Gold Ring x3", txt = "Requires 1 Gold Ingot", params = { event = "row-mining:Cutting:Begin", args = 5 } },
	{ header = "Diamond Ring", txt = "Requires 1 Gold Ring and 1 diamond", params = { event = "row-mining:Cutting:Begin", args = 6 } },
	{ header = "Emerald Ring", txt = "Requires 1 Gold Ring and 1 Emerald", params = { event = "row-mining:Cutting:Begin", args = 7 } },
	{ header = "Ruby Ring", txt = "Requires 1 Gold Ring and 1 Ruby", params = { event = "row-mining:Cutting:Begin", args = 8 } },
	{ header = "Sapphire Necklace", txt = "Requires 1 Gold Ring and 1 Sapphire", params = { event = "row-mining:Cutting:Begin", args = 9 } },
	})
end)
--Necklace Section
RegisterNetEvent('row-mining:JewelCut:Necklace', function()
    exports['qb-menu']:openMenu({
	{ header = "Jewelry Making Machine", txt = "Requires Hand Drill and Drill Bit", isMenuHeader = true },
	{ header = "", txt = "⬅ Back", params = { event = "row-mining:JewelCut", } },
	{ header = "Gold Ring x3", txt = "Requires 1 Gold Ingot", params = { event = "row-mining:Cutting:Begin", args = 10 } },
	{ header = "10k Gold Chain x2", txt = "Requires 1 Gold Ingot", params = { event = "row-mining:Cutting:Begin", args = 11 } },
	{ header = "Diamond Necklace", txt = "Requires 1 Gold Chain and 1 Diamond", params = { event = "row-mining:Cutting:Begin", args = 12 } },
	{ header = "Emerald Necklace", txt = "Requires 1 Gold Chain and 1 Emerald", params = { event = "row-mining:Cutting:Begin", args = 13 } },
	{ header = "Ruby Necklace", txt = "Requires 1 Gold Chain and 1 Ruby", params = { event = "row-mining:Cutting:Begin", args = 14 } },
	{ header = "Sapphire Necklace", txt = "Requires 1 Gold Chain and 1 Sapphire", params = { event = "row-mining:Cutting:Begin", args = 15 } }, 
	})
end)
