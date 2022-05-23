-- Original: Arislan / Modified: Finanx
-- Haste/DW Detection Requires Gearinfo Addon
-- Dressup is setup to auto load with this Lua
-- Itemizer addon is required for auto gear sorting / Warp Scripts / Range Scripts
-------------------------------------------------------------------------------------------------------------------
--  Keybinds
-------------------------------------------------------------------------------------------------------------------
--
--  Modes:      	[ F9 ]              Cycle Offense Mode
--              	[ F10 ]             Cycle Idle Mode
--              	[ F11 ]             Cycle Casting Mode
--              	[ F12 ]             Update Current Gear / Report Current Status
--					[ CTRL + F9 ]		Cycle Weapon Skill Mode
--					[ ALT + F9 ]		Cycle Range Mode
--              	[ Windows + F9 ]    Cycle Hybrid Modes
--
--  Abilities:  	
--
--
--  Weapons:    	[ CTRL + W ]          Toggles Weapon Lock
--
--  WS:         	[ CTRL + Numpad1 ]    Hexa Strike
--					[ CTRL + Numpad2 ]    Judgment
--					[ CTRL + Numpad3 ]    Flash Nova
--					[ CTRL + Numpad4 ]    True Strike
--					[ CTRL + Numpad5 ]    Seraph Strike
--					[ CTRL + Numpad6 ]    Starlight
--					[ CTRL + Numpad7 ]    Moonlight
--
-- Item Binds:		[ Shift + Numpad1 ]	Echo Drop
--					[ Shift + Numpad2 ]	Holy Water
--					[ Shift + Numpad3 ]	Remedy
--					[ Shift + Numpad4 ]	Panacea
--					[ Shift + Numpad7 ]	Silent Oil
--					[ Shift + Numpad9 ]	Prism Powder
--
--					[ Windows + Numpad1 ]	Sublime Sushi
--					[ Windows + Numpad2 ]	Grape Daifuku
--					[ Windows + Numpad3 ]	Tropical Crepe
--					[ Windows + Numpad4 ]	Miso Ramen
--					[ Windows + Numpad5 ]	Red Curry Bun
--					[ Windows + Numpad7 ]	Toolbag (Shihei)
--
--
-- Warp Script:		[ CTRL + Numpad+ ]	Warp Ring
--					[ ALT + Numpad+ ]	Dimensional Ring Dem
--
--
-- Range Script:	[ CTRL + Numpad0 ] (Auto Retrieves Trollbane from Satchel and puts it back once finished)
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
    geo_timer = ''
    indi_timer = ''
    indi_duration = 308
    entrust_timer = ''
    entrust_duration = 344
    entrust = 0
    newLuopan = 0

    state.Buff.Entrust = buffactive.Entrust or false
    state.Buff['Blaze of Glory'] = buffactive['Blaze of Glory'] or false

    -- state.CP = M(false, "Capacity Points Mode")

    state.Auto = M(true, 'Auto Nuke')
    state.Element = M{['description']='Element','Fire','Blizzard','Aero','Stone','Thunder','Water'}

    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
              "Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring"}

    degrade_array = {
        ['Fire'] = {'Fire','Fire II','Fire III','Fire IV','Fire V'},
        ['Ice'] = {'Blizzard','Blizzard II','Blizzard III','Blizzard IV','Blizzard V'},
        ['Wind'] = {'Aero','Aero II','Aero III','Aero IV','Aero V'},
        ['Earth'] = {'Stone','Stone II','Stone III','Stone IV','Stone V'},
        ['Lightning'] = {'Thunder','Thunder II','Thunder III','Thunder IV','Thunder V'},
        ['Water'] = {'Water', 'Water II','Water III', 'Water IV','Water V'},
        ['Aspirs'] = {'Aspir','Aspir II','Aspir III'},
        }

    lockstyleset = 2

