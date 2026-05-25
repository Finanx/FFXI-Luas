function user_job_setup()
	-- Options: Override default values
	state.OffenseMode:options('Normal')
	state.HybridMode:options('Normal','DT')
	state.WeaponskillMode:options('Normal')
	state.CastingMode:options('Normal','MagicBurst','OccultAcumen')
	state.IdleMode:options('Normal')
	state.Weapons:options('None','Mpaca', 'Hvergelmir', 'Laevateinn', 'Opashoro', 'Maxentius')
	state.Subweapon = M{['description']='Sub Weapon Set', 'Daybreak'}
	state.Shield = M{['description']='Shield Set', 'Ammurapi', 'Genmei'}
	
	state.SpellInterrupt = M(false, 'SpellInterrupt') --Only applies to Curing
	
	state.AutoCoatMode = M{['description']='CoatMode', '30', '50', '70', 'OFF'}-- = M(true, 'AutoCoatMode') --Uses RecoverMP elemental magic sets @ 30% MP and lower
	
	init_job_states({},{"Weapons","OffenseMode","WeaponskillMode","IdleMode","CastingMode","AutoCoatMode","SpellInterrupt","TreasureMode",})
	
	Two_Handed_Weapons = {
		Xoanon   = true,
		Musa     = true,
		Opashoro = true,}
		
	One_Handed_Weapons = {
		Maxentius = true,}


	--Includes Global Bind keys
	
	send_command('wait 2; exec Global-Binds.txt')

    --Black Mage binds	

	send_command('wait 2; exec /BLM/Binds.txt')
	
	--Retrieve Gear for Black Mage
	
	send_command('wait 3;org get inventory blm.lua')

	--Job settings

	lockstyleset = 4
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

