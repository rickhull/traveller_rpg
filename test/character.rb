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

    describe Character::Stats.method(:sym) do
      it "converts a string to a symbol" do
        valid = { 'ABC DEF' => :abc_def,
                  'asDf' => :asdf,
                  'Social Status' => :social_status }
        valid.each { |str, sym|
          expect(Character::Stats.sym(str)).must_equal sym
        }
      end

      it "returns any symbol passed in" do
        [:asdf, :social_status, :"any-thing-goes"].each { |sym|
          expect(Character::Stats.sym(sym)).must_equal sym
        }
      end
    end

    describe Character::Stats.method(:member?) do
      it "accepts a string or symbol and returns true or false" do
        [:strength, 'Dexterity', 'enDuRance', 'social Status'].each { |valid|
          expect(Character::Stats.member?(valid)).must_equal true
        }
        ['xStrength', 'dexterity endurance', 'a-s_d-fg#*'].each { |invalid|
          expect(Character::Stats.member?(invalid)).must_equal false
        }
      end
    end

    describe Character::Stats.method(:new) do
      it "returns a set of Stats with nil values" do
        expect(@new.strength).must_be_nil
        expect(@new.dexterity).must_be_nil
        expect(@new[:endurance]).must_be_nil
        expect(@new[:intelligence]).must_be_nil
        expect(@new['education']).must_be_nil
        expect(@new['social_status']).must_be_nil
      end
    end

    describe Character::Stats.method(:empty) do
      it "returns a set of Stats at 0" do
        expect(@empty.strength).must_equal 0
        expect(@empty.dexterity).must_equal 0
        expect(@empty[:endurance]).must_equal 0
        expect(@empty[:intelligence]).must_equal 0
        expect(@empty['education']).must_equal 0
        expect(@empty['social_status']).must_equal 0
      end
    end

    describe Character::Stats.method(:roll) do
      it "returns a randomized set of Stats" do
        expect((2..12)).must_include @roll.strength
        expect((2..12)).must_include @roll.dexterity
        expect((2..12)).must_include @roll[:endurance]
        expect((2..12)).must_include @roll[:intelligence]
        expect((2..12)).must_include @roll['education']
        expect((2..12)).must_include @roll['social_status']
      end
    end

    describe "Stats#boost" do
      it "accepts a hash to increase values" do
        @empty.boost(strength: 3)
        expect(@empty.strength).must_equal 3
        expect(@empty.dexterity).must_equal 0
        @empty.boost(dexterity: 3, endurance: 3)
        expect(@empty.dexterity).must_equal 3
        expect(@empty.endurance).must_equal 3
      end

      it "raises on unknown stats" do
        expect { @empty.boost(stuff: 99) }.must_raise NameError
      end
    end

    describe "Stats#bump" do
      it "accepts a symbol and optional value to increase a stat" do
        @empty.bump(:strength)
        expect(@empty.strength).must_equal 1
      end

      it "accepts a symbol and value to set the value" do
        @empty.bump(:dexterity, 2)
        expect(@empty.dexterity).must_equal 2
        @empty.bump(:dexterity, 2)
        expect(@empty.dexterity).wont_equal 4  # !!!
        expect(@empty.dexterity).must_equal 2
      end

      it "raises on unknown symbol" do
        expect { @empty.bump(:stuff) }.must_raise NameError
      end
    end
  end

  describe Character::Description do
    before do
      @desc = Character::Description.new('Bob', 'M', 18, 'Fair', 'Stuff', 'X')
    end

    describe "Description#merge" do
      it "accepts a Description or a Hash and acts like Hash#merge" do
        expect(@desc.merge(name: 'Robert').name).must_equal 'Robert'
        expect(@desc.name).must_equal 'Bob'
      end
    end
  end

  describe Character.method(:stats_dm) do
    it "converts 0..20 to -3..3" do
      {0 => -3, 1 => -2, 4 => -1, 7 => 0,
       10 => 1, 13 => 2, 16 => 3, 20 => 3 }.each { |input, output|
        expect(Character.stats_dm(input)).must_equal output
      }
      [-1, 21].each { |oob|
        expect { Character.stats_dm(oob) }.must_raise RuntimeError
      }
    end
  end

  describe "new instance" do
    before do
      @desc = Character::Description.new('Bob', 'M', 18, 'A', 'P', 'T')
      @stats = Character::Stats.roll
      capture_io { @char = Character.new(desc: @desc, stats: @stats) }
    end

    describe "Character#stats_dm" do
      it "accepts a stat symbol and returns a value -3..3" do
        expect(@char.stats_dm(:strength)).must_be :>=, -3
        expect(@char.stats_dm(:dexterity)).must_be :<=, 3
      end
    end

    describe "Character#basic_training" do
      it "accepts a String and returns self" do
        ['Admin', 'Art'].each { |skill|
          capture_io { expect(@char.basic_training(skill)).must_equal @char }
        }
      end

      it "trains an untrained skill to 0" do
        ['Admin', 'Art'].each { |skill|
          expect(@char.skills.level(skill)).must_be_nil
          capture_io { @char.basic_training(skill) }
          expect(@char.skills.level(skill)).must_equal 0
        }
      end

      it "does nothing for a trained skill" do
        ['Admin', 'Art'].each { |skill|
          expect(@char.skills.level(skill)).must_be_nil
          capture_io { @char.basic_training(skill) }
          expect(@char.skills.level(skill)).must_equal 0

          # 2nd time
          capture_io { @char.basic_training(skill) }
          expect(@char.skills.level(skill)).must_equal 0
        }
      end
    end

    describe "Character#benefit" do
      it "accepts an Integer representing credits" do
        expect(@char.credits).must_equal 0
        capture_io { @char.benefit(5) }
        expect(@char.credits).must_equal 5
      end

      it "accepts a String representing a single item" do
        expect(@char.stuff['Violin']).must_be_nil
        capture_io { @char.benefit('Violin') }
        expect(@char.stuff['Violin']).must_equal 1
      end

      it "accepts a String representing multiple items" do
        expect(@char.stuff['Violin']).must_be_nil
        capture_io { @char.benefit('2x Violin') }
        expect(@char.stuff['Violin']).must_equal 2
      end

      it "accepts an Array representing multiple items" do
        expect(@char.stuff['Violin']).must_be_nil
        capture_io { @char.benefit %w{Violin Violin} }
        expect(@char.stuff['Violin']).must_equal 2
      end

      it "accepts a Symbol representing a stat bump" do
        endurance = @char.stats.endurance
        capture_io { @char.benefit :endurance }
        expect(@char.stats.endurance).must_equal endurance + 1

        strength = @char.stats.strength
        capture_io { @char.benefit [:strength, :strength] }
        expect(@char.stats.strength).must_equal strength + 2
      end
    end

    describe "Character#log" do
      it "returns the log with no arg" do
        expect(@char.log).must_be_kind_of Array
        expect(@char.log).must_be_empty
        capture_io { @char.log "test" }
        expect(@char.log).wont_be_empty
        expect(@char.log.size).must_equal 1
        expect(@char.log.first).must_equal "test"
      end

      it "accumulates messages with an arg" do
        size = @char.log.size
        capture_io { @char.log "Stuff" }
        expect(@char.log.size).must_equal size + 1
      end
    end

    describe "Character#age" do
      it "returns the age with no arg" do
        expect(@char.age).must_equal 18
      end

      it "advances the age with an arg" do
        @char.age 2
        expect(@char.age).must_equal 20
      end
    end

    describe "Character#cash_roll" do
      it "tracks rolls for credits; ignored after 3 rolls" do
        expect(@char.credits).must_equal 0
        expect(@char.cash_rolls).must_equal 0
        5.times { capture_io { @char.cash_roll(100) } }
        expect(@char.credits).wont_equal 500
        expect(@char.credits).must_equal 300
        expect(@char.cash_rolls).must_equal 5
      end
    end

    describe "Character#birth" do
      before do
        @home = Homeworld.new('Earth')
        capture_io do
          @char = Character.new(desc: @desc, stats: @stats, homeworld: @home)
        end
      end

      it "is a private method" do
        expect { @char.birth @home }.must_raise NoMethodError
      end

      it "is performed at instantiation" do
        # character gets background skills from homeworld
        expect(@char.log.empty?).must_equal false
        expect(@char.skills.empty?).must_equal false
      end

      it "raises when Character#log isn't empty" do
        expect { @char.send(:birth, @home) }.must_raise RuntimeError
      end
    end
  end
end
