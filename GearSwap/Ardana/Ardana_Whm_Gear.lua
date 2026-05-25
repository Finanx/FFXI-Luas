-- Setup vars that are user-dependent.  Can override this in a sidecar file.
function user_job_setup()
    state.OffenseMode:options('Normal','Acc')
	state.HybridMode:options('Normal', 'DT')
	state.WeaponskillMode:options('Normal')
    state.CastingMode:options('Normal','Resistant')
    state.IdleMode:options('Normal', 'DT')
	state.Weapons:options('None','Maxentius', 'Tishtrya', 'Yagrush', 'Mpaca_Staff', 'Xoanon')
	state.Subweapon = M{['description']='Sub Weapon Set', 'Ukaldi', 'Daybreak'}
	state.Shield = M{['description']='Shield Set', 'Archduke', 'Ammurapi', 'Genmei'}
	state.Grip = M{['description']='Shield Set', 'Enki'}
	
	Two_Handed_Weapons = {
		Mpaca_Staff   = true,
		Xoanon     = true,}
		
	One_Handed_Weapons = {
		Tishtrya =	true,
		Yagrush =	true,
		Maxentius = true,}
	
    state.MagicBurst = M(false, 'Magic Burst')
	state.SpellInterrupt = M(false, 'SpellInterrupt')
    state.Barspell = M{['description']='Barspell', 'Barblizzara', 'Barfira', 'Baraera', 'Barstonra', 'Barthundra', 'Barwatera'}
    state.BarStatus = M{['description']='BarStatus', 'Barparalyzra', 'Baramnesra', 'Barvira', 'Barsilencera', 'Barpetra', 'Barpoisonra', 'Barblindra', 'Barsleepra'}
    state.BoostSpell = M{['description']='BoostSpell', 'Boost-STR', 'Boost-DEX', 'Boost-INT', 'Boost-VIT', 'Boost-AGI', 'Boost-MND', 'Boost-CHR'}
	
	init_job_states({},{"Barspell","BarStatus","BoostSpell","Weapons","OffenseMode","WeaponskillMode","IdleMode","CastingMode","MagicBurst","SpellInterrupt","TreasureMode",})

	--Includes Global Bind keys
	
	send_command('wait 2; exec Global-Binds.txt')

    --White Mage binds	

	send_command('wait 2; exec /WHM/Binds.txt')
	
	--Retrieve Gear for White Mage
	
	send_command('wait 3;org get inventory whm.lua')

	--Job settings

	lockstyleset = 3
    select_default_macro_book()
end

function user_unload()

	enable('main','sub','range','ammo','head','body','hands','legs','feet','neck','waist','left_ear','right_ear','left_ring','right_ring','back')

	--Remove Global Binds

	send_command('wait 1; exec Global-UnBinds.txt')
	
	--Remove Gear for White Mage
	
	send_command('wait 1; org get Store.lua')
	
