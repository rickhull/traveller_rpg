require 'traveller_rpg/skill'
require 'minitest/autorun'

include TravellerRPG

describe Skill do
  describe "Skill.name" do
    it "must convert several symbols to a single string" do
      valid = {
        [:foo, :bar, :baz] => 'Foo:Bar:Baz',
        [:foo_bar, :baz] => 'Foo Bar:Baz',
      }
      valid.each { |ary, str|
        expect(Skill.name(*ary)).must_equal str
      }
    end
  end

  describe "Skill.sym" do
    it "must convert a string to a symbol" do
      valid = {
        'Foo' => :foo,
        'Bar' => :bar,
        'Foo Bar' => :foo_bar,
        'FooBar' => :foobar,
      }
      valid.each { |str, sym|
        expect(Skill.sym str).must_equal sym
      }
    end
  end

  describe "Skill.syms" do
    it "must convert a structured string to an array of symbols" do
      valid = {
        'Foo' => [:foo],
        'Bar' => [:bar],
        'Foo Bar' => [:foo_bar],
        'FooBar' => [:foobar],
        'Foo:Bar' => [:foo, :bar],
        'Foo Bar:Baz' => [:foo_bar, :baz],
        'FooBar:Baz' => [:foobar, :baz],
        'Foo Bar Baz' => [:foo_bar_baz],
        'Foo:Bar:Baz' => [:foo, :bar, :baz],
      }
      valid.each { |str, ary|
        expect(Skill.syms str).must_equal ary
      }
    end
  end

  describe "new instance" do
    before do
      @name = 'John Jacob'
      @desc = 'Jingleheimer Schmidt'
      @level = 2
      @invalid_level = 99
    end

    it "must initialize with a name" do
      s = Skill.new(@name)
      expect(s.name).must_equal @name
      expect(s.level).must_equal 0
      expect(s.desc).must_be_empty
    end

    it "must accept a desc and level" do
      s = Skill.new(@name, level: @level, desc: @desc)
      expect(s.name).must_equal @name
      expect(s.level).must_equal @level
      expect(s.desc).must_equal @desc
    end

    it "must clamp bad levels" do
      s = nil
      _out, err = capture_io { s = Skill.new(@name, level: @invalid_level) }
      expect(err).wont_be_empty
      expect(s.name).must_equal @name
      expect(s.level).must_equal s.class::MAX
    end

    describe "Skill#bump" do
      before do
        @skill = Skill.new('Stuff')
        @level = 3
        @invalid_level = 99
      end

      it "bumps to a valid level" do
        @skill.bump(@level)
        expect(@skill.level).must_equal @level
      end

      it "won't bump beyond MAX" do
        _out, err = capture_io { @skill.bump(@invalid_level) }
        expect(err).wont_be_empty
        expect(@skill.level).must_equal @skill.class::MAX
      end

      it "bumps 1 without a level" do
        @skill.bump
        expect(@skill.level).must_equal 1
      end

      it "won't bump beyond MAX without a level" do
        _out, err = capture_io { 9.times { @skill.bump } }
        expect(err).wont_be_empty
        expect(@skill.level).must_equal @skill.class::MAX
      end
    end
  end
end

describe ComplexSkill do
  before do
    @skill_names = %w{First Second Third}
    @skills = @skill_names.map { |n| Skill.new(n) }
    @skill = ComplexSkill.new('Complex', skills: @skills)
  end

  describe "new instance" do
    before do
      @name = 'Complex'
      @desc = 'with specialties'
    end

    it "must initialize with a name" do
      s = ComplexSkill.new(@name)
      expect(s.name).must_equal @name
      expect(s.level).must_equal 0
      expect(s.desc).must_be_empty
    end

    it "must accept a desc" do
      s = ComplexSkill.new(@name, desc: @desc)
      expect(s.name).must_equal @name
      expect(s.level).must_equal 0
      expect(s.desc).must_equal @desc
    end

    # ComplexSkills can only have level 0 for the general skill
    it "must not accept a level" do
      [0, 1, 2].each { |level|
        expect { ComplexSkill.new(@name, level: level) }.must_raise Exception
      }
    end
  end

  describe "ComplexSkill#bump" do
    it "must bump a subskill and remain at level 0" do
      expect(@skill.skills.values.all? { |skill| skill.level == 0 }).must_equal true
      out, err = capture_io { @skill.bump(1) }
      expect(out).wont_be_empty
      expect(err).must_be_empty
      expect(@skill.skills.values.all? { |s| s.level == 0 }).must_equal false
      expect(@skill.skills.values.any? { |s| s.level == 1 }).must_equal true
      expect(@skill.skills.values.select { |s| s.level == 1 }.size).must_equal 1
      expect(@skill.level).must_equal 0
    end

    it "chooses a subskill with level < arg level" do
      @skill.skills['First'].bump(1)
      @skill.skills['Second'].bump(2)
      @skill.skills['Third'].bump(3)
      out, err = capture_io { @skill.bump(2) }
      expect(out).must_be_empty  # no choice needed
      expect(err).must_be_empty
      expect(@skill.skills['First'].level).must_equal 2
      out, err = capture_io { @skill.bump(4) }
      expect(out).wont_be_empty  # choose from all 3 subskills
      expect(err).must_be_empty
      expect(@skill.skills.values.select { |s| s.level == 4 }.size).must_equal 1
    end
  end

  describe "ComplexSkill#fetch" do
    it "must retrieve a specialty skill by name" do
      spec = @skill.fetch(@skill_names.sample)
      expect(spec).must_be_kind_of Skill
    end

    it "must raise if specialty is not found" do
      expect { @skill.fetch('Nonexistent') }.must_raise KeyError
    end
  end

  describe "ComplexSkill#[]" do
    it "must retrieve a specialty skill by name" do
      spec = @skill[@skill_names.sample]
      expect(spec).must_be_kind_of Skill
    end

    it "returns nil if specialty is not found" do
      spec = @skill['Nonexistent']
      expect(spec).must_be_nil
    end
  end

  describe "Skill methods" do
    it "uses method_missing to address the general skill" do
      expect(@skill.name).must_be_kind_of String
      expect(@skill.level).must_be_kind_of Numeric
      expect(@skill.desc).must_be_kind_of String
    end
  end

  describe "ComplexSkill#filter" do
    it "returns a subset of subskills according to names provided" do
      subskills = @skill.filter(['First', 'Second'])
      expect(subskills).must_be_kind_of Array
      expect(subskills.size).must_equal 2
      expect(subskills.any? { |s| s.name == 'Third' }).must_equal false
      expect(subskills.any? { |s| s.name == 'First' }).must_equal true
    end
  end
end
