function user_job_setup()
	state.OffenseMode:options('Normal','Acc')
	state.HybridMode:options('Normal', 'DT', 'PetTank', 'BothDD')
	state.WeaponskillMode:options('Normal', 'ATKCAP')
	state.CastingMode:options('Normal')
	state.IdleMode:options('Normal','Refresh')
	state.RestingMode:options('Normal')
	state.Weapons:options('None','Agwu_Axe', 'Dolichenus', 'Ikenga_Axe', 'Naegling', 'Tauret')
	state.Subweapon = M{['description']='Sub Weapon Set', 'Crepuscular'}
	state.Shield = M{['description']='Shield Set', 'Sacro_Bulwark', 'Archduke'}
	
	state.CorrelationMode = M{['description']='Correlation Mode', 'Neutral'}
	state.Reraise = M(false, "Reraise Mode")
	
	state.JugMode = M{['description']='Jug Mode','GenerousArthur','Bouncing Bertha','Fatso Fargann',' Headbreaker Ken','Sweet Caroline','SlimeFamiliar'}
	state.PetMode = M{['description']='Pet Mode','Pet_Tank','Pet_DD'}

	init_job_states({},{"Weapons","Subweapon","Shield","OffenseMode","WeaponskillMode","IdleMode","PetMode","JugMode", "TreasureMode",})
	
	--Includes Global Bind keys
	
	send_command('wait 2; exec Global-Binds.txt')

	--Beast Master Binds
	
	send_command('wait 2; exec /BST/Binds.txt')
	
	--Retrieve Gear for Beast Master
	
	send_command('wait 3;org get inventory bst.lua')
	send_command('wait 4;get Bubbly Broth all')
	send_command('wait 4;get Blackwater Broth all')
	send_command('wait 4;get Dire Broth all')
	send_command('wait 4;get Aged Humus all')
	send_command('wait 4;get C. Plasma Broth all')
	
	--Job Settings

	lockstyleset = 9
    select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
	enable('main','sub','range','ammo','head','body','hands','legs','feet','neck','waist','left_ear','right_ear','left_ring','right_ring','back')

	--Remove Global Binds

	send_command('wait 1; exec Global-UnBinds.txt')
	
	--Remove Gear for Beast Master
	
	send_command('wait 1; org get Store.lua')
	send_command('put Bubbly Broth satchel all')
	send_command('put Blackwater Broth satchel all')
	send_command('put Dire Broth satchel all')
	send_command('put Aged Humus satchel all')
	send_command('put C. Plasma Broth satchel all')
	
end

