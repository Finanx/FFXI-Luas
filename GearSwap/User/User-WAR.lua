include('/User/roller-ring.lua')

function job_self_command(cmdParams, eventArgs)
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

	local w = state.Weapons.value

    if One_Handed_Weapons[w] == true then
		if (player.sub_job == 'DNC' or player.sub_job == 'NIN') then
			equip(sets.weapons[w].DW)
		else
			equip(sets.weapons[w])
			equip(sets.shield)
		end
	else
		equip(sets.weapons[w])
		equip(sets.grip)
	end

end

function job_aftercast(spell, action, spellMap, eventArgs)
	
	Update_Weapons()

end