Config.Holster = true -- Enable holster system
Config.AllowedHolster = {
	"police", "sheriff"
}

Config.WeaponCategoryOffsets = {
	{category = 'handguns', bone = 11816, x = -0.01, y = -0.023, z = 0.22,  xRot = -90.0, yRot = 5.0,  zRot = -8.0},
	{category = 'waisthandgun', bone = 11816, x = -0.04, y = -0.015, z = 0.20,  xRot = -90.0, yRot = 17.0,  zRot = -13.0},
	{category = 'hiphandgun', bone = 51826, x = 0.05, y = -0.013, z = 0.12,  xRot = 275.0, yRot = 170.0,  zRot = -180.0},
	--{category = 'handguns', bone = 6442, x = 0.05, y = -0.03, z = 0.12,  xRot = -110.0, yRot = -15.0,  zRot = -10.0},
	{category = 'boxers', bone = 11816, x = -0.03, y = 0.11, z = -0.07,  xRot = -210.0, yRot = 5.0,  zRot = -10.0},
	{category = 'revolver', bone = 11816, x = -0.08, y = 0.019, z = 0.22,  xRot = -90.0, yRot = 5.0,  zRot = -15.0},
	{category = 'bighandgun', bone = 11816, x = -0.04, y = 0.019, z = 0.22,  xRot = -90.0, yRot = 5.0,  zRot = -15.0},
	{category = 'utilityhandgun', bone = 11816, x = -0.12, y = 0.09,  z = -0.17, xRot = 135.0,  yRot = -13.50, zRot = -9.5},
	{category = 'smallmelee', bone = 11816, x = -0.15, y = -0.11, z = 0.17, xRot = 120.0, yRot = 90.0, zRot = 0.0},
	{category = 'bigmelee', bone = 11816, x = -0.15, y = -0.04, z = 0.20, xRot = 270.0, yRot = 90.0, zRot = 0.0},
	{category = 'utilitymelee', bone = 58271, x = 0.1, y = 0.1,  z = -0.15, xRot = -90.0,  yRot = 0.90, zRot = 90.0},
	{category = 'machine', bone = 24818, x = 0.09, y = -0.15, z = 0.1, xRot = 10.0, yRot = 160.0, zRot = 10.0},
	{category = 'assault', bone = 24818, x = 0.09, y = -0.15, z = 0.1, xRot = 10.0, yRot = 160.0, zRot = 10.0},
	{category = 'shotgun', bone = 24818, x = 0.09, y = -0.15, z = 0.1, xRot = 10.0, yRot = 160.0, zRot = 10.0},
	{category = 'sniper', bone = 24818, x = 0.09, y = -0.15, z = 0.1, xRot = 10.0, yRot = 160.0, zRot = 10.0},
	{category = 'heavy', bone = 24818, x = 0.09, y = -0.15, z = 0.1, xRot = 10.0, yRot = 160.0, zRot = 10.0},
	{category = 'bat', bone = 24816, x = 0.05, y = -0.15, z = 0.02, xRot = 0.0, yRot = 110.0, zRot = 0.0},
	
	-- • Rifles tácticos, por delante del chaleco.
	{category = 'tacticalrifle', bone = 24818, x = 0.01, y = 0.22, z = 0.1, xRot = 200.0, yRot = 170.0, zRot = 10.0},
	-- • Pistolas detrás.
	{category = 'backhandgun', bone = 24816, x = -0.05, y = -0.15, z = -0.03, xRot = 180.0, yRot = 145.0, zRot = 0.0},
	-- • Pistolas en la cadena
	{category = 'leghandgun', bone = 51826, x = 0.175, y = 0.02, z = 0.134,  xRot = -100.0, yRot = -0.0,  zRot = -13.0},
	-- Cartuchera de pecho 
	{category = 'chesthandgun', bone = 24818, x = -0.0455, y = 0.040, z = 0.21, xRot = 262.0, yRot = 110.0, zRot = 5.0},
	-- • Pistolas en la cadena
	{category = 'handguns2', bone = 51826, x = 0.07, y = 0.030, z = 0.156,  xRot = -105.0, yRot = -0.0,  zRot = -13.1},
}

