require 'traveller_rpg/career'
require 'traveller_rpg/generator'
require 'minitest/autorun'

include TravellerRPG

describe Career do
  describe Career.method(:roll_check?) do
    it "must return true or false based on roll and check" do
      capture_io do
        Career.roll_check?('Stuff', check: 5, roll: 5, dm: 0).must_equal true
        Career.roll_check?('Stuff', check: 5, roll: 4, dm: 1).must_equal true
        Career.roll_check?('Stuff', check: 5, roll: 4, dm: 0).must_equal false
        Career.roll_check?('Stuff', check: 5, roll: 6, dm: 0).must_equal true
        Career.roll_check?('Stuff', check: 5, roll: 6, dm: -1).must_equal true
        Career.roll_check?('Stuff', check: 5, roll: 6, dm: -2).must_equal false
      end
    end
  end

  describe "new instance" do
    before do
      capture_io { @char = Generator.character }
      @career = ExampleCareer.new(@char)
      @skill = ExampleCareer::SKILL
      @assignment = ExampleCareer::SPECIALIST.keys.first
      @title = ExampleCareer::TITLE
    end

    it "must have attrs" do
      @career.term.must_equal 0
      @career.status.must_equal :new
      @career.rank.must_equal 0
      @career.title.must_be_nil
      @career.assignment.must_be_nil
    end

    it "must have a name based on class" do
      @career.name.must_equal 'ExampleCareer' # not TravellerRPG::ExampleCareer
    end

    it "must respond to predicate methods" do
      @career.officer?.must_equal false
      @career.active?.must_equal false
      @career.finished?.must_equal false
      @career.must_remain?.must_equal false
      @career.must_exit?.must_equal false
    end

    describe "Career#report" do
      it "must have multiple lines" do
        @career.report.split("\n").size.must_be :>, 1
      end
    end

    describe "Career#activate" do
      it "must update status, assignment, title, skills" do
        capture_io { @career.activate }
        @career.assignment.wont_be_nil
        @career.assignment.must_equal @assignment
        @career.status.must_equal :active
        @career.active?.must_equal true
        @career.finished?.must_equal false
        @career.title.must_equal @title
        @char.skills.level(@skill).must_be :>=, 0
      end

      it "must not activate twice" do
        capture_io { @career.activate }
        proc { @career.activate }.must_raise RuntimeError
      end

      it "must reject an unknown assignment" do
        proc {
          capture_io { @career.activate :random }
        }.must_raise Career::UnknownAssignment
      end
    end

    describe "Active Career" do
      before do
        capture_io { @career.activate }
      end

      describe "Career#qualify_check?" do
        it "must return true/false based on the dice and check value" do
          capture_io do
            @career.qualify_check?(dm: 10).must_equal true
            @career.qualify_check?(dm: -10).must_equal false
          end
        end
      end

      describe "Career#survival_check?" do
        it "must return true/false based on the dice and check value" do
          capture_io do
            @career.survival_check?(dm: 10).must_equal true
            @career.survival_check?(dm: -10).must_equal false
          end
        end
      end

      describe "Career#advancement_check?" do
        it "must return true/false based on the dice and check value" do
          capture_io do
            @career.advancement_check?(dm: 10).must_equal true
            @career.advancement_check?(dm: -10).must_equal false
          end
        end
      end

      describe "Career#advanced_education?" do
        it "must check Education stat against ADVANCED_EDUCATION" do
          @career.advanced_education?.must_equal(
            @char.stats[:education] >= @career.class::ADVANCED_EDUCATION
          )
        end
      end

      describe "Career#advancement_roll" do
        it "tries to do MilitaryCareer#commission_roll" do
        end

        it "will only advance a rank once per term" do
        end
      end

      describe "Career#training_roll" do
        it "must bump a skill or stat" do
          level = @char.skills.level(@skill)
          capture_io { @career.training_roll }
          @char.skills.level(@skill).must_equal level + 1
        end
      end

      describe "Career#event_roll" do
        it "must log an event" do
          size = @char.log.size
          capture_io { @career.event_roll }
          @char.log.size.must_equal size + 1
        end

        it "must not accept a DM" do
          proc { @career.event_roll(dm: 0) }.must_raise ArgumentError
        end

        it "must process an event" do
          skip # not yet implemented
        end
      end

      describe "Career#mishap_roll" do
        it "must log a mishap" do
          size = @char.log.size
          capture_io { @career.mishap_roll }
          @char.log.size.must_equal size + 1
        end

        it "must not accept a DM" do
          proc { @career.mishap_roll(dm: 0) }.must_raise ArgumentError
        end

        it "must process a mishap" do
          skip # not yet implemented
        end
      end

      describe "Career#rank_benefit" do
        it "must return rank benefits according to specialty and rank" do
          title, skill, level = @career.rank_benefit
          title.must_equal @title
          skill.must_equal @skill
          level.must_be_nil # in this case, for @rank == 0 for ExampleCareer

          capture_io { @career.advance_rank }

          title, skill, level = @career.rank_benefit
          title.must_be_nil
          skill.must_be_nil
          level.must_be_nil
        end
      end

      describe "Career#advance_rank" do
        it "must increase rank and take rank benefits" do
          rank = @career.rank
          capture_io { @career.advance_rank }
          @career.rank.must_equal rank + 1
        end
      end

      describe "Career#run_term" do
        it "must increment Career#term, Character#age, and do some logging" do
          term = @career.term
          age = @char.age
          log_size = @char.log.size
          capture_io { @career.run_term }
          @career.term.must_equal term + 1
          @char.log.size.must_be :>, log_size
          if @career.active?
            @char.age.must_equal age + Career::TERM_YEARS
          elsif @career.status == :mishap
            @char.age.wont_equal age
            @char.age.must_be :<=, age + Career::TERM_YEARS
          else
            raise "unexpected career status: #{@career.status}"
          end
        end

        it "must add some skills" do
          level = @char.skills.level(@skill)
          capture_io { @career.run_term }
          @char.skills.level(@skill).must_be :>, level
        end
      end

      describe "Career#retirement_bonus" do
        it "must be 0 unless term >= 5" do
          # TODO: create LongCareer with survival_check 0
          6.times {
            capture_io {
              begin
                @career.run_term
              rescue Career::Error
                # fine
              end
            }
          }
          if @career.term < 5
            @career.retirement_bonus.must_equal 0
          else
            @career.retirement_bonus.must_be :>, 0
          end
        end
      end

      describe "Career#muster_roll" do
        it "returns 2 values: cash (credits) and a benefit" do
          ary = []
          capture_io { ary = @career.muster_roll('') }
          ary.must_be_kind_of Array
          ary.size.must_equal 2
          ary.first.must_be_kind_of Integer
          # TODO: Benefits are just stubbed out as String for now
          ary.last.must_be_kind_of String
        end
      end

      describe "Career#muster_out" do
        it "raises if career has not run a term yet" do
          proc { capture_io { @career.muster_out } }.must_raise Career::Error
        end

        it "yields at least one cash roll" do
          @char.cash_rolls.must_equal 0
          mishap = false
          capture_io {
            @career.run_term
            mishap = @career.status == :mishap
            @career.muster_out
          }
          @char.cash_rolls.must_equal 1
          # last term doesn't get a benefit in case of mishap
          @char.stuff.size.must_equal (mishap ? 0 : 1)
        end
      end
    end
  end
