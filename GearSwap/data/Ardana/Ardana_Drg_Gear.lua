-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_job_setup()
	-- Options: Override default values
    state.OffenseMode:options('Normal', 'Acc', 'Subtle_Blow')
    state.HybridMode:options('Normal', 'DT', 'Defense')
	state.WeaponskillMode:options('Normal', 'ATKCAP')
    state.IdleMode:options('Normal')
	state.Weapons:options('Gae_Buide', 'Trishula', 'Shining_One', 'Naegling')
	state.Subweapon = M{['description']='Sub Weapon Set', 'Kraken'}
	
	state.PetDT = M(false, "Pet DT")
	state.Reraise = M(false, "Reraise Mode")
	
	--Handles if the weapon from state.WeaponSet is 2 handed or not applies to engaged logic and dual wielded Weapons
	Two_Handed_Weapons = {
		Gae_Buide   = true,
		Trishula    = true,
		Shining_One = true,}

	One_Handed_Weapons = {
		Naegling = true,}

	
	--Includes Global Bind keys
	
	send_command('wait 2; exec Global-Binds.txt')
	
	--Warrior Binds
	
	send_command('wait 2; exec /DRG/Binds.txt')
	
	--Retrieve Gear for Dragoon
	
	send_command('wait 3;org get inventory drg.lua')
	send_command('wait 4;get Angon all')
	

	lockstyleset = 14
    select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
	enable('main','sub','range','ammo','head','body','hands','legs','feet','neck','waist','left_ear','right_ear','left_ring','right_ring','back')

	--Remove Global Binds

	send_command('wait 1; exec Global-UnBinds.txt')
	
	--Remove Gear for Warrior
	
	send_command('wait 1; org get Store.lua')
	send_command('put Angon satchel all')
	
