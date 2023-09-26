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
--  Job Specific Keybinds (Thief Binds)
-------------------------------------------------------------------------------------------------------------------
--
--	Modes:			[ Windows + 1 ]			Sets Weapon to Twashtar
--					[ Windows + 2 ]			Sets Weapon to Mandau
--					[ Windows + 3 ]			Sets Weapon to Tauret
--					[ Windows + 4 ]			Sets Weapon to Naegling
--					[ Windows + 5 ]			Sets Weapon to Karambit
--
--  WS:         	[ CTRL + Numpad1 ]    	Evisceration
--					[ CTRL + Numpad2 ]    	Rudra's Storm
--					[ CTRL + Numpad3 ]    	Mandalic Stab
--					[ CTRL + Numpad4 ]    	Aeolian Edge
--					[ CTRL + Numpad5 ]    	Exenterator
--					[ CTRL + Numpad6 ]    	Shark Bite
--				
--					[ ALT + Numpad1 ]     	Savage Blade
--					[ ALT + Numpad2 ]     	Sanguine Blade
--
--					[ ALT + Numpad4 ]     	Asuran Fists
--
--  Abilities:  	[ CTRL + ` ]   	Sneak Attack
--					[ ALT + ` ]   	Trick Attack
--
-------------------------------------------------------------------------------------------------------------------
--  Custom Commands (preface with /console to use these in macros)
-------------------------------------------------------------------------------------------------------------------
--
--  TH Modes:  None                 Will never equip TH gear
--             Tag                  Will equip TH gear sufficient for initial contact with a mob
--             SATA - Will equip TH gear sufficient for initial contact with a mob, and when using SATA
--             Fulltime - Will keep TH gear equipped fulltime
--
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
    state.Buff['Sneak Attack'] = buffactive['sneak attack'] or false
    state.Buff['Trick Attack'] = buffactive['trick attack'] or false
    state.Buff['Feint'] = buffactive['feint'] or false

    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
					"Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring", "Emporox's Ring"}



    include('Mote-TreasureHunter')

    -- For th_action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}

    state.CP = M(false, "Capacity Points Mode")

    lockstyleset = 11
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
    state.IdleMode:options('Normal')

	state.WeaponSet = M{['description']='Weapon Set', 'Twashtar', 'Mandau', 'Tauret', 'Naegling', 'Karambit'}
	state.WeaponLock = M(false, 'Weapon Lock')
	state.TPBonus = M(false, 'TP Bonus')

	--Load Gearinfo/Dressup Lua
	
    send_command('wait 3; lua l gearinfo')
	send_command('wait 10; lua l Dressup')

    --Global Thief binds (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)	
	
	send_command('bind @u input //gi ugs')
	send_command('bind @d input //lua u dressup; wait 10; input //lua l dressup')
    send_command('bind @t gs c cycle TreasureMode')
    send_command('bind @c gs c toggle CP')
	send_command('bind @b gs c toggle TPBonus')
	send_command('bind ^` input /ja "Sneak Attack" <me>')
    send_command('bind !` input /ja "Trick Attack" <me>')
	send_command('bind ~` input /ja "Flee" <me>')
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
		input /echo [ Windows + T ]	Cycles TreasureHunter Mode;
		input /echo [ Windows + B ]	Toggles TP Bonus Mode;
		input /echo [ Windows + 1 ]	Sets Weapon to Twashtar;
		input /echo [ Windows + 2 ]	Sets Weapon to Mandau;
		input /echo [ Windows + 3 ]	Sets Weapon to Tauret;
		input /echo [ Windows + 4 ]	Sets Weapon to Naegling;
		input /echo [ Windows + 5 ]	Sets Weapon to Karambit;
		input /echo -----Toggles-----;
		input /echo [ Windows + U ]	Toggles Gearswap autoupdate;
		input /echo [ Windows + D ]	Unloads then reloads dressup;
		]])
		
	--Command to show Blue Mage binds in game[ ALT + numpad- ]
	send_command([[bind !numpad- 
		input /echo -----Abilities-----;
		input /echo [ CTRL + ` ] Sneak Attack;
		input /echo [ ALT + ` ] Trick Attack;
		input /echo -----Dagger-----;
		input /echo [ CTRL + Numpad1 ] Evisceration;
		input /echo [ CTRL + Numpad2 ] Rudra's Storm;
		input /echo [ CTRL + Numpad3 ] Mandalic Stab;
		input /echo [ CTRL + Numpad4 ] Aeolian Edge;
		input /echo [ CTRL + Numpad5 ] Exenterator;
		input /echo [ CTRL + Numpad6 ] Shark Bite;
		input /echo -----Sword-----;
		input /echo [ ALT + Numpad1 ] Savage Blade;
		input /echo [ ALT + Numpad2 ] Sanguine Blade;
		input /echo -----Hand-to-Hand-----;
		input /echo [ ALT + Numpad4 ] Asuran Fists;
		]])

	--Weapon set Binds

	send_command('bind @1 gs c set WeaponSet Twashtar')
	send_command('bind @2 gs c set WeaponSet Mandau')
	send_command('bind @3 gs c set WeaponSet Tauret')
	send_command('bind @4 gs c set WeaponSet Naegling')
	send_command('bind @5 gs c set WeaponSet Karambit')

	--Weaponskill Binds (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)

    send_command('bind ^numpad1 input /ws "Evisceration" <t>')
    send_command('bind ^numpad2 input /ws "Rudra\'s Storm" <t>')
    send_command('bind ^numpad3 input /ws "Mandalic Stab" <t>')
    send_command('bind ^numpad4 input /ws "Aeolian Edge" <t>')
	send_command('bind ^numpad5 input /ws "Exenterator" <t>')
	send_command('bind ^numpad6 input /ws "Shark Bite" <t>')
	send_command('bind ^numpad7 input /ws "Mercy Stroke" <t>')
	
	send_command('bind !numpad1 input /ws "Savage Blade" <t>')
	send_command('bind !numpad2 input /ws "Sanguine Blade" <t>')
	
	send_command('bind !numpad4 input /ws "Asuran Fists" <t>')
	
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
	
	send_command('wait 10; input //get Twashtar case')
	send_command('wait 10; input //get Gleti\'s Knife case')
	send_command('wait 10; input //get Karambit case')
	send_command('wait 10; input //get Mandau case')
	send_command('wait 10; input //get Naegling case')
	send_command('wait 10; input //get Tauret case')
	
	send_command([[bind @i ;
		input //get Twashtar case;
		input //get Gleti\'s Knife case;
		input //get Karambit case;
		input //get Mandau case;
		input //get Naegling case;
		input //get Tauret case;
		]])

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

	--Remove Global Thief Binds

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
	
	--Unload Gearinfo/Dressup Lua
	
    send_command('lua u gearinfo')
	send_command('lua u Dressup')
	
	--Gear Removal Commands
	
	send_command('input //put Twashtar case')
	send_command('input //put Gleti\'s Knife case')
	send_command('input //put Karambit case')
	send_command('input //put Mandau case')
	send_command('input //put Naegling case')
	send_command('input //put Tauret case')
	
