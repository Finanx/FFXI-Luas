-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_job_setup()
	-- Options: Override default values
	state.OffenseMode:options('Normal','Acc')
	state.HybridMode:options('Normal','DT')
	state.RangedMode:options('Normal', 'Acc')
	state.WeaponskillMode:options('Normal')
	state.IdleMode:options('Normal', 'Regain')
	state.Weapons:options('Mpu_Gandring', 'Twashtar', 'Mandau', 'Tauret', 'Naegling', 'Onion', 'Karambit')
	state.Subweapon = M{['description']='Sub Weapon Set', 'Centovente', 'Crepuscular', 'Gletis_Knife'}
	
	DisableSub = {
		Karambit = true,
	}
	
	state.ExtraMeleeMode = M{['description']='Extra Melee Mode','None','Suppa','DWMax','Parry'}
	state.AmbushMode = M(false, 'Ambush Mode')

	--Includes Global Bind keys
	
	send_command('wait 2; exec Global-Binds.txt')

	--Thief Binds
	
	send_command('wait 2; exec /THF/Binds.txt')
	
	--Retrieve Gear for Thief
	
	send_command('wait 3;org get inventory thf.lua')
	
	--Job Settings

	lockstyleset = 6
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

	sets.TreasureHunter = {
		feet="Skulk. Poulaines +2",
		waist="Chaac Belt",}
	
	sets.buff['Sneak Attack'] = {}
	sets.buff['Trick Attack'] = {}

	sets.precast.Step = {}
		
	sets.precast.JA['Violent Flourish'] = {}
		
	sets.precast.JA['Animated Flourish'] = set_combine(sets.TreasureHunter, {})
	sets.precast.JA.Provoke = set_combine(sets.TreasureHunter, {})

	--------------------------------------
	-- Precast sets
	--------------------------------------

	-- Precast sets to enhance JAs
	sets.precast.JA['Collaborator'] = {}
	sets.precast.JA['Accomplice'] = {}
	sets.precast.JA['Flee'] = {} 
	sets.precast.JA['Hide'] = {}
	sets.precast.JA['Conspirator'] = {} 
	sets.precast.JA['Steal'] = {ammo="Barathrum"}
	sets.precast.JA['Mug'] = {ammo="Barathrum"}
	sets.precast.JA['Despoil'] = {}
	sets.precast.JA['Perfect Dodge'] = {}
	sets.precast.JA['Feint'] = {} 

	sets.precast.JA['Sneak Attack'] = sets.buff['Sneak Attack']
	sets.precast.JA['Trick Attack'] = sets.buff['Trick Attack']

	-- Waltz set (chr and vit)
	sets.precast.Waltz = {}

	sets.Self_Waltz = {}
		
	-- Don't need any special gear for Healing Waltz.
	sets.precast.Waltz['Healing Waltz'] = {}


	-- Fast cast sets for spells
	sets.precast.FC = {}

	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads",body="Passion Jacket"})


	-- Ranged snapshot gear
	sets.precast.RA = {}


    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------
	
	sets.precast.WS = {
		ammo="Coiste Bodhar",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck={ name="Asn. Gorget +2", augments={'Path: A',}},
		waist="Sailfi Belt +1",
		left_ear="Moonshade Earring",
		right_ear={ name="Skulk. Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+17','Mag. Acc.+17','"Store TP"+6','DEX+9 AGI+9',}},
		left_ring="Regal Ring",
		right_ring="Ephramad's Ring",
		back="Null Shawl",}
		
	sets.precast.WS.Acc = set_combine(sets.precast.WS, {})

	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	sets.precast.WS["Rudra's Storm"] = set_combine(sets.precast.WS, {})
	sets.precast.WS["Rudra's Storm"].Acc = set_combine(sets.precast.WS.Acc, {})
	sets.precast.WS["Rudra's Storm"].SA = set_combine(sets.precast.WS["Rudra's Storm"], {})
	sets.precast.WS["Rudra's Storm"].TA = sets.precast.WS["Rudra's Storm"].SA
	sets.precast.WS["Rudra's Storm"].SATA = sets.precast.WS["Rudra's Storm"].SA
	
	sets.precast.WS["Evisceration"] = set_combine(sets.precast.WS, {})
	sets.precast.WS["Evisceration"].Acc = set_combine(sets.precast.WS.Acc, {})
	sets.precast.WS["Evisceration"].SA = set_combine(sets.precast.WS["Rudra's Storm"], {})
	sets.precast.WS["Evisceration"].TA = sets.precast.WS["Rudra's Storm"].SA
	sets.precast.WS["Evisceration"].SATA = sets.precast.WS["Rudra's Storm"].SA

	sets.precast.WS['Last Stand'] = sets.precast.WS
	sets.precast.WS['Empyreal Arrow'] = sets.precast.WS['Last Stand']
		
	sets.precast.WS['Aeolian Edge'] = sets.precast.WS
	sets.precast.WS['Aeolian Edge'].TH = set_combine(sets.precast.WS['Aeolian Edge'], sets.TreasureHunter)

	-- Swap to these on Moonshade using WS if at 3000 TP
	sets.MaxTP = {}
	sets.AccMaxTP = {}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	sets.midcast.FastRecast = {}

	-- Specific spells
	sets.midcast.Utsusemi = set_combine(sets.midcast.FastRecast, {})

	sets.midcast.Dia = set_combine(sets.midcast.FastRecast, sets.TreasureHunter)
	sets.midcast.Diaga = set_combine(sets.midcast.FastRecast, sets.TreasureHunter)
	sets.midcast['Dia II'] = set_combine(sets.midcast.FastRecast, sets.TreasureHunter)
	sets.midcast.Bio = set_combine(sets.midcast.FastRecast, sets.TreasureHunter)
	sets.midcast['Bio II'] = set_combine(sets.midcast.FastRecast, sets.TreasureHunter)

	-- Ranged gear

	sets.midcast.RA = {}

	sets.midcast.RA.Acc = {}

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

	-- Resting sets
	sets.resting = {}

	-- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)

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
		left_ring="Murky Ring",
		right_ring="Shadow Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
	sets.idle.Regain = {
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
		left_ring="Murky Ring",
		right_ring="Roller's Ring",
		back="Null Shawl",}
		
	sets.idle.rollers = set_combine(sets.idle, {right_ring="Roller's Ring",})
	sets.idle.Regain.rollers = set_combine(sets.idle.Regain, {right_ring="Roller's Ring",})

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------    
	
	sets.engaged = {
		ammo="Aurgelmir Orb +1",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Gleti's Breeches",
		feet="Malignance Boots",
		neck={ name="Asn. Gorget +2", augments={'Path: A',}},
		waist="Gerdr Belt +1",
		left_ear="Alabaster Earring",
		right_ear={ name="Skulk. Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+17','Mag. Acc.+17','"Store TP"+6','DEX+9 AGI+9',}},
		left_ring="Murky Ring",
		right_ring="Gere Ring",
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

    -- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
    --sets.buff['Climactic Flourish'] = {ammo="Charis Feather",head="Adhemar Bonnet +1",body="Meg. Cuirie +2"} --head="Charis Tiara +2"
	sets.buff.Doom = set_combine(sets.buff.Doom, {neck="Nicander's Necklace",waist="Gishdubar Sash",})
	sets.buff.Sleep = {head="Frenzy Sallet"}
	
	sets.weapons.Mpu_Gandring = {main="Mpu Gandring",}
	sets.weapons.Twashtar = {main="Twashtar",}
	sets.weapons.Mandau = {main="Mandau",}
	sets.weapons.Tauret = {main="Tauret",}
	sets.weapons.Naegling = {main="Naegling",}
	sets.weapons.Onion = {main="Onion Sword III",}
	sets.weapons.Karambit = {main="Karambit"}
	
	sets.Centovente = {sub="Fusetto +2",}
	sets.Gletis_Knife = {sub={ name="Gleti\'s Knife", augments={'Path: A',}},}
	sets.Crepuscular = {sub="Crepuscular Knife",}
	
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book
	set_macro_page(1, 6)
end

function user_job_lockstyle()
    send_command('input /lockstyleset ' .. lockstyleset)
end