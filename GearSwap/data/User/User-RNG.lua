include('/Finan_libs/roller-ring.lua')

data.weaponskills.ranged = S{
    -- Bow
    "Flaming Arrow","Piercing Arrow","Dulling Arrow","Sidewinder","Blast Arrow",
    "Arching Arrow","Empyreal Arrow","Refulgent Arrow","Apex Arrow","Namas Arrow",
    "Jishnu's Radiance","Sarv",

    -- Gun
    "Hot Shot","Split Shot","Sniper Shot","Slug Shot","Blast Shot",
    "Heavy Shot","Detonator","Numbing Shot","Last Stand","Coronach",
    "Trueflight","Leaden Salute","Wildfire","Myrkr","Terminus"
}

data.weaponskills.elemental = S{
    -- Gun / Bow Elemental
    "Flaming Arrow","Hot Shot","Leaden Salute","Trueflight","Wildfire",

    -- Sword / Dagger / Club
    "Aeolian Edge","Burning Blade","Cataclysm","Flash Nova","Red Lotus Blade",
    "Sanguine Blade","Seraph Blade","Seraph Strike","Shining Blade","Shining Strike",

    -- Scythe / Great Sword / Polearm
    "Dark Harvest","Frostbite","Freezebite","Herculean Slash","Infernal Scythe",
    "Raiden Thrust","Shadow of Death","Thunder Thrust",

    -- Axe / Great Axe
    "Cloudsplitter","Gale Axe","Primal Rend",

    -- Staff
    "Earth Crusher","Garland of Bliss","Rock Crusher","Starburst","Sunburst",

    -- Katana
    "Blade: Chi","Blade: Ei","Blade: Teki","Blade: To","Blade: Yu",

    -- Great Katana
    "Tachi: Goten","Tachi: Jinpu","Tachi: Kagero","Tachi: Koki","Tachi: Koki"
}


function job_self_command(cmdParams, eventArgs)
    if cmdParams[1] == 'update_ranged_exec' then
        check_ranged_weapon_type()

        if RangedWeaponType == 'Gun' then
            send_command('exec /RNG/Marksman-Alt-Binds.txt')
        elseif RangedWeaponType == 'Bow' then
            send_command('exec /RNG/Bow-Alt-Binds.txt')
        elseif RangedWeaponType == 'Crossbow' then
            send_command('exec /RNG/Marksman-Alt-Binds.txt')
        end
    end
end

function job_state_change(stateField, newValue, oldValue)
	Update_Weapons()
end

function Update_Weapons()

    local w = state.Weapons.value
    if w == 'None' then return end

    -- Equip main-hand
    equip(sets.weapons[w])
	
	--Equip ranged weapon 
	equip(sets[state.RangeSet.value])
	check_ranged_weapon_type()
	equip({ammo = get_idle_ammo()})

    if (player.sub_job == 'NIN' or player.sub_job == 'DNC') then
        equip(sets[state.Subweapon.value])
    else
        equip(sets.shield)
    end

end

RareAmmo = {
    ['Bayeux Bullet'] = true,
    ['Hauksbok Arrow'] = true,
	['Hauksbok Bullet'] = true,
	['Animikii Bullet'] = true,
	['Hauksbok Bolt'] = true,
}

