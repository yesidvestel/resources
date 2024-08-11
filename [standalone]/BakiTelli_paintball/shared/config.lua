Config = {}

Config.Mysql = "oxmysql" -- oxmysql , mysql-async , ghmattimysql
Config.Distance = 5 -- Where to access the menu
Config.Namep = "VRQB" -- LobbyName Prefix
Config.NameNumber = 4 -- How many characters
Config.LobbyCoolDown = 10000 -- Lobby Spawn Cool Down 
Config.apikey = "233DE5CB2B05F75967635256BBE7E894" --  https://steamcommunity.com/dev/apikey
Config.Weapon = "WEAPON_PAINTBALL" -- Weapon code
Config.GameFinishRevive = true -- Finish Game Revive ?
Config.Markers = {
	PaintBall = {
		Type = 21,
		Size = {
			x = 1.0,
			y = 1.0,
			z = 0.5,
		},
		Color = {
			r = 200,
			g = 51,
			b = 51,
		},
	},
}

Config.Blips = {
    Blips = true,
    PaintBall = {
		Sprite = 160,
		Scale = 0.7,
		Colour = 1,
    }
}

Config.Maps = {
	{
		MapName = "Sobre las nubes",
		information = "Un área sobre las nubes donde puedes luchar usando paredes.",
		map_img = "https://cdn.discordapp.com/attachments/996543951236509788/1116075861729349652/image.png",
		red =  {
			[1] = vector4(3234.811, -125.9215, 1388.109, 186.8525),
			[2] = vector4(3231.894, -126.0005, 1388.109, 182.7994),
			[3] = vector4(3229.04, -126.0167, 1388.109, 185.5305),
			[4] = vector4(3214.663, -125.7718, 1388.109, 192.0256),
			[5] = vector4(3208.985, -125.8526, 1388.109, 195.9801),
		},
		blue = {
			[1] = vector4(3234.788, -171.9013, 1388.109, 355.6349),
			[2] = vector4(3231.819, -172.1867, 1388.109, 359.0597),
			[3] = vector4(3229.26, -172.3242, 1388.109, 5.017426),
			[4] = vector4(3214.897, -172.4576, 1388.109, 356.0765),
			[5] = vector4(3209.153, -172.3117, 1388.109, 20.60857),
		}
	},
	{
		MapName = "Mapa de lucha de Lego",
		information = "Este mapa es un espacio hecho al estilo lego que a mucha gente le encanta.",
		map_img = "https://cdn.discordapp.com/attachments/996543951236509788/1116955849643020298/image.png",
		red =  {
			[1] = vector4(-3732.24, -2984.88, 541.92, 184.52),
			[2] = vector4(-3735.76, -2984.48, 541.92, 185.52),
			[3] = vector4(-3740.6, -2984.48, 541.92, 180.52),
			[4] = vector4(-3745.6, -2984.72, 541.92, 186.96),
			[5] = vector4(-3750.12, -2985.24, 541.92, 184.0),
		},
		blue = {
			[1] = vector4(-3748.24, -3021.08, 541.92, 1.64),
			[2] = vector4(-3748.24, -3021.08, 541.92, 1.64),
			[3] = vector4(-3748.24, -3021.08, 541.92, 1.64),
			[4] = vector4(-3748.24, -3021.08, 541.92, 1.64),
			[5] = vector4(-3731.28, -3020.36, 541.92, 1.36),
		}
	},
	{
		MapName = "Almacén de transporte",
		information = "El escondite del espacio estrecho es un mapa que contiene hermosas paredes de lugares..",
		map_img = "https://cdn.discordapp.com/attachments/996543951236509788/1115837749400969226/image.png",
		red =  {
			[1] = vector4(-36.48768, -1140.328, -2.30642, 75.48946),
			[2] = vector4(-36.27711, -1138.796, -2.30642, 77.53115),
			[3] = vector4(-35.89815, -1137.546, -2.30642, 68.69373),
			[4] = vector4(-35.07166, -1136.23, -2.30642, 75.48691),
			[5] = vector4(-34.7529, -1135.046, -2.30642, 68.26452),
		},
		blue = {
			[1] = vector4(-65.59706, -1119.177, -2.30642, 252.2849),
			[2] = vector4(-66.2309, -1120.808, -2.30642, 252.2012),
			[3] = vector4(-66.6067, -1122.751, -2.30642, 258.0199),
			[4] = vector4(-67.78556, -1126.407, -2.30642, 251.9601),
			[5] = vector4(-68.61132, -1128.636, -2.30642, 250.364),
		}
	},
}

Config.PaintballArea = {
	{
		AreaCoord = vector3(501.507, -1637.723, 29.27)
	},
}

Config.Langs = {
	OpenMenu = "[E] - Abrir menú PaintBall",
	BlipName = "Arena de paintball",
	LobbyCoolDown = "No puedes hacer lobby tan rápido, espera."
}