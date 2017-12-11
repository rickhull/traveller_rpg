require 'traveller_rpg'
require 'traveller_rpg/career'

module TravellerRPG
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
      return false unless hsh.is_a?(Hash) and hsh.size == 1
      if hsh['choose']
        hsh['choose'].all? { |k, v| self.stat_check?(k => v) }
      else
        hsh.all? { |k, v| self.stat?(k) and (0..15).include? v }
      end
    end

    def self.fetch_stat_check!(hsh, key)
      raise(StatCheckError, "#{key} not found: #{hsh}") unless hsh.key? key
      val = hsh[key] or return false # e.g. Drifter
      raise(StatCheckError, val.inspect) unless self.stat_check?(val)
      val
    end

    def self.fetch_skills!(hsh, key, stats_allowed: true)
      val = hsh.fetch(key)
      return false if val == false # Drifter['advanced']
      raise(SkillError, val.inspect) unless val.is_a?(Array) and val.size == 6
      val.each { |v|
        case v
        when Hash
          raise(SkillError, v) unless v['choose'].is_a?(Array)
          vals = v['choose']
        else
          vals = [v]
        end
        vals.each { |vv|
          if stats_allowed
            raise(SkillError, "unknown: #{vv}") if self.known(vv) == :unknown
          else
            raise(UnknownSkill, vv) unless self.skill?(vv)
          end
        }
      }
      val
    end

    def self.fetch_ranks!(hsh)
      r = hsh['ranks'] or raise(RankError, "no rank: #{hsh}")
      raise(RankError, r.inspect) unless r.is_a? Hash and r.size <= 7
      r.each { |rank, h|
        raise(RankError, h.inspect) unless h.is_a? Hash and h.size <= 4
        raise(RankError, h.inspect) if (h.keys & %w{title skill stat}).empty?
        if h.key? 'skill' and !self.skill? h['skill']
          raise(UnknownSkill, h['skill']) unless h['skill'].is_a?(Hash)
          a = h['skill']['choose']
          raise(RankError, "choose: #{h['skill']}") unless a.is_a?(Array)
          a.each { |sk| raise(UnknownSkill, sk) unless self.skill? sk }
        end
        if h.key? 'stat' and !self.stat? h['stat']
          raise(UnknownStat, h['stat']) unless h['stat'].is_a? Hash
          a = h['stat']['choose']
          raise(RankError, "choose: #{h['stat']}") unless a.is_a?(Array)
          a.each { |stat| raise(UnknownStat, stat) unless self.stat? stat }
        end
        if h.key? 'level' and !(h.key? 'skill' or h.key? 'stat')
          raise(RankError, "level without a skill/stat")
        end
      }
    end

    def self.specialist(hsh)
      result = {}
      hsh.fetch('specialist').each { |asg, cfg|
        result[asg] = {}
        result[asg][:survival] = self.fetch_stat_check!(cfg, 'survival')
        result[asg][:advancement] = self.fetch_stat_check!(cfg, 'advancement')
        result[asg][:skills] = self.fetch_skills!(cfg, 'skills')
        result[asg][:ranks] = self.fetch_ranks!(cfg)
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

    def self.benefit_type(item)
      raise(BenefitError, item.inspect) if !item.is_a?(String) or item.empty?
      k = self.known(item)
      k == :unknown ? :item : k
    end

    def self.benefits(hsh)
      b = hsh.fetch('benefits')
      raise(BenefitError, b) unless b.is_a?(Array) and b.size == 7
      benefits = {}
      b.each.with_index { |item, idx|
        case item
        when String
          self.benefit_type(item)
        when Hash
          ary = item['choose'] or raise(BenefitError, ary)
          raise(BenefitError, ary) unless ary.is_a?(Array) and ary.size < 5
          ary.each { |a| self.benefit_type a }
        when Array
          item.each { |a| self.benefit_type a }
        else
          raise(BenefitError, item)
        end
        benefits[idx + 1] = item
      }
      benefits
    end

    def self.generate_classes(file_name)
      scope = TravellerRPG
      self.load(file_name).each { |name, cfg|
        # inherit from Career
        c = Class.new(TravellerRPG::Career)

        begin
          # create class constants
          c.const_set('QUALIFICATION',
                      self.fetch_stat_check!(cfg, 'qualification'))
          c.const_set('PERSONAL_SKILLS', self.fetch_skills!(cfg, 'personal'))
          c.const_set('SERVICE_SKILLS', self.fetch_skills!(cfg, 'service'))
          c.const_set('ADVANCED_SKILLS', self.fetch_skills!(cfg, 'advanced'))
          c.const_set('SPECIALIST', self.specialist(cfg))

          # TODO: Events and mishaps are tedious to write.
          #       Currently Career::EVENTS and ::MISHAPS provides defaults.
          #       These should be mandatory once defined for each career.
          c.const_set('EVENTS', self.events(cfg)) if cfg['events']
          c.const_set('MISHAPS', self.mishaps(cfg)) if cfg['mishaps']
          c.const_set('CREDITS', self.credits(cfg))
          c.const_set('BENEFITS', self.benefits(cfg))
        rescue => e
          warn ["Career: #{name}", e.class, e].join("\n")
          raise
        end
        # set class e.g. TravellerRPG::Agent
        scope.const_set(name, c)
      }
    end

    self.generate_classes('base')
  end
end
