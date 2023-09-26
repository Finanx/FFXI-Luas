-- Haste/DW Detection Requires Gearinfo Addon
-- Dressup is setup to auto load with this Lua
-- Itemizer addon is required for auto gear sorting / Warp Scripts / Range Scripts
--
-------------------------------------------------------------------------------------------------------------------
--  Keybinds
-------------------------------------------------------------------------------------------------------------------
--
--  Modes:      	[ F9 ]              	Cycle Offense Mode
--              	[ F10 ]             	Cycle Idle Mode
--              	[ F11 ]             	Cycle Casting Mode
--              	[ F12 ]             	Update Current Gear / Report Current Status
--					[ CTRL + F9 ]			Cycle Weapon Skill Mode
--					[ ALT + F9 ]			Cycle Range Mode
--              	[ Windows + F9 ]    	Cycle Hybrid Modes
--					[ Windows + T ]			Toggles Treasure Hunter Mode
--              	[ Windows + C ]     	Toggle Capacity Points Mode
--              	[ Windows + R ]     	Toggle Reraise Mode
--
-- Warp Script:		[ CTRL + Numpad+ ]		Warp Ring
--					[ ALT + Numpad+ ]		Dimensional Ring Dem
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
--  Job Specific Keybinds (Monk Binds)
-------------------------------------------------------------------------------------------------------------------
--
--	Weapons:		[ Windows: + 1 ]		Godhands Weapon Set
--					[ Windows: + 2 ]		Karambit Weapon Set
--					[ Windows: + 3 ]		Xoanon Weapon Set
--
-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()

    state.Buff['Impetus'] = buffactive['impetus'] or false

    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
					"Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring", "Emporox's Ring"}

	include('Mote-TreasureHunter')
	
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}
	
	lockstyleset = 10
end


