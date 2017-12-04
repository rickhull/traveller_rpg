require 'traveller_rpg'
require 'traveller_rpg/career'

module TravellerRPG
  class Agent < Career
    QUALIFICATION   = [:intelligence, 6]
    ADVANCED_EDUCATION = 8
    PERSONAL_SKILLS = [:gun_combat_group, :dexterity, :endurance,
                       :melee_group, :intelligence, :athletics_group]
    SERVICE_SKILLS  = [:streetwise, :drive_group, :investigate,
                       :flyer_group, :recon, :gun_combat_group]
    ADVANCED_SKILLS = [:advocate, :language_group, :explosives,
                       :medic, :vacc_suit, :electronics_group]
    SPECIALIST = {
      law_enforcement: {
        skills:   [:investigate, :recon, :streetwise,
                   :stealth, :melee_group, :advocate],
        survival: [:endurance, 6],
        advancement: [:intelligence, 6],
      },
      intelligence: {
        skills: [:investigate, :recon, :comms,
                 :stealth, :persuade, :deception],
        survival: [:intelligence, 7],
        advancement: [:intelligence, 5],
      },
      corporate: {
        skills: [:investigate, :computers, :stealth,
                 :carouse, :deception, :streetwise],
        survival: [:intelligence, 5],
        advancement: [:intelligence, 7],
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

    # TODO: this is just the LEO ranks
    # really, Agent ranks are per SPECIALTY (ugh)
    RANKS = {
      0 => ['Rookie', nil, nil],
      1 => ['Corporal', :streetwise, 1],
      2 => ['Sergeant', nil, nil],
      3 => ['Detective', nil, nil],
      4 => ['Lieutenant', :investigate, 1],
      5 => ['Chief', :admin, 1],
      6 => ['Commissioner', :social_standing, 1],
    }

    EVENTS = {
      2 => 'Disaster',
      3 => 'Investigation',
      4 => 'Mission',
      5 => 'Network',
      6 => 'Specialist training',
      7 => 'Life Event',
      8 => 'Undercover',
      9 => 'Call of Duty',
      10 => 'Vehicle training',
      11 => 'Befriended',
      12 => 'Discover conspiracy',
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
    QUALIFICATION = [:intelligence, 0]
    ADVANCED_EDUCATION = 99
    PERSONAL_SKILLS = [:strength, :endurance, :dexterity,
                       :language_group, :social_sciences_group,
                       :jack_of_all_trades]
    SERVICE_SKILLS = [:athletics_group, :melee_unarmed_combat, :recon,
                      :streetwise, :stealth, :survival]
    ADVANCED_SKILLS = []
    SPECIALIST = {
      barbarian: {
        skills: [:animals_group, :carouse, :melee_blade,
                 :stealth, :seafarer_group, :survival],
        survival: [:endurance, 7],
        advancement: [:strength, 7],
        ranks: {
          1 => [nil, :survival, 1],
          2 => ['Warrior', :melee_blade, 1],
          4 => ['Chieftain', :leadership, 1],
          6 => ['Warlord', nil, nil],
        },
      },
      wanderer: {
        skills: [:drive_group, :deception, :recon,
                 :stealth, :streetwise, :survival],
        survival: [:endurance, 7],
        advancement: [:intelligence, 7],
        ranks: {
          1 => [nil, :streetwise, 1],
          3 => [nil, :deception, 1],
        },
      },
      scavenger: {
        skills: [:pilot_small_craft, :mechanic, :astrogation,
                 :vacc_suit, :engineer_group, :gun_combat_group],
        survival: [:dexterity, 7],
        advancement: [:endurance, 7],
        ranks: {
          1 => [nil, :vacc_suit, 1],
          3 => [nil, :mechanic, 1],
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

    EVENTS = {
      1 => '',
      2 => '',
      3 => '',
      4 => '',
      5 => '',
      6 => '',
      7 => '',
      8 => '',
      9 => '',
      10 => '',
      11 => '',
      12 => '',
    }

    MISHAPS = {
      1 => '',
      2 => '',
      3 => '',
      4 => '',
      5 => '',
      6 => '',
    }
  end



  class Entertainer < Career; end
  class MerchantMarine < Career; end
  class Rogue < Career; end
  class Scholar < Career; end

  class Scout < Career
    QUALIFICATION   = [:intelligence, 5]
    ADVANCED_EDUCATION = 8
    PERSONAL_SKILLS = [:strength, :dexterity, :endurance,
                       :intelligence, :education, :jack_of_all_trades]
    SERVICE_SKILLS  = [:pilot_small_craft, :survival, :mechanic,
                      :astrogation, :comms, :gun_combat_group]
    ADVANCED_SKILLS = [:medic, :navigation, :engineer_group,
                       :computers, :space_sciences_group, :jack_of_all_trades]

    RANKS = {
      1 => ['Scout', :vacc_suit, 1],
      3 => ['Senior Scout', :pilot, 1],
    }

    SPECIALIST = {
      courier: {
        skills:   [:comms, :sensors, :pilot_spacecraft,
                   :vacc_suit, :zero_g, :astrogation],
        survival: [:endurance, 5],
        advancement: [:education, 9],
        ranks: RANKS,
      },
      surveyor: {
        skills: [:sensors, :persuade, :pilot_small_craft,
                 :navigation, :diplomat, :streetwise],
        survival: [:endurance, 6],
        advancement: [:intelligence, 8],
        ranks: RANKS,
      },
      explorer: {
        skills: [:sensors, :pilot_spacecraft, :pilot_small_craft,
                 :life_sciences_group, :stealth, :recon],
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
  end

  class Navy < MilitaryCareer
  end

  class Marines < MilitaryCareer
  end
end
