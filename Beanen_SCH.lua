
-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--              Addendum Commands:
--              Shorthand versions for each strategem type that uses the version appropriate for
--              the current Arts.
--                                          Light Arts                    Dark Arts
--                                          ----------                  ---------
--                gs c scholar light          Light Arts/Addendum
--              gs c scholar dark                                       Dark Arts/Addendum
--              gs c scholar cost           Penury                      Parsimony
--              gs c scholar speed          Celerity                    Alacrity
--              gs c scholar aoe            Accession                   Manifestation
--              gs c scholar power          Rapture                     Ebullience
--              gs c scholar duration       Perpetuance
--              gs c scholar accuracy       Altruism                    Focalization
--              gs c scholar enmity         Tranquility                 Equanimity
--              gs c scholar skillchain                                 Immanence
--              gs c scholar addendum       Addendum: White             Addendum: Black


-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
    include('organizer-lib')
    --include('SCH_Lib.lua')  
    organizer_items = {
        echos="Echo Drops",
        remedy="Remedy",
        left_ring="Dim. Ring (Dem)",
        right_ring="Warp Ring",
        ring="Dim. Ring (Dem)",
    }
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    info.addendumNukes = S{"Stone IV", "Water IV", "Aero IV", "Fire IV", "Blizzard IV", "Thunder IV",
        "Stone V", "Water V", "Aero V", "Fire V", "Blizzard V", "Thunder V"}

    state.Buff['Sublimation: Activated'] = buffactive['Sublimation: Activated'] or false
    state.HelixMode = M{['description']='Helix Mode', 'Potency', 'Duration'}
    state.RegenMode = M{['description']='Regen Mode', 'Duration', 'Potency'}
    -- state.CP = M(false, "Capacity Points Mode")

    update_active_strategems()

    lockstyleset = 93

end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'Resistant', 'Magic Burst')
    state.RegenMode:options('Potency','Duration')
    state.IdleMode:options('Normal', 'DT')
    
    state.WeaponLock = M(false, 'Weapon Lock')
    state.MagicBurst = M(false, 'Magic Burst')
    state.StormSurge = M(false, 'Stormsurge')

    state.Buff['Sublimation: Activated'] = buffactive['Sublimation: Activated'] or false
    state.HelixMode = M{['description']='Helix Mode', 'Potency', 'Duration'}
    state.RegenMode = M{['description']='Regen Mode', 'Potency', 'Duration'}


    send_command('bind ^` input /ma Stun <t>')
    send_command('bind !o input /equip ring2 "Warp Ring"; /echo Warping; wait 11; input /item "Warp Ring" <me>;')
    send_command('bind !m input /map')
    send_command('bind !f11 gs c cycle RegenMode')
    send_command('bind capslock input //sat youcommand Merylle "Dia II"')
    send_command('bind ^z input //send Merylle /ma "Curaga II" <me>')
    send_command('bind !z input //send Merylle /ma "Cure IV" <me>')
    send_command('bind ^x input //send @all /mount Red Crab')
    send_command('bind !x input //send @all /dismount Red Crab')
    send_command('bind ~z input //send Merylle /ma "Cure IV" <Beanen>')
    send_command('bind ~z input //send Merylle /ma "Cure IV" <Beanen>')
    send_command('bind ~1 input //send Merylle /ma "Indi-Frailty" <me>')
    send_command('bind ~2 input //sat youcommand Merylle "Geo-Malaise"')
    send_command('bind ~3 input //send Merylle /ma "Indi-Fury" <me>')
    send_command('bind ~4 input //sat youcommand Merylle "Geo-Frailty"')
    send_command('bind ~5 input //send Merylle /ma "Indi-Acumen" <me>')
    send_command('bind ~6 input //send Merylle /ma "Indi-Haste" <me>')
    send_command('bind ~7 input //send Merylle /ja "Full Circle" <me>')
    send_command('bind ~8 input //send Merylle /ja "Ecliptic Attrition" <me>')
    send_command('bind ~9 input //send Merylle /ja "Blaze of Glory" <me>')
    send_command('bind ~0 input //send Merylle /ja "Dematerialize" <me>')
    
    

    select_default_macro_book()
    set_lockstyle()
end

function user_unload()
    send_command('unbind ^`')
    send_command('unbind m')
    send_command('unbind ^F8')
    send_command('unbind !F11')
end
   



