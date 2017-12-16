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
Charlie was born on Venus (rich high_population garden high_tech)
Description
===
         Name: Charlie
       Gender: M
          Age: 18
   Appearance: medium frizzed silver neck hair with blue skin
         Plot: Supplication
  Temperament: Provider

Characteristics
===
       Strength: 8
      Dexterity: 11
      Endurance: 6
   Intelligence: 6
      Education: 11
  Social_status: 6

Education 11 provides up to 4 background skills
Choose background skill:  (Carouse | Gambler | Profession | Art | Streetwise | Animals | Astrogation | Electronics)
> Astrogation
Choose background skill:  (Carouse | Gambler | Profession | Art | Streetwise | Animals | Electronics)
> Animals
Choose background skill:  (Carouse | Gambler | Profession | Art | Streetwise | Electronics)
> Art
Choose background skill:  (Carouse | Gambler | Profession | Streetwise | Electronics)
> Electronics
Background skill: Astrogation 0
Background skill: Animals 0
Background skill: Art 0
Background skill: Electronics 0

Description
===
    Name: Charlie
  Gender: M
     Age: 18

Characteristics
===
       Strength: 8
      Dexterity: 11
      Endurance: 6
   Intelligence: 6
      Education: 11
  Social_status: 6

Skills
===
         Astrogation: 0
[Animals]
          - Handling: 0
        - Veterinary: 0
          - Training: 0
[Art]
         - Performer: 0
        - Holography: 0
        - Instrument: 0
      - Visual Media: 0
             - Write: 0
[Electronics]
             - Comms: 0
         - Computers: 0
        - Remote Ops: 0
           - Sensors: 0

Initiated new career path
Choose a career:  (Agent | Army | Citizen | Entertainer | Marines | Merchant | Navy | Noble | Rogue | Scholar | Scout)
> Marines
Marines qualification: endurance 6+
Qualify check: rolled 9 (DM 0) against 6
Qualified for Marines
Entering new career: Marines
Choose assignment:  (Support | Star Marine | Ground Assault)
> Star Marine
Awarded rank title: Marine
Choose rank bonus:  (Gun Combat 1 | Melee:Blade 1)
> Gun Combat 1
Achieved rank bonus: Gun Combat 1
Choose Gun Combat specialty:  (Archaic | Energy | Slug)
> Energy
Basic Training: Athletics 0
Basic Training: Vacc Suit 0
Basic Training: Tactics 0
Basic Training: Heavy Weapons 0
Basic Training: Stealth 0
Marines term 1 started, age 18
Choose skills regimen:  (Personal | Service | Specialist | Advanced)
> Service
Service training roll (d6): 2 (DM 0)
Trained Vacc Suit +1
Marines [Star Marine] survival: endurance 6+
Survival check: rolled 8 (DM 0) against 6
Marines term 1 completed successfully.
Marines commission: social_status 8
Commission check: rolled 3 (DM 0) against 8
Commission was rejected
Marines [Star Marine] advancement: education 6+
Advancement check: rolled 6 (DM 1) against 6
Advanced career to rank 1
Awarded rank title: Lance Corporal
Achieved rank bonus: Gun Combat 1
Choose Gun Combat specialty:  (Archaic | Slug)
> Archaic
Choose skills regimen:  (Personal | Service | Specialist | Advanced)
> Personal
Personal training roll (d6): 6 (DM 0)
Trained Melee:Blade +1
Event roll (2d6): 3 (DM 0)
Event: Event 3
Muster out?  (yes | no)
> yes
Muster out: Marines
Muster out: Career in good standing; collect all benefits
Muster roll (d6): 5 (DM 0)
Cash roll #1: 20000 credits
Muster roll (d6): 5 (DM 0)
Career benefit: TAS Membership
Muster roll (d6): 2 (DM 0)
Career benefit: intelligence bump to 7

Description
===
    Name: Charlie
  Gender: M
     Age: 22

Characteristics
===
       Strength: 8
      Dexterity: 11
      Endurance: 6
   Intelligence: 7
      Education: 11
  Social_status: 6

Skills
===
         Astrogation: 0
           Vacc Suit: 1
             Stealth: 0
[Animals]
          - Handling: 0
        - Veterinary: 0
          - Training: 0
[Art]
         - Performer: 0
        - Holography: 0
        - Instrument: 0
      - Visual Media: 0
             - Write: 0
[Electronics]
             - Comms: 0
         - Computers: 0
        - Remote Ops: 0
           - Sensors: 0
[Gun Combat]
           - Archaic: 1
            - Energy: 1
              - Slug: 0
[Athletics]
         - Dexterity: 0
         - Endurance: 0
          - Strength: 0
[Tactics]
          - Military: 0
             - Naval: 0
[Heavy Weapons]
         - Artillery: 0
      - Man Portable: 0
           - Vehicle: 0
[Melee]
             - Blade: 1
          - Bludgeon: 0
           - Natural: 0
           - Unarmed: 0

