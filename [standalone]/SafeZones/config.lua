Config = {}


-- Coords for all safezones
Config.zones = {
	{ ['x'] = 1847.916015625, ['y'] = 3675.8190917968, ['z'] = 33.767009735108}, -- Sandy Shores PD
	{ ['x'] = -1688.43811035156, ['y'] = -1073.62536621094, ['z'] = 13.1521873474121},
	{ ['x'] = -2195.1352539063, ['y'] = 4288.7290039063, ['z'] = 49.173923492432},
	{ ['x'] = 224.74, ['y'] = -787.98, ['z'] = 30.73},--parqueadero central
	{ ['x'] = 306.81, ['y'] = -589.56, ['z'] = 43.29},--hospital
	{ ['x'] = 438.61, ['y'] = -986.79, ['z'] = 30.69},--policia
}

Config.showNotification = true -- Show notification when in Safezone?
Config.safezoneMessage = "Actualmente estás en una zona segura" -- Change the message that shows when you are in a safezone
Config.radius = 50.0 -- Change the RADIUS of the Safezone.
Config.speedlimitinSafezone = false -- Set a speed limit in a Safezone (MPH), Set to false to disable


-- Change the color of the notification
Config.notificationstyle = "success"
--Notification Styles
-- inform
-- error
-- success