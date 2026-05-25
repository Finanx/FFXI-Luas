include('/User/roller-ring.lua')

function job_self_command(cmdParams, eventArgs)
    -- Allow job files to extend this
    if user_job_self_command then
        user_job_self_command(cmdParams, eventArgs)
    end
end

function job_state_change(stateField, newValue, oldValue)
    handle_equipping_gear(player.status)
end

function job_handle_equipping_gear(playerStatus, eventArgs)
    Update_Weapons()
	
	if state.Reraise.value then
		equip(sets.Reraise)
		disable('head','body')
	else
		enable('head','body')
	end
	
end

function Update_Weapons()

	if state.Weapons.value == 'None' then
        enable('main','sub')
	else
		local w = state.Weapons.value
		local shield = state.Shield.value
		enable('main','sub')

		if (player.sub_job == 'DNC' or player.sub_job == 'NIN') then
			equip(sets.weapons[w].DW)
		else
			equip(sets.weapons[w])
			equip(sets[shield])
		end
		
		disable('main','sub')
		
	end

end

function job_customize_idle_set(idleSet)

    -- If pet is out, choose the correct PetMode idle set
    if pet.isvalid then
        if state.PetMode.value == 'Pet_Tank' then
            idleSet = sets.idle.Pet_Tank
        elseif state.PetMode.value == 'Pet_DD' then
            idleSet = sets.idle.Pet_DD
        end

        -- Apply DW override if you are dual wielding
        if can_dual_wield then
            if state.PetMode.value == 'Pet_Tank' and sets.idle.Pet_Tank.DW then
                idleSet = set_combine(sets.idle.Pet_Tank, sets.idle.Pet_Tank.DW)
            elseif state.PetMode.value == 'Pet_DD' and sets.idle.Pet_DD.DW then
                idleSet = set_combine(sets.idle.Pet_DD, sets.idle.Pet_DD.DW)
            end
        end
    end

    return idleSet
end


function job_aftercast(spell, action, spellMap, eventArgs)
	
	Update_Weapons()

end