require 'traveller_rpg/homeworld'
require 'minitest/autorun'

include TravellerRPG

describe Homeworld do
  describe "new instance" do
    before do
      @generated = Homeworld.new('Place')
      @traits = {
        economy: :agricultural,
        wealth: :poor,
        population: :low_population,
        environment: :lunar,
      }
      @specified = Homeworld.new('Locale', @traits)
    end

    it "generates traits" do
      traits = @generated.traits
      traits.wont_be_empty
      traits.first.must_be_kind_of Symbol
      (Homeworld::TRAIT_MIN..Homeworld::TRAIT_MAX).must_include traits.size
    end

    it "has specified traits" do
      traits = @specified.traits
      traits.wont_be_empty
      traits.must_equal @traits.values
    end

    it "must have skills" do
      skills = @generated.skills
      skills.wont_be_empty
      skills.first.must_be_kind_of String
      skills.size.must_be :>=, @generated.traits.size

      @specified.skills.must_include 'Animals'
      @specified.skills.size.must_equal 8
    end

    it "must choose skills" do
      @specified.skills.size.must_equal 8 # sanity check
      out, _err = capture_io { @specified.choose_skills(5).size.must_equal 5 }
      out.wont_be_empty
      out, _err = capture_io { @specified.choose_skills(10).size.must_equal 8 }
      out.must_be_empty
    end
  end
end
