-- Original: Finanx
-- Dressup is setup to auto load with this Lua
-- Itemizer addon is required for auto gear sorting / Warp Scripts / Range Scripts
--
-------------------------------------------------------------------------------------------------------------------
--  Keybinds
-------------------------------------------------------------------------------------------------------------------

--  Modes:      	[ F9 ]              Cycle Offense Mode
--              	[ F10 ]             Cycle Idle Mode
--              	[ F11 ]             Cycle Casting Mode
--              	[ F12 ]             Update Current Gear / Report Current Status
--					[ CTRL + F9 ]		Cycle Weapon Skill Mode
--					[ ALT + F9 ]		Cycle Range Mode
--              	[ Windows + F9 ]    Cycle Hybrid Modes
--					[ Windows + ` ]		Toggles Treasure Hunter Mode
--              	[ Windows + C ]     Toggle Capacity Points Mode
--
--  Abilities:  	[ CTRL + ` ]        Hasso
--
--  Weapons:    	[ CTRL + W ]		Toggle Weapon sets
--					[ CTRL + E]			Toggle Grip Sets
--
--  WS:         	[ CTRL + Numpad1 ]    Tachi: Fudo
--					[ CTRL + Numpad2 ]    Tachi: Shoha
--					[ CTRL + Numpad3 ]    Tachi: Kasha
--					[ CTRL + Numpad4 ]    Tachi: Ageha
--					[ CTRL + Numpad5 ]    Tachi: Jinpu
--					[ CTRL + Numpad6 ]    Tachi: Yukikaze
--					[ CTRL + Numpad7 ]    Tachi: Rana
--				
--					[ ALT + Numpad1 ]     Impulse Drive
--
-- Item Binds:		[ Shift + Numpad1 ]	Echo Drop
--					[ Shift + Numpad2 ]	Holy Water
--					[ Shift + Numpad3 ]	Remedy
--					[ Shift + Numpad4 ]	Panacea
--					[ Shift + Numpad7 ]	Silent Oil
--					[ Shift + Numpad9 ]	Prism Powder
--
--					[ Windows + Numpad1 ]	Sublime Sushi
--					[ Windows + Numpad2 ]	Grape Daifuku
--					[ Windows + Numpad3 ]	Tropical Crepe
--					[ Windows + Numpad4 ]	Miso Ramen
--					[ Windows + Numpad5 ]	Red Curry Bun
--					[ Windows + Numpad7 ]	Toolbag (Shihei)
--
-- Warp Script:		[ CTRL + Numpad+ ]	Warp Ring
--					[ ALT + Numpad+ ]	Dimensional Ring Dem
--
-- Range Script:	[ CTRL + Numpad0 ] Ranged Attack
--
-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()

	include('Mote-TreasureHunter')

    state.Buff.Hasso = buffactive.Hasso or false
    state.Buff.Seigan = buffactive.Seigan or false
    state.Buff.Sekkanoki = buffactive.Sekkanoki or false
    state.Buff.Sengikori = buffactive.Sengikori or false
    state.Buff['Meikyo Shisui'] = buffactive['Meikyo Shisui'] or false
	
	state.WeaponSet = M{['description']='Weapon Set', 'Dojikiri', 'Norifusa', 'Soboro' }
	state.GripSet = M{['description']='Grip Set', 'Utu'}
	
	lockstyleset = 13
	
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc')
    state.HybridMode:options('Normal', 'DT')
    state.WeaponskillMode:options('Normal', 'Acc')
	state.TreasureMode:options('Tag', 'None')

    update_combat_form()
	
	--Load Dressup Lua

	send_command('wait 10; lua l Dressup')
    
    --Global Samurai binds (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)	

	send_command('bind @t gs c cycle TreasureMode')
	send_command('bind @w gs c cycle WeaponSet')
	send_command('bind @e gs c cycle GripSet')
    send_command('bind ^` input /ja "Hasso" <me>')
	
	--Weaponskill Binds (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)

    send_command('bind ^numpad1 input /ws "Tachi: Fudo" <t>')
    send_command('bind ^numpad2 input /ws "Tachi: Shoha" <t>')
    send_command('bind ^numpad3 input /ws "Tachi: Kasha" <t>')
	send_command('bind ^numpad4 input /ws "Tachi: Ageha" <t>')
    send_command('bind ^numpad5 input /ws "Tachi: Jinpu" <t>')
    send_command('bind ^numpad6 input /ws "Tachi: Yukikaze" <t>')
	send_command('bind ^numpad7 input /ws "Tachi: Rana" <t>')
	
	send_command('bind !numpad1 input /ws "Impulse Drive" <t>')
	
	--Dual Box binds (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)
	
	--send_command('bind @1 input //assist me; wait 0.5; input //send Aurorasky /attack')
	--send_command('bind @2 input //assist me; wait 0.5; input //send Ardana /attack')
	--send_command('bind @q input //assist me; wait 0.5; input //send Ardana /ma "Distract" <t>')
	
	--Item binds (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)
	
	send_command('bind ~numpad1 input /item "Echo Drops" <me>')
	send_command('bind ~numpad2 input /item "Holy Water" <me>')
    send_command('bind ~numpad3 input /item "Remedy" <me>')
    send_command('bind ~numpad4 input /item "Panacea" <me>')
	send_command('bind ~numpad7 input /item "Silent Oil" <me>')
	send_command('bind ~numpad9 input /item "Prism Powder" <me>')
	
	send_command('bind @numpad1 input /item "Sublime Sushi" <me>')
	send_command('bind @numpad2 input /item "Grape Daifuku" <me>')
	send_command('bind @numpad3 input /item "Tropical Crepe" <me>')
	send_command('bind @numpad4 input /item "Miso Ramen" <me>')
	send_command('bind @numpad5 input /item "Red Curry Bun" <me>')
	send_command('bind @numpad7 input //get Toolbag (Shihe) satchel; wait 3; input /item "Toolbag (Shihei)" <me>')
		
	--Ranged Scripts  (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)

	send_command('bind ^numpad0 input /ra <t>')

	--Warp scripts (this allows the ring to stay in your satchel fulltime) (Requires Itemizer Addon) (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)

	send_command('bind ^numpad+ input //get Warp Ring satchel; wait 1; input /equip Ring1 "Warp Ring"; wait 12; input /item "Warp Ring" <me>; wait 60; input //put Warp Ring satchel')
	send_command('bind !numpad+ input //get Dim. Ring (Dem) satchel; wait 1; input /equip Ring1 "Dim. Ring (Dem)"; wait 12; input /item "Dim. Ring (Dem)" <me>; wait 60; input //put Dim. Ring (Dem) satchel')
	
	--Gear Retrieval Commands 
	
	send_command('wait 10; input //get Dojikiri Yasutsuna Case')
	send_command('wait 10; input //get Norifusa Case')
	send_command('wait 10; input //get Soboro Sukehiro Case')
	send_command('wait 10; input //get Utu Grip Case')
	send_command('wait 10; input //get Smertrios\'s Mantle Case all')
	send_command('wait 10; input //get Takaha Mantle Case')

	--Job Settings

    set_lockstyle()
    select_default_macro_book()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()

	--Remove Global Samurai Binds
	
    send_command('unbind @t')
    send_command('unbind @w')
    send_command('unbind @e')
	send_command('unbind ^`')
	
	--Remove Dual Box Binds
	
	send_command('unbind @1')
	send_command('unbind @2')
	send_command('unbind @q')
	
	--Remove Weaponskill Binds
    
	send_command('unbind ^numpad1')
    send_command('unbind ^numpad2')
    send_command('unbind ^numpad3')
    send_command('unbind ^numpad4')
    send_command('unbind ^numpad5')
    send_command('unbind ^numpad6')
	send_command('unbind ^numpad7')
	send_command('unbind ^numpad8')
	send_command('unbind ^numpad9')
	
	send_command('unbind !numpad1')
    send_command('unbind !numpad2')
	send_command('unbind !numpad3')
    send_command('unbind !numpad4')
	send_command('unbind !numpad5')
    send_command('unbind !numpad6')
	send_command('unbind !numpad7')
	send_command('unbind !numpad8')
	send_command('unbind !numpad9')
	
	
	--Remove Item Binds
	
	send_command('unbind ~numpad1')
    send_command('unbind ~numpad2')
	send_command('unbind ~numpad3')
    send_command('unbind ~numpad4')
	send_command('unbind ~numpad5')
    send_command('unbind ~numpad6')
	send_command('unbind ~numpad7')
	send_command('unbind ~numpad8')
	send_command('unbind ~numpad9')
	
	send_command('unbind @numpad1')
    send_command('unbind @numpad2')
	send_command('unbind @numpad3')
    send_command('unbind @numpad4')
	send_command('unbind @numpad5')
    send_command('unbind @numpad6')
	send_command('unbind @numpad7')
	send_command('unbind @numpad8')
	send_command('unbind @numpad9')
	
	--Remove Ranged Scripts
	
	send_command('unbind ^numpad0')
	
	--Remove Warp Scripts
	
	send_command('unbind ^numpad+')
	send_command('unbind !numpad+')
	
	--Gear Removal Commands

	send_command('wait 5; input //put Dojikiri Yasutsuna Case')
	send_command('wait 5; input //put Norifusa Case')
	send_command('wait 5; input //put Soboro Sukehiro Case')
	send_command('wait 5; input //put Utu Grip Case')
	send_command('wait 5; input //put Smertrios\'s Mantle Case all')
	send_command('wait 5; input //put Takaha Mantle Case all')
	
	--Unload Dressup Lua
	
    send_command('lua u Dressup')

