-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_job_setup()
	state.OffenseMode:options('Normal','Acc')
	state.HybridMode:options('Normal', 'DT', 'Defense')
	state.RangedMode:options('Normal', 'Acc')
	state.WeaponskillMode:options('Normal','Acc','ATKCAP')
	state.CastingMode:options('Normal','Resistant')
	state.IdleMode:options('Normal', 'Aminon')
	state.Weapons:options('Naegling', 'Onion', 'RostamA', 'RostamC')
	state.RangeSet = M{['description']='Range Set', 'TP_Gun', 'Fomalhaut', 'Armageddon', 'DeathPenalty', 'Earp', 'Compensator'}
	state.Quickdraw = M{['description']='Quickdraw', 'Fire', 'Ice', 'Earth', 'Wind', 'Thunder', 'Water'}
	state.CorsairShot = M{['description']='Corsair_Shot', 'Store_TP', 'Damage'}
	state.Subweapon = M{['description']='Sub Weapon Set', 'Gleti', 'Crepuscular', 'Kustawi'}
	
	dagger_weapons = {
		RostamA = true,
		RostamC = true,}
	
	init_job_states({},{"Weapons","Subweapon","RangeSet","OffenseMode","WeaponskillMode","IdleMode","CastingMode","Quickdraw","CorsairShot","TreasureMode",})


	gear.RAbullet = "Chrono Bullet"
	gear.Accbullet = "Chrono Bullet"
	gear.WSbullet = "Chrono Bullet"
	gear.MAbullet = "Chrono Bullet" --For MAB WS, do not put single-use bullets here.
	gear.MeleeWSbullet = "Bayeux Bullet"
	gear.Idlebullet = "Bayeux Bullet"
	gear.QDbullet = "Animikii Bullet"
	options.ammo_warning_limit = 15

	--Includes Global Bind keys
	
	send_command('wait 2; exec Global-Binds.txt')
	
	--Corsair Binds
	
	send_command('wait 2; exec /COR/Binds.txt')
	
	--Corsair Gear Retrieval
	
	send_command('wait 3;org get inventory cor')
	send_command('wait 4;get Animikii Bullet')
	send_command('wait 4;get Bayeux Bullet')
	send_command('wait 4;get Chrono Bullet all')
	send_command('wait 4;get Devastating Bullet all')
	send_command('wait 4;get Living Bullet all')
	send_command('wait 4;get Trump Card all')
	send_command('wait 4;get Shihei all')

	--Job Settings
	
	lockstyleset = 16
	select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
	enable('main','sub','range','ammo','head','body','hands','legs','feet','neck','waist','left_ear','right_ear','left_ring','right_ring','back')

	--Remove Global Binds

	send_command('wait 1; exec Global-UnBinds.txt')
	
	--Gear Removal Script
	
	send_command('wait 1; org get store')
	send_command('put Animikii Bullet Satchel')
	send_command('put Bayeux Bullet Satchel')
	send_command('put Chrono Bullet Satchel all')
	send_command('put Devastating Bullet Satchel all')
	send_command('put Living Bullet Satchel all')
	send_command('put Trump Card satchel all')
	send_command('put Shihei Satchel all')

