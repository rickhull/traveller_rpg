require 'traveller_rpg/skills'

module TravellerRPG
  class SkillSet
    class UnknownSkill < RuntimeError; end

    def initialize
      @skills = {}
    end

    def known?(name)
      TravellerRPG.skill?(*Skill.syms(name))
    end

    # return the skill for name, or nil
    def [](name)
      raise(UnknownSkill, name) unless self.known?(name)
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
      syms = Skill.syms(name)
      raise(UnknownSkill, name) unless TravellerRPG.skill?(*syms)
      names = syms.map { |sym| Skill.name(sym) }
      # make sure @skills has an entry
      skill = (@skills[names.first] ||= TravellerRPG.skill(syms.first))
      # drill into subskill as needed
      skill = skill.fetch(names[1]) if names[1]
      skill
    end
  end
end
