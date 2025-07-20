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
--			    	[ Windows + W ]         Toggles Weapon Lock
--  				[ Windows + R ]         Toggles Range Lock
--					[ Windows + T ]			Toggles Treasure Hunter Mode
--              	[ Windows + C ]     	Toggle Capacity Points Mode
--              	[ Windows + I ]     	Pulls all items in Gear Retrieval
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
--  Job Specific Keybinds (Thief Binds)
-------------------------------------------------------------------------------------------------------------------
--
--	Modes:			[ Windows + 1 ]			Sets Weapon to Twashtar
--					[ Windows + 2 ]			Sets Weapon to Mandau
--					[ Windows + 3 ]			Sets Weapon to Tauret
--					[ Windows + 4 ]			Sets Weapon to Naegling
--					[ Windows + 5 ]			Sets Weapon to Karambit
--
--	Echo Binds:		[ CTRL + Numpad- ]		Shows main Weaponskill Binds in game
--					[ ALT + Numpad- ]		Shows Alternate Weaponskill Binds in game
--					[ Shift + Numpad- ]		Shows Item Binds in game
--					[ Windows + Numpad- ]	Shows Food/Weapon/Misc. Binds in game
--
--  Abilities:  	[ CTRL + ` ]   	Sneak Attack
--					[ ALT + ` ]   	Trick Attack
--
-------------------------------------------------------------------------------------------------------------------
--  Custom Commands (preface with /console to use these in macros)
-------------------------------------------------------------------------------------------------------------------
--
--  TH Modes:  None                 Will never equip TH gear
--             Tag                  Will equip TH gear sufficient for initial contact with a mob
--             SATA - Will equip TH gear sufficient for initial contact with a mob, and when using SATA
--             Fulltime - Will keep TH gear equipped fulltime
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
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff['Striking Flourish'] = buffactive['striking flourish'] or false

    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
					"Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring", "Emporox's Ring"}

    include('Mote-TreasureHunter')

    -- For th_action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}

    state.CP = M(false, "Capacity Points Mode")

    lockstyleset = 17
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc')
    state.HybridMode:options('Normal', 'DT')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.IdleMode:options('Normal', 'Aminon')
	state.TreasureMode:options('Tag', 'None')
	state.step = M{['description']='step', 'Quickstep', 'Stutter Step', 'Feather Step'}

	state.WeaponSet = M{['description']='Weapon Set', 'Mpu_Gandring', 'Terpsichore', 'Twashtar', 'Mandau', 'Tauret', 'Karambit'}
	state.OffhandSet = M{['description']='Weapon Set', 'Crepuscular', 'Gletis_Knife'}
	state.WeaponLock = M(false, 'Weapon Lock')
	state.TPBonus = M(true, 'TP Bonus')

	--Includes Global Bind keys
	
	send_command('wait 2; exec Global-Binds.txt')

	--Thief Binds
	
	send_command('wait 2; exec /DNC/DNC-Binds.txt')
	
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
		
	sets.Enmity = {
		ammo="Sapience Orb",
		head="Halitus Helm",
		body={ name="Emet Harness +1", augments={'Path: A',}},
		hands="Kurys Gloves",
		legs={ name="Zoar Subligar +1", augments={'Path: A',}},
		feet="Macu. Toe Sh. +2",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Kasiri Belt",
		left_ear="Cryptic Earring",
		right_ear="Trux Earring",
		left_ring="Eihwaz Ring",
		right_ring="Supershear Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}

    -- Precast sets to enhance JAs
	
    sets.precast.JA.Provoke = sets.Enmity

    sets.precast.JA['Saber Dance'] = {legs={ name="Horos Tights +4", augments={'Enhances "Saber Dance" effect',}},}
    sets.precast.JA['No Foot Rise'] = {body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},}
	sets.precast.JA['Trance'] = {head={ name="Horos Tiara +3", augments={'Enhances "Trance" effect',}},}

    sets.precast.JA['Violent Flourish'] = {
		ammo="Yamarang",
		head="Maculele Tiara +2",
		body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
		hands="Macu. Bangles +2",
		legs="Maculele Tights +2",
		feet="Macu. Toe Sh. +2",
		neck={ name="Etoile Gorget +2", augments={'Path: A',}},
		waist="Eschan Stone",
		left_ear="Crep. Earring",
		right_ear="Digni. Earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Stikini Ring +1",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
	sets.precast.JA['Animated Flourish'] = sets.Enmity
	
	sets.precast.JA['Reverse Flourish'] = set_combine(sets.idle, {hands="Macu. Bangles +2",back={ name="Toetapper Mantle", augments={'"Store TP"+1','"Dual Wield"+2','"Rev. Flourish"+30',}},})

	sets.precast.JA['Box Step'] = {
		ammo="Yamarang",
		head="Maxixi Tiara +3",
		body="Maxixi Casaque +3",
		hands="Maxixi Bangles +4",
		legs={ name="Horos Tights +4", augments={'Enhances "Saber Dance" effect',}},
		feet={ name="Horos T. Shoes +3", augments={'Enhances "Closed Position" effect',}},
		neck={ name="Etoile Gorget +2", augments={'Path: A',}},
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear="Odr Earring",
		right_ear={ name="Macu. Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+19','Mag. Acc.+19','"Store TP"+7','DEX+13 AGI+13',}},
		left_ring="Ephramad's Ring",
		right_ring="Regal Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
	sets.precast.JA['Quickstep'] = sets.precast.JA['Box Step']
	sets.precast.JA['Stutter Step'] = sets.precast.JA['Box Step']
	sets.precast.JA['Feather Step'] = set_combine(sets.precast.JA['Box Step'], {feet="Macu. Toe Sh. +2",})
	
	sets.precast.Jig = {legs={ name="Horos Tights +4", augments={'Enhances "Saber Dance" effect',}}}
	
	sets.precast.Samba = {head="Maxixi Tiara +3",back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}

    sets.precast.Waltz = {
		ammo="Yamarang",
		head={ name="Anwig Salade", augments={'CHR+4','"Waltz" ability delay -2','CHR+2','"Fast Cast"+2',}},
		body="Maxixi Casaque +3",
		hands={ name="Horos Bangles +3", augments={'Enhances "Fan Dance" effect',}},
		legs="Dashing Subligar",
		feet="Maxixi Toe Shoes +3",
		neck={ name="Etoile Gorget +2", augments={'Path: A',}},
		waist="Chaac Belt",
		left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		right_ear="Tuisto Earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Defending Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
	
	sets.precast.JA['Jump'] = sets.precast.Wing	
	sets.precast.JA['High Jump'] = sets.precast.Wing
		
    sets.precast.FC = {
		ammo="Sapience Orb",
		head={ name="Herculean Helm", augments={'"Mag.Atk.Bns."+6','"Fast Cast"+6','MND+3','Mag. Acc.+4',}},
		body={ name="Adhemar Jacket +1", augments={'HP+105','"Fast Cast"+10','Magic dmg. taken -4',}},
		hands={ name="Leyline Gloves", augments={'Accuracy+5','"Mag.Atk.Bns."+7','"Fast Cast"+1',}},
		legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
		feet={ name="Herculean Boots", augments={'Mag. Acc.+17','"Fast Cast"+6','VIT+6',}},
		neck="Voltsurge Torque",
		waist="Plat. Mog. Belt",
		left_ear="Etiolation Earring",
		right_ear="Loquac. Earring",
		left_ring="Prolix Ring",
		right_ring="Defending Ring",
		back="Null Shawl",}
		
    sets.precast.RA = {
		range="Trollbane",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body="Volte Harness",
		hands="Macu. Bangles +2",
		legs={ name="Adhemar Kecks +1", augments={'AGI+12','"Rapid Shot"+13','Enmity-6',}},
		feet="Meg. Jam. +2",
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Flume Belt +1",
		left_ear="Genmei Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring="Crepuscular Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
	
		--Set used for Icarus Wing to maximize TP gain	
	sets.precast.Wing = {
		ammo="Aurgelmir Orb +1",
		head="Maculele Tiara +2",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Macu. Toe Sh. +2",
		neck={ name="Etoile Gorget +2", augments={'Path: A',}},
		waist="Gerdr Belt +1",
		left_ear="Dedition Earring",
		right_ear={ name="Macu. Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+19','Mag. Acc.+19','"Store TP"+7','DEX+13 AGI+13',}},
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
	sets.precast.Volte_Harness = set_combine(sets.precast.Wing, {body="Volte Harness"})
	sets.precast.Prishes_Boots = set_combine(sets.precast.Wing, {feet="Prishe\'s Boots +1",})


    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Maculele Tiara +2",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Etoile Gorget +2", augments={'Path: A',}},
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear="Sherida Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Ephramad's Ring",
		right_ring="Regal Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
		
    sets.precast.WS.ATKCAP = {
		ammo="Crepuscular Pebble",
		head="Maculele Tiara +2",
		body={ name="Gleti's Cuirass", augments={'Path: A',}},
		hands={ name="Gleti's Gauntlets", augments={'Path: A',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Etoile Gorget +2", augments={'Path: A',}},
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear={ name="Macu. Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+19','Mag. Acc.+19','"Store TP"+7','DEX+13 AGI+13',}},
		left_ring="Ephramad's Ring",
		right_ring="Regal Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS.FullTPMagical = {left_ear="Ishvara Earring",}
	sets.precast.WS.FullTPPhysical = {left_ear="Sherida Earring",}

	sets.precast.WS['Rudra\'s Storm'] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Maculele Tiara +2",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Maxixi Bangles +4",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Etoile Gorget +2", augments={'Path: A',}},
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear={ name="Macu. Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+19','Mag. Acc.+19','"Store TP"+7','DEX+13 AGI+13',}},
		left_ring="Epaminondas's Ring",
		right_ring="Ephramad's Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Rudra\'s Storm'].ATKCAP = {
        ammo="Crepuscular Pebble",
        head="Maculele Tiara +2",
		body={ name="Gleti's Cuirass", augments={'Path: A',}},
		hands="Maxixi Bangles +4",
		legs="Maculele Tights +2",
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Etoile Gorget +2", augments={'Path: A',}},
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear={ name="Macu. Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+19','Mag. Acc.+19','"Store TP"+7','DEX+13 AGI+13',}},
        left_ring="Epaminondas's Ring",
        right_ring="Ephramad's Ring",
        back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Ruthless Stroke'] = {
		ammo="C. Palug Stone",
		head="Maculele Tiara +2",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Maxixi Bangles +4",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Etoile Gorget +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear={ name="Macu. Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+19','Mag. Acc.+19','"Store TP"+7','DEX+13 AGI+13',}},
		left_ring="Epaminondas's Ring",
		right_ring="Ephramad's Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Ruthless Stroke'].ATKCAP = {
		ammo="Crepuscular Pebble",
		head="Maculele Tiara +2",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Maxixi Bangles +4",
		legs="Maculele Tights +2",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Etoile Gorget +2", augments={'Path: A',}},
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear={ name="Macu. Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+19','Mag. Acc.+19','"Store TP"+7','DEX+13 AGI+13',}},
		left_ring="Epaminondas's Ring",
		right_ring="Ephramad's Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
	
	sets.precast.WS['Pyrrhic Kleos'] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Maculele Tiara +2",
		body="Macu. Casaque +2",
		hands="Macu. Bangles +2",
		legs={ name="Gleti's Breeches", augments={'Path: A',}},
		feet="Macu. Toe Sh. +2",
		neck={ name="Etoile Gorget +2", augments={'Path: A',}},
		waist="Fotia Belt",
		left_ear="Sherida Earring",
		right_ear={ name="Macu. Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+19','Mag. Acc.+19','"Store TP"+7','DEX+13 AGI+13',}},
		left_ring="Ephramad's Ring",
		right_ring="Regal Ring",
		back={ name="Senuna's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Pyrrhic Kleos'].ATKCAP = {
	    ammo="Crepuscular Pebble",
		head="Maculele Tiara +2",
		body={ name="Gleti's Cuirass", augments={'Path: A',}},
		hands="Macu. Bangles +2",
		legs={ name="Gleti's Breeches", augments={'Path: A',}},
		feet="Macu. Toe Sh. +2",
		neck={ name="Etoile Gorget +2", augments={'Path: A',}},
		waist="Fotia Belt",
		left_ear="Sherida Earring",
		right_ear={ name="Macu. Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+19','Mag. Acc.+19','"Store TP"+7','DEX+13 AGI+13',}},
		left_ring="Ephramad's Ring",
		right_ring="Regal Ring",
		back={ name="Senuna's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

    sets.precast.WS['Evisceration'] = {
	    ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body={ name="Gleti's Cuirass", augments={'Path: A',}},
		hands={ name="Gleti's Gauntlets", augments={'Path: A',}},
		legs={ name="Gleti's Breeches", augments={'Path: A',}},
		feet="Macu. Toe Sh. +2",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Odr Earring",
		right_ear={ name="Macu. Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+19','Mag. Acc.+19','"Store TP"+7','DEX+13 AGI+13',}},
		left_ring="Ephramad's Ring",
		right_ring="Regal Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}},}
	
	sets.precast.WS['Aeolian Edge'] = {
	    ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Sibyl Scarf",
		waist="Orpheus's Sash",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Friomisi Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Shiva Ring +1",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Asuran Fists'] = {
		ammo="Aurgelmir Orb +1",
		head="Maculele Tiara +2",
		body="Macu. Casaque +2",
		hands="Macu. Bangles +2",
		legs="Maculele Tights +2",
		feet="Macu. Toe Sh. +2",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Tuisto Earring",
		right_ear={ name="Macu. Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+19','Mag. Acc.+19','"Store TP"+7','DEX+13 AGI+13',}},
		left_ring="Sroda Ring",
		right_ring="Ephramad's Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
		
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.SpellInterrupt = {
        ring1="Evanescence Ring", --5
        }

    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt
	
	sets.midcast.RA = {
		range="Trollbane",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Iskur Gorget",
		waist="Eschan Stone",
		left_ear="Telos Earring",
		right_ear="Enervating Earring",
		left_ring="Ilabrat Ring",
		right_ring="Dingir Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}


    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.resting = {}

    sets.idle = {
		ammo="Staunch Tathlum +1",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Flume Belt +1",
		left_ear="Eabani Earring",
		right_ear="Sanare Earring",
		left_ring="Shneddick Ring",
		right_ring="Shadow Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
		}
		
	sets.idle.Aminon = {
	    ammo="Staunch Tathlum +1",
		head="Turms Cap +1",
		body={ name="Gleti's Cuirass", augments={'Path: A',}},
		hands="Regal Gloves",
		legs={ name="Gleti's Breeches", augments={'Path: A',}},
		feet={ name="Gleti's Boots", augments={'Path: A',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Flume Belt +1",
		left_ear="Sanare Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Defending Ring",
		right_ring="Roller's Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    sets.engaged = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Maculele Tiara +2",
		body="Malignance Tabard",
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs={ name="Gleti's Breeches", augments={'Path: A',}},
		feet="Macu. Toe Sh. +2",
		neck={ name="Etoile Gorget +2", augments={'Path: A',}},
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear="Sherida Earring",
		right_ear={ name="Macu. Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+19','Mag. Acc.+19','"Store TP"+7','DEX+13 AGI+13',}},
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back="Null Shawl",} 

    sets.engaged.Acc = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Maculele Tiara +2",
		body="Malignance Tabard",
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs={ name="Gleti's Breeches", augments={'Path: A',}},
		feet="Macu. Toe Sh. +2",
		neck={ name="Etoile Gorget +2", augments={'Path: A',}},
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear="Sherida Earring",
		right_ear={ name="Macu. Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+19','Mag. Acc.+19','"Store TP"+7','DEX+13 AGI+13',}},
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back="Null Shawl",} 

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Maculele Tiara +2",
		body="Malignance Tabard",
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs={ name="Gleti's Breeches", augments={'Path: A',}},
		feet="Macu. Toe Sh. +2",
		neck="Null Loop",
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear="Sherida Earring",
		right_ear={ name="Macu. Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+19','Mag. Acc.+19','"Store TP"+7','DEX+13 AGI+13',}},
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
		back="Null Shawl",}
		
	sets.engaged.Hybrid.Defense = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Maculele Tiara +2",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs={ name="Gleti's Breeches", augments={'Path: A',}},
		feet="Macu. Toe Sh. +2",
		neck={ name="Etoile Gorget +2", augments={'Path: A',}},
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear="Sherida Earring",
		right_ear={ name="Macu. Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+19','Mag. Acc.+19','"Store TP"+7','DEX+13 AGI+13',}},
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
		back="Null Shawl",}

    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
    sets.engaged.Acc.DT = set_combine(sets.engaged.Acc, sets.engaged.Hybrid)
    
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.buff.Doom = {
		neck="Nicander's Necklace",
        waist="Gishdubar Sash", --10
        }
		
	sets.Kiting = {left_ring="Shneddick Ring",}

    sets.CP = {back={ name="Mecisto. Mantle", augments={'Cap. Point+48%','CHR+3','Accuracy+2','DEF+10',}},}

	sets.TreasureHunter = {
		body="Volte Jupon",
		ammo="Per. Lucky Egg",
		waist="Chaac Belt",}


	
	sets.Mpu_Gandring = {main="Mpu Gandring",}
	
	sets.Twashtar = {main={ name="Twashtar", augments={'Path: A',}},}

	sets.Terpsichore = {}
	
	sets.Tauret = {main="Tauret",}
	
	sets.Karambit = {main="Karambit"}
	
	sets.Centovente = {sub="Fusetto +2",}

	sets.Gletis_Knife = {sub={ name="Gleti\'s Knife", augments={'Path: A',}},}
	
	sets.Crepuscular = {sub="Crepuscular Knife",}

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific Functions
-------------------------------------------------------------------------------------------------------------------

function job_post_precast(spell, action, spellMap, eventArgs)

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
	
		--Handles Sneak Attack / Trick Attack Weapon skills
    if spell.type == "WeaponSkill" then
        if state.Buff['Sneak Attack'] == true or state.Buff['Trick Attack'] == true then
			if spell.english == 'Rudra\'s Storm' then
				equip(sets.precast.WS.RudraSATA)
			end
			if spell.english == 'Mandalic Stab' then
				equip(sets.precast.WS.MandalicSATA)
			end
			if spell.english == 'Savage Blade' then
				equip(sets.precast.WS.SavageSATA)
			end
        end
    end
	
    if spell.type == "WeaponSkill" then
		if spell.english == "Exenterator" or spell.english == "Mercy Stroke" then
		else
			if state.TPBonus.value == true then
				if player.tp > 1900 then
					if spell.english == "Aeolian Edge" or spell.english == "Gust Slash" or spell.english == "Cyclone" then
						equip(sets.precast.WS.FullTPMagical)
					else
						equip(sets.precast.WS.FullTPPhysical)
					end
				end
			else
				if player.tp > 2900 then
					if spell.english == "Aeolian Edge" or spell.english == "Gust Slash" or spell.english == "Cyclone" then
						equip(sets.precast.WS.FullTPMagical)
					else
						equip(sets.precast.WS.FullTPPhysical)
					end
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

    if not midaction() then
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

	--Adjusts Melee/Weapon sets for Dual Wield or Single Wield
function update_combat_form()

	if state.WeaponSet.value == 'Mpu_Gandring' then
		equip(sets.Mpu_Gandring)
		if state.TPBonus.value == true then
			equip(sets.Centovente)
		else
			equip(sets[state.OffhandSet.current])
		end
	elseif state.WeaponSet.value == 'Twashtar' then
		equip(sets.Twashtar)
		if state.TPBonus.value == true then
			equip(sets.Centovente)
		else
			equip(sets[state.OffhandSet.current])
		end
	elseif state.WeaponSet.value == 'Terpsichore' then
		equip(sets.Terpsichore)
		if state.TPBonus.value == true then
			equip(sets.Centovente)
		else
			equip(sets[state.OffhandSet.current])
		end
	elseif state.WeaponSet.value == 'Tauret' then
		equip(sets.Tauret)
		if state.TPBonus.value == true then
			equip(sets.Centovente)
		else
			equip(sets[state.OffhandSet.current])
		end
	elseif state.WeaponSet.value == 'Karambit' then
		equip(sets.Karambit)
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

    local d_msg = 'None'
    if state.DefenseMode.value ~= 'None' then
        d_msg = state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
    end

    local i_msg = state.IdleMode.value

    local msg = ''
    if state.TreasureMode.value ~= 'None' then
        msg = msg .. ' TH: ' ..state.TreasureMode.value.. ' |'
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
end

	--Gear Info Functions
function job_self_command(cmdParams, eventArgs)
    gearinfo(cmdParams, eventArgs)
	
	if cmdParams[1]:lower() == 'step' then
        send_command('@input /ja "'..state.step.value..'" <t>')
	end
	
end

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

	--Auto Adjusts gear constantly if DW/Gearinfo is active
windower.register_event('zone change', 
    function()
        send_command('gi ugs true')
    end
)

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()

        set_macro_page(1, 17)
end

function set_lockstyle()
    send_command('wait 13; input /lockstyleset ' .. lockstyleset)
end