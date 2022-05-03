require 'traveller_rpg/skill_set'
require 'minitest/autorun'

include TravellerRPG

describe SkillSet do
  describe SkillSet.method(:split_skill!) do
    it "recognizes subskills" do
      expect(SkillSet.split_skill!('Animals:Handling')).
        must_equal ['Animals', 'Handling']
    end

    it "ignores trailing colon" do
      expect(SkillSet.split_skill!('Art:')).must_equal ['Art', nil]
    end

    it "must accept a single string arg do" do
      ['Admin', 'Animals', 'Animals:Handling'].each { |valid|
        expect(SkillSet.split_skill!(valid)).must_be_kind_of Array
      }
    end

    it "raises UnknownSkill for unknown skills" do
      ['This:That', 'art'].each { |unk|
        expect { SkillSet.split_skill!(unk) }.must_raise SkillSet::UnknownSkill
      }
      [:art, :Art].each { |invalid|
        expect { SkillSet.split_skill!(invalid) }.must_raise NoMethodError
      }
    end
  end

  describe SkillSet.method(:new_skill) do
    it "does not recognize subskills" do
      expect {
        SkillSet.new_skill('Animals:Handling')
      }.must_raise SkillSet::UnknownSkill
    end

    it "accepts a string to find a Skill or ComplexSkill" do
      expect(SkillSet.new_skill('Admin')).
        must_be_kind_of TravellerRPG::Skill
      expect(SkillSet.new_skill('Animals')).
        must_be_kind_of TravellerRPG::ComplexSkill
    end
  end

  describe "new instance" do
    before do
      @valid = %w{Admin Animals Animals:Handling}
      @invalid = %w{xAdmin Adminx Animal Animal:Handling Animals:Handler}
      @skills = SkillSet.new
    end

    describe "SkillSet#count" do
      it "does not count subskills by default" do
        expect(@skills.count).must_equal 0
        @skills.provide 'Animals'
        expect(@skills.count).must_equal 1
        @skills.provide 'Admin'
        expect(@skills.count).must_equal 2
      end

      it "optionally counts subskills" do
        expect(@skills.count).must_equal 0
        @skills.provide 'Animals'
        animals_subskills = @skills['Animals'].skills.size
        expect(@skills.count(subskills: true)).must_equal animals_subskills + 1
        @skills.provide 'Admin'
        expect(@skills.count(subskills: true)).must_equal animals_subskills + 2
      end
    end

    describe "SkillSet#[]" do
      it "must raise for unknown skills" do
        @invalid.each { |s|
          expect { @skills[s] }.must_raise SkillSet::UnknownSkill
        }
      end

      it "must return nil for untrained skills" do
        @valid.each { |s| expect(@skills[s]).must_be_nil }
      end

      it "must return a Skill or ComplexSkill for trained skills" do
        @valid.each { |s|
          @skills.provide(s)
          expect([Skill, ComplexSkill]).must_include @skills[s].class
        }
      end
    end

    describe "SkillSet#level" do
      it "must raise for unknown skills" do
        @invalid.each { |s|
          expect { @skills.level(s) }.must_raise SkillSet::UnknownSkill
        }
      end

      it "must return nil for untrained skills" do
        @valid.each { |s| expect(@skills.level(s)).must_be_nil }
      end

      it "must return an Integer for trained skills" do
        @valid.each { |s|
          @skills.provide(s)
          expect(@skills.level(s)).must_equal 0
        }
      end
    end

    describe "SkillSet#check?" do
      it "must raise for unknown skills" do
        @invalid.each { |s|
          expect { @skills.check?(s, 0) }.must_raise SkillSet::UnknownSkill
        }
      end

      it "must return false for untrained skills" do
        @valid.each { |s| expect(@skills.check?(s, 0)).must_equal false }
      end

      it "must return false against a higher level" do
        @valid.each { |s|
          @skills.provide(s)
          expect(@skills.check?(s, 5)).must_equal false
        }
      end

      it "must return true against a lower or equal level" do
        @valid.each { |s|
          @skills.provide(s)
          expect(@skills.check?(s, 0)).must_equal true
          # ComplexSkills won't go past 0, only their subskills
          # Don't show the TravellerRPG.choose
          capture_io { @skills.bump(s) }
          expect(@skills.check?(s, 5)).must_equal false
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
          expect { @skills.bump(s) }.must_raise SkillSet::UnknownSkill
        }
      end

      it "must create untrained skills" do
        @valid.each { |s|
          capture_io { @skills.bump(s) }
          expect(@skills[s]).wont_be_nil
        }
      end

      it "must increment Skills" do
        @simple.each { |s|
          expect(@skills[s]).must_be_nil
          @skills.bump(s)
          expect(@skills[s]).wont_be_nil
          expect(@skills.level(s)).must_equal 1
          @skills.bump(s)
          expect(@skills.level(s)).must_equal 2
        }
      end

      it "must increment ComplexSkills" do
        @complex.each { |s|
          expect(@skills[s]).must_be_nil
          capture_io { @skills.bump(s) } # subskill via TravellerRPG.choose
          expect(@skills[s]).wont_be_nil
          expect(@skills.level(s)).must_equal 0
        }
      end
    end
  end
end
