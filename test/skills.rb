require 'traveller_rpg/skills'
require 'minitest/autorun'

describe "TravellerRPG.skill?" do
  it "recognizes subskills" do
    TravellerRPG.skill?('Animals:Handling').must_equal true
    TravellerRPG.skill?(:animals, :handling).must_equal true
  end

  it "must accept a single string arg" do
    ['Admin', 'Animals', 'Animals:Handling'].each { |valid|
      TravellerRPG.skill?(valid).must_equal true
    }
  end

  it "must reject multiple string args" do
    proc { TravellerRPG.skill?('This', 'That') }.must_raise ArgumentError
  end

  it "must accept any number of symbol args" do
    [[:admin], [:animals], [:animals, :handling]].each { |valid|
      TravellerRPG.skill?(*valid).must_equal true
    }
  end
end

describe "TravellerRPG.skill" do
  it "does not recognize subskills" do
    proc { TravellerRPG.skill('Animals:Handling') }.must_raise KeyError
    proc { TravellerRPG.skill(:animals, :handling) }.must_raise ArgumentError
  end

  it "accepts a single symbol to find a Skill or ComplexSkill" do
    TravellerRPG.skill(:admin).must_be_kind_of Skill
    TravellerRPG.skill(:animals).must_be_kind_of ComplexSkill
  end
end

describe "TravellerRPG.known_skill?" do
  it "recognizes subskills" do
    TravellerRPG.known_skill?('Animals:Handling').must_equal true
  end

  it "must accept a single string arg do" do
    ['Admin', 'Animals', 'Animals:Handling'].each { |valid|
      TravellerRPG.skill?(valid).must_equal true
    }
  end
end

describe "TravellerRPG.new_skill" do
  it "does not recognize subskills" do
    proc { TravellerRPG.new_skill('Animals:Handling') }.must_raise RuntimeError
  end

  it "accepts a string to find a Skill or ComplexSkill" do
    TravellerRPG.new_skill('Admin').must_be_kind_of Skill
    TravellerRPG.new_skill('Animals').must_be_kind_of ComplexSkill
  end
end
