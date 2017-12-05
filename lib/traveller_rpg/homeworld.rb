require 'traveller_rpg'

module TravellerRPG
  class Homeworld
    TRAITS = {
      economy: {
        agricultural: ['Animals'],
        industrial:   ['Profession'],
      },
      wealth: {
        poor:         ['Melee:Unarmed', 'Medic'],
        rich:         ['Carouse', 'Gambler', 'Profession'],
      },
      population: {
        low_technology:  ['Survival', 'Animals'],
        high_technology: ['Electronics', 'Science', 'Astrogation'],
        high_population: ['Art', 'Broker', 'Diplomat', 'Leadership',
                          'Profession', 'Streetwise'],
      },
      environment: {
        lunar:      ['Science:Astronomy', 'Science:Cosmology',   'Vacc Suit'],
        ice_capped: ['Science:Astronomy', 'Science:Planetology', 'Vacc Suit'],
        fluid_oceans: ['Seafarer'],
        water_world:  ['Seafarer', 'Flyer'],
        desert:       ['Survival'],
        garden:       ['Animals:Handling', 'Art'],
      },
    }
    TRAIT_MIN = 2
    TRAIT_MAX = 4

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
