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
    RANKS = {
      1 => ['Agent', :deception, 1],
      2 => ['Field Agent', :investigate, 1],
      4 => ['Special Agent', :gun_combat_group, 1],
      5 => ['Assistant Director', nil, nil],
      6 => ['Director', nil, nil],
    }
    SPECIALIST = {
      law_enforcement: {
        skills:   [:investigate, :recon, :streetwise,
                   :stealth, :melee_group, :advocate],
        survival: [:endurance, 6],
        advancement: [:intelligence, 6],
        ranks: {
          0 => ['Rookie', nil, nil],
          1 => ['Corporal', :streetwise, 1],
          2 => ['Sergeant', nil, nil],
          3 => ['Detective', nil, nil],
          4 => ['Lieutenant', :investigate, 1],
          5 => ['Chief', :admin, 1],
          6 => ['Commissioner', :social_standing, nil],
        },
      },
      intelligence: {
        skills: [:investigate, :recon, :comms,
                 :stealth, :persuade, :deception],
        survival: [:intelligence, 7],
        advancement: [:intelligence, 5],
        ranks: RANKS,
      },
      corporate: {
        skills: [:investigate, :computers, :stealth,
                 :carouse, :deception, :streetwise],
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

    def qualify_check?(dm: 0)
      true
    end
  end

  class Entertainer < Career; end
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
    QUALIFICATION = [:endurance, 5]
    AGE_PENALTY = 30
    PERSONAL_SKILLS = [:strength, :dexterity, :endurance,
                       :gambler, :medic, :melee_group]
    SERVICE_SKILLS = [:drive_group, :athletics_group, :gun_combat_group,
                      :recon, :melee_group, :heavy_weapons_group]
    ADVANCED_SKILLS = [:tactics_military, :leadership, :advocate,
                       :diplomat, :electronics, :admin]
    OFFICER_SKILLS = [:tactics_military, :leadership, :advocate,
                      :diplomat, :electronics, :admin]
    RANKS = {
      0 => ['Private', :gun_combat_group, 1],
      1 => ['Lance Corporal', :recon, 1],
      2 => ['Corporal', nil, nil],
      3 => ['Lance Sergeant', :leadership, 1],
      4 => ['Sergeant', nil, nil],
      5 => ['Gunnery Sergeant', nil, nil],
      6 => ['Sergeant Major', nil, nil],
    }
    OFFICER_RANKS = {
      1 => ['Lieutenant', :leadership, 1],
      2 => ['Captain', nil, nil],
      3 => ['Major', :tactics_military, 1],
      4 => ['Lieutenant Colonel', nil, nil],
      5 => ['Colonel', nil, nil],
      6 => ['General', :social_status, 10],  # TODO
    }

    SPECIALIST = {
      support: {
        skills: [:mechanic, :flyer_group, :engineer_group, # TODO: profession
                 :explosives, :comms, :medic],
        survival: [:endurance, 5],
        advancement: [:education, 7],
        ranks: RANKS,
      },
      infantry: {
        skills: [:gun_combat_group, :melee_group, :heavy_weapons_group,
                 :stealth, :athletics_group, :recon],
        survival: [:strength, 6],
        advancement: [:education, 6],
        ranks: RANKS,
      },
      cavalry: {
        skills: [:mechanic, :drive_group, :flyer_group,
                 :recon, :heavy_weapons_group, :sensors], # TODO: HW vehicle
        survival: [:intelligence, 7],
        advancement: [:intelligence, 5],
        ranks: RANKS,
      },
    }

    EVENTS = {
      2 => nil,
      3 => nil,
      4 => nil,
      5 => nil,
      6 => nil,
      7 => nil,
      8 => nil,
      9 => nil,
      10 => nil,
      11 => nil,
      12 => nil,
    }

    MISHAPS = {
      1 => nil,
      2 => nil,
      3 => nil,
      4 => nil,
      5 => nil,
      6 => nil,
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

    PERSONAL_SKILLS = [:strength, :dexterity, :endurance,
                       :gambler, :melee_unarmed, :melee_blade]
    SERVICE_SKILLS = [:athletics_group, :vacc_suit, :tactics,
                      :heavy_weapons, :gun_combat_group, :stealth]
    ADVANCED_SKILLS = [:medic, :survival, :explosives,
                       :engineer_group, :pilot_group, :navigation]
    OFFICER_SKILLS = [:engineer_group, :tactics, :admin,
                      :advocate, :vacc_suit, :leadership]
    RANKS = {
      0 => ['Marine', :gun_combat_group, 1], # TODO
      1 => ['Lance Corporal', :gun_combat_group, 1],
      2 => ['Corporal', nil, nil],
      3 => ['Lance Sergeant', :leadership, 1],
      4 => ['Sergeant', nil, nil],
      5 => ['Gunnery Sergeant', :endurance, nil],
      6 => ['Sergeant Major', nil, nil],
    }
    OFFICER_RANKS = {
      1 => ['Lieutenant', :leadership, 1],
      2 => ['Captain', nil, nil],
      3 => ['Force Commander', :tactics, 1],
      4 => ['Lieutenant Colonel', nil, nil],
      5 => ['Colonel', :social_status, 10],  # TODO
      6 => ['Brigadier', nil, nil],
    }

    SPECIALIST = {
      support: {
        skills: [:engineer_electronics, :mechanic, :flyer_group, # TODO
                 :medic, :heavy_weapons_group, :gun_combat_group],
        survival: [:endurance, 5],
        advancement: [:education, 7],
        ranks: RANKS,
      },
      star_marine: {
        skills: [:vacc_suit, :athletics_group, :gunner_group,
                 :melee_blade, :engineer_electronics, :gun_combat_group],
        survival: [:endurance, 6],
        advancement: [:education, 6],
        ranks: RANKS,
      },
      ground_assault: {
        skills: [:vacc_suit, :heavy_weapons_group, :recon,
                 :melee_blade, :tactics_military, :gun_combat_group],
        survival: [:endurance, 7],
        advancement: [:ducation, 5],
        ranks: RANKS,
      }
    }

    EVENTS = {
      2 => nil,
      3 => nil,
      4 => nil,
      5 => nil,
      6 => nil,
      7 => nil,
      8 => nil,
      9 => nil,
      10 => nil,
      11 => nil,
      12 => nil,
    }

    MISHAPS = {
      1 => nil,
      2 => nil,
      3 => nil,
      4 => nil,
      5 => nil,
      6 => nil,
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
                       :intelligence, :education, :social_standing]
    SERVICE_SKILLS = [:pilot_group, :vacc_suit, :athletics_group,
                      :gunner_group, :mechanic, :gun_combat_group]
    ADVANCED_SKILLS = [:engineer_electronics, :astrogation, :engineer_group,
                       :drive_group, :navigation, :admin]
    OFFICER_SKILLS = [:leadership, :engineer_electronics, :pilot,
                      :melee_blade, :admin, :tactics_naval]
    RANKS = {
      0 => ['Crewman', nil, nil],
      1 => ['Able Spacehand', :mechanic, 1],
      2 => ['Petty Officer 3rd class', :vacc_suit, 1],
      3 => ['Petty Officer 2nd class', nil, nil],
      4 => ['Petty Officer 1st class', :endurance, nil],
      5 => ['Chief Petty Officer', nil, nil],
      6 => ['Master Chief', nil, nil],
    }
    OFFICER_RANKS = {
      1 => ['Ensign', :melee_blade, 1],
      2 => ['Sublieutenant', :leadership, 1],
      3 => ['Lieutenant', nil, nil],
      4 => ['Commander', :tactics_naval, 1],
      5 => ['Captain', :social_status, 10], # TODO
      6 => ['Admiral', :social_status, 12], # TODO
    }
    SPECIALIST = {
      line_crew: {
        skills: [:engineer_electronics, :mechanic, :gun_combat_group,
                 :flyer_group, :melee_group, :vacc_suit],
        survival: [:intelligence, 5],
        advancement: [:education, 7],
        ranks: RANKS,
      },
      engineer_gunner: {
        skills: [:engineer_group, :mechanic, :engineer_electronics,
                 :engineer_group, :gunner_group, :flyer_group],
        survival: [:intelligence, 6],
        advancement: [:education, 6],
        ranks: RANKS,
      },
      flight: {
        skills: [:pilot_group, :flyer_group, :gunner_group,
                 :pilot_small_craft, :astrogation, :engineer_electronics],
        survival: [:dexterity, 7],
        advancement: [:education, 5],
        ranks: RANKS,
      },
    }

    EVENTS = {
      2 => nil,
      3 => nil,
      4 => nil,
      5 => nil,
      6 => nil,
      7 => nil,
      8 => nil,
      9 => nil,
      10 => nil,
      11 => nil,
      12 => nil,
    }

    MISHAPS = {
      1 => nil,
      2 => nil,
      3 => nil,
      4 => nil,
      5 => nil,
      6 => nil,
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
