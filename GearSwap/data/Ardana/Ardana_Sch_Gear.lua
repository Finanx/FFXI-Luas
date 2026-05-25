-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_job_setup()
    state.OffenseMode:options('Normal')
	state.HybridMode:options('Normal', 'DT')
	state.WeaponskillMode:options('Normal')
    state.CastingMode:options('Normal','MagicBurst','Occult_Accumen')
    state.IdleMode:options('Normal')
	state.Weapons:options('None','Maxentius', 'Opashoro', 'Xoanon')
	state.Subweapon = M{['description']='Sub Weapon Set', 'Daybreak'}
	state.Shield = M{['description']='Shield Set', 'Ammurapi', 'Genmei'}

	state.RegenMode = M{['description']='Regen Mode', 'Normal', 'Duration'}
	state.SpellInterrupt = M(false, 'SpellInterrupt')
	
	init_job_states({},{"Weapons","OffenseMode","WeaponskillMode","IdleMode","CastingMode","RegenMode","SpellInterrupt","TreasureMode",})
	
	Two_Handed_Weapons = {
		Xoanon   = true,
		Musa     = true,
		Opashoro = true,}
		
	One_Handed_Weapons = {
		Maxentius = true,}


	--Includes Global Bind keys
	
	send_command('wait 2; exec Global-Binds.txt')

    --Scholar binds	

	send_command('wait 2; exec /SCH/Binds.txt')
	
	--Retrieve Gear for Scholar
	
	send_command('wait 3;org get inventory sch.lua')

	--Job settings

	lockstyleset = 18
	select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
	enable('main','sub','range','ammo','head','body','hands','legs','feet','neck','waist','left_ear','right_ear','left_ring','right_ring','back')

	--Remove Global Binds

	send_command('wait 1; exec Global-UnBinds.txt')
	
	--Remove Gear for Scholar
	
	send_command('wait 1; org get Store.lua')
	
