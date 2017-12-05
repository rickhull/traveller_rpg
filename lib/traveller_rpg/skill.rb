require 'traveller_rpg'

# some skills have specialties -- e.g. Animals (riding, veterinary, etc)
module TravellerRPG
  class Skill
    MAX = 5

    def self.name(*syms)
      syms.map { |sym|
        sym.to_s.split('_').map(&:capitalize).join(' ')
      }.join('.')
    end

    def self.sym(name)
      name.split(' ').map(&:downcase).join('_').to_sym
    end

    def self.syms(name)
      name.split(':').map { |n| self.sym(n) }
    end

    attr_reader :name, :value, :desc

    def initialize(name, value: 0, desc: '')
      @name = name
      @value = value
      @desc = desc
    end

    def bump(level = nil)
      if level
        @value = level if level > @value
      else
        @value += 1
      end
      @value = @value.clamp(0, MAX)
    end

    def to_s
      @value.to_s
    end
  end

  class ComplexSkill
    attr_reader :skills

    def initialize(name, value: 0, desc: '', skills: [])
      @skill = Skill.new(name, value: value, desc: desc)
      @skills = skills.reduce({}) { |memo, s| memo.merge(s.name => s) }
    end

    def method_missing(meth, *args)
      @skill.send(meth, *args)
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

    def filter(names)
      result = []
      size = names.size
      @skills.each { |s|
        result << s if names.delete(s.name)
      }
      result
    end

    def to_s
      @skill.to_s
    end
  end

  def self.skill?(*args)
    case args.first
    when String
      raise(ArgumentError, "only one string arg expected") if args.length != 1
      symbols = Skill.syms(args.first)
    when Symbol
      symbols = args
    else
      raise(ArgumentError, "unexpected args: #{args.first.inspect}")
    end
    return false unless SKILLS.key?(symbols.first)
    return true if symbols.length == 1
    return false if symbols.length > 2
    return false unless SKILLS[symbols.first]
    SKILLS[symbols.first].include?(symbols.last)
  end

  def self.skill(sym)
    subs = SKILLS.fetch(sym)
    if subs.nil?
      Skill.new(Skill.name(sym))
    else
      ComplexSkill.new(Skill.name(sym),
                       skills: subs.map { |s| Skill.new(Skill.name(s)) })
    end
  end

  # per http://www.traveller-srd.com/core-rules/skills/
  SKILLS = {
    admin:  nil,
    advocate: nil,
    animals: [:handling, :veterinary, :training],
    art: [:performer, :holography, :instrument, :visual_media, :write],
    astrogation: nil,
    athletics: [:dexterity, :endurance, :strength],
    broker: nil,
    carouse: nil,
    deception: nil,
    diplomat: nil,
    drive: [:hovercraft, :mole, :track, :walker, :wheel],
    electronics: [:comms, :computers, :remote_ops, :sensors],
    engineer: [:manoeuvre, :jump_drive, :life_support, :power],
    explosives: nil,
    flyer: [:airship, :grav, :ornithopter, :rotor, :wing],
    gambler: nil,
    gunner: [:turret, :ortillery, :screen, :capital],
    gun_combat: [:archaic, :energy, :slug],
    heavy_weapons: [:artillery, :man_portable, :vehicle],
    investigate: nil,
    jack_of_all_trades: nil,
    language: [:anglic, :vilani, :zdetl, :oynprith],
    leadership: nil,
    mechanic: nil,
    medic: nil,
    melee: [:unarmed, :blade, :bludgeon, :natural],
    navigation: nil,
    persuade: nil,
    pilot: [:small_craft, :spacecraft, :capital_ships],
    profession: [:belter, :biologicals, :civil_engineering,
                 :construction, :hydroponics, :polymers],
    recon: nil,
    science: [:archaeology, :astronomy, :biology, :chemistry,
              :cosmology, :cybernetics, :economics, :genetics,
              :history, :linguistics, :philosophy, :physics,
              :planetology, :psionicology, :psychology, :robotics,
              :sophontology, :xenology],
    seafarer: [:ocean_ships, :personal, :sail, :submarine],
    stealth: nil,
    steward: nil,
    streetwise: nil,
    survival: nil,
    tactics: [:military, :naval],
    vacc_suit: nil,
  }
end
