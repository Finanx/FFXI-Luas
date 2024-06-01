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
--  Job Specific Keybinds (Red Mage Binds)
-------------------------------------------------------------------------------------------------------------------
--
--	Modes:			[ Windows + M ]			Toggles Magic Burst Mode
--					[ Windows + B ]			Toggles TP Bonus Mode
--					[ Windows + 1 ]			Sets Weapon to Naegling then locks Main/Sub Slots
--					[ Windows + 2 ]			Sets Weapon to Crocea Mors then locks Main/Sub Slots
--					[ Windows + 3 ]			Sets Weapon to Murgleis then locks Main/Sub Slots
--					[ Windows + 4 ]			Sets Weapon to Mandau then locks Main/Sub Slots
--					[ Windows + 5 ]			Sets Weapon to Tauret then locks Main/Sub Slots
--					[ Windows + 6 ]			Sets Weapon to Malevolence then locks Main/Sub Slots
--					[ Windows + 7 ]			Sets Weapon to Maxentius then locks Main/Sub Slots
--
--	Echo Binds:		[ CTRL + Numpad- ]		Shows main Weaponskill Binds in game
--					[ ALT + Numpad- ]		Shows Alternate Weaponskill Binds in game
--					[ Shift + Numpad- ]		Shows Item Binds in game
--					[ Windows + Numpad- ]	Shows Food/Weapon/Misc. Binds in game
--
--	Items:			[ CTRL + Numpad. ]		Chapuli Quiver
--
-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.
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

    state.Buff.Saboteur = buffactive.Saboteur or false
    state.Buff.Chainspell = buffactive.Chainspell or false
	state.Buff.Spontaneity = buffactive.Spontaneity or false
    state.Buff.Stymie = buffactive.Stymie or false	

    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
					"Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring", "Emporox's Ring",}

    skill_spells = S{
        'Temper', 'Temper II', 'Enfire', 'Enfire II', 'Enblizzard', 'Enblizzard II', 'Enaero', 'Enaero II',
        'Enstone', 'Enstone II', 'Enthunder', 'Enthunder II', 'Enwater', 'Enwater II'}
		
	enfeebling_magic_maps = {}
		
	enfeebling_magic_maps.mnd = S{"Slow", "Slow II", "Paralyze", "Paralyze II", "Addle", "Addle II"}
	
	enfeebling_magic_maps.int = S{"Blind", "Blind II"}

	enfeebling_magic_maps.MACC = S{"Frazzle", "Frazzle II", "Dispel", "Inundation"}
	
	enfeebling_magic_maps.Skill = S{"Frazzle III", "Distract", "Distract II", "Distract III", "Poison", "Poison II", "Poisonga"}
	
	enfeebling_magic_maps.Duration = S{"Gravity", "Gravity II", "Sleep", "Sleep II", "Sleepga", "Sleepga II", "Bind", "Break", "Silence", "Dia", "Dia II", "Dia III", "Diaga"}
	
    lockstyleset = 1
end


-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc')
    state.HybridMode:options('Normal', 'DT')
    state.WeaponskillMode:options('Normal', 'Acc', 'ATKCAP')
    state.CastingMode:options('Normal', 'MACC')
    state.IdleMode:options('Normal')
	state.TreasureMode:options('Tag', 'None')
	state.ImpactMode = M{['description']='Impact Mode', 'Normal', 'MB', 'Occult_Accumen'}
	state.WeaponSet = M{['description']='Weapon Set', 'None', 'Naegling', 'Crocea_Mors', 'Murgleis', 'Mpu_Gandring', 'Tauret', 'Malevolence', 'Maxentius'}

	state.RangeLock = M(false, 'Range Lock')
    state.MagicBurst = M(false, 'Magic Burst')
	state.TPBonus = M(true, 'TP Bonus')
    state.NM = M(false, 'NM')

	--Includes Global Bind keys
	
	send_command('wait 2; exec Global-Binds.txt')
	
    --Red Mage binds	

	send_command('wait 2; exec /RDM/RDM-Binds.txt')
		
	--Gear Retrieval Script
	
	send_command('wait 10; exec /RDM/RDM-Gear-Retrieval.txt')
		
	--Job settings

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
	
	send_command('wait 1; exec /RDM/RDM-Gear-Removal.txt')
	
