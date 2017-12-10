require 'traveller_rpg'
require 'traveller_rpg/career'

module TravellerRPG
  # class Citizen < Career; end

  class Drifter < Career
    # QUALIFICATION = [:intelligence, 0]
    ADVANCED_EDUCATION = 99
    PERSONAL_SKILLS = [:strength, :endurance, :dexterity,
                       'Language', 'Profession', 'Jack Of All Trades']
    SERVICE_SKILLS = ['Athletics', 'Melee:Unarmed', 'Recon',
                      'Streetwise', 'Stealth', 'Survival']
    ADVANCED_SKILLS = []
    SPECIALIST = {
      'Barbarian' => {
        skills: ['Animals', 'Carouse', 'Melee:Blade', 'Stealth',
                 ['Seafarer:Personal', 'Seafarer:Sail'], 'Survival'],
        survival: [:endurance, 7],
        advancement: [:strength, 7],
        ranks: {
          1 => [nil, 'Survival', 1],
          2 => ['Warrior', 'Melee:Blade', 1],
          4 => ['Chieftain', 'Leadership', 1],
          6 => ['Warlord', nil, nil],
        },
      },
      'Wanderer' => {
        skills: ['Drive', 'Deception', 'Recon',
                 'Stealth', 'Streetwise', 'Survival'],
        survival: [:endurance, 7],
        advancement: [:intelligence, 7],
        ranks: {
          1 => [nil, 'Streetwise', 1],
          3 => [nil, 'Deception', 1],
        },
      },
      'Scavenger' => {
        skills: ['Pilot:Small Craft', 'Mechanic', 'Astrogation',
                 'Vacc Suit', 'Engineer', 'Gun Combat'],
        survival: [:dexterity, 7],
        advancement: [:endurance, 7],
        ranks: {
          1 => [nil, 'Vacc Suit', 1],
          3 => [nil, ['Profession:Belter', 'Mechanic'], 1],
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

  # class Entertainer < Career; end
  # class Merchant < Career; end
  # class Rogue < Career; end
  # class Scholar < Career; end

  class Scout < Career
    QUALIFICATION   = [:intelligence, 5]
    PERSONAL_SKILLS = [:strength, :dexterity, :endurance,
                       :intelligence, :education, 'Jack Of All Trades']
    SERVICE_SKILLS  = [['Pilot:Small Craft', 'Pilot:Spacecraft'], 'Survival',
                       'Mechanic', 'Astrogation', 'Vacc Suit', 'Gun Combat']
    ADVANCED_SKILLS = ['Medic', 'Navigation', 'Engineer',
                       'Explosives', 'Science', 'Jack Of All Trades']

    RANKS = {
      1 => ['Scout', 'Vacc Suit', 1],
      3 => ['Senior Scout', 'Pilot'],
    }

    SPECIALIST = {
      'Courier' => {
        skills:   ['Electronics', 'Flyer', 'Pilot:Spacecraft',
                   'Engineer', 'Athletics', 'Astrogation'],
        survival: [:endurance, 5],
        advancement: [:education, 9],
        ranks: RANKS,
      },
      'Surveyor' => {
        skills: ['Electronics', 'Persuade', 'Pilot',
                 'Navigation', 'Diplomat', 'Streetwise'],
        survival: [:endurance, 6],
        advancement: [:intelligence, 8],
        ranks: RANKS,
      },
      'Explorer' => {
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
      0 => ['Private', 'Gun Combat'],
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
      'Support' => {
        skills: ['Mechanic', ['Drive', 'Flyer'], 'Profession',
                 'Explosives', 'Electronics:Comms', 'Medic'],
        survival: [:endurance, 5],
        advancement: [:education, 7],
        ranks: RANKS,
      },
      'Infantry' => {
        skills: ['Gun Combat', 'Melee', 'Heavy Weapons',
                 'Stealth', 'Athletics', 'Recon'],
        survival: [:strength, 6],
        advancement: [:education, 6],
        ranks: RANKS,
      },
      'Cavalry' => {
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
      6 => [20_000, ['END +1', 'Combat Implant']],
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
      0 => ['Marine', 'Gun Combat'], # TODO "or Melee Blade"
      1 => ['Lance Corporal', 'Gun Combat'], # TODO: any
      2 => ['Corporal'],
      3 => ['Lance Sergeant', 'Leadership', 1],
      4 => ['Sergeant'],
      5 => ['Gunnery Sergeant', :endurance],
      6 => ['Sergeant Major'],
    }
    OFFICER_RANKS = {
      1 => ['Lieutenant', 'Leadership', 1],
      2 => ['Captain'],
      3 => ['Force Commander', 'Tactics'],
      4 => ['Lieutenant Colonel'],
      5 => ['Colonel', :social_status, 10],  # TODO
      6 => ['Brigadier'],
    }

    SPECIALIST = {
      'Support' => {
        skills: ['Electronics', 'Mechanic', ['Drive', 'Flyer'],
                 'Medic', 'Heavy Weapons', 'Gun Combat'],
        survival: [:endurance, 5],
        advancement: [:education, 7],
        ranks: RANKS,
      },
      'Star Marine' => {
        skills: ['Vacc Suit', 'Athletics', 'Gunner',
                 'Melee:Blade', 'Electronics', 'Gun Combat'],
        survival: [:endurance, 6],
        advancement: [:education, 6],
        ranks: RANKS,
      },
      'Ground Assault' => {
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
      6 => [30_000, ['Armour', 'END +1']],
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
      'Line Crew' => {
        skills: ['Electronics', 'Mechanic', 'Gun Combat',
                 'Flyer', 'Melee', 'Vacc Suit'],
        survival: [:intelligence, 5],
        advancement: [:education, 7],
        ranks: RANKS,
      },
      'Engineer Gunner' => {
        skills: ['Engineer', 'Mechanic', 'Electronics',
                 'Engineer', 'Gunner', 'Flyer'],
        survival: [:intelligence, 6],
        advancement: [:education, 6],
        ranks: RANKS,
      },
      'Flight' => {
        skills: ['Pilot', 'Flyer', 'Gunner',
                 'Pilot:Small Craft', 'Astrogation', 'Electronics'],
        survival: [:dexterity, 7],
        advancement: [:education, 5],
        ranks: RANKS,
      },
    }

    MUSTER_OUT = {
      1 => [1000, ['Personal Vehicle', 'Ship Share']],
      2 => [5000, 'INT +1'],
      3 => [5000, ['EDU +1', 'Two Ship Shares']],
      4 => [10_000, 'Weapon'],
      5 => [20_000, 'TAS Membership'],
      6 => [50_000, ["Ship's Boat", 'Two Ship Shares']],
      7 => [50_000, 'SOC +2'],
    }
  end

  module Careers
    class Error < RuntimeError; end
    class StatError < Error; end
    class UnknownStat < StatError; end
    class StatCheckError < StatError; end
    class SkillError < Error; end
    class UnknownSkill < SkillError; end
    class RankError < Error; end
    class EventError < Error; end
    class MishapError < Error; end
    class CreditError < Error; end
    class BenefitError < Error; end

    require 'yaml'
    require 'traveller_rpg/character'

    def self.load(file_name)
      hsh = YAML.load_file(self.find(file_name))
      raise "unexpected object: #{hsh.inspect}" unless hsh.is_a?(Hash)
      hsh
    end

    def self.find(file_name)
      path = File.join(__dir__, 'careers', file_name)
      files = Dir["#{path}*"].grep /\.ya?ml\z/
      case files.size
      when 0
        raise "can't find #{file_name}"
      when 1
        files[0]
      else
        # prefer .yaml to .yml -- otherwise give up
        files.grep(/\.yaml\z/).first or
          raise "#{file_name} matches #{files.inspect}"
      end
    end

    def self.stat?(str)
      Character::Stats.members.include? str.to_sym
    end

    def self.skill?(str)
      !!TravellerRPG::SkillSet.split_skill!(str) rescue false
    end

    def self.known(str)
      return :stat if self.stat?(str)
      return :skill if self.skill?(str)
      :unknown
    end

    def self.stat_check?(hsh)
      hsh.is_a?(Hash) and
        hsh.size == 1 and
        self.stat?(hsh.keys.first) and
        (0..15).include? hsh.values.first
    end

    def self.fetch_stat_check!(hsh, key)
      val = hsh.fetch(key)
      raise(StatCheckError, val.inspect) unless self.stat_check?(val)
      val.to_a.first
    end

    def self.fetch_skills!(hsh, key, stats_allowed: true)
      val = hsh.fetch(key)
      raise(SkillError, val.inspect) unless val.is_a?(Array) and val.size == 6
      val.flatten.each { |v|
        if stats_allowed
          raise(SkillError, "unknown: #{v}") if self.known(v) == :unknown
        else
          raise(UnknownSkill, v) unless self.skill?(v)
        end
      }
      val
    end

    def self.specialist(hsh)
      result = {}
      hsh.fetch('specialist').each { |asg, cfg|
        result[asg] = {}
        result[asg][:survival] = self.fetch_stat_check!(cfg, 'survival')
        result[asg][:advancement] = self.fetch_stat_check!(cfg, 'advancement')
        result[asg][:skills] = self.fetch_skills!(cfg, 'skills')

        r = cfg.fetch('ranks')
        raise(RankError, r.inspect) unless r.is_a? Hash and r.size <= 7
        r.each { |rank, h|
          raise(RankError, h.inspect) unless h.is_a? Hash and h.size <= 4
          raise(RankError, h.inspect) if (h.keys & %w{title skill stat}).empty?
          if h.key? 'skill' and !self.skill? h['skill']
            raise(UnknownSkill, h['skill'])
          end
          if h.key? 'stat' and !self.stat? h['stat']
            raise(UnknownStat, h['stat'])
          end
          if h.key? 'level' and !(h.key? 'skill' or h.key? 'stat')
            raise(RankError, "level without a skill/stat")
          end
        }
        result[asg][:ranks] = r
      }
      result
    end

    def self.events(hsh)
      e = hsh.fetch('events')
      raise(EventError, e.inspect) unless e.is_a?(Hash) and e.size == 11
      e.values.each { |hsh|
        raise(EventError, hsh.inspect) unless hsh.is_a?(Hash)
        text = hsh.fetch('text')
        raise(EventError, "text is empty") if text.empty?
        # TODO: validate hsh.fetch('script')
      }
      e
    end

    def self.mishaps(hsh)
      m = hsh.fetch('mishaps')
      raise(MishapError, m.inspect) unless m.is_a?(Hash) and m.size == 6
      m.values.each { |hsh|
        raise(MishapError, hsh.inspect) unless hsh.is_a?(Hash)
        text = hsh.fetch('text')
        raise(MishapError, "text is empty") if text.empty?
        # TODO: validate hsh.fetch('script')
      }
      m
    end

    def self.credits(hsh)
      c = hsh.fetch('credits')
      raise(CreditError, c.inspect) unless c.is_a?(Array) and c.size == 7
      creds = {}
      c.each.with_index { |credits, idx|
        raise(CreditError, credits) unless credits.is_a? Integer
        creds[idx + 1] = credits
      }
      creds
    end

    def self.benefits(hsh)
      b = hsh.fetch('benefits')
      raise "unexpected: #{b}" unless b.is_a?(Array) and b.size == 7
      b.flatten.each { |ben|
        raise(BenefitError, ben.inspect) if !ben.is_a?(String) or ben.empty?
      }
      bens = {}
      b.each.with_index { |benefits, idx| bens[idx + 1] = benefits }
      bens
    end

    def self.generate_classes(file_name)
      scope = TravellerRPG
      self.load(file_name).each { |name, cfg|
        # inherit from Career
        c = Class.new(TravellerRPG::Career)

        # create class constants
        c.const_set('QUALIFICATION',
                    self.fetch_stat_check!(cfg, 'qualification'))
        c.const_set('PERSONAL_SKILLS', self.fetch_skills!(cfg, 'personal'))
        c.const_set('SERVICE_SKILLS', self.fetch_skills!(cfg, 'service'))
        c.const_set('ADVANCED_SKILLS', self.fetch_skills!(cfg, 'advanced'))
        c.const_set('SPECIALIST', self.specialist(cfg))
        c.const_set('EVENTS', self.events(cfg))
        c.const_set('MISHAPS', self.mishaps(cfg))
        c.const_set('CREDITS', self.credits(cfg))
        c.const_set('BENEFITS', self.benefits(cfg))

        # set class e.g. TravellerRPG::Agent
        scope.const_set(name, c)
      }
    end
  end
end

if __FILE__ == $0
  require 'traveller_rpg/generator'
  require 'traveller_rpg/career_path'

  include TravellerRPG
  Careers.generate_classes('base')
  char = Generator.character
  path = CareerPath.new(char)
  path.run('Agent')
  # agent = TravellerRPG::Agent.new(char)
  # agent.activate('Intelligence')
end
