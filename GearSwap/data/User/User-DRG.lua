include('/User/roller-ring.lua')

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

end

--Override Selindrile's update_combat_form with dual-axis logic
function update_combat_form()
    local w = state.Weapons.value

    if Two_Handed_Weapons[w] then
		if state.PetDT.value then
			state.CombatForm:set('Two_Handed_PetDT')
		else
			state.CombatForm:set('Two_Handed')
		end
    elseif not (player.sub_job == 'NIN' or player.sub_job == 'DNC') and One_Handed_Weapons[w] then
		if state.PetDT.value then
			state.CombatForm:set('PetDT')
		else
			state.CombatForm:reset()
		end
    elseif (player.sub_job == 'NIN' or player.sub_job == 'DNC') and One_Handed_Weapons[w] then
		if state.PetDT.value then
			state.CombatForm:set('DW_PetDT')
		else
			state.CombatForm:set('DW')
		end
	end

end

function job_aftercast(spell, action, spellMap, eventArgs)
	
	Update_Weapons()

end