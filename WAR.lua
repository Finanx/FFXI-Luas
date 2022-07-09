-- Original: Finanx
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
--              	[ Windows + A ]     	AttackMode: Capped/Uncapped WS Modifier
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
--					[ Windows + Numpad7 ]	Toolbag (Shihei)
--
-- Warp Script:		[ CTRL + Numpad+ ]		Warp Ring
--					[ ALT + Numpad+ ]		Dimensional Ring Dem
--
-- Range Script:	[ CTRL + Numpad0 ]
--
-------------------------------------------------------------------------------------------------------------------
--  Job Specific Keybinds (Bard Binds)
-------------------------------------------------------------------------------------------------------------------
--
--	Weapons:		[ Windows: + 1 ]		Chango Weapon Set
--					[ Windows: + 2 ]		Naegling Weapon Set
--					[ Windows: + 3 ]		Shining_One Weapon Set
--					[ Windows: + 4 ]		Loxotic_Mace Weapon Set
--					[ Windows: + 5 ]		Dolichenus Weapon Set
--
--	Weaponskills:	[ CTRL + Numpad1 ]		Upheaval
--					[ CTRL + Numpad2 ]		Ukko's Furry
--					[ CTRL + Numpad3 ]		Fell Cleave
--					[ CTRL + Numpad4 ]		Full Break
--					[ CTRL + Numpad5 ]		Steel Cyclone
--					[ CTRL + Numpad6 ]		King's Justice
--					[ CTRL + Numpad7 ]		Raging Rush
--
--					[ ALT + Numpad1 ]		Impulse Drive
--					[ ALT + Numpad2 ]		Stardiver
--					[ ALT + Numpad3 ]		Sonic Thrust
--					[ ALT + Numpad4 ]		Savage Blade
--					[ ALT + Numpad5 ]		Sanguine Blade
--					[ ALT + Numpad6 ] 		Decimation
--					[ ALT + Numpad7 ]		Judgment
--					[ ALT + Numpad9 ]		Black Halo
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
	
    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
					"Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring", "Emporox's Ring"}

	include('Mote-TreasureHunter')

    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}



    lockstyleset = 17
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc')
    state.HybridMode:options('Normal', 'DT')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal')
	state.TreasureMode:options('Tag', 'None')
	state.AttackMode = M{['description']='Attack', 'Uncapped', 'Capped'}
	state.Reraise = M(false, "Reraise Mode")
	
	state.WeaponSet = M{['description']='Weapon Set', 'Chango', 'Shining_One', 'Naegling', 'Loxotic_Mace', 'Dolichenus'}

    state.CP = M(false, "Capacity Points Mode")

	--Load Gearinfo/Dressup Lua
	
	send_command('wait 10; lua l Dressup')

	--Global Warrior binds (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)
	
	send_command('bind @a gs c cycle AttackMode')
	send_command('bind @t gs c cycle TreasureMode')
	send_command('bind @c gs c toggle CP')
	send_command('bind @r gs c toggle Reraise')
	
	--Weapon set Binds

	send_command('bind @1 gs c set WeaponSet Chango')
	send_command('bind @2 gs c set WeaponSet Naegling')
	send_command('bind @3 gs c set WeaponSet Shining_One')
	send_command('bind @4 gs c set WeaponSet Loxotic_Mace')
	send_command('bind @5 gs c set WeaponSet Dolichenus')
	
	--Weaponskill Binds (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)
	
	send_command('bind ^numpad1 input /ws "Upheaval" <t>')
    send_command('bind ^numpad2 input /ws "Ukko\'s Fury" <t>')
    send_command('bind ^numpad3 input /ws "Fell Cleave" <t>')
	send_command('bind ^numpad4 input /ws "Armor Break" <t>')
    send_command('bind ^numpad5 input /ws "Steel Cyclone" <t>')
	send_command('bind ^numpad6 input /ws "King\'s Justice" <t>')
	send_command('bind ^numpad7 input /ws "Raging Rush" <t>')
	
	send_command('bind !numpad1 input /ws "Impulse Drive" <t>')
	send_command('bind !numpad2 input /ws "Stardiver" <t>')
	send_command('bind !numpad3 input /ws "Sonic Thrust" <t>')
	send_command('bind !numpad4 input /ws "Savage Blade" <t>')
	send_command('bind !numpad5 input /ws "Sanguine Blade" <t>')
	send_command('bind !numpad6 input /ws "Decimation" <t>')
	send_command('bind !numpad7 input /ws "Judgment" <t>')
	send_command('bind !numpad9 input /ws "Black Halo" <t>')
	
	
	--Dual Box binds (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)
	
	--send_command('bind @1 input //assist me; wait 0.5; input //send Aurorasky /attack')
	--send_command('bind @2 input //assist me; wait 0.5; input //send Ardana /attack')
	--send_command('bind @q input //assist me; wait 0.5; input //send Ardana /ma "Distract" <t>')
	
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
	send_command('bind @numpad7 input //get Toolbag (Shihe) satchel; wait 3; input /item "Toolbag (Shihei)" <me>')
		
	--Ranged Scripts (Tags CTRL + Numpad0 as ranged attack) (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)

	send_command('bind ^numpad0 input /ra <t>')

	--Warp scripts (this allows the ring to stay in your satchel fulltime) (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)

	send_command('bind ^numpad+ input //get Warp Ring satchel; wait 1; input /equip Ring1 "Warp Ring"; wait 12; input /item "Warp Ring" <me>; wait 60; input //put Warp Ring satchel')
	send_command('bind !numpad+ input //get Dim. Ring (Dem) satchel; wait 1; input /equip Ring1 "Dim. Ring (Dem)"; wait 12; input /item "Dim. Ring (Dem)" <me>; wait 60; input //put Dim. Ring (Dem) satchel')
	
	--Gear Retrieval Commands (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)
	
	--send_command('wait 10; input //get Trump Card satchel all')
		
	--Job Settings
	
	select_default_macro_book()
    set_lockstyle()

	--Gearinfo functions
	
    Haste = 0
    DW_needed = 0
    DW = false
    moving = false
    update_combat_form()
    determine_haste_group()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()

	enable('main','sub','range','ammo','head','body','hands','legs','feet','neck','waist','left_ear','right_ear','left_ring','right_ring','back')

	--Remove Global Warrior Binds
	
	send_command('unbind @a')
    send_command('unbind @t')
    send_command('unbind ^`')
	send_command('unbind @r')
	send_command('unbind @h')
	send_command('unbind @1')
	send_command('unbind @2')
	send_command('unbind @3')
	send_command('unbind @4')
	send_command('unbind @5')
	

	--Remove Dual Box Binds
	
	--send_command('unbind @1')
	--send_command('unbind @2')
	--send_command('unbind @q')
	
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
	
	send_command('unbind !numpad1')
    send_command('unbind !numpad2')
	send_command('unbind !numpad3')
    send_command('unbind !numpad4')
	send_command('unbind !numpad5')
    send_command('unbind !numpad6')
	send_command('unbind !numpad7')
	send_command('unbind !numpad8')
	send_command('unbind !numpad9')
	
	
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
	
	send_command('unbind @numpad1')
    send_command('unbind @numpad2')
	send_command('unbind @numpad3')
    send_command('unbind @numpad4')
	send_command('unbind @numpad5')
    send_command('unbind @numpad6')
	send_command('unbind @numpad7')
	send_command('unbind @numpad8')
	send_command('unbind @numpad9')
	
	--Remove Ranged Scripts
	
	send_command('unbind ^numpad0')
	
	--Remove Warp Scripts
	
	send_command('unbind ^numpad+')
	send_command('unbind !numpad+')
	
	--Gear Removal Commands
	
	--send_command('wait 5; input //put Living Bullet satchel all')

	--Unload Gearinfo/Dressup Lua

    send_command('lua u gearinfo')
	send_command('lua u Dressup')

