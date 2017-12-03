require 'traveller_rpg'
require 'traveller_rpg/data'
require 'traveller_rpg/character'
require 'traveller_rpg/homeworld'

module TravellerRPG
  module Generator
    def self.character(descr = {}, homeworld: nil)
      homeworld ||= self.homeworld
      Character.new(desc: self.desc.merge(descr),
                    stats: Character::Stats.roll,
                    homeworld: homeworld)
    end

    def self.homeworld(name = nil)
      name ||= Data.sample('homeworlds.txt')
      Homeworld.new(name)
    end

    def self.name(gender)
      case gender.to_s.downcase
      when 'm', 'male'
        Data.sample('male_names.txt')
      when 'f', 'female'
        Data.sample('female_names.txt')
      else
        raise "unknown gender: #{gender}"
      end
    end

    def self.gender
      TravellerRPG.roll(dice: 1) > 3 ? 'M' : 'F'
    end

    def self.hair(tone: nil, body: nil, color: nil, length: nil)
      tone ||= Data.sample('hair_tone.txt')
      body ||= Data.sample('hair_body.txt')
      color ||= Data.sample('hair_colors.txt')
      length ||= Data.sample('hair_length.txt')
      [tone, body, color, length].join(' ')
    end

    def self.appearance(hair: nil, skin: nil)
      hair ||= self.hair
      skin ||= Data.sample('skin_tones.txt')
      "#{hair} hair with #{skin} skin"
    end

    def self.plot
      Data.sample('plots.txt')
    end

    def self.temperament
      Data.sample('temperaments.txt')
    end

    def self.desc
      gender = self.gender
      Character::Description.new(self.name(gender), gender, 18,
                                 self.appearance, self.plot, self.temperament)
    end
  end
end
