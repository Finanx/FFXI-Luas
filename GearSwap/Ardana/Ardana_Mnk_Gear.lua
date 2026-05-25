function user_job_setup()
	-- Options: Override default values
    state.OffenseMode:options('Normal','Subtle_Blow')
    state.WeaponskillMode:options('Normal','ATKCAP')
    state.HybridMode:options('Normal', 'DT', 'Defense')
	state.Weapons:options('Karambit', 'Godhands', 'Verethragna', 'Xoanon',
							'ProcH2H','ProcClub','ProcStaff')
							
	state.WeaponSets:options('Default','Proc')

	weapon_sets = {
		['Default'] = {'Karambit', 'Verethragna', 'Godhands', 'Xoanon',},
		['Proc'] = {'ProcH2H','ProcClub','ProcStaff'},
	}

    update_melee_groups()
	
	init_job_states({},{"Weapons","OffenseMode","WeaponskillMode","IdleMode","TreasureMode","Reraise",})

	--Includes Global Bind keys
	
	send_command('wait 2; exec Global-Binds.txt')
	
	--Monk Binds
	
	send_command('wait 2; exec /MNK/Binds.txt')
	
	--Retrieve Gear for Monk
	
	send_command('wait 3;org get inventory mnk.lua')	
	
	--Job Settings
	
	lockstyleset = 2
	select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
	enable('main','sub','range','ammo','head','body','hands','legs','feet','neck','waist','left_ear','right_ear','left_ring','right_ring','back')

	--Remove Global Binds

	send_command('wait 1; exec Global-UnBinds.txt')
	
	--Remove Gear for Warrior
	
	send_command('wait 1; org get Store.lua')
	
end

