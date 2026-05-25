function user_job_setup()
	-- Options: Override default values
	state.OffenseMode:options('Normal', 'Acc', 'Subtle_Blow')
	state.WeaponskillMode:options('Normal','ATKCAP')
	state.HybridMode:options('Normal','DT','Defense')
	state.IdleMode:options('Normal')
	state.Weapons:options('Naegling', 'Loxotic_Mace', 'Shining_One', 'Chango', 'Ikenga_axe', 'Lycurgos', 'Dolichenus')

	Two_Handed_Weapons = {
		Chango			= true,
		Lycurgos		= true,
		Shining_One   	= true,}
		
	One_Handed_Weapons = {
		Naegling		= true,
		Loxotic_Mace	= true,
		Ikenga_axe   	= true,
		Dolichenus		= true,}

	state.Reraise = M(false, "Reraise Mode")
	
	init_job_states({},{"Weapons","OffenseMode","WeaponskillMode","IdleMode","CastingMode","Reraise","TreasureMode",})
	
	--Includes Global Bind keys
	
	send_command('wait 2; exec Global-Binds.txt')
	
	--Warrior Binds
	
	send_command('wait 3; exec /WAR/Binds.txt')
	
	--Retrieve Gear for Warrior
	
	send_command('wait 3;org get inventory war.lua')

	--Job settings

	lockstyleset = 1
	select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
	enable('main','sub','range','ammo','head','body','hands','legs','feet','neck','waist','left_ear','right_ear','left_ring','right_ring','back')

	--Remove Global Binds

	send_command('wait 1; exec Global-UnBinds.txt')
	
	--Remove Gear for Warrior
	
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
		hands="Sakpata's Gauntlets",
		legs={ name="Zoar Subligar +1", augments={'Path: A',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Moonlight Necklace",
		waist="Audumbla Sash",
		left_ear="Cryptic Earring",
		right_ear="Friomisi Earring",
		left_ring="Eihwaz Ring",
		right_ring="Begrudging Ring",
		back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
	
	-- Precast sets to enhance JAs
	sets.precast.JA['Berserk'] = {
		body="Pumm. Lorica +3",
		feet={ name="Agoge Calligae +3", augments={'Enhances "Tomahawk" effect',}},
		back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
	
	sets.precast.JA['Warcry'] = {head={ name="Agoge Mask +3", augments={'Enhances "Savagery" effect',}},}
	sets.precast.JA['Defender'] = {hands={ name="Agoge Mufflers", augments={'Enhances "Mighty Strikes" effect',}},}
	sets.precast.JA['Aggressor'] = {head="Pummeler's Mask +3", body={ name="Agoge Lorica +3", augments={'Enhances "Aggressive Aim" effect',}},}
	sets.precast.JA['Mighty Strikes'] = {hands={ name="Agoge Mufflers", augments={'Enhances "Mighty Strikes" effect',}},}
	sets.precast.JA["Warrior's Charge"] = {}
	sets.precast.JA['Tomahawk'] = {ammo="Thr. Tomahawk", feet={ name="Agoge Calligae +3", augments={'Enhances "Tomahawk" effect',}},}
	sets.precast.JA['Restraint'] = {hands="Boii Mufflers +3",}
	sets.precast.JA['Blood Rage'] = {body="Boii Lorica +3",}
	sets.precast.JA['Provoke'] = set_combine(sets.Enmity,{})
				   
	-- Waltz set (chr and vit)
	sets.precast.Waltz = {
        ammo="Yamarang",
		legs="Dashing Subligar",
        waist="Gishdubar Sash",}

	-- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {legs="Dashing Subligar",}
		   
	sets.precast.Step = {}
	
	sets.precast.Flourish1 = {}
		   
	-- Fast cast sets for spells

	sets.precast.FC = {}
	
    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------
	
	--Generic Weapon Skill

	sets.precast.WS = {
		ammo="Knobkierrie",
		head={ name="Agoge Mask +3", augments={'Enhances "Savagery" effect',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Boii Mufflers +3",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="War. Beads +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Thrud Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Regal Ring",
		back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS.ATKCAP = {
		ammo="Knobkierrie",
		head={ name="Agoge Mask +3", augments={'Enhances "Savagery" effect',}},
		body={ name="Sakpata's Plate", augments={'Path: A',}},
		hands="Boii Mufflers +3",
		legs="Boii Cuisses +3",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="War. Beads +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Thrud Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Sroda Ring",
		back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	--Mighty Strikes Set
	sets.Mighty = {ammo="Yetshila +1",feet="Boii Calligae +3"}
	
	--TP Overflow set
	sets.precast.WS.FullTP = {left_ear={ name="Lugra Earring +1", augments={'Path: A',}},}

	--Great Axe Weapon Skills
	
	sets.precast.WS['Upheaval'] = {
		ammo="Knobkierrie",
		head={ name="Agoge Mask +3", augments={'Enhances "Savagery" effect',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Boii Mufflers +3",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="War. Beads +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Thrud Earring",
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring="Niqmaddu Ring",
		back={ name="Cichol's Mantle", augments={'VIT+20','Accuracy+20 Attack+20','VIT+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Upheaval'].ATKCAP = {
		ammo="Knobkierrie",
		head={ name="Agoge Mask +3", augments={'Enhances "Savagery" effect',}},
		body={ name="Sakpata's Plate", augments={'Path: A',}},
		hands="Boii Mufflers +3",
		legs="Boii Cuisses +3",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="War. Beads +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Thrud Earring",
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring="Niqmaddu Ring",
		back={ name="Cichol's Mantle", augments={'VIT+20','Accuracy+20 Attack+20','VIT+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Ukko\'s Fury'] = {
		ammo="Yetshila +1",
		head="Boii Mask +3",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Boii Mufflers +3",
		legs="Boii Cuisses +3",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="War. Beads +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Schere Earring", augments={'Path: A',}},
		right_ear={ name="Boii Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','Crit.hit rate+5',}},
		left_ring="Begrudging Ring",
		right_ring="Niqmaddu Ring",
		back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Ukko\'s Fury'].ATKCAP = {
		ammo="Yetshila +1",
		head="Boii Mask +3",
		body={ name="Sakpata's Plate", augments={'Path: A',}},
		hands="Boii Mufflers +3",
		legs="Boii Cuisses +3",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="War. Beads +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Schere Earring", augments={'Path: A',}},
		right_ear={ name="Boii Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','Crit.hit rate+5',}},
		left_ring="Begrudging Ring",
		right_ring="Niqmaddu Ring",
		back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

	sets.precast.WS['Steel Cyclone'] = {
		ammo="Knobkierrie",
		head={ name="Agoge Mask +3", augments={'Enhances "Savagery" effect',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Boii Mufflers +3",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="War. Beads +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Thrud Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Sroda Ring",
		back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Steel Cyclone'].ATKCAP = {
		ammo="Knobkierrie",
		head={ name="Agoge Mask +3", augments={'Enhances "Savagery" effect',}},
		body={ name="Sakpata's Plate", augments={'Path: A',}},
		hands="Boii Mufflers +3",
		legs="Boii Cuisses +3",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="War. Beads +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Thrud Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Sroda Ring",
		back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['King\'s Justice'] = sets.precast.WS['Steel Cyclone']
	sets.precast.WS['King\'s Justice'].ATKCAP = sets.precast.WS['Steel Cyclone'].ATKCAP

	sets.precast.WS['Fell Cleave'] = sets.precast.WS['Steel Cyclone']

	--Breaks
	
	sets.precast.WS['Full Break'] = {
		ammo="Pemphredo Tathlum",
		head="Boii Mask +3",
		body="Boii Lorica +3",
		hands="Boii Mufflers +3",
		legs="Boii Cuisses +3",
		feet="Boii Calligae +3",
		neck="Moonlight Necklace",
		waist="Eschan Stone",
		left_ear="Digni. Earring",
		right_ear={ name="Boii Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','Crit.hit rate+5',}},
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Cichol's Mantle", augments={'STR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','Weapon skill damage +10%',}},}
	
	sets.precast.WS['Shield Break'] = sets.precast.WS['Full Break']
	sets.precast.WS['Armor Break'] = sets.precast.WS['Full Break']
	sets.precast.WS['Weapon Break'] = sets.precast.WS['Full Break']
	
	
	--Sword Weapon Skills

	sets.precast.WS['Savage Blade'] = {
		ammo="Knobkierrie",
		head={ name="Agoge Mask +3", augments={'Enhances "Savagery" effect',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Boii Mufflers +3",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="War. Beads +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Thrud Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Sroda Ring",
		back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Savage Blade'].ATKCAP = {
		ammo="Knobkierrie",
		head={ name="Agoge Mask +3", augments={'Enhances "Savagery" effect',}},
		body={ name="Sakpata's Plate", augments={'Path: A',}},
		hands="Boii Mufflers +3",
		legs="Boii Cuisses +3",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="War. Beads +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Thrud Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Sroda Ring",
		back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
	
	sets.precast.WS['Seraph Blade'] = {
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
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Epaminondas's Ring",
		back={ name="Cichol's Mantle", augments={'STR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Red Lotus Blade'] = sets.precast.WS['Seraph Blade']

    sets.precast.WS['Sanguine Blade'] = set_combine(sets.precast.WS['Seraph Blade'], {head="Pixie Hairpin +1",left_ring="Archon Ring",left_ear="Thrud Earring",})
		
	--Polearm Weapon Skills

	sets.precast.WS['Impulse Drive'] = sets.precast.WS['Savage Blade']
	sets.precast.WS['Impulse Drive'].ATKCAP = sets.precast.WS['Savage Blade'].ATKCAP
	
	sets.precast.WS['Stardiver'] = sets.precast.WS['Savage Blade']
	sets.precast.WS['Stardiver'].ATKCAP = sets.precast.WS['Savage Blade'].ATKCAP	
	
	--Club Weapon Skills
	
	sets.precast.WS['Black Halo'] = sets.precast.WS['Savage Blade']
	sets.precast.WS['Black Halo'].ATKCAP = sets.precast.WS['Savage Blade'].ATKCAP
	
	sets.precast.WS['Judgment'] = sets.precast.WS['Savage Blade']
	sets.precast.WS['Judgment'].ATKCAP = sets.precast.WS['Savage Blade'].ATKCAP	
		
	--Axe Weapon Skills
	
	sets.precast.WS['Decimation'] = sets.precast.WS['Savage Blade']
	sets.precast.WS['Decimation'].ATKCAP = sets.precast.WS['Savage Blade'].ATKCAP
	
	sets.precast.WS['Mistral Axe'] = sets.precast.WS['Savage Blade']
	sets.precast.WS['Mistral Axe'].ATKCAP = sets.precast.WS['Savage Blade'].ATKCAP
	
	sets.precast.WS['Calamity'] = sets.precast.WS['Savage Blade']
	sets.precast.WS['Calamity'].ATKCAP = sets.precast.WS['Savage Blade'].ATKCAP
	
	-- Swap to these on Moonshade using WS if at 3000 TP
	sets.MaxTP = {}
	sets.AccMaxTP = {}
	sets.AccDayMaxTPWSEars = {}
	sets.DayMaxTPWSEars = {}
	sets.AccDayWSEars = {}
	sets.DayWSEars = {}
	
	--Specialty WS set overwrites.
	sets.AccWSMightyCharge = {}
	sets.AccWSCharge = {}
	sets.AccWSMightyCharge = {}
	sets.WSMightyCharge = {}
	sets.WSCharge = {}
	sets.WSMighty = {}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	-- Midcast Sets
	sets.midcast.FastRecast = sets.precast.FC
	
	sets.midcast.Utsusemi = set_combine(sets.midcast.FastRecast, {})
				   
	sets.midcast.Cure = {}
	
	sets.Self_Healing = {}
	sets.Cure_Received = {right_ring="Kunaji Ring",waist="Gishdubar Sash"}


    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

	 sets.resting = {    
		ammo="Staunch Tathlum +1",
		head={ name="Sakpata's Helm", augments={'Path: A',}},
		body={ name="Sakpata's Plate", augments={'Path: A',}},
		hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
		legs={ name="Sakpata's Cuisses", augments={'Path: A',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Flume Belt +1",
		left_ear="Eabani Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		   
	-- Idle sets
	sets.idle = {    
		ammo="Staunch Tathlum +1",
		head={ name="Sakpata's Helm", augments={'Path: A',}},
		body={ name="Sakpata's Plate", augments={'Path: A',}},
		hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
		legs={ name="Sakpata's Cuisses", augments={'Path: A',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Flume Belt +1",
		left_ear="Eabani Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
	 
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	------------------------------------------------------------------------------------------------
	-----------------------------------------Single Wield Sets--------------------------------------
	------------------------------------------------------------------------------------------------

    sets.engaged = {
		ammo="Coiste Bodhar",
		head="Hjarrandi Helm",
		body="Boii Lorica +3",
		hands="Sakpata's Gauntlets",
		legs="Pumm. Cuisses +4",
		feet="Pumm. Calligae +4",
		neck="Vim Torque +1",
		waist="Sailfi Belt +1",
		left_ear="Schere Earring",
		right_ear={ name="Boii Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+17','Mag. Acc.+17','Crit.hit rate+6','STR+9 VIT+9',}},
		left_ring="Chirich Ring +1",
		right_ring="Petrov Ring",
		back="Null Shawl",}

    sets.engaged.Acc = {
		ammo="Coiste Bodhar",
		head="Hjarrandi Helm",
		body="Boii Lorica +3",
		hands="Sakpata's Gauntlets",
		legs="Pumm. Cuisses +4",
		feet="Pumm. Calligae +4",
		neck="Vim Torque +1",
		waist="Sailfi Belt +1",
		left_ear="Schere Earring",
		right_ear={ name="Boii Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+17','Mag. Acc.+17','Crit.hit rate+6','STR+9 VIT+9',}},
		left_ring="Chirich Ring +1",
		right_ring="Petrov Ring",
		back="Null Shawl",}
		
	------------------------------------------------------------------------------------------------
	-----------------------------------------Dual Wield Sets----------------------------------------
	------------------------------------------------------------------------------------------------

    sets.engaged.DW = {
		ammo="Coiste Bodhar",
		head="Hjarrandi Helm",
		body="Boii Lorica +3",
		hands="Sakpata's Gauntlets",
		legs="Pumm. Cuisses +4",
		feet="Pumm. Calligae +4",
		neck="Vim Torque +1",
		waist="Sailfi Belt +1",
		left_ear="Schere Earring",
		right_ear={ name="Boii Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+17','Mag. Acc.+17','Crit.hit rate+6','STR+9 VIT+9',}},
		left_ring="Chirich Ring +1",
		right_ring="Petrov Ring",
		back="Null Shawl",}

    sets.engaged.DW.Acc = {
		ammo="Coiste Bodhar",
		head="Hjarrandi Helm",
		body="Boii Lorica +3",
		hands="Sakpata's Gauntlets",
		legs="Pumm. Cuisses +4",
		feet="Pumm. Calligae +4",
		neck="Vim Torque +1",
		waist="Sailfi Belt +1",
		left_ear="Schere Earring",
		right_ear={ name="Boii Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+17','Mag. Acc.+17','Crit.hit rate+6','STR+9 VIT+9',}},
		left_ring="Chirich Ring +1",
		right_ring="Petrov Ring",
		back="Null Shawl",}
		
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {    
		ammo="Coiste Bodhar",
		head="Hjarrandi Helm",
		body="Boii Lorica +3",
		hands="Sakpata's Gauntlets",
		legs="Pumm. Cuisses +4",
		feet="Pumm. Calligae +4",
		neck="Vim Torque +1",
		waist="Sailfi Belt +1",
		left_ear="Schere Earring",
		right_ear={ name="Boii Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+17','Mag. Acc.+17','Crit.hit rate+6','STR+9 VIT+9',}},
		left_ring="Moonlight Ring",
		right_ring="Petrov Ring",
		back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
	sets.engaged.Hybrid.Defense = {
		ammo="Coiste Bodhar",
		head="Hjarrandi Helm",
		body="Boii Lorica +3",
		hands="Sakpata's Gauntlets",
		legs="Pumm. Cuisses +4",
		feet="Pumm. Calligae +4",
		neck={ name="War. Beads +2", augments={'Path: A',}},
		waist="Ioskeha Belt +1",
		left_ear="Schere Earring",
		right_ear="Alabaster Earring",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
		back="Null Shawl",}
		
		
    sets.engaged.DT = sets.engaged.Hybrid
    sets.engaged.Acc.DT = sets.engaged.Hybrid
    sets.engaged.Defense = sets.engaged.Hybrid.Defense
    sets.engaged.Acc.Defense = sets.engaged.Hybrid.Defense
	
    sets.engaged.DW.DT = sets.engaged.Hybrid
    sets.engaged.DW.Acc.DT = sets.engaged.Hybrid
    sets.engaged.DW.Defense = sets.engaged.Hybrid.Defense
    sets.engaged.DW.Acc.Defense = sets.engaged.Hybrid.Defense
	
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
	

	sets.Kiting = {left_ring="Shneddick Ring",}
	sets.Reraise = {head="Crepuscular Helm",body="Crepuscular Mail",}
	sets.buff.Doom = set_combine(sets.buff.Doom, {neck="Nicander's Necklace", waist="Gishdubar Sash",})
	
	sets.TreasureHunter = {
		body="Volte Jupon",
		hands="Volte Bracers",
		waist="Chaac Belt",}
		
	--Weaponsets

    sets.weapons.Chango = {main={ name="Chango", augments={'Path: A',}},}
	sets.weapons.Lycurgos = {main="Lycurgos",}
	sets.weapons.Shining_One = {main="Shining One",}
	
	sets.weapons.Naegling = {main="Naegling",}
	sets.weapons.Loxotic_Mace = {main={ name="Loxotic Mace +1", augments={'Path: A',}},}
	sets.weapons.Ikenga_axe = {main="Ikenga's Axe",}
	sets.weapons.Dolichenus = {main="Dolichenus",}
	
	sets.weapons.Naegling.DW = {main="Naegling", sub="Ikenga's Axe",}
	sets.weapons.Loxotic_Mace.DW = {main={ name="Loxotic Mace +1", augments={'Path: A',}},sub="Ikenga's Axe",}
	sets.weapons.Ikenga_axe.DW = {main="Ikenga's Axe", sub="Dolichenus",}
	sets.weapons.Dolichenus.DW = {main="Dolichenus", sub="Ikenga's Axe",}

	sets.grip = {sub="Utu Grip"}
	sets.shield = {sub="Blurred Shield +1",}
	
end
	
-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	set_macro_page(1, 1)
end

function user_job_lockstyle()
    send_command('input /lockstyleset ' .. lockstyleset)
end