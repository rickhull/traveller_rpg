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

    def report
      return '(none)' if @skills.empty?
      report = []
      width = @skills.keys.map(&:size).max + 2
      @skills.each { |name, skill|
        report << format("%s: %s", name.rjust(width, ' '), skill)
        if skill.is_a? ComplexSkill
          skill.skills.each { |subname, subskill|
            label = [name, subname].join(':').rjust(width + 20, ' ')
            report << format("%s: %s", label, subskill) if subskill.level > 0
          }
        end
      }
      report.join("\n")
    end
  end
end