-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA['Tabula Rasa'] = {legs={ name="Peda. Pants +3", augments={'Enhances "Tabula Rasa" effect',}}}
    sets.precast.JA['Enlightenment'] = {body={ name="Peda. Gown +3", augments={'Enhances "Enlightenment" effect',}}}
    sets.precast.JA['Sublimation'] = {
        main={ name="Musa", augments={'Path: C',}},
        sub="Enki Strap",
        head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        neck="Unmoving Collar +1",
        ear1="Eabani Earring",
        left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        ring1="Gelatinous Ring +1",
        ring2="Eihwaz Ring",
        back="Moonlight Cape",
        waist="Plat. Mog. Belt",
        }

    -- Fast cast sets for spells
    sets.precast.FC = {
    --    /RDM --15
    {main={ name="Musa", augments={'Path: C',}},
    sub="Enki Strap",
    ammo="Sapience Orb",
    head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
    body="Pinga Tunic",
    hands={ name="Gende. Gages +1", augments={'Phys. dmg. taken -4%','Magic dmg. taken -4%','"Cure" spellcasting time -5%',}},
    legs="Pinga Pants",
    feet="Regal Pumps +1",
    neck="Baetyl Pendant",
    waist="Witful Belt",
    left_ear="Malignance Earring",
    right_ear="Loquacious Earring",
    left_ring="Kishar Ring",
    right_ring="Weather. Ring +1",
    back={ name="Lugh's Cape", augments={'MND+20','Eva.+20 /Mag. Eva.+20','MND+10','"Fast Cast"+10','Occ. inc. resist. to stat. ailments+10',}}}
        }

    sets.precast.FC.Grimoire = {main={ name="Musa", augments={'Path: C',}},
    sub="Enki Strap",
    ammo="Sapience Orb",
    head={ name="Peda. M.Board +3", augments={'Enh. "Altruism" and "Focalization"',}},
    body="Pinga Tunic",
    hands={ name="Gende. Gages +1", augments={'Phys. dmg. taken -4%','Magic dmg. taken -4%','"Cure" spellcasting time -5%',}},
    legs="Pinga Pants",
    feet="Acad. Loafers +3",
    neck="Baetyl Pendant",
    waist="Witful Belt",
    left_ear="Malignance Earring",
    right_ear="Loquacious Earring",
    left_ring="Kishar Ring",
    right_ring="Weather. Ring +1",
    back={ name="Lugh's Cape", augments={'MND+20','Eva.+20 /Mag. Eva.+20','MND+10','"Fast Cast"+10','Occ. inc. resist. to stat. ailments+10',}}}
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})
    sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {})

    sets.precast.FC.Cure = set_combine(sets.precast.FC, {hands={ name="Gende. Gages +1", augments={'Phys. dmg. taken -4%','Magic dmg. taken -4%','"Cure" spellcasting time -5%',}},
        })

    sets.precast.FC.Curaga = sets.precast.FC.Cure
    sets.precast.FC.Impact = set_combine(sets.precast.FC, {head=empty, body="Twilight Cloak",})
    sets.precast.FC.Dispelga = set_combine(sets.precast.FC, {main="Daybreak", sub="Ammurapi Shield"})
    sets.precast.Storm = set_combine(sets.precast.FC, {ring2={name="Stikini Ring +1",}})


    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {
        body="Agwu's Robe",
        neck="Fotia Gorget",
        body="Arbatel Gown +3",
        ear1="Moonshade Earring",
        ear2="Telos Earring",
        ring1="Cornelia's Ring",
        waist="Fotia Belt",}

    sets.precast.WS['Omniscience'] = set_combine(sets.precast.WS, {
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head="Pixie Hairpin +1",
        body={ name="Peda. Gown +3", augments={'Enhances "Enlightenment" effect',}},
        legs={ name="Peda. Pants +3", augments={'Enhances "Tabula Rasa" effect',}},
        ear1="Malignance Earring",
        ear2="Regal Earring",
        ring2="Archon Ring",
        waist="Sacro Cord",
        })


    sets.precast.WS['Myrkr'] = {
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head="Pixie Hairpin +1",
        feet="Kaykaus Boots +1",
        left_ear="Lugalbanda Earring",
        right_ear="Eabani Earring",
        ring2="Metamor. Ring +1",
        } -- Max MP


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.Cure = {
        main="Daybreak", --30
        sub="Sors Shield", --3/(-5)
        ammo="Pemphredo Tathlum",
        head={ name="Kaykaus Mitra +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
        body={ name="Kaykaus Bliaut +1", augments={'MP+80','"Cure" potency +6%','"Conserve MP"+7',}},
        hands={ name="Peda. Bracers +3", augments={'Enh. "Tranquility" and "Equanimity"',}},
        legs={ name="Kaykaus Tights +1", augments={'MP+80','Spell interruption rate down +12%','"Cure" spellcasting time -7%',}},
        feet={ name="Kaykaus Boots +1", augments={'Mag. Acc.+20','"Cure" potency +6%','"Fast Cast"+4',}},
        neck="Incanter's Torque",
        waist="Luminary Sash",
        left_ear="Mendi. Earring",
        right_ear="Regal Earring",
        left_ring="Naji's Loop",
        right_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
        back={ name="Lugh's Cape", augments={'MND+20','Eva.+20 /Mag. Eva.+20','MND+10','"Fast Cast"+10','Occ. inc. resist. to stat. ailments+10',}}}

    sets.midcast.CureWeather = set_combine(sets.midcast.Cure, {
        main="Chatoyant Staff",
        sub="Enki Strap",
        waist="Hachirin-no-Obi",
        back="Twilight Cape",
        })

    sets.midcast.Curaga = set_combine(sets.midcast.Cure, {
        neck="Aife's Medal",
        left_ring={name="Stikini Ring +1", bag="wardrobe2"},
        right_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
        waist="Luminary Sash",
        left_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
        })

    sets.midcast.StatusRemoval = {
        main={ name="Gada", augments={'Enh. Mag. eff. dur. +5','Mag. Acc.+8',}},
        sub="Ammurapi Shield",
        ammo="Pemphredo Tathlum",
        head={ name="Vanya Hood", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
        body={ name="Peda. Gown +3", augments={'Enhances "Enlightenment" effect',}},
        hands={ name="Peda. Bracers +3", augments={'Enh. "Tranquility" and "Equanimity"',}},
        legs="Acad. Pants +3",
        feet={ name="Vanya Clogs", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
        neck="Debilis Medallion",
        waist="Bishop's Sash",
        left_ear="Beatific Earring",
        right_ear="Meili Earring",
        left_ring={name="Stikini Ring +1", bag="wardrobe2"},
        right_ring={name="Stikini Ring +1", bag="wardrobe3"},
        back={ name="Alaunus's Cape", augments={'MND+20','Eva.+20 /Mag. Eva.+20','MND+10','"Fast Cast"+10','Phys. dmg. taken-10%',}}
        }

    sets.CursnaRecieved = {waist="Gishdubar Sash"}

    sets.midcast.Cursna = set_combine(sets.midcast.StatusRemoval, {
        main={ name="Gada", augments={'Enh. Mag. eff. dur. +5','Mag. Acc.+8',}},
        sub="Ammurapi Shield",
        ammo="Pemphredo Tathlum",
        head={ name="Vanya Hood", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
        body={ name="Peda. Gown +3", augments={'Enhances "Enlightenment" effect',}},
        hands={ name="Peda. Bracers +3", augments={'Enh. "Tranquility" and "Equanimity"',}},
        legs="Acad. Pants +3",
        feet={ name="Vanya Clogs", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
        neck="Debilis Medallion",
        waist="Bishop's Sash",
        left_ear="Beatific Earring",
        right_ear="Meili Earring",
        left_ring="Haoma's Ring",
        right_ring="Menelaus's Ring",
        back={ name="Alaunus's Cape", augments={'MND+20','Eva.+20 /Mag. Eva.+20','MND+10','"Fast Cast"+10','Phys. dmg. taken-10%',}}
        })
        
    sets.midcast.Regen = {main={ name="Musa", augments={'Path: C',}},
        sub="Enki Strap",
        ammo="Pemphredo Tathlum",
        head= "Arbatel Bonnet +3",
        body={ name="Telchine Chas.", augments={'Song spellcasting time -7%','Enh. Mag. eff. dur. +10',}},
        hands={ name="Telchine Gloves", augments={'Enh. Mag. eff. dur. +10',}},
        legs={ name="Telchine Braconi", augments={'Song spellcasting time -6%','Enh. Mag. eff. dur. +10',}},
        feet={ name="Telchine Pigaches", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
        neck="Incanter's Torque",
        waist="Embla Sash",
        back={ name="Bookworm's Cape", augments={'INT+3','MND+1','Helix eff. dur. +20','"Regen" potency+9',}},
        left_ear="Mimir Earring",
        right_ear="Andoaa Earring",
        left_ring={name="Stikini Ring +1", bag="wardrobe2"},
        right_ring={name="Stikini Ring +1", bag="wardrobe3"},}

    sets.midcast['Enhancing Magic'] = {main={ name="Musa", augments={'Path: C',}},
        sub="Enki Strap",
        ammo="Pemphredo Tathlum",
        head={ name="Telchine Cap", augments={'Enh. Mag. eff. dur. +10',}},
        body={ name="Peda. Gown +3", augments={'Enhances "Enlightenment" effect',}},
        hands={ name="Telchine Gloves", augments={'Enh. Mag. eff. dur. +10',}},
        legs={ name="Telchine Braconi", augments={'Song spellcasting time -6%','Enh. Mag. eff. dur. +10',}},
        feet={ name="Telchine Pigaches", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
        neck="Incanter's Torque",
        waist="Embla Sash",
        left_ear="Mimir Earring",
        right_ear="Andoaa Earring",
        left_ring={name="Stikini Ring +1", bag="wardrobe2"},
        right_ring={name="Stikini Ring +1", bag="wardrobe3"},
        back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Occ. inc. resist. to stat. ailments+10',}}}

    sets.midcast['Embrava'] = {main={ name="Musa", augments={'Path: C',}},
        sub="Enki Strap",
        ammo="Pemphredo Tathlum",
        head={ name="Telchine Cap", augments={'Enh. Mag. eff. dur. +10',}},
        body={ name="Peda. Gown +3", augments={'Enhances "Enlightenment" effect',}},
        hands={ name="Telchine Gloves", augments={'Enh. Mag. eff. dur. +10',}},
        legs={ name="Telchine Braconi", augments={'Song spellcasting time -6%','Enh. Mag. eff. dur. +10',}},
        feet={ name="Telchine Pigaches", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
        neck="Incanter's Torque",
        waist="Embla Sash",
        left_ear="Mimir Earring",
        right_ear="Andoaa Earring",
        left_ring={name="Stikini Ring +1", bag="wardrobe2"},
        right_ring={name="Stikini Ring +1", bag="wardrobe3"},
        back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Occ. inc. resist. to stat. ailments+10',}}}

    sets.midcast.EnhancingDuration = {main={ name="Musa", augments={'Path: C',}},
        sub="Enki Strap",
        ammo="Pemphredo Tathlum",
        head={ name="Telchine Cap", augments={'Enh. Mag. eff. dur. +10',}},
        body={ name="Peda. Gown +3", augments={'Enhances "Enlightenment" effect',}},
        hands={ name="Telchine Gloves", augments={'Enh. Mag. eff. dur. +10',}},
        legs={ name="Telchine Braconi", augments={'Song spellcasting time -6%','Enh. Mag. eff. dur. +10',}},
        feet={ name="Telchine Pigaches", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
        neck="Incanter's Torque",
        waist="Embla Sash",
        left_ear="Mimir Earring",
        right_ear="Andoaa Earring",
        left_ring={name="Stikini Ring +1", bag="wardrobe2"},
        right_ring={name="Stikini Ring +1", bag="wardrobe3"},
        back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Occ. inc. resist. to stat. ailments+10',}}}

    

    sets.midcast.Regen.Duration = {
        {main={ name="Musa", augments={'Path: C',}},
        sub="Enki Strap",
        ammo="Pemphredo Tathlum",
        head="Arbatel Bonnet +3",
        body={ name="Telchine Chas.", augments={'Song spellcasting time -7%','Enh. Mag. eff. dur. +10',}},
        hands={ name="Telchine Gloves", augments={'Enh. Mag. eff. dur. +10',}},
        legs={ name="Telchine Braconi", augments={'Song spellcasting time -6%','Enh. Mag. eff. dur. +10',}},
        feet={ name="Telchine Pigaches", augments={'"Fast Cast"+5','Enh. Mag. eff. dur. +10',}},
        neck="Incanter's Torque",
        waist="Embla Sash",
        back={ name="Bookworm's Cape", augments={'INT+3','MND+1','Helix eff. dur. +20','"Regen" potency+9',}},
        left_ear="Mimir Earring",
        right_ear="Andoaa Earring",
        left_ring={name="Stikini Ring +1", bag="wardrobe2"},
        right_ring={name="Stikini Ring +1", bag="wardrobe3"},}
        }

    sets.midcast.Haste = sets.midcast.EnhancingDuration

    sets.midcast.Flurry = sets.midcast.EnhancingDuration

    sets.midcast.Refresh = set_combine(sets.midcast.EnhancingDuration, {
        })

    sets.midcast.Stoneskin = set_combine(sets.midcast.EnhancingDuration, {
        neck="Nodens Gorget",
        waist="Siegel Sash",
        })

    sets.midcast.Aquaveil = set_combine(sets.midcast.EnhancingDuration, {
        })

    sets.midcast.Storm = sets.midcast.EnhancingDuration

    sets.midcast.Stormsurge = set_combine(sets.midcast.Storm, {feet={ name="Peda. Loafers +3", augments={'Enhances "Stormsurge" effect',}}})

    sets.midcast.Protect = set_combine(sets.midcast.EnhancingDuration, {})
    sets.midcast.Protectra = sets.midcast.Protect
    sets.midcast.Shell = sets.midcast.Protect
    sets.midcast.Shellra = sets.midcast.Shell

    -- Custom spell classes
    sets.midcast.MndEnfeebles = {main={ name="Bunzi's Rod", augments={'Path: A',}},
        sub="Ammurapi Shield",
        ammo="Pemphredo Tathlum",
        head="Acad. Mortar. +3",
        body="Acad. Gown +2",
        hands="Acad. Bracers +2",
        legs="Acad. Pants +3",
        feet="Acad. Loafers +3",
        neck={ name="Argute Stole +2", augments={'Path: A',}},
        waist="Luminary Sash",
        left_ear="Malignance Earring",
        right_ear="Regal Earring",
        left_ring={name="Stikini Ring +1", bag="wardrobe2"},
        right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Occ. inc. resist. to stat. ailments+10',}}}
        

    sets.midcast.IntEnfeebles = set_combine(sets.midcast.MndEnfeebles, {main={ name="Bunzi's Rod", augments={'Path: A',}},
        sub="Ammurapi Shield",
        ammo="Pemphredo Tathlum",
        head="Acad. Mortar. +3",
        body="Acad. Gown +2",
        hands="Acad. Bracers +2",
        legs="Acad. Pants +3",
        feet="Acad. Loafers +3",
        neck={ name="Argute Stole +2", augments={'Path: A',}},
        waist="Sacro Cord",
        left_ear="Malignance Earring",
        right_ear="Regal Earring",
        left_ring={name="Stikini Ring +1", bag="wardrobe2"},
        right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Occ. inc. resist. to stat. ailments+10',}}}
        )

    sets.midcast.ElementalEnfeeble = sets.midcast.Enfeebles
    sets.midcast.Dispelga = set_combine(sets.midcast.IntEnfeebles, {main="Daybreak", sub="Ammurapi Shield",})

    sets.midcast['Dark Magic'] = {
        main={ name="Bunzi's Rod", augments={'Path: A',}},
        sub="Ammurapi Shield",
        ammo="Pemphredo Tathlum",
        head={ name="Peda. M.Board +3", augments={'Enh. "Altruism" and "Focalization"',}},
        body="Agwu's Robe",
        hands={ name="Agwu's Gages", augments={'Path: A',}},
        legs="Agwu's Slops",
        feet="Arbatel Loafers +3",
        neck={ name="Argute Stole +2", augments={'Path: A',}},
        waist="Hachirin-no-Obi",
        left_ear="Malignance Earring",
        right_ear="Regal Earring",
        left_ring={name="Stikini Ring +1", bag="wardrobe2"},
        right_ring={name="Stikini Ring +1", bag="wardrobe3"},
        back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Occ. inc. resist. to stat. ailments+10',}}
        }

    sets.midcast.Kaustra = {
        main={ name="Bunzi's Rod", augments={'Path: A',}},
        sub="Ammurapi Shield",
        ammo="Pemphredo Tathlum",
        head="Pixie Hairpin +1",
        body="Agwu's Robe",
        hands={ name="Agwu's Gages", augments={'Path: A',}},
        legs="Agwu's Slops",
        feet="Arbatel Loafers +3",
        neck={ name="Argute Stole +2", augments={'Path: A',}},
        waist="Hachirin-no-Obi",
        left_ear="Malignance Earring",
        right_ear="Regal Earring",
        left_ring="Archon Ring",
        right_ring="Shiva Ring +1",
        back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Occ. inc. resist. to stat. ailments+10',}}
        }

    sets.midcast["Kaustra"] = {
        main={ name="Bunzi's Rod", augments={'Path: A',}},
        sub="Ammurapi Shield",
        ammo="Pemphredo Tathlum",
        head="Pixie Hairpin +1",
        body="Agwu's Robe",
        hands="Agwu's Gages",
        legs="Agwu's Slops",
        feet="Arbatel Loafers +3",
        neck={ name="Argute Stole +2", augments={'Path: A',}},
        waist="Hachirin-no-Obi",
        left_ear="Malignance Earring",
        right_ear="Regal Earring",
        left_ring="Archon Ring",
        right_ring="Shiva Ring +1",
        back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Occ. inc. resist. to stat. ailments+10',}}
        }
    

    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {
        head="Pixie Hairpin +1",
        ear1="Hirudinea Earring",
        ring1="Evanescence Ring",
        ring2="Archon Ring",
        legs={ name="Peda. Pants +3", augments={'Enhances "Tabula Rasa" effect',}},
        neck="Erra Pendant",
        waist="Fucho-no-obi",
        })

    sets.midcast.Aspir = sets.midcast.Drain

    sets.midcast.Stun = set_combine(sets.midcast['Dark Magic'], {
        })

    -- Elemental Magic
    sets.midcast['Elemental Magic'] = {
        main={ name="Bunzi's Rod", augments={'Path: A',}},
        sub="Ammurapi Shield",
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head={ name="Agwu's Cap", augments={'Path: A',}},
        body="Arbatel Gown +3",
        hands={ name="Agwu's Gages", augments={'Path: A',}},
        legs="Agwu's Slops",
        feet="Arbatel Loafers +3",
        neck={ name="Argute Stole +2", augments={'Path: A',}},
        waist="Hachirin-no-Obi",
        left_ear="Malignance Earring",
        right_ear="Regal Earring",
        left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        right_ring="Mujin Band",
        back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Occ. inc. resist. to stat. ailments+10',}}
        }

    sets.midcast['Elemental Magic'].magic_burst = set_combine(sets.midcast['Elemental Magic'], {ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        
        right_ear="Regal Earring",
        right_ring="Mujin Band",
        })

    sets.midcast['Elemental Magic'].Resistant = set_combine(sets.midcast['Elemental Magic'], {
        ammo="Pemphredo Tathlum",
        waist="Sacro Cord",
        left_ring={name="Stikini Ring +1", bag="wardrobe2"},
        })

    sets.midcast.Impact = set_combine(sets.midcast['Elemental Magic'], {
        head=empty,
        body="Twilight Cloak",
        right_ring="Archon Ring",
        })

    sets.midcast.Helix = {main={ name="Bunzi's Rod", augments={'Path: A',}},
        sub="Culminus",
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head={ name="Agwu's Cap", augments={'Path: A',}},
        body={ name="Agwu's Robe", augments={'Path: A',}},
        hands="Agwu's Gages",
        legs="Arbatel Pants +2",
        feet="Arbatel Loafers +3",
        neck={ name="Argute Stole +2", augments={'Path: A',}},
        waist="Skrymir Cord +1",
        left_ear="Crematio Earring",
        right_ear={ name="Arbatel Earring +1", augments={'System: 1 ID: 1676 Val: 0','Mag. Acc.+11','Enmity-1',}},
        right_ring="Shiva Ring +1",
        left_ring="Mallquis Ring",
        back={ name="Bookworm's Cape", augments={'INT+3','MND+1','Helix eff. dur. +20','"Regen" potency+9',}}}

    sets.midcast.Helix.magic_burst = set_combine(sets.midcast.Helix, { 
        main={ name="Bunzi's Rod", augments={'Path: A',}},
        sub="Culminus",
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head={ name="Agwu's Cap", augments={'Path: A',}},
        body={ name="Agwu's Robe", augments={'Path: A',}},
        hands={ name="Agwu's Gages", augments={'Path: A',}},
        legs="Arbatel Pants +2",
        feet="Arbatel Loafers +3",
        neck={ name="Argute Stole +2", augments={'Path: A',}},
        waist="Skrymir Cord +1",
        left_ear="Crematio Earring",
        right_ear={ name="Arbatel Earring +1", augments={'System: 1 ID: 1676 Val: 0','Mag. Acc.+11','Enmity-1',}},
        left_ring="Mallquis Ring",
        right_ring="Mujin Band",
        back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Occ. inc. resist. to stat. ailments+10',}}})
    
    sets.midcast.DarkHelix = set_combine(sets.midcast.Helix, {
        head="Pixie Hairpin +1",
        left_ring="Archon Ring",
        })

    sets.midcast.DarkHelix.magic_burst = set_combine(sets.midcast.Helix.magic_burst, {
        head="Pixie Hairpin +1",
        left_ring="Archon Ring",
        })

    sets.midcast.LightHelix = set_combine(sets.midcast.Helix, {
        main="Daybreak",
        })

    sets.midcast.LightHelix.magic_burst = set_combine(sets.midcast.Helix.magic_burst, {
        main="Daybreak",
        })
    -- Initializes trusts at iLvl 119
    sets.midcast.Trust = sets.precast.FC


    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.idle = {
        main="Mpaca's Staff",
        sub="Oneiros Grip",
        ammo="Homiliary",
        head="Befouled Crown",
        body="Arbatel Gown +3",
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs="Assid. Pants +1",
        feet="Herald's Gaiters",
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Embla Sash",
        right_ring={name="Stikini Ring +1", bag="wardrobe3"},
        left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        right_ear="Lugalbanda Earring",
        left_ring={name="Stikini Ring +1", bag="wardrobe2"},
        back={ name="Lugh's Cape", augments={'MND+20','Eva.+20 /Mag. Eva.+20','MND+10','"Fast Cast"+10','Occ. inc. resist. to stat. ailments+10',}}
        }

    sets.idle.DT = set_combine(sets.idle, {
        main="Mpaca's Staff",
        sub="Oneiros Grip",
        ammo="Staunch Tathlum +1",
        head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Slipor Sash",
        right_ring={name="Stikini Ring +1", bag="wardrobe3"},
        left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        right_ear="Lugalbanda Earring",
        left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        --left_ring={name="Stikini Ring +1", bag="wardrobe2"},
        back={ name="Lugh's Cape", augments={'MND+20','Eva.+20 /Mag. Eva.+20','MND+10','"Fast Cast"+10','Occ. inc. resist. to stat. ailments+10',}}
        })


    sets.idle.Town = set_combine(sets.idle, {
        main="Mpaca's Staff",
        sub="Oneiros Grip",
        ammo="Homiliary",
        head="Befouled Crown",
        body="Councilor's Garb",
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs="Assid. Pants +1",
        feet="Herald's Gaiters",
        neck= { name="Loricate Torque +1", augments={'Path: A',}},
        waist="Embla Sash",
        left_ring={name="Stikini Ring +1", bag="wardrobe2"},
        left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        right_ear="Lugalbanda Earring",
        right_ring={name="Stikini Ring +1", bag="wardrobe3"},
        back={ name="Lugh's Cape", augments={'MND+20','Eva.+20 /Mag. Eva.+20','MND+10','"Fast Cast"+10','Occ. inc. resist. to stat. ailments+10',}}
        })

    sets.resting = set_combine(sets.idle, {
        main="Chatoyant Staff",
        })

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.defense.PDT = sets.idle.DT
    sets.defense.MDT = sets.idle.DT
    sets.Kiting = {feet="Herald's Gaiters"}
    sets.latent_refresh = {waist="Fucho-no-obi"}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged = {main="Mpaca's Staff",
    sub="Oneiros Grip",
    ammo="Amar Cluster",
    head="Arbatel Bonnet +3",
    body="Arbatel Gown +3",
    hands="Arbatel Bracers +3",
    legs="Arbatel Pants +2",
    feet="Arbatel Loafers +3",
    neck="Combatant's Torque",
    waist="Windbuffet Belt +1",
    left_ear="Telos Earring",
    right_ear="Dedition Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back="Moonlight Cape",
    }
        


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.buff['Ebullience'] = {head="Arbatel Bonnet +3"}
    sets.buff['Rapture'] = {head="Arbatel Bonnet +3"}
    sets.buff['Perpetuance'] = {hands="Arbatel Bracers +3"}
    sets.buff['Immanence'] = {hands="Arbatel Bracers +3"}
    sets.buff['Penury'] = {}
    sets.buff['Parsimony'] = {legs="Arbatel Pants +2"}
    sets.buff['Celerity'] = {feet={ name="Peda. Loafers +3", augments={'Enhances "Stormsurge" effect',}}}
    sets.buff['Alacrity'] = {feet={ name="Peda. Loafers +3", augments={'Enhances "Stormsurge" effect',}}}
    sets.buff['Focalization'] = {head={ name="Peda. M.Board +3", augments={'Enh. "Altruism" and "Focalization"',}}}
    sets.buff['Klimaform'] = {feet="Arbatel Loafers +3"}
    

    sets.buff.FullSublimation = {head="Acad. Mortar. +3",
        body={ name="Peda. Gown +3", augments={'Enhances "Enlightenment" effect',}},
        waist="Embla Sash",
       }

    sets.buff.Doom = {
   
        }

    sets.LightArts = {legs="Acad. Pants +3+", feet="Acad. Loafers +3"}
    sets.DarkArts = {body="Acad. Gown +2", feet="Acad. Loafers +3"}

    sets.Obi = {waist="Hachirin-no-Obi"}
    sets.Bookworm = { back={ name="Bookworm's Cape", augments={'INT+3','MND+1','Helix eff. dur. +20','"Regen" potency+9',}}}
    -- sets.CP = {back="Mecisto. Mantle"}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Get a spell mapping for the spell.
function get_spell_map(spell)
    return spell_maps[spell.name]
end


function job_precast(spell, action, spellMap, eventArgs)
    if spell.name:startswith('Aspir') then
        refine_various_spells(spell, action, spellMap, eventArgs)
    end
end

function job_post_precast(spell, action, spellMap, eventArgs)
    if (spell.type == "WhiteMagic" and (buffactive["Light Arts"] or buffactive["Addendum: White"])) or
        (spell.type == "BlackMagic" and (buffactive["Dark Arts"] or buffactive["Addendum: Black"])) then
        equip(sets.precast.FC.Grimoire)
    end
    if spell.name == 'Impact' then
        equip(sets.precast.FC.Impact)
    end
end

-- Run after the general midcast() is done.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.skill == 'Elemental Magic' then
        if spellMap == "Helix" then
            equip(sets.midcast.Helix)
            if spell.english:startswith('Lumino') then
                equip(sets.midcast.LightHelix)
            elseif spell.english:startswith('Nocto') then
                equip(sets.midcast.DarkHelix)
            else
                equip(sets.midcast.Helix)
            end
            if state.HelixMode.value == 'Duration' then
                equip(sets.Bookworm)
            end
        end
        if buffactive['Klimaform'] and spell.element == world.weather_element then
            equip(sets.buff['Klimaform'])
        end
    end
    if spell.action_type == 'Magic' then
        apply_grimoire_bonuses(spell, action, spellMap, eventArgs)
    end
    if spell.skill == 'Enfeebling Magic' then
        if spell.type == "WhiteMagic" and (buffactive["Light Arts"] or buffactive["Addendum: White"]) then
            equip(sets.LightArts)
        elseif spell.type == "BlackMagic" and (buffactive["Dark Arts"] or buffactive["Addendum: Black"]) then
            equip(sets.DarkArts)
        end
    end
    if spell.skill == 'Elemental Magic' or spell.english == "Kaustra" then
        if (spell.element == world.weather_element and (get_weather_intensity() == 2 and spell.element ~= elements.weak_to[world.day_element])) and spellMap ~= 'Helix' then
            equip(sets.Obi)
        -- Target distance under 1.7 yalms.
        elseif spell.target.distance < (1.7 + spell.target.model_size) then
            equip({waist="Orpheus's Sash"})
        -- Matching day and weather.
       elseif (spell.element == world.day_element and spell.element == world.weather_element) and spellMap ~= 'Helix' then
            equip(sets.Obi)
        -- Target distance under 8 yalms.
        elseif spell.target.distance < (8 + spell.target.model_size) then
            equip({waist="Orpheus's Sash"})
        -- Match day or weather.
       elseif (spell.element == world.day_element or spell.element == world.weather_element) and spellMap ~= 'Helix' then
            equip(sets.Obi)
        end
    end
    if spell.skill == 'Enhancing Magic' then
    if classes.NoSkillSpells:contains(spell.english) then
        equip(sets.midcast.EnhancingDuration)
        if spellMap == 'Refresh' then
            equip(sets.midcast.Refresh)
        end
    end
    if spellMap == "Regen" and state.RegenMode.value == 'Duration' then
        equip(sets.midcast.Regen.Duration)
    end
    if state.Buff.Perpetuance then
        equip(sets.buff['Perpetuance'])
    end
    if spellMap == "Storm" and state.StormSurge.value then
        equip (sets.midcast.Stormsurge)
    end
    end
    if spell.skill == 'Elemental Magic' and state.MagicBurst.value then
        equip(sets.midcast['Elemental Magic'].magic_burst)
    end
    if spell.skill == 'Elemental Magic' and state.CastingMode.value == 'Normal' then
        equip(sets.midcast['Elemental Magic'])
    end
    if spell.skill == 'Elemental Magic' and state.CastingMode.value == 'Resistant' then
        equip(sets.midcast['Elemental Magic'].Resistant)
    end
    if spell.skill == 'Elemental Magic' and state.CastingMode.value == 'Magic Burst' then
        equip(sets.midcast['Elemental Magic'].magic_burst)
    end
	if spell.skill == 'Elemental Magic' and spell.element == world.day_element or spell.element == world.weather_element and not spell.name == 'Meteor' then
        equip(sets.Obi)
    end
    if spellMap == "Helix" and state.MagicBurst.value then
        equip(sets.midcast.Helix.magic_burst)
    end
    if spellMap == "Helix" and state.CastingMode.value == 'Normal' then
        equip(sets.midcast.Helix)
    end
    if spellMap == "Helix" and state.CastingMode.value == 'Resistant' then
        equip(sets.midcast.Helix.Resistant)
    end
    if spellMap == "Helix" and state.CastingMode.value == 'Magic Burst' then
        equip(sets.midcast.Helix.magic_burst)
    end
    if spell.name == 'Impact' then
        equip(sets.midcast.Impact)
    end	
end

function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted then
        if spell.english == "Sleep II" then
            send_command('@timers c "Sleep II ['..spell.target.name..']" 90 down spells/00259.png')
        elseif spell.english == "Sleep" or spell.english == "Sleepga" then -- Sleep & Sleepga Countdown --
            send_command('@timers c "Sleep ['..spell.target.name..']" 60 down spells/00253.png')
        elseif spell.english == "Break" then
            send_command('@timers c "Break ['..spell.target.name..']" 30 down spells/00255.png')
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
    if buff == "Sublimation: Activated" then
        handle_equipping_gear(player.status)
    end

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

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------


-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
        if cmdParams[1] == 'user' and not (buffactive['light arts']      or buffactive['dark arts'] or
                           buffactive['addendum: white'] or buffactive['addendum: black']) then
            if state.IdleMode.value == 'Stun' then
                send_command('@input /ja "Dark Arts" <me>')
            else
                send_command('@input /ja "Light Arts" <me>')
            end
    
        update_active_strategems()
        update_sublimation()
    end
    handle_equipping_gear(player.status)
    update_active_strategems()
    update_sublimation()
end

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if default_spell_map == 'Cure' or default_spell_map == 'Curaga' then
            if (world.weather_element == 'Light' or world.day_element == 'Light') then
                return 'CureWeather'
            end
        elseif spell.skill == 'Enfeebling Magic' then
            if spell.type == 'WhiteMagic' then
                return 'MndEnfeebles'
            else
                return 'IntEnfeebles'
            end
        end
    end
end

function customize_idle_set(idleSet)
    if state.Buff['Sublimation: Activated'] then
        idleSet = set_combine(idleSet, sets.buff.FullSublimation)
    end
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    -- if state.CP.current == 'on' then
    --     equip(sets.CP)
    --     disable('back')
    -- else
    --     enable('back')
    -- end

    return idleSet
end

-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)

    local c_msg = state.CastingMode.value

    local h_msg = state.HelixMode.value

    local r_msg = state.RegenMode.value

    local d_msg = 'None'
    if state.DefenseMode.value ~= 'None' then
        d_msg = state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
    end

    local i_msg = state.IdleMode.value

    local msg = ''
    if state.MagicBurst.value then
        msg = ' Burst: On |'
    end
    if state.Kiting.value then
        msg = msg .. ' Kiting: On |'
    end

    add_to_chat(060, '| Magic: ' ..string.char(31,001)..c_msg.. string.char(31,002)..  ' |'
        ..string.char(31,060).. ' Helix: ' ..string.char(31,001)..h_msg.. string.char(31,002)..  ' |'
        ..string.char(31,060).. ' Regen: ' ..string.char(31,001)..r_msg.. string.char(31,002)..  ' |'
        ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for direct player commands.
-- Called for direct player commands.
function job_self_command(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'scholar' then
        handle_strategems(cmdParams)
        eventArgs.handled = true
    elseif cmdParams[1]:lower() == 'nuke' then
        handle_nuking(cmdParams)
        eventArgs.handled = true
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

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

-- Reset the state vars tracking strategems.
function update_active_strategems()
    state.Buff['Ebullience'] = buffactive['Ebullience'] or false
    state.Buff['Rapture'] = buffactive['Rapture'] or false
    state.Buff['Perpetuance'] = buffactive['Perpetuance'] or false
    state.Buff['Immanence'] = buffactive['Immanence'] or false
    state.Buff['Penury'] = buffactive['Penury'] or false
    state.Buff['Parsimony'] = buffactive['Parsimony'] or false
    state.Buff['Celerity'] = buffactive['Celerity'] or false
    state.Buff['Alacrity'] = buffactive['Alacrity'] or false
    state.Buff['Focalization'] = buffactive['Focalization'] or false
    state.Buff['Klimaform'] = buffactive['Klimaform'] or false
end

function update_sublimation()
    state.Buff['Sublimation: Activated'] = buffactive['Sublimation: Activated'] or false
end

-- Equip sets appropriate to the active buffs, relative to the spell being cast.
function apply_grimoire_bonuses(spell, action, spellMap)
    if state.Buff.Perpetuance and spell.type =='WhiteMagic' and spell.skill == 'Enhancing Magic' then
        equip(sets.buff['Perpetuance'])
    end
    if state.Buff.Rapture and (spellMap == 'Cure' or spellMap == 'Curaga') then
        equip(sets.buff['Rapture'])
    end
    if spell.skill == 'Elemental Magic' and spellMap ~= 'ElementalEnfeeble' then
        if state.Buff.Ebullience and spell.english ~= 'Impact' then
            equip(sets.buff['Ebullience'])
        end
        if state.Buff.Immanence then
            equip(sets.buff['Immanence'])
        end
        if state.Buff.Klimaform and spell.element == world.weather_element then
            equip(sets.buff['Klimaform'])
        end
    end

    if state.Buff.Penury then equip(sets.buff['Penury']) end
    if state.Buff.Parsimony then equip(sets.buff['Parsimony']) end
    if state.Buff.Celerity then equip(sets.buff['Celerity']) end
    if state.Buff.Alacrity then equip(sets.buff['Alacrity']) end
    if state.Buff.Focalization then equip(sets.buff['Focalization']) end
end


-- General handling of strategems in an Arts-agnostic way.
-- Format: gs c scholar <strategem>
function handle_strategems(cmdParams)
    -- cmdParams[1] == 'scholar'
    -- cmdParams[2] == strategem to use

    if not cmdParams[2] then
        add_to_chat(123,'Error: No strategem command given.')
        return
    end
    local strategem = cmdParams[2]:lower()

    if strategem == 'light' then
        if buffactive['light arts'] then
            send_command('input /ja "Addendum: White" <me>')
        elseif buffactive['addendum: white'] then
            add_to_chat(122,'Error: Addendum: White is already active.')
        else
            send_command('input /ja "Light Arts" <me>')
        end
    elseif strategem == 'dark' then
        if buffactive['dark arts'] then
            send_command('input /ja "Addendum: Black" <me>')
        elseif buffactive['addendum: black'] then
            add_to_chat(122,'Error: Addendum: Black is already active.')
        else
            send_command('input /ja "Dark Arts" <me>')
        end
    elseif buffactive['light arts'] or buffactive['addendum: white'] then
        if strategem == 'cost' then
            send_command('input /ja Penury <me>')
        elseif strategem == 'speed' then
            send_command('input /ja Celerity <me>')
        elseif strategem == 'aoe' then
            send_command('input /ja Accession <me>')
        elseif strategem == 'power' then
            send_command('input /ja Rapture <me>')
        elseif strategem == 'duration' then
            send_command('input /ja Perpetuance <me>')
        elseif strategem == 'accuracy' then
            send_command('input /ja Altruism <me>')
        elseif strategem == 'enmity' then
            send_command('input /ja Tranquility <me>')
        elseif strategem == 'skillchain' then
            add_to_chat(122,'Error: Light Arts does not have a skillchain strategem.')
        elseif strategem == 'addendum' then
            send_command('input /ja "Addendum: White" <me>')
        else
            add_to_chat(123,'Error: Unknown strategem ['..strategem..']')
        end
    elseif buffactive['dark arts']  or buffactive['addendum: black'] then
        if strategem == 'cost' then
            send_command('input /ja Parsimony <me>')
        elseif strategem == 'speed' then
            send_command('input /ja Alacrity <me>')
        elseif strategem == 'aoe' then
            send_command('input /ja Manifestation <me>')
        elseif strategem == 'power' then
            send_command('input /ja Ebullience <me>')
        elseif strategem == 'duration' then
            add_to_chat(122,'Error: Dark Arts does not have a duration strategem.')
        elseif strategem == 'accuracy' then
            send_command('input /ja Focalization <me>')
        elseif strategem == 'enmity' then
            send_command('input /ja Equanimity <me>')
        elseif strategem == 'skillchain' then
            send_command('input /ja Immanence <me>')
        elseif strategem == 'addendum' then
            send_command('input /ja "Addendum: Black" <me>')
        else
            add_to_chat(123,'Error: Unknown strategem ['..strategem..']')
        end
    else
        add_to_chat(123,'No arts has been activated yet.')
    end
end


-- Gets the current number of available strategems based on the recast remaining
-- and the level of the sch.
function get_current_strategem_count()
    -- returns recast in seconds.
    local allRecasts = windower.ffxi.get_ability_recasts()
    local stratsRecast = allRecasts[231]

    local maxStrategems = (player.main_job_level + 10) / 20

    local fullRechargeTime = 4*60

    local currentCharges = math.floor(maxStrategems - maxStrategems * stratsRecast / fullRechargeTime)

    return currentCharges
end

function refine_various_spells(spell, action, spellMap, eventArgs)
    local newSpell = spell.english
    local spell_recasts = windower.ffxi.get_spell_recasts()
    local cancelling = 'All '..spell.english..' are on cooldown. Cancelling.'

    local spell_index

    if spell_recasts[spell.recast_id] > 0 then
        if spell.name:startswith('Aspir') then
            spell_index = table.find(degrade_array['Aspirs'],spell.name)
            if spell_index > 1 then
                newSpell = degrade_array['Aspirs'][spell_index - 1]
                send_command('@input /ma '..newSpell..' '..tostring(spell.target.raw))
                eventArgs.cancel = true
            end
        end
    end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(10, 13)
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end
