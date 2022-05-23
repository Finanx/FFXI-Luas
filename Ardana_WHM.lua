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
    state.Buff['Afflatus Solace'] = buffactive['Afflatus Solace'] or false
    state.Buff['Afflatus Misery'] = buffactive['Afflatus Misery'] or false
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('None', 'Normal')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal')

    select_default_macro_book()
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

    -- Precast Sets

    -- Fast cast sets for spells
    sets.precast.FC = {
		main={ name="Queller Rod", augments={'Healing magic skill +15','"Cure" potency +10%','"Cure" spellcasting time -7%',}},
		ammo="Incantor Stone",
		head={ name="Kaykaus Mitra", augments={'MP+60','"Cure" spellcasting time -5%','Enmity-5',}},
		body="Wayfarer Robe",
		hands="Wayfarer Cuffs",
		legs="Assid. Pants +1",
		feet={ name="Kaykaus Boots", augments={'MP+60','"Cure" spellcasting time -5%','Enmity-5',}},
		neck="Orison Locket",
		waist="Channeler's Stone",
		left_ear="Nourish. Earring",
		right_ear="Nourish. Earring +1",
		left_ring="Sirona's Ring",
		right_ring="Ephedra Ring",
		back={ name="Alaunus's Cape", augments={'"Fast Cast"+9',}},}
        
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})

    sets.precast.FC.Stoneskin = set_combine(sets.precast.FC['Enhancing Magic'], {head="Umuthi Hat"})

    sets.precast.FC['Healing Magic'] = set_combine(sets.precast.FC, {legs="Orison Pantaloons +1"})

    sets.precast.FC.StatusRemoval = sets.precast.FC['Healing Magic']

    sets.precast.FC.Cure = set_combine(sets.precast.FC, {ear1="Nourish. Earring",ear2="Nourish. Earring +1",legs="Orison Pantaloons +1"})
		
    sets.precast.FC.Curaga = sets.precast.FC.Cure
	
    sets.precast.FC.CureSolace = sets.precast.FC.Cure
	
    -- CureMelee spell map should default back to Healing Magic.
    
    -- Precast sets to enhance JAs
    sets.precast.JA.Benediction = {body="Piety Briault"}

    -- Weaponskill sets

    -- Default set for any weaponskill that isn't any more specifically defined
    gear.default.weaponskill_neck = "Asperity Necklace"
    gear.default.weaponskill_waist = ""
    sets.precast.WS = {
        head="Nahtirah Hat",neck=gear.ElementalGorget,ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Vanir Cotehardie",hands="Yaoyotl Gloves",ring1="Rajas Ring",ring2="K'ayres Ring",
        back="Refraction Cape",waist=gear.ElementalBelt,legs="Gendewitha Spats",feet="Gendewitha Galoshes"}
    
    sets.precast.WS['Flash Nova'] = {
        head="Nahtirah Hat",neck="Stoicheion Medal",ear1="Friomisi Earring",ear2="Hecate's Earring",
        body="Vanir Cotehardie",hands="Yaoyotl Gloves",ring1="Rajas Ring",ring2="Strendu Ring",
        back="Toro Cape",waist="Thunder Belt",legs="Gendewitha Spats",feet="Gendewitha Galoshes"}
    

    -- Midcast Sets
    
		sets.midcast.FastRecast = {
		main={ name="Queller Rod", augments={'Healing magic skill +15','"Cure" potency +10%','"Cure" spellcasting time -7%',}},
		ammo="Incantor Stone",
		head={ name="Kaykaus Mitra", augments={'MP+60','"Cure" spellcasting time -5%','Enmity-5',}},
		body="Wayfarer Robe",
		hands="Wayfarer Cuffs",
		legs="Assid. Pants +1",
		feet={ name="Kaykaus Boots", augments={'MP+60','"Cure" spellcasting time -5%','Enmity-5',}},
		neck="Orison Locket",
		waist="Channeler's Stone",
		left_ear="Nourish. Earring",
		right_ear="Nourish. Earring +1",
		left_ring="Sirona's Ring",
		right_ring="Ephedra Ring",
		back={ name="Alaunus's Cape", augments={'"Fast Cast"+9',}},}
    
    -- Cure sets
    gear.default.obi_waist = "Goading Belt"
    gear.default.obi_back = "Mending Cape"

    sets.midcast.CureSolace = {
		main={ name="Queller Rod", augments={'Healing magic skill +15','"Cure" potency +10%','"Cure" spellcasting time -7%',}},
		ammo="Incantor Stone",
		head={ name="Kaykaus Mitra", augments={'MP+60','"Cure" spellcasting time -5%','Enmity-5',}},
		body="Wayfarer Robe",
		hands="Wayfarer Cuffs",
		legs="Orsn. Pantaln. +1",
		feet={ name="Kaykaus Boots", augments={'MP+60','"Cure" spellcasting time -5%','Enmity-5',}},
		neck="Orison Locket",
		waist="Othila Sash",
		left_ear="Nourish. Earring",
		right_ear="Nourish. Earring +1",
		left_ring="Sirona's Ring",
		right_ring="Ephedra Ring",
		back="Oretania's Cape",}

    sets.midcast.Cure = {
		main={ name="Queller Rod", augments={'Healing magic skill +15','"Cure" potency +10%','"Cure" spellcasting time -7%',}},
		ammo="Incantor Stone",
		head={ name="Kaykaus Mitra", augments={'MP+60','"Cure" spellcasting time -5%','Enmity-5',}},
		body="Wayfarer Robe",
		hands="Wayfarer Cuffs",
		legs="Orsn. Pantaln. +1",
		feet={ name="Kaykaus Boots", augments={'MP+60','"Cure" spellcasting time -5%','Enmity-5',}},
		neck="Orison Locket",
		waist="Othila Sash",
		left_ear="Nourish. Earring",
		right_ear="Nourish. Earring +1",
		left_ring="Sirona's Ring",
		right_ring="Ephedra Ring",
		back="Oretania's Cape",}

    sets.midcast.Curaga = {
		main={ name="Queller Rod", augments={'Healing magic skill +15','"Cure" potency +10%','"Cure" spellcasting time -7%',}},
		ammo="Incantor Stone",
		head={ name="Kaykaus Mitra", augments={'MP+60','"Cure" spellcasting time -5%','Enmity-5',}},
		body="Wayfarer Robe",
		hands="Wayfarer Cuffs",
		legs="Orsn. Pantaln. +1",
		feet={ name="Kaykaus Boots", augments={'MP+60','"Cure" spellcasting time -5%','Enmity-5',}},
		neck="Orison Locket",
		waist="Othila Sash",
		left_ear="Nourish. Earring",
		right_ear="Nourish. Earring +1",
		left_ring="Sirona's Ring",
		right_ring="Ephedra Ring",
		back="Oretania's Cape",}

    sets.midcast.Cursna = {main="Queller Rod",sub="Genbu's Shield",ammo="Incantor Stone",
        head="Kaykaus Mitra",neck="Orison Locket",ear1="Nourish. Earring",ear2="Nourish. Earring +1",
        body="Vanir Cotehardie",hands="Theophany Mitts",ring1="Ephedra Ring",ring2="Sirona's Ring",
        back="Oretania's Cape",waist="",legs="Orison Pantaloons +1",feet="Kaykaus Boots"}

    sets.midcast.StatusRemoval = {
        legs="Orison Pantaloons +1"}

    -- 110 total Enhancing Magic Skill; caps even without Light Arts
    sets.midcast['Enhancing Magic'] = {main="Beneficus",sub="Genbu's Shield",
        head="Umuthi Hat",neck="Colossus's Torque",
        body="Manasa Chasuble",hands="Dynasty Mitts",
        back="Mending Cape",waist="Olympus Sash",legs="Piety Pantaloons",feet="Orison Duckbills +2"}

    sets.midcast.Stoneskin = {
        head="Nahtirah Hat",neck="Orison Locket",ear2="Loquacious Earring",
        body="Vanir Cotehardie",hands="Dynasty Mitts",
        back="Swith Cape +1",waist="Siegel Sash",legs="Gendewitha Spats",feet="Gendewitha Galoshes"}

    sets.midcast.BarElement = {main="Beneficus",sub="Genbu's Shield",
        head="Orison Cap +2",neck="Colossus's Torque",
        body="Orison Bliaud +2",hands="Orison Mitts +2",
        back="Mending Cape",waist="Olympus Sash",legs="Piety Pantaloons",feet="Orison Duckbills +2"}

    sets.midcast.Regen = {main="Bolelabunga",sub="Genbu's Shield",
        body="Piety Briault",hands="Orison Mitts +2",
        legs="Theophany Pantaloons"}

    sets.midcast.Protectra = {ring1="Sheltered Ring",feet="Piety Duckbills +1"}

    sets.midcast.Shellra = {ring1="Sheltered Ring",legs="Piety Pantaloons"}


    sets.midcast['Divine Magic'] = {main="Bolelabunga",sub="Genbu's Shield",
        head="Nahtirah Hat",neck="Colossus's Torque",ear1="Psystorm Earring",ear2="Lifestorm Earring",
        body="Vanir Cotehardie",hands="Yaoyotl Gloves",ring2="Sangoma Ring",
        back="Refraction Cape",waist=gear.ElementalObi,legs="Theophany Pantaloons",feet="Gendewitha Galoshes"}

    sets.midcast['Dark Magic'] = {main="Bolelabunga", sub="Genbu's Shield",
        head="Nahtirah Hat",neck="Aesir Torque",ear1="Psystorm Earring",ear2="Lifestorm Earring",
        body="Vanir Cotehardie",hands="Yaoyotl Gloves",ring1="Strendu Ring",ring2="Sangoma Ring",
        back="Refraction Cape",waist="Demonry Sash",legs="Bokwus Slops",feet="Piety Duckbills +1"}

    -- Custom spell classes
    sets.midcast.MndEnfeebles = {main="Lehbrailg +2", sub="Mephitis Grip",
        head="Nahtirah Hat",neck="Weike Torque",ear1="Psystorm Earring",ear2="Lifestorm Earring",
        body="Vanir Cotehardie",hands="Yaoyotl Gloves",ring1="Aquasoul Ring",ring2="Sangoma Ring",
        back="Refraction Cape",waist="Demonry Sash",legs="Bokwus Slops",feet="Piety Duckbills +1"}

    sets.midcast.IntEnfeebles = {main="Lehbrailg +2", sub="Mephitis Grip",
        head="Nahtirah Hat",neck="Weike Torque",ear1="Psystorm Earring",ear2="Lifestorm Earring",
        body="Vanir Cotehardie",hands="Yaoyotl Gloves",ring1="Icesoul Ring",ring2="Sangoma Ring",
        back="Refraction Cape",waist="Demonry Sash",legs="Bokwus Slops",feet="Piety Duckbills +1"}

    
    -- Sets to return to when not performing an action.
    
    -- Resting sets
    sets.resting = {main="Queller Rod",sub="Genbu's Shield",ammo="Incantor Stone",
        head="Kaykaus Mitra",neck="Orison Locket",ear1="Nourish. Earring",ear2="Nourish. Earring +1",
        body="Vanir Cotehardie",hands="Theophany Mitts",ring1="Ephedra Ring",ring2="Sirona's Ring",
        back="Oretania's Cape",waist="",legs="Assid. Pants +1",feet="Kaykaus Boots"}
    

    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
    sets.idle = {
		main={ name="Queller Rod", augments={'Healing magic skill +15','"Cure" potency +10%','"Cure" spellcasting time -7%',}},
		ammo="Incantor Stone",
		head={ name="Kaykaus Mitra", augments={'MP+60','"Cure" spellcasting time -5%','Enmity-5',}},
		body="Wayfarer Robe",
		hands="Wayfarer Cuffs",
		legs="Assid. Pants +1",
		feet={ name="Kaykaus Boots", augments={'MP+60','"Cure" spellcasting time -5%','Enmity-5',}},
		neck="Orison Locket",
		waist="Fucho-no-Obi",
		left_ear="Nourish. Earring",
		right_ear="Nourish. Earring +1",
		left_ring="Sirona's Ring",
		right_ring="Ephedra Ring",
		back={ name="Alaunus's Cape", augments={'"Fast Cast"+9',}},}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Basic set for if no TP weapon is defined.
    sets.engaged = {
        head="Nahtirah Hat",neck="Asperity Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Vanir Cotehardie",hands="Dynasty Mitts",ring1="Rajas Ring",ring2="K'ayres Ring",
        back="Umbra Cape",waist="Goading Belt",legs="Gendewitha Spats",feet="Gendewitha Galoshes"}


    -- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
    sets.buff['Divine Caress'] = {hands="Orison Mitts +2",back="Mending Cape"}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if spell.english == "Paralyna" and buffactive.Paralyzed then
        -- no gear swaps if we're paralyzed, to avoid blinking while trying to remove it.
        eventArgs.handled = true
    end
    
    if spell.skill == 'Healing Magic' then
        gear.default.obi_back = "Mending Cape"
    else
        gear.default.obi_back = "Toro Cape"
    end
