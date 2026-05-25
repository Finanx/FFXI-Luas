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

function job_get_spell_map(spell, default_spell_map)

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
	
	if spell.skill == 'Elemental Magic' then
		if default_spell_map ~= 'ElementalEnfeeble' and not spell.english:contains('helix') then 
			if spell.english ~= "Death" and spell.english ~= "Comet" and spell.english ~= "Impact" then
				if state.Buff['Mana Wall'] then
					if state.CastingMode.value == 'Normal' then
						equip(sets.midcast['Elemental Magic'].RecoverMP)
					elseif state.CastingMode.value == 'MagicBurst' then
						equip(sets.midcast['Elemental Magic'].MagicBurst.RecoverMP)
					elseif state.CastingMode.value == 'OccultAcumen' then
						equip(sets.midcast['Elemental Magic'].OccultAcumen.RecoverMP)
					end
					equip(sets.buff['Mana Wall'])
				elseif state.AutoCoatMode.value == '30' then
					if player.mpp < 30 then
						if state.CastingMode.value == 'Normal' then
							equip(sets.midcast['Elemental Magic'].RecoverMP)
						elseif state.CastingMode.value == 'MagicBurst' then
							equip(sets.midcast['Elemental Magic'].MagicBurst.RecoverMP)
						elseif state.CastingMode.value == 'OccultAcumen' then
							equip(sets.midcast['Elemental Magic'].OccultAcumen.RecoverMP)
						end
					end
				elseif state.AutoCoatMode.value == '50' then
					if player.mpp < 50 then
						if state.CastingMode.value == 'Normal' then
							equip(sets.midcast['Elemental Magic'].RecoverMP)
						elseif state.CastingMode.value == 'MagicBurst' then
							equip(sets.midcast['Elemental Magic'].MagicBurst.RecoverMP)
						elseif state.CastingMode.value == 'OccultAcumen' then
							equip(sets.midcast['Elemental Magic'].OccultAcumen.RecoverMP)
						end
					end
				elseif state.AutoCoatMode.value == '70' then
					if player.mpp < 70 then
						if state.CastingMode.value == 'Normal' then
							equip(sets.midcast['Elemental Magic'].RecoverMP)
						elseif state.CastingMode.value == 'MagicBurst' then
							equip(sets.midcast['Elemental Magic'].MagicBurst.RecoverMP)
						elseif state.CastingMode.value == 'OccultAcumen' then
							equip(sets.midcast['Elemental Magic'].OccultAcumen.RecoverMP)
						end
					end				
				end
			end
		end
	end		
	
	set_elemental_obi_cape_ring(spell, spellMap)

end

function job_aftercast(spell, action, spellMap, eventArgs)
	
	Update_Weapons()

end