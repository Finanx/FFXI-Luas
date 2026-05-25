include('/User/roller-ring.lua')

state.UnlockWeapons:set(true)

function job_self_command(cmdParams, eventArgs)

	if cmdParams[1]:lower() == 'eleshot' then
        send_command('@input /ja "'..state.Quickdraw.value..' Shot" <t>')
    end

end

function job_state_change(stateField, newValue, oldValue)
    handle_equipping_gear(player.status)
end

function job_handle_equipping_gear(playerStatus, eventArgs)
    Update_Weapons()
end

function Update_Weapons()

    local w = state.Weapons.value
    if w == 'None' then return end

    -- Equip main-hand
    equip(sets.weapons[w])
	
	-- Equip ranged weapon 
	equip(sets[state.RangeSet.value])

    if (player.sub_job == 'NIN' or player.sub_job == 'DNC') then
        equip(sets[state.Subweapon.value])
    else
        equip(sets.shield)
    end

end

function job_post_precast(spell, spellMap, eventArgs)

	if spell.type == 'WeaponSkill' then
		local WSset = standardize_set(get_precast_set(spell, spellMap))
		local wsacc = check_ws_acc()
		
		if (WSset.ear1 == "Moonshade Earring" or WSset.ear2 == "Moonshade Earring") then
			-- Replace Moonshade Earring if we're at cap TP
			if get_effective_player_tp(spell, WSset) >= 3000 then
				if data.weaponskills.elemental:contains(spell.english) then
					if wsacc:contains('Acc') and sets.MagicalAccMaxTP then
						equip(sets.MagicalAccMaxTP[spell.english] or sets.MagicalAccMaxTP)
					elseif sets.MagicalMaxTP then
						equip(sets.MagicalMaxTP[spell.english] or sets.MagicalMaxTP)
					elseif sets.MaxTP then
						equip(sets.MaxTP[spell.english] or sets.MaxTP)
					end
				elseif spell.skill == 26 then
					if wsacc:contains('Acc') and sets.RangedAccMaxTP then
						equip(sets.RangedAccMaxTP[spell.english] or sets.RangedAccMaxTP)
					elseif sets.RangedMaxTP then
						equip(sets.RangedMaxTP[spell.english] or sets.RangedMaxTP)
					elseif sets.MaxTP then
						equip(sets.MaxTP[spell.english] or sets.MaxTP)
					end
				else
					if wsacc:contains('Acc') and not buffactive['Sneak Attack'] and sets.AccMaxTP then
						equip(sets.AccMaxTP[spell.english] or sets.AccMaxTP)
					elseif sets.MaxTP then
						equip(sets.MaxTP[spell.english] or sets.MaxTP)
					end
				end
			end
		end
	elseif spell.type == 'CorsairRoll' or spell.english == "Double-Up" then
		if state.LuzafRing.value and item_available("Luzaf's Ring") then
			equip(sets.precast.LuzafRing)
		end
	elseif spell.english == 'Fold' and buffactive['Bust'] == 2 and sets.precast.FoldDoubleBust then
		equip(sets.precast.FoldDoubleBust)
	end
	
	if spell.type == 'CorsairShot' and not (spell.english == 'Light Shot' or spell.english == 'Dark Shot') then
        -- Elemental shots → use your state
        if state.CorsairShot.value == 'Store_TP' then
            equip(sets.precast.CorsairShot)
        else
            equip(sets.precast.CorsairShot.Damage)
        end

        return
    end
	
	if uses_ammo(spell) then
		check_rare_ammo(spell, spellMap, eventArgs)
	end
	
end

function job_post_midcast(spell, spellMap, eventArgs)
	if spell.action_type == 'Ranged Attack' then
		if state.Buff['Triple Shot'] then
			if (state.RangeSet.value == 'Armageddon' or state.RangeSet.value == 'Earp') and buffactive['Aftermath'] then
				if state.RangedMode.value == 'Acc' then
					equip(sets.TripleShot_AM.Acc)
				else
					equip(sets.TripleShot_AM)
				end
			else
				if state.RangedMode.value == 'Acc' then
					equip(sets.TripleShot.Acc)
				else
					equip(sets.TripleShot)
				end
			end
		end
		if state.TrueShotMode.value and sets.TrueShot and check_sweetspot(spell) then
			equip(sets.TrueShot)
		end
		if state.Buff.Barrage and sets.buff.Barrage then
			equip(sets.buff.Barrage)
		end
	end
end

-- Override Selindrile's update_combat_form with dual-axis logic
function update_combat_form()
    local w = state.Weapons.value
    local wielding = wielding()

    -- Clear custom groups every time
	--classes.CustomMeleeGroups:clear()

    if dagger_weapons[w] then
		if (player.sub_job == 'NIN' or player.sub_job == 'DNC') then
			state.CombatForm:set('Dagger_DW')
		else
			state.CombatForm:set('Dagger')
		end
    elseif sets.engaged.DW and (wielding == 'Dual Wielding' or (state.Weapons.value == 'None' and can_dual_wield)) then
        state.CombatForm:set('DW')
	else
        state.CombatForm:reset()
    end

end

function get_ra_ammo()
    if state.RangedMode and state.RangedMode.value == 'Acc' then
        return gear.Accbullet
    else
        return gear.RAbullet
    end
end

function job_aftercast(spell, action, spellMap, eventArgs)
	
	Update_Weapons()

end