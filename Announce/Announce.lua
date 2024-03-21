-- Function to read effect keywords from effect-announcement-settings.xml
local function loadEffectKeywords()
    local effectKeywords = {
        buffs = {},
        debuffs = {}
    }
    local file = io.open(windower.addon_path..'settings/effect-announcement-settings.xml', "r") -- Changed file path here
    if file then
        local contents = file:read("*all")
        file:close()
        -- Iterate through buffs
        for buff in contents:gmatch("<buffs>(.-)</buffs>") do
            for effect in buff:gmatch("<effect>(.-)</effect>") do
                table.insert(effectKeywords.buffs, effect)
            end
        end
        -- Iterate through debuffs
        for debuff in contents:gmatch("<debuffs>(.-)</debuffs>") do
            for effect in debuff:gmatch("<effect>(.-)</effect>") do
                table.insert(effectKeywords.debuffs, effect)
            end
        end
    end
    return effectKeywords
end

-- Load effect keywords
local effectKeywords = loadEffectKeywords()

windower.register_event('incoming text', function(original, modified, mode)
    local chat = original
    local chatMode = mode
    
    -- Check if the incoming text is from the combat log (mode 20 or higher) and not in party chat (mode 5)
    if chatMode >= 20 then
        -- Convert chat to a string if it's not already
        chat = tostring(chat)
        
        -- Check if the incoming text contains either "effect wears off" or "no longer"
        if string.lower(chat):find("effect wears off") or string.lower(chat):find("no longer") then
            -- Iterate through the effect keywords (buffs)
            for _, buffKeyword in ipairs(effectKeywords.buffs) do
                -- Check if the keyword is present in the incoming text
                if string.find(string.lower(chat), buffKeyword) then
                    -- Code to execute when one of the buff keywords is found
                    
                    -- Send a party message with the chat text and "<call14>"
                    windower.send_command('@input /p ' .. chat .. ' <call14>')
                    
                    -- Additional code for actions after the effect wears off can go here
                    
                    -- Exit the loop since we found a match
                    return
                end
            end
            -- Iterate through the effect keywords (debuffs)
            for _, debuffKeyword in ipairs(effectKeywords.debuffs) do
                -- Check if the keyword is present in the incoming text
                if string.find(string.lower(chat), debuffKeyword) then
                    -- Code to execute when one of the debuff keywords is found
                    
                    -- Send a party message with the chat text and "<call14>"
                    windower.send_command('@input /p ' .. chat .. ' <call14>')
                    
                    -- Additional code for actions after the effect wears off can go here
                    
                    -- Exit the loop since we found a match
                    return
                end
            end
        end
    end
end)

-- Function to read keywords and responses from events.xml
local function loadEventKeywords()
    local eventKeywords = {}
    local file = io.open(windower.addon_path..'settings/events.xml', "r")
    if file then
        local contents = file:read("*all")
        file:close()
        -- Iterate through each <event> block in the XML
        for event in contents:gmatch("<event>(.-)</event>") do
            local keyword = event:match("<keyword>(.-)</keyword>")
            local response = event:match("<response>(.-)</response>")
            if keyword and response then
                -- Store the keyword in lowercase
                eventKeywords[string.lower(keyword)] = response
            end
        end
    end
    return eventKeywords
end

-- Load event keywords and responses
local eventKeywords = loadEventKeywords()

windower.register_event('incoming text', function(original, modified, mode)
    local chat = original
    local chatMode = mode
    
    -- Check if the incoming text is from the combat log (mode 20 or higher) and not in party chat (mode 5)
    if chatMode >= 20 then
        -- Convert chat to a string if it's not already
        chat = tostring(chat)
        
        -- Check for specific keywords in the combat log
        for keyword, response in pairs(eventKeywords) do
            -- Make the comparison case-insensitive
            if string.find(string.lower(chat), keyword) then
                -- Code to execute when one of the specific keywords is found
                
                -- Send a party message with the corresponding response
                windower.send_command('@input /p ' .. response)
                
                -- Additional code for actions after finding a specific keyword can go here
                
                -- Exit the loop since we found a match
                return
            end
        end
    end
end)







