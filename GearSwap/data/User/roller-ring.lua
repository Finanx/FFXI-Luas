--[[
    Original code by Rubenator

    READ ME:

    Add below include to your job's gear file just after the "function user_job_setup()" line, should be at the top of file
        include('roller-ring.lua')

    Add the equipmnent line to your job gear file in same area as other "sets.idle" gear
        sets.idle.rollers = set_combine(sets.idle, {lring="Roller's Ring",})

    NOTE: If movement ring is in same slot(left ring) as the Roller's Ring then it won't equip

]]

-- Blank table used to track 11 roll for Roller's Ring
local roll_numbers = T{}

-- List of all phantom rolls to use one check_buffs
local phantom_roll = S{
    'Allies\' Roll', 'Avenger\'s Roll', 'Beast Roll', 'Blitzer\'s Roll', 'Bolter\'s Roll', 'Caster\'s Roll', 'Chaos Roll',
    'Choral Roll', 'Companion\'s Roll', 'Corsair\'s Roll', 'Courser\'s Roll', 'Dancer\'s Roll', 'Drachen Roll', 'Evoker\'s Roll',
    'Fighter\'s Roll', 'Gallant\'s Roll', 'Healer\'s Roll', 'Hunter\'s Roll', 'Magus\'s Roll', 'Miser\'s Roll', 'Monk\'s Roll',
    'Naturalist\'s Roll', 'Ninja Roll', 'Puppet Roll', 'Rogue\'s Roll', 'Runeist\'s Roll', 'Samurai Roll', 'Scholar\'s Roll',
    'Tactician\'s Roll', 'Warlock\'s Roll', 'Wizard\'s Roll',
}

-- Used with register event to check if roll is 11 to then use the Roller's Ring for regain
local corsairRollIDs = T{
    [98] = 'Fighter\'s Roll',
    [99] = 'Monk\'s Roll',
    [100] = 'Healer\'s Roll',
    [101] = 'Wizard\'s Roll',
    [102] = 'Warlock\'s Roll',
    [103] = 'Rogue\'s Roll',
    [104] = 'Gallant\'s Roll',
    [105] = 'Chaos Roll',
    [106] = 'Beast Roll',
    [107] = 'Choral Roll',
    [108] = 'Hunter\'s Roll',
    [109] = 'Samurai Roll',
    [110] = 'Ninja Roll',
    [111] = 'Drachen Roll',
    [112] = 'Evoker\'s Roll',
    [113] = 'Magus\'s Roll',
    [114] = 'Corsair\'s Roll',
    [115] = 'Puppet Roll',
    [116] = 'Dancer\'s Roll',
    [117] = 'Scholar\'s Roll',
    [118] = 'Bolter\'s Roll',
    [119] = 'Caster\'s Roll',
    [120] = 'Courser\'s Roll',
    [121] = 'Blitzer\'s Roll',
    [122] = 'Tactician\'s Roll',
    [302] = 'Allies\' Roll',
    [303] = 'Miser\'s Roll',
    [304] = 'Companion\'s Roll',
    [305] = 'Avenger\'s Roll',
    [390] = 'Naturalist\'s Roll',
    [391] = 'Runeist\'s Roll',
}

-- Not a common event, stand alone for determining if hit with an 11 COR Roll so you can equip Roller's Ring for Regain
windower.raw_register_event('action', function(act)
    if act.category ~= 6 or not table.containskey(corsairRollIDs, act.param) then return end
    rollActor = act.actor_id
    local rollID = act.param
    local rollNum = act.targets[1].actions[1].param
    local rollName = gearswap.res.job_abilities[rollID].english

    -- anonymous function that checks if the player.id is in the targets without wrapping it in another layer of for loops.
    if
        function(act)
            for i = 1, #act.targets do
                if act.targets[i].id == player.id then
                    return true
                end
            end
            return false
        end(act)
    then
        roll_numbers[rollName] = rollNum
    end
    if rollNum == 11 and player.status == 'Idle' then
        classes.CustomIdleGroups:append('rollers')
        send_command('wait 1; gs c update')
        return
    end
end)

-- Event to remove regain ring once you reach 3000 TP
windower.raw_register_event('tp change', function(new, old)
    -- Regain gear, if at max tp then just update to normal idle set,
    -- if ring isnt equiped but TP drops due to WS or weapon change it will re-equip
    for roll in corsairRollIDs:it() do
        local roll_name = roll
        if buffactive[roll_name] and roll_numbers[roll_name] == 11 and player.status == 'Idle' then
            if player.tp == 3000
                    and (player.equipment.left_ring == 'Roller\'s Ring' or player.equipment.right_ring == 'Roller\'s Ring') then
                classes.CustomIdleGroups:clear()
                send_command('wait 1; gs c update')
            elseif player.tp < 3000
                    and not (player.equipment.left_ring == 'Roller\'s Ring' or player.equipment.right_ring == 'Roller\'s Ring') then
                classes.CustomIdleGroups:append('rollers')
                send_command('wait 1; gs c update')
            end
        end
    end
end)

-- Buff check so when the 11 roll wears off it will change to normal idle set
function job_buff_change(buff, gain, eventArgs)
    if phantom_roll:contains(buff) and not gain then
        if player.equipment.left_ring == 'Roller\'s Ring' or player.equipment.right_ring == 'Roller\'s Ring' then
            classes.CustomIdleGroups:clear()
            send_command('wait 1; gs c update')
        end
    end
end