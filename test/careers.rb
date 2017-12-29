require 'traveller_rpg/careers'
require 'traveller_rpg/character'
require 'traveller_rpg/skill_set'
require 'minitest/autorun'

include TravellerRPG

describe Careers do
  before do
    @valid_skills = ['Art', 'Art:Holography']
    @invalid_skills = ['Nope', 'art', :art, :Art, :endurance, 'endurance']
    @valid_stats = [:strength, 'endurance', :dexterity, 'social Status']
    @invalid_stats = ['art', :art, :Art, :Endurance, :Social_Status]
  end

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
      @valid_skills.each { |v| Careers.skill?(v).must_equal true }
      @invalid_skills.each { |iv| Careers.skill?(iv).must_equal false }
    end
  end



  describe Careers.method(:stat?) do
    it "accepts a symbol or string and returns true or false" do
      @valid_stats.each { |v| Careers.stat?(v).must_equal true }
      @invalid_stats.each { |iv| Careers.stat?(iv).must_equal false }
    end
  end

  describe Careers.method(:stat_sym!) do
    it "accepts a symbol or string and returns a symbol or raises" do
      @valid_stats.each { |v|
        sym = Careers.stat_sym!(v)
        sym.must_be_kind_of Symbol
        if v == :strength
          sym.must_equal :strength
        elsif v == 'endurance'
          sym.must_equal :endurance
        end
      }
      @invalid_stats.each { |iv|
        proc { Careers.stat_sym!(iv) }.must_raise Careers::UnknownStat
      }
    end
  end

  describe Careers.method(:stat_sym) do
    it "accepts a symbol or a string and returns a symbol or input" do
      @valid_stats.each { |v|
        sym = Careers.stat_sym(v)
        sym.must_be_kind_of Symbol
        if v == :strength
          sym.must_equal :strength
        elsif v == 'endurance'
          sym.must_equal :endurance
        end
      }
      @invalid_stats.each { |iv| Careers.stat_sym(iv).must_equal iv }
    end
  end

  describe Careers.method(:fetch_stat_check!) do
    before do
      @simple = { 'endurance' => 5 }
      @choose = { 'choose' => {
                    'endurance' => 5,
                    'intelligence' => 6,
                  },
                }
      @invalid_hsh = { 'endurance' => 5,
                       'intelligence' => 6
                     }
      @invalid_key = { 'xyz' => 5 }
    end

    it "fetches a key from hsh" do
      hsh = { 'xyz' => @simple }
      Careers.fetch_stat_check!(hsh, 'xyz').must_be_kind_of Hash
      proc {
        Careers.fetch_stat_check!(hsh, 'stuff')
      }.must_raise Careers::StatCheckError
    end

    it "validates some stats" do
      hsh = { 'abc' => @simple }
      Careers.fetch_stat_check!(hsh, 'abc').must_be_kind_of Hash

      hsh = { 'abc' => @invalid_key }
      proc {
        Careers.fetch_stat_check!(hsh, 'abc')
      }.must_raise Careers::UnknownStat

      hsh = { 'abc' => @choose }
      Careers.fetch_stat_check!(hsh, 'abc').must_be_kind_of Hash
    end

    it "validates the size of the subhash" do
      hsh = { 'abc' => @invalid_hsh }
      proc {
        Careers.fetch_stat_check!(hsh, 'abc')
      }.must_raise Careers::StatCheckError
    end

    it "converts some strings to symbols" do
      hsh = { 'abc' => @simple }
      result = Careers.fetch_stat_check!(hsh, 'abc')
      result.keys.must_equal [:endurance]
    end

    it "handles 'choose'" do
      hsh = { 'abc' => @choose }
      result = Careers.fetch_stat_check!(hsh, 'abc')
      result.keys.must_equal [:choose]
      result[:choose].keys.must_equal [:endurance, :intelligence]
    end

    it "returns a new hash" do
      hsh = { 'abc' => @simple }
      result = Careers.fetch_stat_check!(hsh, 'abc')
      result.object_id.wont_equal hsh
      result.object_id.wont_equal @simple
    end
  end

  describe Careers.method(:fetch_skills!) do
    before do
      @simple = ['Admin', 'Survival', 'Navigation',
                 'Persuade', 'Deception', 'Gambler']
      @complex = ['Art', 'Pilot', 'Science', 'Tactics', 'Flyer', 'Melee']
      @subskills = ['Art:Holography', 'Pilot:Small Craft', 'Seafarer:Sail',
                    'Gunner:Turret', 'Art:Write', 'Heavy Weapons:Man Portable']
      @invalid_str = ['abc', '123', 'dog', 'cat', 'Art:Ology', '']
    end

    it "fetches a key from hsh" do
      hsh = { 'abc' => @simple }
      Careers.fetch_skills!(hsh, 'abc').must_be_kind_of Array
      proc {
        Careers.fetch_skills!(hsh, 'stuff')
      }.must_raise Careers::SkillError
    end

    it "validates skills" do
      [@simple, @complex, @subskills].each { |valid|
        hsh = { 'abc' => valid }
        Careers.fetch_skills!(hsh, 'abc').must_be_kind_of Array
      }

      hsh = { 'abc' => @invalid_str }
      proc {
        Careers.fetch_skills!(hsh, 'abc')
      }.must_raise Careers::UnknownSkill
    end

    it "can allow and validate stats" do
      all_stats = ['strength', 'endurance', :dexterity, 'intelligence',
                   'education', :social_status]
      hsh = { 'abc' => all_stats }
      Careers.fetch_skills!(hsh, 'abc', stats_ok: true).must_be_kind_of Array

      proc {
        Careers.fetch_skills!(hsh, 'abc', stats_ok: false)
      }.must_raise Careers::UnknownSkill
    end

    it "converts some strings to symbols" do
    end

    it "returns a new array" do
    end

    it "handles 'choose'" do
    end
  end

  describe Careers.method(:ranks) do
    it "fetches a key from hsh" do
    end

    it "validates skills and stats" do
    end

    it "converts some strings to symbols" do
    end

    it "returns a new hash" do
    end
  end

  describe Careers.method(:specialist) do
    it "fetches a key from hsh" do
    end

    it "calls fetch_stat_check!" do
    end

    it "calls fetch_skills!" do
    end

    it "calls ranks" do
    end

    it "returns a new hash" do
    end
  end

  describe Careers.method(:events) do
    it "fetches a key from hsh" do
    end

    it "converts some strings to symbols" do
    end

    it "returns a new hash" do
    end
  end

  describe Careers.method(:credits) do
    it "fetches a key from hsh" do
    end

    it "converts an array to hash with index math" do
    end
  end

  describe Careers.method(:benefits) do
    it "fetches a key from hsh" do
    end

    it "converts an array to hash with index math" do
    end

    it "handles String, Array, Hash" do
    end

    it "handles 'choose'" do
    end
  end
end
