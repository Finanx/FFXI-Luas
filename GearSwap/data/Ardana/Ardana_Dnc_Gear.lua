-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_job_setup()
    state.OffenseMode:options('Normal', 'Acc')
    state.HybridMode:options('Normal', 'DT', 'Defense')
    state.WeaponskillMode:options('Normal', 'ATKCAP')
	state.IdleMode:options('Normal', 'Aminon')
	state.Weapons:options('Mpu_Gandring', 'Terpsichore', 'Twashtar', 'Mandau', 'Tauret', 'Onion', 'Karambit')
	state.Subweapon = M{['description']='Sub Weapon Set', 'Centovente', 'Crepuscular', 'Gletis_Knife'}
	
	DisableSub = {
		Karambit = true,
	}
	
    state.step = M{['description']='step', 'Quickstep', 'Stutter Step', 'Feather Step'}
	
	init_job_states({},{"Weapons","Subweapon","OffenseMode","WeaponskillMode","IdleMode","TreasureMode",})

	--Includes Global Bind keys
	
	send_command('wait 2; exec Global-Binds.txt')

	--Dancer Binds
	
	send_command('wait 2; exec /DNC/Binds.txt')
	
	--Retrieve Gear for Dancer
	
	send_command('wait 3;org get inventory dnc.lua')
	
	--Job Settings

	lockstyleset = 17
    select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
	enable('main','sub','range','ammo','head','body','hands','legs','feet','neck','waist','left_ear','right_ear','left_ring','right_ring','back')

	--Remove Global Binds

	send_command('wait 1; exec Global-UnBinds.txt')
	
	--Remove Gear for Dancer
	
	send_command('wait 1; org get Store.lua')
	
