function user_job_setup()

	state.OffenseMode:options('InquartataPhysical', 'InquartataMagical', 'MagicTank', 'Normal')
	state.HybridMode:options('Normal', 'DT')
	state.WeaponskillMode:options('Normal', 'Acc')
	state.CastingMode:options('Normal', 'SIRD')
	state.IdleMode:options('Normal', 'Refresh')
	state.Weapons:options('Epeolatry', 'Aettir', 'Lycurgos', 'Reikiko', 'Dolichenus')
	state.Grip = M{['description']='Grip Set', 'Refined', 'Utu'}

	Two_Handed_Weapons = {
		Epeolatry   = true,
		Aettir    = true,
		Lycurgos = true,}
	
	One_Handed_Weapons = {
		Reikiko = true,
		Dolichenus = true}
	
	state.RuneElement = M{['description']='RuneElement', 'Lux', 'Tenebrae', 'Ignis', 'Gelus', 'Flabra', 'Tellus', 'Sulpor', 'Unda'}
	state.Barspell = M{['description']='Barspell', '"Barfire"', '"Barblizzard"', '"Baraero"', '"Barstone"','"Barthunder"', '"Barwater"',}
	state.BarStatus = M{['description']='BarStatus', 'Barparalyze', 'Baramnesia', 'Barvirus', 'Barsilence', 'Barpetrify', 'Barpoisone', 'Barblind', 'Barsleep'}
	
	state.WeaponLock = M(false, 'Weapon Lock')	
	
	init_job_states({},{"RuneElement","Barspell","BarStatus","Weapons","Grip","OffenseMode","WeaponLock","WeaponskillMode","IdleMode","CastingMode","TreasureMode",})
	
	--Includes Global Bind keys
	
	send_command('wait 2; exec Global-Binds.txt')
	
	--Rune Fencer Binds
	
	send_command('wait 2; exec /RUN/Binds.txt')

	--Retrieve Gear for Rune Fencer
	
	send_command('wait 3;org get inventory run.lua')
	send_command('wait 4;get Shihei all')
		
	--Job Settings
	
	lockstyleset = 20
    select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
	enable('main','sub','range','ammo','head','body','hands','legs','feet','neck','waist','left_ear','right_ear','left_ring','right_ring','back')

	--Remove Global Binds

	send_command('wait 1; exec Global-UnBinds.txt')
	
	--Remove Gear for Rune Fencer
	
	send_command('wait 1; org get Store.lua')
	send_command('put Shihei Satchel all')
	
end

