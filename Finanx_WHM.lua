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
--			    	[ Windows + W ]         Toggles Weapon Lock OFF
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
--  Job Specific Keybinds (White Mage Binds)
-------------------------------------------------------------------------------------------------------------------
--
--	Modes:			[ Windows + m ]			Toggles Magic Burst Mode
--					[ Windows + 1 ]			Sets Weapon to Maxentius then locks Main/Sub Slots
--					[ Windows + 2 ]			Sets Weapon to Xoanon then locks Main/Sub Slots
--
--  WS:         	[ CTRL + Numpad1 ]    	Hexa Strike
--					[ CTRL + Numpad2 ]    	Judgment
--					[ CTRL + Numpad3 ]    	Black Halo
--					[ CTRL + Numpad4 ]    	Realmrazer
--					[ CTRL + Numpad5 ]    	Moonlight
--					[ CTRL + Numpad6 ]    	Flash Nova
--					[ CTRL + Numpad7 ]    	Shining Strike
--				
--					[ ALT + Numpad1 ]     	Retribution
--					[ ALT + Numpad2 ]     	Full Swing
--					[ ALT + Numpad3 ]     	Shell Crusher
--					[ ALT + Numpad4 ]     	Cataclysm
--					[ ALT + Numpad5 ]     	Spirit Taker
--					[ ALT + Numpad6 ]     	Earth Crusher
--
--  Abilities:  	
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
    state.Buff['Afflatus Solace'] = buffactive['Afflatus Solace'] or false
    state.Buff['Afflatus Misery'] = buffactive['Afflatus Misery'] or false
    state.Buff['Sublimation: Activated'] = buffactive['Sublimation: Activated'] or false

	include('Mote-TreasureHunter')

    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
					"Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring", "Emporox's Ring",}

    lockstyleset = 20

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
    state.IdleMode:options('Normal', 'DT')
	state.TreasureMode:options('Tag', 'None')
	state.WeaponSet = M{['description']='Weapon Set', 'None', 'Maxentius', 'Xoanon'}
	
    state.MagicBurst = M(false, 'Magic Burst')
    state.BarElement = M{['description']='BarElement', 'Barfira', 'Barblizzara', 'Baraera', 'Barstonra', 'Barthundra', 'Barwatera'}
    state.BarStatus = M{['description']='BarStatus', 'Baramnesra', 'Barvira', 'Barparalyzra', 'Barsilencera', 'Barpetra', 'Barpoisonra', 'Barblindra', 'Barsleepra'}
    state.BoostSpell = M{['description']='BoostSpell', 'Boost-STR', 'Boost-INT', 'Boost-AGI', 'Boost-VIT', 'Boost-DEX', 'Boost-MND', 'Boost-CHR'}

    state.WeaponLock = M(false, 'Weapon Lock')
    state.CP = M(false, "Capacity Points Mode")

	--Load Gearinfo/Dressup Lua
	
    send_command('wait 3; lua l gearinfo')
	send_command('wait 10; lua l Dressup')
	
    --Global White Mage binds (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)	

    send_command('bind ^m gs c toggle MagicBurst')
	send_command('bind @t gs c cycle TreasureMode')
	send_command('bind ^- gs c cycle BarElement')
	send_command('bind ^= gs c cycleback BarElement')
	send_command('bind ^` input //gs c BarElement')
	send_command('bind !- gs c cycle BarStatus')
	send_command('bind != gs c cycleback BarStatus')
	send_command('bind !` input //gs c BarStatus')
	send_command('bind @- gs c cycle BoostSpell')
	send_command('bind @= gs c cycleback BoostSpell')
	send_command('bind @` input //gs c BoostSpell')
	
	--Weapon set Binds

	send_command('bind @1 gs c set WeaponSet Maxentius')
	send_command('bind @2 gs c set WeaponSet Xoanon')
	send_command('bind @w input /equip sub; gs c set WeaponSet None')
	
	--Weaponskill Binds (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)
	
    send_command('bind ^numpad1 input /ws "Hexa Strike" <t>')
    send_command('bind ^numpad2 input /ws "Judgment" <t>')
    send_command('bind ^numpad3 input /ws "Black Halo" <t>')
	send_command('bind ^numpad4 input /ws "Realmrazer" <t>')
    send_command('bind ^numpad5 input /ws "Moonlight" <t>')
    send_command('bind ^numpad6 input /ws "Flash Nova" <t>')
	send_command('bind ^numpad7 input /ws "Shining Strike" <t>')
	
	send_command('bind !numpad1 input /ws "Retribution" <t>')
    send_command('bind !numpad2 input /ws "Full Swing" <t>')
	send_command('bind !numpad3 input /ws "Shell Crusher" <t>')
	send_command('bind !numpad4 input /ws "Cataclysm" <t>')
	send_command('bind !numpad5 input /ws "Spirit Taker" <t>')
	send_command('bind !numpad6 input /ws "Earth Crusher" <t>')

	--Dual Box binds (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)
	
	--send_command('bind @1 input //assist me; wait 0.5; input //send Aurorasky /attack')
	--send_command('bind @2 input //assist me; wait 0.5; input //send Ardana /attack')
	--send_command('bind @q input //assist me; wait 0.5; input //send Ardana /ma "Distract" <t>')
	
	--Aurorasky Weaponskills (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)
	
	--send_command('bind ~numpad1 input //send Aurorasky /ws "Leaden Salute" <t>')
    --send_command('bind ~numpad2 input //send Aurorasky /ws "Wildfire" <t>')
    --send_command('bind ~numpad3 input //send Aurorasky /ws "Last Stand" <t>')
	
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
	
	--Ammo Scripts (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)
	
	--Gear Retrieval Commands
	
	send_command('wait 10; input //get Shihei satchel all')
		
	--Job settings

    select_default_macro_book()
    set_lockstyle()

    state.Auto_Kite = M(false, 'Auto_Kite')
    DW = false
    moving = false
    update_combat_form()
