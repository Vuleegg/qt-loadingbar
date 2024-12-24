---@diagnostic disable: missing-parameter
Functions = {}
Functions.isBusy = false 
Functions.canCancel = false 

Functions.RequestAnim = function(animDict)
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(100)
        end
    end
    return animDict
end

Functions.Scenario = function(entity, scenario)
    TaskStartScenarioInPlace(entity, scenario, 0, true)
end

local controls = {
    INPUT_LOOK_LR = 1,
    INPUT_LOOK_UD = 2,
    INPUT_SPRINT = 21,
    INPUT_AIM = 25,
    INPUT_MOVE_LR = 30,
    INPUT_MOVE_UD = 31,
    INPUT_DUCK = 36,
    INPUT_VEH_MOVE_LEFT_ONLY = 63,
    INPUT_VEH_MOVE_RIGHT_ONLY = 64,
    INPUT_VEH_ACCELERATE = 71,
    INPUT_VEH_BRAKE = 72,
    INPUT_VEH_EXIT = 75,
    INPUT_VEH_MOUSE_CONTROL_OVERRIDE = 106,
    INPUT_CHARACTER_WHEEL = 19
}

ExtensionsToogle = function(disabled)

    while Functions.isBusy do

        if disabled.FreezePlayer then
            DisableControlAction(0, controls.INPUT_SPRINT, true)
            DisableControlAction(0, controls.INPUT_MOVE_LR, true)
            DisableControlAction(0, controls.INPUT_MOVE_UD, true)
            DisableControlAction(0, controls.INPUT_DUCK, true)
        end

        if disabled.MouseControl then
            DisableControlAction(0, controls.INPUT_LOOK_LR, true)
            DisableControlAction(0, controls.INPUT_LOOK_UD, true)
            DisableControlAction(0, controls.INPUT_VEH_MOUSE_CONTROL_OVERRIDE, true)
        end

        if disabled.Sprint and not disabled.FreezePlayer then
            DisableControlAction(0, controls.INPUT_SPRINT, true)
        end

        if disabled.Vehicle then
            DisableControlAction(0, controls.INPUT_VEH_MOVE_LEFT_ONLY, true)
            DisableControlAction(0, controls.INPUT_VEH_MOVE_RIGHT_ONLY, true)
            DisableControlAction(0, controls.INPUT_VEH_ACCELERATE, true)
            DisableControlAction(0, controls.INPUT_VEH_BRAKE, true)
            DisableControlAction(0, controls.INPUT_VEH_EXIT, true)
        end

        if disabled.target then
            ExecuteCommand('-ox_target', disableTargeting, false)
        end

        if not Functions.isBusy then
            break
        end

      Wait(0)

    end

end

Animations = function(anim)
    if anim ~= nil then
        if anim.dict and anim.animation then
            Functions.RequestAnim(anim.animation)
            TaskPlayAnim(PlayerPedId(), anim.animation, anim.dict, 8.0, -8.0, -1, 2, 0, false, false, false)
        end
        if anim.scenario then
            Functions.Scenario(PlayerPedId(), anim.scenario)
        end
    end
end

Functions.progressBar = function(data) 
    Functions.isBusy = true

    if data.canCancel then 
        Functions.canCancel = true 
    end

    Animations(data.animation)

    SendNUIMessage({
        type = 'progress',
        title = data.title, 
        description = data.description,
        duration = data.duration, 
    })    

    ExtensionsToogle(data.disabled)

end

exports('progressBar', Functions.progressBar)

--[[RegisterCommand("test", function()
    exports['qt-loadingbar']:progressBar({
            duration = 15000,
            title = "Jedes..",
            description = "Hamburger",
            canCancel = true, 
            disabled = { 
                FreezePlayer = false, 
                MouseControl = false, 
                Sprint = false, 
                Vehicle = false,
                target = true,  
            },
            animation = {
                dict = "mp_player_int_eat_burger_fp",
                animation = "mp_player_inteat@burger",
               -- scenario = "PED SCENARIO",
            },
    })
end)]]

RegisterNUICallback("progressComplete", function(_, cb)
    Functions.isBusy = false
    Functions.canCancel = false 
    ClearPedTasks(PlayerPedId())
    cb("ok")
end)

cancelProgress = function()
    if Functions.isBusy then 
        Functions.isBusy = false 
        Functions.canCancel = false 
        ClearPedTasks(PlayerPedId())
        SendNUIMessage({type = "cancelProgress"})
    end
end

RegisterCommand('cancelprogress', function()
    if Functions.canCancel then 
       cancelProgress()
    end
end)

RegisterKeyMapping('cancelprogress', 'Cancel progressbar', 'keyboard', 'x')

Functions.isActive = function()
    return Functions.isBusy
end

exports('isActive', Functions.isActive)

-- # exports['qt-loadingbar']:isActive()