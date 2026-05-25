function user_job_setup()
	-- Options: Override default values
    state.OffenseMode:options('Normal', 'Acc')
	state.HybridMode:options('Normal', 'DT', 'Defense')
    state.WeaponskillMode:options('Normal', 'ATKCAP')
    state.CastingMode:options('Normal')
    state.IdleMode:options('Normal', 'Refresh')
	state.Weapons:options('Naegling', 'Tizona', 'Maxentius', 'Bunzi')
	state.Subweapon = M{['description']='Sub Weapon Set', 'Thibron', 'Sakpata', 'Zantetsuken',}

	state.SpellInterrupt = M(false, 'SpellInterrupt')
	
	init_job_states({},{"Weapons","Subweapon","OffenseMode","WeaponskillMode","IdleMode","CastingMode","TreasureMode",})

	--Includes Global Bind keys
	
	send_command('wait 2; exec Global-Binds.txt')

	--Blue Mage Binds
	
	send_command('wait 2; exec /BLU/Binds.txt')
	
	--Gear Retrieval Scripts
	
	send_command('wait 10; exec /BLU/Gear-Retrieval.txt')
	
	--Job settings

	lockstyleset = 15
	select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
	enable('main','sub','range','ammo','head','body','hands','legs','feet','neck','waist','left_ear','right_ear','left_ring','right_ring','back')

	--Remove Global Binds

	send_command('wait 1; exec Global-UnBinds.txt')
	
	--Gear Removal Script
	
	send_command('wait 1; org get Store.lua')
	
end

