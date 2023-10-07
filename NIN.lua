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
--  Job Specific Keybinds (Ninja Binds)
-------------------------------------------------------------------------------------------------------------------
--
--	Modes:			[ Windows + M ]			Toggles Magic Burst Mode
--					[ Windows + B ]			Toggles TP Bonus Mode
--					[ Windows + 1 ]			Sets Weapon to Heishi
--					[ Windows + 2 ]			Sets Weapon to Gokotai
--					[ Windows + 3 ]			Sets Weapon to Naegling
--					[ Windows + 4 ]			Sets Weapon to Tauret
--					[ Windows + 5 ]			Sets Weapon to Kaja_Tachi
--					[ Windows + 6 ]			Sets Weapon to Hachimonji
--
--	Echo Binds:		[ CTRL + Numpad- ]		Shows main Weaponskill Binds in game
--					[ ALT + Numpad- ]		Shows Alternate Weaponskill Binds in game
--					[ Shift + Numpad- ]		Shows Item Binds in game
--					[ Windows + Numpad- ]	Shows Food/Weapon/Misc. Binds in game
--
--  Abilities:  	[ CTRL + ` ]        	Yonin
--					[ Alt + ` ]        		Innin
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
    state.Buff.Migawari = buffactive.migawari or false
    state.Buff.Yonin = buffactive.Yonin or false
    state.Buff.Innin = buffactive.Innin or false
    state.Buff.Sange = buffactive.Sange or false

    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
					"Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring", "Emporox's Ring"}

    include('Mote-TreasureHunter')

    -- For th_action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}

    lugra_ws = S{'Blade: Kamu', 'Blade: Shun', 'Blade: Ten'}

    lockstyleset = 16
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc')
    state.HybridMode:options('Normal', 'DT')
    state.WeaponskillMode:options('Normal', 'ATKCAP')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal')
	state.TreasureMode:options('Tag', 'None')
	state.WeaponSet = M{['description']='Weapon Set', 'Heishi', 'Gokotai', 'Naegling', 'Tauret', 'Kaja_Tachi', 'Hachimonji'}
    state.WeaponLock = M(false, 'Weapon Lock')
	state.MagicBurst = M(false, 'Magic_Burst')
	state.TPBonus = M(false, 'TP Bonus')

    state.CP = M(false, "Capacity Points Mode")

	--Includes Global Bind keys
	
	send_command('wait 1; exec Global-Binds.txt')
			
	--Ninja Binds
	
	send_command('wait 2; exec /NIN/NIN-Binds.txt')
	
	--Gear Retrieval Scripts
	
	send_command('wait 10; exec /NIN/NIN-Gear-Retrieval.txt')
	
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

	send_command('exec Global-UnBinds.txt')
	
	--Gear Removal Script
	
	send_command('exec /NIN/NIN-Gear-Removal.txt')
	