function Determine_ammo(spell)
    -- Helper: primary → Default → Spare → nil
    local function pick(primary)
        -- Primary
        if primary and count_ammo(primary) > 0 then
            return primary
        end

        -- Default fallback
        local default = DefaultAmmo[RangedWeaponType].Default
        if default and count_ammo(default) > 0 then
            return default
        end

        -- Spare fallback
        local spare = DefaultAmmo[RangedWeaponType].Spare
        if spare and count_ammo(spare) > 0 then
            return spare
        end

        -- Nothing available
        return nil
    end

    -- Ranged Attack
    if spell.action_type == 'Ranged Attack' then
        if state.RangedMode.value == 'Acc' or state.RangedMode.value == 'FullAcc' then
            return pick(DefaultAmmo[RangedWeaponType].Acc)
        else
            return pick(DefaultAmmo[RangedWeaponType].Default)
        end
    end
	
    -- Ranged Attack
    if spell.english == 'Eagle Eye Shot' then
		if state.RangedMode.value == 'Normal' then
			equip(sets.precast.JA['Eagle Eye Shot'])
            return pick(DefaultAmmo[RangedWeaponType].Default)	
        elseif state.RangedMode.value == 'Acc' then 
			equip(sets.precast.JA['Eagle Eye Shot'].Acc)
			return pick(DefaultAmmo[RangedWeaponType].Acc)
		elseif state.RangedMode.value == 'FullAcc' then
			equip(sets.precast.JA['Eagle Eye Shot'].FullAcc)
            return pick(DefaultAmmo[RangedWeaponType].Acc)
        end
    end

    -- Bounty Shot
    if spell.english == 'Bounty Shot' then
        return pick(DefaultAmmo[RangedWeaponType].Acc)
    end

    -- Unlimited Shot WS
    if state.Buff['Unlimited Shot'] and spell.type == 'WeaponSkill' then
        if data.weaponskills.elemental:contains(spell.name) then
            if check_ws_acc():contains('Acc') then
                return pick(DefaultAmmo[RangedWeaponType].MagicAccUnlimited)
            else
                return pick(DefaultAmmo[RangedWeaponType].MagicUnlimited)
            end
        else
            return pick(DefaultAmmo[RangedWeaponType].Unlimited)
        end
    end

    -- User disabled default ammo logic
    if not state.UseDefaultAmmo.value then
        return nil
    end

    -- Shadowbind
    if spell.english == 'Shadowbind' then
        return pick(DefaultAmmo[RangedWeaponType].Default)
    end


    -- WeaponSkills
    if spell.type == 'WeaponSkill' then
        if data.weaponskills.elemental:contains(spell.name) then
            if check_ws_acc():contains('Acc') then
                return pick(DefaultAmmo[RangedWeaponType].MagicAcc)
            else
                return pick(DefaultAmmo[RangedWeaponType].Magic)
            end
        elseif data.weaponskills.ranged:contains(spell.name) then
            if check_ws_acc():contains('Acc') then
                return pick(DefaultAmmo[RangedWeaponType].Acc)
            else
                return pick(DefaultAmmo[RangedWeaponType].WS)
            end
        else
            return pick(DefaultAmmo[RangedWeaponType].MeleeWS)
        end
    end

    return nil
end

function check_rare_ammo_user(spell, eventArgs)
    if not uses_ammo(spell) then return end

    -- This is the ONLY ammo value we trust
    local desired = LastDesiredAmmo

    -- If Determine_ammo() returned nil → no safe ammo exists
    if desired == nil then
        -- If current ammo is rare, empty it
        local current = player.equipment.ammo
        if RareAmmo[current] and not buffactive['Unlimited Shot'] then
            add_to_chat(123, "Rare ammo '"..current.."' and no safe ammo — emptying slot.")
            equip({ammo = empty})
            -- eventArgs.cancel = true  -- optional
        end
    end
end

function count_ammo(name)
    if not name then return 0 end
    local total = 0

    local sources = {
        player.inventory,
        player.wardrobe,
        player.wardrobe2,
        player.wardrobe3,
        player.wardrobe4,
        player.wardrobe5,
        player.wardrobe6,
        player.wardrobe7,
        player.wardrobe8
    }

    for _,bag in pairs(sources) do
        if bag and bag[name] then
            total = total + bag[name].count
        end
    end

    return total
end

function warn_low_ammo(spell)
    if not uses_ammo(spell) then
        return
    end

    local ammo = LastDesiredAmmo

    -- Skip rare ammo entirely
    if RareAmmo[ammo] then
        return
    end

    local count = count_ammo(ammo)

    if count > 0 and count < 15 then
        add_to_chat(122, "Warning: Ammo '"..ammo.."' low ("..count.." remaining).")
    end
end

