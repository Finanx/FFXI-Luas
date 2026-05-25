function user_job_setup()
	-- Options: Override default values
	state.OffenseMode:options('Normal', 'Acc')
	state.WeaponskillMode:options('Normal','Acc')
	state.HybridMode:options('Normal')
	state.IdleMode:options('Normal')
	state.Weapons:options('Montante','Anguta')
	state.ExtraMeleeMode = M{['description']='Extra Melee Mode','None'}
	state.Passive = M{['description'] = 'Passive Mode','None','MP','Twilight'}
	state.DrainSwapWeaponMode = M{'Always','Never','300','1000'}
	
	state.Reraise = M(false, "Reraise Mode")

	Two_Handed_Weapons = {
		Xoanon   = true,
		Musa     = true,
		Opashoro = true,}
		
	One_Handed_Weapons = {
		Maxentius = true,}
		
	--Includes Global Bind keys
	
	send_command('wait 2; exec Global-Binds.txt')

    --Summoner binds

	send_command('wait 2; exec /DRK/Binds.txt')
	
	--Retrieve Gear for Summoner
	
	send_command('wait 3;org get inventory drk.lua')

	--Job settings

	lockstyleset = 8
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
	--------------------------------------
	-- Start defining the sets
	--------------------------------------
	-- Precast Sets
	-- Precast sets to enhance JAs
	sets.precast.JA['Diabolic Eye'] = {}
	sets.precast.JA['Arcane Circle'] = {}
	sets.precast.JA['Souleater'] = {}
	sets.precast.JA['Weapon Bash'] = {}
	sets.precast.JA['Nether Void'] = {}
	sets.precast.JA['Blood Weapon'] = {}
	sets.precast.JA['Dark Seal'] = {}
	sets.precast.JA['Last Resort'] = {back="Ankou's Mantle"}
				   
	-- Waltz set (chr and vit)
	sets.precast.Waltz = {}
				   
	-- Don't need any special gear for Healing Waltz.
	sets.precast.Waltz['Healing Waltz'] = {}
		   
	sets.precast.Step = {}
	
	sets.precast.Flourish1 = {}
		   
	-- Fast cast sets for spells

	sets.precast.FC = {}

	sets.precast.FC.Impact = set_combine(sets.precast.FC, {head=empty,body="Crepuscular Cloak"})
		
	-- Midcast Sets
	sets.midcast.FastRecast = {}
				   
	-- Specific spells
 
	sets.midcast['Dark Magic'] = {}
		   
	sets.midcast['Enfeebling Magic'] = {}
		   
	sets.midcast['Dread Spikes'] = set_combine(sets.midcast['Dark Magic'], {})
	sets.midcast.Absorb = set_combine(sets.midcast['Dark Magic'], {})
		   
	sets.midcast.Stun = {}
				   
	sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {})
	
	sets.DrainWeapon = {}
	
	--sets.AbsorbWeapon = {main="Liberator",sub="Khonsu",range="Ullr",ammo=empty}
	--sets.DreadWeapon = {main="Crepuscular Scythe",sub="Utu Grip",} 	
				   
	sets.midcast.Aspir = sets.midcast.Drain
	
	sets.midcast.Impact = set_combine(sets.midcast['Dark Magic'], {head=empty,body="Crepuscular Cloak"})
	
	sets.midcast.Cure = {}
	
	sets.Self_Healing = {neck="Phalaina Locket",hands="Buremte Gloves",ring2="Kunaji Ring",waist="Gishdubar Sash"}
	sets.Cure_Received = {neck="Phalaina Locket",hands="Buremte Gloves",ring2="Kunaji Ring",waist="Gishdubar Sash"}
	sets.Self_Refresh = {waist="Gishdubar Sash"}
						                   
	-- Weaponskill sets
	-- Default set for any weaponskill that isn't any more specifically defined
	sets.precast.WS = {}

	sets.precast.WS.Acc = set_combine(sets.precast.WS, {})
 

	-- Swap to these on Moonshade using WS if at 3000 TP
	sets.MaxTP = {ear1="Lugra Earring +1",ear2="Lugra Earring",}
	sets.AccMaxTP = {ear1="Mache Earring +1",ear2="Telos Earring"}
	sets.AccDayMaxTPWSEars = {ear1="Mache Earring +1",ear2="Telos Earring"}
	sets.DayMaxTPWSEars = {ear1="Ishvara Earring",ear2="Brutal Earring",}
	sets.AccDayWSEars = {ear1="Mache Earring +1",ear2="Telos Earring"}
	sets.DayWSEars = {ear1="Brutal Earring",ear2="Moonshade Earring",}	
		   
	 -- Sets to return to when not performing an action.
		   
	 -- Resting sets
	 sets.resting = {}
		   

	 
			-- Idle sets
		   
	sets.idle = {}
		   
	

	-- Engaged sets
	sets.engaged = {
	    ammo="Coiste Bodhar",
		head="Hjarrandi Helm",
		body="Sakpata's Plate",
		hands="Sakpata's Gauntlets",
		legs="Volte Tights",
		feet="Sakpata's Leggings",
		neck="Vim Torque +1",
		waist="Sailfi Belt +1",
		left_ear="Telos Earring",
		right_ear="Alabaster Earring",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back="Null Shawl",}

	sets.engaged.Acc = {}

	sets.Kiting = {left_ring="Shneddick Ring",}
	
	sets.Reraise = {head="Crepuscular Helm",body="Crepuscular Mail"}
	
	sets.buff['Dark Seal'] = {} --head="Fallen's Burgeonet +3"
	sets.buff.Souleater = {}
	sets.buff.Doom = set_combine(sets.buff.Doom, {})
	sets.buff.Sleep = {}
	sets.TreasureHunter = set_combine(sets.TreasureHunter, {})
	
	-- Weapons sets
	sets.weapons.Montante = {main="Montante +1",sub="Utu Grip"}
	sets.weapons.Anguta = {main="Anguta",sub="Utu Grip"}
	
	end
	
-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 8)
end

function user_job_lockstyle()
    send_command('input /lockstyleset ' .. lockstyleset)
end