Stuff
===
  TAS Membership: 1

Credits
===
       Total: 20000
  Cash Rolls: 1


Career: Marines
===
           Term: 1
         Status: Finished
      Specialty: Star Marine
          Title: Lance Corporal
           Rank: 1

Exit career mode?  (yes | no)
> no
Choose a career:  (Agent | Army | Citizen | Entertainer | Merchant | Navy | Noble | Rogue | Scholar | Scout)
> Army
Army qualification: endurance 5+
Qualify check: rolled 3 (DM -1) against 5
Did not qualify for Army
Choose fallback:  (Drifter | Draft)
> Draft
Draft roll (d6): 6 (DM 0)
Drafted: Agent, Law Enforcement
Entering new career: Agent
Awarded rank title: Rookie
Choose skill:  (Streetwise | Drive | Investigate | Flyer | Recon)
> Flyer
Basic Training: Flyer 0
Agent term 1 started, age 22
Choose skills regimen:  (Personal | Service | Specialist | Advanced)
> Specialist
Specialist training roll (d6): 6 (DM 0)
Trained Advocate +1
Agent [Law Enforcement] survival: endurance 6+
Survival check: rolled 10 (DM 0) against 6
Agent term 1 completed successfully.
Agent [Law Enforcement] advancement: intelligence 6+
Advancement check: rolled 9 (DM 0) against 6
Advanced career to rank 1
Awarded rank title: Corporal
Achieved rank bonus: Streetwise 1
Choose skills regimen:  (Personal | Service | Specialist | Advanced)
> Specialist
Specialist training roll (d6): 5 (DM 0)
Choose Melee specialty:  (Blade | Bludgeon | Natural | Unarmed)
> Bludgeon
Trained Melee +1
Event roll (2d6): 3 (DM 0)
Event: An investigation takes on a dangerous turn.  Roll Investigate 8+ or Streetwise 8+. If you fail, roll on the  Mishap Table.  If you succeed, increase one skill of Deception, Jack-of-all-Trades, Persuade, or Tactics.
Muster out?  (yes | no)
> no
Agent term 2 started, age 26
Choose skills regimen:  (Personal | Service | Specialist | Advanced)
> Advanced
Advanced training roll (d6): 3 (DM 0)
Trained Explosives +1
Agent [Law Enforcement] survival: endurance 6+
Survival check: rolled 6 (DM 0) against 6
Agent term 2 completed successfully.
Agent [Law Enforcement] advancement: intelligence 6+
Advancement check: rolled 4 (DM 0) against 6
Event roll (2d6): 6 (DM 0)
Event: You are given advanced training in a specialist field. Roll EDU 8+ to increase any existing skill by 1
Muster out?  (yes | no)
> no
Agent term 3 started, age 30
Choose skills regimen:  (Personal | Service | Specialist | Advanced)
> Service
Service training roll (d6): 5 (DM 0)
Trained Recon +1
Agent [Law Enforcement] survival: endurance 6+
Survival check: rolled 7 (DM 0) against 6
Agent term 3 completed successfully.
Agent [Law Enforcement] advancement: intelligence 6+
Advancement check: rolled 12 (DM 0) against 6
Advanced career to rank 2
Awarded rank title: Sergeant
Choose skills regimen:  (Personal | Service | Specialist | Advanced)
> Personal
Personal training roll (d6): 5 (DM 0)
Trained intelligence +1
Event roll (2d6): 3 (DM 0)
Event: An investigation takes on a dangerous turn.  Roll Investigate 8+ or Streetwise 8+. If you fail, roll on the  Mishap Table.  If you succeed, increase one skill of Deception, Jack-of-all-Trades, Persuade, or Tactics.
Agent term 4 started, age 34
Choose skills regimen:  (Personal | Service | Specialist | Advanced)
> Advanced
Advanced training roll (d6): 5 (DM 0)
Trained Vacc Suit +1
Agent [Law Enforcement] survival: endurance 6+
Survival check: rolled 4 (DM 0) against 6
Agent career ended with a mishap after 3 years.
Mishap roll (d6): 6 (DM 0)
Mishap: Injured. Roll on the Injury table.
Muster out: Agent
Muster out: Career ended early; lose last term benefit
Muster roll (d6): 4 (DM 0)
Cash roll #2: 7500 credits
Muster roll (d6): 4 (DM 0)
Cash roll #3: 7500 credits
Muster roll (d6): 5 (DM 0)
Career benefit: Combat Implant
Muster roll (d6): 5 (DM 0)
Career benefit: Combat Implant
Muster roll (d6): 5 (DM 0)
Career benefit: Combat Implant
Muster roll (d6): 2 (DM 0)
Career benefit: intelligence bump to 9

Description
===
    Name: Charlie
  Gender: M
     Age: 37

Characteristics
===
       Strength: 8
      Dexterity: 11
      Endurance: 6
   Intelligence: 9
      Education: 11
  Social_status: 6

