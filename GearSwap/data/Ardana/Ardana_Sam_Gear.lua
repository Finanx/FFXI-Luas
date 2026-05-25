-- Setup vars that are user-dependent.
function user_job_setup()
    state.OffenseMode:options('Normal', 'Acc', 'Subtle_Blow')
    state.HybridMode:options('Normal','DT','Defense')
    state.WeaponskillMode:options('Normal','ATKCAP')
    state.RangedMode:options('Normal', 'Acc')
    state.IdleMode:options('Normal')
	state.Weapons:options('Dojikiri', 'Kusanagi', 'Masamune', 'Shining_One', 'Hachimonji', 'Soboro', 'Malevolance')
	
	Two_Handed_Weapons = {
		Dojikiri   	= true,
		Kusanagi    = true,
		Masamune 	= true,
		Shining_One = true,
		Hachimonji 	= true,
		Malevolance 		= true,}
	
	One_Handed_Weapons = {
		Malevolance 		= true,}
		
	state.Reraise = M(false, "Reraise Mode")
	
	init_job_states({},{"Weapons","OffenseMode","WeaponskillMode","IdleMode","Reraise","TreasureMode",})

	--Includes Global Bind keys
	
	send_command('wait 2; exec Global-Binds.txt')
	
	--Samurai Binds
	
	send_command('wait 2; exec /SAM/Binds.txt')

	--Job Settings
	
	lockstyleset = 12
    select_default_macro_book()
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
    
    -- Precast Sets
    -- Precast sets to enhance JAs
    sets.precast.JA.Meditate = {
		head="Wakido Kabuto +4",
		hands="Sakonji Kote +3",
		back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
    sets.precast.JA['Warding Circle'] = {head="Wakido Kabuto +4"}
    sets.precast.JA['Blade Bash'] = {hands="Sakonji Kote +3"}
	sets.precast.JA['Sekkanoki'] = {}
	sets.precast.JA['Sengikori'] = {}
	
    sets.precast.Step = {}
	
    sets.precast.JA['Violent Flourish'] = {}

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

    -- Fast cast sets for spells
    sets.precast.FC = {}
	   
    -- Ranged snapshot gear
    sets.precast.RA = {
		range="Trollbane",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs="Volte Tights",
		feet="Volte Spats",
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Yemaya Belt",
		left_ear="Genmei Earring",
		right_ear="Sanare Earring",
		left_ring="Defending Ring",
		right_ring="Archon Ring",
		back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {
		ammo="Knobkierrie",
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Kasuga Kote +3",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Thrud Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Sroda Ring",
		back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS.ATKCAP = {
		ammo="Crepuscular Pebble",
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Kasuga Kote +3",
		legs={ name="Mpaca's Hose", augments={'Path: A',}},
		feet="Kas. Sune-Ate +3",
		neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Thrud Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Sroda Ring",
		back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS.FullTPMagical = {left_ear="Hecate's Earring"}
	sets.precast.WS.FullTPPhysical = {left_ear={ name="Lugra Earring +1", augments={'Path: A',}},}
		
	sets.precast.WS['Tachi: Shoha'] = {
		ammo="Knobkierrie",
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Thrud Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Niqmaddu Ring",
		back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Tachi: Shoha'].ATKCAP = {
		ammo="Crepuscular Pebble",
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Mpaca's Hose", augments={'Path: A',}},
		feet="Kas. Sune-Ate +3",
		neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Thrud Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Sroda Ring",
		back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Tachi: Rana'] = {
		ammo="Knobkierrie",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Kasuga Kote +3",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		right_ear="Thrud Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Sroda Ring",
		back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Tachi: Rana'].ATKCAP = {
		ammo="Crepuscular Pebble",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Kasuga Kote +3",
		legs={ name="Mpaca's Hose", augments={'Path: A',}},
		feet="Kas. Sune-Ate +3",
		neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		right_ear="Thrud Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Sroda Ring",
		back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Impulse Drive'] = {
		ammo="Knobkierrie",
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Kasuga Kote +3",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},"Thrud Earring",
		right_ear="Thrud Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Sroda Ring",
		back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Impulse Drive'].ATKCAP = {
		ammo="Crepuscular Pebble",
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Kasuga Kote +3",
		legs={ name="Mpaca's Hose", augments={'Path: A',}},
		feet="Kas. Sune-Ate +3",
		neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},"Thrud Earring",
		right_ear="Thrud Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Sroda Ring",
		back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Sonic Thrust'] = sets.precast.WS['Impulse Drive']
	
	sets.precast.WS['Stardiver'] = {
	    ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body="Mpaca's Doublet",
		hands="Mpaca's Gloves",
		legs={ name="Mpaca's Hose", augments={'Path: A',}},
		feet="Mpaca's Boots",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear={ name="Schere Earring", augments={'Path: A',}},
		left_ring="Niqmaddu Ring",
		right_ring="Regal Ring",
		back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Stardiver'].ATKCAP = {
	    ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body="Mpaca's Doublet",
		hands="Mpaca's Gloves",
		legs={ name="Mpaca's Hose", augments={'Path: A',}},
		feet="Kas. Sune-Ate +3",
		neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
		waist="Fotia Belt",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear={ name="Schere Earring", augments={'Path: A',}},
		left_ring="Niqmaddu Ring",
		right_ring="Sroda Ring",
		back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.

    sets.precast.WS['Tachi: Ageha'] = {
		ammo="Pemphredo Tathlum",
		head="Kasuga Kabuto +3",
		body="Kasuga Domaru +3",
		hands="Kasuga Kote +3",
		legs="Kasuga Haidate +3",
		feet="Kas. Sune-Ate +3",
		neck="Sanctity Necklace",
		waist="Eschan Stone",
		left_ear="Crep. Earring",
		right_ear={ name="Kasuga Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+14','Mag. Acc.+14','Weapon skill damage +3%',}},
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
		neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
		waist="Orpheus's Sash",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},"Friomisi Earring",
		right_ear="Friomisi Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Niqmaddu Ring",
		back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Tachi: Goten'] = sets.precast.WS['Tachi: Jinpu']
	sets.precast.WS['Tachi: Kagero'] = sets.precast.WS['Tachi: Jinpu']
	sets.precast.WS['Tachi: Koki'] = sets.precast.WS['Tachi: Jinpu']
	
    sets.precast.WS['Aeolian Edge'] = {
		ammo="Knobkierrie",
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
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}	

	-- Swap to these on Moonshade using WS if at 3000 TP
	sets.MaxTP = {ear1="Thrud Earring",ear2="Lugra Earring +1",}
	sets.AccMaxTP = {ear1="Mache Earring +1",ear2="Telos Earring"}
	sets.AccDayMaxTPWSEars = {ear1="Mache Earring +1",ear2="Telos Earring"}
	sets.DayMaxTPWSEars = {ear1="Thrud Earring",ear2="Brutal Earring",}
	sets.AccDayWSEars = {ear1="Mache Earring +1",ear2="Telos Earring"}
	sets.DayWSEars = {ear1="Thrud Earring",ear2="Moonshade Earring",}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC
		
    -- Specific spells
    sets.midcast.Utsusemi = set_combine(sets.midcast.FastRecast, {back="Mujin Mantle"})
	
		
    -- Ranged gear
    sets.midcast.RA = {
		range="Trollbane",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs="Volte Tights",
		feet="Volte Spats",
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Yemaya Belt",
		left_ear="Genmei Earring",
		right_ear="Sanare Earring",
		left_ring="Defending Ring",
		right_ring="Archon Ring",
		back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    sets.midcast.RA.Acc = {
		range="Trollbane",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs="Volte Tights",
		feet="Volte Spats",
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Yemaya Belt",
		left_ear="Genmei Earring",
		right_ear="Sanare Earring",
		left_ring="Defending Ring",
		right_ring="Archon Ring",
		back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    
    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------
    
    -- Resting sets
    sets.resting = {}
    

    -- Idle sets
	
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
		back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
	sets.DayIdle = {}
	sets.NightIdle = {}
    

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged = {
		ammo="Aurgelmir Orb +1",
		head="Kasuga Kabuto +3",
		body="Kasuga Domaru +3",
		hands={ name="Tatena. Gote +1", augments={'Path: A',}},
		legs="Kasuga Haidate +3",
		feet={ name="Ryuo Sune-Ate +1", augments={'HP+65','"Store TP"+5','"Subtle Blow"+8',}},
		neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
		waist="Sweordfaetels +1",
		left_ear="Dedition Earring",
		right_ear={ name="Kasuga Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+14','Mag. Acc.+14','Weapon skill damage +3%',}},
		left_ring="Niqmaddu Ring",
		right_ring="Chirich Ring +1",
		back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

	sets.engaged.Acc = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Kasuga Kabuto +3",
		body="Kasuga Domaru +3",
		hands={ name="Tatena. Gote +1", augments={'Path: A',}},
		legs="Kasuga Haidate +3",
		feet={ name="Tatena. Sune. +1", augments={'Path: A',}},
		neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
		waist="Ioskeha Belt +1",
		left_ear={ name="Schere Earring", augments={'Path: A',}},
		right_ear={ name="Kasuga Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+14','Mag. Acc.+14','Weapon skill damage +3%',}},
		left_ring="Niqmaddu Ring",
		right_ring="Chirich Ring +1",
		back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
	sets.engaged.Subtle_Blow = {
		ammo="Aurgelmir Orb +1",
		head="Kasuga Kabuto +3",
		body="Dagon Breast.",
		hands="Wakido Kote +4",
		legs={ name="Mpaca's Hose", augments={'Path: A',}},
		feet={ name="Ryuo Sune-Ate +1", augments={'HP+65','"Store TP"+5','"Subtle Blow"+8',}},
		neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
		waist="Sweordfaetels +1",
		left_ear={ name="Schere Earring", augments={'Path: A',}},
		right_ear={ name="Kasuga Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+14','Mag. Acc.+14','Weapon skill damage +3%',}},
		left_ring="Niqmaddu Ring",
		right_ring="Chirich Ring +1",
		back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
	sets.engaged.Hybrid = {
		head="Kasuga Kabuto +3",
		body="Kasuga Domaru +3",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs="Kasuga Haidate +3",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},}
		--46% DT + 6% PDT
	
	sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
	sets.engaged.Acc.DT = set_combine(sets.engaged.Acc, sets.engaged.Hybrid)

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------


	sets.Kiting = {right_ring="Shneddick Ring",}

	sets.Reraise = {head="Twilight Helm",body="Crepuscular Mail",}
	
	sets.TreasureHunter = {
		body="Volte Jupon",
		hands="Volte Bracers",
		waist="Chaac Belt",}
	
	sets.buff.Doom = set_combine(sets.buff.Doom, {neck="Nicander's Necklace", waist="Gishdubar Sash",})
	sets.buff.Sleep = {neck="Vim Torque +1"}


	-- Weapons sets
	sets.weapons.Dojikiri = {main="Dojikiri Yasutsuna",sub="Utu Grip"}
	sets.weapons.Kusanagi = {main="Kusanagi",sub="Utu Grip"}
	sets.weapons.Masamune = {main="Masamune",sub="Utu Grip"}
	sets.weapons.Shining_One = {main='Shining One',sub="Utu Grip"}
	sets.weapons.Hachimonji = {main="Hachimonji",sub="Utu Grip"}
	sets.weapons.Soboro = {main="Soboro Sukehiro",sub="Utu Grip"}
	
	--Bow Sets
	sets.Bow = {}
	
	--Offhand Sets
	sets.Malevolance = {sub="Utu Grip"}
	
	--Shield Sets
	sets.Shield = {sub="Regis"}
	
	-- Buff sets
	sets.Cure_Received = {hands="Buremte Gloves",waist="Gishdubar Sash",legs="Flamma Dirs +2"}



--[[
	sets.buff.Hasso = {hands="Wakido Kote +3"}
	sets.buff['Third Eye'] = {} --legs="Sakonji Haidate +3"
    sets.buff.Sekkanoki = {hands="Kasuga Kote +1"}
    sets.buff.Sengikori = {feet="Kas. Sune-Ate +1"}
    sets.buff['Meikyo Shisui'] = {feet="Sak. Sune-Ate +1"}]]
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
	set_macro_page(1, 12)
end

function user_job_lockstyle()
    send_command('input /lockstyleset ' .. lockstyleset)
end