function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
	
	-- Precast sets to enhance JAs on use
	sets.precast.JA['Hundred Fists'] = {legs="Hesychast's Hose +3"}
	sets.precast.JA['Boost'] = {hands="Anchorite's Gloves +3"}
	sets.precast.JA['Boost'].OutOfCombat = {hands="Anchorite's Gloves +1",}
	sets.precast.JA['Dodge'] = {feet="Anchorite's Gaiters +3"}
	sets.precast.JA['Focus'] = {head="Anchorite's Crown +3"}
	sets.precast.JA['Counterstance'] = {feet="Hesychast's Gaiters +3"}
	sets.precast.JA['Footwork'] = {feet="Anchorite's Gaiters +3"}
	sets.precast.JA['Formless Strikes'] = {body="Hesychast's Cyclas +3"}
	sets.precast.JA['Mantra'] = {feet="Hesychast's Gaiters +3"}

	sets.precast.JA['Chi Blast'] = {}
	
	sets.precast.JA['Chakra'] = {}

	-- Waltz set (chr and vit)
	sets.precast.Waltz = {}
	
	-- Don't need any special gear for Healing Waltz.
	sets.precast.Waltz['Healing Waltz'] = {}

	sets.precast.Step = {}
		
	sets.precast.Flourish1 = {}


	-- Fast cast sets for spells
	
	sets.precast.FC = {}

	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads",body="Passion Jacket"})

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Fotia Gorget",
		waist="Moonbow Belt +1",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear={ name="Schere Earring", augments={'Path: A',}},
		left_ring="Gere Ring",
		right_ring="epona Ring",
		back={ name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
    sets.precast.WS.ATKCAP = {
	    ammo="Crepuscular Pebble",
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Bhikku Gloves +2",
		legs={ name="Mpaca's Hose", augments={'Path: A',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Mnk. Nodowa +2", augments={'Path: A',}},
		waist="Moonbow Belt +1",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear={ name="Schere Earring", augments={'Path: A',}},
		left_ring="Gere Ring",
		right_ring="epona Ring",
		back={ name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
	
	sets.precast.WS.FullTPMagical = {left_ear="Hecate's Earring"}
	sets.precast.WS.FullTPPhysical = {left_ear="Sherida Earring",}
		
	sets.precast.WS["Victory Smite"] = {
		ammo="Coiste Bodhar",
		head="Mpaca's Cap",
		body="Bhikku Cyclas +2",
		hands="Bhikku Gloves +2",
		legs="Mpaca's Hose",
		feet="Ken. Sune-Ate +1",
		neck="Fotia Gorget",
		waist="Moonbow Belt +1",
		left_ear="Sherida Earring",
		right_ear="Odr Earring",
		left_ring="Gere Ring",
		right_ring="Shadow Ring",
		back={ name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
	sets.precast.WS["Victory Smite"].ATKCAP = {
		ammo="Crepuscular Pebble",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body={ name="Mpaca's Doublet", augments={'Path: A',}},
		hands="Bhikku Gloves +2",
		legs={ name="Mpaca's Hose", augments={'Path: A',}},
		feet="Ken. Sune-Ate +1",
		neck={ name="Mnk. Nodowa +2", augments={'Path: A',}},
		waist="Fotia Belt",
		left_ear="Sherida Earring",
		right_ear={ name="Schere Earring", augments={'Path: A',}},
		left_ring="Gere Ring",
		right_ring="epona Ring",
		back={ name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Crit.hit rate+10',}},}
		
	sets.precast.WS["Victory Smite"].Impetus = {}
		
	sets.precast.WS["Victory Smite"].ATKCAP.Impetus = {}
		
	sets.precast.WS['Tornado Kick'] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Anch. Gaiters +3",
		neck={ name="Mnk. Nodowa +2", augments={'Path: A',}},
		waist="Moonbow Belt +1",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear={ name="Schere Earring", augments={'Path: A',}},
		left_ring="Gere Ring",
		right_ring="epona Ring",
		back={ name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
	sets.precast.WS['Tornado Kick'].ATKCAP = {
		ammo="Crepuscular Pebble",
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Bhikku Gloves +2",
		legs={ name="Mpaca's Hose", augments={'Path: A',}},
		feet="Anch. Gaiters +3",
		neck={ name="Mnk. Nodowa +2", augments={'Path: A',}},
		waist="Moonbow Belt +1",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear={ name="Schere Earring", augments={'Path: A',}},
		left_ring="Gere Ring",
		right_ring="epona Ring",
		back={ name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
	sets.precast.WS['Tornado Kick'].Footwork = {}
		
	sets.precast.WS['Tornado Kick'].ATKCAP.Footwork = {}
		
	sets.precast.WS['Dragon Kick'] = {}
	sets.precast.WS['Dragon Kick'].ATKCAP = {}
	sets.precast.WS['Dragon Kick'].Footwork = {}
	sets.precast.WS['Dragon Kick'].ATKCAP.Footwork = {}
	
	sets.precast.WS['Raging Fists'] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body="Bhikku Cyclas +2",
		hands="Bhikku Gloves +2",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Mpaca's Boots",
		neck="Rep. Plat. Medal",
		waist="Moonbow Belt +1",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear={ name="Schere Earring", augments={'Path: A',}},
		left_ring="Gere Ring",
		right_ring="epona Ring",
		back={ name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
	
	sets.precast.WS["Raging Fists"].ATKCAP = {
	    ammo="Crepuscular Pebble",
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Bhikku Gloves +2",
		legs={ name="Mpaca's Hose", augments={'Path: A',}},
		feet="Ken. Sune-Ate +1",
		neck={ name="Mnk. Nodowa +2", augments={'Path: A',}},
		waist="Moonbow Belt +1",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear={ name="Schere Earring", augments={'Path: A',}},
		left_ring="Gere Ring",
		right_ring="epona Ring",
		back={ name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
	
	sets.precast.WS['Shijin Spiral'] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body="Bhikku Cyclas +2",
		hands="Bhikku Gloves +2",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Mpaca's Boots",
		neck="Fotia Gorget",
		waist="Moonbow Belt +1",
		left_ear="Sherida Earring",
		right_ear={ name="Schere Earring", augments={'Path: A',}},
		left_ring="Gere Ring",
		right_ring="epona Ring",
		back={ name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
	
	sets.precast.WS['Shijin Spiral'].ATKCAP = {
	    ammo="Crepuscular Pebble",
		head="Ken. Jinpachi +1",
		body="Bhikku Cyclas +2",
		hands="Bhikku Gloves +2",
		legs={ name="Mpaca's Hose", augments={'Path: A',}},
		feet="Ken. Sune-Ate +1",
		neck={ name="Mnk. Nodowa +2", augments={'Path: A',}},
		waist="Moonbow Belt +1",
		left_ear="Sherida Earring",
		right_ear={ name="Schere Earring", augments={'Path: A',}},
		left_ring="Gere Ring",
		right_ring="epona Ring",
		back={ name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
	
	sets.precast.WS['Howling Fist'] = {
		ammo="Coiste Bodhar",
		head="Mpaca's Cap",
		body="Nyame Mail",
		hands="Bhikku Gloves +2",
		legs="Mpaca's Hose",
		feet="Nyame Sollerets",
		neck="Rep. Plat. Medal",
		waist="Moonbow Belt +1",
		left_ear="Moonshade Earring",
		right_ear="Schere Earring",
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back={ name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
	
	sets.precast.WS['Howling Fist'].ATKCAP = {
		ammo="Coiste Bodhar",
		head="Mpaca's Cap",
		body="Nyame Mail",
		hands="Bhikku Gloves +2",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Rep. Plat. Medal",
		waist="Moonbow Belt +1",
		left_ear="Moonshade Earring",
		right_ear="Schere Earring",
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back={ name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
	
	sets.precast.WS['Asuran Fists'] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Hes. Crown +3", augments={'Enhances "Penance" effect',}},
		body="Bhikku Cyclas +2",
		hands="Bhikku Gloves +2",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Mpaca's Boots",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Sherida Earring",
		right_ear={ name="Schere Earring", augments={'Path: A',}},
		left_ring="Sroda Ring",
		right_ring="Ephramad's Ring",
		back={ name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Asuran Fists'].ATKCAP = {
		ammo="Crepuscular Pebble",
		head={ name="Hes. Crown +3", augments={'Enhances "Penance" effect',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Bhikku Gloves +2",
		legs={ name="Mpaca's Hose", augments={'Path: A',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Mnk. Nodowa +2", augments={'Path: A',}},
		waist="Fotia Belt",
		left_ear="Sherida Earring",
		right_ear={ name="Schere Earring", augments={'Path: A',}},
		left_ring="Sroda Ring",
		right_ring="Ephramad's Ring",
		back={ name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
	
	sets.precast.WS["Ascetic's Fury"] = {
		ammo="Crepuscular Pebble",
		head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
		body={ name="Mpaca's Doublet", augments={'Path: A',}},
		hands="Bhikku Gloves +2",
		legs={ name="Mpaca's Hose", augments={'Path: A',}},
		feet="Ken. Sune-Ate +1",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Sherida Earring",
		right_ear={ name="Schere Earring", augments={'Path: A',}},
		left_ring="Gere Ring",
		right_ring="epona Ring",
		back={ name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Crit.hit rate+10',}},}
		
	sets.precast.WS["Ascetic's Fury"].ATKCAP = {
		ammo="Crepuscular Pebble",
		head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
		body={ name="Mpaca's Doublet", augments={'Path: A',}},
		hands="Bhikku Gloves +2",
		legs={ name="Mpaca's Hose", augments={'Path: A',}},
		feet="Ken. Sune-Ate +1",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Sherida Earring",
		right_ear={ name="Schere Earring", augments={'Path: A',}},
		left_ring="Gere Ring",
		right_ring="epona Ring",
		back={ name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Crit.hit rate+10',}},}
		
	sets.precast.WS["Ascetic's Fury"].Impetus = {}
		
	sets.precast.WS["Ascetic's Fury"].ATKCAP.Impetus = {}
		
	sets.precast.WS["Cataclysm"] = {
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head="Pixie Hairpin +1",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Sibyl Scarf",
		waist="Orpheus's Sash",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Friomisi Earring",
		left_ring="Archon Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS["Earth Crusher"] = {
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
		left_ring="Shiva Ring +1",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
	
	-- Swap to these on Moonshade using WS if at 3000 TP
	sets.MaxTP = {ear1="Brutal Earring",ear2="Sherida Earring",}
	sets.AccMaxTP = {ear1="Mache Earring +1",ear2="Telos Earring"}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	sets.midcast.FastRecast = {}
		
	-- Specific spells
	sets.midcast.Utsusemi = set_combine(sets.midcast.FastRecast, {back="Mujin Mantle"})

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

	sets.resting = {
		ammo="Vanir Battery",
		head="Null Masque",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Loricate Torque +1",
		waist="Moonbow Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Hoxne Earring",
		left_ring="Shneddick Ring",
		right_ring="Shadow Ring",
		back="Null Shawl",}
	

	-- Idle sets
	sets.idle = {
	    ammo="Vanir Battery",
		head="Null Masque",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Loricate Torque +1",
		waist="Moonbow Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Hoxne Earring",
		left_ring="Shneddick Ring",
		right_ring="Shadow Ring",
		back="Null Shawl",}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	-- Normal melee sets
	sets.engaged = {
	    ammo="Coiste Bodhar",
		head={ name="Ryuo Somen +1", augments={'HP+65','"Store TP"+5','"Subtle Blow"+8',}},
		body="Bhikku Cyclas +2",
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs="Bhikku Hose +2",
		feet="Tatena. Sune. +1",
		neck={ name="Mnk. Nodowa +2", augments={'Path: A',}},
		waist="Moonbow Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Schere Earring",
		left_ring="Gere Ring",
		right_ring="Shadow Ring",
		back="Null Shawl",}
	
	sets.engaged.Subtle_Blow = {}
	
	sets.engaged.Counter = {}
	
	sets.engaged.Footwork = {}
	sets.engaged.Subtle_Blow.Footwork = {}
	sets.engaged.Counter.Footwork = {}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

	sets.engaged.DT = {
	    ammo="Coiste Bodhar",
		head="Mpaca's Cap",
		body="Bhikku Cyclas +2",
		hands="Malignance Gloves",
		legs="Bhikku Hose +2",
		feet="Malignance Boots",
		neck={ name="Mnk. Nodowa +2", augments={'Path: A',}},
		waist="Moonbow Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Schere Earring",
		left_ring="Gere Ring",
		right_ring="Shadow Ring",
		back="Null Shawl",}
	
	sets.engaged.Subtle_Blow.DT = {}
	
	sets.engaged.Counter.DT = {}
	
	sets.engaged.DT.Footwork = {body="Malignance Tabard",}
	sets.engaged.Subtle_Blow.DT.Footwork = {body="Bhikku Cyclas +2"}
	sets.engaged.Counter.DT.Footwork = {body="Bhikku Cyclas +2"}
	
    ---------------------------------------- Defense Sets -------------------------------------------
	
	sets.engaged.Defense = {}
	
	sets.engaged.Subtle_Blow.Defense = {}
	
	sets.engaged.Counter.Defense = {}
	
	sets.engaged.Defense.Footwork = {body="Malignance Tabard",}
	sets.engaged.Subtle_Blow.Defense.Footwork = {body="Bhikku Cyclas +2"}
	sets.engaged.Counter.Defense.Footwork = {body="Bhikku Cyclas +2"}

    ---------------------------------------- Extra Sets -------------------------------------------
	
	sets.engaged.HF = set_combine(sets.engaged, {})
	sets.engaged.Subtle_Blow.HF = set_combine(sets.engaged.Acc, {})
	sets.engaged.Counter.HF = set_combine(sets.engaged.FullAcc, {})

	sets.buff.Impetus = {body="Bhikku Cyclas +2"}
	sets.buff.Footwork = {feet="Shukuyu Sune-Ate"}
	sets.buff.Boost = {} --waist="Ask Sash"
	
	sets.FootworkWS = {feet="Shukuyu Sune-Ate"}
	
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	sets.Kiting = {left_ring="Shneddick Ring",}
	sets.buff.Doom = set_combine(sets.buff.Doom, {neck="Nicander's Necklace", waist="Gishdubar Sash",})
	
	sets.TreasureHunter = {
		body="Volte Jupon",
		hands="Volte Bracers",
		waist="Chaac Belt",}
	
	-- Weapons sets
	sets.weapons.Godhands = {main="Godhands"}
	sets.weapons.Verethragna = {main="Verethranga"}
	sets.weapons.Karambit = {main="Karambit",}
	sets.weapons.Xoanon = {main="Xoanon", sub="Ultio Grip",}
	
	sets.weapons.ProcH2H = {main=empty}
	sets.weapons.ProcClub = {main="Ethereal Club",}
	sets.weapons.ProcStaff = {main="Treat Staff II",}
	
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	set_macro_page(1, 2)
end

function user_job_lockstyle()
    send_command('input /lockstyleset ' .. lockstyleset)
end