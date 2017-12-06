require 'traveller_rpg/skill_set'
require 'minitest/autorun'

include TravellerRPG

describe SkillSet do
  describe "new instance" do
    before do
      @valid = %w{Admin Animals Animals:Handling}
      @invalid = %w{xAdmin Adminx Animal Animal:Handling Animals:Handler}
      @skills = SkillSet.new
    end

    describe "SkillSet#[]" do
      it "must raise for unknown skills" do
        @invalid.each { |s|
          proc { @skills[s] }.must_raise SkillSet::UnknownSkill
        }
      end

      it "must return nil for untrained skills" do
        @valid.each { |s| @skills[s].must_be_nil }
      end

      it "must return a Skill or ComplexSkill for trained skills" do
        @valid.each { |s|
          @skills.provide(s)
          [Skill, ComplexSkill].must_include @skills[s].class
        }
      end
    end

    describe "SkillSet#level" do
      it "must raise for unknown skills" do
        @invalid.each { |s|
          proc { @skills.level(s) }.must_raise SkillSet::UnknownSkill
        }
      end

      it "must return nil for untrained skills" do
        @valid.each { |s| @skills.level(s).must_be_nil }
      end

      it "must return an Integer for trained skills" do
        @valid.each { |s|
          @skills.provide(s)
          @skills.level(s).must_equal 0
        }
      end
    end

    describe "SkillSet#check?" do
      it "must raise for unknown skills" do
        @invalid.each { |s|
          proc { @skills.check?(s, 0) }.must_raise SkillSet::UnknownSkill
        }
      end

      it "must return false for untrained skills" do
        @valid.each { |s| @skills.check?(s, 0).must_equal false }
      end

      it "must return false against a higher level" do
        @valid.each { |s|
          @skills.provide(s)
          @skills.check?(s, 5).must_equal false
        }
      end

      it "must return true against a lower or equal level" do
        @valid.each { |s|
          @skills.provide(s)
          @skills.check?(s, 0).must_equal true
          capture_io do
            # ComplexSkills won't go past 0, only their subskills
            # Don't show the TravellerRPG.choose
            @skills.bump(s)
          end
          @skills.check?(s, 5).must_equal false
        }
      end
    end

    describe "SkillSet#bump" do
      before do
        @simple = %w{Admin Advocate}
        @complex = %w{Animals Art}
        @subskills = %w{Animals:Handling Art:Performer}
        @skills = SkillSet.new
      end

      it "must raise for unknown skills" do
        @invalid.each { |s|
          proc { @skills.bump(s) }.must_raise RuntimeError
#          proc { @skills.bump(s) }.must_raise SkillSet::UnknownSkill
        }
      end

      it "must create untrained skills" do
        @valid.each { |s|
          capture_io do
            @skills.bump(s)
          end
          @skills[s].wont_be_nil
        }
      end

      it "must increment Skills" do
        @simple.each { |s|
          @skills[s].must_be_nil
          @skills.bump(s)
          @skills[s].wont_be_nil
          @skills.level(s).must_equal 1
          @skills.bump(s)
          @skills.level(s).must_equal 2
        }
      end

      it "must increment ComplexSkills" do
        @complex.each { |s|
          @skills[s].must_be_nil
          capture_io do
            # bump goes to subskill via TravellerRPG.choose
            @skills.bump(s)
          end
          @skills[s].wont_be_nil
          @skills.level(s).must_equal 0
        }
      end
    end
  end
end