end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.JA['Snake Eye'] = {legs="Lanun Trews +3"}
    sets.precast.JA['Wild Card'] = {feet="Lanun Bottes +4"}
    sets.precast.JA['Random Deal'] = {body="Lanun Frac +4"}

	
	sets.precast.FoldDoubleBust = {hands="Lanun Gants +4"}

	sets.precast.CorsairRoll = {
		main={ name="Rostam", augments={'Path: C',}},
		range="Compensator",
		ammo=gear.Idlebullet,
		head={ name="Lanun Tricorne +3", augments={'Enhances "Winning Streak" effect',}},
		body="Chasseur's Frac +3",
		hands="Chasseur's Gants +3",
		legs={ name="Desultor Tassets", augments={'"Phantom Roll" ability delay -5','Movement speed +8%+2',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Regal Necklace",
		waist="Flume Belt +1",
		left_ear="Genmei Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring="Defending Ring",
		back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},}
		
	sets.precast.JA['Double-Up'] = sets.precast.CorsairRoll

	sets.precast.LuzafRing = {left_ring="Luzaf's Ring",}

	sets.precast.CorsairRoll["Blitzer's Roll"] = set_combine(sets.precast.CorsairRoll, {head="Chass. Tricorne +3",})
    sets.precast.CorsairRoll["Tactician's Roll"] = set_combine(sets.precast.CorsairRoll, {body="Chasseur's Frac +3"})
    sets.precast.CorsairRoll["Allies' Roll"] = set_combine(sets.precast.CorsairRoll, {hands="Chasseur's Gants +3"})
	sets.precast.CorsairRoll["Caster's Roll"] = set_combine(sets.precast.CorsairRoll, {legs="Chas. Culottes +3",})
	sets.precast.CorsairRoll["Courser's Roll"] = set_combine(sets.precast.CorsairRoll, {feet="Chass. Bottes +3",})

	--Standard TP Generating Shot
	sets.precast.CorsairShot = {
		ammo=gear.QDbullet,
		head={ name="Ikenga's Hat", augments={'Path: A',}},
		body={ name="Mirke Wardecors", augments={'"Quick Draw" ability delay -5','"Store TP"+4 "Subtle Blow"+4',}},
		hands="Malignance Gloves",
		legs="Chas. Culottes +3",
		feet="Chass. Bottes +3",
		neck={ name="Comm. Charm +2", augments={'Path: A',}},
		waist="Gerdr Belt +1",
		left_ear="Telos Earring",
		right_ear="Cessance Earring",
		left_ring={ name="Chirich Ring +1", bag="wardrobe7" },
		right_ring={ name="Chirich Ring +1", bag="wardrobe8" },
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

	--Damage shot for use with CastingMode: Fodder
	sets.precast.CorsairShot.Damage = {
		ammo=gear.QDbullet,
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Lanun Frac +4", augments={'Enhances "Loaded Deck" effect',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Chass. Bottes +3",
		neck="Baetyl Pendant",
		waist="Skrymir Cord +1",
		left_ear="Friomisi Earring",
		right_ear="Crep. Earring",
		left_ring="Dingir Ring",
		right_ring={ name="Chirich Ring +1", bag="wardrobe8" },
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

	--Macc Shot for Sleep/Dispel
	sets.precast.CorsairShot['Light Shot'] = {
		ammo=gear.QDbullet,
		head="Chass. Tricorne +3",
		body="Chasseur's Frac +3",
		hands="Chasseur's Gants +3",
		legs="Chas. Culottes +3",
		feet="Chass. Bottes +3",
		neck={ name="Comm. Charm +2", augments={'Path: A',}},
		waist="K. Kachina Belt +1",
		left_ear="Crep. Earring",
		right_ear={ name="Chas. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+14','Mag. Acc.+14','Crit.hit rate+5',}},
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','Weapon skill damage +10%',}},}

	sets.precast.CorsairShot['Dark Shot'] = set_combine(sets.precast.CorsairShot['Light Shot'], {})

	-- Waltz set (chr and vit)
	sets.precast.Waltz = set_combine(sets.idle, {legs="Dashing Subligar",ring1="Asklepian Ring",waist="Gishdubar Sash",})
	sets.precast.Waltz['Healing Waltz'] = set_combine(sets.idle, {legs="Dashing Subligar",})

	sets.Self_Waltz = {body="Passion Jacket"}
	
	sets.precast.Step = {}
		
	sets.precast.JA['Violent Flourish'] = {}

	-- Fast cast sets for spells

	sets.precast.FC = {
		ammo=gear.Idlebullet,
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body={ name="Adhemar Jacket +1", augments={'HP+105','"Fast Cast"+10','Magic dmg. taken -4',}},
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
		feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
		neck="Baetyl Pendant",
		waist="Flume Belt +1",
		left_ear="Loquac. Earring",
		right_ear="Etiolation Earring",
		left_ring="Kishar Ring",
		right_ring="Prolix Ring",
		back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},}

	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads",body="Passion Jacket"})

	sets.precast.RA = {
		ammo = get_ra_ammo(),
		head="Chass. Tricorne +3",
		body="Oshosi Vest +1",
		hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
		legs={ name="Adhemar Kecks +1", augments={'AGI+12','"Rapid Shot"+13','Enmity-6',}},
		feet="Meg. Jam. +2",
		neck={ name="Comm. Charm +2", augments={'Path: A',}},
		waist="Impulse Belt",
		left_ear="Alabaster Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Murky Ring",
		right_ring="Crepuscular Ring",
		back={ name="Camulus's Mantle", augments={'"Snapshot"+10',}},}

	sets.precast.RA.Flurry = {
		ammo = get_ra_ammo(),
		head="Chass. Tricorne +3",
		body="Laksa. Frac +4",
		hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
		legs={ name="Adhemar Kecks +1", augments={'AGI+12','"Rapid Shot"+13','Enmity-6',}},
		feet="Meg. Jam. +2",
		neck={ name="Comm. Charm +2", augments={'Path: A',}},
		waist="Yemaya Belt",
		left_ear="Alabaster Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Murky Ring",
		right_ring="Crepuscular Ring",
		back={ name="Camulus's Mantle", augments={'"Snapshot"+10',}},}
		
	sets.precast.RA.Flurry2 = {
		ammo = get_ra_ammo(),
		head="Chass. Tricorne +3",
		body="Laksa. Frac +4",
		hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
		legs={ name="Adhemar Kecks +1", augments={'AGI+12','"Rapid Shot"+13','Enmity-6',}},
		feet={ name="Pursuer's Gaiters", augments={'Rng.Acc.+10','"Rapid Shot"+10','"Recycle"+15',}},
		neck={ name="Comm. Charm +2", augments={'Path: A',}},
		waist="Yemaya Belt",
		left_ear="Alabaster Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Murky Ring",
		right_ring="Crepuscular Ring",
		back={ name="Camulus's Mantle", augments={'"Snapshot"+10',}},}
		
		--Set used for Icarus Wing to maximize TP gain	
	sets.precast.Wing = {
		head={ name="Ikenga's Hat", augments={'Path: A',}},
		body={ name="Ikenga's Vest", augments={'Path: A',}},
		hands="Malignance Gloves",
		legs="Chas. Culottes +3",
		feet="Malignance Boots",
		neck="Iskur Gorget",
		waist="Gerdr Belt +1",
		left_ear="Dedition Earring",
		right_ear="Crep. Earring",
		left_ring={ name="Chirich Ring +1", bag="wardrobe7" },
		right_ring={ name="Chirich Ring +1", bag="wardrobe8" },
		back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
	sets.precast.Volte_Harness = set_combine(sets.precast.Wing, {body="Volte Harness"})
	sets.precast.Prishes_Boots = set_combine(sets.precast.Wing, {feet="Prishe\'s Boots +1",})
	
    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------
	

	--Ranged Weaponskill Sets

    sets.precast.WS = {
		ammo=gear.WSbullet,
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Ikenga's Vest", augments={'Path: A',}},
		hands="Chasseur's Gants +3",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Lanun Bottes +4", augments={'Enhances "Wild Card" effect',}},
		neck={ name="Comm. Charm +2", augments={'Path: A',}},
		waist="Yemaya Belt",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Regal Ring",
		right_ring="Ephramad's Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS.Acc = {
		ammo=gear.Accbullet,
		head="Chass. Tricorne +3",
		body="Chasseur's Frac +3",
		hands="Chasseur's Gants +3",
		legs="Chas. Culottes +3",
		feet={ name="Ikenga's Clogs", augments={'Path: A',}},
		neck={ name="Comm. Charm +2", augments={'Path: A',}},
		waist="K. Kachina Belt +1",
		left_ear="Telos Earring",
		right_ear={ name="Chas. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+14','Mag. Acc.+14','Crit.hit rate+5',}},
		left_ring={ name="Cacoethic Ring +1", augments={'Path: A',}},
		right_ring="Ephramad's Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS.ATKCAP = {
		ammo=gear.WSbullet,
	    head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Ikenga's Vest", augments={'Path: A',}},
		hands="Chasseur's Gants +3",
		legs={ name="Ikenga's Trousers", augments={'Path: A',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear={ name="Chas. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+14','Mag. Acc.+14','Crit.hit rate+5',}},
		left_ring="Regal Ring",
		right_ring="Ephramad's Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%',}},}
		
		-- Swap to these on Moonshade using WS if at 3000 TP
	sets.MaxTP = {left_ear="Telos Earring",}
	sets.AccMaxTP = {}
		
    sets.precast.WS['Last Stand'] = {
		ammo=gear.WSbullet,
	    head="Nyame Helm",
		body="Ikenga's Vest",
		hands="Chasseur's Gants +3",
		legs="Nyame Flanchard",
		feet="Lanun Bottes +4",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Alabaster Earring",
		right_ear="Moonshade Earring",
		left_ring="Regal Ring",
		right_ring="Ephramad's Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Last Stand'].Acc = sets.precast.WS['Last Stand']
	sets.precast.WS['Last Stand'].ATKCAP = sets.precast.WS['Last Stand']
	
	sets.precast.WS['Last Stand'].FullTP = {right_ear="Odr Earring",}
	
	sets.precast.WS['Detonator'] = sets.precast.WS['Last Stand']
	
	sets.precast.WS['Detonator'].Acc = sets.precast.WS['Last Stand']
	sets.precast.WS['Detonator'].ATKCAP = sets.precast.WS['Last Stand']
	sets.precast.WS['Detonator'].FullTP = {right_ear="Odr Earring",}
	
	sets.precast.WS['Terminus'] = {
		ammo=gear.WSbullet,
	    head="Nyame Helm",
		body="Ikenga's Vest",
		hands="Chasseur's Gants +3",
		legs="Nyame Flanchard",
		feet="Lanun Bottes +4",
		neck={ name="Comm. Charm +2", augments={'Path: A',}},
		waist="Fotia Belt",
		left_ear="Alabaster Earring",
		right_ear="Moonshade Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Ephramad's Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Terminus'].Acc = sets.precast.WS['Terminus']
	sets.precast.WS['Terminus'].ATKCAP = sets.precast.WS['Terminus']
	
	sets.precast.WS['Terminus'].FullTP = {right_ear="Odr Earring",}
	
    sets.precast.WS['Leaden Salute'] = {
		ammo=gear.MAbullet,
		head="Pixie Hairpin +1",
		body={ name="Lanun Frac +4", augments={'Enhances "Loaded Deck" effect',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Lanun Bottes +4", augments={'Enhances "Wild Card" effect',}},
		neck={ name="Comm. Charm +2", augments={'Path: A',}},
		waist="Skrymir Cord +1",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Friomisi Earring",
		left_ring="Dingir Ring",
		right_ring="Archon Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','Weapon skill damage +10%',}},}

	sets.precast.WS['Leaden Salute'].FullTP = {left_ear="Hecate's Earring"}
	
    sets.precast.WS['Wildfire'] = {
		ammo=gear.MAbullet,
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Lanun Frac +4", augments={'Enhances "Loaded Deck" effect',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Lanun Bottes +4", augments={'Enhances "Wild Card" effect',}},
		neck={ name="Comm. Charm +2", augments={'Path: A',}},
		waist="Skrymir Cord +1",
		left_ear="Friomisi Earring",
		right_ear="Ishvara Earring",
		left_ring="Dingir Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','Weapon skill damage +10%',}},}

    sets.precast.WS['Hot Shot'] = {
		ammo=gear.WSbullet,
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Chasseur's Gants +3",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Lanun Bottes +4", augments={'Enhances "Wild Card" effect',}},
		neck="Fotia Gorget",
		waist="Skrymir Cord +1",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Friomisi Earring",
		left_ring="Dingir Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Hot Shot'].FullTP = {left_ear="Hecate's Earring"}

		--Melee Weaponskill sets

	sets.precast.WS.Melee = {
		ammo=gear.MeleeWSbullet,
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Chasseur's Gants +3",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Ephramad's Ring",
		right_ring="Sroda Ring",
		back={ name="Camulus's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS.MeleeAcc = {
		ammo=gear.MeleeWSbullet,
		head="Chass. Tricorne +3",
		body="Chasseur's Frac +3",
		hands="Chasseur's Gants +3",
		legs="Chas. Culottes +3",
		feet="Chass. Bottes +3",
		neck="Combatant's Torque",
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear="Odr Earring",
		right_ear={ name="Chas. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+14','Mag. Acc.+14','Crit.hit rate+5',}},
		left_ring={ name="Cacoethic Ring +1", augments={'Path: A',}},
		right_ring="Ephramad's Ring",
		back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},}
	
	sets.precast.WS.MeleeATKCAP = {
		ammo=gear.MeleeWSbullet,
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Ikenga's Vest", augments={'Path: A',}},
		hands="Chasseur's Gants +3",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Lanun Bottes +4", augments={'Enhances "Wild Card" effect',}},
		neck={ name="Comm. Charm +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Ephramad's Ring",
		right_ring="Sroda Ring",
		back={ name="Camulus's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
    sets.precast.WS['Savage Blade'] = sets.precast.WS.Melee
	sets.precast.WS['Savage Blade'].Acc = sets.precast.WS.MeleeAcc
	sets.precast.WS['Savage Blade'].ATKCAP = sets.precast.WS.MeleeATKCAP
	sets.precast.WS['Savage Blade'].FullTP = {left_ear="Telos Earring",}
	
	sets.precast.WS['Fast Blade II'] = {
		ammo=gear.MeleeWSbullet,
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Rep. Plat. Medal",
		waist="Sailfi Belt +1",
		ear1="Alabaster Earring",
		ear2="Moonshade Earring",
		ring1="Regal Ring",
		ring2="Ephramad's ring",
		back={ name="Camulus's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Fast Blade II'].Acc = sets.precast.WS.MeleeAcc
	sets.precast.WS['Fast Blade II'].ATKCAP = sets.precast.WS.MeleeATKCAP
	sets.precast.WS['Fast Blade II'].FullTP = {left_ear="Telos Earring",}

    sets.precast.WS['Evisceration'] = {
		ammo=gear.MeleeWSbullet,
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body="Mummu Jacket +2",
		hands="Chasseur's Gants +3",
		legs={ name="Zoar Subligar +1", augments={'Path: A',}},
		feet="Mummu Gamash. +2",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Odr Earring",
		right_ear={ name="Chas. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+14','Mag. Acc.+14','Crit.hit rate+5',}},
		left_ring="Ilabrat Ring",
		right_ring="Regal Ring",
		back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}},}

	sets.precast.WS['Exenterator'] = {
		ammo=gear.MeleeWSbullet,
	    head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Chasseur's Gants +3",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Telos Earring",
		right_ear={ name="Chas. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+14','Mag. Acc.+14','Crit.hit rate+5',}},
		left_ring="Ephramad's Ring",
		right_ring="Dingir Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%',}},}
    sets.precast.WS['Exenterator'].Acc = sets.precast.WS.MeleeAcc

	sets.precast.WS['Aeolian Edge'] = {
		ammo=gear.MAbullet,
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Lanun Frac +4", augments={'Enhances "Loaded Deck" effect',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Lanun Bottes +4", augments={'Enhances "Wild Card" effect',}},
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Friomisi Earring",
		left_ring="Dingir Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Aeolian Edge'].FullTP = {left_ear="Hecate's Earring"}
	
	sets.precast.WS['Cyclone'] = sets.precast.WS['Aeolian Edge']

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
	
	sets.midcast.FastRecast = sets.precast.FC

	-- Specific spells

	sets.midcast.Cure = {}

	sets.Self_Healing = {neck="Phalaina Locket",ring2="Kunaji Ring",waist="Gishdubar Sash"} --hands="Buremte Gloves",
	sets.Cure_Received = {neck="Phalaina Locket",ring2="Kunaji Ring",waist="Gishdubar Sash"} --hands="Buremte Gloves",

	sets.midcast.Utsusemi = sets.midcast.FastRecast
	
	sets.midcast['Absorb-TP'] = {
		ammo=gear.Accbullet,
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body="Chasseur's Frac +3",
		hands="Chasseur's Gants +3",
		legs="Chas. Culottes +3",
		feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
		neck="Null Loop",
		waist="Null Belt",
		left_ear="Loquac. Earring",
		right_ear={ name="Chas. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+14','Mag. Acc.+14','Crit.hit rate+5',}},
		left_ring="Kishar Ring",
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back="Null Shawl",}
		
	sets.midcast['Aspir'] = {
		ammo=gear.Accbullet,
	    head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body="Chasseur's Frac +3",
		hands="Chasseur's Gants +3",
		legs="Chas. Culottes +3",
		feet="Chass. Bottes +3",
		neck="Null Loop",
		waist="Null Belt",
		left_ear="Digni. Earring",
		right_ear={ name="Chas. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+14','Mag. Acc.+14','Crit.hit rate+5',}},
		left_ring="Evanescence Ring",
		right_ring="Excelsis Ring",
		back="Null Shawl",}

    -- Ranged gear
    sets.midcast.RA = {
		ammo=gear.RAbullet,
		head="Ikenga's Hat",
		body="Ikenga's Vest",
		hands="Malignance Gloves",
		legs="Chas. Culottes +3",
		feet="Ikenga's Clogs",
		neck="Iskur Gorget",
		waist="Gerdr Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Dedition Earring",
		left_ring="Ephramad's Ring",
		right_ring="Crepuscular Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    sets.midcast.RA.Acc = {
		ammo=gear.Accbullet,
		head="Ikenga's Hat",
		body="Ikenga's Vest",
		hands="Malignance Gloves",
		legs="Chas. Culottes +3",
		feet="Ikenga's Clogs",
		neck="Iskur Gorget",
		waist="Gerdr Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Dedition Earring",
		left_ring="Ephramad's Ring",
		right_ring="Crepuscular Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

	sets.TripleShot = {
		ammo=gear.RAbullet,
		head="Oshosi Mask +1",
		body="Chasseur's Frac +3",
		hands="Lanun Gants +4",
		legs="Ikenga's Trousers",
		feet="Ikenga's Clogs",
		neck="Iskur Gorget",
		waist="Gerdr Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Dedition Earring",
		left_ring="Crepuscular Ring",
		right_ring="Ephramad's Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
	sets.TripleShot.Acc = {
		ammo=gear.Accbullet,
		head="Oshosi Mask +1",
		body="Chasseur's Frac +3",
		hands="Lanun Gants +4",
		legs="Ikenga's Trousers",
		feet="Ikenga's Clogs",
		neck="Iskur Gorget",
		waist="Gerdr Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Dedition Earring",
		left_ring="Crepuscular Ring",
		right_ring="Ephramad's Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
	
	sets.TripleShot_AM = {
		ammo=gear.RAbullet,
		head="Oshosi Mask +1",
		body="Chasseur's Frac +3",
		hands="Lanun Gants +4",
		legs="Ikenga's Trousers",
		feet="Osh. Leggings +1",
		neck={ name="Comm. Charm +2", augments={'Path: A',}},
		waist="K. Kachina Belt +1",
		left_ear="Alabaster Earring",
		right_ear={ name="Chas. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+14','Mag. Acc.+14','Crit.hit rate+5',}},
		left_ring="Regal Ring",
		right_ring="Ephramad's Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Crit.hit rate+10','Phys. dmg. taken-10%',}},}
		
	sets.TripleShot_AM.Acc = {
		ammo=gear.Accbullet,
		head="Oshosi Mask +1",
		body="Chasseur's Frac +3",
		hands="Lanun Gants +4",
		legs="Ikenga's Trousers",
		feet="Osh. Leggings +1",
		neck={ name="Comm. Charm +2", augments={'Path: A',}},
		waist="K. Kachina Belt +1",
		left_ear="Alabaster Earring",
		right_ear={ name="Chas. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+14','Mag. Acc.+14','Crit.hit rate+5',}},
		left_ring="Regal Ring",
		right_ring="Ephramad's Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Crit.hit rate+10','Phys. dmg. taken-10%',}},}

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.resting = sets.idle

    sets.idle = {
		ammo=gear.Idlebullet,
		head="Null Masque",
		body="Adamantite Armor",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Flume Belt +1",
		left_ear="Tuisto Earring",
		right_ear="Eabani Earring",
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring={ name="Chirich Ring +1", bag="wardrobe8" },
		back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
    sets.idle.Aminon = {
		ammo=gear.Idlebullet,
		head="Null Masque",
		body="Malignance Tabard",
		hands="Regal Gloves",
		legs="Chas. Culottes +3",
		feet="Malignance Boots",
		neck="Sibyl Scarf",
		waist="Sweordfaetels +1",
		left_ear="Dedition Earring",
		right_ear="Telos Earring",
		left_ring={ name="Chirich Ring +1", bag="wardrobe7" },
		right_ring={ name="Chirich Ring +1", bag="wardrobe8" },
		back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
	sets.idle.rollers = set_combine(sets.idle, {right_ring="Roller's Ring",})
	sets.idle.Aminon.rollers = set_combine(sets.idle.Aminon, {right_ring="Roller's Ring",})

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    sets.engaged = {
		ammo=gear.Idlebullet,
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs="Chas. Culottes +3",
		feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
		neck="Iskur Gorget",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Telos Earring",
		right_ear="Dedition Earring",
		left_ring={ name="Chirich Ring +1", bag="wardrobe7" },
		right_ring="Epona's Ring",
		back="Null Shawl",}

    sets.engaged.Acc = sets.engaged
		
    sets.engaged.Dagger = {
		ammo=gear.Idlebullet,
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs="Chas. Culottes +3",
		feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
		neck="Iskur Gorget",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Telos Earring",
		right_ear="Dedition Earring",
		left_ring={ name="Chirich Ring +1", bag="wardrobe7" },
		right_ring="Epona's Ring",
		back="Null Shawl",}

    sets.engaged.Dagger.Acc = sets.engaged.Dagger

	------------------------------------------------------------------------------------------------
	----------------------------------------Dual Wield Sets ----------------------------------------
	------------------------------------------------------------------------------------------------
	
    sets.engaged.DW = {
		ammo=gear.Idlebullet,
		head="Malignance Chapeau",
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs="Chas. Culottes +3",
		feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
		neck="Iskur Gorget",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Suppanomimi",
		right_ear="Dedition Earring",
		left_ring={ name="Chirich Ring +1", bag="wardrobe7" },
		right_ring="Epona's Ring",
		back="Null Shawl",}

    sets.engaged.DW.Acc = sets.engaged.DW
	
    sets.engaged.Dagger_DW = {
		ammo=gear.Idlebullet,
		head="Malignance Chapeau",
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs="Chas. Culottes +3",
		feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
		neck="Iskur Gorget",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Suppanomimi",
		right_ear="Dedition Earring",
		left_ring={ name="Chirich Ring +1", bag="wardrobe7" },
		right_ring="Epona's Ring",
		back="Null Shawl",}

    sets.engaged.Dagger_DW.Acc = sets.engaged.DW

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Chas. Culottes +3",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
        }
		
	sets.engaged.Hybrid.Defense = {
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs="Chas. Culottes +3",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
        }
		
    sets.engaged.Hybrid.Dagger = {
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Chas. Culottes +3",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
        }
		
	sets.engaged.Hybrid.Dagger.Defense = {
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs="Chas. Culottes +3",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
        }
		
    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
    sets.engaged.Acc.DT = set_combine(sets.engaged.Acc, sets.engaged.Hybrid)
	sets.engaged.Defense = set_combine(sets.engaged, sets.engaged.Hybrid.Defense)
    sets.engaged.Acc.Defense = set_combine(sets.engaged.Acc, sets.engaged.Hybrid.Defense)
	
    sets.engaged.Dagger.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
    sets.engaged.Dagger.Acc.DT = set_combine(sets.engaged.Acc, sets.engaged.Hybrid)
	sets.engaged.Dagger.Defense = set_combine(sets.engaged, sets.engaged.Hybrid.Defense)
    sets.engaged.Dagger.Acc.Defense = set_combine(sets.engaged.Acc, sets.engaged.Hybrid.Defense)

    ------------------------------------------------------------------------------------------------
    ------------------------------------ Hybrid Dual Wield Sets ------------------------------------
    ------------------------------------------------------------------------------------------------
		
    sets.engaged.Hybrid.DW = {
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Chas. Culottes +3",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		right_ear="Eabani Earring",
		back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
	sets.engaged.Hybrid.DW.Defense = {
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs="Chas. Culottes +3",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		right_ear="Eabani Earring",
		back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
        }
		
    sets.engaged.Hybrid.Dagger_DW = {
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Chas. Culottes +3",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		right_ear="Eabani Earring",
		back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
	sets.engaged.Hybrid.Dagger_DW.Defense = {
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs="Chas. Culottes +3",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		right_ear="Eabani Earring",
		back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
        }

    sets.engaged.DW.DT = set_combine(sets.engaged.DW, sets.engaged.Hybrid.DW)
    sets.engaged.DW.Acc.DT = set_combine(sets.engaged.DW.Acc, sets.engaged.Hybrid.DW)
    sets.engaged.DW.Defense = set_combine(sets.engaged.DW, sets.engaged.Hybrid.DW.Defense)
    sets.engaged.DW.Acc.Defense = set_combine(sets.engaged.DW.Acc, sets.engaged.Hybrid.DW.Defense)
	
    sets.engaged.Dagger_DW.DT = set_combine(sets.engaged.Dagger_DW, sets.engaged.Hybrid.Dagger_DW)
    sets.engaged.Dagger_DW.Acc.DT = set_combine(sets.engaged.Dagger_DW.Acc, sets.engaged.Hybrid.Dagger_DW)
    sets.engaged.Dagger_DW.Defense = set_combine(sets.engaged.Dagger_DW, sets.engaged.Hybrid.Dagger_DW.Defense)
    sets.engaged.Dagger_DW.Acc.Defense = set_combine(sets.engaged.Dagger_DW.Acc, sets.engaged.Hybrid.Dagger_DW.Defense)

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
	
	sets.Kiting = {left_ring="Shneddick Ring",}
	
	sets.TreasureHunter = {
		body="Volte Jupon",
		hands="Volte Bracers",
		waist="Chaac Belt",}
	
	sets.buff.Doom = set_combine(sets.buff.Doom, {neck="Nicander's Necklace", waist="Gishdubar Sash",})

	--Weaponsets

	sets.weapons.Naegling = {main="Naegling",}
	sets.weapons.Onion = {main="Onion Sword III",}	
	sets.weapons.RostamA = {main={ name="Rostam", augments={'Path: A',}},}
	sets.weapons.RostamC = {main={ name="Rostam", augments={'Path: C',}},}

	sets.Gleti = {sub={ name="Gleti's Knife", augments={'Path: A',}},}
	sets.Crepuscular = {sub="Crepuscular Knife",}
	sets.Kustawi = {sub={ name="Kustawi +1", augments={'Path: A',}},}
	
	sets.shield = { sub="Nusku Shield" }
	
	--Rangesets
	sets.TP_Gun = {range="Anarchy +2",}
	sets.Earp = {range="Earp",}
	sets.Fomalhaut = {range="Fomalhaut",}
	sets.DeathPenalty = {range="Death Penalty",}
	sets.Armageddon = {range="Armageddon",}
	sets.Compensator = {range="Compensator",}
	
	
	--Ammosets
	sets.Devastating = {waist="Dev. Bul. Pouch",}
	sets.Chrono = {waist="Chr. Bul. Pouch",}
	sets.Living = {waist="Liv. Bul. Pouch",}
	
	
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
		--Default macro set/book
    set_macro_page(1, 16)
end

function user_job_lockstyle()
    send_command('input /lockstyleset ' .. lockstyleset)
end
