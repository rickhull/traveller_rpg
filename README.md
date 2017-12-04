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
Mowgli was born on Jupiter (asteroid high_population water_world fluid_oceans ice_capped)
Education 2 qualifies for 1 skills
Choose a skill:  (zero_g streetwise seafarer_group vacc_suit)
> seafarer_group
Acquired background skill: seafarer_group 0

Description
===
                Name: Mowgli
              Gender: M
                 Age: 18

Characteristics
===
            Strength: 10
           Dexterity: 5
           Endurance: 6
        Intelligence: 8
           Education: 2
       Social Status: 3

Skills
===
      seafarer_group: 0


Initiated new career path
Choose a career  (Scout Agent)
> Agent
Agent qualification: intelligence 6+
Qualify check: rolled 9 (DM 0) against 6
Qualified for Agent
Entering new career: Agent
Choose a specialty:  (law_enforcement intelligence corporate)
> intelligence
Acquired basic training skill: streetwise 0
Acquired basic training skill: drive_group 0
Acquired basic training skill: investigate 0
Acquired basic training skill: flyer_group 0
Acquired basic training skill: recon 0
Acquired basic training skill: gun_combat_group 0
Agent term 1 started, age 18
Choose skills regimen:  (personal service specialist)
> service
Training roll: 5
Trained recon to 1
Agent intelligence survival: intelligence 7+
Survival check: rolled 12 (DM 0) against 7
Agent term 1 completed successfully.
Agent intelligence advancement: intelligence 5+
Advancement check: rolled 7 (DM 0) against 5
Advanced career to rank 1
Awarded rank title: Corporal
Achieved rank skill: streetwise 1
Choose skills regimen:  (personal service specialist)
> personal
Training roll: 3
Trained endurance to 7
Event roll: 8 (DM 0) = 8
Undercover
Muster out?  (yes no)
> no
Agent term 2 started, age 22
Choose skills regimen:  (personal service specialist)
> specialist
Training roll: 1
Trained investigate to 1
Agent intelligence survival: intelligence 7+
Survival check: rolled 5 (DM 0) against 7
Agent career ended with a mishap after 4 years.
Mishap roll: 1
Severely injured in action.  Roll twice on the Injury table or take a level 2 Injury.
Muster out: Agent
Left career early -- lose benefit for last term
Cash roll: 5 (DM 0) = 5
Acquired 10000 credits from cash roll #1
Cash roll: 2 (DM 0) = 2
Acquired 2000 credits from cash roll #2
Benefits roll: 3 (DM 0) = 3
Acquired Ship Share as a career benefit
Retirement bonus: 0


Career: Agent
===
    Term: 2
  Active: false
    Rank: 1
   Title: Corporal


Description
===
                Name: Mowgli
              Gender: M
                 Age: 26

Characteristics
===
            Strength: 10
           Dexterity: 5
           Endurance: 7
        Intelligence: 8
           Education: 2
       Social Status: 3

Skills
===
      seafarer_group: 0
          streetwise: 1
         drive_group: 0
         investigate: 1
         flyer_group: 0
               recon: 1
    gun_combat_group: 0

Stuff
===
          Ship Share: 1

Credits
===
               Total: 12000
          Cash Rolls: 2



Exit career mode?  (yes no)
> no
Choose a career  (Scout)
> Scout
Scout qualification: intelligence 5+
Qualify check: rolled 9 (DM -1) against 5
Qualified for Scout
Entering new career: Scout
Choose a specialty:  (courier surveyor explorer)
> surveyor
Service skill  (pilot_small_craft survival mechanic astrogation comms)
> survival
Acquired basic training skill: survival 0
Scout term 1 started, age 26
Choose skills regimen:  (personal service specialist)
> specialist
Training roll: 4
Trained navigation to 1
Scout surveyor survival: endurance 6+
Survival check: rolled 10 (DM 0) against 6
Scout term 1 completed successfully.
Scout surveyor advancement: intelligence 8+
Advancement check: rolled 4 (DM 0) against 8
Event roll: 12 (DM 0) = 12
You make an important discovery for the Imperium.  Gain a career rank.
Muster out?  (yes no)
> no
Scout term 2 started, age 30
Choose skills regimen:  (personal service specialist)
> specialist
Training roll: 5
Trained diplomat to 1
Scout surveyor survival: endurance 6+
Survival check: rolled 4 (DM 0) against 6
Scout career ended with a mishap after 3 years.
Mishap roll: 1
Severely injured in action.  Roll twice on the Injury table or take a level 2 Injury.
Muster out: Scout
Left career early -- lose benefit for last term
Benefits roll: 5 (DM 0) = 5
Acquired Weapon as a career benefit
Retirement bonus: 0


Career: Scout
===
    Term: 2
  Active: false
    Rank: 0


Description
===
                Name: Mowgli
              Gender: M
                 Age: 33

Characteristics
===
            Strength: 10
           Dexterity: 5
           Endurance: 7
        Intelligence: 8
           Education: 2
       Social Status: 3

Skills
===
      seafarer_group: 0
          streetwise: 1
         drive_group: 0
         investigate: 1
         flyer_group: 0
               recon: 1
    gun_combat_group: 0
            survival: 0
          navigation: 1
            diplomat: 1

Stuff
===
          Ship Share: 1
              Weapon: 1

Credits
===
               Total: 12000
          Cash Rolls: 2



Exit career mode?  (yes no)
> yes
DONE
```
