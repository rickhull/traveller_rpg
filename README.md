# Traveller RPG

This work was inspired by
https://github.com/LeamHall/CT_Character_Generator which is also the origin
for some of the `data/*.txt` files.  Most of the behavior is based on
information available from http://www.traveller-srd.com/core-rules

# Usage

```
git clone https://github.com/rickhull/traveller_rpg.git

cd traveller_rpg

rake chargen
```

## Sample output

```
Eris was born on Paragon (high_population poor vacuum fluid_oceans garden high_technology)
Education 8 qualifies for 3 skills
Choose a skill:  (streetwise animals vacc_suit seafarer computers)
> computers
Choose a skill:  (streetwise animals vacc_suit seafarer)
> vacc_suit
Choose a skill:  (streetwise animals seafarer)
> seafarer
Acquired background skill: computers 0
Acquired background skill: vacc_suit 0
Acquired background skill: seafarer 0
Initiated new career path
Choose a career  (Scout)
> Scout
Qualify DM is based on Intelligence 9
Qualify check: rolled 5 (DM 1) against 5
Qualified for Scout
Entering new career: Scout
Acquired basic training skill: pilot_small_craft 0
Acquired basic training skill: survival 0
Acquired basic training skill: mechanic 0
Acquired basic training skill: astrogation 0
Acquired basic training skill: comms 0
Acquired basic training skill: gun_combat_group 0
Scout term 1 started, age 18
Training roll (d6): 4
Choose training regimen:  (stats service specialist advanced)
> advanced
Trained advanced skill: computers 1
Survival check: rolled 9 (DM 0) against 6
Scout term 1 was successful
Apply for commission?  (yes no)
> no
Advancement check: rolled 5 (DM 0) against 9
Event roll: 11 (DM 0) = 11
You serve as a courier for an important message for the Imperium.  Gain one level of diplomat or take +4 DM to your next Advancement roll.
Muster out?  (yes no)
> no
Scout term 2 started, age 22
Training roll (d6): 1
Choose training regimen:  (stats service specialist advanced)
> advanced
Trained advanced skill: medic 1
Survival check: rolled 7 (DM 0) against 6
Scout term 2 was successful
Apply for commission?  (yes no)
> yes
Commission check: roll 7 (DM 0) against 9
Commission was rejected
Advancement check: rolled 7 (DM 0) against 9
Event roll: 9 (DM 0) = 9
You rescue disaster survivors.  Roll either Medic 8+ or Engineer 8+.  Gain a Contact and +2 DM on next Advancement roll or else gain an Enemy
Muster out?  (yes no)
> no
Scout term 3 started, age 26
Training roll (d6): 6
Choose training regimen:  (stats service specialist advanced)
> advanced
Trained advanced skill: jack_of_all_trades 1
Survival check: rolled 9 (DM 0) against 6
Scout term 3 was successful
Apply for commission?  (yes no)
> no
Advancement check: rolled 7 (DM 0) against 9
Event roll: 4 (DM 0) = 4
Survey an alien world.  Choose Animals, Survival, Recon, or Life Sciences 1
Muster out?  (yes no)
> no
Scout term 4 started, age 30
Training roll (d6): 1
Choose training regimen:  (stats service specialist advanced)
> advanced
Trained advanced skill: medic 2
Survival check: rolled 3 (DM 0) against 6
Scout career ended with a mishap!
Mishap roll (d6): 5
You have no idea what happened to you.  Your ship was found drifting on the fringes of friendly space




Career: Scout
===
    Term: 4
  Active: false
    Rank: 0
Benefits:
---
(none)



Description
===
                Name: Eris
              Gender: F
                 Age: 34

Characteristics
===
            Strength: 8
           Dexterity: 7
           Endurance: 7
        Intelligence: 9
           Education: 8
       Social Status: 6

Skills
===
           computers: 1
           vacc_suit: 0
            seafarer: 0
   pilot_small_craft: 0
            survival: 0
            mechanic: 0
         astrogation: 0
               comms: 0
    gun_combat_group: 0
               medic: 2
  jack_of_all_trades: 1

Stuff
===
(none)



Exit career mode?  (yes no)
> no
No eligible careers available!
DONE
```
