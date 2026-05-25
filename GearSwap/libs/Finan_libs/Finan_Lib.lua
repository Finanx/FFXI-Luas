include('/Finan_libs/roller-ring.lua')

function job_self_command(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'tpbonus' then
        Update_Weapons()
        eventArgs.handled = true
        return
    end

    -- Allow job files to extend this
    if user_job_self_command then
        user_job_self_command(cmdParams, eventArgs)
    end
end

function job_state_change(stateField, newValue, oldValue)

	if stateField == 'Weapons' or stateField == 'TPBonus' or stateField == 'RangeLock' then
		Update_Weapons()
	end

    -- Allow job files to extend this
    if user_job_state_change then
        user_job_state_change(stateField, newValue, oldValue)
    end
end

function job_handle_equipping_gear(playerStatus, eventArgs)
    Update_Weapons()

    if user_job_handle_equipping_gear then
        user_job_handle_equipping_gear(playerStatus, eventArgs)
    end
end

function Update_Weapons()
    enable('main','sub')

    local w = state.Weapons.value

    -- If "None", leave weapons unlocked
    if w == 'None' then
        return
    end

    -- Determine if we should use DW version
    local isDW = (player.sub_job == 'DNC' or player.sub_job == 'NIN')

    -- Build set names dynamically
    local baseSet = sets.weapons[w]               -- SW default
    local dwSet   = sets.weapons[w.."_DW"]        -- DW override
    local tpSet   = sets.weapons[w.."_TPBonus"]   -- DW TPBonus override

    if isDW then
        -- DW branch
        if state.TPBonus.value and tpSet then
            equip(tpSet)
        elseif dwSet then
            equip(dwSet)
        else
            equip(baseSet) -- fallback if no DW set exists
        end
    else
        -- SW branch (always base)
        equip(baseSet)
    end

	-- Lock weapons after equipping
	disable('main','sub')

	-- Job-specific weapon post-processing
	if user_job_post_weapons then
		user_job_post_weapons()
	end

end