Skills
===
         Astrogation: 0
           Vacc Suit: 2
             Stealth: 0
            Advocate: 1
          Streetwise: 1
          Explosives: 1
               Recon: 1
[Animals]
          - Handling: 0
        - Veterinary: 0
          - Training: 0
[Art]
         - Performer: 0
        - Holography: 0
        - Instrument: 0
      - Visual Media: 0
             - Write: 0
[Electronics]
             - Comms: 0
         - Computers: 0
        - Remote Ops: 0
           - Sensors: 0
[Gun Combat]
           - Archaic: 1
            - Energy: 1
              - Slug: 0
[Athletics]
         - Dexterity: 0
         - Endurance: 0
          - Strength: 0
[Tactics]
          - Military: 0
             - Naval: 0
[Heavy Weapons]
         - Artillery: 0
      - Man Portable: 0
           - Vehicle: 0
[Melee]
             - Blade: 1
          - Bludgeon: 1
           - Natural: 0
           - Unarmed: 0
[Flyer]
           - Airship: 0
              - Grav: 0
       - Ornithopter: 0
             - Rotor: 0
              - Wing: 0

Stuff
===
  TAS Membership: 1
  Combat Implant: 3

Credits
===
       Total: 35000
  Cash Rolls: 3


Career: Marines
===
           Term: 1
         Status: Finished
      Specialty: Star Marine
          Title: Lance Corporal
           Rank: 1

Career: Agent
===
           Term: 4
         Status: Finished
      Specialty: Law Enforcement
          Title: Sergeant
           Rank: 2

Exit career mode?  (yes | no)
> yes

Charlie was born on Venus (rich high_population garden high_tech)
Education 11 provides up to 4 background skills
Background skill: Astrogation 0
Background skill: Animals 0
Background skill: Art 0
Background skill: Electronics 0
Initiated new career path
Marines qualification: endurance 6+
Qualified for Marines
Entering new career: Marines
Awarded rank title: Marine
Achieved rank bonus: Gun Combat 1
Basic Training: Athletics 0
Basic Training: Vacc Suit 0
Basic Training: Tactics 0
Basic Training: Heavy Weapons 0
Basic Training: Stealth 0
Marines term 1 started, age 18
Trained Vacc Suit +1
Marines [Star Marine] survival: endurance 6+
Marines term 1 completed successfully.
Marines commission: social_status 8
Commission was rejected
Marines [Star Marine] advancement: education 6+
Advanced career to rank 1
Awarded rank title: Lance Corporal
Achieved rank bonus: Gun Combat 1
Trained Melee:Blade +1
Event: Event 3
Muster out: Marines
Muster out: Career in good standing; collect all benefits
Cash roll #1: 20000 credits
Career benefit: TAS Membership
Career benefit: intelligence bump to 7
Army qualification: endurance 5+
Did not qualify for Army
Drafted: Agent, Law Enforcement
Entering new career: Agent
Awarded rank title: Rookie
Basic Training: Flyer 0
Agent term 1 started, age 22
Trained Advocate +1
Agent [Law Enforcement] survival: endurance 6+
Agent term 1 completed successfully.
Agent [Law Enforcement] advancement: intelligence 6+
Advanced career to rank 1
Awarded rank title: Corporal
Achieved rank bonus: Streetwise 1
Trained Melee +1
Event: An investigation takes on a dangerous turn.  Roll Investigate 8+ or Streetwise 8+. If you fail, roll on the  Mishap Table.  If you succeed, increase one skill of Deception, Jack-of-all-Trades, Persuade, or Tactics.
Agent term 2 started, age 26
Trained Explosives +1
Agent [Law Enforcement] survival: endurance 6+
Agent term 2 completed successfully.
Agent [Law Enforcement] advancement: intelligence 6+
Event: You are given advanced training in a specialist field. Roll EDU 8+ to increase any existing skill by 1
Agent term 3 started, age 30
Trained Recon +1
Agent [Law Enforcement] survival: endurance 6+
Agent term 3 completed successfully.
Agent [Law Enforcement] advancement: intelligence 6+
Advanced career to rank 2
Awarded rank title: Sergeant
Trained intelligence +1
Event: An investigation takes on a dangerous turn.  Roll Investigate 8+ or Streetwise 8+. If you fail, roll on the  Mishap Table.  If you succeed, increase one skill of Deception, Jack-of-all-Trades, Persuade, or Tactics.
Agent term 4 started, age 34
Trained Vacc Suit +1
Agent [Law Enforcement] survival: endurance 6+
Agent career ended with a mishap after 3 years.
Mishap: Injured. Roll on the Injury table.
Muster out: Agent
Muster out: Career ended early; lose last term benefit
Cash roll #2: 7500 credits
Cash roll #3: 7500 credits
Career benefit: Combat Implant
Career benefit: Combat Implant
Career benefit: Combat Implant
Career benefit: intelligence bump to 9
```
