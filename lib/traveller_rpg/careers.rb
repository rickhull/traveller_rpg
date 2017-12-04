require 'traveller_rpg'
require 'traveller_rpg/career'

module TravellerRPG
  class MilitaryCareer < Career
    COMMISSION_CHECK = 9
    OFFICER_SKILLS = Array.new(6) { :default }
    OFFICER_RANKS = {}

    def initialize(char, **kwargs)
      super(char, **kwargs)
      @officer = false
    end

    def officer?
      !!@officer
    end

    def rank
      @officer ? @officer : @rank
    end

    def rank_benefit
      @officer ? self.class::OFFICER_RANKS[@officer] : super
    end

    def advance_rank
      return super unless @officer
      @officer += 1
      @char.log "Advanced career to officer rank #{@officer}"
      title, skill, level = self.rank_benefit
      if title
        @char.log "Awarded officer rank title: #{title}"
        @char.log "Achieved officer rank skill: #{skill} #{level}"
        @char.skills[skill] ||= 0
        @char.skills[skill] = level if level > @char.skills[skill]
      end
    end

    def commission_check?(dm: 0)
      stat, check = self.class::COMMISSION
      @char.log "#{self.name} commission: #{stat} #{check}"
      dm += @char.stats_dm(stat)
      self.class.roll_check?('Commission', dm: dm, check: check)
    end

    def commission_roll(dm: 0)
      return if @officer
      if TravellerRPG.choose("Apply for commission?", :yes, :no) == :yes
        if self.commission_check?
          @char.log "Became an officer!"
          @officer = 1
        else
          @char.log "Commission was rejected"
        end
      end
    end
  end

  class Navy < MilitaryCareer
  end

  class Army < MilitaryCareer
  end

  class Marines < MilitaryCareer
  end

  class MerchantMarine < Career
  end

  class Agent < MilitaryCareer
  end

  class Scout < Career
    QUALIFICATION   = [:intelligence, 5]
    ADVANCED_EDUCATION = 8
    PERSONAL_SKILLS = [:strength, :dexterity, :endurance,
                       :intelligence, :education, :jack_of_all_trades]
    SERVICE_SKILLS  = [:pilot_small_craft, :survival, :mechanic,
                      :astrogation, :comms, :gun_combat_group]
    ADVANCED_SKILLS = [:medic, :navigation, :engineer_group,
                       :computers, :space_sciences_group, :jack_of_all_trades]
    SPECIALIST = {
      courier: {
        skills:   [:comms, :sensors, :pilot_spacecraft,
                   :vacc_suit, :zero_g, :astrogation],
        survival: [:endurance, 5],
        advancement: [:education, 9],
      },
      surveyor: {
        skills: [:sensors, :persuade, :pilot_small_craft,
                 :navigation, :diplomat, :streetwise],
        survival: [:endurance, 6],
        advancement: [:intelligence, 8],
      },
      explorer: {
        skills: [:sensors, :pilot_spacecraft, :pilot_small_craft,
                 :life_sciences_group, :stealth, :recon],
        survival: [:endurance, 7],
        advancement: [:education, 7],
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


    # key: roll; values: title, skill, skill_value
    RANKS = {
      1 => ['Scout', :vacc_suit, 1],
      3 => ['Senior Scout', :pilot, 1],
    }

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

  class Drifter < Career
  end
end
