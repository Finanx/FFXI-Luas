include('/Finan_libs/roller-ring.lua')

function job_self_command(cmdParams, eventArgs)

	if cmdParams[1]:lower() == 'step' then
        send_command('@input /ja "'..state.step.value..'" <t>')
	end

end

function job_state_change(stateField, newValue, oldValue)
    handle_equipping_gear(player.status)
end

function job_handle_equipping_gear(playerStatus, eventArgs)
    Update_Weapons()
end

function Update_Weapons()

    local w = state.Weapons.value

    equip(sets.weapons[w])

    if not DisableSub[w] then
        equip(sets[state.Subweapon.value])
    end

end

function job_aftercast(spell, action, spellMap, eventArgs)
	
	Update_Weapons()

end