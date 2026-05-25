include('/Finan_libs/roller-ring.lua')

last_weapon_set = nil

function job_state_change(stateField, newValue, oldValue)
    handle_equipping_gear(player.status)
end

function job_handle_equipping_gear(playerStatus, eventArgs)
    Update_Weapons()
end

texts = texts or require('texts')

luopan_box = texts.new({
    pos = {x = 4020, y = 880},
    text = {font = 'Arial', size = 20},
    bg = {alpha = 150},
    flags = {draggable = true},
})

luopan_box:hide()

function update_luopan_hp()
    local pet = windower.ffxi.get_mob_by_target('pet')

    if pet and pet.hpp then
		if state.ShowPetHP.value == true then
			luopan_box:text(string.format("Luopan HP: %d%%", pet.hpp))
			luopan_box:show()
		else
			luopan_box:hide()
		end
	else
		luopan_box:hide()
    end
end

-- Live update every frame
windower.register_event('prerender', function()
    update_luopan_hp()
end)

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

function user_job_precast(spell, spellMap, eventArgs)

    if spell.skill == 'Geomancy' then
		if state.UnlockGeomancy.value == 'Always' then
			-- Skip this logic entirely if Entrust is active 
			if state.Buff.Entrust then
				return
			end
		
			-- Save current weapon set BEFORE changing it
			last_weapon_set = state.Weapons.value

			enable('main','sub')
			state.Weapons:set('None')
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
                equip(sets.midcast.CuragaWeather)
            end
		end
	elseif spell.skill == 'Geomancy' then
		if state.Buff.Entrust then
			equip(sets.entrust)
		end
    end
	
end

function job_aftercast(spell, action, spellMap, eventArgs)

	-- Only restore if we actually saved something 
	if last_weapon_set and last_weapon_set ~= 'None' then 
		state.Weapons:set(last_weapon_set) 
	end 
	-- Clear memory so it doesn't fire again 
	last_weapon_set = nil

	Update_Weapons()

end

-- Function that watches pet gain and loss.
function job_pet_change(pet, gain)
	if not gain then
		used_ecliptic = false
	end

	if blazelocked then
		internal_enable_set("Ability")
		blazelocked = false
	end
	
	update_luopan_hp()
end

function job_pet_status_change(new, old) 
	update_luopan_hp() 
end 

function job_pet_aftercast(spell, action, spellMap, eventArgs) 
	update_luopan_hp() 
end