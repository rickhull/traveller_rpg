require 'traveller_rpg'
require 'traveller_rpg/career'

module TravellerRPG
  class Agent < Career
    QUALIFICATION   = [:intelligence, 6]
    ADVANCED_EDUCATION = 8
    PERSONAL_SKILLS = ['Gun Combat', :dexterity, :endurance,
                       'Melee', :intelligence, 'Athletics']
    SERVICE_SKILLS  = ['Streetwise', 'Drive', 'Investigate',
                       'Flyer', 'Recon', 'Gun Combat']
    ADVANCED_SKILLS = ['Advocate', 'Language', 'Explosives',
                       'Medic', 'Vacc Suit', 'Electronics']
    RANKS = {
      1 => ['Agent', 'Deception', 1],
      2 => ['Field Agent', 'Investigate', 1],
      4 => ['Special Agent', 'Gun Combat', 1],
      5 => ['Assistant Director'],
      6 => ['Director'],
    }
    SPECIALIST = {
      law_enforcement: {
        skills:   ['Investigate', 'Recon', 'Streetwise',
                   'Stealth', :melee, 'Advocate'],
        survival: [:endurance, 6],
        advancement: [:intelligence, 6],
        ranks: {
          0 => ['Rookie'],
          1 => ['Corporal', 'Streetwise', 1],
          2 => ['Sergeant'],
          3 => ['Detective'],
          4 => ['Lieutenant', 'Investigate', 1],
          5 => ['Chief', 'Admin', 1],
          6 => ['Commissioner', :social_status],
        },
      },
      intelligence: {
        skills: ['Investigate', 'Recon', 'Electronics:Comms',
                 'Stealth', 'Persuade', 'Deception'],
        survival: [:intelligence, 7],
        advancement: [:intelligence, 5],
        ranks: RANKS,
      },
      corporate: {
        skills: ['Investigate', 'Electronics:Computers', 'Stealth',
                 'Carouse', 'Deception', 'Streetwise'],
        survival: [:intelligence, 5],
        advancement: [:intelligence, 7],
        ranks: RANKS,
      },
    }

    MUSTER_OUT = {
      1 => [1000, 'Scientific Equipment'],
      2 => [2000, 'INT +1'],
      3 => [5000, 'Ship Share'],
      4 => [7500, 'Weapon'],
      5 => [10000, 'Combat Implant'],
      6 => [25000, 'SOC +1 or Combat Implant'],
      7 => [50000, 'TAS Membership'],
    }

    EVENTS = {
      2 => 'Disaster! Roll on the Mishap Table, but you are not ejected ' +
           'from this career.',
      3 => 'An investigation takes on a dangerous turn.  Roll ' +
           'Investigate 8+ or Streetwise 8+. If you fail, roll on the ' +
           'Mishap Table.  If you suceed, increase one skill of ' +
           'Deception, Jack-of-all-Trades, Persuade, or Tactics.',
      4 => 'You complete a mission for your superiors, and are suitably ' +
           'rewarded.  Gain DM+1 to any one Benefit Roll from this career.',
      5 => 'You establish a network of contacts.  Gain d3 Contacts.',
      6 => 'You are given advanced training in a specialist field. Roll ' +\
           'EDU 8+ to increase any existing skill by 1.',
      7 => 'Life Event. Roll on the Live Events Table.',
      8 => 'You go undercover to investigate an enemy.  Roll Deception 8+.' +
           'If you succeed, roll immediately on the Rogue or Citizen Events ' +
           'Table and make one roll on any Specialist skill table for that ' +
           'career. If you fail, roll immediately on the Rogue or Citizen ' +
           'Mishap Table',
      9 => 'You go above and beyond the call of duty.  Gain DM+2 to your ' +
           'next Advancement check',
      10 => 'You are given spcialist training in vehicles.  Gain one of ' +
            'Drive 1, Flyer 1, Pilot 1, or Gunner 1.',
      11 => 'You are befriended by a senior agent. Either increase ' +
            'Investigate by 1 or DM+4 to an Advancement roll thanks to ' +
            'their aid.',
      12 => 'Your efforts uncover a major conspiracy against your ' +
            'employers. You are automatically promoted.',
    }

    MISHAPS = {
      1 => 'Severely injured in action.  Roll twice on the Injury table ' +
           'or take a level 2 Injury.',
      2 => 'A criminal offers you a deal.  Accept the deal to leave career; ' +
           'Refuse, and you must roll twice on the Injury Table and take ' +
           'the lower result.  Gain an Enemy and one level in any skill.',
      3 => 'An investigation goes critically wrong, ruining your career. ' +
           'Roll Advocate 8+; Succeed == keep benefit this term; ' +
           'Fail, lost benefit as normal.  A roll of 2 mandates ' +
           'Prisoner career next term',
      4 => 'You learn something you should not know, and people want to ' +
           'kill you for it.  Gain an Enemy and Deception 1',
      5 => 'Your work comes home with you, and someone gets hurt. ' +
           'Choose a Contact, Ally, or Family Member, and roll twice on the ' +
           'Injury Table for them, taking the lower result.',
      6 => 'Injured. Roll on the Injury table.',
    }

  end

  class Citizen < Career; end

  class Drifter < Career
    # QUALIFICATION = [:intelligence, 0]
    ADVANCED_EDUCATION = 99
    PERSONAL_SKILLS = [:strength, :endurance, :dexterity,
                       'Language', 'Profession', 'Jack Of All Trades']
    SERVICE_SKILLS = ['Athletics', 'Melee:Unarmed', 'Recon',
                      'Streetwise', 'Stealth', 'Survival']
    ADVANCED_SKILLS = []
    SPECIALIST = {
      barbarian: {
        skills: ['Animals', 'Carouse', 'Melee:Blade', 'Stealth',
                 ['Seafarer:Personal', 'Seafarer:Sails'], 'Survival'],
        survival: [:endurance, 7],
        advancement: [:strength, 7],
        ranks: {
          1 => [nil, 'Survival', 1],
          2 => ['Warrior', 'Melee:Blade', 1],
          4 => ['Chieftain', 'Leadership', 1],
          6 => ['Warlord', nil, nil],
        },
      },
      wanderer: {
        skills: ['Drive', 'Deception', 'Recon',
                 'Stealth', 'Streetwise', 'Survival'],
        survival: [:endurance, 7],
        advancement: [:intelligence, 7],
        ranks: {
          1 => [nil, 'Streetwise', 1],
          3 => [nil, 'Deception', 1],
        },
      },
      scavenger: {
        skills: ['Pilot:Small Craft', 'Mechanic', 'Astrogation',
                 'Vacc Suit', 'Engineer', 'Gun Combat'],
        survival: [:dexterity, 7],
        advancement: [:endurance, 7],
        ranks: {
          1 => [nil, 'Vacc Suit', 1],
          3 => [nil, 'Mechanic', 1],
        },
      },
    }

    MUSTER_OUT = {
      1 => [0, 'Contact'],
      2 => [0, 'Weapon'],
      3 => [1000, 'Ally'],
      4 => [2000, 'Weapon'],
      5 => [3000, 'EDU +1'],
      6 => [4000, 'Ship Share'],
      7 => [8000, 'Ship Share x2'],
    }

    def qualify_check?(dm: 0)
      true
    end
  end

  class Entertainer < Career; end
  class Merchant < Career; end
  class Rogue < Career; end
  class Scholar < Career; end

  class Scout < Career
    QUALIFICATION   = [:intelligence, 5]
    ADVANCED_EDUCATION = 8
    PERSONAL_SKILLS = [:strength, :dexterity, :endurance,
                       :intelligence, :education, 'Jack Of All Trades']
    SERVICE_SKILLS  = [['Pilot:Small Craft', 'Pilot:Spacecraft'], 'Survival',
                       'Mechanic', 'Astrogation', 'Vacc Suit', 'Gun Combat']
    ADVANCED_SKILLS = ['Medic', 'Navigation', 'Engineer',
                       'Explosives', 'Science', 'Jack Of All Trades']

    RANKS = {
      1 => ['Scout', 'Vacc Suit', 1],
      3 => ['Senior Scout', 'Pilot', 1],
    }

    SPECIALIST = {
      courier: {
        skills:   ['Electronics', 'Flyer', 'Pilot:Spacecraft',
                   'Engineer', 'Athletics', 'Astrogation'],
        survival: [:endurance, 5],
        advancement: [:education, 9],
        ranks: RANKS,
      },
      surveyor: {
        skills: ['Electronics', 'Persuade', 'Pilot',
                 'Navigation', 'Diplomat', 'Streetwise'],
        survival: [:endurance, 6],
        advancement: [:intelligence, 8],
        ranks: RANKS,
      },
      explorer: {
        skills: ['Electronics', 'Pilot', 'Engineer',
                 'Science', 'Stealth', 'Recon'],
        survival: [:endurance, 7],
        advancement: [:education, 7],
        ranks: RANKS,
      },
    }

    MUSTER_OUT = {
      1 => [20000, 'Ship Share'],
      2 => [20000, 'INT +1'],
      3 => [30000, 'EDU +1'],
      4 => [30000, 'Weapon'],
      5 => [50000, 'Weapon'],
      6 => [50000, 'Scout Ship'],
      7 => [50000, 'Scout Ship'],
    }

    # Weapon: Select any weapon up to 1000 creds and TL12
    # If this benefit is rolled more than once, take a different weapon
    # or one level in the appropriate Melee or Gun Combat skill

    # Scout Ship: Receive a scout ship in exchange for performing periodic
    #             scout missions

    # Ship share: Accumulate these to redeem for a ship.  They are worth
    #             roughly 1M creds but cannot be redeemed for creds.


    EVENTS = {
      2 => 'Disaster! Roll on the mishap table but you are not ejected ' +
           'from career.',
      3 => 'Ambush! Choose Pilot 8+ to escape or Persuade 10+ to bargain. ' +
           'Gain an Enemy either way',
      4 => 'Survey an alien world.  Choose Animals, Survival, Recon, or ' +
           'Life Sciences 1',
      5 => 'You perform an exemplary service.  Gain a benefit roll with +1 DM',
      6 => 'You spend several years exploring the star system; ' +
           'Choose Atrogation, Navigation, Pilot (small craft) or Mechanic 1',
      7 => 'Life event.  Roll on the Life Events table',
      8 => 'Gathered intelligence on an alien race.  Roll Sensors 8+ or ' +
           'Deception 8+.  Gain an ally in the Imperium and +2 DM to your ' +
           'next Advancement roll on success.  Roll on the mishap table on ' +
           'failure, but you are not ejected from career.',
      9 => 'You rescue disaster survivors.  Roll either Medic 8+ or ' +
           'Engineer 8+.  Gain a Contact and +2 DM on next Advancement roll ' +
           'or else gain an Enemy',
      10 => 'You spend a great deal of time on the fringes of known space. ' +
            'Roll Survival 8+ or Pilot 8+.  Gain a Contact in an alien race ' +
            'and one level in any skill, or else roll on the Mishap table.',
      11 => 'You serve as a courier for an important message for the ' +
            'Imperium.  Gain one level of diplomat or take +4 DM to your ' +
            'next Advancement roll.',
      12 => 'You make an important discovery for the Imperium.  Gain a ' +
            'career rank.',
    }

    MISHAPS = {
      1 => 'Severely injured in action.  Roll twice on the Injury table ' +
           'or take a level 2 Injury.',
      2 => 'Suffer psychological damage. Reduce Intelligence or Social ' +
           'Standing by 1',
      3 => 'Your ship is damaged, and you have to hitch a ride back to ' +
           'your nearest scout base.  Gain 1d6 Contacts and 1d3 Enemies.',
      4 => 'You inadvertently cause a conflict between the Imperium and ' +
           'a minor world or race.  Gain a Rival and Diplomat 1.',
      5 => 'You have no idea what happened to you.  Your ship was found ' +
           'drifting on the fringes of friendly space',
      6 => 'Injured.  Roll on the Injury table.',
    }
  end

  class Army < MilitaryCareer
    QUALIFICATION = [:endurance, 5]
    AGE_PENALTY = 30
    PERSONAL_SKILLS = [:strength, :dexterity, :endurance,
                       'Gambler', 'Medic', 'Melee']
    SERVICE_SKILLS =  [['Drive', 'Vacc Suit'], 'Athletics', 'Gun Combat',
                      'Recon', 'Melee', 'Heavy Weapons']
    ADVANCED_SKILLS = ['Tactics:Military', 'Electronics', 'Navigation',
                       'Explosives', 'Engineer', 'Survival']
    OFFICER_SKILLS = ['Tactics:Military', 'Leadership', 'Advocate',
                      'Diplomat', 'Electronics', 'Admin']
    RANKS = {
      0 => ['Private', 'Gun Combat', 1],
      1 => ['Lance Corporal', 'Recon', 1],
      2 => ['Corporal'],
      3 => ['Lance Sergeant', 'Leadership', 1],
      4 => ['Sergeant'],
      5 => ['Gunnery Sergeant'],
      6 => ['Sergeant Major'],
    }
    OFFICER_RANKS = {
      1 => ['Lieutenant', 'Leadership', 1],
      2 => ['Captain'],
      3 => ['Major', 'Tactics:Military', 1],
      4 => ['Lieutenant Colonel'],
      5 => ['Colonel'],
      6 => ['General', :social_status, 10], # TODO
    }

    SPECIALIST = {
      support: {
        skills: ['Mechanic', ['Drive', 'Flyer'], 'Profession',
                 'Explosives', 'Electronics:Comms', 'Medic'],
        survival: [:endurance, 5],
        advancement: [:education, 7],
        ranks: RANKS,
      },
      infantry: {
        skills: ['Gun Combat', 'Melee', 'Heavy Weapons',
                 'Stealth', 'Athletics', 'Recon'],
        survival: [:strength, 6],
        advancement: [:education, 6],
        ranks: RANKS,
      },
      cavalry: {
        skills: ['Mechanic', 'Drive', 'Flyer', 'Recon',
                 'Heavy Weapons:Vehicle', 'Electronics:Sensors'],
        survival: [:intelligence, 7],
        advancement: [:intelligence, 5],
        ranks: RANKS,
      },
    }

    # roll => [cash, benefit]
    MUSTER_OUT = {
      1 => [2000, 'Combat Implant'],
      2 => [5000, 'INT +1'],
      3 => [10_000, 'EDU +1'],
      4 => [10_000, 'Weapon'],
      5 => [10_000, 'Armour'],
      6 => [20_000, 'END +1 or Combat Implant'],
      7 => [30_000, 'SOC +1'],
    }
  end

  class Marines < MilitaryCareer
    QUALIFICATION = [:endurance, 6]
    AGE_PENALTY = 30

    PERSONAL_SKILLS = [:strength, :dexterity, :endurance, 'Gambler',
                       'Melee:Unarmed', 'Melee:Blade']
    SERVICE_SKILLS = ['Athletics', 'Vacc Suit', 'Tactics',
                      'Heavy Weapons', 'Gun Combat', 'Stealth']
    ADVANCED_SKILLS = ['Medic', 'Survival', 'Explosives',
                       'Engineer', 'Pilot', 'Navigation']
    OFFICER_SKILLS = ['Electronics', 'Tactics', 'Admin',
                      'Advocate', 'Vacc Suit', 'Leadership']
    RANKS = {
      0 => ['Marine', 'Gun Combat', 1], # TODO "or Melee Blade"
      1 => ['Lance Corporal', 'Gun Combat', 1], # TODO: any
      2 => ['Corporal'],
      3 => ['Lance Sergeant', 'Leadership', 1],
      4 => ['Sergeant'],
      5 => ['Gunnery Sergeant', :endurance],
      6 => ['Sergeant Major'],
    }
    OFFICER_RANKS = {
      1 => ['Lieutenant', 'Leadership', 1],
      2 => ['Captain'],
      3 => ['Force Commander', 'Tactics', 1],
      4 => ['Lieutenant Colonel'],
      5 => ['Colonel', :social_status, 10],  # TODO
      6 => ['Brigadier'],
    }

    SPECIALIST = {
      support: {
        skills: ['Electronics', 'Mechanic', ['Drive', 'Flyer'],
                 'Medic', 'Heavy Weapons', 'Gun Combat'],
        survival: [:endurance, 5],
        advancement: [:education, 7],
        ranks: RANKS,
      },
      star_marine: {
        skills: ['Vacc Suit', 'Athletics', 'Gunner',
                 'Melee:Blade', 'Electronics', 'Gun Combat'],
        survival: [:endurance, 6],
        advancement: [:education, 6],
        ranks: RANKS,
      },
      ground_assault: {
        skills: ['Vacc Suit', 'Heavy Weapons', 'Recon',
                 'Melee:Blade', 'Tactics:Military', 'Gun Combat'],
        survival: [:endurance, 7],
        advancement: [:education, 5],
        ranks: RANKS,
      }
    }

    MUSTER_OUT = {
      1 => [2000, 'Armour'],
      2 => [5000, 'INT +1'],
      3 => [5000, 'EDU +1'],
      4 => [10_000, 'Weapon'],
      5 => [20_000, 'TAS Membership'],
      6 => [30_000, 'Armour or END +1'],
      7 => [40_000, 'SOC +2'],
    }
  end

  class Navy < MilitaryCareer
    QUALIFICATION = [:intelligence, 6]
    AGE_PENALTY = 34

    PERSONAL_SKILLS = [:strength, :dexterity, :endurance,
                       :intelligence, :education, :social_status]
    SERVICE_SKILLS = ['Pilot', 'Vacc Suit', 'Athletics',
                      'Gunner', 'Mechanic', 'Gun Combat']
    ADVANCED_SKILLS = ['Electronics', 'Astrogation', 'Engineer',
                       'Drive', 'Navigation', 'Admin']
    OFFICER_SKILLS = ['Leadership', 'Electronics', 'Pilot',
                      'Melee:Blade', 'Admin', 'Tactics:Naval']
    RANKS = {
      0 => ['Crewman'],
      1 => ['Able Spacehand', 'Mechanic', 1],
      2 => ['Petty Officer 3rd class', 'Vacc Suit', 1],
      3 => ['Petty Officer 2nd class'],
      4 => ['Petty Officer 1st class', :endurance, nil],
      5 => ['Chief Petty Officer'],
      6 => ['Master Chief'],
    }
    OFFICER_RANKS = {
      1 => ['Ensign', 'Melee:Blade', 1],
      2 => ['Sublieutenant', 'Leadership', 1],
      3 => ['Lieutenant'],
      4 => ['Commander', 'Tactics:Naval', 1],
      5 => ['Captain', :social_status, 10], # TODO
      6 => ['Admiral', :social_status, 12], # TODO
    }
    SPECIALIST = {
      line_crew: {
        skills: ['Electronics', 'Mechanic', 'Gun Combat',
                 'Flyer', 'Melee', 'Vacc Suit'],
        survival: [:intelligence, 5],
        advancement: [:education, 7],
        ranks: RANKS,
      },
      engineer_gunner: {
        skills: ['Engineer', 'Mechanic', 'Electronics',
                 'Engineer', 'Gunner', 'Flyer'],
        survival: [:intelligence, 6],
        advancement: [:education, 6],
        ranks: RANKS,
      },
      flight: {
        skills: ['Pilot', 'Flyer', 'Gunner',
                 'Pilot:Small Craft', 'Astrogation', 'Electronics'],
        survival: [:dexterity, 7],
        advancement: [:education, 5],
        ranks: RANKS,
      },
    }

    MUSTER_OUT = {
      1 => [1000, 'Personal Vehicle or Ship Share'],
      2 => [5000, 'INT +1'],
      3 => [5000, 'EDU +1 or two Ship Shares'],
      4 => [10_000, 'Weapon'],
      5 => [20_000, 'TAS Membership'],
      6 => [50_000, "Ship's Boat or two Ship Shares"],
      7 => [50_000, 'SOC +2'],
    }
  end
end
