local function loadEffectKeywords()
    local effectKeywords = {
        buffs = {},
        debuffs = {},
        Impact_Detection_Enabled = false -- Default value
    }
    local file = io.open(windower.addon_path..'settings/effect-announcement-settings.xml', "r")
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
        
        -- Read Impact Detection Enabled setting
        local enabled = contents:match("<Impact_Detection_Enabled>(.-)</Impact_Detection_Enabled>")
        if enabled then
            effectKeywords.Impact_Detection_Enabled = enabled == "true" -- Convert to boolean
        end
    end
    return effectKeywords
end

-- Load effect keywords
local effectKeywords = loadEffectKeywords()

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
            local responses = {}
            -- Find all response tags
            for response in event:gmatch("<response>(.-)</response>") do
                table.insert(responses, response)
            end
            if keyword and #responses > 0 then
                -- Store the keyword and responses
                eventKeywords[string.lower(keyword)] = responses
            end
        end
    end
    return eventKeywords
end

-- Load event keywords and responses
local eventKeywords = loadEventKeywords()

local attributeDetected = {
    agi = false,
    str = false,
    dex = false,
    vit = false,
    int = false,
    mnd = false,
    chr = false
}

windower.register_event('incoming text', function(original, modified, mode)
    local chat = original
    local chatMode = mode
    
    -- Check if the incoming text is from the combat log (mode 27 or higher) and not in party chat (mode 5)
    if chatMode >= 27 then
        -- Convert chat to a string if it's not already
        chat = tostring(chat)
        
        -- Check if the incoming text contains either "effect wears off" or "no longer"
        if string.lower(chat):find("effect wears off") or string.lower(chat):find("no longer") then
            -- Iterate through the effect keywords (buffs)
            for _, buffKeyword in ipairs(effectKeywords.buffs) do
                -- Check if the keyword is present in the incoming text
                if string.find(string.lower(chat), buffKeyword:lower()) then
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
				if string.find(string.lower(chat), debuffKeyword:lower()) then
					-- Check if the player's name is present in the text
					local playerName = windower.ffxi.get_player().name:lower()
					if not string.find(string.lower(chat), playerName) then
						-- Code to execute when one of the debuff keywords is found and the player's name is not in the text
						
						-- Send a party message with the chat text and "<call14>"
						windower.send_command('@input /p ' .. chat .. ' <call14>')
						
						-- Additional code for actions after the effect wears off can go here
						
						-- Exit the loop since we found a match
						return
					end
				end
			end
		end

		-- This checks the debuff Impact and alerts the party if it wears.
		if effectKeywords.Impact_Detection_Enabled then
			-- Check if the incoming text contains any of the specified attributes
			for attribute, _ in pairs(attributeDetected) do
				if string.find(string.lower(chat), attribute) then
					attributeDetected[attribute] = true
					-- Set a timer to reset the attribute detection after 3 seconds
					if not timer then
						timer = os.clock() + 3
					end
				end
			end
			
			-- Check if the timer has expired and reset attribute detection if necessary
			if timer and os.clock() > timer then
				for attribute, _ in pairs(attributeDetected) do
					attributeDetected[attribute] = false
				end
				timer = nil
			end

			-- Check if all attributes are detected
			local allAttributesDetected = true
			for _, detected in pairs(attributeDetected) do
				if not detected then
					allAttributesDetected = false
					break
				end
			end

			-- If all attributes are detected, trigger the action
			if allAttributesDetected then
				windower.send_command('@input /p Impact has worn off <call14>')
				-- Reset attribute detection
				for attribute, _ in pairs(attributeDetected) do
					attributeDetected[attribute] = false
				end
				timer = nil
			end
		end


        
        -- Check for specific keywords in the combat log (for other events)
        for keyword, responses in pairs(eventKeywords) do
            -- Make the comparison case-insensitive
            if string.find(string.lower(chat), string.lower(keyword)) then
				-- Execute each response in the responses table
				for _, response in ipairs(responses) do
					-- Check if the response contains a delay tag
					local delay = response:match("<delay>(.-)</delay>")
					if delay then
						-- Wait for the specified duration
						coroutine.sleep(tonumber(delay))
					else
						-- Send the response
						windower.send_command('@input ' .. response)
					end
				end
				-- Exit the loop since we found a match
				return
			end
        end
    end
end)