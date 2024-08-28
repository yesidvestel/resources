Config = {

/*BlipSprite = 237,
BlipColor = 26,
BlipText = 'Crafteo',*/


CraftingStopWithDistance = false, -- Crafting will stop when not near workbench

ExperiancePerCraft = 5, -- The amount of experiance added per craft (100 Experiance is 1 level)

HideWhenCantCraft = false, -- Instead of lowering the opacity it hides the item that is not craftable due to low level or wrong job

Categories = {
	['misc'] = {
		Label = 'Misceláneos',
		Image = 'fishingrod',
		Jobs = {}
	},
	['weapons'] = {
		Label = 'Armas',
		Image = 'WEAPON_APPISTOL',
		Jobs = {}
	}
	/*['medical'] = {
		Label = 'Primeros auxilios',
		Image = 'bandage',
		Jobs = {}
	}*/
},

PermanentItems = { -- Items that dont get removed when crafting
	['wrench'] = true
},

Recipes = { -- Enter Item name and then the speed value! The higher the value the more torque

	/*['bandage'] = {
		Level = 0, -- From what level this item will be craftable
		Category = 'medical', -- The category item will be put in
		isGun = false, -- Specify if this is a gun so it will be added to the loadout
		Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
		JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
		Amount = 2, -- The amount that will be crafted
		SuccessRate = 100, -- 100% you will recieve the item
		requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
		Time = 10, -- Time in seconds it takes to craft this item
		Ingredients = { -- Ingredients needed to craft this item
			['clothe'] = 2, -- item name and count, adding items that dont exist in database will crash the script
			['wood'] = 1
		}
	}, */

	['weapon_appistol'] = {
		Level = 2, -- From what level this item will be craftable
		Category = 'weapons', -- The category item will be put in
		isGun = true, -- Specify if this is a gun so it will be added to the loadout
		Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
		JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
		Amount = 1, -- The amount that will be crafted
		SuccessRate = 100, --  100% you will recieve the item
		requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
		Time = 20, -- Time in seconds it takes to craft this item
		Ingredients = { -- Ingredients needed to craft this item
			['copper'] = 5, -- item name and count, adding items that dont exist in database will crash the script
			['wood'] = 3,
			['iron'] = 5
		}
	}, 
},

Workbenches = { -- Every workbench location, leave {} for jobs if you want everybody to access

	{coords = vector3(101.4088, 6616.1929, 32.4353), jobs = {}, gangs = {}, blip = true, recipes = {}, radius = 3.0 }

},

Text = {
	
	['not_enough_ingredients'] = 'No tienes suficientes ingredientes',
	['you_cant_hold_item'] = 'No puedes retener el artículo',
	['item_crafted'] = '¡Artículo elaborado!',
	['wrong_job'] = 'No puedes abrir este banco de trabajo',
	['workbench_hologram'] = '[~b~E~w~] Banco de trabajo',
	['wrong_usage'] = 'Uso incorrecto del comando',
	['inv_limit_exceed'] = '¡Se superó el límite de inventario! Limpia antes de perder más',
	['crafting_failed'] = '¡No pudiste crear el artículo!'

	}
}

function SendTextMessage(msg)

	SetNotificationTextEntry('STRING')
	AddTextComponentString(msg)
	DrawNotification(0,1)

	--EXAMPLE USED IN VIDEO
	--exports['mythic_notify']:SendAlert('inform', msg)
end