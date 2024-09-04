Config = {
    NotificationDistance = 10.0,
    PropsToRemove = {
        vector3(1992.803, 3047.312, 46.22865),
        vector3(-36.301, 6391.44, 31.6047),
        vector3(550.147, -174.76, 50.6930),
        vector3(-574.17, 288.834, 79.1766),
    },

    --[[
        -- To use custom notifications, implement client event handler, example:

        AddEventHandler('rcore_pool:notification', function(serverId, message)
            print(serverId, message)
        end)
    ]]
    CustomNotifications = false,

    --[[
        -- To use custom menu, implement following client handlers
        AddEventHandler('rcore_pool:openMenu', function()
            -- open menu with your system
        end)

        AddEventHandler('rcore_pool:closeMenu', function()
            -- close menu, player has walked far from table
        end)


        -- After selecting game type, trigger one of the following setupTable events
        TriggerEvent('rcore_pool:setupTable', 'BALL_SETUP_8_BALL')
        TriggerEvent('rcore_pool:setupTable', 'BALL_SETUP_STRAIGHT_POOL')
    ]]
    CustomMenu = false,

    --[[
        When you want your players to pay to play pool, set this to true
        AND implement the following server handler in your framework of choice.
        The handler MUST deduct money from the player and then CALL the callback
        if the payment is successful, or inform the player of payment failure.

        This script itself DOES NOT implement ESX/vRP logic, you have to do that yourself.

        AddEventHandler('rcore_pool:payForPool', function(playerServerId, cb)
            print("This should be replaced by deducting money from " .. playerServerId)
            cb() -- successfuly set balls on table
        end)
    ]]
    PayForSettingBalls = false,
    BallSetupCost = nil, -- for example: "$1" or "$200" - any text

    --[[
        You can integrate pool cue into your system with

        SERVERSIDE HANDLERS
            - rcore_pool:onReturnCue - called when player takes cue
            - rcore_pool:onTakeCue   - called when player returns cue

        CLIENTSIDE EVENTS
            - rcore_pool:takeCue   - forces player to take cue in hand
            - rcore_pool:removeCue - removes cue from player's hand

        This prevents players from taking cue from cue rack if `false`
    ]]
    AllowTakePoolCueFromStand = true,

    --[[
        This option is for servers whose anticheats prevents
        this script from setting players invisible.

        When player's ped is blocking camera when aiming,
        set this to true
    ]]
    DoNotRotateAroundTableWhenAiming = false,

    MenuColor = {245, 127, 23},
    Keys = {
        BACK = {code = 200, label = 'INPUT_FRONTEND_PAUSE_ALTERNATE'},
        ENTER = {code = 38, label = 'INPUT_PICKUP'},
        SETUP_MODIFIER = {code = 21, label = 'INPUT_SPRINT'},
        CUE_HIT = {code = 179, label = 'INPUT_CELLPHONE_EXTRA_OPTION'},
        CUE_LEFT = {code = 174, label = 'INPUT_CELLPHONE_LEFT'},
        CUE_RIGHT = {code = 175, label = 'INPUT_CELLPHONE_RIGHT'},
        AIM_SLOWER = {code = 21, label = 'INPUT_SPRINT'},
        BALL_IN_HAND = {code = 29, label = 'INPUT_SPECIAL_ABILITY_SECONDARY'},

        BALL_IN_HAND_LEFT = {code = 174, label = 'INPUT_CELLPHONE_LEFT'},
        BALL_IN_HAND_RIGHT = {code = 175, label = 'INPUT_CELLPHONE_RIGHT'},
        BALL_IN_HAND_UP = {code = 172, label = 'INPUT_CELLPHONE_UP'},
        BALL_IN_HAND_DOWN = {code = 173, label = 'INPUT_CELLPHONE_DOWN'},
    },
    Text = {
        BACK = "Volver",
        HIT = "Golpe",
        BALL_IN_HAND = "Bola en mano",
        BALL_IN_HAND_BACK = "Volver",
        AIM_LEFT = "Apuntar a la izquierda",
        AIM_RIGHT = "Apuntar a la derecha",
        AIM_SLOWER = "Apuntar más despacio",

        POOL = 'Menú de billar',
        POOL_GAME = 'Juego de billar',
        POOL_SUBMENU = 'Selecciona una opción',
        TYPE_8_BALL = '8-Ball',
        TYPE_STRAIGHT = 'Billar en línea',

        HINT_SETUP = 'Preparar la mesa',
        HINT_TAKE_CUE = 'Tomar un taco',
        HINT_RETURN_CUE = 'Devolver el taco',
        HINT_HINT_TAKE_CUE = 'Primero toma un taco para jugar',
        HINT_PLAY = 'Jugar',

        BALL_IN_HAND_LEFT = 'Izquierda',
        BALL_IN_HAND_RIGHT = 'Derecha',
        BALL_IN_HAND_UP = 'Arriba',
        BALL_IN_HAND_DOWN = 'Abajo',
        BALL_POCKETED = 'Bola en el hoyo',
        BALL_IN_HAND_NOTIFY = 'Has metido la bola',
        BALL_LABELS = {
            [-1] = 'Taco',
            [1] = '~y~Sólida 1~s~',
            [2] = '~b~Sólida 2~s~',
            [3] = '~r~Sólida 3~s~',
            [4] = '~p~Sólida 4~s~',
            [5] = '~o~Sólida 5~s~',
            [6] = '~g~Sólida 6~s~',
            [7] = '~r~Sólida 7~s~',
            [8] = 'Negra sólida 8',
            [9] = '~y~Rayada 9~s~',
            [10] = '~b~Rayada 10~s~',
            [11] = '~r~Rayada 11~s~',
            [12] = '~p~Rayada 12~s~',
            [13] = '~o~Rayada 13~s~',
            [14] = '~g~Rayada 14~s~',
            [15] = '~r~Rayada 15~s~',
         }
    },
}