_addon.name = 'TargetCaddie'
_addon.author = 'Greenshoe'
_addon.commands = {'targetcaddie', 'tcaddie', 'tc'}
_addon.version = '1.0.1'
_addon.lastUpdate = '2022.08.22'

require('tables')

res = require('resources')
packets = require('packets')

function print_help()
    windower.add_to_chat(7, _addon.name .. ' v.' .. _addon.version .. ' by ' .. _addon.author)
    windower.add_to_chat(7, "   //tc nearest - Engage the nearest mob, or switches to nearest mob besides the one you're currently fighting")
end



cycle = 0 
addon_status = false



windower.register_event('addon command', function (command,...)
	command = command and command:lower() or 'help'
	local args = {...}

    if S{'help'}:contains(command) then
        print_help()
    elseif S{'reload','unload'}:contains(command) then
        windower.send_command(('lua %s %s'):format(command, _addon.name))
	elseif S{'on'}:contains(command) then
        if not addon_status then
            addon_status = true
            print("addon running...")
        end
    elseif S{'off'}:contains(command) then
        if addon_status then
            addon_status = false
            print("addon off...")
        end    
    elseif S{'toggle'}:contains(command) then
        if not addon_status then
            addon_status = true
            print("addon running...")
        else 
            addon_status = false
            print("addon off....")
        end    
    elseif S{'nearest'}:contains(command) then
        attack_nearest_mob()
    end
end)

windower.register_event('prerender',function()
	if addon_status and os.clock() - cycle > 0.1 then

		if windower.ffxi.get_player().status == 1 and windower.ffxi.get_mob_by_target('t') and windower.ffxi.get_mob_by_target('t').hpp == 0 then
			attack_nearest_mob()
		end
		
		cycle = os.clock()
	end
end)

function is_unclaimed(target)
    if not target.claim_id or target.claim_id == 0 then
        return true
    end

    return false
end

function is_claimed_by_others(target)
    if not target.claim_id or target.claim_id == 0 then
        return false
    end

    alliance = windower.ffxi.get_party()
    for idx=1, 18 do
        member_to_consider = alliance[alliance_indices[idx]]

        if target.claim_id and member_to_consider and member_to_consider.mob and target.claim_id == member_to_consider.mob.id then
            return false
        end
    end

    return true
end

last_attack_target = os.clock()
function attack_nearest_mob()
    local now = os.clock()
    if now - last_attack_target < 0.1 then -- prevent spam
        return
    end
    last_attack_target = now

    local mob_array = windower.ffxi.get_mob_array()
    local closest_mob = nil
    local second_closest_mob = nil
    for key, mob in pairs(mob_array) do
        if mob.is_npc and mob.id%4096<=2047 and mob.spawn_type == 16 and mob.valid_target and mob.hpp > 0 and (is_unclaimed(mob) or not is_claimed_by_others(mob)) then
            -- is a living monster not claimed by others
            
            if second_closest_mob == nil and closest_mob ~= nil then
                second_closest_mob = mob
            end

            if closest_mob == nil then
                closest_mob = mob
            end

            if closest_mob.distance > mob.distance then
                second_closest_mob = closest_mob
                closest_mob = mob
            end
        end
    end

    local player = windower.ffxi.get_player()
    local current_target = windower.ffxi.get_mob_by_target('t')

    if player.status == 1 then
        local target_to_switch_to = nil
        if current_target ~= nil and closest_mob ~= nil and current_target.id ~= closest_mob.id then
            -- if closest_mob is not the one we are fighting we switch to it
            target_to_switch_to = closest_mob
        elseif current_target ~= nil and second_closest_mob ~= nil and current_target.id ~= second_closest_mob.id then
            -- else if the second_closest_mob is not the one we are fighting we switch to it
            target_to_switch_to = second_closest_mob
        end

        if target_to_switch_to ~= nil then
            -- if attacking we switch to the closest mob besides the one you are attacking -- 0x0F
            packets.inject(packets.new('outgoing', 0x1a, {
                ['Target']= target_to_switch_to.id,
                ['Target Index'] = target_to_switch_to.index,
                ['Category']     = 0x0F,
            }))
            windower.add_to_chat(7, '>> Switching to closest mob: ' .. target_to_switch_to.name .. ' [' .. target_to_switch_to.id ..']')
        else
            windower.add_to_chat(123, '>> Unable to attack mobs: no additinal targets within range')    
        end
    elseif player.status == 0 and closest_mob ~= nil then -- idle
        -- if idle we switch to the nearest target -- 0x0F
        packets.inject(packets.new('outgoing', 0x1a, {
            ['Target']= closest_mob.id,
            ['Target Index'] = closest_mob.index,
            ['Category']     = 0x02,
        }))
        windower.add_to_chat(7, '>> Engaging closest mob: ' .. closest_mob.name .. ' [' .. closest_mob.id ..']')
    else
        windower.add_to_chat(123, '>> Unable to attack mobs: no target within range')
    end
end

alliance_indices = {'p0', 'p1', 'p2', 'p3', 'p4', 'p5', 'a10', 'a11', 'a12', 'a13', 'a14', 'a15', 'a20', 'a21', 'a22', 'a23', 'a24', 'a25'}
