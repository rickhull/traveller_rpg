require 'traveller_rpg/careers'
require 'traveller_rpg/character'
require 'minitest/autorun'

ObjectSpace.each_object(Class).select { |klass|
  next unless klass < TravellerRPG::Career
  next if klass == TravellerRPG::MilitaryCareer

  describe klass do
    it "must have valid TERM_YEARS" do
      defined?(klass::TERM_YEARS).wont_be_nil
      klass::TERM_YEARS.must_equal 4
    end

    it "must have valid ADVANCED_EDUCATION" do
      defined?(klass::ADVANCED_EDUCATION).wont_be_nil
      a = klass::ADVANCED_EDUCATION
      # Note: it's always 8, at least so far...
      (1..11).must_include a unless klass == TravellerRPG::Drifter
    end

    it "must have valid QUALIFICATION" do
      unless klass == TravellerRPG::Drifter
        defined?(klass::QUALIFICATION).wont_be_nil
        q = klass::QUALIFICATION
        q.must_be_kind_of Array
        q.size.must_equal 2
        stat, check = *q
        stat.must_be_kind_of Symbol
        TravellerRPG::Character::Stats.members.must_include(stat)
        check.must_be_kind_of Integer
        (2..12).must_include check
      end
    end

    it "must have valid PERSONAL_SKILLS" do
      defined?(klass::PERSONAL_SKILLS).wont_be_nil
      ps = klass::PERSONAL_SKILLS
      ps.must_be_kind_of Array
      ps.size.must_equal 6
      ps.flatten.each { |skill|
        if skill.is_a?(Symbol)
          TravellerRPG::Character::Stats.members.must_include(skill)
        else
          skill.must_be_kind_of String
          TravellerRPG.known_skill?(skill).must_equal true
        end
      }
    end

    it "must have valid SERVICE_SKILLS" do
      defined?(klass::SERVICE_SKILLS).wont_be_nil
      ss = klass::SERVICE_SKILLS
      ss.must_be_kind_of Array
      ss.size.must_equal 6
      ss.flatten.each { |skill|
        if skill.is_a?(Symbol)
          TravellerRPG::Character::Stats.members.must_include(skill)
        else
          skill.must_be_kind_of String
          TravellerRPG.known_skill?(skill).must_equal true
        end
      }
    end

    it "must have valid ADVANCED_SKILLS" do
      unless klass == TravellerRPG::Drifter
        defined?(klass::ADVANCED_SKILLS).wont_be_nil
        as = klass::ADVANCED_SKILLS
        as.must_be_kind_of Array
        as.size.must_equal 6
        as.flatten.each { |skill|
          if skill.is_a?(Symbol)
            TravellerRPG::Character::Stats.members.must_include(skill)
          else
            skill.must_be_kind_of String
            TravellerRPG.known_skill?(skill).must_equal true
          end
        }
      end
    end

    describe "SPECIALIST" do
      before do
        defined?(klass::SPECIALIST).wont_be_nil
        @specs = klass::SPECIALIST
      end

      it "must have valid SPECIALIST" do
        @specs.must_be_kind_of Hash
        if klass == TravellerRPG::ExampleCareer or
          klass == TravellerRPG::ExampleMilitaryCareer
          @specs.keys.size.must_equal 1
        else
          @specs.keys.size.must_equal 3
        end
        @specs.each { |asg, spec|
          asg.must_be_kind_of String
          spec.must_be_kind_of Hash
          [:skills, :survival, :advancement, :ranks].each { |key|
            spec.key?(key).must_equal true
          }
        }
      end

      it "must have valid SPECIALIST :skills" do
        @specs.values.each { |spec|
          skills = spec.fetch(:skills)
          skills.must_be_kind_of Array
          skills.size.must_equal 6
          skills.flatten.each { |skill|
            if skill.is_a?(Symbol)
              TravellerRPG::Character::Stats.members.must_include(skill)
            else
              skill.must_be_kind_of String
              puts skill unless TravellerRPG.known_skill? skill
              TravellerRPG.known_skill?(skill).must_equal true
            end
          }
        }
      end

      it "must have valid SPECIALIST :survival" do
        @specs.values.each { |spec|
          survival = spec.fetch(:survival)
          survival.must_be_kind_of Array
          survival.size.must_equal 2
          stat, check = *survival
          stat.must_be_kind_of Symbol
          TravellerRPG::Character::Stats.members.must_include(stat)
          check.must_be_kind_of Integer
          (2..12).must_include check
        }
      end

      it "must have valid SPECIALIST :advancement" do
        @specs.values.each { |spec|
          advancement = spec.fetch(:advancement)
          advancement.must_be_kind_of Array
          advancement.size.must_equal 2
          stat, check = *advancement
          stat.must_be_kind_of Symbol
          TravellerRPG::Character::Stats.members.must_include(stat)
          check.must_be_kind_of Integer
          (2..12).must_include check
        }
      end

      it "must have valid SPECIALIST :ranks" do
        @specs.values.each { |spec|
          ranks = spec.fetch(:ranks)
          ranks.must_be_kind_of Hash
          ranks.each { |rank, ary|
            (0..6).must_include rank
            ary.size.must_be :<=, 3
            title, skill, _level = *ary

            # rank_benefit must include a title, skill, or both
            if title.nil?
              skill.wont_be_nil
            else
              title.must_be_kind_of String
            end

            if skill.nil?
              title.wont_be_nil
            else
              if skill.is_a? String
                TravellerRPG.known_skill?(skill).must_equal true
              else
                skill.must_be_kind_of Symbol
                TravellerRPG::Character::Stats.members.must_include(skill)
              end
            end
          }
        }
      end
    end
  end
}
