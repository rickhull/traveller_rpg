require 'traveller_rpg'

module TravellerRPG
  class Homeworld
    TRAITS = {
      agricultural: :animals,
      asteroid: :zero_g,
      desert: :survival,
      fluid_oceans: :seafarer,
      garden: :animals,
      high_technology: :computers,
      high_population: :streetwise,
      ice_capped: :vacc_suit,
      industrial: :trade,
      low_technology: :survival,
      poor: :animals,
      rich: :carouse,
      water_world: :seafarer,
      vacuum: :vacc_suit,
      education: [:admin, :advocate, :art, :carouse, :comms,
                  :computer, :drive, :engineer, :language, :medic,
                  :physical_science, :life_science, :social_science,
                  :space_science, :trade],
    }
    TRAIT_MIN = 3
    TRAIT_MAX = 6

    attr_reader :name, :traits, :skills

    def initialize(name, traits = [])
      @name = name
      if traits.size > self.class::TRAIT_MAX
        warn "lots of world traits: #{traits}"
      elsif traits.empty?
        sample_num = rand(TRAIT_MAX - TRAIT_MIN + 1) + TRAIT_MIN
        traits = self.class::TRAITS.keys.sample(sample_num)
      end
      @traits = traits
      @skills = []
      @traits.each { |trait|
        skill = self.class::TRAITS.fetch(trait)
        if skill.is_a?(Array)
          skill.each { |sk| @skills << sk }
        else
          @skills << skill
        end
      }
      @skills.uniq!
    end
  end
end