end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
 
	sets.Enmity = {
		ammo="Sapience Orb",
		head="Halitus Helm",
		body={ name="Emet Harness +1", augments={'Path: A',}},
		hands="Kurys Gloves",
		legs={ name="Zoar Subligar +1", augments={'Path: A',}},
		feet="Macu. Toe Sh. +3",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Kasiri Belt",
		left_ear="Cryptic Earring",
		right_ear="Trux Earring",
		left_ring="Eihwaz Ring",
		right_ring="Supershear Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
 
    -- Precast sets to enhance JAs
	
    sets.precast.JA.Provoke = sets.Enmity

    sets.precast.JA['Saber Dance'] = {legs={ name="Horos Tights +4", augments={'Enhances "Saber Dance" effect',}},}
    sets.precast.JA['No Foot Rise'] = {body={ name="Horos Casaque +4", augments={'Enhances "No Foot Rise" effect',}},}
	sets.precast.JA['Trance'] = {head={ name="Horos Tiara +3", augments={'Enhances "Trance" effect',}},}
    

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
		ammo="Yamarang",
		head={ name="Anwig Salade", augments={'CHR+4','"Waltz" ability delay -2','CHR+2','"Fast Cast"+2',}},
		body="Maxixi Casaque +4",
		hands={ name="Horos Bangles +4", augments={'Enhances "Fan Dance" effect',}},
		legs="Dashing Subligar",
		feet="Maxixi Toe Shoes +3",
		neck={ name="Etoile Gorget +2", augments={'Path: A',}},
		waist="Chaac Belt",
		left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		right_ear="Tuisto Earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Defending Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
	sets.Self_Waltz = sets.precast.Waltz

    sets.precast.Waltz['Healing Waltz'] = {legs="Dashing Subligar",}
    
    sets.precast.Samba = {head="Maxixi Tiara +3",back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}

    sets.precast.Jig = {legs={ name="Horos Tights +4", augments={'Enhances "Saber Dance" effect',}}}

    sets.precast.Step = {
		ammo="Yamarang",
		head="Maxixi Tiara +3",
		body="Maxixi Casaque +4",
		hands="Maxixi Bangles +4",
		legs={ name="Horos Tights +4", augments={'Enhances "Saber Dance" effect',}},
		feet={ name="Horos Toe Sh. +4", augments={'Enhances "Closed Position" effect',}},
		neck={ name="Etoile Gorget +2", augments={'Path: A',}},
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear="Odr Earring",
		right_ear={ name="Macu. Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+19','Mag. Acc.+19','"Store TP"+7','DEX+13 AGI+13',}},
		left_ring="Ephramad's Ring",
		right_ring="Regal Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}

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

    sets.precast.Flourish2 = {}
    sets.precast.Flourish2['Reverse Flourish'] = set_combine(sets.idle, {hands="Macu. Bangles +3",back={ name="Toetapper Mantle", augments={'"Store TP"+1','"Dual Wield"+2','"Rev. Flourish"+30',}},})

    sets.precast.Flourish3 = {}
    sets.precast.Flourish3['Striking Flourish'] = {} --body="Charis Casaque +2"
    sets.precast.Flourish3['Climactic Flourish'] = {}
	
	sets.precast.JA['Jump'] = {
		ammo="Coiste Bodhar",
		head="Maculele Tiara +3",
		body="Malignance Tabard",
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs="Gleti's Breeches",
		feet="Macu. Toe Sh. +3",
		neck={ name="Etoile Gorget +2", augments={'Path: A',}},
		waist="Windbuffet Belt +1",
		left_ear="Sherida Earring",
		right_ear="Dedition Earring",
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back="Null Shawl",}
		
	sets.precast.JA['High Jump'] = sets.precast.JA['Jump']

    -- Fast cast sets for spells
    
    sets.precast.FC = {
		ammo="Sapience Orb",
		head={ name="Herculean Helm", augments={'"Mag.Atk.Bns."+6','"Fast Cast"+6','MND+3','Mag. Acc.+4',}},
		body={ name="Adhemar Jacket +1", augments={'HP+105','"Fast Cast"+10','Magic dmg. taken -4',}},
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
		feet={ name="Herculean Boots", augments={'Mag. Acc.+17','"Fast Cast"+6','VIT+6',}},
		neck="Baetyl Pendant",
		waist="Plat. Mog. Belt",
		left_ear="Etiolation Earring",
		right_ear="Loquac. Earring",
		left_ring="Prolix Ring",
		right_ring="Defending Ring",
		back="Null Shawl",}

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {})
	
    sets.precast.RA = {
		range="Trollbane",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body="Volte Harness",
		hands="Macu. Bangles +3",
		legs={ name="Adhemar Kecks +1", augments={'AGI+12','"Rapid Shot"+13','Enmity-6',}},
		feet="Meg. Jam. +2",
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Flume Belt +1",
		left_ear="Genmei Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring="Crepuscular Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
	
		--Set used for Icarus Wing to maximize TP gain	
	sets.precast.Wing = {
		ammo="Aurgelmir Orb +1",
		head="Maculele Tiara +3",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Macu. Toe Sh. +3",
		neck={ name="Etoile Gorget +2", augments={'Path: A',}},
		waist="Gerdr Belt +1",
		left_ear="Dedition Earring",
		right_ear={ name="Macu. Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+19','Mag. Acc.+19','"Store TP"+7','DEX+13 AGI+13',}},
		left_ring={ name="Chirich Ring +1", bag="wardrobe7" },
		right_ring={ name="Chirich Ring +1", bag="wardrobe8" },
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
	sets.precast.Volte_Harness = set_combine(sets.precast.Wing, {body="Volte Harness"})
	sets.precast.Prishes_Boots = set_combine(sets.precast.Wing, {feet="Prishe\'s Boots +1",})
       
    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Maculele Tiara +3",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Etoile Gorget +2", augments={'Path: A',}},
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear="Sherida Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Ephramad's Ring",
		right_ring="Regal Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
		
    sets.precast.WS.ATKCAP = {
		ammo="Crepuscular Pebble",
		head="Maculele Tiara +3",
		body={ name="Gleti's Cuirass", augments={'Path: A',}},
		hands={ name="Gleti's Gauntlets", augments={'Path: A',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Etoile Gorget +2", augments={'Path: A',}},
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear={ name="Macu. Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+19','Mag. Acc.+19','"Store TP"+7','DEX+13 AGI+13',}},
		left_ring="Ephramad's Ring",
		right_ring="Regal Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Rudra\'s Storm'] = {
		ammo="Coiste Bodhar",
		head="Maculele Tiara +3",
		body="Nyame Mail",
		hands="Maxixi Bangles +4",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck={ name="Etoile Gorget +2", augments={'Path: A',}},
		waist="Kentarch Belt +1",
		left_ear="Moonshade Earring",
		right_ear={ name="Macu. Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+19','Mag. Acc.+19','"Store TP"+7','DEX+13 AGI+13',}},
		left_ring="Regal Ring",
		right_ring="Ephramad's Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Rudra\'s Storm'].ATKCAP = {
		ammo="Crepuscular Pebble",
		head="Maculele Tiara +3",
		body="Nyame Mail",
		hands="Maxixi Bangles +4",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck={ name="Etoile Gorget +2", augments={'Path: A',}},
		waist="Kentarch Belt +1",
		left_ear="Moonshade Earring",
		right_ear={ name="Macu. Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+19','Mag. Acc.+19','"Store TP"+7','DEX+13 AGI+13',}},
		left_ring="Epaminondas's Ring",
		right_ring="Ephramad's Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Ruthless Stroke'] = {
		ammo="Coiste Bodhar",
		head="Maculele Tiara +3",
		body="Nyame Mail",
		hands="Maxixi Bangles +4",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck={ name="Etoile Gorget +2", augments={'Path: A',}},
		waist="Sailfi Belt +1",
		left_ear="Moonshade Earring",
		right_ear={ name="Macu. Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+19','Mag. Acc.+19','"Store TP"+7','DEX+13 AGI+13',}},
		left_ring="Regal Ring",
		right_ring="Ephramad's Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Ruthless Stroke'].ATKCAP = {
		ammo="Crepuscular Pebble",
		head="Maculele Tiara +3",
		body="Nyame Mail",
		hands="Maxixi Bangles +4",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck={ name="Etoile Gorget +2", augments={'Path: A',}},
		waist="Kentarch Belt +1",
		left_ear="Moonshade Earring",
		right_ear={ name="Macu. Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+19','Mag. Acc.+19','"Store TP"+7','DEX+13 AGI+13',}},
		left_ring="Epaminondas's Ring",
		right_ring="Ephramad's Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
	
	sets.precast.WS['Pyrrhic Kleos'] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Maculele Tiara +3",
		body="Macu. Casaque +3",
		hands="Macu. Bangles +3",
		legs={ name="Gleti's Breeches", augments={'Path: A',}},
		feet="Macu. Toe Sh. +3",
		neck={ name="Etoile Gorget +2", augments={'Path: A',}},
		waist="Fotia Belt",
		left_ear="Sherida Earring",
		right_ear={ name="Macu. Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+19','Mag. Acc.+19','"Store TP"+7','DEX+13 AGI+13',}},
		left_ring="Ephramad's Ring",
		right_ring="Regal Ring",
		back={ name="Senuna's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Pyrrhic Kleos'].ATKCAP = {
	    ammo="Crepuscular Pebble",
		head="Maculele Tiara +3",
		body={ name="Gleti's Cuirass", augments={'Path: A',}},
		hands="Macu. Bangles +3",
		legs={ name="Gleti's Breeches", augments={'Path: A',}},
		feet="Macu. Toe Sh. +3",
		neck={ name="Etoile Gorget +2", augments={'Path: A',}},
		waist="Fotia Belt",
		left_ear="Sherida Earring",
		right_ear={ name="Macu. Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+19','Mag. Acc.+19','"Store TP"+7','DEX+13 AGI+13',}},
		left_ring="Ephramad's Ring",
		right_ring="Regal Ring",
		back={ name="Senuna's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

    sets.precast.WS['Evisceration'] = {
	    ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body={ name="Gleti's Cuirass", augments={'Path: A',}},
		hands={ name="Gleti's Gauntlets", augments={'Path: A',}},
		legs={ name="Gleti's Breeches", augments={'Path: A',}},
		feet="Macu. Toe Sh. +3",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Odr Earring",
		right_ear={ name="Macu. Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+19','Mag. Acc.+19','"Store TP"+7','DEX+13 AGI+13',}},
		left_ring="Ephramad's Ring",
		right_ring="Regal Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}},}
	
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
		left_ring="Epaminondas's Ring",
		right_ring="Shiva Ring +1",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Asuran Fists'] = {
		ammo="Aurgelmir Orb +1",
		head="Maculele Tiara +3",
		body="Macu. Casaque +3",
		hands="Macu. Bangles +3",
		legs="Maculele Tights +3",
		feet="Macu. Toe Sh. +3",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Tuisto Earring",
		right_ear={ name="Macu. Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+19','Mag. Acc.+19','"Store TP"+7','DEX+13 AGI+13',}},
		left_ring="Sroda Ring",
		right_ring="Ephramad's Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
		

	-- Swap to these on Moonshade using WS if at 3000 TP
	sets.MaxTP = {ear1="Ishvara Earring",ear2="Sherida Earring"}
	sets.AccMaxTP = {ear1="Mache Earring +1",ear2="Sherida Earring"}
	
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
    
	sets.midcast.FastRecast = sets.precast.FC
        
    -- Specific spells
	sets.midcast.Utsusemi = sets.precast.FC.Utsusemi
    
    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------
 
    -- Resting sets
    sets.resting = {
		ammo="Staunch Tathlum +1",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Flume Belt +1",
		left_ear="Eabani Earring",
		right_ear="Sanare Earring",
		left_ring="Shneddick Ring",
		right_ring="Shadow Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}

    -- Idle sets

    sets.idle = {
		ammo="Staunch Tathlum +1",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Flume Belt +1",
		left_ear="Eabani Earring",
		right_ear="Sanare Earring",
		left_ring="Shneddick Ring",
		right_ring="Shadow Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
	sets.idle.Aminon = {
	    ammo="Staunch Tathlum +1",
		head="Turms Cap +1",
		body={ name="Gleti's Cuirass", augments={'Path: A',}},
		hands="Regal Gloves",
		legs={ name="Gleti's Breeches", augments={'Path: A',}},
		feet={ name="Gleti's Boots", augments={'Path: A',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Flume Belt +1",
		left_ear="Sanare Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Defending Ring",
		right_ring="Roller's Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
	sets.idle.rollers = set_combine(sets.idle, {right_ring="Roller's Ring",})
	sets.idle.Aminon.rollers = set_combine(sets.idle.Aminon, {right_ring="Roller's Ring",})
		
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged = {
		ammo="Coiste Bodhar",
		head="Maculele Tiara +3",
		body="Malignance Tabard",
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs="Gleti's Breeches",
		feet="Macu. Toe Sh. +3",
		neck={ name="Etoile Gorget +2", augments={'Path: A',}},
		waist="Windbuffet Belt +1",
		left_ear="Sherida Earring",
		right_ear="Dedition Earring",
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back="Null Shawl",} 

    sets.engaged.Acc = {
		ammo="Coiste Bodhar",
		head="Maculele Tiara +3",
		body="Malignance Tabard",
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs="Gleti's Breeches",
		feet="Macu. Toe Sh. +3",
		neck={ name="Etoile Gorget +2", augments={'Path: A',}},
		waist="Windbuffet Belt +1",
		left_ear="Sherida Earring",
		right_ear="Dedition Earring",
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back="Null Shawl",} 

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {
		ammo="Coiste Bodhar",
		head="Malignance Chapeau",
		body="Gleti's Cuirass",
		hands="Malignance Gloves",
		legs="Gleti's Breeches",
		feet="Macu. Toe Sh. +3",
		neck={ name="Etoile Gorget +2", augments={'Path: A',}},
		waist="Windbuffet Belt +1",
		left_ear="Sherida Earring",
		right_ear="Alabaster Earring",
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
	sets.engaged.Hybrid.Defense = {
		ammo="Coiste Bodhar",
		head="Malignance Chapeau",
		body="Gleti's Cuirass",
		hands="Gleti's Gauntlets",
		legs="Gleti's Breeches",
		feet="Macu. Toe Sh. +3",
		neck={ name="Etoile Gorget +2", augments={'Path: A',}},
		waist="Windbuffet Belt +1",
		left_ear="Sherida Earring",
		right_ear="Alabaster Earring",
		left_ring="Gere Ring",
		right_ring={ name="Moonlight Ring", bag="wardrobe8" },
		back="Null Shawl",}

    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
    sets.engaged.Acc.DT = set_combine(sets.engaged.Acc, sets.engaged.Hybrid)
	
    sets.engaged.Defense = set_combine(sets.engaged, sets.engaged.Hybrid.Defense)
    sets.engaged.Acc.Defense = set_combine(sets.engaged.Acc, sets.engaged.Hybrid.Defense)
	
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	sets.Kiting = {left_ring="Shneddick Ring",}
	sets.TreasureHunter = set_combine(sets.TreasureHunter, {
		body="Volte Jupon",
		ammo="Per. Lucky Egg",
		waist="Chaac Belt",})

    -- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
    --sets.buff['Climactic Flourish'] = {ammo="Charis Feather",head="Adhemar Bonnet +1",body="Meg. Cuirie +2"} --head="Charis Tiara +2"
	sets.buff.Doom = set_combine(sets.buff.Doom, {neck="Nicander's Necklace",waist="Gishdubar Sash",})
	sets.buff.Sleep = {head="Frenzy Sallet"}
	
	sets.weapons.Mpu_Gandring = {main="Mpu Gandring",}
	sets.weapons.Twashtar = {main="Twashtar",}
	sets.weapons.Terpsichore = {main="Terpsichore",}
	sets.weapons.Tauret = {main="Tauret",}
	sets.weapons.Onion = {main="Onion Sword III",}
	sets.weapons.Karambit = {main="Karambit"}
	
	sets.Centovente = {sub="Fusetto +2",}
	sets.Gletis_Knife = {sub={ name="Gleti\'s Knife", augments={'Path: A',}},}
	sets.Crepuscular = {sub="Crepuscular Knife",}

	
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()

        set_macro_page(1, 17)
end

function user_job_lockstyle()
    send_command('input /lockstyleset ' .. lockstyleset)
end