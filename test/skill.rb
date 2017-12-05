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
        Skill.name(*ary).must_equal str
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
        Skill.sym(str).must_equal sym
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
        Skill.syms(str).must_equal ary
      }
    end
  end

  describe "new instance" do
    before do
      @name = 'Jacob'
      @desc = 'Jingleheimer Schmidt'
      @level = 2
      @invalid_level = 99
    end

    it "must initialize with a name" do
      s = Skill.new(@name)
      s.name.must_equal @name
      s.level.must_equal 0
      s.desc.must_be_empty
    end

    it "must accept a desc and level" do
      s = Skill.new(@name, level: @level, desc: @desc)
      s.name.must_equal @name
      s.level.must_equal @level
      s.desc.must_equal @desc
    end

    it "must clamp bad levels" do
      s = nil
      _out, err = capture_io do
        s = Skill.new(@name, level: @invalid_level)
      end
      err.wont_be_empty
      s.name.must_equal @name
      s.level.must_equal s.class::MAX
    end

    describe "bump" do
      before do
        @skill = Skill.new('Stuff')
        @level = 3
        @invalid_level = 99
      end

      it "bumps to a valid level" do
        @skill.bump(@level)
        @skill.level.must_equal @level
      end

      it "won't bump beyond MAX" do
        _out, err = capture_io do
          @skill.bump(@invalid_level)
        end
        err.wont_be_empty
        @skill.level.must_equal @skill.class::MAX
      end

      it "bumps 1 without a level" do
        @skill.bump
        @skill.level.must_equal 1
      end

      it "won't bump beyond MAX without a level" do
        _out, err = capture_io do
          9.times { @skill.bump }
        end
        err.wont_be_empty
        @skill.level.must_equal @skill.class::MAX
      end
    end
  end
end

describe ComplexSkill do
end
