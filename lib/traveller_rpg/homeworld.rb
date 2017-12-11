require 'traveller_rpg'

module TravellerRPG
  class Homeworld
    TRAITS = {
      economy: {
        agricultural: ['Animals'],
        industrial:   ['Profession'],
        high_tech:    ['Astrogation', 'Electronics'],
      },
      wealth: {
        poor:         ['Medic',   'Melee'],
        rich:         ['Carouse', 'Gambler', 'Profession'],
      },
      population: {
        low_population:  ['Jack Of All Trades', 'Survival'],
        high_population: ['Art', 'Streetwise'],
      },
      environment: {
        desert:       ['Flyer',      'Survival'],
        fluid_oceans: ['Navigation', 'Seafarer'],
        garden:       ['Animals',    'Art'],
        ice_capped:   ['Science',    'Vacc Suit'],
        minerals:     ['Drive',      'Explosives'],
        water_world:  ['Seafarer',   'Tactics'],
      },
    }
    TRAIT_MIN = 3
    TRAIT_MAX = TRAITS.keys.size

    attr_reader :name, :traits, :skills

    def initialize(name, traits = {})
      @name = name
      @skills = []

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
      def @skills.choose(count)
        s = self.dup
        return s if s.size < count
        Array.new(count) {
          s.delete TravellerRPG.choose("Choose background skill:", *s)
        }
      end
    end

    def choose_skills(count)
      s = @skills.dup
      return s if s.size <= count
      Array.new(count) {
        s.delete TravellerRPG.choose("Choose background skill:", *s)
      }
    end
  end
end
