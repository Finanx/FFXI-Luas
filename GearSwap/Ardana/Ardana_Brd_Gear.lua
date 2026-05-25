function user_job_setup()
	-- Options: Override default values
	state.OffenseMode:options('Normal','ACC')
	state.WeaponskillMode:options('Normal','ATKCAP')
	state.HybridMode:options('Normal','DT')
	state.CastingMode:options('Normal','Resistant')
	state.IdleMode:options('Normal', 'Aminon', 'Refresh')
	state.Weapons:options('None','Naegling','Onion','Carnwenhan','Twashtar','Mpu_Gandring','Mandau','Tauret','Xoanon')
	state.Subweapon = M{['description']='Sub Weapon Set', 'Centovente', 'Crepuscular', 'Gletis_Knife', 'Daybreak'}
	state.Shield = M{['description']='Shield Set', 'Genmei'}
	
	DisableSub = {
		Xoanon = true,
	}
	
	state.SongEnmity = M{['description']='Song Enmity', 'None', 'Enmity'}
	
	init_job_states({},{"Weapons","Subweapon","Shield","OffenseMode","WeaponskillMode","IdleMode","CastingMode","TreasureMode",})
	
	--Song Definitions
	state.Threnody = M{['description']='Threnody', '"Fire Threnody II"', '"Ice Threnody II"', '"Wind Threnody II"', '"Earth Threnody II"', '"Ltng. Threnody II"', '"Water Threnody II"', '"Light Threnody II"', '"Dark Threnody II"',}
	state.Carol1 = M{['description']='Carol1', '"Fire Carol"', '"Ice Carol"', '"Wind Carol"', '"Earth Carol"', '"Lightning Carol"', '"Water Carol"', '"Light Carol"', '"Dark Carol"',}
	state.Carol2 = M{['description']='Carol2', '"Fire Carol II"', '"Ice Carol II"', '"Wind Carol II"', '"Earth Carol II"', '"Lightning Carol II"', '"Water Carol II"', '"Light Carol II"', '"Dark Carol II"',}
	state.Etude = M{['description']='Etude', '"Herculean Etude"', '"Uncanny Etude"', '"Vital Etude"', '"Swift Etude"', '"Sage Etude"', '"Logical Etude"', '"Bewitching Etude"',}	

	info.ExtraSongInstrument = 'Loughnashade'
	-- How many extra songs we can keep from Daurdabla/Terpander
	info.ExtraSongs = 2
	
	--Includes Global Bind keys
	
	send_command('wait 2; exec Global-Binds.txt')
	
	--Bard Binds
	
	send_command('wait 2; exec /BRD/Binds.txt')
	
	--Retrieve Gear for Bard
	
	send_command('wait 3;org get inventory brd.lua')
	send_command('wait 4;get Shihei all')

	lockstyleset = 10
	select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
	enable('main','sub','range','ammo','head','body','hands','legs','feet','neck','waist','left_ear','right_ear','left_ring','right_ring','back')

	--Remove Global Binds

	send_command('wait 1; exec Global-UnBinds.txt')
	
	--Remove Gear for Bard
	
	send_command('wait 1; org get Store.lua')
	send_command('put Shihei Satchel all')
	
end

