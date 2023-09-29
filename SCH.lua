-- Haste/DW Detection Requires Gearinfo Addon
-- Dressup is setup to auto load with this Lua
-- Itemizer addon is required for auto gear sorting / Warp Scripts / Range Scripts
--
-------------------------------------------------------------------------------------------------------------------
--  Keybinds (Global Binds for all Jobs)
-------------------------------------------------------------------------------------------------------------------
--  Modes:      	[ F9 ]              	Cycle Offense Mode
--              	[ F10 ]             	Cycle Idle Mode
--              	[ F11 ]             	Cycle Casting Mode
--              	[ F12 ]             	Update Current Gear / Report Current Status
--					[ CTRL + F9 ]			Cycle Weapon Skill Mode
--					[ ALT + F9 ]			Cycle Range Mode
--              	[ Windows + F9 ]    	Cycle Hybrid Modes
--			    	[ Windows + W ]         Toggles Weapon Lock OFF
--  				[ Windows + R ]         Toggles Range Lock
--					[ Windows + T ]			Toggles Treasure Hunter Mode
--              	[ Windows + C ]     	Toggle Capacity Points Mode
--              	[ Windows + I ]     	Pulls all items in Gear Retrieval
--
-- Item Binds:		[ Shift + Numpad1 ]		Echo Drop
--					[ Shift + Numpad2 ]		Holy Water
--					[ Shift + Numpad3 ]		Remedy
--					[ Shift + Numpad4 ]		Panacea
--					[ Shift + Numpad7 ]		Silent Oil
--					[ Shift + Numpad9 ]		Prism Powder
--
--					[ Windows + Numpad1 ]	Sublime Sushi
--					[ Windows + Numpad2 ]	Grape Daifuku
--					[ Windows + Numpad3 ]	Tropical Crepe
--					[ Windows + Numpad4 ]	Miso Ramen
--					[ Windows + Numpad5 ]	Red Curry Bun
--					[ Windows + Numpad6 ]	Rolan. Daifuku
--					[ Windows + Numpad7 ]	Toolbag (Shihei)
--
-- Warp Script:		[ CTRL + Numpad+ ]		Warp Ring
--					[ ALT + Numpad+ ]		Dimensional Ring Dem
--
-- Range Script:	[ CTRL + Numpad0 ] 		Ranged Attack
--
-- Toggles:			[ Windows + U ]			Stops Gear Swap from constantly updating gear
--					[ Windows + D ]			Unloads Dressup then reloads to change lockstyle
--
-------------------------------------------------------------------------------------------------------------------
--  Job Specific Keybinds (White Mage Binds)
-------------------------------------------------------------------------------------------------------------------
--
--	Modes:			[ Windows + M ]			Toggles Magic Burst Mode
--					[ Windows + S ]			Toggles Subtle Blow Mode
--					[ Windows + 1 ]			Sets Weapon to Maxentius then locks Main/Sub Slots
--					[ Windows + 2 ]			Sets Weapon to Xoanon then locks Main/Sub Slots
--					[ Windows + 3 ]			Sets Weapon to Musa then locks Main/Sub Slots
--
--	Echo Binds:		[ CTRL + Numpad- ]		Shows main Weaponskill Binds in game
--					[ ALT + Numpad- ]		Shows Alternate Weaponskill Binds in game
--					[ Shift + Numpad- ]		Shows Item Binds in game
--					[ Windows + Numpad- ]	Shows Food/Weapon/Misc. Binds in game
--
--  Abilities:  	[ CTRL + - ]        	Light Arts
--					[ CTRL + = ]        	Dark Arts
--
-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    info.addendumNukes = S{"Stone IV", "Water IV", "Aero IV", "Fire IV", "Blizzard IV", "Thunder IV",
        "Stone V", "Water V", "Aero V", "Fire V", "Blizzard V", "Thunder V"}

    state.Buff['Sublimation: Activated'] = buffactive['Sublimation: Activated'] or false
    state.RegenMode = M{['description']='Regen Mode', 'Potency', 'Duration'}
    state.CP = M(false, "Capacity Points Mode")

    update_active_strategems()
	
	include('Mote-TreasureHunter')

    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
					"Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring", "Emporox's Ring",}

    degrade_array = {
        ['Aspirs'] = {'Aspir','Aspir II'}
        }

    lockstyleset = 19

