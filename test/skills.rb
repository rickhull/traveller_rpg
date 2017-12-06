require 'traveller_rpg/skills'
require 'minitest/autorun'

describe "TravellerRPG.known_skill?" do
  it "recognizes subskills" do
    TravellerRPG.known_skill?('Animals:Handling').must_equal true
  end

  it "must accept a single string arg do" do
    ['Admin', 'Animals', 'Animals:Handling'].each { |valid|
      TravellerRPG.known_skill?(valid).must_equal true
    }
  end

  it "must reject multiple string args" do
    proc { TravellerRPG.known_skill?('This', 'That') }.must_raise ArgumentError
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
