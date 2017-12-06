require 'traveller_rpg/skills'

module TravellerRPG
  class SkillSet
    class UnknownSkill < RuntimeError; end

    def initialize
      @skills = {}
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
  end
end
