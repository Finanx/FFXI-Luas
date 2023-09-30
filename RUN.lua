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
--			    	[ Windows + W ]			Toggles Weapon sets
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
--  Job Specific Keybinds (Rune Fencer Binds)
-------------------------------------------------------------------------------------------------------------------
--
--	Modes:			[ Windows + 1 ]			Epeolatry Weapon set
--					[ Windows + 2 ]			Aettir Weapon set
--					[ Windows + 3 ]			Lycurgos Weapon set
--					[ Windows + E]			Toggle Grip Sets
--
--	Echo Binds:		[ CTRL + Numpad- ]		Shows main Weaponskill Binds in game
--					[ ALT + Numpad- ]		Shows Alternate Weaponskill Binds in game
--					[ Shift + Numpad- ]		Shows Item Binds in game
--					[ Windows + Numpad- ]	Shows Food/Weapon/Misc. Binds in game
--
--  Abilities:  	[ CTRL + ` ]        	Use current Rune
--              	[ Alt + ` ]         	Rune element cycle forward.
--              	[ Shift + ` ]       	Rune element cycle backward.
--
-- Spell Binds:		[ ALT + ` ]				Cycle Barspells
--					[ ALT + - ]				Cast Barspell
--					[ ALT + = ]				Cycle Back Barspells
--
-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.
-------------------------------------------------------------------------------------------------------------------
-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
	--include('Sel-Include.lua')
	include('Mote-Include.lua')
    res = require 'resources'
end

-- Setup vars that are user-independent.
function job_setup()

    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
					"Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring", "Emporox's Ring"}

	include('Mote-TreasureHunter')

    -- /BLU Spell Maps
    blue_magic_maps = {}

    blue_magic_maps.Enmity = S{'Blank Gaze', 'Geist Wall', 'Jettatura', 'Soporific',
        'Poison Breath', 'Blitzstrahl', 'Sheep Song', 'Chaotic Eye'}
    blue_magic_maps.Cure = S{'Wild Carrot'}
    blue_magic_maps.Buffs = S{'Cocoon', 'Refueling'}

    rayke_duration = 35
    gambit_duration = 96

end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

function user_setup()
    state.OffenseMode:options('InquartataTank', 'T3Tank', 'Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.HybridMode:options('Normal', 'DT')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'Refresh')
	state.TreasureMode:options('Tag', 'None')


    state.WeaponSet = M{['description']='Weapon Set', 'Epeolatry', 'Aettir', 'Lycurgos', 'Dolichenus'}
	state.GripSet = M{['description']='Grip Set', 'Refined', 'Utu'}
	state.WeaponLock = M(false, 'Weapon Lock')
    state.CP = M(false, "Capacity Points Mode")

    state.Runes = M{['description']='Runes', 'Tenebrae', 'Lux', 'Ignis', 'Gelus', 'Flabra', 'Tellus', 'Sulpor', 'Unda'}
	state.Barspell = M{['description']='Barspell', '"Barfire"', '"Barblizzard"', '"Baraero"', '"Barstone"','"Barthunder"', '"Barwater"',}

	--Load Gearinfo/Dressup Lua
	
    send_command('wait 3; lua l gearinfo')
	send_command('wait 10; lua l Dressup')

    --Global Rune Fencer binds (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)
	
	send_command('bind @u input //gi ugs')
	send_command('bind @d input //lua u dressup; wait 10; input //lua l dressup')
    send_command('bind @c gs c toggle CP')
	send_command('bind @t gs c cycle TreasureMode')
	send_command('bind @e gs c cycle GripSet')
	send_command('bind @w gs c toggle WeaponLock')
	send_command('bind ^` input //gs c rune')
	send_command('bind ^= gs c cycle Runes')
	send_command('bind ^- gs c cycleback Runes')
	send_command('bind ^space tc nearest')
	
	send_command('bind !` input //gs c barspell')
    send_command('bind !- gs c cycleback Barspell')
    send_command('bind != gs c cycle Barspell')
	
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
		input /echo [ Windows + E ]	Toggles GripSet;
		input /echo [ Windows + 1 ]	Sets Weapon to Epeolatry;
		input /echo [ Windows + 2 ]	Sets Weapon to Aettir;
		input /echo [ Windows + 3 ]	Sets Weapon to Lycurgos;
		input /echo -----Toggles-----;
		input /echo [ Windows + U ]	Toggles Gearswap autoupdate;
		input /echo [ Windows + D ]	Unloads then reloads dressup;
		]])
	
	--Weapon set Binds

	send_command('bind @1 gs c set WeaponLock off; gs c set WeaponSet Epeolatry')
	send_command('bind @2 gs c set WeaponLock off; gs c set WeaponSet Aettir')
	send_command('bind @3 gs c set WeaponLock off; gs c set WeaponSet Lycurgos')
	send_command('bind @4 gs c set WeaponLock off; gs c set WeaponSet Dolichenus')
	
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

	--Gear Retrieval Scripts (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)
	
	send_command('wait 10; input //get Aettir case')
	send_command('wait 10; input //get Deacon Sword case')
	send_command('wait 10; input //get Epeolatry case')
	send_command('wait 10; input //get Lycurgos case')
	send_command('wait 10; input //get Morgelai case')
	send_command('wait 10; input //get Kaja Axe case')
	send_command('wait 10; input //get Refined Grip +1 sack')
	send_command('wait 10; input //get Utu Grip sack')
	
	send_command([[bind @i ;
		input //get Aettir case;
		input //get Deacon Sword case;
		input //get Epeolatry case;
		input //get Lycurgos case;
		input //get Morgelai case;
		input //get Kaja Axe case;
		input //get Refined Grip +1 sack;
		input //get Utu Grip sack;
		]])
	
	--Job Settings
	
    select_default_macro_book()
    set_lockstyle()

	--gearinfo setup

    state.Auto_Kite = M(false, 'Auto_Kite')	
	Haste = 0
    moving = false
    update_combat_form()
	
