Config = {
    Weapon = 'WEAPON_APPISTOL',
    RemoveWeapon = true, -- if someone has the Weapon but isn't playing paintball, remove it. 
    RequiredPlayers = 1,
    JoinCircle = vector3(188.45, -913.63, 29.71),
    QueueTime = 0.5, -- how long until the match starts (minutes)
    MatchLength = 5, -- length of the match (minutes)
    DisplayWinner = 10, -- how long to show who won (seconds)
    ForceFirstPerson = true, -- force first person?
    SpawnPoints = {
        vector3(-70.56, -1137.08, -1.44),
        vector3(-64.82, -1125.44, -1.44),
        vector3(-51.08, -1122.45, -1.44),
        vector3(-39.84, -1129.2, -1.44),
        vector3(-35.6, -1136.91, -1.44),
        vector3(-55.56, -1141.9, -1.44),
        vector3(-67.06, -1135.18, -1.44),
        vector3(-62.27, -1117.09, -1.44),
    },
    WinnerPosition = vector3(-49.64, -1137.48, -1.2),
    WinnerHeading = 19.95,
    WinnerCam = vector3(-51.73, -1134.25, 2.5),
    Price = 250,

    Translations = {
        ['join_paintball'] = '[~g~E~w~] (costs ~g~$%s~w~) Join the paintball queue\n%s',
        ['leave_paintball'] = '[~g~E~w~] Leave the paintball queue\n%s',  
        ['left_paintball'] = 'You ~r~left ~w~the paintball queue since you walked too far away.',
        ['match_in_progress'] = '~r~%s\n~b~%s~w~seconds left.',
        ['gun_removed'] = 'Your paintball gun got deleted since you are not playing paintball.',
        ['match_ends'] = 'Match ends in: ~g~%s ~w~seconds\nYou have: ~g~%s ~w~kill(s)\nYou have died: ~r~%s ~w~time(s)',
        ['seconds_starts'] = ' the match starts in ',
        ['match_progress'] = 'Match in progress.',
        ['in_queue'] = ' in queue\n',
        ['you_killed'] = 'You killed',
        ['you_got_killed'] = 'You got killed by',
        ['killed_by'] = ' got killed by ',
        ['no_money'] = 'You do not have enough money to play paintball!',
        ['won'] = '~g~%s ~w~won with: %s kills & %s deaths\n~g~You ~w~got: %s kills & %s deaths',
        ['you_won'] = '\n~g~You ~w~won with: %s kills & %s deaths'
        
    },
}