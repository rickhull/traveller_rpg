require 'traveller_rpg'

module TravellerRPG
  class Career
    class Error < RuntimeError; end
    class UnknownAssignment < Error; end

    #
    # Actually useful defaults

    TERM_YEARS = 4
    ADVANCED_EDUCATION = 8

    #
    # Needed to function

    # QUALIFICATION
    # PERSONAL_SKILLS
    # SERVICE_SKILLS
    # ADVANCED_SKILLS
    # SPECIALIST
    # EVENTS
    # MISHAPS
    # CREDITS
    # BENEFITS

    def self.roll_check?(label, dm:, check:, roll: nil)
      roll ||= TravellerRPG.roll('2d6')
      puts format("%s check: rolled %i (DM %i) against %i",
                  label, roll, dm, check)
      (roll + dm) >= check
    end

    attr_reader :term, :status, :rank, :title, :assignment

    def initialize(char, term: 0, status: :new, rank: 0)
      @char = char

      # career tracking
      @term = term
      @status = status
      @rank = rank
      @term_mandate = nil
      @title = nil
      @assignment = nil
    end

    def name
      self.class.name.split('::').last
    end

    def officer?
      false
    end

    def active?
      @status == :active
    end

    def finished?
      [:mishap, :finished].include? @status
    end

    def must_remain?
      @term_mandate == :must_remain
    end

    def must_exit?
      @term_mandate == :must_exit
    end

    # move status from :new to :active
    # take on an assignment
    # take any rank 0 title or skill
    #
    def activate(asg = nil)
      raise("invalid status: #{@status}") unless @status == :new
      @status = :active
      s = self.class::SPECIALIST
      if asg
        raise(UnknownAssignment, asg.inspect) unless s.key?(asg)
        @assignment = asg
      else
        @assignment = TravellerRPG.choose("Choose assignment:", *s.keys)
      end
      self.take_rank_benefit
    end

    def specialty
      self.class::SPECIALIST.fetch(@assignment)
    end

    def qualify_check?(dm: 0)
      return true if self.class::QUALIFICATION == false
      stat, check = self.class::QUALIFICATION
      @char.log "#{self.name} qualification: #{stat} #{check}+"
      dm += @char.stats_dm(stat)
      self.class.roll_check?('Qualify', dm: dm, check: check)
    end

    def survival_check?(dm: 0)
      stat, check = self.specialty.fetch(:survival)
      @char.log "#{self.name} [#{@assignment}] survival: #{stat} #{check}+"
      dm += @char.stats_dm(stat)
      self.class.roll_check?('Survival', dm: dm, check: check)
    end

    def advancement_check?(dm: 0)
      stat, check = self.specialty.fetch(:advancement)
      @char.log "#{self.name} [#{@assignment}] advancement: #{stat} #{check}+"
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
      return false if self.class::ADVANCED_SKILLS == false
      @char.stats[:education] >= self.class::ADVANCED_EDUCATION
    end

    def advancement_roll(dm: 0)
      if self.advancement_check?(dm: dm)
        self.advance_rank
        self.training_roll
      end
    end

    # any skills obtained start at level 1; always a bump (+1)
    def training_roll
      choices = [:personal, :service, :specialist]
      choices << :advanced if self.advanced_education?
      choices << :officer if self.officer?
      choice = TravellerRPG.choose("Choose skills regimen:", *choices)
      roll = TravellerRPG.roll('d6', label: 'Training')
      skill =
        case choice
        when :personal then self.class::PERSONAL_SKILLS.fetch(roll - 1)
        when :service  then self.class::SERVICE_SKILLS.fetch(roll - 1)
        when :specialist then self.specialty.fetch(:skills).fetch(roll - 1)
        when :advanced then self.class::ADVANCED_SKILLS.fetch(roll - 1)
        when :officer  then self.class::OFFICER_SKILLS.fetch(roll - 1)
        end
      skill = TravellerRPG.choose("Choose:", *skill) if skill.is_a?(Array)
      # the "skill" could be a stat e.g. endurance
      if @char.skills.known?(skill)
        @char.skills.bump(skill)
      else
        @char.stats.bump(skill)
      end
      @char.log "Trained #{skill} +1"
      self
    end

    def event_roll
      ev = self.class::EVENTS.fetch TravellerRPG.roll('2d6', label: 'Event')
      @char.log "Event: #{ev.fetch('text')}"
      # TODO: actually perform the event stuff in ev['script']
    end

    def mishap_roll
      mh = self.class::MISHAPS.fetch TravellerRPG.roll('d6', label: 'Mishap')
      @char.log "Mishap: #{mh.fetch('text')}"
      # TODO: actually perform the mishap stuff in mh['script']
    end

    def advance_rank
      @rank += 1
      @char.log "Advanced career to rank #{@rank}"
      self.take_rank_benefit
    end

    # possibly nil
    def rank_benefit
      self.specialty.fetch(:ranks)[@rank]
    end

    def take_rank_benefit
      rb = self.rank_benefit or return self
      label = self.officer? ? "officer rank" : "rank"
      title, skill, stat, level =
                          rb.values_at('title', 'skill', 'stat', 'level')
      if title
        @char.log "Awarded #{label} title: #{title}"
        @title = title
      end
      if skill
        if skill.is_a?(Array)
          skill = TravellerRPG.choose("Choose rank bonus:", *skill)
        end
        @char.log "Achieved #{label} bonus: #{skill} #{level}"
        @char.skills.bump(skill, level)
      end
      if stat
        if stat.is_a?(Array)
          stat = TravellerRPG.choose("Choose rank bonus:", *stat)
        end
        @char.log "Achieved #{label} bonus: #{stat} #{level}"
        @char.stats.bump(stat, level)
      end
      self
    end

    def run_term
      raise(Error, "career is inactive") unless self.active?
      raise(Error, "must exit") if self.must_exit?
      @term += 1
      @char.log format("%s term %i started, age %i",
                       self.name, @term, @char.age)
      self.training_roll

      if self.survival_check?
        @char.log format("%s term %i completed successfully.",
                         self.name, @term)
        @char.age TERM_YEARS
        self.advancement_roll # TODO: DM?
        self.event_roll
      else
        years = rand(TERM_YEARS) + 1
        @char.log format("%s career ended with a mishap after %i years.",
                         self.name, years)
        @char.age years
        self.mishap_roll
        @status = :mishap
      end
      self
    end

    def retirement_bonus
      @term >= 5 ? @term * 2000 : 0
    end

    # returns the roll value with DM applied
    def muster_roll
      dm = @char.skills.check?('Gambler', 1) ? 1 : 0
      TravellerRPG.roll('d6', label: 'Muster', dm: dm)
    end

    def muster_out
      @char.log "Muster out: #{self.name}"
      raise(Error, "career has not started") unless @term > 0
      cash_rolls = @term.clamp(0, 3 - @char.cash_rolls)
      total_ranks = self.officer? ? self.rank + self.enlisted_rank : self.rank
      benefit_rolls = @term + ((total_ranks + 1) / 2).clamp(0, 3)

      case @status
      when :active
        @char.log "Muster out: Career in good standing; collect all benefits"
      when :mishap
        @char.log "Muster out: Career ended early; lose last term benefit"
        benefit_rolls -= 1
      when :new, :finished
        raise "invalid status: #{@status}"
      else
        raise "unknown status: #{@status}"
      end

      # Collect "muster out" benefits
      cash_rolls.times {
        @char.cash_roll self.class::CREDITS.fetch(self.muster_roll)
      }
      benefit_rolls.times {
        @char.benefit self.class::BENEFITS.fetch(self.muster_roll)
      }
      @char.benefit self.retirement_bonus
      @status = :finished
      self
    end

    def report(term: true, status: true, rank: true, spec: true)
      hsh = {}
      hsh['Term'] = @term if term
      hsh['Status'] = @status.to_s.capitalize if status
      hsh['Specialty'] = @assignment if spec
      hsh['Title'] = @title if @title
      if rank
        if self.officer?
          hsh['Officer Rank'] = @officer
          hsh['Enlisted Rank'] = @rank
        else
          hsh['Rank'] = @rank
        end
      end
      report = ["Career: #{self.name}", "==="]
      hsh.each { |label, val|
        report << format("%s: %s", label.to_s.rjust(15, ' '), val)
      }
      report.join("\n")
    end
  end

  class ExampleCareer < Career
    #
    # These are not present in a normal Career

    STAT = :strength
    STAT_CHECK = 5
    TITLE = 'Rookie'
    SKILL = 'Deception'

    #
    # These are necessary for a Career to function

    QUALIFICATION = [STAT, STAT_CHECK]

    PERSONAL_SKILLS = Array.new(6) { SKILL }
    SERVICE_SKILLS = Array.new(6) { SKILL }
    ADVANCED_SKILLS = Array.new(6) { SKILL }

    SPECIALIST = {
      'Specialist' => {
        skills: Array.new(6) { SKILL },
        survival: [STAT, STAT_CHECK],
        advancement: [STAT, STAT_CHECK],
        ranks: { 0 => [TITLE, SKILL] },
      }
    }
  end

  #
  # MilitaryCareer adds Officer commission and parallel Officer ranks

  class MilitaryCareer < Career
    #
    # Actually useful default

    COMMISSION = [:social_status, 8]

    def initialize(char, **kwargs)
      super(char, **kwargs)
      @officer = false
    end

    # Implement age penalty
    def qualify_check?(dm: 0)
      dm -= 2 if @char.age >= self.class::AGE_PENALTY
      super(dm: dm)
    end

    def commission_check?(dm: 0)
      stat, check = self.class::COMMISSION
      @char.log "#{self.name} commission: #{stat} #{check}"
      dm += @char.stats_dm(stat)
      self.class.roll_check?('Commission', dm: dm, check: check)
    end

    def advancement_roll(dm: 0)
      if !@officer and
         (@term == 1 or @char.stats[:social_status] > 9) and true
         # TravellerRPG.choose("Apply for commission?", :yes, :no) == :yes
        comm_dm = @term > 1 ? dm - 1 : dm
        if self.commission_check?(dm: comm_dm)
          @char.log "Became an officer!"
          @officer = 1
          self.take_rank_benefit
          # skip normal advancement after successful commission
          return self
        else
          @char.log "Commission was rejected"
        end
      end
      # perform normal advancement unless commission was obtained
      super(dm: dm)
    end

    #
    # Handle parallel officer track, conditional on officer commission

    def officer?
      !!@officer
    end

    def enlisted_rank
      @rank
    end

    def rank
      @officer ? @officer : @rank
    end

    def rank_benefit
      @officer ? self.class::OFFICER_RANKS[@officer] : super
    end

    def advance_rank
      return super unless @officer
      @officer += 1
      @char.log "Advanced career to officer rank #{@officer}"
      self.take_rank_benefit
    end
  end

  class ExampleMilitaryCareer < Career
    #
    # These are not present in a normal Career or MilitaryCareer

    STAT = :strength
    STAT_CHECK = 5
    TITLE = 'Rookie'
    SKILL = 'Deception'
    OFFICER_TITLE = 'Lieutenant'
    OFFICER_SKILL = 'Tactics'

    #
    # These are necessary for a Career to function

    QUALIFICATION = [STAT, STAT_CHECK]

    PERSONAL_SKILLS = Array.new(6) { SKILL }
    SERVICE_SKILLS = Array.new(6) { SKILL }
    ADVANCED_SKILLS = Array.new(6) { SKILL }

    SPECIALIST = {
      'Specialist' => {
        skills: Array.new(6) { SKILL },
        survival: [STAT, STAT_CHECK],
        advancement: [STAT, STAT_CHECK],
        ranks: { 0 => [TITLE, SKILL] },
      }
    }

    #
    # These are necessary for a MilitaryCareer to function

    AGE_PENALTY = 40
    OFFICER_SKILLS = Array.new(6) { OFFICER_SKILL }
    OFFICER_RANKS = { 0 => [OFFICER_TITLE, OFFICER_SKILL] }
  end
end