end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
	
    -- Precast sets to enhance JAs
    sets.precast.JA['Tabula Rasa'] = {legs={ name="Peda. Pants +3", augments={'Enhances "Tabula Rasa" effect',}},}
    sets.precast.JA['Enlightenment'] = {body={ name="Peda. Gown +4", augments={'Enhances "Enlightenment" effect',}},}

    -- Fast cast sets for spells
    sets.precast.FC = {    
		main={ name="Musa", augments={'Path: C',}},
		sub="Khonsu",
		ammo="Sapience Orb",
		head={ name="Merlinic Hood", augments={'"Fast Cast"+5',}},
		body={ name="Agwu's Robe", augments={'Path: A',}},
		hands="Acad. Bracers +3",
		legs={ name="Agwu's Slops", augments={'Path: A',}},
		feet={ name="Merlinic Crackows", augments={'"Fast Cast"+5',}},
		neck="Baetyl Pendant",
		waist="Embla Sash",
		left_ear="Malignance Earring",
		right_ear="Etiolation Earring",
		left_ring="Kishar Ring",
		right_ring="Prolix Ring",
		back={ name="Fi Follet Cape +1", augments={'Path: A',}},}
		
	sets.precast.FC.Arts = {feet="Acad. Loafers +3"}
	sets.precast.FC.Impact = set_combine(sets.precast.FC, {head=empty,body="Crepuscular Cloak"})
	sets.precast.FC.Dispelga = set_combine(sets.precast.FC, {main="Daybreak",sub="Genmei Shield"})

	sets.precast.RA = {
		main="Mpaca's Staff",
		sub="Khonsu",
		range="Trollbane",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body="Arbatel Gown +3",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Cornelia's Belt",
		left_ear="Eabani Earring",
		right_ear="Mimir Earring",
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}
	
		--Set used for Icarus Wing to maximize TP gain
	sets.precast.Wing = {}

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------
	
    sets.precast.WS = {}

    sets.precast.WS['Omniscience'] = {}

	sets.precast.WS['Myrkr'] = {}
	
	sets.precast.WS['Starlight'] = {}
	
	sets.precast.WS['Shell Crusher'] = {}
	
	sets.precast.WS['Rock Crusher'] = {}
	
	sets.precast.WS['Shining Strike'] = {}
	
	sets.precast.WS['Cataclysm'] = {}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC
		
	sets.midcast.Cure = {    
		main="Daybreak",
		sub="Ammurapi Shield",
		ammo="Staunch Tathlum +1",
		head={ name="Kaykaus Mitra +1", augments={'MP+80','Spell interruption rate down +12%','"Cure" spellcasting time -7%',}},
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','"Cure" potency +6%','"Conserve MP"+7',}},
		hands={ name="Peda. Bracers +3", augments={'Enh. "Tranquility" and "Equanimity"',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','Spell interruption rate down +12%','"Cure" spellcasting time -7%',}},
		feet={ name="Kaykaus Boots +1", augments={'MP+80','Spell interruption rate down +12%','"Cure" spellcasting time -7%',}},
		neck="Incanter's Torque",
		waist="Luminary Sash",
		left_ear="Beatific Earring",
		right_ear="Meili Earring",
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}
		
    sets.midcast.LightWeatherCure = set_combine(sets.midcast.Cure, {		
		main="Chatoyant Staff",
		sub="Enki Strap",
		waist="Hachirin-no-Obi",})

    sets.midcast.Curaga = sets.midcast.Cure
	sets.midcast.CuragaWeather = sets.midcast.LightWeatherCure

	sets.Self_Healing = {waist="Gishdubar Sash",left_ring="Kunaji Ring",}
	sets.Cure_Received = {waist="Gishdubar Sash",left_ring="Kunaji Ring",}
	
	sets.midcast.Cursna = {    
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
		
	sets.midcast.StatusRemoval = set_combine(sets.midcast.FastRecast, {})

	sets.midcast['Enhancing Magic'] = {
		main={ name="Musa", augments={'Path: C',}},
		sub="Khonsu",
		ammo="Sapience Orb",
		head={ name="Telchine Cap", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		body={ name="Peda. Gown +4", augments={'Enhances "Enlightenment" effect',}},
		hands={ name="Telchine Gloves", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		legs={ name="Telchine Braconi", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		feet={ name="Telchine Pigaches", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		neck="Orunmila's Torque",
		waist="Embla Sash",
		left_ear="Malignance Earring",
		right_ear="Loquac. Earring",
		left_ring="Kishar Ring",
		right_ring="Prolix Ring",
		back={ name="Fi Follet Cape +1", augments={'Path: A',}},}

    sets.midcast.Regen = {
		main={ name="Musa", augments={'Path: C',}},
		sub="Khonsu",
		ammo="Sapience Orb",
		head="Arbatel Bonnet +3",
		body={ name="Telchine Chas.", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		hands={ name="Telchine Gloves", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		legs={ name="Telchine Braconi", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		feet={ name="Telchine Pigaches", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		neck="Incanter's Torque",
		waist="Embla Sash",
		left_ear="Malignance Earring",
		right_ear="Loquac. Earring",
		left_ring="Kishar Ring",
		right_ring="Prolix Ring",
		back={ name="Bookworm's Cape", augments={'INT+1','MND+2','Helix eff. dur. +20','"Regen" potency+10',}},}
		
    sets.midcast.Regen_Duration = {
		main={ name="Musa", augments={'Path: C',}},
		sub="Khonsu",
		ammo="Sapience Orb",
		head={ name="Telchine Cap", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		body={ name="Telchine Chas.", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		hands={ name="Telchine Gloves", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		legs={ name="Telchine Braconi", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		feet={ name="Telchine Pigaches", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
		neck="Incanter's Torque",
		waist="Embla Sash",
		left_ear="Malignance Earring",
		right_ear="Loquac. Earring",
		left_ring="Kishar Ring",
		right_ring="Prolix Ring",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}

    sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {})
	
	sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {head="Amalric Coif +1"})	
	sets.Refresh_Received = {back="Grapevine Cape",waist="Gishdubar Sash",feet="Inspirited Boots"}
	sets.Self_Refresh = set_combine(sets.midcast['Enhancing Magic'], {back="Grapevine Cape",waist="Gishdubar Sash",feet="Inspirited Boots"})
	
	sets.midcast.Aquaveil = set_combine(sets.midcast['Enhancing Magic'], {head="Amalric Coif +1",hands="Regal Cuffs",})
	
	sets.midcast.BarElement = set_combine(sets.precast.FC['Enhancing Magic'], {})

    sets.midcast.Storm = set_combine(sets.midcast['Enhancing Magic'], {feet="Peda. Loafers +3"})

    -- Custom spell classes

	sets.midcast['Enfeebling Magic'] = {
		main={ name="Bunzi's Rod", augments={'Path: A',}},
		sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
		head="Acad. Mortar. +4",
		body={ name="Cohort Cloak +1", augments={'Path: A',}},
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs="Arbatel Pants +3",
		feet="Acad. Loafers +3",
		neck={ name="Argute Stole +2", augments={'Path: A',}},
		waist={ name="Obstin. Sash", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back={ name="Aurist's Cape +1", augments={'Path: A',}},}
	
    sets.midcast.ElementalEnfeeble = set_combine(sets.midcast['Enfeebling Magic'], {})

	sets.midcast['Dia II'] = sets.midcast['Enfeebling Magic']
	sets.midcast['Bio II'] = sets.midcast['Enfeebling Magic']
	
	sets.midcast['Divine Magic'] = set_combine(sets.midcast['Enfeebling Magic'], {})

    sets.midcast['Dark Magic'] = {
		main={ name="Musa", augments={'Path: C',}},
		sub="Khonsu",
		ammo="Pemphredo Tathlum",
		head="Acad. Mortar. +4",
		body="Acad. Gown +3",
		hands="Acad. Bracers +3",
		legs="Arbatel Pants +3",
		feet="Acad. Loafers +3",
		neck={ name="Argute Stole +2", augments={'Path: A',}},
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back={ name="Aurist's Cape +1", augments={'Path: A',}},}

    sets.midcast.Kaustra = {
		main="Bunzi's Rod",
		sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
		head="Pixie Hairpin +1",
		body={ name="Agwu's Robe", augments={'Path: A',}},
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		legs={ name="Amalric Slops +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		feet={ name="Agwu's Pigaches", augments={'Path: A',}},
		neck={ name="Argute Stole +2", augments={'Path: A',}},
		waist="Skrymir Cord +1",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Freke Ring",
		right_ring="Archon Ring",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}
		
    sets.midcast.Drain = {
		main={ name="Bunzi's Rod", augments={'Path: A',}},
		sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
		head="Pixie Hairpin +1",
		body="Arbatel Gown +3",
		hands="Arbatel Bracers +3",
		legs={ name="Peda. Pants +3", augments={'Enhances "Tabula Rasa" effect',}},
		feet="Agwu's Pigaches",
		neck="Erra Pendant",
		waist="Fucho-no-Obi",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Evanescence Ring",
		right_ring="Archon Ring",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}

    sets.midcast.Aspir = sets.midcast.Drain

    sets.midcast.Stun = sets.midcast['Dark Magic']

    -- Elemental Magic sets are default for handling low-tier nukes.
    sets.midcast['Elemental Magic'] = {
		main={ name="Bunzi's Rod", augments={'Path: A',}},
		sub="Ammurapi Shield",
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head={ name="Agwu's Cap", augments={'Path: A',}},
		body="Arbatel Gown +3",
		hands="Arbatel Bracers +3",
		legs="Arbatel Pants +3",
		feet="Arbatel Loafers +3",
		neck={ name="Argute Stole +2", augments={'Path: A',}},
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Freke Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}
		
	sets.midcast['Elemental Magic'].MagicBurst = {
		main={ name="Bunzi's Rod", augments={'Path: A',}},
		sub="Ammurapi Shield",
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head={ name="Peda. Mortar. +4", augments={'Enh. "Altruism" and "Focalization"',}},
		body={ name="Agwu's Robe", augments={'Path: A',}},
		hands={ name="Agwu's Gages", augments={'Path: A',}},
		legs={ name="Agwu's Slops", augments={'Path: A',}},
		feet="Arbatel Loafers +3",
		neck={ name="Argute Stole +2", augments={'Path: A',}},
		waist="Skrymir Cord +1",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Mujin Band",
		right_ring="Freke Ring",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}
		
	sets.midcast['Elemental Magic'].MagicBurst_Ebullience = {
		main={ name="Bunzi's Rod", augments={'Path: A',}},
		sub="Ammurapi Shield",
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head="Arbatel Bonnet +3",
		body={ name="Agwu's Robe", augments={'Path: A',}},
		hands={ name="Agwu's Gages", augments={'Path: A',}},
		legs={ name="Agwu's Slops", augments={'Path: A',}},
		feet="Arbatel Loafers +3",
		neck={ name="Argute Stole +2", augments={'Path: A',}},
		waist="Skrymir Cord +1",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Mujin Band",
		right_ring="Freke Ring",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}
	
	sets.midcast['Elemental Magic'].Occult_Accumen = {}

	sets.midcast.Helix = {
		main={ name="Bunzi's Rod", augments={'Path: A',}},
		sub="Culminus",
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head={ name="Agwu's Cap", augments={'Path: A',}},
		body="Arbatel Gown +3",
		hands="Arbatel Bracers +3",
		legs={ name="Agwu's Slops", augments={'Path: A',}},
		feet="Arbatel Loafers +3",
		neck={ name="Argute Stole +2", augments={'Path: A',}},
		waist="Skrymir Cord +1",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Freke Ring",
		right_ring="Mallquis Ring",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}

	sets.midcast.Helix.MagicBurst = {
		main={ name="Bunzi's Rod", augments={'Path: A',}},
		sub="Culminus",
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head="Arbatel Bonnet +3",
		body={ name="Agwu's Robe", augments={'Path: A',}},
		hands={ name="Agwu's Gages", augments={'Path: A',}},
		legs="Arbatel Pants +3",
		feet="Arbatel Loafers +3",
		neck={ name="Argute Stole +2", augments={'Path: A',}},
		waist="Skrymir Cord +1",
		left_ear="Crematio Earring",
		right_ear={ name="Arbatel Earring +2", augments={'System: 1 ID: 1676 Val: 0','Mag. Acc.+18','Enmity-8','INT+11 MND+11',}},
		left_ring="Mujin Band",
		right_ring="Mallquis Ring",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}
		
	sets.midcast.Helix.MagicBurst_Ebullience = {
		main={ name="Bunzi's Rod", augments={'Path: A',}},
		sub="Culminus",
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head="Arbatel Bonnet +3",
		body={ name="Agwu's Robe", augments={'Path: A',}},
		hands={ name="Agwu's Gages", augments={'Path: A',}},
		legs={ name="Agwu's Slops", augments={'Path: A',}},
		feet="Arbatel Loafers +3",
		neck={ name="Argute Stole +2", augments={'Path: A',}},
		waist="Skrymir Cord +1",
		left_ear="Crematio Earring",
		right_ear={ name="Arbatel Earring +2", augments={'System: 1 ID: 1676 Val: 0','Mag. Acc.+18','Enmity-8','INT+11 MND+11',}},
		left_ring="Mujin Band",
		right_ring="Mallquis Ring",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}
		
    sets.midcast.DarkHelix = set_combine(sets.midcast.Helix, {left_ring="Archon Ring",})
    sets.midcast.DarkHelix.MagicBurst = set_combine(sets.midcast.Helix.MagicBurst, {right_ring="Archon Ring",})
    sets.midcast.DarkHelix.MagicBurst_Ebullience = set_combine(sets.midcast.Helix.MagicBurst, {head="Arbatel Bonnet +3",right_ring="Archon Ring",})

    sets.midcast.LightHelix = set_combine(sets.midcast.Helix,{main="Daybreak",sub="Ammurapi Shield",})
    sets.midcast.LightHelix.MagicBurst = set_combine(sets.midcast.Helix.MagicBurst,{main="Daybreak",sub="Ammurapi Shield",})
	sets.midcast.LightHelix.MagicBurst_Ebullience = set_combine(sets.midcast.Helix.MagicBurst,{main="Daybreak",sub="Ammurapi Shield",head="Arbatel Bonnet +3",})

	sets.midcast.Impact = {
		main={ name="Musa", augments={'Path: C',}}, 
		sub="Khonsu",
		ammo="Pemphredo Tathlum",
		head=empty, 
		body="Crepuscular Cloak",
		hands="Acad. Bracers +3",
		legs="Arbatel Pants +3",
		feet="Arbatel Loafers +3",
		neck={ name="Argute Stole +2", augments={'Path: A',}},
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Malignance Earring",
		right_ear={ name="Arbatel Earring +2", augments={'System: 1 ID: 1676 Val: 0','Mag. Acc.+18','Enmity-8','INT+11 MND+11',}},
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
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
	
	sets.midcast.RA = {
		main="Mpaca's Staff",
		sub="Khonsu",
		range="Trollbane",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body="Arbatel Gown +3",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Cornelia's Belt",
		left_ear="Eabani Earring",
		right_ear="Mimir Earring",
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------
	
     -- Resting sets
    sets.resting = {
		main={ name="Mpaca's Staff", augments={'Path: A',}},
		sub="Khonsu",
		ammo="Staunch Tathlum +1",
		head="Null Masque",
		body="Arbatel Gown +3",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Carrier's Sash",
		left_ear="Eabani Earring",
		right_ear="Mimir Earring",
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}

	sets.idle = {
		main={ name="Mpaca's Staff", augments={'Path: A',}},
		sub="Khonsu",
		ammo="Staunch Tathlum +1",
		head="Null Masque",
		body="Arbatel Gown +3",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Carrier's Sash",
		left_ear="Eabani Earring",
		right_ear="Mimir Earring",
		left_ring={ name="Stikini Ring +1", bag="wardrobe7" },
		right_ring={ name="Stikini Ring +1", bag="wardrobe8" },
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}
		
		
    sets.latent_refresh = {waist="Fucho-no-obi"}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged = {
		ammo="White Tathlum",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Gazu Bracelets +1",
		legs="Jhakri Slops +2",
		feet="Nyame Sollerets",
		neck="Combatant's Torque",
		waist="Null Belt",
		left_ear="Telos Earring",
		right_ear="Alabaster Earring",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back="Null Shawl",}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
	
    sets.buff['Ebullience'] = {head="Arbatel Bonnet +3"}
    sets.buff['Rapture'] = {head="Arbatel Bonnet +3"}
    sets.buff['Perpetuance'] = {hands="Arbatel Bracers +3"}
    sets.buff['Immanence'] = {hands="Arbatel Bracers +3"}
    sets.buff['Penury'] = {legs="Arbatel Pants +3"}
    sets.buff['Parsimony'] = {legs="Arbatel Pants +3"}
	sets.buff['Focalization'] = {}
    sets.buff['Celerity'] = {}
    sets.buff['Alacrity'] = {}
    sets.buff['Klimaform'] = {feet="Arbatel Loafers +3"}
	sets.buff['Light Arts'] = {} --legs="Academic's Pants +3"
	sets.buff['Dark Arts'] = {} --body="Academic's Gown +3"
	
    sets.buff.Sublimation = {
		head="Acad. Mortar. +4", --4
		body={ name="Peda. Gown +4", augments={'Enhances "Enlightenment" effect',}}, --5
		waist="Embla Sash",} --5
	
	sets.buff.Doom = set_combine(sets.buff.Doom, {neck="Nicander's Necklace",waist="Gishdubar Sash"})
	
	sets.Kiting = {left_ring="Shneddick Ring"}
		
	sets.TreasureHunter = {
		body="Volte Jupon",
		hands="Volte Bracers",
		waist="Chaac Belt",}
		
	sets.midcast.Dia = set_combine(sets.midcast['Enfeebling Magic'], sets.TreasureHunter)
	sets.midcast['Dia'] = set_combine(sets.midcast['Enfeebling Magic'], sets.TreasureHunter)
	sets.midcast.Diaga = set_combine(sets.midcast['Enfeebling Magic'], sets.TreasureHunter)
	sets.midcast.Bio = set_combine(sets.midcast['Enfeebling Magic'], sets.TreasureHunter)
	
	--Weapon Sets
	
	sets.weapons.Maxentius = {main="Maxentius",}
	sets.weapons.Xoanon = {main="Xoanon"}	
	sets.weapons.Opashoro = {main="Elder Staff",}--{main="Opashoro",}
	
	sets.Daybreak = {sub="Daybreak",}
	
	sets.Khonsu = {sub="Khonsu"}
	sets.Ultio = {sub="Ultio Grip"}
	
	sets.Genmei = {sub="Genmei Shield",}
	sets.Ammurapi = {sub="Ammurapi Shield",}
	
	
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 18)
end

function user_job_lockstyle()
    send_command('input /lockstyleset ' .. lockstyleset)
end