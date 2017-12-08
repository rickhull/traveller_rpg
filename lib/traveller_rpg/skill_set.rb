require 'traveller_rpg/skill'

module TravellerRPG
  class SkillSet
    class UnknownSkill < KeyError; end

    def self.split_skill!(str)
      first, rest = str.split(':')
      if rest
        raise(UnknownSkill, str) unless COMPLEX_SKILLS.key?(first)
        raise(UnknownSkill, str) unless COMPLEX_SKILLS[first].key?(rest)
      elsif !SIMPLE_SKILLS.key?(first) and !COMPLEX_SKILLS.key?(first)
        raise(UnknownSkill, str)
      end
      [first, rest]
    end

    def self.new_skill(str)
      if SIMPLE_SKILLS.key?(str)
        Skill.new(str, desc: SIMPLE_SKILLS[str])
      elsif COMPLEX_SKILLS.key?(str)
        subs = COMPLEX_SKILLS[str].keys.map { |s|
          Skill.new(s, desc: COMPLEX_SKILLS[str][s])
        }
        ComplexSkill.new(str, skills: subs)
      else
        raise(UnknownSkill, str)
      end
    end

    def initialize
      @skills = {}
    end

    def to_h
      @skills
    end

    def count(subskills: false)
      return @skills.size unless subskills
      count = 0
      @skills.values.each { |skill|
        count += 1
        count += skill.skills.size if skill.respond_to? :skills
      }
      count
    end

    # return the skill for name, or nil
    def [](name)
      first, rest = SkillSet.split_skill!(name)
      return unless @skills.key?(first)
      rest ? @skills[first][rest] : @skills[first]
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
      first, rest = SkillSet.split_skill!(name)
      @skills[first] ||= SkillSet.new_skill(first)
      rest ? @skills[first][rest] : @skills[first]
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
        if cpx.skills.empty?
          report << format("%s: %s", name.rjust(width, ' '), cpx)
        else
          report << "[#{cpx.name}]"
          cpx.skills.each { |subname, subskill|
            label = "- #{subname}".rjust(width, ' ')
            report << format("%s: %s", label, subskill)
          }
        end
      }
      report.join("\n")
    end

    COMPLEX_SKILLS = {
      'Animals' => {
        'Handling' => '',
        'Veterinary' => '',
        'Training' => '',
      },
      'Art' => {
        'Performer' => '',
        'Holography' => '',
        'Instrument' => '',
        'Visual Media' => '',
        'Write' => '',
      },
      'Athletics' => {
        'Dexterity' => '',
        'Endurance' => '',
        'Strength' => '',
      },
      'Drive' => {
        'Hovercraft' => '',
        'Mole' => '',
        'Track' => '',
        'Walker' => '',
        'Wheel' => '',
      },
      'Electronics' => {
        'Comms' => '',
        'Computers' => '',
        'Remote Ops' => '',
        'Sensors' => '',
      },
      'Engineer' => {
        'Manoeuvre' => '',
        'Jump Drive' => '',
        'Life Support' => '',
        'Power' => '',
      },
      'Flyer' => {
        'Airship' => '',
        'Grav' => '',
        'Ornithopter' => '',
        'Rotor' => '',
        'Wing' => '',
      },
      'Gunner' => {
        'Turret' => '',
        'Ortillery' => '',
        'Screen' => '',
        'Capital' => '',
      },
      'Gun Combat' => {
        'Archaic' => '',
        'Energy' => '',
        'Slug' => '',
      },
      'Heavy Weapons' => {
        'Artillery' => '',
        'Man Portable' => '',
        'Vehicle' => '',
      },
      'Language' => {
        'Anglic' => '',
        'Vilani' => '',
        'Zdetl' => '',
        'Oynprith' => '',
      },
      'Melee' => {
        'Blade' => '',
        'Bludgeon' => '',
        'Natural' => '',
        'Unarmed' => '',
      },
      'Pilot' => {
        'Small Craft' => '',
        'Spacecraft' => '',
        'Capital' => '',
      },
      'Profession' => {
        'Belter' => '',
        'Biologicals' => '',
        'Civil Engineering' => '',
        'Construction' => '',
        'Hydroponics' => '',
        'Polymers' => '',
      },
      'Science' => {
        'Archaeology' => '',
        'Astronomy' => '',
        'Biology' => '',
        'Chemistry' => '',
        'Cosmology' => '',
        'Cybernetics' => '',
        'Economics' => '',
        'Genetics' => '',
        'History' => '',
        'Linguistics' => '',
        'Philosophy' => '',
        'Physics' => '',
        'Planetology' => '',
        'Psionicology' => '',
        'Psychology' => '',
        'Robotics' => '',
        'Sophontology' => '',
        'Xenology' => '',
      },
      'Seafarer' => {
        'Ocean Ships' => '',
        'Personal' => '',
        'Sail' => '',
        'Submarine' => '',
      },
      'Tactics' => {
        'Military' => '',
        'Naval' => '',
      },
    }

    SIMPLE_SKILLS = {
      'Admin' => '',
      'Advocate' => '',
      'Astrogation' => '',
      'Broker' => '',
      'Carouse' => '',
      'Deception' => '',
      'Diplomat' => '',
      'Explosives' => '',
      'Gambler' => '',
      'Investigate' => '',
      'Jack Of All Trades' => '',
      'Leadership' => '',
      'Mechanic' => '',
      'Medic' => '',
      'Navigation' => '',
      'Persuade' => '',
      'Recon' => '',
      'Stealth' => '',
      'Steward' => '',
      'Streetwise' => '',
      'Survival' => '',
      'Vacc Suit' => '',
    }

  end
end