end

describe MilitaryCareer do
  describe "new instance" do
    before do
      capture_io { @char = Generator.character }
      @career = ExampleMilitaryCareer.new(@char)
      @skill = @career.class::SKILL
      @assignment = @career.class::SPECIALIST.keys.first
      @title = @career.class::TITLE
    end

    it "must have attrs" do
      @career.term.must_equal 0
      @career.status.must_equal :new
      @career.rank.must_equal 0
      @career.title.must_be_nil
      @career.assignment.must_be_nil
    end

    it "must have a name based on class" do
      @career.name.must_equal 'ExampleMilitaryCareer'
    end

    it "must respond to predicate methods" do
      @career.officer?.must_equal false
      @career.active?.must_equal false
      @career.finished?.must_equal false
      @career.must_remain?.must_equal false
      @career.must_exit?.must_equal false
    end

    describe "MilitaryCareer#report" do
      it "must have multiple lines" do
        @career.report.split("\n").size.must_be :>, 1
      end
    end

    describe "MilitaryCareer#activate" do
      it "must update status, assignment, title, skills" do
        capture_io { @career.activate }
        @career.assignment.wont_be_nil
        @career.assignment.must_equal @assignment
        @career.status.must_equal :active
        @career.active?.must_equal true
        @career.finished?.must_equal false
        @career.title.must_equal @title
        @char.skills.level(@skill).must_be :>=, 0
      end

      it "must not activate twice" do
        capture_io { @career.activate }
        proc { @career.activate }.must_raise RuntimeError
      end

      it "must reject an unknown assignment" do
        proc {
          capture_io { @career.activate :random }
        }.must_raise Career::UnknownAssignment
      end
    end

    describe "MilitaryCareer#run_term" do
      it "must not allow commission and advancement in same term" do
        # TODO
      end
    end
  end
end
