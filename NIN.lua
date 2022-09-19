-- Original: Finanx
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
--			    	[ Windows + W ]         Toggles Weapon Lock
--  				[ Windows + R ]         Toggles Range Lock
--					[ Windows + T ]			Toggles Treasure Hunter Mode
--              	[ Windows + C ]     	Toggle Capacity Points Mode
--              	[ Windows + A ]     	AttackMode: Capped/Uncapped WS Modifier
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
-- Range Script:	[ CTRL + Numpad0 ] 		Ranged Attack
--
-------------------------------------------------------------------------------------------------------------------
--  Job Specific Keybinds (Ninja Binds)
-------------------------------------------------------------------------------------------------------------------
--
--	Modes:			[ Windows + m ]			Toggles Magic Burst Mode
--					[ Windows + 1 ]			Sets Weapon to Physical_Katana
--					[ Windows + 2 ]			Sets Weapon to Magical_Katana
--					[ Windows + 3 ]			Sets Weapon to Naegling
--					[ Windows + 4 ]			Sets Weapon to Gleti's_Knife
--
--  WS:         	[ CTRL + Numpad1 ]		Blade: Shun
--					[ CTRL + Numpad2 ]		Blade: Ten
--					[ CTRL + Numpad3 ]		Blade: Hi
--					[ CTRL + Numpad4 ]		Blade: Kamu
--					[ CTRL + Numpad5 ]		Blade: Metsu
--					[ CTRL + Numpad6 ]		Blade: Yu
--					[ CTRL + Numpad7 ]		Blade: Ei
--				
--					[ ALT + Numpad1 ]		Aeolian Edge
--					[ ALT + Numpad2 ]		Evisceration
--					[ ALT + Numpad4 ]		Savage Blade
--					[ ALT + Numpad5 ]		Sanguine Blade
--
--  Abilities:  	[ CTRL + ` ]        	Yonin
--					[ Alt + ` ]        		Innin
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
    state.Buff.Migawari = buffactive.migawari or false
    state.Buff.Yonin = buffactive.Yonin or false
    state.Buff.Innin = buffactive.Innin or false
    state.Buff.Futae = buffactive.Futae or false
    state.Buff.Sange = buffactive.Sange or false

    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
					"Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring", "Emporox's Ring"}

    include('Mote-TreasureHunter')

    -- For th_action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}

    lugra_ws = S{'Blade: Kamu', 'Blade: Shun', 'Blade: Ten'}

    lockstyleset = 16
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc')
    state.HybridMode:options('Normal', 'DT')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal')
	state.TreasureMode:options('Tag', 'None')
	state.WeaponSet = M{['description']='Weapon Set', 'Physical_Katana', 'Magic_Katana', 'Hachimonji', 'Naegling', 'Gletis_Knife'}
    state.WeaponLock = M(false, 'Weapon Lock')
	state.MagicBurst = M(false, 'Magic_Burst')

    state.CP = M(false, "Capacity Points Mode")

	--Load GearInfo/Dressup Lua

    send_command('wait 3; lua l gearinfo')
	send_command('wait 10; lua l Dressup')

    --Global Ninja binds (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)

	send_command('bind @t gs c cycle TreasureMode')
    send_command('bind @c gs c toggle CP')
	send_command('bind ^` input /ja "Yonin" <me>')
	send_command('bind !` input /ja "Innin" <me>')
	send_command('bind @m gs c toggle MagicBurst')
	
	--Weapon set Binds

	send_command('bind @1 input /equip sub; gs c set WeaponSet Physical_Katana')
	send_command('bind @2 input /equip sub; gs c set WeaponSet Magic_Katana')
	send_command('bind @3 input /equip sub; gs c set WeaponSet Hachimonji')
	send_command('bind @4 input /equip sub; gs c set WeaponSet Naegling')
	send_command('bind @5 input /equip sub; gs c set WeaponSet Gletis_Knife')
	send_command('bind @w gs c toggle WeaponLock')

	--Weaponskill Binds (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)

    send_command('bind ^numpad1 input /ws "Blade: Shun" <t>')
    send_command('bind ^numpad2 input /ws "Blade: Ten" <t>')
    send_command('bind ^numpad3 input /ws "Blade: Hi" <t>')
    send_command('bind ^numpad4 input /ws "Blade: To" <t>')
	send_command('bind ^numpad5 input /ws "Blade: Chi" <t>')
    send_command('bind ^numpad6 input /ws "Blade: Teki" <t>')
	send_command('bind ^numpad7 input /ws "Blade: Ei" <t>')
	send_command('bind ^numpad9 input /ws "Blade: Yu" <t>')
	send_command('bind ^numpad. input /ws "Blade: Kamu" <t>')
	
	send_command('bind !numpad7 input /ws "Aeolian Edge" <t>')
	send_command('bind !numpad9 input /ws "Evisceration" <t>')
		
	send_command('bind !numpad4 input /ws "Savage Blade" <t>')
	send_command('bind !numpad5 input /ws "Sanguine Blade" <t>')
	
	send_command('bind !numpad1 input /ws "Tachi: Jinpu" <t>')
	send_command('bind !numpad2 input /ws "Tachi: Goten" <t>')
	send_command('bind !numpad3 input /ws "Tachi: Kagero" <t>')
	send_command('bind !numpad. input /ws "Tachi: Koki" <t>')
	
	
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
		
	--Ranged Scripts  (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)

	send_command('bind ^numpad0 input /ra <t>')

	--Warp scripts (this allows the ring to stay in your satchel fulltime) (Requires Itemizer Addon) (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)

	send_command('bind ^numpad+ input //get Warp Ring satchel; wait 1; input /equip Ring1 "Warp Ring"; wait 12; input /item "Warp Ring" <me>; wait 60; input //put Warp Ring satchel')
	send_command('bind !numpad+ input //get Dim. Ring (Dem) satchel; wait 1; input /equip Ring1 "Dim. Ring (Dem)"; wait 12; input /item "Dim. Ring (Dem)" <me>; wait 60; input //put Dim. Ring (Dem) satchel')
	
	
	--Gear Retrieval Commands
		
	--Tools
	
	send_command('wait 10; input //get Shihei satchel all')
	send_command('wait 10; input //get Chonofuda satchel all')
	send_command('wait 10; input //get Shikanofuda satchel all')
	send_command('wait 10; input //get Inoshishinofuda satchel all')
	
	--Job Settings


    select_default_macro_book()
    set_lockstyle()

	--Gearinfo Functions
	
    state.Auto_Kite = M(false, 'Auto_Kite')
    Haste = 0
    DW_needed = 0
    DW = false
    moving = false
    update_combat_form()
    determine_haste_group()