end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'MagicBurst')
    state.IdleMode:options('Normal', 'Refresh')

    state.WeaponLock = M(false, 'Weapon Lock')
    state.MagicBurst = M(false, 'Magic Burst')

    --Global Red Mage binds (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)	

    send_command('bind !` gs c toggle MagicBurst')
	send_command('bind @w gs c toggle WeaponLock')
	
	--Weaponskill Binds (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)

    send_command('bind ^numpad1 input /ws "Hexa Stike" <t>')
    send_command('bind ^numpad2 input /ws "Judgment" <t>')
    send_command('bind ^numpad3 input /ws "Flash Nova" <t>')
	send_command('bind ^numpad4 input /ws "True Strike" <t>')
    send_command('bind ^numpad5 input /ws "Seraph Strike" <t>')
    send_command('bind ^numpad7 input /ws "Starlight" <t>')
	send_command('bind ^numpad9 input /ws "Moonlight" <t>')

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
		
	--Warp scripts (this allows the ring to stay in your Sack fulltime) (Requires Itemizer Addon) (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)

	send_command('bind ^numpad+ input //get Warp Ring Sack; wait 1; input /equip Ring1 "Warp Ring"; wait 12; input /item "Warp Ring" <me>; wait 60; input //put Warp Ring Sack')
	send_command('bind !numpad+ input //get Dim. Ring (Dem) Sack; wait 1; input /equip Ring1 "Dim. Ring (Dem)"; wait 12; input /item "Dim. Ring (Dem)" <me>; wait 60; input //put Dim. Ring (Dem) Sack')    
	
    select_default_macro_book()
    set_lockstyle()

    state.Auto_Kite = M(false, 'Auto_Kite')
    moving = false
end

function user_unload()
 
 --Remove Global Red Mage Binds

	send_command('unbind !`')	
	send_command('unbind @w')
	send_command('unbind @r')
	send_command('unbind @t')
	send_command('unbind ^`')
	send_command('unbind ^-')

	--Remove Dual Box Binds
	
	send_command('unbind @1')
	send_command('unbind @2')
	send_command('unbind @q')
	
	send_command('unbind ~numpad1')
    send_command('unbind ~numpad2')
    send_command('unbind ~numpad3')
	
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
	
	send_command('unbind ^numpad.')
	
end


