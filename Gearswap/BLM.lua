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
--  				[ Windows + R ]         Toggles RegenMode
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
--  Job Specific Keybinds (Scholar Binds)
-------------------------------------------------------------------------------------------------------------------
--
--	Modes:			[ Windows + M ]			Toggles Magic Burst Mode
--					[ Windows + S ]			Toggles Subtle Blow Mode
--					[ Windows + 1 ]			Sets Weapon to Maxentius then locks Main/Sub Slots
--					[ Windows + 2 ]			Sets Weapon to Xoanon then locks Main/Sub Slots
--					[ Windows + 3 ]			Sets Weapon to Musa then locks Main/Sub Slots
--
--	Echo Binds:		[ CTRL + Numpad- ]		Shows Main Weaponskill Binds in game
--					[ ALT + Numpad- ]		Shows Alternate Weaponskill Binds in game
--					[ Shift + Numpad- ]		Shows Item Binds in game
--					[ Windows + Numpad- ]	Shows Food/Weapon/Misc. Binds in game
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
    info.addendumNukes = S{"Stone IV", "Water IV", "Aero IV", "Fire IV", "Blizzard IV", "Thunder IV",
        "Stone V", "Water V", "Aero V", "Fire V", "Blizzard V", "Thunder V"}

    state.Buff['Sublimation: Activated'] = buffactive['Sublimation: Activated'] or false
	state.Buff['Mana Wall'] = buffactive['mana wall']  or false
	state.CoatMode = M{['description']='Coat Mode', 'Off', 'On'}
    state.CP = M(false, "Capacity Points Mode")
	
	include('Mote-TreasureHunter')

    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
					"Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring", "Emporox's Ring",}

    degrade_array = {
        ['Aspirs'] = {'Aspir','Aspir II'}
        }

    lockstyleset = 14

end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc')
    state.HybridMode:options('Normal', 'DT')
    state.WeaponskillMode:options('Normal')
    state.CastingMode:options('Normal', 'MACC')
    state.IdleMode:options('Normal', 'Death')
	state.TreasureMode:options('Tag', 'None')
	state.WeaponSet = M{['description']='Weapon Set', 'None', 'Mpaca', 'Hvergelmir', 'Laevateinn', 'Opashoro', 'Maxentius'}
	state.Element = M{['description']='Element', 'Fire', 'Blizzard', 'Aero', 'Stone', 'Thunder', 'Water'}
	
	state.MagicBurst = M{['description']='Magic Burst', 'Off', 'On'}

	--Includes Global Bind keys
	
	send_command('wait 2; exec Global-Binds.txt')

    --Scholar binds	

	send_command('wait 2; exec /BLM/BLM-Binds.txt')

	--Gear Retrieval Scripts
	
	send_command('wait 10; exec /BLM/BLM-Gear-Retrieval.txt')
	
	--Job settings

    select_default_macro_book()
    set_lockstyle()
	
	--Gearinfo Functions
	
    state.Auto_Kite = M(false, 'Auto_Kite')
    moving = false
	
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
	enable('main','sub','range','ammo','head','body','hands','legs','feet','neck','waist','left_ear','right_ear','left_ring','right_ring','back')

	--Remove Global Binds

	send_command('wait 1; exec Global-UnBinds.txt')
	
	--Gear Removal Script
	
	send_command('wait 1; exec /BLM/BLM-Gear-Removal.txt')
	