end

function user_unload()

	enable('main','sub','range','ammo','head','body','hands','legs','feet','neck','waist','left_ear','right_ear','left_ring','right_ring','back')
	
	--Remove Global Ninja Binds	
	
    send_command('unbind @t')
    send_command('unbind @w')
	send_command('unbind @c')
	send_command('unbind ^`')
	send_command('unbind !`')
	send_command('unbind @`')
    send_command('unbind @m')
	
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
	
	--Remove Toolbag Scripts
	
    send_command('unbind ^numpad.')
    send_command('unbind @numpad.')
	send_command('unbind !numpad.')
	send_command('unbind !numpad0')
	
	--Gear Removal Commands
	
	--Tools
	
	send_command('wait 5; input //put Shihei satchel all')
	send_command('wait 5; input //put Chonofuda satchel all')
	send_command('wait 5; input //put Shikanofuda satchel all')
	send_command('wait 5; input //put Inoshishinofuda satchel all')

	--Unload Gearinfo/Dressup Lua
	
    send_command('lua u gearinfo')
	send_command('lua u Dressup')
	
end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Enmity set
    sets.Enmity = {
		ammo="Per. Lucky Egg",
		head="Malignance Chapeau",
		body="Volte Jupon",
		hands="Kurys Gloves",
		legs={ name="Zoar Subligar +1", augments={'Path: A',}},
		feet="Ahosi Leggings",
		neck="Moonlight Necklace",
		waist="Chaac Belt",
		left_ear="Cryptic Earring",
		right_ear="Friomisi Earring",
		left_ring="Eihwaz Ring",
		right_ring="Begrudging Ring",
		back={ name="Andartia's Mantle", augments={'HP+60','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10',}},
        }

    sets.precast.JA['Provoke'] = sets.Enmity
    sets.precast.JA['Mijin Gakure'] = {}
    sets.precast.JA['Futae'] = {hands="Hattori Tekko +1",}
    sets.precast.JA['Sange'] = {}
    sets.precast.JA['Innin'] = {}
    sets.precast.JA['Yonin'] = {}

    sets.precast.Waltz = {
        ammo="Yamarang",
        waist="Gishdubar Sash",
        }

    sets.precast.Waltz['Healing Waltz'] = {}

    -- Fast cast sets for spells

    sets.precast.FC = {
		ammo="Sapience Orb",
		head={ name="Herculean Helm", augments={'Pet: Accuracy+21 Pet: Rng. Acc.+21','"Subtle Blow"+3','Weapon skill damage +7%','Mag. Acc.+10 "Mag.Atk.Bns."+10',}},
		body={ name="Adhemar Jacket +1", augments={'HP+105','"Fast Cast"+10','Magic dmg. taken -4',}},
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
		feet="Malignance Boots",
		neck="Orunmila's Torque",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Loquac. Earring",
		right_ear="Etiolation Earring",
		left_ring="Prolix Ring",
		right_ring="Kishar Ring",
		back={ name="Andartia's Mantle", augments={'HP+60','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10',}},}

    sets.precast.RA = {}

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------
	
    sets.precast.WS = {
		ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
		head="Mpaca's Cap",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		left_ring="Regal Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

    sets.precast.WS['Blade: Hi'] = {
		ammo="Yetshila +1",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Odr Earring",
		right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		left_ring="Begrudging Ring",
		right_ring="Regal Ring",
		back={ name="Andartia's Mantle", augments={'AGI+20','Accuracy+20 Attack+20','AGI+10','Crit.hit rate+10',}},}

    sets.precast.WS['Blade: Ten'] = {
		ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
		head="Mpaca's Cap",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		left_ring="Regal Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Savage Blade'] = sets.precast.WS['Blade: Ten']

    sets.precast.WS['Blade: Shun'] = {
		ammo="Aurgelmir Orb +1",
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Mpaca's Hose",
		feet="Ken. Sune-Ate +1",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Fotia Belt",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		left_ring="Gere Ring",
		right_ring="Regal Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10',}},}

    sets.precast.WS['Blade: Ku'] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body="Mpaca's Doublet",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Mache Earring +1",
		right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		left_ring="Gere Ring",
		right_ring="Regal Ring",
		back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

    sets.precast.WS['Blade: Kamu'] = {
		ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
		head="Hachiya Hatsu. +3",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs="Mpaca's Hose",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Odr Earring",
		right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		left_ring="Gere Ring",
		right_ring="Regal Ring",
		back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

    sets.precast.WS['Blade: Chi'] = {
		ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Fotia Gorget",
		waist="Orpheus's Sash",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		left_ring="Gere Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Blade: Teki'] = sets.precast.WS['Blade: Chi']
    sets.precast.WS['Blade: To'] = sets.precast.WS['Blade: Chi']
	sets.precast.WS['Tachi: Jinpu'] = sets.precast.WS['Blade: Chi']
	sets.precast.WS['Tachi: Kagero'] = sets.precast.WS['Blade: Chi']
	sets.precast.WS['Tachi: Goten'] = sets.precast.WS['Blade: Chi']
	sets.precast.WS['Tachi: Koki'] = sets.precast.WS['Blade: Chi']	
		
	sets.precast.WS['Blade: Ei'] = {
		ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
		head="Pixie Hairpin +1",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Sibyl Scarf",
		waist="Orpheus's Sash",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Friomisi Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Archon Ring",
		back={ name="Andartia's Mantle", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Mag.Atk.Bns."+10',}},}

	sets.precast.WS['Sanguine Blade'] = sets.precast.WS['Blade: Ei']
		
	sets.precast.WS['Blade: Yu'] = {
		ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Fotia Gorget",
		waist="Orpheus's Sash",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Friomisi Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Gere Ring",
		back={ name="Andartia's Mantle", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Mag.Atk.Bns."+10',}},}
		
	sets.precast.WS['Aeolian Edge'] = sets.precast.WS['Blade: Yu']
		
	sets.precast.WS['Evisceration'] = {
		ammo="Yetshila +1",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Caro Necklace",
		waist="Chaac Belt",
		left_ear="Odr Earring",
		right_ear="Ishvara Earring",
		left_ring="Regal Ring",
		right_ring="Begrudging Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10',}},}
		
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.SpellInterrupt = {}

    -- Specific spells
    sets.midcast.Utsusemi = {
		ammo="Sapience Orb",
		head={ name="Herculean Helm", augments={'Pet: Accuracy+21 Pet: Rng. Acc.+21','"Subtle Blow"+3','Weapon skill damage +7%','Mag. Acc.+10 "Mag.Atk.Bns."+10',}},
		body={ name="Adhemar Jacket +1", augments={'HP+105','"Fast Cast"+10','Magic dmg. taken -4',}},
		hands={ name="Mochizuki Tekko +3", augments={'Enh. "Ninja Tool Expertise" effect',}},
		legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
		feet="Hattori Kyahan +1",
		neck="Orunmila's Torque",
		waist="Flume Belt +1",
		left_ear="Loquac. Earring",
		right_ear="Etiolation Earring",
		left_ring="Kishar Ring",
		right_ring="Prolix Ring",
		back={ name="Andartia's Mantle", augments={'HP+60','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10',}},
        }
		
	sets.midcast['Utsusemi: Ichi'] = sets.midcast.Utsusemi
	sets.midcast['Utsusemi: Ni'] = sets.midcast.Utsusemi
	sets.midcast['Utsusemi: San'] = sets.midcast.Utsusemi
	
    sets.midcast.ElementalNinjutsu = {
		ammo="Pemphredo Tathlum",
		head={ name="Mochi. Hatsuburi +3", augments={'Enhances "Yonin" and "Innin" effect',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Mochi. Kyahan +3", augments={'Enh. Ninj. Mag. Acc/Cast Time Red.',}},
		neck="Sibyl Scarf",
		waist="Orpheus's Sash",
		left_ear="Hecate's Earring",
		right_ear="Friomisi Earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Dingir Ring",
		back={ name="Andartia's Mantle", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Mag.Atk.Bns."+10',}},}
		
	sets.midcast.ElementalNinjutsu_MagicBurst = {
		ammo="Pemphredo Tathlum",
		head={ name="Mochi. Hatsuburi +3", augments={'Enhances "Yonin" and "Innin" effect',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Mochi. Kyahan +3", augments={'Enh. Ninj. Mag. Acc/Cast Time Red.',}},
		neck="Sibyl Scarf",
		waist="Orpheus's Sash",
		left_ear="Hecate's Earring",
		right_ear="Friomisi Earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Mujin Band",
		back={ name="Andartia's Mantle", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Mag.Atk.Bns."+10',}},}
		
	sets.midcast.ElementalNinjutsu_MagicBurst_Futae = set_combine(sets.midcast.ElementalNinjutsu_MagicBurst, {hands="Hattori Tekko +1",})

    sets.midcast.EnfeeblingNinjutsu = {
		ammo="Yamarang",
		head="Hachiya Hatsu. +3",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Hachiya Kyahan +3",
		neck="Sanctity Necklace",
		waist="Eschan Stone",
		left_ear="Crep. Earring",
		right_ear="Digni. Earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Stikini Ring +1",
		back={ name="Andartia's Mantle", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Mag.Atk.Bns."+10',}},}
		
	sets.midcast['Hojo: Ichi'] = sets.midcast.EnfeeblingNinjutsu
	sets.midcast['Hojo: Ni'] = sets.midcast.EnfeeblingNinjutsu
	sets.midcast['Kurayami: Ichi'] = sets.midcast.EnfeeblingNinjutsu
	sets.midcast['Kurayami: Ni'] = sets.midcast.EnfeeblingNinjutsu
	sets.midcast['Aisha: Ichi'] = sets.midcast.EnfeeblingNinjutsu
	sets.midcast['Yurin: Ichi'] = sets.midcast.EnfeeblingNinjutsu
	sets.midcast['Jubaku: Ichi'] = sets.midcast.EnfeeblingNinjutsu
	

    sets.midcast.EnhancingNinjutsu = {
		ammo="Sapience Orb",
		head={ name="Herculean Helm", augments={'Pet: Accuracy+21 Pet: Rng. Acc.+21','"Subtle Blow"+3','Weapon skill damage +7%','Mag. Acc.+10 "Mag.Atk.Bns."+10',}},
		body={ name="Adhemar Jacket +1", augments={'HP+105','"Fast Cast"+10','Magic dmg. taken -4',}},
		hands={ name="Mochizuki Tekko +3", augments={'Enh. "Ninja Tool Expertise" effect',}},
		legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
		feet="Malignance Boots",
		neck="Orunmila's Torque",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Loquac. Earring",
		right_ear="Etiolation Earring",
		left_ring="Prolix Ring",
		right_ring="Kishar Ring",
		back={ name="Andartia's Mantle", augments={'HP+60','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10',}},}
		
	sets.midcast['Migawari: Ichi'] = {
		ammo="Sapience Orb",
		head="Hachiya Hatsu. +3",
		body={ name="Adhemar Jacket +1", augments={'HP+105','"Fast Cast"+10','Magic dmg. taken -4',}},
		hands={ name="Mochizuki Tekko +3", augments={'Enh. "Ninja Tool Expertise" effect',}},
		legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
		feet={ name="Mochi. Kyahan +3", augments={'Enh. Ninj. Mag. Acc/Cast Time Red.',}},
		neck="Incanter's Torque",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Loquac. Earring",
		right_ear="Etiolation Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Andartia's Mantle", augments={'HP+60','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10',}},}

    sets.midcast.Stun = sets.midcast.EnfeeblingNinjutsu

    sets.midcast.RA = {
		ammo=empty,
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck="Iskur Gorget",
        ear1="Enervating Earring",
        ear2="Telos Earring",
        ring1="Dingir Ring",
        ring2="Hajduk Ring +1",
        waist="Yemaya Belt",
		back={ name="Andartia's Mantle", augments={'AGI+20','Accuracy+20 Attack+20','Weapon skill damage +10%',}},}

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Resting sets
--    sets.resting = {}

    -- Idle sets
    sets.idle = {
		ammo="Yamarang",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Bathy Choker +1", augments={'Path: A',}},
		waist="Engraved Belt",
		left_ear="Infused Earring",
		right_ear="Eabani Earring",
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring="Vengeful Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- * NIN Native DW Trait: 35% DW

    -- No Magic Haste (74% DW to cap)
    sets.engaged = {
		ammo="Seki Shuriken",
		head={ name="Ryuo Somen +1", augments={'HP+65','"Store TP"+5','"Subtle Blow"+8',}},																--9%
		body={ name="Mochi. Chainmail +3", augments={'Enhances "Sange" effect',}},																		--9%
		hands="Malignance Gloves",
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Tatena. Sune. +1", augments={'Path: A',}},
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Reiki Yotai",																															--7%
		left_ear="Dedition Earring",
		right_ear="Eabani Earring",																														--4%
		left_ring="Gere Ring",
		right_ring="Chirich Ring +1",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},			--10%
        } --39%GDW + 35%JADW = 74%

    -- 15% Magic Haste (67% DW to cap)
    sets.engaged.LowHaste = {
		ammo="Seki Shuriken",
		head={ name="Ryuo Somen +1", augments={'HP+65','"Store TP"+5','"Subtle Blow"+8',}},																--9%
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},																	--6%
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Tatena. Sune. +1", augments={'Path: A',}},
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Reiki Yotai",																															--7%
		left_ear="Dedition Earring",
		right_ear="Telos Earring",
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},			--10%
        } --32%GDW + 35%JADW = 67%


    -- 30% Magic Haste (56% DW to cap)
    sets.engaged.MidHaste = {
		ammo="Seki Shuriken",
		head={ name="Ryuo Somen +1", augments={'HP+65','"Store TP"+5','"Subtle Blow"+8',}},																--9%
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},																	--6%
		hands="Malignance Gloves",
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Tatena. Sune. +1", augments={'Path: A',}},
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Reiki Yotai",																															--7%
		left_ear="Dedition Earring",
		right_ear="Telos Earring",
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
		} --22%GDW + 35%JADW = 57%


    -- 35% Magic Haste (51% DW to cap)
    sets.engaged.HighHaste = {
		ammo="Seki Shuriken",
		head={ name="Ryuo Somen +1", augments={'HP+65','"Store TP"+5','"Subtle Blow"+8',}},																--9%
		body={ name="Tatena. Harama. +1", augments={'Path: A',}},
		hands="Malignance Gloves",
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Tatena. Sune. +1", augments={'Path: A',}},
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist="Reiki Yotai",																															--7%
		left_ear="Dedition Earring",
		right_ear="Telos Earring",
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
        } --16%GDW + 35%JADW = 51%

    -- 45% Magic Haste (36% DW to cap)
    sets.engaged.MaxHaste = {
		ammo="Seki Shuriken",
		head="Malignance Chapeau",
		body={ name="Tatena. Harama. +1", augments={'Path: A',}},
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet="Malignance Boots",
		neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Dedition Earring",
		right_ear="Telos Earring",
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
		} --0%GDW + 35%JADW = 35%%%

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
        }

    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)

    sets.engaged.DT.LowHaste = set_combine(sets.engaged.LowHaste, sets.engaged.Hybrid)

    sets.engaged.DT.MidHaste = set_combine(sets.engaged.MidHaste, sets.engaged.Hybrid)

    sets.engaged.DT.HighHaste = set_combine(sets.engaged.HighHaste, sets.engaged.Hybrid)

    sets.engaged.DT.MaxHaste = set_combine(sets.engaged.MaxHaste, sets.engaged.Hybrid)

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
	
	sets.NightMovement = {feet="Hachiya Kyahan +3"}
	sets.DayMovement = {feet="Danzo Sune-Ate"}

    sets.buff.Migawari = {body="Hattori Ningi +1",}
    sets.buff.Yonin = {}
    sets.buff.Innin = {}
    sets.buff.Sange = {ammo="Hachiya Shuriken"}

	sets.Physical_Katana = {main="Kunimitsu",sub={ name="Gleti's Knife", augments={'Path: A',}},}
	sets.Magic_Katana = {main="Kunimitsu",sub={ name="Ochu", augments={'STR+8','DEX+8','Ninjutsu skill +10','DMG:+14',}},}
	sets.Hachimonji = {main="Hachimonji",}
	sets.Naegling = {main="Naegling",sub="Kunimitsu",}
	sets.Gletis_Knife = {main={ name="Gleti's Knife", augments={'Path: A',}},sub="Kunimitsu",}


    sets.buff.Doom = {
		neck="Nicander's Necklace",
        waist="Gishdubar Sash", --10
        }

    sets.CP = {neck={ name="Ninja Nodowa +2", augments={'Path: A',}},}
    
    sets.TreasureHunter = {
		ammo="Per. Lucky Egg", --TH1
		body="Volte Jupon",		--TH2
		waist="Chaac Belt",} --TH+1


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

		--handles Weaponskill events
    if spell.type == 'WeaponSkill' then
	
        if lugra_ws:contains(spell.english) and (world.time >= (17*60) or world.time <= (7*60)) then
            equip(sets.Lugra)
        end
		
        if spell.english == 'Blade: Yu' and (world.weather_element == 'Water' or world.day_element == 'Water') then
            equip(sets.Obi)
        end

		if spell.english == 'Blade: Ei' and (world.weather_element == 'Dark' or world.day_element == 'Dark') then
            equip(sets.Obi)
        end

		if spell.english == 'Blade: To' and (world.weather_element == 'Ice' or world.day_element == 'Ice') then
            equip(sets.Obi)
        end

		if spell.english == 'Blade: Chi' and (world.weather_element == 'Earth' or world.day_element == 'Earth') then
            equip(sets.Obi)
        end
		
    end
end

function job_post_midcast(spell, action, spellMap, eventArgs)

		--Handles Elemental Ninjutsu Events
    if spellMap == 'ElementalNinjutsu' then
        if (spell.element == world.day_element or spell.element == world.weather_element) then
            equip(sets.Obi)
        end
		
        if state.Buff.Futae then
            equip(sets.precast.JA['Futae'])
        end

		if state.MagicBurst.value == true then
			equip(sets.midcast.ElementalNinjutsu_MagicBurst)
				if state.Buff.Futae then
					equip(sets.midcast.ElementalNinjutsu_MagicBurst_Futae)
				end
		end
    end
	
end

function job_aftercast(spell, action, spellMap, eventArgs)

    if not spell.interrupted and spell.english == "Migawari: Ichi" then
        state.Buff.Migawari = true
    end

end

function job_buff_change(buff, gain)

    if buff == "Migawari" and not gain then
        add_to_chat(61, "*** MIGAWARI DOWN ***")
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

end

-------------------------------------------------------------------------------------------------------------------
-- Code for Melee sets
-------------------------------------------------------------------------------------------------------------------

	--Gearinfo related function
function job_handle_equipping_gear(playerStatus, eventArgs)
    check_gear()
    update_combat_form()
    determine_haste_group()
    check_moving()
end

function job_update(cmdParams, eventArgs)
    handle_equipping_gear(player.status)
    th_update(cmdParams, eventArgs)
end

function update_combat_form()

    if DW == true then
        state.CombatForm:set('DW')
    elseif DW == false then
        state.CombatForm:reset()
    end

	if state.WeaponLock.value == true then
		disable('main','sub')
	else
        enable('main','sub')
    end

	if state.WeaponSet.value == 'Physical_Katana' then
		equip(sets.Physical_Katana)
	end

	if state.WeaponSet.value == 'Magic_Katana' then
		equip(sets.Magic_Katana)
	end
	
	if state.WeaponSet.value == 'Hachimonji' then
		equip(sets.Hachimonji)
	end

	if state.WeaponSet.value == 'Naegling' then
		equip(sets.Naegling) 
	end
	
	if state.WeaponSet.value == 'Gletis_Knife' then
		equip(sets.Gletis_Knife) 
	end
	
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)


    if state.Buff.Migawari then
       idleSet = set_combine(idleSet, sets.buff.Migawari)
    end

		--Allows CP back to stay on if toggled on
    if state.CP.current == 'on' then
        equip(sets.CP)
        disable('neck')
    else
        enable('neck')
    end
	
    if state.Auto_Kite.value == true then
        if world.time >= (17*60) or world.time <= (7*60) then
            idleSet = set_combine(idleSet, sets.NightMovement)
        else
            idleSet = set_combine(idleSet, sets.DayMovement)
        end
    end

    return idleSet
end


-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)

    if state.Buff.Migawari then
        meleeSet = set_combine(meleeSet, sets.buff.Migawari)
    end
 
	if state.Buff.Sange then
        meleeSet = set_combine(meleeSet, sets.buff.Sange)
    end

    return meleeSet


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
        ..string.char(31,060).. ' Magic: ' ..string.char(31,001)..c_msg.. string.char(31,002)..  ' |'
        ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function check_moving()
    if state.DefenseMode.value == 'None'  and state.Kiting.value == false then
        if state.Auto_Kite.value == false and moving then
            state.Auto_Kite:set(true)
        elseif state.Auto_Kite.value == true and moving == false then
            state.Auto_Kite:set(false)
        end
    end
end

	--Determines Haste Group / Melee set for Gear Info
function determine_haste_group()
    classes.CustomMeleeGroups:clear()
    if DW == true then
        if DW_needed <= 1 then
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif DW_needed > 1 and DW_needed <= 16 then
            classes.CustomMeleeGroups:append('HighHaste')
        elseif DW_needed > 16 and DW_needed <= 21 then
            classes.CustomMeleeGroups:append('MidHaste')
        elseif DW_needed > 21 and DW_needed <= 34 then
            classes.CustomMeleeGroups:append('LowHaste')
        elseif DW_needed > 34 then
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

-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.
function th_action_check(category, param)
    if category == 2 or -- any ranged attack
        --category == 4 or -- any magic action
        (category == 3 and param == 30) or -- Aeolian Edge
        (category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
        (category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
        then return true
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
        set_macro_page(1, 5)

end

function set_lockstyle()
    send_command('wait 5; input /lockstyleset ' .. lockstyleset)
end