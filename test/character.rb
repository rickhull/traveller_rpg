require 'traveller_rpg/character'
require 'minitest/autorun'

include TravellerRPG

describe Character do
  describe Character::Stats do
    before do
      @new = Character::Stats.new      # nils
      @empty = Character::Stats.empty  # 0s
      @roll = Character::Stats.roll    # randos
    end

    describe Character::Stats.method(:new) do
      it "returns a set of Stats with nil values" do
        @new.strength.must_be_nil
        @new.dexterity.must_be_nil
        @new[:endurance].must_be_nil
        @new[:intelligence].must_be_nil
        @new['education'].must_be_nil
        @new['social_status'].must_be_nil
      end
    end

    describe Character::Stats.method(:empty) do
      it "returns a set of Stats at 0" do
        @empty.strength.must_equal 0
        @empty.dexterity.must_equal 0
        @empty[:endurance].must_equal 0
        @empty[:intelligence].must_equal 0
        @empty['education'].must_equal 0
        @empty['social_status'].must_equal 0
      end
    end

    describe Character::Stats.method(:roll) do
      it "returns a randomized set of Stats" do
        (2..12).must_include @roll.strength
        (2..12).must_include @roll.dexterity
        (2..12).must_include @roll[:endurance]
        (2..12).must_include @roll[:intelligence]
        (2..12).must_include @roll['education']
        (2..12).must_include @roll['social_status']
      end
    end

    describe "Stats#boost" do
      it "accepts a hash to increase values" do
        @empty.boost(strength: 3)
        @empty.strength.must_equal 3
        @empty.dexterity.must_equal 0
        @empty.boost(dexterity: 3, endurance: 3)
        @empty.dexterity.must_equal 3
        @empty.endurance.must_equal 3
      end

      it "raises on unknown stats" do
        proc { @empty.boost(stuff: 99) }.must_raise NameError
      end
    end

    describe "Stats#bump" do
      it "accepts a symbol and optional value to increase a stat" do
        @empty.bump(:strength)
        @empty.strength.must_equal 1
      end

      it "accepts a symbol and value to set the value" do
        @empty.bump(:dexterity, 2)
        @empty.dexterity.must_equal 2
        @empty.bump(:dexterity, 2)
        @empty.dexterity.wont_equal 4  # !!!
        @empty.dexterity.must_equal 2
      end

      it "raises on unknown symbol" do
        proc { @empty.bump(:stuff) }.must_raise NameError
      end
    end
  end

  describe Character::Description do
    before do
      @desc = Character::Description.new('Bob', 'M', 18, 'Fair', 'Stuff', 'X')
    end

    describe "Description#merge" do
      it "accepts a Description or a Hash and acts like Hash#merge" do
        @desc.merge(name: 'Robert').name.must_equal 'Robert'
        @desc.name.must_equal 'Bob'
      end
    end
  end

  describe Character.method(:stats_dm) do
    it "converts 0..20 to -3..3" do
      {0 => -3, 1 => -2, 4 => -1, 7 => 0,
       10 => 1, 13 => 2, 16 => 3, 20 => 3 }.each { |input, output|
        Character.stats_dm(input).must_equal output
      }
      [-1, 21].each { |oob|
        proc { Character.stats_dm(oob) }.must_raise RuntimeError
      }
    end
  end

  describe "new instance" do
    before do
      @desc = Character::Description.new('Bob', 'M', 18, 'A', 'P', 'T')
      @stats = Character::Stats.roll
      @home = Homeworld.new('Earth')
      capture_io do
        @char = Character.new(desc: @desc, stats: @stats, homeworld: @home)
      end
    end

    describe "Character#stats_dm" do
      it "accepts a stat symbol and returns a value -3..3" do
        @char.stats_dm(:strength).must_be :>=, -3
        @char.stats_dm(:dexterity).must_be :<=, 3
      end
    end

    describe "Character#provide_one" do
      it "takes skill names and returns a Skill or ComplexSkill" do
        complex_skill = 'Athletics'
        skill = nil
        capture_io { skill = @char.provide_one(complex_skill) }
        skill.must_be_kind_of ComplexSkill
        skill.level.must_equal 0
        @char.provide_one(complex_skill).must_be_nil
        @char.provide_one(Array.new(rand(2) + 2, 'Athletics')).must_be_nil
        capture_io do
          @char.provide_one(%w{Admin Broker Recon}).must_be_kind_of Skill
        end
      end
    end

    describe "Character#benefit" do
      it "accepts an Integer (credits) or a singular String" do
        @char.credits.must_equal 0
        capture_io { @char.benefit(5) }
        @char.credits.must_equal 5
        @char.stuff['Violin'].must_be_nil
        capture_io { @char.benefit('Violin') }
        @char.stuff['Violin'].must_equal 1
      end
    end

    describe "Character#log" do
      it "returns the log with no arg" do
        @char.log.must_be_kind_of Array
        @char.log.wont_be_empty
      end

      it "accumulates messages with an arg" do
        size = @char.log.size
        capture_io { @char.log "Stuff" }
        @char.log.size.must_equal size + 1
      end
    end

    describe "Character#age" do
      it "returns the age with no arg" do
        @char.age.must_equal 18
      end

      it "advances the age with an arg" do
        @char.age 2
        @char.age.must_equal 20
      end
    end

    describe "Character#cash_roll" do
      it "tracks rolls for credits; ignored after 3 rolls" do
        @char.credits.must_equal 0
        @char.cash_rolls.must_equal 0
        5.times { capture_io { @char.cash_roll(100) } }
        @char.credits.wont_equal 500
        @char.credits.must_equal 300
        @char.cash_rolls.must_equal 5
      end
    end

    describe "Character#birth" do
      it "is a private method" do
        proc { @char.birth @home }.must_raise NoMethodError
      end

      it "is performed at instantiation" do
        # character gets background skills from homeworld
        @char.log.empty?.must_equal false
        @char.skills.empty?.must_equal false
      end

      it "raises when Character#log isn't empty" do
        proc { @char.send(:birth, @home) }.must_raise RuntimeError
      end
    end
  end
end
