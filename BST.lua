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
-- Range Script:	[ CTRL + Numpad0 ]
--
-- Toggles:			[ Windows + U ]			Stops Gear Swap from constantly updating gear
--					[ Windows + D ]			Unloads Dressup then reloads to change lockstyle
--
-------------------------------------------------------------------------------------------------------------------
--  Job Specific Keybinds (Beast Master Binds)
-------------------------------------------------------------------------------------------------------------------
--
--	Weapons:		[ Windows: + 1 ]		MACC_Axe Weapon Set
--					[ Windows: + 2 ]		Dolichenus Weapon Set
--					[ Windows: + 4 ]		Ikenga_Axe Weapon Set
--					[ Windows: + 3 ]		Naegling Weapon Set
--					[ Windows: + 5 ]		Malevolence Weapon Set
--
--	Weaponskills:	[ CTRL + Numpad1 ]		Upheaval
--					[ CTRL + Numpad2 ]		Ukko's Furry
--					[ CTRL + Numpad3 ]		Armor Break
--					[ CTRL + Numpad4 ]		Fell Cleave
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

-- INPUT PREFERRED JUG PETS HERE
	state.JugPet = M{['description']='Current Jug Pet', 
		'Dire Broth',				--slugman
		'Bubbly Broth', 			--cricket
		'C. Plasma Broth',			--leech
		'Lyrical Broth',			--sheep
		'Fizzy Broth',				--pig
		--'Salubrious Broth',		--pink bird
		--'Meaty Broth',			--tiger
		--'Rancid Broth',			--crab
		--'Poisonous Broth',		--acuex
		--'Livid Broth',			--lizard
		--'Blackwater Broth',		--fly
		--'Turpid Broth',			--hippo
		--'Decaying Broth',			--slime
	}	
	
    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
					"Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring", "Emporox's Ring"}

	include('Mote-TreasureHunter')

    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}



    lockstyleset = 18
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Complete list of Ready moves to use with Sic & Ready Recast -5 Desultor Tassets.

ready_moves_to_check = S{'Sic','Whirl Claws','Dust Cloud','Foot Kick','Sheep Song','Sheep Charge','Lamb Chop',
	'Rage','Head Butt','Scream','Dream Flower','Wild Oats','Leaf Dagger','Claw Cyclone','Razor Fang',
	'Roar','Gloeosuccus','Palsy Pollen','Soporific','Cursed Sphere','Venom','Geist Wall','Toxic Spit',
	'Numbing Noise','Nimble Snap','Cyclotail','Spoil','Rhino Guard','Rhino Attack','Power Attack',
	'Hi-Freq Field','Sandpit','Sandblast','Venom Spray','Mandibular Bite','Metallic Body','Bubble Shower',
	'Bubble Curtain','Scissor Guard','Big Scissors','Grapple','Spinning Top','Double Claw','Filamented Hold',
	'Frog Kick','Queasyshroom','Silence Gas','Numbshroom','Spore','Dark Spore','Shakeshroom','Blockhead',
	'Secretion','Fireball','Tail Blow','Plague Breath','Brain Crush','Infrasonics','??? Needles',
	'Needleshot','Chaotic Eye','Blaster','Scythe Tail','Ripper Fang','Chomp Rush','Intimidate','Recoil Dive',
	'Water Wall','Snow Cloud','Wild Carrot','Sudden Lunge','Spiral Spin','Noisome Powder','Wing Slap',
	'Beak Lunge','Suction','Drainkiss','Acid Mist','TP Drainkiss','Back Heel','Jettatura','Choke Breath',
	'Fantod','Charged Whisker','Purulent Ooze','Corrosive Ooze','Tortoise Stomp','Harden Shell','Aqua Breath',
	'Sensilla Blades','Tegmina Buffet','Molting Plumage','Swooping Frenzy','Pentapeck','Sweeping Gouge',
	'Zealous Snort','Somersault ','Tickling Tendrils','Stink Bomb','Nectarous Deluge','Nepenthic Plunge',
    'Pecking Flurry','Pestilent Plume','Foul Waters','Spider Web','Sickle Slash','Frogkick','Ripper Fang','Scythe Tail','Chomp Rush'}

		
