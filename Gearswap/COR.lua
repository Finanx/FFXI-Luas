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
--  				[ Windows + R ]         Locks Range Weapon
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
--  Job Specific Keybinds (Corsair Binds)
-------------------------------------------------------------------------------------------------------------------
--
--  Weapons:    	[ Windows + 1 ]			Naegling Weapon Set
--					[ Windows + 2 ]			RostamA Weapon Set
--					[ Windows + 3 ]			RostamC Weapon Set
--
--	Range Weapons:	[ Windows + 6 ]			TP Gun Range Set
--					[ Windows + 7 ]			Earp Range Set
--					[ Windows + 8 ]			Armageddon Range Set
--					[ Windows + 9 ]			Fomalhaut Range Set
--					[ Windows + 0 ]			Death Penalty Range Set
--
--	Echo Binds:		[ CTRL + Numpad- ]		Shows main Weaponskill Binds in game
--					[ ALT + Numpad- ]		Shows Alternate Weaponskill Binds in game
--					[ Shift + Numpad- ]		Shows Item Binds in game
--					[ Windows + Numpad- ]	Shows Food/Weapon/Misc. Binds in game
--
-- Luzaf Ring:     	[ CTRL + ` ]     		Toggle use of Luzaf Ring.
--
-- Item Binds:		[ Windows + Numpad9 ]	Trump Card Case
--					[ CTRL + Numpad. ]		Chrono Bullet Pouch
--					[ ALT + Numpad. ]		Devastating Bullet Pouch
--					[ Windows + Numpad. ]	Living Bullet Pouch
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
					"Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring", "Emporox's Ring",}

    -- Whether to use Luzaf's Ring
    state.LuzafRing = M(true, "Luzaf's Ring")
	
    -- Whether a warning has been given for low ammo
    state.warned = M(false)

	include('Mote-TreasureHunter')

    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}

    define_roll_values()

    lockstyleset = 16
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc')
    state.HybridMode:options('Normal', 'DT', 'Defense')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'Acc', 'ATKCAP')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'Aminon')
	state.TreasureMode:options('Tag', 'None')
	state.WeaponSet = M{['description']='Weapon Set', 'Naegling', 'Onion', 'RostamA', 'RostamC'}
	state.RangeSet = M{['description']='Range Set', 'Fomalhaut', 'Armageddon', 'DeathPenalty', 'Earp', 'TP_Gun'}
	state.Quickdraw = M{['description']='Quickdraw', 'Fire', 'Ice', 'Earth', 'Wind', 'Thunder', 'Water'}
	state.CorsairShot = M{['description']='Corsair_Shot', 'Store_TP', 'Damage'}


    state.CP = M(false, "Capacity Points Mode")
	state.RangeLock = M(false, 'Range Lock')

	gear.RAbullet = "Chrono Bullet"
	gear.WSbullet = "Chrono Bullet"
	gear.MeleeWSbullet = "Chrono Bullet"
	gear.Accbullet = "Chrono Bullet"
    gear.MAbullet = "Chrono Bullet"
    gear.QDbullet = "Chrono Bullet"
    options.ammo_warning_limit = 10
	
	--Includes Global Bind keys
	
	send_command('wait 2; exec Global-Binds.txt')
	
	--Corsair Binds
	
	send_command('wait 2; exec /COR/COR-Binds.txt')
	
	--Corsair Gear Retrieval
	
	send_command('wait 10; exec /COR/COR-Gear-Retrieval.txt')
	
	--[[		Remove the comments for this if you want basic key binds and dont want to use mine and delete all my Scripts
	
	--Global Corsair binds (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)

	send_command('bind @u gi ugs')
	send_command('bind @d lua u dressup; wait 10; lua l dressup')
	send_command('bind @r gs c toggle RangeLock')
	send_command('bind ^` gs c toggle LuzafRing')
	send_command('bind @t gs c cycle TreasureMode')
	send_command('bind ^= gs c cycle Quickdraw')
	send_command('bind ^- gs c cycleback Quickdraw')
	send_command('bind ^space tc nearest')
	
	send_command('bind @1 gs c set WeaponSet Naegling')
	send_command('bind @2 gs c set WeaponSet RostamA')
	send_command('bind @3 gs c set WeaponSet RostamC')
	
	send_command('bind @6 gs c set RangeLock false; gs c set RangeSet TP_Gun')
	send_command('bind @7 gs c set RangeLock false; gs c set RangeSet Earp')
	send_command('bind @8 gs c set RangeLock false; gs c set RangeSet Armageddon')
	send_command('bind @9 gs c set RangeLock false; gs c set RangeSet Fomalhaut')
	send_command('bind @0 gs c set RangeLock false; gs c set RangeSet DeathPenalty')
	
	send_command('wait 3; lua l gearinfo;')
	send_command('wait 17; lua l Dressup;')
	
	]]
		
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
	
	--Gear Removal Script
	
	send_command('wait 1; exec /COR/COR-Gear-Removal.txt')
	
	--[[		Remove the comments for this if you want basic key binds and dont want to use mine and delete all my Scripts
	
	send_command('unbind @u')
	send_command('unbind @d')
	send_command('unbind @r')
	send_command('unbind ^`')
	send_command('unbind @t')
	send_command('unbind ^=')
	send_command('unbind ^-')
	send_command('unbind ^space')
	
	send_command('unbind @1')
	send_command('unbind @2')
	send_command('unbind @3')
	
	send_command('unbind @6')
	send_command('unbind @7')
	send_command('unbind @8')
	send_command('unbind @9')
	send_command('unbind @0')
	
	send_command('wait 1; lua u gearinfo')
	send_command('wait 1; lua u Dressup')
	
	]]
	