end

function user_unload()

	enable('main','sub','range','ammo','head','body','hands','legs','feet','neck','waist','left_ear','right_ear','left_ring','right_ring','back')

	--Remove Global White Mage Binds

	send_command('unbind !`')	
	send_command('unbind @w')
	send_command('unbind @r')
	send_command('unbind @t')
    send_command('unbind ^m')
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
	
	--Remove Dual Box Binds
	
	--send_command('unbind @1')
	--send_command('unbind @2')
	--send_command('unbind @q')
	
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
	
	--Remove Ammo Scripts
	
	--Gear Removal Commands
	
	send_command('input //put Shihei satchel all')

	--Unload Gearinfo/Dressup Lua
	
    send_command('lua u gearinfo')
	send_command('lua u Dressup')	
	
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

    -- Precast Sets

    -- Fast cast sets for spells

    sets.precast.FC = {
		main="Daybreak",
		sub="Genmei Shield",
		ammo="Sapience Orb",
		head={ name="Bunzi's Hat", augments={'Path: A',}},
		body="Inyanga Jubbah +2",
		hands={ name="Bunzi's Gloves", augments={'Path: A',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Orunmila's Torque",
		waist="Embla Sash",
		left_ear="Etiolation Earring",
		right_ear="Loquac. Earring",
		left_ring="Prolix Ring",
		right_ring="Kishar Ring",
		back="Alaunus's Cape",}

    sets.precast.FC.Cure = set_combine(sets.precast.FC, {})

    sets.precast.FC.Curaga = sets.precast.FC.Cure
    sets.precast.FC.CureSolace = sets.precast.FC.Cure
    sets.precast.FC.Impact = set_combine(sets.precast.FC, {head=empty, body="Twilight Cloak"})
    sets.precast.FC.Dispelga = set_combine(sets.precast.FC, {main="Daybreak", sub="Ammurapi Shield"})

    -- Precast sets to enhance JAs
    --sets.precast.JA.Benediction = {}

    -- Weaponskill sets

    send_command('bind ^numpad1 input /ws "Hexa Strike" <t>')
    send_command('bind ^numpad2 input /ws "Judgment" <t>')
    send_command('bind ^numpad3 input /ws "Black Halo" <t>')
	send_command('bind ^numpad4 input /ws "Realmrazer" <t>')
    send_command('bind ^numpad5 input /ws "Mystic Boon" <t>')
    send_command('bind ^numpad6 input /ws "Flash Nova" <t>')
	send_command('bind ^numpad7 input /ws "Shining Strike" <t>')
	
	send_command('bind !numpad1 input /ws "Retribution" <t>')
    send_command('bind !numpad2 input /ws "Full Swing" <t>')
	send_command('bind !numpad3 input /ws "Shell Crusher" <t>')
	send_command('bind !numpad4 input /ws "Cataclysm" <t>')
	send_command('bind !numpad5 input /ws "Spirit Taker" <t>')
	send_command('bind !numpad6 input /ws "Earth Crusher" <t>')


    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {}

    sets.precast.WS['Hexa Strike'] = {}
	
    sets.precast.WS['Realmrazer'] = {}
	
    sets.precast.WS['Flash Nova'] = {}

    sets.precast.WS['Mystic Boon'] = {}
	
    sets.precast.WS['Spirit Taker'] = sets.precast.WS['Mystic Boon']
	
	sets.precast.WS['Shell Crusher'] = {}
	
    sets.precast.WS['Shining Strike'] = {}
	
	sets.precast.WS['Cataclysm'] = {}
	
	sets.precast.WS['Earth Crusher'] = {}

    -- Midcast Sets

    sets.midcast.FC = sets.precast.FC

    -- Cure sets

    sets.midcast.CureSolace = {
		main="Daybreak",
		sub="Genmei Shield",
		ammo="Homiliary",
		head={ name="Kaykaus Mitra +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','"Cure" potency +6%','"Conserve MP"+7',}},
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		feet={ name="Kaykaus Boots +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		neck="Incanter's Torque",
		waist="Luminary Sash",
		left_ear="Regal Earring",
		right_ear="Meili Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Alaunus's Cape",}

    sets.midcast.CureSolaceWeather = {
		main="Daybreak",
		sub="Genmei Shield",
		ammo="Homiliary",
		head={ name="Kaykaus Mitra +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','"Cure" potency +6%','"Conserve MP"+7',}},
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		feet={ name="Kaykaus Boots +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		neck="Incanter's Torque",
		waist="Luminary Sash",
		left_ear="Regal Earring",
		right_ear="Meili Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Alaunus's Cape",}


    sets.midcast.CureNormal = {
		main="Daybreak",
		sub="Genmei Shield",
		ammo="Homiliary",
		head={ name="Kaykaus Mitra +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','"Cure" potency +6%','"Conserve MP"+7',}},
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		feet={ name="Kaykaus Boots +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		neck="Incanter's Torque",
		waist="Luminary Sash",
		left_ear="Regal Earring",
		right_ear="Meili Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Alaunus's Cape",}

    sets.midcast.CureWeather = {
		main="Daybreak",
		sub="Genmei Shield",
		ammo="Homiliary",
		head={ name="Kaykaus Mitra +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','"Cure" potency +6%','"Conserve MP"+7',}},
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		feet={ name="Kaykaus Boots +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		neck="Incanter's Torque",
		waist="Luminary Sash",
		left_ear="Regal Earring",
		right_ear="Meili Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Alaunus's Cape",}

    sets.midcast.CuragaNormal = {
		main="Daybreak",
		sub="Genmei Shield",
		ammo="Homiliary",
		head={ name="Kaykaus Mitra +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','"Cure" potency +6%','"Conserve MP"+7',}},
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		feet={ name="Kaykaus Boots +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		neck="Incanter's Torque",
		waist="Luminary Sash",
		left_ear="Regal Earring",
		right_ear="Meili Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Alaunus's Cape",}

    sets.midcast.CuragaWeather = {
		main="Daybreak",
		sub="Genmei Shield",
		ammo="Homiliary",
		head={ name="Kaykaus Mitra +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','"Cure" potency +6%','"Conserve MP"+7',}},
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		feet={ name="Kaykaus Boots +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		neck="Incanter's Torque",
		waist="Luminary Sash",
		left_ear="Regal Earring",
		right_ear="Meili Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Alaunus's Cape",}

    --sets.midcast.CureMelee = sets.midcast.CureSolace

    sets.midcast.StatusRemoval = {}

    sets.midcast.Cursna = {}

    sets.midcast.Erase = set_combine(sets.midcast.StatusRemoval, {neck="Clr. Torque +2"})

    -- 110 total Enhancing Magic Skill; caps even without Light Arts
    sets.midcast['Enhancing Magic'] = {
		sub="Ammurapi Shield",
		ammo="Sapience Orb",
		head={ name="Telchine Cap", augments={'"Fast Cast"+4','Enh. Mag. eff. dur. +10',}},
		body={ name="Telchine Chas.", augments={'Enh. Mag. eff. dur. +10',}},
		hands={ name="Telchine Gloves", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +9',}},
		legs={ name="Telchine Braconi", augments={'"Fast Cast"+3','Enh. Mag. eff. dur. +10',}},
		feet={ name="Telchine Pigaches", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +10',}},
		neck="Orunmila's Torque",
		waist="Embla Sash",
		left_ear="Andoaa Earring",
		right_ear="Mimir Earring",
		left_ring="Kishar Ring",
		right_ring="Stikini Ring +1",
		back="Alaunus's Cape",}
		
	sets.midcast.EnhancingDuration = sets.midcast['Enhancing Magic']

    sets.midcast.Regen = sets.midcast['Enhancing Magic']

    sets.midcast.Refresh = sets.midcast['Enhancing Magic']
	
	sets.midcast.RefreshSelf = {
		sub="Ammurapi Shield",
		ammo="Sapience Orb",
		head={ name="Telchine Cap", augments={'"Fast Cast"+4','Enh. Mag. eff. dur. +10',}},
		body={ name="Telchine Chas.", augments={'Enh. Mag. eff. dur. +10',}},
		hands={ name="Telchine Gloves", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +9',}},
		legs={ name="Telchine Braconi", augments={'"Fast Cast"+3','Enh. Mag. eff. dur. +10',}},
		feet={ name="Telchine Pigaches", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +10',}},
		neck="Orunmila's Torque",
		waist="Gishdubar Sash",
		left_ear="Andoaa Earring",
		right_ear="Mimir Earring",
		left_ring="Kishar Ring",
		right_ring="Stikini Ring +1",
		back="Grapevine Cape",}

    sets.midcast.Aquaveil = sets.midcast['Enhancing Magic']

    sets.midcast.Auspice = sets.midcast['Enhancing Magic']

    sets.midcast.BarElement = sets.midcast['Enhancing Magic']

    sets.midcast.BoostStat = sets.midcast['Enhancing Magic']

    sets.midcast.Protect = sets.midcast['Enhancing Magic']

    sets.midcast.Protectra = sets.midcast.Protect
    sets.midcast.Shell = sets.midcast.Protect
    sets.midcast.Shellra = sets.midcast.Protect

    sets.midcast['Divine Magic'] = {}

    sets.midcast.Banish = {}

    sets.midcast.Holy = sets.midcast.Banish

    sets.midcast['Dark Magic'] = {}

    -- Custom spell classes
	sets.midcast['Enfeebling Magic'] = {}

    sets.midcast.Dispelga = {}

    sets.midcast.Impact = {}

    -- Initializes trusts at iLvl 119
    sets.midcast.Trust = sets.precast.FC

    -- Sets to return to when not performing an action.

    -- Resting sets
    sets.resting = {
		main="Daybreak",
		sub="Genmei Shield",
		ammo="Homiliary",
		head="Befouled Crown",
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','"Cure" potency +6%','"Conserve MP"+7',}},
		hands={ name="Bunzi's Gloves", augments={'Path: A',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Fucho-no-Obi",
		left_ear="Mimir Earring",
		right_ear="Meili Earring",
		left_ring="Defending Ring",
		right_ring="Stikini Ring +1",
		back="Alaunus's Cape",}

    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
    sets.idle = {
		main="Daybreak",
		sub="Genmei Shield",
		ammo="Homiliary",
		head="Befouled Crown",
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','"Cure" potency +6%','"Conserve MP"+7',}},
		hands={ name="Bunzi's Gloves", augments={'Path: A',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Fucho-no-Obi",
		left_ear="Mimir Earring",
		right_ear="Meili Earring",
		left_ring="Defending Ring",
		right_ring="Stikini Ring +1",
		back="Alaunus's Cape",}

    sets.idle.DT = {
		main="Daybreak",
		sub="Genmei Shield",
		ammo="Homiliary",
		head="Befouled Crown",
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','"Cure" potency +6%','"Conserve MP"+7',}},
		hands={ name="Bunzi's Gloves", augments={'Path: A',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Fucho-no-Obi",
		left_ear="Mimir Earring",
		right_ear="Meili Earring",
		left_ring="Defending Ring",
		right_ring="Stikini Ring +1",
		back="Alaunus's Cape",}

    sets.Kiting = {feet="Herald's Gaiters"}
    sets.latent_refresh = {waist="Fucho-no-obi"}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Basic set for if no TP weapon is defined.
    sets.engaged = {
		main="Maxentius",
		sub="Genmei Shield",
		ammo="Amar Cluster",
		head="Aya. Zucchetto +2",
		body="Ayanmo Corazza +2",
		hands={ name="Bunzi's Gloves", augments={'Path: A',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Lissome Necklace",
		waist="Windbuffet Belt +1",
		left_ear="Brutal Earring",
		right_ear="Crep. Earring",
		left_ring="Hetairoi Ring",
		right_ring="Chirich Ring +1",
		back="Alaunus's Cape",}

    sets.engaged.Acc = {
		main="Maxentius",
		sub="Genmei Shield",
		ammo="Amar Cluster",
		head="Aya. Zucchetto +2",
		body="Ayanmo Corazza +2",
		hands={ name="Bunzi's Gloves", augments={'Path: A',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Combatant's Torque",
		waist="Grunfeld Rope",
		left_ear="Mache Earring +1",
		right_ear="Crep. Earring",
		left_ring="Hetairoi Ring",
		right_ring="Chirich Ring +1",
		back="Alaunus's Cape",}

    sets.engaged.DW = {
		main="Maxentius",
		sub="Bunzi's Rod",
		ammo="Amar Cluster",
		head="Aya. Zucchetto +2",
		body="Ayanmo Corazza +2",
		hands={ name="Bunzi's Gloves", augments={'Path: A',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Lissome Necklace",
		waist="Windbuffet Belt +1",
		left_ear="Eabani Earring",
		right_ear="Suppanomimi",
		left_ring="Hetairoi Ring",
		right_ring="Chirich Ring +1",
		back="Alaunus's Cape",}

    sets.engaged.DW.Acc = {
		main="Maxentius",
		sub="Bunzi's Rod",
		ammo="Amar Cluster",
		head="Aya. Zucchetto +2",
		body="Ayanmo Corazza +2",
		hands={ name="Bunzi's Gloves", augments={'Path: A',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Combatant's Torque",
		waist="Grunfeld Rope",
		left_ear="Eabani Earring",
		right_ear="Suppanomimi",
		left_ring="Hetairoi Ring",
		right_ring="Chirich Ring +1",
		back="Alaunus's Cape",}

    sets.engaged.Aftermath = {
		ammo="Amar Cluster",
		head="Aya. Zucchetto +2",
		body="Ayanmo Corazza +2",
		hands={ name="Bunzi's Gloves", augments={'Path: A',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Lissome Necklace",
		waist="Windbuffet Belt +1",
		left_ear="Eabani Earring",
		right_ear="Suppanomimi",
		left_ring="Hetairoi Ring",
		right_ring="Chirich Ring +1",
		back="Alaunus's Cape",}

    -- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
		sets.buff['Divine Caress'] = {hands="Ebers Mitts +1", back="Mending Cape"}
		sets.buff['Devotion'] = {head="Piety Cap +3"}
		sets.buff.Sublimation = {waist="Embla Sash"}
	
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	sets.TreasureHunter = {
		ammo="Per. Lucky Egg", 		--TH1
		body="Volte Jupon",			--TH2
		waist="Chaac Belt",} 	 	--TH1

	
    sets.buff.Doom = {
		neck="Nicander's Necklace",
		waist="Gishdubar Sash", --10
        }
		
	sets.Warp = {left_ring="Warp Ring"}

    sets.Obi = {waist="Hachirin-no-Obi"}
	
    sets.CP = {back="Mecisto. Mantle"}
	
	--Weapon Sets

	sets.Maxentius = {main="Maxentius", sub="Daybreak",}
	sets.Maxentius.SW = {main="Maxentius", sub="Genmei Shield"}
	
	sets.Xoanon = {main="Kaja Staff", sub="Enki Strap"}

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
    if spell.name == 'Impact' then
        equip(sets.precast.FC.Impact)
    end
end

function job_post_precast(spell, action, spellMap, eventArgs)
		--Equips gearset to precast Impact
    if spell.name == 'Impact' then
        equip(sets.precast.FC.Impact)
    end
		--Equips gearset to precast Dispelga
	if spell.name == 'Dispelga' then
        equip(sets.precast.FC.Dispelga)
    end
end

function job_post_midcast(spell, action, spellMap, eventArgs)

    -- Apply Divine Caress boosting items as highest priority over other gear, if applicable.
    if spellMap == 'StatusRemoval' and buffactive['Divine Caress'] then
        equip(sets.buff['Divine Caress'])
    end
	
    if spellMap == 'Banish' or spellMap == "Holy" then
        if (world.weather_element == 'Light' or world.day_element == 'Light') then
            equip(sets.Obi)
        end
    end
	
	-- Handles Enhancing Magic
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
	end
	
		--Changes all Enfeebling magic to accuracy set
	if state.CastingMode.value == 'MACC' and spell.skill == 'Enfeebling Magic' then
		equip(sets.midcast['Enfeebling Magic'].MACC)
	end
	
		--Handles Magic Burst Toggle
	if state.MagicBurst.value == true and spell.skill == 'Elemental Magic' then
		equip(sets.midcast['Elemental Magic'].MagicBurst)
	end
	
	if state.MagicBurst.value == true and spell.skill == 'Divine Magic' then
		if spell.name ~= 'Repose' or spell.name ~= 'Flash' then
			equip(sets.midcast['Divine Magic'].MagicBurst)
		end
	end
	
		--Changes Cure set if Curing yourself
    if spellMap == 'Cure' and spell.target.type == 'SELF' then
        equip(sets.midcast.CureSelf)
    end
	
		--Handles Elemental Magic Mappings
    if spell.skill == 'Elemental Magic' then

			--Equips gearset to cast Impact
		if spell.english == "Impact" then
                equip(sets.midcast.Impact)
        end
		
			--Equips gearset to cast Impact
		if spell.english == "Dispelga" then
                equip(sets.midcast.Dispelga)
        end
		
			--Equips Obi set if the correct day or weather matches Elemental Magic
        if (spell.element == world.day_element or spell.element == world.weather_element) then
            equip(sets.Obi)
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
-- Code for Melee sets
-------------------------------------------------------------------------------------------------------------------

	--Gearinfo related function
function job_handle_equipping_gear(playerStatus, eventArgs)
    update_combat_form()
end

function job_update(cmdParams, eventArgs)
	check_gear()
    handle_equipping_gear(player.status)
end

	--Adjusts Melee/Weapon sets for Dual Wield or Single Wield
function update_combat_form()
    if DW == true then
        state.CombatForm:set('DW')
    elseif DW == false then
        state.CombatForm:reset()
    end
	
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
	
	if state.WeaponSet.value == 'None' then
		enable('main','sub')
	end
end

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if default_spell_map == 'Cure' then
            if buffactive['Afflatus Solace'] then
				if (world.weather_element == 'Light' or world.day_element == 'Light') then
					return "CureSolaceWeather"
				else
					return "CureSolace"
				end
            else
                if (world.weather_element == 'Light' or world.day_element == 'Light') then
                    return "CureWeather"
                else
                    return "CureNormal"
				end
			end
        elseif default_spell_map == 'Curaga' then
            if (world.weather_element == 'Light' or world.day_element == 'Light') then
                return "CuragaWeather"
            else
                return "CuragaNormal"
            end
		end
    end
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if buffactive['Aftermath: Lv.3'] and player.equipment.main == "Yagrush" then
        meleeSet = set_combine(meleeSet, sets.engaged.Aftermath)
    end

    return meleeSet
end

function customize_idle_set(idleSet)

    if state.Buff['Sublimation: Activated'] and state.IdleMode.value == 'Normal' then
        idleSet = set_combine(idleSet, sets.buff.Sublimation)
    end

    if player.mpp < 51 and state.IdleMode.value == 'Normal' then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end

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
	
    if state.MagicBurst.value == true and state.TreasureMode.value == 'Tag' then
		msg = ' TH: Tag | Burst: On |'
	elseif 		state.TreasureMode.value == 'Tag' then
		msg = msg .. ' TH: Tag |'
	elseif state.MagicBurst.value == true then
		msg = ' Burst: On |'
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

	--Gear Info Functions
function job_self_command(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'scholar' then
        handle_strategems(cmdParams)
        eventArgs.handled = true
    elseif cmdParams[1]:lower() == 'nuke' then
        handle_nuking(cmdParams)
        eventArgs.handled = true
    elseif cmdParams[1]:lower() == 'barelement' then
        send_command('@input /ma '..state.BarElement.value..' <me>')
    elseif cmdParams[1]:lower() == 'barstatus' then
        send_command('@input /ma '..state.BarStatus.value..' <me>')
    elseif cmdParams[1]:lower() == 'boostspell' then
        send_command('@input /ma '..state.BoostSpell.value..' <me>')
    end

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

function update_sublimation()
    state.Buff['Sublimation: Activated'] = buffactive['Sublimation: Activated'] or false
end

-- Auto Kite Feature
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
        if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
            send_command('gi ugs true')
        end
    end
)

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
		--Default macro set/book
    set_macro_page(1, 6)
end

function set_lockstyle()
    send_command('wait 5; input /lockstyleset ' .. lockstyleset)
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    set_macro_page(1, 4)
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end