end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc')
    state.HybridMode:options('Normal', 'DT')
    state.WeaponskillMode:options('Normal')
    state.CastingMode:options('Normal', 'MACC')
    state.IdleMode:options('Normal')
	state.TreasureMode:options('Tag', 'None')
	state.WeaponSet = M{['description']='Weapon Set', 'None', 'Maxentius', 'Xoanon', 'Musa', 'Opashoro'}

    state.MagicBurst = M(false, 'Magic Burst')
	state.Subtle_Blow = M(false, 'Subtle Blow')

	--Load Gearinfo/Dressup Lua
	
    send_command('wait 3; lua l gearinfo')
	send_command('wait 10; lua l Dressup')
	
    --Global Scholar binds (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)	
	
	send_command('bind @u input //gi ugs')
	send_command('bind @d input //lua u dressup; wait 10; input //lua l dressup')	
    send_command('bind @r gs c cycle RegenMode')
    send_command('bind @m gs c toggle MagicBurst')
	send_command('bind @s gs c toggle Subtle_Blow')
	send_command('bind @t gs c cycle TreasureMode')
	send_command('bind @c gs c toggle CP')
	send_command('bind ^- input /ja "Light Arts" <me>')
	send_command('bind ^= input /ja "Dark Arts" <me>')
	send_command('bind ^space tc nearest')
	
	--Command to show Item binds in game[ Shift + numpad- ]
	send_command([[bind ~numpad- 
		input /echo -----Item_Binds-----;
		input /echo [ Shift + Numpad1 ]	Echo Drop;
		input /echo [ Shift + Numpad2 ]	Holy Water;
		input /echo [ Shift + Numpad3 ]	Remedy;
		input /echo [ Shift + Numpad4 ]	Panacea;
		input /echo [ Shift + Numpad7 ]	Silent Oil;
		input /echo [ Shift + Numpad9 ]	Prism Powder;
		]])
		
	--Command to show Food/Weapon/Misc binds in game[ Windows + numpad- ]	
	send_command([[bind @numpad- 		
		input /echo -----Food_Binds-----;
		input /echo [ Windows + Numpad1 ]	Sublime Sushi;
		input /echo [ Windows + Numpad2 ]	Grape Daifuku;
		input /echo [ Windows + Numpad3 ]	Tropical Crepe;
		input /echo [ Windows + Numpad4 ]	Miso Ramen;
		input /echo [ Windows + Numpad5 ]	Red Curry Bun;
		input /echo [ Windows + Numpad6 ]	Rolan. Daifuku;
		input /echo [ Windows + Numpad7 ]	Toolbag (Shihei);
		input /echo -----Modes-----;
		input /echo [ Windows + M ]	Toggles Magic Burst Mode;
		input /echo [ Windows + S ]	Toggles Subtle Blow Mode;
		input /echo [ Windows + W ]	Sets Weapon to None;
		input /echo [ Windows + 1 ]	Sets Weapon to Maxentius;
		input /echo [ Windows + 2 ]	Sets Weapon to Xoanon;
		input /echo [ Windows + 3 ]	Sets Weapon to Musa;
		input /echo -----Toggles-----;
		input /echo [ Windows + U ]	Toggles Gearswap autoupdate;
		input /echo [ Windows + D ]	Unloads then reloads dressup;
		]])
	
	--Weapon set Binds

	send_command('bind @1 gs c set WeaponSet Maxentius')
	send_command('bind @2 gs c set WeaponSet Xoanon')
	send_command('bind @3 gs c set WeaponSet Musa')
	send_command('bind @w input /equip sub; gs c set WeaponSet None')
	
	--Item binds (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)
	
	send_command('bind ~numpad1 input /item "Echo Drops" <me>')
	send_command('bind ~numpad2 input /item "Holy Water" <me>')
    send_command('bind ~numpad3 input /item "Remedy" <me>')
    send_command('bind ~numpad4 input /item "Panacea" <me>')
	send_command('bind ~numpad7 input /item "Silent Oil" <me>')
	send_command('bind ~numpad9 input /item "Prism Powder" <me>')
	
	send_command('bind @numpad1 input /item "Sublime Sushi" <me>')
	send_command('bind @numpad2 input /item "Grape Daifuku" <me>')
	send_command('bind @numpad3 input /item "Tropical Crepe" <me>')
	send_command('bind @numpad4 input /item "Miso Ramen" <me>')
	send_command('bind @numpad5 input /item "Red Curry Bun" <me>')
	send_command('bind @numpad6 input /item "Rolan. Daifuku" <me>')
	send_command('bind @numpad7 input //get Toolbag (Shihe) satchel; wait 3; input /item "Toolbag (Shihei)" <me>')
		
	--Ranged Scripts  (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)

	send_command('bind ^numpad0 input /ra <t>')

	--Warp scripts (this allows the ring to stay in your satchel fulltime) (Requires Itemizer Addon) (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)

	send_command('bind ^numpad+ input //get Warp Ring satchel; wait 1; input /equip Ring1 "Warp Ring"; wait 12; input /item "Warp Ring" <me>; wait 60; input //put Warp Ring satchel')
	send_command('bind !numpad+ input //get Dim. Ring (Dem) satchel; wait 1; input /equip Ring1 "Dim. Ring (Dem)"; wait 12; input /item "Dim. Ring (Dem)" <me>; wait 60; input //put Dim. Ring (Dem) satchel')    
	
	--Ammo Scripts (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)
	
	--Gear Retrieval Scripts (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)
	
	send_command('wait 10; input //get Ammurapi Shield sack')
	send_command('wait 10; input //get Bunzi\'s Rod case')
	send_command('wait 10; input //get Chatoyant Staff case')
	send_command('wait 10; input //get Culminus sack')
	send_command('wait 10; input //get Daybreak case')
	send_command('wait 10; input //get Genmei Shield sack')
	send_command('wait 10; input //get Khonsu sack')
	send_command('wait 10; input //get Maxentius case')
	send_command('wait 10; input //get Mpaca\'s Staff case')
	send_command('wait 10; input //get Musa case')
	send_command('wait 10; input //get Xoanon case')
	
	send_command([[bind @i ;
		input //get Ammurapi Shield sack;
		input //get Bunzi\'s Rod case;
		input //get Chatoyant Staff case;
		input //get Culminus sack;
		input //get Daybreak case;
		input //get Genmei Shield sack;
		input //get Khonsu sack;
		input //get Maxentius case;
		input //get Mpaca\'s Staff case;
		input //get Musa case;
		input //get Xoanon case;
		]])
	
	--Job settings

    select_default_macro_book()
    set_lockstyle()
	
	--Gearinfo Functions
	
    state.Auto_Kite = M(false, 'Auto_Kite')
    moving = false
	
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
	enable('main','sub','range','ammo','head','body','hands','legs','feet','neck','waist','left_ear','right_ear','left_ring','right_ring','back')

	--Remove Global Scholar Binds

	send_command('unbind @u')
	send_command('unbind @d')
	send_command('unbind @e')	
    send_command('unbind @w')
	send_command('unbind @r')
    send_command('unbind @c')
	send_command('unbind @t')
	send_command('unbind @b')
	send_command('unbind @m')
	send_command('unbind @i')
	send_command('unbind ^space')
	send_command('unbind ^`')
	send_command('unbind ^-')
	send_command('unbind ^=')
	send_command('unbind !`')
	send_command('unbind !-')
	send_command('unbind !=')
	send_command('unbind @`')
	send_command('unbind @-')
	send_command('unbind @=')
	send_command('unbind ^numpad-')
	send_command('unbind @numpad-')
	send_command('unbind ~numpad-')
	send_command('unbind !numpad-')
	
	--Remove Weapon Set binds
	
	send_command('unbind @1')
	send_command('unbind @2')
	send_command('unbind @3')
	send_command('unbind @4')
	send_command('unbind @5')
	send_command('unbind @6')
	send_command('unbind @7')
	send_command('unbind @8')
	send_command('unbind @9')
	send_command('unbind @0')
	
	--Remove Weaponskill Binds
    
	send_command('unbind ^numpad1')
    send_command('unbind ^numpad2')
    send_command('unbind ^numpad3')
    send_command('unbind ^numpad4')
    send_command('unbind ^numpad5')
    send_command('unbind ^numpad6')
	send_command('unbind ^numpad7')
	send_command('unbind ^numpad8')
	send_command('unbind ^numpad9')
	send_command('unbind ^numpad.')
	
	send_command('unbind !numpad1')
    send_command('unbind !numpad2')
	send_command('unbind !numpad3')
    send_command('unbind !numpad4')
	send_command('unbind !numpad5')
    send_command('unbind !numpad6')
	send_command('unbind !numpad7')
	send_command('unbind !numpad8')
	send_command('unbind !numpad9')
	send_command('unbind !numpad.')
	
	--Remove Item Binds
	
	send_command('unbind ~numpad1')
    send_command('unbind ~numpad2')
	send_command('unbind ~numpad3')
    send_command('unbind ~numpad4')
	send_command('unbind ~numpad5')
    send_command('unbind ~numpad6')
	send_command('unbind ~numpad7')
	send_command('unbind ~numpad8')
	send_command('unbind ~numpad9')
	send_command('unbind ~numpad.')
	
	send_command('unbind @numpad1')
    send_command('unbind @numpad2')
	send_command('unbind @numpad3')
    send_command('unbind @numpad4')
	send_command('unbind @numpad5')
    send_command('unbind @numpad6')
	send_command('unbind @numpad7')
	send_command('unbind @numpad8')
	send_command('unbind @numpad9')
	send_command('unbind @numpad.')
	
	--Remove Ranged Scripts
	
	send_command('unbind ^numpad0')
	
	--Remove Warp Scripts
	
	send_command('unbind ^numpad+')
	send_command('unbind !numpad+')
	
	--Gear Removal Scripts
	
	send_command('input //put Ammurapi Shield sack')
	send_command('input //put Bunzi\'s Rod case')
	send_command('input //put Chatoyant Staff case')
	send_command('input //put Culminus sack')
	send_command('input //put Daybreak case')
	send_command('input //put Genmei Shield sack')
	send_command('input //put Khonsu sack')
	send_command('input //put Maxentius case')
	send_command('input //put Mpaca\'s Staff case')
	send_command('input //put Musa case')
	send_command('input //put Xoanon case')
	
	--Unload Gearinfo/Dressup Lua
	
    send_command('lua u gearinfo')
	send_command('lua u Dressup')	
	