end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA['Chainspell'] = {body="Viti. Tabard +3"}
	sets.precast.JA['Convert'] = {main={ name="Murgleis", augments={'Path: A',}},}

    -- Fast cast sets for spells
    sets.precast.FC = {
		main={ name="Crocea Mors", augments={'Path: C',}},
		sub="Genmei Shield",
		ammo="Staunch Tathlum +1",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body="Lethargy Sayon +3",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
		neck="Orunmila's Torque",
		waist="Embla Sash",
		left_ear="Malignance Earring",
		right_ear={ name="Leth. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','"Dbl.Atk."+5',}},
		left_ring="Kishar Ring",
		right_ring="Defending Ring",
		back={ name="Sucellos's Cape", augments={'"Fast Cast"+10','Phys. dmg. taken-10%',}},}

    sets.precast.FC.Impact = {
		main={ name="Crocea Mors", augments={'Path: C',}},
		sub="Genmei Shield",
		ammo="Staunch Tathlum +1",
		body="Crepuscular Cloak",
		hands="Leth. Ganth. +3",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
		neck="Orunmila's Torque",
		waist="Embla Sash",
		left_ear="Malignance Earring",
		right_ear={ name="Leth. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','"Dbl.Atk."+5',}},
		left_ring="Kishar Ring",
		right_ring="Defending Ring",
		back={ name="Sucellos's Cape", augments={'"Fast Cast"+10','Phys. dmg. taken-10%',}},}
		
	sets.precast.FC.Dispelga = {
		main="Daybreak",
		sub="Genmei Shield",
		ammo="Staunch Tathlum +1",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body="Lethargy Sayon +3",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
		neck="Orunmila's Torque",
		waist="Embla Sash",
		left_ear="Malignance Earring",
		right_ear={ name="Leth. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','"Dbl.Atk."+5',}},
		left_ring="Kishar Ring",
		right_ring="Defending Ring",
		back={ name="Sucellos's Cape", augments={'"Fast Cast"+10','Phys. dmg. taken-10%',}},}

	sets.precast.RA = {
		range="Ullr",
		ammo="Chapuli Arrow",
		head={ name="Taeon Chapeau", augments={'"Snapshot"+5','"Snapshot"+5',}},
		body={ name="Taeon Tabard", augments={'"Snapshot"+5','"Snapshot"+5',}},
		hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
		legs={ name="Taeon Tights", augments={'"Snapshot"+4','"Snapshot"+5',}},
		feet="Volte Spats",
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Yemaya Belt",
		left_ear="Etiolation Earring",
		right_ear="Genmei Earring",
		left_ring="Defending Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
	
		--Set used for Icarus Wing to maximize TP gain	
	sets.precast.Wing = {
	    ammo="Aurgelmir Orb +1",
		head={ name="Bunzi's Hat", augments={'Path: A',}},
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist="Gerdr Belt +1",
		left_ear="Telos Earring",
		right_ear="Sherida Earring",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Leth. Houseaux +3",
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Ephramad's Ring",
		back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS.Acc = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Leth. Chappel +3",
		body="Lethargy Sayon +3",
		hands="Leth. Ganth. +3",
		legs="Leth. Fuseau +3",
		feet="Leth. Houseaux +3",
		neck="Combatant's Torque",
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear="Mache Earring +1",
		right_ear={ name="Leth. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','"Dbl.Atk."+5',}},
		left_ring="Ephramad's Ring",
		right_ring={ name="Cacoethic Ring +1", augments={'Path: A',}},
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}	
		
	sets.precast.WS.ATKCAP = {
		ammo="Crepuscular Pebble",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Malignance Gloves",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Leth. Houseaux +3",
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Sroda Ring",
		right_ring="Ephramad's Ring",
		back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS.FullTPPhysical = {left_ear="Sherida Earring",}
	sets.precast.WS.FullTPMagical = {left_ear="Regal Earring",}

    sets.precast.WS['Savage Blade'] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Leth. Houseaux +3",
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Ephramad's Ring",
		back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
    sets.precast.WS['Savage Blade'].Acc = sets.precast.WS.Acc
    sets.precast.WS['Savage Blade'].ATKCAP = sets.precast.WS.ATKCAP
	
	sets.precast.WS['Flat Blade'] = sets.precast.WS.Acc
	
	sets.precast.WS['Chant du Cygne'] = {
		ammo="Yetshila +1",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body="Lethargy Sayon +3",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Zoar Subligar +1", augments={'Path: A',}},
		feet="Thereoid Greaves",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Sherida Earring",
		right_ear="Mache Earring +1",
		left_ring="Ilabrat Ring",
		right_ring="Begrudging Ring",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}},}
		
	sets.precast.WS['Chant du Cygne'].Acc = sets.precast.WS.Acc
	
	sets.precast.WS['Chant du Cygne'].ATKCAP = {
		ammo="Yetshila +1",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs={ name="Zoar Subligar +1", augments={'Path: A',}},
		feet="Thereoid Greaves",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Sherida Earring",
		right_ear="Mache Earring +1",
		left_ring="Ilabrat Ring",
		right_ring="Begrudging Ring",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}},}
	
	sets.precast.WS['Evisceration'] = sets.precast.WS['Chant du Cygne']
	sets.precast.WS['Evisceration'].Acc = sets.precast.WS.Acc
	sets.precast.WS['Evisceration'].ATKCAP = sets.precast.WS['Chant du Cygne'].ATKCAP
		
	sets.precast.WS['Death Blossom'] = {
	    ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Leth. Houseaux +3",
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Sherida Earring",
		left_ring="Sroda Ring",
		right_ring="Ephramad's Ring",
		back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Death Blossom'].Acc = sets.precast.WS.Acc

	sets.precast.WS['Death Blossom'].ATKCAP = {
		ammo="Crepuscular Pebble",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Bunzi's Robe", augments={'Path: A',}},
		hands="Malignance Gloves",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Leth. Houseaux +3",
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Sherida Earring",
		left_ring="Sroda Ring",
		right_ring="Ephramad's Ring",
		back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

	sets.precast.WS['Black Halo'] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Leth. Houseaux +3",
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Regal Earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Ephramad's Ring",
		back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Black Halo'].Acc = sets.precast.WS.Acc
	
	sets.precast.WS['Black Halo'].ATKCAP = {
		ammo="Crepuscular Pebble",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Bunzi's Robe", augments={'Path: A',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Leth. Houseaux +3",
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Regal Earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Ephramad's Ring",
		back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

    sets.precast.WS['Requiescat'] = {
		ammo="Regal Gem",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Leth. Houseaux +3",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Regal Earring",
		left_ring="Epaminondas's Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Weapon skill damage +10%',}},}

    sets.precast.WS['Aeolian Edge'] = {
		ammo="Sroda Tathlum",
		head="Leth. Chappel +3",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Jhakri Cuffs +2",
		legs="Leth. Fuseau +3",
		feet="Leth. Houseaux +3",
		neck="Sibyl Scarf",
		waist="Orpheus's Sash",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Malignance Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Freke Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Weapon skill damage +10%',}},}
		
    sets.precast.WS['Sanguine Blade'] = {
		ammo="Sroda Tathlum",
		head="Pixie Hairpin +1",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Jhakri Cuffs +2",
		legs="Leth. Fuseau +3",
		feet="Leth. Houseaux +3",
		neck="Sibyl Scarf",
		waist="Orpheus's Sash",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Archon Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Red Lotus Blade'] = {
		ammo="Sroda Tathlum",
		head="Leth. Chappel +3",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Jhakri Cuffs +2",
		legs="Leth. Fuseau +3",
		feet="Leth. Houseaux +3",
		neck="Sibyl Scarf",
		waist="Orpheus's Sash",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Malignance Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Freke Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Seraph Blade'] = {
		ammo="Sroda Tathlum",
		head="Leth. Chappel +3",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Jhakri Cuffs +2",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Leth. Houseaux +3",
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Orpheus's Sash",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Malignance Earring",
		left_ring="Epaminondas's Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Empyreal Arrow'] = {
		ammo="Chapuli Arrow",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Combatant's Torque",
		waist="Yemaya Belt",
		left_ear="Telos Earring",
		right_ear="Enervating Earring",
		left_ring="Ephramad's Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
	
	sets.midcast.ra = {
		range="Ullr",
		ammo="Chapuli Arrow",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Combatant's Torque",
		waist="Yemaya Belt",
		left_ear="Telos Earring",
		right_ear="Crep. Earring",
		left_ring="Ephramad's Ring",
		right_ring="Chirich Ring +1",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

	sets.Enmity = {
		ammo="Sapience Orb",
		head="Halitus Helm",
		body="Emet Harness +1",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Zoar Subligar +1", augments={'Path: A',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Kasiri Belt",
		left_ear="Friomisi Earring",
		right_ear="Cryptic Earring",
		left_ring="Eihwaz Ring",
		right_ring="Begrudging Ring",
		back={ name="Sucellos's Cape", augments={'"Fast Cast"+10','Phys. dmg. taken-10%',}},}

	sets.precast.Flourish1 = sets.precast.WS.Acc
	sets.precast.Flourish1['Animated Flourish'] = sets.Enmity	

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.Cure = {
		main="Daybreak",
		sub="Ammurapi Shield",
		ammo="Regal Gem",
		head={ name="Kaykaus Mitra +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','"Cure" potency +6%','"Conserve MP"+7',}},
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		feet={ name="Kaykaus Boots +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		neck="Incanter's Torque",
		waist="Luminary Sash",
		left_ear="Beatific Earring",
		right_ear="Meili Earring",
		left_ring="Stikini Ring +1",
		right_ring="Sirona's Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Enmity-10',}},}

    sets.midcast.CureWeather = set_combine(sets.midcast.Cure, {		
		main="Chatoyant Staff",
		sub="Enki Strap",
		waist="Hachirin-no-Obi",
		back="Twilight Cape",})

    sets.midcast.CureSelf = {
		main="Daybreak",
		sub="Ammurapi Shield",
		ammo="Regal Gem",
		head={ name="Kaykaus Mitra +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','"Cure" potency +6%','"Conserve MP"+7',}},
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		feet={ name="Kaykaus Boots +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		neck="Phalaina Locket",
		waist="Gishdubar Sash",
		left_ear="Beatific Earring",
		right_ear="Meili Earring",
		left_ring="Sirona's Ring",
		right_ring="Kunaji Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Enmity-10',}},}
		
	sets.midcast.CureSelfWeather = set_combine(sets.midcast.CureSelf, {		
		main="Chatoyant Staff",
		sub="Enki Strap",
		waist="Hachirin-no-Obi",
		back="Twilight Cape",})

    sets.midcast.StatusRemoval = sets.precast.FC

    sets.midcast.Cursna = {
		main="Daybreak",
		sub="Ammurapi Shield",
		ammo="Regal Gem",
		head={ name="Kaykaus Mitra +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		feet={ name="Vanya Clogs", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
		neck="Debilis Medallion",
		waist="Bishop's Sash",
		left_ear="Beatific Earring",
		right_ear="Meili Earring",
		left_ring="Menelaus's Ring",
		right_ring="Sirona's Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Enmity-10',}},}

    sets.midcast['Enhancing Magic'] = {
		main={ name="Crocea Mors", augments={'Path: C',}},
		sub="Ammurapi Shield",
		ammo="Sapience Orb",
		head={ name="Telchine Cap", augments={'"Fast Cast"+4','Enh. Mag. eff. dur. +10',}},
		body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
		hands="Atrophy Gloves +3",
		legs={ name="Telchine Braconi", augments={'"Fast Cast"+3','Enh. Mag. eff. dur. +10',}},
		feet="Leth. Houseaux +3",
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Embla Sash",
		left_ear="Malignance Earring",
		right_ear={ name="Leth. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','"Dbl.Atk."+5',}},
		left_ring="Kishar Ring",
		right_ring="Prolix Ring",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    sets.midcast['Phalanx'] = {
		main={ name="Sakpata's Sword", augments={'Path: A',}},
		sub="Ammurapi Shield",
		ammo="Staunch Tathlum +1",
		head={ name="Telchine Cap", augments={'"Fast Cast"+4','Enh. Mag. eff. dur. +10',}},
		body={ name="Taeon Tabard", augments={'Phalanx +3',}},
		hands={ name="Taeon Gloves", augments={'"Recycle"+7','Phalanx +3',}},
		legs={ name="Taeon Tights", augments={'Accuracy+19 Attack+19','"Triple Atk."+2','Phalanx +3',}},
		feet={ name="Taeon Boots", augments={'Phalanx +3',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Embla Sash",
		left_ear="Mimir Earring",
		right_ear={ name="Leth. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','"Dbl.Atk."+5',}},
		left_ring="Defending Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
	sets.midcast['Aquaveil'] = {
		main={ name="Crocea Mors", augments={'Path: C',}},
		sub="Ammurapi Shield",
		ammo="Sapience Orb",
		head={ name="Amalric Coif +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
		hands="Regal Cuffs",
		legs={ name="Telchine Braconi", augments={'"Fast Cast"+3','Enh. Mag. eff. dur. +10',}},
		feet="Leth. Houseaux +3",
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Embla Sash",
		left_ear="Malignance Earring",
		right_ear={ name="Leth. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','"Dbl.Atk."+5',}},
		left_ring="Kishar Ring",
		right_ring="Prolix Ring",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    sets.midcast.EnhancingSkill = {
		main="Pukulatmuj +1",
		sub={ name="Forfend +1", augments={'Path: A',}},
		ammo="Sapience Orb",
		head="Befouled Crown",
		body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
		hands={ name="Viti. Gloves +3", augments={'Enhancing Magic duration',}},
		legs="Atrophy Tights +3",
		feet="Leth. Houseaux +3",
		neck="Incanter's Torque",
		waist="Olympus Sash",
		left_ear="Mimir Earring",
		right_ear="Andoaa Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Ghostfyre Cape", augments={'Enfb.mag. skill +1','Enha.mag. skill +10','Mag. Acc.+5','Enh. Mag. eff. dur. +18',}},}
		
	sets.buff.ComposureOther = {
		main={ name="Crocea Mors", augments={'Path: C',}},
		sub="Ammurapi Shield",
		ammo="Sapience Orb",
		head="Leth. Chappel +3",
		body="Lethargy Sayon +3",
		hands="Atrophy Gloves +3",
		legs="Leth. Fuseau +3",
		feet="Leth. Houseaux +3",
		neck="Dls. Torque +2",
		waist="Embla Sash",
		left_ear="Malignance Earring",
		right_ear={ name="Leth. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','"Dbl.Atk."+5',}},
		left_ring="Kishar Ring",
		right_ring="Prolix Ring",
		back={ name="Sucellos's Cape", augments={'"Fast Cast"+10','Phys. dmg. taken-10%',}},}
		
	sets.midcast.Gain_Spell = set_combine(sets.midcast['Enhancing Magic'], {hands="Viti. Gloves +3",})

    sets.midcast.Regen = set_combine(sets.midcast['Enhancing Magic'], {
		main="Bolelabunga",
		feet={ name="Bunzi's Sabots", augments={'Path: A',}},})
		
	sets.midcast.Regen_Composure = set_combine(sets.buff.ComposureOther, {
		main="Bolelabunga",
		feet={ name="Bunzi's Sabots", augments={'Path: A',}},})
	
    sets.midcast.Refresh = {
		main={ name="Crocea Mors", augments={'Path: C',}},
		sub="Ammurapi Shield",
		ammo="Sapience Orb",
		head={ name="Amalric Coif +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		body="Atrophy Tabard +3",
		hands="Atrophy Gloves +3",
		legs="Leth. Fuseau +3",
		feet="Leth. Houseaux +3",
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Embla Sash",
		left_ear="Malignance Earring",
		right_ear={ name="Leth. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','"Dbl.Atk."+5',}},
		left_ring="Kishar Ring",
		right_ring="Prolix Ring",
		back={ name="Sucellos's Cape", augments={'"Fast Cast"+10','Phys. dmg. taken-10%',}},}

    sets.midcast.RefreshSelf = set_combine(sets.midcast.Refresh, {
        waist="Gishdubar Sash",})

    sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {
        neck="Nodens Gorget",
        })

    sets.midcast.Storm = sets.midcast['Enhancing Magic']

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Enfeebling Spells ----------------------------------------
    ------------------------------------------------------------------------------------------------
	 
	 --MND Potency Based Enfeebling Slow,Paralyze,Addle	 
	sets.midcast['Enfeebling Magic'] = {
		main="Daybreak",
		sub="Ammurapi Shield",
		ammo="Regal Gem",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Lethargy Sayon +3",
		hands="Leth. Ganth. +3",
		legs={ name="Chironic Hose", augments={'Mag. Acc.+18 "Mag.Atk.Bns."+18','Haste+2','MND+13','Mag. Acc.+12',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Luminary Sash",
		left_ear="Regal Earring",
		right_ear="Snotra Earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Stikini Ring +1",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Enmity-10',}},}
		
	sets.midcast['Enfeebling Magic'].mnd = sets.midcast['Enfeebling Magic']
	sets.midcast['Enfeebling Magic'].int = sets.midcast['Enfeebling Magic']
		
	--Accuracy Based Enfeebling Frazzle 1-2, Dispel, Innundation
	sets.midcast['Enfeebling Magic'].MACC = {
		main={ name="Murgleis", augments={'Path: A',}},
		sub="Ammurapi Shield",
		ammo="Regal Gem",
		head="Atrophy Chapeau +3",
		body="Atrophy Tabard +3",
		hands="Leth. Ganth. +3",
		legs={ name="Chironic Hose", augments={'Mag. Acc.+18 "Mag.Atk.Bns."+18','Haste+2','MND+13','Mag. Acc.+12',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist={ name="Obstin. Sash", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear={ name="Leth. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','"Dbl.Atk."+5',}},
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Aurist's Cape +1", augments={'Path: A',}},}

	--Enfeebling Skill based spells Frazzle 3 (625 Skill Cap), Distract 1-3 (610 Skill Cap),
	sets.midcast['Enfeebling Magic'].Skill	= {
		main={ name="Murgleis", augments={'Path: A',}},
		sub="Ammurapi Shield",
		ammo="Regal Gem",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Lethargy Sayon +3",
		hands="Leth. Ganth. +3",
		legs={ name="Chironic Hose", augments={'Mag. Acc.+18 "Mag.Atk.Bns."+18','Haste+2','MND+13','Mag. Acc.+12',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist={ name="Obstin. Sash", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Snotra Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Enmity-10',}},}
	
	--Enfeebling Duration for spells that need to last long Sleeps,Break,Blind,Silence
	sets.midcast['Enfeebling Magic'].Duration = {
		main={ name="Murgleis", augments={'Path: A',}},
		sub="Ammurapi Shield",
		ammo="Regal Gem",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Lethargy Sayon +3",
		hands="Regal Cuffs",
		legs={ name="Chironic Hose", augments={'Mag. Acc.+18 "Mag.Atk.Bns."+18','Haste+2','MND+13','Mag. Acc.+12',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist={ name="Obstin. Sash", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Snotra Earring",
		left_ring="Kishar Ring",
		right_ring="Stikini Ring +1",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Enmity-10',}},}
	
	sets.midcast.Dispelga = set_combine(sets.midcast['Enfeebling Magic'].MACC, {main="Daybreak",sub="Ammurapi Shield",})
		
    sets.midcast['Dark Magic'] = {
		main={ name="Crocea Mors", augments={'Path: C',}},
		sub="Ammurapi Shield",
		ammo="Regal Gem",
		head="Atrophy Chapeau +3",
		body="Lethargy Sayon +3",
		hands="Leth. Ganth. +3",
		legs="Leth. Fuseau +3",
		feet="Leth. Houseaux +3",
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Malignance Earring",
		right_ear={ name="Leth. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','"Dbl.Atk."+5',}},
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Aurist's Cape +1", augments={'Path: A',}},}

    sets.midcast.Drain = {
		main={ name="Bunzi's Rod", augments={'Path: A',}},
		sub="Ammurapi Shield",
		ammo="Regal Gem",
		head="Atrophy Chapeau +3",
		body="Atrophy Tabard +3",
		hands="Leth. Ganth. +3",
		legs="Leth. Fuseau +3",
		feet="Leth. Houseaux +3",
		neck="Erra Pendant",
		waist="Fucho-no-Obi",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Evanescence Ring",
		right_ring="Archon Ring",
		back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},}

    sets.midcast.Aspir = sets.midcast.Drain
	
	sets.midcast['Absorb-TP'] = {
		main={ name="Crocea Mors", augments={'Path: C',}},
		sub="Ammurapi Shield",
		ammo="Regal Gem",
		head="Atrophy Chapeau +3",
		body="Lethargy Sayon +3",
		hands="Leth. Ganth. +3",
		legs="Leth. Fuseau +3",
		feet="Leth. Houseaux +3",
		neck="Erra Pendant",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Malignance Earring",
		right_ear={ name="Leth. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','"Dbl.Atk."+5',}},
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Aurist's Cape +1", augments={'Path: A',}},}

    sets.midcast['Elemental Magic'] = {
		main={ name="Bunzi's Rod", augments={'Path: A',}},
		sub="Ammurapi Shield",
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head="Leth. Chappel +3",
		body="Lethargy Sayon +3",
		hands="Leth. Ganth. +3",
		legs="Leth. Fuseau +3",
		feet="Leth. Houseaux +3",
		neck="Sibyl Scarf",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Freke Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},}
		
    sets.midcast['Elemental Magic'].MACC = {
		main="Bunzi's Rod",
		sub="Ammurapi Shield",
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head="Leth. Chappel +3",
		body="Lethargy Sayon +3",
		hands="Leth. Ganth. +3",
		legs="Leth. Fuseau +3",
		feet="Leth. Houseaux +3",
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Freke Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},}

	sets.midcast['Elemental Magic'].MagicBurst = {
		main={ name="Bunzi's Rod", augments={'Path: A',}},
		sub="Ammurapi Shield",
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head="Ea Hat +1",
		body="Lethargy Sayon +3",
		hands={ name="Bunzi's Gloves", augments={'Path: A',}},
		legs="Leth. Fuseau +3",
		feet="Leth. Houseaux +3",
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Freke Ring",
		back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},}

    sets.midcast.Impact = {
		main={ name="Murgleis", augments={'Path: A',}},
		sub="Ammurapi Shield",
		ammo="Regal Gem",
		head=empty,
		body="Crepuscular Cloak",
		hands="Leth. Ganth. +3",
		legs="Leth. Fuseau +3",
		feet="Leth. Houseaux +3",
		neck="Dls. Torque +2",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Snotra Earring",
		right_ear="Malignance Earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Stikini Ring +1",
		back={ name="Aurist's Cape +1", augments={'Path: A',}},}
		
	sets.midcast.Impact.MB = {
		main={ name="Bunzi's Rod", augments={'Path: A',}},
		sub="Ammurapi Shield",
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		body="Crepuscular Cloak",
		hands={ name="Bunzi's Gloves", augments={'Path: A',}},
		legs="Leth. Fuseau +3",
		feet="Leth. Houseaux +3",
		neck="Mizu. Kubikazari",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Archon Ring",
		back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},}
		
	sets.midcast.Impact.Occult_Accumen = {
		main={ name="Crocea Mors", augments={'Path: C',}},
		sub="Ammurapi Shield",
		ammo="Aurgelmir Orb +1",
		body="Crepuscular Cloak",
		hands={ name="Merlinic Dastanas", augments={'Mag. Acc.+4 "Mag.Atk.Bns."+4','"Occult Acumen"+11','"Mag.Atk.Bns."+10',}},
		legs="Perdition Slops",
		feet={ name="Merlinic Crackows", augments={'"Occult Acumen"+11','Mag. Acc.+3','"Mag.Atk.Bns."+5',}},
		neck="Anu Torque",
		waist="Oneiros Rope",
		left_ear="Sherida Earring",
		right_ear="Dedition Earring",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    -- Initializes trusts at iLvl 119
    sets.midcast.Trust = sets.precast.FC

    sets.buff.Saboteur = {hands="Leth. Ganth. +3"}


    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.idle = {
		main={ name="Sakpata's Sword", augments={'Path: A',}},																		
		sub="Genmei Shield",																												--10% PDT
		ammo="Homiliary",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Lethargy Sayon +3",																											--13%DT
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},																				--7% DT
		legs={ name="Nyame Flanchard", augments={'Path: B',}},																				--8% DT
		feet={ name="Nyame Sollerets", augments={'Path: B',}},																				--7% DT
		neck="Sibyl Scarf",
		waist="Flume Belt +1",																												--4% PDT
		left_ear="Mimir Earring",
		right_ear="Genmei Earring",																											--2% PDT
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},} --10% PDT
		--38% DT + 24 PDT

    sets.resting = {}

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
		ammo="Aurgelmir Orb +1",
		head={ name="Bunzi's Hat", augments={'Path: A',}},
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist="Windbuffet Belt +1",
		left_ear="Telos Earring",
		right_ear="Sherida Earring",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    sets.engaged.Acc = {
		main="Naegling",
		sub="Genmei Shield",
		ammo="Aurgelmir Orb +1",
		head={ name="Bunzi's Hat", augments={'Path: A',}},
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Combatant's Torque",
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear="Eabani Earring",
		right_ear="Telos Earring",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    -- No Magic Haste (74% DW to cap)
    sets.engaged.DW = {
		main="Naegling",
		sub={ name="Gleti\'s Knife", augments={'Path: A',}},
		ammo="Aurgelmir Orb +1",
		head={ name="Bunzi's Hat", augments={'Path: A',}},
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},											--6%
		feet={ name="Taeon Boots", augments={'Accuracy+25','"Dual Wield"+5','STR+5 DEX+5',}},												--9%
		neck="Anu Torque",
		waist="Reiki Yotai",																												--7%
		left_ear="Eabani Earring",																											--4%
		right_ear="Suppanomimi",																											--5%
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},}--10%
		--41%GDW + 25%JADW = 66%

	sets.engaged.DW.Acc = {
		main="Naegling",
		sub="Genmei Shield",
		ammo="Aurgelmir Orb +1",
		head={ name="Bunzi's Hat", augments={'Path: A',}},
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},											--6%
		feet={ name="Taeon Boots", augments={'Accuracy+25','"Dual Wield"+5','STR+5 DEX+5',}},												--9%
		neck="Combatant's Torque",
		waist="Reiki Yotai",																												--7%
		left_ear="Eabani Earring",																											--4%
		right_ear="Suppanomimi",																											--5%
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},}--10%
		--41%GDW + 25%JADW = 66%

    -- 15% Magic Haste (67% DW to cap)
    sets.engaged.DW.LowHaste = {
		main="Naegling",
		sub={ name="Gleti\'s Knife", augments={'Path: A',}},
		ammo="Aurgelmir Orb +1",
		head={ name="Bunzi's Hat", augments={'Path: A',}},
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},											--6%
		feet={ name="Taeon Boots", augments={'Accuracy+25','"Dual Wield"+5','STR+5 DEX+5',}},												--9%
		neck="Anu Torque",
		waist="Reiki Yotai",																												--7%
		left_ear="Eabani Earring",																											--4%
		right_ear="Suppanomimi",																											--5%
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},}--10%
		--41%GDW + 25%JADW = 66%

    sets.engaged.DW.Acc.LowHaste = {
		main="Naegling",
		sub="Genmei Shield",
		ammo="Aurgelmir Orb +1",
		head={ name="Bunzi's Hat", augments={'Path: A',}},
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},											--6%
		feet={ name="Taeon Boots", augments={'Accuracy+25','"Dual Wield"+5','STR+5 DEX+5',}},												--9%
		neck="Combatant's Torque",
		waist="Reiki Yotai",																												--7%
		left_ear="Eabani Earring",																											--4%
		right_ear="Suppanomimi",																											--5%
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},}--10%
		--41%GDW + 25%JADW = 66%

    -- 30% Magic Haste (56% DW to cap)
    sets.engaged.DW.MidHaste = {
		main="Naegling",
		sub={ name="Gleti\'s Knife", augments={'Path: A',}},
		ammo="Aurgelmir Orb +1",
		head={ name="Bunzi's Hat", augments={'Path: A',}},
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},											--6%
		feet="Malignance Boots",
		neck="Anu Torque",
		waist="Reiki Yotai",																												--7%
		left_ear="Eabani Earring",																											--4%
		right_ear="Suppanomimi",																											--5%
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},}--10%
		--32%GDW + 25%JADW = 57%

    sets.engaged.DW.Acc.MidHaste = {
		main="Naegling",
		sub="Genmei Shield",
		ammo="Aurgelmir Orb +1",
		head={ name="Bunzi's Hat", augments={'Path: A',}},
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},											--6%
		feet="Malignance Boots",
		neck="Combatant's Torque",
		waist="Reiki Yotai",																												--7%
		left_ear="Eabani Earring",																											--4%
		right_ear="Suppanomimi",																											--5%
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},}--10%
		--32%GDW + 25%JADW = 57%

    -- 35% Magic Haste (51% DW to cap)
    sets.engaged.DW.HighHaste = {
		main="Naegling",
		sub={ name="Gleti\'s Knife", augments={'Path: A',}},
		ammo="Aurgelmir Orb +1",
		head={ name="Bunzi's Hat", augments={'Path: A',}},
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist="Reiki Yotai",																												--7%
		left_ear="Eabani Earring",																											--4%
		right_ear="Suppanomimi",																											--5%
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},}--10%
		--26%GDW + 25%JADW = 51%

    sets.engaged.DW.Acc.HighHaste = {
		main="Naegling",
		sub="Genmei Shield",
		ammo="Aurgelmir Orb +1",
		head={ name="Bunzi's Hat", augments={'Path: A',}},
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Combatant's Torque",
		waist="Reiki Yotai",																												--7%
		left_ear="Eabani Earring",																											--4%
		right_ear="Suppanomimi",																											--5%
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},}--10%
		--26%GDW + 25%JADW = 51%

    -- 45% Magic Haste (36% DW to cap)
    sets.engaged.DW.MaxHaste = {
		main="Naegling",
		sub={ name="Gleti\'s Knife", augments={'Path: A',}},
		ammo="Aurgelmir Orb +1",
		head={ name="Bunzi's Hat", augments={'Path: A',}},
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist="Reiki Yotai",																												--7%
		left_ear="Eabani Earring",																											--4%
		right_ear="Sherida Earring",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		--11%GDW + 25%JADW = 36%

    sets.engaged.DW.Acc.MaxHaste = {
		main="Naegling",
		sub="Genmei Shield",
		ammo="Aurgelmir Orb +1",
		head={ name="Bunzi's Hat", augments={'Path: A',}},
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Combatant's Torque",
		waist="Reiki Yotai",																												--7%
		left_ear="Eabani Earring",																											--4%
		right_ear="Telos Earring",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		--11%GDW + 25%JADW = 36%


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid =  {
		head={ name="Bunzi's Hat", augments={'Path: A',}},
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
		}--41% DT + 10% PDT

		
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
	
	
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	sets.Kiting = {left_ring="Shneddick Ring",}

	sets.TreasureHunter = {
		hands={ name="Chironic Gloves", augments={'MND+4','Phys. dmg. taken -2%','"Treasure Hunter"+1','Accuracy+5 Attack+5',}}, 	--TH1
		body="Volte Jupon",			--TH2
		waist="Chaac Belt",} 	 	--TH1

	
    sets.buff.Doom = {
		neck="Nicander's Necklace",
		waist="Gishdubar Sash", --10
        }

    sets.Obi = {waist="Hachirin-no-Obi"}
	
	--Weapon Sets

	sets.Naegling = {main="Naegling", sub={ name="Gleti\'s Knife", augments={'Path: A',}},}
	sets.Naegling_Thibron = {main="Naegling", sub={ name="Machaera +2", augments={'TP Bonus +1000',}},}
	sets.Naegling.SW = {main="Naegling", sub="Genmei Shield",}
	
	sets.Crocea_Mors = {main={ name="Crocea Mors", augments={'Path: C',}}, sub="Daybreak",}
	sets.Crocea_Mors.SW = {main={ name="Crocea Mors", augments={'Path: C',}}, sub="Ammurapi Shield",}

	sets.Murgleis = {main={ name="Murgleis", augments={'Path: A',}},sub={ name="Bunzi's Rod", augments={'Path: A',}},}
	sets.Murgleis_Thibron = {main={ name="Murgleis", augments={'Path: A',}}, sub={ name="Machaera +2", augments={'TP Bonus +1000',}},}
	sets.Murgleis.SW = {main={ name="Murgleis", augments={'Path: A',}},sub="Ammurapi Shield"}
	
	sets.Malevolence = {main={ name="Malevolence", augments={'INT+10','Mag. Acc.+10','"Mag.Atk.Bns."+10','"Fast Cast"+5',}},sub={ name="Bunzi's Rod", augments={'Path: A',}},}
	sets.Malevolence_Thibron = {main="Malevolence", sub={ name="Machaera +2", augments={'TP Bonus +1000',}},}
	sets.Malevolence.SW = {main={ name="Malevolence", augments={'INT+10','Mag. Acc.+10','"Mag.Atk.Bns."+10','"Fast Cast"+5',}}, sub="Ammurapi Shield"}
	
	sets.Tauret = {main="Tauret", sub={ name="Gleti\'s Knife", augments={'Path: A',}},}
	sets.Tauret.SW = {main="Tauret", sub="Genmei Shield"}
	
	sets.Mpu_Gandring = {main="Mpu Gandring", sub={ name="Gleti\'s Knife", augments={'Path: A',}},}
	sets.Mpu_Gandring_Thibron = {main="Mpu Gandring", sub={ name="Machaera +2", augments={'TP Bonus +1000',}},}
	sets.Mpu_Gandring.SW = {main="Mpu Gandring", sub="Genmei Shield",}
	
	sets.Maxentius = {main="Maxentius", sub={ name="Gleti\'s Knife", augments={'Path: A',}},}
	sets.Maxentius_Thibron = {main="Maxentius", sub={ name="Machaera +2", augments={'TP Bonus +1000',}},}
	sets.Maxentius.SW = {main="Maxentius", sub="Genmei Shield",}
	sets.Maxentius.SW.Acc = {main="Maxentius", sub="Genmei Shield",}
	
	--Range Sets
	
	sets.Empyreal = {range="Ullr", ammo="Chapuli Arrow"}

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
		--Equips gearset to precast Impact
    if spell.name == 'Impact' then
        equip(sets.precast.FC.Impact)
    end
		--Equips gearset to precast Dispelga
	if spell.name == 'Dispelga' then
        equip(sets.precast.FC.Dispelga)
    end
	
		--equips correct sets if Chainspell is active
	if state.Buff.Chainspell or state.Buff.Spontaneity then
		if spell.skill == 'Enfeebling Magic' then
			if state.CastingMode.value == 'MACC' then
				equip(sets.midcast['Enfeebling Magic'].MACC)
			else
				if enfeebling_magic_maps.mnd:contains(spell.english) then
					equip(sets.midcast['Enfeebling Magic'].mnd)
				elseif enfeebling_magic_maps.int:contains(spell.english) then
					equip(sets.midcast['Enfeebling Magic'].int)
				elseif enfeebling_magic_maps.MACC:contains(spell.english) then
					equip(sets.midcast['Enfeebling Magic'].MACC)
				elseif enfeebling_magic_maps.Skill:contains(spell.english) then
					equip(sets.midcast['Enfeebling Magic'].Skill)
				elseif enfeebling_magic_maps.Duration:contains(spell.english) then
					equip(sets.midcast['Enfeebling Magic'].Duration)
				end
			end
			if state.Buff.Saboteur then
				equip(sets.buff.Saboteur)
			end
		end
	end
	
end

function job_post_midcast(spell, action, spellMap, eventArgs)

		--equips Mappings for Enfeebling Magic
    if spell.skill == 'Enfeebling Magic' then
		if state.CastingMode.value == 'MACC' then
			equip(sets.midcast['Enfeebling Magic'].MACC)
		else
			if enfeebling_magic_maps.mnd:contains(spell.english) then
				equip(sets.midcast['Enfeebling Magic'].mnd)
			elseif enfeebling_magic_maps.int:contains(spell.english) then
				equip(sets.midcast['Enfeebling Magic'].int)
			elseif enfeebling_magic_maps.MACC:contains(spell.english) then
				equip(sets.midcast['Enfeebling Magic'].MACC)
			elseif enfeebling_magic_maps.Skill:contains(spell.english) then
				equip(sets.midcast['Enfeebling Magic'].Skill)
			elseif enfeebling_magic_maps.Duration:contains(spell.english) then
				equip(sets.midcast['Enfeebling Magic'].Duration)
			end
		end
        if state.Buff.Saboteur then
            equip(sets.buff.Saboteur)
        end
    end
	
		--Changes all Enfeebling magic to accuracy set
	if state.CastingMode.value == 'MACC' and spell.skill == 'Enfeebling Magic' then
		equip(sets.midcast['Enfeebling Magic'].MACC)
	end
	
	if state.WeaponSet.value == 'None' and state.CastingMode.value == 'MACC' and spell.skill == 'Enfeebling Magic' then
		equip(sets.Empyreal)
	end
	if state.WeaponSet.value == 'None' and enfeebling_magic_maps.MACC:contains(spell.english) then
		equip(sets.Empyreal)
	end
	
		--Handles TP Overflow
	if spell.type == 'WeaponSkill' and state.WeaponskillMode.value ~= 'Acc' then
		if spell.english ~= "Chant du Cygne" or spell.english ~= "Evisceration" or spell.english ~= "Empyreal Arrow" or spell.english ~= "Sanguine Blade" or spell.english ~= "Death Blossom" then
			if spell.english == 'Seraph Blade' or spell.english == 'Red Lotus Blade' or spell.english == 'Aeolian Edge' then
				if state.TPBonus.value == true and (player.sub_job == 'DNC' or player.sub_job == 'NIN') then
					if player.tp > 1900 then
						equip(sets.precast.WS.FullTPMagical)
					end
				else
					if player.tp > 2900 then
						equip(sets.precast.WS.FullTPMagical)
					end
				end
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
			end
		end
		if spell.english == "Sanguine Blade" then
			if (world.weather_element == 'Dark' or world.day_element == 'Dark') then
				equip(sets.Obi)
				if world.day_element == 'Light' then
					equip({waist="Orpheus's Sash"})
				end
			end
		elseif spell.english == "Seraph Blade" then
			if (world.weather_element == 'Light' or world.day_element == 'Light') then
				equip(sets.Obi)
				if world.day_element == 'Dark' then
					equip({waist="Orpheus's Sash"})
				end
			end
		elseif spell.english == "Red Lotus Blade" then
			if (world.weather_element == 'Fire' or world.day_element == 'Fire') then
				equip(sets.Obi)
				if world.day_element == 'Water' then
					equip({waist="Orpheus's Sash"})
				end
			end
		elseif spell.english == "Aeolian Edge" then
			if (world.weather_element == 'Wind' or world.day_element == 'Wind') then
				equip(sets.Obi)
				if world.day_element == 'Ice' then
					equip({waist="Orpheus's Sash"})
				end
			end
		end
	end
	
		--Handles Magic Burst Toggle
	if state.MagicBurst.value == true and spell.skill == 'Elemental Magic' then
		if spell.name ~= 'Impact' then
			equip(sets.midcast['Elemental Magic'].MagicBurst)
		end
	end
	
		--Handles all Enhancing Magic mappings
    if spell.skill == 'Enhancing Magic' then
        if classes.NoSkillSpells:contains(spell.english) then
            equip(sets.midcast.EnhancingDuration)
        elseif skill_spells:contains(spell.english) then
            equip(sets.midcast.EnhancingSkill)
        elseif spell.english:startswith('Gain') then
			equip(sets.midcast.Gain_Spell)
        end
		if (spell.target.type == 'PLAYER' or spell.target.type == 'NPC') and buffactive.Composure then
            equip(sets.buff.ComposureOther)
        end
		if spellMap == 'Refresh' then
			equip(sets.midcast.Refresh)
			if spell.target.type == 'SELF' then
				equip (sets.midcast.RefreshSelf)
			end
		end
		if spellMap == 'Regen' then
			equip(sets.midcast.Regen)
			if (spell.target.type == 'PLAYER' or spell.target.type == 'NPC') and buffactive.Composure then
				equip (sets.midcast.Regen_Composure)
			end
		end
    end
	
		--Changes Cure set if Curing yourself
    if spellMap == 'Cure' and spell.target.type == 'SELF' then
        equip(sets.midcast.CureSelf)
			if (world.weather_element == 'Light' or world.day_element == 'Light') then
				equip(sets.midcast.CureSelfWeather)
			end
    end
	
		--Handles Elemental Magic Mappings
    if spell.skill == 'Elemental Magic' then

			--Equips gearset to cast Impact
		if spell.english == "Impact" then
			if state.ImpactMode.value == 'Normal' then
				equip(sets.midcast.Impact)
				if state.WeaponSet.value == 'None' then
					equip(sets.Empyreal)
				end
			elseif state.ImpactMode.value == 'MB' then
				equip(sets.midcast.Impact.MB)
			elseif state.ImpactMode.value == 'Occult_Accumen' then
				equip(sets.midcast.Impact.Occult_Accumen)
			end
        end
		
			--Equips gearset to cast Dispelga
		if spell.english == "Dispelga" then
            equip(sets.midcast.Dispelga)
        end
		
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
	end

end

function job_aftercast(spell, action, spellMap, eventArgs)

		--Posts a Sleep Timer if it lands
    if spell.english:contains('Sleep') and not spell.interrupted then
        set_sleep_timer(spell)
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
    update_combat_form()
    determine_haste_group()
	check_moving()
end

function job_update(cmdParams, eventArgs)
	check_gear()
    handle_equipping_gear(player.status)
end

	--Adjusts Melee/Weapon sets for Dual Wield or Single Wield
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
				equip(sets.Naegling_Thibron)
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
	elseif state.WeaponSet.value == 'Crocea_Mors' then
		if player.sub_job == 'DNC' or player.sub_job == 'NIN' then
			enable('main','sub')
			equip(sets.Crocea_Mors)
			disable('main','sub')
		else
			enable('main','sub')
			equip(sets.Crocea_Mors.SW)
			disable('main','sub')
		end
	elseif state.WeaponSet.value == 'Murgleis' then
		if player.sub_job == 'DNC' or player.sub_job == 'NIN' then
			if state.TPBonus.value == true then
				enable('main','sub')
				equip(sets.Murgleis_Thibron)
				disable('main','sub')
			else
				enable('main','sub')
				equip(sets.Murgleis)
				disable('main','sub')
			end
		else
			enable('main','sub')
			equip(sets.Murgleis.SW)
			disable('main','sub')
		end
	elseif state.WeaponSet.value == 'Mpu_Gandring' then
		if player.sub_job == 'DNC' or player.sub_job == 'NIN' then
			if state.TPBonus.value == true then
				enable('main','sub')
				equip(sets.Mpu_Gandring_Thibron)
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
	elseif state.WeaponSet.value == 'Tauret' then
		if player.sub_job == 'DNC' or player.sub_job == 'NIN' then
			enable('main','sub')
			equip(sets.Tauret)
			disable('main','sub')
		else
			enable('main','sub')
			equip(sets.Tauret.SW)
			disable('main','sub')
		end
	elseif state.WeaponSet.value == 'Malevolence' then
		if player.sub_job == 'DNC' or player.sub_job == 'NIN' then
			if state.TPBonus.value == true then
				enable('main','sub')
				equip(sets.Malevolence_Thibron)
				disable('main','sub')
			else
				enable('main','sub')
				equip(sets.Malevolence)
				disable('main','sub')
			end	
		else
			enable('main','sub')
			equip(sets.Malevolence.SW)
			disable('main','sub')
		end
	elseif state.WeaponSet.value == 'Maxentius' then
		if player.sub_job == 'DNC' or player.sub_job == 'NIN' then
			if state.TPBonus.value == true then
				enable('main','sub')
				equip(sets.Maxentius_Thibron)
				disable('main','sub')
			else
				enable('main','sub')
				equip(sets.Maxentius)
				disable('main','sub')
			end	
		else
			enable('main','sub')
			equip(sets.Maxentius.SW.Acc)
			disable('main','sub')
		end
	elseif state.WeaponSet.value == 'None' then
		enable('main','sub')
	end
	
		--Locks Ranged/ammo slots and equips Empyreal bow set
	if state.RangeLock.value == true then
		equip(sets.Empyreal)
		disable('range','ammo')
	else
		enable('range','ammo')
	end
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)

    if state.Auto_Kite.value == true then
       idleSet = set_combine(idleSet, sets.Kiting)
    end
	
    return idleSet
end

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)

		--Equips Cure weather set if weather/day is light
    if spell.action_type == 'Magic' then
        if default_spell_map == 'Cure' or default_spell_map == 'Curaga' then
            if (world.weather_element == 'Light' or world.day_element == 'Light') then
                return 'CureWeather'
            end
        end
    end
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
	
    if state.MagicBurst.value == true and state.TreasureMode.value == 'Tag' then
		msg = ' TH: Tag | Burst: On |'
	elseif 		state.TreasureMode.value == 'Tag' then
		msg = msg .. ' TH: Tag |'
	elseif state.MagicBurst.value == true then
		msg = ' Burst: On |'
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

	--Determines Haste Group / Melee set for Gear Info
function determine_haste_group()
    classes.CustomMeleeGroups:clear()
    if DW == true then
        if DW_needed <= 11 then
            classes.CustomMeleeGroups:append('MaxHaste')
        end
		if DW_needed > 11 and DW_needed <= 26 then
            classes.CustomMeleeGroups:append('HighHaste')
        end
		if DW_needed > 26 and DW_needed <= 33 then
            classes.CustomMeleeGroups:append('MidHaste')
        end
		if DW_needed > 33 and DW_needed <= 42 then
            classes.CustomMeleeGroups:append('LowHaste')
        end
		if DW_needed > 42 then
            classes.CustomMeleeGroups:append('')
        end
    end
end

	--Gear Info Functions
function job_self_command(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'scholar' then
        handle_strategems(cmdParams)
        eventArgs.handled = true
    elseif cmdParams[1]:lower() == 'nuke' then
        handle_nuking(cmdParams)
        eventArgs.handled = true
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
        if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
            send_command('gi ugs true')
        end
    end
)

	--Handles Sleep Timers based off Saboteur
function set_sleep_timer(spell)
    local self = windower.ffxi.get_player()

    if spell.en == "Sleep II" then 
        base = 90
    elseif spell.en == "Sleep" or spell.en == "Sleepga" then 
        base = 60
    end

    if state.Buff.Saboteur then
        if state.NM.value then
			base = base * 1.25
		else
			base = base * 2
		end
    end

    -- Job Points Buff
    base = base + self.job_points.rdm.enfeebling_magic_duration

	if state.Buff.Stymie then
		base = base + self.job_points.rdm.stymie_effect
	end

	add_to_chat(004, 'Base Duration: ' ..base)

    --User enfeebling duration enhancing gear total
    gear_mult = 1.55
    --User enfeebling duration enhancing augment total
	aug_mult = 1.17

    totalDuration = math.floor(base * gear_mult * aug_mult)
        
    -- Create the custom timer
    if spell.english == "Sleep II" then
        send_command('@timers c "Sleep II ['..spell.target.name..']" ' ..totalDuration.. ' down spells/00259.png')
    elseif spell.english == "Sleep" or spell.english == "Sleepga" then
        send_command('@timers c "Sleep ['..spell.target.name..']" ' ..totalDuration.. ' down spells/00253.png')
    end

end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
		--Default macro set/book
    set_macro_page(1, 6)
end

function set_lockstyle()
    send_command('wait 5; input /lockstyleset ' .. lockstyleset)
end