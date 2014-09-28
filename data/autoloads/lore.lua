-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.


newLore {
	id = 'grayswandir-illusion-intro',
	category = 'start',
	name = 'Gray\'s Illusions Notes',
	start = true,
	always_pop = true,
	lore = [[
#{bold}#Illusory Woods#{normal}#
New area near Zigur. Recommended level is 18.
Useful Stuff to have: High mental save, a mental status clear, some sort of tracking method.

#{bold}#Antiperception#{normal}#
Certain creatures have #{italic}#antiperception#{normal}#, which causes them to either be invisible or look like something else entirely. Antiperception power is generally equal to mindpower, but can be higher or lower based on other attributes. It is resisted with mind save. Taking damage from something with #{italic}#antiperception#{normal}# will give you a temporary 'memory' bonus, decreasing their effective antiperception power for you by (your rank * % life lost). Past 100% you start to get less memory bonus from the same amount of damage.

#{bold}#Displacement#{normal}#
Displacement causes enemies to think that you're on a different tile than you are, based on your difference from them. So a displacement of 50% will make an enemy 6 spaces away think you're on a random space within 3 spaces of your true position. The tile chosen is uniformly picked from all points in the circle.

#{bold}#Illusion Damage Type#{normal}#
Like mind damage, but on a succesful save deals no damage instead of half.]],}

newLore {
	id = 'grayswandir-hidden-one-1',
	category = 'hidden-one',
	name = 'Letter of Introduction',
	lore = [[To my friends and fellow protectors of nature:

The bearer of this letter is the young Roerl. You must begin training him in our ways immediately! Do not be fooled by his passive demeanour - for his age, he is exceedingly cunning and sly. In time he will surely be a powerful force against the dark arts. Already he has done nature a great service.

I am sure you are aware of my work, nipping at the heels and frustrating the efforts of those whose perversions of nature have made them too powerul to confront directly. But this child has accomplished more in a single night than I have in years! At the time, there was a very powerful alchemist who was subjecting the town to his deprevations. The clever rogue had somehow managed to sneak his way into the mage's inner sanctum, and was just leaving with much of the alchemist's ill-gotten gains when he ran into the alchemist himself. The alchemist, in a blind rage, unleashed every arcane contraption and foul invocation that he had upon the child. Only one blessed by nature could have escaped that fury with as few wounds as he did. Certainly, he came out better than the town did.

Lacking my keen eye, the (remaining) villagers did not see Roerl sneaking away from the carnage - they only saw, at last, the alchemist's insanity for what it truly was. True, half the village burned down, and at least as many villagers, but those who live now have a renewed understanding of just how terrible all magic really is.

It is my regret to report that the alchemist did manage to escape in the end - both the angry mob and my silent blade. For now, I must be content in the knowledge the alchemist's dark designs were at the very least disrupted. Tracking down Roerl, I explained this to him - how proud he must be, to fight so nobly against the mages, to have his face known to them as one of nature's protectors! Those very same mages who, through their wicked divinations could track down those who anger them no matter where they hide.

When I suggested that, through dedication to nature and training, he could learn from us how to guard himself against these magic users, he quite readily agreed.

Too often those of our more, shadowy, disposition find themselves tempted by the foul powers of magic. But this one is yet clean! I implore you, train him, hard and well. Make no allowances, for nature's need is great, and Reorl is quite #{italic}#dedicated#{normal}# to our cause.

-- Sister Leskas]],}

newLore {
	id = 'grayswandir-hidden-one-2',
	category = 'hidden-one',
	name = 'Experiment Log',
	lore = [[#{italic}#Subject 22#{normal}#
I finally got my hands on one of those wolves! Out of all the creatures from that insane place, the wolves are the hardest to #{italic}#perceive#{normal}#. It's all thanks to the efforts of the talented Brother Roerl. He fully shares my vision - to learn how to hide ourselves from the eyes of mages, just as the creatures in that wood do through nature's blessing.

As for the results - the potency was remarkably improved. I could barely let my eyes rest on the woman. She still seemed to go as mad as the rest, however. I do wish there was some way to bind them from magic without cutting out their tongue - it is hard to gauge the effects when they can't answer questions. Measuring the volume of the screams can only take you so far.

#{italic}#Subject 23#{normal}#
Brother Roerl brought me another one of those so-called "paladins" today - it bewilders me how such a foul creature can be so trusting. This batch seems much more promising - it had about the same potency, and the subject's behaviour barely changed after administering it.

Also of note, several doses of the solution went missing today. Perhaps brother Roerl...? No, it was probably just somebody looking for a novel way to cleanse one of the captured mages. I'll have to start keeping them under tighter lock.]],}

newLore {
	id = 'grayswandir-hidden-one-3',
	category = 'hidden-one',
	name = 'scrap of paper',
	bloodstains = 3,
	lore = [[... will be the second search party for those who have gone missing, starting with Brother Roerl. May we ...]],}