end



-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA['Tabula Rasa'] = {legs="Peda. Pants +1"}
    sets.precast.JA['Enlightenment'] = {body="Peda. Gown +3"}

    sets.precast.JA['Sublimation'] = {
       head="Acad. Mortar. +3", --4
       body={ name="Peda. Gown +3", augments={'Enhances "Enlightenment" effect',}}, --5
       --right_ear="Savant's Earring", --1
       waist="Embla Sash", --5
       }

    -- Fast cast sets for spells
    sets.precast.FC = {    
		main={ name="Musa", augments={'Path: C',}},
		sub="Khonsu",
		ammo="Sapience Orb",
		head="Acad. Mortar. +3",
		body="Zendik Robe",
		hands="Acad. Bracers +3",
		legs="Agwu's Slops",
		feet={ name="Chironic Slippers", augments={'"Fast Cast"+7','MND+3',}},
		neck="Orunmila's Torque",
		waist="Embla Sash",
		left_ear="Malignance Earring",
		right_ear="Etiolation Earring",
		left_ring="Kishar Ring",
		right_ring="Prolix Ring",
		back={ name="Fi Follet Cape +1", augments={'Path: A',}},}

    sets.precast.FC.Grimoire = {head="Peda. M.Board +3", feet="Acad. Loafers +3"}

    sets.precast.FC.Cure = set_combine(sets.precast.FC,{})

    sets.precast.FC.Curaga = sets.precast.FC.Cure
    sets.precast.FC.Impact = set_combine(sets.precast.FC, {head=empty, body="Crepuscular Cloak"})
    sets.precast.FC.Dispelga = set_combine(sets.precast.FC, {main="Daybreak", sub="Ammurapi Shield"})
	
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
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}

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
		ammo="Hydrocera",
		head={ name="Kaykaus Mitra +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','"Cure" potency +6%','"Conserve MP"+7',}},
		hands={ name="Peda. Bracers +3", augments={'Enh. "Tranquility" and "Equanimity"',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		feet={ name="Kaykaus Boots +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		neck="Incanter's Torque",
		waist="Luminary Sash",
		left_ear="Beatific Earring",
		right_ear="Meili Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}

    sets.midcast.CureWeather = {    
		main="Chatoyant Staff",
		sub="Khonsu",
		ammo="Hydrocera",
		head={ name="Kaykaus Mitra +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','"Cure" potency +6%','"Conserve MP"+7',}},
		hands={ name="Peda. Bracers +3", augments={'Enh. "Tranquility" and "Equanimity"',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		feet={ name="Kaykaus Boots +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		neck="Incanter's Torque",
		waist="Hachirin-no-Obi",
		left_ear="Mendi. Earring",
		right_ear="Meili Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Twilight Cape",}
	
	sets.midcast.CureSelf = {    
		main="Daybreak",
		sub="Ammurapi Shield",
		ammo="Hydrocera",
		head={ name="Kaykaus Mitra +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','"Cure" potency +6%','"Conserve MP"+7',}},
		hands={ name="Agwu's Gages", augments={'Path: A',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		feet={ name="Kaykaus Boots +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		neck="Phalaina Locket",
		waist="Gishdubar Sash",
		left_ear="Beatific Earring",
		right_ear="Meili Earring",
		left_ring="Kunaji Ring",
		right_ring="Stikini Ring +1",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}

    sets.midcast.Curaga = {    
		main="Daybreak",
		sub="Ammurapi Shield",
		ammo="Hydrocera",
		head={ name="Kaykaus Mitra +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','"Cure" potency +6%','"Conserve MP"+7',}},
		hands={ name="Peda. Bracers +3", augments={'Enh. "Tranquility" and "Equanimity"',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		feet={ name="Kaykaus Boots +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		neck="Incanter's Torque",
		waist="Luminary Sash",
		left_ear="Beatific Earring",
		right_ear="Meili Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}

    sets.midcast.StatusRemoval = {    
		main="Daybreak",
		sub="Ammurapi Shield",
		ammo="Hydrocera",
		head={ name="Kaykaus Mitra +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','"Cure" potency +6%','"Conserve MP"+7',}},
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		feet={ name="Kaykaus Boots +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		neck="Incanter's Torque",
		waist="Luminary Sash",
		left_ear="Beatific Earring",
		right_ear="Meili Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}

    sets.midcast.Cursna = {    
		main="Daybreak",
		sub="Ammurapi Shield",
		ammo="Sapience Orb",
		head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
		body={ name="Peda. Gown +3", augments={'Enhances "Enlightenment" effect',}},
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

    sets.midcast['Enhancing Magic'] = {
		main={ name="Musa", augments={'Path: C',}},
		sub="Khonsu",
		ammo="Sapience Orb",
		head={ name="Telchine Cap", augments={'"Fast Cast"+4','Enh. Mag. eff. dur. +10',}},
		body={ name="Peda. Gown +3", augments={'Enhances "Enlightenment" effect',}},
		hands={ name="Telchine Gloves", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +9',}},
		legs={ name="Telchine Braconi", augments={'"Fast Cast"+3','Enh. Mag. eff. dur. +10',}},
		feet={ name="Telchine Pigaches", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +10',}},
		neck="Orunmila's Torque",
		waist="Embla Sash",
		left_ear="Malignance Earring",
		right_ear="Loquac. Earring",
		left_ring="Kishar Ring",
		right_ring="Prolix Ring",
		back={ name="Fi Follet Cape +1", augments={'Path: A',}},}

    sets.midcast.EnhancingDuration = {
		main={ name="Musa", augments={'Path: C',}},
		sub="Khonsu",
		ammo="Sapience Orb",
		head={ name="Telchine Cap", augments={'"Fast Cast"+4','Enh. Mag. eff. dur. +10',}},
		body={ name="Peda. Gown +3", augments={'Enhances "Enlightenment" effect',}},
		hands={ name="Telchine Gloves", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +9',}},
		legs={ name="Telchine Braconi", augments={'"Fast Cast"+3','Enh. Mag. eff. dur. +10',}},
		feet={ name="Telchine Pigaches", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +10',}},
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
		body={ name="Telchine Chas.", augments={'Enh. Mag. eff. dur. +10',}},
		hands={ name="Telchine Gloves", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +9',}},
		legs={ name="Telchine Braconi", augments={'"Fast Cast"+3','Enh. Mag. eff. dur. +10',}},
		feet={ name="Telchine Pigaches", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +10',}},
		neck="Incanter's Torque",
		waist="Embla Sash",
		left_ear="Malignance Earring",
		right_ear="Loquac. Earring",
		left_ring="Kishar Ring",
		right_ring="Prolix Ring",
		back={ name="Bookworm's Cape", augments={'INT+1','MND+2','Helix eff. dur. +20','"Regen" potency+10',}},}

    sets.midcast.RegenDuration = {
		main={ name="Musa", augments={'Path: C',}},
		sub="Khonsu",
		ammo="Sapience Orb",
		head={ name="Telchine Cap", augments={'"Fast Cast"+4','Enh. Mag. eff. dur. +10',}},
		body={ name="Telchine Chas.", augments={'Enh. Mag. eff. dur. +10',}},
		hands={ name="Telchine Gloves", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +9',}},
		legs={ name="Telchine Braconi", augments={'"Fast Cast"+3','Enh. Mag. eff. dur. +10',}},
		feet={ name="Telchine Pigaches", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +10',}},
		neck="Incanter's Torque",
		waist="Embla Sash",
		left_ear="Malignance Earring",
		right_ear="Loquac. Earring",
		left_ring="Kishar Ring",
		right_ring="Prolix Ring",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}
		
    sets.midcast['Embrava'] = {
		main={ name="Musa", augments={'Path: C',}},
		sub="Khonsu",
		ammo="Sapience Orb",
		head={ name="Telchine Cap", augments={'"Fast Cast"+4','Enh. Mag. eff. dur. +10',}},
		body={ name="Peda. Gown +3", augments={'Enhances "Enlightenment" effect',}},
		hands={ name="Telchine Gloves", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +9',}},
		legs={ name="Telchine Braconi", augments={'"Fast Cast"+3','Enh. Mag. eff. dur. +10',}},
		feet={ name="Telchine Pigaches", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +10',}},
		neck="Incanter's Torque",
		waist="Embla Sash",
		left_ear="Malignance Earring",
		right_ear="Loquac. Earring",
		left_ring="Kishar Ring",
		right_ring="Prolix Ring",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}

    sets.midcast.Refresh = {
		main={ name="Musa", augments={'Path: C',}},
		sub="Khonsu",
		ammo="Sapience Orb",
		head={ name="Amalric Coif +1", augments={'INT+12','Mag. Acc.+25','Enmity-6',}},
		body={ name="Peda. Gown +3", augments={'Enhances "Enlightenment" effect',}},
		hands={ name="Telchine Gloves", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +9',}},
		legs={ name="Telchine Braconi", augments={'"Fast Cast"+3','Enh. Mag. eff. dur. +10',}},
		feet={ name="Telchine Pigaches", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +10',}},
		neck="Incanter's Torque",
		waist="Embla Sash",
		left_ear="Malignance Earring",
		right_ear="Loquac. Earring",
		left_ring="Kishar Ring",
		right_ring="Prolix Ring",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}
	
	sets.midcast.RefreshSelf = {
		main={ name="Musa", augments={'Path: C',}},
		sub="Khonsu",
		ammo="Sapience Orb",
		head={ name="Amalric Coif +1", augments={'INT+12','Mag. Acc.+25','Enmity-6',}},
		body={ name="Telchine Chas.", augments={'Enh. Mag. eff. dur. +10',}},
		hands={ name="Telchine Gloves", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +9',}},
		legs={ name="Telchine Braconi", augments={'"Fast Cast"+3','Enh. Mag. eff. dur. +10',}},
		feet="Inspirited Boots",
		neck="Incanter's Torque",
		waist="Gishdubar Sash",
		left_ear="Malignance Earring",
		right_ear="Loquac. Earring",
		left_ring="Kishar Ring",
		right_ring="Prolix Ring",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}

    sets.midcast.Stoneskin = {
		main={ name="Musa", augments={'Path: C',}},
		sub="Khonsu",
		ammo="Sapience Orb",
		head={ name="Telchine Cap", augments={'"Fast Cast"+4','Enh. Mag. eff. dur. +10',}},
		body={ name="Peda. Gown +3", augments={'Enhances "Enlightenment" effect',}},
		hands={ name="Telchine Gloves", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +9',}},
		legs={ name="Telchine Braconi", augments={'"Fast Cast"+3','Enh. Mag. eff. dur. +10',}},
		feet={ name="Telchine Pigaches", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +10',}},
		neck="Nodens Gorget",
		waist="Siegel Sash",
		left_ear="Malignance Earring",
		right_ear="Loquac. Earring",
		left_ring="Kishar Ring",
		right_ring="Prolix Ring",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}

    sets.midcast.Aquaveil = {
		main={ name="Musa", augments={'Path: C',}},
		sub="Khonsu",
		ammo="Sapience Orb",
		head={ name="Amalric Coif +1", augments={'INT+12','Mag. Acc.+25','Enmity-6',}},
		body={ name="Peda. Gown +3", augments={'Enhances "Enlightenment" effect',}},
		hands="Regal Cuffs",
		legs={ name="Telchine Braconi", augments={'"Fast Cast"+3','Enh. Mag. eff. dur. +10',}},
		feet={ name="Telchine Pigaches", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +10',}},
		neck="Incanter's Torque",
		waist="Embla Sash",
		left_ear="Malignance Earring",
		right_ear="Loquac. Earring",
		left_ring="Kishar Ring",
		right_ring="Prolix Ring",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}

    sets.midcast.Storm = sets.midcast.EnhancingDuration

    sets.midcast.Protect = sets.midcast.EnhancingDuration
    sets.midcast.Protectra = sets.midcast.Protect
    sets.midcast.Shell = sets.midcast.Protect
    sets.midcast.Shellra = sets.midcast.Protect

    sets.midcast['Enfeebling Magic'] = {
		main={ name="Bunzi's Rod", augments={'Path: A',}},
		sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
		body={ name="Cohort Cloak +1", augments={'Path: A',}},
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs="Arbatel Pants +3",
		feet="Acad. Loafers +3",
		neck={ name="Argute Stole +2", augments={'Path: A',}},
		waist={ name="Obstin. Sash", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Aurist's Cape +1", augments={'Path: A',}},}
	
	sets.midcast['Dia II'] = set_combine(sets.midcast['Enfeebling Magic'], {ammo="Per. Lucky Egg",body="Volte Jupon",waist="Chaac Belt",})
    sets.LightArts = set_combine(sets.midcast['Enfeebling Magic'], {})
    sets.DarkArts = set_combine(sets.midcast['Enfeebling Magic'], {head="Acad. Mortar. +3",body="Acad. Gown +3",})
	
    sets.midcast['Dark Magic'] = {
		main={ name="Musa", augments={'Path: C',}},
		sub="Khonsu",
		ammo="Pemphredo Tathlum",
		head="Acad. Mortar. +3",
		body="Acad. Gown +3",
		hands="Acad. Bracers +3",
		legs="Arbatel Pants +3",
		feet="Acad. Loafers +3",
		neck={ name="Argute Stole +2", augments={'Path: A',}},
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
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
		legs={ name="Peda. Pants +1", augments={'Enhances "Tabula Rasa" effect',}},
		feet="Agwu's Pigaches",
		neck="Erra Pendant",
		waist="Fucho-no-Obi",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Evanescence Ring",
		right_ring="Archon Ring",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}

    sets.midcast.Aspir = sets.midcast.Drain

    -- Elemental Magic
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
		head={ name="Agwu's Cap", augments={'Path: A',}},
		body="Arbatel Gown +3",
		hands={ name="Agwu's Gages", augments={'Path: A',}},
		legs={ name="Agwu's Slops", augments={'Path: A',}},
		feet="Arbatel Loafers +3",
		neck={ name="Argute Stole +2", augments={'Path: A',}},
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Freke Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}
		
	sets.midcast['Elemental Magic'].MagicBurstEbullience = {
		main={ name="Bunzi's Rod", augments={'Path: A',}},
		sub="Ammurapi Shield",
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head="Arbatel Bonnet +3",
		body={ name="Agwu's Robe", augments={'Path: A',}},
		hands={ name="Agwu's Gages", augments={'Path: A',}},
		legs={ name="Agwu's Slops", augments={'Path: A',}},
		feet="Arbatel Loafers +3",
		neck={ name="Argute Stole +2", augments={'Path: A',}},
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Mujin Band",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}

    sets.midcast['Elemental Magic'].Resistant = {
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
		right_ear={ name="Arbatel Earring +1", augments={'System: 1 ID: 1676 Val: 0','Mag. Acc.+13','Enmity-3',}},
		left_ring="Stikini Ring +1",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Aurist's Cape +1", augments={'Path: A',}},}
	
    sets.midcast.Dispelga = set_combine(sets.midcast.IntEnfeebles, {main="Daybreak", sub="Ammurapi Shield"})

    sets.midcast.Helix = {
		main={ name="Bunzi's Rod", augments={'Path: A',}},
		sub="Culminus",
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head={ name="Agwu's Cap", augments={'Path: A',}},
		body={ name="Agwu's Robe", augments={'Path: A',}},
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		legs={ name="Agwu's Slops", augments={'Path: A',}},
		feet={ name="Amalric Nails +1", augments={'Mag. Acc.+20','"Mag.Atk.Bns."+20','"Conserve MP"+7',}},
		neck={ name="Argute Stole +2", augments={'Path: A',}},
		waist="Skrymir Cord +1",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Freke Ring",
		right_ring="Mallquis Ring",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}

	sets.midcast.Subtle_Blow = {
		main=empty,
		sub=empty,
		ammo="Homiliary",
		head=empty,
		body=empty,
		hands=empty,
		legs=empty,
		feet=empty,
		neck={ name="Bathy Choker +1", augments={'Path: A',}},
		waist="Luminary Sash",
		left_ear="Etiolation Earring",
		right_ear="Magnetic Earring",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Fi Follet Cape +1", augments={'Path: A',}},}
	
	sets.midcast.Helix.MagicBurst = {
		main={ name="Bunzi's Rod", augments={'Path: A',}},
		sub="Ammurapi Shield",
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head={ name="Peda. M.Board +3", augments={'Enh. "Altruism" and "Focalization"',}},
		body={ name="Agwu's Robe", augments={'Path: A',}},
		hands={ name="Agwu's Gages", augments={'Path: A',}},
		legs={ name="Agwu's Slops", augments={'Path: A',}},
		feet="Arbatel Loafers +3",
		neck={ name="Argute Stole +2", augments={'Path: A',}},
		waist="Skrymir Cord +1",
		left_ear="Malignance Earring",
		right_ear={ name="Arbatel Earring +1", augments={'System: 1 ID: 1676 Val: 0','Mag. Acc.+13','Enmity-3',}},
		left_ring="Mujin Band",
		right_ring="Freke Ring",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}
		
	sets.midcast.Helix.MagicBurstEbullience = {
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
		left_ear="Malignance Earring",
		right_ear={ name="Arbatel Earring +1", augments={'System: 1 ID: 1676 Val: 0','Mag. Acc.+13','Enmity-3',}},
		left_ring="Mujin Band",
		right_ring="Freke Ring",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}	

    sets.midcast.DarkHelix = set_combine(sets.midcast.Helix, {head="Pixie Hairpin +1",left_ring="Archon Ring",})
    sets.midcast.DarkHelix.MagicBurst = set_combine(sets.midcast.Helix.MagicBurst, {head="Pixie Hairpin +1",right_ring="Archon Ring",})
    sets.midcast.DarkHelix.MagicBurstEbullience = set_combine(sets.midcast.Helix.MagicBurst, {head="Arbatel Bonnet +3",right_ring="Archon Ring",})

    sets.midcast.LightHelix = set_combine(sets.midcast.Helix,{main="Daybreak",sub="Ammurapi Shield",})
    sets.midcast.LightHelix.MagicBurst = set_combine(sets.midcast.Helix.MagicBurst,{main="Daybreak",sub="Ammurapi Shield",})
	sets.midcast.LightHelix.MagicBurstEbullience = set_combine(sets.midcast.Helix.MagicBurst,{main="Daybreak",sub="Ammurapi Shield",head="Arbatel Bonnet +3",})
	
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
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}
	
    -- Initializes trusts at iLvl 119
    sets.midcast.Trust = sets.precast.FC


    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.idle = {
		main="Mpaca's Staff",
		sub="Khonsu",
		ammo="Homiliary",
		head="Befouled Crown",
		body="Arbatel Gown +3",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Cornelia's Belt",
		left_ear="Eabani Earring",
		right_ear="Mimir Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.latent_refresh = {waist="Fucho-no-obi"}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged = {
	    ammo="Homiliary",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Combatant's Torque",
		waist="Eschan Stone",
		left_ear="Crep. Earring",
		right_ear="Mache Earring +1",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	sets.Kiting = {left_ring="Shneddick Ring"}

    sets.buff['Rapture'] = {head="Arbatel Bonnet +3"}
    sets.buff['Perpetuance'] = {hands="Arbatel Bracers +3"}
    sets.buff['Immanence'] = {}
    sets.buff['Penury'] = {legs="Arbatel Pants +3"}
    sets.buff['Parsimony'] = {legs="Arbatel Pants +3"}
    sets.buff['Celerity'] = {feet="Peda. Loafers +3"}
    sets.buff['Alacrity'] = {feet="Peda. Loafers +3"}
    sets.buff['Klimaform'] = {feet="Arbatel Loafers +3"}

    sets.buff.FullSublimation = {
       head="Acad. Mortar. +3", --4
       body={ name="Peda. Gown +3", augments={'Enhances "Enlightenment" effect',}}, --5
       --right_ear="Savant's Earring", --1
       waist="Embla Sash", --5
       }

	sets.TreasureHunter = {
		ammo="Per. Lucky Egg", 		--TH1
		body="Volte Jupon",			--TH2
		waist="Chaac Belt",} 	 	--TH1
	
    sets.buff.Doom = {
		neck="Nicander's Necklace",
		waist="Gishdubar Sash", --10
        }

    sets.Obi = {waist="Hachirin-no-Obi"}
    sets.CP = {neck={ name="Argute Stole +2", augments={'Path: A',}},}
	
	--Weapon Sets

	sets.Maxentius = {main="Maxentius", sub="Daybreak",}
	sets.Maxentius.SW = {main="Maxentius", sub="Genmei Shield"}
	
	sets.Xoanon = {main="Xoanon", sub="Khonsu"}
	
	sets.Musa = {main={ name="Musa", augments={'Path: C',}}, sub="Khonsu"}
	
	sets.Opashoro = {main="Opashoro", sub="Khonsu"}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific Functions
-------------------------------------------------------------------------------------------------------------------

function job_precast(spell, action, spellMap, eventArgs)
    if spell.name:startswith('Aspir') then
        refine_various_spells(spell, action, spellMap, eventArgs)
    end
end

function job_post_precast(spell, action, spellMap, eventArgs)
    if (spell.type == "WhiteMagic" and (buffactive["Light Arts"] and buffactive["Addendum: White"])) or
        (spell.type == "BlackMagic" and (buffactive["Dark Arts"] or buffactive["Addendum: Black"])) then
        equip(sets.precast.FC.Grimoire)
    elseif spell.name == 'Impact' then
        equip(sets.precast.FC.Impact)
    end
end

-- Run after the general midcast() is done.
function job_post_midcast(spell, action, spellMap, eventArgs)

    if spell.skill == 'Elemental Magic' then
		if state.MagicBurst.value == true and spell.skill == 'Elemental Magic' then
			if state.Buff.Ebullience then
				equip(sets.midcast['Elemental Magic'].MagicBurstEbullience)
			else
				equip(sets.midcast['Elemental Magic'].MagicBurst)
			end
		end
		
        if spellMap == "Helix" then
			if state.Subtle_Blow.value == true and state.Buff.Immanence then
				equip(sets.midcast.Subtle_Blow)
			else
				if state.MagicBurst.value == true then
					if state.Buff.Ebullience then
						equip(sets.midcast.Helix.MagicBurstEbullience)
					else
						equip(sets.midcast.Helix.MagicBurst)
					end

					if spell.english:startswith('Lumino') then
						equip(sets.midcast.LightHelix.MagicBurst)
					elseif spell.english:startswith('Nocto') then
						equip(sets.midcast.DarkHelix.MagicBurst)
						if state.Buff.Ebullience and spell.english:startswith('Lumino') then
							equip(sets.midcast.LightHelix.MagicBurstEbullience)
						elseif state.Buff.Ebullience and spell.english:startswith('Nocto') then
							equip(sets.midcast.DarkHelix.MagicBurstEbullience)
						end
					end
				else 
					equip(sets.midcast.Helix)
						if spell.english:startswith('Lumino') then
							equip(sets.midcast.LightHelix)
						elseif spell.english:startswith('Nocto') then
							equip(sets.midcast.DarkHelix)
						end
				end
			end
			
			--[[if state.Buff.Klimaform and spell.element == world.weather_element then
				equip(sets.buff['Klimaform'])
			end]]
        end
		
    end
	
    if spell.action_type == 'Magic' then
        apply_grimoire_bonuses(spell, action, spellMap, eventArgs)
    end
	
    if spell.skill == 'Enfeebling Magic' then
        if spell.type == "WhiteMagic" and (buffactive["Light Arts"] and buffactive["Addendum: White"]) then
            equip(sets.LightArts)
        elseif spell.type == "BlackMagic" and (buffactive["Dark Arts"] and buffactive["Addendum: Black"]) then
            equip(sets.DarkArts)
        end
    end

    if spell.skill == 'Elemental Magic' then

			--Equips gearset to cast Impact
		if spell.english == "Impact" then
                equip(sets.midcast.Impact)
        end
		
			--Equips gearset to cast Impact
		if spell.english == "Dispelga" then
                equip(sets.midcast.Dispelga)
        end
    end	

		--Changes Cure set if Curing yourself
    if spellMap == 'Cure' and spell.target.type == 'SELF' then
        equip(sets.midcast.CureSelf)
    end
	
    if spell.skill == 'Elemental Magic' or spell.english == "Kaustra" then
        if (spell.element == world.weather_element and (get_weather_intensity() == 2 and spell.element ~= elements.weak_to[world.day_element])) and spellMap ~= 'Helix' then
            equip(sets.Obi)
        -- Target distance under 1.7 yalms.
        elseif spell.target.distance < (1.7 + spell.target.model_size) then
            equip({waist="Orpheus's Sash"})
        -- Matching day and weather.
       elseif (spell.element == world.day_element and spell.element == world.weather_element) and spellMap ~= 'Helix' then
            equip(sets.Obi)
        -- Target distance under 8 yalms.
        elseif spell.target.distance < (8 + spell.target.model_size) then
            equip({waist="Orpheus's Sash"})
        -- Match day or weather.
       elseif (spell.element == world.day_element or spell.element == world.weather_element) and spellMap ~= 'Helix' then
            equip(sets.Obi)
        end
    end
	
    if spell.skill == 'Enhancing Magic' then
        if classes.NoSkillSpells:contains(spell.english) then
            equip(sets.midcast.EnhancingDuration)

			if spellMap == 'Refresh' then
				equip(sets.midcast.Refresh)
				if spell.target.type == 'SELF' then
					equip (sets.midcast.RefreshSelf)
				end
			end
			
        end
		
        if spellMap == "Regen" then
            if state.RegenMode.value == 'Duration' then
				equip(sets.midcast.RegenDuration)
			end
            if state.RegenMode.value == 'Potency' then
				equip(sets.midcast.Regen)			
			end
        end
		
        if state.Buff.Perpetuance then
            equip(sets.buff['Perpetuance'])
        end
		
    end
end


function job_buff_change(buff,gain)

		--Handles Sublimation gear
    if buff == "Sublimation: Activated" then
        handle_equipping_gear(player.status)
    end

		--Auto equips Cursna Recieved doom set when doom debuff is on
    if buff == "doom" then
        if gain then
            equip(sets.buff.Doom)
            --send_command('@input /p Doomed.')
            disable('neck','waist')
        else
            enable('neck','waist')
            handle_equipping_gear(player.status)
        end
    end
	
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function job_handle_equipping_gear(playerStatus, eventArgs)
    check_gear()
    check_moving()
	update_combat_form()
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    handle_equipping_gear(player.status)
	Weaponskill_Keybinds()
    update_active_strategems()
    update_sublimation()
end

	--Adjusts Melee/Weapon sets for Dual Wield or Single Wield
function update_combat_form()

	if state.WeaponSet.value == 'Maxentius' then
		if player.sub_job == 'DNC' or player.sub_job == 'NIN' then
			enable('main','sub')
			equip(sets.Maxentius)
			disable('main','sub')
		else
			enable('main','sub')
			equip(sets.Maxentius.SW)
			disable('main','sub')
		end
	end

	if state.WeaponSet.value == 'Xoanon' then
		enable('main','sub')
		equip(sets.Xoanon)
		disable('main','sub')
	end
	
	if state.WeaponSet.value == 'Musa' then
		enable('main','sub')
		equip(sets.Musa)
		disable('main','sub')
	end
	
	if state.WeaponSet.value == 'None' then
		enable('main','sub')
	end

end

function Weaponskill_Keybinds()

	if state.WeaponSet.value == 'Xoanon' or state.WeaponSet.value == 'Musa' or state.WeaponSet.value == 'Opashoro' or state.WeaponSet.value == 'None' then
		send_command([[bind ^numpad- 
			input /echo -----Abilities-----;
			input /echo [ CTRL + - ] Light Arts;
			input /echo [ CTRL + = ] Dark Arts;
			input /echo -----Staff-----;
			input /echo [ CTRL + Numpad1 ] Retribution;
			input /echo [ CTRL + Numpad2 ] Full Swing;
			input /echo [ CTRL + Numpad3 ] Shell Crusher;
			input /echo [ CTRL + Numpad4 ] Cataclysm;
			input /echo [ CTRL + Numpad5 ] Myrkr;
			input /echo [ CTRL + Numpad6 ] Oshala;
			input /echo [ CTRL + Numpad7 ] Omniscience;
			input /echo [ CTRL + Numpad9 ] Spirit Taker;
			input /echo [ CTRL + Numpad. ] Shattersoul;]])
		send_command('bind ^numpad1 input /ws "Retribution" <t>')
		send_command('bind ^numpad2 input /ws "Full Swing" <t>')
		send_command('bind ^numpad3 input /ws "Shell Crusher" <t>')
		send_command('bind ^numpad4 input /ws "Cataclysm" <t>')
		send_command('bind ^numpad5 input /ws "Myrker" <t>')
		send_command('bind ^numpad6 input /ws "Oshala" <t>')
		send_command('bind ^numpad7 input /ws "Omniscience" <t>')
		send_command('bind ^numpad9 input /ws "Spirit Taker" <t>')
		send_command('bind ^numpad. input /ja "Shattersoul" <t>')

		send_command([[bind !numpad- 
			input /echo -----Staff-----;
			input /echo [ ALT + Numpad1 ] Sunburst;
			input /echo [ ALT + Numpad2 ] Starburst;
			input /echo [ ALT + Numpad3 ] Rock Crusher;
			input /echo [ ALT + Numpad4 ] Earth Crusher;
			input /echo [ ALT + Numpad5 ] Heavy Swing;]])
		send_command('bind !numpad1 input /ws "Sunburst" <t>')
		send_command('bind !numpad2 input /ws "Starburst" <t>')
		send_command('bind !numpad3 input /ws "Rock Crusher" <t>')
		send_command('bind !numpad4 input /ws "Earth Crusher" <t>')
		send_command('bind !numpad5 input /ja "Heavy Swing" <t>')
			
	elseif state.WeaponSet.value == 'Maxentius' then
		send_command([[bind ^numpad- 
			input /echo -----Abilities-----;
			input /echo [ CTRL + - ] Light Arts;
			input /echo [ CTRL + = ] Dark Arts;
			input /echo -----Club-----;
			input /echo [ CTRL + Numpad1 ] Judgment;
			input /echo [ CTRL + Numpad2 ] Black Halo;
			input /echo [ CTRL + Numpad3 ] Skullbreaker;
			input /echo [ CTRL + Numpad4 ] Shining Strike;
			input /echo [ CTRL + Numpad5 ] True Strike;
			input /echo [ CTRL + Numpad6 ] Flash Nova;
			input /echo [ CTRL + Numpad7 ] Seraph Strike;
			input /echo [ CTRL + Numpad9 ] Realmrazer;
			input /echo [ CTRL + Numpad. ] Brainshaker;]])
		send_command('bind ^numpad1 input /ws "Judgment" <t>')
		send_command('bind ^numpad2 input /ws "Black Halo" <t>')
		send_command('bind ^numpad3 input /ws "Skullbreaker" <t>')
		send_command('bind ^numpad4 input /ws "Shining Strike" <t>')
		send_command('bind ^numpad5 input /ws "True Strike" <t>')
		send_command('bind ^numpad6 input /ws "Flash Nova" <t>')
		send_command('bind ^numpad7 input /ws "Seraph Strike" <t>')
		send_command('bind ^numpad9 input /ws "Realmrazer" <t>')
		send_command('bind ^numpad. input /ws "Brainshaker" <t>')

		send_command([[bind !numpad- 
			input /echo -----Club-----;
			input /echo [ ALT + Numpad1 ]  Starlight;
			input /echo [ ALT + Numpad2 ]  Moonlight;]])
		send_command('bind !numpad1 input /ws "Starlight" <t>')
		send_command('bind !numpad2 input /ws "Moonlight" <t>')
	end
		
end

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if default_spell_map == 'Cure' or default_spell_map == 'Curaga' then
            if (world.weather_element == 'Light' or world.day_element == 'Light') then
                return 'CureWeather'
            end
        end
    end
end

function customize_idle_set(idleSet)

    if state.Buff['Sublimation: Activated'] then
        idleSet = set_combine(idleSet, sets.buff.FullSublimation)
    end
	
    if player.mpp < 51 and state.IdleMode.value == 'Normal' then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
	
    if state.CP.current == 'on' then
		equip(sets.CP)
		disable('neck')
	else
	enable('neck')
	end
	
    if state.Auto_Kite.value == true then
       idleSet = set_combine(idleSet, sets.Kiting)
    end

    return idleSet
end

-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)

    local c_msg = state.CastingMode.value

    local r_msg = state.RegenMode.value

    local d_msg = 'None'
    if state.DefenseMode.value ~= 'None' then
        d_msg = state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
    end

    local i_msg = state.IdleMode.value

    local msg = ''
    if state.MagicBurst.value == true and state.TreasureMode.value == 'Tag' then
		msg = ' TH: Tag | Burst: On |'
	elseif 		state.TreasureMode.value == 'Tag' then
		msg = msg .. ' TH: Tag |'
	elseif state.MagicBurst.value == true then
		msg = ' Burst: On |'
    end
    if state.Kiting.value then
        msg = msg .. ' Kiting: On |'
    end

    add_to_chat(060, '| Magic: ' ..string.char(31,001)..c_msg.. string.char(31,002)..  ' |'
        ..string.char(31,060).. ' Regen: ' ..string.char(31,001)..r_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for direct player commands.
function job_self_command(cmdParams, eventArgs)
    gearinfo(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'scholar' then
        handle_strategems(cmdParams)
        eventArgs.handled = true
    elseif cmdParams[1]:lower() == 'nuke' then
        handle_nuking(cmdParams)
        eventArgs.handled = true
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function gearinfo(cmdParams, eventArgs)
    if cmdParams[1] == 'gearinfo' then
        if type(cmdParams[4]) == 'string' then
            if cmdParams[4] == 'true' then
                moving = true
            elseif cmdParams[4] == 'false' then
                moving = false
            end
        end
        if not midaction() then
            job_update()
        end
    end
end

-- Reset the state vars tracking strategems.
function update_active_strategems()
    state.Buff['Ebullience'] = buffactive['Ebullience'] or false
    state.Buff['Rapture'] = buffactive['Rapture'] or false
    state.Buff['Perpetuance'] = buffactive['Perpetuance'] or false
    state.Buff['Immanence'] = buffactive['Immanence'] or false
    state.Buff['Penury'] = buffactive['Penury'] or false
    state.Buff['Parsimony'] = buffactive['Parsimony'] or false
    state.Buff['Celerity'] = buffactive['Celerity'] or false
    state.Buff['Alacrity'] = buffactive['Alacrity'] or false

    state.Buff['Klimaform'] = buffactive['Klimaform'] or false
end

function update_sublimation()
    state.Buff['Sublimation: Activated'] = buffactive['Sublimation: Activated'] or false
end

-- Equip sets appropriate to the active buffs, relative to the spell being cast.
function apply_grimoire_bonuses(spell, action, spellMap)
    if state.Buff.Perpetuance and spell.type =='WhiteMagic' and spell.skill == 'Enhancing Magic' then
        equip(sets.buff['Perpetuance'])
    end
    if state.Buff.Rapture and (spellMap == 'Cure' or spellMap == 'Curaga') then
        equip(sets.buff['Rapture'])
    end
    if spell.skill == 'Elemental Magic' and spellMap ~= 'ElementalEnfeeble' then
        if state.Buff.Ebullience and spell.english ~= 'Impact' then
            equip(sets.buff['Ebullience'])
        end
        if state.Subtle_Blow.value == true and state.Buff.Immanence then
            equip(sets.midcast.Subtle_Blow)
        end
        if state.Buff.Klimaform and spell.element == world.weather_element then
            equip(sets.buff['Klimaform'])
        end
    end

    if state.Buff.Penury then equip(sets.buff['Penury']) end
    if state.Buff.Parsimony then equip(sets.buff['Parsimony']) end
    if state.Buff.Celerity then equip(sets.buff['Celerity']) end
    if state.Buff.Alacrity then equip(sets.buff['Alacrity']) end
end


-- General handling of strategems in an Arts-agnostic way.
-- Format: gs c scholar <strategem>
function handle_strategems(cmdParams)
    -- cmdParams[1] == 'scholar'
    -- cmdParams[2] == strategem to use

    if not cmdParams[2] then
        add_to_chat(123,'Error: No strategem command given.')
        return
    end
    local strategem = cmdParams[2]:lower()

    if strategem == 'light' then
        if buffactive['light arts'] then
            send_command('input /ja "Addendum: White" <me>')
        elseif buffactive['addendum: white'] then
            add_to_chat(122,'Error: Addendum: White is already active.')
        else
            send_command('input /ja "Light Arts" <me>')
        end
    elseif strategem == 'dark' then
        if buffactive['dark arts'] then
            send_command('input /ja "Addendum: Black" <me>')
        elseif buffactive['addendum: black'] then
            add_to_chat(122,'Error: Addendum: Black is already active.')
        else
            send_command('input /ja "Dark Arts" <me>')
        end
    elseif buffactive['light arts'] or buffactive['addendum: white'] then
        if strategem == 'cost' then
            send_command('input /ja Penury <me>')
        elseif strategem == 'speed' then
            send_command('input /ja Celerity <me>')
        elseif strategem == 'aoe' then
            send_command('input /ja Accession <me>')
        elseif strategem == 'power' then
            send_command('input /ja Rapture <me>')
        elseif strategem == 'duration' then
            send_command('input /ja Perpetuance <me>')
        elseif strategem == 'accuracy' then
            send_command('input /ja Altruism <me>')
        elseif strategem == 'enmity' then
            send_command('input /ja Tranquility <me>')
        elseif strategem == 'skillchain' then
            add_to_chat(122,'Error: Light Arts does not have a skillchain strategem.')
        elseif strategem == 'addendum' then
            send_command('input /ja "Addendum: White" <me>')
        else
            add_to_chat(123,'Error: Unknown strategem ['..strategem..']')
        end
    elseif buffactive['dark arts']  or buffactive['addendum: black'] then
        if strategem == 'cost' then
            send_command('input /ja Parsimony <me>')
        elseif strategem == 'speed' then
            send_command('input /ja Alacrity <me>')
        elseif strategem == 'aoe' then
            send_command('input /ja Manifestation <me>')
        elseif strategem == 'power' then
            send_command('input /ja Ebullience <me>')
        elseif strategem == 'duration' then
            add_to_chat(122,'Error: Dark Arts does not have a duration strategem.')
        elseif strategem == 'accuracy' then
            send_command('input /ja Focalization <me>')
        elseif strategem == 'enmity' then
            send_command('input /ja Equanimity <me>')
        elseif strategem == 'skillchain' then
            send_command('input /ja Immanence <me>')
        elseif strategem == 'addendum' then
            send_command('input /ja "Addendum: Black" <me>')
        else
            add_to_chat(123,'Error: Unknown strategem ['..strategem..']')
        end
    else
        add_to_chat(123,'No arts has been activated yet.')
    end
end


-- Gets the current number of available strategems based on the recast remaining
-- and the level of the sch.
function get_current_strategem_count()
    -- returns recast in seconds.
    local allRecasts = windower.ffxi.get_ability_recasts()
    local stratsRecast = allRecasts[231]

    local maxStrategems = (player.main_job_level + 10) / 20

    local fullRechargeTime = 4*60

    local currentCharges = math.floor(maxStrategems - maxStrategems * stratsRecast / fullRechargeTime)

    return currentCharges
end

function refine_various_spells(spell, action, spellMap, eventArgs)
    local newSpell = spell.english
    local spell_recasts = windower.ffxi.get_spell_recasts()
    local cancelling = 'All '..spell.english..' are on cooldown. Cancelling.'

    local spell_index

    if spell_recasts[spell.recast_id] > 0 then
        if spell.name:startswith('Aspir') then
            spell_index = table.find(degrade_array['Aspirs'],spell.name)
            if spell_index > 1 then
                newSpell = degrade_array['Aspirs'][spell_index - 1]
                send_command('@input /ma '..newSpell..' '..tostring(spell.target.raw))
                eventArgs.cancel = true
            end
        end
    end
end

function check_moving()
    if state.DefenseMode.value == 'None'  and state.Kiting.value == false then
        if state.Auto_Kite.value == false and moving then
            state.Auto_Kite:set(true)
        elseif state.Auto_Kite.value == true and moving == false then
            state.Auto_Kite:set(false)
        end
    end
end

	--Allows equipping of warp/exp rings without auto swapping back to current set
function check_gear()
    if no_swap_gear:contains(player.equipment.left_ring) then
        disable("ring1")
    else
        enable("ring1")
    end
    if no_swap_gear:contains(player.equipment.right_ring) then
        disable("ring2")
    else
        enable("ring2")
    end
end

windower.register_event('zone change',
    function()
        if no_swap_gear:contains(player.equipment.left_ring) then
            enable("ring1")
            equip(sets.idle)
        end
        if no_swap_gear:contains(player.equipment.right_ring) then
            enable("ring2")
            equip(sets.idle)
        end
    end
)

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 12)
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end