end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.JA['Berserk'] = {}
    sets.precast.JA['Warcry'] = {}
    sets.precast.JA['Agressor'] = {}
	sets.precast.JA['Retaliation'] = {}
	sets.precast.JA['Warrior\'s Charge'] = {}
	sets.precast.JA['Tomahawk'] = {}
	sets.precast.JA['Restraint'] = {}
	sets.precast.JA['Blood Rage'] = {}
	sets.precast.JA['Mighty Strikes'] = {}

	sets.precast.JA['Provoke'] = {
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
		back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    sets.precast.Waltz = {
        ring1="Asklepian Ring",
        waist="Gishdubar Sash",
        }

    sets.precast.Waltz['Healing Waltz'] = {}

    sets.precast.FC = {
        }

    -- (10% Snapshot from JP Gifts)
		
		
	sets.precast.RA = {
		}

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

	--Generic Weapon Skill

    sets.precast.WS.Uncapped = {
		ammo="Knobkierrie",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Caro Necklace",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Thrud Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Epaminondas's Ring",
		right_ring="Regal Ring",
		back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS = {
		ammo="Knobkierrie",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Sakpata's Plate", augments={'Path: A',}},
		hands="Sakpata's Gauntlets",
		legs="Sakpata's Cuisses",
		feet="Sulev. Leggings +2",
		neck="Caro Necklace",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Thrud Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Epaminondas's Ring",
		right_ring="Regal Ring",
		back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

	--Great Axe Weapon Skills
	
	sets.precast.WS['Upheaval'] = {
		ammo="Knobkierrie",
		head="Sakpata's Helm",
		body={ name="Sakpata's Plate", augments={'Path: A',}},
		hands="Sakpata's Gauntlets",
		legs="Sakpata's Cuisses",
		feet="Sakpata's Leggings",
		neck="Combatant's Torque",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Thrud Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring="Niqmaddu Ring",
		back={ name="Cichol's Mantle", augments={'VIT+20','Accuracy+20 Attack+20','VIT+10','Weapon skill damage +10%',}},}

	sets.precast.WS['Upheaval'].Uncapped = {
		ammo="Knobkierrie",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Combatant's Torque",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Thrud Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring="Niqmaddu Ring",
		back={ name="Cichol's Mantle", augments={'VIT+20','Accuracy+20 Attack+20','VIT+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Ukko\'s Fury'] = {
	    ammo="Yetshila +1",
		head="Sakpata's Helm",
		body={ name="Sakpata's Plate", augments={'Path: A',}},
		hands="Sakpata's Gauntlets",
		legs="Sakpata's Cuisses",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Caro Necklace",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Thrud Earring",
		right_ear={ name="Schere Earring", augments={'Path: A',}},
		left_ring="Regal Ring",
		right_ring="Niqmaddu Ring",
		back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

	sets.precast.WS['Steel Cyclone'] = {
		ammo="Knobkierrie",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Caro Necklace",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Thrud Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Epaminondas's Ring",
		right_ring="Regal Ring",
		back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Steel Cyclone'].Uncapped = {
		ammo="Knobkierrie",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Caro Necklace",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Thrud Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Epaminondas's Ring",
		right_ring="Regal Ring",
		back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

	sets.precast.WS['Fell Cleave'] = sets.precast.WS['Steel Cyclone']
	sets.precast.WS['Fell Cleave'].Uncapped = sets.precast.WS['Steel Cyclone'].Uncapped

	--Breaks
	
	sets.precast.WS['Full Break'] = {
		ammo="Pemphredo Tathlum",
		head="Sakpata's Helm",
		body={ name="Sakpata's Plate", augments={'Path: A',}},
		hands="Sakpata's Gauntlets",
		legs="Sakpata's Cuisses",
		feet="Sakpata's Leggings",
		neck="Moonlight Necklace",
		waist="Eschan Stone",
		left_ear="Digni. Earring",
		right_ear="Crep. Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Cichol's Mantle", augments={'STR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','Weapon skill damage +10%',}},}
	
	sets.precast.WS['Shield Break'] = sets.precast.WS['Full Break']
	sets.precast.WS['Armor Break'] = sets.precast.WS['Full Break']
	sets.precast.WS['Weapon Break'] = sets.precast.WS['Full Break']
	
	
	--Sword Weapon Skills
	
	sets.precast.WS['Savage Blade'] = {
		ammo="Knobkierrie",
		head="Sakpata's Helm",
		body={ name="Sakpata's Plate", augments={'Path: A',}},
		hands="Sakpata's Gauntlets",
		legs="Sakpata's Cuisses",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Caro Necklace",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Thrud Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Epaminondas's Ring",
		right_ring="Regal Ring",
		back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

	sets.precast.WS['Savage Blade'].Uncapped = {
		ammo="Knobkierrie",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Caro Necklace",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Thrud Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Epaminondas's Ring",
		right_ring="Regal Ring",
		back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
	
    sets.precast.WS['Sanguine Blade'] = {
		ammo="Knobkierrie",
		head="Pixie Hairpin +1",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear="Friomisi Earring",
		right_ear="Thrud Earring",
		left_ring="Archon Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Cichol's Mantle", augments={'STR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','Weapon skill damage +10%',}},}
		
	--Polearm Weapon Skills

	sets.precast.WS['Impulse Drive'] = sets.precast.WS['Savage Blade']	
	sets.precast.WS['Impulse Drive'].Uncapped = sets.precast.WS['Savage Blade'].Uncapped
	
	sets.precast.WS['Stardiver'] = sets.precast.WS['Savage Blade']	
	sets.precast.WS['Stardiver'].Uncapped = sets.precast.WS['Savage Blade'].Uncapped
	
	--Club Weapon Skills
	
	sets.precast.WS['Black Halo'] = sets.precast.WS['Savage Blade']	
	sets.precast.WS['Black Halo'].Uncapped = sets.precast.WS['Savage Blade'].Uncapped
	
	sets.precast.WS['Judgment'] = sets.precast.WS['Savage Blade']	
	sets.precast.WS['Judgment'].Uncapped = sets.precast.WS['Savage Blade'].Uncapped
		
	--Axe Weapon Skills
	
	sets.precast.WS['Decimation'] = {
	ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
    head="Sakpata's Helm",
    body={ name="Sakpata's Plate", augments={'Path: A',}},
    hands="Sakpata's Gauntlets",
    legs="Sakpata's Cuisses",
    feet="Sakpata's Leggings",
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear="Thrud Earring",
    right_ear={ name="Schere Earring", augments={'Path: A',}},
    left_ring="Regal Ring",
    right_ring="Niqmaddu Ring",
    back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.Utsusemi = sets.precast.FC

    -- Ranged gear
	
    sets.midcast.RA = {    
		ammo="Staunch Tathlum +1",
		head="Sakpata's Helm",
		body={ name="Sakpata's Plate", augments={'Path: A',}},
		hands="Sakpata's Gauntlets",
		legs="Sakpata's Cuisses",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Sanctity Necklace",
		waist="Audumbla Sash",
		left_ear="Eabani Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Mecisto. Mantle", augments={'Cap. Point+48%','CHR+3','Accuracy+2','DEF+10',}},}

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.resting = {    
		ammo="Staunch Tathlum +1",
		head="Sakpata's Helm",
		body={ name="Sakpata's Plate", augments={'Path: A',}},
		hands="Sakpata's Gauntlets",
		legs="Sakpata's Cuisses",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Sanctity Necklace",
		waist="Audumbla Sash",
		left_ear="Eabani Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    sets.idle = {    
		ammo="Staunch Tathlum +1",
		head="Sakpata's Helm",
		body={ name="Sakpata's Plate", augments={'Path: A',}},
		hands="Sakpata's Gauntlets",
		legs="Sakpata's Cuisses",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Sanctity Necklace",
		waist="Audumbla Sash",
		left_ear="Eabani Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.

    sets.engaged = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Flam. Zucchetto +2",
		body={ name="Tatena. Harama. +1", augments={'Path: A',}},
		hands={ name="Tatena. Gote +1", augments={'Path: A',}},
		legs={ name="Tatena. Haidate +1", augments={'Path: A',}},
		feet={ name="Tatena. Sune. +1", augments={'Path: A',}},
		neck="Sanctity Necklace",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Schere Earring", augments={'Path: A',}},
		right_ear="Telos Earring",
		left_ring="Chirich Ring +1",
		right_ring="Niqmaddu Ring",
		back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    sets.engaged.Acc = {
		ammo="Aurgelmir Orb +1",
		head="Flam. Zucchetto +2",
		body={ name="Tatena. Harama. +1", augments={'Path: A',}},
		hands={ name="Tatena. Gote +1", augments={'Path: A',}},
		legs={ name="Tatena. Haidate +1", augments={'Path: A',}},
		feet={ name="Tatena. Sune. +1", augments={'Path: A',}},
		neck="Combatant's Torque",
		waist="Ioskeha Belt",
		left_ear={ name="Schere Earring", augments={'Path: A',}},
		right_ear="Telos Earring",
		left_ring="Chirich Ring +1",
		right_ring="Niqmaddu Ring",
		back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    -- * DNC Subjob DW Trait: +15%
    -- * NIN Subjob DW Trait: +25%

    -- No Magic Haste (74% DW to cap)
    sets.engaged.DW = {}

    sets.engaged.DW.Acc = {}

    -- 15% Magic Haste (67% DW to cap)
    sets.engaged.DW.LowHaste = {}

    sets.engaged.DW.Acc.LowHaste = {}

    -- 30% Magic Haste (56% DW to cap)
    sets.engaged.DW.MidHaste = {}

    sets.engaged.DW.Acc.MidHaste = {}

    -- 35% Magic Haste (51% DW to cap)
    sets.engaged.DW.HighHaste = {}

    sets.engaged.DW.Acc.HighHaste = {}


    -- 45% Magic Haste (36% DW to cap) for /Nin
    sets.engaged.DW.MaxHaste = {}
    
	sets.engaged.DW.Acc.MaxHaste = {}
		
	-- 45% Magic Haste (36% DW to cap) for /DNC
	
	sets.engaged.DW.MaxHastePlus = {}
    
	sets.engaged.DW.Acc.MaxHastePlus = {}
	


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {    
		head="Sakpata's Helm",
		body={ name="Sakpata's Plate", augments={'Path: A',}},
		hands="Sakpata's Gauntlets",
		legs="Sakpata's Cuisses",
		feet="Sakpata's Leggings",}
		
		
    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
    sets.engaged.Acc.DT = set_combine(sets.engaged.Acc, sets.engaged.Hybrid)
	

    sets.engaged.DW.DT = set_combine(sets.engaged.DW, sets.engaged.Hybrid)
    sets.engaged.DW.Acc.DT = set_combine(sets.engaged.DW.Acc, sets.engaged.Hybrid)


    sets.engaged.DW.DT.LowHaste = set_combine(sets.engaged.DW.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.Acc.DT.LowHaste = set_combine(sets.engaged.DW.Acc.LowHaste, sets.engaged.Hybrid)


    sets.engaged.DW.DT.MidHaste = set_combine(sets.engaged.DW.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.Acc.DT.MidHaste = set_combine(sets.engaged.DW.Acc.MidHaste, sets.engaged.Hybrid)


    sets.engaged.DW.DT.HighHaste = set_combine(sets.engaged.DW.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.Acc.DT.HighHaste = set_combine(sets.engaged.DW.Acc.HighHaste, sets.engaged.Hybrid)


    sets.engaged.DW.DT.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.Acc.DT.MaxHaste = set_combine(sets.engaged.DW.Acc.MaxHaste, sets.engaged.Hybrid)

	
	sets.engaged.DW.DT.MaxHastePlus = set_combine(sets.engaged.DW.MaxHastePlus, sets.engaged.Hybrid)
    sets.engaged.DW.Acc.DT.MaxHastePlus = set_combine(sets.engaged.DW.Acc.MaxHastePlus, sets.engaged.Hybrid)


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------


    sets.TreasureHunter = {
		ammo="Per. Lucky Egg", --TH1
		body="Volte Jupon",		--TH2
		waist="Chaac Belt",} --TH+1

    sets.buff.Doom = {
		neck="Nicander's Necklace",
        waist="Gishdubar Sash", --10
        }

	sets.Warp = {left_ring="Warp Ring"}
    sets.CP = {back={ name="Mecisto. Mantle", augments={'Cap. Point+48%','CHR+3','Accuracy+2','DEF+10',}},}
    sets.Obi = {waist="Hachirin-no-Obi"}
	sets.Reraise = {head="Twilight Helm",body="Twilight Mail"}


	--Weaponsets

    sets.Chango = {main="Kaja Chopper", sub="Utu Grip"}
	sets.Shining_One = {main="Shining One", sub="Utu Grip"}
	sets.Naegling = {main="Naegling", sub="Blurred Shield +1",}
	sets.Loxotic_Mace = {main={ name="Loxotic Mace +1", augments={'Path: A',}},sub="Blurred Shield +1",}
	sets.Dolichenus = {}
	
	

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
	
	    -- Equip obi if weather/day matches for WS.
	if spell.type == 'WeaponSkill' then
        if spell.english == 'Sanguine Blade' and world.weather_element == 'Dark' or world.day_element == 'Dark' then
                equip(sets.Obi)
        end
        if spell.english == 'Red Lotus Blade' and (world.weather_element == 'Fire' or world.day_element == 'Fire') then
            equip(sets.Obi)
        end
		if spell.english == 'Seraph Blade' and (world.weather_element == 'Light' or world.day_element == 'Light') then
            equip(sets.Obi)
        end
    end
end

	--Allows an uncapped attack and a capped attack Weaponskill Set
function get_custom_wsmode(spell, action, spellMap)
    if spell.type == 'WeaponSkill' and state.AttackMode.value == 'Uncapped' then
        return "Uncapped"
    end
end

function job_state_change(field, new_value, old_value)
 
    equip(sets[state.WeaponSet.current])
	
	if state.Reraise.current == 'on' then
        equip(sets.Reraise)
        disable('head', 'body')
    else
        enable('head', 'body')
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
    determine_haste_group()
end

function job_update(cmdParams, eventArgs)
	check_gear()
    handle_equipping_gear(player.status)
end

	--Determines Dual Wield melee set
function update_combat_form()
    if DW == true then
        state.CombatForm:set('DW')
    elseif DW == false then
        state.CombatForm:reset()
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

    local am_msg = '(' ..string.sub(state.AttackMode.value,1,1).. ')'
	
    local ws_msg = state.WeaponskillMode.value

    local d_msg = 'None'
    if state.DefenseMode.value ~= 'None' then
        d_msg = state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
    end

    local i_msg = state.IdleMode.value

    local msg = ''
    if state.Kiting.value then
        msg = msg .. ' Kiting: On |'
    end
	
	if state.TreasureMode.value == 'Tag' then
        msg = msg .. ' TH: Tag |'
    end

    add_to_chat(002, '| ' ..string.char(31,210).. 'Melee' ..cf_msg.. ': ' ..string.char(31,001)..m_msg.. string.char(31,002)..  ' |'
        ..string.char(31,207).. ' WS' ..am_msg.. ': ' ..string.char(31,001)..ws_msg.. string.char(31,002)..  ' |'
        ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

	--Determines Haste Group / Melee set for Gear Info
function determine_haste_group()
    classes.CustomMeleeGroups:clear()
    if DW == true then
        if DW_needed <= 11 then
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif DW_needed > 11 and DW_needed <= 26 then
            classes.CustomMeleeGroups:append('HighHaste')
        elseif DW_needed > 26 and DW_needed <= 31 then
            classes.CustomMeleeGroups:append('MidHaste')
        elseif DW_needed > 31 and DW_needed <= 42 then
            classes.CustomMeleeGroups:append('LowHaste')
        elseif DW_needed > 42 then
            classes.CustomMeleeGroups:append('')
        end
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
        set_macro_page(1, 10)
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end
