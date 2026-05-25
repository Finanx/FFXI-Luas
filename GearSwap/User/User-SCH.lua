include('/Finan_libs/roller-ring.lua')

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

		if One_Handed_Weapons[w] then
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
		else
			if state.Weapons.value == 'Xoanon' then
				equip(sets.Ultio)
			else
				equip(sets.Khonsu)
			end
		end
		
		disable('main','sub')
		
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
                equip(sets.midcast.CuragaWeather)
            end
		end
    end
	
		--Handles all Enhancing Magic mappings
    if spell.skill == 'Enhancing Magic' then
		-- Regen logic
		if spellMap == 'Regen' then
			if state.RegenMode.value == 'Duration' then
				equip(sets.midcast.Regen_Duration)
			else
				equip(sets.midcast.Regen)
			end
			return
		end
	end
	
	-- Magic Burst + Ebullience override for Elemental Magic / Helix
	if spell.skill == 'Elemental Magic' then
		if spell.english ~= 'Impact' then
			if state.CastingMode.value == 'MagicBurst' and buffactive.Ebullience then
				equip(sets.midcast['Elemental Magic'].MagicBurst_Ebullience)
			end
		end
		-- Helix spells use the same logic
		if spellMap == 'Helix' then
			if state.CastingMode.value == 'MagicBurst' and buffactive.Ebullience then
				equip(sets.midcast.Helix.MagicBurst_Ebullience)
			end
		end
	end
	
	set_elemental_obi_cape_ring(spell, spellMap)

end

function job_aftercast(spell, action, spellMap, eventArgs)
	
	Update_Weapons()

end