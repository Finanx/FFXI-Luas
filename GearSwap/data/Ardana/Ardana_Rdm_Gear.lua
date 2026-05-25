function user_job_setup()
	-- Options: Override default values
    state.OffenseMode:options('Normal','Enspell')
	state.WeaponskillMode:options('Normal','ATKCAP', 'Acc')
    state.HybridMode:options('Normal','DT','Defense')
	state.CastingMode:options('Normal','Resistant')
    state.IdleMode:options('Normal','Aminon')
	state.Weapons:options('None', 'Naegling', 'Crocea_Mors', 'Onion', 'Excalibur', 'Murgleis', 'Mpu_Gandring', 'Tauret', 'Maxentius')
	state.Subweapon = M{['description']='Sub Weapon Set', 'Thibron', 'Crepuscular', 'Gletis_Knife', 'Daybreak'}
	state.Shield = M{['description']='Shield Set', 'Genmei', 'Ammurapi', 'Archduke'}


	state.SpellInterrupt = M(false, 'SpellInterrupt')
	state.NukeMode = M{['description']='Nuke Mode','Normal','Low_MagicBurst','High_MagicBurst','Occult_Accumen'}
	state.RangeLock = M(false, 'Range Lock')
	
    skill_spells = S{
        'Temper', 'Temper II', 'Enfire', 'Enfire II', 'Enblizzard', 'Enblizzard II', 'Enaero', 'Enaero II',
        'Enstone', 'Enstone II', 'Enthunder', 'Enthunder II', 'Enwater', 'Enwater II'}

	init_job_states({},{"Weapons","Shield","Subweapon","OffenseMode","WeaponskillMode","IdleMode","CastingMode","SpellInterrupt","NukeMode","TreasureMode",})
		
	--Includes Global Bind keys
	
	send_command('wait 2; exec Global-Binds.txt')
	
    --Red Mage binds	

	send_command('wait 2; exec /RDM/Binds.txt')
	
	--Retrieve Gear for Red mage
	
	send_command('wait 3;org get inventory rdm.lua')
	send_command('wait 4;get Chapuli arrow all')
	send_command('wait 4;get Shihei all')

	lockstyleset = 5	
	select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
	enable('main','sub','range','ammo','head','body','hands','legs','feet','neck','waist','left_ear','right_ear','left_ring','right_ring','back')

	--Remove Global Binds

	send_command('wait 1; exec Global-UnBinds.txt')
	
	--Remove Gear for Red mage
	
	send_command('wait 1; org get Store.lua')
	send_command('put Chapuli arrow Satchel all')
	send_command('put Shihei Satchel all')
	
end

