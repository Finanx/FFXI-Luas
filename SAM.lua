-- Haste/DW Detection Requires Gearinfo Addon
-- Dressup is setup to auto load with this Lua
-- Itemizer addon is required for auto gear sorting / Warp Scripts / Range Scripts
--
-------------------------------------------------------------------------------------------------------------------
--  Keybinds (Global Binds for all Jobs)
-------------------------------------------------------------------------------------------------------------------
--  Modes:      	[ F9 ]              	Cycle Offense Mode
--              	[ F10 ]             	Cycle Idle Mode
--              	[ F11 ]             	Cycle Casting Mode
--              	[ F12 ]             	Update Current Gear / Report Current Status
--					[ CTRL + F9 ]			Cycle Weapon Skill Mode
--					[ ALT + F9 ]			Cycle Range Mode
--              	[ Windows + F9 ]    	Cycle Hybrid Modes
--					[ Windows + T ]			Toggles Treasure Hunter Mode
--              	[ Windows + C ]     	Toggle Capacity Points Mode
--              	[ Windows + R ]     	Toggle Reraise Mode
--
-- Item Binds:		[ Shift + Numpad1 ]		Echo Drop
--					[ Shift + Numpad2 ]		Holy Water
--					[ Shift + Numpad3 ]		Remedy
--					[ Shift + Numpad4 ]		Panacea
--					[ Shift + Numpad7 ]		Silent Oil
--					[ Shift + Numpad9 ]		Prism Powder
--
--					[ Windows + Numpad1 ]	Sublime Sushi
--					[ Windows + Numpad2 ]	Grape Daifuku
--					[ Windows + Numpad3 ]	Tropical Crepe
--					[ Windows + Numpad4 ]	Miso Ramen
--					[ Windows + Numpad5 ]	Red Curry Bun
--					[ Windows + Numpad6 ]	Rolanberry Daifuku
--					[ Windows + Numpad7 ]	Toolbag (Shihei)
--
-- Warp Script:		[ CTRL + Numpad+ ]		Warp Ring
--					[ ALT + Numpad+ ]		Dimensional Ring Dem
--
-- Range Script:	[ CTRL + Numpad0 ] 		Ranged Attack
--
-------------------------------------------------------------------------------------------------------------------
--  Job Specific Keybinds (Samurai Binds)
-------------------------------------------------------------------------------------------------------------------
--
--	Modes:			[ Windows + 1 ]			Sets Weapon to Dojikiri then locks Main/Sub Slots
--					[ Windows + 2 ]			Sets Weapon to Masamune then locks Main/Sub Slots
--					[ Windows + 3 ]			Sets Weapon to Shining_One then locks Main/Sub Slots
--					[ Windows + 4 ]			Sets Weapon to Hachimonji then locks Main/Sub Slots
--					[ Windows + 5 ]			Sets Weapon to Soboro then locks Main/Sub Slots
--
--  WS:         	[ CTRL + Numpad1 ]    	Tachi: Fudo
--					[ CTRL + Numpad2 ]    	Tachi: Shoha
--					[ CTRL + Numpad3 ]    	Tachi: Kasha
--					[ CTRL + Numpad4 ]    	Tachi: Ageha
--					[ CTRL + Numpad5 ]    	Tachi: Jinpu
--					[ CTRL + Numpad6 ]    	Tachi: Yukikaze
--					[ CTRL + Numpad7 ]    	Tachi: Rana
--				
--					[ ALT + Numpad1 ]		Tachi: Kagero
--					[ ALT + Numpad2 ]		Tachi: Goten
--					[ ALT + Numpad3 ]		Tachi: Koki
--					[ ALT + Numpad4 ]		Impulse Drive
--
--  Abilities:  	[ CTRL + ` ]        	Hasso
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

    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
					"Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring", "Emporox's Ring"}

	include('Mote-TreasureHunter')
	
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}

    state.Buff.Hasso = buffactive.Hasso or false
    state.Buff.Seigan = buffactive.Seigan or false
    state.Buff.Sekkanoki = buffactive.Sekkanoki or false
    state.Buff.Sengikori = buffactive.Sengikori or false
    state.Buff['Meikyo Shisui'] = buffactive['Meikyo Shisui'] or false
	
	lockstyleset = 13
	
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc')
    state.HybridMode:options('Normal', 'DT')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal')
	state.TreasureMode:options('Tag', 'None')
	state.WeaponSet = M{['description']='Weapon Set', 'Dojikiri', 'Masamune', 'Shining_One', 'Hachimonji', 'Soboro' }
	state.Reraise = M(false, "Reraise Mode")
	
	state.CP = M(false, "Capacity Points Mode")
	
	--Load Gearinfo/Dressup Lua
	
    send_command('wait 3; lua l gearinfo')
	send_command('wait 10; lua l Dressup')
    
    --Global Samurai binds (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)
	
	send_command('bind @t gs c cycle TreasureMode')
	send_command('bind @c gs c toggle CP')
	send_command('bind @r gs c toggle Reraise')
    send_command('bind ^` input /ja "Hasso" <me>')
	
	--Weapon set Binds

	send_command('bind @1 gs c set WeaponSet Dojikiri')
	--send_command('bind @2 gs c set WeaponSet Masamune')
	send_command('bind @3 gs c set WeaponSet Shining_One')
	send_command('bind @4 gs c set WeaponSet Hachimonji')
	send_command('bind @5 gs c set WeaponSet Soboro')
	
	--Weaponskill Binds (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)

    send_command('bind ^numpad1 input /ws "Tachi: Fudo" <t>')
    send_command('bind ^numpad2 input /ws "Tachi: Shoha" <t>')
    send_command('bind ^numpad3 input /ws "Tachi: Kasha" <t>')
	send_command('bind ^numpad4 input /ws "Tachi: Ageha" <t>')
    send_command('bind ^numpad5 input /ws "Tachi: Jinpu" <t>')
    send_command('bind ^numpad6 input /ws "Tachi: Yukikaze" <t>')
	send_command('bind ^numpad7 input /ws "Tachi: Rana" <t>')

	send_command('bind !numpad1 input /ws "Tachi: Kagero" <t>')
	send_command('bind !numpad2 input /ws "Tachi: Goten" <t>')
	send_command('bind !numpad3 input /ws "Tachi: Koki" <t>')
	send_command('bind !numpad4 input /ws "Impulse Drive" <t>')
	
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
	send_command('bind @numpad6 input /item "Rolanberry Daifuku" <me>')
	send_command('bind @numpad7 input //get Toolbag (Shihe) satchel; wait 3; input /item "Toolbag (Shihei)" <me>')
		
	--Ranged Scripts  (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)

	send_command('bind ^numpad0 input /ra <t>')

	--Warp scripts (this allows the ring to stay in your satchel fulltime) (Requires Itemizer Addon) (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)

	send_command('bind ^numpad+ input //get Warp Ring satchel; wait 1; input /equip Ring1 "Warp Ring"; wait 12; input /item "Warp Ring" <me>; wait 60; input //put Warp Ring satchel')
	send_command('bind !numpad+ input //get Dim. Ring (Dem) satchel; wait 1; input /equip Ring1 "Dim. Ring (Dem)"; wait 12; input /item "Dim. Ring (Dem)" <me>; wait 60; input //put Dim. Ring (Dem) satchel')
	
	--Gear Retrieval Commands 

	--Job Settings

    set_lockstyle()
    select_default_macro_book()
	
	--Gearinfo Functions

    state.Auto_Kite = M(false, 'Auto_Kite')
	
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()

	enable('main','sub','range','ammo','head','body','hands','legs','feet','neck','waist','left_ear','right_ear','left_ring','right_ring','back')

	--Remove Global Samurai Binds
	
    send_command('unbind @t')
    send_command('unbind @c')
    send_command('unbind @r')
	send_command('unbind ^`')
	send_command('unbind ^-')
	send_command('unbind ^=')
	send_command('unbind !`')
	send_command('unbind !-')
	send_command('unbind !=')
	send_command('unbind @`')
	send_command('unbind @-')
	send_command('unbind @=')
	
	--Remove Weapon Set binds
	
	send_command('unbind @1')
	send_command('unbind @2')
	send_command('unbind @3')
	send_command('unbind @4')
	send_command('unbind @5')
	send_command('unbind @6')
	send_command('unbind @7')
	send_command('unbind @8')
	send_command('unbind @9')
	send_command('unbind @0')
	
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
	send_command('unbind ^numpad.')
	
	send_command('unbind !numpad1')
    send_command('unbind !numpad2')
	send_command('unbind !numpad3')
    send_command('unbind !numpad4')
	send_command('unbind !numpad5')
    send_command('unbind !numpad6')
	send_command('unbind !numpad7')
	send_command('unbind !numpad8')
	send_command('unbind !numpad9')
	send_command('unbind !numpad.')
	
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
	send_command('unbind ~numpad.')
	
	send_command('unbind @numpad1')
    send_command('unbind @numpad2')
	send_command('unbind @numpad3')
    send_command('unbind @numpad4')
	send_command('unbind @numpad5')
    send_command('unbind @numpad6')
	send_command('unbind @numpad7')
	send_command('unbind @numpad8')
	send_command('unbind @numpad9')
	send_command('unbind @numpad.')
	
	--Remove Ranged Scripts
	
	send_command('unbind ^numpad0')
	
	--Remove Warp Scripts
	
	send_command('unbind ^numpad+')
	send_command('unbind !numpad+')
	
	--Gear Removal Commands
	
	--Unload Gearinfo/Dressup Lua

    send_command('lua u gearinfo')
	send_command('lua u Dressup')

end


-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
    
    -- Precast Sets
    -- Precast sets to enhance JAs

    sets.precast.JA.Meditate = {head="Wakido Kabuto +3",hands={ name="Sakonji Kote +3", augments={'Enhances "Blade Bash" effect',}},back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Damage taken-5%',}},}
    sets.precast.JA['Warding Circle'] = {head="Wakido Kabuto +3"}
    sets.precast.JA['Blade Bash'] = {hands={ name="Sakonji Kote +3", augments={'Enhances "Blade Bash" effect',}},}

    -- Waltz set (chr and vit)

    sets.precast.Waltz = {}
        
    -- Don't need any special gear for Healing Waltz.

    sets.precast.Waltz['Healing Waltz'] = {}

       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined

    sets.precast.WS = {
		ammo="Knobkierrie",
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Fotia Gorget",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Thrud Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Epaminondas's Ring",
		right_ring="Niqmaddu Ring",
		back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Impulse Drive'] = {
		ammo="Knobkierrie",
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Fotia Gorget",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Thrud Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Epaminondas's Ring",
		right_ring="Niqmaddu Ring",
		back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.

    sets.precast.WS['Tachi: Ageha'] = {
		ammo="Pemphredo Tathlum",
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body="Mpaca's Doublet",
		hands="Mpaca's Gloves",
		legs="Mpaca's Hose",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Sanctity Necklace",
		waist="Eschan Stone",
		left_ear="Crep. Earring",
		right_ear="Digni. Earring",
		left_ring="Stikini Ring +1",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

    sets.precast.WS['Tachi: Jinpu'] = {
		ammo="Knobkierrie",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Fotia Gorget",
		waist="Orpheus's Sash",
		left_ear="Friomisi Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Epaminondas's Ring",
		right_ring="Niqmaddu Ring",
		back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Tachi: Goten'] = sets.precast.WS['Tachi: Jinpu']
	sets.precast.WS['Tachi: Kagero'] = sets.precast.WS['Tachi: Jinpu']
	sets.precast.WS['Tachi: Koki'] = sets.precast.WS['Tachi: Jinpu']
	sets.precast.WS['Tachi: '] = sets.precast.WS['Tachi: Jinpu']


    -- Midcast Sets
 
	sets.midcast.FastRecast = {}

    

    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)

    sets.idle = {
		sub="Utu Grip",
		ammo="Staunch Tathlum +1",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Flume Belt +1",
		left_ear="Genmei Earring",
		right_ear="Sanare Earring",
		left_ring="Defending Ring",
		right_ring="Archon Ring",
		back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Damage taken-5%',}},}
    

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Normal melee group
    -- Delay 450 GK, 25 Save TP => 65 Store TP for a 5-hit (25 Store TP in gear)

    sets.engaged = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Flam. Zucchetto +2",
		body={ name="Tatena. Harama. +1", augments={'Path: A',}},
		hands="Wakido Kote +3",
		legs={ name="Tatena. Haidate +1", augments={'Path: A',}},
		feet={ name="Tatena. Sune. +1", augments={'Path: A',}},
		neck={ name="Vim Torque +1", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Schere Earring", augments={'Path: A',}},
		right_ear="Telos Earring",
		left_ring="Niqmaddu Ring",
		right_ring="Chirich Ring +1",
		back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Damage taken-5%',}},}

	sets.engaged.Acc = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Flam. Zucchetto +2",
		body={ name="Tatena. Harama. +1", augments={'Path: A',}},
		hands="Wakido Kote +3",
		legs={ name="Tatena. Haidate +1", augments={'Path: A',}},
		feet={ name="Tatena. Sune. +1", augments={'Path: A',}},
		neck={ name="Vim Torque +1", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Schere Earring", augments={'Path: A',}},
		right_ear="Telos Earring",
		left_ring="Niqmaddu Ring",
		right_ring="Chirich Ring +1",
		back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Damage taken-5%',}},}
		
	sets.engaged.Crit = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Flam. Zucchetto +2",
		body={ name="Tatena. Harama. +1", augments={'Path: A',}},
		hands="Wakido Kote +3",
		legs={ name="Tatena. Haidate +1", augments={'Path: A',}},
		feet={ name="Tatena. Sune. +1", augments={'Path: A',}},
		neck={ name="Vim Torque +1", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Schere Earring", augments={'Path: A',}},
		right_ear="Telos Earring",
		left_ring="Niqmaddu Ring",
		right_ring="Chirich Ring +1",
		back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Damage taken-5%',}},}
		
		
   
	sets.engaged.Hybrid = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Wakido Kote +3",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Dedition Earring",
		right_ear="Telos Earring",
		left_ring="Niqmaddu Ring",
		right_ring="Chirich Ring +1",
		back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Damage taken-5%',}},}
		--46% DT + 6% PDT
	
	sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)	
	
	
	------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	sets.Kiting = {feet="Danzo Sune-Ate"}

    sets.buff.Sekkanoki = {hands="Unkai Kote +2"}
    sets.buff.Sengikori = {feet="Unkai Sune-ate +2"}
    sets.buff['Meikyo Shisui'] = {feet="Sakonji Sune-ate"}

    sets.TreasureHunter = {
		ammo="Per. Lucky Egg", --TH1
		body="Volte Jupon",		--TH2
		waist="Chaac Belt",} --TH+1

    sets.buff.Doom = {
		neck="Nicander's Necklace",
        waist="Gishdubar Sash", --10
        }
	
	sets.Dojikiri = {main={ name="Dojikiri Yasutsuna", augments={'Path: A',}},}
	sets.Masamune = {main={ name="Dojikiri Yasutsuna", augments={'Path: A',}},}
	sets.Shining_One = {main='Shining One'}
	sets.Hachimonji = {main="Hachimonji"}
	sets.Soboro = {main="Soboro Sukehiro"}
	
    sets.Obi = {waist="Hachirin-no-Obi"}
	
	sets.Reraise = {head="Twilight Helm",body="Twilight Mail"}
	
	
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific Functions
-------------------------------------------------------------------------------------------------------------------

function job_post_precast(spell, action, spellMap, eventArgs)

		--Handles Job Ability Gearsets
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

function job_precast(spell, action, spellMap, eventArgs)

		--Will stop utsusemi from being cast if 2 shadows or more
	if spellMap == 'Utsusemi' then
        if buffactive['Copy Image (3)'] or buffactive['Copy Image (4+)'] then
            cancel_spell()
            add_to_chat(123, '**!! '..spell.english..' Canceled: [3+ IMAGES] !!**')
            eventArgs.handled = true
            return
        elseif buffactive['Copy Image'] or buffactive['Copy Image (2)'] then
            send_command('cancel 66; cancel 444; cancel Copy Image; cancel Copy Image (2)')
        end
    end

	    -- Equip obi if weather/day matches for WS.	
	if spell.type == 'WeaponSkill' then
        if spell.english == 'Tachi: Jinpu' and (world.weather_element == 'Wind' or world.day_element == 'Wind') then
                equip(sets.Obi)
        end
    end
end

function job_buff_change(buff,gain)

		--Auto equips Cursna Recieved doom set when doom debuff is on
    if buff == "doom" then
        if gain then
            equip(sets.buff.Doom)
            send_command('@input /p Doomed.')
            disable('neck','waist')
        else
            enable('neck','waist')
            handle_equipping_gear(player.status)
        end
    end
	
end

	--Handles Weapon set changes and Reraise set
function job_state_change(field, new_value, old_value)
 
    equip(sets[state.WeaponSet.current])
	
	if state.Reraise.current == 'on' then
        equip(sets.Reraise)
        disable('head', 'body')
    else
        enable('head', 'body')
    end
	
end

-------------------------------------------------------------------------------------------------------------------
-- Code for Melee sets
-------------------------------------------------------------------------------------------------------------------

-- Handles Gearinfo / Melee / Weapon / Range Sets
function job_handle_equipping_gear(playerStatus, eventArgs)
    update_combat_form()
    determine_haste_group()
	check_moving()
end

function job_update(cmdParams, eventArgs)
	check_gear()
    handle_equipping_gear(player.status)
end

	--Determines Dual Wield melee set
function update_combat_form()
    if DW == true then
        state.CombatForm:set('DW')
    elseif DW == false then
        state.CombatForm:reset()
    end
end

	--Handles Weapon set changes and Reraise set
function job_state_change(field, new_value, old_value)
 
    equip(sets[state.WeaponSet.current])
	
	if state.Reraise.current == 'on' then
        equip(sets.Reraise)
        disable('head', 'body')
    else
        enable('head', 'body')
    end
	
end

function customize_idle_set(idleSet)

		--Allows CP back to stay on if toggled on
    if state.CP.current == 'on' then
        equip(sets.CP)
        disable('back')
    else
        enable('back')
    end
	
	if state.Auto_Kite.value == true then
       idleSet = set_combine(idleSet, sets.Kiting)
    end
    
    return idleSet
	
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

	--Determines Haste Group / Melee set for Gear Info
function determine_haste_group()
    classes.CustomMeleeGroups:clear()
    if DW == true then
        if DW_needed <= 11 then
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif DW_needed > 11 and DW_needed <= 26 then
            classes.CustomMeleeGroups:append('HighHaste')
        elseif DW_needed > 26 and DW_needed <= 31 then
            classes.CustomMeleeGroups:append('MidHaste')
        elseif DW_needed > 31 and DW_needed <= 42 then
            classes.CustomMeleeGroups:append('LowHaste')
        elseif DW_needed > 42 then
            classes.CustomMeleeGroups:append('')
        end
    end
end

	--Gear Info Functions
function job_self_command(cmdParams, eventArgs)
    gearinfo(cmdParams, eventArgs)
end

function gearinfo(cmdParams, eventArgs)
    if cmdParams[1] == 'gearinfo' then
        if type(cmdParams[4]) == 'string' then
            if cmdParams[4] == 'true' then
                moving = true
            elseif cmdParams[4] == 'false' then
                moving = false
            end
        end
        if not midaction() then
            job_update()
        end
    end
end

	--Auto_Kite function
function check_moving()
    if state.DefenseMode.value == 'None'  and state.Kiting.value == false then
        if state.Auto_Kite.value == false and moving then
            state.Auto_Kite:set(true)
        elseif state.Auto_Kite.value == true and moving == false then
            state.Auto_Kite:set(false)
        end
    end
end

	--Allows equipping of warp/exp rings without auto swapping back to current set
function check_gear()
    if no_swap_gear:contains(player.equipment.left_ring) then
        disable("ring1")
    else
        enable("ring1")
    end
    if no_swap_gear:contains(player.equipment.right_ring) then
        disable("ring2")
    else
        enable("ring2")
    end
end

windower.register_event('zone change',
    function()
        if no_swap_gear:contains(player.equipment.left_ring) then
            enable("ring1")
            equip(sets.idle)
        end
        if no_swap_gear:contains(player.equipment.right_ring) then
            enable("ring2")
            equip(sets.idle)
        end
    end
)

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
        set_macro_page(1, 11)
end

function set_lockstyle()
    send_command('wait 5; input /lockstyleset ' .. lockstyleset)
end
