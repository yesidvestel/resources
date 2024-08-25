RegisterNUICallback("UseButton", function(data)
	if data.action == 'close' then
		InMenu = false
		SetNuiFocus(false, false)
		EnableMinimap()

		if Joined and not InBet then
			Joined = false
			CurrentArea = nil
			CurrentAreaTable = {}
			TriggerServerEvent('brutal_boxing:server:removejoin')
		end

		if not InBoxing and not InParty and not InBet then
			CurrentArea = nil
			CurrentAreaTable = {}
		end
	elseif data.action == 'join' then
		TriggerServerEvent('brutal_boxing:server:join', CurrentArea, tonumber(data.place), tonumber(data.totalwins))
	elseif data.action == 'leave' then
		TriggerServerEvent('brutal_boxing:server:leave', CurrentArea, tonumber(data.place))
	elseif data.action == 'start' then
		TriggerServerEvent('brutal_boxing:server:start', CurrentArea, data.rounds, data.gloves, data.bet)
	elseif data.action == 'bet' then
		TriggerServerEvent('brutal_boxing:server:bet', CurrentArea, tonumber(data.player), tonumber(data.amount))
	end
end)