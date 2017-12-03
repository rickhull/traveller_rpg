require 'traveller_rpg'

module TravellerRPG
  class Homeworld
    TRAITS = {
      agricultural: :animals_group,
      asteroid: :zero_g,
      desert: :survival,
      fluid_oceans: :seafarer_group,
      garden: [:animals_riding, :animals_veterinary],
      high_technology: :computers,
      high_population: :streetwise,
      ice_capped: :vacc_suit,
      industrial: :trade_group,
      low_technology: :survival,
      poor: :animals_group,
      rich: :carouse,
      water_world: :seafarer_group,
      vacuum: :vacc_suit,
      education: [:admin, :advocate, :art_group, :carouse, :comms,
                  :computers, :drive_group, :engineer_group, :language_group,
                  :medic, :physical_sciences_group, :life_sciences_group,
                  :social_sciences_group, :space_sciences_group, :trade_group],
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
