-- Original: Finanx
-- Haste/DW Detection Requires Gearinfo Addon
-- Dressup is setup to auto load with this Lua
-- Azuresets is setup to auto load with this Lua
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
--  Job Specific Keybinds (Blue Mage Binds)
-------------------------------------------------------------------------------------------------------------------
--
--	Modes:			[ Windows + 1 ]			Naegling Weapon Set
--					[ Windows + 2 ]			Maxentius Weapon Set
--
--  WS:         	[ CTRL + Numpad1 ]    	Sanguine Blade
--					[ CTRL + Numpad2 ]    	Flat Blade
--					[ CTRL + Numpad3 ]    	Requiescat
--					[ CTRL + Numpad4 ]    	Savage Blade
--					[ CTRL + Numpad5 ]    	Chant Du Cygne
--					[ CTRL + Numpad6 ]    	Expiacion
--				
--					[ ALT + Numpad1 ]     	Black Halo
--					[ ALT + Numpad2 ]     	True Strike
--					[ ALT + Numpad3 ]     	Judgment
--					[ ALT + Numpad4 ]     	Realm Razer
--					[ ALT + Numpad4 ]     	Moonlight
--
--------------------------------------------------------------------------------------------------------------------
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
    state.Buff['Burst Affinity'] = buffactive['Burst Affinity'] or false
    state.Buff['Chain Affinity'] = buffactive['Chain Affinity'] or false
    state.Buff.Convergence = buffactive.Convergence or false
    state.Buff.Diffusion = buffactive.Diffusion or false
    state.Buff.Efflux = buffactive.Efflux or false

    state.Buff['Unbridled Learning'] = buffactive['Unbridled Learning'] or false
    blue_magic_maps = {}

    -- Mappings for gear sets to use for various blue magic spells.
    -- While Str isn't listed for each, it's generally assumed as being at least
    -- moderately signficant, even for spells with other mods.

    -- Physical spells with no particular (or known) stat mods
    blue_magic_maps.Physical = S{'Bilgestorm'}

    -- Spells with heavy accuracy penalties, that need to prioritize accuracy first.
    blue_magic_maps.PhysicalAcc = S{'Heavy Strike'}

    -- Physical spells with Str stat mod
    blue_magic_maps.PhysicalStr = S{'Battle Dance','Bloodrake','Death Scissors','Dimensional Death',
        'Empty Thrash','Quadrastrike','Saurian Slide','Sinker Drill','Spinal Cleave','Sweeping Gouge',
        'Uppercut','Vertical Cleave'}

    -- Physical spells with Dex stat mod
    blue_magic_maps.PhysicalDex = S{'Amorphic Spikes','Asuran Claws','Barbed Crescent','Claw Cyclone',
        'Disseverment','Foot Kick','Frenetic Rip','Goblin Rush','Hysteric Barrage','Paralyzing Triad',
        'Seedspray','Sickle Slash','Smite of Rage','Terror Touch','Thrashing Assault','Vanity Dive'}

    -- Physical spells with Vit stat mod
    blue_magic_maps.PhysicalVit = S{'Body Slam','Cannonball','Delta Thrust','Glutinous Dart','Grand Slam',
        'Power Attack','Quad. Continuum','Sprout Smack','Sub-zero Smash'}

    -- Physical spells with Agi stat mod
    blue_magic_maps.PhysicalAgi = S{'Benthic Typhoon','Feather Storm','Helldive','Hydro Shot','Jet Stream',
        'Pinecone Bomb','Spiral Spin','Wild Oats'}

    -- Physical spells with Int stat mod
    blue_magic_maps.PhysicalInt = S{'Mandibular Bite','Queasyshroom'}

    -- Physical spells with Mnd stat mod
    blue_magic_maps.PhysicalMnd = S{'Ram Charge','Screwdriver','Tourbillion'}

    -- Physical spells with Chr stat mod
    blue_magic_maps.PhysicalChr = S{'Bludgeon'}

    -- Physical spells with HP stat mod
    blue_magic_maps.PhysicalHP = S{'Final Sting'}

    -- Magical spells with the typical Int mod
    blue_magic_maps.Magical = S{'Anvil Lightning','Blastbomb','Blazing Bound','Bomb Toss','Cursed Sphere',
        'Droning Whirlwind','Embalming Earth','Entomb','Firespit','Foul Waters','Ice Break','Leafstorm',
        'Maelstrom','Molting Plumage','Nectarous Deluge','Regurgitation','Rending Deluge','Scouring Spate',
        'Spectral Floe','Subduction','Tem. Upheaval','Water Bomb'}

    blue_magic_maps.MagicalDark = S{'Dark Orb','Death Ray','Eyes On Me','Evryone. Grudge','Palling Salvo',
        'Tenebral Crush'}

    blue_magic_maps.MagicalLight = S{'Blinding Fulgor','Diffusion Ray','Radiant Breath','Rail Cannon',
        'Retinal Glare'}

    -- Magical spells with a primary Mnd mod
    blue_magic_maps.MagicalMnd = S{'Acrid Stream','Magic Hammer','Mind Blast'}

    -- Magical spells with a primary Chr mod
    blue_magic_maps.MagicalChr = S{'Mysterious Light'}

    -- Magical spells with a Vit stat mod (on top of Int)
    blue_magic_maps.MagicalVit = S{'Thermal Pulse'}

    -- Magical spells with a Dex stat mod (on top of Int)
    blue_magic_maps.MagicalDex = S{'Charged Whisker','Gates of Hades'}

    -- Magical spells (generally debuffs) that we want to focus on magic accuracy over damage.
    -- Add Int for damage where available, though.
    blue_magic_maps.MagicAccuracy = S{'1000 Needles','Absolute Terror','Actinic Burst','Atra. Libations',
        'Auroral Drape','Awful Eye', 'Blank Gaze','Blistering Roar','Blood Saber','Chaotic Eye',
        'Cimicine Discharge','Cold Wave','Corrosive Ooze','Demoralizing Roar','Digest','Dream Flower',
        'Enervation','Feather Tickle','Filamented Hold','Frightful Roar','Geist Wall','Hecatomb Wave',
        'Infrasonics','Jettatura','Light of Penance','Lowing','Mind Blast','Mortal Ray','MP Drainkiss',
        'Osmosis','Reaving Wind','Sandspin','Sandspray','Sheep Song','Soporific','Sound Blast',
        'Stinking Gas','Sub-zero Smash','Venom Shell','Voracious Trunk','Yawn','Silent Storm'}

    -- Breath-based spells
    blue_magic_maps.Breath = S{'Bad Breath','Flying Hip Press','Frost Breath','Heat Breath','Hecatomb Wave',
        'Magnetite Cloud','Poison Breath','Self-Destruct','Thunder Breath','Vapor Spray','Wind Breath'}

    -- Stun spells
    blue_magic_maps.Stun = S{'Blitzstrahl','Frypan','Head Butt','Sudden Lunge','Tail slap','Temporal Shift',
        'Thunderbolt','Whirl of Rage'}

    -- Healing spells
    blue_magic_maps.Healing = S{'Healing Breeze','Magic Fruit','Plenilune Embrace','Pollen','Restoral',
        'White Wind','Wild Carrot'}

    -- Buffs that depend on blue magic skill
    blue_magic_maps.SkillBasedBuff = S{'Barrier Tusk','Diamondhide','Magic Barrier','Metallic Body',
        'Plasma Charge','Pyric Bulwark','Reactor Cool','Occultation'}

    -- Other general buffs
    blue_magic_maps.Buff = S{'Amplification','Animating Wail','Carcharian Verve','Cocoon',
        'Erratic Flutter','Exuviation','Fantod','Feather Barrier','Harden Shell','Memento Mori',
        'Nat. Meditation','Orcish Counterstance','Refueling','Regeneration','Saline Coat','Triumphant Roar',
        'Warm-Up','Winds of Promyvion','Zephyr Mantle'}

    blue_magic_maps.Refresh = S{'Battery Charge'}

    -- Spells that require Unbridled Learning to cast.
    unbridled_spells = S{'Absolute Terror','Bilgestorm','Blistering Roar','Bloodrake','Carcharian Verve','Cesspool',
        'Crashing Thunder','Cruel Joke','Droning Whirlwind','Gates of Hades','Harden Shell','Mighty Guard',
        'Polar Roar','Pyric Bulwark','Tearing Gust','Thunderbolt','Tourbillion','Uproot'}
		
    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
					"Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring", "Emporox's Ring"}

    include('Mote-TreasureHunter')

    -- For th_action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}

    lockstyleset = 2
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
    state.CastingMode:options('Normal')
    state.IdleMode:options('Normal', 'Refresh')
	state.TreasureMode:options('Tag', 'None')
	state.WeaponSet = M{['description']='Weapon Set', 'Naegling', 'Maxentius', 'Magic_Accuracy'}
	state.EvasiveMode = M(false, 'EvasiveMode')

    state.CP = M(false, "Capacity Points Mode")

	--Load Gearinfo/Azuresets/Dressup Lua
	
    send_command('wait 3; lua l gearinfo')
    send_command('wait 3; lua l azureSets')
	send_command('wait 10; lua l Dressup')

    --Global Blue Mage binds (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)

    send_command('bind @c gs c toggle CP')
	send_command('bind @t gs c cycle TreasureMode')
	send_command('bind ^` gs c toggle EvasiveMode')
	
	--Weapon set Binds
	
	send_command('bind @1 gs c set WeaponSet Naegling')
	send_command('bind @2 gs c set WeaponSet Maxentius')
	send_command('bind @3 gs c set WeaponSet Magic_Accuracy')
	
	--Weaponskill Binds (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)

    send_command('bind ^numpad1 input /ws "Sanguine Blade" <t>')
    send_command('bind ^numpad2 input /ws "Flat Blade" <t>')
	send_command('bind ^numpad3 input /ws "Requiescat" <t>')
	send_command('bind ^numpad4 input /ws "Savage Blade" <t>')
	send_command('bind ^numpad5 input /ws "Chant du Cygne" <t>')
    send_command('bind ^numpad6 input /ws "Expiacion" <t>')

    send_command('bind !numpad1 input /ws "Black Halo" <t>')
    send_command('bind !numpad2 input /ws "True Strike" <t>')
	send_command('bind !numpad3 input /ws "Judgment" <t>')
	send_command('bind !numpad4 input /ws "Realm Razer" <t>')
	send_command('bind !numpad5 input /ws "Moonlight" <t>')
	
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
	
	send_command('wait 10; input //get Shihei satchel all')
	
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

	--Remove Global Blue Mage binds

    send_command('unbind @c')
	send_command('unbind @t ')
	send_command('unbind @1 ')
	send_command('unbind @2 ')

	--Remove Dual Box Binds
	
	--send_command('unbind @1')
	--send_command('unbind @2')
	--send_command('unbind @q')
	--send_command('unbind ^`')
	
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

	send_command('input //put Shihei satchel all')

	--Unload Gearinfo/Azuresets/Dressup Lua
	
    send_command('lua u gearinfo')
    send_command('lua u azureSets')
	send_command('lua u Dressup')

