-- Original: Motenten / Modified: Arislan
-- Haste/DW Detection Requires Gearinfo Addon

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
	-- Load and initialize the include file.
    mote_include_version = 2
	include('Mote-Include.lua')
	include('organizer-lib')
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

    lockstyleset = 87

no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
              "Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring"}


end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()

    state.OffenseMode:options('Normal', 'Multi')
    state.HybridMode:options('Normal', 'DT')
    state.RangedMode:options('STP', 'Normal', 'Acc', 'HighAcc', 'Critical')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.IdleMode:options('Normal', 'DT')

    state.WeaponSet = M{['description']='Weapon Set', 'Gastraphetes', 'Fomalhaut'}
    state.CP = M(false, "Capacity Points Mode")

    state.MoveSpeed  = M(true, "MoveSpeed")
    state.Moving  = M(false, "moving")

    DefaultAmmo = {['Yoichinoyumi'] = "Chrono Arrow",
                   ['Gandiva'] = "Chrono Arrow",
                   ['Fail-Not'] = "Chrono Arrow",
                   ['Annihilator'] = "Chrono Bullet",
                   ['Armageddon'] = "Chrono Bullet",
                   ['Gastraphetes'] = "Quelling Bolt",
                   ['Fomalhaut'] = "Chrono Bullet",
                   }

    AccAmmo = {    ['Yoichinoyumi'] = "Yoichi's Arrow",
                   ['Gandiva'] = "Yoichi's Arrow",
                   ['Fail-Not'] = "Yoichi's Arrow",
                   ['Annihilator'] = "Devastating Bullet",
                   ['Armageddon'] = "Devastating Bullet",
                   ['Gastraphetes'] = "Quelling Bolt",
                   ['Fomalhaut'] = "Chrono Bullet",
                   }

    WSAmmo = {     ['Yoichinoyumi'] = "Chrono Arrow",
                   ['Gandiva'] = "Chrono Arrow",
                   ['Fail-Not'] = "Chrono Arrow",
                   ['Annihilator'] = "Chrono Bullet",
                   ['Armageddon'] = "Chrono Bullet",
                   ['Gastraphetes'] = "Quelling Bolt",
                   ['Fomalhaut'] = "Chrono Bullet",
                   }

    MagicAmmo = {  ['Yoichinoyumi'] = "Chrono Arrow",
                   ['Gandiva'] = "Chrono Arrow",
                   ['Fail-Not'] = "Chrono Arrow",
                   ['Annihilator'] = "Chrono Bullet",
                   ['Armageddon'] = "Chrono Bullet",
                   ['Gastraphetes'] = "Quelling Bolt",
                   ['Fomalhaut'] = "Chrono Bullet",
                   }


    -- Additional local binds


    --send_command('bind ^` input /ja "Velocity Shot" <me>')
    --send_command ('bind @` input /ja "Scavenge" <me>')

    --send_command('bind @c gs c toggle CP')
    --send_command('bind @e gs c cycleback WeaponSet')

    send_command('lua l hovershot')
    send_command('bind f10 gs c cycle WeaponskillMode')
    send_command('bind !f10 gs c toggle MoveSpeed')

    --send_command('bind ^numlock input /ja "Double Shot" <me>')


    --send_command('bind ^numpad7 input /ws "Trueflight" <t>')
    send_command('bind numpad1 input /ws "Last Stand" <t>')
    --send_command('bind ^numpad4 input /ws "Wildfire" <t>')
    --send_command('bind ^numpad6 input /ws "Coronach" <t>')
    --send_command('bind ^numpad2 input /ws "Sniper Shot" <t>')
    --send_command('bind ^numpad3 input /ws "Numbing Shot" <t>')

    send_command('bind numpad0 input /ra <t>')

    select_default_macro_book()
    set_lockstyle()

    Haste = 0
    DW_needed = 0
    DW = false
    moving = false
    update_combat_form()
    determine_haste_group()
	
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()

    send_command('unbind f9')
    send_command('unbind ^f9')
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind @`')
    send_command('unbind ^,')
    send_command('unbind @f')
    send_command('unbind @c')
    send_command('unbind @e')
    send_command('unbind @r')
    send_command('unbind ^numlock')
    send_command('unbind ^numpad/')
    send_command('unbind ^numpad*')
    send_command('unbind ^numpad-')
    send_command('unbind ^numpad7')
    send_command('unbind ^numpad8')
    send_command('unbind ^numpad4')
    send_command('unbind ^numpad6')
	send_command('unbind numpad1')
    send_command('unbind ^numpad2')
    send_command('unbind ^numpad3')
    send_command('unbind numpad0')

    send_command('unbind #`')
    send_command('unbind #1')
    send_command('unbind #2')
    send_command('unbind #3')
    send_command('unbind #4')
    send_command('unbind #5')
    send_command('unbind #6')
    send_command('unbind #7')
    send_command('unbind #8')
    send_command('unbind #9')
    send_command('unbind #0')

     send_command('unbind f10')
     send_command('unbind !f10')

    send_command('lua u hovershot')

