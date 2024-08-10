-- Zones for Menues
Config = Config or {}

Config.UseTarget = GetConvar('UseTarget', 'false') == 'false' -- Use qb-target interactions (don't change this, go to your server.cfg and add `setr UseTarget true` to use this and just that from true to false or the other way around)

Config.BossMenus = {
    police = {
        vector3(447.16, -974.31, 30.47),
    },
    ambulance = {
        vector3(311.21, -599.36, 43.29),
    },
    cardealer = {
        vector3(-32.94, -1114.64, 26.42),
    },
    mechanic = {
        vector3(-347.59, -133.35, 39.01),
		   },
    bennys = {
        vector3(-217.11, -1319.57, 31.03),
		
    },
	vunicorn = {
        vector3(93.65, -1294.06, 29.08),
    },
}
--coordenadas
Config.GangMenus = {
    lostmc = {
        vector3(0, 0, 0),
    },
    ballas = {
        vector3(83.05, -1960.02, 17.04),
    },
    vagos = {
        vector3(353.72, -2028.32, 22.26),
    },
    cartel = {
        vector3(1446.88, -1486.11, 66.53),
    },
    families = {
        vector3(-150.06, -1596.82, 34.94),
    },
}
