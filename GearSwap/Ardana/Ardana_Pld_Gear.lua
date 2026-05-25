function user_job_setup()

	-- Options: Override default values	
	state.OffenseMode:options('Normal','Acc')
	state.WeaponskillMode:options('Normal', 'Acc')
	state.HybridMode:options('Normal', 'DT')
	state.CastingMode:options('Normal','SIRD')
	state.IdleMode:options('Normal', 'Aminon', 'Refresh')
	state.Weapons:options('Sakpata', 'Excalibur', 'Onion', 'Naegling', 'Burtgang')
	
	state.Shield = M{['description']='Shield Set', 'Duban', 'Aegis'}
	state.WeaponLock = M(false, 'Weapon Lock')
    state.Reraise = M(false, "Reraise Mode")
	
	state.RuneElement = M{['description']='RuneElement', 'Lux', 'Tenebrae', 'Ignis', 'Gelus', 'Flabra', 'Tellus', 'Sulpor', 'Unda'}
	state.Barspell = M{['description']='Barspell', '"Barfire"', '"Barblizzard"', '"Baraero"', '"Barstone"','"Barthunder"', '"Barwater"',}
	
	
	if player.sub_job == 'RUN' then
		init_job_states({},{"RuneElement","Barspell","Weapons","Shield","OffenseMode","WeaponLock","WeaponskillMode","IdleMode","CastingMode","TreasureMode","Reraise",})
		send_command('wait 5; bind ^` gs c RuneElement')
		send_command('wait 5; bind ^= gs c cycle RuneElement')
		send_command('wait 5; bind ^- gs c cycleback RuneElement')
		send_command('wait 5; bind !` gs c Barspell')
		send_command('wait 5; bind !- gs c cycleback Barspell')
		send_command('wait 5; bind != gs c cycle Barspell')
	elseif player.sub_job == 'SCH' then
		init_job_states({},{"Weapons","Shield","OffenseMode","WeaponLock","WeaponskillMode","IdleMode","CastingMode","TreasureMode","Reraise",})
		send_command('wait 5; bind ^` input /ja "Accession" <me>')
		send_command('wait 5; bind ^= input /ja "Addendum: White" <me>')
		send_command('wait 5; bind ^- input /ja "Light Arts" <me>')
		send_command('wait 5; bind !` input /ja "Sublimation" <me>')
		send_command('wait 5; bind !- input /ma "Sneak" <stpc>')
		send_command('wait 5; bind != input /ma "Invisible" <stpc>')
	else
		init_job_states({},{"Weapons","Shield","OffenseMode","WeaponLock","WeaponskillMode","IdleMode","CastingMode","TreasureMode","Reraise",})
	end
	
	--Includes Global Bind keys
	
	send_command('wait 2; exec Global-Binds.txt')
	
	--Paladin Binds
	
	send_command('wait 2; exec /PLD/Binds.txt')
	
	--Retrieve Gear for Paladin
	
	send_command('wait 3;org get inventory pld.lua')	
	
	lockstyleset = 7	
	select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
	enable('main','sub','range','ammo','head','body','hands','legs','feet','neck','waist','left_ear','right_ear','left_ring','right_ring','back')

	--Remove Global Binds

	send_command('wait 1; exec Global-UnBinds.txt')
	
	--Remove Gear for Paladin
	
	send_command('wait 1; org get Store.lua')
	
end

