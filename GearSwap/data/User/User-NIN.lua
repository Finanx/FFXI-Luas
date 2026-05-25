include('/User/roller-ring.lua')

function job_state_change(stateField, newValue, oldValue)
    handle_equipping_gear(player.status)
end

function job_handle_equipping_gear(playerStatus, eventArgs)
    Update_Weapons()
end

function Update_Weapons()

	
	local w = state.Weapons.value
	equip(sets.weapons[w])

	if state.WeaponSets.value == 'Default' then
		if Two_Handed_Weapons[state.Weapons.value] then
			equip(sets.grip)
		else
			if sets[state.Subweapon.value] then
				equip(sets[state.Subweapon.value])
			end
		end
	end

end

-- Modify the default melee set after it was constructed.
function job_customize_melee_set(meleeSet)
	if state.Buff.Yonin then
		if state.DefenseMode.value == 'None' or state.DefenseMode.value == 'Evasion' then
			meleeSet = set_combine(meleeSet, sets.buff.Yonin)
		end
	elseif state.Buff.Innin then
		if (state.OffenseMode.value == 'Normal' or state.OffenseMode.value == 'Fodder') and state.DefenseMode.value == 'None' then
			meleeSet = set_combine(meleeSet, sets.buff.Innin)
		end
	end

	if state.WeaponSets.value == 'Default' then
		meleeSet = set_combine(meleeSet, sets.ammo_Daken)
	else
		meleeSet = set_combine(meleeSet, sets.ammo_Proc)
	end

	return meleeSet
end

function update_combat_form()

    -- Two-handed rule ALWAYS wins
    if Two_Handed_Weapons[state.Weapons.value] then
        if state.Buff.Migawari then
            state.CombatForm:set('Two_Handed_Migawari')
        else
            state.CombatForm:set('Two_Handed')
        end

    -- TP Bonus rule (only if not two-handed)
    elseif TPBonus[state.Subweapon.value] then
        if state.Buff.Migawari then
            state.CombatForm:set('TPBonus_Migawari')
        else
            state.CombatForm:set('TPBonus')
        end

    -- Normal engaged Migawari
    elseif state.Buff.Migawari then
        state.CombatForm:set('Migawari')

    -- Default
    else
        state.CombatForm:reset()
    end
end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, spellMap, eventArgs)
	
		--Handles Elemental Ninjutsu Events
    if spellMap == 'ElementalNinjutsu' then

		if state.MagicBurst.value == true then
			equip(sets.midcast.ElementalNinjutsu_MagicBurst)
		end
				
		if state.Buff.Futae then
			equip(sets.buff.Futae)
		end
	end
	
end

function job_aftercast(spell, action, spellMap, eventArgs)
	
	Update_Weapons()

end