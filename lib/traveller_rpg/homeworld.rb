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

    def initialize(name) # TODO: allow trait initialization
      @name = name
      sample_num = rand(TRAIT_MAX - TRAIT_MIN + 1) + TRAIT_MIN
      @skills = []
      @traits = self.class::TRAITS.keys.sample(sample_num).map { |t|
        k = TRAITS[t].keys.sample
        @skills += TRAITS[t][k]
        k
      }
      @skills.uniq!
    end
  end
end