end


-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
    
    -- Precast Sets
    -- Precast sets to enhance JAs

    sets.precast.JA.Meditate = {head="Myochin Kabuto",hands="Sakonji Kote"}
    sets.precast.JA['Warding Circle'] = {head="Myochin Kabuto"}
    sets.precast.JA['Blade Bash'] = {hands="Sakonji Kote"}

    -- Waltz set (chr and vit)

    sets.precast.Waltz = {}
        
    -- Don't need any special gear for Healing Waltz.

    sets.precast.Waltz['Healing Waltz'] = {}

       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined

    sets.precast.WS = {
		ammo="Knobkierrie",
		head={ name="Valorous Mask", augments={'Accuracy+13','Weapon skill damage +5%','STR+5',}},
		body="Flamma Korazin +2",
		hands={ name="Valorous Mitts", augments={'Weapon skill damage +4%','STR+8','Accuracy+15 Attack+15','Mag. Acc.+17 "Mag.Atk.Bns."+17',}},
		legs="Hiza. Hizayoroi +2",
		feet={ name="Valorous Greaves", augments={'Attack+30','Weapon skill damage +4%','DEX+3','Accuracy+15',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Regal Ring",
		back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.

    sets.precast.WS['Tachi: Ageha'] = {
		ammo="Knobkierrie",
		head="Flam. Zucchetto +2",
		body="Flamma Korazin +2",
		hands="Flam. Manopolas +2",
		legs="Hiza. Hizayoroi +2",
		feet="Flam. Gambieras +2",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Telos Earring",
		right_ear="Digni. Earring",
		left_ring="Rufescent Ring",
		right_ring="Flamma Ring",
		back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

    sets.precast.WS['Tachi: Jinpu'] = {
		ammo="Knobkierrie",
		head={ name="Valorous Mask", augments={'Accuracy+13','Weapon skill damage +5%','STR+5',}},
		body={ name="Found. Breastplate", augments={'Accuracy+9','Mag. Acc.+8','"Mag.Atk.Bns."+12',}},
		hands={ name="Founder's Gauntlets", augments={'STR+10','Attack+15','"Mag.Atk.Bns."+15','Phys. dmg. taken -5%',}},
		legs="Hiza. Hizayoroi +2",
		feet={ name="Founder's Greaves", augments={'VIT+10','Accuracy+15','"Mag.Atk.Bns."+15','Mag. Evasion+15',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Friomisi Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Regal Ring",
		right_ring="Niqmaddu Ring",
		back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}



    -- Midcast Sets
 
	sets.midcast.FastRecast = {}

    

    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)

    sets.idle = {
		ammo="Staunch Tathlum +1",
		head="Flam. Zucchetto +2",
		body="Ken. Samue",
		hands="Kurys Gloves",
		legs="Ken. Hakama",
		feet={ name="Founder's Greaves", augments={'VIT+10','Accuracy+15','"Mag.Atk.Bns."+15','Mag. Evasion+15',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Flume Belt +1",
		left_ear="Genmei Earring",
		right_ear="Etiolation Earring",
		left_ring="Defending Ring",
		right_ring="Vocane Ring",
		back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Damage taken-5%',}},}
    

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Normal melee group
    -- Delay 450 GK, 25 Save TP => 65 Store TP for a 5-hit (25 Store TP in gear)

    sets.engaged = {
		ammo="Ginsen",
		head="Flam. Zucchetto +2",
		body="Ken. Samue",
		hands="Wakido Kote +3",
		legs="Ken. Hakama",
		feet="Flam. Gambieras +2",
		neck="Moonbeam Nodowa",
		waist="Ioskeha Belt",
		left_ear="Telos Earring",
		right_ear="Dedition Earring",
		left_ring="Flamma Ring",
		right_ring="Niqmaddu Ring",
		back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Damage taken-5%',}},}

	sets.engaged.Acc = {
		ammo="Ginsen",
		head="Flam. Zucchetto +2",
		body="Ken. Samue",
		hands="Wakido Kote +3",
		legs="Ken. Hakama",
		feet="Flam. Gambieras +2",
		neck="Moonbeam Nodowa",
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear="Telos Earring",
		right_ear="Mache Earring +1",
		left_ring="Flamma Ring",
		right_ring="Regal Ring",
		back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Damage taken-5%',}},}
		
	sets.engaged.Crit = {
		ammo="Ginsen",
		head="Flam. Zucchetto +2",
		body="Ken. Samue",
		hands="Wakido Kote +3",
		legs="Ken. Hakama",
		feet="Flam. Gambieras +2",
		neck="Moonbeam Nodowa",
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear="Telos Earring",
		right_ear="Mache Earring +1",
		left_ring="Flamma Ring",
		right_ring="Regal Ring",
		back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Damage taken-5%',}},}
		
		
   
	sets.engaged.Hybrid = {
		ammo="Staunch Tathlum +1",																											--3%
		head="Flam. Zucchetto +2",
		body="Ken. Samue",
		hands="Wakido Kote +3",
		legs="Ken. Hakama",
		feet="Flam. Gambieras +2",
		neck={ name="Loricate Torque +1", augments={'Path: A',}},																											--6%
		waist="Flume Belt +1",																												--4%PDT
		left_ear="Telos Earring",
		right_ear="Genmei Earring",																											--2%PDT
		left_ring="Defending Ring",																											--10%
		right_ring="Vocane Ring",																											--7%
		back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Damage taken-5%',}},}	--5%
		--31% DT + 6% PDT
	
	sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)	


    sets.buff.Sekkanoki = {hands="Unkai Kote +2"}
    sets.buff.Sengikori = {feet="Unkai Sune-ate +2"}
    sets.buff['Meikyo Shisui'] = {feet="Sakonji Sune-ate"}
	
	
	    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------


    sets.TreasureHunter = {
		ammo="Per. Lucky Egg", --TH1
		body="Volte Jupon",		--TH2
		waist="Chaac Belt",} --TH+1

    sets.buff.Doom = {
		neck="Nicander's Necklace",
        waist="Gishdubar Sash", --10
        }
	
	sets.Dojikiri = {main={ name="Dojikiri Yasutsuna", augments={'Path: A',}},}
	sets.Norifusa = {main= "Norifusa"}
	sets.Soboro = {main= "Soboro Sukehiro"}

	sets.Utu = {sub="Utu Grip",}
	
	
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic target handling to be done.
function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.type == 'WeaponSkill' then
        -- Change any GK weaponskills to polearm weaponskill if we're using a polearm.
        if player.equipment.main=='Quint Spear' or player.equipment.main=='Quint Spear' then
            if spell.english:startswith("Tachi:") then
                send_command('@input /ws "Penta Thrust" '..spell.target.raw)
                eventArgs.cancel = true
            end
        end
    end
end

-- Run after the default precast() is done.
-- eventArgs is the same one used in job_precast, in case information needs to be persisted.
function job_post_precast(spell, action, spellMap, eventArgs)
    equip(sets[state.WeaponSet.current])
	equip(sets[state.GripSet.current])	
    if spell.type:lower() == 'weaponskill' then
        if state.Buff.Sekkanoki then
            equip(sets.buff.Sekkanoki)
        end
        if state.Buff.Sengikori then
            equip(sets.buff.Sengikori)
        end
        if state.Buff['Meikyo Shisui'] then
            equip(sets.buff['Meikyo Shisui'])
        end
    end
end

function customize_melee_set(meleeSet)
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end

    return meleeSet
end


-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    -- Effectively lock these items in place.
    if state.HybridMode.value == 'Reraise' or
        (state.DefenseMode.value == 'Physical' and state.PhysicalDefenseMode.value == 'Reraise') then
        equip(sets.Reraise)
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    update_combat_form()
	equip(sets[state.WeaponSet.current])
	equip(sets[state.GripSet.current])
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)

end

-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function update_combat_form()
    if areas.Adoulin:contains(world.area) and buffactive.ionis then
        state.CombatForm:set('Adoulin')
    else
        state.CombatForm:reset()
    end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'WAR' then
        set_macro_page(1, 11)
    elseif player.sub_job == 'DNC' then
        set_macro_page(2, 11)
    elseif player.sub_job == 'THF' then
        set_macro_page(3, 11)
    elseif player.sub_job == 'NIN' then
        set_macro_page(4, 11)
    else
        set_macro_page(1, 11)
    end
end

function set_lockstyle()
    send_command('wait 5; input /lockstyleset ' .. lockstyleset)
end
