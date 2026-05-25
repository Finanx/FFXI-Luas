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

    lockstyleset = 10
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc')
    state.HybridMode:options('Normal', 'DT')
    state.WeaponskillMode:options('Normal', 'Acc', 'ATKCAP')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'Aminon', 'Refresh')
	state.TreasureMode:options('Tag', 'None')
	state.SongMode = M{['description']='Song Mode', 'None', 'Placeholder'}
	state.SongEnmity = M{['description']='Song Enmity', 'None', 'Enmity'}
	state.WeaponSet = M{['description']='Weapon Set', 'None', 'Naegling', 'Carnwenhan', 'Twashtar', 'Mpu_Gandring', 'Mandau', 'Tauret', 'Xoanon'}
	
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
	
	--Includes My Libraries for this lua to function
	
	include('/Finan_libs/Finan_Lib.lua')
	
	--Retrieve Gear for Bard
	
	send_command('wait 3;org get inventory brd.lua')
	send_command('wait 4;get Shihei all')
		
	--Job Settings

    select_default_macro_book()
    set_lockstyle()
	
	--Gearinfo Functions

    state.Auto_Kite = M(false, 'Auto_Kite')
    DW = false
    moving = false
    update_combat_form()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
	enable('main','sub','range','ammo','head','body','hands','legs','feet','neck','waist','left_ear','right_ear','left_ring','right_ring','back')

	--Remove Global Binds

	send_command('wait 1; exec Global-UnBinds.txt')
	
	--Remove Gear for Bard
	
	send_command('wait 1; org get Store.lua')
	send_command('put Shihei Satchel all')
	
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
		head="Bunzi's Hat",
		body="Inyanga Jubbah +2",
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','Spell interruption rate down +12%','"Cure" spellcasting time -7%',}},
		feet="Fili Cothurnes +2",
		neck="Voltsurge Torque",
		waist="Embla Sash",
		left_ear="Loquac. Earring",
		right_ear="Etiolation Earring",
		left_ring="Prolix Ring",
		right_ring="Kishar Ring",
		back="Fi Follet Cape +1",}

    sets.precast.FC.BardSong = {
		main={ name="Kali", augments={'Mag. Acc.+15','String instrument skill +10','Wind instrument skill +10',}},
		sub="Genmei Shield",
		head="Fili Calot +2",
		body="Inyanga Jubbah +2",
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','Spell interruption rate down +12%','"Cure" spellcasting time -7%',}},
		feet="Fili Cothurnes +2",
		neck="Voltsurge Torque",
		waist="Embla Sash",
		left_ear="Loquac. Earring",
		right_ear="Alabaster Earring",
		left_ring="Murky Ring",
		right_ring="Kishar Ring",
		back="Fi Follet Cape +1",}
		
    sets.precast.FC.Dispelga = set_combine(sets.precast.FC, {main="Daybreak", sub="Ammurapi Shield"})
	
	sets.precast['Herb Pastoral'] = set_combine(sets.precast.FC.BardSong, sets.Dummy)
	sets.precast['Shining Fantasia'] = set_combine(sets.precast.FC.BardSong, sets.Dummy)

    -- Precast sets to enhance JAs

    sets.precast.JA['Nightingale'] = {feet={ name="Bihu Slippers +4", augments={'Enhances "Nightingale" effect',}},}
    sets.precast.JA['Troubadour'] = {body={ name="Bihu Just. +4", augments={'Enhances "Troubadour" effect',}},}
    sets.precast.JA['Soul Voice'] = {legs={ name="Bihu Cannions +3", augments={'Enhances "Soul Voice" effect',}},}

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {legs="Dashing Subligar",waist="Gishdubar Sash",}
	
	sets.precast.Waltz['Healing Waltz'] = {legs="Dashing Subligar",}


    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
		range={ name="Linos", augments={'Accuracy+19','Weapon skill damage +3%','STR+8',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Bihu Just. +4", augments={'Enhances "Troubadour" effect',}},
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
		range={ name="Linos", augments={'Accuracy+14 Attack+14','Weapon skill damage +3%','DEX+8',}},
		head="Fili Calot +2",
		body="Fili Hongreline +2",
		hands="Fili Manchettes +2",
		legs="Fili Rhingrave +2",
		feet="Fili Cothurnes +2",
		neck={ name="Bard's Charm +2", augments={'Path: A',}},
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear="Digni. Earring",
		right_ear={ name="Fili Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','Damage taken-6%','MND+7 CHR+7',}},
		left_ring="Ephramad's Ring",
		right_ring={ name="Cacoethic Ring +1", augments={'Path: A',}},
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS.ATKCAP = {
		range={ name="Linos", augments={'Accuracy+19','Weapon skill damage +3%','STR+8',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body="Bunzi's Robe",
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
		range={ name="Linos", augments={'Accuracy+14 Attack+14','Weapon skill damage +3%','DEX+8',}},
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body={ name="Bihu Just. +4", augments={'Enhances "Troubadour" effect',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Zoar Subligar +1", augments={'Path: A',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Brutal Earring",
		right_ear="Mache Earring +1",
		left_ring="Ilabrat Ring",
		right_ring="Begrudging Ring",
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}

    sets.precast.WS['Mordant Rime'] = {
		range={ name="Linos", augments={'Accuracy+19','Weapon skill damage +3%','STR+8',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Bihu Just. +4", augments={'Enhances "Troubadour" effect',}},
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
		range={ name="Linos", augments={'Accuracy+14 Attack+14','Weapon skill damage +3%','DEX+8',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Bihu Just. +4", augments={'Enhances "Troubadour" effect',}},
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
		
    sets.precast.WS['Rudra\'s Storm'].ATKCAP = {
		range={ name="Linos", augments={'Accuracy+14 Attack+14','Weapon skill damage +3%','DEX+8',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body="Bunzi's Robe",
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
		range={ name="Linos", augments={'Accuracy+14 Attack+14','Weapon skill damage +3%','DEX+8',}},
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
		range={ name="Linos", augments={'Accuracy+19','Weapon skill damage +3%','STR+8',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Bihu Just. +4", augments={'Enhances "Troubadour" effect',}},
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
		range={ name="Linos", augments={'Accuracy+14 Attack+14','Weapon skill damage +3%','DEX+8',}},
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
		range={ name="Linos", augments={'Accuracy+14 Attack+14','Weapon skill damage +3%','DEX+8',}},
		head="Fili Calot +2",
		body="Fili Hongreline +2",
		hands="Fili Manchettes +2",
		legs="Fili Rhingrave +2",
		feet="Fili Cothurnes +2",
		neck="Sanctity Necklace",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Digni. Earring",
		right_ear={ name="Fili Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','Damage taken-6%','MND+7 CHR+7',}},
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring={ name="Cacoethic Ring +1", augments={'Path: A',}},
		back="Null Shawl",}
		
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
		back="Null Shawl",}
	
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
		back="Null Shawl",}
		
	sets.precast.Volte_Harness = set_combine(sets.precast.Wing, {body="Volte Harness"})
	sets.precast.Prishes_Boots = set_combine(sets.precast.Wing, {feet="Prishe\'s Boots +1",})


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- General set for recast times.
    sets.midcast.FastRecast = sets.precast.FC
	
	sets.midcast.Enmity = {
		main="Mafic Cudgel",
		sub="Genmei Shield",
		range="Loughnashade",
		head="Halitus Helm",
		body="Emet Harness +1",
		hands="Fili Manchettes +2",
		legs="Zoar Subligar +1",
		feet="Nyame Sollerets",
		neck="Unmoving Collar +1",
		waist="Kasiri Belt",
		left_ear="Friomisi Earring",
		right_ear="Cryptic Earring",
		left_ring="Eihwaz Ring",
		right_ring="Gelatinous Ring +1",
		back="Null Shawl",}


    -- For song buffs (duration and AF3 set bonus)
	
	sets.midcast.SongEnhancing = {
		main={ name="Carnwenhan", augments={'Path: A',}},
		sub={ name="Kali", augments={'Mag. Acc.+15','String instrument skill +10','Wind instrument skill +10',}},
		head="Fili Calot +2",
		body="Fili Hongreline +2",
		hands="Fili Manchettes +2",
		legs="Inyanga Shalwar +2",
		feet="Brioso Slippers +4",
		neck="Mnbw. Whistle +1",
		waist="Embla Sash",
		left_ear="Tuisto Earring",
		right_ear="Alabaster Earring",
		left_ring="Murky Ring",
		right_ring="Gelatinous Ring +1",
		back={ name="Intarabus's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},}
		
	sets.midcast['Adventurer\'s Dirge'] = sets.midcast.SongEnhancing
	sets.midcast['Foe Sirvente'] = sets.midcast.SongEnhancing
		
	sets.midcast['Herb Pastoral'] = set_combine(sets.precast.FC, sets.Dummy)
	sets.midcast['Shining Fantasia'] = set_combine(sets.precast.FC, sets.Dummy)


    -- Defines Song sets can also add equipment to increase certain songs.
	

	sets.midcast.Paeon = set_combine(sets.midcast.SongEnhancing, {head="Brioso Roundlet +3"})
	sets.midcast.Ballad = set_combine(sets.midcast.SongEnhancing, {})
	sets.midcast.Minne = set_combine(sets.midcast.SongEnhancing, {})
	sets.midcast.Mambo = set_combine(sets.midcast.SongEnhancing, {})
	sets.midcast.Minuet = set_combine(sets.midcast.SongEnhancing, {body="Fili Hongreline +2"})
	sets.midcast.Madrigal = set_combine(sets.midcast.SongEnhancing, {head="Fili Calot +2"})
	sets.midcast.HonorMarch = set_combine(sets.midcast.SongEnhancing, {range="Marsyas", hands="Fili Manchettes +2"})
	sets.midcast.Aria = set_combine(sets.midcast.SongEnhancing, {range="Loughnashade"})
	sets.midcast.March = set_combine(sets.midcast.SongEnhancing, {hands="Fili Manchettes +2"})
	sets.midcast.Etude = set_combine(sets.midcast.SongEnhancing, {head="Mousai Turban +1",})
	sets.midcast.Carol = set_combine(sets.midcast.SongEnhancing, {hands="Mousai Gages +1",})
	sets.midcast["Sentinel's Scherzo"] = set_combine(sets.midcast.SongEnhancing, {feet="Fili Cothurnes +2"})
	sets.midcast.Mazurka = set_combine(sets.midcast.SongEnhancing, {})
	

    -- For song defbuffs (duration primary, accuracy secondary)
    sets.midcast.SongEnfeeble = {
		main={ name="Carnwenhan", augments={'Path: A',}},
		sub="Ammurapi Shield",
		range="Loughnashade",
		head="Brioso Roundlet +3",
		body="Fili Hongreline +2",
		hands="Fili Manchettes +2",
		legs="Inyanga Shalwar +2",
		feet="Brioso Slippers +4",
		neck="Mnbw. Whistle +1",
		waist="Null Belt",
		left_ear="Regal Earring",
		right_ear={ name="Fili Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','Damage taken-6%','MND+7 CHR+7',}},
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Null Shawl",}

    -- For song defbuffs (accuracy primary, duration secondary)
    sets.midcast.SongEnfeebleAcc = {
		main={ name="Carnwenhan", augments={'Path: A',}},
		sub="Ammurapi Shield",
		range="Loughnashade",
		head="Brioso Roundlet +3",
		body="Brioso Justau. +3",
		hands="Fili Manchettes +2",
		legs="Brioso Cannions +3",
		feet="Brioso Slippers +4",
		neck="Mnbw. Whistle +1",
		waist="Null Belt",
		left_ear="Regal Earring",
		right_ear={ name="Fili Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','Damage taken-6%','MND+7 CHR+7',}},
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Null Shawl",}

	sets.midcast.Threnody = set_combine(sets.midcast.SongEnfeeble, {body="Mou. Manteel +1",})
	sets.midcast.Threnody.Resistant = set_combine(sets.midcast.SongEnfeebleAcc, {body="Mou. Manteel +1",})
	
	-- For Foe Lullaby.
	sets.midcast.Foe = set_combine(sets.midcast.SongEnfeeble, {range="Marsyas", hands="Brioso Cuffs +4",})
	
	sets.midcast.FoeResist	= set_combine(sets.midcast.SongEnfeeble, {range="Loughnashade", hands="Brioso Cuffs +4",})
		
    -- For Horde Lullaby.
    sets.midcast.Horde = {
		main={ name="Carnwenhan", augments={'Path: A',}},
		sub="Ammurapi Shield",
		range="Blurred Harp +1",
		head="Brioso Roundlet +3",
		body="Brioso Justau. +3",
		hands="Fili Manchettes +2",
		legs="Inyanga Shalwar +2",
		feet="Brioso Slippers +4",
		neck="Mnbw. Whistle +1",
		waist="Null Belt",
		left_ear="Gersemi Earring",
		right_ear="Regal Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Null Shawl",}
		
	sets.midcast.HordeResist = sets.midcast.Horde


    -- Other general spells and classes.
    sets.midcast.Cure = {
		main="Daybreak",
		sub="Genmei Shield",
		range={ name="Linos", augments={'Mag. Evasion+15','Phys. dmg. taken -4%','VIT+8',}},
		head={ name="Kaykaus Mitra +1", augments={'MP+80','Spell interruption rate down +12%','"Cure" spellcasting time -7%',}},
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','"Cure" potency +6%','"Conserve MP"+7',}},
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','Spell interruption rate down +12%','"Cure" spellcasting time -7%',}},
		feet={ name="Kaykaus Boots +1", augments={'MP+80','Spell interruption rate down +12%','"Cure" spellcasting time -7%',}},
		neck="Incanter's Torque",
		waist="Shinjutsu-no-Obi +1",
		left_ear="Magnetic Earring",
		right_ear="Meili Earring",
		left_ring="Stikini Ring +1",
		right_ring="Sirona's Ring",
		back="Fi Follet Cape +1",}

	sets.midcast.CureSelf = {
		main="Daybreak",
		sub="Genmei Shield",
		range={ name="Linos", augments={'Mag. Evasion+15','Phys. dmg. taken -4%','VIT+8',}},
		head={ name="Kaykaus Mitra +1", augments={'MP+80','Spell interruption rate down +12%','"Cure" spellcasting time -7%',}},
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','"Cure" potency +6%','"Conserve MP"+7',}},
		hands="Buremte Gloves",
		legs={ name="Kaykaus Tights +1", augments={'MP+80','Spell interruption rate down +12%','"Cure" spellcasting time -7%',}},
		feet={ name="Kaykaus Boots +1", augments={'MP+80','Spell interruption rate down +12%','"Cure" spellcasting time -7%',}},
		neck="Incanter's Torque",
		waist="Gishdubar Sash",
		left_ear="Magnetic Earring",
		right_ear="Meili Earring",
		left_ring="Kunaji Ring",
		right_ring="Sirona's Ring",
		back="Fi Follet Cape +1",}

    sets.midcast.Curaga = sets.midcast.Cure

    sets.midcast.StatusRemoval = sets.midcast.Cure

    sets.midcast.Cursna = {
		main="Daybreak",
		sub="Genmei Shield",
		range={ name="Linos", augments={'Mag. Evasion+15','Phys. dmg. taken -4%','VIT+8',}},
		head={ name="Kaykaus Mitra +1", augments={'MP+80','Spell interruption rate down +12%','"Cure" spellcasting time -7%',}},
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','"Cure" potency +6%','"Conserve MP"+7',}},
		hands="Inyan. Dastanas +2",
		legs={ name="Kaykaus Tights +1", augments={'MP+80','Spell interruption rate down +12%','"Cure" spellcasting time -7%',}},
		feet={ name="Vanya Clogs", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
		neck="Debilis Medallion",
		waist="Bishop's Sash",
		left_ear="Beatific Earring",
		right_ear="Meili Earring",
		left_ring="Haoma's Ring",
		right_ring="Menelaus's Ring",
		back="Fi Follet Cape +1",}

    sets.midcast['Enhancing Magic'] = {
		main={ name="Kali", augments={'Mag. Acc.+15','String instrument skill +10','Wind instrument skill +10',}},
		sub="Ammurapi Shield",
		range={ name="Linos", augments={'Mag. Evasion+15','Phys. dmg. taken -4%','VIT+8',}},
		head={ name="Telchine Cap", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		body={ name="Telchine Chas.", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		hands={ name="Telchine Gloves", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		legs={ name="Telchine Braconi", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		feet={ name="Telchine Pigaches", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		neck="Voltsurge Torque",
		waist="Embla Sash",
		left_ear="Etiolation Earring",
		right_ear="Loquac. Earring",
		left_ring="Prolix Ring",
		right_ring="Kishar Ring",
		back="Fi Follet Cape +1",}

    sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {waist="Gishdubar Sash"})
	sets.midcast.Haste = sets.midcast['Enhancing Magic']

    sets.midcast['Enfeebling Magic'] = {
		main={ name="Carnwenhan", augments={'Path: A',}},
		sub="Ammurapi Shield",
		range={ name="Linos", augments={'Mag. Evasion+15','Phys. dmg. taken -4%','VIT+8',}},
		head="Brioso Roundlet +3",
		body="Brioso Justau. +3",
		hands="Inyan. Dastanas +2",
		legs="Brioso Cannions +3",
		feet="Brioso Slippers +4",
		neck="Mnbw. Whistle +1",
		waist="Null Belt",
		left_ear="Regal Earring",
		right_ear={ name="Fili Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','Damage taken-6%','MND+7 CHR+7',}},
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Null Shawl",}

    sets.midcast.Dispelga = set_combine(sets.midcast['Enfeebling Magic'], {main="Daybreak", sub="Ammurapi Shield"})
	
	sets.midcast['Dark Magic'] = {
		main={ name="Carnwenhan", augments={'Path: A',}},
		sub="Ammurapi Shield",
		range={ name="Linos", augments={'Mag. Evasion+15','Phys. dmg. taken -4%','VIT+8',}},
		head="Brioso Roundlet +3",
		body="Brioso Justau. +3",
		hands="Inyan. Dastanas +2",
		legs="Brioso Cannions +3",
		feet="Brioso Slippers +4",
		neck="Mnbw. Whistle +1",
		waist="Null Belt",
		left_ear="Regal Earring",
		right_ear={ name="Fili Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','Damage taken-6%','MND+7 CHR+7',}},
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Null Shawl",}
		
	sets.midcast['Absorb-TP'] = {
		main={ name="Carnwenhan", augments={'Path: A',}},
		sub="Ammurapi Shield",
		range={ name="Linos", augments={'Mag. Evasion+15','Phys. dmg. taken -4%','VIT+8',}},
		head="Bunzi's Hat",
		body="Inyanga Jubbah +2",
		hands="Inyan. Dastanas +2",
		legs="Brioso Cannions +3",
		feet="Fili Cothurnes +2",
		neck="Mnbw. Whistle +1",
		waist="Null Belt",
		left_ear="Regal Earring",
		right_ear={ name="Fili Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','Damage taken-6%','MND+7 CHR+7',}},
		left_ring="Kishar Ring",
		right_ring="Stikini Ring +1",
		back="Null Shawl",}
	
	sets.midcast.RA = {
		range="Trollbane",
		head="Nyame Helm",
		body="Volte Harness",
		hands="Nyame Gauntlets",
		legs="Volte Tights",
		feet="Volte Spats",
		neck="Loricate Torque +1",
		waist="Yemaya Belt",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Gelatinous Ring +1",
		right_ring="Crepuscular Ring",
		back="Null Shawl",}

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.idle = {
		main="Daybreak",
		sub="Genmei Shield",
		range={ name="Linos", augments={'Mag. Evasion+15','Phys. dmg. taken -4%','VIT+8',}},
		head="Null Masque",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Loricate Torque +1",
		waist="Flume Belt +1",
		left_ear="Odnowa Earring +1",
		right_ear="Alabaster Earring",
		left_ring="Murky Ring",
		right_ring="Shadow Ring",
		back="Null Shawl",}
		
    sets.idle.Aminon = {
		main="Daybreak",
		sub="Genmei Shield",
		range={ name="Linos", augments={'Mag. Evasion+15','Phys. dmg. taken -4%','VIT+8',}},
		head="Null Masque",
		body="Volte Harness",
		hands="Regal Gloves",
		legs="Volte Tights",
		feet="Volte Spats",
		neck="Rep. Plat. Medal",
		waist="Sweordfaetels +1",
		left_ear="Odnowa Earring +1",
		right_ear={ name="Fili Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','Damage taken-6%','MND+7 CHR+7',}},
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
		back="Null Shawl",}
		
	sets.idle.Refresh = {
		main="Mpaca's Staff",
		sub="Enki Strap",
		range={ name="Linos", augments={'Mag. Evasion+15','Phys. dmg. taken -4%','VIT+8',}},
		head="Null Masque",
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','"Cure" potency +6%','"Conserve MP"+7',}},
		hands="Fili Manchettes +2",
		legs="Fili Rhingrave +2",
		feet="Nyame Sollerets",
		neck="Sibyl Scarf",
		waist="Flume Belt +1",
		left_ear="Alabaster Earring",
		right_ear={ name="Fili Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','Damage taken-6%','MND+7 CHR+7',}},
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Null Shawl",}
		
	sets.idle.Town = set_combine(sets.idle, {main="Mpu Gandring", range="Loughnashade"})

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
		range={ name="Linos", augments={'Accuracy+18','"Store TP"+4','Quadruple Attack +3',}},
		head="Bunzi's Hat",
		body="Ashera Harness",
		hands="Bunzi's Gloves",
		legs="Volte Tights",
		feet="Nyame Sollerets",
		neck={ name="Bard's Charm +2", augments={'Path: A',}},
		waist="Sailfi Belt +1",
		left_ear="Dedition Earring",
		right_ear="Brutal Earring",
		left_ring="Petrov Ring",
		right_ring="Chirich Ring +1",
		back="Null Shawl",}

    sets.engaged.Acc = sets.engaged
		
	------------------------------------------------------------------------------------------------
	-----------------------------------------Dual Wield Sets----------------------------------------
	------------------------------------------------------------------------------------------------

    sets.engaged.DW = {
		main="Naegling",
		sub={ name="Gleti\'s Knife", augments={'Path: A',}},
		range={ name="Linos", augments={'Accuracy+18','"Store TP"+4','Quadruple Attack +3',}},
		head="Bunzi's Hat",
		body="Ashera Harness",
		hands="Bunzi's Gloves",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck={ name="Bard's Charm +2", augments={'Path: A',}},
		waist="Reiki Yotai",
		left_ear="Eabani Earring",
		right_ear="Alabaster Earring",
		left_ring="Petrov Ring",
		right_ring="Chirich Ring +1",
		back="Null Shawl",}	

    sets.engaged.DW.Acc = sets.engaged.DW

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {
		range={ name="Linos", augments={'Accuracy+18','"Store TP"+4','Quadruple Attack +3',}},
		head="Bunzi's Hat",
		body="Ashera Harness",
		hands="Bunzi's Gloves",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck={ name="Bard's Charm +2", augments={'Path: A',}},
		waist="Sailfi Belt +1",
		left_ear="Dedition Earring",
		right_ear="Cessance Earring",
		left_ring="Moonlight Ring",
		right_ring="Chirich Ring +1",
		back="Null Shawl",}
		
	sets.engaged.HybridDW = {
		range={ name="Linos", augments={'Accuracy+18','"Store TP"+4','Quadruple Attack +3',}},
		head="Bunzi's Hat",
		body="Ashera Harness",
		hands="Bunzi's Gloves",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck={ name="Bard's Charm +2", augments={'Path: A',}},
		waist="Reiki Yotai",
		left_ear="Eabani Earring",
		right_ear="Alabaster Earring",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
		back="Null Shawl",}

    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
    sets.engaged.Acc.DT = set_combine(sets.engaged.Acc, sets.engaged.Hybrid)

    sets.engaged.DW.DT = set_combine(sets.engaged.DW, sets.engaged.HybridDW)
    sets.engaged.DW.Acc.DT = set_combine(sets.engaged.DW.Acc, sets.engaged.HybridDW)

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	sets.Kiting = {left_ring="Shneddick Ring",}
	sets.Roller = {right_ring="Roller's Ring",}
	sets.Kiting_Roller = {left_ring="Shneddick Ring",right_ring="Roller's Ring",}

	sets.TreasureHunter = {
		body="Volte Jupon",
		hands="Volte Bracers",
		waist="Chaac Belt",}

    sets.SongDWDuration = {main="Carnwenhan", sub="Kali"}
	sets.SongSWDuration = {main="Carnwenhan", sub="Genmei Shield"}
	sets.Dummy = {range="Loughnashade"}
	sets.Effect = {range="Loughnashade"}

    sets.buff.Doom = {
		neck="Nicander's Necklace",
        waist="Gishdubar Sash", --10
        }

    sets.Obi = {waist="Hachirin-no-Obi"}
    sets.CP = {back="Mecisto. Mantle"}
	
	
	sets.Naegling = {main="Naegling", sub={ name="Gleti\'s Knife", augments={'Path: A',}},}
	sets.Naegling_Centovente = {main="Naegling", sub="Fusetto +2",}
	sets.Naegling.SW = {main="Naegling", sub="Genmei Shield"}
	
	sets.Carnwenhan = {main="Carnwenhan", sub="Fusetto +2",}
	sets.Carnwenhan.SW = {main="Carnwenhan", sub="Genmei Shield"}
	
	sets.Twashtar = {main={ name="Twashtar", augments={'Path: A',}}, sub={ name="Gleti\'s Knife", augments={'Path: A',}},}
	sets.Twashtar_Centovente = {main={ name="Twashtar", augments={'Path: A',}}, sub="Fusetto +2",}
	sets.Twashtar.SW = {main={ name="Twashtar", augments={'Path: A',}}, sub="Genmei Shield"}
	
	sets.Mandau = {main="Mandau", sub={ name="Gleti\'s Knife", augments={'Path: A',}},}
	sets.Mandau.SW = {main="Mandau", sub="Genmei Shield"}
	
	sets.Mpu_Gandring = {main="Mpu Gandring", sub={ name="Gleti\'s Knife", augments={'Path: A',}},}
	sets.Mpu_Gandring_Centovente = {main="Mpu Gandring", sub="Fusetto +2",}
	sets.Mpu_Gandring.SW = {main="Mpu Gandring", sub="Genmei Shield"}
	
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
		if spell.name == 'Herb Pastoral' or spell.name == 'Shining Fantasia' then
			equip(sets.Dummy)
		end
    end

		--Will stop utsusemi from being cast if 3 shadows or more
    if spellMap == 'Utsusemi' then
        if buffactive['Copy Image'] or buffactive['Copy Image (2)'] then 
			send_command('cancel Copy Image*')
		elseif buffactive['Copy Image (3)'] then
            cancel_spell()
            add_to_chat(123, '**!! '..spell.english..' Canceled: [3+ IMAGES] !!**')
            eventArgs.handled = true
            return
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
		
		if spell.name == 'Herb Pastoral' or spell.name == 'Shining Fantasia' then
			equip(sets.Dummy)
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
	
end

-------------------------------------------------------------------------------------------------------------------
-- Code for Melee sets
-------------------------------------------------------------------------------------------------------------------

	--Gearinfo related function
function job_handle_equipping_gear(playerStatus, eventArgs)
    check_gear()
    update_combat_form()
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
	
	if state.WeaponSet.value == 'Mpu_Gandring' then
		if player.sub_job == 'DNC' or player.sub_job == 'NIN' then
			if state.TPBonus.value == true then
				enable('main','sub')
				equip(sets.Mpu_Gandring_Centovente)
				disable('main','sub')
			else
				enable('main','sub')
				equip(sets.Mpu_Gandring)
				disable('main','sub')
			end	
		else
			enable('main','sub')
			equip(sets.Mpu_Gandring.SW)
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
    set_macro_page(1, 10)
end

function set_lockstyle()
    send_command('wait 5; input /lockstyleset ' .. lockstyleset)
end