mab_ready_moves = S{'Cursed Sphere','Venom','Toxic Spit',
	 'Venom Spray','Bubble Shower',
	 'Fireball','Plague Breath',
	 'Snow Cloud','Acid Spray','Silence Gas','Dark Spore',
	 'Charged Whisker','Purulent Ooze','Aqua Breath','Stink Bomb',
	 'Nectarous Deluge','Nepenthic Plunge','Foul Waters','Dust Cloud','Sheep Song','Scream','Dream Flower','Roar','Gloeosuccus','Palsy Pollen',
	 'Soporific','Geist Wall','Numbing Noise','Spoil','Hi-Freq Field',
	 'Sandpit','Sandblast','Filamented Hold',
	 'Spore','Infrasonics','Chaotic Eye',
	 'Blaster','Intimidate','Noisome Powder','TP Drainkiss','Jettatura','Spider Web',
	 'Corrosive Ooze','Molting Plumage','Swooping Frenzy',
	 'Pestilent Plume',}

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Pet')
    state.HybridMode:options('Normal', 'DT')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'ATKCAP')
	state.CorrelationMode = M{['description']='Correlation Mode', 'Neutral', 'HighAcc', 'MaxAcc',}
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal')
	state.TreasureMode:options('Tag', 'None')
	state.WeaponSet = M{['description']='Weapon Set', 'MACC_Axe', 'Dolichenus', 'Ikenga_Axe', 'Naegling', 'Malevolence'}
	state.Reraise = M(false, "Reraise Mode")
	


    state.CP = M(false, "Capacity Points Mode")

	--Load Gearinfo/Dressup Lua
	
	send_command('wait 3; lua l gearinfo')
	send_command('wait 10; lua l Dressup')

	--Global Warrior binds (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)
	
	send_command('bind @u input //gi ugs')
	send_command('bind @d input //lua u dressup; wait 10; input //lua l dressup')	
	send_command('bind @t gs c cycle TreasureMode')
	send_command('bind @c gs c toggle CP')
	send_command('bind @r gs c toggle Reraise')
	
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
		input /echo [ Windows + R ]	Puts Reraise Set on;
		input /echo [ Windows + 1 ]	Sets Weapon to MACC_Axe;
		input /echo [ Windows + 2 ]	Sets Weapon to Dolichenus;
		input /echo [ Windows + 3 ]	Sets Weapon to Ikenga_Axe;
		input /echo [ Windows + 4 ]	Sets Weapon to Naegling;
		input /echo [ Windows + 5 ]	Sets Weapon to Malevolence;
		input /echo -----Toggles-----;
		input /echo [ Windows + U ]	Toggles Gearswap autoupdate;
		input /echo [ Windows + D ]	Unloads then reloads dressup;
		]])
		
	--Command to show Rune Fencer binds in game[ ALT + numpad- ]
	send_command([[bind !numpad- 
		input /echo -----Abilities-----;
		input /echo  
		input /echo -----Great_Axe-----;
		input /echo [ CTRL + Numpad1 ] Upheaval;
		input /echo [ CTRL + Numpad2 ] Ukko's Fury;
		input /echo [ CTRL + Numpad3 ] Armor Break;
		input /echo [ CTRL + Numpad4 ] Fell Cleave;
		input /echo [ CTRL + Numpad5 ] Steel Cyclone;
		input /echo [ CTRL + Numpad6 ] King's Justice;
		input /echo [ CTRL + Numpad7 ] Raging Rush;
		input /echo -----Polearm-----;
		input /echo [ ALT + Numpad1 ] Impulse Drive;
		input /echo [ ALT + Numpad2 ] Stardiver;
		input /echo [ ALT + Numpad3 ] Sonic Thrust;
		input /echo -----Sword-----;
		input /echo [ ALT + Numpad4 ] Savage Blade;
		input /echo [ ALT + Numpad5 ] Sanguine Blade;
		input /echo -----Axe-----;
		input /echo [ ALT + Numpad6 ] Decimation;
		input /echo -----Club-----;
		input /echo [ ALT + Numpad7 ] Judgment;
		input /echo [ ALT + Numpad9 ] Black Halo;
		]])
	
	--Weapon set Binds

	send_command('bind @1 input /equip main; gs c set WeaponSet MACC_Axe')
	send_command('bind @2 input /equip main; gs c set WeaponSet Dolichenus')
	send_command('bind @3 input /equip main; gs c set WeaponSet Ikenga_Axe')
	send_command('bind @4 input /equip main; gs c set WeaponSet Naegling')
	send_command('bind @5 input /equip main; gs c set WeaponSet Malevolence')
	
	--Weaponskill Binds (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)
	
	send_command('bind ^numpad1 input /ws "Upheaval" <t>')
    send_command('bind ^numpad2 input /ws "Ukko\'s Fury" <t>')
	send_command('bind ^numpad3 input /ws "Armor Break" <t>')
    send_command('bind ^numpad4 input /ws "Fell Cleave" <t>')
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
	
	--Gear Retrieval Commands (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)
	
	--send_command('wait 10; input //get Trump Card satchel all')
		
	--Job Settings
	
	select_default_macro_book()
    set_lockstyle()

	--Gearinfo functions

    state.Auto_Kite = M(false, 'Auto_Kite')	
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

	send_command('unbind @u')
	send_command('unbind @d')
    send_command('unbind @t')
    send_command('unbind @c')
	send_command('unbind @r')
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

    sets.precast.JA['Berserk'] = {
		body="Pumm. Lorica +3",
		feet={ name="Agoge Calligae +3", augments={'Enhances "Tomahawk" effect',}},
		back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
    
	sets.precast.JA['Warcry'] = {head={ name="Agoge Mask +3", augments={'Enhances "Savagery" effect',}},}
    
	sets.precast.JA['Agressor'] = {
		head="Pummeler's Mask +3",
		body={ name="Agoge Lorica +3", augments={'Enhances "Aggressive Aim" effect',}},}
		
	sets.precast.JA['Warrior\'s Charge'] = {}
	sets.precast.JA['Tomahawk'] = {ammo="Thr. Tomahawk", feet={ name="Agoge Calligae +3", augments={'Enhances "Tomahawk" effect',}},}
	sets.precast.JA['Restraint'] = {hands="Boii Mufflers +3",}
	sets.precast.JA['Blood Rage'] = {body="Boii Lorica +3",}
	sets.precast.JA['Mighty Strikes'] = {hands={ name="Agoge Mufflers", augments={'Enhances "Mighty Strikes" effect',}},}

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
		back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}

    sets.precast.Waltz = {
        ring1="Asklepian Ring",
        waist="Gishdubar Sash",
        }

    sets.precast.Waltz['Healing Waltz'] = {}

    sets.precast.FC = {
        }

    -- (10% Snapshot from JP Gifts)
		
		
	sets.precast.RA = {
		range="Trollbane",
	    head={ name="Sakpata's Helm", augments={'Path: A',}},
		body={ name="Sakpata's Plate", augments={'Path: A',}},
		hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
		legs="Volte Tights",
		feet="Volte Spats",
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Audumbla Sash",
		left_ear="Tuisto Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring="Defending Ring",
		back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

	--Generic Weapon Skill

	sets.precast.WS = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Thrud Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Epaminondas's Ring",
		right_ring="Sroda Ring",
		back="Shadow Mantle",}
		
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
		head="Boii Mask +2",
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
		head="Boii Mask +2",
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
		head="Boii Mask +2",
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
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Thrud Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Epaminondas's Ring",
		right_ring="Sroda Ring",
		back="Shadow Mantle",}
		
	sets.precast.WS['Savage Blade'].ATKCAP = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Thrud Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Epaminondas's Ring",
		right_ring="Sroda Ring",
		back="Shadow Mantle",}
	
	sets.precast.WS['Aeolian Edge'] = {
		ammo="Staunch Tathlum +1",
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
		back="Shadow Mantle",}
		
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

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.Utsusemi = sets.precast.FC

    -- Ranged gear
	
    sets.midcast.RA = {    
		range="Trollbane",
	    head={ name="Sakpata's Helm", augments={'Path: A',}},
		body={ name="Sakpata's Plate", augments={'Path: A',}},
		hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
		legs="Volte Tights",
		feet="Volte Spats",
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Audumbla Sash",
		left_ear="Tuisto Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring="Defending Ring",
		back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}

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
		back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}

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
		back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.

    sets.engaged = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Malignance Chapeau",
		body={ name="Gleti's Cuirass", augments={'Path: A',}},
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Telos Earring",
		right_ear="Sherida Earring",
		left_ring="Epona's Ring",
		right_ring="Gere Ring",
		back="Shadow Mantle",}

    sets.engaged.Acc = {
		ammo="Aurgelmir Orb +1",
		head={ name="Sakpata's Helm", augments={'Path: A',}},
		body="Boii Lorica +3",
		hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
		legs="Pumm. Cuisses +3",
		feet="Pumm. Calligae +3",
		neck={ name="War. Beads +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Schere Earring", augments={'Path: A',}},
		right_ear={ name="Boii Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','Crit.hit rate+5',}},
		left_ring="Niqmaddu Ring",
		right_ring="Moonlight Ring",
		back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
	sets.engaged.SB = {
	    ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Sakpata's Helm", augments={'Path: A',}},
		body="Dagon Breast.",
		hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
		legs={ name="Sakpata's Cuisses", augments={'Path: A',}},
		feet={ name="Sakpata's Leggings", augments={'Path: A',}},
		neck={ name="War. Beads +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Schere Earring", augments={'Path: A',}},
		right_ear={ name="Boii Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','Crit.hit rate+5',}},
		left_ring="Niqmaddu Ring",
		right_ring="Moonlight Ring",
		back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}

    -- * DNC Subjob DW Trait: +15%
    -- * NIN Subjob DW Trait: +25%

    -- No Magic Haste (74% DW to cap)
    sets.engaged.DW = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Malignance Chapeau",
		body={ name="Gleti's Cuirass", augments={'Path: A',}},
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Telos Earring",
		right_ear="Sherida Earring",
		left_ring="Epona's Ring",
		right_ring="Gere Ring",
		back="Shadow Mantle",}

    sets.engaged.DW.Acc = {}

    -- 15% Magic Haste (67% DW to cap)
    sets.engaged.DW.LowHaste = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Malignance Chapeau",
		body={ name="Gleti's Cuirass", augments={'Path: A',}},
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Telos Earring",
		right_ear="Sherida Earring",
		left_ring="Epona's Ring",
		right_ring="Gere Ring",
		back="Shadow Mantle",}

    sets.engaged.DW.Acc.LowHaste = {}

    -- 30% Magic Haste (56% DW to cap)
    sets.engaged.DW.MidHaste = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Malignance Chapeau",
		body={ name="Gleti's Cuirass", augments={'Path: A',}},
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Telos Earring",
		right_ear="Sherida Earring",
		left_ring="Epona's Ring",
		right_ring="Gere Ring",
		back="Shadow Mantle",}

    sets.engaged.DW.Acc.MidHaste = {}

    -- 35% Magic Haste (51% DW to cap)
    sets.engaged.DW.HighHaste = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Malignance Chapeau",
		body={ name="Gleti's Cuirass", augments={'Path: A',}},
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Telos Earring",
		right_ear="Sherida Earring",
		left_ring="Epona's Ring",
		right_ring="Gere Ring",
		back="Shadow Mantle",}

    sets.engaged.DW.Acc.HighHaste = {}


    -- 45% Magic Haste (36% DW to cap) for /Nin
    sets.engaged.DW.MaxHaste = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Malignance Chapeau",
		body={ name="Gleti's Cuirass", augments={'Path: A',}},
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Telos Earring",
		right_ear="Sherida Earring",
		left_ring="Epona's Ring",
		right_ring="Gere Ring",
		back="Shadow Mantle",}
    
	sets.engaged.DW.Acc.MaxHaste = {}
		
	-- 45% Magic Haste (36% DW to cap) for /DNC
	
	sets.engaged.DW.MaxHastePlus = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Malignance Chapeau",
		body={ name="Gleti's Cuirass", augments={'Path: A',}},
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Telos Earring",
		right_ear="Sherida Earring",
		left_ring="Epona's Ring",
		right_ring="Gere Ring",
		back="Shadow Mantle",}
    
	sets.engaged.DW.Acc.MaxHastePlus = {}
	


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {    
		ammo="Aurgelmir Orb +1",
		head={ name="Sakpata's Helm", augments={'Path: A',}},
		body={ name="Sakpata's Plate", augments={'Path: A',}},
		hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
		legs={ name="Sakpata's Cuisses", augments={'Path: A',}},
		feet={ name="Sakpata's Leggings", augments={'Path: A',}},
		neck={ name="War. Beads +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Schere Earring", augments={'Path: A',}},
		right_ear={ name="Boii Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','Crit.hit rate+5',}},
		left_ring="Niqmaddu Ring",
		right_ring="Moonlight Ring",
		back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
		
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

	sets.Kiting = {feet="Hermes' Sandals"}

    sets.TreasureHunter = {
		ammo="Per. Lucky Egg", --TH1
		body="Volte Jupon",		--TH2
		waist="Chaac Belt",} --TH+1

    sets.buff.Doom = {
		neck="Nicander's Necklace",
        waist="Gishdub48ar Sash", --10
        }

	sets.Warp = {left_ring="Warp Ring"}
    sets.CP = {back={ name="Mecisto. Mantle", augments={'Cap. Point+48%','CHR+3','Accuracy+2','DEF+10',}},}
    sets.Obi = {waist="Hachirin-no-Obi"}
	sets.Reraise = {head="Crepuscular Helm",body="Crepuscular Mail",}


	--Weaponsets

	sets.MACC_Axe = {main="Agwu's Axe", sub="Adapa Shield",}
	sets.MACC_Axe.DW = {main="Agwu's Axe", sub="Ikenga's Axe",}	
	sets.Dolichenus = {main="Kaja Axe", sub="Adapa Shield",}
	sets.Dolichenus.DW = {main="Kaja Axe", sub="Ikenga's Axe",}
	sets.Ikenga_Axe = {main="Ikenga's Axe", sub="Adapa Shield",}
	sets.Ikenga_Axe.DW = {main="Ikenga's Axe", sub="Kaja Axe",}	
	sets.Naegling = {main="Naegling", sub="Adapa Shield",}
	sets.Naegling.DW = {main="Naegling", sub="Ikenga's Axe",}
	sets.Malevolence = {main={ name="Malevolence", augments={'INT+10','Mag. Acc.+10','"Mag.Atk.Bns."+10','"Fast Cast"+5',}}, sub="Adapa Shield",}
	sets.Malevolence.DW = {main={ name="Malevolence", augments={'INT+10','Mag. Acc.+10','"Mag.Atk.Bns."+10','"Fast Cast"+5',}}, sub="Ikenga's Axe",}


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

	cancel_conflicting_buffs(spell, action, spellMap, eventArgs)

	if spell.english == 'Bestial Loyalty' or spell.english == 'Call Beast' then					
		equip({ammo=state.JugPet.value})
	end    	

-- Define class for Sic and Ready moves.
    if ready_moves_to_check:contains(spell.name) and pet.status == 'Engaged' then
		equip(sets.midcast.Pet.ReadyRecast)
    end

end

-- Return true if we handled the aftercast work.  Otherwise it will fall back
-- to the general aftercast() code in Mote-Include.
function job_aftercast(spell, action, spellMap, eventArgs)
	if spell.type == "Monster" and not spell.interrupted then
		equip(set_combine(sets.midcast.Pet.WS, sets.midcast.Pet[state.CorrelationMode.value]))
		if mab_ready_moves:contains(spell.english) and pet.status == 'Engaged' then
			equip(sets.midcast.Pet.MabReady)
		end
 
		if buffactive['Unleash'] then
            hands="Gleti's Gauntlets"
        end
		
		eventArgs.handled = true
	end
end

function job_post_precast(spell, action, spellMap, eventArgs)



end

function job_state_change(field, new_value, old_value)
 
	if state.Reraise.value == true then
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

function Weapon_Change(field, new_value, old_value)

	if state.WeaponSet.value == 'MACC_Axe' then
		if player.sub_job == 'DNC' or player.sub_job == 'NIN' then
			equip(sets.MACC_Axe.DW)
		else
			equip(sets.MACC_Axe)
		end
	end
	
	if state.WeaponSet.value == 'Dolichenus' then
		if player.sub_job == 'DNC' or player.sub_job == 'NIN' then
			equip(sets.Dolichenus.DW)
		else
			equip(sets.Dolichenus)
		end
	end

	if state.WeaponSet.value == 'Ikenga_Axe' then
		if player.sub_job == 'DNC' or player.sub_job == 'NIN' then
			equip(sets.Ikenga_Axe.DW)
		else
			equip(sets.Ikenga_Axe)
		end
	end
	
	if state.WeaponSet.value == 'Naegling' then
		if player.sub_job == 'DNC' or player.sub_job == 'NIN' then
			equip(sets.Naegling.DW)
		else
			equip(sets.Naegling)
		end
	end
	
	if state.WeaponSet.value == 'Malevolence' then
		if player.sub_job == 'DNC' or player.sub_job == 'NIN' then
			equip(sets.Malevolence.DW)
		else
			equip(sets.Malevolence)
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
	check_moving()
	Weapon_Change()
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

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
        set_macro_page(1, 10)
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end
