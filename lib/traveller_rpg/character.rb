require 'traveller_rpg'

module TravellerRPG
  class Character
    Stats = Struct.new(:strength, :dexterity, :endurance,
                       :intelligence, :education, :social_status) do
      def self.roll(spec = '2d6')
        self.new(*Array.new(6) { TravellerRPG.roll spec })
      end

      def self.empty
        self.new(*Array.new(6) { 0 })
      end

      def boost(hsh)
        hsh.each { |k,v| self[k] += v if self[k] }
        self
      end
    end

    Description = Struct.new(:name, :gender, :age,
                             :appearance, :plot, :temperament) do
      def self.new_with_hash(hsh)
        self.new(hsh[:name], hsh[:gender], hsh[:age],
                 hsh[:appearance], hsh[:plot], hsh[:temperament])
      end

      def merge(other)
        other = self.class.new_with_hash(other) if other.is_a?(Hash)
        self.class.new(other.name || self.name,
                       other.gender || self.gender,
                       other.age    || self.age,
                       other.appearance || self.appearance,
                       other.plot       || self.plot,
                       other.temperament || self.temperament)
      end
    end

    def self.stats_dm(stat)
      case stat
      when 0 then -3
      when 1..2 then -2
      when 3..5 then -1
      when 6..8 then 0
      when 9..11 then 1
      when 12..14 then 2
      when 15..20 then 3
      else
        raise "unexpected stat: #{stat} (#{stat.class})"
      end
    end

    attr_reader :desc, :stats, :homeworld, :skills, :stuff

    def initialize(desc:, stats:, homeworld:,
                   skills: {}, stuff: {}, log: [])
      @desc = desc
      @stats = stats
      @homeworld = homeworld
      @skills = skills
      @stuff = stuff
      @log = log
      self.birth
    end

    # gain background skills based on homeworld
    def birth
      return nil unless @log.empty?
      self.log format("%s was born on %s (%s)",
                      @desc.name,
                      @homeworld.name,
                      @homeworld.traits.join(' '))
      skill_count = 3 + self.class.stats_dm(@stats.education)
      self.log format("Education %i qualifies for %i skills",
                      @stats.education, skill_count)
      skill_choices = []

      # choose skill_count skills
      if @homeworld.skills.size <= skill_count
        self.log format("Homeworld %s only has %i skills available",
                        @homeworld.name, @homeworld.skills.size)
        skill_choices = @homeworld.skills
      else
        skill_count.times { |i|
          available = @homeworld.skills - skill_choices
          skill_choices << TravellerRPG.choose("Choose a skill:", *available)
        }
      end
      skill_choices.each { |sym|
        self.log "Acquired background skill: #{sym} 0"
        @skills[sym] ||= 0
      }
    end

    def add_stuff(benefits)
      benefits.each { |sym, val|
        self.log "Collecting #{sym} #{val}"
        case @stuff[sym]
        when Numeric, Array
          self.log "Adding #{sym} #{val} to #{@stuff[sym]}"
          @stuff[sym] += val
        when NilClass
          @stuff[sym] = val
        else
          raise("unexpected benefit: #{sym} #{val} (#{val.class})")
        end
      }
    end

    def log(msg = nil)
      return @log unless msg
      puts msg
      @log << msg
    end

    def name
      @desc.name
    end

    def age(years = nil)
      years ? @desc.age += years : @desc.age
    end

    def skill_check?(skill, val = 0)
      @skills[skill] and @skills[skill] >= val
    end
  end
end