end


-- Set up all gear sets.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA['Eagle Eye Shot'] = {    
	
		head={ name="Arcadian Beret +3", augments={'Enhances "Recycle" effect',}},
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Arc. Braccae +3",
		feet="Malignance Boots",
		neck="Scout's Gorget +2",
		waist="Yemaya Belt",
		left_ear="Telos Earring",
		right_ear="Dedition Earring",
		right_ring="Ilabrat Ring",
		left_ring="Regal Ring",
		back={ name="Belenus's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','Rng.Acc.+10','"Store TP"+10','Phys. dmg. taken-10%',}},
	
		}

    sets.precast.JA['Bounty Shot'] = {
	
		head={ name="Herculean Helm", augments={'Weapon skill damage +2%','MND+8','"Treasure Hunter"+1',}}, 
		legs={ name="Herculean Trousers", augments={'"Cure" potency +3%','Weapon skill damage +2%','"Treasure Hunter"+2','Accuracy+1 Attack+1','Mag. Acc.+5 "Mag.Atk.Bns."+5',}},
		waist="Chaac Belt"
		
		}
		
    --sets.precast.JA['Camouflage'] = {body="Orion Jerkin +1"}
    --sets.precast.JA['Scavenge'] = {feet="Orion Socks"}
    sets.precast.JA['Shadowbind'] = {
	
		hands="Orion Bracers +3",
		ammo="",
		
		}
    sets.precast.JA['Sharpshot'] = {legs="Orion Braccae +3"}


    -- Fast cast sets for spells

    sets.precast.Waltz = {
	
        body="Passion Jacket",
        waist="Gishdubar Sash",
		
        }

    sets.precast.Waltz['Healing Waltz'] = {}

    sets.precast.FC = {
	
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body={ name="Adhemar Jacket +1", augments={'HP+105','"Fast Cast"+10','Magic dmg. taken -4',}},
		hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
		legs={ name="Taeon Tights", augments={'Mag. Evasion+16','"Fast Cast"+5','Phalanx +3',}},
		feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
		neck="Baetyl Pendant",
		left_ring="Weather. Ring +1",
		left_ear="Etiolation Earring",
		right_ear="Loquac. Earring",
		back={ name="Belenus's Cape", augments={'"Fast Cast"+10',}},
	
        }

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
	
        body="Passion Jacket",
        neck="Magoraga Beads",
		
        })


    -- (10% Snapshot, 5% Rapid from Merits)
	
    sets.precast.RA = {
	
		head={ name="Taeon Chapeau", augments={'"Snapshot"+5','"Snapshot"+5',}},
		body="Amini Caban +3",
		hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
		legs="Orion Braccae +2",
		feet="Meg. Jam. +2",
		neck="Scout's Gorget +1",
		ring1="Crepuscular Ring",
		waist="Impulse Belt",
		back={ name="Belenus's Cape", augments={'"Snapshot"+10',}},
		
      } 

    sets.precast.RA.Flurry1 = set_combine(sets.precast.RA, {
	
		head="Orion Beret +3",
		legs={ name="Adhemar Kecks +1", augments={'AGI+12','"Rapid Shot"+13','Enmity-6',}},
		
        }) 

    sets.precast.RA.Flurry2 = set_combine(sets.precast.RA.Flurry1, {
	
		feet={ name="Pursuer's Gaiters", augments={'Rng.Acc.+10','"Rapid Shot"+10','"Recycle"+15',}},
		
        }) 
		
    sets.precast.RA.Gastra = set_combine(sets.precast, {
	
		head="Orion Beret +3",
		
		})
		
    sets.precast.RA.Gastra.Flurry1 = set_combine(sets.precast.RA.Gastra, {
	
		legs={ name="Adhemar Kecks +1", augments={'AGI+12','"Rapid Shot"+13','Enmity-6',}},
		feet={ name="Pursuer's Gaiters", augments={'Rng.Acc.+10','"Rapid Shot"+10','"Recycle"+15',}},

		})
		
    sets.precast.RA.Gastra.Flurry2 = set_combine(sets.precast.RA.Gastra.Flurry1, {
	
		legs={ name="Pursuer's Pants", augments={'AGI+10','"Rapid Shot"+10','"Subtle Blow"+7',}},
		waist="Yemaya Belt",
		
		})


    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {
	
		head="Orion Beret +3",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Meg. Gloves +2",
		legs={ name="Arc. Braccae +3", augments={'Enhances "Eagle Eye Shot" effect',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Regal Ring",
		back={ name="Belenus's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%',}},
        
		}

    sets.precast.WS.Acc = set_combine(sets.precast.WS, {        })


    sets.precast.WS["Last Stand"] = set_combine(sets.precast.WS, { 
	
		head="Orion Beret +3",
		neck="Fotia Gorget", 
		ear1="Moonshade Earring",
		ear2="Ishvara Earring",
		body="Amini Caban +3",
		hands="Nyame Gauntlets",
		ear2="Amini Earring +2",
		ring1="Regal Ring",
		ring2="Dingir Ring",
		waist="Fotia Belt",
		legs="Nyame Flanchard",
		feet="Amini Bottillons +3",
		
		})

    sets.precast.WS['Last Stand'].Acc = set_combine(sets.precast.WS['Last Stand'], {

		neck="Scout's Gorget +1",
		body="Ikenga's Vest",
		hands="Malignance Gloves",
		legs="Ikenga's Trousers",
		ear2="Amini Earring +2",
		left_ring="Epaminondas's Ring",
		right_ring="Sroda Ring",
		
		
		})

    sets.precast.WS["Coronach"] = set_combine(sets.precast.WS['Last Stand'], { 

		ammo="Chrono Bullet",
		head="Orion Beret +3",
		--head="Arcadian Beret +3",
		body="Amini Caban +3",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		--legs="Adhemar Kecks +1",
		feet="Amini Bottillons +3",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Sherida Earring",
		right_ear="Ishvara Earring",
		left_ring="Epaminondas's Ring",
		--left_ring="Dingir Ring",
		right_ring="Regal Ring",
		back={ name="Belenus's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%',}},
        
		})

    sets.precast.WS["Coronach"].Acc = set_combine(sets.precast.WS['Coronach'], { 

		neck="Scout's Gorget +1",
		left_ear="Ishvara Earring",
		right_ear="Amini Earring +2",
		right_ring="Ephramad's Ring",
		
		})

    sets.precast.WS["Trueflight"] = {
	
		head={ name="Herculean Helm", augments={'Mag. Acc.+19 "Mag.Atk.Bns."+19','Weapon skill damage +4%','"Mag.Atk.Bns."+13',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Scout's Gorget +1",
		waist="Skrymir Cord +1",
		left_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		right_ear="Friomisi Earring",
		left_ring="Weather. Ring +1",
		right_ring="Dingir Ring",
		back={ name="Belenus's Cape", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','Weapon skill damage +10%',}},        
		
		}

sets.precast.WS["Trueflight"].Acc = set_combine(sets.precast.WS['Trueflight'], { head={ name="Nyame Helm", augments={'Path: B',}},        })

    sets.precast.WS["Wildfire"] = set_combine(sets.precast.WS["Trueflight"], {left_ear="Crematio Earring", left_ring="Epaminondas's Ring",})

    sets.precast.WS["Wildfire"].Acc = set_combine(sets.precast.WS["Wildfire"], {     })


    sets.precast.WS['Aeolian Edge']  = set_combine(sets.precast.WS["Trueflight"], {head={ name="Nyame Helm", augments={'Path: B',}}, left_ring="Epaminondas's Ring",})

    sets.precast.WS['Aeolian Edge'].Acc  = set_combine(sets.precast.WS['Aeolian Edge'], {    })

    sets.precast.WS['Hot Shot']  = set_combine(sets.precast.WS["Trueflight"], {head={ name="Nyame Helm", augments={'Path: B',}}, left_ring="Epaminondas's Ring",})

    sets.precast.WS['Hot Shot'].Acc  = set_combine(sets.precast.WS['Hot Shot'], {    })


    sets.precast.WS['Evisceration'] = {        }

    sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS['Evisceration'], {        })


	sets.precast.WS['Savage Blade'] = { 

		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Republican Platinum Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
		right_ear="Amini Earring +1",
		left_ring="Epaminondas's Ring",
		right_ring="Sroda Ring",
		back={ name="Belenus's Cape", augments={'Weapon skill damage +10%',}}, 

		}

	sets.precast.WS['Savage Blade'].Acc = set_combine(sets.precast.WS['Savage Blade'], {        })


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Fast recast for spells

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.SpellInterrupt = {
	
        legs="Carmine Cuisses +1", --20
        ring1="Evanescence Ring", --5
        waist="Rumination Sash", --10
		
        }

    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt

    -- Ranged sets

    sets.midcast.RA = {
	
		head={ name="Arcadian Beret +3", augments={'Enhances "Recycle" effect',}},
		body="Ikenga's Vest",
		hands="Amini Glovelettes +3",
		legs="Amini Bragues +3",
		--feet="Malignance Boots",
		feet="Ikenga's Clogs",
		neck="Scout's Gorget +1",
		waist="Yemaya Belt",
		left_ear="Telos Earring",
		right_ear="Dedition Earring",
		right_ring="Ilabrat Ring",
		left_ring="Regal Ring",
		back={ name="Belenus's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','Rng.Acc.+10','"Store TP"+10','Phys. dmg. taken-10%',}},
		
        }

    sets.midcast.RA.Acc = set_combine(sets.midcast.RA, {
	
        right_ring="Cacoethic Ring +1",
		right_ear="Enervating Earring",
		
        })

    sets.midcast.RA.HighAcc = set_combine(sets.midcast.RA.Acc, {
	
        })

    sets.midcast.RA.Critical = set_combine(sets.midcast.RA, {
	
		head="Mummu Bonnet +2",
		body="Nisroch Jerkin",
		hands="Mummu Wrists +2",
		legs="Mummu Kecks +2",
		feet="Mummu Gamash. +2",
		neck="Scout's Gorget +2",
		left_ring={ name="Cacoethic Ring +1", augments={'Path: A',}},
		right_ring="Mummu Ring",
		
        })

    sets.midcast.RA.STP = set_combine(sets.midcast.RA, {
	
        neck="Scout's Gorget +2",
        right_ear="Dedition Earring",
        left_ring="Chirich Ring +1",
		
        })

    sets.DoubleShot = {        } 

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.resting = {}

    sets.MoveSpeed = { legs = "Carmine Cuisses +1", }

    -- Idle sets
    sets.idle = {
	
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Loricate Torque +1",
		waist="Flume Belt", 
		left_ear="Etiolation Earring",
		right_ear="Eabani Earring",
		left_ring="Chirich Ring +1",
		right_ring="Defending Ring",
		back={ name="Belenus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Damage taken-5%',}},

        }

    sets.idle.DT = set_combine(sets.idle, {        })

    sets.idle.Town = set_combine(sets.idle, {
	
		waist="Windbuffet Belt +1",
		
        })


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.defense.PDT = sets.idle.DT
    sets.defense.MDT = sets.idle.DT

    sets.Kiting = {legs="Carmine Cuisses +1"}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    sets.engaged = {
	
		head="Malignance Chapeau",
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		hands="Malignance Gloves",
		legs="Amini Bragues +3",
		feet="Malignance Boots",
		neck="Iskur Gorget",
		waist="Windbuffet Belt +1",
		left_ear="Sherida Earring",
		right_ear="Suppanomimi",
		left_ring="Chirich Ring +1",
		right_ring="Epona's Ring",
		back={ name="Belenus's Cape", augments={'"Store TP"+10'}},

        }

    sets.engaged.LowAcc = set_combine(sets.engaged, {       })

    sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc, {        })

    sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc, {
        })

    sets.engaged.Multi = set_combine(sets.engaged, { 
	
		head="Adhemar Bonnet +1",
		body="Adhemar Jacket +1",
		hands="Adhemar Wrist. +1",
		legs={ name="Tatena. Haidate +1", augments={'Path: A',}},
		feet={ name="Tatena. Sune. +1", augments={'Path: A',}},
		neck="Iskur Gorget",
		waist="Windbuffet Belt +1",
		left_ear="Sherida Earring",
		right_ear="Suppanomimi",
		left_ring="Chirich Ring +1",
		right_ring="Epona's Ring",
		back={ name="Belenus's Cape", augments={'"Store TP"+10'}},
       
	   })

    -- * DNC Subjob DW Trait: +15%
    -- * NIN Subjob DW Trait: +25%

    -- No Magic Haste (74% DW to cap)
	
    sets.engaged.DW = {
	
		head="Malignance Chapeau",
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		hands="Malignance Gloves",
		legs="Amini Bragues +3",
		feet="Malignance Boots",
		neck="Iskur Gorget",
		waist="Windbuffet Belt +1",
		left_ear="Sherida Earring",
		right_ear="Suppanomimi",
		left_ring="Chirich Ring +1",
		right_ring="Epona's Ring",
		back={ name="Belenus's Cape", augments={'"Store TP"+10'}},

        } 

    sets.engaged.DW.LowAcc = set_combine(sets.engaged.DW, {        })

    sets.engaged.DW.MidAcc = set_combine(sets.engaged.DW.LowAcc, {        })

    sets.engaged.DW.HighAcc = set_combine(sets.engaged.DW.MidAcc, {        })

    sets.engaged.DW.Multi = set_combine(sets.engaged.DW, {        })

    -- 15% Magic Haste (67% DW to cap)
	
    sets.engaged.DW.LowHaste = {
	
		head="Malignance Chapeau",
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		hands="Malignance Gloves",
		legs="Amini Bragues +3",
		feet="Malignance Boots",
		neck="Iskur Gorget",
		waist="Windbuffet Belt +1",
		left_ear="Sherida Earring",
		right_ear="Suppanomimi",
		left_ring="Chirich Ring +1",
		right_ring="Epona's Ring",
		back={ name="Belenus's Cape", augments={'"Store TP"+10'}},

        }

    sets.engaged.DW.LowAcc.LowHaste = set_combine(sets.engaged.DW.LowHaste, {        })

    sets.engaged.DW.MidAcc.LowHaste = set_combine(sets.engaged.DW.LowAcc.LowHaste, {        })

    sets.engaged.DW.HighAcc.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, {        })

    sets.engaged.DW.Multi.LowHaste = set_combine(sets.engaged.DW.LowHaste, {        })

    -- 30% Magic Haste (56% DW to cap)
	
    sets.engaged.DW.MidHaste = { 
	
		head="Malignance Chapeau",
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		hands="Malignance Gloves",
		legs="Amini Bragues +3",
		feet="Malignance Boots",
		neck="Iskur Gorget",
		waist="Windbuffet Belt +1",
		left_ear="Sherida Earring",
		right_ear="Suppanomimi",
		left_ring="Chirich Ring +1",
		right_ring="Epona's Ring",
		back={ name="Belenus's Cape", augments={'"Store TP"+10'}},

     } -- 31%

    sets.engaged.DW.LowAcc.MidHaste = set_combine(sets.engaged.DW.MidHaste, {
        })

    sets.engaged.DW.MidAcc.MidHaste = set_combine(sets.engaged.DW.LowAcc.MidHaste, {      })

    sets.engaged.DW.HighAcc.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, {        })

    sets.engaged.DW.Multi.MidHaste = set_combine(sets.engaged.DW.MidHaste, {        })

    -- 35% Magic Haste (51% DW to cap)
	
    sets.engaged.DW.HighHaste = {
	
		head="Malignance Chapeau",
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		hands="Malignance Gloves",
		legs="Amini Bragues +3",
		feet="Malignance Boots",
		neck="Iskur Gorget",
		waist="Windbuffet Belt +1",
		left_ear="Sherida Earring",
		right_ear="Suppanomimi",
		left_ring="Chirich Ring +1",
		right_ring="Epona's Ring",
		back={ name="Belenus's Cape", augments={'"Store TP"+10'}},

      } -- 27%

    sets.engaged.DW.LowAcc.HighHaste = set_combine(sets.engaged.DW.HighHaste, {        })

    sets.engaged.DW.MidAcc.HighHaste = set_combine(sets.engaged.DW.LowAcc.HighHaste, {        })

    sets.engaged.DW.HighAcc.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, {        })

    sets.engaged.DW.Multi.HighHaste = set_combine(sets.engaged.DW.HighHaste, {        })

    -- 45% Magic Haste (36% DW to cap)
	
    sets.engaged.DW.MaxHaste = {
	
		head="Malignance Chapeau",
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		hands="Malignance Gloves",
		legs="Amini Bragues +3",
		feet="Malignance Boots",
		neck="Iskur Gorget",
		waist="Windbuffet Belt +1",
		left_ear="Sherida Earring",
		right_ear="Suppanomimi",
		left_ring="Chirich Ring +1",
		right_ring="Epona's Ring",
		back={ name="Belenus's Cape", augments={'"Store TP"+10'}},

        } -- 11%

    sets.engaged.DW.LowAcc.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {        })
    sets.engaged.DW.MidAcc.MaxHaste = set_combine(sets.engaged.DW.LowAcc.MaxHaste, {        })
    sets.engaged.DW.HighAcc.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, {        })
    sets.engaged.DW.Multi.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {        })
    sets.engaged.DW.MaxHastePlus = set_combine(sets.engaged.DW.MaxHaste, { })
    sets.engaged.DW.LowAcc.MaxHastePlus = set_combine(sets.engaged.DW.LowAcc.MaxHaste, {})
    sets.engaged.DW.MidAcc.MaxHastePlus = set_combine(sets.engaged.DW.MidAcc.MaxHaste, {})
    sets.engaged.DW.HighAcc.MaxHastePlus = set_combine(sets.engaged.DW.HighAcc.MaxHaste, {})
    sets.engaged.DW.Multi.MaxHastePlus = set_combine(sets.engaged.DW.Multi.MaxHaste, {})


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {
	
        neck="Loricate Torque +1", --6/6
        ring1="Defending Ring", --10/10
		
        }

    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
    sets.engaged.LowAcc.DT = set_combine(sets.engaged.LowAcc, sets.engaged.Hybrid)
    sets.engaged.MidAcc.DT = set_combine(sets.engaged.MidAcc, sets.engaged.Hybrid)
    sets.engaged.HighAcc.DT = set_combine(sets.engaged.HighAcc, sets.engaged.Hybrid)
    sets.engaged.Multi.DT = set_combine(sets.engaged.Multi, sets.engaged.Hybrid)

    sets.engaged.DW.DT = set_combine(sets.engaged.DW, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT = set_combine(sets.engaged.DW.LowAcc, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT = set_combine(sets.engaged.DW.MidAcc, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT = set_combine(sets.engaged.DW.HighAcc, sets.engaged.Hybrid)
    sets.engaged.DW.Multi.DT = set_combine(sets.engaged.DW.Multi, sets.engaged.Hybrid)

    sets.engaged.DW.DT.LowHaste = set_combine(sets.engaged.DW.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.LowHaste = set_combine(sets.engaged.DW.LowAcc.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.LowHaste = set_combine(sets.engaged.DW.HighAcc.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.Multi.DT.LowHaste = set_combine(sets.engaged.DW.Multi.LowHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.MidHaste = set_combine(sets.engaged.DW.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.MidHaste = set_combine(sets.engaged.DW.LowAcc.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.MidHaste = set_combine(sets.engaged.DW.HighAcc.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.Multi.DT.MidHaste = set_combine(sets.engaged.DW.Multi.MidHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.HighHaste = set_combine(sets.engaged.DW.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.HighHaste = set_combine(sets.engaged.DW.LowAcc.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.HighHaste = set_combine(sets.engaged.DW.HighAcc.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.Multi.DT.HighHaste = set_combine(sets.engaged.DW.HighHaste.Multi, sets.engaged.Hybrid)

    sets.engaged.DW.DT.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.MaxHaste = set_combine(sets.engaged.DW.LowAcc.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.MaxHaste = set_combine(sets.engaged.DW.HighAcc.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.Multi.DT.MaxHaste = set_combine(sets.engaged.DW.Multi.MaxHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.MaxHastePlus = set_combine(sets.engaged.DW.MaxHastePlus, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.MaxHastePlus = set_combine(sets.engaged.DW.LowAcc.MaxHastePlus, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.MaxHastePlus = set_combine(sets.engaged.DW.MidAcc.MaxHastePlus, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.MaxHastePlus = set_combine(sets.engaged.DW.HighAcc.MaxHastePlus, sets.engaged.Hybrid)
    sets.engaged.DW.Multi.DT.MaxHastePlus = set_combine(sets.engaged.DW.Multi.MaxHastePlus, sets.engaged.Hybrid)


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.buff.Barrage = {hands="Orion Bracers +2"}
    sets.buff['Velocity Shot'] = set_combine(sets.precast.RA, {body="Amini Caban +3"})
    sets.buff.Camouflage = {}

    sets.buff.Doom = {
        waist="Gishdubar Sash", --10
        }

    sets.FullTP = {Left_ear="Crematio Earring"}
    sets.FullTPPhys = {Left_ear="Sherida Earring"}
    sets.Obi = {waist="Hachirin-no-Obi"}
    --sets.Reive = {neck="Ygnas's Resolve +1"}
    sets.CP = {back="Mecisto. Mantle"}

    sets.Annihilator = {ranged="Annihilator"}
    sets.Fomalhaut = {ranged="Fomalhaut", ammo="Chrono Bullet",}
    sets.Gastraphetes = {ranged="Gastraphetes", ammo="Quelling Bolt",}

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
    -- Check that proper ammo is available if we're using ranged attacks or similar.
    if spell.action_type == 'Ranged Attack' or (spell.type == 'WeaponSkill' and (spell.skill == 'Marksmanship' or spell.skill == 'Archery')) then
        check_ammo(spell, action, spellMap, eventArgs)
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
        if spell.action_type == 'Ranged Attack' and state.WeaponSet.current == "Gastraphetes" then
            if flurry == 2 then
                equip(sets.precast.RA.Gastra.Flurry2)
            elseif flurry == 1 then
                equip(sets.precast.RA.Gastra.Flurry1)
            else
                equip(sets.precast.RA.Gastra)
            end        
        elseif spell.action_type == 'Ranged Attack' then
            if flurry == 2 then
                equip(sets.precast.RA.Flurry2)
            elseif flurry == 1 then
                equip(sets.precast.RA.Flurry1)
            end
        end
	end
	
    if spell.type == 'WeaponSkill' then
    -- Replace TP-bonus gear if not needed.
        if (spell.english == 'Trueflight' or spell.english == 'Aeolian Edge') and player.tp > 2900 then
            equip(sets.FullTP)
	   elseif (spell.english == 'Last Stand' or spell.english == 'Savage Blade') and player.tp > 2900 then
            equip(sets.FullTPPhys)
        end
        -- Equip orpheus sash for defined WS.
    if elemental_ws:contains(spell.name) then
		if spell.english == 'Trueflight' then
			-- Matching double weather (w/o day conflict).
			if spell.element == world.weather_element and get_weather_intensity() == 2 then
               equip({waist="Korin Obi"})
			-- Target distance under 1.7 yalms.
			elseif spell.target.distance < (1.7 + spell.target.model_size) then
				equip({waist="Orpheus's Sash"})
			-- Matching day and weather.
			elseif spell.element == world.day_element and spell.element == world.weather_element then
				equip({waist="Korin Obi"})
			-- Target distance under 8 yalms.
			elseif spell.target.distance < (8 + spell.target.model_size) then
				equip({waist="Orpheus's Sash"})
			-- Match day or weather.
			elseif spell.element == world.day_element or spell.element == world.weather_element then
				equip({waist="Korin Obi"})
			-- Target distance under 14 yalms.
			elseif spell.target.distance < (14 + spell.target.model_size) then
				equip({waist="Orpheus's Sash"})
			end
		elseif spell.english ~= 'Trueflight' then
		-- Target distance under 14 yalms.
			if spell.target.distance < (14 + spell.target.model_size) then
				equip({waist="Orpheus's Sash"})
			end
        end
    end
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.action_type == 'Ranged Attack' then
        if buffactive['Double Shot'] then
            equip(sets.DoubleShot)
        end
        if state.Buff.Barrage then
            equip(sets.buff.Barrage)
        end
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


    if buff == "doom" then
        if gain then
            --equip(sets.buff.Doom)
            send_command('@input /p Doomed.')
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

function customize_idle_set(idleSet)
    if state.CP.current == 'on' then
        equip(sets.CP)
        disable('back')
    else
        enable('back')
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

--determine moving and equip movespeed
mov = {counter=0}
if player and player.index and windower.ffxi.get_mob_by_index(player.index) then
    mov.x = windower.ffxi.get_mob_by_index(player.index).x
    mov.y = windower.ffxi.get_mob_by_index(player.index).y
    mov.z = windower.ffxi.get_mob_by_index(player.index).z
end

moving = false
windower.raw_register_event('prerender',function()
    mov.counter = mov.counter + 1;
    if mov.counter>15 and not midaction() then
        local pl = windower.ffxi.get_mob_by_index(player.index)
        if pl and pl.x and mov.x then
            dist = math.sqrt( (pl.x-mov.x)^2 + (pl.y-mov.y)^2 + (pl.z-mov.z)^2 )
            if dist > 1 and not moving and player.status=='Idle' and state.MoveSpeed.value then
                state.Moving.value = true
				send_command('gs c update')
                send_command('gs equip sets.MoveSpeed')
			    --if world.area:contains("Adoulin") then
			--send_command('gs equip sets.Adoulin')
				--end
                moving = true
				
            elseif dist < 1 and moving and state.MoveSpeed.value then
                state.Moving.value = false
                send_command('gs c update')
                moving = false
            end
        end
        if pl and pl.x then
            mov.x = pl.x
            mov.y = pl.y
            mov.z = pl.z
        end
        mov.counter = 0
    end
end)




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

-- Check for proper ammo when shooting or weaponskilling
function check_ammo(spell, action, spellMap, eventArgs)
    if spell.action_type == 'Ranged Attack' then
        if player.equipment.ammo == 'empty' or player.equipment.ammo ~= DefaultAmmo[player.equipment.range] then
            if DefaultAmmo[player.equipment.range] then
                if player.inventory[DefaultAmmo[player.equipment.range]] then
                    --add_to_chat(3,"Using Default Ammo")
                    equip({ammo=DefaultAmmo[player.equipment.range]})
                else
                    add_to_chat(3,"Default ammo unavailable.  Leaving empty.")
                end
            else
                add_to_chat(3,"Unable to determine default ammo for current weapon.  Leaving empty.")
            end
        end
    elseif spell.type == 'WeaponSkill' then
        if spell.element == 'None' then
        --physical weaponskills
            if state.WeaponskillMode.value == 'Acc' then
                if player.inventory[AccAmmo[player.equipment.range]] then
                    equip({ammo=AccAmmo[player.equipment.range]})
                else
                    add_to_chat(3,"Acc ammo unavailable.  Using default ammo.")
                    equip({ammo=DefaultAmmo[player.equipment.range]})
                end
            else
                if player.inventory[WSAmmo[player.equipment.range]] then
                    equip({ammo=WSAmmo[player.equipment.range]})
                else
                    add_to_chat(3,"WS ammo unavailable.  Using default ammo.")
                    equip({ammo=DefaultAmmo[player.equipment.range]})
                end
            end
        else
            -- magical weaponskills
            if player.inventory[MagicAmmo[player.equipment.range]] then
                equip({ammo=MagicAmmo[player.equipment.range]})
            else
                add_to_chat(3,"Magic ammo unavailable.  Using default ammo.")
                equip({ammo=DefaultAmmo[player.equipment.range]})
            end
        end
    end
    if player.equipment.ammo ~= 'empty' and player.inventory[player.equipment.ammo].count < 15 then
        add_to_chat(39,"*** Ammo '"..player.inventory[player.equipment.ammo].shortname.."' running low! *** ("..player.inventory[player.equipment.ammo].count..")")
    end
end

function update_offense_mode()
    if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
        state.CombatForm:set('DW')
    else
        state.CombatForm:reset()
    end
end

--disables swaps for warp and tele rings
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
        if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
            send_command('gi ugs true')
        end

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
    set_macro_page(1, 21)
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end
