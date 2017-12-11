require 'traveller_rpg/career_path'
require 'traveller_rpg/generator'
require 'minitest/autorun'

include TravellerRPG

describe CareerPath do
  describe CareerPath.method(:career_class) do
    it "takes a string and returns a class" do
      CareerPath.career_class('Drifter').must_equal Drifter
    end
  end

  describe CareerPath.method(:draft_career?) do
    it "takes a career name and recognizes draft destinations" do
      CareerPath.draft_career?('Army').must_equal true
      CareerPath.draft_career?('Navy').must_equal true
      CareerPath.draft_career?('Drifter').must_equal false
      # these work for now, subject to change
      CareerPath.draft_career?('ExampleCareer').must_equal false
      CareerPath.draft_career?('abolutely anything!').must_equal false
    end
  end

  describe CareerPath.method(:run) do
    before do
      capture_io { @char = Generator.character }
    end

    it "accepts an Array of career names and returns a CareerPath" do
      capture_io do
        CareerPath.run(%w{Drifter Agent},
                       character: @char).must_be_kind_of CareerPath
      end
    end

    it "runs careers until it quits" do
      path = nil
      capture_io { path = CareerPath.run(['Drifter'], character: @char) }
      path.careers.wont_be_empty
      path.careers.any? { |c| c.is_a?(Drifter) }.must_equal true
    end
  end

  describe "new instance" do
    before do
      capture_io do
        @char = Generator.character
        @path = CareerPath.new(@char)
      end
      @career = Scout.new(@char)   # anything but Drifter
    end

    it "has attrs" do
      @path.char.must_equal @char
      @path.careers.must_be_kind_of Array
      @path.careers.must_be_empty
    end

    describe "CareerPath#eligible?" do
      it "accepts a String or a Career" do
        @path.eligible?('Drifter').must_equal true
        @path.eligible?(@career).must_equal true
      end

      it "rejects non-new careers" do
        capture_io do
          @path.eligible?(@career.activate).must_equal false
          @path.eligible?(@career.run_term).must_equal false
          @path.eligible?(@career.muster_out).must_equal false
        end
      end

      it "rejects careers which have been completed" do
        capture_io { @path.send "run!", @career.activate }
        @path.eligible?(@career.name).must_equal false
      end
    end

    describe "CareerPath#apply" do
      it "accepts a String or a Career and returns an entered Career" do
        career = nil
        capture_io { career = @path.apply(@career) }
        career.must_be_kind_of Career # maybe Drifter or Draft
        career.active?.must_equal true
        case career
        when @career.class
          # TODO: this can fail if CareerPath.draft_career?(@career.name)
          # career.must_equal @career
        when Drifter
          # ok
        else
          CareerPath.draft_career?(career.name).must_equal true
        end
      end

      it "activates a career and performs basic training" do
        career = nil
        @career.active?.must_equal false
        num_skills = @char.skills.count
        capture_io { career = @path.apply @career }
        career.active?.must_equal true
        @char.skills.count.must_be :>, num_skills
      end

      it "rejects ineligible careers" do
        career = @path.career(@career.name)  # duplicate
        capture_io { @path.send "run!", career.activate }
        proc { @path.apply career }.must_raise CareerPath::Ineligible
        # can't enter Scout a 2nd time, even if it's a new career
        proc { @path.apply @career }.must_raise CareerPath::Ineligible
      end
    end

    describe "CareerPath#run" do
      it "returns a Career" do
        capture_io do
          @path.run('Drifter').must_be_kind_of Drifter
          @path.run(@career).must_be_kind_of Career # maybe Drifter or Draft
        end
      end

      it "affects Character and career history" do
        @path.careers.must_be_empty
        @char.cash_rolls.must_equal 0
        capture_io { @path.run 'Drifter' }
        @path.careers.wont_be_empty
        @path.careers.size.must_equal 1
        @char.cash_rolls.must_be :>, 0
        capture_io { @path.run @career }
        @path.careers.size.must_equal 2
      end
    end

    describe "CareerPath#draft" do
      it "returns an entered Career" do
        skill_count = @char.skills.count(subskills: true)
        career = nil
        capture_io { career = @path.draft }
        CareerPath.draft_career?(career.name).must_equal true
        career.active?.must_equal true
        @char.skills.count(subskills: true).must_be :>, skill_count + 3
      end
    end

    describe "CareerPath#basic_training" do
      it "accepts a Career, provides Character Skills, returns that Career" do
        skill_count = @char.skills.count(subskills: true)
        capture_io do
          @path.basic_training(@career.activate).must_equal @career
        end
        @char.skills.count(subskills: true).must_be :>, skill_count + 3
      end

      it "rejects inactive careers" do
        proc {
          @path.basic_training(@career)      # @career.status == :new
        }.must_raise CareerPath::Ineligible
      end

      it "provides up to 6 service skills for the first career" do
        capture_io { @path.basic_training(@career.activate) }
        ss = @career.service_skills(choose: false)
        if ss.size == 6
          # all present
          ss.each { |s| @char.skills[s].wont_be_nil }
        elsif ss.size > 6
          ss.size.must_be :<=, 9  # sanity check
          # at least 6 of these are known
          ss.select { |s| @char.skills[s] }.size.must_be :>=, 6
        else
          raise "unexpected SERVICE_SKILLS: #{ss.inspect}"
        end
      end

      it "allows only a single service skill for subsequent careers" do
        career = nil
        capture_io { career = @path.run @career }
        skill_count = @char.skills.count
        capture_io { @path.basic_training @path.career('Drifter').activate }
        case career
        when Drifter
          Drifter::SERVICE_SKILLS.flatten.size.must_equal 6 # sanity check
          # can't learn any new skills the second go-round
          @char.skills.count.must_equal skill_count
        else
          @char.skills.count.must_equal skill_count + 1
        end
      end
    end
  end
end
