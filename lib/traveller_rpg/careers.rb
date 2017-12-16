require 'yaml'
require 'traveller_rpg'
require 'traveller_rpg/career'
require 'traveller_rpg/character'
require 'traveller_rpg/skill_set'

module TravellerRPG
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
      raise(StatCheckError, cfg) unless cfg.is_a?(Hash) and cfg.size == 1
      result = {}
      if cfg.key? 'choose'
        result[:choose] = {}
        cfg['choose'].each { |stat, check|
          result[:choose][self.stat_sym!(stat)] = check
        }
      else
        result[self.stat_sym!(cfg.keys.first)] = cfg.values.first
      end
      result
    end

    def self.fetch_skills!(hsh, key, stats_ok: true)
      ary = hsh[key] or raise(SkillError, hsh[key].inspect)
      unless ary.is_a?(Array) and ary.size == 6
        raise(SkillError, "unexpected: #{ary}")
      end
      self.extract_skills(ary, stats_ok: stats_ok)
    end

    # convert 'choose' to :choose and e.g. 'strength' to :strength
    def self.extract_skills(ary, stats_ok: true)
      ary.reduce([]) { |memo, val|
        case val
        when Hash
          raise(SkillError, val) unless val['choose'].is_a? Array
          val = {
            choose: self.extract_skills(val['choose'], stats_ok: stats_ok)
          }
        else
          if stats_ok and self.stat? val
            val = self.stat_sym! val
          else
            raise(UnknownSkill, val) unless self.skill? val
          end
        end
        memo + [val]
      }
    end

    def self.ranks(hsh)
      r = hsh['ranks'] or raise(RankError, "no rank: #{hsh}")
      raise(RankError, r) unless r.is_a? Hash and r.size <= 7
      result = {}
      r.each { |rank, h|
        result[rank] = {}
        raise(RankError, h) unless h.is_a? Hash and h.size <= 3
        raise(RankError, h) if (h.keys & %w{title skill stat choose}).empty?
        title, skill, stat, level = h.values_at(*%w{title skill stat level})
        if title
          raise(RankError, "not a string: #{title}") unless title.is_a?(String)
          result[rank][:title] = title
        end
        choices = h['choose']
        if choices
          raise("bad choices: #{choices}") unless choices.is_a?(Array)
          result[rank][:choose] = []
          choices.each { |hh|
            if hh['skill'] and hh['stat']
              raise("can't have both skill and stat: #{hh}")
            elsif hh['skill']
              raise(UnknownSkill, hh['skill']) unless self.skill?(hh['skill'])
              res = { skill: hh['skill'] }
              res[:level] = hh['level'] if hh['level']
              result[rank][:choose] << res
            elsif hh['stat']
              res = { stat: self.stat_sym!(hh['stat']) }
              res[:level] = hh['level'] if hh['level']
              result[rank][:choose] << res
            else
              raise("need at least one of skill or stat: #{hh}")
            end
          }
          next
        end

        # ok, no choose

        if skill
          case skill
          when String
            result[rank][:skill] =
              self.skill?(skill) ? skill : raise(UnknownSkill, skill)
          else
            raise(UnknownSkill, skill)
          end
        end
        if stat
          case stat
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
          c.const_set('SERVICE_SKILLS', self.fetch_skills!(cfg, 'service'))
          if cfg.key?('advanced_education')
            c.const_set('ADVANCED_EDUCATION', cfg['advanced_education'])
            if cfg['advanced_education']
              c.const_set('ADVANCED_SKILLS',
                          self.fetch_skills!(cfg, 'advanced'))
            end
          end
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
