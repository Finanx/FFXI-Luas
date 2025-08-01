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
--              	[ Windows + R ]     	Toggle Reraise Mode
--					[ Windows + T ]			Toggles Treasure Hunter Mode
--              	[ Windows + C ]     	Toggle Capacity Points Mode
--              	[ Windows + I ]     	Pulls all items in Gear Retrieval
--
-- Warp Script:		[ CTRL + Numpad+ ]		Warp Ring
--					[ ALT + Numpad+ ]		Dimensional Ring Dem
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
--					[ Windows + Numpad6 ]	Rolan. Daifuku
--					[ Windows + Numpad7 ]	Toolbag (Shihei)
--
-- Warp Script:		[ CTRL + Numpad+ ]		Warp Ring
--					[ ALT + Numpad+ ]		Dimensional Ring Dem
--
-- Range Script:	[ CTRL + Numpad0 ] 		Ranged Attack
--
-- Toggles:			[ Windows + U ]			Stops Gear Swap from constantly updating gear
--					[ Windows + D ]			Unloads Dressup then reloads to change lockstyle
--
-------------------------------------------------------------------------------------------------------------------
--  Job Specific Keybinds (Warrior Binds)
-------------------------------------------------------------------------------------------------------------------
--
--	Weapons:		[ Windows: + 1 ]		Chango Weapon Set
--					[ Windows: + 2 ]		Lycurgos Weapon Set
--					[ Windows: + 3 ]		Naegling Weapon Set
--					[ Windows: + 4 ]		Loxotic_Mace Weapon Set
--					[ Windows: + 5 ]		Shining_One Weapon Set
--					[ Windows: + 6 ]		Ikenga_axe Weapon Set
--					[ Windows: + 7 ]		Dolichenus Weapon Set
--
--	Echo Binds:		[ CTRL + Numpad- ]		Shows main Weaponskill Binds in game
--					[ ALT + Numpad- ]		Shows Alternate Weaponskill Binds in game
--					[ Shift + Numpad- ]		Shows Item Binds in game
--					[ Windows + Numpad- ]	Shows Food/Weapon/Misc. Binds in game
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

	state.Buff['Mighty Strikes'] = buffactive['mighty strikes']  or false
	state.Buff['Warcry'] = buffactive['warcry']  or false
	state.Buff['Berserk'] = buffactive['berserk']  or false
	
    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
					"Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring", "Emporox's Ring"}

	include('Mote-TreasureHunter')

    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}



    lockstyleset = 17
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc', 'SB')
    state.HybridMode:options('Normal', 'DT')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'ATKCAP')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal')
	state.TreasureMode:options('Tag', 'None')
	state.Reraise = M(false, "Reraise Mode")
	
	state.WeaponSet = M{['description']='Weapon Set', 'Chango', 'Lycurgos', 'Shining_One', 'Naegling', 'Loxotic_Mace', 'Ikenga_axe', 'Dolichenus'}
    state.CP = M(false, "Capacity Points Mode")

	--Includes Global Bind keys
	
	send_command('wait 2; exec Global-Binds.txt')
	
	--Warrior Binds
	
	send_command('wait 2; exec /WAR/WAR-Binds.txt')
	
	--Job Settings
	
	select_default_macro_book()
    set_lockstyle()

	--Gearinfo functions

    state.Auto_Kite = M(false, 'Auto_Kite')	
    Haste = 0
    DW_needed = 0
    DW = false
    moving = false
    update_combat_form()
    determine_haste_group()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
	enable('main','sub','range','ammo','head','body','hands','legs','feet','neck','waist','left_ear','right_ear','left_ring','right_ring','back')

	--Remove Global Binds

	send_command('wait 1; exec Global-UnBinds.txt')
	
