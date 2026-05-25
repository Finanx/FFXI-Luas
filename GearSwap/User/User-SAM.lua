include('/Finan_libs/roller-ring.lua')

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

    equip(sets.weapons[w])

    if One_Handed_Weapons[w] == true then
		if (player.sub_job == 'DNC' or player.sub_job == 'NIN') then
			equip(sets[state.Subweapon.value])
		else
			equip(sets.shield)
		end
    end
	
    if state.RangeLock and state.RangeLock.value == true then
        equip(sets.Bow)
        disable('range','ammo')
    else
        enable('range','ammo')
    end

end

function job_aftercast(spell, action, spellMap, eventArgs)
	
	Update_Weapons()

end