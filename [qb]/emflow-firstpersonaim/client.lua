local isAiming = false
local originalViewMode = 1

CreateThread(function()
    while true do
        Wait(0)

        if IsPlayerFreeAiming(PlayerId()) then
            if GetFollowPedCamViewMode() ~= 4 then
                originalViewMode = GetFollowPedCamViewMode()
                SetFollowPedCamViewMode(4)
            end
            isAiming = true
        elseif isAiming then
            SetFollowPedCamViewMode(originalViewMode)
            isAiming = false
        end
    end
end)