Config.RealWeapons = {

	{name = 'WEAPON_KNIFE', 			category = 'smallmelee', 	model = 'prop_w_me_knife_01', canHide = true},
	--{name = 'WEAPON_NIGHTSTICK', 		category = 'utilitymelee', 	model = 'w_me_nightstick', canHide = true},
	{name = 'WEAPON_HAMMER', 			category = 'utilitymelee',	model = 'prop_tool_hammer', canHide = true},
	{name = 'WEAPON_BAT', 				category = 'bat', 			model = 'WEAPON_BAT', canHide = false},
	{name = 'WEAPON_GOLFCLUB', 			category = 'bigmelee', 		model = 'w_me_gclub', canHide = false},
	{name = 'WEAPON_CROWBAR', 			category = 'utilitymelee', 	model = 'w_me_crowbar', canHide = false},
	{name = 'WEAPON_BOTTLE', 			category = 'smallmelee', 	model = 'prop_w_me_bottle', canHide = true},
	--{name = 'WEAPON_KNUCKLE', 		category = 'melee', 		model = 'prop_w_me_dagger', canHide = true},
	{name = 'WEAPON_HATCHET', 			category = 'bigmelee', 		model = 'w_me_hatchet', canHide = false},
	{name = 'WEAPON_BATTLEAXE', 		category = 'bigmelee', 		model = 'w_me_battleaxe', canHide = false},
	{name = 'WEAPON_STONE_HATCHET', 	category = 'bigmelee', 		model = 'w_me_stonehatchet', canHide = false},
	{name = 'WEAPON_MACHETE', 			category = 'bigmelee', 		model = 'prop_ld_w_me_machette', canHide = false},
	--{name = 'WEAPON_SWITCHBLADE', 	category = 'melee', 		model = 'w_me_switchblade'},
	{name = 'WEAPON_FLASHLIGHT', 		category = 'utilitymelee', 	model = nil, canHide = true},

	{name = 'WEAPON_PISTOL', 			category = 'handguns', 		model = 'w_pi_pistol', canHide = true},
	{name = 'WEAPON_COMBATPISTOL', 		category = 'handguns', 		model = 'w_pi_combatpistol', canHide = true},
	{name = 'WEAPON_APPISTOL', 			category = 'handguns', 		model = 'w_pi_appistol', canHide = true},
	{name = 'WEAPON_PISTOL50', 			category = 'bighandgun', 	model = 'w_pi_pistol50', canHide = true},
	{name = 'WEAPON_VINTAGEPISTOL', 	category = 'handguns', 		model = 'w_pi_vintage_pistol', canHide = true},
	{name = 'WEAPON_HEAVYPISTOL', 		category = 'handguns', 		model = 'w_pi_heavypistol', canHide = true},
	{name = 'WEAPON_SNSPISTOL', 		category = 'handguns', 		model = 'w_pi_sns_pistol', canHide = true},
	{name = 'WEAPON_FLAREGUN', 			category = 'utilityhandgun',model = 'w_pi_flaregun', canHide = true},
	{name = 'WEAPON_MARKSMANPISTOL', 	category = 'handguns', 		model = 'w_pi_singleshot', canHide = true},
	{name = 'WEAPON_CERAMICPISTOL', 	category = 'handguns', 		model = 'w_pi_ceramic_pistol', canHide = true},
	{name = 'WEAPON_REVOLVER', 			category = 'revolver', 		model = 'w_pi_revolver', canHide = true},
	{name = 'WEAPON_STUNGUN', 			category = 'handguns',		model =  nil, 	canHide = true},
	{name = 'WEAPON_DOUBLEACTION', 		category = 'revolver', 		model = 'w_pi_wep1_gun', canHide = true},

	{name = 'WEAPON_MICROSMG', 			category = 'machine', 	model = 'w_sb_microsmg', canHide = false},
	{name = 'WEAPON_SMG', 				category = 'machine', 	model = 'w_sb_smg', canHide = false},
	{name = 'WEAPON_MG', 				category = 'machine', 	model = 'w_mg_mg', canHide = false},
	{name = 'WEAPON_COMBATMG', 			category = 'machine', 	model = 'w_mg_combatmg', canHide = false},
	{name = 'WEAPON_GUSENBERG', 		category = 'machine', 	model = 'w_sb_gusenberg', canHide = false},
	{name = 'WEAPON_COMBATPDW', 		category = 'machine', 	model = 'w_sb_pdw', canHide = false},
	{name = 'WEAPON_MACHINEPISTOL', 	category = 'machine', 	model = 'w_sb_compactsmg', canHide = false},
	{name = 'WEAPON_ASSAULTSMG', 		category = 'machine', 	model = 'w_sb_assaultsmg', canHide = false},
	{name = 'WEAPON_MINISMG', 			category = 'machine', 	model = 'w_sb_minismg', canHide = false},

	{name = 'WEAPON_ASSAULTRIFLE', 		category = 'assault', 	model = 'w_ar_assaultrifle', canHide = false}, 
	{name = 'WEAPON_CARBINERIFLE', 		category = 'assault', 	model = 'w_ar_carbinerifle', canHide = false},
	{name = 'WEAPON_ADVANCEDRIFLE', 	category = 'assault', 	model = 'w_ar_advancedrifle', canHide = false},
	{name = 'WEAPON_SPECIALCARBINE', 	category = 'assault', 	model = 'w_ar_specialcarbine', canHide = false},
	{name = 'WEAPON_BULLPUPRIFLE', 		category = 'assault', 	model = 'w_ar_bullpuprifle', canHide = false},
	{name = 'WEAPON_COMPACTRIFLE', 		category = 'assault', 	model = 'w_ar_assaultrifle_smg', canHide = false},

	{name = 'WEAPON_PUMPSHOTGUN', 		category = 'shotgun', 	model = 'w_sg_pumpshotgun', canHide = false},
	{name = 'WEAPON_SAWNOFFSHOTGUN', 	category = 'shotgun', 	model = 'w_sg_sawnoff', canHide = false},
	{name = 'WEAPON_BULLPUPSHOTGUN', 	category = 'shotgun', 	model = 'w_sg_bullpupshotgun', canHide = false},
	{name = 'WEAPON_ASSAULTSHOTGUN', 	category = 'shotgun', 	model = 'w_sg_assaultshotgun', canHide = false},
	{name = 'WEAPON_MUSKET', 			category = 'shotgun', 	model = 'w_ar_musket', canHide = false},
	{name = 'WEAPON_HEAVYSHOTGUN', 		category = 'shotgun', 	model = 'w_sg_heavyshotgun', canHide = false},
	{name = 'WEAPON_DBSHOTGUN', 		category = 'shotgun', 	model = 'w_sg_doublebarrel', canHide = false},
	{name = 'WEAPON_AUTOSHOTGUN', 		category = 'shotgun', 	model = 'w_sg_sweeper', canHide = false},

	{name = 'WEAPON_SNIPERRIFLE', 		category = 'sniper', 	model = 'w_sr_sniperrifle', canHide = false},
	{name = 'WEAPON_HEAVYSNIPER', 		category = 'sniper', 	model = 'w_sr_heavysniper', canHide = false},
	{name = 'WEAPON_MARKSMANRIFLE', 	category = 'sniper', 	model = 'w_sr_marksmanrifle', canHide = false},

	--{name = 'WEAPON_REMOTESNIPER', 		category = 'none', 		model = ''},
	--{name = 'WEAPON_STINGER', 			category = 'none', 		model = ''},

	{name = 'WEAPON_GRENADELAUNCHER', 	category = 'heavy', 		model = 'w_lr_grenadelauncher', canHide = false},
	{name = 'WEAPON_RPG', 				category = 'heavy', 		model = 'w_lr_rpg', canHide = false},
	{name = 'WEAPON_MINIGUN', 			category = 'heavy', 		model = 'w_mg_minigun', canHide = false},
	{name = 'WEAPON_FIREWORK', 			category = 'heavy', 		model = 'w_lr_firework', canHide = false},
	{name = 'WEAPON_RAILGUN', 			category = 'heavy', 		model = 'w_ar_railgun', canHide = false},
	{name = 'WEAPON_HOMINGLAUNCHER', 	category = 'heavy', 		model = 'w_lr_homing', canHide = false},
	{name = 'WEAPON_COMPACTLAUNCHER', 	category = 'heavy', 		model = '', canHide = false},

	{name = 'WEAPON_STICKYBOMB', 		category = 'thrown', 	model = nil, canHide = true},
	{name = 'WEAPON_MOLOTOV', 			category = 'thrown', 	model = nil, canHide = true},
	{name = 'WEAPON_FIREEXTINGUISHER', 	category = 'thrown', 	model = nil, canHide = true},
	{name = 'WEAPON_PETROLCAN', 		category = 'thrown', 	model = nil, canHide = true},
	{name = 'WEAPON_PROXMINE', 			category = 'thrown', 	model = nil, canHide = true},
	{name = 'WEAPON_SNOWBALL', 			category = 'thrown', 	model = nil, canHide = true},
	{name = 'WEAPON_BALL', 				category = 'thrown', 	model = nil, canHide = true},
	{name = 'WEAPON_GRENADE', 			category = 'thrown', 	model = nil, canHide = true},
	{name = 'WEAPON_SMOKEGRENADE', 		category = 'thrown', 	model = nil, canHide = true},
	{name = 'WEAPON_BZGAS', 			category = 'thrown', 	model = nil, canHide = true},

	--{name = 'WEAPON_DIGISCANNER', 		category = 'others', 	model = 'w_am_digiscanner'},
	{name = 'WEAPON_DAGGER', 			category = 'smallemelee', 	model = 'prop_w_me_dagger', canHide = true},
	--{name = 'WEAPON_GARBAGEBAG', 		category = 'others', 	model = ''},
	--{name = 'WEAPON_HANDCUFFS', 		category = 'others', 	model = ''},
	{name = 'WEAPON_BATTLEAXE', 		category = 'bigmelee', 	model = 'prop_tool_fireaxe', canHide = false},
	--{name = 'WEAPON_PIPEBOMB', 			category = 'others', 	model = ''},
	--{name = 'WEAPON_POOLCUE', 			category = 'others', 	model = 'prop_pool_cue'},
	{name = 'WEAPON_WRENCH', 			category = 'bigmelee', 	model = 'w_me_hammer', canHide = false},
	--{name = 'GADGET_NIGHTVISION', 		category = 'others', 	model = ''},
	--{name = 'GADGET_PARACHUTE', 		bone = 24818, x = 0.05, y = -0.15, z = 0.02, xRot = 180.0, yRot = 90.0, zRot = 0.0, category = 'others', 	model = 'p_parachute_s'},

	{name = 'WEAPON_PISTOL_MK2', 		category = 'handguns', 		model = 'w_pi_pistolmk2', canHide = true},
	{name = 'WEAPON_SNSPISTOL_MK2', 	category = 'handguns', 		model = 'w_pi_sns_pistolmk2', canHide = true},
	{name = 'WEAPON_REVOLVER_MK2', 		category = 'handguns', 		model = 'w_pi_revolvermk2', canHide = true},
	{name = 'WEAPON_SMG_MK2', 			category = 'machine', 		model = 'w_sb_smgmk2', canHide = false},
	{name = 'WEAPON_PUMPSHOTGUN_MK2', 	category = 'shotgun', 		model = 'w_sg_pumpshotgunmk2', canHide = false},
	{name = 'WEAPON_ASSAULTRIFLE_MK2', 	category = 'assault', 		model = 'w_ar_assaultriflemk2', canHide = false},
	{name = 'WEAPON_CARBINERIFLE_MK2', 	category = 'assault', 		model = 'w_ar_carbineriflemk2', canHide = false},
	{name = 'WEAPON_SPECIALCARBINE_MK2',category = 'assault', 		model = 'w_ar_specialcarbinemk2', canHide = false},
	{name = 'WEAPON_BULLPUPRIFLE_MK2', 	category = 'assault', 		model = 'w_ar_bullpupriflemk2', canHide = false},
	{name = 'WEAPON_COMBATMG_MK2', 		category = 'machine', 		model = 'w_mg_combatmgmk2', canHide = false},
	{name = 'WEAPON_HEAVYSNIPER_MK2', 	category = 'sniper', 		model = 'w_sr_heavysnipermk2', canHide = false},
	{name = 'WEAPON_MARKSMANRIFLE_MK2', category = 'sniper', 		model = 'w_sr_marksmanriflemk2', canHide = false},
	{name = 'WEAPON_MILITARYRIFLE', 	category = 'assault', 		model = 'WEAPON_MILITARYRIFLE', canHide = false},
	{name = 'WEAPON_COMBATSHOTGUN', 	category = 'shotgun', 		model = 'WEAPON_COMBATSHOTGUN', canHide = false},
	{name = 'WEAPON_GADGETPISTOL', 		category = 'revolver',      model = 'WEAPON_GADGETPISTOL', canHide = true},
}

Config.AnimationSpeed = {
	["backhandgun"] = {
		animSpeed = 0.325,
		clearAnimWait = 700
	},
	["boxers"] = {
		animSpeed = 0.325,
		clearAnimWait = 700
	},
	["chesthandgun"] = {
		animSpeed = 0.325,
		clearAnimWait = 700
	},
	["leghandgun"] = {
		animSpeed = 0.325,
		clearAnimWait = 700
	},
	["tacticalrifle"] = {
		animSpeed = 0.325,
		clearAnimWait = 700
	},
}