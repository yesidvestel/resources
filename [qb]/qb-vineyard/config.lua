Config = {
	Debug = false,
	PickAmount = {min = 8, max = 12},
	GrapeAmount = {min = 8, max = 12},
	GrapeJuiceAmount = {min = 6, max = 10},
	WineAmount = {min = 6, max = 10},
	wineTimer = 50,
	Routes = {
		[1] = {
			DeliveryCoords = vector3(193.24, 103.58, 93.54),
			Heading = 307.14
		},
		[2] = {
			DeliveryCoords = vector3(-413.65, 220.61, 83.43),
			Heading = 314.8
		},
		[3] = {
			DeliveryCoords = vector3(-1213.52, -406.82, 34.14),
			Heading = 210.1
		},
		[4] = {
			DeliveryCoords = vector3(-1213.49, -406.76, 34.14),
			Heading = 210.1
		},
		[5] = {
			DeliveryCoords = vector3(63.66, -1728.99, 29.64),
			Heading = 40.26
		},
	},
	RoutesBlipConfig = {
		BlipSprite = 274,
		BlipDisplay = 3,
		BlipScale = 0.6,
		BlipColour = 59,
		BlipName = "Dealer Destination",
	},
	EnabledBlip = {
		BlipSprite = 615,
		BlipDisplay = 4,
		BlipScale = 0.6,
		BlipColour = 58,
		BlipName = "Vineyard",
	},
	Vineyard = {
		start ={
			coords = vector3(-1927.5, 2061.69, 140.84),
			zones = {
				vector2(-1926.19, 2059.13),
				vector2(-1925.46, 2062.16),
				vector2(-1930.47, 2063.81),
				vector2(-1931.35, 2060.37),
			},
			minZ=140.24,
			maxZ=141.44
		},
		wine ={
			coords = vector3(-1879.54, 2062.55, 135.92),
			zones = {
				vector2(-1873.85, 2063.01),
				vector2(-1876.35, 2059.48),
				vector2(-1883.02, 2062.11),
				vector2(-1882.03, 2064.85),
				vector2(-1880.51, 2065.44)
			},
			minZ=135.42,
			maxZ=136.42
		},
		grapejuice = {
			coords = vector3(-1911.43, 2084.33, 140.38),
			zones = {
				vector2(-1911.5402832032, 2081.7651367188),
				vector2(-1909.338256836, 2084.3671875),
				vector2(-1911.3267822266, 2086.9885253906),
				vector2(-1914.6043701172, 2083.7666015625)
			},
			minZ=140.38330078125,
			maxZ=140.38343811036
		}
	}
}