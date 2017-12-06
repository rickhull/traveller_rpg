require 'traveller_rpg/homeworld'
require 'minitest/autorun'

include TravellerRPG

describe Homeworld do
  describe "new instance" do
    before do
      @homeworld = Homeworld.new('Place')
    end

    it "must have traits" do
      traits = @homeworld.traits
      traits.wont_be_empty
      traits.first.must_be_kind_of Symbol
      (Homeworld::TRAIT_MIN..Homeworld::TRAIT_MAX).must_include traits.size
    end

    it "must have skills" do
      skills = @homeworld.skills
      skills.wont_be_empty
      skills.first.must_be_kind_of String
      skills.size.must_be :>=, @homeworld.traits.size
    end
  end
end
