-- Original: Motenten / Modified: Arislan

-------------------------------------------------------------------------------------------------------------------
--  Keybinds
-------------------------------------------------------------------------------------------------------------------

--  Modes:      [ F9 ]              Cycle Offense Modes
--              [ CTRL+F9 ]         Cycle Hybrid Modes
--              [ ALT+F9 ]          Cycle Ranged Modes
--              [ WIN+F9 ]          Cycle Weapon Skill Modes
--              [ F10 ]             Emergency -PDT Mode
--              [ ALT+F10 ]         Toggle Kiting Mode
--              [ F11 ]             Emergency -MDT Mode
--              [ F12 ]             Update Current Gear / Report Current Status
--              [ CTRL+F12 ]        Cycle Idle Modes
--              [ ALT+F12 ]         Cancel Emergency -PDT/-MDT Mode
--              [ WIN+C ]           Toggle Capacity Points Mode
--
--  Abilities:  [ CTRL+NumLock ]    Double Shot
--              [ CTRL+Numpad/ ]    Berserk/Meditate
--              [ CTRL+Numpad* ]    Warcry/Sekkanoki
--              [ CTRL+Numpad- ]    Aggressor/Third Eye
--
--  Spells:     [ WIN+, ]           Utsusemi: Ichi
--              [ WIN+. ]           Utsusemi: Ni
--
--  Weapons:    [ WIN+E/R ]         Cycles between available Weapon Sets
--
--  WS:         [ CTRL+Numpad7 ]    Trueflight
--              [ CTRL+Numpad8 ]    Last Stand
--              [ CTRL+Numpad4 ]    Wildfire
--
--  RA:         [ Numpad0 ]         Ranged Attack
--
--
--              (Global-Binds.lua contains additional non-job-related keybinds)


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
    state.Buff.Barrage = buffactive.Barrage or false
    state.Buff.Camouflage = buffactive.Camouflage or false
    state.Buff['Unlimited Shot'] = buffactive['Unlimited Shot'] or false
    state.Buff['Velocity Shot'] = buffactive['Velocity Shot'] or false
    state.Buff['Double Shot'] = buffactive['Double Shot'] or false

    -- Whether a warning has been given for low ammo
    state.warned = M(false)

    elemental_ws = S{'Aeolian Edge', 'Trueflight', 'Wildfire'}
    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
              "Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring",
              "Era. Bul. Pouch", "Dev. Bul. Pouch", "Chr. Bul. Pouch", "Quelling B. Quiver",
              "Yoichi's Quiver", "Artemis's Quiver", "Chrono Quiver"}
	no_shoot_ammo = S{"Animikii Bullet", "Hauksbok Arrow"}

    lockstyleset = 90
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal','SVB')
    state.HybridMode:options('Normal', 'DT')
    state.RangedMode:options('Normal', 'Acc', 'HighAcc')
    state.WeaponskillMode:options('Normal', 'Acc', 'Enmity')
    state.IdleMode:options('Normal', 'DT')

    state.WeaponSet = M{['description']='Weapon Set', 'Gastraphetes', 'Annihilator', 'Fomalhaut'}
    -- state.CP = M(false, "Capacity Points Mode")
	gear.RAbullet = "Quelling Bolt"
    gear.RAccbullet = "Quelling Bolt"
    gear.WSbullet = "Quelling Bolt"
    gear.MAbullet = "Quelling Bolt"
    options.ammo_warning_limit = 10

    -- Additional local binds


    -- send_command('bind @c gs c toggle CP')
    send_command('bind @r gs c cycle WeaponSet')

    send_command('bind ^numpad0 input /ra <t>')

    select_default_macro_book()
    set_lockstyle()

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
    -- send_command('unbind @c')
    send_command('unbind @r')
    send_command('unbind ^numpad0')
end


