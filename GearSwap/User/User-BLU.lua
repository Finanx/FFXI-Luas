include('/User/roller-ring.lua')

function job_state_change(stateField, newValue, oldValue)
    handle_equipping_gear(player.status)
end

function job_handle_equipping_gear(playerStatus, eventArgs)
    Update_Weapons()
end

function Update_Weapons()
		enable('main','sub')

		local w = state.Weapons.value
		equip(sets.weapons[w])

		local sub = state.Subweapon.value
		equip(sets[sub])
	
end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, spellMap, eventArgs)
	-- Add enhancement gear for Chain Affinity, etc.
	if not eventArgs.handled and spell.skill == 'Blue Magic' then
		if spellMap == 'Healing' then
			if spell.target.type == 'SELF' then
				if aoe_blue_magic_healing:contains(spell.english) then
					equip(sets.midcast['Blue Magic'].AoEHealing)
				elseif sets.Self_Healing then
					equip(sets.Self_Healing)
				end
			end
		end

		for buff,active in pairs(state.Buff) do
			if active and sets.buff[buff] then
				equip(sets.buff[buff])
			end
		end
	end
	
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
                equip(sets.midcast.LightWeatherCure)
            end
		end
    end

	-- If in learning mode, keep on gear intended to help with that, regardless of action.
	if state.LearningMode.value == true then
		equip(sets.Learning)
	end
end

function job_aftercast(spell, action, spellMap, eventArgs)
	
	Update_Weapons()

end