function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Fast cast sets for spells
    sets.precast.FC = {
		main={ name="Kali", augments={'Mag. Acc.+15','String instrument skill +10','Wind instrument skill +10',}},
		sub="Genmei Shield",
		head="Bunzi's Hat",
		body="Inyanga Jubbah +2",
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','Spell interruption rate down +12%','"Cure" spellcasting time -7%',}},
		feet="Fili Cothurnes +3",
		neck="Baetyl Pendant",
		waist="Embla Sash",
		left_ear="Loquac. Earring",
		right_ear="Etiolation Earring",
		left_ring="Prolix Ring",
		right_ring="Kishar Ring",
		back="Fi Follet Cape +1",}

    sets.precast.FC.BardSong = {
		main={ name="Kali", augments={'Mag. Acc.+15','String instrument skill +10','Wind instrument skill +10',}},
		sub="Genmei Shield",
		head="Fili Calot +3",
		body="Inyanga Jubbah +2",
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','Spell interruption rate down +12%','"Cure" spellcasting time -7%',}},
		feet="Fili Cothurnes +3",
		neck="Baetyl Pendant",
		waist="Embla Sash",
		left_ear="Loquac. Earring",
		right_ear="Alabaster Earring",
		left_ring="Murky Ring",
		right_ring="Kishar Ring",
		back="Fi Follet Cape +1",}
		
	sets.precast.FC.SongPlaceholder = set_combine(sets.precast.FC.BardSong, {range="Loughnashade"})
		
    sets.precast.FC.Dispelga = set_combine(sets.precast.FC, {main="Daybreak", sub="Ammurapi Shield"})
	
	sets.precast['Herb Pastoral'] = set_combine(sets.precast.FC.BardSong, {range="Loughnashade"})
	sets.precast['Shining Fantasia'] = set_combine(sets.precast.FC.BardSong, {range="Loughnashade"})

    -- Precast sets to enhance JAs

    sets.precast.JA['Nightingale'] = {feet={ name="Bihu Slippers +4", augments={'Enhances "Nightingale" effect',}},}
    sets.precast.JA['Troubadour'] = {body={ name="Bihu Just. +4", augments={'Enhances "Troubadour" effect',}},}
    sets.precast.JA['Soul Voice'] = {legs={ name="Bihu Cannions +3", augments={'Enhances "Soul Voice" effect',}},}

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {legs="Dashing Subligar",waist="Gishdubar Sash",}
	
	sets.precast.Waltz['Healing Waltz'] = {legs="Dashing Subligar",}


    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
		range={ name="Linos", augments={'Accuracy+19','Weapon skill damage +3%','STR+8',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Bihu Just. +4", augments={'Enhances "Troubadour" effect',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Ephramad's Ring",
		back={ name="Intarabus's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS.Acc = {
		range={ name="Linos", augments={'Accuracy+14 Attack+14','Weapon skill damage +3%','DEX+8',}},
		head="Fili Calot +3",
		body="Fili Hongreline +3",
		hands="Fili Manchettes +3",
		legs="Fili Rhingrave +3",
		feet="Fili Cothurnes +3",
		neck={ name="Bard's Charm +2", augments={'Path: A',}},
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear="Digni. Earring",
		right_ear={ name="Fili Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','Damage taken-6%','MND+7 CHR+7',}},
		left_ring="Ephramad's Ring",
		right_ring={ name="Cacoethic Ring +1", augments={'Path: A',}},
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS.ATKCAP = {
		range={ name="Linos", augments={'Accuracy+19','Weapon skill damage +3%','STR+8',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body="Bunzi's Robe",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Bard's Charm +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Sroda Ring",
		right_ring="Ephramad's Ring",
		back={ name="Intarabus's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

	sets.precast.WS.FullTPPhysical = {left_ear="Telos Earring",}
	sets.precast.WS.FullTPRudra = {left_ear="Ishvara Earring",}
	sets.precast.WS.FullTPMagical = {left_ear="Regal Earring",}

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    
	sets.precast.WS['Evisceration'] = {
		range={ name="Linos", augments={'Accuracy+14 Attack+14','Weapon skill damage +3%','DEX+8',}},
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body={ name="Bihu Just. +4", augments={'Enhances "Troubadour" effect',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Zoar Subligar +1", augments={'Path: A',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Brutal Earring",
		right_ear="Mache Earring +1",
		left_ring="Ilabrat Ring",
		right_ring="Begrudging Ring",
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}

    sets.precast.WS['Mordant Rime'] = {
		range={ name="Linos", augments={'Accuracy+19','Weapon skill damage +3%','STR+8',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Bihu Just. +4", augments={'Enhances "Troubadour" effect',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Bard's Charm +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Ishvara Earring",
		left_ring="Epaminondas's Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Intarabus's Cape", augments={'CHR+20','Accuracy+20 Attack+20','CHR+10','Weapon skill damage +10%',}},}

    sets.precast.WS['Rudra\'s Storm'] = {
		range={ name="Linos", augments={'Accuracy+14 Attack+14','Weapon skill damage +3%','DEX+8',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Bihu Just. +4", augments={'Enhances "Troubadour" effect',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Bard's Charm +2", augments={'Path: A',}},
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Mache Earring +1",
		left_ring="Ephramad's Ring",
		right_ring="Ilabrat Ring",
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
		
    sets.precast.WS['Rudra\'s Storm'].ATKCAP = {
		range={ name="Linos", augments={'Accuracy+14 Attack+14','Weapon skill damage +3%','DEX+8',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body="Bunzi's Robe",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Bard's Charm +2", augments={'Path: A',}},
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Mache Earring +1",
		left_ring="Ephramad's Ring",
		right_ring="Ilabrat Ring",
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
		
    sets.precast.WS['Aeolian Edge'] = {
		range={ name="Linos", augments={'Accuracy+14 Attack+14','Weapon skill damage +3%','DEX+8',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Friomisi Earring",
		left_ring="Epaminondas's Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}

    sets.precast.WS['Savage Blade'] = sets.precast.WS
	sets.precast.WS['Savage Blade'].ATKCAP = sets.precast.WS.ATKCAP

	sets.precast.WS['Savage Blade'].Acc = {
		range={ name="Linos", augments={'Accuracy+19','Weapon skill damage +3%','STR+8',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Bihu Just. +4", augments={'Enhances "Troubadour" effect',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Rep. Plat. Medal",
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Ephramad's Ring",
		back={ name="Intarabus's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
	
	sets.precast.WS['Fast Blade'] = sets.precast.WS
	sets.precast.WS['Fast Blade'].ATKCAP = sets.precast.WS.ATKCAP
	
	sets.precast.WS['Fast Blade II'] = {
		range={ name="Linos", augments={'Accuracy+14 Attack+14','Weapon skill damage +3%','DEX+8',}},
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck={ name="Bard's Charm +2", augments={'Path: A',}},
		waist="Sailfi Belt +1",
		left_ear="Moonshade Earring",
		right_ear="Ishvara Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Ephramad's Ring",
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},}
	
	sets.precast.WS['Seraph Blade'] = {
		range={ name="Linos", augments={'Accuracy+14 Attack+14','Weapon skill damage +3%','DEX+8',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Friomisi Earring",
		left_ring="Epaminondas's Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Shining Blade'] = sets.precast.WS['Seraph Blade']
	sets.precast.WS['Red Lotus Blade'] = sets.precast.WS['Seraph Blade']
	sets.precast.WS['Burning Blade'] = sets.precast.WS['Seraph Blade']

	sets.precast.WS['Sanguine Blade'] = set_combine(sets.precast.WS['Seraph Blade'], {head="Pixie Hairpin +1",right_ring="Archon Ring",})
	
	sets.precast.WS['Flat Blade'] = sets.precast.WS.Acc
		
	sets.precast.WS['Shell Crusher'] = {
		range={ name="Linos", augments={'Accuracy+14 Attack+14','Weapon skill damage +3%','DEX+8',}},
		head="Fili Calot +3",
		body="Fili Hongreline +3",
		hands="Fili Manchettes +3",
		legs="Fili Rhingrave +3",
		feet="Fili Cothurnes +3",
		neck="Sanctity Necklace",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Digni. Earring",
		right_ear={ name="Fili Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','Damage taken-6%','MND+7 CHR+7',}},
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring={ name="Cacoethic Ring +1", augments={'Path: A',}},
		back="Null Shawl",}
		
	sets.precast.WS['Retribution'] = sets.precast.WS
		
	sets.precast.RA = {
		range="Trollbane",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs="Volte Tights",
		feet="Volte Spats",
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Yemaya Belt",
		left_ear="Tuisto Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring="Ilabrat Ring",
		back="Null Shawl",}
	
		--Set used for Icarus Wing to maximize TP gain	
	sets.precast.Wing = {
	    range={ name="Linos", augments={'Accuracy+15','"Store TP"+4','Quadruple Attack +3',}},
		head={ name="Bunzi's Hat", augments={'Path: A',}},
		body="Ashera Harness",
		hands={ name="Bunzi's Gloves", augments={'Path: A',}},
		legs="Volte Tights",
		feet="Volte Spats",
		neck={ name="Bard's Charm +2", augments={'Path: A',}},
		waist="Gerdr Belt +1",
		left_ear="Crep. Earring",
		right_ear="Telos Earring",
		left_ring={ name="Chirich Ring +1", bag="wardrobe7" },
		right_ring={ name="Chirich Ring +1", bag="wardrobe8" },
		back="Null Shawl",}
		
	sets.precast.Volte_Harness = set_combine(sets.precast.Wing, {body="Volte Harness"})
	sets.precast.Prishes_Boots = set_combine(sets.precast.Wing, {feet="Prishe\'s Boots +1",})


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- General set for recast times.
    sets.midcast.FastRecast = sets.precast.FC
	
	sets.midcast.Enmity = {
		main="Mafic Cudgel",
		sub="Genmei Shield",
		range="Loughnashade",
		head="Halitus Helm",
		body="Emet Harness +1",
		hands="Fili Manchettes +3",
		legs="Zoar Subligar +1",
		feet="Nyame Sollerets",
		neck="Unmoving Collar +1",
		waist="Kasiri Belt",
		left_ear="Friomisi Earring",
		right_ear="Cryptic Earring",
		left_ring="Eihwaz Ring",
		right_ring="Gelatinous Ring +1",
		back="Null Shawl",}

    -- For song buffs (duration and AF3 set bonus)
	
	sets.midcast.SongEffect = {
		main={ name="Carnwenhan", augments={'Path: A',}},
		sub="Genmei Shield",
		range="Loughnashade",
		head="Fili Calot +3",
		body="Fili Hongreline +3",
		hands="Fili Manchettes +3",
		legs="Inyanga Shalwar +2",
		feet="Brioso Slippers +4",
		neck="Mnbw. Whistle +1",
		waist="Embla Sash",
		left_ear="Tuisto Earring",
		right_ear="Alabaster Earring",
		left_ring="Murky Ring",
		right_ring="Gelatinous Ring +1",
		back={ name="Intarabus's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},}
		
	sets.midcast.SongEffect.DW = set_combine(sets.midcast.SongEffect, {sub={ name="Kali", augments={'Mag. Acc.+15','String instrument skill +10','Wind instrument skill +10',}},})
	sets.midcast.SongPlaceholder = set_combine(sets.midcast.SongEffect, {range="Loughnashade"})
		
	sets.midcast['Herb Pastoral'] = set_combine(sets.precast.FC.BardSong, {range="Loughnashade"})
	sets.midcast['Shining Fantasia'] = set_combine(sets.precast.FC.BardSong, {range="Loughnashade"})
	
	-- Cast spell with normal gear, except using Daurdabla instead
	sets.midcast.Daurdabla = {range=info.ExtraSongInstrument}
	
	-- Dummy song with Daurdabla; minimize duration to make it easy to overwrite.
	sets.midcast.DaurdablaDummy = set_combine(sets.midcast.SongRecast, {range=info.ExtraSongInstrument})

    -- Defines Song sets can also add equipment to increase certain songs.
	
	sets.midcast.Paeon = {head="Brioso Roundlet +3"}
	sets.midcast.Ballad = {}
	sets.midcast.Minne = {}
	sets.midcast.Mambo = {}
	sets.midcast.Minuet = {body="Fili Hongreline +3"}
	sets.midcast.Madrigal = {head="Fili Calot +3"}
	sets.midcast.March = {hands="Fili Manchettes +3"}
	sets.midcast.Etude = {head="Mousai Turban +1",}
	sets.midcast.Carol = {hands="Mousai Gages +1",}
	sets.midcast["Sentinel's Scherzo"] = {feet="Fili Cothurnes +3"}
	sets.midcast.Mazurka = {}
	sets.midcast.HonorMarch = {hands="Fili Manchettes +3"}	

    -- For song debuffs (duration primary, accuracy secondary)
    sets.midcast.SongDebuff = {
		main={ name="Carnwenhan", augments={'Path: A',}},
		sub="Ammurapi Shield",
		range="Marsyas",
		head="Brioso Roundlet +3",
		body="Fili Hongreline +3",
		hands="Fili Manchettes +3",
		legs="Inyanga Shalwar +2",
		feet="Brioso Slippers +4",
		neck="Mnbw. Whistle +1",
		waist="Null Belt",
		left_ear="Regal Earring",
		right_ear={ name="Fili Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','Damage taken-6%','MND+7 CHR+7',}},
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back="Null Shawl",}
		
	sets.midcast.SongDebuff.DW = {main={ name="Carnwenhan", augments={'Path: A',}},sub={ name="Kali", augments={'Mag. Acc.+15','String instrument skill +10','Wind instrument skill +10',}},} --Only weapons in this set. This set is overlayed onto  SongDebuff

    -- For song defbuffs (accuracy primary, duration secondary)
    sets.midcast.SongDebuff.Resistant = {
		main={ name="Carnwenhan", augments={'Path: A',}},
		sub="Ammurapi Shield",
		range="Marsyas",
		head="Brioso Roundlet +3",
		body="Brioso Justau. +3",
		hands="Fili Manchettes +3",
		legs="Brioso Cannions +3",
		feet="Brioso Slippers +4",
		neck="Mnbw. Whistle +1",
		waist="Null Belt",
		left_ear="Regal Earring",
		right_ear={ name="Fili Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','Damage taken-6%','MND+7 CHR+7',}},
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back="Null Shawl",}

	sets.midcast.Threnody = set_combine(sets.midcast.SongDebuff, {body="Mou. Manteel +1",})
	sets.midcast.Threnody.Resistant = set_combine(sets.midcast.SongDebuff, {body="Mou. Manteel +1",})
	
	-- For Foe Lullaby.
	sets.midcast.Lullaby = set_combine(sets.midcast.SongDebuff, {range="Marsyas", hands="Brioso Cuffs +4",})
	
	sets.midcast.Lullaby.Resistant	= set_combine(sets.midcast.SongDebuff, {range="Marsyas", hands="Brioso Cuffs +4",})
		
    -- For Horde Lullaby.
    sets.midcast.Horde = {
		main={ name="Carnwenhan", augments={'Path: A',}},
		sub="Ammurapi Shield",
		range="Blurred Harp +1",
		head="Brioso Roundlet +3",
		body="Brioso Justau. +3",
		hands="Fili Manchettes +3",
		legs="Inyanga Shalwar +2",
		feet="Brioso Slippers +4",
		neck="Mnbw. Whistle +1",
		waist="Null Belt",
		left_ear="Gersemi Earring",
		right_ear="Regal Earring",
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back="Null Shawl",}
		
	sets.midcast.Horde.Resistant = sets.midcast.Horde
	
	sets.midcast['Horde Lullaby'] = sets.midcast.Horde
	sets.midcast['Horde Lullaby'].Resistant = sets.midcast.Horde.Resistant
	sets.midcast['Horde Lullaby II'] = sets.midcast.Horde
	sets.midcast['Horde Lullaby II'].Resistant = sets.midcast.Horde.Resistant

    -- Other general spells and classes.
    sets.midcast.Cure = {
		main="Daybreak",
		sub="Genmei Shield",
		range={ name="Linos", augments={'Mag. Evasion+15','Phys. dmg. taken -4%','VIT+8',}},
		head={ name="Kaykaus Mitra +1", augments={'MP+80','Spell interruption rate down +12%','"Cure" spellcasting time -7%',}},
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','"Cure" potency +6%','"Conserve MP"+7',}},
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','Spell interruption rate down +12%','"Cure" spellcasting time -7%',}},
		feet={ name="Kaykaus Boots +1", augments={'MP+80','Spell interruption rate down +12%','"Cure" spellcasting time -7%',}},
		neck="Incanter's Torque",
		waist="Shinjutsu-no-Obi +1",
		left_ear="Magnetic Earring",
		right_ear="Meili Earring",
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring="Sirona's Ring",
		back="Fi Follet Cape +1",}

	sets.midcast.CureSelf = {
		main="Daybreak",
		sub="Genmei Shield",
		range={ name="Linos", augments={'Mag. Evasion+15','Phys. dmg. taken -4%','VIT+8',}},
		head={ name="Kaykaus Mitra +1", augments={'MP+80','Spell interruption rate down +12%','"Cure" spellcasting time -7%',}},
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','"Cure" potency +6%','"Conserve MP"+7',}},
		hands="Buremte Gloves",
		legs={ name="Kaykaus Tights +1", augments={'MP+80','Spell interruption rate down +12%','"Cure" spellcasting time -7%',}},
		feet={ name="Kaykaus Boots +1", augments={'MP+80','Spell interruption rate down +12%','"Cure" spellcasting time -7%',}},
		neck="Incanter's Torque",
		waist="Gishdubar Sash",
		left_ear="Magnetic Earring",
		right_ear="Meili Earring",
		left_ring="Kunaji Ring",
		right_ring="Sirona's Ring",
		back="Fi Follet Cape +1",}

    sets.midcast.Curaga = sets.midcast.Cure

    sets.midcast.StatusRemoval = sets.midcast.Cure

    sets.midcast.Cursna = {
		main="Daybreak",
		sub="Genmei Shield",
		range={ name="Linos", augments={'Mag. Evasion+15','Phys. dmg. taken -4%','VIT+8',}},
		head={ name="Kaykaus Mitra +1", augments={'MP+80','Spell interruption rate down +12%','"Cure" spellcasting time -7%',}},
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','"Cure" potency +6%','"Conserve MP"+7',}},
		hands="Inyan. Dastanas +2",
		legs={ name="Kaykaus Tights +1", augments={'MP+80','Spell interruption rate down +12%','"Cure" spellcasting time -7%',}},
		feet={ name="Vanya Clogs", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
		neck="Debilis Medallion",
		waist="Bishop's Sash",
		left_ear="Beatific Earring",
		right_ear="Meili Earring",
		left_ring="Haoma's Ring",
		right_ring="Menelaus's Ring",
		back="Fi Follet Cape +1",}

    sets.midcast['Enhancing Magic'] = {
		main={ name="Kali", augments={'Mag. Acc.+15','String instrument skill +10','Wind instrument skill +10',}},
		sub="Ammurapi Shield",
		range={ name="Linos", augments={'Mag. Evasion+15','Phys. dmg. taken -4%','VIT+8',}},
		head={ name="Telchine Cap", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		body={ name="Telchine Chas.", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		hands={ name="Telchine Gloves", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		legs={ name="Telchine Braconi", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		feet={ name="Telchine Pigaches", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		neck="Baetyl Pendant",
		waist="Embla Sash",
		left_ear="Etiolation Earring",
		right_ear="Loquac. Earring",
		left_ring="Prolix Ring",
		right_ring="Kishar Ring",
		back="Fi Follet Cape +1",}

    sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {waist="Gishdubar Sash"})
	sets.midcast.Haste = sets.midcast['Enhancing Magic']

    sets.midcast['Enfeebling Magic'] = {
		main={ name="Carnwenhan", augments={'Path: A',}},
		sub="Ammurapi Shield",
		range={ name="Linos", augments={'Mag. Evasion+15','Phys. dmg. taken -4%','VIT+8',}},
		head="Brioso Roundlet +3",
		body="Brioso Justau. +3",
		hands="Inyan. Dastanas +2",
		legs="Brioso Cannions +3",
		feet="Brioso Slippers +4",
		neck="Mnbw. Whistle +1",
		waist="Null Belt",
		left_ear="Regal Earring",
		right_ear={ name="Fili Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','Damage taken-6%','MND+7 CHR+7',}},
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back="Null Shawl",}

    sets.midcast.Dispelga = set_combine(sets.midcast['Enfeebling Magic'], {main="Daybreak", sub="Ammurapi Shield"})
	
	sets.midcast['Dark Magic'] = {
		main={ name="Carnwenhan", augments={'Path: A',}},
		sub="Ammurapi Shield",
		range={ name="Linos", augments={'Mag. Evasion+15','Phys. dmg. taken -4%','VIT+8',}},
		head="Brioso Roundlet +3",
		body="Brioso Justau. +3",
		hands="Inyan. Dastanas +2",
		legs="Brioso Cannions +3",
		feet="Brioso Slippers +4",
		neck="Mnbw. Whistle +1",
		waist="Null Belt",
		left_ear="Regal Earring",
		right_ear={ name="Fili Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','Damage taken-6%','MND+7 CHR+7',}},
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back="Null Shawl",}
		
	sets.midcast['Absorb-TP'] = {
		main={ name="Carnwenhan", augments={'Path: A',}},
		sub="Ammurapi Shield",
		range={ name="Linos", augments={'Mag. Evasion+15','Phys. dmg. taken -4%','VIT+8',}},
		head="Bunzi's Hat",
		body="Inyanga Jubbah +2",
		hands="Inyan. Dastanas +2",
		legs="Brioso Cannions +3",
		feet="Fili Cothurnes +3",
		neck="Mnbw. Whistle +1",
		waist="Null Belt",
		left_ear="Regal Earring",
		right_ear={ name="Fili Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','Damage taken-6%','MND+7 CHR+7',}},
		left_ring="Kishar Ring",
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back="Null Shawl",}
	
	sets.midcast.RA = {
		range="Trollbane",
		head="Nyame Helm",
		body="Volte Harness",
		hands="Nyame Gauntlets",
		legs="Volte Tights",
		feet="Volte Spats",
		neck="Loricate Torque +1",
		waist="Yemaya Belt",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Gelatinous Ring +1",
		right_ring="Crepuscular Ring",
		back="Null Shawl",}

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.idle = {
		main="Daybreak",
		sub="Genmei Shield",
		range={ name="Linos", augments={'Mag. Evasion+15','Phys. dmg. taken -4%','VIT+8',}},
		head="Null Masque",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Loricate Torque +1",
		waist="Flume Belt +1",
		left_ear="Odnowa Earring +1",
		right_ear="Alabaster Earring",
		left_ring="Murky Ring",
		right_ring="Shadow Ring",
		back="Null Shawl",}
		
    sets.idle.Aminon = {
		main="Daybreak",
		sub="Genmei Shield",
		range={ name="Linos", augments={'Mag. Evasion+15','Phys. dmg. taken -4%','VIT+8',}},
		head="Null Masque",
		body="Volte Harness",
		hands="Regal Gloves",
		legs="Volte Tights",
		feet="Volte Spats",
		neck="Rep. Plat. Medal",
		waist="Sweordfaetels +1",
		left_ear="Odnowa Earring +1",
		right_ear={ name="Fili Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','Damage taken-6%','MND+7 CHR+7',}},
		left_ring={ name="Moonlight Ring", bag="wardrobe7" },
		right_ring={ name="Moonlight Ring", bag="wardrobe8" },
		back="Null Shawl",}
		
	sets.idle.Refresh = {
		main="Mpaca's Staff",
		sub="Enki Strap",
		range={ name="Linos", augments={'Mag. Evasion+15','Phys. dmg. taken -4%','VIT+8',}},
		head="Null Masque",
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','"Cure" potency +6%','"Conserve MP"+7',}},
		hands="Fili Manchettes +3",
		legs="Fili Rhingrave +3",
		feet="Nyame Sollerets",
		neck="Sibyl Scarf",
		waist="Flume Belt +1",
		left_ear="Alabaster Earring",
		right_ear={ name="Fili Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','Damage taken-6%','MND+7 CHR+7',}},
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back="Null Shawl",}
		
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
	
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
		range={ name="Linos", augments={'Accuracy+18','"Store TP"+4','Quadruple Attack +3',}},
		head="Bunzi's Hat",
		body="Ashera Harness",
		hands="Bunzi's Gloves",
		legs="Volte Tights",
		feet="Nyame Sollerets",
		neck={ name="Bard's Charm +2", augments={'Path: A',}},
		waist="Sailfi Belt +1",
		left_ear="Dedition Earring",
		right_ear="Brutal Earring",
		left_ring="Petrov Ring",
		right_ring={ name="Chirich Ring +1", bag="wardrobe8" },
		back="Null Shawl",}

    sets.engaged.Acc = sets.engaged
		
	------------------------------------------------------------------------------------------------
	-----------------------------------------Dual Wield Sets----------------------------------------
	------------------------------------------------------------------------------------------------

    sets.engaged.DW = {
		main="Naegling",
		sub={ name="Gleti\'s Knife", augments={'Path: A',}},
		range={ name="Linos", augments={'Accuracy+18','"Store TP"+4','Quadruple Attack +3',}},
		head="Bunzi's Hat",
		body="Ashera Harness",
		hands="Bunzi's Gloves",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck={ name="Bard's Charm +2", augments={'Path: A',}},
		waist="Reiki Yotai",
		left_ear="Eabani Earring",
		right_ear="Alabaster Earring",
		left_ring="Petrov Ring",
		right_ring={ name="Chirich Ring +1", bag="wardrobe8" },
		back="Null Shawl",}	

    sets.engaged.DW.Acc = sets.engaged.DW

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {
		range={ name="Linos", augments={'Accuracy+18','"Store TP"+4','Quadruple Attack +3',}},
		head="Bunzi's Hat",
		body="Ashera Harness",
		hands="Bunzi's Gloves",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck={ name="Bard's Charm +2", augments={'Path: A',}},
		waist="Sailfi Belt +1",
		left_ear="Dedition Earring",
		right_ear="Cessance Earring",
		left_ring={ name="Moonlight Ring", bag="wardrobe7" },
		right_ring={ name="Chirich Ring +1", bag="wardrobe8" },
		back="Null Shawl",}
		
	sets.engaged.HybridDW = {
		range={ name="Linos", augments={'Accuracy+18','"Store TP"+4','Quadruple Attack +3',}},
		head="Bunzi's Hat",
		body="Ashera Harness",
		hands="Bunzi's Gloves",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck={ name="Bard's Charm +2", augments={'Path: A',}},
		waist="Reiki Yotai",
		left_ear="Eabani Earring",
		right_ear="Alabaster Earring",
		left_ring={ name="Moonlight Ring", bag="wardrobe7" },
		right_ring={ name="Moonlight Ring", bag="wardrobe8" },
		back="Null Shawl",}

    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
    sets.engaged.Acc.DT = set_combine(sets.engaged.Acc, sets.engaged.Hybrid)

    sets.engaged.DW.DT = set_combine(sets.engaged.DW, sets.engaged.HybridDW)
    sets.engaged.DW.Acc.DT = set_combine(sets.engaged.DW.Acc, sets.engaged.HybridDW)

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	sets.Kiting = {left_ring="Shneddick Ring",}
	sets.Roller = {right_ring="Roller's Ring",}
	sets.Kiting_Roller = {left_ring="Shneddick Ring",right_ring="Roller's Ring",}

	sets.TreasureHunter = {
		body="Volte Jupon",
		hands="Volte Bracers",
		waist="Chaac Belt",}

    sets.SongDWDuration = {main="Carnwenhan", sub="Kali"}
	sets.SongSWDuration = {main="Carnwenhan", sub="Genmei Shield"}

    sets.buff.Doom = {
		neck="Nicander's Necklace",
        waist="Gishdubar Sash", --10
        }

    sets.Obi = {waist="Hachirin-no-Obi"}

	sets.buff.Sublimation = {}
	
	
	sets.weapons.Naegling = {main="Naegling", sub="Genmei Shield"}
	sets.weapons.Onion = {main="Onion Sword III",}
	sets.weapons.Carnwenhan = {main="Carnwenhan", sub="Genmei Shield"}
	sets.weapons.Twashtar = {main={ name="Twashtar", augments={'Path: A',}}, sub="Genmei Shield"}
	sets.weapons.Mandau = {main="Mandau", sub="Genmei Shield"}
	sets.weapons.Mpu_Gandring = {main="Mpu Gandring", sub="Genmei Shield"}
	sets.weapons.Tauret = {main="Tauret", sub="Genmei Shield"}
	
	sets.weapons.Xoanon = {main="Xoanon", sub="Ultio Grip",}
	
	sets.Centovente = {sub="Fusetto +2",}
	sets.Gletis_Knife = {sub={ name="Gleti\'s Knife", augments={'Path: A',}},}
	sets.Crepuscular = {sub="Crepuscular Knife",}
	
	

end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	set_macro_page(1, 10)
end

function user_job_lockstyle()
    send_command('input /lockstyleset ' .. lockstyleset)
end