function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Enmity sets
	sets.Enmity = {
		ammo="Staunch Tathlum +1",
		head="Halitus Helm",
		body="Emet Harness +1",
		hands="Kurys Gloves",
		legs="Eri. Leg Guards +3",
		feet="Erilaz Greaves +3",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Kasiri Belt",
		left_ear="Cryptic Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Eihwaz Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}
		 
	sets.Enmity.SIRD = {
		ammo="Staunch Tathlum +1",
		head="Erilaz Galea +3",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Rawhide Gloves", augments={'HP+50','Accuracy+15','Evasion+20',}},
		legs="Eri. Leg Guards +3",
		feet="Erilaz Greaves +3",
		neck="Moonlight Necklace",
		waist="Audumbla Sash",
		left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		right_ear="Magnetic Earring",
		left_ring="Evanescence Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Spell interruption rate down-10%',}},}

	sets.precast.JA['Vallation'] = set_combine(sets.Enmity,{body="Runeist Coat +4",legs={ name="Futhark Trousers +4", augments={'Enhances "Inspire" effect',}}})
	sets.precast.JA['Valiance'] = sets.precast.JA['Vallation']
	sets.precast.JA['Pflug'] = set_combine(sets.Enmity,{})
	sets.precast.JA['Battuta'] = set_combine(sets.Enmity,{head="Fu. Bandeau +4",})
	sets.precast.JA['Liement'] = set_combine(sets.Enmity,{body={ name="Futhark Coat +4", augments={'Enhances "Elemental Sforzo" effect',}},})
	sets.precast.JA['Elemental Sforzo'] = set_combine(sets.Enmity,{body={ name="Futhark Coat +4", augments={'Enhances "Elemental Sforzo" effect',}},})
	sets.precast.JA['Swordplay'] = set_combine(sets.Enmity,{hands="Futhark Mitons +3",})
	sets.precast.JA['Embolden'] = set_combine(sets.Enmity,{})
	sets.precast.JA['One for All'] = set_combine(sets.Enmity,{})
	
	sets.precast.JA['Provoke'] = set_combine(sets.Enmity, {})
	sets.precast.JA['Warcry'] = set_combine(sets.Enmity, {})
	sets.precast.JA['Defender'] = set_combine(sets.Enmity, {})
	sets.precast.JA['Berserk'] = set_combine(sets.Enmity, {})
	sets.precast.JA['Last Resort'] = set_combine(sets.Enmity, {})
	sets.precast.JA['Aggressor'] = set_combine(sets.Enmity, {})
	sets.precast.JA['Animated Flourish'] = set_combine(sets.Enmity, {})

	sets.precast.JA['Gambit'] = set_combine(sets.Enmity,{hands="Runeist Mitons +4"})
	sets.precast.JA['Rayke'] = set_combine(sets.Enmity,{feet="Futhark Boots +3"})

	sets.precast.JA['Lunge'] = {
		ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
		head={ name="Agwu's Cap", augments={'Path: A',}},
		body={ name="Agwu's Robe", augments={'Path: A',}},
		hands={ name="Agwu's Gages", augments={'Path: A',}},
		legs={ name="Agwu's Slops", augments={'Path: A',}},
		feet={ name="Agwu's Pigaches", augments={'Path: A',}},
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear="Friomisi Earring",
		right_ear="Hecate's Earring",
		left_ring="Mujin Band",
		right_ring="Locus Ring",
		back={ name="Ogma's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},}

	sets.precast.JA['Swipe'] = sets.precast.JA['Lunge']

	-- Gear for specific elemental nukes.
	sets.element.Dark = {head="Pixie Hairpin +1",ring1="Archon Ring"}

	-- Pulse sets, different stats for different rune modes, stat aligned.
	sets.precast.JA['Vivacious Pulse'] = {main={ name="Morgelai", augments={'Path: C',}},head="Erilaz Galea +3",}
	
	-- Waltz set (chr and vit)
	sets.precast.Waltz = {legs="Dashing Subligar",left_ring="Asklepian Ring",waist="Gishdubar Sash",}
		
	-- Don't need any special gear for Healing Waltz.
	sets.precast.Waltz['Healing Waltz'] = {legs="Dashing Subligar",}
	
	sets.precast.Step = {}
		
	sets.precast.JA['Violent Flourish'] = {}
		
	-- Fast cast sets for spells
	sets.precast.FC = {
		ammo="Sapience Orb",
		head="Runeist Bandeau +4",
		body="Erilaz Surcoat +3",
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Agwu's Slops", augments={'Path: A',}},
		feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
		neck="Baetyl Pendant",
		waist="Plat. Mog. Belt",
		left_ear="Etiolation Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Kishar Ring",
		right_ring="Prolix Ring",
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Spell interruption rate down-10%',}},}
			
	sets.precast.FC.Inspiration = {}
		
	sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {legs={ name="Futhark Trousers +4", augments={'Enhances "Inspire" effect',}},})
	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {})
	
	sets.precast.RA = {
		range="Trollbane",
		head="Null Masque",
		body="Volte Harness",
		hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
		legs={ name="Adhemar Kecks +1", augments={'AGI+12','"Rapid Shot"+13','Enmity-6',}},
		feet="Meg. Jam. +2",
		neck={ name="Futhark Torque +2", augments={'Path: A',}},
		waist="Yemaya Belt",
		left_ear="Tuisto Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring={ name="Moonlight Ring", bag="wardrobe7" },
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}
	
		--Set used for Icarus Wing to maximize TP gain	
	sets.precast.Wing = {}
	
	sets.precast.Volte_Harness = set_combine(sets.precast.Wing, {body="Volte Harness"})
	sets.precast.Prishes_Boots = set_combine(sets.precast.Wing, {feet="Prishe\'s Boots +1",})

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

	sets.precast.WS = {
		ammo="Knobkierrie",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Fotia Gorget",
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Odr Earring",
		left_ring="Ephramad's Ring",
		right_ring="Niqmaddu Ring",
		back={ name="Ogma's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS.Acc = {
		ammo="Yamarang",
		head="Erilaz Galea +3",
		body="Erilaz Surcoat +3",
		hands="Erilaz Gauntlets +3",
		legs="Eri. Leg Guards +3",
		feet="Erilaz Greaves +3",
		neck="Null Loop",
		waist="Null Belt",
		left_ear="Odr Earring",
		right_ear="Mache Earring +1",
		left_ring="Ephramad's Ring",
		right_ring={ name="Cacoethic Ring +1", augments={'Path: A',}},
		back="Null Shawl",}

	sets.precast.WS.FullTP = {left_ear="Sherida Earring",}
		
	sets.precast.WS['Dimidiation'] = sets.precast.WS
	sets.precast.WS['Dimidiation'].Acc = sets.precast.WS.Acc
	sets.precast.WS['Dimidiation'].FullTP = {left_ear="Sherida Earring",}

	sets.precast.WS['Resolution'] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Erilaz Gauntlets +3",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Sherida Earring",
		left_ring="Ephramad's Ring",
		right_ring="Niqmaddu Ring",
		back={ name="Ogma's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

	sets.precast.WS['Resolution'].Acc = sets.precast.WS.Acc
	sets.precast.WS['Resolution'].FullTP = {left_ear="Odr Earring",}
	
    sets.precast.WS['Herculean Slash'] = {
		ammo="Knobkierrie",
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
		right_ring="Shiva Ring +1",
		back={ name="Ogma's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},}
		
	sets.precast.WS['Frostbite'] = sets.precast.WS['Herculean Slash']
	sets.precast.WS['Freezebite'] = sets.precast.WS['Herculean Slash']

	sets.precast.WS['Herculean Slash'].FullTP = {left_ear="Hecate's Earring"}
		
    sets.precast.WS['Shockwave'] = {
		ammo="Yamarang",
		head="Erilaz Galea +3",
		body="Erilaz Surcoat +3",
		hands="Erilaz Gauntlets +3",
		legs="Eri. Leg Guards +3",
		feet="Erilaz Greaves +3",
		neck="Erra Pendant",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Crep. Earring",
		right_ear={ name="Erilaz Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+13','Mag. Acc.+13','Damage taken-4%',}},
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Ogma's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},}
		
    sets.precast.WS['Fell Cleave'] = {
		ammo="Knobkierrie",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Sherida Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Regal Ring",
		back={ name="Ogma's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Steel Cyclone'] = sets.precast.WS['Fell Cleave']
    sets.precast.WS['Upheaval'] = sets.precast.WS['Fell Cleave']
		
	sets.precast.WS['Armor Break'] = sets.precast.WS['Shockwave']
	sets.precast.WS['Full Break'] = sets.precast.WS['Armor Break']
	sets.precast.WS['Weapon Break'] = sets.precast.WS['Armor Break']

	sets.precast.WS['Ruinator'] = sets.precast.WS.Acc
	sets.precast.WS['Ruinator'].Acc = sets.precast.WS.Acc
	
	sets.precast.WS['Shining Blade'] = sets.precast.WS['Herculean Slash']
	sets.precast.WS['Sanguine Blade'] = set_combine(sets.precast.WS['Herculean Slash'], {head="Pixie Hairpin +1",right_ring="Archon Ring",})
	
	-- Swap to these on Moonshade using WS if at 3000 TP
	sets.MaxTP = {ear1="Brutal Earring"}
	sets.AccMaxTP = {ear1="Telos Earring"}
    
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
	
	sets.midcast.FastRecast = sets.precast.FC
			
	sets.midcast.FastRecast.SIRD = {}

	sets.midcast['Enhancing Magic'] = {
		ammo="Staunch Tathlum +1",
		head="Erilaz Galea +3",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Runeist Mitons +4",
		legs={ name="Futhark Trousers +4", augments={'Enhances "Inspire" effect',}},
		feet="Erilaz Greaves +3",
		neck="Moonlight Necklace",
		waist="Audumbla Sash",
		left_ear="Tuisto Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Spell interruption rate down-10%',}},}
	
	sets.midcast['Enhancing Magic'].SIRD = sets.midcast['Enhancing Magic']
	
	sets.midcast.BarElement = {
		ammo="Staunch Tathlum +1",
		head="Erilaz Galea +3",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Runeist Mitons +4",
		legs={ name="Futhark Trousers +4", augments={'Enhances "Inspire" effect',}},
		feet="Erilaz Greaves +3",
		neck="Moonlight Necklace",
		waist="Audumbla Sash",
		left_ear="Tuisto Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Spell interruption rate down-10%',}},}
	
	sets.midcast['Phalanx'] = {
		main="Deacon Sword",
		ammo="Staunch Tathlum +1",
		head="Fu. Bandeau +4",
		body={ name="Herculean Vest", augments={'INT+4','Accuracy+10','Phalanx +4',}},
		hands={ name="Herculean Gloves", augments={'Attack+29','Accuracy+1 Attack+1','Phalanx +4',}},
		legs={ name="Herculean Trousers", augments={'Pet: "Subtle Blow"+6','"Store TP"+1','Phalanx +4','Mag. Acc.+3 "Mag.Atk.Bns."+3',}},
		feet={ name="Herculean Boots", augments={'Pet: "Mag.Atk.Bns."+19','AGI+1','Phalanx +5','Accuracy+13 Attack+13',}},
		neck="Loricate Torque +1",
		waist="Olympus Sash",
		left_ear="Tuisto Earring",
		right_ear="Mimir Earring",
		left_ring="Murky Ring",
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back="Merciful Cape",}
	
	sets.midcast['Phalanx'].SIRD = sets.midcast['Phalanx']
	
	sets.Phalanx_Received = {
		main="Deacon Sword",
		head="Fu. Bandeau +4",
		body={ name="Herculean Vest", augments={'INT+4','Accuracy+10','Phalanx +4',}},
		hands={ name="Herculean Gloves", augments={'Attack+29','Accuracy+1 Attack+1','Phalanx +4',}},
		legs={ name="Herculean Trousers", augments={'Pet: "Subtle Blow"+6','"Store TP"+1','Phalanx +4','Mag. Acc.+3 "Mag.Atk.Bns."+3',}},
		feet={ name="Herculean Boots", augments={'Pet: "Mag.Atk.Bns."+19','AGI+1','Phalanx +5','Accuracy+13 Attack+13',}},}
	
	sets.midcast['Regen'] = {
		main={ name="Morgelai", augments={'Path: C',}},
		ammo="Staunch Tathlum +1",
		head="Runeist Bandeau +4",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Regal Gauntlets",
		legs={ name="Futhark Trousers +4", augments={'Enhances "Inspire" effect',}},
		feet="Erilaz Greaves +3",
		neck="Sacro Gorget",
		waist="Sroda Belt",
		left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		right_ear={ name="Erilaz Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+13','Mag. Acc.+13','Damage taken-4%',}},
		left_ring="Defending Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Spell interruption rate down-10%',}},}
		
	sets.RegenRecieved = {right_ear={ name="Erilaz Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+14','Mag. Acc.+14','Damage taken-5%',}},}
	
	sets.midcast['Refresh'] = set_combine(sets.midcast['Enhancing Magic'],{head="Erilaz Galea +3",}) 
	
	sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {})
	
	sets.midcast.Flash = set_combine(sets.Enmity, {})
	sets.midcast.Foil = set_combine(sets.Enmity, {})
	sets.midcast.Stun = set_combine(sets.Enmity, {})
	
	sets.midcast['Blue Magic'] = set_combine(sets.Enmity.SIRD, {})
	sets.midcast['Blue Magic'].SIRD = set_combine(sets.Enmity.SIRD, {})

	sets.midcast.Cure = {
		ammo="Staunch Tathlum +1",
		head="Null Masque",
		body="Adamantite Armor",
		hands="Regal Gauntlets",
		legs="Eri. Leg Guards +3",
		feet="Erilaz Greaves +3",
		neck="Sacro Gorget",
		waist="Sroda Belt",
		left_ear="Mendi. Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring={ name="Moonlight Ring", bag="wardrobe7" },
		right_ring="Eihwaz Ring",
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Spell interruption rate down-10%',}},}
		
	sets.midcast.Curaga = sets.midcast.Cure
		
	sets.midcast['Wild Carrot'] = set_combine(sets.midcast.Cure, {})
	sets.midcast['Magic Fruit'] = set_combine(sets.midcast.Cure, {})
		
	sets.Self_Healing = {hands="Buremte Gloves",ring2="Kunaji Ring",waist="Gishdubar Sash"}
	sets.Cure_Received = {hands="Buremte Gloves",ring2="Kunaji Ring",waist="Gishdubar Sash"}
	sets.Self_Refresh = {waist="Gishdubar Sash"}

	------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

	sets.resting = {
		ammo="Homiliary",
		head="Null Masque",
		body="Runeist Coat +4",
		hands="Erilaz Gauntlets +3",
		legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
		feet="Erilaz Greaves +3",
		neck="Sibyl Scarf",
		waist="Flume Belt +1",
		left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		right_ear={ name="Erilaz Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+14','Mag. Acc.+14','Damage taken-5%',}},
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}

    sets.idle = {
		ammo="Staunch Tathlum +1",
		head="Null Masque",
		body="Runeist Coat +4",
		hands="Sworn Gauntlets",
		legs="Sworn Brais",
		feet="Erilaz Greaves +3",
		neck="Loricate Torque +1",
		waist="Engraved Belt",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Gelatinous Ring +1",
		right_ring="Shneddick Ring",
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}
		
	sets.idle.Refresh = {
		ammo="Homiliary",
		head="Null Masque",
		body="Runeist Coat +4",
		hands="Erilaz Gauntlets +3",
		legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
		feet="Erilaz Greaves +3",
		neck="Sibyl Scarf",
		waist="Flume Belt +1",
		left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		right_ear={ name="Erilaz Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+14','Mag. Acc.+14','Damage taken-5%',}},
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}

	sets.TreasureHunter = set_combine(sets.TreasureHunter, {})
	


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
		neck="Anu Torque",
		waist="Windbuffet Belt +1",
		left_ear="Telos Earring",
		right_ear="Sherida Earring",
		left_ring="Epona's Ring",
		right_ring="Niqmaddu Ring",
		back={ name="Ogma's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
	sets.engaged.InquartataPhysical = {
		ammo="Staunch Tathlum +1",
		head="Sworn Crown",
		body="Sworn Platemail",
		hands="Turms Mittens +1",
		legs="Eri. Leg Guards +3",
		feet="Erilaz Greaves +3",
		neck={ name="Futhark Torque +2", augments={'Path: A',}},
		waist="Flume Belt +1",
		left_ear="Tuisto Earring",
		right_ear="Alabaster Earring",
		left_ring="Regal Ring",
		right_ring="Gelatinous Ring +1",
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Parrying rate+5%',}},}
		
	sets.engaged.InquartataMagical = {
		ammo="Staunch Tathlum +1",
		head="Sworn Crown",
		body="Sworn Platemail",
		hands="Turms Mittens +1",
		legs="Eri. Leg Guards +3",
		feet="Erilaz Greaves +3",
		neck={ name="Futhark Torque +2", augments={'Path: A',}},
		waist="Engraved Belt",
		left_ear="Alabaster Earring",
		right_ear={ name="Erilaz Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+14','Mag. Acc.+14','Damage taken-5%',}},
		left_ring="Shadow Ring",
		right_ring="Gelatinous Ring +1",
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Parrying rate+5%',}},}

	sets.engaged.MagicTank = {
		ammo="Vanir Battery",
		head="Null Masque",
		body="Runeist Coat +4",
		hands="Nyame Gauntlets",
		legs="Eri. Leg Guards +3",
		feet="Erilaz Greaves +3",
		neck="Warder's Charm +1",
		waist="Engraved Belt",
		left_ear="Alabaster Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Vexer Ring +1",
		right_ring="Gelatinous Ring +1",
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Parrying rate+5%',}},}		

    sets.engaged.Aftermath = {
		ammo="Aurgelmir Orb +1",
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs="Eri. Leg Guards +3",
		feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
		neck="Anu Torque",
		waist="Windbuffet Belt +1",
		left_ear="Telos Earring",
		right_ear="Sherida Earring",
		left_ring={ name="Chirich Ring +1", bag="wardrobe7" },
		right_ring="Niqmaddu Ring",
		back={ name="Ogma's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.DT	= {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body="Ashera Harness",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Anu Torque",
		waist="Ioskeha Belt +1",
		left_ear="Brutal Earring",
		right_ear="Sherida Earring",
		left_ring="Niqmaddu Ring",
		right_ring={ name="Moonlight Ring", bag="wardrobe8" },
		back={ name="Ogma's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
		}
		
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	sets.Kiting = {right_ring="Shneddick Ring",}

    sets.TreasureHunter = {
		ammo="Per. Lucky Egg", --TH1
		body="Volte Jupon",		--TH2
		waist="Chaac Belt",} --TH+1

	sets.buff.Doom = set_combine(sets.buff.Doom, {neck="Nicander's Necklace", waist="Gishdubar Sash",})
	sets.buff.Embolden = {back={ name="Evasionist's Cape", augments={'Enmity+3','"Embolden"+15','"Dbl.Atk."+3',}},}
	
	--Weapon Sets

    sets.weapons.Epeolatry = {main={ name="Epeolatry", augments={'Path: A',}},}
    sets.weapons.Aettir = {main="Aettir"}
	sets.weapons.Lycurgos = {main="Lycurgos"}
	sets.weapons.Dolichenus = {main="Dolichenus"}
	sets.weapons.Reikiko = {main="Trial Blade"}
	
	--Grip Sets
	
	sets.Refined = {sub={ name="Refined Grip +1", augments={'Path: A',}},}
	sets.Utu = {sub="Utu Grip",}
	
	--Shield Sets
	
	sets.shield = {sub="Regis",}
	
end

	-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book: (set, book)
	set_macro_page(1, 20)
end

function user_job_lockstyle()
    send_command('input /lockstyleset ' .. lockstyleset)
end