end


-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.TreasureHunter = {
		feet="Skulk. Poulaines +3", --TH5
        }

    -- Actions we want to use to tag TH.
    sets.precast.Step = sets.TreasureHunter
    sets.precast.Flourish1 = sets.TreasureHunter
    sets.precast.JA.Provoke = sets.TreasureHunter


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Precast sets to enhance JAs

    sets.precast.JA['Collaborator'] = {head="Skulker's Bonnet +3"}
    sets.precast.JA['Accomplice'] = {head="Skulker's Bonnet +3"}
    sets.precast.JA['Flee'] = {feet="Pill. Poulaines +3"}
    sets.precast.JA['Hide'] = {body="Pillager's Vest +3"}
    sets.precast.JA['Conspirator'] = {body="Skulker's Vest +3"}

    sets.precast.JA['Steal'] = {
        ammo="Barathrum", --3
		head={ name="Plun. Bonnet +3", augments={'Enhances "Aura Steal" effect',}},
        hands="Pillager's Armlets +1",
        feet="Pill. Poulaines +3",}
		
	sets.precast.JA['Mug'] = {head={ name="Plun. Bonnet +3", augments={'Enhances "Aura Steal" effect',}},}

    sets.precast.JA['Despoil'] = {ammo="Barathrum",legs="Skulk. Culottes +3",feet="Skulk. Poulaines +3",}
    sets.precast.JA['Perfect Dodge'] = {hands="Plunderer's Armlets +1"}
    sets.precast.JA['Feint'] = {legs="Plunderer's Culottes +3"}

    sets.precast.Waltz = {
        ammo="Yamarang",
        neck="Phalaina Locket",
        ring1="Asklepian Ring",
        waist="Gishdubar Sash",
        }

    sets.precast.Waltz['Healing Waltz'] = {}

    sets.precast.FC = {
		ammo="Sapience Orb",
		head={ name="Herculean Helm", augments={'Mag. Acc.+6','"Fast Cast"+6','INT+6','"Mag.Atk.Bns."+2',}},
		body={ name="Adhemar Jacket +1", augments={'HP+105','"Fast Cast"+10','Magic dmg. taken -4',}},
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
		feet={ name="Herculean Boots", augments={'"Fast Cast"+6','MND+5',}},
		neck="Orunmila's Torque",
		waist="Flume Belt +1",
		left_ear="Etiolation Earring",
		right_ear="Loquac. Earring",
		left_ring="Prolix Ring",
		right_ring="Defending Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
    sets.precast.RA = {
		range="Trollbane",
		head={ name="Taeon Chapeau", augments={'"Snapshot"+5','"Snapshot"+5',}},
		body={ name="Taeon Tabard", augments={'"Snapshot"+5','"Snapshot"+5',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Taeon Tights", augments={'"Snapshot"+4','"Snapshot"+5',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Flume Belt +1",
		left_ear="Genmei Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring="Defending Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},} 


    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body="Skulker's Vest +3",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Plun. Culottes +3", augments={'Enhances "Feint" effect',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Asn. Gorget +2", augments={'Path: A',}},
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Odr Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Regal Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
		
    sets.precast.WS.ATKCAP = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Skulker's Bonnet +3",
		body={ name="Gleti's Cuirass", augments={'Path: A',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Plun. Culottes +3", augments={'Enhances "Feint" effect',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Asn. Gorget +2", augments={'Path: A',}},
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Odr Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Regal Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS.FullTPMagical = {}
	sets.precast.WS.FullTPPhysical = {}

    sets.precast.WS['Evisceration'] = {
		ammo="Yetshila +1",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body={ name="Gleti's Cuirass", augments={'Path: A',}},
		hands={ name="Gleti's Gauntlets", augments={'Path: A',}},
		legs="Skulk. Culottes +3",
		feet={ name="Gleti's Boots", augments={'Path: A',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Sherida Earring",
		right_ear="Odr Earring",
		left_ring="Ilabrat Ring",
		right_ring="Regal Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}},}
	
	sets.precast.WS['Rudra\'s Storm'] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body="Skulker's Vest +3",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Asn. Gorget +2", augments={'Path: A',}},
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Odr Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Regal Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Rudra\'s Storm'].ATKCAP = {
		ammo="Yetshila +1",
		head="Skulker's Bonnet +3",
		body="Skulker's Vest +3",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Asn. Gorget +2", augments={'Path: A',}},
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Odr Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Regal Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS.RudraSATA = set_combine(sets.precast.WS['Rudra\'s Storm'], {head="Pill. Bonnet +3",ammo="Yetshila +1",})
		
	sets.precast.WS['Mandalic Stab'] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body="Skulker's Vest +3",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Asn. Gorget +2", augments={'Path: A',}},
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Odr Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Regal Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Mandalic Stab'].ATKCAP = {
		ammo="Yetshila +1",
		head="Skulker's Bonnet +3",
		body="Skulker's Vest +3",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Asn. Gorget +2", augments={'Path: A',}},
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Odr Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Regal Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS.MandalicSATA = set_combine(sets.precast.WS['Mandalic Stab'], {head="Pill. Bonnet +3",ammo="Yetshila +1",})
		
	sets.precast.WS['Shark Bite'] = {
		ammo="Yetshila +1",
		head="Skulker's Bonnet +3",
		body="Skulker's Vest +3",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Asn. Gorget +2", augments={'Path: A',}},
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Odr Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Regal Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Shark Bite'].ATKCAP = {
		ammo="Yetshila +1",
		head="Skulker's Bonnet +3",
		body="Skulker's Vest +3",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Asn. Gorget +2", augments={'Path: A',}},
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Odr Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Regal Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Dancing Edge'] = {
		ammo="Yetshila +1",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body={ name="Gleti's Cuirass", augments={'Path: A',}},
		hands={ name="Gleti's Gauntlets", augments={'Path: A',}},
		legs="Skulk. Culottes +3",
		feet={ name="Gleti's Boots", augments={'Path: A',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Sherida Earring",
		right_ear="Odr Earring",
		left_ring="Ilabrat Ring",
		right_ring="Regal Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}},}

	sets.precast.WS['Aeolian Edge'] = {
		ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Sibyl Scarf",
		waist="Orpheus's Sash",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Friomisi Earring",
		left_ring="Dingir Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Cyclone'] = set_combine(sets.precast.WS['Aeolian Edge'], {feet="Skulk. Poulaines +3",})

	sets.precast.WS['Savage Blade'] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body="Skulker's Vest +3",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Sroda Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Savage Blade'].ATKCAP = {
		ammo="Crepuscular Pebble",
		head="Skulker's Bonnet +3",
		body="Skulker's Vest +3",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Sroda Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS.SavageSATA = set_combine(sets.precast.WS['Savage Blade'], {head="Pill. Bonnet +3",ammo="Yetshila +1",})
		
	sets.precast.WS['Sanguine Blade'] = {
		ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
		head="Pixie Hairpin +1",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Sibyl Scarf",
		waist="Orpheus's Sash",
		left_ear="Hecate's Earring",
		right_ear="Friomisi Earring",
		left_ring="Archon Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Asuran Fists'] = {
		ammo="Aurgelmir Orb +1",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Skulk. Armlets +3",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Gleti's Boots", augments={'Path: A',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		right_ear="Sherida Earring",
		left_ring="Regal Ring",
		right_ring="Sroda Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Asuran Fists'].ATKCAP = {
		ammo="Crepuscular Pebble",
		head="Skulker's Bonnet +3",
		body={ name="Gleti's Cuirass", augments={'Path: A',}},
		hands={ name="Gleti's Gauntlets", augments={'Path: A',}},
		legs={ name="Gleti's Breeches", augments={'Path: A',}},
		feet={ name="Gleti's Boots", augments={'Path: A',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		right_ear="Sherida Earring",
		left_ring="Regal Ring",
		right_ring="Sroda Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
		
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.SpellInterrupt = {
        ring1="Evanescence Ring", --5
        }

    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt
	
	sets.midcast.RA = {
		range="Trollbane",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Iskur Gorget",
		waist="Eschan Stone",
		left_ear="Telos Earring",
		right_ear="Enervating Earring",
		left_ring="Ilabrat Ring",
		right_ring="Dingir Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}


    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.resting = {}

    sets.idle = {
		ammo="Staunch Tathlum +1",	--3%
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Sanctity Necklace",
		waist="Kasiri Belt",
		left_ear="Eabani Earring",
		right_ear="Hearty Earring",
		left_ring="Chirich Ring +1",
		right_ring="Defending Ring",	--10%
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},	--10%PDT
		} --44% DT / 10% PDT
		
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    sets.engaged = {
		ammo="Aurgelmir Orb +1",
		head="Skulker's Bonnet +3",
		body="Pillager's Vest +3",
		hands={ name="Gleti's Gauntlets", augments={'Path: A',}},
		legs={ name="Gleti's Breeches", augments={'Path: A',}},
		feet={ name="Plun. Poulaines +3", augments={'Enhances "Assassin\'s Charge" effect',}},
		neck={ name="Asn. Gorget +2", augments={'Path: A',}},
		waist="Reiki Yotai",
		left_ear="Dedition Earring",
		right_ear={ name="Skulk. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+13','Mag. Acc.+13','"Store TP"+4',}},
		left_ring="Gere Ring",
		right_ring="Hetairoi Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    sets.engaged.Acc = {
		ammo="Aurgelmir Orb +1",
		head="Skulker's Bonnet +3",
		body="Pillager's Vest +3",
		hands={ name="Gleti's Gauntlets", augments={'Path: A',}},
		legs={ name="Gleti's Breeches", augments={'Path: A',}},
		feet={ name="Plun. Poulaines +3", augments={'Enhances "Assassin\'s Charge" effect',}},
		neck={ name="Asn. Gorget +2", augments={'Path: A',}},
		waist="Reiki Yotai",
		left_ear="Dedition Earring",
		right_ear={ name="Skulk. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+13','Mag. Acc.+13','"Store TP"+4',}},
		left_ring="Gere Ring",
		right_ring="Hetairoi Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    -- * DNC Native DW Trait: 30% DW
    -- * DNC Job Points DW Gift: 5% DW

    -- No Magic Haste (74% DW to cap)
    sets.engaged.DW = {
		ammo="Aurgelmir Orb +1",
		head="Skulker's Bonnet +3",
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},											--6%
		hands={ name="Floral Gauntlets", augments={'Rng.Acc.+15','Accuracy+15','"Triple Atk."+3','Magic dmg. taken -4%',}},		--5%
		legs={ name="Gleti's Breeches", augments={'Path: A',}},
		feet={ name="Plun. Poulaines +3", augments={'Enhances "Assassin\'s Charge" effect',}},
		neck={ name="Asn. Gorget +2", augments={'Path: A',}},
		waist="Reiki Yotai", 																									--7%
		left_ear="Suppanomimi", 																								--5%
		right_ear="Eabani Earring", 																							--4%
		left_ring="Gere Ring",
		right_ring="Hetairoi Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
		} --30% JA + 27% Gear = 57%
		
    sets.engaged.DW.Acc = {
		ammo="Aurgelmir Orb +1",
		head="Skulker's Bonnet +3",
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},											--6%
		hands={ name="Floral Gauntlets", augments={'Rng.Acc.+15','Accuracy+15','"Triple Atk."+3','Magic dmg. taken -4%',}},		--5%
		legs={ name="Gleti's Breeches", augments={'Path: A',}},
		feet={ name="Plun. Poulaines +3", augments={'Enhances "Assassin\'s Charge" effect',}},
		neck={ name="Asn. Gorget +2", augments={'Path: A',}},
		waist="Reiki Yotai", 																									--7%
		left_ear="Suppanomimi", 																								--5%
		right_ear="Eabani Earring", 																							--4%
		left_ring="Gere Ring",
		right_ring="Hetairoi Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
		} --30% JA + 27% Gear = 57%

    -- 15% Magic Haste (67% DW to cap)
    sets.engaged.DW.LowHaste = {
		ammo="Aurgelmir Orb +1",
		head="Skulker's Bonnet +3",
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},											--6%
		hands={ name="Floral Gauntlets", augments={'Rng.Acc.+15','Accuracy+15','"Triple Atk."+3','Magic dmg. taken -4%',}},		--5%
		legs={ name="Gleti's Breeches", augments={'Path: A',}},
		feet={ name="Plun. Poulaines +3", augments={'Enhances "Assassin\'s Charge" effect',}},
		neck={ name="Asn. Gorget +2", augments={'Path: A',}},
		waist="Reiki Yotai", 																									--7%
		left_ear="Suppanomimi", 																								--5%
		right_ear="Eabani Earring", 																							--4%
		left_ring="Gere Ring",
		right_ring="Hetairoi Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
		} --30% JA + 27% Gear = 57%


    sets.engaged.DW.Acc.LowHaste = {
		ammo="Aurgelmir Orb +1",
		head="Skulker's Bonnet +3",
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},											--6%
		hands={ name="Floral Gauntlets", augments={'Rng.Acc.+15','Accuracy+15','"Triple Atk."+3','Magic dmg. taken -4%',}},		--5%
		legs={ name="Gleti's Breeches", augments={'Path: A',}},
		feet={ name="Plun. Poulaines +3", augments={'Enhances "Assassin\'s Charge" effect',}},
		neck={ name="Asn. Gorget +2", augments={'Path: A',}},
		waist="Reiki Yotai", 																									--7%
		left_ear="Suppanomimi", 																								--5%
		right_ear="Eabani Earring", 																							--4%
		left_ring="Gere Ring",
		right_ring="Hetairoi Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
		} --30% JA + 27% Gear = 57%


    -- 30% Magic Haste (56% DW to cap)
    sets.engaged.DW.MidHaste = {
		ammo="Aurgelmir Orb +1",
		head="Skulker's Bonnet +3",
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},											--6%
		hands={ name="Floral Gauntlets", augments={'Rng.Acc.+15','Accuracy+15','"Triple Atk."+3','Magic dmg. taken -4%',}},		--5%
		legs={ name="Gleti's Breeches", augments={'Path: A',}},
		feet={ name="Plun. Poulaines +3", augments={'Enhances "Assassin\'s Charge" effect',}},
		neck={ name="Asn. Gorget +2", augments={'Path: A',}},
		waist="Reiki Yotai", 																									--7%
		left_ear="Suppanomimi", 																								--5%
		right_ear="Eabani Earring", 																							--4%
		left_ring="Gere Ring",
		right_ring="Hetairoi Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
		} --30% JA + 27% Gear = 57%

    sets.engaged.DW.Acc.MidHaste = {
		ammo="Aurgelmir Orb +1",
		head="Skulker's Bonnet +3",
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},											--6%
		hands={ name="Floral Gauntlets", augments={'Rng.Acc.+15','Accuracy+15','"Triple Atk."+3','Magic dmg. taken -4%',}},		--5%
		legs={ name="Gleti's Breeches", augments={'Path: A',}},
		feet={ name="Plun. Poulaines +3", augments={'Enhances "Assassin\'s Charge" effect',}},
		neck={ name="Asn. Gorget +2", augments={'Path: A',}},
		waist="Reiki Yotai", 																									--7%
		left_ear="Suppanomimi", 																								--5%
		right_ear="Eabani Earring", 																							--4%
		left_ring="Gere Ring",
		right_ring="Hetairoi Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
		} --30% JA + 27% Gear = 57%

    -- 35% Magic Haste (51% DW to cap)
    sets.engaged.DW.HighHaste = {
		ammo="Aurgelmir Orb +1",
		head="Skulker's Bonnet +3",
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},											--6%
		hands={ name="Floral Gauntlets", augments={'Rng.Acc.+15','Accuracy+15','"Triple Atk."+3','Magic dmg. taken -4%',}},		--5%
		legs={ name="Gleti's Breeches", augments={'Path: A',}},
		feet={ name="Plun. Poulaines +3", augments={'Enhances "Assassin\'s Charge" effect',}},
		neck={ name="Asn. Gorget +2", augments={'Path: A',}},
		waist="Reiki Yotai", 																									--7%
		left_ear="Suppanomimi", 																								--5%
		right_ear={ name="Skulk. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+13','Mag. Acc.+13','"Store TP"+4',}},
		left_ring="Gere Ring",
		right_ring="Hetairoi Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
		} --30% JA + 27% Gear = 57%

    sets.engaged.DW.Acc.HighHaste = {
		ammo="Aurgelmir Orb +1",
		head="Skulker's Bonnet +3",
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},											--6%
		hands={ name="Floral Gauntlets", augments={'Rng.Acc.+15','Accuracy+15','"Triple Atk."+3','Magic dmg. taken -4%',}},		--5%
		legs={ name="Gleti's Breeches", augments={'Path: A',}},
		feet={ name="Plun. Poulaines +3", augments={'Enhances "Assassin\'s Charge" effect',}},
		neck={ name="Asn. Gorget +2", augments={'Path: A',}},
		waist="Reiki Yotai", 																									--7%
		left_ear="Suppanomimi", 																								--5%
		right_ear={ name="Skulk. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+13','Mag. Acc.+13','"Store TP"+4',}},
		left_ring="Gere Ring",
		right_ring="Hetairoi Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
		} --30% JA + 27% Gear = 57%

    -- 45% Magic Haste (36% DW to cap)
    sets.engaged.DW.MaxHaste = {
		ammo="Aurgelmir Orb +1",
		head="Skulker's Bonnet +3",
		body="Pillager's Vest +3",
		hands={ name="Gleti's Gauntlets", augments={'Path: A',}},
		legs={ name="Gleti's Breeches", augments={'Path: A',}},
		feet={ name="Plun. Poulaines +3", augments={'Enhances "Assassin\'s Charge" effect',}},
		neck={ name="Asn. Gorget +2", augments={'Path: A',}},
		waist="Reiki Yotai",																									--7%
		left_ear="Dedition Earring",
		right_ear={ name="Skulk. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+13','Mag. Acc.+13','"Store TP"+4',}},
		left_ring="Gere Ring",
		right_ring="Hetairoi Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
			--30% JA + 7% Gear = 37%

    sets.engaged.DW.Acc.MaxHaste = {
		ammo="Aurgelmir Orb +1",
		head="Skulker's Bonnet +3",
		body="Pillager's Vest +3",
		hands={ name="Gleti's Gauntlets", augments={'Path: A',}},
		legs={ name="Gleti's Breeches", augments={'Path: A',}},
		feet={ name="Plun. Poulaines +3", augments={'Enhances "Assassin\'s Charge" effect',}},
		neck={ name="Asn. Gorget +2", augments={'Path: A',}},
		waist="Reiki Yotai",																									--7%
		left_ear="Dedition Earring",
		right_ear={ name="Skulk. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+13','Mag. Acc.+13','"Store TP"+4',}},
		left_ring="Gere Ring",
		right_ring="Hetairoi Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
			--30% JA + 7% Gear = 37%


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
        left_ring="Moonlight Ring", 	--10%
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}, --10%
        } --51%

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
    

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.buff.Doom = {
		neck="Nicander's Necklace",
        waist="Gishdubar Sash", --10
        }
		
	sets.Kiting = {right_ring="Shneddick Ring",}

    sets.CP = {neck={ name="Asn. Gorget +2", augments={'Path: A',}},}
	
	sets.Twashtar = {main={ name="Mandau", augments={'Path: A',}}, sub={ name="Gleti's Knife", augments={'Path: A',}},}
	
	sets.Mandau = {main={ name="Mandau", augments={'Path: A',}}, sub={ name="Gleti's Knife", augments={'Path: A',}},}
	
	sets.Tauret = {main="Tauret", sub={ name="Gleti's Knife", augments={'Path: A',}},}
	
	sets.Naegling = {main="Naegling", { name="Gleti's Knife", augments={'Path: A',}},}
	sets.Naegling_Centovente = {main="Naegling", sub="Fusetto +2",}
	
	sets.Karambit = {main="Karambit"}

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific Functions
-------------------------------------------------------------------------------------------------------------------

function job_post_precast(spell, action, spellMap, eventArgs)

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
	
		--Turns Aeolian Edge into AoE Treasure Hunter
    if spell.english == 'Aeolian Edge' and state.TreasureMode.value ~= 'None' then
        equip(sets.TreasureHunter)
		
    elseif spell.english=='Sneak Attack' or spell.english=='Trick Attack' then
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
    end

		--Handles Sneak Attack / Trick Attack Weapon skills
    if spell.type == "WeaponSkill" then
        if state.Buff['Sneak Attack'] == true or state.Buff['Trick Attack'] == true then
			if spell.english == 'Rudra\'s Storm' then
				equip(sets.precast.WS.RudraSATA)
			end
			if spell.english == 'Mandalic Stab' then
				equip(sets.precast.WS.MandalicSATA)
			end
			if spell.english == 'Savage Blade' then
				equip(sets.precast.WS.SavageSATA)
			end
        end
    end
	
    if spell.type == "WeaponSkill" then
		if spell.english == "Exenterator" or spell.english == "Mercy Stroke" then
		else
			if state.TPBonus.value == true then
				if player.tp > 2900 then
					if spell.english == "Aeolian Edge" or spell.english == "Gust Slash" or spell.english == "Cyclone" then
							equip(sets.precast.WS.FullTPMagical)
					else
						equip(sets.precast.WS.FullTPPhysical)
					end
				end
			end
		end
	end

end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    -- Weaponskills wipe SATA/Feint.  Turn those state vars off before default gearing is attempted.
    if spell.type == 'WeaponSkill' and not spell.interrupted then
        state.Buff['Sneak Attack'] = false
        state.Buff['Trick Attack'] = false
        state.Buff['Feint'] = false
    end
end

function job_post_aftercast(spell, action, spellMap, eventArgs)
    -- If Feint is active, put that gear set on on top of regular gear.
    -- This includes overlaying SATA gear.
    check_buff('Feint', eventArgs)
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

    if not midaction() then
        handle_equipping_gear(player.status)
    end
end

	--Handles Weapon set changes
function job_state_change(stateField, newValue, oldValue)

    equip(sets[state.WeaponSet.current])

end

-------------------------------------------------------------------------------------------------------------------
-- Code for Melee sets
-------------------------------------------------------------------------------------------------------------------

	--Gearinfo related function
function job_handle_equipping_gear(playerStatus, eventArgs)
    update_combat_form()
    determine_haste_group()
	check_moving()
end

function job_update(cmdParams, eventArgs)
	check_gear()
    handle_equipping_gear(player.status)
    th_update(cmdParams, eventArgs)
end

	--Adjusts Melee/Weapon sets for Dual Wield or Single Wield
function update_combat_form()

	if DW == true then
        state.CombatForm:set('DW')
    elseif DW == false then
        state.CombatForm:reset()
    end

	if state.WeaponSet.value == 'Twashtar' then
		enable('main','sub')
		equip(sets.Twashtar)
		disable('main','sub')
	end
	
	if state.WeaponSet.value == 'Mandau' then
		enable('main','sub')
		equip(sets.Mandau)
		disable('main','sub')
	end

	if state.WeaponSet.value == 'Tauret' then
		enable('main','sub')
		equip(sets.Tauret)
		disable('main','sub')
	end
	
	if state.WeaponSet.value == 'Naegling' then
		if state.TPBonus.value == true then
			enable('main','sub')
			equip(sets.Naegling_Centovente)
			disable('main','sub')
		else
			enable('main','sub')
			equip(sets.Naegling)
			disable('main','sub')
		end
	end
	
	if state.WeaponSet.value == 'Karambit' then
		enable('main','sub')
		equip(sets.Karambit)
		disable('main','sub')
	end
					
end

function customize_idle_set(idleSet)

		--Allows CP back to stay on if toggled on
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

	--Handles Full Time Treasure Hunter Set
function customize_melee_set(meleeSet)
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
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

    local d_msg = 'None'
    if state.DefenseMode.value ~= 'None' then
        d_msg = state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
    end

    local i_msg = state.IdleMode.value

    local msg = ''
    if state.TreasureMode.value ~= 'None' then
        msg = msg .. ' TH: ' ..state.TreasureMode.value.. ' |'
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
        if DW_needed <= 6 then
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif DW_needed > 6 and DW_needed <= 22 then
            classes.CustomMeleeGroups:append('HighHaste')
        elseif DW_needed > 22 and DW_needed <= 26 then
            classes.CustomMeleeGroups:append('MidHaste')
        elseif DW_needed > 26 and DW_needed <= 37 then
            classes.CustomMeleeGroups:append('LowHaste')
        elseif DW_needed > 37 then
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

-- State buff checks that will equip buff gear and mark the event as handled.
function check_buff(buff_name, eventArgs)
    if state.Buff[buff_name] then
        equip(sets.buff[buff_name] or {})
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
        eventArgs.handled = true
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

        set_macro_page(1, 8)
end

function set_lockstyle()
    send_command('wait 5; input /lockstyleset ' .. lockstyleset)
end