end

function user_unload()

	enable('main','sub','range','ammo','head','body','hands','legs','feet','neck','waist','left_ear','right_ear','left_ring','right_ring','back')
    
	--Remove Global Rune Fencer Binds

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
	
	send_command('input //put Aettir case')
	send_command('input //put Deacon Sword case')
	send_command('input //put Epeolatry case')
	send_command('input //put Lycurgos case')
	send_command('input //put Morgelai case')
	send_command('input //put Kaja Axe case')
	send_command('input //put Refined Grip +1 sack')
	send_command('input //put Utu Grip sack')

	--Unload Dressup Lua
	
    send_command('lua u Dressup')
	send_command('lua u gearinfo')

end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Enmity sets
	sets.Enmity = {
		ammo="Staunch Tathlum +1",
		head="Halitus Helm",
		body="Emet Harness +1",
		hands="Kurys Gloves",
		legs="Eri. Leg Guards +3",
		feet="Erilaz Greaves +3",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Kasiri Belt",
		left_ear="Cryptic Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Eihwaz Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}
		
	sets.SiR_Enmity = {
		ammo="Staunch Tathlum +1",
		head="Erilaz Galea +3",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Rawhide Gloves", augments={'HP+50','Accuracy+15','Evasion+20',}},
		legs="Eri. Leg Guards +3",
		feet="Erilaz Greaves +3",
		neck="Moonlight Necklace",
		waist="Audumbla Sash",
		left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		right_ear="Magnetic Earring",
		left_ring="Evanescence Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Spell interruption rate down-10%',}},}
		
	sets.precast.JA['One for All'] = {
		ammo="Staunch Tathlum +1",
		head="Halitus Helm",
		body="Emet Harness +1",
		hands="Kurys Gloves",
		legs="Eri. Leg Guards +3",
		feet="Erilaz Greaves +3",
		neck={ name="Futhark Torque +2", augments={'Path: A',}},
		waist="Kasiri Belt",
		left_ear="Cryptic Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Eihwaz Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}

    sets.precast.JA['Vallation'] = {
		ammo="Staunch Tathlum +1",
		head="Halitus Helm",
		body="Runeist Coat +3",
		hands="Kurys Gloves",
		legs="Futhark Trousers +3",
		feet="Erilaz Greaves +3",
		neck={ name="Futhark Torque +2", augments={'Path: A',}},
		waist="Kasiri Belt",
		left_ear="Cryptic Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Eihwaz Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}
		
		
    sets.precast.JA['Valiance'] = sets.precast.JA['Vallation']
	
    sets.precast.JA['Pflug'] = {
		ammo="Staunch Tathlum +1",
		head="Halitus Helm",
		body="Emet Harness +1",
		hands="Kurys Gloves",
		legs="Eri. Leg Guards +3",
		feet="Erilaz Greaves +3",
		neck={ name="Futhark Torque +2", augments={'Path: A',}},
		waist="Kasiri Belt",
		left_ear="Cryptic Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Eihwaz Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}
		
    sets.precast.JA['Battuta'] = {
		ammo="Staunch Tathlum +1",
		head="Halitus Helm",
		body="Emet Harness +1",
		hands="Kurys Gloves",
		legs="Eri. Leg Guards +3",
		feet="Erilaz Greaves +3",
		neck={ name="Futhark Torque +2", augments={'Path: A',}},
		waist="Kasiri Belt",
		left_ear="Cryptic Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Eihwaz Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}
		
    sets.precast.JA['Liement'] = {
		ammo="Staunch Tathlum +1",
		head="Halitus Helm",
		body="Futhark Coat +3",
		hands="Kurys Gloves",
		legs="Eri. Leg Guards +3",
		feet="Erilaz Greaves +3",
		neck={ name="Futhark Torque +2", augments={'Path: A',}},
		waist="Kasiri Belt",
		left_ear="Cryptic Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Eihwaz Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}

    sets.precast.JA['Lunge'] = {
		ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
		head={ name="Agwu's Cap", augments={'Path: A',}},
		body={ name="Agwu's Robe", augments={'Path: A',}},
		hands={ name="Agwu's Gages", augments={'Path: A',}},
		legs={ name="Agwu's Slops", augments={'Path: A',}},
		feet={ name="Agwu's Pigaches", augments={'Path: A',}},
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear="Friomisi Earring",
		right_ear="Hecate's Earring",
		left_ring="Mujin Band",
		right_ring="Locus Ring",
		back={ name="Ogma's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},}

    sets.precast.JA['Swipe'] = sets.precast.JA['Lunge']
	
    sets.precast.JA['Gambit'] = {hands="Runeist Mitons +3"}
    sets.precast.JA['Rayke'] = {feet="Futhark Boots +3"}
    
	sets.precast.JA['Elemental Sforzo'] = {
		ammo="Staunch Tathlum +1",
		head="Halitus Helm",
		body={ name="Futhark Coat +3", augments={'Enhances "Elemental Sforzo" effect',}},
		hands="Kurys Gloves",
		legs="Eri. Leg Guards +3",
		feet="Erilaz Greaves +3",
		neck={ name="Futhark Torque +2", augments={'Path: A',}},
		waist="Kasiri Belt",
		left_ear="Cryptic Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Eihwaz Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}
		
    sets.precast.JA['Swordplay'] = {
		ammo="Staunch Tathlum +1",
		head="Halitus Helm",
		body="Emet Harness +1",
		hands="Kurys Gloves",
		legs="Eri. Leg Guards +3",
		feet="Erilaz Greaves +3",
		neck={ name="Futhark Torque +2", augments={'Path: A',}},
		waist="Kasiri Belt",
		left_ear="Cryptic Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Eihwaz Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}
		
	sets.precast.JA['Vivacious Pulse'] = {main={ name="Morgelai", augments={'Path: C',}},head="Erilaz Galea +3",} 
	
	
	sets.precast.RA = {
		range="Trollbane",
		head={ name="Taeon Chapeau", augments={'"Snapshot"+5','"Snapshot"+5',}},
		body={ name="Taeon Tabard", augments={'"Snapshot"+5','"Snapshot"+5',}},
		hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
		legs={ name="Taeon Tights", augments={'"Snapshot"+4','"Snapshot"+5',}},
		feet="Volte Spats",
		neck={ name="Futhark Torque +2", augments={'Path: A',}},
		waist="Yemaya Belt",
		left_ear="Tuisto Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Moonlight Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}


    -- Fast cast sets for spells

	sets.precast.FC = {
		ammo="Sapience Orb",
		head="Rune. Bandeau +3",
		body="Erilaz Surcoat +3",
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs="Agwu's Slops",
		feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
		neck="Orunmila's Torque",
		waist="Kasiri Belt",
		left_ear="Etiolation Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Kishar Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Spell interruption rate down-10%',}},}
		
	sets.precast.FC.Enhancing = set_combine(sets.precast.FC, {legs={ name="Futhark Trousers +3", augments={'Enhances "Inspire" effect',}},})
		
	sets.precast.FC.Val = set_combine(sets.precast.FC,{left_ear="Tuisto Earring",})
	
	sets.precast.FC.ValEnhancing = set_combine(sets.precast.FC.Val, {legs={ name="Futhark Trousers +3", augments={'Enhances "Inspire" effect',}},})
	

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

	sets.precast.WS = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Sherida Earring",
		left_ring="Regal Ring",
		right_ring="Niqmaddu Ring",
		back={ name="Ogma's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS.FullTP = {left_ear="Ishvara Earring",}

	sets.precast.WS['Resolution'] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Sherida Earring",
		left_ring="Epona's Ring",
		right_ring="Niqmaddu Ring",
		back={ name="Ogma's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Resolution'].FullTP = {left_ear="Ishvara Earring",}
	
	sets.precast.WS['Steel Cyclone'] = sets.precast.WS['Resolution']
    sets.precast.WS['Upheaval'] = sets.precast.WS['Resolution']

	sets.precast.WS['Dimidiation'] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Fotia Gorget",
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Sherida Earring",
		left_ring="Regal Ring",
		right_ring="Niqmaddu Ring",
		back={ name="Ogma's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Dimidiation'].Acc = {
		ammo="Yamarang",
		head="Erilaz Galea +3",
		body="Erilaz Surcoat +3",
		hands="Erilaz Gauntlets +3",
		legs="Eri. Leg Guards +3",
		feet="Erilaz Greaves +3",
		neck="Combatant's Torque",
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear="Odr Earring",
		right_ear="Mache Earring +1",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Ogma's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Dimidiation'].FullTP = {left_ear="Odr Earring",}
		
    sets.precast.WS['Herculean Slash'] = {
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
		left_ring="Epaminondas's Ring",
		right_ring="Shiva Ring +1",
		back={ name="Ogma's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},}
		
	sets.precast.WS['Frostbite'] = sets.precast.WS['Herculean Slash']
	sets.precast.WS['Freezebite'] = sets.precast.WS['Herculean Slash']

	sets.precast.WS['Herculean Slash'].FullTP = {left_ear="Hecate's Earring"}
		
    sets.precast.WS['Shockwave'] = {
		ammo="Yamarang",
		head="Erilaz Galea +3",
		body="Erilaz Surcoat +3",
		hands="Erilaz Gauntlets +3",
		legs="Eri. Leg Guards +3",
		feet="Erilaz Greaves +3",
		neck="Erra Pendant",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Crep. Earring",
		right_ear={ name="Erilaz Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+12','Mag. Acc.+12','Damage taken-4%',}},
		left_ring="Stikini Ring +1",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Ogma's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},}
		
    sets.precast.WS['Fell Cleave'] = {
		ammo="Knobkierrie",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Sherida Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Regal Ring",
		back={ name="Ogma's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Armor Break'] = {
		ammo="Yamarang",
		head="Erilaz Galea +3",
		body="Erilaz Surcoat +3",
		hands="Erilaz Gauntlets +3",
		legs="Eri. Leg Guards +3",
		feet="Erilaz Greaves +3",
		neck="Erra Pendant",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Crep. Earring",
		right_ear={ name="Erilaz Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+12','Mag. Acc.+12','Damage taken-4%',}},
		left_ring="Stikini Ring +1",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Ogma's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},}
		
	sets.precast.WS['Full Break'] = sets.precast.WS['Armor Break']
	sets.precast.WS['Weapon Break'] = sets.precast.WS['Armor Break']

	sets.precast.WS['Ruinator'] = {	
		ammo="Yamarang",
		head="Erilaz Galea +3",
		body="Erilaz Surcoat +3",
		hands="Erilaz Gauntlets +3",
		legs="Eri. Leg Guards +3",
		feet="Erilaz Greaves +3",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Odr Earring",
		right_ear="Mache Earring +1",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Ogma's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Ruinator'].Acc = sets.precast.WS['Ruinator']
    
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
	
	sets.midcast.RA = {
		range="Trollbane",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Flume Belt +1",
		left_ear="Sanare Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Defending Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast['Enhancing Magic'] = {
		ammo="Staunch Tathlum +1",
		head="Erilaz Galea +3",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Regal Gauntlets",
		legs={ name="Futhark Trousers +3", augments={'Enhances "Inspire" effect',}},
		feet="Erilaz Greaves +3",
		neck="Moonlight Necklace",
		waist="Audumbla Sash",
		left_ear="Tuisto Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Stikini Ring +1",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Spell interruption rate down-10%',}},}
		
	sets.midcast.BarElement = {
	    ammo="Staunch Tathlum +1",
		head="Erilaz Galea +3",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Regal Gauntlets",
		legs={ name="Futhark Trousers +3", augments={'Enhances "Inspire" effect',}},
		feet="Erilaz Greaves +3",
		neck="Incanter's Torque",
		waist="Audumbla Sash",
		left_ear="Mimir Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Stikini Ring +1",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Spell interruption rate down-10%',}},}
		
	sets.midcast['Aquaveil'] = set_combine(sets.midcast['Enhancing Magic'], {hands="Regal Cuffs",})
    
    sets.midcast['Phalanx'] = {
		main="Deacon Sword",
		ammo="Staunch Tathlum +1",
		head={ name="Fu. Bandeau +3", augments={'Enhances "Battuta" effect',}},
		body={ name="Taeon Tabard", augments={'Phalanx +3',}},
		hands={ name="Taeon Gloves", augments={'"Recycle"+7','Phalanx +3',}},
		legs={ name="Taeon Tights", augments={'Accuracy+19 Attack+19','"Triple Atk."+2','Phalanx +3',}},
		feet={ name="Herculean Boots", augments={'Sklchn.dmg.+4%','MND+4','Phalanx +4','Mag. Acc.+15 "Mag.Atk.Bns."+15',}},
		neck="Moonlight Necklace",
		waist="Olympus Sash",
		left_ear="Andoaa Earring",
		right_ear="Mimir Earring",
		left_ring="Defending Ring",
		right_ring="Stikini Ring +1",
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Spell interruption rate down-10%',}},}
		
	sets.PhalanxRecieved =    { 
		main="Deacon Sword",
		head={ name="Fu. Bandeau +3", augments={'Enhances "Battuta" effect',}},
		body={ name="Taeon Tabard", augments={'Phalanx +3',}},
		hands={ name="Taeon Gloves", augments={'"Recycle"+7','Phalanx +3',}},
		legs={ name="Taeon Tights", augments={'Accuracy+19 Attack+19','"Triple Atk."+2','Phalanx +3',}},
		feet={ name="Herculean Boots", augments={'Sklchn.dmg.+4%','MND+4','Phalanx +4','Mag. Acc.+15 "Mag.Atk.Bns."+15',}},}
		
	sets.midcast['Temper'] = {
		ammo="Staunch Tathlum +1",
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body="Manasa Chasuble",
		hands="Runeist Mitons +3",
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		feet={ name="Taeon Boots", augments={'Evasion+23','Spell interruption rate down -10%','HP+50',}},
		neck="Incanter's Torque",
		waist="Olympus Sash",
		left_ear="Andoaa Earring",
		right_ear="Mimir Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Merciful Cape",}

    sets.midcast['Regen'] = {
		main={ name="Morgelai", augments={'Path: C',}},
		ammo="Staunch Tathlum +1",
		head="Rune. Bandeau +3",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Regal Gauntlets",
		legs={ name="Futhark Trousers +3", augments={'Enhances "Inspire" effect',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Sacro Gorget",
		waist="Sroda Belt",
		left_ear="Tuisto Earring",
		right_ear={ name="Erilaz Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+12','Mag. Acc.+12','Damage taken-4%',}},
		left_ring="Moonlight Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Spell interruption rate down-10%',}},}
		
	sets.RegenRecieved = {right_ear={ name="Erilaz Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+12','Mag. Acc.+12','Damage taken-4%',}},}
		
    sets.midcast['Refresh'] = {
		ammo="Staunch Tathlum +1",
		head="Erilaz Galea +3",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Regal Gauntlets",
		legs={ name="Futhark Trousers +3", augments={'Enhances "Inspire" effect',}},
		feet={ name="Taeon Boots", augments={'Evasion+23','Spell interruption rate down -10%','HP+50',}},
		neck="Moonlight Necklace",
		waist="Gishdubar Sash",
		left_ear="Tuisto Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Moonlight Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Spell interruption rate down-10%',}},}
		
	sets.RefreshRecieved = {waist="Gishdubar Sash"}
		
    --sets.midcast['Divine Magic'] = {}

    sets.midcast.Flash = sets.Enmity
    sets.midcast.Foil = sets.Enmity

    sets.midcast['Blue Magic'] = sets.SiR_Enmity
    sets.midcast['Blue Magic'].Enmity = sets.SiR_Enmity
    sets.midcast['Blue Magic'].Buff = sets.SiR_Enmity
	sets.midcast['Banishga'] = sets.SiR_Enmity
	sets.midcast['Banishga II'] = sets.SiR_Enmity
	
	sets.midcast['Blue Magic'].Cure = {
		ammo="Staunch Tathlum +1",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Erilaz Gauntlets +3",
		legs="Eri. Leg Guards +3",
		feet="Erilaz Greaves +3",
		neck="Sacro Gorget",
		waist="Sroda Belt",
		left_ear="Mendi. Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Moonlight Ring",
		right_ring="Eihwaz Ring",
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Parrying rate+5%',}},}
	
	sets.midcast.Cure = {
	    ammo="Staunch Tathlum +1",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Erilaz Gauntlets +3",
		legs="Eri. Leg Guards +3",
		feet="Erilaz Greaves +3",
		neck="Sacro Gorget",
		waist="Sroda Belt",
		left_ear="Roundel Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Moonlight Ring",
		right_ring="Eihwaz Ring",
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Parrying rate+5%',}},}


    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.idle = {
		ammo="Staunch Tathlum +1",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body="Erilaz Surcoat +3",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Flume Belt +1",
		left_ear="Tuisto Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Moonlight Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}
		
	sets.idle.Refresh = {
		ammo="Homiliary",
		head="Rawhide Mask",
		body="Runeist Coat +3",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Fucho-no-Obi",
		left_ear="Sanare Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Defending Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}
		


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Herculean Boots", augments={'Accuracy+10 Attack+10','"Triple Atk."+4','Accuracy+14',}},
		neck="Anu Torque",
		waist="Windbuffet Belt +1",
		left_ear="Telos Earring",
		right_ear="Sherida Earring",
		left_ring="Epona's Ring",
		right_ring="Niqmaddu Ring",
		back={ name="Ogma's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
	sets.engaged.Acc = {
		ammo="Yamarang",
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		feet={ name="Herculean Boots", augments={'Accuracy+10 Attack+10','"Triple Atk."+4','Accuracy+14',}},
		neck="Combatant's Torque",
		waist="Ioskeha Belt +1",
		left_ear="Telos Earring",
		right_ear="Sherida Earring",
		left_ring="Chirich Ring +1",
		right_ring="Niqmaddu Ring",
		back={ name="Ogma's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
	sets.engaged.InquartataTank =	{
		ammo="Staunch Tathlum +1",																											--3%DT
		head={ name="Nyame Helm", augments={'Path: B',}},																					--7%DT
		body="Erilaz Surcoat +3",
		hands="Turms Mittens +1",
		legs="Eri. Leg Guards +3",																											--12%DT
		feet="Turms Leggings +1",
		neck={ name="Futhark Torque +2", augments={'Path: A',}},																			--7%DT
		waist="Engraved Belt",
		left_ear="Eabani Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},																		--3%DT
		left_ring="Defending Ring",																											--10%DT
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},																		--7%PDT
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Parrying rate+5%',}},}					
		--42% DT + 3%(Strap) 7% PDT

	sets.engaged.T3Tank =	{
		ammo="Staunch Tathlum +1",																											--3%DT
		head="Erilaz Galea +3",
		body="Erilaz Surcoat +3",
		hands="Erilaz Gauntlets +3",																										--11%DT
		legs="Eri. Leg Guards +3",																											--13%DT
		feet="Erilaz Greaves +3",																											--11%DT
		neck={ name="Warder's Charm +1", augments={'Path: A',}},
		waist="Flume Belt +1",																												--4%PDT
		left_ear="Tuisto Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},																		--3%DT
		left_ring="Roller's Ring",
		right_ring="Moonlight Ring",																										--5%DT
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Parrying rate+5%',}},}		
			--42% DT + 3%(Strap) 7% PDT		
	

    sets.engaged.Aftermath = {
		ammo="Aurgelmir Orb +1",
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Herculean Boots", augments={'Accuracy+10 Attack+10','"Triple Atk."+4','Accuracy+14',}},
		neck="Anu Torque",
		waist="Windbuffet Belt +1",
		left_ear="Telos Earring",
		right_ear="Sherida Earring",
		left_ring="Chirich Ring +1",
		right_ring="Niqmaddu Ring",
		back={ name="Ogma's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
		}
		
	sets.engaged.Acc.Aftermath = {
		ammo="Yamarang",
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		feet={ name="Herculean Boots", augments={'Accuracy+10 Attack+10','"Triple Atk."+4','Accuracy+14',}},
		neck="Combatant's Torque",
		waist="Ioskeha Belt +1",
		left_ear="Telos Earring",
		right_ear="Sherida Earring",
		left_ring="Chirich Ring +1",
		right_ring="Niqmaddu Ring",
		back={ name="Ogma's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
		}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid	= {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body="Ashera Harness",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Anu Torque",
		waist="Ioskeha Belt +1",
		left_ear="Brutal Earring",
		right_ear="Sherida Earring",
		left_ring="Niqmaddu Ring",
		right_ring="Moonlight Ring",
		back={ name="Ogma's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
		}
		
	sets.engaged.Hybrid.Aftermath	= {
		ammo="Yamarang",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body="Ashera Harness",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Anu Torque",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Telos Earring",
		right_ear="Sherida Earring",
		left_ring="Niqmaddu Ring",
		right_ring="Moonlight Ring",
		back={ name="Ogma's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
		}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	sets.Kiting = {right_ring="Shneddick Ring",}

    sets.TreasureHunter = {
		ammo="Per. Lucky Egg", --TH1
		body="Volte Jupon",		--TH2
		waist="Chaac Belt",} --TH+1

    sets.buff.Doom = {
		neck="Nicander's Necklace",
        waist="Gishdubar Sash", --10
        }
		
    sets.Embolden = {back={ name="Evasionist's Cape", augments={'Enmity+2','"Embolden"+15','"Dbl.Atk."+3',}},}
    sets.Obi = {waist="Hachirin-no-Obi"}
    sets.CP = {back="Mecisto. Mantle"}

	--Weapon Sets

    sets.Epeolatry = {main={ name="Epeolatry", augments={'Path: A',}},}
    sets.Aettir = {main="Aettir"}
	sets.Lycurgos = {main="Lycurgos"}
	sets.Dolichenus = {main="Kaja Axe"}
	
	--Grip Sets
	
	sets.Refined = {sub={ name="Refined Grip +1", augments={'Path: A',}},}
	sets.Utu = {sub="Utu Grip",}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific Functions
-------------------------------------------------------------------------------------------------------------------

function job_precast(spell, action, spellMap, eventArgs)

		--Stops gear from changing if unable to use due to status
	if buffactive['terror'] or buffactive['petrification'] or buffactive['stun'] or buffactive['sleep'] then
        add_to_chat(167, 'Stopped due to status.')
        eventArgs.cancel = true
        return
    end

		--Will use Vallation instead of Valiance if it is on cool down will also prevent from activating if Valiance is still up
    if spell.english == 'Valiance' then
        local abil_recasts = windower.ffxi.get_ability_recasts()
        if abil_recasts[spell.recast_id] > 0 then
            send_command('input /jobability "Vallation" <me>')
            eventArgs.cancel = true
            return
        elseif spell.english == 'Valiance' and buffactive['vallation'] then
            cast_delay(0.2)
            send_command('cancel Vallation') -- command requires 'cancel' add-on to work
        end
    end
	
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
	
    if spell.action_type == 'Magic' then
        if buffactive['Vallation'] or buffactive ['Valiance'] then
            if spell.skill == 'Enhancing Magic' then
                equip(sets.precast.FC.ValEnhancing)
            else
                equip(sets.precast.FC.Val)
            end
        else
            if spell.skill == 'Enhancing Magic' then
                equip(sets.precast.FC.Enhancing)
            else
                equip(sets.precast.FC)
            end
        end
    end
	
end

function job_post_precast(spell, action, spellMap, eventArgs)

	if spell.type == 'WeaponSkill' then
		if spell.english == 'Herculean Slash' or spell.english == 'Freezebite' or spell.english == 'Freezebite' then
			if player.tp > 2900 then
				equip(sets.precast.WS['Herculean Slash'].FullTP)
			end
		elseif spell.english == "Resolution" then
			if player.tp > 2900 then
				equip(sets.precast.WS['Resolution'].FullTP)
			end
		elseif spell.english == "Dimidiation" then
			if player.tp > 2900 then
				equip(sets.precast.WS['Dimidiation'].FullTP)
			end
		elseif spell.english == "Shockwave" or spell.english == "Armor Break" or spell.english == "Full Break" or spell.english == "Weapon Break" then
		else
			if player.tp > 2900 then
				equip(sets.precast.WS.FullTP)
			end
		end
	end
	
end

function job_aftercast(spell, action, spellMap, eventArgs)

		--Lets you know when Rayke/Gambit Wears off
    if spell.name == 'Rayke' and not spell.interrupted then
        send_command('@timers c "Rayke ['..spell.target.name..']" '..rayke_duration..' down spells/00136.png')
        send_command('wait '..rayke_duration..';input /echo [Rayke just wore off!];')
    elseif spell.name == 'Gambit' and not spell.interrupted then
        send_command('@timers c "Gambit ['..spell.target.name..']" '..gambit_duration..' down spells/00136.png')
        send_command('wait '..gambit_duration..';input /echo [Gambit just wore off!];')
    end
end

	--Handles Weapon/Grip set changes
function job_state_change(field, new_value, old_value)
    classes.CustomMeleeGroups:clear()
end

function job_buff_change(buff,gain)

		--Changes gear to tanking idle set when terrorized
    if buff == "terror" then
        if gain then
            equip(sets.idle)
        end
    end

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

		--equips Embolden duration back and locks while Embolden is active
    if buff == 'Embolden' then
        if gain then
            equip(sets.Embolden)
            disable('back')
        else
            enable('back')
            status_change(player.status)
        end
    end

		--Changes Engaged set when Aftermath is up
    if buff:startswith('Aftermath') then
        state.Buff.Aftermath = gain
        customize_melee_set()
        handle_equipping_gear(player.status)
    end

end

function customize_melee_set(meleeSet)
	if buffactive['Aftermath: Lv.3'] and player.equipment.main == "Epeolatry" and state.OffenseMode.value == 'Normal' and state.HybridMode.value == 'Normal' then
		meleeSet = sets.engaged.Aftermath
	end
	if buffactive['Aftermath: Lv.3'] and player.equipment.main == "Epeolatry" and state.OffenseMode.value == 'Acc' and state.HybridMode.value == 'Normal' then
		meleeSet = sets.engaged.Acc.Aftermath
	end
	if buffactive['Aftermath: Lv.3'] and player.equipment.main == "Epeolatry" and state.OffenseMode.value == 'Normal' and state.HybridMode.value == 'DT' then
		meleeSet = sets.engaged.Hybrid.Aftermath
	end
		if buffactive['Aftermath: Lv.3'] and player.equipment.main == "Epeolatry" and state.OffenseMode.value == 'Acc' and state.HybridMode.value == 'DT' then
		meleeSet = sets.engaged.Hybrid.Aftermath
	end
	
	return meleeSet
end

-------------------------------------------------------------------------------------------------------------------
-- Code for Melee sets
-------------------------------------------------------------------------------------------------------------------

	--Gearinfo related function
function job_handle_equipping_gear(playerStatus, eventArgs)
    update_combat_form()
	check_moving()
end

function job_update(cmdParams, eventArgs)
	check_gear()
	Weaponskill_Keybinds()
    handle_equipping_gear(player.status)
end

	--Adjusts Melee/Weapon sets for Dual Wield or Single Wield
function update_combat_form()
    if DW == true then
        state.CombatForm:set('DW')
    elseif DW == false then
        state.CombatForm:reset()
    end

	if state.WeaponSet.value == 'Epeolatry' then
		if state.WeaponLock.value == true then
			equip(sets.Epeolatry)
			disable('main')
		else
			enable('main')
			equip(sets.Epeolatry)
		end
	elseif state.WeaponSet.value == 'Aettir' then
		if state.WeaponLock.value == true then
			equip(sets.Aettir)
			disable('main')
		else
			enable('main')
			equip(sets.Aettir)
		end
	elseif state.WeaponSet.value == 'Lycurgos' then
		if state.WeaponLock.value == true then
			equip(sets.Lycurgos)
			disable('main')
		else
			enable('main')
			equip(sets.Lycurgos)
		end
	elseif state.WeaponSet.value == 'Dolichenus' then
		if state.WeaponLock.value == true then
			equip(sets.Dolichenus)
			disable('main')
		else
			enable('main')
			equip(sets.Dolichenus)
		end
	end
	
	if state.WeaponSet.value ~= 'Dolichenus' then
		if state.GripSet.value == 'Refined' then
			if state.WeaponLock.value == true then
				equip(sets.Refined)
				disable('sub')
			else
				enable('sub')
				equip(sets.Refined)
			end
		elseif state.GripSet.value == 'Utu' then
			if state.WeaponLock.value == true then
				equip(sets.Utu)
				disable('sub')
			else
				enable('sub')
				equip(sets.Utu)
			end
		end
	end

end

function Weaponskill_Keybinds()

	if state.WeaponSet.value == 'Epeolatry' or state.WeaponSet.value == 'Aettir' then
		send_command([[bind ^numpad- 
			input /echo -----Abilities-----;
			input /echo [ CTRL + ` ] Uses Assigned Rune;
			input /echo [ CTRL + - ] Cycleback Runes;
			input /echo [ CTRL + = ] Cycle Runes;
			input /echo -----Great_Sword-----;
			input /echo [ CTRL + Numpad1 ] Resolution;
			input /echo [ CTRL + Numpad2 ] Dimidiation;
			input /echo [ CTRL + Numpad3 ] Ground Strike;
			input /echo [ CTRL + Numpad4 ] Shockwave;
			input /echo [ CTRL + Numpad5 ] Herculean Slash;
			input /echo [ CTRL + Numpad6 ] Spinning Slash;
			input /echo [ CTRL + Numpad7 ] Sickle Moon;
			input /echo [ CTRL + Numpad9 ] Crescent Moon;
			input /echo [ CTRL + Numpad. ] Swipe;]])
		send_command('bind ^numpad1 input /ws "Resolution" <t>')
		send_command('bind ^numpad2 input /ws "Dimidiation" <t>')
		send_command('bind ^numpad3 input /ws "Ground Strike" <t>')
		send_command('bind ^numpad4 input /ws "Shockwave" <t>')
		send_command('bind ^numpad5 input /ws "Herculean Slash" <t>')
		send_command('bind ^numpad6 input /ws "Spinning Slash" <t>')
		send_command('bind ^numpad7 input /ws "Sickle Moon" <t>')
		send_command('bind ^numpad9 input /ws "Crescent Moon" <t>')
		send_command('bind ^numpad. input /ja "Swipe" <t>')

		send_command([[bind !numpad- 
			input /echo -----Abilities-----;
			input /echo [ ALT + ` ] Uses Assigned Barspell;
			input /echo [ ALT + - ] Cycleback Barspells;
			input /echo [ ALT + = ] Cycle Barspells;		
			input /echo -----Great_Sword-----;
			input /echo [ ALT + Numpad1 ] Hard Slash;
			input /echo [ ALT + Numpad2 ] Power Slash;
			input /echo [ ALT + Numpad3 ] Freezebite;
			input /echo [ ALT + Numpad4 ] Frostbite;
			input /echo [ ALT  + Numpad. ] Lunge;]])
		send_command('bind !numpad1 input /ws "Hard Slash" <t>')
		send_command('bind !numpad2 input /ws "Power Slash" <t>')
		send_command('bind !numpad3 input /ws "Freezebite" <t>')
		send_command('bind !numpad4 input /ws "Frostbite" <t>')
		send_command('bind !numpad. input /ja "Lunge" <t>')
			
	elseif state.WeaponSet.value == 'Lycurgos' then
		send_command([[bind ^numpad- 
			input /echo -----Abilities-----;
			input /echo [ CTRL + ` ] Uses Assigned Rune;
			input /echo [ CTRL + - ] Cycleback Runes;
			input /echo [ CTRL + = ] Cycle Runes;
			input /echo -----Great_Axe-----;
			input /echo [ CTRL + Numpad1 ] Upheaval;
			input /echo [ CTRL + Numpad2 ] Steel Cyclone;
			input /echo [ CTRL + Numpad3 ] Armor Break;
			input /echo [ CTRL + Numpad4 ] Fell Cleave;
			input /echo [ CTRL + Numpad5 ] Weapon Break;
			input /echo [ CTRL + Numpad6 ] Shield Break;
			input /echo [ CTRL + Numpad7 ] Keen Edge;
			input /echo [ CTRL + Numpad9 ] Sturmwind;
			input /echo [ CTRL + Numpad. ] Swipe;]])
		send_command('bind ^numpad1 input /ws "Upheaval" <t>')
		send_command('bind ^numpad2 input /ws "Steel Cyclone" <t>')
		send_command('bind ^numpad3 input /ws "Armor Break" <t>')
		send_command('bind ^numpad4 input /ws "Fell Cleave" <t>')
		send_command('bind ^numpad5 input /ws "Weapon Break" <t>')
		send_command('bind ^numpad6 input /ws "Shield Break" <t>')
		send_command('bind ^numpad7 input /ws "Keen Edge" <t>')
		send_command('bind ^numpad9 input /ws "Sturmwind" <t>')
		send_command('bind ^numpad. input /ja "Swipe" <t>')

		send_command([[bind !numpad- 
			input /echo -----Abilities-----;
			input /echo [ ALT + ` ] Uses Assigned Barspell;
			input /echo [ ALT + - ] Cycleback Barspells;
			input /echo [ ALT + = ] Cycle Barspells;		
			input /echo -----Great_Axe-----;
			input /echo [ ALT + Numpad1 ] Iron Tempest;
			input /echo [ ALT  + Numpad. ] Lunge;]])
		send_command('bind !numpad1 input /ja "Iron Tempest" <t>')
		send_command('bind !numpad. input /ja "Lunge" <t>')
		
	elseif state.WeaponSet.value == 'Dolichenus' then
		send_command([[bind ^numpad- 
			input /echo -----Abilities-----;
			input /echo [ CTRL + ` ] Uses Assigned Rune;
			input /echo [ CTRL + - ] Cycleback Runes;
			input /echo [ CTRL + = ] Cycle Runes;
			input /echo -----Axe-----;
			input /echo [ CTRL + Numpad1 ] Decimation;
			input /echo [ CTRL + Numpad2 ] Ruinator;
			input /echo [ CTRL + Numpad3 ] Bora Axe;
			input /echo [ CTRL + Numpad4 ] Rampage;
			input /echo [ CTRL + Numpad5 ] Gale Axe;
			input /echo [ CTRL + Numpad6 ] Avalanche Axe;
			input /echo [ CTRL + Numpad7 ] Spinning Axe;
			input /echo [ CTRL + Numpad9 ] Raging Axe;
			input /echo [ CTRL + Numpad. ] Swipe;]])
		send_command('bind ^numpad1 input /ws "Decimation" <t>')
		send_command('bind ^numpad2 input /ws "Ruinator" <t>')
		send_command('bind ^numpad3 input /ws "Bora Axe" <t>')
		send_command('bind ^numpad4 input /ws "Rampage" <t>')
		send_command('bind ^numpad5 input /ws "Gale Axe" <t>')
		send_command('bind ^numpad6 input /ws "Avalanche Axe" <t>')
		send_command('bind ^numpad7 input /ws "Spinning Axe" <t>')
		send_command('bind ^numpad9 input /ws "Raging Axe" <t>')
		send_command('bind ^numpad. input /ja "Swipe" <t>')

		send_command([[bind !numpad- 
			input /echo -----Abilities-----;
			input /echo [ ALT + ` ] Uses Assigned Barspell;
			input /echo [ ALT + - ] Cycleback Barspells;
			input /echo [ ALT + = ] Cycle Barspells;		
			input /echo -----Axe-----;
			input /echo [ ALT + Numpad1 ] Smash Axe;
			input /echo [ ALT  + Numpad. ] Lunge;]])
		send_command('bind !numpad1 input /ja "Smash Axe" <t>')
		send_command('bind !numpad. input /ja "Lunge" <t>')
	end

end

-- Modify the default idle set after it was constructed.
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
    local r_msg = state.Runes.current
    local r_color = ''
    if state.Runes.current == 'Ignis' then r_color = 167
    elseif state.Runes.current == 'Gelus' then r_color = 210
    elseif state.Runes.current == 'Flabra' then r_color = 204
    elseif state.Runes.current == 'Tellus' then r_color = 050
    elseif state.Runes.current == 'Sulpor' then r_color = 215
    elseif state.Runes.current == 'Unda' then r_color = 207
    elseif state.Runes.current == 'Lux' then r_color = 001
    elseif state.Runes.current == 'Tenebrae' then r_color = 160 end

    local cf_msg = ''
    if state.CombatForm.has_value then
        cf_msg = ' (' ..state.CombatForm.value.. ')'
    end

    local m_msg = state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        m_msg = m_msg .. '/' ..state.HybridMode.value
    end

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

    add_to_chat(r_color, string.char(129,121).. '  ' ..string.upper(r_msg).. '  ' ..string.char(129,122) ..string.char(31,002)..  ' | '
		..string.char(31,210).. 'Melee' ..cf_msg.. ': ' ..string.char(31,001)..m_msg.. string.char(31,002)..  ' |'
        ..string.char(31,207).. ' WS: ' ..string.char(31,001)..ws_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- handles Blue Magic Mapping
-------------------------------------------------------------------------------------------------------------------
function job_get_spell_map(spell, default_spell_map)
    if spell.skill == 'Blue Magic' then
        for category,spell_list in pairs(blue_magic_maps) do
            if spell_list:contains(spell.english) then
                return category
            end
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

	--Gear Info Functions 	--Handles the state.Runes which allows you to bind a key to cast a rune
function job_self_command(cmdParams, eventArgs)
    gearinfo(cmdParams, eventArgs)
	if cmdParams[1]:lower() == 'rune' then
        send_command('@input /ja '..state.Runes.value..' <me>')
	elseif cmdParams[1]:lower() == 'barspell' then
        send_command('@input /ma '..state.Barspell.value..' <me>')
    end
end

function gearinfo(cmdParams, eventArgs)
    if cmdParams[1] == 'gearinfo' then
        if type(tonumber(cmdParams[2])) == 'number' then
            if tonumber(cmdParams[2]) ~= DW_needed then
            DW_needed = tonumber(cmdParams[2])
            DW = true
            end
        elseif type(cmdParams[2]) == 'string' then
            if cmdParams[2] == 'false' then
                DW_needed = 0
                DW = false
              end
        end
        if type(tonumber(cmdParams[3])) == 'number' then
              if tonumber(cmdParams[3]) ~= Haste then
                  Haste = tonumber(cmdParams[3])
            end
        end
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


	--Auto Adjusts gear constantly if DW/Gearinfo is active
windower.register_event('zone change', 
    function()
        send_command('gi ugs true')
    end
)

	-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book: (set, book)
    if player.sub_job == 'BLU' then
        set_macro_page(3, 7)
    elseif player.sub_job == 'DRK' then
        set_macro_page(2, 7)
    elseif player.sub_job == 'WAR' then
        set_macro_page(1, 7)
    elseif player.sub_job == 'SAM' then
        set_macro_page(4, 7)
    elseif player.sub_job == 'PLD' then
        set_macro_page(5, 7)
    else
        set_macro_page(1, 7)
    end
end

function set_lockstyle()
    send_command('wait 5; input /lockstyleset 9')
end