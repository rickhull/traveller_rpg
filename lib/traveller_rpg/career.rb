require 'traveller_rpg'

module TravellerRPG
  class Career
    class Error < RuntimeError; end
    class UnknownAssignment < Error; end
    class MusterError < Error; end

    def self.roll_check?(label, dm:, check:, roll: nil)
      roll ||= TravellerRPG.roll('2d6')
      puts format("%s check: rolled %i (DM %i) against %i",
                  label, roll, dm, check)
      (roll + dm) >= check
    end

    TERM_YEARS = 4

    QUALIFICATION = [:default, 5]
    ADVANCED_EDUCATION = 8
    PERSONAL_SKILLS = Array.new(6) { :default }
    SERVICE_SKILLS = Array.new(6) { :default }
    ADVANCED_SKILLS = Array.new(6) { :default }
    SPECIALIST = {
      default: {
        skills: Array.new(6) { :default },
        survival: [:default, 6],
        advancement: [:default, 8],
      }
    }
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
      s = self.class::SPECIALIST
      if assignment
        raise(UnknownAssignment, assignment.inspect) unless s.key?(assignment)
        @assignment = assignment
      else
        @assignment = TravellerRPG.choose("Choose a specialty:", *s.keys)
      end

      # career tracking
      @term = term
      @active = active
      @rank = rank
      @benefits = benefits  # acquired equipment, ships / shares
      @term_mandate = nil
      @title = nil
    end

    def officer?
      false
    end

    def activate
      @active = true
    end

    def active?
      !!@active
    end

    def qualify_check?(career_count)
      stat, check = self.class::QUALIFICATION
      @char.log "#{self.name} qualification: #{stat} #{check}+"
      dm = @char.stats_dm(stat)
      dm += -1 * career_count
      self.class.roll_check?('Qualify', dm: dm, check: check)
    end

    def survival_check?(dm: 0)
      stat, check = self.class::SPECIALIST.fetch(@assignment).fetch(:survival)
      @char.log "#{self.name} #{@assignment} survival: #{stat} #{check}+"
      dm += @char.stats_dm(stat)
      self.class.roll_check?('Survival', dm: dm, check: check)
    end

    def advancement_check?(dm: 0)
      stat, check =
            self.class::SPECIALIST.fetch(@assignment).fetch(:advancement)
      @char.log "#{self.name} #{@assignment} advancement: #{stat} #{check}+"
      dm += @char.stats_dm(stat)
      roll = TravellerRPG.roll('2d6')
      if roll <= @term
        @term_mandate = :must_exit
      elsif roll == 12
        @term_mandate = :must_remain
      else
        @term_mandate = nil
      end
      self.class.roll_check?('Advancement', dm: dm, check: check, roll: roll)
    end

    def advanced_education?
      @char.stats[:education] >= self.class::ADVANCED_EDUCATION
    end

    # any skills obtained start at level 1
    def training_roll
      choices = [:personal, :service, :specialist]
      choices << :advanced if self.advanced_education?
      choices << :officer if self.officer?
      choice = TravellerRPG.choose("Choose skills regimen:", *choices)
      roll = TravellerRPG.roll('d6')
      @char.log "Training roll: #{roll}"
      @char.bump_skill \
              case choice
              when :personal then self.class::PERSONAL_SKILLS.fetch(roll - 1)
              when :service  then self.class::SERVICE_SKILLS.fetch(roll - 1)
              when :specialist
                self.class::SPECIALIST.dig(@assignment, :skills, roll - 1)
              when :advanced then self.class::ADVANCED_SKILLS.fetch(roll - 1)
              when :officer  then self.class::OFFICER_SKILLS.fetch(roll - 1)
              end
      self
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
        @title = title
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

      # TODO: DM?
      if self.survival_check?
        @char.log format("%s term %i completed successfully.",
                         self.name, @term)
        @char.age TERM_YEARS

        # TODO: DM?
        self.commission_roll if self.respond_to?(:commission_roll)

        # TODO: DM?
        if self.advancement_check?
          self.advance_rank
          self.training_roll
        end

        # TODO: DM?
        self.event_roll
      else
        years = rand(TERM_YEARS) + 1
        @char.log format("%s career ended with a mishap after %i years.",
                         self.name, years)
        @char.age years
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
      if rank
        hsh['Officer Rank'] = self.rank if self.officer?
        hsh['Rank'] = @rank
        hsh['Title'] = @title if @title
      end
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