end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.JA['Berserk'] = {
		body="Pumm. Lorica +3",
		feet={ name="Agoge Calligae +3", augments={'Enhances "Tomahawk" effect',}},
		back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
    
	sets.precast.JA['Warcry'] = {head={ name="Agoge Mask +3", augments={'Enhances "Savagery" effect',}},}
    
	sets.precast.JA['Agressor'] = {
		head="Pummeler's Mask +3",
		body={ name="Agoge Lorica +3", augments={'Enhances "Aggressive Aim" effect',}},}
		
	sets.precast.JA['Warrior\'s Charge'] = {}
	sets.precast.JA['Tomahawk'] = {ammo="Thr. Tomahawk", feet={ name="Agoge Calligae +3", augments={'Enhances "Tomahawk" effect',}},}
	sets.precast.JA['Restraint'] = {hands="Boii Mufflers +3",}
	sets.precast.JA['Blood Rage'] = {body="Boii Lorica +3",}
	sets.precast.JA['Mighty Strikes'] = {hands={ name="Agoge Mufflers", augments={'Enhances "Mighty Strikes" effect',}},}

	sets.precast.JA['Provoke'] = {
	    ammo="Sapience Orb",
		head="Halitus Helm",
		body={ name="Emet Harness +1", augments={'Path: A',}},
		hands="Sakpata's Gauntlets",
		legs={ name="Zoar Subligar +1", augments={'Path: A',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Moonlight Necklace",
		waist="Audumbla Sash",
		left_ear="Cryptic Earring",
		right_ear="Friomisi Earring",
		left_ring="Eihwaz Ring",
		right_ring="Begrudging Ring",
		back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}

    sets.precast.Waltz = {
        ring1="Asklepian Ring",
        waist="Gishdubar Sash",
        }

    sets.precast.Waltz['Healing Waltz'] = {}

    sets.precast.FC = {
        }

		
	sets.precast.RA = {
		range="Trollbane",
	    head={ name="Sakpata's Helm", augments={'Path: A',}},
		body={ name="Sakpata's Plate", augments={'Path: A',}},
		hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
		legs="Volte Tights",
		feet="Volte Spats",
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Audumbla Sash",
		left_ear="Tuisto Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring="Defending Ring",
		back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
	
		--Set used for Icarus Wing to maximize TP gain
	sets.precast.Wing = {}

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

	--Generic Weapon Skill

	sets.precast.WS = {
		ammo="Knobkierrie",
		head={ name="Agoge Mask +3", augments={'Enhances "Savagery" effect',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Boii Mufflers +3",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="War. Beads +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Thrud Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Regal Ring",
		back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS.ATKCAP = {
		ammo="Knobkierrie",
		head={ name="Agoge Mask +3", augments={'Enhances "Savagery" effect',}},
		body={ name="Sakpata's Plate", augments={'Path: A',}},
		hands="Boii Mufflers +3",
		legs="Boii Cuisses +3",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="War. Beads +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Thrud Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Sroda Ring",
		back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	--Mighty Strikes Set
	sets.Mighty = {ammo="Yetshila +1",feet="Boii Calligae +3"}
	
	--TP Overflow set
	sets.precast.WS.FullTP = {left_ear={ name="Lugra Earring +1", augments={'Path: A',}},}

	--Great Axe Weapon Skills
	
	sets.precast.WS['Upheaval'] = {
		ammo="Knobkierrie",
		head={ name="Agoge Mask +3", augments={'Enhances "Savagery" effect',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Boii Mufflers +3",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="War. Beads +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Thrud Earring",
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring="Niqmaddu Ring",
		back={ name="Cichol's Mantle", augments={'VIT+20','Accuracy+20 Attack+20','VIT+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Upheaval'].ATKCAP = {
		ammo="Knobkierrie",
		head={ name="Agoge Mask +3", augments={'Enhances "Savagery" effect',}},
		body={ name="Sakpata's Plate", augments={'Path: A',}},
		hands="Boii Mufflers +3",
		legs="Boii Cuisses +3",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="War. Beads +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Thrud Earring",
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring="Niqmaddu Ring",
		back={ name="Cichol's Mantle", augments={'VIT+20','Accuracy+20 Attack+20','VIT+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Ukko\'s Fury'] = {
		ammo="Yetshila +1",
		head="Boii Mask +3",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Boii Mufflers +3",
		legs="Boii Cuisses +3",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="War. Beads +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Schere Earring", augments={'Path: A',}},
		right_ear={ name="Boii Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','Crit.hit rate+5',}},
		left_ring="Begrudging Ring",
		right_ring="Niqmaddu Ring",
		back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Ukko\'s Fury'].ATKCAP = {
		ammo="Yetshila +1",
		head="Boii Mask +3",
		body={ name="Sakpata's Plate", augments={'Path: A',}},
		hands="Boii Mufflers +3",
		legs="Boii Cuisses +3",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="War. Beads +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Schere Earring", augments={'Path: A',}},
		right_ear={ name="Boii Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','Crit.hit rate+5',}},
		left_ring="Begrudging Ring",
		right_ring="Niqmaddu Ring",
		back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

	sets.precast.WS['Steel Cyclone'] = {
		ammo="Knobkierrie",
		head={ name="Agoge Mask +3", augments={'Enhances "Savagery" effect',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Boii Mufflers +3",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="War. Beads +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Thrud Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Sroda Ring",
		back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Steel Cyclone'].ATKCAP = {
		ammo="Knobkierrie",
		head={ name="Agoge Mask +3", augments={'Enhances "Savagery" effect',}},
		body={ name="Sakpata's Plate", augments={'Path: A',}},
		hands="Boii Mufflers +3",
		legs="Boii Cuisses +3",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="War. Beads +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Thrud Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Sroda Ring",
		back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['King\'s Justice'] = sets.precast.WS['Steel Cyclone']
	sets.precast.WS['King\'s Justice'].ATKCAP = sets.precast.WS['Steel Cyclone'].ATKCAP

	sets.precast.WS['Fell Cleave'] = sets.precast.WS['Steel Cyclone']

	--Breaks
	
	sets.precast.WS['Full Break'] = {
		ammo="Pemphredo Tathlum",
		head="Boii Mask +3",
		body="Boii Lorica +3",
		hands="Boii Mufflers +3",
		legs="Boii Cuisses +3",
		feet="Boii Calligae +3",
		neck="Moonlight Necklace",
		waist="Eschan Stone",
		left_ear="Digni. Earring",
		right_ear={ name="Boii Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','Crit.hit rate+5',}},
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Cichol's Mantle", augments={'STR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','Weapon skill damage +10%',}},}
	
	sets.precast.WS['Shield Break'] = sets.precast.WS['Full Break']
	sets.precast.WS['Armor Break'] = sets.precast.WS['Full Break']
	sets.precast.WS['Weapon Break'] = sets.precast.WS['Full Break']
	
	
	--Sword Weapon Skills

	sets.precast.WS['Savage Blade'] = {
		ammo="Knobkierrie",
		head={ name="Agoge Mask +3", augments={'Enhances "Savagery" effect',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Boii Mufflers +3",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="War. Beads +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Thrud Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Sroda Ring",
		back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Savage Blade'].ATKCAP = {
		ammo="Knobkierrie",
		head={ name="Agoge Mask +3", augments={'Enhances "Savagery" effect',}},
		body={ name="Sakpata's Plate", augments={'Path: A',}},
		hands="Boii Mufflers +3",
		legs="Boii Cuisses +3",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="War. Beads +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Thrud Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Sroda Ring",
		back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
	
	sets.precast.WS['Seraph Blade'] = {
		ammo="Knobkierrie",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Friomisi Earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Epaminondas's Ring",
		back={ name="Cichol's Mantle", augments={'STR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Red Lotus Blade'] = sets.precast.WS['Seraph Blade']

    sets.precast.WS['Sanguine Blade'] = set_combine(sets.precast.WS['Seraph Blade'], {head="Pixie Hairpin +1",left_ring="Archon Ring",left_ear="Thrud Earring",})
		
	--Polearm Weapon Skills

	sets.precast.WS['Impulse Drive'] = sets.precast.WS['Savage Blade']
	sets.precast.WS['Impulse Drive'].ATKCAP = sets.precast.WS['Savage Blade'].ATKCAP
	
	sets.precast.WS['Stardiver'] = sets.precast.WS['Savage Blade']
	sets.precast.WS['Stardiver'].ATKCAP = sets.precast.WS['Savage Blade'].ATKCAP	
	
	--Club Weapon Skills
	
	sets.precast.WS['Black Halo'] = sets.precast.WS['Savage Blade']
	sets.precast.WS['Black Halo'].ATKCAP = sets.precast.WS['Savage Blade'].ATKCAP
	
	sets.precast.WS['Judgment'] = sets.precast.WS['Savage Blade']
	sets.precast.WS['Judgment'].ATKCAP = sets.precast.WS['Savage Blade'].ATKCAP	
		
	--Axe Weapon Skills
	
	sets.precast.WS['Decimation'] = sets.precast.WS['Savage Blade']
	sets.precast.WS['Decimation'].ATKCAP = sets.precast.WS['Savage Blade'].ATKCAP
	
	sets.precast.WS['Mistral Axe'] = sets.precast.WS['Savage Blade']
	sets.precast.WS['Mistral Axe'].ATKCAP = sets.precast.WS['Savage Blade'].ATKCAP
	
	sets.precast.WS['Calamity'] = sets.precast.WS['Savage Blade']
	sets.precast.WS['Calamity'].ATKCAP = sets.precast.WS['Savage Blade'].ATKCAP

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.Utsusemi = sets.precast.FC

    -- Ranged gear
	
    sets.midcast.RA = {    
		range="Trollbane",
	    head={ name="Sakpata's Helm", augments={'Path: A',}},
		body={ name="Sakpata's Plate", augments={'Path: A',}},
		hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
		legs="Volte Tights",
		feet="Volte Spats",
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Audumbla Sash",
		left_ear="Tuisto Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring="Defending Ring",
		back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.resting = {    
		ammo="Staunch Tathlum +1",
		head={ name="Sakpata's Helm", augments={'Path: A',}},
		body={ name="Sakpata's Plate", augments={'Path: A',}},
		hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
		legs={ name="Sakpata's Cuisses", augments={'Path: A',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Flume Belt +1",
		left_ear="Eabani Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}

    sets.idle = {    
		ammo="Staunch Tathlum +1",
		head={ name="Sakpata's Helm", augments={'Path: A',}},
		body={ name="Sakpata's Plate", augments={'Path: A',}},
		hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
		legs={ name="Sakpata's Cuisses", augments={'Path: A',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Flume Belt +1",
		left_ear="Eabani Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.

    sets.engaged = {
		ammo="Aurgelmir Orb +1",
		head={ name="Sakpata's Helm", augments={'Path: A',}},
		body="Boii Lorica +3",
		hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
		legs="Pumm. Cuisses +3",
		feet="Pumm. Calligae +3",
		neck={ name="War. Beads +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Schere Earring", augments={'Path: A',}},
		right_ear={ name="Boii Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','Crit.hit rate+5',}},
		left_ring="Niqmaddu Ring",
		right_ring="Moonlight Ring",
		back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}

    sets.engaged.Acc = {
		ammo="Aurgelmir Orb +1",
		head={ name="Sakpata's Helm", augments={'Path: A',}},
		body="Boii Lorica +3",
		hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
		legs="Pumm. Cuisses +3",
		feet="Pumm. Calligae +3",
		neck={ name="War. Beads +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Schere Earring", augments={'Path: A',}},
		right_ear={ name="Boii Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','Crit.hit rate+5',}},
		left_ring="Niqmaddu Ring",
		right_ring="Moonlight Ring",
		back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
	sets.engaged.SB = {
	    ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Sakpata's Helm", augments={'Path: A',}},
		body="Dagon Breast.",
		hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
		legs={ name="Sakpata's Cuisses", augments={'Path: A',}},
		feet={ name="Sakpata's Leggings", augments={'Path: A',}},
		neck={ name="War. Beads +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Schere Earring", augments={'Path: A',}},
		right_ear={ name="Boii Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','Crit.hit rate+5',}},
		left_ring="Niqmaddu Ring",
		right_ring="Moonlight Ring",
		back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}

    -- * DNC Subjob DW Trait: +15%
    -- * NIN Subjob DW Trait: +25%

    -- No Magic Haste (74% DW to cap)
    sets.engaged.DW = {}

    sets.engaged.DW.Acc = {}

    -- 15% Magic Haste (67% DW to cap)
    sets.engaged.DW.LowHaste = {}

    sets.engaged.DW.Acc.LowHaste = {}

    -- 30% Magic Haste (56% DW to cap)
    sets.engaged.DW.MidHaste = {}

    sets.engaged.DW.Acc.MidHaste = {}

    -- 35% Magic Haste (51% DW to cap)
    sets.engaged.DW.HighHaste = {}

    sets.engaged.DW.Acc.HighHaste = {}


    -- 45% Magic Haste (36% DW to cap) for /Nin
    sets.engaged.DW.MaxHaste = {}
    
	sets.engaged.DW.Acc.MaxHaste = {}
		
	-- 45% Magic Haste (36% DW to cap) for /DNC
	
	sets.engaged.DW.MaxHastePlus = {}
    
	sets.engaged.DW.Acc.MaxHastePlus = {}
	


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {    
		ammo="Aurgelmir Orb +1",
		head={ name="Sakpata's Helm", augments={'Path: A',}},
		body={ name="Sakpata's Plate", augments={'Path: A',}},
		hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
		legs={ name="Sakpata's Cuisses", augments={'Path: A',}},
		feet={ name="Sakpata's Leggings", augments={'Path: A',}},
		neck={ name="War. Beads +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Schere Earring", augments={'Path: A',}},
		right_ear={ name="Boii Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','Crit.hit rate+5',}},
		left_ring="Niqmaddu Ring",
		right_ring="Moonlight Ring",
		back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
		
    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
    sets.engaged.Acc.DT = set_combine(sets.engaged.Acc, sets.engaged.Hybrid)
	

    sets.engaged.DW.DT = set_combine(sets.engaged.DW, sets.engaged.Hybrid)
    sets.engaged.DW.Acc.DT = set_combine(sets.engaged.DW.Acc, sets.engaged.Hybrid)


    sets.engaged.DW.DT.LowHaste = set_combine(sets.engaged.DW.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.Acc.DT.LowHaste = set_combine(sets.engaged.DW.Acc.LowHaste, sets.engaged.Hybrid)


    sets.engaged.DW.DT.MidHaste = set_combine(sets.engaged.DW.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.Acc.DT.MidHaste = set_combine(sets.engaged.DW.Acc.MidHaste, sets.engaged.Hybrid)


    sets.engaged.DW.DT.HighHaste = set_combine(sets.engaged.DW.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.Acc.DT.HighHaste = set_combine(sets.engaged.DW.Acc.HighHaste, sets.engaged.Hybrid)


    sets.engaged.DW.DT.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.Acc.DT.MaxHaste = set_combine(sets.engaged.DW.Acc.MaxHaste, sets.engaged.Hybrid)

	
	sets.engaged.DW.DT.MaxHastePlus = set_combine(sets.engaged.DW.MaxHastePlus, sets.engaged.Hybrid)
    sets.engaged.DW.Acc.DT.MaxHastePlus = set_combine(sets.engaged.DW.Acc.MaxHastePlus, sets.engaged.Hybrid)


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	sets.Kiting = {left_ring="Shneddick Ring",}

    sets.TreasureHunter = {
		ammo="Per. Lucky Egg", --TH1
		body="Volte Jupon",		--TH2
		waist="Chaac Belt",} --TH+1

    sets.buff.Doom = {
		neck="Nicander's Necklace",
        waist="Gishdubar Sash", --10
        }

    sets.CP = {back={ name="Mecisto. Mantle", augments={'Cap. Point+48%','CHR+3','Accuracy+2','DEF+10',}},}
    sets.Obi = {waist="Hachirin-no-Obi"}
	sets.Reraise = {head="Crepuscular Helm",body="Crepuscular Mail",}


	--Weaponsets

    sets.Chango = {main={ name="Chango", augments={'Path: A',}}, sub="Utu Grip"}
	sets.Lycurgos = {main="Lycurgos", sub="Utu Grip"}
	sets.Shining_One = {main="Shining One", sub="Utu Grip"}
	sets.Naegling = {main="Naegling", sub="Blurred Shield +1",}
	sets.Naegling.DW = {main="Naegling", sub="Ikenga's Axe",}
	sets.Loxotic_Mace = {main={ name="Loxotic Mace +1", augments={'Path: A',}},sub="Blurred Shield +1",}
	sets.Loxotic_Mace.DW = {main={ name="Loxotic Mace +1", augments={'Path: A',}},sub="Ikenga's Axe",}
	sets.Ikenga_axe = {main="Ikenga's Axe", sub="Blurred Shield +1",}
	sets.Ikenga_axe.DW = {main="Ikenga's Axe", sub="Dolichenus",}
	sets.Dolichenus = {main="Dolichenus", sub="Blurred Shield +1",}
	sets.Dolichenus.DW = {main="Dolichenus", sub="Ikenga's Axe",}
	

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific Functions
-------------------------------------------------------------------------------------------------------------------

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

end

function job_post_precast(spell, action, spellMap, eventArgs)

		--Handles Mighty Strikes on Weapon skills
    if spell.type == "WeaponSkill" then
        if state.Buff['Mighty Strikes'] then
			if spell.english == "Sanguine Blade" or spell.english == "Armor Break" or spell.english == "Weapon Break" then
			else
			equip(sets.Mighty)
			end
        end
		
		if spell.english == "Ukko\'s Fury" or spell.english == "Sanguine Blade" or spell.english == "Full Break" or spell.english == "Shield Break" or spell.english == "Armor Break" or spell.english == "Weapon Break" then
		else
			if state.Buff['Warcry'] then
				if state.WeaponSet.value == "Chango" then
					if state.WeaponskillMode.value == "Normal" then
						if player.tp > 1700 then
							equip(sets.precast.WS.FullTP)
						end
					elseif state.WeaponskillMode.value == "ATKCAP" then
						if player.tp > 1600 then
							equip(sets.precast.WS.FullTP)
						end
					end					
				elseif state.WeaponSet.value == "Lycurgos" or state.WeaponSet.value == "Shining_One" then
					if state.WeaponskillMode.value == "Normal" then
						if player.tp > 2200 then
							equip(sets.precast.WS.FullTP)
						end
					elseif state.WeaponskillMode.value == "ATKCAP" then
						if player.tp > 2100 then
							equip(sets.precast.WS.FullTP)
						end
					end
				elseif state.WeaponSet.value == "Naegling" or state.WeaponSet.value == "Loxotic_Mace" or state.WeaponSet.value == "Dolichenus" or state.WeaponSet.value == "Ikenga_axe" then
					if player.sub_job == 'DNC' or player.sub_job == 'NIN' then
						if state.WeaponskillMode.value == "Normal" then
							if player.tp > 1700 then
								equip(sets.precast.WS.FullTP)
							end
						elseif state.WeaponskillMode.value == "ATKCAP" then
							if player.tp > 1600 then
								equip(sets.precast.WS.FullTP)
							end
						end						
					else
						if state.WeaponskillMode.value == "Normal" then
							if player.tp > 1600 then
								equip(sets.precast.WS.FullTP)
							end
						elseif state.WeaponskillMode.value == "ATKCAP" then
							if player.tp > 1470 then
								equip(sets.precast.WS.FullTP)
							end
						end
					end
				end
			else
				if state.WeaponSet.value == "Chango" then
					if state.WeaponskillMode.value == "Normal" then
						if player.tp > 2400 then
							equip(sets.precast.WS.FullTP)
						end
					elseif state.WeaponskillMode.value == "ATKCAP" then
						if player.tp > 2300 then
							equip(sets.precast.WS.FullTP)
						end
					end
				elseif state.WeaponSet.value == "Lycurgos" or state.WeaponSet.value == "Shining_One" then
					if state.WeaponskillMode.value == "Normal" then
						if player.tp > 2900 then
							equip(sets.precast.WS.FullTP)
						end
					elseif state.WeaponskillMode.value == "ATKCAP" then
						if player.tp > 2800 then
							equip(sets.precast.WS.FullTP)
						end
					end
				elseif state.WeaponSet.value == "Naegling" or state.WeaponSet.value == "Loxotic_Mace" or state.WeaponSet.value == "Dolichenus" or state.WeaponSet.value == "Ikenga_axe" then
					if player.sub_job == 'DNC' or player.sub_job == 'NIN' then
						if state.WeaponskillMode.value == "Normal" then
							if player.tp > 2400 then
								equip(sets.precast.WS.FullTP)
							end
						elseif state.WeaponskillMode.value == "ATKCAP" then
							if player.tp > 2300 then
								equip(sets.precast.WS.FullTP)
							end
						end						
					else
						if state.WeaponskillMode.value == "Normal" then
							if player.tp > 2300 then
								equip(sets.precast.WS.FullTP)
							end
						elseif state.WeaponskillMode.value == "ATKCAP" then
							if player.tp > 2170 then
								equip(sets.precast.WS.FullTP)
							end
						end
					end
				end
			end
		end
    end

end

	--Handles Weapon set changes and Reraise set
function Auto_Reraise()
	if state.Reraise.current == 'on' then
		equip(sets.Reraise)
		disable('head', 'body')
		reraiseActive = true
	elseif reraiseActive and state.Reraise.current == 'off' then
		enable('head', 'body')
		reraiseActive = false
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


-------------------------------------------------------------------------------------------------------------------
-- Code for Melee sets
-------------------------------------------------------------------------------------------------------------------

-- Handles Gearinfo / Melee / Weapon / Range Sets
function job_handle_equipping_gear(playerStatus, eventArgs)
    update_combat_form()
    determine_haste_group()
	Auto_Reraise()
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

	if state.WeaponSet.value == 'Chango' then
		equip(sets.Chango)
	end	
	
	if state.WeaponSet.value == 'Lycurgos' then
		equip(sets.Lycurgos)
	end	

	if state.WeaponSet.value == 'Shining_One' then
		equip(sets.Shining_One)
	end		
	
	if state.WeaponSet.value == 'Naegling' then
		if player.sub_job == 'DNC' or player.sub_job == 'NIN' then
			equip(sets.Naegling.DW)
		else
			equip(sets.Naegling)
		end
	end

	if state.WeaponSet.value == 'Loxotic_Mace' then
		if player.sub_job == 'DNC' or player.sub_job == 'NIN' then
			equip(sets.Loxotic_Mace.DW)
		else
			equip(sets.Loxotic_Mace)
		end
	end

	if state.WeaponSet.value == 'Ikenga_axe' then
		if player.sub_job == 'DNC' or player.sub_job == 'NIN' then
			equip(sets.Ikenga_axe.DW)
		else
			equip(sets.Ikenga_axe)
		end
	end
	
	if state.WeaponSet.value == 'Dolichenus' then
		if player.sub_job == 'DNC' or player.sub_job == 'NIN' then
			equip(sets.Dolichenus.DW)
		else
			equip(sets.Dolichenus)
		end
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

-- Function to display the current relevant user state when doing an update.
function display_current_job_state(eventArgs)
    local cf_msg = ''
    if state.CombatForm.has_value then
        cf_msg = ' (' ..state.CombatForm.value.. ')'
    end

    local m_msg = state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        m_msg = m_msg .. '/' ..state.HybridMode.value
    end

    local ws_msg = state.WeaponskillMode.value

    local c_msg = state.CastingMode.value

    local d_msg = 'None'
    if state.DefenseMode.value ~= 'None' then
        d_msg = state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
    end

    local i_msg = state.IdleMode.value

    local msg = ''
    if state.TreasureMode.value == 'Tag' then
        msg = msg .. ' TH: Tag |'
    end
    if state.Kiting.value then
        msg = msg .. ' Kiting: On |'
    end

    add_to_chat(002, '| ' ..string.char(31,210).. 'Melee' ..cf_msg.. ': ' ..string.char(31,001)..m_msg.. string.char(31,002)..  ' |'
        ..string.char(31,207).. ' WS: ' ..string.char(31,001)..ws_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
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
        set_macro_page(1, 10)
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end