-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'ATKCAP')
    state.HybridMode:options('Normal', 'DT', 'Counter')
    state.IdleMode:options('Normal')
	state.TreasureMode:options('Tag', 'None')

    state.CP = M(false, "Capacity Points Mode")
	state.WeaponSet = M{['description']='Weapon Set', 'Godhands', 'Karambit', 'Verethragna', 'Xoanon'}
	
	--Load Gearinfo/Dressup Lua
	
    send_command('wait 3; lua l gearinfo')
	send_command('wait 10; lua l Dressup')
	
    --Global Monk binds (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)

	send_command('bind @u input //gi ugs')
	send_command('bind @d input //lua u dressup; wait 10; input //lua l dressup')
	send_command('bind @t gs c cycle TreasureMode')
    send_command('bind @c gs c toggle CP')
	send_command('bind ^space tc nearest')
	
	--Command to show global binds in game[ CTRL + numpad- ]
	send_command([[bind ^numpad- 
		input /echo -----Item_Binds-----;
		input /echo [ Shift + Numpad1 ]	Echo Drop;
		input /echo [ Shift + Numpad2 ]	Holy Water;
		input /echo [ Shift + Numpad3 ]	Remedy;
		input /echo [ Shift + Numpad4 ]	Panacea;
		input /echo [ Shift + Numpad7 ]	Silent Oil;
		input /echo [ Shift + Numpad9 ]	Prism Powder;
		input /echo -----Food_Binds-----;
		input /echo [ Windows + Numpad1 ]	Sublime Sushi;
		input /echo [ Windows + Numpad2 ]	Grape Daifuku;
		input /echo [ Windows + Numpad3 ]	Tropical Crepe;
		input /echo [ Windows + Numpad4 ]	Miso Ramen;
		input /echo [ Windows + Numpad5 ]	Red Curry Bun;
		input /echo [ Windows + Numpad6 ]	Rolan. Daifuku;
		input /echo [ Windows + Numpad7 ]	Toolbag (Shihei);
		input /echo -----Modes-----;
		input /echo [ Windows + 1 ]	Sets Weapon to Godhands;
		input /echo [ Windows + 2 ]	Sets Weapon to Karambit;
		input /echo [ Windows + 3 ]	Sets Weapon to Xoanon;
		input /echo -----Toggles-----;
		input /echo [ Windows + U ]	Toggles Gearswap autoupdate;
		input /echo [ Windows + D ]	Unloads then reloads dressup;
		]])
		
	--Weapon set Binds

	send_command('bind @1 gs c set WeaponSet Godhands')
	send_command('bind @2 gs c set WeaponSet Karambit')
	send_command('bind @3 gs c set WeaponSet Xoanon')

	--Weaponskill Binds (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)


	
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
		
	--Ranged Scripts (Tags CTRL + Numpad0 as ranged attack) (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)

	send_command('bind ^numpad0 input /ra <t>')

	--Warp scripts (this allows the ring to stay in your satchel fulltime) (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)

	send_command('bind ^numpad+ input //get Warp Ring satchel; wait 1; input /equip Ring1 "Warp Ring"; wait 12; input /item "Warp Ring" <me>; wait 60; input //put Warp Ring satchel')
	send_command('bind !numpad+ input //get Dim. Ring (Dem) satchel; wait 1; input /equip Ring1 "Dim. Ring (Dem)"; wait 12; input /item "Dim. Ring (Dem)" <me>; wait 60; input //put Dim. Ring (Dem) satchel')
	
	--Gear Retrieval Scripts (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)
	
	send_command('wait 10; input //get Karambit case')
	send_command('wait 10; input //get Verethragna case')
	send_command('wait 10; input //get Godhands case')
	send_command('wait 10; input //get Xoanon case')
	send_command('wait 10; input //get Rigorous Grip +1 sack')
	
	send_command([[bind @i ;
		input //get Karambit case;
		input //get Verethragna case;
		input //get Godhands case;
		input //get Xoanon case;
		input //get Rigorous Grip +1 sack;
		]])

	--Job Settings
	
	select_default_macro_book()
    set_lockstyle()

	--Gearinfo functions

    state.Auto_Kite = M(false, 'Auto_Kite')
    moving = false
    update_combat_form()
	determine_impetus()
end


