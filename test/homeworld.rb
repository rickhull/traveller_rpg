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
        environment: :ice_capped,
      }
      @specified = Homeworld.new('Locale', @traits)
      @num_skills = 7
    end

    it "generates traits" do
      traits = @generated.traits
      expect(traits).wont_be_empty
      expect(traits.first).must_be_kind_of Symbol
      expect((Homeworld::TRAIT_MIN..Homeworld::TRAIT_MAX)).must_include traits.size
    end

    it "has specified traits" do
      traits = @specified.traits
      expect(traits).wont_be_empty
      expect(traits).must_equal @traits.values
    end

    it "must have skills" do
      skills = @generated.skills
      expect(skills).wont_be_empty
      expect(skills.first).must_be_kind_of String
      expect(skills.size).must_be :>=, @generated.traits.size

      expect(@specified.skills).must_include 'Animals'
      expect(@specified.skills.size).must_equal @num_skills
    end

    it "must choose skills" do
      expect(@specified.skills.size).must_equal @num_skills # sanity check
      out, _err = capture_io { expect(@specified.choose_skills(5).size).must_equal 5 }
      expect(out).wont_be_empty
      out, _err = capture_io do
        expect(@specified.choose_skills(10).size).must_equal @num_skills
      end
      expect(out).must_be_empty
    end
  end
end
