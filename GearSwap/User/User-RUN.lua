include('user/roller-ring.lua')

state.UnlockWeapons:set(true)

function job_self_command(cmdParams, eventArgs)

	if cmdParams[1]:lower() == 'barspell' then
        send_command('@input /ma "'..state.Barspell.value..'" <me>')
	elseif cmdParams[1]:lower() == 'barstatus' then
        send_command('@input /ma '..state.BarStatus.value..' <me>')
    end

end

function job_state_change(stateField, newValue, oldValue)
    handle_equipping_gear(player.status)
end

function job_handle_equipping_gear(playerStatus, eventArgs)
    Update_Weapons()
end

function Update_Weapons()

	if state.WeaponLock and state.WeaponLock.value then
        disable('main','sub')
	else
		enable('main','sub')
    end

    local w = state.Weapons.value
	local grip = state.Grip.value

    equip(sets.weapons[w])

    if One_Handed_Weapons[w] == true then
		equip(sets.shield)
    elseif Two_Handed_Weapons[w] == true then
		equip(sets[grip])
	end

end

function customize_melee_set(meleeSet)
    if buffactive['Aftermath: Lv.3'] and player.equipment.main == "Epeolatry" and state.OffenseMode.value == 'Normal' then
		meleeSet = sets.engaged.Aftermath
    end

    return meleeSet
end

function job_aftercast(spell, action, spellMap, eventArgs)
	
	Update_Weapons()

end