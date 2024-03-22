if you wish to add buffs or debuffs to check for and alert in party chat when they wear off then here is examples of that

    <buffs>
		<effect>haste</effect>
    </buffs>
    <debuffs>
        <effect>paralyze</effect>
        <effect>slow</effect>
    </debuffs>

if you wish to have an event to trigger a response that you want then use this example

	<event>
		<keyword>bane of tartarus</keyword>
		<response>/p  STOP NUKING <call14> </response>
	</event>
	
if you want to have multiple responses to an event then use this example 

	<event>
		<keyword>bane of tartarus</keyword>
		<response>/p  STOP NUKING <call14> </response>
		<response>/ja "Saboteur" <me> </response>
		<response><delay>3</delay></response>
		<response>/ma "Sleep II" <bt> </response>
	</event>
	
the Delay line is calculated in seconds adjust accordingly