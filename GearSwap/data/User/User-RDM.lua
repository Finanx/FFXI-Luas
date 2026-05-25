include('/User/roller-ring.lua')

--state.UnlockWeapons:set(true)

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
	
    if state.RangeLock and state.RangeLock.value == true then
        equip(sets.Empyreal)
        disable('range','ammo')
    else
        enable('range','ammo')
    end

end

function job_customize_melee_set(meleeSet)
	if state.OffenseMode.value == 'Enspell' and enspell ~= '' then
		local enspell_element = data.elements.enspells_lookup[enspell]

		if item_equippable("Orpheus's Sash") then
			meleeSet = set_combine(meleeSet, {waist="Orpheus's Sash"})
		elseif enspell_element == world.weather_element or enspell_element == world.day_element then
			if item_equippable(data.elements.obi_of[enspell_element]) then
				meleeSet = set_combine(meleeSet, {waist=data.elements.obi_of[enspell_element]})
			elseif item_equippable('Hachirin-no-Obi') then
				local day_potency = (enspell_element == world.day_element and 10) or (enspell_element == data.elements.weak_to[world.day_element] and -10) or 0
				local weather_potency = (enspell_element == world.weather_element and data.weather_bonus_potency[world.weather_intensity]) or (data.elements.weak_to[world.weather_element] and (data.weather_bonus_potency[world.weather_intensity] * -1)) or 0
				if (day_potency + weather_potency) >= 5 then
					meleeSet = set_combine(meleeSet, {waist="Hachirin-no-Obi"})
				end
			end
		end
	end
	
    -- Shield-based CombatForm logic
    if not (player.sub_job == 'DNC' or player.sub_job == 'NIN') then
        local shield = state.Shield.value

        if shield ~= 'Genmei' then
            state.CombatForm:set('No_DT_Shield')
        else
            state.CombatForm:reset()
        end
    end

	return meleeSet
end

function job_update_melee_groups()
	--[[if enspell ~= '' then
		if enspell:endswith('II') then
			classes.CustomMeleeGroups:append('Enspell2')
		else
			classes.CustomMeleeGroups:append('Enspell')
		end
	end]]
end

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
	if spell.skill == 'Elemental Magic' and default_spell_map ~= 'ElementalEnfeeble' and not spell.english:contains('helix') then
		if LowTierNukes:contains(spell.english) then
			return 'LowTierNuke'
		else
			return 'HighTierNuke'
		end
	end
end

function user_job_post_midcast(spell, spellMap, eventArgs)

		--Changes Cure set conditions
	if spellMap == 'Cure' then
		if state.SpellInterrupt.value == true then
			equip(sets.midcast.Cure_SpellInterrupt)
		else
            if (world.weather_element == 'Light' or world.day_element == 'Light') then
                equip(sets.midcast.LightWeatherCure)
            end
			if spell.target.type == 'SELF' then
				equip(sets.midcast.CureSelf)
				if (world.weather_element == 'Light' or world.day_element == 'Light') then
					equip(sets.midcast.CureSelfWeather)
				end
			end
		end
    elseif spellMap == 'Curaga' then
		if state.SpellInterrupt.value == true then
			equip(sets.midcast.Cure_SpellInterrupt)
		else
            if (world.weather_element == 'Light' or world.day_element == 'Light') then
                equip(sets.midcast.CureWeather)
            end
		end
    end
	
		--Handles all Enhancing Magic mappings
    if spell.skill == 'Enhancing Magic' then
        if classes.NoSkillSpells:contains(spell.english) then
            equip(sets.midcast.EnhancingDuration)
        elseif skill_spells:contains(spell.english) then
            equip(sets.midcast.EnhancingSkill)
        elseif spell.english:startswith('Gain') then
			equip(sets.midcast.Gain_Spell)
        end
		-- Refresh logic
		if spellMap == 'Refresh' then
			if spell.target.type == 'SELF' then
				equip(sets.midcast.RefreshSelf)
			elseif buffactive.Composure then
				equip(sets.midcast.Refresh_Composure)
			else
				equip(sets.midcast.Refresh)
			end
			return
		end
		-- Regen logic
		if spellMap == 'Regen' then
			if spell.target.type == 'SELF' then
				equip(sets.midcast.Regen)
			elseif spell.target.type == 'PLAYER' then
				if buffactive.Composure then
					equip(sets.midcast.Regen_Composure)
				else
					equip(sets.midcast.Regen)
				end
			end
			return
		end
		if spell.english == 'Phalanx II' then
			if spell.target.type == 'SELF' then
				equip(sets.Self_Phalanx)
			end
		end

    end
	
	if spell.english == "Impact" then
		equip(sets.midcast.Impact)
		if state.Weapons.value == 'None' then
			equip(sets.Empyreal)
		end
	end

    --------------------------------------------------------------------
    -- Apply NukeMode override (ALWAYS wins when active)
    --------------------------------------------------------------------

	--Must be after all other magic types so it only considers elemental magic after this line
	if spell.skill ~= 'Elemental Magic' then
        return
    end

    local nukemode = state.NukeMode.value

	if nukemode ~= 'Normal' then

		-- Global NukeMode override (Low, High, Occult)
		if sets.midcast['Elemental Magic'][nukemode] then
			equip(sets.midcast['Elemental Magic'][nukemode])
		end

		-- Spell-specific overrides
		if spell.english == 'Impact' then

			-- Low and High both use Impact.MB
			if nukemode == 'Low_MagicBurst' or nukemode == 'High_MagicBurst' then
				if sets.midcast.Impact.Magic_Burst then
					equip(sets.midcast.Impact.Magic_Burst)
				end

			-- Occult uses Impact.Occult_Accumen
			elseif nukemode == 'Occult_Accumen' then
				if sets.midcast.Impact.Occult_Accumen then
					equip(sets.midcast.Impact.Occult_Accumen)
				end
			end

		end
	end

end

function job_aftercast(spell, action, spellMap, eventArgs)
	
	Update_Weapons()

end