function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	sets.precast.JA['Azure Lore'] = {hands="Luh. Bazubands +1"}
	sets.buff['Burst Affinity'] = {legs="Assim. Shalwar +3",feet="Hashi. Basmak +3"}
	sets.buff['Chain Affinity'] = {feet="Assim. Charuqs +1"}
	sets.buff.Convergence = {head="Luh. Keffiyeh +3"}
	sets.buff.Diffusion = {feet="Luhlaza Charuqs +3"}
	sets.buff.Enchainment = {body="Luhlaza Jubbah +3",}
	sets.buff.Efflux = {legs="Hashishin Tayt +3"}

    -- Enmity set
    sets.Enmity = {
		ammo="Sapience Orb",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Emet Harness +1", augments={'Path: A',}},
		hands="Hashi. Bazu. +3",
		legs={ name="Zoar Subligar +1", augments={'Path: A',}},
		feet="Ahosi Leggings",
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Kasiri Belt",
		left_ear="Cryptic Earring",
		right_ear="Friomisi Earring",
		left_ring="Begrudging Ring",
		right_ring="Eihwaz Ring",
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

	sets.precast.JA['Provoke'] = sets.Enmity

	-- Waltz set (chr and vit)
    sets.precast.Waltz = {legs="Dashing Subligar",waist="Gishdubar Sash",}
	
	sets.Self_Waltz = {body="Passion Jacket",ring1="Asklepian Ring"}

	-- Don't need any special gear for Healing Waltz.
	sets.precast.Waltz['Healing Waltz'] = {legs="Dashing Subligar",}

	sets.precast.Step = {}

    sets.precast.Flourish1 = {
		ammo="Yamarang",
		head="Maculele Tiara +3",
		body={ name="Horos Casaque +4", augments={'Enhances "No Foot Rise" effect',}},
		hands="Macu. Bangles +3",
		legs="Maculele Tights +3",
		feet="Macu. Toe Sh. +3",
		neck={ name="Etoile Gorget +2", augments={'Path: A',}},
		waist="Eschan Stone",
		left_ear="Crep. Earring",
		right_ear="Digni. Earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
    sets.precast.Flourish1['Animated Flourish'] = sets.Enmity

	-- Fast cast sets for spells

	sets.precast.FC = {
		ammo="Sapience Orb",
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body={ name="Adhemar Jacket +1", augments={'HP+105','"Fast Cast"+10','Magic dmg. taken -4',}},
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
		feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
		neck="Orunmila's Torque",
		waist="Witful Belt",
		left_ear="Loquac. Earring",
		right_ear="Etiolation Earring",
		left_ring="Prolix Ring",
		right_ring="Kishar Ring",
		back={ name="Fi Follet Cape +1", augments={'Path: A',}},}

	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {body="Passion Jacket"})

	sets.precast.FC['Blue Magic'] = set_combine(sets.precast.FC, {body="Hashishin Mintan +3"})
	
		--Set used for Icarus Wing to maximize TP gain	
	sets.precast.Wing = {}
		
	sets.precast.Volte_Harness = set_combine(sets.precast.Wing, {body="Volte Harness"})
	sets.precast.Prishes_Boots = set_combine(sets.precast.Wing, {feet="Prishe\'s Boots +1",})
	
    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {
		ammo="Oshasha's Treatise",
		head="Hashishin Kavuk +3",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Mirage Stole +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Sroda Ring",
		back={ name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

    sets.precast.WS.ATKCAP = {
		ammo="Crepuscular Pebble",
		head="Hashishin Kavuk +3",
		body={ name="Gleti's Cuirass", augments={'Path: A',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Gleti's Breeches", augments={'Path: A',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Mirage Stole +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Sroda Ring",
		back={ name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

	sets.precast.WS.FullTPPhysical = {left_ear="Ishvara Earring",{ name="Hashi. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','"Dbl.Atk."+5',}},}
	sets.precast.WS.FullTPMagical = {left_ear="Regal Earring",right_ear="Friomisi Earring",}

    sets.precast.WS['Chant du Cygne'] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body={ name="Gleti's Cuirass", augments={'Path: A',}},
		hands={ name="Gleti's Gauntlets", augments={'Path: A',}},
		legs={ name="Gleti's Breeches", augments={'Path: A',}},
		feet={ name="Gleti's Boots", augments={'Path: A',}},
		neck={ name="Mirage Stole +2", augments={'Path: A',}},
		waist="Fotia Belt",
		left_ear="Odr Earring",
		right_ear="Mache Earring +1",
		left_ring="Begrudging Ring",
		right_ring="Epona's Ring",
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}},}

    sets.precast.WS['Vorpal Blade'] = sets.precast.WS['Chant du Cygne']

    sets.precast.WS['Savage Blade'] = {
		ammo="Oshasha's Treatise",
		head="Hashishin Kavuk +3",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Mirage Stole +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Sroda Ring",
		back={ name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

    sets.precast.WS['Savage Blade'].ATKCAP = {
		ammo="Crepuscular Pebble",
		head="Hashishin Kavuk +3",
		body={ name="Gleti's Cuirass", augments={'Path: A',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Gleti's Breeches", augments={'Path: A',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Mirage Stole +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Sroda Ring",
		back={ name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

    sets.precast.WS['Requiescat'] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Hashishin Kavuk +3",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Gleti's Breeches", augments={'Path: A',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear={ name="Hashi. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','"Dbl.Atk."+5',}},
		left_ring="Epaminondas's Ring",
		right_ring="Epona's Ring",
		back={ name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

    sets.precast.WS['Expiacion'] = {
		ammo="Oshasha's Treatise",
		head="Hashishin Kavuk +3",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Mirage Stole +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Epaminondas's Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

    sets.precast.WS['Expiacion'].ATKCAP = {
		ammo="Crepuscular Pebble",
		head="Hashishin Kavuk +3",
		body={ name="Gleti's Cuirass", augments={'Path: A',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Gleti's Breeches", augments={'Path: A',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Mirage Stole +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Epaminondas's Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

    sets.precast.WS['Sanguine Blade'] = {
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head="Pixie Hairpin +1",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Jhakri Cuffs +2",
		legs={ name="Luhlaza Shalwar +3", augments={'Enhances "Assimilation" effect',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Sibyl Scarf",
		waist="Orpheus's Sash",
		left_ear="Regal Earring",
		right_ear="Friomisi Earring",
		left_ring="Archon Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},}
		
	sets.precast.WS['Red Lotus Blade'] = {
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Jhakri Cuffs +2",
		legs={ name="Luhlaza Shalwar +3", augments={'Enhances "Assimilation" effect',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Sibyl Scarf",
		waist="Orpheus's Sash",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Friomisi Earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Epaminondas's Ring",
		back={ name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},}
		
		
	sets.precast.WS['Burning Blade'] = sets.precast.WS['Red Lotus Blade']
	sets.precast.WS['Shining Blade'] = sets.precast.WS['Red Lotus Blade']
	sets.precast.WS['Seraph Blade'] = sets.precast.WS['Red Lotus Blade']
	
	--Club Weapon Skills
	
    sets.precast.WS['True Strike'] = sets.precast.WS['Savage Blade']
    sets.precast.WS['True Strike'].ATKCAP = sets.precast.WS['Savage Blade'].ATKCAP
    sets.precast.WS['Judgment'] = sets.precast.WS['Savage Blade']
    sets.precast.WS['Judgment'].ATKCAP = sets.precast.WS['Savage Blade'].ATKCAP
    sets.precast.WS['Black Halo'] = sets.precast.WS['Savage Blade']
    sets.precast.WS['Black Halo'].ATKCAP = sets.precast.WS['Savage Blade'].ATKCAP
    sets.precast.WS['Realmrazer'] = sets.precast.WS['Requiescat']

    sets.precast.WS['Flash Nova'] = sets.precast.WS['Red Lotus Blade']

	-- Swap to these on Moonshade using WS if at 3000 TP
	sets.MaxTP = {ear1="Cessance Earring",ear2="Brutal Earring"}
	sets.AccMaxTP = {ear1="Regal Earring",ear2="Telos Earring"}
	
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	-- Midcast Sets
	sets.midcast.FastRecast = sets.precast.FC

	sets.midcast['Blue Magic'] = {}

	-- Physical Spells --

	sets.midcast['Blue Magic'].Physical = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Hashishin Kavuk +3",
		body="Hashishin Mintan +3",
		hands="Hashi. Bazu. +3",
		legs="Hashishin Tayt +3",
		feet="Hashi. Basmak +3",
		neck={ name="Mirage Stole +2", augments={'Path: A',}},
		waist="Eschan Stone",
		left_ear="Telos Earring",
		right_ear={ name="Hashi. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','"Dbl.Atk."+5',}},
		left_ring="Ilabrat Ring",
		right_ring="Excelsis Ring",
		back={ name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

	sets.midcast['Blue Magic'].PhysicalStr = set_combine(sets.midcast['Blue Magic'].Physical, {})
	sets.midcast['Blue Magic'].PhysicalDex = set_combine(sets.midcast['Blue Magic'].Physical, {})
	sets.midcast['Blue Magic'].PhysicalVit = set_combine(sets.midcast['Blue Magic'].Physical, {})
	sets.midcast['Blue Magic'].PhysicalAgi = set_combine(sets.midcast['Blue Magic'].Physical, {})
	sets.midcast['Blue Magic'].PhysicalInt = set_combine(sets.midcast['Blue Magic'].Physical, {})
	sets.midcast['Blue Magic'].PhysicalMnd = set_combine(sets.midcast['Blue Magic'].Physical, {})
	sets.midcast['Blue Magic'].PhysicalChr = set_combine(sets.midcast['Blue Magic'].Physical, {})
	sets.midcast['Blue Magic'].PhysicalHP = set_combine(sets.midcast['Blue Magic'].Physical, {})

	-- Magical Spells --

	sets.midcast['Blue Magic'].Magical = {
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head="Hashishin Kavuk +3",
		body="Hashishin Mintan +3",
		hands="Hashi. Bazu. +3",
		legs={ name="Luhlaza Shalwar +3", augments={'Enhances "Assimilation" effect',}},
		feet="Hashi. Basmak +3",
		neck="Sibyl Scarf",
		waist="Orpheus's Sash",
		left_ear="Friomisi Earring",
		right_ear="Regal Earring",
		left_ring="Shiva Ring +1",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},}
		
	sets.midcast['Blue Magic'].MagicalMnd = set_combine(sets.midcast['Blue Magic'].Magical, {right_ring={ name="Stikini Ring +1", bag="wardrobe8" },})
	sets.midcast['Blue Magic'].MagicalChr = set_combine(sets.midcast['Blue Magic'].Magical, {})
	sets.midcast['Blue Magic'].MagicalVit = set_combine(sets.midcast['Blue Magic'].Magical, {})
	sets.midcast['Blue Magic'].MagicalDex = set_combine(sets.midcast['Blue Magic'].Magical, {})

	sets.midcast['Blue Magic'].MagicAccuracy = {
		ammo="Pemphredo Tathlum",
		head="Hashishin Kavuk +3",
		body="Hashishin Mintan +3",
		hands="Hashi. Bazu. +3",
		legs="Hashishin Tayt +3",
		feet="Hashi. Basmak +3",
		neck={ name="Mirage Stole +2", augments={'Path: A',}},
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Crep. Earring",
		right_ear={ name="Hashi. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','"Dbl.Atk."+5',}},
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Aurist's Cape +1", augments={'Path: A',}},}
		
	sets.midcast['Blue Magic'].TPDrain = {
		ammo="Pemphredo Tathlum",
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body="Hashishin Mintan +3",
		hands="Hashi. Bazu. +3",
		legs="Hashishin Tayt +3",
		feet="Hashi. Basmak +3",
		neck={ name="Mirage Stole +2", augments={'Path: A',}},
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Crep. Earring",
		right_ear={ name="Hashi. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','"Dbl.Atk."+5',}},
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Aurist's Cape +1", augments={'Path: A',}},}
		
	sets.midcast['Blue Magic']['Reaving Wind'] = sets.midcast['Blue Magic'].TPDrain
	
	sets.midcast['Blue Magic']['Feather Tickle'] = sets.midcast['Blue Magic'].TPDrain
	
	-- Breath Spells --

	sets.midcast['Blue Magic'].Breath = sets.midcast['Blue Magic'].Magical

	-- Physical Added Effect Spells most notably "Stun" spells --

	sets.midcast['Blue Magic'].Stun = sets.midcast['Blue Magic'].MagicAccuracy

	-- Other Specific Spells --

	sets.midcast['Blue Magic'].AoEHealing = {}

	sets.midcast['Blue Magic'].Healing = {
		ammo="Staunch Tathlum +1",
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body="Hashishin Mintan +3",
		hands={ name="Telchine Gloves", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +9',}},
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		feet={ name="Telchine Pigaches", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +10',}},
		neck="Phalaina Locket",
		waist="Luminary Sash",
		left_ear="Mendi. Earring",
		right_ear="Meili Earring",
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
	sets.midcast['Blue Magic'].SkillBasedBuff = {}

	sets.midcast['Blue Magic'].Buff = {}

	sets.midcast['Blue Magic']['Battery Charge'] = set_combine(sets.midcast['Blue Magic'].Buff, {head="Amalric Coif +1",back="Grapevine Cape",waist="Gishdubar Sash"})

	sets.midcast['Blue Magic']['Carcharian Verve'] = set_combine(sets.midcast['Blue Magic'].Buff, {head="Amalric Coif +1",hands="Regal Cuffs",})
	
	sets.midcast['Enfeebling Magic'] = {}

	sets.midcast['Dark Magic'] = {}

	sets.midcast['Enhancing Magic'] = {
		ammo="Staunch Tathlum +1",
		head={ name="Telchine Cap", augments={'"Fast Cast"+4','Enh. Mag. eff. dur. +10',}},
		body={ name="Telchine Chas.", augments={'Enh. Mag. eff. dur. +10',}},
		hands={ name="Telchine Gloves", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +9',}},
		legs={ name="Telchine Braconi", augments={'"Fast Cast"+3','Enh. Mag. eff. dur. +10',}},
		feet={ name="Telchine Pigaches", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +10',}},
		neck="Incanter's Torque",
		waist="Olympus Sash",
		left_ear="Mimir Earring",
		right_ear="Andoaa Earring",
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
	sets.midcast['Phalanx'] = set_combine(sets.midcast['Enhancing Magic'],{})

	sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {head="Amalric Coif +1"})

	sets.midcast.Aquaveil = set_combine(sets.midcast['Enhancing Magic'], {head="Amalric Coif +1",hands="Regal Cuffs",})

	sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {})

	sets.midcast.BarElement = set_combine(sets.precast.FC['Enhancing Magic'], {})
	
	sets.midcast['Divine Magic'] = {}

	sets.midcast['Elemental Magic'] = {}

	sets.element.Dark = {head="Pixie Hairpin +1",right_ring="Archon Ring"}
	sets.element.Light = {} --ring2="Weatherspoon Ring"

	sets.midcast.Cure = {
		ammo="Staunch Tathlum +1",
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body="Hashishin Mintan +3",
		hands={ name="Telchine Gloves", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +9',}},
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		feet={ name="Telchine Pigaches", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +10',}},
		neck="Phalaina Locket",
		waist="Luminary Sash",
		left_ear="Mendi. Earring",
		right_ear="Meili Earring",
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
	sets.midcast.Curaga = {}
		
	sets.midcast.Cure_SpellInterrupt = {}
	
	sets.midcast.LightWeatherCure = {}
	
	sets.midcast.CureSelf = {}
	
	sets.midcast.CureSelfWeather = {}
		
	sets.midcast.Cursna =  set_combine(sets.midcast.Cure, {neck="Debilis Medallion",hands="Hieros Mittens",
		back="Oretan. Cape +1",ring1="Haoma's Ring",ring2="Menelaus's Ring",waist="Witful Belt"})

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

	sets.resting = {
		ammo="Staunch Tathlum +1",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body="Hashishin Mintan +3",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Sibyl Scarf",
		waist="Flume Belt +1",
		left_ear="Eabani Earring",
		right_ear="Infused Earring",
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    sets.idle = {
		head="Null Masque",
		body="Hashishin Mintan +3",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Sibyl Scarf",
		waist="Flume Belt +1",
		left_ear="Eabani Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Shneddick Ring",
		right_ring="Stikini Ring +1",
		back="Null Shawl",}

    sets.idle.Refresh = {
		ammo="Staunch Tathlum +1",
		head="Null Masque",
		body="Hashishin Mintan +3",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Sibyl Scarf",
		waist="Flume Belt +1",
		left_ear="Genmei Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
	sets.idle.Bumba = {
	    ammo="Staunch Tathlum +1",
		head="Hashishin Kavuk +3",
		body="Hashishin Mintan +3",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs="Hashishin Tayt +3",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Warder's Charm +1", augments={'Path: A',}},
		waist="Flume Belt +1",
		left_ear="Eabani Earring",
		right_ear="Magnetic Earring",
		left_ring="Shadow Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	sets.engaged = {
		ammo="Coiste Bodhar",
		head="Malignance Chapeau",
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs="Gleti's Breeches",
		feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
		neck={ name="Mirage Stole +2", augments={'Path: A',}},
		waist="Windbuffet Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Suppanomimi",
		left_ring="Petrov Ring",
		right_ring="Epona's Ring",
		back="Null Shawl",}

	sets.engaged.AM = {}

	sets.engaged.Acc = {
		ammo="Coiste Bodhar",
		head="Malignance Chapeau",
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs="Gleti's Breeches",
		feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
		neck={ name="Mirage Stole +2", augments={'Path: A',}},
		waist="Windbuffet Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Suppanomimi",
		left_ring="Petrov Ring",
		right_ring="Epona's Ring",
		back="Null Shawl",}

	sets.engaged.Acc.AM = {}

	sets.engaged.DT = {
		ammo="Coiste Bodhar",
		head="Malignance Chapeau",
		body="Gleti's Cuirass",
		hands="Malignance Gloves",
		legs="Gleti's Breeches",
		feet="Nyame Sollerets",
		neck={ name="Mirage Stole +2", augments={'Path: A',}},
		waist="Reiki Yotai",
		left_ear="Alabaster Earring",
		right_ear="Eabani Earring",
		left_ring="Chirich Ring +1",
		right_ring="Epona's Ring",
		back="Null Shawl",}

	sets.engaged.DT.AM = {}

	sets.engaged.Acc.DT = {
		ammo="Coiste Bodhar",
		head="Malignance Chapeau",
		body="Gleti's Cuirass",
		hands="Malignance Gloves",
		legs="Gleti's Breeches",
		feet="Nyame Sollerets",
		neck={ name="Mirage Stole +2", augments={'Path: A',}},
		waist="Reiki Yotai",
		left_ear="Alabaster Earring",
		right_ear="Eabani Earring",
		left_ring="Chirich Ring +1",
		right_ring="Epona's Ring",
		back="Null Shawl",}
				
	sets.engaged.Acc.DT.AM = {}
	
	sets.engaged.Defense = {
		ammo="Coiste Bodhar",
		head="Nyame Helm",
		body="Gleti's Cuirass",
		hands="Nyame Gauntlets",
		legs="Gleti's Breeches",
		feet="Nyame Sollerets",
		neck={ name="Mirage Stole +2", augments={'Path: A',}},
		waist="Reiki Yotai",
		left_ear="Alabaster Earring",
		right_ear="Eabani Earring",
		left_ring="Petrov Ring",
		right_ring="Epona's Ring",
		back="Null Shawl",}

	sets.engaged.Defense.AM = {}

	sets.engaged.Acc.Defense = {
		ammo="Coiste Bodhar",
		head="Nyame Helm",
		body="Gleti's Cuirass",
		hands="Nyame Gauntlets",
		legs="Gleti's Breeches",
		feet="Nyame Sollerets",
		neck={ name="Mirage Stole +2", augments={'Path: A',}},
		waist="Reiki Yotai",
		left_ear="Alabaster Earring",
		right_ear="Eabani Earring",
		left_ring="Petrov Ring",
		right_ring="Epona's Ring",
		back="Null Shawl",}
				
	sets.engaged.Acc.Defense.AM = {}

	sets.Self_Healing = {waist="Gishdubar Sash"}
	sets.Cure_Received = {neck="Phalaina Locket",hands="Buremte Gloves",ring2="Kunaji Ring",waist="Gishdubar Sash"}
	
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	sets.Kiting = {left_ring="Shneddick Ring",}

	sets.latent_refresh = {waist="Fucho-no-obi"}
	
	sets.buff.Doom = set_combine(sets.buff.Doom, {neck="Nicander's Necklace", waist="Gishdubar Sash",})
	
	sets.Refresh_Received = {back="Grapevine Cape",waist="Gishdubar Sash",feet="Inspirited Boots"}
	sets.Self_Refresh = {back="Grapevine Cape",waist="Gishdubar Sash"}
	
	sets.Phalanx_Received = {}
	
	sets.TreasureHunter = {
		ammo="Per. Lucky Egg", --TH1
		body="Volte Jupon",		--TH2
		waist="Chaac Belt",} --TH+1
		
	sets.midcast.Dia = set_combine(sets.midcast['Enfeebling Magic'], sets.TreasureHunter)
	sets.midcast.Diaga = set_combine(sets.midcast['Enfeebling Magic'], sets.TreasureHunter)
	sets.midcast.Bio = set_combine(sets.midcast['Enfeebling Magic'], sets.TreasureHunter)

	-- Gear for learning spells: +skill and AF hands.
	sets.Learning = {hands="Assim. Bazu. +3"}
	
	--Weapon Sets
	
	sets.weapons.Tizona = {main="Tizona",}
	sets.weapons.Naegling = {main="Naegling",}
	sets.weapons.Maxentius = {main="Maxentius",}
	sets.weapons.Bunzi = {main={ name="Bunzi's Rod", augments={'Path: A',}},}
	
	sets.Thibron = {sub={ name="Machaera +2", augments={'TP Bonus +1000',}},}
	sets.Sakpata = {sub="Sakpata's Sword",}
	sets.Zantetsuken = {sub="Zantetsuken"}
	
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
	if player.sub_job == 'RDM' then
        set_macro_page(10, 15)
    else
        set_macro_page(1, 15)
    end
end

function user_job_lockstyle()
    send_command('input /lockstyleset ' .. lockstyleset)
end