end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.JA.Benediction = {body="Piety Bliaut +3"}

	-- Waltz set (chr and vit)
    sets.precast.Waltz = {}

    -- Fast cast sets for spells
    sets.precast.FC = {
		main="Daybreak",
		sub="Genmei Shield",
		ammo="Sapience Orb",
		head="Ebers Cap +3",
		body="Inyanga Jubbah +2",
		hands={ name="Telchine Gloves", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		legs={ name="Telchine Braconi", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		feet={ name="Telchine Pigaches", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		neck="Baetyl Pendant",
		waist="Embla Sash",
		left_ear="Malignance Earring",
		right_ear="Loquac. Earring",
		left_ring="Prolix Ring",
		right_ring="Kishar Ring",
		back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},}
		
	sets.precast.FC.Impact =  set_combine(sets.precast.FC, {head=empty,body="Crepuscular Cloak"})
	sets.precast.FC.Dispelga = set_combine(sets.precast.FC, {main="Daybreak",sub="Genmei Shield"})

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {
	    ammo="Oshasha's Treatise",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Regal Earring",
		left_ring="Epaminondas's Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Aurist's Cape +1", augments={'Path: A',}},}

    sets.precast.WS['Hexa Strike'] = {
	    ammo="Oshasha's Treatise",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Mache Earring +1",
		right_ear={ name="Ebers Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+13','Mag. Acc.+13','Damage taken-4%',}},
		left_ring="Begrudging Ring",
		right_ring="Ephramad's Ring",
		back={ name="Aurist's Cape +1", augments={'Path: A',}},}
	
	sets.precast.WS['Black Halo'] = {
	    ammo="Oshasha's Treatise",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Regal Earring",
		left_ring="Epaminondas's Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Aurist's Cape +1", augments={'Path: A',}},}
	
    sets.precast.WS['Realmrazer'] = {
	    ammo="Hasty Pinion +1",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Bunzi's Gloves", augments={'Path: A',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Regal Earring",
		right_ear="Telos Earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Ephramad's Ring",
		back={ name="Aurist's Cape +1", augments={'Path: A',}},}
	
    sets.precast.WS['Flash Nova'] = {
	    ammo="Oshasha's Treatise",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Sanctity Necklace",
		waist="Fucho-no-Obi",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Malignance Earring",
		left_ring="Epaminondas's Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Aurist's Cape +1", augments={'Path: A',}},}

    sets.precast.WS['Mystic Boon'] = {}
	
    sets.precast.WS['Spirit Taker'] = sets.precast.WS['Mystic Boon']
	
	sets.precast.WS['Shell Crusher'] = {}
	
    sets.precast.WS['Shining Strike'] = {
	    ammo="Hasty Pinion +1",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','"Cure" potency +6%','"Conserve MP"+7',}},
		hands={ name="Bunzi's Gloves", augments={'Path: A',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Bunzi's Sabots",
		neck="Combatant's Torque",
		waist="Fotia Belt",
		left_ear="Mache Earring +1",
		right_ear={ name="Ebers Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+13','Mag. Acc.+13','Damage taken-4%',}},
		left_ring={ name="Cacoethic Ring +1", augments={'Path: A',}},
		right_ring="Ephramad's Ring",
		back={ name="Aurist's Cape +1", augments={'Path: A',}},}
	
	sets.precast.WS['Cataclysm'] = {}
	
	sets.precast.WS['Earth Crusher'] = {}
		
	sets.MaxTP = {}
	sets.MaxTP.Myrkr = {}
	sets.MaxTP.Dagan = {}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
	
    sets.midcast.FastRecast = {main=gear.grioavolr_fc_staff,sub="Clerisy Strap +1",ammo="Pemphredo Tathlum",
		head="Ebers Cap +3",neck="Clr. Torque +1",ear1="Loquac. Earring",ear2="Malignance Earring",
		body="Inyanga Jubbah +2",hands="Fanatic Gloves",ring1="Defending Ring",ring2="Freke Ring",
		back="Alaunus's Cape",waist="Cornelia's Belt",legs="Aya. Cosciales +2",feet="Regal Pumps +1"}
		
	sets.midcast.Raise = sets.midcast.FastRecast

    -- Cure sets

	sets.midcast['Full Cure'] = sets.midcast.FastRecast
	
	sets.midcast.Cure = {
		main="Daybreak",
		sub="Genmei Shield",
		ammo="Staunch Tathlum +1",
		head={ name="Kaykaus Mitra +1", augments={'MP+80','Spell interruption rate down +12%','"Cure" spellcasting time -7%',}},
		body="Ebers Bliaut +3",
		hands="Theophany Mitts +3",
		legs="Ebers Pant. +3",
		feet={ name="Kaykaus Boots +1", augments={'MP+80','Spell interruption rate down +12%','"Cure" spellcasting time -7%',}},
		neck={ name="Clr. Torque +2", augments={'Path: A',}},
		waist="Plat. Mog. Belt",
		left_ear="Nourish. Earring +1",
		right_ear={ name="Ebers Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+13','Mag. Acc.+13','Damage taken-4%',}},
		left_ring="Sirona's Ring",
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},}
	
	sets.midcast.LightWeatherCure	= set_combine(sets.midcast.Cure, {
		main="Chatoyant Staff",
		sub="Enki Strap",
		waist="Hachirin-no-Obi",})

	sets.midcast.Curaga = {
		main="Daybreak",
		sub="Genmei Shield",
		ammo="Staunch Tathlum +1",
		head={ name="Kaykaus Mitra +1", augments={'MP+80','Spell interruption rate down +12%','"Cure" spellcasting time -7%',}},
		body="Theo. Bliaut +3",
		hands="Theophany Mitts +3",
		legs="Ebers Pant. +3",
		feet={ name="Kaykaus Boots +1", augments={'MP+80','Spell interruption rate down +12%','"Cure" spellcasting time -7%',}},
		neck={ name="Clr. Torque +2", augments={'Path: A',}},
		waist="Plat. Mog. Belt",
		left_ear="Nourish. Earring +1",
		right_ear={ name="Ebers Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+13','Mag. Acc.+13','Damage taken-4%',}},
		left_ring="Sirona's Ring",
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back="Fi Follet Cape +1",}
		
	sets.midcast.CuragaWeather = set_combine(sets.midcast.Curaga, {
		waist="Hachirin-no-Obi",})
	
	sets.midcast.Cure_SpellInterrupt = {
		main="Daybreak",
		sub="Genmei Shield",
		ammo="Staunch Tathlum +1",
		head="Ebers Cap +3",
		body="Ebers Bliaut +3",
		hands={ name="Chironic Gloves", augments={'Mag. Acc.+4','Spell interruption rate down -11%','MND+3','"Mag.Atk.Bns."+4',}},
		legs="Ebers Pant. +3",
		feet="Theo. Duckbills +3",
		neck="Loricate Torque +1",
		waist="Plat. Mog. Belt",
		left_ear="Magnetic Earring",
		right_ear={ name="Ebers Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+13','Mag. Acc.+13','Damage taken-4%',}},
		left_ring="Sirona's Ring",
		right_ring="Murky Ring",
		back={ name="Alaunus's Cape", augments={'MND+20','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','"Fast Cast"+10','Spell interruption rate down-10%',}},}

	--Situational Healing Sets
	sets.Self_Healing = {waist="Gishdubar Sash",left_ring="Kunaji Ring",}
	sets.Cure_Received = {waist="Gishdubar Sash",left_ring="Kunaji Ring",}
	CureSelfWeather = LightWeatherCure

	sets.midcast.Cursna = {
		main="Daybreak",
		sub="Genmei Shield",
		ammo="Sapience Orb",
		head="Ebers Cap +3",
		body="Ebers Bliaut +3",
		hands="Inyan. Dastanas +2",
		legs="Th. Pant. +3",
		feet={ name="Vanya Clogs", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
		neck="Debilis Medallion",
		waist="Bishop's Sash",
		left_ear="Beatific Earring",
		right_ear={ name="Ebers Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+13','Mag. Acc.+13','Damage taken-4%',}},
		left_ring="Haoma's Ring",
		right_ring="Menelaus's Ring",
		back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},}

	sets.midcast.StatusRemoval = set_combine(sets.precast.FC, {
		head="Ebers Cap +3",
		hands="Ebers Mitts +3",
		legs={ name="Piety Pantaln. +3", augments={'Enhances "Afflatus Misery" effect',}},})
		
	sets.midcast.Erase = set_combine(sets.precast.FC, {neck="Clr. Torque +2"})

    -- 110 total Enhancing Magic Skill; caps even without Light Arts
	sets.midcast['Enhancing Magic'] = {
		main={ name="Gada", augments={'Enh. Mag. eff. dur. +6','MND+6','"Mag.Atk.Bns."+3','DMG:+14',}},
		sub="Ammurapi Shield",
		ammo="Sapience Orb",
		head={ name="Telchine Cap", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		body={ name="Telchine Chas.", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		hands={ name="Telchine Gloves", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		legs={ name="Telchine Braconi", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		feet="Theo. Duckbills +3",
		neck="Incanter's Torque",
		waist="Embla Sash",
		left_ear="Andoaa Earring",
		right_ear="Mimir Earring",
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back={ name="Alaunus's Cape", augments={'MND+20','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','"Fast Cast"+10','Spell interruption rate down-10%',}},}

	sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {})
	sets.midcast.Auspice = set_combine(sets.midcast['Enhancing Magic'], {feet="Ebers Duckbills +3"})
	sets.midcast.Aquaveil = set_combine(sets.midcast['Enhancing Magic'], {hands="Regal Cuffs",})
	
	sets.midcast.Regen = {
		main="Bolelabunga",
		sub="Ammurapi Shield",
		ammo="Sapience Orb",
		head="Inyanga Tiara +2",
		body={ name="Piety Bliaut +3", augments={'Enhances "Benediction" effect',}},
		hands="Ebers Mitts +3",
		legs="Th. Pant. +3",
		feet="Theo. Duckbills +3",
		neck="Incanter's Torque",
		waist="Embla Sash",
		left_ear="Andoaa Earring",
		right_ear="Malignance Earring",
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},}
		
	sets.midcast.BarElement = set_combine(sets.midcast['Enhancing Magic'], {
		head="Ebers Cap +3",
		body="Ebers Bliaut +3",
		hands="Ebers Mitts +3",
		legs="Piety Pantaln. +3",
		feet="Ebers Duckbills +3",})
	
	sets.midcast.BarStatus = set_combine(sets.midcast['Enhancing Magic'], {neck="Sroda Necklace"})

	sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {})	
	sets.Refresh_Received = {back="Grapevine Cape",waist="Gishdubar Sash",feet="Inspirited Boots"}
	sets.Self_Refresh = set_combine(sets.midcast['Enhancing Magic'], {back="Grapevine Cape",waist="Gishdubar Sash",feet="Inspirited Boots"})
	
	sets.midcast['Divine Magic'] = {
	    main="Daybreak",
		sub="Ammurapi Shield",
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		body={ name="Cohort Cloak +1", augments={'Path: A',}},
		hands={ name="Bunzi's Gloves", augments={'Path: A',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Bunzi's Sabots",
		neck="Baetyl Pendant",
		waist="Eschan Stone",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Freke Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Aurist's Cape +1", augments={'Path: A',}},}
		
	sets.midcast['Divine Magic'].MagicBurst = {
	    main="Bunzi's Rod",
		sub="Ammurapi Shield",
		ammo="Ghastly Tathlum +1",
		head="Bunzi's Hat",
		body="Bunzi's Robe",
		hands="Bunzi's Gloves",
		legs="Bunzi's Pants",
		feet="Bunzi's Sabots",
		neck="Sibyl Scarf",
		waist="Skrymir Cord +1",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Metamor. Ring +1",
		right_ring="Freke Ring",
		back="Aurist's Cape +1",}
		
	sets.midcast.Repose = {}
	sets.midcast.Repose.Resistant = set_combine(sets.midcast.Repose, {})
	
	sets.midcast.Impact = {
	    main={ name="Bunzi's Rod", augments={'Path: A',}},
		sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
		head=empty,
		body="Crepuscular Cloak",
		hands="Ebers Mitts +3",
		legs="Ebers Pant. +3",
		feet="Ebers Duckbills +3",
		neck="Incanter's Torque",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Malignance Earring",
		right_ear={ name="Ebers Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+13','Mag. Acc.+13','Damage taken-4%',}},
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back={ name="Aurist's Cape +1", augments={'Path: A',}},}
		
	sets.midcast['Elemental Magic'] = {
	    main="Bunzi's Rod",
		sub="Ammurapi Shield",
		ammo="Ghastly Tathlum +1",
		head="Bunzi's Hat",
		body="Bunzi's Robe",
		hands="Bunzi's Gloves",
		legs="Bunzi's Pants",
		feet="Bunzi's Sabots",
		neck="Sibyl Scarf",
		waist="Skrymir Cord +1",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Metamor. Ring +1",
		right_ring="Freke Ring",
		back="Aurist's Cape +1",}

	sets.midcast['Elemental Magic'].MagicBurst = {
	    main="Bunzi's Rod",
		sub="Ammurapi Shield",
		ammo="Ghastly Tathlum +1",
		head="Bunzi's Hat",
		body="Bunzi's Robe",
		hands="Bunzi's Gloves",
		legs="Bunzi's Pants",
		feet="Bunzi's Sabots",
		neck="Sibyl Scarf",
		waist="Skrymir Cord +1",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Metamor. Ring +1",
		right_ring="Freke Ring",
		back="Aurist's Cape +1",}
		
	sets.midcast['Dark Magic'] = {
	    main="Bunzi's Rod",
		sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
		head="Ebers Cap +3",
		body="Ebers Bliaut +3",
		hands="Ebers Mitts +3",
		legs="Ebers Pant. +3",
		feet="Ebers Duckbills +3",
		neck="Null Loop",
		waist="Null Belt",
		left_ear="Malignance Earring",
		right_ear={ name="Ebers Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+13','Mag. Acc.+13','Damage taken-4%',}},
		left_ring="Metamor. Ring +1",
		right_ring="Freke Ring",
		back="Null Shawl",}

    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {})

    sets.midcast.Aspir = sets.midcast.Drain

	sets.midcast.Stun = sets.midcast['Dark Magic']
		
	sets.midcast['Enfeebling Magic'] = {
		main="Daybreak",
		sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
		head="Ebers Cap +3",
		body="Theo. Bliaut +3",
		hands="Regal Cuffs",
		legs="Th. Pant. +3",
		feet="Theo. Duckbills +3",
		neck="Null Loop",
		waist={ name="Obstin. Sash", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Kishar Ring",
		back="Null Shawl",}

	sets.midcast['Enfeebling Magic'].Resistant = {
		main="Daybreak",
		sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
		head="Ebers Cap +3",
		body="Theo. Bliaut +3",
		hands="Regal Cuffs",
		legs="Th. Pant. +3",
		feet="Theo. Duckbills +3",
		neck="Null Loop",
		waist={ name="Obstin. Sash", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Kishar Ring",
		back="Null Shawl",}
		
	sets.midcast.Dispel = sets.midcast['Enfeebling Magic'].Resistant
	sets.midcast.Dispelga = set_combine(sets.midcast.Dispel, {main="Daybreak",sub="Ammurapi Shield"})
		
    sets.midcast.ElementalEnfeeble = set_combine(sets.midcast['Enfeebling Magic'], {})
    sets.midcast.ElementalEnfeeble.Resistant = set_combine(sets.midcast['Enfeebling Magic'].Resistant, {})

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------
	
	sets.resting = {
		main="Daybreak",
		sub="Genmei Shield",
		ammo="Staunch Tathlum +1",
		head="Null Masque",
		body="Ebers Bliaut +3",
		hands="Ebers Mitts +3",
		legs="Ebers Pant. +3",
		feet="Ebers Duckbills +3",
		neck="Sibyl Scarf",
		waist="Embla Sash",
		left_ear="Genmei Earring",
		right_ear="Etiolation Earring",
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},}

    sets.idle = {
		main="Daybreak",
		sub="Genmei Shield",
		ammo="Staunch Tathlum +1",
		head="Null Masque",
		body="Ebers Bliaut +3",
		hands="Sworn Gauntlets",
		legs="Sworn Brais",
		feet="Sworn Sabatons",
		neck="Sibyl Scarf",
		waist="Embla Sash",
		left_ear="Alabaster Earring",
		right_ear="Etiolation Earring",
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},}
		
	sets.idle.DT = {
		main="Daybreak",
		sub="Genmei Shield",
		ammo="Staunch Tathlum +1",
		head="Null Masque",
		body="Ebers Bliaut +3",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Sibyl Scarf",
		waist="Carrier's Sash",
		left_ear="Mimir Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},}
		
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Basic set for if no TP weapon is defined.
    sets.engaged = {
		ammo="White Tathlum",
		head="Bunzi's Hat",
		body="Nyame Mail",
		hands="Bunzi's Gloves",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Combatant's Torque",
		waist="Null Belt",
		left_ear="Telos Earring",
		right_ear="Crep. Earring",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back="Null Shawl",}

    sets.engaged.Acc = {
		ammo="White Tathlum",
		head="Bunzi's Hat",
		body="Nyame Mail",
		hands="Bunzi's Gloves",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Combatant's Torque",
		waist="Null Belt",
		left_ear="Telos Earring",
		right_ear="Crep. Earring",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back="Null Shawl",}

    sets.engaged.DW = {
		ammo="White Tathlum",
		head="Bunzi's Hat",
		body="Nyame Mail",
		hands="Bunzi's Gloves",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Combatant's Torque",
		waist="Null Belt",
		left_ear="Telos Earring",
		right_ear="Crep. Earring",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back="Null Shawl",}

    sets.engaged.DW.Acc = {
		ammo="White Tathlum",
		head="Bunzi's Hat",
		body="Nyame Mail",
		hands="Bunzi's Gloves",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Combatant's Torque",
		waist="Null Belt",
		left_ear="Telos Earring",
		right_ear="Crep. Earring",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back="Null Shawl",}
		
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
	
	sets.Kiting = {left_ring="Shneddick Ring",}
    sets.latent_refresh = {waist="Fucho-no-obi"}
	
	sets.TreasureHunter = {
		body="Volte Jupon",
		feet="Volte Bracers",
		waist="Chaac Belt",}
		
	sets.midcast.Dia = set_combine(sets.midcast['Enfeebling Magic'], sets.TreasureHunter)
	sets.midcast.Diaga = set_combine(sets.midcast['Enfeebling Magic'], sets.TreasureHunter)
	sets.midcast['Dia II'] = set_combine(sets.midcast['Enfeebling Magic'], sets.TreasureHunter)
	sets.midcast.Bio = set_combine(sets.midcast['Enfeebling Magic'], sets.TreasureHunter)
	sets.midcast['Bio II'] = set_combine(sets.midcast['Enfeebling Magic'], sets.TreasureHunter)

		-- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
    sets.buff['Divine Caress'] = {hands="Ebers Mitts +3",back="Mending Cape"}
    sets.buff.Sublimation = {waist="Embla Sash"}

	sets.buff.Doom = set_combine(sets.buff.Doom, {neck="Nicander's Necklace",waist="Gishdubar Sash",})

	--Weapon Sets
	
	sets.weapons.Maxentius = {main="Maxentius",}
	sets.weapons.Tishtrya = {main="Tishtrya",}
	sets.weapons.Yagrush = {main="Yagrush",}
	sets.weapons.Xoanon = {main="Xoanon", sub="Ultio Grip"}
	sets.weapons.Mpaca_Staff = {main="Mpaca's Staff",}
	
	sets.Ukaldi = {sub="Makhila +2",}
	sets.Daybreak = {sub="Daybreak",}

	sets.Enki = {sub="Enki Strap"}
	sets.Ultio = {sub="Ultio Grip"}
	
	sets.Genmei = {sub="Genmei Shield",}
	sets.Ammurapi = {sub="Ammurapi Shield",}
	sets.Archduke = {sub="Archduke's Shield",}	
	

end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 3)
end

function user_job_lockstyle()
    send_command('input /lockstyleset ' .. lockstyleset)
end