function user_job_setup()

	-- Options: Override default values
    state.OffenseMode:options('Normal')
	state.HybridMode:options('Normal', 'DT')
	state.WeaponskillMode:options('Normal')
	state.CastingMode:options('Normal','MagicBurst','Occult_Accumen')
    state.IdleMode:options('Normal', 'Aminon')
	state.Weapons:options('None','Idris','Tishtrya', 'Maxentius', 'Mpaca', 'Xoanon', 'Opashoro')
	state.Subweapon = M{['description']='Sub Weapon Set', 'Daybreak'}
	state.Shield = M{['description']='Shield Set', 'Ammurapi', 'Genmei'}
	state.UnlockGeomancy = M{'Always','Never'}
	state.ShowPetHP = M(true, 'ShowPetHP')

	state.SpellInterrupt = M(false, 'SpellInterrupt')
	
	init_job_states({},{"Weapons","OffenseMode","WeaponskillMode","IdleMode","CastingMode","UnlockGeomancy","ShowPetHP","SpellInterrupt","TreasureMode",})
	
	One_Handed_Weapons = {
		Idris	 = true,
		Tishtrya = true,
		Maxentius   = true,}
	
	indi_duration = 290
	
	--Includes Global Bind keys
	
	send_command('wait 2; exec Global-Binds.txt')

    --Geomancer	binds	

	send_command('wait 2; exec /GEO/Binds.txt')
	
	--Retrieve Gear for Geomancer
	
	send_command('wait 3;org get inventory geo.lua')
	
	lockstyleset = 19
	select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
	enable('main','sub','range','ammo','head','body','hands','legs','feet','neck','waist','left_ear','right_ear','left_ring','right_ring','back')

	--Remove Global Binds

	send_command('wait 1; exec Global-UnBinds.txt')
	
	--Remove Gear for Geomancer
	
	send_command('wait 1; org get Store.lua')
	
end