-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Precast Sets -----------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA.Bolster = {body="Bagua Tunic"}
    sets.precast.JA['Full Circle'] = {head="Azimuth Hood +1"}
    sets.precast.JA['Life Cycle'] = {
		head="Bagua Galero", 
		body="Geomancy Tunic +2", 
		back={ name="Nantosuelta's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Damage taken-5%',}},}


    -- Fast cast sets for spells

    sets.precast.FC = {
		main={ name="Solstice", augments={'Mag. Acc.+20','Pet: Damage taken -4%','"Fast Cast"+5',}},
		sub="Genmei Shield",
		range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
		head={ name="Merlinic Hood", augments={'"Fast Cast"+5',}},
		body={ name="Telchine Chas.", augments={'Mag. Evasion+25','Pet: "Regen"+3','Pet: Damage taken -4%',}},
		hands={ name="Merlinic Dastanas", augments={'"Fast Cast"+5','MND+8','Mag. Acc.+12','"Mag.Atk.Bns."+11',}},
		legs="Geomancy Pants +2",
		feet={ name="Merlinic Crackows", augments={'"Fast Cast"+5',}},
		neck={ name="Bagua Charm +2", augments={'Path: A',}},
		waist="Channeler's Stone",
		left_ear="Andoaa Earring",
		right_ear="Etiolation Earring",
		left_ring="Prolix Ring",
		right_ring="Kishar Ring",
		back={ name="Nantosuelta's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Damage taken-5%',}},}

    sets.precast.FC['Enhancing Magic'] = {
		main={ name="Solstice", augments={'Mag. Acc.+20','Pet: Damage taken -4%','"Fast Cast"+5',}},
		sub="Genmei Shield",
		range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
		head={ name="Merlinic Hood", augments={'"Fast Cast"+5',}},
		body={ name="Telchine Chas.", augments={'Mag. Evasion+25','Pet: "Regen"+3','Pet: Damage taken -4%',}},
		hands={ name="Merlinic Dastanas", augments={'"Fast Cast"+5','MND+8','Mag. Acc.+12','"Mag.Atk.Bns."+11',}},
		legs="Geomancy Pants +2",
		feet={ name="Merlinic Crackows", augments={'"Fast Cast"+5',}},
		neck={ name="Bagua Charm +2", augments={'Path: A',}},
		waist="Channeler's Stone",
		left_ear="Andoaa Earring",
		right_ear="Etiolation Earring",
		left_ring="Prolix Ring",
		right_ring="Kishar Ring",
		back={ name="Nantosuelta's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Damage taken-5%',}},}

    sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {hands="Bagua Mitaines +3"})

    sets.precast.FC.Cure = {
		main={ name="Solstice", augments={'Mag. Acc.+20','Pet: Damage taken -4%','"Fast Cast"+5',}},
		sub="Sors Shield",
		range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
		head={ name="Merlinic Hood", augments={'"Fast Cast"+5',}},
		body={ name="Vanya Robe", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
		hands={ name="Merlinic Dastanas", augments={'"Fast Cast"+5','MND+8','Mag. Acc.+12','"Mag.Atk.Bns."+11',}},
		legs="Geomancy Pants +2",
		feet={ name="Merlinic Crackows", augments={'"Fast Cast"+5',}},
		neck={ name="Bagua Charm +2", augments={'Path: A',}},
		waist="Channeler's Stone",
		left_ear="Andoaa Earring",
		right_ear="Etiolation Earring",
		left_ring="Prolix Ring",
		right_ring="Kishar Ring",
		back={ name="Nantosuelta's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Damage taken-5%',}},}

    sets.precast.FC.Curaga = sets.precast.FC.Cure
    sets.precast.FC.Impact = set_combine(sets.precast.FC, {head=empty, body="Twilight Cloak"})
    sets.precast.FC.Dispelga = set_combine(sets.precast.FC, {main="Daybreak", sub="Ammurapi Shield"})


    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        head="Jhakri Coronal +2",
        body="Jhakri Robe +2",
        hands="Jhakri Cuffs +2",
        legs="Jhakri Slops +2",
        feet="Jhakri Pigaches +2",
        neck="Fotia Gorget",
        ear1="Moonshade Earring",
        ear2="Brutal Earring",
        ring1="Petrov Ring",
        ring2="Hetairoi Ring",
        waist="Fotia Belt",
        }

    ------------------------------------------------------------------------
    ----------------------------- Midcast Sets -----------------------------
    ------------------------------------------------------------------------

    -- Base fast recast for spells
    sets.midcast.FastRecast = {
		main={ name="Solstice", augments={'Mag. Acc.+20','Pet: Damage taken -4%','"Fast Cast"+5',}},
		sub="Genmei Shield",
		range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
		head={ name="Merlinic Hood", augments={'"Fast Cast"+5',}},
		body={ name="Telchine Chas.", augments={'Mag. Evasion+25','Pet: "Regen"+3','Pet: Damage taken -4%',}},
		hands={ name="Merlinic Dastanas", augments={'"Fast Cast"+5','MND+8','Mag. Acc.+12','"Mag.Atk.Bns."+11',}},
		legs="Geomancy Pants +2",
		feet={ name="Merlinic Crackows", augments={'"Fast Cast"+5',}},
		neck={ name="Bagua Charm +2", augments={'Path: A',}},
		waist="Channeler's Stone",
		left_ear="Andoaa Earring",
		right_ear="Etiolation Earring",
		left_ring="Defending Ring",
		right_ring="Kishar Ring",
		back={ name="Nantosuelta's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Damage taken-5%',}},}

   sets.midcast.Geomancy = {
		main={ name="Solstice", augments={'Mag. Acc.+20','Pet: Damage taken -4%','"Fast Cast"+5',}},
		sub="Genmei Shield",
		range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
		head="Azimuth Hood +1",
		body="Azimuth Coat",
		hands="Geomancy Mitaines +2",
		legs={ name="Bagua Pants +1", augments={'Enhances "Mending Halation" effect',}},
		feet="Azimuth Gaiters +1",
		neck={ name="Bagua Charm +2", augments={'Path: A',}},
		waist="Luminary Sash",
		left_ear="Genmei Earring",
		right_ear="Etiolation Earring",
		left_ring="Defending Ring",
		right_ring="Kishar Ring",
		back={ name="Nantosuelta's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Damage taken-5%',}},}

    sets.midcast.Geomancy.Indi = {
		main={ name="Solstice", augments={'Mag. Acc.+20','Pet: Damage taken -4%','"Fast Cast"+5',}},
		sub="Genmei Shield",
		range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
		head="Azimuth Hood +1",
		body="Azimuth Coat",
		hands="Geomancy Mitaines +2",
		legs={ name="Bagua Pants +1", augments={'Enhances "Mending Halation" effect',}},
		feet="Azimuth Gaiters +1",
		neck={ name="Bagua Charm +2", augments={'Path: A',}},
		waist="Luminary Sash",
		left_ear="Genmei Earring",
		right_ear="Etiolation Earring",
		left_ring="Defending Ring",
		right_ring="Kishar Ring",
		back={ name="Nantosuelta's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Damage taken-5%',}},}

    sets.midcast.Cure = {
		main={ name="Gada", augments={'Enh. Mag. eff. dur. +6','MND+6','"Mag.Atk.Bns."+3','DMG:+14',}},
		sub="Sors Shield",
		range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
		head={ name="Vanya Hood", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
		body={ name="Vanya Robe", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
		hands={ name="Vanya Cuffs", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
		legs={ name="Vanya Slops", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
		feet={ name="Vanya Clogs", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
		neck="Loricate Torque +1",
		waist="Luminary Sash",
		left_ear="Mendi. Earring",
		right_ear="Etiolation Earring",
		left_ring="Sirona's Ring",
		right_ring="Ephedra Ring",
		back="Tempered Cape +1",}

    sets.midcast.Curaga = {
		main={ name="Gada", augments={'Enh. Mag. eff. dur. +6','MND+6','"Mag.Atk.Bns."+3','DMG:+14',}},
		sub="Sors Shield",
		range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
		head={ name="Vanya Hood", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
		body={ name="Vanya Robe", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
		hands={ name="Vanya Cuffs", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
		legs={ name="Vanya Slops", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
		feet={ name="Vanya Clogs", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
		neck="Loricate Torque +1",
		waist="Luminary Sash",
		left_ear="Mendi. Earring",
		right_ear="Etiolation Earring",
		left_ring="Sirona's Ring",
		right_ring="Ephedra Ring",
		back="Tempered Cape +1",}

    sets.midcast.Cursna = set_combine(sets.midcast.Cure, {
        ring1="Ephedra Ring",
        })

    sets.midcast['Enhancing Magic'] = {
		main={ name="Gada", augments={'Enh. Mag. eff. dur. +6','MND+6','"Mag.Atk.Bns."+3','DMG:+14',}},
		sub="Genmei Shield",
		range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
		head={ name="Merlinic Hood", augments={'"Fast Cast"+5',}},
		body={ name="Telchine Chas.", augments={'Mag. Evasion+25','Pet: "Regen"+3','Pet: Damage taken -4%',}},
		hands={ name="Telchine Gloves", augments={'Enh. Mag. eff. dur. +9',}},
		legs="Geomancy Pants +2",
		feet={ name="Merlinic Crackows", augments={'"Fast Cast"+5',}},
		neck={ name="Bagua Charm +2", augments={'Path: A',}},
		waist="Channeler's Stone",
		left_ear="Andoaa Earring",
		right_ear="Etiolation Earring",
		left_ring="Prolix Ring",
		right_ring="Kishar Ring",
		back={ name="Nantosuelta's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Damage taken-5%',}},}

    sets.midcast.EnhancingDuration = {
		main={ name="Gada", augments={'Enh. Mag. eff. dur. +6','MND+6','"Mag.Atk.Bns."+3','DMG:+14',}},
		sub="Genmei Shield",
		range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
		head={ name="Merlinic Hood", augments={'"Fast Cast"+5',}},
		body={ name="Telchine Chas.", augments={'Mag. Evasion+25','Pet: "Regen"+3','Pet: Damage taken -4%',}},
		hands={ name="Telchine Gloves", augments={'Enh. Mag. eff. dur. +9',}},
		legs="Geomancy Pants +2",
		feet={ name="Merlinic Crackows", augments={'"Fast Cast"+5',}},
		neck={ name="Bagua Charm +2", augments={'Path: A',}},
		waist="Channeler's Stone",
		left_ear="Andoaa Earring",
		right_ear="Etiolation Earring",
		left_ring="Prolix Ring",
		right_ring="Kishar Ring",
		back={ name="Nantosuelta's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Damage taken-5%',}},}

    sets.midcast.Regen = set_combine(sets.midcast.EnhancingDuration, {
        main="Bolelabunga",
        sub="Ammurapi Shield",
        })

    sets.midcast.Refresh = set_combine(sets.midcast.EnhancingDuration, {
        head="Amalric Coif",
        })

    sets.midcast.Protect = set_combine(sets.midcast.EnhancingDuration, {ring2="Sheltered Ring"})
    sets.midcast.Protectra = sets.midcast.Protect
    sets.midcast.Shell = sets.midcast.Protect
    sets.midcast.Shellra = sets.midcast.Protect


    sets.midcast.MndEnfeebles = {
		main={ name="Solstice", augments={'Mag. Acc.+20','Pet: Damage taken -4%','"Fast Cast"+5',}},
		sub="Genmei Shield",
		range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
		head="Geo. Galero +2",
		body="Geomancy Tunic +2",
		hands="Geo. Mitaines +2",
		legs="Geomancy Pants +2",
		feet="Geo. Sandals +2",
		neck={ name="Bagua Charm +2", augments={'Path: A',}},
		waist="Luminary Sash",
		left_ear="Gwati Earring",
		right_ear="Digni. Earring",
		left_ring="Mallquis Ring",
		right_ring="Jhakri Ring",
		back={ name="Nantosuelta's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Damage taken-5%',}},}

    sets.midcast.IntEnfeebles = {
		main={ name="Solstice", augments={'Mag. Acc.+20','Pet: Damage taken -4%','"Fast Cast"+5',}},
		sub="Genmei Shield",
		range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
		head="Geo. Galero +2",
		body="Geomancy Tunic +2",
		hands="Geo. Mitaines +2",
		legs="Geomancy Pants +2",
		feet="Geo. Sandals +2",
		neck={ name="Bagua Charm +2", augments={'Path: A',}},
		waist="Luminary Sash",
		left_ear="Gwati Earring",
		right_ear="Digni. Earring",
		left_ring="Mallquis Ring",
		right_ring="Jhakri Ring",
		back={ name="Nantosuelta's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Damage taken-5%',}},}
		
	sets.midcast['Dia II'] = {
		main={ name="Solstice", augments={'Mag. Acc.+20','Pet: Damage taken -4%','"Fast Cast"+5',}},
		sub="Genmei Shield",
		range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
		head="Geo. Galero +2",
		body="Geomancy Tunic +2",
		hands="Geo. Mitaines +2",
		legs={ name="Merlinic Shalwar", augments={'MND+1','INT+3','"Treasure Hunter"+2','Accuracy+18 Attack+18',}},
		feet="Geo. Sandals +2",
		neck={ name="Bagua Charm +2", augments={'Path: A',}},
		waist="Luminary Sash",
		left_ear="Gwati Earring",
		right_ear="Digni. Earring",
		left_ring="Mallquis Ring",
		right_ring="Jhakri Ring",
		back={ name="Nantosuelta's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Damage taken-5%',}},}

    sets.midcast.Dispelga = set_combine(sets.midcast.IntEnfeebles, {main="Daybreak", sub="Ammurapi Shield"})

    sets.midcast['Dark Magic'] = {
		main={ name="Solstice", augments={'Mag. Acc.+20','Pet: Damage taken -4%','"Fast Cast"+5',}},
		sub="Genmei Shield",
		range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
		head="Geo. Galero +2",
		body="Geomancy Tunic +2",
		hands="Geo. Mitaines +2",
		legs="Geomancy Pants +2",
		feet="Geo. Sandals +2",
		neck={ name="Bagua Charm +2", augments={'Path: A',}},
		waist="Luminary Sash",
		left_ear="Gwati Earring",
		right_ear="Digni. Earring",
		left_ring="Mallquis Ring",
		right_ring="Jhakri Ring",
		back={ name="Nantosuelta's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Damage taken-5%',}},}

    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {
		ammo="Pemphredo Tathlum",
        head="Bagua Galero +3",
        ring1="Evanescence Ring",
        ring2="Archon Ring",
        ear2="Mani Earring",
        waist="Fucho-no-Obi",
        })

    sets.midcast.Aspir = sets.midcast.Drain

    sets.midcast.Stun = {
		main={ name="Solstice", augments={'Mag. Acc.+20','Pet: Damage taken -4%','"Fast Cast"+5',}},
		sub="Genmei Shield",
		range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
		head="Geo. Galero +2",
		body="Geomancy Tunic +2",
		hands="Geo. Mitaines +2",
		legs="Geomancy Pants +2",
		feet="Geo. Sandals +2",
		neck={ name="Bagua Charm +2", augments={'Path: A',}},
		waist="Luminary Sash",
		left_ear="Gwati Earring",
		right_ear="Digni. Earring",
		left_ring="Mallquis Ring",
		right_ring="Jhakri Ring",
		back={ name="Nantosuelta's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Damage taken-5%',}},}

    -- Elemental Magic sets

    sets.midcast['Elemental Magic'] = {
		main="Kaja Rod",
		sub="Genmei Shield",
		ammo="Pemphredo Tathlum",
		head="Jhakri Coronal +2",
		body="Jhakri Robe +2",
		hands="Jhakri Cuffs +2",
		legs="Jhakri Slops +2",
		feet="Jhakri Pigaches +2",
		neck="Stoicheion Medal",
		waist="Eschan Stone",
		left_ear="Malignance Earring",
		right_ear="Hecate's Earring",
		left_ring="Kishar Ring",
		right_ring="Mallquis Ring",
		back={ name="Nantosuelta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10',}},}

    sets.midcast['Elemental Magic'].MagicBurst = {
		main="Kaja Rod",
		sub="Genmei Shield",
		ammo="Pemphredo Tathlum",
		head="Ea Hat +1",
		body="Ea Houppe. +1",
		hands="Ea Cuffs +1",
		legs="Ea Slops +1",
		feet="Jhakri Pigaches +2",
		neck="Stoicheion Medal",
		waist="Eschan Stone",
		left_ear="Malignance Earring",
		right_ear="Hecate's Earring",
		left_ring="Locus Ring",
		right_ring="Mujin Band",
		back={ name="Nantosuelta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10',}},}

    sets.midcast.GeoElem = set_combine(sets.midcast['Elemental Magic'], {})


    sets.midcast.Impact = set_combine(sets.midcast['Elemental Magic'], {
        head=empty,
        body="Twilight Cloak",
        ring2="Archon Ring",
        })

    -- Initializes trusts at iLvl 119
    sets.midcast.Trust = sets.precast.FC

    ------------------------------------------------------------------------------------------------
    ------------------------------------------ Idle Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.idle = {
		main={ name="Solstice", augments={'Mag. Acc.+20','Pet: Damage taken -4%','"Fast Cast"+5',}},
		sub="Genmei Shield",
		range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
		head={ name="Telchine Cap", augments={'Mag. Evasion+23','Pet: "Regen"+3','Pet: Damage taken -4%',}},
		body={ name="Telchine Chas.", augments={'Mag. Evasion+25','Pet: "Regen"+3','Pet: Damage taken -4%',}},
		hands="Geo. Mitaines +2",
		legs={ name="Telchine Braconi", augments={'Mag. Evasion+25','Pet: "Regen"+3','Pet: Damage taken -4%',}},
		feet={ name="Bagua Sandals +1", augments={'Enhances "Radial Arcana" effect',}},
		neck={ name="Bagua Charm +2", augments={'Path: A',}},
		waist="Isa Belt",
		left_ear="Genmei Earring",
		right_ear="Etiolation Earring",
		left_ring="Defending Ring",
		right_ring="Persis Ring",
		back={ name="Nantosuelta's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Pet: "Regen"+10','Pet: "Regen"+5',}},}

    sets.resting = {
		main="Bolelabunga",
		sub="Genmei Shield",
		range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
		head={ name="Telchine Cap", augments={'Mag. Evasion+23','Pet: "Regen"+3','Pet: Damage taken -4%',}},
		body="Jhakri Robe +2",
		hands="Geo. Mitaines +2",
		legs="Assid. Pants +1",
		feet={ name="Bagua Sandals +1", augments={'Enhances "Radial Arcana" effect',}},
		neck={ name="Bagua Charm +2", augments={'Path: A',}},
		waist="Isa Belt",
		left_ear="Genmei Earring",
		right_ear="Etiolation Earring",
		left_ring="Defending Ring",
		right_ring="Persis Ring",
		back={ name="Nantosuelta's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Pet: "Regen"+10','Pet: "Regen"+5',}},}

    sets.idle.Refresh = {
		main="Bolelabunga",
		sub="Genmei Shield",
		range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
		head={ name="Telchine Cap", augments={'Mag. Evasion+23','Pet: "Regen"+3','Pet: Damage taken -4%',}},
		body="Jhakri Robe +2",
		hands="Geo. Mitaines +2",
		legs="Assid. Pants +1",
		feet={ name="Bagua Sandals +1", augments={'Enhances "Radial Arcana" effect',}},
		neck={ name="Bagua Charm +2", augments={'Path: A',}},
		waist="Isa Belt",
		left_ear="Genmei Earring",
		right_ear="Etiolation Earring",
		left_ring="Defending Ring",
		right_ring="Persis Ring",
		back={ name="Nantosuelta's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Pet: "Regen"+10','Pet: "Regen"+5',}},}


    sets.Kiting = {feet="Geo. Sandals +3"}

    sets.latent_refresh = {waist="Fucho-no-Obi"}

    --------------------------------------
    -- Engaged sets
    --------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee group
    sets.engaged = {
        main="Idris",
        sub="Genmei Shield",
        head="Jhakri Coronal +2",
        body="Jhakri Robe +2",
        hands="Jhakri Cuffs +2",
        legs="Jhakri Slops +2",
        feet="Jhakri Pigaches +2",
        ear1="Cessance Earring",
        ear2="Brutal Earring",
        ring1="Petrov Ring",
        ring2="Hetairoi Ring",
        waist="Cetl Belt",
        }


    --------------------------------------
    -- Custom buff sets
    --------------------------------------


    sets.buff.Doom = {ring1={name="Saida Ring", bag="wardrobe3"}, ring2={name="Saida Ring", bag="wardrobe4"},}
    sets.Obi = {waist="Hachirin-no-Obi"}
    -- sets.CP = {back="Mecisto. Mantle"}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_pretarget(spell, spellMap, eventArgs)
    if spell.type == 'Geomancy' then
        if spell.name:startswith('Indi') and state.Buff.Entrust and spell.target.type == 'SELF' then
            add_to_chat(002, 'Entrust active - Select a party member!')
            cancel_spell()
        end
    end
end

function job_precast(spell, action, spellMap, eventArgs)
    if spell.name:startswith('Aspir') then
        refine_various_spells(spell, action, spellMap, eventArgs)
    elseif state.Auto.value == true then
        if spell.skill == 'Elemental Magic' and spell.english ~= 'Impact' and spellMap ~= 'GeoNuke' then
            refine_various_spells(spell, action, spellMap, eventArgs)
        end
    end
end

function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.name == 'Impact' then
        equip(sets.precast.FC.Impact)
    end
end

function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.skill == 'Elemental Magic' then
        if state.MagicBurst.value then
            equip(sets.magic_burst)
            if spell.english == "Impact" then
                equip(sets.midcast.Impact)
            end
        end
        if (spell.element == world.day_element or spell.element == world.weather_element) then
            equip(sets.Obi)
        end
    elseif spell.skill == 'Enhancing Magic' and classes.NoSkillSpells:contains(spell.english) then
        equip(sets.midcast.EnhancingDuration)
        if spellMap == 'Refresh' then
            equip(sets.midcast.Refresh)
        end
    elseif spell.skill == 'Geomancy' then
        if state.Buff.Entrust and spell.english:startswith('Indi-') then
            equip({main=gear.Gada_GEO})
                entrust = 1
        end
    end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted then
        --[[if spell.english:startswith('Geo') then
            geo_timer = spell.english
            send_command('@timers c "'..geo_timer..'" 600 down spells/00136.png')
        elseif spell.english:startswith('Indi') then
            if entrust == 1 then
                entrust_timer = spell.english
                send_command('@timers c "'..entrust_timer..' ['..spell.target.name..']" '..entrust_duration..' down spells/00136.png')
                entrust = 0
            else
                send_command('@timers d "'..indi_timer..'"')
                indi_timer = spell.english
                send_command('@timers c "'..indi_timer..'" '..indi_duration..' down spells/00136.png')
            end
        end ]]
        if spell.english == "Sleep II" then
            send_command('@timers c "Sleep II ['..spell.target.name..']" 90 down spells/00259.png')
        elseif spell.english == "Sleep" or spell.english == "Sleepga" then -- Sleep & Sleepga Countdown --
            send_command('@timers c "Sleep ['..spell.target.name..']" 60 down spells/00253.png')
        elseif spell.english:startswith('Geo-') or spell.english == "Life Cycle" then
            newLuopan = 1
        end
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if buff == "doom" then
        if gain then
            equip(sets.buff.Doom)
            send_command('@input /p Doomed.')
             disable('ring1','ring2','waist')
        else
            enable('ring1','ring2','waist')
            handle_equipping_gear(player.status)
        end
    end

end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if state.WeaponLock.value == true then
        disable('main','sub')
    else
        enable('main','sub')
    end
end

-- Called when a player gains or loses a pet.
-- pet == pet structure
-- gain == true if the pet was gained, false if it was lost.
function job_pet_change(petparam, gain)
    if gain == false then
        send_command('@timers d "'..geo_timer..'"')
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function job_handle_equipping_gear(playerStatus, eventArgs)
    check_gear()
    check_moving()
end

function job_update(cmdParams, eventArgs)
    handle_equipping_gear(player.status)
    classes.CustomIdleGroups:clear()
end

function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if spell.skill == 'Enfeebling Magic' then
            if spell.type == 'WhiteMagic' then
                return 'MndEnfeebles'
            else
                return 'IntEnfeebles'
            end
        elseif spell.skill == 'Geomancy' then
            if spell.english:startswith('Indi') then
                return 'Indi'
            end
        elseif spell.skill == 'Elemental Magic' then
            if spellMap == 'GeoElem' then
                return 'GeoElem'
            end
        end
    end
end

function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    -- if state.CP.current == 'on' then
    --     equip(sets.CP)
    --     disable('back')
    -- else
    --     enable('back')
    -- end
    if pet.isvalid then
        if pet.hpp > 73 then
            if newLuopan == 1 then
                equip(sets.PetHP)
                disable('head')
            end
        elseif pet.hpp <= 73 then
            enable('head')
            newLuopan = 0
        end
    end
    if state.Auto_Kite.value == true then
       idleSet = set_combine(idleSet, sets.Kiting)
    end

    return idleSet
end

-- Function to display the current relevant user state when doing an update.
function display_current_job_state(eventArgs)
    local c_msg = state.CastingMode.value

    local d_msg = 'None'
    if state.DefenseMode.value ~= 'None' then
        d_msg = state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
    end

    local i_msg = state.IdleMode.value

    local msg = ''
    if state.MagicBurst.value then
        msg = ' Burst: On |'
    end
    if state.Auto.value then
        msg = ' Auto: On |'
    end
    if state.Kiting.value then
        msg = msg .. ' Kiting: On |'
    end

    add_to_chat(060, '| Magic: ' ..string.char(31,001)..c_msg.. string.char(31,002)..  ' |'
        ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
end

function refine_various_spells(spell, action, spellMap, eventArgs)

    local newSpell = spell.english
    local spell_recasts = windower.ffxi.get_spell_recasts()
    local cancelling = 'All '..spell.english..' are on cooldown. Cancelling.'

    local spell_index

    if spell_recasts[spell.recast_id] > 0 then
        if spell.skill == 'Elemental Magic' and spellMap ~= 'GeoElem' then
            spell_index = table.find(degrade_array[spell.element],spell.name)
            if spell_index > 1 then
                newSpell = degrade_array[spell.element][spell_index - 1]
                send_command('@input /ma '..newSpell..' '..tostring(spell.target.raw))
                eventArgs.cancel = true
            end
        elseif spell.name:startswith('Aspir') then
            spell_index = table.find(degrade_array['Aspirs'],spell.name)
            if spell_index > 1 then
                newSpell = degrade_array['Aspirs'][spell_index - 1]
                send_command('@input /ma '..newSpell..' '..tostring(spell.target.raw))
                eventArgs.cancel = true
            end
        end
    end
end



-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function job_self_command(cmdParams, eventArgs)
    if cmdParams[1] == 'nuke' and not midaction() then
        send_command('@input /ma "' .. state.Element.current .. ' V" <t>')
    end
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

function check_moving()
    if state.DefenseMode.value == 'None'  and state.Kiting.value == false then
        if state.Auto_Kite.value == false and moving then
            state.Auto_Kite:set(true)
        elseif state.Auto_Kite.value == true and moving == false then
            state.Auto_Kite:set(false)
        end
    end
end

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
    set_macro_page(1, 6)
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end