require 'traveller_rpg'

module TravellerRPG
  class Skill
    MAX = 4

    def self.name(*syms)
      syms.map { |sym|
        sym.to_s.split('_').map(&:capitalize).join(' ')
      }.join(':')
    end

    def self.sym(name)
      name.split(' ').map(&:downcase).join('_').to_sym
    end

    def self.syms(name)
      name.split(':').map { |n| self.sym(n) }
    end

    attr_reader :name, :level, :desc

    def initialize(name, level: 0, desc: '')
      @name = name
      self.level = level
      @desc = desc
    end

    def bump(level = nil)
      if level
        self.level = level if level > @level
      else
        self.level += 1
      end
      self
    end

    def check?(level)
      @level >= level
    end

    def to_s
      @level.to_s
    end

    protected

    def level=(val)
      @level = val.clamp(0, MAX)
      warn "level #{val} was clamped to #{@level}" if val != @level
      @level
    end
  end

  # note, Engineer (e.g.) can't go above 0, so Engineer#bump means
  # you have to pick a specialty to bump
  class ComplexSkill
    MAX = 0

    attr_reader :skills

    # accept subskills as array, store as hash keyed by subskill name
    def initialize(name, desc: '', skills: [])
      @skill = Skill.new(name, desc: desc)
      @skills = skills.reduce({}) { |memo, s| memo.merge(s.name => s) }
    end

    def bump(level = nil)
      skills = @skills.select { |_, s| level ? s.level < level : true }
      case skills.size
      when 0
        return self
      when 1
        name = skills.keys.first
      else
        name = TravellerRPG.choose("Choose #{@skill.name} specialty:",
                                   *skills.keys)
      end
      @skills[name].bump level
    end

    def fetch(name)
      raise(KeyError, name) unless @skills.key?(name)
      @skills[name]
    end

    def [](name)
      @skills[name]
    end

    def []=(name, skill)
      raise("#{name} collision: #{skill} vs #{@skills[name]}") if @skills[name]
      @skills[name] = skill
    end

    def method_missing(meth, *args)
      @skill.send(meth, *args)
    end

    def filter(names)
      @skills.keys.reduce([]) { |memo, s|
        names.delete(s) ? (memo + [@skills[s]]) : memo
      }
    end

    def to_s
      @skill.to_s
    end
  end
end