-- Set up all gear sets.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA['Eagle Eye Shot'] = {
		ammo="Quelling Bolt",
		head={ name="Arcadian Beret +2", augments={'Enhances "Recycle" effect',}},
		body={ name="Arc. Jerkin +3", augments={'Enhances "Snapshot" effect',}},
		hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
		legs={ name="Arc. Braccae +3", augments={'Enhances "Eagle Eye Shot" effect',}},
		feet="Meg. Jam. +2",
		neck="Scout's Gorget +2",
		waist="Yemaya Belt",
		left_ear="Telos Earring",
		right_ear="Enervating Earring",
		left_ring="Dingir Ring",
		right_ring="Regal Ring",
		back={ name="Belenus's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+8','"Store TP"+10',}},}
	
    sets.precast.JA['Bounty Shot'] = {hands="Amini Glove. +1", waist="Chaac Belt"}
    sets.precast.JA['Camouflage'] = {}
    sets.precast.JA['Scavenge'] = {feet="Orion Socks +2"}
    sets.precast.JA['Shadowbind'] = {hands="Orion Bracers +3"}
    sets.precast.JA['Sharpshot'] = {}
	sets.precast.JA['Barrage'] = {hands="Orion Bracers +3"}

    -- Fast cast sets for spells

    sets.precast.Waltz = {
        waist="Gishdubar Sash",
        }

    sets.precast.Waltz['Healing Waltz'] = {}

    sets.precast.FC = { 
		ammo="Quelling Bolt",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
		legs="Carmine Cuisses +1",
		feet="Malignance Boots",
		neck={ name="Scout's Gorget +2", augments={'Path: A',}},
		waist="Yemaya Belt",
		left_ear="Loquac. Earring",
		right_ear="Etiolation Earring",
		left_ring="Lebeche Ring",
		right_ring="Roller's Ring",
		back={ name="Belenus's Cape", augments={'"Snapshot"+10',}},}

    -- (10% Snapshot, 5% Rapid from Merits)
    sets.precast.RA = {
		ammo="Quelling Bolt",
		head={ name="Taeon Chapeau", augments={'Pet: Attack+17 Pet: Rng.Atk.+17','"Snapshot"+5','"Snapshot"+5',}},
		body="Amini Caban +1",
		hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
		legs="Oshosi Trousers",
		feet="Meg. Jam. +2",
		neck={ name="Scout's Gorget +2", augments={'Path: A',}},
		waist="Yemaya Belt",
		left_ear="Telos Earring",
		right_ear="Etiolation Earring",
		left_ring="Dingir Ring",
		right_ring="Arvina Ringlet +1",
		back={ name="Belenus's Cape", augments={'"Snapshot"+10',}},}

    sets.precast.RA.Flurry1 = {
		ammo="Quelling Bolt",
		head={ name="Taeon Chapeau", augments={'"Snapshot"+5','"Snapshot"+5',}},	--head="Orion Beret +3",
		body="Amini Caban +1",
		hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
		legs="Oshosi Trousers",
		feet={ name="Arcadian Socks +3", augments={'Enhances "Stealth Shot" effect',}},
		neck={ name="Scout's Gorget +2", augments={'Path: A',}},
		waist="Yemaya Belt",
		left_ear="Telos Earring",
		right_ear="Etiolation Earring",
		left_ring="Dingir Ring",
		right_ring="Arvina Ringlet +1",
		back={ name="Belenus's Cape", augments={'"Snapshot"+10',}},}

    sets.precast.RA.Flurry2 = {
		ammo="Quelling Bolt",
		head="Orion Beret +3",
		body="Amini Caban +1",
		hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
		legs={ name="Pursuer's Pants", augments={'AGI+10','"Rapid Shot"+10','"Subtle Blow"+7',}},
		feet={ name="Arcadian Socks +3", augments={'Enhances "Stealth Shot" effect',}},
		neck={ name="Scout's Gorget +2", augments={'Path: A',}},
		waist="Yemaya Belt",
		left_ear="Telos Earring",
		right_ear="Etiolation Earring",
		left_ring="Dingir Ring",
		right_ring="Arvina Ringlet +1",
		back={ name="Belenus's Cape", augments={'"Snapshot"+10',}},}

    --sets.precast.RA.Gastra = {head="Mummu Bonnet +2"}
    --sets.precast.RA.Gastra.Flurry1 = set_combine(sets.precast.RA.Gastra, {})
    --sets.precast.RA.Gastra.Flurry2 = set_combine(sets.precast.RA.Gastra.Flurry1, {})


    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {
		ammo="Quelling Bolt",
		head="Orion Beret +3",
		body={ name="Herculean Vest", augments={'Accuracy+4','"Rapid Shot"+4','Weapon skill damage +9%','Accuracy+17 Attack+17','Mag. Acc.+14 "Mag.Atk.Bns."+14',}},
		hands="Meg. Gloves +2",
		legs={ name="Arc. Braccae +3", augments={'Enhances "Eagle Eye Shot" effect',}},
		feet={ name="Herculean Boots", augments={'Mag. Acc.+18 "Mag.Atk.Bns."+18','Weapon skill damage +3%','Mag. Acc.+6','"Mag.Atk.Bns."+14',}},
		neck={ name="Scout's Gorget +2", augments={'Path: A',}},
		waist="Fotia Belt",
		left_ear="Telos Earring",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Ilabrat Ring",
		right_ring="Regal Ring",
		back={ name="Belenus's Cape", augments={'STR+20','Rng.Acc.+20 Rng.Atk.+20','STR+10','Weapon skill damage +10%',}},}

    sets.precast.WS['Apex Arrow'] = {}


    sets.precast.WS['Jishnu\'s Radiance'] = {}

	sets.precast.WS['Empyreal Arrow'] = {
		ammo="Quelling Bolt",
		head="Orion Beret +3",
		body={ name="Herculean Vest", augments={'Accuracy+4','"Rapid Shot"+4','Weapon skill damage +9%','Accuracy+17 Attack+17','Mag. Acc.+14 "Mag.Atk.Bns."+14',}},
		hands={ name="Herculean Gloves", augments={'Attack+22','MND+1','Weapon skill damage +5%','Accuracy+7 Attack+7','Mag. Acc.+13 "Mag.Atk.Bns."+13',}},
		legs={ name="Arc. Braccae +3", augments={'Enhances "Eagle Eye Shot" effect',}},
		feet={ name="Herculean Boots", augments={'Mag. Acc.+18 "Mag.Atk.Bns."+18','Weapon skill damage +3%','Mag. Acc.+6','"Mag.Atk.Bns."+14',}},
		neck={ name="Scout's Gorget +2", augments={'Path: A',}},
		waist="Yemaya Belt",
		left_ear="Telos Earring",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Dingir Ring",
		right_ring="Regal Ring",
		back={ name="Belenus's Cape", augments={'STR+20','Rng.Acc.+20 Rng.Atk.+20','STR+10','Weapon skill damage +10%',}},}

    sets.precast.WS["Last Stand"] = {
		ammo="Quelling Bolt",
		head="Orion Beret +3",
		body={ name="Herculean Vest", augments={'Accuracy+4','"Rapid Shot"+4','Weapon skill damage +9%','Accuracy+17 Attack+17','Mag. Acc.+14 "Mag.Atk.Bns."+14',}},
		hands="Meg. Gloves +2",
		legs={ name="Arc. Braccae +3", augments={'Enhances "Eagle Eye Shot" effect',}},
		feet={ name="Herculean Boots", augments={'Mag. Acc.+18 "Mag.Atk.Bns."+18','Weapon skill damage +3%','Mag. Acc.+6','"Mag.Atk.Bns."+14',}},
		neck={ name="Scout's Gorget +2", augments={'Path: A',}},
		waist="Fotia Belt",
		left_ear="Telos Earring",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Ilabrat Ring",
		right_ring="Regal Ring",
		back={ name="Belenus's Cape", augments={'STR+20','Rng.Acc.+20 Rng.Atk.+20','STR+10','Weapon skill damage +10%',}},}

    
    sets.precast.WS["Coronach"] = {	
		ammo="Quelling Bolt",
		head="Orion Beret +3",
		body={ name="Herculean Vest", augments={'Accuracy+4','"Rapid Shot"+4','Weapon skill damage +9%','Accuracy+17 Attack+17','Mag. Acc.+14 "Mag.Atk.Bns."+14',}},
		hands="Meg. Gloves +2",
		legs={ name="Arc. Braccae +3", augments={'Enhances "Eagle Eye Shot" effect',}},
		feet={ name="Herculean Boots", augments={'Mag. Acc.+18 "Mag.Atk.Bns."+18','Weapon skill damage +3%','Mag. Acc.+6','"Mag.Atk.Bns."+14',}},
		neck={ name="Scout's Gorget +2", augments={'Path: A',}},
		waist="Fotia Belt",
		left_ear="Telos Earring",
		right_ear="Sherida Earring",
		left_ring="Ilabrat Ring",
		right_ring="Regal Ring",
		back={ name="Belenus's Cape", augments={'STR+20','Rng.Acc.+20 Rng.Atk.+20','STR+10','Weapon skill damage +10%',}},}

    sets.precast.WS["Trueflight"] = {
		ammo="Quelling Bolt",
		body={ name="Cohort Cloak +1", augments={'Path: A',}},
		hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
		legs={ name="Augury Cuisses +1", augments={'Path: A',}},
		feet={ name="Herculean Boots", augments={'Mag. Acc.+18 "Mag.Atk.Bns."+18','Weapon skill damage +3%','Mag. Acc.+6','"Mag.Atk.Bns."+14',}},
		neck={ name="Scout's Gorget +2", augments={'Path: A',}},
		waist="Eschan Stone",
		left_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		right_ear="Friomisi Earring",
		left_ring="Dingir Ring",
		right_ring="Weather. Ring",
		back={ name="Belenus's Cape", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','Weapon skill damage +10%',}},}

    sets.precast.WS["Wildfire"] = {
		ammo="Quelling Bolt",
		body={ name="Cohort Cloak +1", augments={'Path: A',}},
		hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
		legs={ name="Augury Cuisses +1", augments={'Path: A',}},
		feet={ name="Herculean Boots", augments={'Mag. Acc.+18 "Mag.Atk.Bns."+18','Weapon skill damage +3%','Mag. Acc.+6','"Mag.Atk.Bns."+14',}},
		neck={ name="Scout's Gorget +2", augments={'Path: A',}},
		waist="Eschan Stone",
		left_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		right_ear="Friomisi Earring",
		left_ring="Dingir Ring",
		right_ring="Arvina Ringlet +1",
		back={ name="Belenus's Cape", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','Weapon skill damage +10%',}},}

    sets.precast.WS['Evisceration'] = {
        }

    sets.precast.WS['Aeolian Edge'] = {
		ammo="Quelling Bolt",
		head={ name="Herculean Helm", augments={'"Mag.Atk.Bns."+22','Weapon skill damage +4%','INT+12','Mag. Acc.+5',}},
		body={ name="Herculean Vest", augments={'Accuracy+4','"Rapid Shot"+4','Weapon skill damage +9%','Accuracy+17 Attack+17','Mag. Acc.+14 "Mag.Atk.Bns."+14',}},
		hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
		legs={ name="Augury Cuisses +1", augments={'Path: A',}},
		feet={ name="Herculean Boots", augments={'Mag. Acc.+18 "Mag.Atk.Bns."+18','Weapon skill damage +3%','Mag. Acc.+6','"Mag.Atk.Bns."+14',}},
		neck="Baetyl Pendant",
		waist="Eschan Stone",
		left_ear="Telos Earring",
		right_ear="Friomisi Earring",
		left_ring="Dingir Ring",
		right_ring="Arvina Ringlet +1",
		back={ name="Belenus's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%',}},}

    sets.precast.WS['Rampage'] = {}
	
	sets.precast.WS['Savage Blade'] = {
		ammo="Hauksbok Arrow",
		head="Orion Beret +3",
		body={ name="Herculean Vest", augments={'Accuracy+4','"Rapid Shot"+4','Weapon skill damage +9%','Accuracy+17 Attack+17','Mag. Acc.+14 "Mag.Atk.Bns."+14',}},
		hands="Meg. Gloves +2",
		legs={ name="Arc. Braccae +3", augments={'Enhances "Eagle Eye Shot" effect',}},
		feet={ name="Herculean Boots", augments={'Mag. Acc.+18 "Mag.Atk.Bns."+18','Weapon skill damage +3%','Mag. Acc.+6','"Mag.Atk.Bns."+14',}},
		neck={ name="Scout's Gorget +2", augments={'Path: A',}},
		waist="Fotia Belt",
		left_ear="Telos Earring",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Dingir Ring",
		right_ring="Regal Ring",
		back={ name="Belenus's Cape", augments={'STR+20','Rng.Acc.+20 Rng.Atk.+20','STR+10','Weapon skill damage +10%',}},}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Fast recast for spells

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt

    -- Ranged sets

    sets.midcast.RA = {
		ammo="Quelling Bolt",
		head="Orion Beret +3",
		body="Mummu Jacket +2",
		hands="Mummu Wrists +2",
		legs="Amini Brague +1",
		feet="Osh. Leggings +1",
		neck={ name="Scout's Gorget +2", augments={'Path: A',}},
		waist="K. Kachina Belt +1",
		left_ear="Telos Earring",
		right_ear="Enervating Earring",
		left_ring="Regal Ring",
		right_ring="Hajduk Ring +1",
		back={ name="Belenus's Cape", augments={'STR+20','Rng.Acc.+20 Rng.Atk.+20','AGI+8','"Store TP"+10',}},}

    sets.midcast.RA.Crit = {}

    sets.midcast.RA.HighAcc = {
		ammo="Quelling Bolt",
		head="Orion Beret +3",
		body="Mummu Jacket +2",
		hands="Orion Bracers +3",
		legs="Malignance Tights",
		feet="Mummu Gamash. +2",
		neck={ name="Scout's Gorget +2", augments={'Path: A',}},
		waist="K. Kachina Belt +1",
		left_ear="Telos Earring",
		right_ear="Enervating Earring",
		left_ring="Regal Ring",
		right_ring="Hajduk Ring +1",
		back={ name="Belenus's Cape", augments={'STR+20','Rng.Acc.+20 Rng.Atk.+20','AGI+8','"Store TP"+10',}},}

    sets.DoubleShot = {
		head="Oshosi Mask +1",
		body={ name="Arc. Jerkin +3", augments={'Enhances "Snapshot" effect',}},
		hands="Oshosi Gloves",
		legs="Oshosi Trousers",
		feet="Oshosi Leggings +1",
		neck={ name="Scout's Gorget +2", augments={'Path: A',}},
		waist="K. Kachina Belt +1",
		left_ear="Telos Earring",
		right_ear="Enervating Earring",
		left_ring="Hajduk Ring +1",
		right_ring="Ilabrat Ring",
		back={ name="Belenus's Cape", augments={'STR+20','Rng.Acc.+20 Rng.Atk.+20','AGI+8','"Store TP"+10',}},}


    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.resting = {}

    -- Idle sets
    sets.idle = {
		ammo="Quelling Bolt",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Carmine Cuisses +1",
		feet="Malignance Boots",
		neck={ name="Scout's Gorget +2", augments={'Path: A',}},
		waist="Yemaya Belt", 
		left_ear="Telos Earring",
		right_ear="Etiolation Earring",
		left_ring="Defending Ring",
		right_ring="Patricius Ring",
		back={ name="Belenus's Cape", augments={'STR+20','Rng.Acc.+20 Rng.Atk.+20','AGI+8','"Store TP"+10',}},}

    sets.idle.Town = {
		ammo="Quelling Bolt",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Carmine Cuisses +1",
		feet="Malignance Boots",
		neck={ name="Scout's Gorget +2", augments={'Path: A',}},
		waist="Yemaya Belt",
		left_ear="Telos Earring",
		right_ear="Etiolation Earring",
		left_ring="Defending Ring",
		right_ring="Patricius Ring",
		back={ name="Belenus's Cape", augments={'STR+20','Rng.Acc.+20 Rng.Atk.+20','AGI+8','"Store TP"+10',}},}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.defense.PDT = sets.idle.DT
    sets.defense.MDT = sets.idle.DT

    sets.Kiting = {feet="Orion Socks +3"}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    sets.engaged = {
		main={ name="Malevolence", augments={'INT+9','Mag. Acc.+10','"Mag.Atk.Bns."+9','"Fast Cast"+4',}},
		sub={ name="Malevolence", augments={'INT+10','Mag. Acc.+10','"Mag.Atk.Bns."+8','"Fast Cast"+5',}},
		range={ name="Gastraphetes", augments={'Path: A',}},
		ammo="Quelling Bolt",
		head={ name="Dampening Tam", augments={'DEX+10','Accuracy+15','Mag. Acc.+15','Quadruple Attack +3',}},
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet="Malignance Boots",
		neck={ name="Scout's Gorget +2", augments={'Path: A',}},
		waist="Sarissapho. Belt",
		left_ear="Telos Earring",
		right_ear="Sherida Earring",
		left_ring="Petrov Ring",
		right_ring="Ilabrat Ring",
		back={ name="Belenus's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+8','"Store TP"+10',}},}

    sets.engaged.SVB = {
		main="Naegling",
		sub={ name="Vampirism", augments={'STR+8','INT+9','"Occult Acumen"+8','DMG:+14',}},
		range={ name="Sparrowhawk +2", augments={'TP Bonus +1000',}},
		ammo="Hauksbok Arrow",
		head={ name="Dampening Tam", augments={'DEX+10','Accuracy+15','Mag. Acc.+15','Quadruple Attack +3',}},
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet="Malignance Boots",
		neck={ name="Scout's Gorget +2", augments={'Path: A',}},
		waist="Sarissapho. Belt",
		left_ear="Sherida Earring",
		right_ear="Eabani Earring",
		left_ring="Ilabrat Ring",
		right_ring="Petrov Ring",
		back={ name="Belenus's Cape", augments={'STR+20','Rng.Acc.+20 Rng.Atk.+20','AGI+8','"Store TP"+10',}},}



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


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.buff.Barrage = {
		ammo="Quelling Bolt",
		head="Orion Beret +3",
		body="Malignance Tabard",
		hands="Orion Bracers +3",
		legs="Malignance Tights",
		feet="Orion Socks +2",
		neck={ name="Scout's Gorget +2", augments={'Path: A',}},
		waist="K. Kachina Belt +1",
		left_ear="Telos Earring",
		right_ear="Enervating Earring",
		left_ring="Ilabrat Ring",
		left_ring="Hajduk Ring +1",
		back={ name="Belenus's Cape", augments={'STR+20','Rng.Acc.+20 Rng.Atk.+20','AGI+8','"Store TP"+10',}},}
	
	
    sets.buff['Velocity Shot'] = {}
    sets.buff.Camouflage = {}

    sets.buff.Doom = {}
	sets.Obi = {waist="Hachirin-no-Obi"}

    --sets.Reive = {neck="Ygnas's Resolve +1"}
    -- sets.CP = {back="Mecisto. Mantle"}

    sets.Annihilator = {ranged="Annihilator"}
    sets.Fomalhaut = {ranged="Fomalhaut"}
    sets.Gastraphetes = {ranged="Gastraphetes"}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    equip(sets[state.WeaponSet.current])

    if spell.action_type == 'Ranged Attack' then
        state.CombatWeapon:set(player.equipment.range)
    end
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
    if spell.action_type == 'Ranged Attack' then
        --special_ammo_check()
        if flurry == 2 then
            equip(sets.precast.RA.Flurry2)
        elseif flurry == 1 then
            equip(sets.precast.RA.Flurry1)
        end
    elseif spell.type == 'WeaponSkill' then
        if spell.skill == 'Marksmanship' then
         --   special_ammo_check()
        end
        -- Replace TP-bonus gear if not needed.
        if spell.english == 'Trueflight' or spell.english == 'Aeolian Edge' and player.tp > 2900 then
            equip(sets.FullTP)
        end
        if elemental_ws:contains(spell.name) then
            -- Matching double weather (w/o day conflict).
            if spell.element == world.weather_element and (get_weather_intensity() == 2 and spell.element ~= elements.weak_to[world.day_element]) then
                equip({waist="Hachirin-no-Obi"})
            -- Target distance under 1.7 yalms.
            --elseif spell.target.distance < (1.7 + spell.target.model_size) then
                --equip({waist="Orpheus's Sash"})
            -- Matching day and weather.
            elseif spell.element == world.day_element and spell.element == world.weather_element then
                equip({waist="Hachirin-no-Obi"})
            -- Target distance under 8 yalms.
            --elseif spell.target.distance < (8 + spell.target.model_size) then
                --equip({waist="Orpheus's Sash"})
            -- Match day or weather.
            elseif spell.element == world.day_element or spell.element == world.weather_element then
                equip({waist="Hachirin-no-Obi"})
            end
        end
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.action_type == 'Ranged Attack' then
        if buffactive['Double Shot'] then
            equip(sets.DoubleShot)
            if buffactive['Aftermath: Lv.3'] and player.equipment.ranged == "Armageddon" then
                equip(sets.DoubleShotCritical)
            end
        elseif buffactive['Aftermath: Lv.3'] and player.equipment.ranged == "Armageddon" then
            equip(sets.midcast.RA.Critical)
        end
        if state.Buff.Barrage then
            equip(sets.buff.Barrage)
        end
--        if state.Buff['Velocity Shot'] and state.RangedMode.value == 'STP' then
--            equip(sets.buff['Velocity Shot'])
--        end
    end
end


function job_aftercast(spell, action, spellMap, eventArgs)
    equip(sets[state.WeaponSet.current])

    if spell.english == "Shadowbind" then
        send_command('@timers c "Shadowbind ['..spell.target.name..']" 42 down abilities/00122.png')
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff,gain)
-- If we gain or lose any flurry buffs, adjust gear.
    if S{'flurry'}:contains(buff:lower()) then
        if not gain then
            flurry = nil
            add_to_chat(122, "Flurry status cleared.")
        end
        if not midaction() then
            handle_equipping_gear(player.status)
        end
    end

    if buff == "Camouflage" then
        if gain then
            equip(sets.buff.Camouflage)
            disable('body')
        else
            enable('body')
        end
    end

--    if buffactive['Reive Mark'] then
--        if gain then
--            equip(sets.Reive)
--            disable('neck')
--        else
--            enable('neck')
--        end
--    end

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

function job_state_change(stateField, newValue, oldValue)
    --if state.WeaponLock.value == true then
    --    disable('ranged')
    --else
    --    enable('ranged')
   -- end

    equip(sets[state.WeaponSet.current])

end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_handle_equipping_gear(playerStatus, eventArgs)
    check_gear()
    update_combat_form()
    determine_haste_group()
    check_moving()
end

function job_update(cmdParams, eventArgs)
    equip(sets[state.WeaponSet.current])
    handle_equipping_gear(player.status)
end

function update_combat_form()
    if DW == true then
        state.CombatForm:set('DW')
    elseif DW == false then
        state.CombatForm:reset()
    end
end

function get_custom_wsmode(spell, action, spellMap)
    local wsmode
    if (spell.skill == 'Marksmanship' or spell.skill == 'Archery') then
        if state.RangedMode.value == 'Acc' or state.RangedMode.value == 'HighAcc' then
            wsmode = 'Acc'
            add_to_chat(1, 'WS Mode Auto Acc')
        end
    elseif (spell.skill ~= 'Marksmanship' and spell.skill ~= 'Archery') then
        if state.OffenseMode.value == 'Acc' or state.OffenseMode.value == 'HighAcc' then
            wsmode = 'Acc'
        end
    end

    return wsmode
end

function customize_idle_set(idleSet)
    -- if state.CP.current == 'on' then
    --     equip(sets.CP)
    --     disable('back')
    -- else
    --     enable('back')
    -- end
    if state.Auto_Kite.value == true then
       idleSet = set_combine(idleSet, sets.Kiting)
    end

    return idleSet
end

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
    if state.Kiting.value then
        msg = msg .. ' Kiting: On |'
    end

    add_to_chat(002, '| ' ..string.char(31,210).. 'Melee' ..cf_msg.. ': ' ..string.char(31,001)..m_msg.. string.char(31,002)..  ' |'
        ..string.char(31,207).. ' WS: ' ..string.char(31,001)..ws_msg.. string.char(31,002)..  ' |'
        ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

--Read incoming packet to differentiate between Haste/Flurry I and II
windower.register_event('action',
    function(act)
        --check if you are a target of spell
        local actionTargets = act.targets
        playerId = windower.ffxi.get_player().id
        isTarget = false
        for _, target in ipairs(actionTargets) do
            if playerId == target.id then
                isTarget = true
            end
        end
        if isTarget == true then
            if act.category == 4 then
                local param = act.param
                if param == 845 and flurry ~= 2 then
                    --add_to_chat(122, 'Flurry Status: Flurry I')
                    flurry = 1
                elseif param == 846 then
                    --add_to_chat(122, 'Flurry Status: Flurry II')
                    flurry = 2
              end
            end
        end
    end)

function determine_haste_group()
    classes.CustomMeleeGroups:clear()
    if DW == true then
        if DW_needed <= 11 then
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif DW_needed > 11 and DW_needed <= 21 then
            classes.CustomMeleeGroups:append('MaxHastePlus')
        elseif DW_needed > 21 and DW_needed <= 27 then
            classes.CustomMeleeGroups:append('HighHaste')
        elseif DW_needed > 27 and DW_needed <= 31 then
            classes.CustomMeleeGroups:append('MidHaste')
        elseif DW_needed > 31 and DW_needed <= 42 then
            classes.CustomMeleeGroups:append('LowHaste')
        elseif DW_needed > 42 then
            classes.CustomMeleeGroups:append('')
        end
    end
end

-- Check for proper ammo when shooting or weaponskilling


function update_offense_mode()
    if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
        state.CombatForm:set('DW')
    else
        state.CombatForm:reset()
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
    if no_swap_gear:contains(player.equipment.waist) then
        disable("waist")
    else
        enable("waist")
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
        if no_swap_gear:contains(player.equipment.waist) then
            enable("waist")
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