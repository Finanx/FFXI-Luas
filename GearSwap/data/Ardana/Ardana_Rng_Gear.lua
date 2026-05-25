-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_job_setup()
	state.OffenseMode:options('Normal','Acc')
	state.HybridMode:options('Normal','DT','Defense')
	state.RangedMode:options('Normal','Acc', 'FullAcc')
	state.WeaponskillMode:options('Normal', 'ATKCAP', 'Acc', 'FullAcc')
	state.IdleMode:options('Normal')
	state.Weapons:options('Perun','Naegling','Oneiros','Malevolence')
	state.RangeSet = M{['description']='Range Set', 'TP_Bow', 'Fomalhaut', 'Earp', 'Annihilator', 'Armageddon', 'Ullr', 'Gastrephetes'}
	state.Subweapon = M{['description']='Sub Weapon Set', 'Gleti', 'Kraken', 'Crepuscular', 'Ternion', 'Kustawi'}
	
	RangedWS_Boost_Weapons = {
		Perun   	= true,
		Oneiros     = true,}
	
	Ikenga_vest_bonus = 200
	
	RangedWeaponType = 'Gun'

	DefaultAmmo = {
		['Bow']  = {['Default'] = "Chapuli Arrow",
					['WS'] = "Chrono Arrow",
					['MeleeWS'] = "Hauksbok Arrow",
					['Idle'] = "Chapuli Arrow",
					['Acc'] = "Chrono Arrow",
					['Magic'] = "Chrono Arrow",
					['MagicAcc'] = "Chrono Arrow",
					['Unlimited'] = "Hauksbok Arrow",
					['MagicUnlimited'] ="Hauksbok Arrow",
					['MagicAccUnlimited'] ="Hauksbok Arrow"},
					
		['Gun']  = {['Default'] = "Chrono Bullet",
					['WS'] = "Chrono Bullet",
					['MeleeWS'] = "Bayeux Bullet",
					['Idle'] = "Bayeux Bullet",
					['Acc'] = "Chrono Bullet",
					['Magic'] = "Chrono Bullet",
					['MagicAcc'] = "Chrono Bullet",
					['Unlimited'] = "Hauksbok Bullet",
					['MagicUnlimited'] = "Hauksbok Bullet",
					['MagicAccUnlimited'] ="Animikii Bullet"},
					
		['Crossbow'] = {['Default'] = "Quelling Bolt",
						['WS'] = "Quelling Bolt",
						['MeleeWS'] = "Quelling Bolt",
						['Idle'] = "Quelling Bolt",
						['Acc'] = "Quelling Bolt",
						['Magic'] = "Quelling Bolt",
						['MagicAcc'] = "Quelling Bolt",
						['Unlimited'] = "Hauksbok Bolt",
						['MagicUnlimited'] = "Hauksbok Bolt",
						['MagicAccUnlimited'] ="Hauksbok Bolt"}
	}
	
	--Includes Global Bind keys
	
	send_command('wait 2; exec Global-Binds.txt')
	
	--Ranger Binds
	
	send_command('wait 2; exec /RNG/Binds.txt')
	
	--Retrieve Gear for Ranger
	
	send_command('wait 3;org get inventory rng.lua')
	send_command('wait 4;get Animikii Bullet')
	send_command('wait 4;get Bayeux Bullet')
	send_command('wait 4;get Chrono Bullet all')
	send_command('wait 4;get Devastating Bullet all')
	send_command('wait 4;get Eradicating Bullet all')
	send_command('wait 4;get Shihei all')

	--Job settings

	lockstyleset = 11
	select_default_macro_book()
end

function user_unload()

	enable('main','sub','range','ammo','head','body','hands','legs','feet','neck','waist','left_ear','right_ear','left_ring','right_ring','back')

	--Remove Global Binds

	send_command('wait 1; exec Global-UnBinds.txt')
	
	--Remove Gear for White Mage
	
	send_command('wait 1; org get Store.lua')
	
end

