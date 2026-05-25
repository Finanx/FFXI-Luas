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