end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.JA['Snake Eye'] = {legs="Lanun Trews +3"}
    sets.precast.JA['Wild Card'] = {feet="Lanun Bottes +4"}
    sets.precast.JA['Random Deal'] = {body="Lanun Frac +4"}


    sets.precast.CorsairRoll = {
		main={ name="Rostam", augments={'Path: C',}},
		range="Compensator",
		head={ name="Lanun Tricorne +3", augments={'Enhances "Winning Streak" effect',}},
		body="Chasseur's Frac +3",
		hands="Chasseur's Gants +3",
		legs={ name="Desultor Tassets", augments={'"Phantom Roll" ability delay -5','Movement speed +8%+2',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Regal Necklace",
		waist="Flume Belt +1",
		left_ear="Genmei Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring="Defending Ring",
		back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},}

    sets.precast.LuzafRing = set_combine(sets.precast.CorsairRoll, {left_ring="Luzaf's Ring",})

	sets.precast.CorsairRoll["Blitzer's Roll"] = set_combine(sets.precast.CorsairRoll, {head="Chass. Tricorne +3",})
    sets.precast.CorsairRoll["Tactician's Roll"] = set_combine(sets.precast.CorsairRoll, {body="Chasseur's Frac +3"})
    sets.precast.CorsairRoll["Allies' Roll"] = set_combine(sets.precast.CorsairRoll, {hands="Chasseur's Gants +3"})
	sets.precast.CorsairRoll["Caster's Roll"] = set_combine(sets.precast.CorsairRoll, {legs="Chas. Culottes +3",})
	sets.precast.CorsairRoll["Courser's Roll"] = set_combine(sets.precast.CorsairRoll, {feet="Chass. Bottes +2",})

    sets.precast.FoldDoubleBust = {hands="Lanun Gants +3"}

    sets.precast.Waltz = set_combine(sets.idle, {legs="Dashing Subligar",ring1="Asklepian Ring",waist="Gishdubar Sash",})

    sets.precast.Waltz['Healing Waltz'] = set_combine(sets.idle, {legs="Dashing Subligar",})

    sets.precast.FC = {
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body={ name="Adhemar Jacket +1", augments={'HP+105','"Fast Cast"+10','Magic dmg. taken -4',}},
		hands={ name="Leyline Gloves", augments={'Accuracy+5','"Mag.Atk.Bns."+7','"Fast Cast"+1',}},
		legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
		feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
		neck="Voltsurge Torque",
		waist="Flume Belt +1",
		left_ear="Loquac. Earring",
		right_ear="Etiolation Earring",
		left_ring="Kishar Ring",
		right_ring="Prolix Ring",
		back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},}

    -- (10% Snapshot from JP Gifts)
		
	sets.precast.RA = {
		head="Chass. Tricorne +3",
		body="Oshosi Vest +1",
		hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
		legs={ name="Adhemar Kecks +1", augments={'AGI+12','"Rapid Shot"+13','Enmity-6',}},
		feet="Meg. Jam. +2",
		neck={ name="Comm. Charm +2", augments={'Path: A',}},
		waist="Impulse Belt",
		left_ear="Genmei Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Crepuscular Ring",
		right_ring="Defending Ring",
		back={ name="Camulus's Mantle", augments={'INT+20','Eva.+20 /Mag. Eva.+20','"Snapshot"+10',}},}
		--10% JP + 64% Gear SS / 30% Job Trait + 42% Gear RS
		--74% SS 64% RS

	sets.precast.RA.Flurry1 = {
		head="Chass. Tricorne +3",
		body="Laksa. Frac +3",
		hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
		legs={ name="Adhemar Kecks +1", augments={'AGI+12','"Rapid Shot"+13','Enmity-6',}},
		feet="Meg. Jam. +2",
		neck={ name="Comm. Charm +2", augments={'Path: A',}},
		waist="Yemaya Belt",
		left_ear="Genmei Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Crepuscular Ring",
		right_ring="Defending Ring",
		back={ name="Camulus's Mantle", augments={'INT+20','Eva.+20 /Mag. Eva.+20','"Snapshot"+10',}},}
		--10% JP + 15% Flurry1 + 45% Gear SS / 30% Job Trait + 67% Gear RS
		--70% SS 97% RS

	sets.precast.RA.Flurry2 = {
		head="Chass. Tricorne +3",
		body="Laksa. Frac +3",
		hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
		legs={ name="Adhemar Kecks +1", augments={'AGI+12','"Rapid Shot"+13','Enmity-6',}},
		feet={ name="Pursuer's Gaiters", augments={'Rng.Acc.+10','"Rapid Shot"+10','"Recycle"+15',}},
		neck={ name="Comm. Charm +2", augments={'Path: A',}},
		waist="Yemaya Belt",
		left_ear="Genmei Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring="Defending Ring",
		back={ name="Camulus's Mantle", augments={'INT+20','Eva.+20 /Mag. Eva.+20','"Snapshot"+10',}},}
		--10% JP + 30% Flurry1 + 32% Gear SS / 30% Job Trait + 77% Gear RS
		--72% SS 107% RS
	
    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

		--Ranged Weaponskill Sets

    sets.precast.WS = {
		ammo=gear.WSbullet,
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Ikenga's Vest", augments={'Path: A',}},
		hands="Chasseur's Gants +3",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Lanun Bottes +4", augments={'Enhances "Wild Card" effect',}},
		neck={ name="Comm. Charm +2", augments={'Path: A',}},
		waist="Yemaya Belt",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Regal Ring",
		right_ring="Ephramad's Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS.FullTP = {left_ear="Telos Earring",}
	
	sets.precast.WS.Acc = {
		ammo=gear.Accbullet,
		head="Chass. Tricorne +3",
		body="Chasseur's Frac +3",
		hands="Chasseur's Gants +3",
		legs="Chas. Culottes +3",
		feet={ name="Ikenga's Clogs", augments={'Path: A',}},
		neck={ name="Comm. Charm +2", augments={'Path: A',}},
		waist="K. Kachina Belt +1",
		left_ear="Telos Earring",
		right_ear={ name="Chas. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+12','Mag. Acc.+12','Crit.hit rate+4',}},
		left_ring={ name="Cacoethic Ring +1", augments={'Path: A',}},
		right_ring="Ephramad's Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS.ATKCAP = {
		ammo=gear.WSbullet,
	    head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Ikenga's Vest", augments={'Path: A',}},
		hands="Chasseur's Gants +3",
		legs={ name="Ikenga's Trousers", augments={'Path: A',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear={ name="Chas. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+12','Mag. Acc.+12','Crit.hit rate+4',}},
		left_ring="Regal Ring",
		right_ring="Ephramad's Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%',}},}
		
    sets.precast.WS['Last Stand'] = sets.precast.WS
	sets.precast.WS['Last Stand'].Acc = sets.precast.WS.Acc
	sets.precast.WS['Last Stand'].ATKCAP = sets.precast.WS.ATKCAP
	sets.precast.WS['Last Stand'].FullTP = {left_ear="Odr Earring",}
	
	sets.precast.WS['Detonator'] = sets.precast.WS
	sets.precast.WS['Detonator'].Acc = sets.precast.WS.RangedAcc
	sets.precast.WS['Detonator'].ATKCAP = sets.precast.WS.ATKCAP
	sets.precast.WS['Detonator'].FullTP = {left_ear="Odr Earring",}
	
	sets.precast.WS['Terminus'] = sets.precast.WS
	sets.precast.WS['Terminus'].Acc = sets.precast.WS.Acc
	sets.precast.WS['Terminus'].ATKCAP = sets.precast.WS.ATKCAP
	sets.precast.WS['Terminus'].FullTP = {left_ear="Odr Earring",}
	
    sets.precast.WS['Leaden Salute'] = {
		ammo=gear.MAbullet,
		head="Pixie Hairpin +1",
		body={ name="Lanun Frac +4", augments={'Enhances "Loaded Deck" effect',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Lanun Bottes +4", augments={'Enhances "Wild Card" effect',}},
		neck={ name="Comm. Charm +2", augments={'Path: A',}},
		waist="Skrymir Cord +1",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Friomisi Earring",
		left_ring="Dingir Ring",
		right_ring="Archon Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','Weapon skill damage +10%',}},}

	sets.precast.WS['Leaden Salute'].FullTP = {left_ear="Hecate's Earring"}
	
    sets.precast.WS['Wildfire'] = {
		ammo=gear.MAbullet,
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Lanun Frac +4", augments={'Enhances "Loaded Deck" effect',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Lanun Bottes +4", augments={'Enhances "Wild Card" effect',}},
		neck={ name="Comm. Charm +2", augments={'Path: A',}},
		waist="Skrymir Cord +1",
		left_ear="Friomisi Earring",
		right_ear="Ishvara Earring",
		left_ring="Dingir Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','Weapon skill damage +10%',}},}

    sets.precast.WS['Hot Shot'] = {
		ammo=gear.WSbullet,
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Chasseur's Gants +3",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Lanun Bottes +4", augments={'Enhances "Wild Card" effect',}},
		neck="Fotia Gorget",
		waist="Skrymir Cord +1",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Friomisi Earring",
		left_ring="Dingir Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Hot Shot'].FullTP = {left_ear="Hecate's Earring"}

		--Melee Weaponskill sets

	sets.precast.WS.Melee = {
		ammo=gear.MeleeWSbullet,
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Chasseur's Gants +3",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Comm. Charm +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Ephramad's Ring",
		right_ring="Sroda Ring",
		back={ name="Camulus's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

	sets.precast.WS.MeleeAcc = {
		ammo=gear.MeleeWSbullet,
		head="Chass. Tricorne +3",
		body="Chasseur's Frac +3",
		hands="Chasseur's Gants +3",
		legs="Chas. Culottes +3",
		feet="Chass. Bottes +2",
		neck="Combatant's Torque",
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear="Odr Earring",
		right_ear={ name="Chas. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+12','Mag. Acc.+12','Crit.hit rate+4',}},
		left_ring={ name="Cacoethic Ring +1", augments={'Path: A',}},
		right_ring="Ephramad's Ring",
		back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},}
	
	sets.precast.WS.MeleeATKCAP = {
		ammo=gear.MeleeWSbullet,
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Ikenga's Vest", augments={'Path: A',}},
		hands="Chasseur's Gants +3",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Comm. Charm +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Ephramad's Ring",
		right_ring="Sroda Ring",
		back={ name="Camulus's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

    sets.precast.WS['Savage Blade'] = sets.precast.WS.Melee
	sets.precast.WS['Savage Blade'].Acc = sets.precast.WS.MeleeAcc
	sets.precast.WS['Savage Blade'].ATKCAP = sets.precast.WS.MeleeATKCAP
	sets.precast.WS['Savage Blade'].FullTP = {left_ear="Telos Earring",}

    sets.precast.WS['Evisceration'] = {
		ammo=gear.MeleeWSbullet,
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body="Mummu Jacket +2",
		hands="Chasseur's Gants +3",
		legs={ name="Zoar Subligar +1", augments={'Path: A',}},
		feet="Mummu Gamash. +2",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Odr Earring",
		right_ear={ name="Chas. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+12','Mag. Acc.+12','Crit.hit rate+4',}},
		left_ring="Ilabrat Ring",
		right_ring="Regal Ring",
		back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}},}

	sets.precast.WS['Exenterator'] = {
		ammo=gear.MeleeWSbullet,
	    head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Chasseur's Gants +3",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Telos Earring",
		right_ear={ name="Chas. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+12','Mag. Acc.+12','Crit.hit rate+4',}},
		left_ring="Ephramad's Ring",
		right_ring="Dingir Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%',}},}
    sets.precast.WS['Exenterator'].Acc = sets.precast.WS.MeleeAcc

	sets.precast.WS['Aeolian Edge'] = {
		ammo=gear.MAbullet,
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Lanun Frac +4", augments={'Enhances "Loaded Deck" effect',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Lanun Bottes +4", augments={'Enhances "Wild Card" effect',}},
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Friomisi Earring",
		left_ring="Dingir Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Aeolian Edge'].FullTP = {left_ear="Hecate's Earring"}
	
	sets.precast.WS['Cyclone'] = sets.precast.WS['Aeolian Edge']
	
		--Set used for Icarus Wing to maximize TP gain	
	sets.precast.Wing = {
		head={ name="Ikenga's Hat", augments={'Path: A',}},
		body={ name="Ikenga's Vest", augments={'Path: A',}},
		hands="Malignance Gloves",
		legs="Chas. Culottes +3",
		feet="Malignance Boots",
		neck="Iskur Gorget",
		waist="Gerdr Belt +1",
		left_ear="Dedition Earring",
		right_ear="Crep. Earring",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
	sets.precast.Volte_Harness = set_combine(sets.precast.Wing, {body="Volte Harness"})
	sets.precast.Prishes_Boots = set_combine(sets.precast.Wing, {feet="Prishe\'s Boots +1",})
		
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.SpellInterrupt = {
        legs="Carmine Cuisses +1", --20
        ring1="Evanescence Ring", --5
        }
		
	sets.midcast['Absorb-TP'] = {
		ammo=gear.Accbullet,
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body="Chasseur's Frac +3",
		hands="Chasseur's Gants +3",
		legs="Chas. Culottes +3",
		feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
		neck="Null Loop",
		waist="Null Belt",
		left_ear="Loquac. Earring",
		right_ear={ name="Chas. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+12','Mag. Acc.+12','Crit.hit rate+4',}},
		left_ring="Kishar Ring",
		right_ring="Stikini Ring +1",
		back="Null Shawl",}
		
	sets.midcast['Aspir'] = {
		ammo=gear.Accbullet,
	    head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body="Chasseur's Frac +3",
		hands="Chasseur's Gants +3",
		legs="Chas. Culottes +3",
		feet="Chass. Bottes +2",
		neck="Null Loop",
		waist="Null Belt",
		left_ear="Digni. Earring",
		right_ear={ name="Chas. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+12','Mag. Acc.+12','Crit.hit rate+4',}},
		left_ring="Evanescence Ring",
		right_ring="Excelsis Ring",
		back="Null Shawl",}


    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt

    sets.midcast.CorsairShot = {
		ammo=gear.MAbullet,
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Lanun Frac +4", augments={'Enhances "Loaded Deck" effect',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Chass. Bottes +2",
		neck="Baetyl Pendant",
		waist="Skrymir Cord +1",
		left_ear="Friomisi Earring",
		right_ear="Crep. Earring",
		left_ring="Dingir Ring",
		right_ring="Chirich Ring +1",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
    sets.midcast.CorsairShot.Store_TP = {
		ammo=gear.MAbullet,
		head={ name="Ikenga's Hat", augments={'Path: A',}},
		body={ name="Mirke Wardecors", augments={'"Quick Draw" ability delay -5','"Store TP"+4 "Subtle Blow"+4',}},
		hands="Malignance Gloves",
		legs="Chas. Culottes +3",
		feet="Chass. Bottes +2",
		neck={ name="Comm. Charm +2", augments={'Path: A',}},
		waist="Gerdr Belt +1",
		left_ear="Telos Earring",
		right_ear="Cessance Earring",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    sets.midcast.CorsairShot['Light Shot'] = {
		ammo=gear.QDbullet,
		head="Chass. Tricorne +3",
		body={ name="Mirke Wardecors", augments={'"Quick Draw" ability delay -5','"Store TP"+4 "Subtle Blow"+4',}},
		hands="Chasseur's Gants +3",
		legs="Chas. Culottes +3",
		feet="Chass. Bottes +2",
		neck={ name="Comm. Charm +2", augments={'Path: A',}},
		waist="K. Kachina Belt +1",
		left_ear="Crep. Earring",
		right_ear={ name="Chas. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+12','Mag. Acc.+12','Crit.hit rate+4',}},
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Stikini Ring +1",
		back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','Weapon skill damage +10%',}},}
    
	sets.midcast.CorsairShot['Dark Shot'] = {
		ammo=gear.QDbullet,
		head="Chass. Tricorne +3",
		body="Chasseur's Frac +3",
		hands="Chasseur's Gants +3",
		legs="Chas. Culottes +3",
		feet="Chass. Bottes +2",
		neck={ name="Comm. Charm +2", augments={'Path: A',}},
		waist="K. Kachina Belt +1",
		left_ear="Crep. Earring",
		right_ear={ name="Chas. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+12','Mag. Acc.+12','Crit.hit rate+4',}},
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Stikini Ring +1",
		back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','Weapon skill damage +10%',}},}
    
    -- Ranged gear
    sets.midcast.RA = {
		head={ name="Ikenga's Hat", augments={'Path: A',}},
		body={ name="Ikenga's Vest", augments={'Path: A',}},
		hands={ name="Ikenga's Gloves", augments={'Path: A',}},
		legs="Chas. Culottes +3",
		feet={ name="Ikenga's Clogs", augments={'Path: A',}},
		neck={ name="Comm. Charm +2", augments={'Path: A',}},
		waist="Yemaya Belt",
		left_ear="Telos Earring",
		right_ear="Digni. Earring",
		left_ring="Ilabrat Ring",
		right_ring="Dingir Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    sets.midcast.RA.Acc = {
		head={ name="Ikenga's Hat", augments={'Path: A',}},
		body="Chasseur's Frac +3",
		hands={ name="Ikenga's Gloves", augments={'Path: A',}},
		legs="Chas. Culottes +3",
		feet={ name="Ikenga's Clogs", augments={'Path: A',}},
		neck="Iskur Gorget",
		waist="K. Kachina Belt +1",
		left_ear="Telos Earring",
		right_ear="Crep. Earring",
		left_ring={ name="Cacoethic Ring +1", augments={'Path: A',}},
		right_ring="Ephramad's Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
	sets.TripleShot = {
		ammo="Chrono Bullet",
		head={ name="Ikenga's Hat", augments={'Path: A',}},
		body="Chasseur's Frac +3",
		hands={ name="Lanun Gants +3", augments={'Enhances "Fold" effect',}},
		legs="Chas. Culottes +3",
		feet="Osh. Leggings +1",
		neck={ name="Comm. Charm +2", augments={'Path: A',}},
		waist="Yemaya Belt",
		left_ear="Telos Earring",
		right_ear="Digni. Earring",
		left_ring="Ilabrat Ring",
		right_ring="Dingir Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
	sets.TripleShot.Acc = {
		head={ name="Ikenga's Hat", augments={'Path: A',}},
		body="Chasseur's Frac +3",
		hands={ name="Ikenga's Gloves", augments={'Path: A',}},
		legs="Chas. Culottes +3",
		feet={ name="Ikenga's Clogs", augments={'Path: A',}},
		neck="Iskur Gorget",
		waist="K. Kachina Belt +1",
		left_ear="Telos Earring",
		right_ear="Crep. Earring",
		left_ring={ name="Cacoethic Ring +1", augments={'Path: A',}},
		right_ring="Ephramad's Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
	
	sets.TripleShot_AM = {
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body="Chasseur's Frac +3",
		hands="Chasseur's Gants +3",
		legs={ name="Ikenga's Trousers", augments={'Path: A',}},
		feet="Osh. Leggings +1",
		neck="Iskur Gorget",
		waist="K. Kachina Belt +1",
		left_ear="Odr Earring",
		right_ear={ name="Chas. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+12','Mag. Acc.+12','Crit.hit rate+4',}},
		left_ring="Mummu Ring",
		right_ring="Ephramad's Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
	sets.TripleShot_AM.Acc = {
		head={ name="Ikenga's Hat", augments={'Path: A',}},
		body="Chasseur's Frac +3",
		hands={ name="Ikenga's Gloves", augments={'Path: A',}},
		legs="Chas. Culottes +3",
		feet={ name="Ikenga's Clogs", augments={'Path: A',}},
		neck="Iskur Gorget",
		waist="K. Kachina Belt +1",
		left_ear="Telos Earring",
		right_ear="Crep. Earring",
		left_ring={ name="Cacoethic Ring +1", augments={'Path: A',}},
		right_ring="Ephramad's Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.resting = {}

    sets.idle = {
		ammo=gear.RAbullet,
		head="Null Masque",
		body="Adamantite Armor",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Flume Belt +1",
		left_ear="Tuisto Earring",
		right_ear="Eabani Earring",
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring="Roller's Ring",
		back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
    sets.idle.Aminon = {
		ammo=gear.RAbullet,
		head="Null Masque",
		body="Malignance Tabard",
		hands="Regal Gloves",
		legs="Chas. Culottes +3",
		feet="Malignance Boots",
		neck="Sibyl Scarf",
		waist="Sweordfaetels +1",
		left_ear="Dedition Earring",
		right_ear="Telos Earring",
		left_ring="Chirich Ring +1",
		right_ring="Roller's Ring",
		back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    sets.engaged = {
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs="Chas. Culottes +3",
		feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
		neck="Iskur Gorget",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Telos Earring",
		right_ear="Dedition Earring",
		left_ring="Chirich Ring +1",
		right_ring="Epona's Ring",
		back="Null Shawl",}

    sets.engaged.Acc = {
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs="Chas. Culottes +3",
		feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
		neck="Iskur Gorget",
		waist="Windbuffet Belt +1",
		left_ear="Telos Earring",
		right_ear="Brutal Earring",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    -- Dual Wield Sets
    sets.engaged.DW = {
		head="Malignance Chapeau",
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs="Chas. Culottes +3",
		feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
		neck="Iskur Gorget",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Suppanomimi",
		right_ear="Dedition Earring",
		left_ring="Chirich Ring +1",
		right_ring="Epona's Ring",
		back="Null Shawl",
		}

    sets.engaged.DW.Acc = {
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},															--6%
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},												--6%
		feet={ name="Taeon Boots", augments={'Accuracy+25','"Dual Wield"+5','STR+5 DEX+5',}},													--9%
		neck="Combatant's Torque",
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear="Mache Earring +1",
		right_ear="Odr Earring",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},	--10%
		}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Chas. Culottes +3",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
        }
		
	sets.engaged.Hybrid.Defense = {
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs="Chas. Culottes +3",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
        }
		
    sets.engaged.Hybrid.DW = {
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Chas. Culottes +3",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		right_ear="Eabani Earring",
		back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
        }
		
	sets.engaged.Hybrid.DW.Defense = {
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs="Chas. Culottes +3",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		right_ear="Eabani Earring",
		back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
        }

	--[[ Use this for a full Crit Set
		{
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body="Mummu Jacket +2",
		hands="Chasseur's Gants +3",
		legs={ name="Zoar Subligar +1", augments={'Path: A',}},
		feet="Mummu Gamash. +2",
		neck="Combatant's Torque",
		waist="K. Kachina Belt +1",
		left_ear="Odr Earring",
		right_ear={ name="Chas. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+12','Mag. Acc.+12','Crit.hit rate+4',}},
		left_ring="Begrudging Ring",
		right_ring="Mummu Ring",
		back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}},}	]]
		

		
		
    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
    sets.engaged.Acc.DT = set_combine(sets.engaged.Acc, sets.engaged.Hybrid)
	sets.engaged.Defense = set_combine(sets.engaged, sets.engaged.Hybrid.Defense)
    sets.engaged.Acc.Defense = set_combine(sets.engaged.Acc, sets.engaged.Hybrid.Defense)

    sets.engaged.DW.DT = set_combine(sets.engaged.DW, sets.engaged.Hybrid.DW)
    sets.engaged.DW.Acc.DT = set_combine(sets.engaged.DW.Acc, sets.engaged.Hybrid.DW)
    sets.engaged.DW.Defense = set_combine(sets.engaged.DW, sets.engaged.Hybrid.DW.Defense)
    sets.engaged.DW.Acc.Defense = set_combine(sets.engaged.DW.Acc, sets.engaged.Hybrid.DW.Defense)

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

    sets.buff.Doom = {
		neck="Nicander's Necklace",
        waist="Gishdubar Sash", --10
        }

    sets.Obi = {waist="Hachirin-no-Obi"}
	sets.Orpheus = {waist="Orpheus's Sash"}
    sets.CP = {back="Mecisto. Mantle"}

	--Weaponsets

    sets.RostamA = {main={ name="Rostam", augments={'Path: A',}}, sub="Crepuscular Knife",}
    sets.RostamA.Acc = {main={ name="Rostam", augments={'Path: A',}}, sub="Crepuscular Knife",}
	sets.RostamA.RAcc = {main={ name="Rostam", augments={'Path: A',}}, sub={ name="Kustawi +1", augments={'Path: A',}},}
	
    sets.RostamC = {main={ name="Rostam", augments={'Path: C',}}, sub="Crepuscular Knife",}
    sets.RostamC.Acc = {main={ name="Rostam", augments={'Path: C',}}, sub="Crepuscular Knife",}
	sets.RostamC.RAcc = {main={ name="Rostam", augments={'Path: C',}}, sub={ name="Kustawi +1", augments={'Path: A',}},}

	sets.Naegling = {main="Naegling", sub="Crepuscular Knife",}
    sets.Naegling.Acc = {main="Naegling", sub="Crepuscular Knife",}
	sets.Naegling.RAcc = {main="Naegling", sub={ name="Kustawi +1", augments={'Path: A',}},}
	
	sets.Onion = {main="Onion Sword III", sub="Crepuscular Knife",}
    sets.Onion.Acc = {main="Onion Sword III", sub="Crepuscular Knife",}
	sets.Onion.RAcc = {main="Onion Sword III", sub={ name="Kustawi +1", augments={'Path: A',}},}
	
	sets.RostamA.SW = {main={ name="Rostam", augments={'Path: A',}}, sub="Nusku Shield"}
    sets.RostamA.SW.Acc = {main={ name="Rostam", augments={'Path: A',}}, sub="Nusku Shield"}
	sets.RostamA.SW.RAcc = {main={ name="Rostam", augments={'Path: A',}}, sub="Nusku Shield"}
	
	sets.RostamC.SW = {main={ name="Rostam", augments={'Path: C',}}, sub="Nusku Shield"}
    sets.RostamC.SW.Acc = {main={ name="Rostam", augments={'Path: C',}}, sub="Nusku Shield"}	
	sets.RostamC.SW.RAcc = {main={ name="Rostam", augments={'Path: C',}}, sub="Nusku Shield"}
	
	sets.Naegling.SW = {main="Naegling", sub="Nusku Shield"}
    sets.Naegling.SW.Acc = {main="Naegling", sub="Nusku Shield"}
	sets.Naegling.SW.RAcc = {main="Naegling", sub="Nusku Shield"}
	
	sets.Onion.SW = {main="Onion Sword III", sub="Nusku Shield"}
    sets.Onion.SW.Acc = {main="Onion Sword III", sub="Nusku Shield"}
	sets.Onion.SW.RAcc = {main="Onion Sword III", sub="Nusku Shield"}
	
	--Rangesets
	sets.TP_Gun = {range="Anarchy +2",}
	sets.Earp = {range="Compensator",}
	sets.Fomalhaut = {range="Fomalhaut",}
	sets.DeathPenalty = {range="Death Penalty",}
	sets.Armageddon = {range="Armageddon",}
	
	
	--Ammosets
	sets.Devastating = {waist="Dev. Bul. Pouch",}
	sets.Chrono = {waist="Chr. Bul. Pouch",}
	sets.Living = {waist="Liv. Bul. Pouch",}
	

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific Functions
-------------------------------------------------------------------------------------------------------------------

function job_precast(spell, action, spellMap, eventArgs)
	
		-- Check that proper ammo is available if we're using ranged attacks or similar.
    if spell.action_type == 'Ranged Attack' or spell.type == 'WeaponSkill' or spell.type == 'CorsairShot' then
        do_bullet_checks(spell, spellMap, eventArgs)
    end

		-- Handles Luzaf Ring if toggled on
    if state.LuzafRing.value == true then
        sets.precast.CorsairRoll = sets.precast.LuzafRing
	end
	if spell.english == "Double-Up" and state.LuzafRing.value == true then
		equip(sets.precast.LuzafRing)
	end

		--handles Double Bust 
    if spell.english == 'Fold' and buffactive['Bust'] == 2 then
        if sets.precast.FoldDoubleBust then
            equip(sets.precast.FoldDoubleBust)
            eventArgs.handled = true
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

function job_post_precast(spell, action, spellMap, eventArgs)

		--Handles Snapshot sets based on if Flurry is on
    if spell.action_type == 'Ranged Attack' then
		if state.RangedMode.value == 'Acc' then
			equip({ammo=gear.Accbullet})
		else
			equip({ammo=gear.RAbullet})
		end
        if flurry == 2 then
            equip(sets.precast.RA.Flurry2)
        elseif flurry == 1 then
            equip(sets.precast.RA.Flurry1)
        end
	end
		
		-- Equip obi if weather/day matches for WS.
    if spell.type == 'WeaponSkill' then
		if state.RangeSet.value == 'TP_Gun' then
			if player.tp > 1900 then
				equip(sets.precast.WS.FullTP)
			end
		elseif state.RangeSet.value == 'Fomalhaut' then
			if player.tp > 2400 then
				equip(sets.precast.WS.FullTP)
			end
		elseif state.RangeSet.value == 'DeathPenalty' or state.RangeSet.value == 'Armageddon' or state.RangeSet.value == 'Earp' then
			if player.tp > 2900 then
				equip(sets.precast.WS.FullTP)
			end
		end
		if spell.english == 'Leaden Salute' then
			if state.RangeSet.value == 'Fomalhaut' then
				if player.tp > 2400 then
					equip(sets.precast.WS['Leaden Salute'].FullTP)
				end
			else
				if player.tp > 2900 then
					equip(sets.precast.WS['Leaden Salute'].FullTP)
				end
			end
			if world.day_element == 'Dark' then
				if world.weather_element == 'Dark' and get_weather_intensity() >= 1 then
					equip(sets.Obi)
				else
					if spell.target.distance < (6 + spell.target.model_size) then
						equip({waist="Orpheus's Sash"})
					end
				end
			else
				if world.weather_element == 'Dark' and get_weather_intensity() == 2 then
					equip(sets.Obi)
				elseif world.weather_element == 'Dark' and get_weather_intensity() == 1 then
					if spell.target.distance < (6 + spell.target.model_size) then
						equip({waist="Orpheus's Sash"})
					else
						equip(sets.Obi)
					end
				elseif world.day_element == 'Light' then
					if spell.target.distance < (8 + spell.target.model_size) then
						equip({waist="Orpheus's Sash"})
					end
				end
			end
        elseif spell.english == 'Wildfire' then
			if player.tp > 2900 then
				equip(sets.precast.WS['Wildfire'])
			end			
			if world.day_element == 'Fire' then
				if world.weather_element == 'Fire' and get_weather_intensity() >= 1 then
					equip(sets.Obi)
				else
					if spell.target.distance < (6 + spell.target.model_size) then
						equip({waist="Orpheus's Sash"})
					end
				end
			else
				if world.weather_element == 'Fire' and get_weather_intensity() == 2 then
					equip(sets.Obi)
				elseif world.weather_element == 'Fire' and get_weather_intensity() == 1 then
					if spell.target.distance < (6 + spell.target.model_size) then
						equip({waist="Orpheus's Sash"})
					else
						equip(sets.Obi)
					end
				elseif world.day_element == 'Water' then
					if spell.target.distance < (8 + spell.target.model_size) then
						equip({waist="Orpheus's Sash"})
					end
				end
			end
		elseif spell.english == 'Hot Shot' then
			if state.RangeSet.value == 'Fomalhaut' then
				if player.tp > 2400 then
					equip(sets.precast.WS['Hot Shot'].FullTP)
				end
			else
				if player.tp > 2900 then
					equip(sets.precast.WS['Hot Shot'].FullTP)
				end
			end
			if world.day_element == 'Fire' then
				if world.weather_element == 'Fire' and get_weather_intensity() >= 1 then
					equip(sets.Obi)
				else
					if spell.target.distance < (6 + spell.target.model_size) then
						equip({waist="Orpheus's Sash"})
					end
				end
			else
				if world.weather_element == 'Fire' and get_weather_intensity() == 2 then
					equip(sets.Obi)
				elseif world.weather_element == 'Fire' and get_weather_intensity() == 1 then
					if spell.target.distance < (6 + spell.target.model_size) then
						equip({waist="Orpheus's Sash"})
					else
						equip(sets.Obi)
					end
				elseif world.day_element == 'Water' then
					if spell.target.distance < (8 + spell.target.model_size) then
						equip({waist="Orpheus's Sash"})
					end
				end
			end
		elseif spell.english == 'Aeolian Edge' or spell.english == 'Cyclone' then
			if state.RangeSet.value == 'TP_Gun' then
				if player.tp > 1900 then
					equip(sets.precast.WS['Aeolian Edge'].FullTP)
				end
			elseif state.RangeSet.value == 'Fomalhaut' then
				if player.tp > 2400 then
					equip(sets.precast.WS['Aeolian Edge'].FullTP)
				end
			elseif state.RangeSet.value == 'DeathPenalty' or state.RangeSet.value == 'Armageddon' or state.RangeSet.value == 'Earp' then
				if player.tp > 2900 then
					equip(sets.precast.WS['Aeolian Edge'].FullTP)
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
		elseif spell.english == 'Savage Blade' then
			if state.RangeSet.value == 'TP_Gun' then
				if player.tp > 1900 then
					equip(sets.precast.WS['Savage Blade'].FullTP)
				end
			elseif state.RangeSet.value == 'Fomalhaut' then
				if player.tp > 2400 then
					equip(sets.precast.WS['Savage Blade'].FullTP)
				end
			elseif state.RangeSet.value == 'DeathPenalty' or state.RangeSet.value == 'Armageddon' or state.RangeSet.value == 'Earp' then
				if player.tp > 2900 then
					equip(sets.precast.WS['Savage Blade'].FullTP)
				end
			end
		elseif spell.english == 'Last Stand' then
			if state.RangeSet.value == 'Fomalhaut' then
				if player.tp > 2400 then
					equip(sets.precast.WS['Last Stand'].FullTP)
				end
			else
				if player.tp > 2900 then
					equip(sets.precast.WS['Last Stand'].FullTP)
				end
			end
		elseif spell.english == 'Terminus' then
			if player.tp > 2900 then
				equip(sets.precast.WS['Terminus'].FullTP)
			end
		elseif spell.english == 'Detonator' then
			if state.RangeSet.value == 'Fomalhaut' then
				if player.tp > 2400 then
					equip(sets.precast.WS['Detonator'].FullTP)
				end
			else
				if player.tp > 2900 then
					equip(sets.precast.WS['Detonator'].FullTP)
				end
			end
		elseif spell.english == 'Evisceration' then
			if player.tp > 2900 then
				equip(sets.precast.WS['Evisceration'])
			end	
        end
    end
	
end

function job_post_midcast(spell, action, spellMap, eventArgs)

	if spell.type == 'CorsairShot' then 
		if spell.english ~= "Light Shot" or spell.english ~= "Dark Shot" then
			if state.CorsairShot.value == 'Damage' then
				equip(sets.midcast.CorsairShot)
					--Equips Obi set if the correct day or weather matches Elemental Magic and if correct distance
				if spell.element == world.day_element then
					if spell.element == world.weather_element and get_weather_intensity() == 2 then
						equip(sets.Obi)
					elseif spell.element == world.weather_element and get_weather_intensity() == 1 then
						equip(sets.Obi)
					elseif spell.element ~= world.weather_element then
						if spell.target.distance < (1.93 + spell.target.model_size) then
							equip({waist="Orpheus's Sash"})
						else
							equip(sets.Obi)
						end
					end
				else
					if (spell.element == world.weather_element and (get_weather_intensity() == 2 and spell.element ~= elements.weak_to[world.day_element])) then
						equip(sets.Obi)
					elseif (spell.element == world.weather_element and (get_weather_intensity() == 1 and spell.element ~= elements.weak_to[world.day_element])) then
						if spell.target.distance < (1.93 + spell.target.model_size) then
							equip({waist="Orpheus's Sash"})
						else
							equip(sets.Obi)
						end
					elseif (spell.element == world.weather_element and (get_weather_intensity() == 2 and spell.element == elements.weak_to[world.day_element])) then
						equip(sets.Obi)
					elseif (spell.element == world.weather_element and (get_weather_intensity() == 1 and spell.element == elements.weak_to[world.day_element])) then
						if spell.target.distance < (8 + spell.target.model_size) then
							equip({waist="Orpheus's Sash"})
						end
					elseif spell.element ~= world.weather_element then
						if spell.target.distance < (8 + spell.target.model_size) then
							equip({waist="Orpheus's Sash"})
						end
					end
				end
			elseif state.CorsairShot.value == 'Store_TP' then
				equip(sets.midcast.CorsairShot.Store_TP)
			end
		end
	end	

	if spell.action_type == 'Ranged Attack' then
	    if buffactive['Triple Shot'] then
			if state.RangedMode.value == 'Acc' then
				equip(sets.TripleShot.Acc)
			else
				equip(sets.TripleShot)
			end
		end
		
		if buffactive['Triple Shot'] and (buffactive['Aftermath: Lv.1'] or buffactive['Aftermath: Lv.2'] or buffactive['Aftermath: Lv.3']) and player.equipment.ranged == "Armageddon" then
            if state.RangedMode.value == 'Acc' then
				equip(sets.TripleShot_AM.Acc)
			else
				equip(sets.TripleShot_AM)
			end
		end
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)

		--Handles Light Shot Timer
    if spell.english == "Light Shot" then
        send_command('@timers c "Light Shot ['..spell.target.name..']" 60 down abilities/00195.png')
    end
	
end

function job_buff_change(buff,gain)

		--If we gain or lose any flurry buffs, adjust gear.
    if S{'flurry'}:contains(buff:lower()) then
        if not gain then
            flurry = nil
            --add_to_chat(122, "Flurry status cleared.")
        end
        if not midaction() then
            handle_equipping_gear(player.status)
        end
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

--Handles accuracy sets for weapons

function check_weaponset()
    if player.sub_job == 'DNC' or player.sub_job == 'NIN' then
		if	state.OffenseMode.value == 'Acc' and state.RangedMode.value == 'Acc' then
			equip(sets[state.WeaponSet.current].RAcc)
		elseif	state.OffenseMode.value == 'Acc' and state.RangedMode.value == 'Normal' then
			equip(sets[state.WeaponSet.current].Acc)
		elseif state.OffenseMode.value == 'Normal' and state.RangedMode.value == 'Acc' then
			equip(sets[state.WeaponSet.current].RAcc)
		else
			equip(sets[state.WeaponSet.current])
		end
	else
		if	state.OffenseMode.value == 'Acc' and state.RangedMode.value == 'Acc' then
			equip(sets[state.WeaponSet.current].SW.RAcc)
		elseif	state.OffenseMode.value == 'Acc' and state.RangedMode.value == 'Normal' then
			equip(sets[state.WeaponSet.current].SW.Acc)
		elseif state.OffenseMode.value == 'Normal' and state.RangedMode.value == 'Acc' then
			equip(sets[state.WeaponSet.current].SW.RAcc)
		else
			equip(sets[state.WeaponSet.current].SW)
		end
	end
end
--handles equiping ranged weapon sets

function check_rangeset()
	equip(sets[state.RangeSet.current])
	
	if state.RangeLock.value == true then
		disable('range')
	else
		enable('range')
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
	check_weaponset()				  
	check_rangeset()
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

	-- Modify the default idle set after it was constructed.
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

    local r_msg = state.RangedMode.value 

    local m_msg = state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        m_msg = m_msg .. '/' ..state.HybridMode.value
    end

    local ws_msg = state.WeaponskillMode.value

    local c_msg = state.CastingMode.value
	
    local q_msg = state.Quickdraw.current
    local q_color = ''
    if state.Quickdraw.current == 'Fire' then r_color = 167
    elseif state.Quickdraw.current == 'Ice' then r_color = 210
    elseif state.Quickdraw.current == 'Wind' then r_color = 204
    elseif state.Quickdraw.current == 'Earth' then r_color = 050
    elseif state.Quickdraw.current == 'Thunder' then r_color = 215
    elseif state.Quickdraw.current == 'Water' then r_color = 207 end

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

    add_to_chat(q_color, string.char(129,121).. '  ' ..string.upper(q_msg).. '  ' ..string.char(129,122) ..string.char(31,002)..  ' | '
		..string.char(31,210).. 'Melee' ..cf_msg.. ': ' ..string.char(31,001)..m_msg.. string.char(31,002)..  ' |'
		..string.char(31,060).. ' Range: ' ..string.char(31,001)..r_msg.. string.char(31,002)..  ' |'
        ..string.char(31,207).. ' WS: ' ..string.char(31,001)..ws_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

	--Read incoming packet to differentiate between Haste/Flurry I and II
windower.register_event('action',
    function(act)
        --check if you are a target of spell
        local actionTargets = act.targets
        playerId = windower.ffxi.get_player().id
        isTarget = false
        for _, target in ipairs(actionTargets) do
            if playerId == target.id then
                isTarget = true
            end
        end
        if isTarget == true then
            if act.category == 4 then
                local param = act.param
                if param == 845 and flurry ~= 2 then
                    --add_to_chat(122, 'Flurry Status: Flurry I')
                    flurry = 1
                elseif param == 846 then
                    --add_to_chat(122, 'Flurry Status: Flurry II')
                    flurry = 2
                end
            end
        end
    end)

	--Determines Haste Group / Melee set for Gear Info
function determine_haste_group()
    classes.CustomMeleeGroups:clear()
    if DW == true then
        classes.CustomMeleeGroups:append('')
    end
end

	--Gear Info Functions
function job_self_command(cmdParams, eventArgs)
	if cmdParams[1]:lower() == 'eleshot' then
        send_command('@input /ja "'..state.Quickdraw.value..' Shot" <t>')
    end

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

	--Defines Lucky/Unlucky Roll values
function define_roll_values()
    rolls = {
        ["Corsair's Roll"] =    {lucky=5, unlucky=9, bonus="Experience Points"},
        ["Ninja Roll"] =        {lucky=4, unlucky=8, bonus="Evasion"},
        ["Hunter's Roll"] =     {lucky=4, unlucky=8, bonus="Accuracy"},
        ["Chaos Roll"] =        {lucky=4, unlucky=8, bonus="Attack"},
        ["Magus's Roll"] =      {lucky=2, unlucky=6, bonus="Magic Defense"},
        ["Healer's Roll"] =     {lucky=3, unlucky=7, bonus="Cure Potency Received"},
        ["Drachen Roll"] =      {lucky=4, unlucky=8, bonus="Pet Magic Accuracy/Attack"},
        ["Choral Roll"] =       {lucky=2, unlucky=6, bonus="Spell Interruption Rate"},
        ["Monk's Roll"] =       {lucky=3, unlucky=7, bonus="Subtle Blow"},
        ["Beast Roll"] =        {lucky=4, unlucky=8, bonus="Pet Attack"},
        ["Samurai Roll"] =      {lucky=2, unlucky=6, bonus="Store TP"},
        ["Evoker's Roll"] =     {lucky=5, unlucky=9, bonus="Refresh"},
        ["Rogue's Roll"] =      {lucky=5, unlucky=9, bonus="Critical Hit Rate"},
        ["Warlock's Roll"] =    {lucky=4, unlucky=8, bonus="Magic Accuracy"},
        ["Fighter's Roll"] =    {lucky=5, unlucky=9, bonus="Double Attack Rate"},
        ["Puppet Roll"] =       {lucky=3, unlucky=7, bonus="Pet Magic Attack/Accuracy"},
        ["Gallant's Roll"] =    {lucky=3, unlucky=7, bonus="Defense"},
        ["Wizard's Roll"] =     {lucky=5, unlucky=9, bonus="Magic Attack"},
        ["Dancer's Roll"] =     {lucky=3, unlucky=7, bonus="Regen"},
        ["Scholar's Roll"] =    {lucky=2, unlucky=6, bonus="Conserve MP"},
        ["Naturalist's Roll"] = {lucky=3, unlucky=7, bonus="Enh. Magic Duration"},
        ["Runeist's Roll"] =    {lucky=4, unlucky=8, bonus="Magic Evasion"},
        ["Bolter's Roll"] =     {lucky=3, unlucky=9, bonus="Movement Speed"},
        ["Caster's Roll"] =     {lucky=2, unlucky=7, bonus="Fast Cast"},
        ["Courser's Roll"] =    {lucky=3, unlucky=9, bonus="Snapshot"},
        ["Blitzer's Roll"] =    {lucky=4, unlucky=9, bonus="Attack Delay"},
        ["Tactician's Roll"] =  {lucky=5, unlucky=8, bonus="Regain"},
        ["Allies' Roll"] =      {lucky=3, unlucky=10, bonus="Skillchain Damage"},
        ["Miser's Roll"] =      {lucky=5, unlucky=7, bonus="Save TP"},
        ["Companion's Roll"] =  {lucky=2, unlucky=10, bonus="Pet Regain and Regen"},
        ["Avenger's Roll"] =    {lucky=4, unlucky=8, bonus="Counter Rate"},
    }
end

function display_roll_info(spell)
    rollinfo = rolls[spell.english]
    local rollsize = (state.LuzafRing.value and string.char(129,157)) or ''

    if rollinfo then
        add_to_chat(001, string.char(129,115).. '  ' ..string.char(31,210)..spell.english..string.char(31,001)..
            ' : '..rollinfo.bonus.. ' ' ..string.char(129,116).. ' ' ..string.char(129,195)..
            '  Lucky: ' ..string.char(31,204).. tostring(rollinfo.lucky)..string.char(31,001).. ' /' ..
            ' Unlucky: ' ..string.char(31,167).. tostring(rollinfo.unlucky)..string.char(31,002)..
            '  ' ..rollsize)
    end
end

	-- Determine whether we have sufficient ammo for the action being attempted.
function do_bullet_checks(spell, spellMap, eventArgs)
    local bullet_name
    local bullet_min_count = 1

    if spell.type == 'WeaponSkill' then
        if spell.skill == "Marksmanship" then
            if spell.english == 'Wildfire' or spell.english == 'Leaden Salute' then
                -- magical weaponskills
                bullet_name = gear.MAbullet
            else
                -- physical weaponskills
                bullet_name = gear.WSbullet
            end
        else
            -- Ignore non-ranged weaponskills
            return
        end
		
    elseif spell.type == 'CorsairShot' then
        bullet_name = gear.QDbullet
		
    elseif spell.action_type == 'Ranged Attack' then
        bullet_name = gear.RAbullet
		
        if buffactive['Triple Shot'] then
            bullet_min_count = 3
        end
		
    end

    local available_bullets = player.inventory[bullet_name] or player.wardrobe[bullet_name]

		--If no ammo is available, give appropriate warning and end.
    if not available_bullets then
        if spell.type == 'CorsairShot' and player.equipment.ammo ~= 'empty' then
            add_to_chat(104, 'No Quick Draw ammo left.  Using what\'s currently equipped ('..player.equipment.ammo..').')
            return
        elseif spell.type == 'WeaponSkill' and player.equipment.ammo == gear.RAbullet then
            add_to_chat(104, 'No weaponskill ammo left.  Using what\'s currently equipped (standard ranged bullets: '..player.equipment.ammo..').')
            return
        else
            add_to_chat(104, 'No ammo ('..tostring(bullet_name)..') available for that action.')
            eventArgs.cancel = true
            return
        end
    end

		--Don't allow shooting or weaponskilling with ammo reserved for quick draw.
    if spell.type ~= 'CorsairShot' and bullet_name == gear.QDbullet and available_bullets.count <= bullet_min_count then
        add_to_chat(104, 'No ammo will be left for Quick Draw.  Cancelling.')
        eventArgs.cancel = true
        return
    end

		--Low ammo warning.
    if spell.type ~= 'CorsairShot' and state.warned.value == false
        and available_bullets.count > 1 and available_bullets.count <= options.ammo_warning_limit then
        local msg = '*****  LOW AMMO WARNING: '..bullet_name..' *****'
        --local border = string.repeat("*", #msg)
        local border = ""
        for i = 1, #msg do
            border = border .. "*"
        end

        add_to_chat(104, border)
        add_to_chat(104, msg)
        add_to_chat(104, border)

        state.warned:set()
    elseif available_bullets.count > options.ammo_warning_limit and state.warned then
        state.warned:reset()
    end
end

function special_ammo_check()
		--Stop if Animikii/Hauksbok equipped
    if no_shoot_ammo:contains(player.equipment.ammo) then
        cancel_spell()
        add_to_chat(123, '** Action Canceled: [ '.. player.equipment.ammo .. ' equipped!! ] **')
        return
    end
end

	--Allows equipping of warp/exp rings and ammo belts without auto swapping back to current set
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
		--Default macro set/book
    set_macro_page(1, 16)
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end