-- Set up all gear sets.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
	
	sets.precast.JA['Camouflage'] = {body="Orion Jerkin +3"}
	sets.precast.JA['Scavenge'] = {feet="Orion Socks +4"}
	sets.precast.JA['Shadowbind'] = {hands="Orion Bracers +4"}
	sets.precast.JA['Sharpshot'] = {legs="Orion Braccae +4"}
	
	sets.precast.JA['Eagle Eye Shot'] = {
	    head="Meghanada Visor +2",
		body="Amini Caban +3",
		hands="Ikenga's Gloves",
		legs="Arc. Braccae +4",
		feet="Osh. Leggings +1",
		neck={ name="Scout's Gorget +2", augments={'Path: A',}},
		waist="K. Kachina Belt +1",
		left_ear="Odr Earring",
		right_ear={ name="Amini Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','Crit.hit rate+6','STR+7 AGI+7',}},
		left_ring="Ephramad's Ring",
		right_ring="Murky Ring",
		back={ name="Belenus's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Crit.hit rate+10','Phys. dmg. taken-10%',}},}
		
	sets.precast.JA['Eagle Eye Shot'].Acc = {
	    head="Meghanada Visor +2",
		body="Amini Caban +3",
		hands="Ikenga's Gloves",
		legs="Arc. Braccae +4",
		feet="Osh. Leggings +1",
		neck={ name="Scout's Gorget +2", augments={'Path: A',}},
		waist="K. Kachina Belt +1",
		left_ear="Odr Earring",
		right_ear={ name="Amini Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','Crit.hit rate+6','STR+7 AGI+7',}},
		left_ring="Ephramad's Ring",
		right_ring="Murky Ring",
		back={ name="Belenus's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Crit.hit rate+10','Phys. dmg. taken-10%',}},}
		
	sets.precast.JA['Eagle Eye Shot'].FullAcc = {
	    head="Meghanada Visor +2",
		body="Amini Caban +3",
		body="Amini Caban +3",
		legs="Arc. Braccae +4",
		feet="Osh. Leggings +1",
		neck={ name="Scout's Gorget +2", augments={'Path: A',}},
		waist="K. Kachina Belt +1",
		left_ear="Odr Earring",
		right_ear={ name="Amini Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','Crit.hit rate+6','STR+7 AGI+7',}},
		left_ring="Ephramad's Ring",
		right_ring="Murky Ring",
		back={ name="Belenus's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Crit.hit rate+10','Phys. dmg. taken-10%',}},}
	
	-- Fast cast sets for spells

	sets.precast.FC = {
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body={ name="Adhemar Jacket +1", augments={'HP+105','"Fast Cast"+10','Magic dmg. taken -4',}},
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
		feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
		neck="Baetyl Pendant",
		waist="Plat. Mog. Belt",
		left_ear="Loquac. Earring",
		right_ear="Etiolation Earring",
		left_ring="Prolix Ring",
		right_ring="Murky Ring",
		back="Null Shawl",}

	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads",body="Passion Jacket"})


	-- Ranged sets (snapshot)
	
	sets.precast.RA = {
		head="Arcadian Beret +3",
		body="Amini Caban +3",
		hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
		legs={ name="Adhemar Kecks +1", augments={'AGI+12','"Rapid Shot"+13','Enmity-6',}},
		feet="Meg. Jam. +2",
		neck={ name="Scout's Gorget +2", augments={'Path: A',}},
		waist="Impulse Belt",
		left_ear="Alabaster Earring",
		right_ear="Sanare Earring",
		left_ring="Crepuscular Ring",
		right_ring="Murky Ring",
		back="Null Shawl",}
		
	sets.precast.RA.Flurry = {
		head="Arcadian Beret +3",
		body="Amini Caban +3",
		hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
		legs={ name="Adhemar Kecks +1", augments={'AGI+12','"Rapid Shot"+13','Enmity-6',}},
		feet="Meg. Jam. +2",
		neck={ name="Scout's Gorget +2", augments={'Path: A',}},
		waist="Impulse Belt",
		left_ear="Alabaster Earring",
		right_ear="Sanare Earring",
		left_ring="Crepuscular Ring",
		right_ring="Murky Ring",
		back="Null Shawl",}
		
	sets.precast.RA.Flurry2 = {
		head="Arcadian Beret +3",
		body="Amini Caban +3",
		hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
		legs={ name="Adhemar Kecks +1", augments={'AGI+12','"Rapid Shot"+13','Enmity-6',}},
		feet="Meg. Jam. +2",
		neck={ name="Scout's Gorget +2", augments={'Path: A',}},
		waist="Impulse Belt",
		left_ear="Alabaster Earring",
		right_ear="Sanare Earring",
		left_ring="Crepuscular Ring",
		right_ring="Murky Ring",
		back="Null Shawl",}


    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------
	
	sets.precast.WS = {
	    head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Rep. Plat. Medal",
		waist="Sailfi Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Moonshade Earring",
		left_ring="Sroda Ring",
		right_ring="Ephramad's Ring",
		back="Null Shawl",}
		
	sets.precast.WS.ATKCAP = {
	    head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Rep. Plat. Medal",
		waist="Sailfi Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Moonshade Earring",
		left_ring="Sroda Ring",
		right_ring="Ephramad's Ring",
		back="Null Shawl",}
		
	sets.precast.WS.Acc = {}
	
	sets.precast.WS.FullAcc = {}
	
	sets.precast.WS['Terminus'] = {
		head="Orion Beret +4",
		body="Ikenga's Vest",
		hands="Nyame Gauntlets",
		legs="Arc. Braccae +4",
		feet="Amini Bottillons +3",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Moonshade Earring",
		right_ear="Alabaster Earring",
		left_ring="Ephramad's Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Belenus's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},}
	
	sets.precast.WS['Terminus'].ATKCAP = {
	    head="Orion Beret +4",
		body="Ikenga's Vest",
		hands="Nyame Gauntlets",
		legs="Arc. Braccae +4",
		feet="Amini Bottillons +3",
		neck={ name="Scout's Gorget +2", augments={'Path: A',}},
		waist="Fotia Belt",
		left_ear="Moonshade Earring",
		right_ear={ name="Amini Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','Crit.hit rate+6','STR+7 AGI+7',}},
		left_ring="Ephramad's Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Belenus's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},}

	--sets.precast.WS['Terminus'].Acc = {}
	
	--sets.precast.WS['Terminus'].FullAcc = {}
	
	sets.precast.WS['Coronach'] = {
	    head="Orion Beret +4",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Arc. Braccae +4",
		feet="Amini Bottillons +3",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Alabaster Earring",
		right_ear={ name="Amini Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','Crit.hit rate+6','STR+7 AGI+7',}},
		left_ring="Ephramad's Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Belenus's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},}
		
	sets.precast.WS['Coronach'].ATKCAP = {
		head="Orion Beret +4",
		body="Amini Caban +3",
		hands="Nyame Gauntlets",
		legs="Arc. Braccae +4",
		feet="Amini Bottillons +3",
		neck={ name="Scout's Gorget +2", augments={'Path: A',}},
		waist="Fotia Belt",
		left_ear="Alabaster Earring",
		right_ear={ name="Amini Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','Crit.hit rate+6','STR+7 AGI+7',}},
		left_ring="Ephramad's Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Belenus's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},}

	--sets.precast.WS['Coronach'].Acc = {}
	
	--sets.precast.WS['Coronach'].FullAcc = {}

	sets.precast.WS['Wildfire'] = {}

	sets.precast.WS['Wildfire'].Acc = {}
		
	sets.precast.WS['Aeolian Edge'] = {}
		
	sets.precast.WS['Trueflight'] = {}

	sets.precast.WS['Trueflight'].Acc = {}
		
	-- Swap to these on Moonshade using WS if at 3000 TP
	sets.MaxTP = {}
	sets.AccMaxTP = {}
	


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	-- Fast recast for spells
	
	sets.midcast.FastRecast = sets.precast.FC
		
	-- Ranged sets

	sets.midcast.RA = {
	    head="Arcadian Beret +4",
		body="Arc. Jerkin +4",
		hands="Malignance Gloves",
		legs="Amini Bragues +3",
		feet="Arc. Socks +4",
		neck={ name="Scout's Gorget +2", augments={'Path: A',}},
		waist="Tellen Belt",
		left_ear="Alabaster Earring",
		right_ear={ name="Amini Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','Crit.hit rate+6','STR+7 AGI+7',}},
		left_ring="Ephramad's Ring",
		right_ring="Crepuscular Ring",
		back={ name="Belenus's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
	
	sets.midcast.RA.Acc = {
	    head="Arcadian Beret +4",
		body="Arc. Jerkin +4",
		hands="Malignance Gloves",
		legs="Amini Bragues +3",
		feet="Arc. Socks +4",
		neck={ name="Scout's Gorget +2", augments={'Path: A',}},
		waist="Tellen Belt",
		left_ear="Alabaster Earring",
		right_ear={ name="Amini Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','Crit.hit rate+6','STR+7 AGI+7',}},
		left_ring="Ephramad's Ring",
		right_ring="Crepuscular Ring",
		back={ name="Belenus's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
	sets.midcast.RA.FullAcc = {
	    head="Arcadian Beret +4",
		body="Arc. Jerkin +4",
		hands="Malignance Gloves",
		legs="Amini Bragues +3",
		feet="Arc. Socks +4",
		neck={ name="Scout's Gorget +2", augments={'Path: A',}},
		waist="Tellen Belt",
		left_ear="Alabaster Earring",
		right_ear={ name="Amini Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','Crit.hit rate+6','STR+7 AGI+7',}},
		left_ring="Ephramad's Ring",
		right_ring="Crepuscular Ring",
		back={ name="Belenus's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
	
	sets.DoubleShot = {
	    head="Oshosi Mask +1",
		body="Arc. Jerkin +4",
		hands="Ikenga's Gloves",
		legs="Amini Bragues +3",
		feet="Osh. Leggings +1",
		neck={ name="Scout's Gorget +2", augments={'Path: A',}},
		waist="K. Kachina Belt +1",
		left_ear="Odr Earring",
		right_ear={ name="Amini Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','Crit.hit rate+6','STR+7 AGI+7',}},
		left_ring="Ephramad's Ring",
		right_ring="Murky Ring",
		back={ name="Belenus's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Crit.hit rate+10','Phys. dmg. taken-10%',}},}
	
	sets.DoubleShot.Acc = {
	    head="Oshosi Mask +1",
		body="Arc. Jerkin +4",
		hands="Ikenga's Gloves",
		legs="Amini Bragues +3",
		feet="Osh. Leggings +1",
		neck={ name="Scout's Gorget +2", augments={'Path: A',}},
		waist="K. Kachina Belt +1",
		left_ear="Odr Earring",
		right_ear={ name="Amini Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','Crit.hit rate+6','STR+7 AGI+7',}},
		left_ring="Ephramad's Ring",
		right_ring="Murky Ring",
		back={ name="Belenus's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Crit.hit rate+10','Phys. dmg. taken-10%',}},}
	
	sets.DoubleShot.FullAcc = {
	    head="Oshosi Mask +1",
		body="Arc. Jerkin +4",
		hands="Ikenga's Gloves",
		legs="Amini Bragues +3",
		feet="Osh. Leggings +1",
		neck={ name="Scout's Gorget +2", augments={'Path: A',}},
		waist="K. Kachina Belt +1",
		left_ear="Odr Earring",
		right_ear={ name="Amini Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','Crit.hit rate+6','STR+7 AGI+7',}},
		left_ring="Ephramad's Ring",
		right_ring="Murky Ring",
		back={ name="Belenus's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Crit.hit rate+10','Phys. dmg. taken-10%',}},}
		
	sets.buff.Barrage = {
		head="Blistering Sallet +1",
		body="Amini Caban +3",
		hands="Orion Bracers +4",
		legs="Arc. Braccae +4",
		feet="Osh. Leggings +1",
		neck={ name="Scout's Gorget +2", augments={'Path: A',}},
		waist="K. Kachina Belt +1",
		left_ear="Odr Earring",
		right_ear={ name="Amini Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','Crit.hit rate+6','STR+7 AGI+7',}},
		left_ring="Ephramad's Ring",
		right_ring="Sroda Ring",
		back={ name="Belenus's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Crit.hit rate+10','Phys. dmg. taken-10%',}},}
	
	sets.buff.Barrage.Acc = {
		head="Blistering Sallet +1",
		body="Amini Caban +3",
		hands="Orion Bracers +4",
		legs="Arc. Braccae +4",
		feet="Osh. Leggings +1",
		neck={ name="Scout's Gorget +2", augments={'Path: A',}},
		waist="K. Kachina Belt +1",
		left_ear="Odr Earring",
		right_ear={ name="Amini Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','Crit.hit rate+6','STR+7 AGI+7',}},
		left_ring="Ephramad's Ring",
		right_ring="Sroda Ring",
		back={ name="Belenus's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Crit.hit rate+10','Phys. dmg. taken-10%',}},}
	
	sets.buff.Barrage.FullAcc = {
		head="Blistering Sallet +1",
		body="Amini Caban +3",
		hands="Orion Bracers +4",
		legs="Arc. Braccae +4",
		feet="Osh. Leggings +1",
		neck={ name="Scout's Gorget +2", augments={'Path: A',}},
		waist="K. Kachina Belt +1",
		left_ear="Odr Earring",
		right_ear={ name="Amini Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+16','Mag. Acc.+16','Crit.hit rate+6','STR+7 AGI+7',}},
		left_ring="Ephramad's Ring",
		right_ring="Sroda Ring",
		back={ name="Belenus's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Crit.hit rate+10','Phys. dmg. taken-10%',}},}
	
	--These sets will overlay based on accuracy level, regardless of other options.
	sets.buff.Camouflage = {body="Orion Jerkin +3"}
	sets.buff.Camouflage.Acc = {}
	
	
	sets.Self_Healing = {neck="Phalaina Locket",hands="Buremte Gloves",ring2="Kunaji Ring",waist="Gishdubar Sash"}
	sets.Cure_Received = {neck="Phalaina Locket",hands="Buremte Gloves",ring2="Kunaji Ring",waist="Gishdubar Sash"}
	sets.Self_Refresh = {waist="Gishdubar Sash"}
	
	sets.midcast.Utsusemi = sets.midcast.FastRecast
	
    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

	-- Sets to return to when not performing an action.

	-- Resting sets
	sets.resting = {
		head="Null Masque",
		body="Adamantite Armor",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Loricate Torque +1",
		waist="Carrier's Sash",
		left_ear="Alabaster Earring",
		right_ear="Sanare Earring",
		left_ring="Shneddick Ring",
		right_ring="Murky Ring",
		back="Null Shawl",}

	-- Idle sets
	sets.idle = {
		head="Null Masque",
		body="Adamantite Armor",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Loricate Torque +1",
		waist="Carrier's Sash",
		left_ear="Alabaster Earring",
		right_ear="Sanare Earring",
		left_ring="Shneddick Ring",
		right_ring="Murky Ring",
		back="Null Shawl",}
	
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	-- Normal melee group
	sets.engaged = {
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		hands="Amini Glove. +3",
		legs="Amini Bragues +3",
		feet="Tatena. Sune. +1",
		neck="Iskur Gorget",
		waist="Windbuffet Belt +1",
		left_ear="Suppanomimi",
		right_ear="Eabani Earring",
		left_ring="Petrov Ring",
		right_ring="Epona's Ring",
		back="Null Shawl",}
	
	sets.engaged.Acc = {}

	sets.engaged.DT = {}
		
	sets.engaged.Defense = {}

	sets.engaged.DW = {
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		hands="Amini Glove. +3",
		legs="Amini Bragues +3",
		feet="Tatena. Sune. +1",
		neck="Iskur Gorget",
		waist="Windbuffet Belt +1",
		left_ear="Suppanomimi",
		right_ear="Eabani Earring",
		left_ring="Petrov Ring",
		right_ring="Epona's Ring",
		back="Null Shawl",}
		
	sets.engaged.DW.DT = {}
	
	sets.engaged.DW.Acc = {}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
	
	sets.Kiting = {left_ring="Shneddick Ring",}
	
	sets.TreasureHunter = {
		body="Volte Jupon",
		hands="Volte Bracers",
		waist="Chaac Belt",}
		
	sets.precast.JA['Bounty Shot'] = {hands="Amini Glove. +3"}
	
	sets.buff.Doom = set_combine(sets.buff.Doom, {neck="Nicander's Necklace", waist="Gishdubar Sash",})	
	
	--Weaponsets

	sets.weapons.Perun = {main="Perun +1",}
	sets.weapons.Naegling = {main="Naegling",}
	sets.weapons.Oneiros = {main="Oneiros Knife",}
	sets.weapons.Malevolence = {main="Malevolence",}

	sets.Gleti = {sub={ name="Gleti's Knife", augments={'Path: A',}},}
	sets.Crepuscular = {sub="Crepuscular Knife",}
	sets.Ternion = {sub="Ternion Dagger +1",}
	sets.Kustawi = {sub={ name="Kustawi +1", augments={'Path: A',}},}
	
	sets.shield = { sub="Nusku Shield" }
	
	--Rangesets
	sets.TP_Bow = {range="Anarchy +2",}
	sets.Earp = {range="Earp",}
	sets.Fomalhaut = {range="Fomalhaut",}
	sets.Annihilator = {Range="Annihilator",}
	sets.Armageddon = {range="Armageddon",}
	sets.Ullr = {range="Ullr",}
	
	
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	set_macro_page(1, 11)
end

function user_job_lockstyle()
    send_command('input /lockstyleset ' .. lockstyleset)
end