function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.JA['Chainspell'] = {body="Viti. Tabard +4"}
	sets.precast.JA['Convert'] = {main="Murgleis",}
	
	-- Fast cast sets for spells
	sets.precast.FC = {
		main={ name="Crocea Mors", augments={'Path: C',}},
		sub="Genmei Shield",
		ammo="Staunch Tathlum +1",
		head="Atro. Chapeau +4",
		body={ name="Viti. Tabard +4", augments={'Enhances "Chainspell" effect',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Plat. Mog. Belt",
		left_ear="Alabaster Earring",
		right_ear={ name="Leth. Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','"Dbl.Atk."+6','STR+7 DEX+7',}},
		left_ring="Kishar Ring",
		right_ring="Murky Ring",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
	sets.precast.FC.Dispelga = set_combine(sets.precast.FC, {main="Daybreak",sub="Genmei Shield"})

    sets.precast.FC.Impact = {
		main={ name="Crocea Mors", augments={'Path: C',}},
		sub="Genmei Shield",
		ammo="Sapience Orb",
		body="Crepuscular Cloak",
		hands="Leth. Ganth. +3",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Embla Sash",
		left_ear="Malignance Earring",
		right_ear={ name="Leth. Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','"Dbl.Atk."+6','STR+7 DEX+7',}},
		left_ring="Kishar Ring",
		right_ring="Murky Ring",
		back={ name="Fi Follet Cape +1", augments={'Path: A',}},}
		
	sets.precast.RA = {
		range="Ullr",
		ammo="Chapuli Arrow",
		head="Null Masque",
		body="Volte Harness",
		hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
		legs="Volte Tights",
		feet="Volte Spats",
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Yemaya Belt",
		left_ear="Genmei Earring",
		right_ear={ name="Alabaster Earring", augments={'Path: A',}},
		left_ring={ name="Murky Ring", augments={'Path: A',}},
		right_ring="Crepuscular Ring",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
		--Set used for Icarus Wing to maximize TP gain	
	sets.precast.Wing = {
	    ammo="Aurgelmir Orb +1",
		head={ name="Bunzi's Hat", augments={'Path: A',}},
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist="Gerdr Belt +1",
		left_ear="Telos Earring",
		right_ear="Sherida Earring",
		left_ring={ name="Chirich Ring +1", bag="wardrobe7" },
		right_ring={ name="Chirich Ring +1", bag="wardrobe8" },
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
	sets.precast.Volte_Harness = set_combine(sets.precast.Wing, {body="Volte Harness"})
	sets.precast.Prishes_Boots = set_combine(sets.precast.Wing, {feet="Prishe\'s Boots +1",})
	
    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

       
	-- Weaponskill sets

    sets.precast.WS = {
	    ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Viti. Chapeau +4", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Leth. Houseaux +3",
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Alabaster Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Ephramad's Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS.Acc = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Leth. Chappel +3",
		body="Lethargy Sayon +3",
		hands="Leth. Ganth. +3",
		legs="Leth. Fuseau +3",
		feet="Leth. Houseaux +3",
		neck="Combatant's Torque",
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear="Mache Earring +1",
		right_ear={ name="Leth. Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','"Dbl.Atk."+6','STR+7 DEX+7',}},
		left_ring="Ephramad's Ring",
		right_ring={ name="Cacoethic Ring +1", augments={'Path: A',}},
		back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}	
		
	sets.precast.WS.ATKCAP = {
	    ammo="Crepuscular Pebble",
		head={ name="Viti. Chapeau +4", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Atro. Gloves +4",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Leth. Houseaux +3",
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Alabaster Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Ephramad's Ring",
		right_ring="Sroda Ring",
		back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS.FullTPPhysical = {left_ear="Sherida Earring",}
	sets.precast.WS.FullTPMagical = {left_ear="Regal Earring",}

    sets.precast.WS['Savage Blade'] = {
	    ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Viti. Chapeau +4", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Leth. Houseaux +3",
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Alabaster Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Ephramad's Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
    sets.precast.WS['Savage Blade'].Acc = sets.precast.WS.Acc
	
    sets.precast.WS['Savage Blade'].ATKCAP = {
	    ammo="Crepuscular Pebble",
		head={ name="Viti. Chapeau +4", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Atro. Gloves +4",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Leth. Houseaux +3",
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Alabaster Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Ephramad's Ring",
		right_ring="Sroda Ring",
		back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
	
	sets.precast.WS['Flat Blade'] = sets.precast.WS.Acc
	
	sets.precast.WS['Chant du Cygne'] = {
		ammo="Yetshila +1",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Malignance Gloves",
		legs={ name="Zoar Subligar +1", augments={'Path: A',}},
		feet="Thereoid Greaves",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Alabaster Earring",
		right_ear="Sherida Earring",
		left_ring="Ephramad's Ring",
		right_ring="Begrudging Ring",
		back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Chant du Cygne'].Acc = sets.precast.WS.Acc
	
	sets.precast.WS['Chant du Cygne'].ATKCAP = {
		ammo="Yetshila +1",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs={ name="Zoar Subligar +1", augments={'Path: A',}},
		feet="Thereoid Greaves",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Alabaster Earring",
		right_ear="Sherida Earring",
		left_ring="Ephramad's Ring",
		right_ring="Murky Ring",
		back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
	
	sets.precast.WS['Death Blossom'] = {
		ammo="Crepuscular Pebble",
		head={ name="Viti. Chapeau +4", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Leth. Houseaux +3",
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Alabaster Earring",
		right_ear="Sherida Earring",
		left_ring="Ephramad's Ring",
		right_ring="Sroda Ring",
		back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Death Blossom'].Acc = sets.precast.WS.Acc

	sets.precast.WS['Death Blossom'].ATKCAP = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Viti. Chapeau +4", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Malignance Gloves",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Leth. Houseaux +3",
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Alabaster Earring",
		right_ear="Sherida Earring",
		left_ring="Ephramad's Ring",
		right_ring="Sroda Ring",
		back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Knights of Round'] = {
	    ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Viti. Chapeau +4", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Leth. Houseaux +3",
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Alabaster Earring",
		right_ear="Sherida Earring",
		left_ring="Ephramad's Ring",
		right_ring="Sroda Ring",
		back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Knights of Round'].Acc = sets.precast.WS.Acc

	sets.precast.WS['Knights of Round'].ATKCAP = {
	    ammo="Crepuscular Pebble",
		head={ name="Viti. Chapeau +4", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Leth. Houseaux +3",
		neck="Fotia Gorget",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Alabaster Earring",
		right_ear="Sherida Earring",
		left_ring="Ephramad's Ring",
		right_ring="Sroda Ring",
		back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
    sets.precast.WS['Imperator'] = {
	    ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Viti. Chapeau +4", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Leth. Houseaux +3",
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Alabaster Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Ephramad's Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Weapon skill damage +10%',}},}
	
	sets.precast.WS['Imperator'].Acc = sets.precast.WS.Acc
	
	sets.precast.WS['Imperator'].ATKCAP = {
	    ammo="Crepuscular Pebble",
		head={ name="Viti. Chapeau +4", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Bunzi's Robe",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Leth. Houseaux +3",
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Alabaster Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Ephramad's Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Weapon skill damage +10%',}},}	

    sets.precast.WS['Requiescat'] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Viti. Chapeau +4", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Leth. Houseaux +3",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Alabaster Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Ephramad's Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Requiescat'].Acc = sets.precast.WS.Acc
	
	sets.precast.WS['Requiescat'].ATKCAP = {
	    ammo="Crepuscular Pebble",
		head="Null Masque",
		body="Bunzi's Robe",
		hands="Malignance Gloves",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Leth. Houseaux +3",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Alabaster Earring",
		right_ear="Regal Earring",
		left_ring="Ephramad's Ring",
		right_ring="Sroda Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Weapon skill damage +10%',}},}
		
    sets.precast.WS['Fast Blade II'] = {
	    ammo="Crepuscular Pebble",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs={ name="Zoar Subligar +1", augments={'Path: A',}},
		feet="Malignance Boots",
		neck="Fotia Gorget",
		waist="Windbuffet Belt +1",
		left_ear="Alabaster Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Ephramad's Ring",
		right_ring={ name="Cacoethic Ring +1", augments={'Path: A',}},
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
	sets.precast.WS['Fast Blade II'].Acc = sets.precast.WS.Acc
	
	sets.precast.WS['Fast Blade II'].ATKCAP = sets.precast.WS['Fast Blade II']

    sets.precast.WS['Sanguine Blade'] = {
		ammo="Sroda Tathlum",
		head="Pixie Hairpin +1",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Jhakri Cuffs +2",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Leth. Houseaux +3",
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Archon Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Seraph Blade'] = {
		ammo="Sroda Tathlum",
		head="Leth. Chappel +3",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Leth. Ganth. +3",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Leth. Houseaux +3",
		neck="Fotia Gorget",
		waist="Orpheus's Sash",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Malignance Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Freke Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Weapon skill damage +10%',}},}

	sets.precast.WS['Red Lotus Blade'] = {
		ammo="Sroda Tathlum",
		head="Leth. Chappel +3",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Jhakri Cuffs +2",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Leth. Houseaux +3",
		neck="Sibyl Scarf",
		waist="Orpheus's Sash",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Malignance Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Freke Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Weapon skill damage +10%',}},}

	sets.precast.WS['Mercy Stroke'] = {
	    ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Alabaster Earring",
		right_ear="Sherida Earring",
		left_ring="Sroda Ring",
		right_ring="Ephramad's Ring",
		back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Mercy Stroke'].Acc = sets.precast.WS.Acc
	
	sets.precast.WS['Mercy Stroke'].ATKCAP = {
		ammo="Crepuscular Pebble",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Alabaster Earring",
		right_ear="Sherida Earring",
		left_ring="Sroda Ring",
		right_ring="Ephramad's Ring",
		back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

	sets.precast.WS['Ruthless Stroke'] = {
	    ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Leth. Houseaux +3",
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Alabaster Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Ilabrat Ring",
		right_ring="Ephramad's Ring",
		back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Ruthless Stroke'].Acc = sets.precast.WS.Acc
	
	sets.precast.WS['Ruthless Stroke'].ATKCAP = {
	    ammo="Crepuscular Pebble",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Malignance Gloves",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Leth. Houseaux +3",
		neck="Rep. Plat. Medal",
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear="Alabaster Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Epaminondas's Ring",
		right_ring="Ephramad's Ring",
		back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

	sets.precast.WS['Evisceration'] = {
		ammo="Yetshila +1",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Thereoid Greaves",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Alabaster Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Begrudging Ring",
		right_ring="Ephramad's Ring",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
	
	sets.precast.WS['Evisceration'].Acc = sets.precast.WS.Acc
	
	sets.precast.WS['Evisceration'].ATKCAP = {
		ammo="Yetshila +1",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs={ name="Zoar Subligar +1", augments={'Path: A',}},
		feet="Thereoid Greaves",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Alabaster Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Begrudging Ring",
		right_ring="Ephramad's Ring",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

	sets.precast.WS['Black Halo'] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Viti. Chapeau +4", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Leth. Houseaux +3",
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Alabaster Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Epaminondas's Ring",
		right_ring="Ephramad's Ring",
		back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Black Halo'].Acc = sets.precast.WS.Acc
	
	sets.precast.WS['Black Halo'].ATKCAP = {
	    ammo="Crepuscular Pebble",
		head={ name="Viti. Chapeau +4", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Atro. Gloves +4",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Leth. Houseaux +3",
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Alabaster Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Sroda Ring",
		right_ring="Ephramad's Ring",
		back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

    sets.precast.WS['Aeolian Edge'] = {
		ammo="Sroda Tathlum",
		head="Leth. Chappel +3",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Jhakri Cuffs +2",
		legs="Leth. Fuseau +3",
		feet="Leth. Houseaux +3",
		neck="Sibyl Scarf",
		waist="Orpheus's Sash",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Malignance Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Freke Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Enmity-10','Phys. dmg. taken-10%',}},}
		
	sets.precast.WS['Empyreal Arrow'] = {
	    head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Atro. Gloves +4",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Leth. Houseaux +3",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Alabaster Earring",
		left_ring="Ephramad's Ring",
		right_ring="Sroda Ring",
		back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

	-- Swap to these on Moonshade using WS if at 3000 TP
	sets.MaxTP = {left_ear="Sherida Earring",}
	sets.AccMaxTP = {left_ear="Sherida Earring",}
	sets.MagicalMaxTP = {left_ear="Regal Earring",}
	
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	sets.midcast.RA = {
		range="Ullr",
		ammo="Chapuli Arrow",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Combatant's Torque",
		waist="Yemaya Belt",
		left_ear="Telos Earring",
		right_ear="Crep. Earring",
		left_ring="Ephramad's Ring",
		right_ring={ name="Chirich Ring +1", bag="wardrobe8" },
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

	sets.Enmity = {
		ammo="Sapience Orb",
		head="Halitus Helm",
		body={ name="Emet Harness +1", augments={'Path: A',}},
		hands={ name="Merlinic Dastanas", augments={'Mag. Acc.+30','"Occult Acumen"+11','"Mag.Atk.Bns."+10',}},
		legs={ name="Zoar Subligar +1", augments={'Path: A',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Kasiri Belt",
		left_ear="Trux Earring",
		right_ear="Cryptic Earring",
		left_ring="Eihwaz Ring",
		right_ring="Supershear Ring",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
	sets.precast.Flourish1 = sets.precast.WS.Acc
	sets.precast.Flourish1['Animated Flourish'] = sets.Enmity

	sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.Cure = {
		main="Daybreak",
		sub="Ammurapi Shield",
		ammo="Regal Gem",
		head={ name="Kaykaus Mitra +1", augments={'MP+80','Spell interruption rate down +12%','"Cure" spellcasting time -7%',}},
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','"Cure" potency +6%','"Conserve MP"+7',}},
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','Spell interruption rate down +12%','"Cure" spellcasting time -7%',}},
		feet={ name="Kaykaus Boots +1", augments={'MP+80','Spell interruption rate down +12%','"Cure" spellcasting time -7%',}},
		neck="Incanter's Torque",
		waist="Bishop's Sash",
		left_ear="Beatific Earring",
		right_ear="Meili Earring",
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring="Sirona's Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Enmity-10','Phys. dmg. taken-10%',}},}
		
	sets.midcast.Curaga = sets.midcast.Cure
		
    sets.midcast.LightWeatherCure = set_combine(sets.midcast.Cure, {		
		main="Chatoyant Staff",
		sub="Enki Strap",
		waist="Hachirin-no-Obi",})
		
	
	sets.Cure_Received = {left_ring="Kunaji Ring",waist="Gishdubar Sash"}
		
    sets.midcast.CureSelf = {
		main="Daybreak",
		sub="Ammurapi Shield",
		ammo="Regal Gem",
		head={ name="Kaykaus Mitra +1", augments={'MP+80','Spell interruption rate down +12%','"Cure" spellcasting time -7%',}},
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','"Cure" potency +6%','"Conserve MP"+7',}},
		hands={ name="Buremte Gloves", augments={'Phys. dmg. taken -2%','Magic dmg. taken -2%','Phys. dmg. taken -2%',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','Spell interruption rate down +12%','"Cure" spellcasting time -7%',}},
		feet={ name="Kaykaus Boots +1", augments={'MP+80','Spell interruption rate down +12%','"Cure" spellcasting time -7%',}},
		neck="Nodens Gorget",
		waist="Gishdubar Sash",
		left_ear="Mendi. Earring",
		right_ear="Meili Earring",
		left_ring="Kunaji Ring",
		right_ring="Sirona's Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Enmity-10','Phys. dmg. taken-10%',}},}
		
	sets.midcast.CureSelfWeather = set_combine(sets.midcast.CureSelf, {		
		main="Chatoyant Staff",
		sub="Enki Strap",})
		
	sets.midcast.Cure_SpellInterrupt = {
		ammo="Staunch Tathlum +1",
		head={ name="Kaykaus Mitra +1", augments={'MP+80','Spell interruption rate down +12%','"Cure" spellcasting time -7%',}},
		body="Bunzi's Robe",
		hands={ name="Chironic Gloves", augments={'Mag. Acc.+4','Spell interruption rate down -11%','MND+3','"Mag.Atk.Bns."+4',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','Spell interruption rate down +12%','"Cure" spellcasting time -7%',}},
		feet={ name="Kaykaus Boots +1", augments={'MP+80','Spell interruption rate down +12%','"Cure" spellcasting time -7%',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Rumination Sash",
		left_ear="Alabaster Earring",
		right_ear="Mendi. Earring",
		left_ring="Defending Ring",
		right_ring="Murky Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Enmity-10','Phys. dmg. taken-10%',}},}

    sets.midcast.Cursna = {
		main="Daybreak",
		sub="Ammurapi Shield",
		ammo="Sapience Orb",
		head={ name="Kaykaus Mitra +1", augments={'MP+80','Spell interruption rate down +12%','"Cure" spellcasting time -7%',}},
		body={ name="Viti. Tabard +4", augments={'Enhances "Chainspell" effect',}},
		hands={ name="Vanya Cuffs", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
		legs="Atro. Tights +4",
		feet={ name="Vanya Clogs", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
		neck="Debilis Medallion",
		waist="Bishop's Sash",
		left_ear="Beatific Earring",
		right_ear="Meili Earring",
		left_ring="Menelaus's Ring",
		right_ring="Haoma's Ring",
		back={ name="Fi Follet Cape +1", augments={'Path: A',}},}

	sets.midcast.StatusRemoval = sets.midcast.FastRecast
	
    sets.midcast['Enhancing Magic'] = {
		main={ name="Sakpata's Sword", augments={'Path: A',}},
		sub="Ammurapi Shield",
		ammo="Staunch Tathlum +1",
		head={ name="Telchine Cap", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		body={ name="Viti. Tabard +4", augments={'Enhances "Chainspell" effect',}},
		hands="Atro. Gloves +4",
		legs={ name="Telchine Braconi", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		feet="Leth. Houseaux +3",
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Embla Sash",
		left_ear="Malignance Earring",
		right_ear={ name="Leth. Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','"Dbl.Atk."+6','STR+7 DEX+7',}},
		left_ring="Murky Ring",
		right_ring="Prolix Ring",
		back={ name="Ghostfyre Cape", augments={'Enfb.mag. skill +1','Enha.mag. skill +10','Mag. Acc.+2','Enh. Mag. eff. dur. +19',}},}

	sets.buff.ComposureOther = {
		main={ name="Crocea Mors", augments={'Path: C',}},
		sub="Ammurapi Shield",
		ammo="Sapience Orb",
		head="Leth. Chappel +3",
		body="Lethargy Sayon +3",
		hands="Atro. Gloves +4",
		legs="Leth. Fuseau +3",
		feet="Leth. Houseaux +3",
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Embla Sash",
		left_ear="Malignance Earring",
		right_ear={ name="Leth. Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','"Dbl.Atk."+6','STR+7 DEX+7',}},
		left_ring="Kishar Ring",
		right_ring="Prolix Ring",
		back={ name="Ghostfyre Cape", augments={'Enfb.mag. skill +1','Enha.mag. skill +10','Mag. Acc.+2','Enh. Mag. eff. dur. +19',}},}
		
	--Red Mage enhancing sets are handled in a different way from most, layered on due to the way Composure works
	--Don't set combine a full set with these spells, they should layer on Enhancing Set > Composure (If Applicable) > Spell
	sets.EnhancingSkill = {
		main="Pukulatmuj +1",
		sub={ name="Forfend +1", augments={'Path: A',}},
		ammo="Sapience Orb",
		head="Befouled Crown",
		body={ name="Viti. Tabard +4", augments={'Enhances "Chainspell" effect',}},
		hands={ name="Viti. Gloves +4", augments={'Enhancing Magic duration',}},
		legs="Atrophy Tights +4",
		feet="Leth. Houseaux +3",
		neck="Hoxne Torque",
		waist="Olympus Sash",
		left_ear="Mimir Earring",
		right_ear="Andoaa Earring",
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back={ name="Ghostfyre Cape", augments={'Enfb.mag. skill +1','Enha.mag. skill +10','Mag. Acc.+2','Enh. Mag. eff. dur. +19',}},}
		
	sets.midcast.Temper = sets.EnhancingSkill
	sets.midcast.Enspell = sets.EnhancingSkill
	sets.midcast.Gain_Spell = {hands="Viti. Gloves +4"}
		
	sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {head="Amalric Coif +1",body="Atrophy Tabard +4",legs="Leth. Fuseau +3"})
	sets.midcast.Refresh_Composure = set_combine(sets.Compo, {head="Amalric Coif +1",body="Atrophy Tabard +4",legs="Leth. Fuseau +3"})
	sets.Self_Refresh = set_combine(sets.midcast.Refresh, {waist="Gishdubar Sash",})
	
	
	sets.midcast['Aquaveil'] = set_combine(sets.midcast['Enhancing Magic'], {
		head={ name="Amalric Coif +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands="Regal Cuffs",})
	sets.midcast.BarStatus = set_combine(sets.midcast['Enhancing Magic'], {neck="Sroda Necklace"})

	sets.midcast.Regen = set_combine(sets.midcast['Enhancing Magic'], {main="Bolelabunga",sub="Ammurapi Shield", feet="Bunzi's Sabots"})
	sets.midcast.Regen_Composure = set_combine(sets.buff.ComposureOther, {main="Bolelabunga",sub="Ammurapi Shield", feet="Bunzi's Sabots"})
	
	sets.midcast['Phalanx'] = {
		main={ name="Sakpata's Sword", augments={'Path: A',}},
		sub="Ammurapi Shield",
		ammo="Staunch Tathlum +1",
		head={ name="Taeon Chapeau", augments={'Spell interruption rate down -10%','Phalanx +3',}},
		body={ name="Taeon Tabard", augments={'Spell interruption rate down -10%','Phalanx +3',}},
		hands={ name="Taeon Gloves", augments={'Spell interruption rate down -10%','Phalanx +3',}},
		legs={ name="Taeon Tights", augments={'Spell interruption rate down -10%','Phalanx +3',}},
		feet={ name="Taeon Boots", augments={'Spell interruption rate down -10%','Phalanx +3',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Embla Sash",
		left_ear="Magnetic Earring",
		right_ear={ name="Leth. Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','"Dbl.Atk."+6','STR+7 DEX+7',}},
		left_ring="Murky Ring",
		right_ring="Freke Ring",
		back={ name="Ghostfyre Cape", augments={'Enfb.mag. skill +1','Enha.mag. skill +10','Mag. Acc.+2','Enh. Mag. eff. dur. +19',}},}
		
	sets.Self_Phalanx = sets.midcast['Phalanx']
	sets.Self_Phalanx.DW = sets.midcast['Phalanx']

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Enfeebling Spells ----------------------------------------
    ------------------------------------------------------------------------------------------------

	 --MND Potency + Effect Based Enfeebling Slow,Paralyze,Addle,Gravity,Blind
	sets.midcast['Enfeebling Magic'] = {
		main="Daybreak",
		sub="Ammurapi Shield",
		ammo="Regal Gem",
		head={ name="Viti. Chapeau +4", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Lethargy Sayon +3",
		hands="Leth. Ganth. +3",
		legs="Leth. Fuseau +3",
		feet={ name="Viti. Boots +4", augments={'Immunobreak Chance',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Luminary Sash",
		left_ear="Regal Earring",
		right_ear="Snotra Earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Enmity-10','Phys. dmg. taken-10%',}},}
		
	sets.midcast.Inundation = sets.midcast['Enfeebling Magic']

	sets.midcast.Slow = sets.midcast['Enfeebling Magic']
	sets.midcast.Slow.Resistant = sets.midcast['Enfeebling Magic'].Resistant
	sets.midcast.Paralyze = sets.midcast['Enfeebling Magic']
	sets.midcast.Paralyze.Resistant = sets.midcast['Enfeebling Magic'].Resistant
	sets.midcast.Addle = sets.midcast['Enfeebling Magic']	
	sets.midcast.Addle.Resistant = sets.midcast['Enfeebling Magic'].Resistant
	sets.midcast.Gravity = sets.midcast['Enfeebling Magic']
	sets.midcast.Gravity.Resistant = sets.midcast['Enfeebling Magic'].Resistant
	sets.midcast.Blind = sets.midcast['Enfeebling Magic']
	sets.midcast.Blind.Resistant = sets.midcast['Enfeebling Magic'].Resistant
	
	sets.midcast.Slow.DW = {main="Daybreak",sub="Bunzi's Rod"}
	sets.midcast.Paralyze.DW = {main="Daybreak",sub="Bunzi's Rod"}
	sets.midcast.Addle.DW = {main="Daybreak",sub="Bunzi's Rod"}		
	sets.midcast.Gravity.DW = {main="Bunzi's Rod",sub="Maxentius"}
	sets.midcast.Blind.DW = {main="Bunzi's Rod",sub="Maxentius"}

	--Accuracy Based Enfeebling Frazzle 2, Dispel,		
	sets.midcast['Enfeebling Magic'].Resistant = {
		main="Crocea Mors",
		sub="Ammurapi Shield",
		ammo="Regal Gem",
		head="Atro. Chapeau +4",
		body="Atrophy Tabard +4",
		hands="Leth. Ganth. +3",
		legs="Atro. Tights +4",
		feet={ name="Viti. Boots +4", augments={'Immunobreak Chance',}},
		neck="Null Loop",
		waist={ name="Obstin. Sash", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Snotra Earring",
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back="Null Shawl",}

	sets.midcast['Frazzle II'] = sets.midcast['Enfeebling Magic'].Resistant			
	sets.midcast.Dispel = set_combine(sets.midcast['Enfeebling Magic'].Resistant, {neck={ name="Dls. Torque +2", augments={'Path: A',}},})
	sets.midcast.Dispel.DW = {main="Bunzi's Rod",sub="Maxentius"}
	sets.midcast.Dispelga = set_combine(sets.midcast['Enfeebling Magic'].Resistant, {main="Daybreak",sub="Ammurapi Shield", neck={ name="Dls. Torque +2", augments={'Path: A',}},})
	sets.midcast.Dispelga.DW = {main="Daybreak",sub="Bunzi's Rod"}
		
	--Enfeebling Skill based spells Poison, Frazzle 3 (625 Skill Cap), Distract 1-3 (610 Skill Cap),
	sets.midcast['Enfeebling Magic'].Skill	= {
		main={ name="Crocea Mors", augments={'Path: C',}},
		sub="Ammurapi Shield",
		ammo="Regal Gem",
		head={ name="Viti. Chapeau +4", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Lethargy Sayon +3",
		hands="Leth. Ganth. +3",
		legs="Atro. Tights +4",
		feet={ name="Viti. Boots +4", augments={'Immunobreak Chance',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist={ name="Obstin. Sash", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Snotra Earring",
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Enmity-10','Phys. dmg. taken-10%',}},}
		
	sets.midcast.Poison = sets.midcast['Enfeebling Magic'].Skill
	sets.midcast.Poison.Resistant = sets.midcast['Enfeebling Magic'].Resistant
	sets.midcast.Frazzle = sets.midcast['Enfeebling Magic'].Skill
	
	sets.midcast.Distract = sets.midcast['Enfeebling Magic'].Skill		
	sets.midcast.Distract.Resistant = sets.midcast['Enfeebling Magic'].Resistant
	
	sets.midcast.Poison.DW = {main="Bunzi's Rod",sub="Maxentius"}
	sets.midcast.Frazzle.DW = {main="Bunzi's Rod",sub="Daybreak"}
	sets.midcast.Distract.DW = {main="Bunzi's Rod",sub="Daybreak"}
		
	--Enfeebling Duration for spells that need to last long Sleeps,Break,Bind,Silence
	sets.midcast['Enfeebling Magic'].Duration = {
		main={ name="Crocea Mors", augments={'Path: C',}},
		sub="Ammurapi Shield",
		ammo="Regal Gem",
		head={ name="Viti. Chapeau +4", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Lethargy Sayon +3",
		hands="Regal Cuffs",
		legs="Leth. Fuseau +3",
		feet="Leth. Houseaux +3",
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist={ name="Obstin. Sash", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Snotra Earring",
		left_ring="Kishar Ring",
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Enmity-10','Phys. dmg. taken-10%',}},}
		
	sets.midcast.Sleep = sets.midcast['Enfeebling Magic'].Duration
	sets.midcast.Sleep.Resistant = sets.midcast['Enfeebling Magic'].Resistant
	sets.midcast.Break = sets.midcast['Enfeebling Magic'].Duration
	sets.midcast.Break.Resistant = sets.midcast['Enfeebling Magic'].Resistant
	sets.midcast.Bind = sets.midcast['Enfeebling Magic'].Duration
	sets.midcast.Bind.Resistant = sets.midcast['Enfeebling Magic'].Resistant
	sets.midcast.Silence = sets.midcast['Enfeebling Magic'].Duration
	sets.midcast.Silence.Resistant = sets.midcast['Enfeebling Magic'].Resistant

	sets.midcast.Sleep.DW = {main="Bunzi's Rod",sub="Maxentius"}
	sets.midcast.Break.DW = {main="Bunzi's Rod",sub="Maxentius"}
	sets.midcast.Bind.DW = {main="Bunzi's Rod",sub="Maxentius"}
	sets.midcast.Silence.DW = {main="Bunzi's Rod",sub="Maxentius"}
		
    ------------------------------------------------------------------------------------------------
    ------------------------------------- Elemental Spells -----------------------------------------
    ------------------------------------------------------------------------------------------------
	
	--After Bunzi's is augmented it will probably win on low-tier nukes.
	sets.midcast['Elemental Magic'] = {
		main={ name="Bunzi's Rod", augments={'Path: A',}},
		sub="Ammurapi Shield",
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head="Leth. Chappel +3",
		body="Lethargy Sayon +3",
		hands="Leth. Ganth. +3",
		legs="Leth. Fuseau +3",
		feet={ name="Viti. Boots +4", augments={'Immunobreak Chance',}},
		neck="Sibyl Scarf",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Freke Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Aurist's Cape +1", augments={'Path: A',}},}
		
    sets.midcast['Elemental Magic'].Resistant = {
		main={ name="Bunzi's Rod", augments={'Path: A',}},
		sub="Ammurapi Shield",
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head="Leth. Chappel +3",
		body="Lethargy Sayon +3",
		hands="Leth. Ganth. +3",
		legs="Leth. Fuseau +3",
		feet={ name="Viti. Boots +4", augments={'Immunobreak Chance',}},
		neck="Sibyl Scarf",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Freke Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Aurist's Cape +1", augments={'Path: A',}},}
		
	sets.midcast['Elemental Magic'].Low_MagicBurst = {
		main={ name="Bunzi's Rod", augments={'Path: A',}},
		sub="Ammurapi Shield",
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head="Ea Hat +1",
		body="Ea Houppe. +1",
		hands={ name="Bunzi's Gloves", augments={'Path: A',}},
		legs="Leth. Fuseau +3",
		feet={ name="Viti. Boots +4", augments={'Immunobreak Chance',}},
		neck="Sibyl Scarf",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Freke Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Aurist's Cape +1", augments={'Path: A',}},}
	
	sets.midcast['Elemental Magic'].High_MagicBurst = {
		main={ name="Bunzi's Rod", augments={'Path: A',}},
		sub="Ammurapi Shield",
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head="Ea Hat +1",
		body="Ea Houppe. +1",
		hands={ name="Bunzi's Gloves", augments={'Path: A',}},
		legs="Ea Slops +1",
		feet={ name="Viti. Boots +4", augments={'Immunobreak Chance',}},
		neck="Sibyl Scarf",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Freke Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Aurist's Cape +1", augments={'Path: A',}},}
		
	sets.midcast['Elemental Magic'].Occult_Accumen = {
		main={ name="Crocea Mors", augments={'Path: C',}},
		sub="Ammurapi Shield",
		ammo="Aurgelmir Orb +1",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands={ name="Merlinic Dastanas", augments={'Mag. Acc.+30','"Occult Acumen"+11','"Mag.Atk.Bns."+10',}},
		legs="Perdition Slops",
		feet={ name="Merlinic Crackows", augments={'"Occult Acumen"+11','Mag. Acc.+13',}},
		neck="Anu Torque",
		waist="Oneiros Rope",
		left_ear="Sherida Earring",
		right_ear="Dedition Earring",
		left_ring={ name="Chirich Ring +1", bag="wardrobe7" },
		right_ring={ name="Chirich Ring +1", bag="wardrobe8" },
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

	sets.midcast['Elemental Magic'].Weapon_Lock_High_MagicBurst = set_combine(sets.midcast['Elemental Magic'].High_MagicBurst, {neck="Mizu. Kubikazari",})
	sets.midcast['Elemental Magic'].DW = {main="Bunzi's Rod",sub="Daybreak"}
	
	sets.midcast.Impact = {
		main={ name="Murgleis", augments={'Path: A',}},
		sub="Ammurapi Shield",
		ammo="Regal Gem",
		head=empty,
		body="Crepuscular Cloak",
		hands="Leth. Ganth. +3",
		legs="Leth. Fuseau +3",
		feet="Leth. Houseaux +3",
		neck="Dls. Torque +2",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Snotra Earring",
		right_ear="Malignance Earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back={ name="Aurist's Cape +1", augments={'Path: A',}},}
		
	sets.midcast.Impact.Magic_Burst = {
		main="Bunzi's Rod",
		sub="Ammurapi Shield",
		ammo="Ghastly Tathlum +1",
		body="Crepuscular Cloak",
		hands="Bunzi's Gloves",
		legs="Leth. Fuseau +3",
		feet="Viti. Boots +4",
		neck="Mizu. Kubikazari",
		waist="Acuity Belt +1",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Archon Ring",
		right_ring="Freke Ring",
		back="Aurist's Cape +1",}
		
	sets.midcast.Impact.Occult_Accumen = {
		main={ name="Crocea Mors", augments={'Path: C',}},
		sub="Ammurapi Shield",
		ammo="Aurgelmir Orb +1",
		body="Crepuscular Cloak",
		hands={ name="Merlinic Dastanas", augments={'Mag. Acc.+30','"Occult Acumen"+11','"Mag.Atk.Bns."+10',}},
		legs="Perdition Slops",
		feet={ name="Merlinic Crackows", augments={'"Occult Acumen"+11','Mag. Acc.+13',}},
		neck="Anu Torque",
		waist="Oneiros Rope",
		left_ear="Sherida Earring",
		right_ear="Dedition Earring",
		left_ring={ name="Chirich Ring +1", bag="wardrobe7" },
		right_ring={ name="Chirich Ring +1", bag="wardrobe8" },
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Dark Magic Spells ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast['Dark Magic'] = {
		main={ name="Crocea Mors", augments={'Path: C',}},
		sub="Ammurapi Shield",
		ammo="Regal Gem",
		head="Atro. Chapeau +4",
		body="Atrophy Tabard +4",
		hands="Atro. Gloves +4",
		legs="Atro. Tights +4",
		feet="Leth. Houseaux +3",
		neck="Null Loop",
		waist="Null Belt",
		left_ear="Regal Earring",
		right_ear={ name="Leth. Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','"Dbl.Atk."+6','STR+7 DEX+7',}},
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back="Null Shawl",}
		
	sets.midcast.Stun = set_combine(sets.midcast['Dark Magic'], {body={ name="Viti. Tabard +4", augments={'Enhances "Chainspell" effect',}},left_ear="Malignance Earring",})

    sets.midcast.Drain = {
		main={ name="Bunzi's Rod", augments={'Path: A',}},
		sub="Ammurapi Shield",
		ammo="Regal Gem",
		head="Atro. Chapeau +4",
		body="Atrophy Tabard +4",
		hands="Leth. Ganth. +3",
		legs="Leth. Fuseau +3",
		feet="Leth. Houseaux +3",
		neck="Erra Pendant",
		waist="Fucho-no-Obi",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Evanescence Ring",
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back="Null Shawl",}

	sets.midcast.Aspir = sets.midcast.Drain
	
	sets.midcast['Absorb-TP'] = {
		main={ name="Crocea Mors", augments={'Path: C',}},
		sub="Ammurapi Shield",
		ammo="Regal Gem",
		head="Atrophy Chapeau +4",
		body={ name="Viti. Tabard +4", augments={'Enhances "Chainspell" effect',}},
		hands="Leth. Ganth. +3",
		legs="Leth. Fuseau +3",
		feet="Leth. Houseaux +3",
		neck="Null Loop",
		waist="Null Belt",
		left_ear="Malignance Earring",
		right_ear={ name="Leth. Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','"Dbl.Atk."+6','STR+7 DEX+7',}},
		left_ring="Kishar Ring",
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back="Null Shawl",}
	
    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.idle = {
		main="Daybreak",
		sub="Genmei Shield",
		ammo="Staunch Tathlum +1",
		head={ name="Viti. Chapeau +4", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Lethargy Sayon +3",
		hands="Sworn Gauntlets",
		legs="Sworn Brais",
		feet="Sworn Sabatons",
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Flume Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Genmei Earring",
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back="Null Shawl",}
		
    sets.idle.Aminon = {
		main="Daybreak",
		sub="Genmei Shield",
		ammo="Staunch Tathlum +1",
		head="Null Masque",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Sibyl Scarf",
		waist="Flume Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Dedition Earring",
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
    sets.resting = sets.idle
		
	sets.idle.rollers = set_combine(sets.idle, {right_ring="Roller's Ring",})
	sets.idle.Aminon.rollers = set_combine(sets.idle.Aminon, {right_ring="Roller's Ring",})
	
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
	
	------------------------------------------------------------------------------------------------
	-----------------------------------------Single Wield Sets--------------------------------------
	------------------------------------------------------------------------------------------------

    sets.engaged = {
		main="Naegling",
		sub="Genmei Shield",
		ammo="Aurgelmir Orb +1",
		head={ name="Bunzi's Hat", augments={'Path: A',}},
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
		neck="Anu Torque",
		waist="Windbuffet Belt +1",
		left_ear="Sherida Earring",
		right_ear="Dedition Earring",
		left_ring={ name="Chirich Ring +1", bag="wardrobe7" },
		right_ring={ name="Chirich Ring +1", bag="wardrobe8" },
		back="Null Shawl",}

    sets.engaged.Enspell = set_combine(sets.engaged,{
		hands="Aya. Manopolas +2",
		waist="Orpheus's Sash",
		back={ name="Ghostfyre Cape", augments={'Enfb.mag. skill +1','Enha.mag. skill +10','Mag. Acc.+2','Enh. Mag. eff. dur. +19',}},})

	----------------------------------------Full DT Sets---------------------------------------------

    sets.engaged.DT =  {
		main="Naegling",
		sub="Genmei Shield",
		ammo="Aurgelmir Orb +1",
		head={ name="Bunzi's Hat", augments={'Path: A',}},
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist="Windbuffet Belt +1",
		left_ear="Sherida Earring",
		right_ear="Dedition Earring",
		left_ring={ name="Chirich Ring +1", bag="wardrobe7" },
		right_ring={ name="Chirich Ring +1", bag="wardrobe8" },
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
    sets.engaged.Enspell.DT = set_combine(sets.engaged.DT, {waist="Orpheus's Sash",})

	-----------------------------------------Full DEFENSE Sets--------------------------------------
	
	sets.engaged.Defense = {
	    main="Naegling",
		sub="Genmei Shield",
		ammo="Aurgelmir Orb +1",
		head={ name="Bunzi's Hat", augments={'Path: A',}},
		body="Malignance Tabard",
		hands={ name="Bunzi's Gloves", augments={'Path: A',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Anu Torque",
		waist="Windbuffet Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Dedition Earring",
		left_ring={ name="Chirich Ring +1", bag="wardrobe7" },
		right_ring="Petrov Ring",
		back="Null Shawl",}
		
    sets.engaged.Enspell.Defense = set_combine(sets.engaged.Defense, {waist="Orpheus's Sash",})
	
	------------------------------------------------------------------------------------------------		
	-----------------------------------------No DT Shield Sets--------------------------------------
	------------------------------------------------------------------------------------------------
	
	sets.engaged.No_DT_Shield = {
		ammo="Aurgelmir Orb +1",
		head={ name="Bunzi's Hat", augments={'Path: A',}},
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
		neck="Anu Torque",
		waist="Windbuffet Belt +1",
		left_ear="Sherida Earring",
		right_ear="Dedition Earring",
		left_ring={ name="Chirich Ring +1", bag="wardrobe7" },
		right_ring={ name="Chirich Ring +1", bag="wardrobe8" },
		back="Null Shawl",}
	
	sets.engaged.No_DT_Shield.Enspell = set_combine(sets.engaged.No_DT_Shield, {
		hands="Aya. Manopolas +2",
		waist="Orpheus's Sash",
		back={ name="Ghostfyre Cape", augments={'Enfb.mag. skill +1','Enha.mag. skill +10','Mag. Acc.+2','Enh. Mag. eff. dur. +19',}},})
	
	----------------------------------------Full DT Sets---------------------------------------------
	
	sets.engaged.No_DT_Shield.DT = {
	    ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Bunzi's Hat", augments={'Path: A',}},
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist="Windbuffet Belt +1",
		left_ear="Sherida Earring",
		right_ear="Dedition Earring",
		left_ring="Murky Ring",
		right_ring="Petrov Ring",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
	
	sets.engaged.No_DT_Shield.Enspell.DT = set_combine(sets.engaged.No_DT_Shield.Defense, {waist="Orpheus's Sash",})
	
	-----------------------------------------Full DEFENSE Sets--------------------------------------
	
	sets.engaged.No_DT_Shield.Defense = {
	    ammo="Aurgelmir Orb +1",
		head={ name="Bunzi's Hat", augments={'Path: A',}},
		body="Malignance Tabard",
		hands={ name="Bunzi's Gloves", augments={'Path: A',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Anu Torque",
		waist="Windbuffet Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Dedition Earring",
		left_ring="Murky Ring",
		right_ring={ name="Chirich Ring +1", bag="wardrobe8" },
		back="Null Shawl",}
	
	sets.engaged.No_DT_Shield.Enspell.Defense = set_combine(sets.engaged.No_DT_Shield.Defense, {waist="Orpheus's Sash",})
	
	------------------------------------------------------------------------------------------------
	----------------------------------------Dual Wield Sets ----------------------------------------
	------------------------------------------------------------------------------------------------
	
    sets.engaged.DW = {
		main="Naegling",
		sub={ name="Machaera +2", augments={'TP Bonus +1000',}},
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Bunzi's Hat", augments={'Path: A',}},
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
		neck="Anu Torque",
		waist="Reiki Yotai",
		left_ear="Sherida Earring",
		right_ear="Eabani Earring",
		left_ring={ name="Chirich Ring +1", bag="wardrobe7" },
		right_ring={ name="Chirich Ring +1", bag="wardrobe8" },
		back="Null Shawl",}

    sets.engaged.DW.Enspell = set_combine(sets.engaged.DW,{
		ammo="Sroda Tathlum",
		hands="Aya. Manopolas +2",
		neck="Null Loop",
		waist="Orpheus's Sash",
		left_ear="Eabani Earring",
		right_ear="Suppanomimi",
		back={ name="Ghostfyre Cape", augments={'Enfb.mag. skill +1','Enha.mag. skill +10','Mag. Acc.+2','Enh. Mag. eff. dur. +19',}},})
		
	----------------------------------------Full DT Sets---------------------------------------------

    sets.engaged.DW.DT = {
	    main="Naegling",
		sub={ name="Machaera +2", augments={'TP Bonus +1000',}},
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Bunzi's Hat", augments={'Path: A',}},
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist="Windbuffet Belt +1",
		left_ear="Sherida Earring",
		right_ear="Dedition Earring",
		left_ring="Murky Ring",
		right_ring={ name="Chirich Ring +1", bag="wardrobe8" },
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','"Dual Wield"+10',}},}
	
    sets.engaged.DW.Enspell.DT = set_combine(sets.engaged.DW.DT, {
		ammo="Sroda Tathlum",
		hands="Aya. Manopolas +2",
		neck="Null Loop",
		waist="Orpheus's Sash",
		left_ear="Eabani Earring",
		right_ear="Suppanomimi",
		back={ name="Ghostfyre Cape", augments={'Enfb.mag. skill +1','Enha.mag. skill +10','Mag. Acc.+2','Enh. Mag. eff. dur. +19',}},})
		
	-----------------------------------------Full DEFENSE Sets--------------------------------------
	
    sets.engaged.DW.Defense = {
	    main="Naegling",
		sub={ name="Machaera +2", augments={'TP Bonus +1000',}},
		ammo="Aurgelmir Orb +1",
		head={ name="Bunzi's Hat", augments={'Path: A',}},
		body="Malignance Tabard",
		hands={ name="Bunzi's Gloves", augments={'Path: A',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Anu Torque",
		waist="Reiki Yotai",
		left_ear="Eabani Earring",
		right_ear="Alabaster Earring",
		left_ring="Murky Ring",
		right_ring="Petrov Ring",
		back="Null Shawl",}

    sets.engaged.DW.Enspell.Defense = set_combine(sets.engaged.DW.Defense, {
		waist="Orpheus's Sash",})		

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	sets.buff.Saboteur = {hands="Leth. Ganth. +3"}

	sets.Kiting = {left_ring="Shneddick Ring",}
	
	sets.latent_refresh = {waist="Fucho-no-obi"}
	
    sets.buff.Sublimation = {waist="Embla Sash"}

	sets.TreasureHunter = {
		body="Volte Jupon",
		hands="Volte Bracers",
		waist="Chaac Belt",}
		
	sets.midcast['Bio III'] = set_combine(sets.midcast['Enfeebling Magic'], sets.TreasureHunter)
	sets.midcast['Dia III'] = set_combine(sets.midcast['Enfeebling Magic'], sets.TreasureHunter)
	sets.midcast.Dia = set_combine(sets.midcast['Enfeebling Magic'], sets.TreasureHunter)
	sets.midcast.Diaga = set_combine(sets.midcast['Enfeebling Magic'], sets.TreasureHunter)
	sets.midcast.Bio = set_combine(sets.midcast['Enfeebling Magic'], sets.TreasureHunter)

    sets.buff.Doom = set_combine(sets.buff.Doom, {
		neck="Nicander's Necklace",
		waist="Gishdubar Sash", --10
        })

    sets.Obi = {waist="Hachirin-no-Obi"}
	
	--Weapon Sets

	sets.weapons.Naegling = {main="Naegling",}
	sets.weapons.Crocea_Mors = {main={ name="Crocea Mors", augments={'Path: C',}},}
	sets.weapons.Onion = {main="Onion Sword III",}
	sets.weapons.Excalibur = {main={ name="Excalibur", augments={'Path: A',}},}
	sets.weapons.Murgleis = {main={ name="Murgleis", augments={'Path: A',}},}
	sets.weapons.Mpu_Gandring = {main="Mpu Gandring",}
	sets.weapons.Tauret = {main="Tauret",}
	sets.weapons.Maxentius = {main="Maxentius",}
	
	sets.Thibron = {sub={ name="Machaera +2", augments={'TP Bonus +1000',}},}
	sets.Gletis_Knife = {sub={ name="Gleti\'s Knife", augments={'Path: A',}},}
	sets.Crepuscular = {sub="Crepuscular Knife",}
	sets.Daybreak = {sub="Daybreak",}
	
	sets.Genmei = {sub="Genmei Shield",}
	sets.Ammurapi = {sub="Ammurapi Shield",}
	sets.Archduke = {sub="Archduke's Shield",}	
	
	--Range Sets
	
	sets.Empyreal = {range="Ullr", ammo="Chapuli Arrow"}
		
end

-- Default macro set/book
function select_default_macro_book()
	set_macro_page(1, 5)
end

function user_job_lockstyle()
    send_command('input /lockstyleset ' .. lockstyleset)
end