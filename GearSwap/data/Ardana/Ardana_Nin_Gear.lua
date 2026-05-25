-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_job_setup()
	state.OffenseMode:options('Normal')
	state.HybridMode:options('Normal','DT')
	state.RangedMode:options('Normal')
	state.WeaponskillMode:options('Normal','ATKCAP')
	state.CastingMode:options('Normal','Resistant')
	state.IdleMode:options('Normal')
	state.MagicBurst = M(false, 'Magic_Burst')
	state.Weapons:options('Heishi', 'Gokotai', 'Naegling', 'Tauret', 'Kaja_Tachi',
							'ProcDagger','ProcSword','ProcGreatSword','ProcScythe','ProcPolearm','ProcGreatKatana','ProcKatana','ProcClub','ProcStaff')

	state.WeaponSets:options('Default','Proc')

	weapon_sets = {
		['Default'] = {'Heishi', 'Gokotai', 'Naegling', 'Tauret', 'Kaja_Tachi',},
		['Proc'] = {'ProcDagger','ProcSword','ProcGreatSword','ProcScythe','ProcPolearm','ProcGreatKatana','ProcKatana','ProcClub','ProcStaff'},
	}
	
	state.Subweapon = M{['description']='Sub Weapon Set', 'Hitaki', 'Kunimitsu', 'Gletis_Knife', 'Crepuscular',}

	init_job_states({},{"Weapons","OffenseMode","WeaponskillMode","IdleMode","CastingMode","RegenMode","SpellInterrupt","TreasureMode",})
	
	Two_Handed_Weapons = {
		Kaja_Tachi   = true,}
		
	TPBonus = {
		Hitaki   = true,}

	--Includes Global Bind keys
	
	send_command('wait 2; exec Global-Binds.txt')
			
	--Ninja Binds
	
	send_command('wait 2; exec /NIN/Binds.txt')
	
	--Retrieve Gear for Ninja
	
	send_command('wait 3;org get inventory nin.lua')
	send_command('wait 4;get Shihei all')
	send_command('wait 4;get Seki Shuriken all')
	send_command('wait 4;get Inoshishinofuda all')
	send_command('wait 4;get Shikanofuda all')
	send_command('wait 4;get Chonofuda all')

	--Job settings

	utsusemi_cancel_delay = .3
	utsusemi_ni_cancel_delay = .06

	lockstyleset = 13
	select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
	enable('main','sub','range','ammo','head','body','hands','legs','feet','neck','waist','left_ear','right_ear','left_ring','right_ring','back')

	--Remove Global Binds

	send_command('wait 1; exec Global-UnBinds.txt')
	
	--Remove Gear for Ninja
	
	send_command('wait 1; org get Store.lua')
	send_command('put Shihei Satchel all')
	send_command('put Seki Shuriken Satchel all')
	send_command('put Inoshishinofuda Satchel all')
	send_command('put Shikanofuda Satchel all')
	send_command('put Chonofuda Satchel all')
	
