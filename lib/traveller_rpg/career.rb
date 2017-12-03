require 'traveller_rpg'

module TravellerRPG
  class Career
    class Error < RuntimeError; end
    class UnknownAssignment < Error; end
    class MusterError < Error; end

    def self.advanced_skills?(stats)
      stats.education >= 8
    end

    TERM_YEARS = 4

    QUALIFY_CHECK = 5
    SURVIVAL_CHECK = 6
    ADVANCEMENT_CHECK = 9

    STATS = Array.new(6) { :default }
    SERVICE_SKILLS = Array.new(6) { :default }
    ADVANCED_SKILLS = Array.new(6) { :default }
    SPECIALIST_SKILLS = { default: Array.new(6) { :default } }
    RANKS = {}

    EVENTS = {
      2 => nil,
      3 => nil,
      4 => nil,
      5 => nil,
      6 => nil,
      7 => nil,
      8 => nil,
      9 => nil,
      10 => nil,
      11 => nil,
      12 => nil,
    }

    MISHAPS = {
      1 => nil,
      2 => nil,
      3 => nil,
      4 => nil,
      5 => nil,
      6 => nil,
    }

    CASH = {
      2 => -500,
      3 => -100,
      4 => 200,
      5 => 400,
      6 => 600,
      7 => 800,
      8 => 1000,
      9 => 2000,
      10 => 4000,
      11 => 8000,
      12 => 16000,
    }

    attr_reader :term, :active, :rank, :benefits

    def initialize(char, assignment: nil, term: 0, active: false, rank: 0,
                   benefits: {})
      @char = char
      @assignment = assignment
      if @assignment and !self.class::SPECIALIST_SKILLS.key?(@assignment)
        raise(UnknownAssignment, assignment.inspect)
      end

      # career tracking
      @term = term
      @active = active
      @rank = rank
      @benefits = benefits  # acquired equipment, ships / shares
      @term_mandate = nil
    end

    def activate
      @active = true
    end

    def assignment
      @assignment ||= TravellerRPG.choose("Choose a specialty:",
                                       *self.class::SPECIALIST_SKILLS.keys)
    end

    def active?
      !!@active
    end

    def qualify_check?(career_count, dm: 0)
      dm += -1 * career_count
      roll = TravellerRPG.roll('2d6')
      puts format("Qualify check: rolled %i (DM %i) against %i",
                  roll, dm, self.class::QUALIFY_CHECK)
      (roll + dm) >= self.class::QUALIFY_CHECK
    end

    def survival_check?(dm: 0)
      roll = TravellerRPG.roll('2d6')
      puts format("Survival check: rolled %i (DM %i) against %i",
                  roll, dm, self.class::SURVIVAL_CHECK)
      (roll + dm) >= self.class::SURVIVAL_CHECK
    end

    def advancement_check?(roll: nil, dm: 0)
      roll ||= TravellerRPG.roll('2d6')
      puts format("Advancement check: rolled %i (DM %i) against %i",
                  roll, dm, self.class::ADVANCEMENT_CHECK)
      (roll + dm) >= self.class::ADVANCEMENT_CHECK
    end

    # any skills obtained start at level 1
    def training_roll
      roll = TravellerRPG.roll('d6')
      @char.log "Training roll (d6): #{roll}"
      choices = [:stats, :service, :specialist]
      choices << :advanced if self.class.advanced_skills?(@char.stats)
      choices << :officer if self.respond_to?(:officer) and self.officer
      choice = TravellerRPG.choose("Choose training regimen:", *choices)
      case choice
      when :stats
        stat = self.class::STATS.fetch(roll - 1)
        if @char.stats.respond_to?(stat)
          @char.stats.boost(stat => 1)
          @char.log "Trained #{stat.to_s.capitalize} " +
                    "to #{@char.stats.send(stat)}"
        else
          raise "bad stat: #{stat}" unless TravellerRPG::SKILLS.key?(stat)
          # stat is likely :jack_of_all_trades skill
          @char.skills[stat] ||= 0
          @char.skills[stat] += 1
          @char.log "Trained stats skill: #{stat} #{@char.skills[stat]}"
        end
      when :service
        svc = self.class::SERVICE_SKILLS.fetch(roll - 1)
        @char.skills[svc] ||= 0
        @char.skills[svc] += 1
        @char.log "Trained service skill: #{svc} #{@char.skills[svc]}"
      when :specialist
        spec =
          self.class::SPECIALIST_SKILLS.fetch(self.assignment).fetch(roll - 1)
        @char.skills[spec] ||= 0
        @char.skills[spec] += 1
        @char.log "Trained #{@assignment.to_s.capitalize} specialist skill: " +
                  "#{spec} #{@char.skills[spec]}"
      when :advanced
        adv = self.class::ADVANCED_SKILLS.fetch(roll - 1)
        @char.skills[adv] ||= 0
        @char.skills[adv] += 1
        @char.log "Trained advanced skill: #{adv} #{@char.skills[adv]}"
      when :officer
        off = self.class::OFFICER_SKILLS.fetch(roll - 1)
        @char.skills[off] ||= 0
        @char.skills[off] += 1
        @char.log "Trained officer skill: #{off} #{@char.skills[off]}"
      end
    end

    def event_roll(dm: 0)
      roll = TravellerRPG.roll('2d6')
      clamped = (roll + dm).clamp(2, 12)
      @char.log "Event roll: #{roll} (DM #{dm}) = #{clamped}"
      @char.log self.class::EVENTS.fetch(clamped)
      # TODO: actually perform the event stuff
    end

    def mishap_roll
      roll = TravellerRPG.roll('d6')
      @char.log "Mishap roll (d6): #{roll}"
      @char.log self.class::MISHAPS.fetch(roll)
      # TODO: actually perform the mishap stuff
    end

    def cash_roll(dm: 0)
      roll = TravellerRPG.roll('2d6')
      clamped = (roll + dm).clamp(2, 12)
      amount = self.class::CASH.fetch(clamped)
      puts "Cash roll: #{roll} (DM #{dm}) = #{clamped} for #{amount}"
      amount
    end

    def advance_rank
      @rank += 1
      @char.log "Advanced career to rank #{@rank}"
      title, skill, level = self.rank_benefit
      if title
        @char.log "Awarded rank title: #{title}"
        @char.log "Achieved rank skill: #{skill} #{level}"
        @char.skills[skill] ||= 0
        @char.skills[skill] = level if level > @char.skills[skill]
      end
    end

    def must_remain?
      @term_mandate == :must_remain
    end

    def must_exit?
      @term_mandate == :must_exit
    end

    def run_term
      raise(Error, "career is inactive") unless @active
      raise(Error, "must exit") if self.must_exit?
      @term += 1
      @char.log format("%s term %i started, age %i",
                       self.name, @term, @char.age)
      self.training_roll

      if self.survival_check?
        @char.log format("%s term %i was successful", self.name, @term)
        @char.age TERM_YEARS

        self.commission_roll if self.respond_to?(:commission_roll)

        adv_roll = TravellerRPG.roll('2d6')
        # TODO: DM?
        if self.advancement_check?(roll: adv_roll)
          self.advance_rank
          self.training_roll
        end
        if adv_roll <= @term
          @term_mandate = :must_exit
        elsif adv_roll == 12
          @term_mandate = :must_remain
        else
          @term_mandate = nil
        end

        self.event_roll
      else
        @char.log "#{self.name} career ended with a mishap!"
        @char.age rand(TERM_YEARS) + 1
        self.mishap_roll
        @active = false
      end
    end

    def retirement_bonus
      @term >= 5 ? @term * 2000 : 0
    end

    def muster_out(dm: 0)
      if @active
        raise(MusterError, "career has not started") unless @term > 0
        @active = false
        cash_benefit = 0
        @char.log "Muster out: #{self.name}"
        dm += @char.skill_check?(:gambler, 1) ? 1 : 0
        @term.clamp(0, 3).times {
          cash_benefit += self.cash_roll(dm: dm)
        }
        @char.log "Cash benefit: #{cash_benefit}"
        @char.log "Retirement bonus: #{self.retirement_bonus}"
        @benefits[:cash] ||= 0
        @benefits[:cash] += cash_benefit + self.retirement_bonus
        @benefits
      end
    end

    def name
      self.class.name.split('::').last
    end

    # possibly nil
    def rank_benefit
      self.class::RANKS[@rank]
    end

    def report(term: true, active: true, rank: true, benefits: true)
      hsh = {}
      hsh['Term'] = @term if term
      hsh['Active'] = @active if active
      hsh['Rank'] = @rank if rank
      hsh['Benefits'] = @benefits if benefits
      report = ["Career: #{self.name}", "==="]
      hsh.each { |label, val|
        if val.is_a?(Hash)
          report << "#{label}:\n---"
          report << "(none)" if val.empty?
          k_width = 0
          val.each { |k, v|
            k_width = k.size if k.size > k_width
            report << format("%s: %s", k.to_s.rjust(k_width, ' '), v.to_s)
          }
          report << ' '
        else
          report << format("%s: %s", label.to_s.rjust(8, ' '), val.to_s)
        end
      }
      report.join("\n")
    end
  end
end