function job_precast(spell, spellMap, eventArgs)
	if spell.action_type == 'Ranged Attack' then
		state.CombatWeapon:set(player.equipment.range)
	end
	
	if spell.action_type == 'Ranged Attack' then
		if buffactive.Flurry then
			if lastflurry == 1 then
				if sets.precast.RA[state.RangeSet.value] and sets.precast.RA[state.RangeSet.value].Flurry then
					equip(sets.precast.RA[state.RangeSet.value].Flurry)
				elseif sets.precast.RA.Flurry then
					equip(sets.precast.RA.Flurry)
				end
			elseif lastflurry == 2 then
				if sets.precast.RA[state.RangeSet.value] and sets.precast.RA[state.RangeSet.value].Flurry2 then
					equip(sets.precast.RA[state.RangeSet.value].Flurry2)
				elseif sets.precast.RA.Flurry2 then
					equip(sets.precast.RA.Flurry2)
				end
			end
		end
	end
	
end

function job_post_precast(spell, spellMap, eventArgs)

    LastDesiredAmmo = Determine_ammo(spell)

    if LastDesiredAmmo then
        equip({ammo = LastDesiredAmmo})
    end

    check_rare_ammo_user(spell, eventArgs)
    warn_low_ammo(spell)

	if spell.type == 'WeaponSkill' then
		local WSset = standardize_set(get_precast_set(spell, spellMap))
		local wsacc = check_ws_acc()
		
		if (WSset.ear1 == "Moonshade Earring" or WSset.ear2 == "Moonshade Earring") then
			-- Replace Moonshade Earring if we're at cap TP
			if get_effective_player_tp(spell, WSset) > 3200 then
				if data.weaponskills.elemental:contains(spell.english) then
					if wsacc:contains('Acc') and sets.MagicalAccMaxTP then
						equip(sets.MagicalAccMaxTP[spell.english] or sets.MagicalAccMaxTP)
					elseif sets.MagicalMaxTP then
						equip(sets.MagicalMaxTP[spell.english] or sets.MagicalMaxTP)
					else
					end
				elseif S{25,26}:contains(spell.skill) then
					if wsacc:contains('Acc') and sets.RangedAccMaxTP then
						equip(sets.RangedAccMaxTP[spell.english] or sets.RangedAccMaxTP)
					elseif sets.RangedMaxTP then
						equip(sets.RangedMaxTP[spell.english] or sets.RangedMaxTP)
					else
					end
				else
					if wsacc:contains('Acc') and not buffactive['Sneak Attack'] and sets.AccMaxTP then
						equip(sets.AccMaxTP[spell.english] or sets.AccMaxTP)
					elseif sets.MaxTP then
						equip(sets.MaxTP[spell.english] or sets.MaxTP)
					else
					end
				end
			end
		end
	end
	
end

function job_midcast(spell, action, spellMap, eventArgs)

end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_post_midcast(spell, spellMap, eventArgs)
	if spell.action_type == 'Ranged Attack' then
		if state.Buff['Camouflage'] and sets.buff.Camouflage then
			if sets.buff['Camouflage'][state.RangedMode.value] then
				equip(sets.buff['Camouflage'][state.RangedMode.value])
			else
				equip(sets.buff['Camouflage'])
			end
		end
		if state.Buff['Double Shot'] then
			if state.RangedMode.value == 'Normal' then
				equip(sets.DoubleShot)
			elseif state.RangedMode.value == 'Acc' then
				equip(sets.DoubleShot.Acc)
			elseif state.RangedMode.value == 'FullAcc' then
				equip(sets.DoubleShot.FullAcc)
			end
		end
		if state.TrueShotMode.value and sets.TrueShot and check_sweetspot(spell) then
			equip(sets.TrueShot)
		end
		if state.Buff.Barrage and sets.buff.Barrage then
			if state.RangedMode.value == 'Normal' then
				equip(sets.buff.Barrage)
			elseif state.RangedMode.value == 'Acc' then
				equip(sets.buff.Barrage.Acc)
			elseif state.RangedMode.value == 'FullAcc' then
				equip(sets.buff.Barrage.FullAcc)
			end
		end
	end
	
end

function get_idle_ammo()
    if RangedWeaponType ~= 'None' and DefaultAmmo[RangedWeaponType] then
        return DefaultAmmo[RangedWeaponType].Idle
    end
    return nil
end

function job_customize_melee_set(meleeSet)
    meleeSet.ammo = DefaultAmmo[RangedWeaponType].MeleeWS
    return meleeSet
end

function job_aftercast(spell, spellMap, eventArgs)
	Update_Weapons()
		equip({ammo=DefaultAmmo[RangedWeaponType].Idle})
end