end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	sets.Enmity = {
		ammo="Sapience Orb",
		head="Null Masque",
		body="Emet Harness +1",
		hands="Kurys Gloves",
		legs="Zoar Subligar +1",
		feet="Mochi. Kyahan +4",
		neck="Moonlight Necklace",
		waist="Kasiri Belt",
		left_ear="Cryptic Earring",
		right_ear="Trux Earring",
		left_ring="Eihwaz Ring",
		right_ring="Supershear Ring",
		back="Null Shawl",}

	-- Precast sets to enhance JAs
	sets.precast.JA['Mijin Gakure'] = {} --legs="Mochizuki Hakama",--main="Nagi"
	sets.precast.JA['Futae'] = {hands="Hattori Tekko +2"}
	sets.precast.JA['Sange'] = {} --body="Mochizuki Chainmail"
	sets.precast.JA['Provoke'] = sets.Enmity
	sets.precast.JA['Warcry'] = sets.Enmity

	-- Waltz set (chr and vit)
	sets.precast.Waltz = {
        ammo="Yamarang",
		legs="Dashing Subligar",
        waist="Gishdubar Sash",}

	-- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {legs="Dashing Subligar",}

	-- Set for acc on steps, since Yonin drops acc a fair bit
	sets.precast.Step = {}

	sets.precast.JA['Violent Flourish'] = {}

	-- Fast cast sets for spells

	sets.precast.FC = {
		ammo="Sapience Orb",
		head={ name="Herculean Helm", augments={'"Mag.Atk.Bns."+6','"Fast Cast"+6','MND+3','Mag. Acc.+4',}},
		body={ name="Adhemar Jacket +1", augments={'HP+105','"Fast Cast"+10','Magic dmg. taken -4',}},
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
		feet={ name="Herculean Boots", augments={'Mag. Acc.+17','"Fast Cast"+6','VIT+6',}},
		neck="Baetyl Pendant",
		waist="Sailfi Belt +1",
		left_ear="Loquac. Earring",
		right_ear="Etiolation Earring",
		left_ring="Prolix Ring",
		right_ring="Kishar Ring",
		back="Null Shawl",}

	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {})

	sets.precast.RA = {
		range="Trollbane",
		head="Null Masque",
		body="Volte Harness",
		hands="Nyame Gauntlets",
		legs={ name="Adhemar Kecks +1", augments={'AGI+12','"Rapid Shot"+13','Enmity-6',}},
		feet={ name="Pursuer's Gaiters", augments={'Rng.Acc.+10','"Rapid Shot"+10','"Recycle"+15',}},
		neck="Loricate Torque +1",
		waist="Yemaya Belt",
		left_ear="Alabaster Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Crepuscular Ring",
		right_ring="Murky Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
		--Set used for Icarus Wing to maximize TP gain	
	sets.precast.Wing = {
		ammo="Aurgelmir Orb +1",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Iskur Gorget",
		waist="Gerdr Belt +1",
		left_ear="Dedition Earring",
		right_ear={ name="Hattori Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+14','Mag. Acc.+14','"Store TP"+5',}},
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back="Null Shawl",}
		
	sets.precast.Volte_Harness = set_combine(sets.precast.Wing, {body="Volte Harness"})
	sets.precast.Prishes_Boots = set_combine(sets.precast.Wing, {feet="Prishe\'s Boots +1",})
	
    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------
		
	
	sets.precast.WS['Savage Blade'] = {
		ammo="Seeth. Bomblet +1",
		head="Hachi. Hatsu. +4",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Hattori Kyahan +2",
		neck="Rep. Plat. Medal",
		waist="Sailfi Belt +1",
		left_ear="Moonshade Earring",
		right_ear="Alabaster Earring",
		left_ring="Ephramad's Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},}
		
	sets.precast.WS['Savage Blade'].ATKCAP = {
		ammo="Crepuscular Pebble",
		head="Hachi. Hatsu. +4",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Hattori Kyahan +2",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Sailfi Belt +1",
		left_ear="Moonshade Earring",
		right_ear={ name="Hattori Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+14','Mag. Acc.+14','"Store TP"+5',}},
		left_ring="Ephramad's Ring",
		right_ring="Sroda Ring",
		back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},}
		
	sets.precast.WS['Fast Blade II'] = {
		ammo="Coiste Bodhar",
		head="Mpaca's Cap",
		body="Hattori Ningi +2",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Hattori Kyahan +2",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Sailfi Belt +1",
		left_ear="Moonshade Earring",
		right_ear="Alabaster Earring",
		left_ring="Ephramad's Ring",
		right_ring="Gere Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
	sets.precast.WS['Fast Blade II'].ATKCAP = {
		ammo="Coiste Bodhar",
		head="Mpaca's Cap",
		body="Malignance Tabard",
		hands="Nyame Gauntlets",
		legs="Mpaca's Hose",
		feet="Ken. Sune-Ate +1",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Sailfi Belt +1",
		left_ear="Moonshade Earring",
		right_ear="Alabaster Earring",
		left_ring="Ephramad's Ring",
		right_ring="Gere Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
	sets.precast.WS['Sanguine Blade'] = {
		ammo="Seeth. Bomblet +1",
		head="Mochi. Hatsu. +4",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Sibyl Scarf",
		waist="Orpheus's Sash",
		left_ear="Friomisi Earring",
		right_ear="Alabaster Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Archon Ring",
		back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},}
		
    ------------------------------------------------------------------------------------------------
    ----------------------------------Katana Weapon Skill Sets -------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS['Blade: Shun'] = {
		ammo="Coiste Bodhar",
		head="Mpaca's Cap",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Mpaca's Hose",
		feet="Hattori Kyahan +2",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Lugra Earring +1",
		right_ear={ name="Hattori Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+14','Mag. Acc.+14','"Store TP"+5',}},
		left_ring="Ephramad's Ring",
		right_ring="Gere Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
    sets.precast.WS['Blade: Shun'].ATKCAP = {
		ammo="Coiste Bodhar",
		head="Ken. Jinpachi +1",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Mpaca's Hose",
		feet="Ken. Sune-Ate +1",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Fotia Belt",
		left_ear="Lugra Earring +1",
		right_ear={ name="Hattori Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+14','Mag. Acc.+14','"Store TP"+5',}},
		left_ring="Ephramad's Ring",
		right_ring="Gere Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}

    sets.precast.WS['Blade: Ten'] = {
		ammo="Seeth. Bomblet +1",
		head="Mpaca's Cap",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Rep. Plat. Medal",
		waist="Sailfi Belt +1",
		left_ear="Moonshade Earring",
		right_ear="Alabaster Earring",
		left_ring="Regal Ring",
		right_ring="Ephramad's Ring",
		back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},}
		
    sets.precast.WS['Blade: Ten'].ATKCAP = {
		ammo="Crepuscular Pebble",
		head="Hachi. Hatsu. +4",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Hattori Kyahan +2",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Sailfi Belt +1",
		left_ear="Moonshade Earring",
		right_ear={ name="Hattori Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+14','Mag. Acc.+14','"Store TP"+5',}},
		left_ring="Sroda Ring",
		right_ring="Ephramad's Ring",
		back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},}
		
    sets.precast.WS['Blade: Chi'] = {
		ammo="Seeth. Bomblet +1",
		head="Mochi. Hatsu. +4",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Fotia Gorget",
		waist="Orpheus's Sash",
		left_ear="Moonshade Earring",
		right_ear="Alabaster Earring",
		left_ring="Gere Ring",
		right_ring="Ephramad's Ring",
		back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},}
		
    sets.precast.WS['Blade: Chi'].ATKCAP = {
		ammo="Seeth. Bomblet +1",
		head="Mochi. Hatsu. +4",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Orpheus's Sash",
		left_ear="Moonshade Earring",
		right_ear={ name="Hattori Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+14','Mag. Acc.+14','"Store TP"+5',}},
		left_ring="Gere Ring",
		right_ring="Ephramad's Ring",
		back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},}
		
	sets.precast.WS['Blade: Teki'] = sets.precast.WS['Blade: Chi']
	sets.precast.WS['Blade: Teki'].ATKCAP = sets.precast.WS['Blade: Chi'].ATKCAP
    sets.precast.WS['Blade: To'] = sets.precast.WS['Blade: Chi']
    sets.precast.WS['Blade: To'].ATKCAP = sets.precast.WS['Blade: Chi'].ATKCAP

    sets.precast.WS['Blade: Hi'] = {
		ammo="Yetshila +1",
		head="Hachi. Hatsu. +4",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Hattori Kyahan +2",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Gerdr Belt +1",
		left_ear="Odr Earring",
		right_ear="Alabaster Earring",
		left_ring="Regal Ring",
		right_ring="Ephramad's Ring",
		back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},}
		
    sets.precast.WS['Blade: Hi'].ATKCAP = {
		ammo="Yetshila +1",
		head="Hachi. Hatsu. +4",
		body="Nyame Mail",
		hands="Malignance Gloves",
		legs="Nyame Flanchard",
		feet="Hattori Kyahan +2",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Gerdr Belt +1",
		left_ear="Alabaster Earring",
		right_ear={ name="Hattori Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+14','Mag. Acc.+14','"Store TP"+5',}},
		left_ring="Regal Ring",
		right_ring="Ephramad's Ring",
		back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},}

    sets.precast.WS['Blade: Ku'] = {
		ammo="Coiste Bodhar",
		head="Mpaca's Cap",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Hattori Kyahan +2",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Alabaster Earring",
		right_ear="Lugra Earring +1",
		left_ring="Gere Ring",
		right_ring="Ephramad's Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
    sets.precast.WS['Blade: Ku'].ATKCAP = {
		ammo="Crepuscular Pebble",
		head="Blistering Sallet +1",
		body="Nyame Mail",
		hands="Malignance Gloves",
		legs="Mpaca's Hose",
		feet="Hattori Kyahan +2",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Fotia Belt",
		left_ear="Lugra Earring +1",
		right_ear={ name="Hattori Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+14','Mag. Acc.+14','"Store TP"+5',}},
		left_ring="Gere Ring",
		right_ring="Ephramad's Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}

    sets.precast.WS['Blade: Kamu'] = {
		ammo="Coiste Bodhar",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Mpaca's Hose",
		feet="Nyame Sollerets",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Sailfi Belt +1",
		left_ear="Lugra Earring +1",
		right_ear={ name="Hattori Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+14','Mag. Acc.+14','"Store TP"+5',}},
		left_ring="Gere Ring",
		right_ring="Ephramad's Ring",
		back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},}
		
    sets.precast.WS['Blade: Kamu'].ATKCAP = {
		ammo="Coiste Bodhar",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Mpaca's Hose",
		feet="Nyame Sollerets",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Sailfi Belt +1",
		left_ear="Lugra Earring +1",
		right_ear={ name="Hattori Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+14','Mag. Acc.+14','"Store TP"+5',}},
		left_ring="Gere Ring",
		right_ring="Ephramad's Ring",
		back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},}
		
    sets.precast.WS['Blade: Jin'] = {
		ammo="Yetshila +1",
		head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
		body="Mpaca's Doublet",
		hands={ name="Ryuo Tekko +1", augments={'DEX+12','Accuracy+25','"Dbl.Atk."+4',}},
		legs="Mpaca's Hose",
		feet="Ken. Sune-Ate +1",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Odr Earring",
		right_ear="Lugra Earring +1",
		left_ring="Gere Ring",
		right_ring="Ephramad's Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
    sets.precast.WS['Blade: Jin'].ATKCAP = {
		ammo="Yetshila +1",
		head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
		body="Mpaca's Doublet",
		hands={ name="Ryuo Tekko +1", augments={'DEX+12','Accuracy+25','"Dbl.Atk."+4',}},
		legs="Mpaca's Hose",
		feet="Ken. Sune-Ate +1",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Fotia Belt",
		left_ear="Lugra Earring +1",
		right_ear={ name="Hattori Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+14','Mag. Acc.+14','"Store TP"+5',}},
		left_ring="Gere Ring",
		right_ring="Ephramad's Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}

	sets.precast.WS['Blade: Ei'] = {
		ammo="Seeth. Bomblet +1",
		head="Mochi. Hatsu. +4",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear="Moonshade Earring",
		right_ear="Friomisi Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Archon Ring",
		back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},}

	sets.precast.WS['Blade: Yu'] = {
		ammo="Ghastly Tathlum +1",
		head="Mochi. Hatsu. +4",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear="Crematio Earring",
		right_ear="Friomisi Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Dingir Ring",
		back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},}
		
    ------------------------------------------------------------------------------------------------
    -------------------------------Great Katana Weapon Skill Sets ----------------------------------
    ------------------------------------------------------------------------------------------------
	
	sets.precast.WS['Tachi: Ageha'] = {
	    ammo="Yamarang",
		head="Hachi. Hatsu. +4",
		body="Hattori Ningi +2",
		hands="Hattori Tekko +2",
		legs="Mpaca's Hose",
		feet="Hachiya Kyahan +4",
		neck="Null Loop",
		waist="Null Belt",
		left_ear="Alabaster Earring",
		right_ear={ name="Hattori Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+14','Mag. Acc.+14','"Store TP"+5',}},
		left_ring="Metamor. Ring +1",
		right_ring="Murky Ring",
		back="Null Shawl",}
	
	sets.precast.WS['Tachi: Jinpu'] = {
	    ammo="Seeth. Bomblet +1",
		head="Mpaca's Cap",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Fotia Gorget",
		waist="Orpheus's Sash",
		left_ear="Moonshade Earring",
		right_ear="Friomisi Earring",
		left_ring="Ephramad's Ring",
		right_ring="Gere Ring",
		back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},}
		
	sets.precast.WS['Tachi: Jinpu'].ATKCAP = {
	    ammo="Seeth. Bomblet +1",
		head="Mpaca's Cap",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Fotia Gorget",
		waist="Orpheus's Sash",
		left_ear="Moonshade Earring",
		right_ear={ name="Hattori Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+14','Mag. Acc.+14','"Store TP"+5',}},
		left_ring="Ephramad's Ring",
		right_ring="Gere Ring",
		back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},}
	
	sets.precast.WS['Tachi: Kagero'] = sets.precast.WS['Tachi: Jinpu']
	sets.precast.WS['Tachi: Goten'] = sets.precast.WS['Tachi: Jinpu']
	sets.precast.WS['Tachi: Koki'] = sets.precast.WS['Tachi: Jinpu']
	sets.precast.WS['Tachi: Kagero'].ATKCAP = sets.precast.WS['Tachi: Jinpu'].ATKCAP
	sets.precast.WS['Tachi: Goten'].ATKCAP = sets.precast.WS['Tachi: Jinpu'].ATKCAP
	sets.precast.WS['Tachi: Koki'].ATKCAP = sets.precast.WS['Tachi: Jinpu'].ATKCAP
	
	sets.precast.WS['Tachi: Kasha'] = {
	    ammo="Crepuscular Pebble",
		head="Mpaca's Cap",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Sailfi Belt +1",
		left_ear="Moonshade Earring",
		right_ear={ name="Hattori Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+14','Mag. Acc.+14','"Store TP"+5',}},
		left_ring="Ephramad's Ring",
		right_ring="Sroda Ring",
		back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},}
		
	sets.precast.WS['Tachi: Kasha'].ATKCAP = {
		ammo="Crepuscular Pebble",
		head="Mpaca's Cap",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Hattori Kyahan +2",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Sailfi Belt +1",
		left_ear="Moonshade Earring",
		right_ear={ name="Hattori Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+14','Mag. Acc.+14','"Store TP"+5',}},
		left_ring="Ephramad's Ring",
		right_ring="Sroda Ring",
		back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},}
	
    ------------------------------------------------------------------------------------------------
    ----------------------------------Dagger Weapon Skill Sets -------------------------------------
    ------------------------------------------------------------------------------------------------
	
	sets.precast.WS['Aeolian Edge'] = {
	    ammo="Ghastly Tathlum +1",
		head="Mochi. Hatsu. +4",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Sibyl Scarf",
		waist="Orpheus's Sash",
		left_ear="Moonshade Earring",
		right_ear="Friomisi Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Dingir Ring",
		back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},}
		
	sets.precast.WS['Evisceration'] = {
		ammo="Yetshila +1",
		head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
		body="Mpaca's Doublet",
		hands={ name="Ryuo Tekko +1", augments={'DEX+12','Accuracy+25','"Dbl.Atk."+4',}},
		legs="Mpaca's Hose",
		feet="Ken. Sune-Ate +1",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Odr Earring",
		right_ear="Lugra Earring +1",
		left_ring="Gere Ring",
		right_ring="Ephramad's Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
	sets.precast.WS['Evisceration'].ATKCAP = {
		ammo="Yetshila +1",
		head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
		body="Mpaca's Doublet",
		hands={ name="Ryuo Tekko +1", augments={'DEX+12','Accuracy+25','"Dbl.Atk."+4',}},
		legs="Mpaca's Hose",
		feet="Ken. Sune-Ate +1",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Fotia Belt",
		left_ear="Odr Earring",
		right_ear={ name="Hattori Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+14','Mag. Acc.+14','"Store TP"+5',}},
		left_ring="Gere Ring",
		right_ring="Ephramad's Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
	sets.precast.WS['Exenterator'] = {
		ammo="Coiste Bodhar",
		head="Mpaca's Cap",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Hattori Kyahan +2",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Lugra Earring +1",
		right_ear="Alabaster Earring",
		left_ring="Gere Ring",
		right_ring="Ephramad's Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
	sets.precast.WS['Exenterator'].ATKCAP = {
		ammo="Crepuscular Pebble",
		head="Hachi. Hatsu. +4",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Mpaca's Hose",
		feet="Hattori Kyahan +2",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Fotia Belt",
		left_ear="Alabaster Earring",
		right_ear={ name="Hattori Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+14','Mag. Acc.+14','"Store TP"+5',}},
		left_ring="Gere Ring",
		right_ring="Ephramad's Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}

	-- Swap to these on Moonshade using WS if at 3000 TP
	sets.MaxTP = {}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	sets.midcast.FastRecast = sets.precast.FC
	
    sets.midcast.Utsusemi = set_combine(sets.precast.FC, {
		hands="Mochi. Tekko +4",
		feet="Hattori Kyahan +2",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},})

	sets.midcast.ElementalNinjutsu = {
		ammo="Ghastly Tathlum +1",
		head="Mochi. Hatsu. +4",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Mochi. Kyahan +4",
		neck="Sibyl Scarf",
		waist="Skrymir Cord +1",
		left_ear="Crematio Earring",
		right_ear="Friomisi Earring",
		left_ring="Metamor. Ring +1",
		right_ring="Dingir Ring",
		back="Null Shawl",}
		
	sets.midcast.ElementalNinjutsu_MagicBurst = {
		ammo="Ghastly Tathlum +1",
		head="Mochi. Hatsu. +4",
		body="Nyame Mail",
		hands="Hattori Tekko +2",
		legs="Nyame Flanchard",
		feet="Mochi. Kyahan +4",
		neck="Sibyl Scarf",
		waist="Skrymir Cord +1",
		left_ear="Crematio Earring",
		right_ear="Friomisi Earring",
		left_ring="Metamor. Ring +1",
		right_ring="Mujin Band",
		back="Null Shawl",}

	sets.midcast.ElementalNinjutsu.Resistant = set_combine(sets.midcast.ElementalNinjutsu, {})

	sets.midcast.NinjutsuDebuff = {
		ammo="Yamarang",
		head="Hachi. Hatsu. +4",
		body="Mpaca's Doublet",
		hands="Hattori Tekko +2",
		legs="Mpaca's Hose",
		feet="Hachiya Kyahan +4",
		neck="Null Loop",
		waist="Null Belt",
		left_ear="Alabaster Earring",
		right_ear={ name="Hattori Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+14','Mag. Acc.+14','"Store TP"+5',}},
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Null Shawl",}

	sets.midcast.NinjutsuBuff = {
		ammo="Staunch Tathlum +1",
		head="Null Masque",
		body="Adamantite Armor",
		hands="Mochi. Tekko +4",
		legs="Nyame Flanchard",
		feet="Hattori Kyahan +2",
		neck="Loricate Torque +1",
		waist="Audumbla Sash",
		left_ear="Magnetic Earring",
		right_ear="Alabaster Earring",
		left_ring="Evanescence Ring",
		right_ring="Murky Ring",
		back="Null Shawl",}
		
	sets.midcast['Migawari: Ichi'] = set_combine(sets.precast.FC, {hands="Mochi. Tekko +4",})

	sets.midcast.RA = {
		range="Trollbane",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Yemaya Belt",
		left_ear="Alabaster Earring",
		right_ear={ name="Hattori Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+14','Mag. Acc.+14','"Store TP"+5',}},
		left_ring="Crepuscular Ring",
		right_ring="Ilabrat Ring",
		back="Null Shawl",}

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Resting sets
    sets.resting = {}

    -- Idle sets
    sets.idle = {
		ammo="Yamarang",
		head="Null Masque",
		body="Adamantite Armor",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Bathy Choker +1",
		waist="Svelt. Gouriz +1",
		left_ear="Sanare Earring",
		right_ear="Eabani Earring",
		left_ring="Murky Ring",
		right_ring="Ephramad's Ring",
		back="Null Shawl",}
		
	sets.idle.rollers = set_combine(sets.idle, {right_ring="Roller's Ring",})

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
		head="Mpaca's Cap",
		body="Mpaca's Doublet",
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs={ name="Ryuo Hakama +1", augments={'Accuracy+25','"Store TP"+5','Phys. dmg. taken -4',}},
		feet="Tatena. Sune. +1",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Windbuffet Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Dedition Earring",
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back="Null Shawl",}
	
	sets.engaged.TPBonus = {
		head="Mpaca's Cap",
		body="Mpaca's Doublet",
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs="Tatena. Haidate +1",
		feet="Malignance Boots",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Kentarch Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Telos Earring",
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back="Null Shawl",}
	
	sets.engaged.Two_Handed = {
		head="Mpaca's Cap",
		body="Mpaca's Doublet",
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs={ name="Ryuo Hakama +1", augments={'Accuracy+25','"Store TP"+5','Phys. dmg. taken -4',}},
		feet="Tatena. Sune. +1",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Windbuffet Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Dedition Earring",
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back="Null Shawl",}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

	sets.engaged.DT = {
		head="Mpaca's Cap",
		body="Mpaca's Doublet",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Nyame Sollerets",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Windbuffet Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Dedition Earring",
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
	
	sets.engaged.TPBonus.DT = {
		head="Mpaca's Cap",
		body="Mpaca's Doublet",
		hands="Malignance Gloves",
		legs="Mpaca's Hose",
		feet="Malignance Boots",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Kentarch Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Telos Earring",
		left_ring="Gere Ring",
		right_ring="Murky Ring",
		back="Null Shawl",}
	
	sets.engaged.Two_Handed.DT = {
		head="Mpaca's Cap",
		body="Mpaca's Doublet",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Nyame Sollerets",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Windbuffet Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Dedition Earring",
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
	
    ------------------------------------------------------------------------------------------------
    ------------------------------------ Migawari Engaged Sets -------------------------------------
    ------------------------------------------------------------------------------------------------
	
	sets.engaged.Migawari = {
		head="Mpaca's Cap",
		body="Hattori Ningi +2",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Windbuffet Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Dedition Earring",
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
	
	sets.engaged.TPBonus_Migawari = {
		head="Mpaca's Cap",
		body="Hattori Ningi +2",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Kentarch Belt +1",
		left_ear="Alabaster Earring",
		right_ear={ name="Hattori Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+14','Mag. Acc.+14','"Store TP"+5',}},
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
	
	sets.engaged.Two_Handed_Migawari = {
		head="Mpaca's Cap",
		body="Hattori Ningi +2",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Windbuffet Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Dedition Earring",
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
	
	sets.engaged.Migawari.DT = sets.engaged.Migawari	
	sets.engaged.TPBonus_Migawari.DT = sets.engaged.TPBonus_Migawari
	sets.engaged.Two_Handed_Migawari.DT = sets.engaged.Two_Handed_Migawari

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
	
	sets.Kiting = {right_ring="Shneddick Ring",}
	sets.DuskKiting = {feet="Hachiya Kyahan +4"}
	
	sets.buff.Migawari = {body="Hattori Ningi +2",} --body="Hattori Ningi +1"
	sets.buff.Doom = set_combine(sets.buff.Doom, {neck="Nicander's Necklace", waist="Gishdubar Sash",})
	sets.buff.Futae = {hands="Hattori Tekko +2",}
	sets.buff.Yonin = {} --legs="Hattori Hakama +1"
	sets.buff.Innin = {} --head="Hattori Zukin +1"

	sets.TreasureHunter = {
		body="Volte Jupon",
		hands="Volte Bracers",
		waist="Chaac Belt",}
	
	
		-- Weapons sets
	sets.weapons.Heishi = {main={ name="Heishi Shorinken", augments={'Path: A',}},}
	sets.weapons.Gokotai = {main="Gokotai",}
	sets.Gokotai_Hitaki = {main="Gokotai",}
	sets.weapons.Naegling = {main="Naegling",}
	sets.Naegling_Hitaki = {main="Naegling",}
	sets.weapons.Tauret = {main="Tauret",}
	sets.weapons.Kaja_Tachi = {main="Kaja Tachi",}
	
	sets.Hitaki = {sub="Uzura +2",}
	sets.Kunimitsu = {sub="Kunimitsu",}
	sets.Gletis_Knife = {sub={ name="Gleti\'s Knife", augments={'Path: A',}},}
	sets.Crepuscular = {sub="Crepuscular Knife",}
	
	sets.grip = {sub={ name="Rigorous Grip +1", augments={'Path: A',}},}
	
	sets.ammo_Daken = {ammo="Seki Shuriken",}
	sets.ammo_proc = {ammo="Yamarang",}	
	
		-- Proc Weapon Sets for Abyssea
	sets.weapons.ProcDagger = {main="Hedron Dagger",sub="Debahocho +1",}
	sets.weapons.ProcSword = {main="Excalipoor II",sub="Debahocho +1",}
	sets.weapons.ProcGreatSword = {main="Ethereal G. Sword",}
	sets.weapons.ProcScythe = {main="Ethereal Scythe",}
	sets.weapons.ProcPolearm = {main="Ethereal Spear",}
	sets.weapons.ProcKatana = {main="Ethereal Katana",sub="Debahocho +1",}
	sets.weapons.ProcGreatKatana = {main="Ethereal Tachi",}
	sets.weapons.ProcClub = {main="Ethereal Club",sub="Debahocho +1",}
	sets.weapons.ProcStaff = {main="Treat Staff II",}
	
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
        set_macro_page(1, 13)
end

function user_job_lockstyle()
    send_command('input /lockstyleset ' .. lockstyleset)
end