end


function job_post_midcast(spell, action, spellMap, eventArgs)
    -- Apply Divine Caress boosting items as highest priority over other gear, if applicable.
    if spellMap == 'StatusRemoval' and buffactive['Divine Caress'] then
        equip(sets.buff['Divine Caress'])
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Offense Mode' then
        if newValue == 'Normal' then
            disable('main','sub','range')
        else
            enable('main','sub','range')
        end
    end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if (default_spell_map == 'Cure' or default_spell_map == 'Curaga') and player.status == 'Engaged' then
            return "CureMelee"
        elseif default_spell_map == 'Cure' and state.Buff['Afflatus Solace'] then
            return "CureSolace"
        elseif spell.skill == "Enfeebling Magic" then
            if spell.type == "WhiteMagic" then
                return "MndEnfeebles"
            else
                return "IntEnfeebles"
            end
        end
    end
end


function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    return idleSet
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    if cmdParams[1] == 'user' and not areas.Cities:contains(world.area) then
        local needsArts = 
            player.sub_job:lower() == 'sch' and
            not buffactive['Light Arts'] and
            not buffactive['Addendum: White'] and
            not buffactive['Dark Arts'] and
            not buffactive['Addendum: Black']
            
        if not buffactive['Afflatus Solace'] and not buffactive['Afflatus Misery'] then
            if needsArts then
                send_command('@input /ja "Afflatus Solace" <me>;wait 1.2;input /ja "Light Arts" <me>')
            else
                send_command('@input /ja "Afflatus Solace" <me>')
            end
        end
    end
end


-- Function to display the current relevant user state when doing an update.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    set_macro_page(4, 14)
end

