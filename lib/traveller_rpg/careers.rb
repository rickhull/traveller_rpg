require 'yaml'
require 'traveller_rpg'
require 'traveller_rpg/career'
require 'traveller_rpg/character'
require 'traveller_rpg/skill_set'

module TravellerRPG
  class Army < MilitaryCareer
    QUALIFICATION = { endurance: 5 }
    AGE_PENALTY = 30
    PERSONAL_SKILLS = [:strength, :dexterity, :endurance,
                       'Gambler', 'Medic', 'Melee']
    SERVICE_SKILLS =  [ { choose: ['Drive', 'Vacc Suit'] }, 'Athletics',
                        'Gun Combat', 'Recon', 'Melee', 'Heavy Weapons']
    ADVANCED_SKILLS = ['Tactics:Military', 'Electronics', 'Navigation',
                       'Explosives', 'Engineer', 'Survival']
    OFFICER_SKILLS = ['Tactics:Military', 'Leadership', 'Advocate',
                      'Diplomat', 'Electronics', 'Admin']
    RANKS = {
      0 => { title: 'Private',
             skill: 'Gun Combat',
             level: 1 },
      1 => { title: 'Lance Corporal',
             skill: 'Recon',
             level: 1 },
      2 => { title: 'Corporal' },
      3 => { title: 'Lance Sergeant',
             skill: 'Leadership',
             level: 1 },
      4 => { title: 'Sergeant' },
      5 => { title: 'Gunnery Sergeant' },
      6 => { title: 'Sergeant Major' },
    }
    OFFICER_RANKS = {
      1 => { title: 'Lieutenant',
             skill: 'Leadership',
             level: 1 },
      2 => { title: 'Captain' },
      3 => { title: 'Major',
             skill: 'Tactics:Military',
             level: 1 },
      4 => { title: 'Lieutenant Colonel' },
      5 => { title: 'Colonel' },
      6 => { title: 'General',
             stat:  :social_status,
             level: 10 },  # TODO: Choose :social_status +1 or level: 10
    }

    SPECIALIST = {
      'Support' => {
        survival: { endurance: 5 },
        advancement: { education: 7 },
        skills: ['Mechanic', { choose: ['Drive', 'Flyer'] }, 'Profession',
                 'Explosives', 'Electronics:Comms', 'Medic'],
        ranks: RANKS,
      },
      'Infantry' => {
        survival: { strength: 6 },
        advancement: { education: 6 },
        skills: ['Gun Combat', 'Melee', 'Heavy Weapons',
                 'Stealth', 'Athletics', 'Recon'],
        ranks: RANKS,
      },
      'Cavalry' => {
        survival: { intelligence: 7 },
        advancement: { intelligence: 5 },
        skills: ['Mechanic', 'Drive', 'Flyer', 'Recon',
                 'Heavy Weapons:Vehicle', 'Electronics:Sensors'],
        ranks: RANKS,
      },
    }

    CREDITS = {
      1 => 2000,
      2 => 5000,
      3 => 10_000,
      4 => 10_000,
      5 => 10_000,
      6 => 20_000,
      7 => 30_000,
    }

    BENEFITS = {
      1 => 'Combat Implant',
      2 => :intelligence,
      3 => :education,
      4 => 'Weapon',
      5 => 'Armour',
      6 => { choose: [:endurance, 'Combat Implant'] },
      7 => :social_status,
    }
  end

  class Marines < MilitaryCareer
    QUALIFICATION = { endurance: 6 }
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
      0 => { title: 'Marine',
             skill: { choose: ['Gun Combat', 'Melee:Blade' ] },
             level: 1 },
      1 => { title: 'Lance Corporal',
             skill: 'Gun Combat',
             level: 1 },
      2 => { title: 'Corporal' },
      3 => { title: 'Lance Sergeant',
             skill: 'Leadership',
             level: 1 },
      4 => { title: 'Sergeant' },
      5 => { title: 'Gunnery Sergeant',
             stat:  :endurance },
      6 => { title: 'Sergeant Major' },
    }

    OFFICER_RANKS = {
      1 => { title: 'Lieutenant',
             skill: 'Leadership',
             level: 1 },
      2 => { title: 'Captain' },
      3 => { title: 'Force Commander',
             skill: 'Tactics',
             level: 1 },
      4 => { title: 'Lieutenant Colonel' },
      5 => { title: 'Colonel',
             stat:  :social_status,
             level: 10 },  # TODO or bump social_status
      6 => { title: 'Brigadier' },
    }

    SPECIALIST = {
      'Support' => {
        survival: { endurance: 5 },
        advancement: { education: 7 },
        skills: ['Electronics', 'Mechanic', { choose: ['Drive', 'Flyer'] },
                 'Medic', 'Heavy Weapons', 'Gun Combat'],
        ranks: RANKS,
      },
      'Star Marine' => {
        survival: { endurance: 6 },
        advancement: { education: 6 },
        skills: ['Vacc Suit', 'Athletics', 'Gunner',
                 'Melee:Blade', 'Electronics', 'Gun Combat'],
        ranks: RANKS,
      },
      'Ground Assault' => {
        survival: { endurance: 7 },
        advancement: { education: 5 },
        skills: ['Vacc Suit', 'Heavy Weapons', 'Recon',
                 'Melee:Blade', 'Tactics:Military', 'Gun Combat'],
        ranks: RANKS,
      }
    }

    CREDITS = {
      1 => 2000,
      2 => 5000,
      3 => 5_000,
      4 => 10_000,
      5 => 20_000,
      6 => 30_000,
      7 => 40_000,
    }

    BENEFITS = {
      1 => 'Armour',
      2 => :intelligence,
      3 => :education,
      4 => 'Weapon',
      5 => 'TAS Membership',
      6 => { choose: [:endurance, 'Armour'] },
      7 => [:social_status, :social_status],    # i.e. SOC +2
    }
  end

  class Navy < MilitaryCareer
    QUALIFICATION = { intelligence: 6 }
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
      0 => { title: 'Crewman' },
      1 => { title: 'Able Spacehand',
             skill: 'Mechanic',
             level: 1 },
      2 => { title: 'Petty Officer 3rd class',
             skill: 'Vacc Suit',
             level: 1 },
      3 => { title: 'Petty Officer 2nd class' },
      4 => { title: 'Petty Officer 1st class',
             stat:  :endurance },
      5 => { title: 'Chief Petty Officer' },
      6 => { title: 'Master Chief' },
    }
    OFFICER_RANKS = {
      1 => { title: 'Ensign',
             skill: 'Melee:Blade',
             level: 1 },
      2 => { title: 'Sublieutenant',
             skill: 'Leadership',
             level: 1 },
      3 => { title: 'Lieutenant' },
      4 => { title: 'Commander',
             skill: 'Tactics:Naval',
             level: 1 },
      5 => { title: 'Captain',
             stat:  :social_status,
             level: 10 }, # TODO or bump
      6 => { title: 'Admiral',
             stat:  :social_status,
             level: 12 }, # TODO or bump
    }
    SPECIALIST = {
      'Line Crew' => {
        survival: { intelligence: 5 },
        advancement: { education: 7 },
        skills: ['Electronics', 'Mechanic', 'Gun Combat',
                 'Flyer', 'Melee', 'Vacc Suit'],
        ranks: RANKS,
      },
      'Engineer Gunner' => {
        survival: { intelligence: 6 },
        advancement: { education: 6 },
        skills: ['Engineer', 'Mechanic', 'Electronics',
                 'Engineer', 'Gunner', 'Flyer'],
        ranks: RANKS,
      },
      'Flight' => {
        survival: { dexterity: 7 },
        advancement: { education: 5 },
        skills: ['Pilot', 'Flyer', 'Gunner',
                 'Pilot:Small Craft', 'Astrogation', 'Electronics'],
        ranks: RANKS,
      },
    }

    CREDITS = {
      1 => 1000,
      2 => 5000,
      3 => 5000,
      4 => 10_000,
      5 => 20_000,
      6 => 50_000,
      7 => 50_000,
    }

    BENEFITS = {
      1 => { choose: ['Personal Vehicle', 'Ship Share'] },
      2 => :intelligence,
      3 => { choose: [:education, ['Ship Share', 'Ship Share' ]] },
      4 => 'Weapon',
      5 => 'TAS Membership',
      6 => { choose: ["Ship's Boat", ['Ship Share', 'Ship Share']] },
      7 => [:social_stats, :social_status],
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

    def self.load(file_name)
      hsh = YAML.load_file(self.find(file_name))
      raise "unexpected object: #{hsh.inspect}" unless hsh.is_a?(Hash)
      hsh
    end

    def self.find(file_name)
      path = File.join(__dir__, 'careers', file_name)
      files = Dir["#{path}*"].grep %r{\.ya?ml\z}
      case files.size
      when 0
        raise "can't find #{file_name}"
      when 1
        files[0]
      else
        # prefer .yaml to .yml -- otherwise give up
        files.grep(/\.yaml\z/).first or
          raise "#{file_name} matches #{files}"
      end
    end

    def self.skill?(str)
      !!TravellerRPG::SkillSet.split_skill!(str) rescue false
    end

    # accepts symbol or string
    def self.stat? stat
      Character::Stats.member? stat
    end

    # accepts symbol or string; raises if not recongnized
    def self.stat_sym! stat
      raise(UnknownStat, stat) unless self.stat? stat
      Character::Stats.sym stat
    end

    # accepts symbol or string; returns symbol if stat is recognized
    def self.stat_sym stat
      self.stat?(stat) ? Character::Stats.sym(stat) : stat
    end

    # convert 'choose' to :choose and e.g. 'strength' to :strength
    def self.fetch_stat_check!(hsh, key)
      raise(StatCheckError, "#{key} not found: #{hsh}") unless hsh.key? key
      cfg = hsh[key] or return false # e.g. Drifter
      if !cfg.is_a?(Hash) or (key != 'choose' and cfg.size != 1)
        raise(StatCheckError, cfg)
      end
      result = {}
      if cfg.key? 'choose'
        result[:choose] = self.fetch_stat_check!(cfg, 'choose')
      else
        result[self.stat_sym!(cfg.keys.first)] = cfg.values.first
      end
      result
    end

    # converto 'choose' to :choose and e.g. 'strength' to :strength
    def self.fetch_skills!(hsh, key, stats_allowed: true)
      ary = hsh.fetch(key)
      return false if ary == false # Drifter['advanced']
      if !ary.is_a?(Array) or (key != 'choose' and ary.size != 6)
        raise(SkillError, "bad array: #{ary} (size #{size.inspect}")
      end
      result = []
      ary.each { |val|
        case val
        when Hash # recursive, 'choose' becomes :choose
          raise(SkillError, val) unless val['choose'].is_a?(Array)
          result << { choose: self.fetch_skills!(val, 'choose') }
        else
          if stats_allowed and self.stat? val
            result << self.stat_sym!(val)
          else
            result << (self.skill?(val) ? val : raise(UnknownSkill, val))
          end
        end
      }
      result
    end

    def self.ranks(hsh)
      r = hsh['ranks'] or raise(RankError, "no rank: #{hsh}")
      raise(RankError, r) unless r.is_a? Hash and r.size <= 7
      result = {}
      r.each { |rank, h|
        result[rank] = {}
        raise(RankError, h) unless h.is_a? Hash and h.size <= 4
        raise(RankError, h) if (h.keys & %w{title skill stat}).empty?
        title, skill, stat, level = h.values_at(*%w{title skill stat level})
        if title
          raise(RankError, "not a string: #{title}") unless title.is_a?(String)
          result[rank][:title] = title
        end
        if skill
          case skill
          when Hash
            a = skill['choose']
            raise(RankError, "no choose: #{skill}") unless a.is_a?(Array)
            result[rank][:skill] = {
              choose: a.map { |sk|
                self.skill?(sk) ? sk : raise(UnknownSkill, sk)
              }
            }
          when String
            result[rank][:skill] =
              self.skill?(skill) ? skill : raise(UnknownSkill, skill)
          else
            raise(UnknownSkill, skill)
          end
        end
        if stat
          case stat
          when Hash
            a = stat['choose']
            raise(RankError, "choose: #{stat}") unless a.is_a?(Array)
            result[rank][:stat] = { choose: a.map { |st| self.stat_sym! st } }
          when String, Symbol
            result[rank][:stat] = self.stat_sym! stat
          else
            raise(UnknownStat, stat)
          end
        end
        if level
          raise(RankError, "unexpected level") unless skill or stat
          raise(RankError, "bad level: #{level}") unless (0..5).include?(level)
          result[rank][:level] = level
        end
      }
      result
    end

    def self.specialist(hsh)
      result = {}
      hsh.fetch('specialist').each { |asg, cfg|
        result[asg] = {}
        result[asg][:survival] = self.fetch_stat_check!(cfg, 'survival')
        result[asg][:advancement] = self.fetch_stat_check!(cfg, 'advancement')
        result[asg][:skills] = self.fetch_skills!(cfg, 'skills')
        result[asg][:ranks] = self.ranks(cfg)
      }
      result
    end

    def self.events(hsh)
      e = hsh.fetch('events')
      raise(EventError, e) unless e.is_a?(Hash) and e.size == 11
      e.values.each { |h|
        raise(EventError, h) unless h.is_a?(Hash)
        text = h.fetch('text')
        raise(EventError, "text is empty") if text.empty?
        # TODO: validate h.fetch('script')
      }
      e
    end

    def self.mishaps(hsh)
      m = hsh.fetch('mishaps')
      raise(MishapError, m) unless m.is_a?(Hash) and m.size == 6
      m.values.each { |h|
        raise(MishapError, h) unless h.is_a?(Hash)
        text = h.fetch('text')
        raise(MishapError, "text is empty") if text.empty?
        # TODO: validate h.fetch('script')
      }
      m
    end

    def self.credits(hsh)
      c = hsh.fetch('credits')
      raise(CreditError, c) unless c.is_a?(Array) and c.size == 7
      creds = {}
      c.each.with_index { |credits, idx|
        raise(CreditError, credits) unless credits.is_a? Integer
        creds[idx + 1] = credits
      }
      creds
    end

    def self.benefits(hsh)
      result = {}
      b = hsh.fetch('benefits')
      raise(BenefitError, b) unless b.is_a?(Array) and b.size == 7
      b.each.with_index { |item, idx|
        case item
        when String
          result[idx + 1] = self.stat_sym(item)
        when Hash
          ary = item['choose']
          raise(BenefitError, item) unless ary.is_a?(Array) and ary.size < 5
          result[idx + 1] = { choose: ary.map { |a| self.stat_sym(a) } }
        when Array
          result[idx + 1] = item.map { |a| self.stat_sym(a) }
        else
          raise(BenefitError, item)
        end
      }
      result
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
          c.const_set('SERVICE_SKILLS', self.fetch_skills!(cfg,  'service'))
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
