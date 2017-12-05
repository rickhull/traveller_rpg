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

    def self.stats_dm(stat_val)
      case stat_val
      when 0 then -3
      when 1..2 then -2
      when 3..5 then -1
      when 6..8 then 0
      when 9..11 then 1
      when 12..14 then 2
      when 15..20 then 3
      else
        raise "unexpected stat: #{stat_val} (#{stat_val.class})"
      end
    end

    attr_reader :desc, :stats, :homeworld, :skills,
                :stuff, :credits, :cash_rolls

    def initialize(desc:, stats:, homeworld:,
                   skills: {}, stuff: {}, log: [], credits: 0, cash_rolls: 0)
      @desc = desc
      @stats = stats
      @homeworld = homeworld
      @skills = skills
      @stuff = stuff
      @log = log
      @cash_rolls = cash_rolls # max 3 lifetime
      @credits = credits
      self.birth
    end

    def stats_dm(stat_sym)
      self.class.stats_dm(@stats[stat_sym])
    end

    # gain background skills based on homeworld
    def birth
      return nil unless @log.empty?
      self.log format("%s was born on %s (%s)",
                      @desc.name,
                      @homeworld.name,
                      @homeworld.traits.join(' '))
      skill_count = 3 + self.stats_dm(:education)
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
        if TravellerRPG::SKILLS.key?(sym)
          self.log "Acquired background skill: #{sym} 0"
          @skills[sym] ||= 0
        else
          raise(KeyError, sym)
        end
      }
      self
    end

    def train(sym, level = nil)
      target = TravellerRPG::SKILLS.key?(sym) ? @skills : @stats
      target[sym] ||= 0
      if level
        if target[sym] < level
          target[sym] = level
        else
          self.log "Train: #{sym} is already #{target[sym]}"
        end
      else
        target[sym] += 1
        level = target[sym]
      end
      self.log "Trained: #{sym} #{level}"
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
      self
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

    def skill_level(sym)
      @skills[sym] and @skills[sym].clamp(0, 4)
    end

    def cash_roll(amount)
      @cash_rolls += 1
      if @cash_rolls <= 3
        @credits += amount
        self.log "Acquired #{amount} credits from cash roll ##{@cash_rolls}"
      else
        self.log "Ignoring cash roll ##{@cash_rolls}"
      end
      self
    end

    def benefit(item)
      if item.is_a?(Integer)
        if item != 0
          self.log "Acquired #{item} credits as a career benefit"
          @credits += item
        end
      else
        self.log "Acquired #{item} as a career benefit"
        @stuff[item] ||= 0
        @stuff[item] += 1
      end
    end

    def report(desc: :short, stats: true, skills: true, stuff: true,
               log: false, credits: true)
      hsh = {}
      if desc
        hsh['Description'] = { 'Name'   => @desc.name,
                               'Gender' => @desc.gender,
                               'Age'    => @desc.age }
        if desc == :long
          hsh['Description'].merge! 'Appearance'  => @desc.appearance,
                                    'Temperament' => @desc.temperament,
                                    'Plot'        => @desc.plot
        end
      end
      if stats
        hsh['Characteristics'] = {
          'Strength' => @stats.strength,
          'Dexterity' => @stats.dexterity,
          'Endurance' => @stats.endurance,
          'Intelligence' => @stats.intelligence,
          'Education' => @stats.education,
          'Social Status' => @stats.social_status,
        }
      end
      hsh['Skills'] = @skills if skills
      hsh['Stuff'] = @stuff if stuff
      hsh['Log'] = @log if log
      if credits
        hsh['Credits'] = {
          'Total' => @credits,
          'Cash Rolls' => @cash_rolls,
        }
      end
      report = []
      hsh.each { |section, tbl|
        report << "#{section}\n==="
        report << "(none)" if tbl.empty?
        if tbl.is_a?(Hash)
          tbl.each { |label, val|
            report << format("%s: %s", label.to_s.rjust(20, ' '), val.to_s)
          }
        elsif tbl.is_a?(Array)
          report += tbl
        else
          report << tbl
        end
        report << ' '
      }
      report.join("\n")
    end
  end
end