-- BST gearsets
function init_gear_sets()
	-- PRECAST SETS
	sets.precast.JA['Killer Instinct'] = {head={ name="Ankusa Helm", augments={'Enhances "Killer Instinct" effect',}},}
	sets.precast.JA.Familiar = {legs="Ankusa Trousers +1"}
	sets.precast.JA.Tame = {head="Totemic Helm +1"}
	
	sets.precast.JA.Spur = {back="Artio's Mantle",feet="Nukumi Ocreae +3"}
	
	sets.SpurAxe = {main="Skullrender"}
	sets.SpurAxesDW = {main="Skullrender",sub="Skullrender"}

	sets.precast.JA['Feral Howl'] = {} --body="Ankusa Jackcoat",
	
	sets.precast.JA['Bestial Loyalty'] = {
		hands={ name="Ankusa Gloves +2", augments={'Enhances "Beast Affinity" effect',}},
		feet={ name="Gleti's Boots", augments={'Path: A',}},
		right_ear={ name="Nukumi Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','Pet: "Dbl. Atk."+7',}},}
		
	sets.precast.JA['Call Beast'] = sets.precast.JA['Bestial Loyalty']

	sets.precast.JA.Reward = {
	    main="Dolichenus",
		sub="Sacro Bulwark",
		ammo="Pet Food Theta",
		head="Crepuscular Helm",
		body="Tot. Jackcoat +3",
		hands="Malignance Gloves",
		legs={ name="Ankusa Trousers +3", augments={'Enhances "Familiar" effect',}},
		feet={ name="Ankusa Gaiters +3", augments={'Enhances "Beast Healer" effect',}},
		neck="Phalaina Locket",
		waist="Engraved Belt",
		left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		right_ear="Genmei Earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back={ name="Artio's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

	sets.precast.JA.Reward.DW = {
	    main="Dolichenus",
		sub="Sacro Bulwark",
		ammo="Pet Food Theta",
		head="Crepuscular Helm",
		body="Tot. Jackcoat +3",
		hands="Malignance Gloves",
		legs={ name="Ankusa Trousers +3", augments={'Enhances "Familiar" effect',}},
		feet={ name="Ankusa Gaiters +3", augments={'Enhances "Beast Healer" effect',}},
		neck="Phalaina Locket",
		waist="Engraved Belt",
		left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		right_ear="Genmei Earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back={ name="Artio's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

	sets.precast.JA.Charm = {
	    main="Agwu's Axe",
		sub="Sacro Bulwark",
		ammo="Staunch Tathlum +1",
		head={ name="Ankusa Helm +3", augments={'Enhances "Killer Instinct" effect',}},
		body={ name="An. Jackcoat +3", augments={'Enhances "Feral Howl" effect',}},
		hands={ name="Ankusa Gloves +3", augments={'Enhances "Beast Affinity" effect',}},
		legs={ name="Ankusa Trousers +3", augments={'Enhances "Familiar" effect',}},
		feet={ name="Ankusa Gaiters +3", augments={'Enhances "Beast Healer" effect',}},
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Chaac Belt",
		left_ear="Tuisto Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring="Defending Ring",
		back={ name="Artio's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

	-- CURING WALTZ
	sets.precast.Waltz = {legs="Dashing Subligar",left_ring="Asklepian Ring",waist="Gishdubar Sash",}

		-- HEALING WALTZ
	sets.precast.Waltz['Healing Waltz'] = {legs="Dashing Subligar",}

		-- STEPS
	sets.precast.Step = {}

		-- VIOLENT FLOURISH
	sets.precast.Flourish1 = {}
	sets.precast.Flourish1['Violent Flourish'] = {}

	sets.precast.FC = {
	    main="Izizoeksi",
		sub="Sacro Bulwark",
		ammo="Sapience Orb",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Orunmila's Torque",
		waist="Flume Belt +1",
		left_ear="Etiolation Earring",
		right_ear="Loquac. Earring",
		left_ring="Prolix Ring",
		right_ring="Defending Ring",
		back={ name="Artio's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {})
	
		--Set used for Icarus Wing to maximize TP gain	
	sets.precast.Wing = {}
	
	sets.precast.Volte_Harness = set_combine(sets.precast.Wing, {body="Volte Harness"})
	sets.precast.Prishes_Boots = {feet="Prishe\'s Boots +1",}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
	
	sets.midcast.FastRecast = sets.precast.FC

	sets.midcast.Utsusemi = set_combine(sets.midcast.FastRecast, {})

	sets.midcast.Cure = {}

	sets.midcast.Curaga = sets.midcast.Cure

	sets.Self_Healing = {hands="Buremte Gloves",ring2="Kunaji Ring",waist="Gishdubar Sash"}
	sets.Cure_Received = {hands="Buremte Gloves",ring2="Kunaji Ring",waist="Gishdubar Sash"}
	sets.Self_Refresh = {waist="Gishdubar Sash"}

	sets.midcast.Stoneskin = sets.midcast.FastRecast

	sets.midcast.Cursna = {}
	
    -- Ranged gear
	
    sets.midcast.RA = {}

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

	--Generic Weapon Skill

	sets.precast.WS = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Thrud Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Epaminondas's Ring",
		right_ring="Sroda Ring",
		back="Shadow Mantle",}
		
	sets.precast.WS.ATKCAP = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Thrud Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Epaminondas's Ring",
		right_ring="Sroda Ring",
		back="Shadow Mantle",}

	--TP Overflow set

	sets.precast.WS.FullTP = {left_ear={ name="Lugra Earring +1", augments={'Path: A',}},}
		
	--Axe Weapon Skills
	
	sets.precast.WS['Decimation'] = {
	    ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Gleti's Cuirass", augments={'Path: A',}},
		hands={ name="Gleti's Gauntlets", augments={'Path: A',}},
		legs={ name="Gleti's Breeches", augments={'Path: A',}},
		feet="Nukumi Ocreae +2",
		neck="Rep. Plat. Medal",
		waist="Fotia Belt",
		left_ear="Sroda Earring",
		right_ear="Sherida Earring",
		left_ring="Gere Ring",
		right_ring="Sroda Ring",
		back={ name="Artio's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
	
	sets.precast.WS['Decimation'].ATKCAP = {
	    ammo="Crepuscular Pebble",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Gleti's Cuirass", augments={'Path: A',}},
		hands={ name="Gleti's Gauntlets", augments={'Path: A',}},
		legs={ name="Gleti's Breeches", augments={'Path: A',}},
		feet="Nukumi Ocreae +2", 
		neck={ name="Bst. Collar +2", augments={'Path: A',}},
		waist="Fotia Belt",
		left_ear="Sroda Earring",
		right_ear="Sherida Earring",
		left_ring="Gere Ring",
		right_ring="Sroda Ring",
		back={ name="Artio's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Ruinator'] = sets.precast.WS['Decimation']
	sets.precast.WS['Ruinator'].ATKCAP = sets.precast.WS['Decimation'].ATKCAP
	
	sets.precast.WS['Calamity'] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Ankusa Helm +3", augments={'Enhances "Killer Instinct" effect',}},
		body="Nukumi Gausape +2",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Thrud Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Sroda Ring",
		back={ name="Artio's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
	
	sets.precast.WS['Calamity'].ATKCAP = {
		ammo="Crepuscular Pebble",
		head={ name="Ankusa Helm +3", augments={'Enhances "Killer Instinct" effect',}},
		body="Nukumi Gausape +2",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Nukumi Ocreae +2", 
		neck={ name="Bst. Collar +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Thrud Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Sroda Ring",
		back={ name="Artio's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
	
	sets.precast.WS['Mistral Axe'] = sets.precast.WS['Calamity']
	sets.precast.WS['Mistral Axe'].ATKCAP = sets.precast.WS['Calamity'].ATKCAP
	
	sets.precast.WS['Rampage'] = {
	    ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Gleti's Cuirass", augments={'Path: A',}},
		hands={ name="Gleti's Gauntlets", augments={'Path: A',}},
		legs={ name="Gleti's Breeches", augments={'Path: A',}},
		feet={ name="Gleti's Boots", augments={'Path: A',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Sherida Earring",
		left_ring="Gere Ring",
		right_ring="Sroda Ring",
		back={ name="Artio's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
	
	sets.precast.WS['Primal Rend'] = {
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
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Epaminondas's Ring",
		back="Shadow Mantle",}
	
	sets.precast.WS['Cloudsplitter'] = sets.precast.WS['Primal Rend']
	
	--Sword Weapon Skills

	sets.precast.WS['Savage Blade'] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Ankusa Helm +3", augments={'Enhances "Killer Instinct" effect',}},
		body="Nukumi Gausape +2",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Thrud Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Sroda Ring",
		back={ name="Artio's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Savage Blade'].ATKCAP = {
		ammo="Crepuscular Pebble",
		head={ name="Ankusa Helm +3", augments={'Enhances "Killer Instinct" effect',}},
		body="Nukumi Gausape +2",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Nukumi Ocreae +2", 
		neck={ name="Bst. Collar +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Thrud Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Sroda Ring",
		back={ name="Artio's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	--Dagger Weapon Skills
	
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
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Epaminondas's Ring",
		back="Shadow Mantle",}
		
	sets.precast.WS['Evisceration'] = sets.precast.WS['Rampage']
		
	sets.precast.WS['Exenterator'] = sets.precast.WS['Rampage']

		-- Swap to these on Moonshade using WS if at 3000 TP
	sets.MaxTP = {ear1="Sherida Earring",ear2="Brutal Earring",}
	sets.AccMaxTP = {ear1="Telos Earring",ear2="Nukumi Earring +1"}
	
    ------------------------------------------------------------------------------------------------
    ------------------------------------- Pet Ready Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

				-- PET SIC & READY MOVES
	sets.midcast.Pet.WS = {
		main="Agwu's Axe",
		sub="Sacro Bulwark",
		ammo="Hesperiidae",
		head={ name="Emicho Coronet +1", augments={'Pet: Accuracy+20','Pet: Attack+20','Pet: "Dbl. Atk."+4',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Nukumi Manoplas +2",
		legs="Tot. Trousers +3",
		feet={ name="Gleti's Boots", augments={'Path: A',}},
		neck={ name="Bst. Collar +2", augments={'Path: A',}},
		waist="Incarnation Sash",
		left_ear="Sroda Earring",
		right_ear={ name="Nukumi Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','Pet: "Dbl. Atk."+7',}},
		left_ring="Tali'ah Ring",
		right_ring="C. Palug Ring",
		back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Accuracy+20 Attack+20','Pet: Accuracy+10 Pet: Rng. Acc.+10','Pet: Haste+10','Pet: Damage taken -5%',}},}

	sets.midcast.Pet.Acc = sets.midcast.Pet.WS

		--all magic_ready_moves
	sets.midcast.Pet.MagicReady = {
		main="Agwu's Axe",
		sub="Sacro Bulwark",
	    ammo="Hesperiidae",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body="Udug Jacket",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Gleti's Breeches", augments={'Path: A',}},
		feet={ name="Gleti's Boots", augments={'Path: A',}},
		neck="Adad Amulet",
		waist="Incarnation Sash",
		left_ear="Enmerkar Earring",
		right_ear={ name="Nukumi Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','Pet: "Dbl. Atk."+7',}},
		left_ring="Tali'ah Ring",
		right_ring="C. Palug Ring",
		back={ name="Artio's Mantle", augments={'Pet: M.Acc.+20 Pet: M.Dmg.+20','Accuracy+20 Attack+20','Pet: Mag. Acc.+10','Pet: "Regen"+10','Pet: Damage taken -5%',}},}
		
		--all debuff_ready_moves
	sets.midcast.Pet.DebuffReady = {
		main="Agwu's Axe",
		sub="Sacro Bulwark",
		ammo={ name="Hesperiidae", augments={'Path: A',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Gleti's Breeches", augments={'Path: A',}},
		feet={ name="Gleti's Boots", augments={'Path: A',}},
		neck={ name="Bst. Collar +2", augments={'Path: A',}},
		waist="Incarnation Sash",
		left_ear="Enmerkar Earring",
		right_ear={ name="Nukumi Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','Pet: "Dbl. Atk."+7',}},
		left_ring="Murky Ring",
		right_ring="C. Palug Ring",
		back={ name="Artio's Mantle", augments={'Pet: M.Acc.+20 Pet: M.Dmg.+20','Accuracy+20 Attack+20','Pet: "Regen"+10','Pet: Damage taken -5%',}},}

		--all physical_debuff_ready_moves		
	sets.midcast.Pet.PhysicalDebuffReady = {
		main="Agwu's Axe",
		sub="Sacro Bulwark",
		ammo={ name="Hesperiidae", augments={'Path: A',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Gleti's Breeches", augments={'Path: A',}},
		feet={ name="Gleti's Boots", augments={'Path: A',}},
		neck={ name="Bst. Collar +2", augments={'Path: A',}},
		waist="Incarnation Sash",
		left_ear="Enmerkar Earring",
		right_ear={ name="Nukumi Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','Pet: "Dbl. Atk."+7',}},
		left_ring="Murky Ring",
		right_ring="C. Palug Ring",
		back={ name="Artio's Mantle", augments={'Pet: M.Acc.+20 Pet: M.Dmg.+20','Accuracy+20 Attack+20','Pet: "Regen"+10','Pet: Damage taken -5%',}},}

		--all multi_hit_ready_moves
	sets.midcast.Pet.MultiHitReady = {
		main="Agwu's Axe",
		sub="Sacro Bulwark",
		ammo="Hesperiidae",
		head={ name="Emicho Coronet +1", augments={'Pet: Accuracy+20','Pet: Attack+20','Pet: "Dbl. Atk."+4',}},
		body={ name="An. Jackcoat +3", augments={'Enhances "Feral Howl" effect',}},
		hands="Nukumi Manoplas +2",
		legs={ name="Emicho Hose +1", augments={'Pet: Accuracy+20','Pet: Attack+20','Pet: "Dbl. Atk."+4',}},
		feet={ name="Gleti's Boots", augments={'Path: A',}},
		neck={ name="Bst. Collar +2", augments={'Path: A',}},
		waist="Incarnation Sash",
		left_ear="Sroda Earring",
		right_ear={ name="Nukumi Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','Pet: "Dbl. Atk."+7',}},
		left_ring="Tali'ah Ring",
		right_ring="C. Palug Ring",
		back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Accuracy+20 Attack+20','Pet: Accuracy+10 Pet: Rng. Acc.+10','Pet: Haste+10','Pet: Damage taken -5%',}},}

	sets.midcast.Pet.ReadyRecast = {legs="Gleti's Breeches"}
	sets.midcast.Pet.Neutral = {}
	sets.midcast.Pet.Favorable = {head="Nuk. Cabasset +3"}
	sets.midcast.Pet.TPBonus = {hands="Nukumi Manoplas +3"}

	-- RESTING
	sets.resting = {
		main="Agwu's Axe",
		sub="Sacro Bulwark",
		ammo="Staunch Tathlum +1",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Flume Belt +1",
		left_ear="Tuisto Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring="Defending Ring",
		back={ name="Artio's Mantle", augments={'Pet: M.Acc.+20 Pet: M.Dmg.+20','Accuracy+20 Attack+20','Pet: "Regen"+10','Pet: Damage taken -5%',}},}

	sets.idle = {
		main="Agwu's Axe",
		sub="Sacro Bulwark",
		ammo="Staunch Tathlum +1",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Flume Belt +1",
		left_ear="Tuisto Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring="Defending Ring",
		back={ name="Artio's Mantle", augments={'Pet: M.Acc.+20 Pet: M.Dmg.+20','Accuracy+20 Attack+20','Pet: "Regen"+10','Pet: Damage taken -5%',}},}
		
	sets.idle.Refresh = {}
		
	sets.idle.Pet_Tank = {
	    main="Agwu's Axe",
		sub="Sacro Bulwark",
		ammo="Staunch Tathlum +1",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body="Totemic Jackcoat +3",
		hands={ name="Gleti's Gauntlets", augments={'Path: A',}},
		legs="Tali'ah Sera. +2",
		feet={ name="Ankusa Gaiters +3", augments={'Enhances "Beast Healer" effect',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Isa Belt",
		left_ear="Enmerkar Earring",
		right_ear={ name="Nukumi Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','Pet: "Dbl. Atk."+7',}},
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring="Defending Ring",
		back={ name="Artio's Mantle", augments={'Pet: M.Acc.+20 Pet: M.Dmg.+20','Accuracy+20 Attack+20','Pet: "Regen"+10','Pet: Damage taken -5%',}},}
		
	sets.idle.Pet_Tank.DW = {main="Agwu's Axe",sub="Dolichenus",}

	sets.idle.Pet_DD = {
	    main="Agwu's Axe",
		sub="Sacro Bulwark",
		ammo="Hesperiidae",
		head="Tali'ah Turban +2",
		body={ name="An. Jackcoat +3", augments={'Enhances "Feral Howl" effect',}},
		hands={ name="Emi. Gauntlets +1", augments={'Pet: Accuracy+20','Pet: Attack+20','Pet: "Dbl. Atk."+4',}},
		legs={ name="Ankusa Trousers +3", augments={'Enhances "Familiar" effect',}},
		feet={ name="Gleti's Boots", augments={'Path: A',}},
		neck={ name="Bst. Collar +2", augments={'Path: A',}},
		waist="Incarnation Sash",
		left_ear="Sroda Earring",
		right_ear="Enmerkar Earring",
		left_ring="Tali'ah Ring",
		right_ring="C. Palug Ring",
		back={ name="Artio's Mantle", augments={'Pet: M.Acc.+20 Pet: M.Dmg.+20','Accuracy+20 Attack+20','Pet: "Regen"+10','Pet: Damage taken -5%',}},}

	sets.idle.Pet_DD.DW = {main="Agwu's Axe",sub="Dolichenus",}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.

    sets.engaged = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Crepuscular Helm",
		body="Tali'ah Manteel +2",
		hands={ name="Emi. Gauntlets +1", augments={'Accuracy+25','"Dual Wield"+6','Pet: Accuracy+25',}},
		legs={ name="Gleti's Breeches", augments={'Path: A',}},
		feet="Nukumi Ocreae +2",
		neck="Anu Torque",
		waist="Windbuffet Belt +1",
		left_ear="Suppanomimi",
		right_ear="Dedition Earring",
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back={ name="Artio's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
	sets.engaged.DT = {}

    sets.engaged.Acc = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Crepuscular Helm",
		body="Tali'ah Manteel +2",
		hands={ name="Emi. Gauntlets +1", augments={'Accuracy+25','"Dual Wield"+6','Pet: Accuracy+25',}},
		legs={ name="Gleti's Breeches", augments={'Path: A',}},
		feet="Nukumi Ocreae +2",
		neck="Anu Torque",
		waist="Windbuffet Belt +1",
		left_ear="Suppanomimi",
		right_ear="Dedition Earring",
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back={ name="Artio's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
	sets.engaged.Acc.DT = {}
		
	-- GEARSETS FOR MASTER ENGAGED (SINGLE-WIELD) & PET ENGAGED
	sets.engaged.BothDD = set_combine(sets.engaged,{})
	sets.engaged.BothDD.Acc = set_combine(sets.engaged.Acc, {})

	-- GEARSETS FOR MASTER ENGAGED (SINGLE-WIELD) & PET TANKING
	sets.engaged.PetTank = set_combine(sets.engaged,{})
	sets.engaged.PetTank.Acc = set_combine(sets.engaged.Acc, {})

	------------------------------------------------------------------------------------------------
	-----------------------------------------Dual Wield Sets----------------------------------------
	------------------------------------------------------------------------------------------------
		
    sets.engaged.DW = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Crepuscular Helm",
		body="Tali'ah Manteel +2",
		hands={ name="Emi. Gauntlets +1", augments={'Accuracy+25','"Dual Wield"+6','Pet: Accuracy+25',}},
		legs={ name="Gleti's Breeches", augments={'Path: A',}},
		feet={ name="Taeon Boots", augments={'Accuracy+25','"Dual Wield"+5','STR+5 DEX+5',}},
		neck="Anu Torque",
		waist="Reiki Yotai",
		left_ear="Suppanomimi",
		right_ear="Eabani Earring",
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back={ name="Artio's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
	sets.engaged.DW.DT = {}

    sets.engaged.DW.Acc = {
		ammo="Coiste Bodhar",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Gleti's Breeches",
		feet="Nyame Sollerets",
		neck="Anu Torque",
		waist="Reiki Yotai",
		left_ear="Suppanomimi",
		right_ear="Alabaster Earring",
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back="Null Shawl",}

	sets.engaged.DW.Acc.DT = {}
		
	-- GEARSETS FOR MASTER ENGAGED (DUAL-WIELD) & PET ENGAGED
	sets.engaged.DW.BothDD = set_combine(sets.engaged.DW,{})
	sets.engaged.DW.BothDD.Acc = set_combine(sets.engaged.DW.Acc, {})

	-- GEARSETS FOR MASTER ENGAGED (DUAL-WIELD) & PET TANKING
	sets.engaged.DW.PetTank = set_combine(sets.engaged.DW,{})
	sets.engaged.DW.PetTank.Acc = set_combine(sets.engaged.DW.Acc, {})


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	sets.Kiting = {left_ring="Shneddick Ring",}

    sets.TreasureHunter = {
		ammo="Per. Lucky Egg", --TH1
		body="Volte Jupon",		--TH2
		waist="Chaac Belt",} --TH+1
		
	sets.buff['Killer Instinct'] = {body="Nukumi Gausape +3"}
		
	sets.buff.Doom = set_combine(sets.buff.Doom, {neck="Nicander's Necklace",waist="Gishdubar Sash",})
	
	sets.Reraise = {head="Crepuscular Helm",body="Crepuscular Mail",}

	-- Weapons sets
	
	sets.weapons.Agwu_Axe = {main="Agwu's Axe",}
	sets.weapons.Dolichenus = {main="Dolichenus",}
	sets.weapons.Ikenga_Axe = {main="Ikenga's Axe",}
	sets.weapons.Naegling = {main="Naegling",}
	sets.weapons.Tauret = {main="Tauret",}

	sets.weapons.Agwu_Axe.DW = {main="Agwu's Axe",sub="Ikenga's Axe",}	
	sets.weapons.Dolichenus.DW = {main="Dolichenus",sub="Ikenga's Axe",}
	sets.weapons.Ikenga_Axe.DW = {main="Ikenga's Axe", sub="Agwu's Axe",}
	sets.weapons.Naegling.DW = {main="Naegling",sub="Ikenga's Axe",}
	sets.weapons.Tauret.DW = {main="Double Axe",sub="Crepuscular Knife",--[[main="Tauret",sub="Ikenga's Axe",]]}
	
	sets.Crepuscular = {sub="Crepuscular Knife",}
	
	sets.Sacro_Bulwark = {sub="Sacro Bulwark",}
	sets.Archduke = {sub="Archduke's Shield",}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Jug Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	-------------------------------------------------------------------------------------------------------------------
	-- Complete Lvl 76-99 Jug Pet Precast List +Funguar +Courier +Amigo
	-------------------------------------------------------------------------------------------------------------------

	sets.precast.JA['Bestial Loyalty'].FatsoFargann = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="C. Plasma Broth"})

--[[
	sets.precast.JA['Bestial Loyalty'].FunguarFamiliar = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Seedbed Soil"})
	sets.precast.JA['Bestial Loyalty'].CourierCarrie = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Fish Oil Broth"})
	sets.precast.JA['Bestial Loyalty'].AmigoSabotender = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Sun Water"})
	sets.precast.JA['Bestial Loyalty'].NurseryNazuna = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="D. Herbal Broth"})
	sets.precast.JA['Bestial Loyalty'].CraftyClyvonne = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Cng. Brain Broth"})
	sets.precast.JA['Bestial Loyalty'].PrestoJulio = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="C. Grass. Broth"})
	sets.precast.JA['Bestial Loyalty'].SwiftSieghard = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Mlw. Bird Broth"})
	sets.precast.JA['Bestial Loyalty'].MailbusterCetas = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Gob. Bug Broth"})
	sets.precast.JA['Bestial Loyalty'].AudaciousAnna = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="B. Carrion Broth"})
	sets.precast.JA['Bestial Loyalty'].TurbidToloi = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Auroral Broth"})
	sets.precast.JA['Bestial Loyalty'].LuckyLulush = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="L. Carrot Broth"})
	sets.precast.JA['Bestial Loyalty'].DipperYuly = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Wool Grease"})
	sets.precast.JA['Bestial Loyalty'].FlowerpotMerle = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Vermihumus"})
	sets.precast.JA['Bestial Loyalty'].DapperMac = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Briny Broth"})
	sets.precast.JA['Bestial Loyalty'].DiscreetLouise = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Deepbed Soil"})
	
	sets.precast.JA['Bestial Loyalty'].FaithfulFalcorr = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Lucky Broth"})
	sets.precast.JA['Bestial Loyalty'].BugeyedBroncha = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Svg. Mole Broth"})
	sets.precast.JA['Bestial Loyalty'].BloodclawShasra = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Rzr. Brain Broth"})
	sets.precast.JA['Bestial Loyalty'].GorefangHobs = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="B. Carrion Broth"})
	sets.precast.JA['Bestial Loyalty'].GooeyGerard = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Cl. Wheat Broth"})
	sets.precast.JA['Bestial Loyalty'].CrudeRaphie = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Shadowy Broth"})
	]]

	-------------------------------------------------------------------------------------------------------------------
	-- Complete iLvl Jug Pet Precast List
	-------------------------------------------------------------------------------------------------------------------

	sets.precast.JA['Bestial Loyalty'].BouncingBertha = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Bubbly Broth"})
	sets.precast.JA['Bestial Loyalty'].GenerousArthur = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Dire Broth"})
	sets.precast.JA['Bestial Loyalty'].SweetCaroline = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Aged Humus"})
	sets.precast.JA['Bestial Loyalty'].HeadbreakerKen = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Blackwater Broth"})
	sets.precast.JA['Bestial Loyalty'].SlimeFamiliar = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Decaying Broth"})

--[[
	sets.precast.JA['Bestial Loyalty'].DroopyDortwin = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Swirling Broth"})
	sets.precast.JA['Bestial Loyalty'].PonderingPeter = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Vis. Broth"})
	sets.precast.JA['Bestial Loyalty'].SunburstMalfik = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Shimmering Broth"})
	sets.precast.JA['Bestial Loyalty'].AgedAngus = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Ferm. Broth"})
	sets.precast.JA['Bestial Loyalty'].WarlikePatrick = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Livid Broth"})
	sets.precast.JA['Bestial Loyalty'].ScissorlegXerin = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Spicy Broth"})	
	sets.precast.JA['Bestial Loyalty'].RhymingShizuna = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Lyrical Broth"})
	sets.precast.JA['Bestial Loyalty'].AttentiveIbuki = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Salubrious Broth"})
	sets.precast.JA['Bestial Loyalty'].SwoopingZhivago = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Windy Greens"})
	sets.precast.JA['Bestial Loyalty'].AmiableRoche = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Airy Broth"})
	sets.precast.JA['Bestial Loyalty'].HeraldHenry = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Trans. Broth"})
	sets.precast.JA['Bestial Loyalty'].BrainyWaluis = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Crumbly Soil"})
	sets.precast.JA['Bestial Loyalty'].SuspiciousAlice = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Furious Broth"})
	sets.precast.JA['Bestial Loyalty'].AnklebiterJedd = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Crackling Broth"})
	sets.precast.JA['Bestial Loyalty'].FleetReinhard = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Rapid Broth"})
	sets.precast.JA['Bestial Loyalty'].CursedAnnabelle = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Creepy Broth"})
	sets.precast.JA['Bestial Loyalty'].SurgingStorm = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Insipid Broth"})
	sets.precast.JA['Bestial Loyalty'].SubmergedIyo = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Deepwater Broth"})
	sets.precast.JA['Bestial Loyalty'].RedolentCandi = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Electrified Broth"})
	sets.precast.JA['Bestial Loyalty'].AlluringHoney = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Bug-Ridden Broth"})
	sets.precast.JA['Bestial Loyalty'].CaringKiyomaro = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Fizzy Broth"})
	sets.precast.JA['Bestial Loyalty'].VivaciousVickie = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Tant. Broth"})
	sets.precast.JA['Bestial Loyalty'].HurlerPercival = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Pale Sap"})
	sets.precast.JA['Bestial Loyalty'].BlackbeardRandy = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Meaty Broth"})	
	sets.precast.JA['Bestial Loyalty'].ThreestarLynn = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Muddy Broth"})
	sets.precast.JA['Bestial Loyalty'].MosquitoFamiliar = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Wetlands Broth"})
	sets.precast.JA['Bestial Loyalty']['Left-HandedYoko'] = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Heavenly Broth"})
	sets.precast.JA['Bestial Loyalty'].BraveHeroGlenn = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Wispy Broth"})
	sets.precast.JA['Bestial Loyalty'].SharpwitHermes = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Saline Broth"})
	sets.precast.JA['Bestial Loyalty'].ColibriFamiliar = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Sugary Broth"})
	sets.precast.JA['Bestial Loyalty'].ChoralLeera = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Glazed Broth"})
	sets.precast.JA['Bestial Loyalty'].SpiderFamiliar = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Sticky Webbing"})
	sets.precast.JA['Bestial Loyalty'].GussyHachirobe = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Slimy Webbing"})
	sets.precast.JA['Bestial Loyalty'].AcuexFamiliar = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Poisonous Broth"})
	sets.precast.JA['Bestial Loyalty'].FluffyBredo = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Venomous Broth"})
	sets.precast.JA['Bestial Loyalty'].WeevilFamiliar = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Pristine Sap"})
	sets.precast.JA['Bestial Loyalty'].StalwartAngelina = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="T. Pristine Sap"})
	sets.precast.JA['Bestial Loyalty']['P.CrabFamiliar'] = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Rancid Broth"})
	sets.precast.JA['Bestial Loyalty'].JovialEdwin = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Pungent Broth"})
	sets.precast.JA['Bestial Loyalty']['Y.BeetleFamiliar'] = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Zestful Sap"})
	sets.precast.JA['Bestial Loyalty'].EnergizedSefina = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Gassy Sap"})
	sets.precast.JA['Bestial Loyalty'].LynxFamiliar = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Frizzante Broth"})
	sets.precast.JA['Bestial Loyalty'].VivaciousGaston = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Spumante Broth"})
	sets.precast.JA['Bestial Loyalty']['Hip.Familiar'] = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Turpid Broth"})
	sets.precast.JA['Bestial Loyalty'].DaringRoland = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Feculent Broth"})
	
	sets.precast.JA['Bestial Loyalty'].SultryPatrice = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Putrescent Broth"})
	]]
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
        set_macro_page(1, 9)
end

function user_job_lockstyle()
    send_command('input /lockstyleset ' .. lockstyleset)
end