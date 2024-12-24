    exports['qt-loadingbar']:progressBar({
            duration = 15000, 
            title = "Jedes..",  -- # optional 
            description = "Hamburger",  -- # optional
            canCancel = true, -- # optional
            disabled = {   -- # optional
                FreezePlayer = false, 
                MouseControl = false, 
                Sprint = false, 
                Vehicle = false,
                target = true,  
            },
            animation = {  -- # optional 
                dict = "mp_player_int_eat_burger_fp",
                animation = "mp_player_inteat@burger", -- # you can choose animation or ped scenario 
               -- scenario = "PED SCENARIO",
            },
    })
exports['qt-loadingbar']:isActive() -- # returns boolean 