end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Precast sets to enhance JAs

    sets.precast.JA['Sublimation'] = {waist="Embla Sash",} --5
	sets.precast.JA['Manafont'] = {body={ name="Arch. Coat +3", augments={'Enhances "Manafont" effect',}},}

    -- Fast cast sets for spells
    sets.precast.FC = {
		main={ name="Mpaca's Staff", augments={'Path: A',}},
		sub="Khonsu",
		ammo="Sapience Orb",
		head={ name="Amalric Coif +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		body="Zendik Robe",
		hands={ name="Agwu's Gages", augments={'Path: A',}},
		legs={ name="Agwu's Slops", augments={'Path: A',}},
		feet={ name="Agwu's Pigaches", augments={'Path: A',}},
		neck="Orunmila's Torque",
		waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
		left_ear="Loquac. Earring",
		right_ear="Malignance Earring",
		left_ring="Prolix Ring",
		right_ring="Kishar Ring",
		back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10','Phys. dmg. taken-10%',}},}

    sets.precast.FC.Impact = set_combine(sets.precast.FC, {head=empty, body="Crepuscular Cloak"})
    sets.precast.FC.Dispelga = set_combine(sets.precast.FC, {main="Daybreak", sub="Ammurapi Shield"})

	sets.precast.FC.Death = {
		main={ name="Mpaca's Staff", augments={'Path: A',}},
		sub="Khonsu",
		ammo="Sapience Orb",
		head={ name="Amalric Coif +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		body={ name="Ros. Jaseran +1", augments={'Path: A',}},
		hands={ name="Agwu's Gages", augments={'Path: A',}},
		legs={ name="Agwu's Slops", augments={'Path: A',}},
		feet={ name="Amalric Nails +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		neck="Orunmila's Torque",
		waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
		left_ear="Loquac. Earring",
		right_ear="Etiolation Earring",
		left_ring="Kishar Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10','Phys. dmg. taken-10%',}},}
	
	sets.precast.RA = {
		main={ name="Mpaca's Staff", augments={'Path: A',}},
		sub="Khonsu",
		range="Trollbane",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Cornelia's Belt",
		left_ear="Eabani Earring",
		right_ear="Mimir Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10','Phys. dmg. taken-10%',}},}
		
		--Set used for Icarus Wing to maximize TP gain
	sets.precast.Wing = {}

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {}

    sets.precast.WS['Vidohunir'] = {
		ammo="Pemphredo Tathlum",
		head="Pixie Hairpin +1",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Sibyl Scarf",
		waist="Hachirin-no-Obi",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Archon Ring",
		right_ring="Freke Ring",
		back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}

	sets.precast.WS['Myrkr'] = {}
	
	sets.precast.WS['Starlight'] = {}
	
	sets.precast.WS['Shell Crusher'] = {}
	
	sets.precast.WS['Rock Crusher'] = {}
	
	sets.precast.WS['Shining Strike'] = {}
	
	sets.precast.WS['Cataclysm'] = {}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.Cure = {    
		main="Daybreak",
		sub="Ammurapi Shield",
		ammo="Staunch Tathlum +1",
		head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
		body="Shamash Robe",
		hands="Wicce Gloves +2",
		legs={ name="Agwu's Slops", augments={'Path: A',}},
		feet="Wicce Sabots +3",
		neck="Incanter's Torque",
		waist="Luminary Sash",
		left_ear="Mendi. Earring",
		right_ear="Meili Earring",
		left_ring="Menelaus's Ring",
		right_ring="Stikini Ring +1",
		back={ name="Fi Follet Cape +1", augments={'Path: A',}},}

	sets.midcast.CureSelf = {
	    main="Daybreak",
		sub="Ammurapi Shield",
		ammo="Staunch Tathlum +1",
		head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
		body="Shamash Robe",
		hands="Wicce Gloves +2",
		legs={ name="Agwu's Slops", augments={'Path: A',}},
		feet="Wicce Sabots +3",
		neck="Incanter's Torque",
		waist="Luminary Sash",
		left_ear="Mendi. Earring",
		right_ear="Meili Earring",
		left_ring="Menelaus's Ring",
		right_ring="Kunaji Ring",
		back={ name="Fi Follet Cape +1", augments={'Path: A',}},}

    sets.midcast.Curaga = {    
		main="Daybreak",
		sub="Ammurapi Shield",
		ammo="Staunch Tathlum +1",
		head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
		body="Shamash Robe",
		hands="Wicce Gloves +2",
		legs={ name="Agwu's Slops", augments={'Path: A',}},
		feet="Wicce Sabots +3",
		neck="Incanter's Torque",
		waist="Luminary Sash",
		left_ear="Mendi. Earring",
		right_ear="Meili Earring",
		left_ring="Menelaus's Ring",
		right_ring="Stikini Ring +1",
		back={ name="Fi Follet Cape +1", augments={'Path: A',}},}

    sets.midcast.StatusRemoval = sets.precast.FC

    sets.midcast['Enhancing Magic'] = {
		main={ name="Mpaca's Staff", augments={'Path: A',}},
		sub="Khonsu",
		ammo="Sapience Orb",
		head={ name="Telchine Cap", augments={'"Fast Cast"+4','Enh. Mag. eff. dur. +10',}},
		body={ name="Telchine Chas.", augments={'Enh. Mag. eff. dur. +10',}},
		hands={ name="Telchine Gloves", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +9',}},
		legs={ name="Telchine Braconi", augments={'"Fast Cast"+3','Enh. Mag. eff. dur. +10',}},
		feet={ name="Telchine Pigaches", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +10',}},
		neck="Incanter's Torque",
		waist="Embla Sash",
		left_ear="Mimir Earring",
		right_ear="Andoaa Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Fi Follet Cape +1", augments={'Path: A',}},}

    sets.midcast.EnhancingDuration = {
	    main={ name="Mpaca's Staff", augments={'Path: A',}},
		sub="Khonsu",
		ammo="Sapience Orb",
		head={ name="Telchine Cap", augments={'"Fast Cast"+4','Enh. Mag. eff. dur. +10',}},
		body={ name="Telchine Chas.", augments={'Enh. Mag. eff. dur. +10',}},
		hands={ name="Telchine Gloves", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +9',}},
		legs={ name="Telchine Braconi", augments={'"Fast Cast"+3','Enh. Mag. eff. dur. +10',}},
		feet={ name="Telchine Pigaches", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +10',}},
		neck="Incanter's Torque",
		waist="Olympus Sash",
		left_ear="Mimir Earring",
		right_ear="Andoaa Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Fi Follet Cape +1", augments={'Path: A',}},}

    sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {head={ name="Amalric Coif +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},back="Grapevine Cape",})
	
	sets.midcast.RefreshSelf = set_combine(sets.midcast['Enhancing Magic'], {head={ name="Amalric Coif +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},waist="Olympus Sash",back="Grapevine Cape",})

    sets.midcast.Aquaveil = set_combine(sets.midcast['Enhancing Magic'], {head={ name="Amalric Coif +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},hands="Regal Cuffs",})

    sets.midcast['Enfeebling Magic'] = {
	    main={ name="Mpaca's Staff", augments={'Path: A',}},
		sub="Khonsu",
		ammo="Pemphredo Tathlum",
		body={ name="Cohort Cloak +1", augments={'Path: A',}},
		hands="Regal Cuffs",
		legs="Spae. Tonban +3",
		feet="Wicce Sabots +3",
		neck={ name="Src. Stole +2", augments={'Path: A',}},
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Kishar Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Aurist's Cape +1", augments={'Path: A',}},}
	
	sets.midcast['Dia II'] = set_combine(sets.midcast['Enfeebling Magic'], {ammo="Per. Lucky Egg",body="Volte Jupon",waist="Chaac Belt",})
	
    sets.midcast['Dark Magic'] = {
		main={ name="Mpaca's Staff", augments={'Path: A',}},
		sub="Khonsu",
		ammo="Pemphredo Tathlum",
		head="Wicce Petasos +3",
		body="Wicce Coat +3",
		hands="Spae. Gloves +3",
		legs="Spae. Tonban +3",
		feet="Wicce Sabots +3",
		neck={ name="Src. Stole +2", augments={'Path: A',}},
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Kishar Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Aurist's Cape +1", augments={'Path: A',}},}

    sets.midcast.Drain = {
	    main={ name="Mpaca's Staff", augments={'Path: A',}},
		sub="Khonsu",
		ammo="Pemphredo Tathlum",
		head="Wicce Petasos +3",
		body="Wicce Coat +3",
		hands="Wicce Gloves +2",
		legs="Spae. Tonban +3",
		feet={ name="Agwu's Pigaches", augments={'Path: A',}},
		neck="Erra Pendant",
		waist="Fucho-no-Obi",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Evanescence Ring",
		right_ring="Archon Ring",
		back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}

    sets.midcast.Aspir = {
	    main={ name="Mpaca's Staff", augments={'Path: A',}},
		sub="Khonsu",
		ammo="Pemphredo Tathlum",
		head="Wicce Petasos +3",
		body="Wicce Coat +3",
		hands="Wicce Gloves +2",
		legs="Spae. Tonban +3",
		feet={ name="Agwu's Pigaches", augments={'Path: A',}},
		neck="Erra Pendant",
		waist="Fucho-no-Obi",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Evanescence Ring",
		right_ring="Archon Ring",
		back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}

    -- Elemental Magic
    sets.midcast['Elemental Magic'] = {
		main={ name="Bunzi's Rod", augments={'Path: A',}},
		sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
		head="Wicce Petasos +3",
		body="Wicce Coat +3",
		hands="Wicce Gloves +2",
		legs="Wicce Chausses +3",
		feet="Wicce Sabots +3",
		neck={ name="Src. Stole +2", augments={'Path: A',}},
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Freke Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}
		
	sets.midcast['Elemental Magic'].MPCoat = set_combine(sets.midcast['Elemental Magic'],{body="Spaekona's Coat +3",})

	sets.midcast['Elemental Magic'].MagicBurst = {
		main={ name="Bunzi's Rod", augments={'Path: A',}},
		sub="Ammurapi Shield",
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head="Wicce Petasos +3",
		body="Wicce Coat +3",
		hands={ name="Agwu's Gages", augments={'Path: A',}},
		legs="Wicce Chausses +3",
		feet={ name="Agwu's Pigaches", augments={'Path: A',}},
		neck={ name="Src. Stole +2", augments={'Path: A',}},
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Freke Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}

	sets.midcast['Elemental Magic'].MPCoatBurst = set_combine(sets.midcast['Elemental Magic'].MagicBurst,{body="Spaekona's Coat +3",})
		
    sets.midcast['Elemental Magic'].Resistant = {
		main={ name="Bunzi's Rod", augments={'Path: A',}},
		sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
		head="Wicce Petasos +3",
		body="Wicce Coat +3",
		hands="Wicce Gloves +2",
		legs="Wicce Chausses +3",
		feet="Wicce Sabots +3",
		neck={ name="Src. Stole +2", augments={'Path: A',}},
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Freke Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}
		
    sets.midcast['Elemental Magic'].Manawall = set_combine(sets.midcast['Elemental Magic'],{
		head="Wicce Petasos +3",
		body="Spaekona's Coat +3",
		hands="Wicce Gloves +2",
		feet="Wicce Sabots +3",
		right_ring="Defending Ring",
		back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},})
		
    sets.midcast['Elemental Magic'].ManawallBurst = set_combine(sets.midcast['Elemental Magic'].MagicBurst,{
		head="Wicce Petasos +3",
		body="Spaekona's Coat +3",
		hands="Wicce Gloves +2",
		feet="Wicce Sabots +3",
		right_ring="Defending Ring",
		back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},})
		
	sets.midcast.Death = {
	    main={ name="Mpaca's Staff", augments={'Path: A',}},
		sub="Khonsu",
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head="Pixie Hairpin +1",
		body="Wicce Coat +3",
		hands={ name="Agwu's Gages", augments={'Path: A',}},
		legs="Wicce Chausses +3",
		feet={ name="Amalric Nails +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		neck={ name="Src. Stole +2", augments={'Path: A',}},
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Barkaro. Earring",
		right_ear="Etiolation Earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Archon Ring",
		back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10','Phys. dmg. taken-10%',}},}
		
	sets.midcast.DeathMB = sets.midcast.Death
		
	sets.midcast.Comet = set_combine(sets.midcast['Elemental Magic'], {head="Pixie Hairpin +1",})
	sets.midcast.CometMB = set_combine(sets.midcast['Elemental Magic'].MagicBurst, {head="Pixie Hairpin +1",})

    sets.midcast.Impact = {
		main={ name="Mpaca's Staff", augments={'Path: A',}},
		sub="Enki Strap",
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head=empty,
		body="Crepuscular Cloak",
		hands={ name="Agwu's Gages", augments={'Path: A',}},
		legs="Wicce Chausses +3",
		feet={ name="Agwu's Pigaches", augments={'Path: A',}},
		neck={ name="Src. Stole +2", augments={'Path: A',}},
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Freke Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}
	
    sets.midcast.Dispelga = set_combine(sets.midcast['Enfeebling Magic'], {main="Daybreak", sub="Ammurapi Shield"})
	
	sets.midcast.ElementalEnfeeble = {
		main={ name="Bunzi's Rod", augments={'Path: A',}},
		sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
		head="Wicce Petasos +3",
		body="Spaekona's Coat +3",
		hands="Spae. Gloves +3",
		legs={ name="Arch. Tonban +3", augments={'Increases Elemental Magic debuff time and potency',}},
		feet={ name="Arch. Sabots +3", augments={'Increases Aspir absorption amount',}},
		neck={ name="Src. Stole +2", augments={'Path: A',}},
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Stikini Ring +1",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}

	sets.midcast.RA = {
		main={ name="Mpaca's Staff", augments={'Path: A',}},
		sub="Khonsu",
		range="Trollbane",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Cornelia's Belt",
		left_ear="Eabani Earring",
		right_ear="Mimir Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10','Phys. dmg. taken-10%',}},}
	
    -- Initializes trusts at iLvl 119
    sets.midcast.Trust = sets.precast.FC


    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.idle = {
		main={ name="Mpaca's Staff", augments={'Path: A',}},
		sub="Khonsu",
		ammo="Staunch Tathlum +1",
		head="Wicce Petasos +3",
		body="Shamash Robe",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Agwu's Slops", augments={'Path: A',}},
		feet="Wicce Sabots +3",
		neck="Sibyl Scarf",
		waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
		left_ear="Etiolation Earring",
		right_ear="Loquac. Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10','Phys. dmg. taken-10%',}},}
		
    sets.idle.Death = {
		main={ name="Mpaca's Staff", augments={'Path: A',}},
		sub="Khonsu",
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head="Wicce Petasos +3",
		body={ name="Ros. Jaseran +1", augments={'Path: A',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Amalric Slops +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		feet="Wicce Sabots +3",
		neck="Sanctity Necklace",
		waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
		left_ear="Etiolation Earring",
		right_ear="Loquac. Earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Prolix Ring",
		back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10','Phys. dmg. taken-10%',}},}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.latent_refresh = {waist="Fucho-no-obi"}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged = {
	    ammo="Crepuscular pebble",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Combatant's Torque",
		waist="Eschan Stone",
		left_ear="Crep. Earring",
		right_ear="Mache Earring +1",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	sets.Kiting = {left_ring="Shneddick Ring"}

    sets.buff.FullSublimation = {
       waist="Embla Sash", --5
       }

	sets.TreasureHunter = {
		ammo="Per. Lucky Egg", 		--TH1
		body="Volte Jupon",			--TH2
		waist="Chaac Belt",} 	 	--TH1
	
    sets.buff.Doom = {
		neck="Nicander's Necklace",
		waist="Gishdubar Sash", --10
        }

    sets.Obi = {waist="Hachirin-no-Obi"}
    sets.CP = {neck={ name="Argute Stole +2", augments={'Path: A',}},}
	
	--Weapon Sets

	sets.Maxentius = {main="Maxentius", sub="Daybreak",}
	sets.Maxentius.SW = {main="Maxentius", sub="Genmei Shield"}

	sets.Mpaca = {main={ name="Mpaca's Staff", augments={'Path: A',}}, sub="Khonsu",}
	
	sets.Hvergelmir = {main={ name="Mpaca's Staff", augments={'Path: A',}}, sub="Khonsu"}
	
	sets.Laevateinn = {main={ name="Mpaca's Staff", augments={'Path: A',}}, sub="Khonsu"}
	
	sets.Opashoro = {main="Opashoro", sub="Khonsu"}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific Functions
-------------------------------------------------------------------------------------------------------------------

function job_precast(spell, action, spellMap, eventArgs)
    if spell.name:startswith('Aspir') then
        refine_various_spells(spell, action, spellMap, eventArgs)
    end
end

function job_post_precast(spell, action, spellMap, eventArgs)
	if spell.name == 'Impact' then
        equip(sets.precast.FC.Impact)
    end
end

-- Run after the general midcast() is done.
function job_post_midcast(spell, action, spellMap, eventArgs)

    if spell.skill == 'Elemental Magic' then
		if state.MagicBurst.value == 'On' then
			if spell.english == "Death" then 
				equip(sets.midcast.DeathMB)
			elseif spell.english == "Comet" then
				equip(sets.midcast.CometMB)
			else
				if state.Buff['Mana Wall'] then
					equip(sets.midcast['Elemental Magic'].ManawallBurst)
				elseif state.CoatMode.value == 'On' then
					equip(sets.midcast['Elemental Magic'].MPCoatBurst)
				elseif player.mpp < 40 then
					equip(sets.midcast['Elemental Magic'].MPCoatBurst)
				else
					equip(sets.midcast['Elemental Magic'].MagicBurst)
				end
			end
		else
			if state.CoatMode.value == 'On' then
				equip(sets.midcast['Elemental Magic'].MPCoat)
			end
			
			if state.Buff['Mana Wall'] then
				equip(sets.midcast['Elemental Magic'].Manawall)
			end
		end

			--Equips gearset to cast Impact
		if spell.english == "Impact" then
                equip(sets.midcast.Impact)
        end
		
			--Equips gearset to cast Impact
		if spell.english == "Dispelga" then
                equip(sets.midcast.Dispelga)
        end
    end	

		--Changes Cure set if Curing yourself
    if spellMap == 'Cure' and spell.target.type == 'SELF' then
        equip(sets.midcast.CureSelf)
    end
	
    if spell.skill == 'Elemental Magic' or spell.english == "Death" then
        if (spell.element == world.weather_element and (get_weather_intensity() == 2 and spell.element ~= elements.weak_to[world.day_element])) and spellMap ~= 'Helix' then
            equip(sets.Obi)
        -- Target distance under 1.7 yalms.
        elseif spell.target.distance < (1.7 + spell.target.model_size) then
            equip({waist="Orpheus's Sash"})
        -- Matching day and weather.
       elseif (spell.element == world.day_element and spell.element == world.weather_element) then
            equip(sets.Obi)
        -- Target distance under 8 yalms.
        elseif spell.target.distance < (8 + spell.target.model_size) then
            equip({waist="Orpheus's Sash"})
        -- Match day or weather.
       elseif (spell.element == world.day_element or spell.element == world.weather_element) then
            equip(sets.Obi)
        end
    end
	
    if spell.skill == 'Enhancing Magic' then
        if classes.NoSkillSpells:contains(spell.english) then
            equip(sets.midcast.EnhancingDuration)

			if spellMap == 'Refresh' then
				equip(sets.midcast.Refresh)
				if spell.target.type == 'SELF' then
					equip (sets.midcast.RefreshSelf)
				end
			end
			
        end
    end
end


function job_buff_change(buff,gain)

		--Handles Sublimation gear
    if buff == "Sublimation: Activated" then
        handle_equipping_gear(player.status)
    end

		--Auto equips Cursna Recieved doom set when doom debuff is on
    if buff == "doom" then
        if gain then
            equip(sets.buff.Doom)
            --send_command('@input /p Doomed.')
            disable('neck','waist')
        else
            enable('neck','waist')
            handle_equipping_gear(player.status)
        end
    end
	
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function job_handle_equipping_gear(playerStatus, eventArgs)
    check_gear()
    check_moving()
	update_combat_form()
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    handle_equipping_gear(player.status)
    update_sublimation()
end

	--Adjusts Melee/Weapon sets for Dual Wield or Single Wield
function update_combat_form()

	if state.WeaponSet.value == 'Mpaca' then
		enable('main','sub')
		equip(sets.Mpaca)
		disable('main','sub')
	elseif state.WeaponSet.value == 'Hvergelmir' then
		enable('main','sub')
		equip(sets.Hvergelmir)
		disable('main','sub')
	elseif state.WeaponSet.value == 'Laevateinn' then
		enable('main','sub')
		equip(sets.Laevateinn)
		disable('main','sub')
	elseif state.WeaponSet.value == 'Opashoro' then
		enable('main','sub')
		equip(sets.Opashoro)
		disable('main','sub')
	elseif state.WeaponSet.value == 'Maxentius' then
		if player.sub_job == 'DNC' or player.sub_job == 'NIN' then
			enable('main','sub')
			equip(sets.Maxentius)
			disable('main','sub')
		else
			enable('main','sub')
			equip(sets.Maxentius.SW)
			disable('main','sub')
		end
	elseif state.WeaponSet.value == 'None' then
		enable('main','sub')
	end

end

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if default_spell_map == 'Cure' or default_spell_map == 'Curaga' then
            if (world.weather_element == 'Light' or world.day_element == 'Light') then
                return 'CureWeather'
            end
        end
    end
end

function customize_idle_set(idleSet)

    if state.Buff['Sublimation: Activated'] then
        idleSet = set_combine(idleSet, sets.buff.FullSublimation)
    end
	
    if player.mpp < 51 and state.IdleMode.value == 'Normal' then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
	
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
-- Return true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)

    local c_msg = state.CastingMode.value

    local i_msg = state.IdleMode.value

    local co_msg = state.CoatMode.value
	
	local th_msg = state.TreasureMode.value

	local mb_msg = state.MagicBurst.value
	
    local e_msg = state.Element.value
    local e_color = ''
    if state.Element.current == 'Fire' then e_color = 167
    elseif state.Element.current == 'Blizzard' then e_color = 210
    elseif state.Element.current == 'Aero' then e_color = 204
    elseif state.Element.current == 'Stone' then e_color = 050
    elseif state.Element.current == 'Thunder' then e_color = 215
    elseif state.Element.current == 'Water' then e_color = 207 end

    local msg = ''

    add_to_chat(e_color, string.char(129,121).. '  ' ..string.upper(e_msg).. '  ' ..string.char(129,122) ..string.char(31,002)..  ' | '
		..string.char(31,060).. '| Magic: ' ..string.char(31,001)..c_msg.. string.char(31,002)..  ' |'
        ..string.char(31,040).. ' CoatMode: ' ..string.char(31,001)..co_msg.. string.char(31,002)..  ' |'
		..string.char(31,040).. ' Burst: ' ..string.char(31,001)..mb_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
		..string.char(31,002).. ' TH: ' ..string.char(31,001)..th_msg.. string.char(31,002)..  ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for direct player commands.
function job_self_command(cmdParams, eventArgs)
    gearinfo(cmdParams, eventArgs)
	if cmdParams[1]:lower() == 'element1' then
        send_command('@input /ma "'..state.Element.value..'" <t>')
	elseif cmdParams[1]:lower() == 'element2' then
        send_command('@input /ma "'..state.Element.value..' II" <t>')
	elseif cmdParams[1]:lower() == 'element3' then
        send_command('@input /ma "'..state.Element.value..' III" <t>')
	elseif cmdParams[1]:lower() == 'element4' then
        send_command('@input /ma "'..state.Element.value..' IV" <t>')
	elseif cmdParams[1]:lower() == 'element5' then
        send_command('@input /ma "'..state.Element.value..' V" <t>')
	elseif cmdParams[1]:lower() == 'element6' then
        send_command('@input /ma "'..state.Element.value..' VI" <t>')
	end
	if cmdParams[1]:lower() == 'elementja' then
		if state.Element.value == 'Fire' then
			send_command('@input /ma "Firaja" <t>')
		elseif state.Element.value == 'Blizzard' then
			send_command('@input /ma "Blizzaja" <t>')
		elseif state.Element.value == 'Thunder' then
			send_command('@input /ma "Thundaja" <t>')
		else
			send_command('@input /ma "'..state.Element.value..'ja" <t>')
		end
	end
	if cmdParams[1]:lower() == 'elementga1' then
		if state.Element.value == 'Fire' then
			send_command('@input /ma "Firaga" <t>')
		elseif state.Element.value == 'Blizzard' then
			send_command('@input /ma "Blizzaga" <t>')
		elseif state.Element.value == 'Thunder' then
			send_command('@input /ma "Thundaga" <t>')
		else
			send_command('@input /ma "'..state.Element.value..'ga" <t>')
		end
	end
	if cmdParams[1]:lower() == 'elementga2' then
		if state.Element.value == 'Fire' then
			send_command('@input /ma "Firaga II" <t>')
		elseif state.Element.value == 'Blizzard' then
			send_command('@input /ma "Blizzaga II" <t>')
		elseif state.Element.value == 'Thunder' then
			send_command('@input /ma "Thundaga II" <t>')
		else
			send_command('@input /ma "'..state.Element.value..'ga II" <t>')
		end
	end
	if cmdParams[1]:lower() == 'elementga3' then
		if state.Element.value == 'Fire' then
			send_command('@input /ma "Firaga III" <t>')
		elseif state.Element.value == 'Blizzard' then
			send_command('@input /ma "Blizzaga III" <t>')
		elseif state.Element.value == 'Thunder' then
			send_command('@input /ma "Thundaga III" <t>')
		else
			send_command('@input /ma "'..state.Element.value..'ga III" <t>')
		end
	end
	if cmdParams[1]:lower() == 'elementam1' then
		if state.Element.value == 'Fire' then
			send_command('@input /ma "Flare" <t>')
		elseif state.Element.value == 'Blizzard' then
			send_command('@input /ma "Freeze" <t>')
		elseif state.Element.value == 'Aero' then
			send_command('@input /ma "Tornado" <t>')
		elseif state.Element.value == 'Stone' then
			send_command('@input /ma "Quake" <t>')
		elseif state.Element.value == 'Thunder' then
			send_command('@input /ma "Burst" <t>')
		elseif state.Element.value == 'Water' then
			send_command('@input /ma "Flood" <t>')
		end
	end
	if cmdParams[1]:lower() == 'elementam2' then
		if state.Element.value == 'Fire' then
			send_command('@input /ma "Flare II" <t>')
		elseif state.Element.value == 'Blizzard' then
			send_command('@input /ma "Freeze II" <t>')
		elseif state.Element.value == 'Aero' then
			send_command('@input /ma "Tornado II" <t>')
		elseif state.Element.value == 'Stone' then
			send_command('@input /ma "Quake II" <t>')
		elseif state.Element.value == 'Thunder' then
			send_command('@input /ma "Burst II" <t>')
		elseif state.Element.value == 'Water' then
			send_command('@input /ma "Flood II" <t>')
		end
	end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

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

function update_sublimation()
    state.Buff['Sublimation: Activated'] = buffactive['Sublimation: Activated'] or false
end

function refine_various_spells(spell, action, spellMap, eventArgs)
    local newSpell = spell.english
    local spell_recasts = windower.ffxi.get_spell_recasts()
    local cancelling = 'All '..spell.english..' are on cooldown. Cancelling.'

    local spell_index

    if spell_recasts[spell.recast_id] > 0 then
        if spell.name:startswith('Aspir') then
            spell_index = table.find(degrade_array['Aspirs'],spell.name)
            if spell_index > 1 then
                newSpell = degrade_array['Aspirs'][spell_index - 1]
                send_command('@input /ma '..newSpell..' '..tostring(spell.target.raw))
                eventArgs.cancel = true
            end
        end
    end
end

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
    set_macro_page(1, 15)
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end