function init_gear_sets()
	
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	sets.precast.JA.Bolster = {body="Bagua Tunic +3"}
	sets.precast.JA['Life Cycle'] = {body="Geomancy Tunic +3",back="Nantosuelta's Cape"}
	sets.precast.JA['Radial Arcana'] = {feet="Bagua Sandals +3"}
	sets.precast.JA['Mending Halation'] = {legs="Bagua Pants +3"}
	sets.precast.JA['Full Circle'] = {head="Azimuth Hood +3",hands="Bagua Mitaines +3"}
	
	-- Indi Duration in slots that would normally have skill here to make entrust more efficient.
	sets.buff.Entrust = {}
	
	-- Relic hat for Blaze of Glory HP increase.
	sets.buff['Blaze of Glory'] = {head="Bagua Galero +3",}
	
	-- Fast cast sets for spells

	sets.precast.FC = {
		range="Dunna",
		head={ name="Amalric Coif +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		body="Agwu's Robe",
		hands="Agwu's Gages",
		legs="Geomancy Pants +3",
		feet="Agwu's Pigaches",
		neck="Baetyl Pendant",
		waist="Shinjutsu-no-Obi +1",
		left_ear="Loquac. Earring",
		right_ear="Malignance Earring",
		left_ring="Prolix Ring",
		right_ring="Kishar Ring",
		back={ name="Nantosuelta's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},}
		
	sets.precast.RA = {
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
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back={ name="Nantosuelta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
	
	sets.precast.FC.Impact = set_combine(sets.precast.FC, {head=empty, body="Crepuscular Cloak"})		
	sets.precast.FC.Dispelga = set_combine(sets.precast.FC, {main="Daybreak",sub="Genmei Shield"})
	
		--Set used for Icarus Wing to maximize TP gain	
	sets.precast.Wing = {}
	
	sets.precast.Prishes_Boots = set_combine(sets.precast.Wing, {feet="Prishe\'s Boots +1",})
	
    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------
	
	sets.precast.WS = {
		ammo="Crepuscular Pebble",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Alabaster Earring",
		right_ear="Moonshade Earring",
		left_ring="Ephramad's Ring",
		right_ring="Epaminondas's Ring",
		back="Null Shawl",}
		
	sets.precast.WS['Judgment'] = {
		ammo="Oshasha's Treatise",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Rep. Plat. Medal",
		waist="Cornelia's Belt",
		left_ear="Alabaster Earring",
		right_ear="Moonshade Earring",
		left_ring="Ephramad's Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Nantosuelta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
	
	sets.midcast.RA = {
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
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back={ name="Nantosuelta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
	
    sets.midcast.FastRecast = sets.precast.FC

	sets.midcast.Geomancy = {
		main="Idris",
		sub="Ammurapi Shield",
		range="Dunna",
		head="Azimuth Hood +3",
		body="Azimuth Coat +3",
		hands="Azimuth Gloves +3",
		legs="Azimuth Tights +3",
		feet="Azimuth Gaiters +3",
		neck={ name="Bagua Charm +2", augments={'Path: A',}},
		waist="Shinjutsu-no-Obi +1",
		left_ear="Magnetic Earring",
		right_ear="Mendi. Earring",
		left_ring="Freke Ring",
		right_ring="Evanescence Ring",
		back={ name="Nantosuelta's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},}

	sets.midcast.Geomancy.Indi = {
		main="Idris",
		sub="Ammurapi Shield",
		range="Dunna",
		head="Azimuth Hood +3",
		body="Azimuth Coat +3",
		hands="Azimuth Gloves +3",
		legs="Bagua Pants +3",
		feet="Azimuth Gaiters +3",
		neck={ name="Bagua Charm +2", augments={'Path: A',}},
		waist="Shinjutsu-no-Obi +1",
		left_ear="Magnetic Earring",
		right_ear="Mendi. Earring",
		left_ring="Freke Ring",
		right_ring="Evanescence Ring",
		back={ name="Nantosuelta's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},}
		
	sets.entrust = {main={ name="Solstice", augments={'Mag. Acc.+20','Pet: Damage taken -4%','"Fast Cast"+5',}},}
	
	sets.midcast.Cure = {    
		main="Daybreak",
		sub="Genmei Shield",
		ammo="Staunch Tathlum +1",
		head={ name="Vanya Hood", augments={'MND+10','Spell interruption rate down +15%','"Conserve MP"+6',}},
		body="Adamantite Armor",
		hands={ name="Vanya Cuffs", augments={'MND+10','Spell interruption rate down +15%','"Conserve MP"+6',}},
		legs={ name="Vanya Slops", augments={'MND+10','Spell interruption rate down +15%','"Conserve MP"+6',}},
		feet={ name="Vanya Clogs", augments={'MND+10','Spell interruption rate down +15%','"Conserve MP"+6',}},
		neck="Incanter's Torque",
		waist="Shinjutsu-no-Obi +1",
		left_ear="Mendi. Earring",
		right_ear="Meili Earring",
		left_ring="Stikini Ring +1",
		right_ring="Murky Ring",
		back={ name="Nantosuelta's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},}
	
	sets.midcast.Cure_SpellInterrupt = {
	    main="Daybreak",
		sub="Genmei Shield",
		ammo="Staunch Tathlum +1",
		head={ name="Vanya Hood", augments={'MND+10','Spell interruption rate down +15%','"Conserve MP"+6',}},
		body="Adamantite Armor",
		hands={ name="Vanya Cuffs", augments={'MND+10','Spell interruption rate down +15%','"Conserve MP"+6',}},
		legs={ name="Vanya Slops", augments={'MND+10','Spell interruption rate down +15%','"Conserve MP"+6',}},
		feet={ name="Vanya Clogs", augments={'MND+10','Spell interruption rate down +15%','"Conserve MP"+6',}},
		neck="Incanter's Torque",
		waist="Shinjutsu-no-Obi +1",
		left_ear="Mendi. Earring",
		right_ear="Magnetic Earring",
		left_ring="Freke Ring",
		right_ring="Murky Ring",
		back={ name="Nantosuelta's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},}
		
    sets.midcast.LightWeatherCure = set_combine(sets.midcast.Cure, {		
		waist="Hachirin-no-Obi",})

    sets.midcast.Curaga = sets.midcast.Cure
	sets.midcast.CuragaWeather = sets.midcast.LightWeatherCure

	sets.Self_Healing = {left_ring="Kunaji Ring",right_ring="Asklepian Ring",waist="Gishdubar Sash"}
	sets.Cure_Received = {left_ring="Kunaji Ring",right_ring="Asklepian Ring",waist="Gishdubar Sash"}

	sets.midcast.Cursna =  {
		main="Daybreak",
		sub="Ammurapi Shield",
		ammo="Sapience Orb",
		head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
		body={ name="Peda. Gown +4", augments={'Enhances "Enlightenment" effect',}},
		hands={ name="Peda. Bracers +3", augments={'Enh. "Tranquility" and "Equanimity"',}},
		legs="Acad. Pants +3",
		feet={ name="Vanya Clogs", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
		neck="Debilis Medallion",
		waist="Bishop's Sash",
		left_ear="Meili Earring",
		right_ear="Beatific Earring",
		left_ring="Haoma's Ring",
		right_ring="Menelaus's Ring",
		back="Oretan. Cape +1",}
	
	sets.midcast.StatusRemoval = sets.midcast.FastRecast
	
    sets.midcast['Elemental Magic'] = {
		main={ name="Bunzi's Rod", augments={'Path: A',}},
		sub="Ammurapi Shield",
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head={ name="Agwu's Cap", augments={'Path: A',}},
		body="Azimuth Coat +3",
		hands={ name="Agwu's Gages", augments={'Path: A',}},
		legs="Azimuth Tights +3",
		feet={ name="Agwu's Pigaches", augments={'Path: A',}},
		neck="Sibyl Scarf",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Freke Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Nantosuelta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},}

	sets.midcast['Elemental Magic'].MagicBurst = {
		main={ name="Bunzi's Rod", augments={'Path: A',}},
		sub="Ammurapi Shield",
		ammo="Ghastly Tathlum +1",
		head="Ea Hat +1",
		body="Azimuth Coat +3",
		hands="Agwu's Gages",
		legs="Azimuth Tights +3",
		feet="Agwu's Pigaches",
		neck="Sibyl Scarf",
		waist="Acuity Belt +1",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Freke Ring",
		right_ring="Mujin Band",
		back="Aurist's Cape +1",}
		
	sets.midcast['Elemental Magic'].Occult_Accumen = {
		main={ name="Bunzi's Rod", augments={'Path: A',}},
		sub="Ammurapi Shield",
	    ammo="Seraphic Ampulla",
		head="Agwu's Cap",
		body="Azimuth Coat +3",
		hands={ name="Merlinic Dastanas", augments={'Mag. Acc.+30','"Occult Acumen"+11','"Mag.Atk.Bns."+10',}},
		legs="Perdition Slops",
		feet={ name="Merlinic Crackows", augments={'"Occult Acumen"+11','Mag. Acc.+13',}},
		neck="Combatant's Torque",
		waist="Oneiros Rope",
		left_ear="Alabaster Earring",
		right_ear="Dedition Earring",
		left_ring={ name="Chirich Ring +1", bag="wardrobe7" },
		right_ring={ name="Chirich Ring +1", bag="wardrobe8" },
		back="Null Shawl",}
		
    sets.midcast['Dark Magic'] = {
	    main="Bunzi's Rod",
		sub="Ammurapi Shield",
		range="Dunna",
		head="Azimuth Hood +3",
		body="Geomancy Tunic +3",
		hands="Geo. Mitaines +3",
		legs="Geomancy Pants +3",
		feet="Azimuth Gaiters +3",
		neck="Null Loop",
		waist="Null Belt",
		left_ear="Alabaster Earring",
		right_ear={ name="Azimuth Earring +2", augments={'System: 1 ID: 1676 Val: 0','Mag. Acc.+16','Damage taken-6%','INT+7 MND+7',}},
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Null Shawl",}
		
    sets.midcast.Drain = {
	    main="Bunzi's Rod",
		sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
		head="Agwu's Cap",
		body="Geomancy Tunic +3",
		hands="Geo. Mitaines +3",
		legs="Azimuth Tights +3",
		feet="Agwu's Pigaches",
		neck="Erra Pendant",
		waist="Fucho-no-Obi",
		left_ear="Alabaster Earring",
		right_ear="Regal Earring",
		left_ring="Evanescence Ring",
		right_ring="Excelsis Ring",
		back="Null Shawl",}
    
    sets.midcast.Aspir = sets.midcast.Drain
		
	sets.midcast['Absorb-TP'] = {
		main="Idris",
		sub="Ammurapi Shield",
		range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
		head={ name="Amalric Coif +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		body="Agwu's Robe",
		hands="Agwu's Gages",
		legs="Geomancy Pants +3",
		feet="Agwu's Pigaches",
		neck="Erra Pendant",
		waist="Null Belt",
		left_ear="Alabaster Earring",
		right_ear="Malignance Earring",
		left_ring="Kishar Ring",
		right_ring="Stikini Ring +1",
		back={ name="Nantosuelta's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},}
		
	sets.midcast.Impact = {
		main={ name="Bunzi's Rod", augments={'Path: A',}},
		sub="Ammurapi Shield",
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head=empty,
		body="Crepuscular Cloak",
		hands={ name="Agwu's Gages", augments={'Path: A',}},
		legs="Azimuth Tights +3",
		feet={ name="Agwu's Pigaches", augments={'Path: A',}},
		neck="Sibyl Scarf",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Freke Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Aurist's Cape +1", augments={'Path: A',}},}
		
	sets.midcast.Impact.MagicBurst = {
		main={ name="Musa", augments={'Path: C',}}, 
		sub="Khonsu",
		ammo="Pemphredo Tathlum",
		head=empty, 
		body="Crepuscular Cloak",
		hands="Acad. Bracers +3",
		legs={ name="Agwu's Slops", augments={'Path: A',}},
		feet="Arbatel Loafers +3",
		neck={ name="Argute Stole +2", augments={'Path: A',}},
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Malignance Earring",
		right_ear={ name="Arbatel Earring +2", augments={'System: 1 ID: 1676 Val: 0','Mag. Acc.+18','Enmity-8','INT+11 MND+11',}},
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Aurist's Cape +1", augments={'Path: A',}},}
		
    sets.midcast.Impact.OccultAcumen = set_combine(sets.midcast['Elemental Magic'].OccultAcumen, {head=empty,body="Crepuscular Cloak"})
	
	sets.midcast['Enfeebling Magic'] = {
		main="Idris",
		sub="Ammurapi Shield",
		ammo=empty,
		range="Dunna",
		head="Azimuth Hood +3",
		body="Geomancy Tunic +3",
		hands="Azimuth Gloves +3",
		legs="Geomancy Pants +3",
		feet="Azimuth Gaiters +3",
		neck="Null Loop",
		waist="Null Belt",
		left_ear="Alabaster Earring",
		right_ear={ name="Azimuth Earring +2", augments={'System: 1 ID: 1676 Val: 0','Mag. Acc.+16','Damage taken-6%','INT+7 MND+7',}},
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Null Shawl",}
		
	sets.midcast.Dispel = sets.midcast['Enfeebling Magic']

	sets.midcast.Dispelga = set_combine(sets.midcast.Dispel, {main="Daybreak",sub="Ammurapi Shield"})
		
    sets.midcast.ElementalEnfeeble = set_combine(sets.midcast['Enfeebling Magic'], {})
	
	sets.midcast['Divine Magic'] = set_combine(sets.midcast['Enfeebling Magic'], {})
		
	sets.midcast['Enhancing Magic'] = {
	    main="Idris",
		sub="Ammurapi Shield",
		range="Dunna",
		head={ name="Telchine Cap", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		body={ name="Telchine Chas.", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		hands={ name="Telchine Gloves", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		legs={ name="Telchine Braconi", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		feet={ name="Telchine Pigaches", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		neck="Incanter's Torque",
		waist="Embla Sash",
		left_ear="Mimir Earring",
		right_ear="Andoaa Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Fi Follet Cape +1",}
		
	sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {neck="Nodens Gorget",})
	
	sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {head="Amalric Coif +1"})
	
	sets.Self_Refresh = set_combine(sets.midcast.Refresh, {back="Grapevine Cape",waist="Gishdubar Sash",feet="Inspirited Boots"})
	sets.Refresh_Received = {back="Grapevine Cape",waist="Gishdubar Sash",feet="Inspirited Boots"}
	
	sets.midcast.Aquaveil = set_combine(sets.midcast['Enhancing Magic'], {head="Amalric Coif +1",hands="Regal Cuffs",})
	
	sets.midcast.BarElement = set_combine(sets.precast.FC['Enhancing Magic'], {})

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

	-- Resting sets
	sets.resting = {}

	-- Idle sets

	sets.idle = {
		main="Mpaca's Staff",
		sub="Khonsu",
		ammo={empty, priority=20 },
		range="Dunna",
		head="Null Masque",
		body="Azimuth Coat +3",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Azimuth Gaiters +3",
		neck="Sibyl Scarf",
		waist="Carrier's Sash",
		left_ear="Alabaster Earring",
		right_ear="Sanare Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Nantosuelta's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},}
		
	sets.idle.Aminon = {
		main="Mpaca's Staff",
		sub="Khonsu",
		ammo={empty, priority=20 },
		range="Dunna",
		head="Null Masque",
		body="Azimuth Coat +3",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Azimuth Gaiters +3",
		neck="Sibyl Scarf",
		waist="Carrier's Sash",
		left_ear="Alabaster Earring",
		right_ear="Sanare Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Nantosuelta's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},}
		
	-- .Pet sets are for when Luopan is present.
	sets.idle.Pet = {
		main="Idris",
		sub="Genmei Shield",
		ammo={empty, priority=20 },
		range="Dunna",
		head="Azimuth Hood +3",
		body="Azimuth Coat +3",
		hands="Geo. Mitaines +3",
		legs="Agwu's Slops",
		feet="Bagua Sandals +3",
		neck={ name="Bagua Charm +2", augments={'Path: A',}},
		waist="Isa Belt",
		left_ear="Alabaster Earring",
		right_ear="Sanare Earring",
		left_ring="Stikini Ring +1",
		right_ring="Murky Ring",
		back={ name="Nantosuelta's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Pet: "Regen"+10','Pet: "Regen"+5',}},}
		
	sets.idle.Aminon.Pet = {
		main="Idris",
		sub="Genmei Shield",
		ammo={empty, priority=20 },
		range="Dunna",
		head="Null Masque",
		body="Azimuth Coat +3",
		hands="Geo. Mitaines +3",
		legs="Agwu's Slops",
		feet="Bagua Sandals +3",
		neck={ name="Bagua Charm +2", augments={'Path: A',}},
		waist="Isa Belt",
		left_ear="Alabaster Earring",
		right_ear="Sanare Earring",
		left_ring="Stikini Ring +1",
		right_ring="Murky Ring",
		back={ name="Nantosuelta's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Pet: "Regen"+10','Pet: "Regen"+5',}},}

	--[[ .Indi sets are for when an Indi-spell is active.
	sets.idle.Indi = set_combine(sets.idle, {})
	sets.idle.Pet.Indi = set_combine(sets.idle.Pet, {}) 
	sets.idle.Refresh.Indi = set_combine(sets.idle.Refresh, {}) 
	sets.idle.Refresh.Pet.Indi = set_combine(sets.idle.Refresh.Pet, {})
	]]
	
	sets.idle.rollers = set_combine(sets.idle, {right_ring="Roller's Ring",})
	sets.idle.Aminon.rollers = set_combine(sets.idle.Aminon, {right_ring="Roller's Ring",})
	
	sets.idle.Pet.rollers = set_combine(sets.idle.Pet, {right_ring="Roller's Ring",})
	sets.idle.Aminon.Pet.rollers = set_combine(sets.idle.Aminon.Pet, {right_ring="Roller's Ring",})

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	-- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
	-- sets if more refined versions aren't defined.
	-- If you create a set with both offense and defense modes, the offense mode should be first.
	-- EG: sets.engaged.Dagger.Accuracy.Evasion

	-- Normal melee group
	sets.engaged = {
		main="Idris",	--replace with Aeonic
		sub="Ammurapi Shield",
		ammo="White Tathlum",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Gazu Bracelets +1",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Combatant's Torque",	--replace with lissome necklace
		waist="Windbuffet Belt +1",
		left_ear="Cessance Earring",
		right_ear="Brutal Earring",
		left_ring={ name="Chirich Ring +1", bag="wardrobe7" },
		right_ring={ name="Chirich Ring +1", bag="wardrobe8" },
		back="Null Shawl",}
		
	----------------------------------------Full DT Sets---------------------------------------------

    sets.engaged.DT =  {
		main="Idris",	--replace with Aeonic
		sub="Ammurapi Shield",
		ammo="White Tathlum",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Gazu Bracelets +1",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Combatant's Torque",	--replace with lissome necklace
		waist="Windbuffet Belt +1",
		left_ear="Cessance Earring",
		right_ear="Dedition Earring",
		left_ring="Murky Ring",
		right_ring="Chirich Ring +1",
		back="Null Shawl",}
		
	------------------------------------------------------------------------------------------------
	----------------------------------------Dual Wield Sets ----------------------------------------
	------------------------------------------------------------------------------------------------
	
	sets.engaged.DW = {
		main="Idris",	--replace with Aeonic
		sub="Genmei Shield",	--replace with Ternion
		ammo="White Tathlum",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Gazu Bracelets +1",
		legs="Jhakri Slops +2",
		feet="Nyame Sollerets",
		neck="Combatant's Torque",	--replace with lissome necklace
		waist="Windbuffet Belt +1",
		left_ear="Dedition Earring",
		right_ear="Brutal Earring",
		left_ring="Petrov Ring",
		right_ring="Chirich Ring +1",
		back="Null Shawl",}
		
	----------------------------------------Full DT Sets---------------------------------------------

    sets.engaged.DW.DT = {
		main="Idris",	--replace with Aeonic
		sub="Genmei Shield",	--replace with Ternion
		ammo="White Tathlum",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Null Loop",			--replace with lissome necklace
		waist="Windbuffet Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Cessance Earring",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back="Null Shawl",}		--replace with JSE cape Dex + Dual Wield

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
	
	sets.latent_refresh = {waist="Fucho-no-obi"}
	
	sets.buff.Sublimation = {waist="Embla Sash"}
	
	sets.buff.Doom = set_combine(sets.buff.Doom, {neck="Nicander's Necklace",waist="Gishdubar Sash"})
	
	sets.Kiting = {left_ring="Shneddick Ring"}
		
	sets.TreasureHunter = {
		body="Volte Jupon",
		hands="Volte Bracers",
		waist="Chaac Belt",}
		
	sets.midcast.Dia = set_combine(sets.midcast['Enfeebling Magic'], sets.TreasureHunter)
	sets.midcast.Diaga = set_combine(sets.midcast['Enfeebling Magic'], sets.TreasureHunter)
	sets.midcast.Bio = set_combine(sets.midcast['Enfeebling Magic'], sets.TreasureHunter)
	
	--Weapon Sets
	
	sets.weapons.Idris = {main="Idris",}
	sets.weapons.Tishtrya = {main="Tishtrya",}
	sets.weapons.Maxentius = {main="Maxentius",}
	sets.weapons.Mpaca = {main={ name="Mpaca's Staff", augments={'Path: A',}}, sub="Khonsu"}
	sets.weapons.Xoanon = {main="Xoanon", sub="Khonsu"}
	sets.weapons.Opashoro = {main="Opashoro", sub="Khonsu"}	
	
	sets.Ammurapi = {sub="Ammurapi Shield"}
	sets.Genmei = {sub="Genmei Shield"}

	sets.Daybreak = {sub="Daybreak",}
	
	sets.Ultio = {sub="Ultio Grip"}
	sets.Khonsu = {sub="Khonsu"}


end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 19)
end

function user_job_lockstyle()
    send_command('input /lockstyleset ' .. lockstyleset)
end