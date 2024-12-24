-- Start a progress bar with the given options
exports['qt-loadingbar']:progressBar({
    duration = 15000,  -- Duration of the progress bar (in milliseconds)
    title = "Jedes..",  -- Optional title of the progress bar
    description = "Hamburger",  -- Optional description of the progress bar
    canCancel = true,  -- Optional, if the progress bar can be cancelled by the player
    disabled = {  -- Optional, disables certain player actions
        FreezePlayer = false, 
        MouseControl = false, 
        Sprint = false, 
        Vehicle = false,
        target = true,  -- Targeting is disabled
    },
    animation = {  -- Optional, defines animation settings
        dict = "mp_player_int_eat_burger_fp",  -- Animation dictionary
        animation = "mp_player_inteat@burger",  -- Animation name
        -- scenario = "PED SCENARIO",  -- Optional, define a ped scenario (alternative to animation)
    },
})

-- Check if the progress bar is currently active
exports['qt-loadingbar']:isActive()  -- Returns a boolean indicating if the progress bar is active
