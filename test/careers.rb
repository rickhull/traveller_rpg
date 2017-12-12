require 'traveller_rpg/careers'
require 'traveller_rpg/character'
require 'traveller_rpg/skill_set'
require 'minitest/autorun'

include TravellerRPG

describe Careers do
  describe Careers.method(:load) do
    it "does not require a path or extension" do
      Careers.load('base').must_be_kind_of Hash
    end
  end

  describe Careers.method(:find) do
    it "does not require a path or extension" do
      File.readable?(Careers.find('base')).must_equal true
    end
  end

  describe Careers.method(:skill?) do
    it "accepts a string and returns true or false" do
      ['Art', 'Art:Holography'].each { |valid|
        Careers.skill?(valid).must_equal true
      }
      ['Nope', 'art', :art, :Art, :endurance, 'endurance'].each { |invalid|
        Careers.skill?(invalid).must_equal false
      }
    end
  end

  describe Careers.method(:stat?) do
    it "accepts a symbol or string and returns true or false" do
      [:strength, 'endurance', :dexterity, 'social Status'].each { |valid|
        Careers.stat?(valid).must_equal true
      }
      ['art', :art, :Art, :Endurance, :Social_Status].each { |invalid|
        Careers.stat?(invalid).must_equal false
      }
    end
  end

  describe Careers.method(:stat_sym!) do
    it "accepts a symbol or string and returns a symbol or raises" do
      [:strength, 'endurance'].each { |valid|
        sym = Careers.stat_sym!(valid)
        sym.must_be_kind_of Symbol
        if valid == :strength
          sym.must_equal :strength
        elsif valid == 'endurance'
          sym.must_equal :endurance
        end
      }
      ['art', :art, :Endurance].each { |invalid|
        proc { Careers.stat_sym!(invalid) }.must_raise Careers::UnknownStat
      }
    end
  end

  describe Careers.method(:stat_sym) do
    it "accepts a symbol or a string and returns a symbol or input" do
      [:strength, 'endurance'].each { |valid|
        sym = Careers.stat_sym(valid)
        sym.must_be_kind_of Symbol
        if valid == :strength
          sym.must_equal :strength
        elsif valid == 'endurance'
          sym.must_equal :endurance
        end
      }
      ['art', :art, :Endurance].each { |invalid|
        Careers.stat_sym(invalid).must_equal invalid
      }
    end
  end

  # TODO: KEEP GOING!
end
