require 'traveller_rpg'

module TravellerRPG
  class Homeworld
    TRAITS = {
      economy: {
        agricultural: ['Animals'],
        industrial:   ['Profession'],
        high_tech:    ['Electronics', 'Science', 'Astrogation'],
      },
      wealth: {
        poor:         ['Melee:Unarmed', 'Medic'],
        rich:         ['Carouse', 'Gambler', 'Profession'],
      },
      population: {
        low_population:  ['Survival', 'Jack Of All Trades'],
        high_population: ['Art', 'Broker', 'Diplomat', 'Leadership',
                          'Profession', 'Streetwise'],
      },
      environment: {
        lunar:      ['Science:Astronomy', 'Science:Cosmology',   'Vacc Suit'],
        ice_capped: ['Science:Astronomy', 'Science:Planetology', 'Vacc Suit'],
        fluid_oceans: ['Seafarer', 'Navigation'],
        water_world:  ['Seafarer', 'Tactics:Naval'],
        desert:       ['Survival', 'Flyer'],
        garden:       ['Animals:Handling', 'Art'],
      },
    }
    TRAIT_MIN = 2
    TRAIT_MAX = TRAITS.keys.size

    attr_reader :name, :traits, :skills

    def initialize(name, traits = {})
      @name = name
      @skills = []

      # TODO: def @skills.choose(count)

      if traits.empty?
        trait_count = rand(TRAIT_MAX - TRAIT_MIN + 1) + TRAIT_MIN
        @traits = self.class::TRAITS.keys.sample(trait_count).map { |t|
          k = TRAITS[t].keys.sample
          @skills += TRAITS[t][k]
          k
        }
      else
        @traits = []
        traits.each { |type, trait|
          @skills += TRAITS.fetch(type).fetch(trait)
          @traits << trait
        }
      end
      @skills.uniq!
    end

    def choose_skills(count)
      s = @skills.dup
      if @skills.size > count
        Array.new(count) {
          s.delete TravellerRPG.choose("Choose background skill:", *s)
        }
      else
        s
      end
    end
  end
end