end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Precast sets to enhance JAs

    -- Enmity set
    sets.Enmity = {
		ammo="Sapience Orb",
		head="Malignance Chapeau",
		body={ name="Emet Harness +1", augments={'Path: A',}},
		hands="Malignance Gloves",
		legs={ name="Zoar Subligar +1", augments={'Path: A',}},
		feet="Ahosi Leggings",
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Kasiri Belt",
		left_ear="Cryptic Earring",
		right_ear="Friomisi Earring",
		left_ring="Begrudging Ring",
		right_ring="Eihwaz Ring",
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    sets.precast.JA['Provoke'] = sets.Enmity

    sets.buff['Burst Affinity'] = {legs="Assim. Shalwar +3", feet="Hashi. Basmak +1"}
    sets.buff['Diffusion'] = {feet="Luhlaza Charuqs +3"}
    sets.buff['Efflux'] = {legs="Hashishin Tayt +1"}

    sets.precast.JA['Azure Lore'] = {hands="Luh. Bazubands +1"}
    sets.precast.JA['Chain Affinity'] = {feet="Assim. Charuqs +1"}
    sets.precast.JA['Convergence'] = {head="Luh. Keffiyeh +3"}
    sets.precast.JA['Enchainment'] = {body="Luhlaza Jubbah +3"}

    sets.precast.FC = {
		ammo="Sapience Orb",
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body={ name="Adhemar Jacket +1", augments={'HP+105','"Fast Cast"+10','Magic dmg. taken -4',}},
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
		feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
		neck="Orunmila's Torque",
		waist="Witful Belt",
		left_ear="Loquac. Earring",
		right_ear="Etiolation Earring",
		left_ring="Prolix Ring",
		right_ring="Kishar Ring",
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    --sets.precast.FC['Blue Magic'] = set_combine(sets.precast.FC, {body="Hashishin Mintan +1"})
    --sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})
    --sets.precast.FC.Cure = set_combine(sets.precast.FC, {ammo="Impatiens", ear2="Mendi. Earring"})
	
	
	sets.precast.RA = {    
		range="Trollbane",
		head={ name="Taeon Chapeau", augments={'"Snapshot"+5','"Snapshot"+5',}},
		body={ name="Taeon Tabard", augments={'"Snapshot"+5','"Snapshot"+5',}},
		hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
		legs={ name="Taeon Tights", augments={'"Snapshot"+4','"Snapshot"+5',}},
		feet="Malignance Boots",
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Yemaya Belt",
		left_ear="Genmei Earring",
		right_ear="Etiolation Earring",
		left_ring="Vocane Ring",
		right_ring="Defending Ring",
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},} 

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {
		ammo="Aurgelmir Orb +1",
		head={ name="Herculean Helm", augments={'Pet: Accuracy+21 Pet: Rng. Acc.+21','"Subtle Blow"+3','Weapon skill damage +7%','Mag. Acc.+10 "Mag.Atk.Bns."+10',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Jhakri Cuffs +2",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Caro Necklace",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Rufescent Ring",
		back={ name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}


    sets.precast.WS.Acc = {
		ammo="Aurgelmir Orb +1",
		head={ name="Herculean Helm", augments={'Pet: Accuracy+21 Pet: Rng. Acc.+21','"Subtle Blow"+3','Weapon skill damage +7%','Mag. Acc.+10 "Mag.Atk.Bns."+10',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Jhakri Cuffs +2",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Caro Necklace",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Rufescent Ring",
		back={ name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}


    sets.precast.WS['Chant du Cygne'] = {
		ammo="Aurgelmir Orb +1",
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		body="Abnoba Kaftan",
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs={ name="Zoar Subligar +1", augments={'Path: A',}},
		feet="Aya. Gambieras +2",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Mache Earring +1",
		right_ear="Odr Earring",
		left_ring="Epona's Ring",
		right_ring="Begrudging Ring",
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}},}

    sets.precast.WS['Vorpal Blade'] = sets.precast.WS['Chant du Cygne']
    

    sets.precast.WS['Savage Blade'] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Caro Necklace",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Epaminondas's Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

    sets.precast.WS['Savage Blade'].Acc = {
		ammo="Aurgelmir Orb +1",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Caro Necklace",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Epaminondas's Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

    sets.precast.WS['Requiescat'] = {
		ammo="Aurgelmir Orb +1",
		head={ name="Herculean Helm", augments={'Pet: Accuracy+21 Pet: Rng. Acc.+21','"Subtle Blow"+3','Weapon skill damage +7%','Mag. Acc.+10 "Mag.Atk.Bns."+10',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Jhakri Cuffs +2",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Caro Necklace",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Rufescent Ring",
		back={ name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

    sets.precast.WS['Requiescat'].Acc = {
		ammo="Aurgelmir Orb +1",
		head={ name="Herculean Helm", augments={'Pet: Accuracy+21 Pet: Rng. Acc.+21','"Subtle Blow"+3','Weapon skill damage +7%','Mag. Acc.+10 "Mag.Atk.Bns."+10',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Jhakri Cuffs +2",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Caro Necklace",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Rufescent Ring",
		back={ name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

    sets.precast.WS['Expiacion'] = {
		ammo="Aurgelmir Orb +1",
		head={ name="Herculean Helm", augments={'Pet: Accuracy+21 Pet: Rng. Acc.+21','"Subtle Blow"+3','Weapon skill damage +7%','Mag. Acc.+10 "Mag.Atk.Bns."+10',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Jhakri Cuffs +2",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Caro Necklace",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Rufescent Ring",
		back={ name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

    sets.precast.WS['Expiacion'].Acc = {
		ammo="Aurgelmir Orb +1",
		head={ name="Herculean Helm", augments={'Pet: Accuracy+21 Pet: Rng. Acc.+21','"Subtle Blow"+3','Weapon skill damage +7%','Mag. Acc.+10 "Mag.Atk.Bns."+10',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Jhakri Cuffs +2",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Caro Necklace",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Rufescent Ring",
		back={ name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

    sets.precast.WS['Sanguine Blade'] = {
		ammo="Pemphredo Tathlum",
		head="Pixie Hairpin +1",
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands="Jhakri Cuffs +2",
		legs={ name="Herculean Trousers", augments={'"Dual Wield"+1','Pet: VIT+8','Weapon skill damage +8%','Accuracy+1 Attack+1','Mag. Acc.+18 "Mag.Atk.Bns."+18',}},
		feet={ name="Amalric Nails +1", augments={'Mag. Acc.+20','"Mag.Atk.Bns."+20','"Conserve MP"+7',}},
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear="Regal Earring",
		right_ear="Friomisi Earring",
		left_ring="Archon Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},}
		
	sets.precast.WS['Red Lotus Blade'] = {
		ammo="Pemphredo Tathlum",
		head="Jhakri Coronal +2",
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands="Jhakri Cuffs +2",
		legs={ name="Amalric Slops +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		feet={ name="Amalric Nails +1", augments={'Mag. Acc.+20','"Mag.Atk.Bns."+20','"Conserve MP"+7',}},
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Shiva Ring +1",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Weapon skill damage +10%',}},}
		
		
	sets.precast.WS['Burning Blade'] = sets.precast.WS['Red Lotus Blade']
	sets.precast.WS['Shining Blade'] = sets.precast.WS['Red Lotus Blade']
	sets.precast.WS['Seraph Blade'] = sets.precast.WS['Red Lotus Blade']
    sets.precast.WS['True Strike'] = sets.precast.WS['Savage Blade']
    sets.precast.WS['True Strike'].Acc = sets.precast.WS['Savage Blade'].Acc
    sets.precast.WS['Judgment'] = sets.precast.WS['Savage Blade']
    sets.precast.WS['Judgment'].Acc = sets.precast.WS['Savage Blade'].Acc
    sets.precast.WS['Black Halo'] = sets.precast.WS['Savage Blade']
    sets.precast.WS['Black Halo'].Acc = sets.precast.WS['Savage Blade'].Acc
    sets.precast.WS['Realmrazer'] = sets.precast.WS['Requiescat']
    sets.precast.WS['Realmrazer'].Acc = sets.precast.WS['Requiescat'].Acc

    sets.precast.WS['Flash Nova'] = set_combine(sets.precast.WS['Sanguine Blade'], {
        head="Jhakri Coronal +2",
        ring1="Stikini Ring +1",
        ring2="Stikini Ring +1",
        })

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = {
		ammo="Sapience Orb",
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body={ name="Adhemar Jacket +1", augments={'HP+105','"Fast Cast"+10','Magic dmg. taken -4',}},
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
		feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
		neck="Orunmila's Torque",
		waist="Witful Belt",
		left_ear="Loquac. Earring",
		right_ear="Etiolation Earring",
		left_ring="Prolix Ring",
		right_ring="Kishar Ring",
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    sets.midcast['Blue Magic'] = {
        ammo="Mavi Tathlum",
        head="Luh. Keffiyeh +3",
        body="Assim. Jubbah +3",
        hands="Rawhide Gloves",
        legs="Hashishin Tayt +1",
        feet="Luhlaza Charuqs +3",
        neck="Incanter's Torque",
        ring1={name="Stikini Ring +1", bag="wardrobe3"},
        ring2={name="Stikini Ring +1", bag="wardrobe4"},
        back="Cornflower Cape",
        }

    sets.midcast['Blue Magic'].Physical = {
		ammo="Ginsen",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body="Jhakri Robe +2",
		hands="Jhakri Cuffs +2",
		legs="Jhakri Slops +2",
		feet={ name="Herculean Boots", augments={'Accuracy+10 Attack+10','"Triple Atk."+4','Accuracy+14',}},
		neck="Caro Necklace",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Telos Earring",
		right_ear="Mache Earring +1",
		left_ring="Ilabrat Ring",
		right_ring="Rufescent Ring",
		back={ name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

    sets.midcast['Blue Magic'].PhysicalAcc = {
		ammo="Ginsen",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body="Jhakri Robe +2",
		hands="Jhakri Cuffs +2",
		legs="Jhakri Slops +2",
		feet={ name="Herculean Boots", augments={'Accuracy+10 Attack+10','"Triple Atk."+4','Accuracy+14',}},
		neck="Caro Necklace",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Telos Earring",
		right_ear="Mache Earring +1",
		left_ring="Ilabrat Ring",
		right_ring="Rufescent Ring",
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    sets.midcast['Blue Magic'].PhysicalStr = sets.midcast['Blue Magic'].Physical

    sets.midcast['Blue Magic'].PhysicalDex = sets.midcast['Blue Magic'].Physical

    sets.midcast['Blue Magic'].PhysicalVit = sets.midcast['Blue Magic'].Physical

    sets.midcast['Blue Magic'].PhysicalAgi = sets.midcast['Blue Magic'].Physical

    sets.midcast['Blue Magic'].PhysicalInt = set_combine(sets.midcast['Blue Magic'].Physical, {
        left_ear="Regal Earring",
        back={ name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},
        })

    sets.midcast['Blue Magic'].PhysicalMnd = set_combine(sets.midcast['Blue Magic'].Physical, {
        left_ear="Regal Earring",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
        })

    sets.midcast['Blue Magic'].PhysicalChr = set_combine(sets.midcast['Blue Magic'].Physical, {left_ear="Regal Earring",})

    sets.midcast['Blue Magic'].Magical = {
		ammo="Pemphredo Tathlum",
		head="Jhakri Coronal +2",
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		legs={ name="Amalric Slops +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		feet={ name="Amalric Nails +1", augments={'Mag. Acc.+20','"Mag.Atk.Bns."+20','"Conserve MP"+7',}},
		neck="Baetyl Pendant",
		waist="Eschan Stone",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Shiva Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},}

    sets.midcast['Blue Magic'].MagicalDark = set_combine(sets.midcast['Blue Magic'].Magical, {
        head="Pixie Hairpin +1",
        ring2="Archon Ring",
        })

    sets.midcast['Blue Magic'].MagicalLight = {
		ammo="Pemphredo Tathlum",
		head="Jhakri Coronal +2",
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		legs={ name="Amalric Slops +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		feet={ name="Amalric Nails +1", augments={'Mag. Acc.+20','"Mag.Atk.Bns."+20','"Conserve MP"+7',}},
		neck="Baetyl Pendant",
		waist="Eschan Stone",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Shiva Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},}

    sets.midcast['Blue Magic'].MagicalMnd = {
		ammo="Pemphredo Tathlum",
		head="Jhakri Coronal +2",
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		legs={ name="Amalric Slops +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		feet={ name="Amalric Nails +1", augments={'Mag. Acc.+20','"Mag.Atk.Bns."+20','"Conserve MP"+7',}},
		neck="Baetyl Pendant",
		waist="Eschan Stone",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Shiva Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},}

    sets.midcast['Blue Magic'].MagicalDex = set_combine(sets.midcast['Blue Magic'].Magical, {
        right_ring="Ilabrat Ring",
        })

    sets.midcast['Blue Magic'].MagicalVit = set_combine(sets.midcast['Blue Magic'].Magical, {})
    sets.midcast['Blue Magic'].MagicalChr = set_combine(sets.midcast['Blue Magic'].Magical, {})

    sets.midcast['Blue Magic'].MagicAccuracy = {
		ammo="Pemphredo Tathlum",
		head="Assim. Keffiyeh +3",
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands="Malignance Gloves",
		legs="Assim. Shalwar +3",
		feet="Malignance Boots",
		neck="Erra Pendant",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Crep. Earring",
		left_ring="Stikini Ring +1",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},}

    sets.midcast['Subduction'] = {
		ammo="Pemphredo Tathlum",
		head="Jhakri Coronal +2",
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		legs={ name="Amalric Slops +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		feet={ name="Amalric Nails +1", augments={'Mag. Acc.+20','"Mag.Atk.Bns."+20','"Conserve MP"+7',}},
		neck="Baetyl Pendant",
		waist="Eschan Stone",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Shiva Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},}

    sets.midcast['Yawn'] = set_combine(sets.midcast['Blue Magic'].MagicAccuracy, {
		ammo="Per. Lucky Egg",
		hands={ name="Herculean Gloves", augments={'Weapon skill damage +1%','Magic dmg. taken -2%','"Treasure Hunter"+2','Accuracy+12 Attack+12',}},
		waist="Chaac Belt",})
		
	sets.midcast.TH_Entomb = {
		ammo="Per. Lucky Egg",
		head="Jhakri Coronal +2",
		body="Volte Jupon",
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		legs={ name="Amalric Slops +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		feet={ name="Amalric Nails +1", augments={'Mag. Acc.+20','"Mag.Atk.Bns."+20','"Conserve MP"+7',}},
		neck="Baetyl Pendant",
		waist="Chaac Belt",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Shiva Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},}
		
	--sets.midcast['Blue Magic'].Breath = set_combine(sets.midcast['Blue Magic'].Magical, {head="Luh. Keffiyeh +3"})

    sets.midcast['Blue Magic'].Stun = {
		ammo="Pemphredo Tathlum",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Sanctity Necklace",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Gwati Earring",
		right_ear="Digni. Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},}

    sets.midcast['Blue Magic'].Healing = {
		ammo="Hydrocera",
		head={ name="Telchine Cap", augments={'"Fast Cast"+4','Enh. Mag. eff. dur. +10',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Telchine Gloves", augments={'Enh. Mag. eff. dur. +7',}},
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Phalaina Locket",
		waist="Luminary Sash",
		left_ear="Mendi. Earring",
		right_ear="Meili Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    sets.midcast['Blue Magic'].HealingSelf = {
	    ammo="Hydrocera",
		head={ name="Telchine Cap", augments={'"Fast Cast"+4','Enh. Mag. eff. dur. +10',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Telchine Gloves", augments={'Enh. Mag. eff. dur. +7',}},
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Phalaina Locket",
		waist="Gishdubar Sash",
		left_ear="Mendi. Earring",
		right_ear="Meili Earring",
		left_ring="Vocane Ring",
		right_ring="Kunaji Ring",
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},}


    sets.midcast['Blue Magic'].Buff = sets.midcast['Blue Magic']
    sets.midcast['Blue Magic'].Refresh = set_combine(sets.midcast['Blue Magic'], {head="Amalric Coif +1", waist="Gishdubar Sash", back="Grapevine Cape"})
    sets.midcast['Blue Magic'].SkillBasedBuff = sets.midcast['Blue Magic']

    sets.midcast['Blue Magic']['Occultation'] = {
		ammo="Sapience Orb",
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body={ name="Adhemar Jacket +1", augments={'HP+105','"Fast Cast"+10','Magic dmg. taken -4',}},
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
		feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
		neck="Orunmila's Torque",
		waist="Witful Belt",
		left_ear="Loquac. Earring",
		right_ear="Etiolation Earring",
		left_ring="Prolix Ring",
		right_ring="Kishar Ring",
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
	sets.midcast.Cure = {
		ammo="Hydrocera",
		head={ name="Telchine Cap", augments={'"Fast Cast"+4','Enh. Mag. eff. dur. +10',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Telchine Gloves", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +9',}},
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		feet={ name="Telchine Pigaches", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +10',}},
		neck="Phalaina Locket",
		waist="Luminary Sash",
		left_ear="Mendi. Earring",
		right_ear="Meili Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
	
	sets.midcast.CureSelf = {
	    ammo="Hydrocera",
		head={ name="Telchine Cap", augments={'"Fast Cast"+4','Enh. Mag. eff. dur. +10',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Telchine Gloves", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +9',}},
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		feet={ name="Telchine Pigaches", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +10',}},
		neck="Phalaina Locket",
		waist="Gishdubar Sash",
		left_ear="Mendi. Earring",
		right_ear="Meili Earring",
		left_ring="Vocane Ring",
		right_ring="Kunaji Ring",
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

	sets.midcast['Elemental Magic'] = {
		ammo="Pemphredo Tathlum",
		head="Jhakri Coronal +2",
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		legs={ name="Amalric Slops +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		feet={ name="Amalric Nails +1", augments={'Mag. Acc.+20','"Mag.Atk.Bns."+20','"Conserve MP"+7',}},
		neck="Baetyl Pendant",
		waist="Eschan Stone",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Shiva Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},}

    sets.midcast['Enhancing Magic'] = {
		ammo="Staunch Tathlum +1",
		head={ name="Telchine Cap", augments={'"Fast Cast"+4','Enh. Mag. eff. dur. +10',}},
		body={ name="Telchine Chas.", augments={'Enh. Mag. eff. dur. +10',}},
		hands={ name="Telchine Gloves", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +9',}},
		legs={ name="Telchine Braconi", augments={'"Fast Cast"+3','Enh. Mag. eff. dur. +10',}},
		feet={ name="Telchine Pigaches", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +10',}},
		neck="Incanter's Torque",
		waist="Olympus Sash",
		left_ear="Mimir Earring",
		right_ear="Andoaa Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
	sets.midcast['Refresh'] = {
		ammo="Staunch Tathlum +1",
		head={ name="Amalric Coif +1", augments={'INT+12','Mag. Acc.+25','Enmity-6',}},
		body={ name="Telchine Chas.", augments={'Enh. Mag. eff. dur. +10',}},
		hands={ name="Telchine Gloves", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +9',}},
		legs={ name="Telchine Braconi", augments={'"Fast Cast"+3','Enh. Mag. eff. dur. +10',}},
		feet={ name="Telchine Pigaches", augments={'"Cure" potency +8%','Enh. Mag. eff. dur. +10',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Gishdubar Sash",
		left_ear="Genmei Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Defending Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back="Grapevine Cape",}
		
	sets.midcast['Phalanx'] = {
		ammo="Staunch Tathlum +1",
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body={ name="Taeon Tabard", augments={'Phalanx +3',}},
		hands={ name="Taeon Gloves", augments={'"Recycle"+7','Phalanx +3',}},
		legs={ name="Taeon Tights", augments={'Accuracy+19 Attack+19','"Triple Atk."+2','Phalanx +3',}},
		feet={ name="Taeon Boots", augments={'Phalanx +3',}},
		neck="Incanter's Torque",
		waist="Olympus Sash",
		left_ear="Mimir Earring",
		right_ear="Andoaa Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
	sets.midcast['Aquaveil'] = {set_combine(sets.midcast['Enhancing Magic'], {head={ name="Amalric Coif +1", augments={'INT+12','Mag. Acc.+25','Enmity-6',}},})}
	
	sets.midcast.Enspell = {
		ammo="Staunch Tathlum +1",
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body={ name="Telchine Chas.", augments={'Enh. Mag. eff. dur. +10',}},
		hands={ name="Telchine Gloves", augments={'Enh. Mag. eff. dur. +7',}},
		legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
		feet={ name="Telchine Pigaches", augments={'Enh. Mag. eff. dur. +10',}},
		neck="Incanter's Torque",
		waist="Olympus Sash",
		left_ear="Mimir Earring",
		right_ear="Andoaa Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
	sets.midcast['Enfire'] = sets.midcast.Enspell
	sets.midcast['Enblizzard'] = sets.midcast.Enspell
	sets.midcast['Enaero'] = sets.midcast.Enspell
	sets.midcast['Enstone'] = sets.midcast.Enspell
	sets.midcast['Enthunder'] = sets.midcast.Enspell
	sets.midcast['Enwater'] = sets.midcast.Enspell

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Resting sets
    sets.resting = {
		ammo="Staunch Tathlum +1",
		head="Rawhide Mask",
		body="Jhakri Robe +2",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Flume Belt +1",
		left_ear="Genmei Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},}


    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)

    sets.idle = {
		ammo="Staunch Tathlum +1",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Bathy Choker +1", augments={'Path: A',}},
		waist="Kasiri Belt",
		left_ear="Eabani Earring",
		right_ear="Infused Earring",
		left_ring="Ilabrat Ring",
		right_ring="Vengeful Ring",
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    sets.idle.Refresh = {
		ammo="Staunch Tathlum +1",
		head="Rawhide Mask",
		body="Jhakri Robe +2",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Flume Belt +1",
		left_ear="Genmei Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},}


    --sets.idle.Learning = set_combine(sets.idle, sets.Learning)

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

    sets.engaged = {
		ammo="Ginsen",
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Herculean Boots", augments={'Accuracy+10 Attack+10','"Triple Atk."+4','Accuracy+14',}},
		neck="Sanctity Necklace",
		waist="Windbuffet Belt +1",
		left_ear="Telos Earring",
		right_ear="Brutal Earring",
		left_ring="Epona's Ring",
		right_ring="Chirich Ring +1",
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10',}},}

    sets.engaged.Acc = {
		ammo="Ginsen",
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Herculean Boots", augments={'Accuracy+10 Attack+10','"Triple Atk."+4','Accuracy+14',}},
		neck="Sanctity Necklace",
		waist="Windbuffet Belt +1",
		left_ear="Telos Earring",
		right_ear="Brutal Earring",
		left_ring="Epona's Ring",
		right_ring="Chirich Ring +1",
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10',}},}

    -- Base Dual-Wield Values:
    -- * DW6: +41%
    -- * DW5: +35%
    -- * DW4: +30%
    -- * DW3: +25% (NIN Subjob)
    -- * DW2: +15% (DNC Subjob)
    -- * DW1: +10%

    -- No Magic Haste (74% DW to cap)
    sets.engaged.DW = {
		ammo="Ginsen",
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},							--6%
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},				--6%
		feet={ name="Taeon Boots", augments={'Accuracy+25','"Dual Wield"+5','STR+5 DEX+5',}},					--9%
		neck="Sanctity Necklace",
		waist="Reiki Yotai",																					--7%
		left_ear="Eabani Earring",																				--4%
		right_ear="Suppanomimi",																				--5%
		left_ring="Epona's Ring",
		right_ring="Chirich Ring +1",
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10',}},} -- 37% + 25% traits = 62%

    sets.engaged.DW.Acc = {
		ammo="Ginsen",
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},							--6%
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},				--6%
		feet={ name="Taeon Boots", augments={'Accuracy+25','"Dual Wield"+5','STR+5 DEX+5',}},					--9%
		neck="Sanctity Necklace",
		waist="Reiki Yotai",																					--7%
		left_ear="Eabani Earring",																				--4%
		right_ear="Suppanomimi",																				--5%
		left_ring="Epona's Ring",
		right_ring="Chirich Ring +1",
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10',}},} -- 37% + 25% traits = 62%

    -- 15% Magic Haste (67% DW to cap)
    sets.engaged.DW.LowHaste = {
		ammo="Ginsen",
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},							--6%
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},				--6%
		feet={ name="Taeon Boots", augments={'Accuracy+25','"Dual Wield"+5','STR+5 DEX+5',}},					--9%
		neck="Sanctity Necklace",
		waist="Reiki Yotai",																					--7%
		left_ear="Eabani Earring",																				--4%
		right_ear="Suppanomimi",																				--5%
		left_ring="Epona's Ring",
		right_ring="Chirich Ring +1",
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10',}},} -- 37% + 25% traits = 62%

    sets.engaged.DW.Acc.LowHaste = {
		ammo="Ginsen",
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},							--6%
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},				--6%
		feet={ name="Taeon Boots", augments={'Accuracy+25','"Dual Wield"+5','STR+5 DEX+5',}},					--9%
		neck="Sanctity Necklace",
		waist="Reiki Yotai",																					--7%
		left_ear="Eabani Earring",																				--4%
		right_ear="Suppanomimi",																				--5%
		left_ring="Epona's Ring",
		right_ring="Chirich Ring +1",
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10',}},} -- 37% + 25% traits = 62%
		
    -- 30% Magic Haste (56% DW to cap)
    sets.engaged.DW.MidHaste = {
		ammo="Ginsen",
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},							--6%
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Taeon Boots", augments={'Accuracy+25','"Dual Wield"+5','STR+5 DEX+5',}},					--9%
		neck="Sanctity Necklace",
		waist="Reiki Yotai",																					--7%
		left_ear="Eabani Earring",																				--4%
		right_ear="Suppanomimi",																				--5%
		left_ring="Epona's Ring",
		right_ring="Chirich Ring +1",
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10',}},} -- 31% + 25% traits = 56%

    sets.engaged.DW.Acc.MidHaste = {
		ammo="Ginsen",
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},							--6%
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Taeon Boots", augments={'Accuracy+25','"Dual Wield"+5','STR+5 DEX+5',}},					--9%
		neck="Sanctity Necklace",
		waist="Reiki Yotai",																					--7%
		left_ear="Eabani Earring",																				--4%
		right_ear="Suppanomimi",																				--5%
		left_ring="Epona's Ring",
		right_ring="Chirich Ring +1",
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10',}},} -- 31% + 25% traits = 56%

    -- 35% Magic Haste (51% DW to cap)
    sets.engaged.DW.HighHaste = {
		ammo="Ginsen",
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},							--6%
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Taeon Boots", augments={'Accuracy+25','"Dual Wield"+5','STR+5 DEX+5',}},					--9%
		neck="Sanctity Necklace",
		waist="Reiki Yotai",																					--7%
		left_ear="Telos Earring",
		right_ear="Suppanomimi",																				--5%
		left_ring="Epona's Ring",
		right_ring="Chirich Ring +1",
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10',}},} -- 27% + 25% traits = 52%

    sets.engaged.DW.Acc.HighHaste = {
		ammo="Ginsen",
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},							--6%
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Taeon Boots", augments={'Accuracy+25','"Dual Wield"+5','STR+5 DEX+5',}},					--9%
		neck="Sanctity Necklace",
		waist="Reiki Yotai",																					--7%
		left_ear="Telos Earring",
		right_ear="Suppanomimi",																				--5%
		left_ring="Epona's Ring",
		right_ring="Chirich Ring +1",
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10',}},} -- 27% + 25% traits = 52%

    -- 45% Magic Haste (36% DW to cap)
    sets.engaged.DW.MaxHaste = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},							--6%
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Herculean Boots", augments={'Accuracy+10 Attack+10','"Triple Atk."+4','Accuracy+14',}},
		neck="Combatant's Torque",
		waist="Windbuffet Belt +1",
		left_ear="Telos Earring",
		right_ear="Suppanomimi",																				--5%
		left_ring="Epona's Ring",
		right_ring="Chirich Ring +1",
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10',}},} --11% + 25% traits = 36%

    sets.engaged.DW.Acc.MaxHaste = {
		ammo="Ginsen",
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},							--6%
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Herculean Boots", augments={'Accuracy+10 Attack+10','"Triple Atk."+4','Accuracy+14',}},
		neck="Sanctity Necklace",
		waist="Windbuffet Belt +1",
		left_ear="Telos Earring",
		right_ear="Suppanomimi",																				--5%
		left_ring="Epona's Ring",
		right_ring="Chirich Ring +1",
		back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10',}},} --11% + 25% traits = 36%

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {
		head="Malignance Chapeau", --6%
		body="Malignance Tabard",  --9%
		hands="Malignance Gloves", --5%
		legs="Malignance Tights", --7%
		feet="Malignance Boots", --4%
		right_ring="Defending Ring", --10
        } 

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

    --sets.Learning = {hands="Assim. Bazu. +1"}
    sets.latent_refresh = {waist="Fucho-no-obi"}

    sets.buff.Doom = {
		neck="Nicander's Necklace",
        waist="Gishdubar Sash", --10
        }

    sets.CP = {back="Mecisto. Mantle"}

    sets.TreasureHunter = {
		ammo="Per. Lucky Egg", --TH1
		body="Volte Jupon",		--TH2
		waist="Chaac Belt",} --TH+1
    
	sets.midcast.Dia = sets.TreasureHunter
    sets.midcast.Diaga = sets.TreasureHunter
    sets.midcast.Bio = sets.TreasureHunter
	
		--Weaponsets

	sets.Naegling = {main="Naegling", sub="Zantetsuken"}
	sets.Maxentius = {main="Kaja Rod", sub="Bunzi's Rod"}
	sets.Magic_Accuracy = {main="Bunzi's Rod", sub="Naegling"}
    

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

function job_post_midcast(spell, action, spellMap, eventArgs)
	
		--Changes Cure set if Curing yourself
	if spellMap == 'Cure' and spell.target.type == 'SELF' then
		equip(sets.midcast.CureSelf)
	end
	
		--Add enhancement gear for Chain Affinity, etc.
    if spell.skill == 'Blue Magic' then
        for buff,active in pairs(state.Buff) do
            if active and sets.buff[buff] then
                equip(sets.buff[buff])
            end
        end
        if spellMap == 'Healing' and spell.target.type == 'SELF' then
            equip(sets.midcast['Blue Magic'].HealingSelf)
        end
    end
	
		--Changes Dream Flower to use Defensive set and Entomb to use Treasure Hunter when cast while toggled
	if state.EvasiveMode.value == true then 
		if spell.english == "Dream Flower" then
			equip(sets.idle)
		end
		if spell.english == "Entomb" then
			equip(sets.midcast.TH_Entomb)
		end
	end
	
end

function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted then
        if spell.english == "Dream Flower" then
            send_command('@timers c "Dream Flower ['..spell.target.name..']" 90 down spells/00098.png')
        elseif spell.english == "Soporific" then
            send_command('@timers c "Sleep ['..spell.target.name..']" 90 down spells/00259.png')
        elseif spell.english == "Sheep Song" then
            send_command('@timers c "Sheep Song ['..spell.target.name..']" 60 down spells/00098.png')
        elseif spell.english == "Yawn" then
            send_command('@timers c "Yawn ['..spell.target.name..']" 60 down spells/00098.png')
        elseif spell.english == "Entomb" then
            send_command('@timers c "Entomb ['..spell.target.name..']" 60 down spells/00547.png')
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
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


function check_weaponset()
		if	state.WeaponSet.value == 'Naegling' then
			equip(sets.Naegling)
		end
		if state.WeaponSet.value == 'Maxentius' then
			equip(sets.Maxentius)
		end
		if state.WeaponSet.value == 'Magic_Accuracy' then
			equip(sets.Magic_Accuracy)
		end
end


-------------------------------------------------------------------------------------------------------------------
-- Code for Melee sets
-------------------------------------------------------------------------------------------------------------------

	--Gearinfo related function
function job_handle_equipping_gear(playerStatus, eventArgs)
    update_combat_form()
    determine_haste_group()
end

function job_update(cmdParams, eventArgs)
	check_gear()
	check_weaponset()
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
end

	--Custom spell mapping.
	--Return custom spellMap value that can override the default spell mapping.
	--Don't return anything to allow default spell mapping to be used.
function job_get_spell_map(spell, default_spell_map)
    if spell.skill == 'Blue Magic' then
        for category,spell_list in pairs(blue_magic_maps) do
            if spell_list:contains(spell.english) then
                return category
            end
        end
    end
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)

		--Latent Refresh function
	if state.IdleMode.value == 'Refresh' then
		if player.mpp < 51 then
			idleSet = set_combine(idleSet, sets.latent_refresh)
		end
	end
	
		--Allows CP back to stay on if toggled on
    if state.CP.current == 'on' then
        equip(sets.CP)
        disable('back')
    else
        enable('back')
    end

    return idleSet
end

	--Function to display the current relevant user state when doing an update.
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
    if state.TreasureMode.value ~= 'None' then
        msg = msg .. ' TH: ' ..state.TreasureMode.value.. ' |'
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

	--Determines Haste Group / Melee set for Gear Info
function determine_haste_group()
    classes.CustomMeleeGroups:clear()
    if DW == true then
        if DW_needed <= 11 then
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif DW_needed > 11 and DW_needed <= 21 then
            classes.CustomMeleeGroups:append('HighHaste')
        elseif DW_needed > 21 and DW_needed <= 27 then
            classes.CustomMeleeGroups:append('MidHaste')
        elseif DW_needed > 27 and DW_needed <= 37 then
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

	--Blue Job Ability Functions
function update_active_abilities()
    state.Buff['Burst Affinity'] = buffactive['Burst Affinity'] or false
    state.Buff['Efflux'] = buffactive['Efflux'] or false
    state.Buff['Diffusion'] = buffactive['Diffusion'] or false
end

	--State buff checks that will equip buff gear and mark the event as handled.
function apply_ability_bonuses(spell, action, spellMap)
    if state.Buff['Burst Affinity'] and (spellMap == 'Magical' or spellMap == 'MagicalLight' or spellMap == 'MagicalDark' or spellMap == 'Breath') then
        equip(sets.buff['Burst Affinity'])
    end
    if state.Buff.Efflux and spellMap == 'Physical' then
        equip(sets.buff['Efflux'])
    end
    if state.Buff.Diffusion and (spellMap == 'Buffs' or spellMap == 'BlueSkill') then
        equip(sets.buff['Diffusion'])
    end

    if state.Buff['Burst Affinity'] then equip (sets.buff['Burst Affinity']) end
    if state.Buff['Efflux'] then equip (sets.buff['Efflux']) end
    if state.Buff['Diffusion'] then equip (sets.buff['Diffusion']) end
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

	--Auto Adjusts gear constantly if DW/Gearinfo is active
windower.register_event('zone change', 
    function()
        send_command('gi ugs true')
    end
)

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'WAR' then
        set_macro_page(1, 2)
    elseif player.sub_job == 'RDM' then
        set_macro_page(10, 2)
    else
        set_macro_page(1, 2)
    end
end

function set_lockstyle()
    send_command('wait 5; input /lockstyleset ' .. lockstyleset)
end