end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
	
	sets.precast.JA['Angon'] = set_combine(idleSet, {ammo="Angon", hands="Ptero. Fin. G. +3",})
	
	sets.precast.JA['Call Wyvern'] = set_combine(idleSet, {body="Ptero. Mail +3",})
	sets.precast.JA['Spirit Link'] = set_combine(idleSet, {hands="Pel. Vambraces +3", feet="Ptero. Greaves +3",})
	sets.precast.JA['Ancient Circle'] = set_combine(idleSet, {legs="Vishap Brais +3",})
	sets.precast.JA['Deep Breathing'] = {head="Ptero. Armet +3"}
	sets.precast.JA['Spirit Surge'] = set_combine(idleSet, {body="Ptero. Mail +3",})
	sets.precast.JA['Steady Wing'] = {}

	sets.precast.JA['Jump'] = {
	    ammo="Aurgelmir Orb +1",
		head="Flam. Zucchetto +2",
		body="Vishap Mail +3",
		hands="Vis. Fng. Gaunt. +3",
		legs="Ptero. Brais +3",
		feet="Ostro Greaves",
		neck="Vim Torque +1",
		waist="Sailfi Belt +1",
		left_ear="Sherida Earring",
		right_ear="Telos Earring",
		left_ring="Niqmaddu Ring",
		right_ring={ name="Chirich Ring +1", bag="wardrobe8" },
		back={ name="Brigantia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
	
	sets.precast.JA['High Jump'] = sets.precast.JA['Jump']
	sets.precast.JA['Super Jump'] = sets.precast.JA['Jump']
	sets.precast.JA['Soul Jump'] = sets.precast.JA['Jump']
	sets.precast.JA['Spirit Jump'] = set_combine(sets.precast.JA['Jump'], {feet="Pelt. Schyn. +3",})
	
	-- Breath sets
	sets.precast.JA['Restoring Breath'] = {back="Brigantia's Mantle"}
	sets.precast.JA['Smiting Breath'] = {back="Brigantia's Mantle"}
	sets.HealingBreath = {back="Brigantia's Mantle"}
	--sets.SmitingBreath = {back="Brigantia's Mantle"}

	-- Fast cast sets for spells
	
	sets.precast.FC = {}
	
	-- Waltz set (chr and vit)
	sets.precast.Waltz = {legs="Dashing Subligar",}
		
	-- Don't need any special gear for Healing Waltz.
	sets.precast.Waltz['Healing Waltz'] = {legs="Dashing Subligar",}
	
	sets.precast.RA = {}
	
		--Set used for Icarus Wing to maximize TP gain
	sets.precast.Wing = {}
	
	sets.precast.Volte_Harness = set_combine(sets.precast.Wing, {body="Volte Harness"})
	sets.precast.Prishes_Boots = {feet="Prishe\'s Boots +1",}

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

	--Generic Weapon Skill

	sets.precast.WS = {    
		ammo="Knobkierrie",
		head="Peltast's Mezail +3",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck={ name="Dgn. Collar +2", augments={'Path: A',}},
		waist="Sailfi Belt +1",
		left_ear="Moonshade Earring",
		right_ear="Thrud Earring",
		left_ring="Ephramad's Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Brigantia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS.ATKCAP = {    
		ammo="Knobkierrie",
		head="Peltast's Mezail +3",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck={ name="Dgn. Collar +2", augments={'Path: A',}},
		waist="Sailfi Belt +1",
		left_ear="Moonshade Earring",
		right_ear="Thrud Earring",
		left_ring="Ephramad's Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Brigantia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	--TP Overflow set
	sets.precast.WS.FullTP = {left_ear={ name="Lugra Earring +1", augments={'Path: A',}},}

	--Sword Weapon Skills

	sets.precast.WS['Savage Blade'] = {    
		ammo="Knobkierrie",
		head="Peltast's Mezail +3",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck={ name="Dgn. Collar +2", augments={'Path: A',}},
		waist="Sailfi Belt +1",
		left_ear="Moonshade Earring",
		right_ear="Thrud Earring",
		left_ring="Ephramad's Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Brigantia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Savage Blade'].ATKCAP = {    
		ammo="Knobkierrie",
		head="Peltast's Mezail +3",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck={ name="Dgn. Collar +2", augments={'Path: A',}},
		waist="Sailfi Belt +1",
		left_ear="Moonshade Earring",
		right_ear="Thrud Earring",
		left_ring="Ephramad's Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Brigantia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
	
	--Polearm Weapon Skills

	sets.precast.WS['Impulse Drive'] = {    
		ammo="Coiste Bodhar",
		head="Blistering Sallet +1",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck={ name="Dgn. Collar +2", augments={'Path: A',}},
		waist="Sailfi Belt +1",
		left_ear="Moonshade Earring",
		right_ear="Sherida Earring",
		left_ring="Ephramad's Ring",
		right_ring="Epaminondas's Ring",
		back="Null Shawl",}
		
	sets.precast.WS['Impulse Drive'].ATKCAP = {    
		ammo="Knobkierrie",
		head="Peltast's Mezail +3",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck={ name="Dgn. Collar +2", augments={'Path: A',}},
		waist="Sailfi Belt +1",
		left_ear="Moonshade Earring",
		right_ear="Thrud Earring",
		left_ring="Ephramad's Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Brigantia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
	
	sets.precast.WS['Stardiver'] = {    
		ammo="Knobkierrie",
		head="Peltast's Mezail +3",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck={ name="Dgn. Collar +2", augments={'Path: A',}},
		waist="Sailfi Belt +1",
		left_ear="Moonshade Earring",
		right_ear="Thrud Earring",
		left_ring="Ephramad's Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Brigantia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Stardiver'].ATKCAP = {    
		ammo="Knobkierrie",
		head="Peltast's Mezail +3",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck={ name="Dgn. Collar +2", augments={'Path: A',}},
		waist="Sailfi Belt +1",
		left_ear="Moonshade Earring",
		right_ear="Thrud Earring",
		left_ring="Ephramad's Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Brigantia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

	
	-- Swap to these on Moonshade using WS if at 3000 TP
	sets.MaxTP = {ear1="Lugra Earring +1",ear2="Sherida Earring",}
	sets.AccMaxTP = {ear1="Mache Earring +1",ear2="Telos Earring"}
	sets.AccDayMaxTPWSEars = {ear1="Mache Earring +1",ear2="Telos Earring"}
	sets.DayMaxTPWSEars = {ear1="Brutal Earring",ear2="Sherida Earring",}
	sets.AccDayWSEars = {ear1="Mache Earring +1",ear2="Telos Earring"}
	sets.DayWSEars = {ear1="Moonshade Earring",ear2="Sherida Earring",}
	
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------	
	
	sets.midcast.Cure = {}
	
	sets.Self_Healing = {hands="Buremte Gloves",ring2="Kunaji Ring",waist="Gishdubar Sash"}
	sets.Cure_Received = {hands="Buremte Gloves",ring2="Kunaji Ring",waist="Gishdubar Sash"}
	sets.Self_Refresh = {waist="Gishdubar Sash"}
	
	-- Midcast Sets
	sets.midcast.FastRecast = sets.precast.FC
	
	sets.midcast.Utsusemi = sets.precast.FC
		
	-- Put HP+ gear and the AF head to make healing breath trigger more easily with this set.
	sets.midcast.HB_Trigger = set_combine(sets.midcast.FastRecast, {head="Vishap Armet +1"})
	
    -- Ranged gear
	
    sets.midcast.RA = {}
	
    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.resting = {
	    ammo="Vanir Battery",
		head="Null Masque",
		body="Adamantite Armor",
		hands="Gleti's Gauntlets",
		legs="Ptero. Brais +3",
		feet="Gleti's Boots",
		neck={ name="Dgn. Collar +2", augments={'Path: A',}},
		waist="Flume Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Enmerkar Earring",
		left_ring={ name="Moonlight Ring", bag="wardrobe7" },
		right_ring="Murky Ring",
		back="Null Shawl",}

    sets.idle = {
	    ammo="Vanir Battery",
		head="Null Masque",
		body="Adamantite Armor",
		hands="Gleti's Gauntlets",
		legs="Ptero. Brais +3",
		feet="Gleti's Boots",
		neck={ name="Dgn. Collar +2", augments={'Path: A',}},
		waist="Flume Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Enmerkar Earring",
		left_ring={ name="Moonlight Ring", bag="wardrobe7" },
		right_ring="Murky Ring",
		back="Null Shawl",}

	------------------------------------------------------------------------------------------------
	-----------------------------------------Single Wield Sets--------------------------------------
	------------------------------------------------------------------------------------------------

    sets.engaged = {
	    ammo="Coiste Bodhar",
		head="Hjarrandi Helm",
		body="Gleti's Cuirass",
		hands="Pel. Vambraces +3",
		legs="Volte Tights",
		feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
		neck="Vim Torque +1",
		waist="Ioskeha Belt +1",
		left_ear="Sherida Earring",
		right_ear="Sroda Earring",
		left_ring={ name="Chirich Ring +1", bag="wardrobe7" },
		right_ring={ name="Chirich Ring +1", bag="wardrobe8" },
		back="Null Shawl",}

    sets.engaged.Acc = sets.engaged
	
    sets.engaged.DT = {
	    ammo="Coiste Bodhar",
		head="Hjarrandi Helm",
		body="Gleti's Cuirass",
		hands="Pel. Vambraces +3",
		legs="Gleti's Breeches",
		feet="Flam. Gambieras +2",
		neck="Vim Torque +1",
		waist="Ioskeha Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Sherida Earring",
		left_ring={ name="Moonlight Ring", bag="wardrobe7" },
		right_ring={ name="Moonlight Ring", bag="wardrobe8" },
		back="Null Shawl",}
		
    sets.engaged.Acc.DT = sets.engaged.DT
	
    sets.engaged.Defense = {
		ammo="Coiste Bodhar",
		head="Hjarrandi Helm",
		body="Gleti's Cuirass",
		hands="Pel. Vambraces +3",
		legs="Gleti's Breeches",
		feet="Nyame Sollerets",
		neck="Vim Torque +1",
		waist="Ioskeha Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Sherida Earring",
		left_ring="Petrov Ring",
		right_ring={ name="Moonlight Ring", bag="wardrobe8" },
		back="Null Shawl",}
		
    sets.engaged.Acc.Defense = sets.engaged.Defense
	
	------------------------------------------Pet DT Sets-------------------------------------------
	
    sets.engaged.PetDT = {
	    ammo="Coiste Bodhar",
		head="Hjarrandi Helm",
		body="Gleti's Cuirass",
		hands="Pel. Vambraces +3",
		legs="Volte Tights",
		feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
		neck={ name="Dgn. Collar +2", augments={'Path: A',}},
		waist="Ioskeha Belt +1",
		left_ear="Sherida Earring",
		right_ear="Sroda Earring",
		left_ring={ name="Chirich Ring +1", bag="wardrobe7" },
		right_ring={ name="Chirich Ring +1", bag="wardrobe8" },
		back="Null Shawl",}

    sets.engaged.PetDT.Acc = sets.engaged.PetDT
	
    sets.engaged.PetDT.DT = {
	    ammo="Coiste Bodhar",
		head="Hjarrandi Helm",
		body="Gleti's Cuirass",
		hands="Pel. Vambraces +3",
		legs="Gleti's Breeches",
		feet="Flam. Gambieras +2",
		neck={ name="Dgn. Collar +2", augments={'Path: A',}},
		waist="Ioskeha Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Sherida Earring",
		left_ring={ name="Moonlight Ring", bag="wardrobe7" },
		right_ring={ name="Moonlight Ring", bag="wardrobe8" },
		back="Null Shawl",}
		
    sets.engaged.PetDT.Acc.DT = sets.engaged.PetDT.DT
	
    sets.engaged.PetDT.Defense = {
		ammo="Coiste Bodhar",
		head="Hjarrandi Helm",
		body="Gleti's Cuirass",
		hands="Pel. Vambraces +3",
		legs="Gleti's Breeches",
		feet="Nyame Sollerets",
		neck={ name="Dgn. Collar +2", augments={'Path: A',}},
		waist="Ioskeha Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Sherida Earring",
		left_ring="Petrov Ring",
		right_ring={ name="Moonlight Ring", bag="wardrobe8" },
		back="Null Shawl",}
		
    sets.engaged.PetDT.Acc.Defense = sets.engaged.PetDT.Defense
	
	------------------------------------------------------------------------------------------------
	-----------------------------------------Dual Wield Sets----------------------------------------
	------------------------------------------------------------------------------------------------

    sets.engaged.DW = {
	    ammo="Vanir Battery",
		head="Null Masque",
		body="Adamantite Armor",
		hands="Gleti's Gauntlets",
		legs="Ptero. Brais +3",
		feet="Gleti's Boots",
		neck="Vim Torque +1",
		waist="Flume Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Enmerkar Earring",
		left_ring={ name="Moonlight Ring", bag="wardrobe7" },
		right_ring="Murky Ring",
		back="Null Shawl",}

    sets.engaged.DW.Acc = {}
	
    sets.engaged.DW.DT = {
	    ammo="Vanir Battery",
		head="Null Masque",
		body="Adamantite Armor",
		hands="Gleti's Gauntlets",
		legs="Ptero. Brais +3",
		feet="Gleti's Boots",
		neck="Vim Torque +1",
		waist="Flume Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Enmerkar Earring",
		left_ring={ name="Moonlight Ring", bag="wardrobe7" },
		right_ring="Murky Ring",
		back="Null Shawl",}
	
    sets.engaged.DW.Acc.DT = sets.engaged.DW.DT
	
    sets.engaged.DW.Defense = {
	    ammo="Vanir Battery",
		head="Null Masque",
		body="Adamantite Armor",
		hands="Gleti's Gauntlets",
		legs="Ptero. Brais +3",
		feet="Gleti's Boots",
		neck="Vim Torque +1",
		waist="Flume Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Enmerkar Earring",
		left_ring={ name="Moonlight Ring", bag="wardrobe7" },
		right_ring="Murky Ring",
		back="Null Shawl",}
	
    sets.engaged.DW.Acc.Defense = sets.engaged.DW.Defense
	
	------------------------------------------Pet DT Sets-------------------------------------------
	
    sets.engaged.DW_PetDT = {
	    ammo="Vanir Battery",
		head="Null Masque",
		body="Adamantite Armor",
		hands="Gleti's Gauntlets",
		legs="Ptero. Brais +3",
		feet="Gleti's Boots",
		neck={ name="Dgn. Collar +2", augments={'Path: A',}},
		waist="Flume Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Enmerkar Earring",
		left_ring={ name="Moonlight Ring", bag="wardrobe7" },
		right_ring="Murky Ring",
		back="Null Shawl",}

    sets.engaged.DW_PetDT.Acc = sets.engaged.DW_PetDT
	
    sets.engaged.DW_PetDT.DT = {
	    ammo="Vanir Battery",
		head="Null Masque",
		body="Adamantite Armor",
		hands="Gleti's Gauntlets",
		legs="Ptero. Brais +3",
		feet="Gleti's Boots",
		neck={ name="Dgn. Collar +2", augments={'Path: A',}},
		waist="Flume Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Enmerkar Earring",
		left_ring={ name="Moonlight Ring", bag="wardrobe7" },
		right_ring="Murky Ring",
		back="Null Shawl",}
	
    sets.engaged.DW_PetDT.Acc.DT = sets.engaged.DW_PetDT.DT
	
    sets.engaged.DW_PetDT.Defense = {
	    ammo="Vanir Battery",
		head="Null Masque",
		body="Adamantite Armor",
		hands="Gleti's Gauntlets",
		legs="Ptero. Brais +3",
		feet="Gleti's Boots",
		neck={ name="Dgn. Collar +2", augments={'Path: A',}},
		waist="Flume Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Enmerkar Earring",
		left_ring={ name="Moonlight Ring", bag="wardrobe7" },
		right_ring="Murky Ring",
		back="Null Shawl",}
	
    sets.engaged.DW_PetDT.Acc.Defense = sets.engaged.DW_PetDT.Defense
		
	------------------------------------------------------------------------------------------------
	-----------------------------------------Two-Handed Sets----------------------------------------
	------------------------------------------------------------------------------------------------
	
    sets.engaged.Two_Handed = {
		ammo="Coiste Bodhar",
		head="Hjarrandi Helm",
		body="Gleti's Cuirass",
		hands="Pel. Vambraces +3",
		legs="Gleti's Breeches",
		feet="Flam. Gambieras +2",
		neck="Vim Torque +1",
		waist="Ioskeha Belt +1",
		left_ear="Dedition Earring",
		right_ear="Sherida Earring",
		left_ring="Petrov Ring",
		right_ring={ name="Moonlight Ring", bag="wardrobe8" },
		back="Null Shawl",}
		
    sets.engaged.Two_Handed.Acc = sets.engaged.Two_Handed
	
    sets.engaged.Two_Handed.DT = {
		ammo="Coiste Bodhar",
		head="Hjarrandi Helm",
		body="Gleti's Cuirass",
		hands="Pel. Vambraces +3",
		legs="Gleti's Breeches",
		feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
		neck="Vim Torque +1",
		waist="Ioskeha Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Sherida Earring",
		left_ring={ name="Moonlight Ring", bag="wardrobe7" },
		right_ring={ name="Moonlight Ring", bag="wardrobe8" },
		back="Null Shawl",}
	
    sets.engaged.Two_Handed.Acc.DT = sets.engaged.Two_Handed.DT
	
    sets.engaged.Two_Handed.Defense = {
		ammo="Coiste Bodhar",
		head="Hjarrandi Helm",
		body="Gleti's Cuirass",
		hands="Pel. Vambraces +3",
		legs="Gleti's Breeches",
		feet="Nyame Sollerets",
		neck="Vim Torque +1",
		waist="Ioskeha Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Sherida Earring",
		left_ring={ name="Chirich Ring +1", bag="wardrobe7" },
		right_ring={ name="Moonlight Ring", bag="wardrobe8" },
		back="Null Shawl",}
	
    sets.engaged.Two_Handed.Acc.Defense = sets.engaged.Two_Handed.Defense
	
	------------------------------------------Pet DT Sets-------------------------------------------
	
    sets.engaged.Two_Handed_PetDT = {
		ammo="Coiste Bodhar",
		head="Hjarrandi Helm",
		body="Gleti's Cuirass",
		hands="Pel. Vambraces +3",
		legs="Gleti's Breeches",
		feet="Flam. Gambieras +2",
		neck={ name="Dgn. Collar +2", augments={'Path: A',}},
		waist="Ioskeha Belt +1",
		left_ear="Dedition Earring",
		right_ear="Sherida Earring",
		left_ring="Petrov Ring",
		right_ring={ name="Moonlight Ring", bag="wardrobe8" },
		back="Null Shawl",}

    sets.engaged.Two_Handed_PetDT.Acc = sets.engaged.Two_Handed_PetDT
	
    sets.engaged.Two_Handed_PetDT.DT = {
		ammo="Coiste Bodhar",
		head="Hjarrandi Helm",
		body="Gleti's Cuirass",
		hands="Pel. Vambraces +3",
		legs="Gleti's Breeches",
		feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
		neck={ name="Dgn. Collar +2", augments={'Path: A',}},
		waist="Ioskeha Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Sherida Earring",
		left_ring={ name="Moonlight Ring", bag="wardrobe7" },
		right_ring={ name="Moonlight Ring", bag="wardrobe8" },
		back="Null Shawl",}
	
    sets.engaged.Two_Handed_PetDT.Acc.DT = sets.engaged.Two_Handed_PetDT.DT
	
    sets.engaged.Two_Handed_PetDT.Defense = {
		ammo="Coiste Bodhar",
		head="Hjarrandi Helm",
		body="Gleti's Cuirass",
		hands="Pel. Vambraces +3",
		legs="Gleti's Breeches",
		feet="Nyame Sollerets",
		neck={ name="Dgn. Collar +2", augments={'Path: A',}},
		waist="Ioskeha Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Sherida Earring",
		left_ring={ name="Chirich Ring +1", bag="wardrobe7" },
		right_ring={ name="Moonlight Ring", bag="wardrobe8" },
		back="Null Shawl",}
	
    sets.engaged.Two_Handed_PetDT.Acc.Defense = sets.engaged.Two_Handed_PetDT.Defense
		
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	sets.Kiting = {left_ring="Shneddick Ring",}
	
    sets.TreasureHunter = {
		ammo="Per. Lucky Egg", --TH1
		body="Volte Jupon",		--TH2
		waist="Chaac Belt",} --TH+1
		
	sets.Reraise = {head="Crepuscular Helm",body="Crepuscular Mail",}
	
	sets.buff.Doom = set_combine(sets.buff.Doom, {neck="Nicander's Necklace",waist="Gishdubar Sash",})
	
	--Weaponsets

	sets.weapons.Gae_Buide = {main="Gae Buide", sub="Utu Grip"}
	sets.weapons.Trishula = {main="Shining One", sub="Utu Grip"}
	sets.weapons.Shining_One = {main="Shining One", sub="Utu Grip"}
	sets.weapons.Naegling = {main="Naegling",}
	
	sets.shield = {sub="Regis",}
	
	sets.Kraken = {sub="Excalipoor II",}
	
	

end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 14)
end

function user_job_lockstyle()
    send_command('input /lockstyleset ' .. lockstyleset)
end