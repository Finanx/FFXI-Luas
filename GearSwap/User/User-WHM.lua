include('/Finan_libs/roller-ring.lua')

function job_self_command(cmdParams, eventArgs)

	if cmdParams[1]:lower() == 'barspell' then
        send_command('@input /ma '..state.Barspell.value..' <me>')
    elseif cmdParams[1]:lower() == 'barstatus' then
        send_command('@input /ma '..state.BarStatus.value..' <me>')
    elseif cmdParams[1]:lower() == 'boostspell' then
        send_command('@input /ma '..state.BoostSpell.value..' <me>')
    end

end

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
			local grip = state.Grip.value
			if state.Weapons.value == 'Xoanon' then
				equip(sets.Ultio)
			else
				equip(sets[grip])
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

--[[    local cure_maps = {
        Cure = true,
        CureSolace = true,
        CureSelf = true,
        CureSolaceSelf = true,
        LightWeatherCure = true,
        LightDayCure = true,
        LightWeatherCureSolace = true,
        LightDayCureSolace = true,
        MeleeCure = true,
        MeleeCureSolace = true,
        MeleeLightWeatherCure = true,
        MeleeLightDayCure = true,
        MeleeLightWeatherCureSolace = true,
        MeleeLightDayCureSolace = true,
    }

    local curaga_maps = {
        Curaga = true,
        CuragaSelf = true,
        LightWeatherCuraga = true,
        LightDayCuraga = true,
    }

    if cure_maps[spellMap] then

        if state.SpellInterrupt.value then
            equip(sets.midcast.Cure_SpellInterrupt)
            return
        end

        equip(sets.midcast.Cure)

        -- 3) Weather/day override
        if world.weather_element == 'Light' or world.day_element == 'Light' then
            equip(sets.midcast.LightWeatherCure)
        end

        -- 4) Self‑Healing LAST (overwrites waist/ring)
        if spell.target.type == 'SELF' then
            equip(sets.Self_Healing)
        end

        return
    end

    if curaga_maps[spellMap] then

        if state.SpellInterrupt.value then
            equip(sets.midcast.Cure_SpellInterrupt)
            return
        end

        equip(sets.midcast.Curaga)

        if world.weather_element == 'Light' or world.day_element == 'Light' then
            equip(sets.midcast.CuragaWeather)
        end

        return
    end]]

    if state.MagicBurstMode.value then
        if spell.skill == 'Divine Magic' then
            if sets.midcast['Divine Magic'] and sets.midcast['Divine Magic'].MagicBurst then
                equip(sets.midcast['Divine Magic'].MagicBurst)
                return
            end
        end

        if spell.skill == 'Elemental Magic' then
            if sets.midcast['Elemental Magic'] and sets.midcast['Elemental Magic'].MagicBurst then
                equip(sets.midcast['Elemental Magic'].MagicBurst)
                return
            end
        end
    end
	
	
end


function job_aftercast(spell, action, spellMap, eventArgs)
	
	Update_Weapons()

end
