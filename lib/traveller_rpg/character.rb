require 'traveller_rpg'
require 'traveller_rpg/homeworld'
require 'traveller_rpg/skill_set'

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

      def bump(sym, level = nil)
        if level
          self[sym] = level if level > self[sym]
        else
          self[sym] += 1
        end
      end

      def report
        rpt = []
        w = 'Social Status'.size + 2
        self.members.each { |sym|
          rpt << format("%s: %s", sym.to_s.capitalize.rjust(w, ' '), self[sym])
        }
        rpt.join("\n")
      end
    end

    Description = Struct.new(:name, :gender, :age,
                             :appearance, :plot, :temperament) do
      def merge(other)
        self.class.new(other[:name]        || self.name,
                       other[:gender]      || self.gender,
                       other[:age]         || self.age,
                       other[:appearance]  || self.appearance,
                       other[:plot]        || self.plot,
                       other[:temperament] || self.temperament)
      end

      def report(short: false)
        rpt = []
        w = (short ? 'Gender' : 'Temperament').size + 2
        self.members.each { |sym|
          next if short and [:appearance, :plot, :temperament].include?(sym)
          rpt << format("%s: %s", sym.to_s.capitalize.rjust(w, ' '), self[sym])
        }
        rpt.join("\n")
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

    def initialize(desc:, stats:, homeworld:, skills: SkillSet.new,
                   stuff: {}, log: [], credits: 0, cash_rolls: 0)
      @desc = desc
      @stats = stats
      @homeworld = homeworld
      @skills = skills
      @stuff = stuff
      @log = log
      @cash_rolls = cash_rolls # max 3 lifetime
      @credits = credits
      birth # private method
    end

    def stats_dm(stat_sym)
      self.class.stats_dm(@stats[stat_sym])
    end

    def benefit(item)
      if item.is_a?(Integer)
        if item != 0
          @credits += item
          self.log "Acquired #{item} credits as a career benefit"
        end
      elsif item.is_a?(String)
        @stuff[item] ||= 0
        @stuff[item] += 1
        self.log "Acquired #{item} as a career benefit"
      elsif item.is_a?(Array)
        # TODO: should this be handled in Career#muster_out ?
        item = TravellerRPG.choose("Choose benefit:", *item)
        self.benefit(item)
      end
    end

    def log(msg = nil)
      return @log unless msg
      puts msg
      @log << msg
      self
    end

    # convenience
    def name
      @desc.name
    end

    def age(years = nil)
      years ? @desc.age += years : @desc.age
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

    def report(desc: :short, stats: true, skills: true, stuff: true,
               log: false, credits: true)
      hsh = {}
      hsh['Description'] = @desc.report(short: desc == :short) if desc
      hsh['Characteristics'] = @stats.report if stats
      hsh['Skills'] = @skills.report if skills
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
        if tbl.empty?
          report << "(none)"
        elsif tbl.is_a?(Hash)
          width = tbl.keys.map(&:size).max + 2
          tbl.each { |k, v|
            report << format("%s: %s", k.to_s.rjust(width, ' '), v)
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

    private

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
      skill_count.times {
        skill = TravellerRPG.choose("Choose a skill:", *@homeworld.skills)
        self.log "Acquired background skill: #{skill}"
        @skills.provide(skill)
      }
    end
  end
end