end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Enmity set
    sets.Enmity = {
		ammo="Sapience Orb",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Emet Harness +1", augments={'Path: A',}},
		hands="Kurys Gloves",
		legs={ name="Zoar Subligar +1", augments={'Path: A',}},
		feet="Ahosi Leggings",
		neck="Moonlight Necklace",
		waist="Kasiri Belt",
		left_ear="Cryptic Earring",
		right_ear="Friomisi Earring",
		left_ring="Eihwaz Ring",
		right_ring="Begrudging Ring",
		back={ name="Andartia's Mantle", augments={'HP+60','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10',}},}

    sets.precast.JA['Provoke'] = sets.Enmity
    sets.precast.JA['Mijin Gakure'] = {}

    sets.precast.Waltz = {
        ammo="Yamarang",
        waist="Gishdubar Sash",
        }

    sets.precast.Waltz['Healing Waltz'] = {}

    -- Fast cast sets for spells

    sets.precast.FC = {
		ammo="Sapience Orb",
		head={ name="Herculean Helm", augments={'Mag. Acc.+6','"Fast Cast"+6','INT+6','"Mag.Atk.Bns."+2',}},
		body={ name="Adhemar Jacket +1", augments={'HP+105','"Fast Cast"+10','Magic dmg. taken -4',}},
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
		feet={ name="Herculean Boots", augments={'"Fast Cast"+6','MND+5',}},
		neck="Orunmila's Torque",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Loquac. Earring",
		right_ear="Etiolation Earring",
		left_ring="Prolix Ring",
		right_ring="Kishar Ring",
		back={ name="Andartia's Mantle", augments={'HP+60','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10',}},}
		
    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
        body={ name="Mochi. Chainmail +3", augments={'Enhances "Sange" effect',}},
		neck="Magoraga Beads",
        })

    sets.precast.RA = {
	    range="Trollbane",
		head={ name="Taeon Chapeau", augments={'"Snapshot"+5','"Snapshot"+5',}},
		body={ name="Taeon Tabard", augments={'"Snapshot"+5','"Snapshot"+5',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Taeon Tights", augments={'"Snapshot"+4','"Snapshot"+5',}},
		feet={ name="Pursuer's Gaiters", augments={'Rng.Acc.+10','"Rapid Shot"+10','"Recycle"+15',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Yemaya Belt",
		left_ear="Genmei Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring="Defending Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------
	
    sets.precast.WS = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Hattori Kyahan +3",
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		left_ring="Regal Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
    sets.precast.WS.ATKCAP = {
		ammo="Crepuscular Pebble",
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Mpaca's Hose", augments={'Path: A',}},
		feet="Hattori Kyahan +3",
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear={ name="Hattori Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+13','Mag. Acc.+13','"Store TP"+4',}},
		left_ring="Sroda Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS.FullTPPhysical = {left_ear={ name="Lugra Earring +1", augments={'Path: A',}},right_ear={ name="Hattori Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+13','Mag. Acc.+13','"Store TP"+4',}},}
	sets.precast.WS.FullTPMagical = {left_ear={ name="Lugra Earring +1", augments={'Path: A',}},right_ear="Friomisi Earring",}

    sets.precast.WS['Blade: Hi'] = {
		ammo="Yetshila +1",
		head="Hachiya Hatsu. +3",
		body="Hattori Ningi +3",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Hattori Kyahan +3",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Gerdr Belt +1",
		left_ear="Odr Earring",
		right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		left_ring="Gere Ring",
		right_ring="Regal Ring",
		back={ name="Andartia's Mantle", augments={'AGI+20','Accuracy+20 Attack+20','AGI+10','Crit.hit rate+10',}},}
		
    sets.precast.WS['Blade: Hi'].ATKCAP = {
		ammo="Yetshila +1",
		head="Hachiya Hatsu. +3",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Mpaca's Hose", augments={'Path: A',}},
		feet="Hattori Kyahan +3",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Gerdr Belt +1",
		left_ear="Odr Earring",
		right_ear={ name="Hattori Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+13','Mag. Acc.+13','"Store TP"+4',}},
		left_ring="Sroda Ring",
		right_ring="Regal Ring",
		back={ name="Andartia's Mantle", augments={'AGI+20','Accuracy+20 Attack+20','AGI+10','Crit.hit rate+10',}},}

    sets.precast.WS['Blade: Ten'] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Hattori Kyahan +3",
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		left_ring="Regal Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
    sets.precast.WS['Blade: Ten'].ATKCAP = {
		ammo="Crepuscular Pebble",
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Hattori Kyahan +3",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear={ name="Hattori Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+13','Mag. Acc.+13','"Store TP"+4',}},
		left_ring="Sroda Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Savage Blade'] = {
		ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
		head="Mpaca's Cap",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Hattori Kyahan +3",
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		left_ring="Sroda Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Savage Blade'].ATKCAP = {
		ammo="Crepuscular Pebble",
		head="Mpaca's Cap",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Hattori Kyahan +3",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear={ name="Hattori Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+13','Mag. Acc.+13','"Store TP"+4',}},
		left_ring="Sroda Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
    sets.precast.WS['Blade: Shun'] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body="Hattori Ningi +3",
		hands="Hattori Tekko +3",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Hattori Kyahan +3",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		left_ring="Gere Ring",
		right_ring="Regal Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10',}},}
		
    sets.precast.WS['Blade: Shun'].ATKCAP = {
		ammo="Crepuscular Pebble",
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs={ name="Mpaca's Hose", augments={'Path: A',}},
		feet="Hattori Kyahan +3",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Fotia Belt",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear={ name="Hattori Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+13','Mag. Acc.+13','"Store TP"+4',}},
		left_ring="Gere Ring",
		right_ring="Regal Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10',}},}

    sets.precast.WS['Blade: Ku'] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Mochizuki Tekko +3", augments={'Enh. "Ninja Tool Expertise" effect',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Hattori Kyahan +3",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		right_ear={ name="Hattori Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+13','Mag. Acc.+13','"Store TP"+4',}},
		left_ring="Gere Ring",
		right_ring="Regal Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10',}},}
		
    sets.precast.WS['Blade: Ku'].ATKCAP = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Malignance Gloves",
		legs={ name="Mpaca's Hose", augments={'Path: A',}},
		feet="Hattori Kyahan +3",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Fotia Belt",
		left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		right_ear={ name="Hattori Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+13','Mag. Acc.+13','"Store TP"+4',}},
		left_ring="Gere Ring",
		right_ring="Sroda Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10',}},}

    sets.precast.WS['Blade: Kamu'] = {
		ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Fotia Gorget",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		right_ear={ name="Hattori Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+13','Mag. Acc.+13','"Store TP"+4',}},
		left_ring="Gere Ring",
		right_ring="Regal Ring",
		back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
    sets.precast.WS['Blade: Kamu'].ATKCAP = {
		ammo="Crepuscular Pebble",
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Mpaca's Hose", augments={'Path: A',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		right_ear={ name="Hattori Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+13','Mag. Acc.+13','"Store TP"+4',}},
		left_ring="Sroda Ring",
		right_ring="Regal Ring",
		back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

    sets.precast.WS['Blade: Chi'] = {
		ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
		head={ name="Mochi. Hatsuburi +3", augments={'Enhances "Yonin" and "Innin" effect',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Fotia Gorget",
		waist="Orpheus's Sash",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		left_ring="Gere Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Blade: Teki'] = sets.precast.WS['Blade: Chi']
    sets.precast.WS['Blade: To'] = sets.precast.WS['Blade: Chi']
	sets.precast.WS['Tachi: Jinpu'] = sets.precast.WS['Blade: Chi']
	sets.precast.WS['Tachi: Kagero'] = sets.precast.WS['Blade: Chi']
	sets.precast.WS['Tachi: Goten'] = sets.precast.WS['Blade: Chi']
	sets.precast.WS['Tachi: Koki'] = sets.precast.WS['Blade: Chi']	
		
	sets.precast.WS['Blade: Ei'] = {
		ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
		head="Pixie Hairpin +1",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Sibyl Scarf",
		waist="Orpheus's Sash",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Friomisi Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Archon Ring",
		back={ name="Andartia's Mantle", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Mag.Atk.Bns."+10',}},}

	sets.precast.WS['Sanguine Blade'] = sets.precast.WS['Blade: Ei']
		
	sets.precast.WS['Blade: Yu'] = {
		ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
		head={ name="Mochi. Hatsuburi +3", augments={'Enhances "Yonin" and "Innin" effect',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Friomisi Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Dingir Ring",
		back={ name="Andartia's Mantle", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Mag.Atk.Bns."+10',}},}
		
	sets.precast.WS['Aeolian Edge'] = sets.precast.WS['Blade: Yu']
		
	sets.precast.WS['Evisceration'] = {
		ammo="Yetshila +1",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body="Hattori Ningi +3",
		hands={ name="Ryuo Tekko +1", augments={'DEX+12','Accuracy+25','"Dbl.Atk."+4',}},
		legs={ name="Mpaca's Hose", augments={'Path: A',}},
		feet="Ken. Sune-Ate +1",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Fotia Belt",
		left_ear="Odr Earring",
		right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		left_ring="Gere Ring",
		right_ring="Regal Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}},}
		
	sets.precast.WS['Evisceration'].ATKCAP = {
		ammo="Yetshila +1",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body="Hattori Ningi +3",
		hands={ name="Ryuo Tekko +1", augments={'DEX+12','Accuracy+25','"Dbl.Atk."+4',}},
		legs={ name="Mpaca's Hose", augments={'Path: A',}},
		feet="Ken. Sune-Ate +1",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Odr Earring",
		right_ear={ name="Hattori Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+13','Mag. Acc.+13','"Store TP"+4',}},
		left_ring="Gere Ring",
		right_ring="Begrudging Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}},}
		
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.SpellInterrupt = {}

    -- Specific spells
    sets.midcast.Utsusemi = {
		ammo="Sapience Orb",
		head={ name="Herculean Helm", augments={'Mag. Acc.+6','"Fast Cast"+6','INT+6','"Mag.Atk.Bns."+2',}},
		body={ name="Adhemar Jacket +1", augments={'HP+105','"Fast Cast"+10','Magic dmg. taken -4',}},
		hands={ name="Mochizuki Tekko +3", augments={'Enh. "Ninja Tool Expertise" effect',}},
		legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
		feet="Hattori Kyahan +3",
		neck="Orunmila's Torque",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Loquac. Earring",
		right_ear="Etiolation Earring",
		left_ring="Kishar Ring",
		right_ring="Prolix Ring",
		back={ name="Andartia's Mantle", augments={'HP+60','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10',}},}
	
    sets.midcast.ElementalNinjutsu = {
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head={ name="Mochi. Hatsuburi +3", augments={'Enhances "Yonin" and "Innin" effect',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Mochi. Kyahan +3", augments={'Enh. Ninj. Mag. Acc/Cast Time Red.',}},
		neck="Sibyl Scarf",
		waist="Skrymir Cord +1",
		left_ear="Hecate's Earring",
		right_ear="Friomisi Earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Dingir Ring",
		back={ name="Andartia's Mantle", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Mag.Atk.Bns."+10',}},}
		
	sets.midcast.ElementalNinjutsu_MagicBurst = {
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head={ name="Mochi. Hatsuburi +3", augments={'Enhances "Yonin" and "Innin" effect',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Hattori Tekko +3",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Mochi. Kyahan +3", augments={'Enh. Ninj. Mag. Acc/Cast Time Red.',}},
		neck="Sibyl Scarf",
		waist="Skrymir Cord +1",
		left_ear="Hecate's Earring",
		right_ear="Friomisi Earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Mujin Band",
		back={ name="Andartia's Mantle", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Mag.Atk.Bns."+10',}},}
		
    sets.midcast.EnfeeblingNinjutsu = {
		ammo="Yamarang",
		head="Hachiya Hatsu. +3",
		body="Hattori Ningi +3",
		hands="Hattori Tekko +3",
		legs="Hattori Hakama +3",
		feet="Hachiya Kyahan +3",
		neck="Sanctity Necklace",
		waist="Eschan Stone",
		left_ear="Crep. Earring",
		right_ear={ name="Hattori Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+13','Mag. Acc.+13','"Store TP"+4',}},
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Stikini Ring +1",
		back={ name="Andartia's Mantle", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Mag.Atk.Bns."+10',}},}

    sets.midcast.EnhancingNinjutsu = {
		ammo="Yamarang",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Mochizuki Tekko +3", augments={'Enh. "Ninja Tool Expertise" effect',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Bathy Choker +1", augments={'Path: A',}},
		waist="Engraved Belt",
		left_ear="Infused Earring",
		right_ear="Eabani Earring",
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring="Vengeful Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
	sets.midcast['Migawari: Ichi'] = {
		ammo="Sapience Orb",
		head="Hachiya Hatsu. +3",
		body={ name="Adhemar Jacket +1", augments={'HP+105','"Fast Cast"+10','Magic dmg. taken -4',}},
		hands={ name="Mochizuki Tekko +3", augments={'Enh. "Ninja Tool Expertise" effect',}},
		legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
		feet={ name="Mochi. Kyahan +3", augments={'Enh. Ninj. Mag. Acc/Cast Time Red.',}},
		neck="Incanter's Torque",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Loquac. Earring",
		right_ear="Etiolation Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Andartia's Mantle", augments={'HP+60','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10',}},}

    sets.midcast.Stun = sets.midcast.EnfeeblingNinjutsu

    sets.midcast.RA = {
		range="Trollbane",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Bathy Choker +1", augments={'Path: A',}},
		waist="Engraved Belt",
		left_ear="Infused Earring",
		right_ear="Eabani Earring",
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring="Vengeful Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Resting sets
--    sets.resting = {}

    -- Idle sets
    sets.idle = {
		ammo="Yamarang",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Bathy Choker +1", augments={'Path: A',}},
		waist="Engraved Belt",
		left_ear="Infused Earring",
		right_ear="Eabani Earring",
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring="Vengeful Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- * NIN Native DW Trait: 35% DW

    -- No Magic Haste (74% DW to cap)
    sets.engaged = {
		ammo="Seki Shuriken",
		head={ name="Ryuo Somen +1", augments={'HP+65','"Store TP"+5','"Subtle Blow"+8',}},																--9%
		body={ name="Mochi. Chainmail +3", augments={'Enhances "Sange" effect',}},																		--9%
		hands="Malignance Gloves",
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Tatena. Sune. +1", augments={'Path: A',}},
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Reiki Yotai",																															--7%
		left_ear="Dedition Earring",
		right_ear="Eabani Earring",																														--4%
		left_ring="Gere Ring",
		right_ring="Chirich Ring +1",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},			--10%
        } --39%GDW + 35%JADW = 74%

    -- 15% Magic Haste (67% DW to cap)
    sets.engaged.LowHaste = {
		ammo="Seki Shuriken",
		head={ name="Ryuo Somen +1", augments={'HP+65','"Store TP"+5','"Subtle Blow"+8',}},																--9%
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},																	--6%
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Tatena. Sune. +1", augments={'Path: A',}},
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Reiki Yotai",																															--7%
		left_ear="Dedition Earring",
		right_ear="Telos Earring",
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},			--10%
        } --32%GDW + 35%JADW = 67%


    -- 30% Magic Haste (56% DW to cap)
    sets.engaged.MidHaste = {
		ammo="Seki Shuriken",
		head={ name="Ryuo Somen +1", augments={'HP+65','"Store TP"+5','"Subtle Blow"+8',}},																--9%
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},																	--6%
		hands="Malignance Gloves",
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Tatena. Sune. +1", augments={'Path: A',}},
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Reiki Yotai",																															--7%
		left_ear="Dedition Earring",
		right_ear="Telos Earring",
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
		} --22%GDW + 35%JADW = 57%


    -- 35% Magic Haste (51% DW to cap)
    sets.engaged.HighHaste = {
		ammo="Seki Shuriken",
		head={ name="Ryuo Somen +1", augments={'HP+65','"Store TP"+5','"Subtle Blow"+8',}},																--9%
		body={ name="Tatena. Harama. +1", augments={'Path: A',}},
		hands="Malignance Gloves",
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Tatena. Sune. +1", augments={'Path: A',}},
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Reiki Yotai",																															--7%
		left_ear="Dedition Earring",
		right_ear="Telos Earring",
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
        } --16%GDW + 35%JADW = 51%

    -- 45% Magic Haste (36% DW to cap)
    sets.engaged.MaxHaste = {
		ammo="Seki Shuriken",
		head="Malignance Chapeau",
		body={ name="Tatena. Harama. +1", augments={'Path: A',}},
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet="Malignance Boots",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Dedition Earring",
		right_ear="Telos Earring",
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
		} --0%GDW + 35%JADW = 35%%%

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
        }

    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)

    sets.engaged.DT.LowHaste = set_combine(sets.engaged.LowHaste, sets.engaged.Hybrid)

    sets.engaged.DT.MidHaste = set_combine(sets.engaged.MidHaste, sets.engaged.Hybrid)

    sets.engaged.DT.HighHaste = set_combine(sets.engaged.HighHaste, sets.engaged.Hybrid)

    sets.engaged.DT.MaxHaste = set_combine(sets.engaged.MaxHaste, sets.engaged.Hybrid)

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
	
	sets.NightMovement = {feet="Hachiya Kyahan +3"}
	sets.DayMovement = {right_ring="Shneddick Ring",}

    sets.buff.Migawari = {body="Hattori Ningi +3",}
    sets.buff.Sange = {ammo="Hachiya Shuriken"}

	sets.Heishi = {main={ name="Heishi Shorinken", augments={'Path: A',}},sub={ name="Kunimitsu", augments={'Path: A',}},}
	sets.Heishi_Hitaki = {main={ name="Heishi Shorinken", augments={'Path: A',}},sub={ name="Kunimitsu", augments={'Path: A',}},}
	sets.Gokotai = {main="Gokotai",sub={ name="Kunimitsu", augments={'Path: A',}},}
	sets.Gokotai_Hitaki = {main="Gokotai",sub={ name="Kunimitsu", augments={'Path: A',}},}
	sets.Naegling = {main="Naegling",sub="Kunimitsu",}
	sets.Naegling_Hitaki = {main="Naegling",sub="Kunimitsu",}
	sets.Tauret = {main="Tauret",sub={ name="Gleti's Knife", augments={'Path: A',}},}
	sets.Hachimonji = {main="Hachimonji",sub={ name="Rigorous Grip +1", augments={'Path: A',}},}
	sets.Kaja_Tachi = {main="Kaja Tachi",sub={ name="Rigorous Grip +1", augments={'Path: A',}},}

    sets.buff.Doom = {
		neck="Nicander's Necklace",
        waist="Gishdubar Sash", --10
        }
		
	sets.Obi = {waist="Hachirin-no-Obi"}

    sets.CP = {neck={ name="Ninja Nodowa +2", augments={'Path: A',}},}
    
    sets.TreasureHunter = {
		ammo="Per. Lucky Egg", --TH1
		body="Volte Jupon",		--TH2
		waist="Chaac Belt",} --TH+1


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

    if spell.type == "WeaponSkill" then
		if spell.english == "Blade: Hi" or spell.english == "Blade: Ku" or spell.english == "Blade: Kamu" or spell.english == "Sanguine Blade" or spell.english == "Evisceration" then
		else
			if state.WeaponSet.value == "Heishi" then
				if state.TPBonus.value == true then
					if player.tp > 1400 then
						if spell.english == "Blade: Chi" or spell.english == "Blade: Teki" or spell.english == "Blade: To" or spell.english == "Blade: Ei" or spell.english == "Blade: Yu" or 
							spell.english == "Tachi: Jinpu" or spell.english == "Tachi: Kagero" or spell.english == "Tachi: Goten" or spell.english == "Tachi: Koki" or spell.english == "Aeolian Edge" then
								equip(sets.precast.WS.FullTPMagical)
						else
							equip(sets.precast.WS.FullTPPhysical)
						end
					end
				else
					if player.tp > 2400 then
						if spell.english == "Blade: Chi" or spell.english == "Blade: Teki" or spell.english == "Blade: To" or spell.english == "Blade: Ei" or spell.english == "Blade: Yu" or 
							spell.english == "Tachi: Jinpu" or spell.english == "Tachi: Kagero" or spell.english == "Tachi: Goten" or spell.english == "Tachi: Koki" or spell.english == "Aeolian Edge" then
								equip(sets.precast.WS.FullTPMagical)
						else
							equip(sets.precast.WS.FullTPPhysical)
						end
					end
				end
			end
			if state.WeaponSet.value == "Gokotai" or state.WeaponSet.value == "Naegling" or state.WeaponSet.value == "Gletis_Knife" then
				if state.TPBonus.value == true then
					if player.tp > 1900 then
						if spell.english == "Blade: Chi" or spell.english == "Blade: Teki" or spell.english == "Blade: To" or spell.english == "Blade: Ei" or spell.english == "Blade: Yu" or 
							spell.english == "Tachi: Jinpu" or spell.english == "Tachi: Kagero" or spell.english == "Tachi: Goten" or spell.english == "Tachi: Koki" or spell.english == "Aeolian Edge" then
								equip(sets.precast.WS.FullTPMagical)
						else
							equip(sets.precast.WS.FullTPPhysical)
						end
					end
				else
					if player.tp > 2900 then
						if spell.english == "Blade: Chi" or spell.english == "Blade: Teki" or spell.english == "Blade: To" or spell.english == "Blade: Ei" or spell.english == "Blade: Yu" or 
							spell.english == "Tachi: Jinpu" or spell.english == "Tachi: Kagero" or spell.english == "Tachi: Goten" or spell.english == "Tachi: Koki" or spell.english == "Aeolian Edge" then
								equip(sets.precast.WS.FullTPMagical)
						else
							equip(sets.precast.WS.FullTPPhysical)
						end
					end
				end
			end
			if state.WeaponSet.value == "Kaja_Tachi" or state.WeaponSet.value == "Hachimonji" then
				if player.tp > 2900 then
					if spell.english == "Blade: Chi" or spell.english == "Blade: Teki" or spell.english == "Blade: To" or spell.english == "Blade: Ei" or spell.english == "Blade: Yu" or 
						spell.english == "Tachi: Jinpu" or spell.english == "Tachi: Kagero" or spell.english == "Tachi: Goten" or spell.english == "Tachi: Koki" or spell.english == "Aeolian Edge" then
							equip(sets.precast.WS.FullTPMagical)
					else
						equip(sets.precast.WS.FullTPPhysical)
					end
				end
			end
		end
	end
end

function job_post_midcast(spell, action, spellMap, eventArgs)

		--Handles Elemental Ninjutsu Events
    if spellMap == 'ElementalNinjutsu' then
        if (spell.element == world.day_element or spell.element == world.weather_element) and spell.target.distance > (8 + spell.target.model_size) then
            equip(sets.Obi)
		elseif spell.target.distance < (8 + spell.target.model_size) then
            equip({waist="Orpheus's Sash"})
        end
		
        if state.Buff.Futae then
            equip(sets.precast.JA['Futae'])
        end

		if state.MagicBurst.value == true then
			equip(sets.midcast.ElementalNinjutsu_MagicBurst)
		end
    end
	
end

function job_aftercast(spell, action, spellMap, eventArgs)

    if not spell.interrupted and spell.english == "Migawari: Ichi" then
        state.Buff.Migawari = true
    end

end

function job_buff_change(buff, gain)

    if buff == "Migawari" and not gain then
        add_to_chat(61, "*** MIGAWARI DOWN ***")
    end

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
    determine_haste_group()
    check_moving()
end

function job_update(cmdParams, eventArgs)
    handle_equipping_gear(player.status)
	Weaponskill_Keybinds()
end

function update_combat_form()

    if DW == true then
        state.CombatForm:set('DW')
    elseif DW == false then
        state.CombatForm:reset()
    end

	if state.WeaponLock.value == true then
		disable('main','sub')
	else
        enable('main','sub')
    end

	if state.WeaponSet.value == 'Heishi' then
		if state.TPBonus.value == true then
			equip(sets.Heishi_Hitaki)
		else
			equip(sets.Heishi)
		end	
	end
	
	if state.WeaponSet.value == 'Gokotai' then
		if state.TPBonus.value == true then
			equip(sets.Gokotai_Hitaki)
		else
			equip(sets.Gokotai)
		end
	end

	if state.WeaponSet.value == 'Naegling' then
		if state.TPBonus.value == true then
			equip(sets.Naegling_Hitaki)
		else
			equip(sets.Naegling)
		end
	end
	
	if state.WeaponSet.value == 'Tauret' then
		equip(sets.Tauret)
	end
	
	if state.WeaponSet.value == 'Kaja_Tachi' then
		equip(sets.Kaja_Tachi)
	end
	
	if state.WeaponSet.value == 'Hachimonji' then
		equip(sets.Hachimonji)
	end
	
end

function Weaponskill_Keybinds()

	if state.WeaponSet.value == 'Heishi' or state.WeaponSet.value == 'Gokotai' then
		send_command([[bind ^numpad- 
			input /echo -----Abilities-----;
			input /echo [ CTRL + ` ] Yonin;
			input /echo -----Katana-----;
			input /echo [ CTRL + Numpad1 ] Blade: Shun;
			input /echo [ CTRL + Numpad2 ] Blade: Ten;
			input /echo [ CTRL + Numpad3 ] Blade: Hi;
			input /echo [ CTRL + Numpad4 ] Blade: Kamu;
			input /echo [ CTRL + Numpad5 ] Blade: Ku;
			input /echo [ CTRL + Numpad6 ] Blade: Jin;
			input /echo [ CTRL + Numpad7 ] Blade: Rin;
			input /echo [ CTRL + Numpad9 ] Blade: Retsu;]])
		send_command('bind ^numpad1 input /ws "Blade: Shun" <t>')
		send_command('bind ^numpad2 input /ws "Blade: Ten" <t>')
		send_command('bind ^numpad3 input /ws "Blade: Hi" <t>')
		send_command('bind ^numpad4 input /ws "Blade: Kamu" <t>')
		send_command('bind ^numpad5 input /ws "Blade: Ku" <t>')
		send_command('bind ^numpad6 input /ws "Blade: Jin" <t>')
		send_command('bind ^numpad7 input /ws "Blade: Rin" <t>')
		send_command('bind ^numpad9 input /ws "Blade: Retsu" <t>')

		send_command([[bind !numpad- 
			input /echo -----Abilities-----;
			input /echo [ ALT + ` ] Innin;
			input /echo -----Katana-----;
			input /echo [ ALT + Numpad1 ] Blade: Chi;
			input /echo [ ALT + Numpad2 ] Blade: To;
			input /echo [ ALT + Numpad3 ] Blade: Teki;
			input /echo [ ALT + Numpad4 ] Blade: Ei;
			input /echo [ ALT + Numpad5 ] Blade: Yu;]])
		send_command('bind !numpad1 input /ws "Blade: Chi" <t>')
		send_command('bind !numpad2 input /ws "Blade: To" <t>')
		send_command('bind !numpad3 input /ws "Blade: Teki" <t>')
		send_command('bind !numpad4 input /ws "Blade: Ei" <t>')
		send_command('bind !numpad5 input /ws "Blade: Yu" <t>')

	elseif state.WeaponSet.value == 'Hachimonji' or state.WeaponSet.value == 'Kaja_Tachi' then
		send_command([[bind ^numpad- 
			input /echo -----Abilities-----;
			input /echo [ CTRL + ` ] Yonin;
			input /echo -----Great_Katana-----;
			input /echo [ CTRL + Numpad1 ] Tachi: Jinpu;
			input /echo [ CTRL + Numpad2 ] Tachi: Kagero;
			input /echo [ CTRL + Numpad3 ] Tachi: Goten;
			input /echo [ CTRL + Numpad4 ] Tachi: Ageha;
			input /echo [ CTRL + Numpad5 ] Tachi: Koki;
			input /echo [ CTRL + Numpad6 ] Tachi: Kasha;
			input /echo [ CTRL + Numpad7 ] Tachi: Enpi;
			input /echo [ CTRL + Numpad. ] Tachi: Hobaku;]])
		send_command('bind ^numpad1 input /ws "Tachi: Jinpu" <t>')
		send_command('bind ^numpad2 input /ws "Tachi: Kagero" <t>')
		send_command('bind ^numpad3 input /ws "Tachi: Goten" <t>')
		send_command('bind ^numpad4 input /ws "Tachi: Ageha" <t>')
		send_command('bind ^numpad5 input /ws "Tachi: Koki" <t>')
		send_command('bind ^numpad6 input /ws "Tachi: Kasha" <t>')
		send_command('bind ^numpad7 input /ws "Tachi: Enpi" <t>')
		send_command('bind ^numpad. input /ws "Tachi: Hobaku" <t>')
		
		send_command([[bind !numpad- 
			input /echo -----Abilities-----;
			input /echo [ ALT + ` ] Innin;]])
			
	elseif state.WeaponSet.value == 'Naegling'  then
		send_command([[bind ^numpad- 
			input /echo -----Abilities-----;
			input /echo [ CTRL + ` ] Yonin;
			input /echo -----Sword-----;
			input /echo [ CTRL + Numpad1 ] Sanguine Blade;
			input /echo [ CTRL + Numpad2 ] Seraph Blade;
			input /echo [ CTRL + Numpad3 ] Red Lotus Blade;
			input /echo [ CTRL + Numpad4 ] Savage Blade;
			input /echo [ CTRL + Numpad5 ] Burning Blade;
			input /echo [ CTRL + Numpad6 ] Shining Blade;
			input /echo [ CTRL + Numpad9 ] Vorpal Blade;
			input /echo [ CTRL + Numpad. ] Flat Blade;]])
		send_command('bind ^numpad1 input /ws "Sanguine Blade" <t>')
		send_command('bind ^numpad2 input /ws "Seraph Blade" <t>')
		send_command('bind ^numpad3 input /ws "Red Lotus Blade" <t>')
		send_command('bind ^numpad4 input /ws "Savage Blade" <t>')
		send_command('bind ^numpad5 input /ws "Burning Blade" <t>')
		send_command('bind ^numpad6 input /ws "Shining Blade" <t>')
		send_command('bind ^numpad7 input /ws "" <t>')
		send_command('bind ^numpad9 input /ws "Vorpal Blade" <t>')
		send_command('bind ^numpad. input /ws "Flat Blade" <t>')
		
		send_command([[bind !numpad- 
			input /echo -----Abilities-----;
			input /echo [ ALT + ` ] Innin;
			input /echo -----Sword-----;
			input /echo [ ALT + Numpad1 ]  Fast Blade;
			input /echo [ ALT + Numpad2 ]  Spirits Within;
			input /echo [ ALT + Numpad3 ]  Circle Blade;]])
		send_command('bind !numpad1 input /ws "Fast Blade" <t>')
		send_command('bind !numpad2 input /ws "Spirits Within" <t>')
		send_command('bind !numpad3 input /ws "Circle Blade" <t>')
		
	elseif state.WeaponSet.value == 'Tauret' then
		send_command([[bind ^numpad- 
			input /echo -----Abilities-----;
			input /echo [ CTRL + ` ] Yonin;	
			input /echo -----Dagger-----;
			input /echo [ CTRL + Numpad1 ] Evisceration;
			input /echo [ CTRL + Numpad2 ] Viper Bite;
			input /echo [ CTRL + Numpad3 ] Exenterator;
			input /echo [ CTRL + Numpad4 ] Aeolian Edge;
			input /echo [ CTRL + Numpad5 ] Cyclone;
			input /echo [ CTRL + Numpad6 ] Gust Slash;
			input /echo [ CTRL + Numpad9 ] Wasp Sting;
			input /echo [ CTRL + Numpad. ] Shadowstitch;]])
		send_command('bind ^numpad1 input /ws "Evisceration" <t>')
		send_command('bind ^numpad2 input /ws "Viper Bite" <t>')
		send_command('bind ^numpad3 input /ws "Exenterator" <t>')
		send_command('bind ^numpad4 input /ws "Aeolian Edge" <t>')
		send_command('bind ^numpad5 input /ws "Cyclone" <t>')
		send_command('bind ^numpad6 input /ws "Gust Slash" <t>')
		send_command('bind ^numpad9 input /ws "Wasp Sting" <t>')
		send_command('bind ^numpad. input /ws "Shadowstitch" <t>')
		
		send_command([[bind !numpad- 
			input /echo -----Abilities-----;
			input /echo [ ALT + ` ] Innin;
			input /echo -----Dagger-----;
			input /echo [ ALT + Numpad1 ]  Energy Steal;
			input /echo [ ALT + Numpad2 ]  Energy Drain;]])
		send_command('bind !numpad1 input /ws "Energy Steal" <t>')
		send_command('bind !numpad2 input /ws "Energy Drain" <t>')
	end
	
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)


    if state.Buff.Migawari then
       idleSet = set_combine(idleSet, sets.buff.Migawari)
    end

		--Allows CP back to stay on if toggled on
    if state.CP.current == 'on' then
        equip(sets.CP)
        disable('neck')
    else
        enable('neck')
    end
	
    if state.Auto_Kite.value == true then
        if world.time >= (17*60) or world.time <= (7*60) then
            idleSet = set_combine(idleSet, sets.NightMovement)
        else
            idleSet = set_combine(idleSet, sets.DayMovement)
        end
    end

    return idleSet
end


-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)

    if state.Buff.Migawari then
        meleeSet = set_combine(meleeSet, sets.buff.Migawari)
    end
 
	if state.Buff.Sange then
        meleeSet = set_combine(meleeSet, sets.buff.Sange)
    end

    return meleeSet


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

    local i_msg = state.IdleMode.value

	local th_msg = state.TreasureMode.value
	
    local mb_msg = ''
	if state.MagicBurst.value == true then
        mb_msg = mb_msg .. 'On'
	else
		mb_msg = mb_msg .. 'Off'
    end

    local msg = ''
	
    if state.Kiting.value then
        msg = msg .. ' Kiting: On |'
    end

    add_to_chat(002, '| ' ..string.char(31,210).. 'Melee' ..cf_msg.. ': ' ..string.char(31,001)..m_msg.. string.char(31,002)..  ' |'
        ..string.char(31,207).. ' WS: ' ..string.char(31,001)..ws_msg.. string.char(31,002)..  ' |'
        ..string.char(31,060).. ' Magic: ' ..string.char(31,001)..c_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
        ..string.char(31,85).. ' TH: ' ..string.char(31,85)..th_msg.. string.char(31,002)..  ' |'
        ..string.char(31,85).. ' Burst: ' ..string.char(31,85)..mb_msg.. string.char(31,002)..  ' |'		
		..string.char(31,002)..msg)


    eventArgs.handled = true
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function check_moving()
    if state.DefenseMode.value == 'None'  and state.Kiting.value == false then
        if state.Auto_Kite.value == false and moving then
            state.Auto_Kite:set(true)
        elseif state.Auto_Kite.value == true and moving == false then
            state.Auto_Kite:set(false)
        end
    end
end

	--Determines Haste Group / Melee set for Gear Info
function determine_haste_group()
    classes.CustomMeleeGroups:clear()
    if DW == true then
        if DW_needed <= 1 then
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif DW_needed > 1 and DW_needed <= 16 then
            classes.CustomMeleeGroups:append('HighHaste')
        elseif DW_needed > 16 and DW_needed <= 21 then
            classes.CustomMeleeGroups:append('MidHaste')
        elseif DW_needed > 21 and DW_needed <= 34 then
            classes.CustomMeleeGroups:append('LowHaste')
        elseif DW_needed > 34 then
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

-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.
function th_action_check(category, param)
    if category == 2 or -- any ranged attack
        --category == 4 or -- any magic action
        (category == 3 and param == 30) or -- Aeolian Edge
        (category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
        (category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
        then return true
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
        set_macro_page(1, 5)

end

function set_lockstyle()
    send_command('wait 5; input /lockstyleset ' .. lockstyleset)
end