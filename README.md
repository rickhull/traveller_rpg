# Traveller RPG

This work was inspired by
https://github.com/LeamHall/CT_Character_Generator which is also the origin
for some of the `data/*.txt` files.  Most of the behavior is based on
information available from http://www.traveller-srd.com/core-rules

# Usage

```
git clone https://github.com/rickhull/traveller_rpg.git

cd traveller_rpg

HUMAN=1 rake chargen
```

## Sample output

```
Frances was born on Europa (vacuum rich asteroid industrial)
Education 10 qualifies for 4 skills
Homeworld Europa only has 4 skills available
Acquired background skill: vacc_suit 0
Acquired background skill: carouse 0
Acquired background skill: zero_g 0
Acquired background skill: trade_group 0

Description
===
                Name: Frances
              Gender: F
                 Age: 18
          Appearance: full frizzed blue neck hair with medium skin
         Temperament: Promoter
                Plot: Madness

Characteristics
===
            Strength: 11
           Dexterity: 9
           Endurance: 10
        Intelligence: 7
           Education: 10
       Social Status: 2

Skills
===
           vacc_suit: 0
             carouse: 0
              zero_g: 0
         trade_group: 0

Initiated new career path
Choose a career:  (Agent  Army  Marines  Navy  Scout)
> Navy
Navy qualification: intelligence 6+
Qualify check: rolled 7 (DM 0) against 6
Qualified for Navy
Entering new career: Navy
Choose a specialty:  (line_crew  engineer_gunner  flight)
> engineer_gunner
Acquired basic training skill: pilot_group 0
Acquired basic training skill: athletics_group 0
Acquired basic training skill: gunner_group 0
Acquired basic training skill: mechanic 0
Acquired basic training skill: gun_combat_group 0
Navy term 1 started, age 18
Choose skills regimen:  (personal  service  specialist  advanced)
> advanced
Training roll: 5
Trained: navigation 1
Navy engineer_gunner survival: intelligence 6+
Survival check: rolled 8 (DM 0) against 6
Navy term 1 completed successfully.
Apply for commission?  (yes  no)
> no
Navy engineer_gunner advancement: education 6+
Advancement check: rolled 8 (DM 1) against 6
Advanced career to rank 1
Awarded rank title: Able Spacehand
Achieved rank skill: mechanic 1
Trained: mechanic 1
Choose skills regimen:  (personal  service  specialist  advanced)
> advanced
Training roll: 3
Trained: engineer_group 1
Event roll: 8 (DM 0) = 8
Event: 8
Muster out?  (yes  no)
> no
Navy term 2 started, age 22
Choose skills regimen:  (personal  service  specialist  advanced)
> personal
Training roll: 5
Trained: education 11
Navy engineer_gunner survival: intelligence 6+
Survival check: rolled 6 (DM 0) against 6
Navy term 2 completed successfully.
Apply for commission?  (yes  no)
> yes
Navy commission: social_status 8
Commission check: rolled 4 (DM -2) against 8
Commission was rejected
Navy engineer_gunner advancement: education 6+
Advancement check: rolled 8 (DM 1) against 6
Advanced career to rank 2
Awarded rank title: Petty Officer 3rd class
Achieved rank skill: vacc_suit 1
Trained: vacc_suit 1
Choose skills regimen:  (personal  service  specialist  advanced)
> specialist
Training roll: 1
Trained: engineer_group 2
Event roll: 7 (DM 0) = 7
Event: 7
Muster out?  (yes  no)
> yes
Muster out: Navy
Career is in good standing -- collect all benefits
Cash roll: 4 (DM 0) = 4
Acquired 10000 credits from cash roll #1
Cash roll: 6 (DM 0) = 6
Acquired 50000 credits from cash roll #2
Benefits roll: 5 (DM 0) = 5
Acquired TAS Membership as a career benefit
Benefits roll: 1 (DM 0) = 1
Acquired Personal Vehicle or Ship Share as a career benefit
Retirement bonus: 0

Description
===
                Name: Frances
              Gender: F
                 Age: 26

Characteristics
===
            Strength: 11
           Dexterity: 9
           Endurance: 10
        Intelligence: 7
           Education: 11
       Social Status: 2

Skills
===
           vacc_suit: 1
             carouse: 0
              zero_g: 0
         trade_group: 0
         pilot_group: 0
     athletics_group: 0
        gunner_group: 0
            mechanic: 1
    gun_combat_group: 0
          navigation: 1
      engineer_group: 2

Stuff
===
      TAS Membership: 1
Personal Vehicle or Ship Share: 1

Credits
===
               Total: 60000
          Cash Rolls: 2


Career: Navy
===
      Term: 2
    Active: false
 Specialty: Engineer_gunner
      Rank: 2
     Title: Petty Officer 3rd class

Exit career mode?  (yes  no)
> no
Choose a career:  (Agent  Army  Marines  Scout)
> Scout
Scout qualification: intelligence 5+
Qualify check: rolled 3 (DM -1) against 5
Did not qualify for Scout
Fallback career:  (drifter  draft)
> draft
Draft roll: 1
Drafted: Navy
Choose a specialty:  (line_crew  engineer_gunner  flight)
> flight
Navy term 1 started, age 26
Choose skills regimen:  (personal  service  specialist  advanced)
> advanced
Training roll: 2
Trained: astrogation 1
Navy flight survival: dexterity 7+
Survival check: rolled 8 (DM 1) against 7
Navy term 1 completed successfully.
Apply for commission?  (yes  no)
> yes
Navy commission: social_status 8
Commission check: rolled 6 (DM -2) against 8
Commission was rejected
Navy flight advancement: education 5+
Advancement check: rolled 12 (DM 1) against 5
Advanced career to rank 1
Awarded rank title: Able Spacehand
Achieved rank skill: mechanic 1
Train: mechanic is already 1
Trained: mechanic 1
Choose skills regimen:  (personal  service  specialist  advanced)
> advanced
Training roll: 6
Trained: admin 1
Event roll: 5 (DM 0) = 5
Event: 5
Navy term 2 started, age 30
Choose skills regimen:  (personal  service  specialist  advanced)
> personal
Training roll: 2
Trained: dexterity 10
Navy flight survival: dexterity 7+
Survival check: rolled 5 (DM 1) against 7
Navy career ended with a mishap after 4 years.
Mishap roll: 3
Mishap: 3
Muster out: Navy
Left career early -- lose benefit for last term
Cash roll: 3 (DM 0) = 3
Acquired 5000 credits from cash roll #3
Benefits roll: 4 (DM 0) = 4
Acquired Weapon as a career benefit
Retirement bonus: 0

Description
===
                Name: Frances
              Gender: F
                 Age: 34

Characteristics
===
            Strength: 11
           Dexterity: 10
           Endurance: 10
        Intelligence: 7
           Education: 11
       Social Status: 2

Skills
===
           vacc_suit: 1
             carouse: 0
              zero_g: 0
         trade_group: 0
         pilot_group: 0
     athletics_group: 0
        gunner_group: 0
            mechanic: 1
    gun_combat_group: 0
          navigation: 1
      engineer_group: 2
         astrogation: 1
               admin: 1

Stuff
===
      TAS Membership: 1
Personal Vehicle or Ship Share: 1
              Weapon: 1

Credits
===
               Total: 65000
          Cash Rolls: 3


Career: Navy
===
      Term: 2
    Active: false
 Specialty: Engineer_gunner
      Rank: 2
     Title: Petty Officer 3rd class

Career: Navy
===
      Term: 2
    Active: false
 Specialty: Flight
      Rank: 1
     Title: Able Spacehand

Exit career mode?  (yes  no)
> no
Choose a career:  (Agent  Army  Marines  Scout)
> Army
Army qualification: endurance 5+
Qualify check: rolled 7 (DM -3) against 5
Did not qualify for Army
Fallback career:  (drifter  draft)
> draft
Draft roll: 3
Drafted: Marines
Choose a specialty:  (support  star_marine  ground_assault)
> star_marine
Trained: gun_combat_group 1
Choose service skill:  (tactics_group  heavy_weapons_group  stealth)
> stealth
Acquired basic training skill: stealth 0
Marines term 1 started, age 34
Choose skills regimen:  (personal  service  specialist  advanced)
> advanced
Training roll: 3
Trained: explosives 1
Marines star_marine survival: endurance 6+
Survival check: rolled 7 (DM 1) against 6
Marines term 1 completed successfully.
Apply for commission?  (yes  no)
> yes
Marines commission: social_status 8
Commission check: rolled 11 (DM -2) against 8
Became an officer!
Advanced career to officer rank 1
Awarded officer rank title: Lieutenant
Achieved officer rank skill: leadership 1
Trained: leadership 1
Marines star_marine advancement: education 6+
Advancement check: rolled 11 (DM 1) against 6
Advanced career to officer rank 2
Awarded officer rank title: Captain
Choose skills regimen:  (personal  service  specialist  advanced  officer)
> officer
Training roll: 5
Trained: vacc_suit 2
Event roll: 10 (DM 0) = 10
Event: 10
Muster out?  (yes  no)
> no
Marines term 2 started, age 38
Choose skills regimen:  (personal  service  specialist  advanced  officer)
> service
Training roll: 5
Trained: gun_combat_group 2
Marines star_marine survival: endurance 6+
Survival check: rolled 3 (DM 1) against 6
Marines career ended with a mishap after 4 years.
Mishap roll: 3
Mishap: 3
Muster out: Marines
Left career early -- lose benefit for last term
Benefits roll: 6 (DM 0) = 6
Acquired Armour or END +1 as a career benefit
Retirement bonus: 0

Description
===
                Name: Frances
              Gender: F
                 Age: 42

Characteristics
===
            Strength: 11
           Dexterity: 10
           Endurance: 10
        Intelligence: 7
           Education: 11
       Social Status: 2

Skills
===
           vacc_suit: 2
             carouse: 0
              zero_g: 0
         trade_group: 0
         pilot_group: 0
     athletics_group: 0
        gunner_group: 0
            mechanic: 1
    gun_combat_group: 2
          navigation: 1
      engineer_group: 2
         astrogation: 1
               admin: 1
             stealth: 0
          explosives: 1
          leadership: 1

Stuff
===
      TAS Membership: 1
Personal Vehicle or Ship Share: 1
              Weapon: 1
    Armour or END +1: 1

Credits
===
               Total: 65000
          Cash Rolls: 3


Career: Navy
===
      Term: 2
    Active: false
 Specialty: Engineer_gunner
      Rank: 2
     Title: Petty Officer 3rd class

Career: Navy
===
      Term: 2
    Active: false
 Specialty: Flight
      Rank: 1
     Title: Able Spacehand

Career: Marines
===
      Term: 2
    Active: false
 Specialty: Star_marine
Officer Rank: 2
      Rank: 0
     Title: Captain

Exit career mode?  (yes  no)
> yes

```
