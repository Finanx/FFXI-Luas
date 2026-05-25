include('/Finan_libs/roller-ring.lua')

function job_state_change(stateField, newValue, oldValue)
    handle_equipping_gear(player.status)
end

function job_handle_equipping_gear(playerStatus, eventArgs)
    Update_Weapons()
end

function Update_Weapons()

    local w = state.Weapons.value

    equip(sets.weapons[w])

end

-- Run after the general precast() is done.
function job_post_precast(spell, spellMap, eventArgs)
	if spell.type == 'WeaponSkill' then
		local WSset = standardize_set(get_precast_set(spell, spellMap))
		local wsacc = check_ws_acc()
		
		if (WSset.ear1 == "Moonshade Earring" or WSset.ear2 == "Moonshade Earring") then
			-- Replace Moonshade Earring if we're at cap TP
			if get_effective_player_tp(spell, WSset) > 3200 then
				if wsacc:contains('Acc') and not buffactive['Sneak Attack'] and sets.AccMaxTP then
					equip(sets.AccMaxTP[spell.english] or sets.AccMaxTP)
				elseif sets.MaxTP then
					equip(sets.MaxTP[spell.english] or sets.MaxTP)
				else
				end
			end
		end
		
		if state.Buff['Impetus'] and (spell.english == "Ascetic's Fury" or spell.english == "Victory Smite") then
			if sets.precast.WS[spell.english] then
				if state.WeaponskillMode.value == "Normal" then
					if sets.precast.WS[spell.english].Impetus then
						equip(sets.precast.WS[spell.english].Impetus)
					end
				else
					if sets.precast.WS[spell.english][state.WeaponskillMode.value] and sets.precast.WS[spell.english][state.WeaponskillMode.value].Impetus then
						equip(sets.precast.WS[spell.english][state.WeaponskillMode.value].Impetus)
					end
				end
			end
		end
		if state.Buff['Footwork'] and (spell.english == "Dragon Kick" or spell.english	 == "Tornado Kick") then
			if sets.precast.WS[spell.english] then
				if state.WeaponskillMode.value == "Normal" then
					if sets.precast.WS[spell.english].Footwork then
						equip(sets.precast.WS[spell.english].Footwork)
					end
				else
					if sets.precast.WS[spell.english][state.WeaponskillMode.value] and sets.precast.WS[spell.english][state.WeaponskillMode.value].Footwork then
						equip(sets.precast.WS[spell.english][state.WeaponskillMode.value].Footwork)
					end
				end
			end
		end
	elseif spell.english == 'Boost' and not (in_combat or player.status == 'Engaged') and sets.precast.JA['Boost'].OutOfCombat then
		equip(sets.precast.JA['Boost'].OutOfCombat)
	end
end