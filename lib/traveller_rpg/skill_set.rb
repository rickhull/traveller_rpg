require 'traveller_rpg/skills'

module TravellerRPG
  class SkillSet
    class UnknownSkill < RuntimeError; end

    def initialize
      @skills = {}
    end

    def to_h
      @skills
    end

    # return the skill for name, or nil
    def [](name)
      raise(UnknownSkill, name) unless TravellerRPG.known_skill? name
      names = name.split(':')
      return unless (skill = @skills[names.first])
      return skill unless names.size == 2
      skill[names.last]
    end

    def level(name)
      self[name] and self[name].level
    end

    def check?(name, level)
      !self[name].nil? and self[name].check? level
    end

    # valid names: 'Admin', 'Animals', 'Animals:Handling'
    def bump(name, level = nil)
      self.provide(name).bump(level)
    end

    # add named skill to @skills if needed; return named skill
    def provide(name)
      name, rest = name.split(':')
      @skills[name] ||= TravellerRPG.new_skill(name)
      if rest
        @skills[name][rest] or raise(UnknownSkill, name)
      else
        @skills[name]
      end
    end

    def empty?
      @skills.empty?
    end

    # LONGEST:
    # Jack Of All Trades (18) = 18
    # Heavy Weapons:Man Portable (13:12) = 26
    # Profession:Civil Engineering (10:17) = 28

    def report
      return '(none)' if @skills.empty?
      report = []
      width = 20
      @skills.each { |name, simple|
        next if simple.is_a?(ComplexSkill)
        report << format("%s: %s", name.rjust(width, ' '), simple)
      }
      @skills.each { |name, cpx|
        next unless cpx.is_a?(ComplexSkill)
        sub_count = cpx.skills.values.select { |s| s.level > 0 }
        if sub_count == 0
          report << format("%s: %s", name.rjust(width, ' '), cpx)
        else
          report << "(#{cpx.name})"
          cpx.skills.each { |subname, subskill|
            next if subskill.level <= 0
            label = "- #{subname}".rjust(width, ' ')
            report << format("%s: %s", label, subskill)
          }
        end
      }
      report.join("\n")
    end
  end
end
