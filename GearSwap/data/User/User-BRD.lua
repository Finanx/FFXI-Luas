include('/User/roller-ring.lua')

function job_self_command(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'tpbonus' then
        Update_Weapons()
        eventArgs.handled = true
        return
    end
	
    if cmdParams[1]:lower() == 'carol1' then
        send_command('@input /ma '..state.Carol1.value..' <stpc>')
	elseif cmdParams[1]:lower() == 'carol2' then
        send_command('@input /ma '..state.Carol2.value..' <stpc>')
	elseif cmdParams[1]:lower() == 'etude' then
        send_command('@input /ma '..state.Etude.value..' <stpc>')
    elseif cmdParams[1]:lower() == 'threnody' then
        send_command('@input /ma '..state.Threnody.value..' <t>')
    end

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
end

function Update_Weapons()

	if state.Weapons.value == 'None' then
        enable('main','sub')
	else
		local w = state.Weapons.value
		enable('main','sub')
		equip(sets.weapons[w])

		-- Sub-weapon / Shield from TOP-LEVEL sets
		if (player.sub_job == 'DNC' or player.sub_job == 'NIN') then
			local sub = state.Subweapon.value
			if sub and sets[sub] then
				equip(sets[sub])
			end
		else
			local shield = state.Shield.value
			if shield and sets[shield] then
				equip(sets[shield])
			end
		end
		
		disable('main','sub')
		
	end

end

function job_aftercast(spell, action, spellMap, eventArgs)
	Update_Weapons()
end