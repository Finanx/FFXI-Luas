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
--			    	[ Windows + W ]         Toggles Weapon Lock OFF
--  				[ Windows + R ]         Toggles Range Lock
--					[ Windows + T ]			Toggles Treasure Hunter Mode
--              	[ Windows + C ]     	Toggle Capacity Points Mode
--              	[ Windows + I ]     	Pulls all items in Gear Retrieval
--
-- Warp Scripts:	[ CTRL + Numpad+ ]		Warp Ring
--					[ ALT + Numpad+ ]		Dimensional Ring Dem
--					[ Windows + Numpad+ ]	Dimensional Ring Holla
--					[ Shift + Numpad+ ]		Dimensional Ring Mea
--
-- Range Script:	[ CTRL + Numpad0 ] 		Ranged Attack
--
-- Toggles:			[ Windows + U ]			Stops Gear Swap from constantly updating gear
--					[ Windows + D ]			Unloads Dressup then reloads to change lockstyle
--
-------------------------------------------------------------------------------------------------------------------
--  Job Specific Keybinds (Bard Binds)
-------------------------------------------------------------------------------------------------------------------
--
--  Modes:      	[ CTRL + ` ]			Toggles Song Mode (Regular, Dummy)
--					[ Windows + 1 ]			Sets Weapon to Naegling then locks Main/Sub Slots
--					[ Windows + 2 ]			Sets Weapon to Carnwenhan then locks Main/Sub Slots
--					[ Windows + 3 ]			Sets Weapon to Twashtar then locks Main/Sub Slots
--					[ Windows + 4 ]			Sets Weapon to Mandau then locks Main/Sub Slots
--					[ Windows + 5 ]			Sets Weapon to Tauret then locks Main/Sub Slots
--					[ Windows + 6 ]			Sets Weapon to Xoanon then locks Main/Sub Slots
--
--	Echo Binds:		[ CTRL + Numpad- ]		Shows main Weaponskill Binds in game
--					[ ALT + Numpad- ]		Shows Song Binds in game
--					[ Shift + Numpad- ]		Shows Item Binds in game
--					[ Windows + Numpad- ]	Shows Food/Weapon/Misc. Binds in game
--
--					
-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
    res = require 'resources'
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()

	include('Mote-TreasureHunter')

    state.Buff['Pianissimo'] = buffactive['pianissimo'] or false

    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
					"Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring", "Emporox's Ring"}

    lockstyleset = 15
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc')
    state.HybridMode:options('Normal', 'DT')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'Refresh')
	state.TreasureMode:options('Tag', 'None')
	state.SongMode = M{['description']='Song Mode', 'None', 'Placeholder'}
	state.SongEnmity = M{['description']='Song Enmity', 'None', 'Enmity'}
	state.WeaponSet = M{['description']='Weapon Set', 'None', 'Naegling', 'Carnwenhan', 'Twashtar', 'Mandau', 'Tauret', 'Xoanon'}
	
    state.CP = M(false, "Capacity Points Mode")
	state.TPBonus = M(true, 'TP Bonus')
	
	state.Threnody = M{['description']='Threnody', '"Fire Threnody II"', '"Ice Threnody II"', '"Wind Threnody II"', '"Earth Threnody II"', '"Ltng. Threnody II"', '"Water Threnody II"', '"Light Threnody II"', '"Dark Threnody II"',}
		
	state.Carol1 = M{['description']='Carol1', '"Fire Carol"', '"Ice Carol"', '"Wind Carol"', '"Earth Carol"', '"Lightning Carol"', '"Water Carol"', '"Light Carol"', '"Dark Carol"',}
		
	state.Carol2 = M{['description']='Carol2', '"Fire Carol II"', '"Ice Carol II"', '"Wind Carol II"', '"Earth Carol II"', '"Lightning Carol II"', '"Water Carol II"', '"Light Carol II"', '"Dark Carol II"',}
		
	state.Etude = M{['description']='Etude', '"Herculean Etude"', '"Uncanny Etude"', '"Vital Etude"', '"Swift Etude"', '"Sage Etude"', '"Logical Etude"', '"Bewitching Etude"',}

	--Includes Global Bind keys
	
	send_command('wait 2; exec Global-Binds.txt')
	
	--Bard Binds
	
	send_command('wait 2; exec /BRD/BRD-Binds.txt')
		
	--Gear Retrieval Script
	
	send_command('wait 10; exec /BRD/BRD-Gear-Retrieval.txt')
		
	--Job Settings

    select_default_macro_book()
    set_lockstyle()
	
	--Gearinfo Functions

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
	
	--Gear Removal Script
	
	send_command('wait 1; exec /BRD/BRD-Gear-Removal.txt')
	
end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Fast cast sets for spells
    sets.precast.FC = {
		main={ name="Kali", augments={'Mag. Acc.+15','String instrument skill +10','Wind instrument skill +10',}},
		sub="Genmei Shield",
		head={ name="Bunzi's Hat", augments={'Path: A',}},
		body="Inyanga Jubbah +2",
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		feet="Fili Cothurnes +3",
		neck="Orunmila's Torque",
		waist="Embla Sash",
		left_ear="Loquac. Earring",
		right_ear="Etiolation Earring",
		left_ring="Prolix Ring",
		right_ring="Kishar Ring",
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}},}

    sets.precast.FC.BardSong = {
		main={ name="Kali", augments={'Mag. Acc.+15','String instrument skill +10','Wind instrument skill +10',}},
		sub="Genmei Shield",
		head="Fili Calot +3",
		body="Inyanga Jubbah +2",
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		feet={ name="Bihu Slippers +3", augments={'Enhances "Nightingale" effect',}},
		neck="Orunmila's Torque",
		waist="Embla Sash",
		left_ear="Loquac. Earring",
		right_ear={ name="Fili Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','Damage taken-5%',}},
		left_ring="Defending Ring",
		right_ring="Kishar Ring",
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}},}
		
    sets.precast.FC.Dispelga = set_combine(sets.precast.FC, {main="Daybreak", sub="Ammurapi Shield"})

    -- Precast sets to enhance JAs

    sets.precast.JA['Nightingale'] = {feet={ name="Bihu Slippers +3", augments={'Enhances "Nightingale" effect',}},}
    sets.precast.JA['Troubadour'] = {body={ name="Bihu Jstcorps. +3", augments={'Enhances "Troubadour" effect',}},}
    sets.precast.JA['Soul Voice'] = {legs={ name="Bihu Cannions +3", augments={'Enhances "Soul Voice" effect',}},}

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {legs="Dashing Subligar",ring1="Asklepian Ring",waist="Gishdubar Sash",}
	
	sets.precast.Waltz['Healing Waltz'] = {legs="Dashing Subligar",}


    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
		range={ name="Linos", augments={'Accuracy+12 Attack+12','Weapon skill damage +3%','STR+8',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Bihu Jstcorps. +3", augments={'Enhances "Troubadour" effect',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Ephramad's Ring",
		back={ name="Intarabus's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS.Acc = {
		range={ name="Linos", augments={'Accuracy+12 Attack+12','Weapon skill damage +3%','DEX+8',}},
		head="Fili Calot +3",
		body="Fili Hongreline +3",
		hands="Fili Manchettes +3",
		legs="Fili Rhingrave +3",
		feet="Fili Cothurnes +3",
		neck={ name="Bard's Charm +2", augments={'Path: A',}},
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear="Digni. Earring",
		right_ear={ name="Fili Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','Damage taken-5%',}},
		left_ring="Ephramad's Ring",
		right_ring={ name="Cacoethic Ring +1", augments={'Path: A',}},
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS.ATKCAP = {
		range={ name="Linos", augments={'Accuracy+12 Attack+12','Weapon skill damage +3%','STR+8',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Bard's Charm +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Sroda Ring",
		right_ring="Ephramad's Ring",
		back={ name="Intarabus's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

	sets.precast.WS.FullTPPhysical = {left_ear="Telos Earring",}
	sets.precast.WS.FullTPRudra = {left_ear="Ishvara Earring",}
	sets.precast.WS.FullTPMagical = {left_ear="Regal Earring",}

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    
	sets.precast.WS['Evisceration'] = {
		range={ name="Linos", augments={'Accuracy+12 Attack+12','Crit.hit rate+3','DEX+8',}},
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body={ name="Bihu Jstcorps. +3", augments={'Enhances "Troubadour" effect',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Zoar Subligar +1", augments={'Path: A',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Brutal Earring",
		right_ear="Mache Earring +1",
		left_ring="Ilabrat Ring",
		right_ring="Begrudging Ring",
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}},}

    sets.precast.WS['Mordant Rime'] = {
		range={ name="Linos", augments={'Accuracy+12 Attack+12','Weapon skill damage +3%','STR+8',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Bihu Jstcorps. +3", augments={'Enhances "Troubadour" effect',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Bard's Charm +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Ishvara Earring",
		left_ring="Epaminondas's Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Intarabus's Cape", augments={'CHR+20','Accuracy+20 Attack+20','CHR+10','Weapon skill damage +10%',}},}

    sets.precast.WS['Rudra\'s Storm'] = {
		range={ name="Linos", augments={'Accuracy+12 Attack+12','Weapon skill damage +3%','DEX+8',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Bihu Jstcorps. +3", augments={'Enhances "Troubadour" effect',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Bard's Charm +2", augments={'Path: A',}},
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Mache Earring +1",
		left_ring="Ephramad's Ring",
		right_ring="Ilabrat Ring",
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
		
    sets.precast.WS['Aeolian Edge'] = {
		range={ name="Linos", augments={'Accuracy+12 Attack+12','Weapon skill damage +3%','DEX+8',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Friomisi Earring",
		left_ring="Epaminondas's Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}

    sets.precast.WS['Savage Blade'] = sets.precast.WS
	sets.precast.WS['Savage Blade'].ATKCAP = sets.precast.WS.ATKCAP

	sets.precast.WS['Savage Blade'].Acc = {
		range={ name="Linos", augments={'Accuracy+12 Attack+12','Weapon skill damage +3%','STR+8',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Bihu Jstcorps. +3", augments={'Enhances "Troubadour" effect',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Rep. Plat. Medal",
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Ephramad's Ring",
		back={ name="Intarabus's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
	
	sets.precast.WS['Fast Blade'] = sets.precast.WS
	sets.precast.WS['Fast Blade'].ATKCAP = sets.precast.WS.ATKCAP
	
	sets.precast.WS['Seraph Blade'] = {
		range={ name="Linos", augments={'Accuracy+12 Attack+12','Weapon skill damage +3%','DEX+8',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Friomisi Earring",
		left_ring="Epaminondas's Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Shining Blade'] = sets.precast.WS['Seraph Blade']
	sets.precast.WS['Red Lotus Blade'] = sets.precast.WS['Seraph Blade']
	sets.precast.WS['Burning Blade'] = sets.precast.WS['Seraph Blade']

	sets.precast.WS['Sanguine Blade'] = set_combine(sets.precast.WS['Seraph Blade'], {head="Pixie Hairpin +1",right_ring="Archon Ring",})
	
	sets.precast.WS['Flat Blade'] = sets.precast.WS.Acc
		
	sets.precast.WS['Shell Crusher'] = {
		range={ name="Linos", augments={'Accuracy+12 Attack+12','Weapon skill damage +3%','DEX+8',}},
		head="Fili Calot +3",
		body="Fili Hongreline +3",
		hands="Fili Manchettes +3",
		legs="Fili Rhingrave +3",
		feet="Fili Cothurnes +3",
		neck="Sanctity Necklace",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Digni. Earring",
		right_ear={ name="Fili Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','Damage taken-5%',}},
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring={ name="Cacoethic Ring +1", augments={'Path: A',}},
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}},}
		
	sets.precast.WS['Retribution'] = sets.precast.WS
		
	sets.precast.RA = {
		range="Trollbane",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs="Volte Tights",
		feet="Volte Spats",
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Yemaya Belt",
		left_ear="Tuisto Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring="Ilabrat Ring",
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
	
		--Set used for Icarus Wing to maximize TP gain	
	sets.precast.Wing = {
	    range={ name="Linos", augments={'Accuracy+15','"Store TP"+4','Quadruple Attack +3',}},
		head={ name="Bunzi's Hat", augments={'Path: A',}},
		body="Ashera Harness",
		hands={ name="Bunzi's Gloves", augments={'Path: A',}},
		legs="Volte Tights",
		feet="Volte Spats",
		neck={ name="Bard's Charm +2", augments={'Path: A',}},
		waist="Gerdr Belt +1",
		left_ear="Crep. Earring",
		right_ear="Telos Earring",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- General set for recast times.
    sets.midcast.FastRecast = sets.precast.FC
	
	sets.Enmity = {
		main="Mafic Cudgel",
		sub="Genmei Shield",
		range={ name="Linos", augments={'Mag. Evasion+15','Phys. dmg. taken -4%','HP+20',}},
		head="Halitus Helm",
		body={ name="Emet Harness +1", augments={'Path: A',}},
		hands="Fili Manchettes +3",
		legs={ name="Zoar Subligar +1", augments={'Path: A',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Kasiri Belt",
		left_ear="Friomisi Earring",
		right_ear="Cryptic Earring",
		left_ring="Eihwaz Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}},}
		
	sets.midcast.Enmity = {
		main="Mafic Cudgel",
		sub="Genmei Shield",
		range={ name="Linos", augments={'Mag. Evasion+15','Phys. dmg. taken -4%','HP+20',}},
		head="Halitus Helm",
		body={ name="Emet Harness +1", augments={'Path: A',}},
		hands="Fili Manchettes +3",
		legs={ name="Zoar Subligar +1", augments={'Path: A',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Kasiri Belt",
		left_ear="Friomisi Earring",
		right_ear="Cryptic Earring",
		left_ring="Eihwaz Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}},}


    -- For song buffs (duration and AF3 set bonus)
	
	sets.midcast.SongEnhancing = {
		main={ name="Carnwenhan", augments={'Path: A',}},
		sub={ name="Kali", augments={'Mag. Acc.+15','String instrument skill +10','Wind instrument skill +10',}},
		head="Fili Calot +3",
		body="Fili Hongreline +3",
		hands="Fili Manchettes +3",
		legs="Inyanga Shalwar +2",
		feet="Brioso Slippers +3",
		neck="Mnbw. Whistle +1",
		waist="Flume Belt +1",
		left_ear="Genmei Earring",
		right_ear={ name="Fili Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','Damage taken-5%',}},
		left_ring="Defending Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}},}
		
	sets.midcast['Adventurer\'s Dirge'] = sets.midcast.SongEnhancing
	sets.midcast['Foe Sirvente'] = sets.midcast.SongEnhancing
		
	sets.midcast['Herb Pastoral'] = set_combine(sets.precast.FC, {range="Daurdabla"})
	sets.midcast['Shining Fantasia'] = set_combine(sets.precast.FC, {range="Daurdabla"})


    -- Defines Song sets can also add equipment to increase certain songs.
	

	sets.midcast.Paeon = set_combine(sets.midcast.SongEnhancing, {head="Brioso Roundlet +3"})
	sets.midcast.Ballad = set_combine(sets.midcast.SongEnhancing, {})
	sets.midcast.Minne = set_combine(sets.midcast.SongEnhancing, {})
	sets.midcast.Mambo = set_combine(sets.midcast.SongEnhancing, {})
	sets.midcast.Minuet = set_combine(sets.midcast.SongEnhancing, {body="Fili Hongreline +3"})
	sets.midcast.Madrigal = set_combine(sets.midcast.SongEnhancing, {head="Fili Calot +3"})
	sets.midcast.HonorMarch = set_combine(sets.midcast.SongEnhancing, {range="Marsyas", hands="Fili Manchettes +3"})
	sets.midcast.Aria = set_combine(sets.midcast.SongEnhancing, {range="Loughnashade"})
	sets.midcast.March = set_combine(sets.midcast.SongEnhancing, {hands="Fili Manchettes +3"})
	sets.midcast.Etude = set_combine(sets.midcast.SongEnhancing, {head="Mousai Turban +1",})
	sets.midcast.Carol = set_combine(sets.midcast.SongEnhancing, {hands="Mousai Gages +1",})
	sets.midcast["Sentinel's Scherzo"] = set_combine(sets.midcast.SongEnhancing, {feet="Fili Cothurnes +3"})
	sets.midcast.Mazurka = set_combine(sets.midcast.SongEnhancing, {range="Marsyas"})
	

    -- For song defbuffs (duration primary, accuracy secondary)
    sets.midcast.SongEnfeeble = {
		main={ name="Carnwenhan", augments={'Path: A',}},
		sub="Ammurapi Shield",
		range="Gjallarhorn",
		head="Brioso Roundlet +3",
		body="Fili Hongreline +3",
		hands="Fili Manchettes +3",
		legs="Fili Rhingrave +3",
		feet="Brioso Slippers +3",
		neck="Mnbw. Whistle +1",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear={ name="Fili Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','Damage taken-5%',}},
		left_ring="Stikini Ring +1",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}},}

    -- For song defbuffs (accuracy primary, duration secondary)
    sets.midcast.SongEnfeebleAcc = {
		main={ name="Carnwenhan", augments={'Path: A',}},
		sub="Ammurapi Shield",
		range="Gjallarhorn",
		head="Brioso Roundlet +3",
		body="Fili Hongreline +3",
		hands="Fili Manchettes +3",
		legs="Fili Rhingrave +3",
		feet="Brioso Slippers +3",
		neck="Mnbw. Whistle +1",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear={ name="Fili Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','Damage taken-5%',}},
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}},}

	sets.midcast.Threnody = set_combine(sets.midcast.SongEnfeeble, {body="Mou. Manteel +1",})
	sets.midcast.Threnody.Resistant = set_combine(sets.midcast.SongEnfeebleAcc, {body="Mou. Manteel +1",})
	
	-- For Foe Lullaby.
	sets.midcast.Foe = {
		main={ name="Carnwenhan", augments={'Path: A',}},
		sub="Ammurapi Shield",
		range="Marsyas",
		head="Brioso Roundlet +3",
		body="Fili Hongreline +3",
		hands="Brioso Cuffs +3",
		legs="Inyanga Shalwar +2",
		feet="Brioso Slippers +3",
		neck="Mnbw. Whistle +1",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear={ name="Fili Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','Damage taken-5%',}},
		left_ring="Stikini Ring +1",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}},}	
	
	sets.midcast.FoeResist	= {
		main={ name="Carnwenhan", augments={'Path: A',}},
		sub="Ammurapi Shield",
		range="Marsyas",
		head="Brioso Roundlet +3",
		body="Fili Hongreline +3",
		hands="Brioso Cuffs +3",
		legs="Fili Rhingrave +3",
		feet="Brioso Slippers +3",
		neck="Mnbw. Whistle +1",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear={ name="Fili Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','Damage taken-5%',}},
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}},}
		
    -- For Horde Lullaby.
    sets.midcast.Horde = {
		main={ name="Carnwenhan", augments={'Path: A',}},
		sub="Ammurapi Shield",
		range="Daurdabla",
		head="Brioso Roundlet +3",
		body="Brioso Justau. +3",
		hands="Fili Manchettes +3",
		legs="Inyanga Shalwar +2",
		feet={ name="Bihu Slippers +3", augments={'Enhances "Nightingale" effect',}},
		neck="Mnbw. Whistle +1",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Gersemi Earring",
		right_ear="Regal Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}},}
		
	sets.midcast.HordeResist = {
		main={ name="Carnwenhan", augments={'Path: A',}},
		sub="Ammurapi Shield",
		range="Daurdabla",
		head="Brioso Roundlet +3",
		body="Brioso Justau. +3",
		hands="Fili Manchettes +3",
		legs="Fili Rhingrave +3",
		feet={ name="Bihu Slippers +3", augments={'Enhances "Nightingale" effect',}},
		neck="Mnbw. Whistle +1",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Gersemi Earring",
		right_ear="Regal Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}},}


    -- Other general spells and classes.
    sets.midcast.Cure = {
		main="Daybreak",
		sub="Genmei Shield",
		range={ name="Linos", augments={'Mag. Evasion+15','Phys. dmg. taken -4%','HP+20',}},
		head={ name="Kaykaus Mitra +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','"Cure" potency +6%','"Conserve MP"+7',}},
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		feet={ name="Kaykaus Boots +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		neck="Incanter's Torque",
		waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
		left_ear="Magnetic Earring",
		right_ear="Meili Earring",
		left_ring="Stikini Ring +1",
		right_ring="Sirona's Ring",
		back={ name="Aurist's Cape +1", augments={'Path: A',}},}

	sets.midcast.CureSelf = {
		main="Daybreak",
		sub="Genmei Shield",
		range={ name="Linos", augments={'Mag. Evasion+15','Phys. dmg. taken -4%','HP+20',}},
		head={ name="Kaykaus Mitra +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','"Cure" potency +6%','"Conserve MP"+7',}},
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		feet={ name="Kaykaus Boots +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		neck="Phalaina Locket",
		waist="Gishdubar Sash",
		left_ear="Magnetic Earring",
		right_ear="Meili Earring",
		left_ring="Kunaji Ring",
		right_ring="Asklepian Ring",
		back={ name="Aurist's Cape +1", augments={'Path: A',}},}

    sets.midcast.Curaga = sets.midcast.Cure

    sets.midcast.StatusRemoval = sets.midcast.Cure

    sets.midcast.Cursna = {
		main="Daybreak",
		sub="Genmei Shield",
		range={ name="Linos", augments={'Mag. Evasion+15','Phys. dmg. taken -4%','HP+20',}},
		head={ name="Kaykaus Mitra +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','"Cure" potency +6%','"Conserve MP"+7',}},
		hands="Inyan. Dastanas +2",
		legs={ name="Kaykaus Tights +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		feet={ name="Vanya Clogs", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
		neck="Debilis Medallion",
		waist="Bishop's Sash",
		left_ear="Beatific Earring",
		right_ear="Meili Earring",
		left_ring="Haoma's Ring",
		right_ring="Menelaus's Ring",
		back="Oretan. Cape +1",}

    sets.midcast['Enhancing Magic'] = {
		main={ name="Kali", augments={'Mag. Acc.+15','String instrument skill +10','Wind instrument skill +10',}},
		sub="Ammurapi Shield",
		range={ name="Linos", augments={'Mag. Evasion+15','Phys. dmg. taken -4%','HP+20',}},
		head={ name="Telchine Cap", augments={'"Fast Cast"+4','Enh. Mag. eff. dur. +10',}},
		body={ name="Telchine Chas.", augments={'Enh. Mag. eff. dur. +10',}},
		hands={ name="Telchine Gloves", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +9',}},
		legs={ name="Telchine Braconi", augments={'"Fast Cast"+3','Enh. Mag. eff. dur. +10',}},
		feet={ name="Telchine Pigaches", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +10',}},
		neck="Orunmila's Torque",
		waist="Embla Sash",
		left_ear="Etiolation Earring",
		right_ear="Loquac. Earring",
		left_ring="Prolix Ring",
		right_ring="Kishar Ring",
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}},}

    sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {waist="Gishdubar Sash"})
	sets.midcast.Haste = sets.midcast['Enhancing Magic']

    sets.midcast['Enfeebling Magic'] = {
		main={ name="Carnwenhan", augments={'Path: A',}},
		sub="Ammurapi Shield",
		range={ name="Linos", augments={'Mag. Evasion+15','Phys. dmg. taken -4%','HP+20',}},
		head="Brioso Roundlet +3",
		body="Brioso Justau. +3",
		hands="Inyan. Dastanas +2",
		legs="Fili Rhingrave +3",
		feet="Brioso Slippers +3",
		neck="Mnbw. Whistle +1",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear={ name="Fili Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','Damage taken-5%',}},
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Aurist's Cape +1", augments={'Path: A',}},}

    sets.midcast.Dispelga = set_combine(sets.midcast['Enfeebling Magic'], {main="Daybreak", sub="Ammurapi Shield"})
	
	sets.midcast['Dark Magic'] = {
		main={ name="Carnwenhan", augments={'Path: A',}},
		sub="Ammurapi Shield",
		range={ name="Linos", augments={'Mag. Evasion+15','Phys. dmg. taken -4%','HP+20',}},
		head="Brioso Roundlet +3",
		body="Brioso Justau. +3",
		hands="Inyan. Dastanas +2",
		legs="Fili Rhingrave +3",
		feet="Fili Cothurnes +3",
		neck="Mnbw. Whistle +1",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear={ name="Fili Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','Damage taken-5%',}},
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Aurist's Cape +1", augments={'Path: A',}},}
	
	sets.midcast.RA = {
		range="Trollbane",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs="Volte Tights",
		feet="Volte Spats",
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Yemaya Belt",
		left_ear="Tuisto Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring="Ilabrat Ring",
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.idle = {
		main="Daybreak",
		sub="Genmei Shield",
		range={ name="Linos", augments={'Mag. Evasion+15','Phys. dmg. taken -4%','HP+20',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Flume Belt +1",
		left_ear="Genmei Earring",
		right_ear={ name="Fili Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','Damage taken-5%',}},
		left_ring="Shadow Ring",
		right_ring="Roller's Ring",
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
	sets.idle.Refresh = {
		main="Daybreak",
		sub="Genmei Shield",
		range={ name="Linos", augments={'Mag. Evasion+15','Phys. dmg. taken -4%','HP+20',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','"Cure" potency +6%','"Conserve MP"+7',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Flume Belt +1",
		left_ear="Eabani Earring",
		right_ear="Sanare Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
	
    sets.latent_refresh = {waist="Fucho-no-obi"}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    sets.engaged = {
		main="Naegling",
		sub="Genmei Shield",
		range={ name="Linos", augments={'Accuracy+15','"Store TP"+4','Quadruple Attack +3',}},
		head={ name="Bunzi's Hat", augments={'Path: A',}},
		body="Ashera Harness",
		hands={ name="Bunzi's Gloves", augments={'Path: A',}},
		legs="Volte Tights",
		feet="Volte Spats",
		neck={ name="Bard's Charm +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Telos Earring",
		right_ear="Balder Earring +1",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    sets.engaged.Acc = {
		main="Naegling",
		sub="Genmei Shield",
		range={ name="Linos", augments={'Accuracy+15','"Store TP"+4','Quadruple Attack +3',}},
		head={ name="Bunzi's Hat", augments={'Path: A',}},
		body="Ashera Harness",
		hands={ name="Bunzi's Gloves", augments={'Path: A',}},
		legs="Volte Tights",
		feet="Volte Spats",
		neck={ name="Bard's Charm +2", augments={'Path: A',}},
		waist="Windbuffet Belt +1",
		left_ear="Telos Earring",
		right_ear="Balder Earring +1",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    -- * DNC Subjob DW Trait: +15%
    -- * NIN Subjob DW Trait: +25%

    -- No Magic Haste (74% DW to cap)
    sets.engaged.DW = {
		main="Naegling",
		sub={ name="Gleti\'s Knife", augments={'Path: A',}},
		range={ name="Linos", augments={'Accuracy+15','"Store TP"+4','Quadruple Attack +3',}},
		head={ name="Bunzi's Hat", augments={'Path: A',}},
		body="Ashera Harness",
		hands={ name="Bunzi's Gloves", augments={'Path: A',}},
		legs="Volte Tights",
		feet="Volte Spats",
		neck={ name="Bard's Charm +2", augments={'Path: A',}},
		waist="Reiki Yotai",
		left_ear="Suppanomimi",
		right_ear="Eabani Earring",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},}		
		--26%GDW + 25%JADW = 51%

    sets.engaged.DW.Acc = {
		main="Naegling",
		sub={ name="Gleti\'s Knife", augments={'Path: A',}},
		range={ name="Linos", augments={'Accuracy+15','"Store TP"+4','Quadruple Attack +3',}},
		head={ name="Bunzi's Hat", augments={'Path: A',}},
		body="Ashera Harness",
		hands={ name="Bunzi's Gloves", augments={'Path: A',}},
		legs="Volte Tights",
		feet="Volte Spats",
		neck={ name="Bard's Charm +2", augments={'Path: A',}},
		waist="Reiki Yotai",
		left_ear="Suppanomimi",
		right_ear="Eabani Earring",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},}
		--26%GDW + 25%JADW = 51%

    -- 15% Magic Haste (67% DW to cap)
    sets.engaged.DW.LowHaste = sets.engaged.DW
    sets.engaged.DW.Acc.LowHaste = sets.engaged.DW.Acc

    -- 30% Magic Haste (56% DW to cap)
    sets.engaged.DW.MidHaste = sets.engaged.DW
    sets.engaged.DW.Acc.MidHaste = sets.engaged.DW.Acc

    -- 35% Magic Haste (51% DW to cap)
    sets.engaged.DW.HighHaste = sets.engaged.DW
    sets.engaged.DW.Acc.HighHaste = sets.engaged.DW.Acc

    -- 45% Magic Haste (36% DW to cap)
    sets.engaged.DW.MaxHaste = {
		main="Naegling",
		sub={ name="Gleti\'s Knife", augments={'Path: A',}},
		range={ name="Linos", augments={'Accuracy+15','"Store TP"+4','Quadruple Attack +3',}},
		head={ name="Bunzi's Hat", augments={'Path: A',}},
		body="Ashera Harness",
		hands={ name="Bunzi's Gloves", augments={'Path: A',}},
		legs="Volte Tights",
		feet="Volte Spats",
		neck={ name="Bard's Charm +2", augments={'Path: A',}},
		waist="Windbuffet Belt +1",
		left_ear="Telos Earring",
		right_ear="Balder Earring +1",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},}
		--11%GDW + 25%JADW = 36%

    sets.engaged.DW.MaxHaste.Acc = {
		main="Naegling",
		sub={ name="Gleti\'s Knife", augments={'Path: A',}},
		range={ name="Linos", augments={'Accuracy+15','"Store TP"+4','Quadruple Attack +3',}},
		head={ name="Bunzi's Hat", augments={'Path: A',}},
		body="Ashera Harness",
		hands={ name="Bunzi's Gloves", augments={'Path: A',}},
		legs="Volte Tights",
		feet="Volte Spats",
		neck={ name="Bard's Charm +2", augments={'Path: A',}},
		waist="Windbuffet Belt +1",
		left_ear="Telos Earring",
		right_ear="Balder Earring +1",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},}		
		--11%GDW + 25%JADW = 36%
		
	---------------------------------------- AFTERMATH ---------------------------------------------
	
	sets.engaged.Aftermath = {
		range={ name="Linos", augments={'Accuracy+15','"Store TP"+4','Quadruple Attack +3',}},
		head={ name="Bunzi's Hat", augments={'Path: A',}},
		body="Ashera Harness",
		hands={ name="Bunzi's Gloves", augments={'Path: A',}},
		legs="Volte Tights",
		feet="Volte Spats",
		neck={ name="Bard's Charm +2", augments={'Path: A',}},
		waist="Windbuffet Belt +1",
		left_ear="Telos Earring",
		right_ear="Balder Earring +1",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
	sets.engaged.Acc.Aftermath = {
		range={ name="Linos", augments={'Accuracy+15','"Store TP"+4','Quadruple Attack +3',}},
		head={ name="Bunzi's Hat", augments={'Path: A',}},
		body="Ashera Harness",
		hands={ name="Bunzi's Gloves", augments={'Path: A',}},
		legs="Volte Tights",
		feet="Volte Spats",
		neck={ name="Bard's Charm +2", augments={'Path: A',}},
		waist="Windbuffet Belt +1",
		left_ear="Telos Earring",
		right_ear="Balder Earring +1",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
	sets.engaged.DW.Aftermath = {
		range={ name="Linos", augments={'Accuracy+15','"Store TP"+4','Quadruple Attack +3',}},
		head={ name="Bunzi's Hat", augments={'Path: A',}},
		body="Ashera Harness",
		hands={ name="Bunzi's Gloves", augments={'Path: A',}},
		legs="Volte Tights",
		feet="Volte Spats",
		neck={ name="Bard's Charm +2", augments={'Path: A',}},
		waist="Windbuffet Belt +1",
		left_ear="Telos Earring",
		right_ear="Balder Earring +1",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},}	
		
	sets.engaged.DW.Acc.Aftermath = {
		range={ name="Linos", augments={'Accuracy+15','"Store TP"+4','Quadruple Attack +3',}},
		head={ name="Bunzi's Hat", augments={'Path: A',}},
		body="Ashera Harness",
		hands={ name="Bunzi's Gloves", augments={'Path: A',}},
		legs="Volte Tights",
		feet="Volte Spats",
		neck={ name="Bard's Charm +2", augments={'Path: A',}},
		waist="Windbuffet Belt +1",
		left_ear="Telos Earring",
		right_ear="Balder Earring +1",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {
	    left_ear="Digni. Earring",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},}
		
	sets.engaged.HybridDW = {
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},}

    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
	sets.engaged.Aftermath.DT = set_combine(sets.engaged.Aftermath, sets.engaged.Hybrid)
    sets.engaged.Acc.DT = set_combine(sets.engaged.Acc, sets.engaged.Hybrid)
	sets.engaged.Acc.Aftermath.DT = set_combine(sets.engaged.Acc.Aftermath, sets.engaged.Hybrid)

    sets.engaged.DW.DT = set_combine(sets.engaged.DW, sets.engaged.HybridDW)
	sets.engaged.DW.Aftermath.DT = set_combine(sets.engaged.DW.Aftermath, sets.engaged.HybridDW)
    sets.engaged.DW.Acc.DT = set_combine(sets.engaged.DW.Acc, sets.engaged.HybridDW)
	sets.engaged.DW.Acc.Aftermath.DT = set_combine(sets.engaged.DW.Acc.Aftermath, sets.engaged.HybridDW)

    sets.engaged.DW.DT.LowHaste = set_combine(sets.engaged.DW.LowHaste, sets.engaged.HybridDW)
    sets.engaged.DW.Aftermath.DT.LowHaste = set_combine(sets.engaged.DW.Aftermath, sets.engaged.HybridDW)
    sets.engaged.DW.Acc.DT.LowHaste = set_combine(sets.engaged.DW.Acc.LowHaste, sets.engaged.HybridDW)
	sets.engaged.DW.Acc.Aftermath.DT.LowHaste = set_combine(sets.engaged.DW.Acc.Aftermath, sets.engaged.HybridDW)

    sets.engaged.DW.DT.MidHaste = set_combine(sets.engaged.DW.MidHaste, sets.engaged.HybridDW)
    sets.engaged.DW.Aftermath.DT.MidHaste = set_combine(sets.engaged.DW.Aftermath, sets.engaged.HybridDW)
    sets.engaged.DW.Acc.DT.MidHaste = set_combine(sets.engaged.DW.Acc.MidHaste, sets.engaged.HybridDW)
	sets.engaged.DW.Acc.Aftermath.DT.MidHaste = set_combine(sets.engaged.DW.Acc.Aftermath, sets.engaged.HybridDW)
	
    sets.engaged.DW.DT.HighHaste = set_combine(sets.engaged.DW.HighHaste, sets.engaged.HybridDW)
    sets.engaged.DW.Aftermath.DT.HighHaste = set_combine(sets.engaged.DW.Aftermath, sets.engaged.HybridDW)
    sets.engaged.DW.Acc.DT.HighHaste = set_combine(sets.engaged.DW.Acc.HighHaste, sets.engaged.HybridDW)
	sets.engaged.DW.Acc.Aftermath.DT.HighHaste = set_combine(sets.engaged.DW.Acc.Aftermath, sets.engaged.HybridDW)
	
    sets.engaged.DW.DT.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, sets.engaged.HybridDW)
    sets.engaged.DW.Aftermath.DT.MaxHaste = set_combine(sets.engaged.DW.Aftermath, sets.engaged.HybridDW)
    sets.engaged.DW.Acc.DT.MaxHaste = set_combine(sets.engaged.DW.Acc.MaxHaste, sets.engaged.HybridDW)
	sets.engaged.DW.Acc.Aftermath.DT.MaxHaste = set_combine(sets.engaged.DW.Acc.Aftermath, sets.engaged.HybridDW)

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	sets.Kiting = {left_ring="Shneddick Ring",}
	sets.Roller = {right_ring="Roller's Ring",}
	sets.Kiting_Roller = {left_ring="Shneddick Ring",right_ring="Roller's Ring",}

    sets.TreasureHunter = {
		hands={ name="Chironic Gloves", augments={'MND+4','Phys. dmg. taken -2%','"Treasure Hunter"+1','Accuracy+5 Attack+5',}},	--TH1
		body="Volte Jupon",		--TH2
		waist="Chaac Belt",} --TH1

    sets.SongDWDuration = {main="Carnwenhan", sub="Kali"}
	sets.SongSWDuration = {main="Carnwenhan", sub="Genmei Shield"}
	sets.Dummy = {range="Daurdabla",}
	sets.Effect = {range="Gjallarhorn",}

    sets.buff.Doom = {
		neck="Nicander's Necklace",
        waist="Gishdubar Sash", --10
        }

    sets.Obi = {waist="Hachirin-no-Obi"}
    sets.CP = {neck={ name="Bard's Charm +2", augments={'Path: A',}},}
	
	
	sets.Naegling = {main="Naegling", sub={ name="Gleti\'s Knife", augments={'Path: A',}},}
	sets.Naegling_Centovente = {main="Naegling", sub="Fusetto +2",}
	sets.Naegling.SW = {main="Naegling", sub="Genmei Shield"}
	
	sets.Carnwenhan = {main="Carnwenhan", sub="Crepuscular Knife",}
	sets.Carnwenhan.SW = {main="Carnwenhan", sub="Genmei Shield"}
	
	sets.Twashtar = {main={ name="Twashtar", augments={'Path: A',}}, sub={ name="Gleti\'s Knife", augments={'Path: A',}},}
	sets.Twashtar_Centovente = {main={ name="Twashtar", augments={'Path: A',}}, sub="Fusetto +2",}
	sets.Twashtar.SW = {main={ name="Twashtar", augments={'Path: A',}}, sub="Genmei Shield"}
	
	sets.Mandau = {main="Mandau", sub={ name="Gleti\'s Knife", augments={'Path: A',}},}
	sets.Mandau.SW = {main="Mandau", sub="Genmei Shield"}
	
	sets.Tauret = {main="Tauret", sub={ name="Gleti\'s Knife", augments={'Path: A',}},}
	sets.Tauret.SW = {main="Tauret", sub="Genmei Shield"}
	
	sets.Xoanon = {main="Xoanon", sub="Ultio Grip",}

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific Functions
-------------------------------------------------------------------------------------------------------------------

function job_precast(spell, action, spellMap, eventArgs)

		--Equips Marsyas for Honor March
    if spell.type == 'BardSong' then
        if spell.name == 'Honor March' then
            equip({range="Marsyas"})
        end
		if spell.name == 'Aria of Passion' then
            equip({range="Loughnashade"})
        end
    end

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

function job_midcast(spell, action, spellMap, eventArgs)

    if spell.type == 'BardSong' then
        -- layer general gear on first, then let default handler add song-specific gear.
        local generalClass = get_song_class(spell)
        if generalClass and sets.midcast[generalClass] then
            equip(sets.midcast[generalClass])
        end
		
			--Equips Marsyas for Honor March
        if spell.name == 'Honor March' then
            equip(sets.midcast.HonorMarch)
        end
		
		if spell.name == 'Aria of Passion' then
            equip(sets.midcast.Aria)
        end

			--Handles Lullaby sets
		if (spell.name == "Horde Lullaby" or spell.name == "Horde Lullaby II") and state.CastingMode.value == 'Normal' and state.SongEnmity.value == 'None' then 
			equip(sets.midcast.Horde)
		elseif (spell.name == "Horde Lullaby" or spell.name == "Horde Lullaby II") and state.CastingMode.value == 'Normal' and state.SongEnmity.value == 'Enmity' then 
			equip(sets.midcast.Enmity)
		elseif (spell.name == "Horde Lullaby" or spell.name == "Horde Lullaby II") and state.CastingMode.value == 'Resistant' and state.SongEnmity.value == 'None' then 
			equip(sets.midcast.HordeResist)		
		elseif (spell.name == "Horde Lullaby" or spell.name == "Horde Lullaby II") and state.CastingMode.value == 'Resistant' and state.SongEnmity.value == 'Enmity' then 
			equip(sets.midcast.Enmity)
		end
		
		if (spell.name == "Foe Lullaby" or spell.name == "Foe Lullaby II") and state.CastingMode.value == 'Normal' and state.SongEnmity.value == 'None' then 
			equip(sets.midcast.Foe)
		elseif (spell.name == "Foe Lullaby" or spell.name == "Foe Lullaby II") and state.CastingMode.value == 'Normal' and state.SongEnmity.value == 'Enmity' then 
			equip(sets.midcast.Enmity)
		elseif (spell.name == "Foe Lullaby" or spell.name == "Foe Lullaby II") and state.CastingMode.value == 'Resistant' and state.SongEnmity.value == 'None' then 
			equip(sets.midcast.FoeResist)			
		elseif (spell.name == "Foe Lullaby" or spell.name == "Foe Lullaby II") and state.CastingMode.value == 'Resistant' and state.SongEnmity.value == 'Enmity' then
			equip(sets.midcast.Enmity)
		end
		
    end
end

function job_post_midcast(spell, action, spellMap, eventArgs)

		--Handles Dualwield vs Singlewierd Bard songs
    if spell.type == 'BardSong' then
        if state.CombatForm.current == 'DW' then
            equip(sets.SongDWDuration)
		else
			equip(sets.SongSWDuration)
        end
    end
	
		--Changes Cure set if Curing yourself
	if spellMap == 'Cure' and spell.target.type == 'SELF' then
        equip(sets.midcast.CureSelf)
    end
	
		--Handles TP Overflow
	if spell.type == 'WeaponSkill' then
		if spell.english == "Mordant Rime" or spell.english == "Evisceration" or spell.english == "Shell Crusher" then
		else
			if state.TPBonus.value == true and (player.sub_job == 'DNC' or player.sub_job == 'NIN') then
				if player.tp > 1900 then
					equip(sets.precast.WS.FullTPPhysical)
				end
			else
				if player.tp > 2900 then
					equip(sets.precast.WS.FullTPPhysical)
				end
			end
			if spell.english == 'Aeolian Edge' then
				if state.TPBonus.value == true and state.WeaponSet.value == 'Twashtar' and (player.sub_job == 'DNC' or player.sub_job == 'NIN') then
					if player.tp > 1900 then
						equip(sets.precast.WS.FullTPMagical)
					end
				else
					if player.tp > 2900 then
						equip(sets.precast.WS.FullTPMagical)
					end
				end
				if world.day_element == 'Wind' then
					if world.weather_element == 'Wind' and get_weather_intensity() >= 1 then
						equip(sets.Obi)
					end
				else
					if world.weather_element == 'Wind' and get_weather_intensity() == 2 then
						equip(sets.Obi)
					end
				end
			end
			if spell.english == 'Rudra\'s Storm' then
				if state.TPBonus.value == true and state.WeaponSet.value == 'Twashtar' and (player.sub_job == 'DNC' or player.sub_job == 'NIN') then
					if player.tp > 1900 then
						equip(sets.precast.WS.FullTPRudra)
					end
				else
					if player.tp > 2900 then
						equip(sets.precast.WS.FullTPRudra)
					end
				end
			end
			if spell.english == 'Retribution' then
				if player.tp > 2900 then
					equip(sets.precast.WS.FullTPRudra)
				end
			end
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
	
			--Changes Engaged set when Aftermath is up
    if buff:startswith('Aftermath') then
        state.Buff.Aftermath = gain
        customize_melee_set()
        handle_equipping_gear(player.status)
    end

end

-------------------------------------------------------------------------------------------------------------------
-- Code for Melee sets
-------------------------------------------------------------------------------------------------------------------

	--Gearinfo related function
function job_handle_equipping_gear(playerStatus, eventArgs)
    check_gear()
    update_combat_form()
    determine_haste_group()
    check_moving()
end

function job_update(cmdParams, eventArgs)
    handle_equipping_gear(player.status)
end

function update_combat_form()
    if DW == true then
        state.CombatForm:set('DW')
    elseif DW == false then
        state.CombatForm:reset()
    end
	
	if state.WeaponSet.value == 'Naegling' then
		if player.sub_job == 'DNC' or player.sub_job == 'NIN' then
			if state.TPBonus.value == true then
				enable('main','sub')
				equip(sets.Naegling_Centovente)
				disable('main','sub')
			else
				enable('main','sub')
				equip(sets.Naegling)
				disable('main','sub')
			end			
		else
			enable('main','sub')
			equip(sets.Naegling.SW)
			disable('main','sub')
		end
	end
	
	if state.WeaponSet.value == 'Carnwenhan' then
		if player.sub_job == 'DNC' or player.sub_job == 'NIN' then
			enable('main','sub')
			equip(sets.Carnwenhan)
			disable('main','sub')
		else
			enable('main','sub')
			equip(sets.Carnwenhan.SW)
			disable('main','sub')
		end
	end
	
	if state.WeaponSet.value == 'Twashtar' then
		if player.sub_job == 'DNC' or player.sub_job == 'NIN' then
			if state.TPBonus.value == true then
				enable('main','sub')
				equip(sets.Twashtar_Centovente)
				disable('main','sub')
			else
				enable('main','sub')
				equip(sets.Twashtar)
				disable('main','sub')
			end	
		else
			enable('main','sub')
			equip(sets.Twashtar.SW)
			disable('main','sub')
		end
	end
	
	if state.WeaponSet.value == 'Mandau' then
		if player.sub_job == 'DNC' or player.sub_job == 'NIN' then
			enable('main','sub')
			equip(sets.Mandau)
			disable('main','sub')
		else
			enable('main','sub')
			equip(sets.Mandau.SW)
			disable('main','sub')
		end
	end
	
	if state.WeaponSet.value == 'Tauret' then
		if player.sub_job == 'DNC' or player.sub_job == 'NIN' then
			enable('main','sub')
			equip(sets.Tauret)
			disable('main','sub')
		else
			enable('main','sub')
			equip(sets.Tauret.SW)
			disable('main','sub')
		end
	end
	
	if state.WeaponSet.value == 'Xoanon' then
			enable('main','sub')
			equip(sets.Xoanon)
			disable('main','sub')
	end
	
	if state.WeaponSet.value == 'None' then
		enable('main','sub')
	end	
	
end

	--Handles Carol 1 / Carol 2 / Etude / Threnody keybinds
function job_self_command(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'carol1' then
        send_command('@input /ma '..state.Carol1.value..' <stpc>')
	elseif cmdParams[1]:lower() == 'carol2' then
        send_command('@input /ma '..state.Carol2.value..' <stpc>')
	elseif cmdParams[1]:lower() == 'etude' then
        send_command('@input /ma '..state.Etude.value..' <stpc>')
    elseif cmdParams[1]:lower() == 'threnody' then
        send_command('@input /ma '..state.Threnody.value..' <t>')
    end

    gearinfo(cmdParams, eventArgs)
end

function customize_melee_set(meleeSet)

	if player.sub_job == 'DNC' or player.sub_job == 'NIN' then
		if buffactive['Aftermath: Lv.3'] and player.equipment.main == "Carnwenhan" and state.OffenseMode.value == 'Normal' and state.HybridMode.value == 'Normal' then
			meleeSet = sets.engaged.DW.Aftermath
		end
		if buffactive['Aftermath: Lv.3'] and player.equipment.main == "Carnwenhan" and state.OffenseMode.value == 'Acc' and state.HybridMode.value == 'Normal' then
			meleeSet = sets.engaged.DW.Acc.Aftermath
		end
		if buffactive['Aftermath: Lv.3'] and player.equipment.main == "Carnwenhan" and state.OffenseMode.value == 'Normal' and state.HybridMode.value == 'DT' then
			meleeSet = sets.engaged.DW.Aftermath.DT
		end
			if buffactive['Aftermath: Lv.3'] and player.equipment.main == "Carnwenhan" and state.OffenseMode.value == 'Acc' and state.HybridMode.value == 'DT' then
			meleeSet = sets.engaged.DW.Acc.Aftermath.DT
		end
	else
		if buffactive['Aftermath: Lv.3'] and player.equipment.main == "Carnwenhan" and state.OffenseMode.value == 'Normal' and state.HybridMode.value == 'Normal' then
			meleeSet = sets.engaged.Aftermath
		end
		if buffactive['Aftermath: Lv.3'] and player.equipment.main == "Carnwenhan" and state.OffenseMode.value == 'Acc' and state.HybridMode.value == 'Normal' then
			meleeSet = sets.engaged.Acc.Aftermath
		end
		if buffactive['Aftermath: Lv.3'] and player.equipment.main == "Carnwenhan" and state.OffenseMode.value == 'Normal' and state.HybridMode.value == 'DT' then
			meleeSet = sets.engaged.Aftermath.DT
		end
			if buffactive['Aftermath: Lv.3'] and player.equipment.main == "Carnwenhan" and state.OffenseMode.value == 'Acc' and state.HybridMode.value == 'DT' then
			meleeSet = sets.engaged.Acc.Aftermath.DT
		end
	end
	
    return meleeSet
end

function get_custom_wsmode(spell, action, spellMap)
    local wsmode
    if state.OffenseMode.value == 'MidAcc' or state.OffenseMode.value == 'HighAcc' then
        wsmode = 'Acc'
    end

    return wsmode
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)

		--Allows CP back to stay on if toggled on
    if state.CP.current == 'on' then
         equip(sets.CP)
         disable('neck')
     else
         enable('neck')
     end
	 
		--Handles Latent Refresh
	if player.sub_job == 'WHM' or player.sub_job == 'SCH' or player.sub_job == 'RDM' then
		if player.mpp < 51 then
			idleSet = set_combine(idleSet, sets.latent_refresh)
		end
	end
	
    if state.Auto_Kite.value == true then
       idleSet = set_combine(idleSet, sets.Kiting)
	elseif rollNum == 11 == true then
		idleSet = set_combine(idleSet, sets.Roller)
	elseif state.Auto_Kite.value == true and rollNum == 11 == true then
		idleSet = set_combine(idleSet, sets.Kiting_Roller)
	end

    return idleSet
end

	--Function to display the current relevant user state when doing an update.
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
        ..string.char(31,060).. ' Magic: ' ..string.char(31,001)..c_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Determine the custom class to use for the given song.
function get_song_class(spell)
 
		--Can't use spell.targets:contains() because this is being pulled from resources
		--Handles Accuracy for Enfeebling Songs
    if set.contains(spell.targets, 'Enemy') then
        if state.CastingMode.value == 'Resistant' then
            return 'SongEnfeebleAcc'
        else
            return 'SongEnfeeble'
        end
	end
	
		--Handles the Dummy Song toggle allowing all songs to either use a normal instrument or multisong instrument
	if state.SongMode.value == 'Placeholder' and spell.type == 'BardSong' then
		equip(sets.Dummy)
	else
		equip(sets.Effect)
	end
	 	

end

	--Determines Haste Group / Melee set for Gear Info
function determine_haste_group()
    classes.CustomMeleeGroups:clear()
    if DW == true then
        if DW_needed <= 12 then
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif DW_needed > 21 and DW_needed <= 27 then
            classes.CustomMeleeGroups:append('HighHaste')
        elseif DW_needed > 27 and DW_needed <= 31 then
            classes.CustomMeleeGroups:append('MidHaste')
        elseif DW_needed > 31 and DW_needed <= 42 then
            classes.CustomMeleeGroups:append('LowHaste')
        elseif DW_needed > 42 then
            classes.CustomMeleeGroups:append('')
        end
    end
end

	--Gear Info Functions
function gearinfo(cmdParams, eventArgs)
    if cmdParams[1] == 'gearinfo' then
        if type(tonumber(cmdParams[2])) == 'number' then
            if tonumber(cmdParams[2]) ~= DW_needed then
            DW_needed = tonumber(cmdParams[2])
            DW = true
            end
        elseif type(cmdParams[2]) == 'string' then
            if cmdParams[2] == 'false' then
                DW_needed = 0
                DW = false
            end
        end
        if type(tonumber(cmdParams[3])) == 'number' then
            if tonumber(cmdParams[3]) ~= Haste then
                Haste = tonumber(cmdParams[3])
            end
        end
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
    set_macro_page(1, 3)
end

function set_lockstyle()
    send_command('wait 5; input /lockstyleset ' .. lockstyleset)
end