function user_unload()

	enable('main','sub','range','ammo','head','body','hands','legs','feet','neck','waist','left_ear','right_ear','left_ring','right_ring','back')

	--Remove Global Monk Binds
	
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
	
	send_command('input //put Karambit case')
	send_command('input //put Verethragna case')
	send_command('input //put Godhands case')
	send_command('input //put Xoanon case')
	send_command('input //put Rigorous Grip +1 sack')
	
	--send_command('wait 5; input //put Living Bullet satchel all')

	--Unload Gearinfo/Dressup Lua

    send_command('lua u gearinfo')
	send_command('lua u Dressup')
	
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    
    -- Precast sets to enhance JAs on use
    sets.precast.JA['Hundred Fists'] = {legs="Hesychast's Hose +1"}
    sets.precast.JA['Boost'] = {hands="Anchorite's Gloves +1"}
    sets.precast.JA['Dodge'] = {feet="Anchorite's Gaiters +1"}
    sets.precast.JA['Focus'] = {head="Anchorite's Crown +1"}
    sets.precast.JA['Counterstance'] = {feet="Hesychast's Gaiters +1"}
    sets.precast.JA['Footwork'] = {feet="Tantra Gaiters +2"}
    sets.precast.JA['Formless Strikes'] = {body="Hesychast's Cyclas"}
    sets.precast.JA['Mantra'] = {feet="Hesychast's Gaiters +1"}

    sets.precast.JA['Chi Blast'] = {
		ammo="Staunch Tathlum +1",
		head="Rawhide Mask",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Ahosi Leggings",
		neck="Phalaina Locket",
		waist="Luminary Sash",
		left_ear="Genmei Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}

    sets.precast.JA['Chakra'] = {    
		ammo="Staunch Tathlum +1",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Hiza. Hizayoroi +2",
		feet="Tatena. Sune. +1",
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Kasiri Belt",
		left_ear="Genmei Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Niqmaddu Ring",
		right_ring="Regal Ring",
		back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
	sets.precast.JA['Provoke'] = {
		ammo="Staunch Tathlum +1",
		head="Halitus Helm",
		body="Emet Harness +1",
		hands="Kurys Gloves",
		legs="Malignance Tights",
		feet="Ahosi Leggings",
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Kasiri Belt",
		left_ear="Friomisi Earring",
		right_ear="Cryptic Earring",
		left_ring="Eihwaz Ring",
		right_ring="Supershear Ring",
		back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}


    -- Fast cast sets for spells
    
    sets.precast.FC = {
		ammo="Sapience Orb",
		head={ name="Herculean Helm", augments={'Pet: Accuracy+21 Pet: Rng. Acc.+21','"Subtle Blow"+3','Weapon skill damage +7%','Mag. Acc.+10 "Mag.Atk.Bns."+10',}},
		body={ name="Samnuha Coat", augments={'Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+5','"Dual Wield"+5',}},
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
		feet="Malignance Boots",
		neck="Orunmila's Torque",
		waist="Kasiri Belt",
		left_ear="Loquac. Earring",
		right_ear="Etiolation Earring",
		left_ring="Defending Ring","Prolix Ring",
		right_ring="Prolix Ring",
		back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}

       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body="Bhikku Cyclas +2",
		hands="Bhikku Gloves +2",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Mpaca's Boots",
		neck="Rep. Plat. Medal",
		waist="Moonbow Belt +1",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear={ name="Schere Earring", augments={'Path: A',}},
		left_ring="Gere Ring",
		right_ring="Niqmaddu Ring",
		back={ name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10',}},}
		
    sets.precast.WS.Acc = {}
	
	sets.precast.WS.FullTPMagical = {left_ear="Hecate's Earring"}
	sets.precast.WS.FullTPPhysical = {left_ear="Sherida Earring",}
		
	sets.precast.WS["Victory Smite"] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body={ name="Mpaca's Doublet", augments={'Path: A',}},
		hands={ name="Ryuo Tekko +1", augments={'DEX+12','Accuracy+25','"Dbl.Atk."+4',}},
		legs={ name="Mpaca's Hose", augments={'Path: A',}},
		feet="Mpaca's Boots",
		neck="Fotia Gorget",
		waist="Moonbow Belt +1",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear={ name="Schere Earring", augments={'Path: A',}},
		left_ring="Gere Ring",
		right_ring="Niqmaddu Ring",
		back={ name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Crit.hit rate+10',}},}
		
	sets.precast.WS['Tornado Kick'] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Anch. Gaiters +3",
		neck={ name="Mnk. Nodowa +2", augments={'Path: A',}},
		waist="Moonbow Belt +1",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear={ name="Schere Earring", augments={'Path: A',}},
		left_ring="Gere Ring",
		right_ring="Niqmaddu Ring",
		back={ name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Dragon Kick'] = sets.precast.WS['Tornado Kick']
	
	sets.precast.WS['Tornado Kick'].Acc = {}
	
	sets.precast.WS['Raging Fists'] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body="Bhikku Cyclas +2",
		hands="Bhikku Gloves +2",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Mpaca's Boots",
		neck="Rep. Plat. Medal",
		waist="Moonbow Belt +1",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear={ name="Schere Earring", augments={'Path: A',}},
		left_ring="Gere Ring",
		right_ring="Niqmaddu Ring",
		back={ name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10',}},}
	
	sets.precast.WS["Raging Fists"].Acc = {}
	
	sets.precast.WS['Shijin Spiral'] = {
		ammo="Knobkierrie",
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Hiza. Hizayoroi +2",
		feet={ name="Herculean Boots", augments={'Accuracy+10 Attack+10','"Triple Atk."+4','Accuracy+14',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Sherida Earring",
		right_ear="Mache Earring +1",
		left_ring="Niqmaddu Ring",
		right_ring="Gere Ring",
		back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
	
	sets.precast.WS['Shijin Spiral'].Acc = {}
	
	sets.precast.WS['Howling Fist'] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Fotia Gorget",
		waist="Moonbow Belt +1",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear={ name="Schere Earring", augments={'Path: A',}},
		left_ring="Gere Ring",
		right_ring="Niqmaddu Ring",
		back={ name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
	
	sets.precast.WS['Howling Fist'].Acc = {}
	
	sets.precast.WS['Asuran Fists'] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Hes. Crown +3", augments={'Enhances "Penance" effect',}},
		body="Bhikku Cyclas +2",
		hands="Bhikku Gloves +2",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet="Mpaca's Boots",
		neck="Rep. Plat. Medal",
		waist="Moonbow Belt +1",
		left_ear="Sherida Earring",
		right_ear={ name="Schere Earring", augments={'Path: A',}},
		left_ring="Sroda Ring",
		right_ring="Ephramad's Ring",
		back={ name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10',}},}
	
	sets.precast.WS["Ascetic's Fury"] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body={ name="Mpaca's Doublet", augments={'Path: A',}},
		hands={ name="Ryuo Tekko +1", augments={'DEX+12','Accuracy+25','"Dbl.Atk."+4',}},
		legs={ name="Mpaca's Hose", augments={'Path: A',}},
		feet="Mpaca's Boots",
		neck="Fotia Gorget",
		waist="Moonbow Belt +1",
		left_ear="Sherida Earring",
		right_ear={ name="Schere Earring", augments={'Path: A',}},
		left_ring="Gere Ring",
		right_ring="Niqmaddu Ring",
		back={ name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Crit.hit rate+10',}},}
	
	sets.precast.WS['Spinning Attack'] = {
		ammo="Knobkierrie",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body={ name="Herculean Vest", augments={'Accuracy+4','Weapon skill damage +4%','DEX+10','Attack+13',}},
		hands="Mummu Wrists +2",
		legs="Hiza. Hizayoroi +2",
		feet={ name="Herculean Boots", augments={'Accuracy+10 Attack+10','"Triple Atk."+4','Accuracy+14',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Ishvara Earring",
		right_ear="Sherida Earring",
		left_ring="Niqmaddu Ring",
		right_ring="Gere Ring",
		back={ name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10',}},}
		
		
		
    -- Midcast Sets
    sets.midcast.FastRecast = {
		ammo="Sapience Orb",
		head={ name="Herculean Helm", augments={'Pet: Accuracy+21 Pet: Rng. Acc.+21','"Subtle Blow"+3','Weapon skill damage +7%','Mag. Acc.+10 "Mag.Atk.Bns."+10',}},
		body={ name="Samnuha Coat", augments={'Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+5','"Dual Wield"+5',}},
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
		feet="Malignance Boots",
		neck="Orunmila's Torque",
		waist="Kasiri Belt",
		left_ear="Loquac. Earring",
		right_ear="Etiolation Earring",
		left_ring="Prolix Ring",
		right_ring="Defending Ring",
		back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}

    -- Idle sets
    sets.idle = {
		ammo="Staunch Tathlum +1",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Moonbow Belt +1",
		left_ear="Eabani Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Ilabrat Ring",
		right_ring="Shadow Ring",
		back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}

 

    -- Engaged sets
    
    -- Normal melee sets
    sets.engaged = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Ken. Jinpachi +1",
		body={ name="Mpaca's Doublet", augments={'Path: A',}},
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs="Bhikku Hose +2",
		feet="Anch. Gaiters +3",
		neck={ name="Mnk. Nodowa +2", augments={'Path: A',}},
		waist="Moonbow Belt +1",
		left_ear="Sherida Earring",
		right_ear={ name="Schere Earring", augments={'Path: A',}},
		left_ring="Gere Ring",
		right_ring="Niqmaddu Ring",
		back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}

    sets.engaged.Acc = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Ken. Jinpachi +1",
		body={ name="Mpaca's Doublet", augments={'Path: A',}},
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs="Bhikku Hose +2",
		feet="Anch. Gaiters +3",
		neck={ name="Mnk. Nodowa +2", augments={'Path: A',}},
		waist="Moonbow Belt +1",
		left_ear="Sherida Earring",
		right_ear={ name="Schere Earring", augments={'Path: A',}},
		left_ring="Gere Ring",
		right_ring="Niqmaddu Ring",
		back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
	sets.engaged.Impetus = set_combine(sets.engaged, {body="Bhikku Cyclas +2",})
	sets.engaged.Acc.Impetus = set_combine(sets.engaged.Acc, {body="Bhikku Cyclas +2",})

	--Hybrid Sets
	
	sets.engaged.Hybrid = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Bhikku Crown +2",
		body={ name="Mpaca's Doublet", augments={'Path: A',}},
		hands="Mpaca's Gloves",
		legs="Bhikku Hose +2",
		feet="Mpaca's Boots",
		neck={ name="Mnk. Nodowa +2", augments={'Path: A',}},
		waist="Moonbow Belt +1",
		left_ear="Sherida Earring",
		right_ear={ name="Schere Earring", augments={'Path: A',}},
		left_ring="Gere Ring",
		right_ring="Niqmaddu Ring",
		back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
	sets.engaged.Counter = {
		ammo="Crepuscular Pebble",
		head="Bhikku Crown +2",
		body={ name="Mpaca's Doublet", augments={'Path: A',}},
		hands="Mpaca's Gloves",
		legs="Anch. Hose +2",
		feet="Bhikku Gaiters +2",
		neck={ name="Bathy Choker +1", augments={'Path: A',}},
		waist="Moonbow Belt +1",
		left_ear="Cryptic Earring",
		right_ear={ name="Bhikku Earring +2", augments={'System: 1 ID: 1676 Val: 0','Accuracy+17','Mag. Acc.+17','"Store TP"+6','STR+9 DEX+9',}},
		left_ring="Defending Ring",
		right_ring="Niqmaddu Ring",
		back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','System: 1 ID: 640 Val: 4',}},}

    -- Defensive melee hybrid sets
    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
    sets.engaged.Acc.DT = set_combine(sets.engaged.Acc, sets.engaged.Hybrid)
	sets.engaged.Counter = set_combine(sets.engaged, sets.engaged.Counter)
	sets.engaged.Acc.Counter = set_combine(sets.engaged.Acc, sets.engaged.Counter)
	
    sets.engaged.Impetus.DT = set_combine(sets.engaged.Impetus, sets.engaged.Hybrid)
    sets.engaged.Acc.Impetus.DT = set_combine(sets.engaged.Acc.Impetus, sets.engaged.Hybrid)
    sets.engaged.Impetus.Counter = set_combine(sets.engaged.Impetus, sets.engaged.Counter)
    sets.engaged.Acc.Impetus.Counter = set_combine(sets.engaged.Acc.Impetus, sets.engaged.Counter)
		
    --------------------------------------
    -- Custom buff sets
    --------------------------------------

	sets.Kiting = {left_ring="Shneddick Ring",}
	
	sets.Impetus = {body="Bhikku Cyclas +2",}
	
    sets.buff.Doom = {
		neck="Nicander's Necklace",
        waist="Gishdubar Sash", --10
        }

    sets.CP = {back="Mecisto. Mantle"}
    
    sets.TreasureHunter = {
		ammo="Per. Lucky Egg", --TH1
		body="Volte Jupon",		--TH2
		waist="Chaac Belt",} --TH+1
		
	sets.Godhands = {main="Karambit",}
	sets.Karambit = {main="Karambit",}
	sets.Xoanon = {main="Xoanon",sub={ name="Rigorous Grip +1", augments={'Path: A',}},}


end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific Functions
-------------------------------------------------------------------------------------------------------------------

function job_precast(spell, action, spellMap, eventArgs)

		--Will stop utsusemi from being cast if 2 shadows or more
    if spellMap == 'Utsusemi' then
        if buffactive['Copy Image (3)'] or buffactive['Copy Image (4+)'] then
            cancel_spell()
            add_to_chat(123, '**!! '..spell.english..' Canceled: [3+ IMAGES] !!**')
            eventArgs.handled = true
            return
        elseif buffactive['Copy Image'] or buffactive['Copy Image (2)'] then
            send_command('cancel 66; cancel 444; cancel Copy Image; cancel Copy Image (2)')
        end
    end

end

function job_post_precast(spell, action, spellMap, eventArgs)

		--Handles TP Overflow on Weapon skills
    if spell.type == "WeaponSkill" then
		if spell.english == "Victory Smite" or spell.english == "Ascetic\'s Fury" then
			if state.Buff['Impetus'] == true then
				equip(sets.Impetus)
			end
		else
			if spell.english == "Final Heaven" or spell.english == "Shijin Spiral" or spell.english == "Asuran Fists" or spell.english == "Shattersoul" or spell.english == "Shell Crusher" then
			else
				if spell.english == "Cataclysm" or spell.english == "Earth Crusher" then
					if player.tp > 2900 then
						equip(sets.precast.WS.FullTPMagical)
					end
				else
					if state.WeaponSet.value == "Godhands" then
						if player.tp > 2200 then
							equip(sets.precast.WS.FullTPPhysical)
						end
					elseif state.WeaponSet.value == "Karambit" or state.WeaponSet.value == "Xoanon" then
						if state.WeaponskillMode.value == "Normal" then
							if player.tp > 2700 then
								equip(sets.precast.WS.FullTPPhysical)
							end
						end
					end
				end
			end
		end
    end
end

function job_buff_change(buff,gain)

		--Auto equips Cursna Recieved doom set when doom debuff is on
    if buff == "doom" then
        if gain then
            equip(sets.buff.Doom)
            send_command('@input /p Doomed.')
            disable('neck','waist')
        else
            enable('neck','waist')
            handle_equipping_gear(player.status)
        end
    end

end

-------------------------------------------------------------------------------------------------------------------
-- Code for Melee sets
-------------------------------------------------------------------------------------------------------------------

-- Handles Gearinfo / Melee / Weapon / Range Sets
function job_handle_equipping_gear(playerStatus, eventArgs)
    update_combat_form()
	determine_impetus()
	check_moving()
end

function job_update(cmdParams, eventArgs)
	check_gear()
	Weaponskill_Keybinds()
    handle_equipping_gear(player.status)
end

	--Determines Dual Wield melee set
function update_combat_form()

	if state.WeaponSet.value == 'Godhands' then
		equip(sets.Godhands)
	end

	if state.WeaponSet.value == 'Karambit' then
		equip(sets.Karambit) 
	end
	
	if state.WeaponSet.value == 'Xoanon' then
		equip(sets.Xoanon) 
	end
	
end

function Weaponskill_Keybinds()

	if state.WeaponSet.value == 'Godhands' or state.WeaponSet.value == 'Karambit' then
		send_command([[bind !numpad- 
			input /echo -----H2H-----;
			input /echo [ CTRL + Numpad1 ] Howling Fist;
			input /echo [ CTRL + Numpad2 ] Tornado Kick;
			input /echo [ CTRL + Numpad3 ] Dragon Kick;
			input /echo [ CTRL + Numpad4 ] Victory Smite;
			input /echo [ CTRL + Numpad5 ] Raging Fists;
			input /echo [ CTRL + Numpad6 ] Shijin Spiral;
			input /echo [ CTRL + Numpad7 ] Asuran Fists;
			input /echo [ CTRL + Numpad9 ] Ascetic's Fury;
			input /echo [ CTRL + Numpad. ] Spinning Attack;]])
		send_command('bind ^numpad1 input /ws "Howling Fist" <t>')
		send_command('bind ^numpad2 input /ws "Tornado Kick" <t>')
		send_command('bind ^numpad3 input /ws "Dragon Kick" <t>')	
		send_command('bind ^numpad4 input /ws "Victory Smite" <t>')
		send_command('bind ^numpad5 input /ws "Raging Fists" <t>')
		send_command('bind ^numpad6 input /ws "Shijin Spiral" <t>')
		send_command('bind ^numpad7 input /ws "Asuran Fists" <t>')
		send_command('bind ^numpad9 input /ws "Ascetic\'s Fury" <t>')
		send_command('bind ^numpad. input /ws "Spinning Attack" <t>')
		
	elseif state.WeaponSet.value == 'Xoanon' then
		send_command([[bind !numpad- 
			input /echo -----Staff-----;
			input /echo [ ALT + Numpad1 ] Retribution;
			input /echo [ ALT + Numpad2 ] Full Swing;
			input /echo [ ALT + Numpad3 ] Shell Crusher;
			input /echo [ ALT + Numpad4 ] Cataclysm;
			input /echo [ ALT + Numpad5 ] Earth Crusher;
			input /echo [ ALT + Numpad6 ] Shattersoul;]])
		send_command('bind ^numpad1 input /ws "Retribution" <t>')
		send_command('bind ^numpad2 input /ws "Full Swing" <t>')
		send_command('bind ^numpad3 input /ws "Shell Crusher" <t>')
		send_command('bind ^numpad4 input /ws "Cataclysm" <t>')
		send_command('bind ^numpad5 input /ws "Earth Crusher" <t>')
		send_command('bind ^numpad6 input /ws "Shattersoul" <t>')
	end

end

function customize_idle_set(idleSet)

		--Allows CP back to stay on if toggled on
    if state.CP.current == 'on' then
        equip(sets.CP)
        disable('back')
    else
        enable('back')
    end
    
	if state.Auto_Kite.value == true then
       idleSet = set_combine(idleSet, sets.Kiting)
    end
	
    return idleSet
end

-- Function to display the current relevant user state when doing an update.
function display_current_job_state(eventArgs)
    local cf_msg = ''
    if state.CombatForm.has_value then
        cf_msg = ' (' ..state.CombatForm.value.. ')'
    end

    local m_msg = state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        m_msg = m_msg .. '/' ..state.HybridMode.value
    end

    local ws_msg = state.WeaponskillMode.value

    local c_msg = state.CastingMode.value

    local d_msg = 'None'
    if state.DefenseMode.value ~= 'None' then
        d_msg = state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
    end

    local i_msg = state.IdleMode.value

    local msg = ''
    if state.TreasureMode.value == 'Tag' then
        msg = msg .. ' TH: Tag |'
    end
    if state.Kiting.value then
        msg = msg .. ' Kiting: On |'
    end

    add_to_chat(002, '| ' ..string.char(31,210).. 'Melee' ..cf_msg.. ': ' ..string.char(31,001)..m_msg.. string.char(31,002)..  ' |'
        ..string.char(31,207).. ' WS: ' ..string.char(31,001)..ws_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

	--Determines Impetus Engaged Melee set
function determine_impetus()
    classes.CustomMeleeGroups:clear()
	
	if state.Buff['Impetus'] == true then
		classes.CustomMeleeGroups:append('Impetus')
    end
	
end

	--Gear Info Functions
function job_self_command(cmdParams, eventArgs)
    gearinfo(cmdParams, eventArgs)
end

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

	--Auto_Kite function
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
        set_macro_page(1, 1)
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end
