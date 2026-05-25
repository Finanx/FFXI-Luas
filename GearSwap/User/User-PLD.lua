include('user/roller-ring.lua')

state.UnlockWeapons:set(true)

state.ReprisalActive = M(false)

function job_self_command(cmdParams, eventArgs)

	if cmdParams[1]:lower() == 'barspell' then
        send_command('@input /ma '..state.Barspell.value..' <me>')
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

	if state.WeaponLock and state.WeaponLock.value then
		disable('main','sub')
	else
		enable('main','sub')
	end

	local w = state.Weapons.value
	equip(sets.weapons[w])

    local shield = state.Shield.value

    if state.ReprisalActive and state.ReprisalActive.value and shield == 'Duban' then
		equip(sets.Priwen)
    else
		equip(sets[shield])
    end

end

function job_buff_change(buff, gain)
    if buff:lower() == 'reprisal' then
        state.ReprisalActive:set(gain)
        handle_equipping_gear(player.status)
    end
end

function job_aftercast(spell, action, spellMap, eventArgs)
	Update_Weapons()
end