function init_gear_sets()
	
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
	
	sets.Enmity = {
		ammo="Sapience Orb",
		head={ name="Loess Barbuta +1", augments={'Path: A',}},
		body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		feet="Chev. Sabatons +3",
		neck="Moonlight Necklace",
		waist="Creed Baudrier",
		left_ear="Cryptic Earring",
		right_ear="Trux Earring",
		left_ring="Supershear Ring",
		right_ring="Eihwaz Ring",
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}
		
	sets.Enmity.SIRD = {
		ammo="Staunch Tathlum +1",
		head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		body="Chev. Cuirass +3",
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Founder's Hose", augments={'MND+5','Mag. Acc.+2','Breath dmg. taken -2%',}},
		feet="Chev. Sabatons +3",
		neck="Moonlight Necklace",
		waist="Creed Baudrier",
		left_ear="Cryptic Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Eihwaz Ring",
		right_ring="Murky Ring",
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}
		
	-- Precast sets to enhance JAs
	sets.precast.JA['Invincible'] = set_combine(sets.Enmity,{legs={ name="Cab. Breeches +3", augments={'Enhances "Invincible" effect',}},})
	sets.precast.JA['Holy Circle'] = set_combine(sets.Enmity,{feet="Rev. Leggings +3",})
	sets.precast.JA['Sentinel'] = set_combine(sets.Enmity,{feet={ name="Cab. Leggings +3", augments={'Enhances "Guardian" effect',}},})
	sets.precast.JA['Rampart'] = set_combine(sets.Enmity,{head={ name="Cab. Coronet +3", augments={'Enhances "Iron Will" effect',}},})
	sets.precast.JA['Fealty'] = set_combine(sets.Enmity,{body={ name="Cab. Surcoat +3", augments={'Enhances "Fealty" effect',}},})
	sets.precast.JA['Divine Emblem'] = set_combine(sets.Enmity,{feet="Chev. Sabatons +3",})
	sets.precast.JA['Cover'] = set_combine(sets.Enmity,{body={ name="Cab. Surcoat +3", augments={'Enhances "Fealty" effect',}},})
	
	sets.precast.JA['Chivalry'] = set_combine(sets.Enmity,{hands={ name="Cab. Gauntlets +3", augments={'Enhances "Chivalry" effect',}},})

	sets.precast.JA['Shield Bash'] = set_combine(sets.Enmity,{hands={ name="Cab. Gauntlets +3", augments={'Enhances "Chivalry" effect',}},})
	sets.precast.JA['Palisade'] = set_combine(sets.Enmity, {})
	sets.precast.JA['Intervene'] = set_combine(sets.Enmity, {})
	
	sets.precast.JA['Provoke'] = set_combine(sets.Enmity, {})
	sets.precast.JA['Warcry'] = set_combine(sets.Enmity, {})	
	sets.precast.JA['Defender'] = set_combine(sets.Enmity, {})
	sets.precast.JA['Berserk'] = set_combine(sets.Enmity, {})
	sets.precast.JA['Aggressor'] = set_combine(sets.Enmity, {})
	
	-- Waltz set (chr and vit)
	sets.precast.Waltz = {}
		
	-- Don't need any special gear for Healing Waltz.
	sets.precast.Waltz['Healing Waltz'] = {}
	
	sets.precast.Step = {}
		
	sets.precast.JA['Violent Flourish'] = {}
		
	sets.precast.JA['Animated Flourish'] = set_combine(sets.Enmity, {})

	-- Fast cast sets for spells
	
	sets.precast.FC = {
		ammo="Sapience Orb",
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body="Rev. Surcoat +4",
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs="Sworn Brais",
		feet="Chev. Sabatons +3",
		neck="Orunmila's Torque",
		waist="Plat. Mog. Belt",
		left_ear="Loquac. Earring",
		right_ear="Etiolation Earring",
		left_ring="Kishar Ring",
		right_ring="Moonlight Ring",
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','"Fast Cast"+10','Phys. dmg. taken-10%',}},}
		
	sets.precast.FC.Cure = set_combine(sets.precast.FC, {
        ammo="Sapience Orb",
        head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
        body="Volte Jupon",
        hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
        legs="Enif Cosciales",
        feet="Chev. Sabatons +3",
        neck="Orunmila's Torque",
        waist="Audumbla Sash",
        left_ear="Loquac. Earring",
        right_ear="Mendi. Earring",
        left_ring="Kishar Ring",
        right_ring="Prolix Ring",
        back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','"Fast Cast"+10','Phys. dmg. taken-10%',}},}) 
	
		--Set used for Icarus Wing to maximize TP gain	
	sets.precast.Wing = {}
	
	sets.precast.Volte_Harness = set_combine(sets.precast.Wing, {body="Volte Harness"})
	sets.precast.Prishes_Boots = set_combine(sets.precast.Wing, {feet="Prishe\'s Boots +1",})
  
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
		neck="Rep. Plat. Medal",
		waist="Sailfi Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Moonshade Earring",
		left_ring="Regal Ring",
		right_ring="Ephramad's Ring",
		back={ name="Rudianos's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Savage Blade'] = {
		ammo="Coiste Bodhar",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Rep. Plat. Medal",
		waist="Sailfi Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Moonshade Earring",
		left_ring="Regal Ring",
		right_ring="Ephramad's Ring",
		back={ name="Rudianos's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Knights of Round'] = {
		ammo="Coiste Bodhar",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Rep. Plat. Medal",
		waist="Sailfi Belt +1",
		left_ear="Alabaster Earring",
		right_ear="Thrud Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Ephramad's Ring",
		back={ name="Rudianos's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

	sets.precast.WS['Fast Blade II'] = {
	    ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Sakpata's Plate", augments={'Path: A',}},
		hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
		legs={ name="Sakpata's Cuisses", augments={'Path: A',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Rep. Plat. Medal",
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		left_ring="Regal Ring",
		right_ring="Ephramad's Ring",
		back={ name="Rudianos's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS.Acc = {}

	-- Swap to these on Moonshade using WS if at 3000 TP
	sets.MaxTP = {left_ear="Sherida Earring",}
	sets.AccMaxTP = {left_ear="Sherida Earring",}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	sets.midcast.FastRecast = {}
		
	sets.midcast.Flash = set_combine(sets.Enmity, {})
	sets.midcast.Flash.SIRD = set_combine(sets.Enmity.SIRD, {})
	sets.midcast.Stun = set_combine(sets.Enmity, {})
	sets.midcast.Stun.SIRD = set_combine(sets.Enmity.SIRD, {})
	sets.midcast['Blue Magic'] = set_combine(sets.Enmity, {})
	sets.midcast['Blue Magic'].SIRD = set_combine(sets.Enmity.SIRD, {})
	sets.midcast.Cocoon = set_combine(sets.Enmity.SIRD, {})
	
	sets.midcast['Banishga'] = sets.Enmity.SIRD

	sets.midcast.Cure = {
		ammo="Staunch Tathlum +1",
		head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		body="Rev. Surcoat +4",
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Founder's Hose", augments={'MND+5','Mag. Acc.+2','Breath dmg. taken -2%',}},
		feet={ name="Odyssean Greaves", augments={'Mag. Acc.+14','"Fast Cast"+6','VIT+2','"Mag.Atk.Bns."+12',}},
		neck="Moonlight Necklace",
		waist="Sroda Belt",
		left_ear="Alabaster Earring",
		right_ear={ name="Chev. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','Damage taken-5%',}},
		left_ring="Gelatinous Ring +1",
		right_ring={ name="Moonlight Ring", bag="wardrobe8" },
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','"Fast Cast"+10','Phys. dmg. taken-10%',}},}
		
	sets.midcast.Cure.SIRD = {
		ammo="Staunch Tathlum +1",
		head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		body="Rev. Surcoat +4",
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Founder's Hose", augments={'MND+5','Mag. Acc.+2','Breath dmg. taken -2%',}},
		feet={ name="Odyssean Greaves", augments={'Mag. Acc.+14','"Fast Cast"+6','VIT+2','"Mag.Atk.Bns."+12',}},
		neck="Moonlight Necklace",
		waist="Sroda Belt",
		left_ear="Alabaster Earring",
		right_ear={ name="Chev. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','Damage taken-5%',}},
		left_ring="Gelatinous Ring +1",
		right_ring={ name="Moonlight Ring", bag="wardrobe8" },
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','"Fast Cast"+10','Phys. dmg. taken-10%',}},}
		
	sets.Self_Healing = {
        ammo="Staunch Tathlum +1",
        head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        body="Rev. Surcoat +4",
        hands="Regal Gauntlets",
        legs={ name="Founder's Hose", augments={'MND+5','Mag. Acc.+2','Breath dmg. taken -2%',}},
        feet={ name="Odyssean Greaves", augments={'Mag. Acc.+14','"Fast Cast"+6','VIT+2','"Mag.Atk.Bns."+12',}},
        neck="Unmoving Collar +1",
        waist="Sroda Belt",
        left_ear="Alabaster Earring",
        right_ear={ name="Chev. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','Damage taken-5%',}},
        left_ring="Gelatinous Ring +1",
        right_ring="Murky Ring",
        back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','"Fast Cast"+10','Phys. dmg. taken-10%',}},}
		
	sets.Self_Healing.SIRD = {
        ammo="Staunch Tathlum +1",
        head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        body="Rev. Surcoat +4",
        hands="Regal Gauntlets",
        legs={ name="Founder's Hose", augments={'MND+5','Mag. Acc.+2','Breath dmg. taken -2%',}},
        feet={ name="Odyssean Greaves", augments={'Mag. Acc.+14','"Fast Cast"+6','VIT+2','"Mag.Atk.Bns."+12',}},
        neck="Unmoving Collar +1",
        waist="Sroda Belt",
        left_ear="Alabaster Earring",
        right_ear={ name="Chev. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','Damage taken-5%',}},
        left_ring="Gelatinous Ring +1",
        right_ring="Murky Ring",
        back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','"Fast Cast"+10','Phys. dmg. taken-10%',}},}
		
	sets.Cure_Received = {
		head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},}
		
	sets.midcast['Enhancing Magic'] = {
	    ammo="Sapience Orb",
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body="Shab. Cuirass +1",
		hands="Regal Gauntlets",
		legs="Enif Cosciales",
		feet="Chev. Sabatons +3",
		neck="Baetyl Pendant",
		waist="Plat. Mog. Belt",
		left_ear="Etiolation Earring",
		right_ear="Tuisto Earring",
		left_ring="Gelatinous Ring +1",
		right_ring="Kishar Ring",
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','"Fast Cast"+10','Phys. dmg. taken-10%',}},}
		
	sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {
	    ammo="Sapience Orb",
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body="Shab. Cuirass +1",
		hands="Regal Gauntlets",
		legs="Sworn Brais",
		feet="Chev. Sabatons +3",
		neck="Orunmila's Torque",
		waist="Siegel Sash",
		left_ear="Etiolation Earring",
		right_ear="Tuisto Earring",
		left_ring="Gelatinous Ring +1",
		right_ring="Moonlight Ring",
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','"Fast Cast"+10','Phys. dmg. taken-10%',}},})

	sets.midcast.Phalanx = {
		main={ name="Sakpata's Sword", augments={'Path: A',}},
		sub={ name="Priwen", augments={'HP+50','Mag. Evasion+50','Damage Taken -3%',}},
		ammo="Staunch Tathlum +1",
		head={ name="Yorium Barbuta", augments={'DEF+21','Spell interruption rate down -10%','Phalanx +3',}},
		body="Sworn Platemail",
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Sakpata's Cuisses", augments={'Path: A',}},
		feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		neck="Moonlight Necklace",
		waist="Audumbla Sash",
		left_ear="Mimir Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring={ name="Moonlight Ring", bag="wardrobe8" },
		back={ name="Weard Mantle", augments={'VIT+1','DEX+3','Enmity+2','Phalanx +5',}},}
	
	sets.Phalanx_Received = {
		main={ name="Sakpata's Sword", augments={'Path: A',}},
		sub={ name="Priwen", augments={'HP+50','Mag. Evasion+50','Damage Taken -3%',}},
		head={ name="Yorium Barbuta", augments={'DEF+21','Spell interruption rate down -10%','Phalanx +3',}},
		body="Sworn Platemail",
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Sakpata's Cuisses", augments={'Path: A',}},
		feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		back={ name="Weard Mantle", augments={'VIT+1','DEX+3','Enmity+2','Phalanx +5',}},}
		
	sets.Refresh_Received = {waist="Gishdubar Sash"}
		
	sets.midcast.Reprisal = {
		ammo="Sapience Orb",
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body="Shab. Cuirass +1",
		hands="Regal Gauntlets",
		legs="Sworn Brais",
		feet="Chev. Sabatons +3",
		neck="Orunmila's Torque",
		waist="Plat. Mog. Belt",
		left_ear="Loquac. Earring",
		right_ear="Etiolation Earring",
		left_ring="Kishar Ring",
		right_ring="Prolix Ring",
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','"Fast Cast"+10','Phys. dmg. taken-10%',}},}
		
    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

	sets.resting = {
		main={ name="Sakpata's Sword", augments={'Path: A',}},
		sub={ name="Priwen", augments={'HP+50','Mag. Evasion+50','Damage Taken -3%',}},
		head={ name="Yorium Barbuta", augments={'DEF+21','Spell interruption rate down -10%','Phalanx +3',}},
		body="Sworn Platemail",
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Sakpata's Cuisses", augments={'Path: A',}},
		feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		back={ name="Weard Mantle", augments={'VIT+1','DEX+3','Enmity+2','Phalanx +5',}},}

	-- Idle sets
	-- The priority is there because of the cure set so your hp doesnt dip after you cure yourself
    sets.idle = {
		ammo="Staunch Tathlum +1",
		head="Null Masque",
		body="Adamantite Armor",
		hands="Sworn Gauntlets",
		legs="Sworn Brais",
		feet="Sakpata's Leggings",
		neck="Warder's Charm +1",
		waist="Carrier's Sash",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Gelatinous Ring +1",
		right_ring="Shadow Ring",
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}
		
	sets.idle.Aminon = {
		ammo="Vanir Battery",
		head="Null Masque",
		body="Adamantite Armor",
		hands="Nyame Gauntlets",
		legs="Sworn Brais",
		feet="Nyame Sollerets",
		neck="Coatl Gorget +1",
		waist="Carrier's Sash",
		left_ear="Alabaster Earring",
		right_ear="Lugra Earring +1",
		left_ring="Vexer Ring +1",
		right_ring="Metamor. Ring +1",
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}
		
    sets.idle.Refresh = {
		ammo="Staunch Tathlum +1",
		head="Null Masque",
		body="Crepuscular Mail",
		hands="Regal Gauntlets",
		legs="Chev. Cuisses +3",
		feet="Sakpata's Leggings",
		neck="Warder's Charm +1",
		waist="Carrier's Sash",
		left_ear="Alabaster Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}
		
	sets.idle.Aminon.rollers = set_combine(sets.idle.Aminon, {right_ring="Roller's Ring",})
	
	--To prevent Duban from killing you over and over add regen to this.
	sets.idle.Town = set_combine(sets.idle, {left_ring={ name="Chirich Ring +1", bag="wardrobe7" },})

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged = {
		ammo="Staunch Tathlum +1",
		head="Null Masque",
		body="Adamantite Armor",
		hands="Sworn Gauntlets",
		legs="Sworn Brais",
		feet="Sakpata's Leggings",
		neck="Warder's Charm +1",
		waist="Carrier's Sash",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Gelatinous Ring +1",
		right_ring="Shadow Ring",
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}
		
	sets.engaged.Acc = {
		ammo="Staunch Tathlum +1",
		head="Null Masque",
		body="Adamantite Armor",
		hands="Sworn Gauntlets",
		legs="Sworn Brais",
		feet="Sakpata's Leggings",
		neck="Warder's Charm +1",
		waist="Carrier's Sash",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Gelatinous Ring +1",
		right_ring="Shadow Ring",
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}
		
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid	= {
		ammo="Staunch Tathlum +1",
		head="Null Masque",
		body="Adamantite Armor",
		hands="Sworn Gauntlets",
		legs="Sworn Brais",
		feet="Sakpata's Leggings",
		neck="Warder's Charm +1",
		waist="Carrier's Sash",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Gelatinous Ring +1",
		right_ring="Shadow Ring",
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}
		
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	sets.Kiting = {right_ring="Shneddick Ring",}
	
	--sets.latent_refresh = {waist="Fucho-no-obi"}

	sets.TreasureHunter = {
		body="Volte Jupon",
		hands="Volte Bracers",
		waist="Chaac Belt",}

	sets.buff.Doom = set_combine(sets.buff.Doom, {neck="Nicander's Necklace", waist="Gishdubar Sash",})
	sets.buff.Sleep = {neck="Vim Torque +1"}
	sets.buff.Cover = {body="Cab. Surcoat +3"}
	
	sets.Reraise = {head="Crepuscular Helm",body="Crepuscular Mail",}
	
	--Weapon Sets

    sets.weapons.Burtgang = {main="Burtgang",}
    sets.weapons.Excalibur = {main="Excalibur"}
	sets.weapons.Naegling = {main="Naegling"}
	sets.weapons.Sakpata = {main={ name="Sakpata's Sword", augments={'Path: A',}},}
	sets.weapons.Onion = {main="Onion Sword III"}
	
	--Shield Sets

	sets.Priwen = {sub={ name="Priwen", augments={'HP+50','Mag. Evasion+50','Damage Taken -3%',}},}
	sets.Duban = {sub="Duban",}
	sets.Aegis = {sub="Aegis",}
		
end

-- Default macro set/book
function select_default_macro_book()
    -- Default macro set/book
	if player.sub_job == 'SCH' then
        set_macro_page(10, 7)
    else
		set_macro_page(1, 7)
    end
end

function user_job_lockstyle()
    send_command('input /lockstyleset ' .. lockstyleset)
end