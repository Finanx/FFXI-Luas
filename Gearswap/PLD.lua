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
-- Warp Scripts:	[ CTRL + Numpad+ ]		Warp Ring
--					[ ALT + Numpad+ ]		Dimensional Ring Dem
--					[ Windows + Numpad+ ]	Dimensional Ring Holla
--					[ Shift + Numpad+ ]		Dimensional Ring Mea
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
--					[ Windows + E]			Toggle Shield Sets
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

	state.Buff.Reprisal = buffactive.Reprisal or false

    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
					"Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring", "Emporox's Ring"}

	include('Mote-TreasureHunter')

    -- /BLU Spell Maps
    blue_magic_maps = {}

    blue_magic_maps.Enmity = S{'Blank Gaze', 'Geist Wall', 'Jettatura', 'Soporific',
        'Poison Breath', 'Blitzstrahl', 'Sheep Song', 'Chaotic Eye'}
    blue_magic_maps.Cure = S{'Wild Carrot'}
    blue_magic_maps.Buffs = S{'Cocoon', 'Refueling'}

    lockstyleset = 7
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

function user_setup()
    state.OffenseMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.HybridMode:options('Normal', 'DT')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'Aminon', 'Refresh')
	state.TreasureMode:options('Tag', 'None')


    state.WeaponSet = M{['description']='Weapon Set', 'Sakpata', 'Excalibur', 'Onion', 'Naegling', 'Burtgang'}
	state.ShieldSet = M{['description']='Shield Set', 'Duban', 'Aegis'}
	state.WeaponLock = M(false, 'Weapon Lock')
    state.Reraise = M(false, "Reraise Mode")
	state.CP = M(false, "Capacity Points Mode")	
	
	reraiseActive = false

    state.Runes = M{['description']='Runes', 'Lux', 'Tenebrae', 'Ignis', 'Gelus', 'Flabra', 'Tellus', 'Sulpor', 'Unda'}
	state.Barspell = M{['description']='Barspell', '"Barfire"', '"Barblizzard"', '"Baraero"', '"Barstone"','"Barthunder"', '"Barwater"',}

	--Includes Global Bind keys
	
	send_command('wait 2; exec Global-Binds.txt')
	
	--Rune Fencer Binds
	
	send_command('wait 2; exec /PLD/PLD-Binds.txt')
		
	--Job Settings
	
    select_default_macro_book()
    set_lockstyle()

	--gearinfo setup

    state.Auto_Kite = M(false, 'Auto_Kite')	
	Haste = 0
    moving = false
    update_combat_form()
	
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
	enable('main','sub','range','ammo','head','body','hands','legs','feet','neck','waist','left_ear','right_ear','left_ring','right_ring','back')

	--Remove Global Binds

	send_command('wait 1; exec Global-UnBinds.txt')
	