function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
	
	-- Precast Sets
	
	-- Precast sets to enhance JAs
	sets.precast.JA['Mana Wall'] = {back=gear.nuke_jse_back,feet="Wicce Sabots +3"}
	sets.precast.JA.Manafont = {} --body="Sorcerer's Coat +2"

	-- Fast cast sets for spells
	sets.precast.FC = {}
		
	sets.precast.FC.DT = {}
		
	sets.precast.FC.Dispelga = set_combine(sets.precast.FC, {main="Daybreak",sub="Genmei Shield"})
	
	sets.precast.FC.Death = {}

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------
	
	sets.precast.WS = {}

	sets.precast.WS['Myrkr'] = {}
		
	sets.MaxTPMyrkr = {}
	
	
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
	
	sets.midcast.FastRecast = sets.precast.FC

	sets.midcast.Cure = {}
	
	sets.midcast.LightWeatherCure	= set_combine(sets.midcast.Cure, {})

	sets.midcast.Curaga = {}
		
	sets.midcast.CuragaWeather = set_combine(sets.midcast.Curaga, {})
	
	sets.midcast.Cure_SpellInterrupt = {}

	--Situational Healing Sets
	sets.Self_Healing = {waist="Gishdubar Sash",left_ring="Kunaji Ring",}
	sets.Cure_Received = {waist="Gishdubar Sash",left_ring="Kunaji Ring",}
	CureSelfWeather = LightWeatherCure
		
	sets.midcast.Cursna =  {}
	
	sets.midcast.StatusRemoval = set_combine(sets.midcast.FastRecast, {})

	sets.midcast['Enhancing Magic'] = {}
	
	sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {neck="Nodens Gorget",waist="Siegel Sash"}) --ear2="Earthcry Earring",legs="Shedir Seraweels"
	
	sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {head="Amalric Coif +1"})
	
	sets.midcast.Aquaveil = set_combine(sets.midcast['Enhancing Magic'], {head="Amalric Coif +1",hands="Regal Cuffs",})
	
	sets.midcast.BarElement = set_combine(sets.precast.FC['Enhancing Magic'], {})--legs="Shedir Seraweels"

	sets.midcast['Enfeebling Magic'] = {}
		
	sets.midcast['Enfeebling Magic'].Resistant = {}
		
	sets.midcast.ElementalEnfeeble = {}
		
	sets.midcast['Divine Magic'] = set_combine(sets.midcast['Enfeebling Magic'], {})

	sets.midcast['Dark Magic'] = {}

	sets.midcast.Drain = {}
		
	sets.midcast.Drain.Resistant = {}
	
	sets.midcast.Aspir = sets.midcast.Drain
	sets.midcast.Aspir.Resistant = sets.midcast.Drain.Resistant
	
	sets.midcast.Stun = {}
		
	sets.midcast.Stun.Resistant = {}

	sets.midcast.BardSong = {}

	-- Elemental Magic sets
	
	sets.midcast['Elemental Magic'] = {ammo="Sapience Orb",}
		
	sets.midcast['Elemental Magic'].MagicBurst = {}
	
	sets.midcast['Elemental Magic'].OccultAcumen = {}
	
	sets.midcast['Elemental Magic'].RecoverMP = {ammo="Staunch Tathlum +1",}
		
	sets.midcast['Elemental Magic'].MagicBurst.RecoverMP = {}
	
	sets.midcast['Elemental Magic'].OccultAcumen.RecoverMP = {}
	
	sets.midcast.Comet = {ammo="Pemphredo Tathlum",}
	
	sets.midcast.Death = {ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},}
		
	sets.midcast.Impact = {}
	
	sets.midcast.Helix = {}
		
	sets.midcast.Impact.OccultAcumen = set_combine(sets.midcast['Elemental Magic'].OccultAcumen, {head=empty,body="Crepuscular Cloak"})
	
	-- Gear that converts elemental damage done to recover MP.
	sets.RecoverMP = {body="Spaekona's Coat +2"}

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------
	
	-- Resting sets
	sets.resting = {}

	-- Idle sets

	sets.idle = {}

	sets.idle.Death = {}

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
		
	sets.engaged.DT = {}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
	
	sets.buff['Mana Wall'] = {back=gear.nuke_jse_back,feet="Wicce Sabots +3"}
	
	sets.latent_refresh = {waist="Fucho-no-obi"}
	sets.latent_refresh_grip = {sub="Oneiros Grip"}
	sets.TPEat = {neck="Chrys. Torque"}

	sets.Kiting = {left_ring="Shneddick Ring"}
	
	sets.buff.Doom = set_combine(sets.buff.Doom, {neck="Nicander's Necklace",waist="Gishdubar Sash"})
		
	sets.TreasureHunter = {
		body="Volte Jupon",
		hands="Volte Bracers",
		waist="Chaac Belt",}
		
	sets.midcast.Dia = set_combine(sets.midcast['Enfeebling Magic'], sets.TreasureHunter)
	sets.midcast['Dia II'] = set_combine(sets.midcast['Enfeebling Magic'], sets.TreasureHunter)
	
	sets.midcast.Bio = set_combine(sets.midcast['Enfeebling Magic'], sets.TreasureHunter)
	sets.midcast['Bio II'] = set_combine(sets.midcast['Enfeebling Magic'], sets.TreasureHunter)
		
	sets.buff.Sublimation = {waist="Embla Sash"}

	--Situational sets: Gear that is equipped on certain targets
	sets.Self_Healing = {neck="Phalaina Locket",ring1="Kunaji Ring",waist="Gishdubar Sash"}
	sets.Cure_Received = {neck="Phalaina Locket",ring1="Kunaji Ring",waist="Gishdubar Sash"}
	sets.Self_Refresh = {back="Grapevine Cape",waist="Gishdubar Sash",feet="Inspirited Boots"}
	
	--Weapon Sets
	
	sets.weapons.Mpaca = {main="Mpaca's Staff",}
	sets.weapons.Hvergelmir = {main="Hvergelmir",}
	sets.weapons.Laevateinn = {main="Laevateinn",}
	sets.weapons.Opashoro = {main="Opashoro",}
	sets.weapons.Xoanon = {main="Xoanon"}
	sets.weapons.Maxentius = {main="Maxentius",}
	
	sets.Daybreak = {sub="Daybreak",}
	
	sets.Khonsu = {sub="Khonsu"}
	sets.Ultio = {sub="Ultio Grip"}
	
	sets.Genmei = {sub="Genmei Shield",}
	sets.Ammurapi = {sub="Ammurapi Shield",}
	
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	set_macro_page(1, 4)
end

function user_job_lockstyle()
    send_command('input /lockstyleset ' .. lockstyleset)
end