end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Enmity sets
	sets.Enmity = {
		ammo="Sapience Orb",
		head={ name="Loess Barbuta +1", augments={'Path: A',}},
		body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		feet="Chev. Sabatons +3",
		neck="Moonlight Necklace",
		waist="Creed Baudrier",
		left_ear="Cryptic Earring",
		right_ear="Trux Earring",
		left_ring="Supershear Ring",
		right_ring="Eihwaz Ring",
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}
		
	sets.SiR_Enmity = {
		ammo="Staunch Tathlum +1",
		head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		body="Chev. Cuirass +3",
		hands="Regal Gauntlets",
		legs={ name="Cab. Breeches +3", augments={'Enhances "Invincible" effect',}},
		feet={ name="Odyssean Greaves", augments={'Mag. Acc.+14','"Fast Cast"+6','VIT+2','"Mag.Atk.Bns."+12',}},
		neck="Moonlight Necklace",
		waist="Audumbla Sash",
		left_ear="Cryptic Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Eihwaz Ring",
		right_ring="Defending Ring",
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}
		
	sets.precast.JA['Holy Circle'] = set_combine(sets.Enmity,{feet="Rev. Leggings +1",})
    sets.precast.JA['Sentinel'] = set_combine(sets.Enmity,{feet={ name="Cab. Leggings +3", augments={'Enhances "Guardian" effect',}},})
    sets.precast.JA['Rampart'] = set_combine(sets.Enmity,{head={ name="Cab. Coronet +3", augments={'Enhances "Iron Will" effect',}},})
    sets.precast.JA['Fealty'] = set_combine(sets.Enmity,{body={ name="Cab. Surcoat +3", augments={'Enhances "Fealty" effect',}},})
	sets.precast.JA['Shield Bash'] = set_combine(sets.Enmity,{hands={ name="Cab. Gauntlets +3", augments={'Enhances "Chivalry" effect',}},})
	sets.precast.JA['Chivalry'] = set_combine(sets.Enmity,{hands={ name="Cab. Gauntlets +3", augments={'Enhances "Chivalry" effect',}},})
    sets.precast.JA['Divine Emblem'] = set_combine(sets.Enmity,{feet="Chev. Sabatons +3",})
    sets.precast.JA['Sepulcher'] = set_combine(sets.Enmity,{})
	sets.precast.JA['Palisade'] = set_combine(sets.Enmity,{})
	sets.precast.JA['Intervene'] = set_combine(sets.Enmity,{})
	sets.precast.JA['Invincible'] = set_combine(sets.Enmity,{legs={ name="Cab. Breeches +3", augments={'Enhances "Invincible" effect',}},})
	
	sets.precast.JA['Valiance'] = set_combine(sets.Enmity,{})
	sets.precast.JA['Vallation'] = set_combine(sets.Enmity,{})
	sets.precast.JA['Pflug'] = set_combine(sets.Enmity,{})
	sets.precast.JA['Swordplay'] = set_combine(sets.Enmity,{})
	
	
	sets.precast.RA = {}
	
		--Set used for Icarus Wing to maximize TP gain	
	sets.precast.Wing = {}
	
	sets.precast.Volte_Harness = set_combine(sets.precast.Wing, {body="Volte Harness"})
	sets.precast.Prishes_Boots = set_combine(sets.precast.Wing, {feet="Prishe\'s Boots +1",})

    -- Fast cast sets for spells

	sets.precast.FC = {
		ammo="Sapience Orb",
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body="Adamantite Armor",
		hands="Regal Gauntlets",
		legs="Enif Cosciales",
		feet="Chev. Sabatons +3",
		neck="Voltsurge Torque",
		waist="Plat. Mog. Belt",
		left_ear="Loquac. Earring",
		right_ear="Etiolation Earring",
		left_ring="Kishar Ring",
		right_ring="Prolix Ring",
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','"Fast Cast"+10','Phys. dmg. taken-10%',}},}
		
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
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Thrud Earring",
		left_ring="Sroda Ring",
		right_ring="Ephramad's Ring",
		back={ name="Rudianos's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

	sets.precast.WS['Fast Blade II'] = {
	    ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Sakpata's Plate", augments={'Path: A',}},
		hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
		legs={ name="Sakpata's Cuisses", augments={'Path: A',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Rep. Plat. Medal",
		waist={ name="Kentarch Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		left_ring="Regal Ring",
		right_ring="Ephramad's Ring",
		back={ name="Rudianos's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS.Acc = {}

	sets.precast.WS.FullTP = {left_ear="Sherida Earring",}
		
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
	
	sets.midcast.RA = {}

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast['Enhancing Magic'] = {
	    ammo="Sapience Orb",
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body="Shab. Cuirass +1",
		hands="Regal Gauntlets",
		legs="Enif Cosciales",
		feet="Chev. Sabatons +3",
		neck="Voltsurge Torque",
		waist="Plat. Mog. Belt",
		left_ear="Etiolation Earring",
		right_ear="Tuisto Earring",
		left_ring="Kishar Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','"Fast Cast"+10','Phys. dmg. taken-10%',}},}
		
    sets.midcast['Phalanx'] = {
		main={ name="Sakpata's Sword", augments={'Path: A',}},
		sub={ name="Priwen", augments={'HP+50','Mag. Evasion+50','Damage Taken -3%',}},
		ammo="Staunch Tathlum +1",
		head={ name="Yorium Barbuta", augments={'DEF+21','Spell interruption rate down -10%','Phalanx +3',}},
		body={ name="Yorium Cuirass", augments={'DEF+20','Spell interruption rate down -10%','Phalanx +3',}},
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Sakpata's Cuisses", augments={'Path: A',}},
		feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		neck="Moonlight Necklace",
		waist="Audumbla Sash",
		left_ear="Mimir Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Moonlight Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back={ name="Weard Mantle", augments={'VIT+2','DEX+1','Enmity+5','Phalanx +4',}},}
		
	sets.PhalanxRecieved = {
		main={ name="Sakpata's Sword", augments={'Path: A',}},
		sub={ name="Priwen", augments={'HP+50','Mag. Evasion+50','Damage Taken -3%',}},
		head={ name="Yorium Barbuta", augments={'DEF+21','Spell interruption rate down -10%','Phalanx +3',}},
		body={ name="Yorium Cuirass", augments={'DEF+20','Spell interruption rate down -10%','Phalanx +3',}},
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Sakpata's Cuisses", augments={'Path: A',}},
		feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		back={ name="Weard Mantle", augments={'VIT+2','DEX+1','Enmity+5','Phalanx +4',}},}
		
    sets.midcast['Reprisal'] = {
	    ammo="Sapience Orb",
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body="Shab. Cuirass +1",
		hands="Regal Gauntlets",
		legs="Enif Cosciales",
		feet="Chev. Sabatons +3",
		neck="Voltsurge Torque",
		waist="Plat. Mog. Belt",
		left_ear="Etiolation Earring",
		right_ear="Tuisto Earring",
		left_ring="Kishar Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','"Fast Cast"+10','Phys. dmg. taken-10%',}},}
		
	sets.RefreshRecieved = {waist="Gishdubar Sash"}
		
    --sets.midcast['Divine Magic'] = {}

    sets.midcast.Flash = sets.Enmity
    sets.midcast.Foil = sets.Enmity
	sets.midcast.Stun = sets.Enmity

    sets.midcast['Blue Magic'] = sets.SiR_Enmity
    sets.midcast['Blue Magic'].Enmity = sets.SiR_Enmity
    sets.midcast['Blue Magic'].Buff = sets.SiR_Enmity
	sets.midcast['Banishga'] = sets.SiR_Enmity
	sets.midcast['Banishga II'] = sets.SiR_Enmity
	sets.midcast['Banish'] = sets.SiR_Enmity
	sets.midcast['Banish II'] = sets.SiR_Enmity
	
	sets.midcast.Cure = {
		ammo="Staunch Tathlum +1",
		head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		body="Chev. Cuirass +3",
		hands="Regal Gauntlets",
		legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		feet={ name="Odyssean Greaves", augments={'Mag. Acc.+14','"Fast Cast"+6','VIT+2','"Mag.Atk.Bns."+12',}},
		neck="Moonlight Necklace",
		waist="Sroda Belt",
		left_ear={ name="Nourish. Earring +1", augments={'Path: A',}},
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Defending Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','"Fast Cast"+10','Phys. dmg. taken-10%',}},}


    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.idle = {
		ammo="Staunch Tathlum +1",
		head="Chev. Armet +3",
		body="Adamantite Armor",
		hands="Chev. Gauntlets +3",
		legs="Chev. Cuisses +3",
		feet={ name="Sakpata's Leggings", augments={'Path: A',}},
		neck={ name="Warder's Charm +1", augments={'Path: A',}},
		waist="Carrier's Sash",
		left_ear="Tuisto Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring="Shadow Ring",
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}
		
	sets.idle.Aminon = {
		ammo="Vanir Battery",
		head="Null Masque",
		body="Adamantite Armor",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Coatl Gorget +1",
		waist="Carrier's Sash",
		left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		right_ear={ name="Chev. Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+15','Mag. Acc.+15','Damage taken-5%',}},
		left_ring="Vexer Ring +1",
		right_ring="Roller's Ring",
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}
		
    sets.idle.Refresh = {
		ammo="Staunch Tathlum +1",
		head="Null Masque",
		body="Crepuscular Mail",
		hands="Regal Gauntlets",
		legs="Chev. Cuisses +3",
		feet={ name="Sakpata's Leggings", augments={'Path: A',}},
		neck={ name="Warder's Charm +1", augments={'Path: A',}},
		waist="Carrier's Sash",
		left_ear="Tuisto Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged = {
		ammo="Staunch Tathlum +1",
		head="Chev. Armet +3",
		body="Adamantite Armor",
		hands="Chev. Gauntlets +3",
		legs="Chev. Cuisses +3",
		feet={ name="Sakpata's Leggings", augments={'Path: A',}},
		neck={ name="Warder's Charm +1", augments={'Path: A',}},
		waist="Null Belt",
		left_ear="Tuisto Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Shadow Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}
		
	sets.engaged.Acc = {
		ammo="Staunch Tathlum +1",
		head="Chev. Armet +3",
		body="Adamantite Armor",
		hands="Chev. Gauntlets +3",
		legs="Chev. Cuisses +3",
		feet={ name="Sakpata's Leggings", augments={'Path: A',}},
		neck={ name="Warder's Charm +1", augments={'Path: A',}},
		waist="Null Belt",
		left_ear="Tuisto Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Shadow Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}
		
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid	= {
		ammo="Staunch Tathlum +1",
		head="Chev. Armet +3",
		body="Adamantite Armor",
		hands="Chev. Gauntlets +3",
		legs="Chev. Cuisses +3",
		feet={ name="Sakpata's Leggings", augments={'Path: A',}},
		neck={ name="Warder's Charm +1", augments={'Path: A',}},
		waist="Null Belt",
		left_ear="Tuisto Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Shadow Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	sets.Kiting = {right_ring="Shneddick Ring",}

	sets.TreasureHunter = {
		body="Volte Jupon",
		hands="Volte Bracers",
		waist="Chaac Belt",}

    sets.buff.Doom = {
		neck="Nicander's Necklace",
        waist="Gishdubar Sash", --10
        }

    sets.Obi = {waist="Hachirin-no-Obi"}
    sets.CP = {back="Mecisto. Mantle"}
	
	sets.Reraise = {head="Crepuscular Helm",body="Crepuscular Mail",}

	--Weapon Sets

    sets.Burtgang = {main="Burtgang",}
    sets.Excalibur = {main="Excalibur"}
	sets.Naegling = {main="Naegling"}
	sets.Sakpata = {main={ name="Sakpata's Sword", augments={'Path: A',}},}
	sets.Onion = {main="Onion Sword III"}
	
	--Shield Sets

	sets.Priwen = {sub={ name="Priwen", augments={'HP+50','Mag. Evasion+50','Damage Taken -3%',}},}
	sets.Duban = {sub="Duban",}	
	sets.Aegis = {sub="Aegis",}

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

	if spell.type == 'WeaponSkill' then
		if spell.english == 'Herculean Slash' or spell.english == 'Freezebite' or spell.english == 'Freezebite' then
			if player.tp > 2900 then
				equip(sets.precast.WS['Herculean Slash'].FullTP)
			end
			if world.day_element == 'Ice' then
				if world.weather_element == 'Ice' and get_weather_intensity() >= 1 then
					equip(sets.Obi)
				end
			else
				if world.weather_element == 'Ice' and get_weather_intensity() == 2 then
					equip(sets.Obi)
				end
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


end

	--Handles Weapon/Shield set changes
function job_state_change(field, new_value, old_value)
    classes.CustomMeleeGroups:clear()
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

	--Gearinfo related function
function job_handle_equipping_gear(playerStatus, eventArgs)
    update_combat_form()
	check_moving()
	Auto_Reraise()
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

	if state.WeaponSet.value == 'Burtgang' then
		if state.WeaponLock.value == true then
			equip(sets.Burtgang)
			disable('main','sub')
		else
			enable('main','sub')
			equip(sets.Burtgang)
		end
	elseif state.WeaponSet.value == 'Excalibur' then
		if state.WeaponLock.value == true then
			equip(sets.Excalibur)
			disable('main','sub')
		else
			enable('main','sub')
			equip(sets.Excalibur)
		end
	elseif state.WeaponSet.value == 'Naegling' then
		if state.WeaponLock.value == true then
			equip(sets.Naegling)
			disable('main','sub')
		else
			enable('main','sub')
			equip(sets.Naegling)
		end
	elseif state.WeaponSet.value == 'Onion' then
		if state.WeaponLock.value == true then
			equip(sets.Onion)
			disable('main','sub')
		else
			enable('main','sub')
			equip(sets.Onion)
		end
	elseif state.WeaponSet.value == 'Sakpata' then
		if state.WeaponLock.value == true then
			equip(sets.Sakpata)
			disable('main','sub')
		else
			enable('main','sub')
			equip(sets.Sakpata)
		end
	end
	
	if state.ShieldSet.value == 'Duban' then
		if state.WeaponLock.value == true then
			equip(sets.Duban)
			disable('main','sub')
		else
			if state.Buff.Reprisal then
				enable('main','sub')
				equip(sets.Priwen)
			else
				enable('main','sub')
				equip(sets.Duban)
			end
		end
	elseif state.ShieldSet.value == 'Aegis' then
		if state.WeaponLock.value == true then
			equip(sets.Aegis)
			disable('main','sub')
		else
			enable('main','sub')
			equip(sets.Aegis)
		end
	end
	
end

	--Handles Weapon set changes and Reraise set
function Auto_Reraise()
if state.Reraise.current == 'on' then
    equip(sets.Reraise)
    disable('head', 'body')
    reraiseActive = true
elseif reraiseActive and state.Reraise.current == 'off' then
    enable('head', 'body')
    reraiseActive = false
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
    set_macro_page(1, 7)
end

function set_lockstyle()
    send_command('wait 5; input /lockstyleset ' .. lockstyleset)
end