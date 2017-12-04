require 'traveller_rpg/career'

module TravellerRPG
  class CareerPath
    class Error < RuntimeError; end
    class Ineligible < Error; end

    attr_reader :char, :careers, :active_career

    def initialize(character)
      @char = character
      @char.log "Initiated new career path"
      @careers = []
      @active_career
    end

    def run(career)
      self.apply(career) or self.fallback
      return unless @active_career
      loop {
        @active_career.run_term
        break unless @active_career.active?
        break if @active_career.must_exit?
        next if @active_career.must_remain?
        break if TravellerRPG.choose("Muster out?", :yes, :no) == :yes
      }
      self.muster_out
    end

    def eligible?(career)
      case career
      when Career
        return false if career.active?
        cls = career.class
      when String
        cls = TravellerRPG.career_class(career)
      end
      !@careers.any? { |c| c.class == cls }
    end

    def apply(career)
      raise(Ineligible, career.name) unless self.eligible?(career)
      if career.qualify_check?(@careers.size)
        @char.log "Qualified for #{career.name}"
        self.enter(career)
      else
        @char.log "Did not qualify for #{career.name}"
        false
      end
    end

    def enter(career)
      raise(Ineligible, career.name) unless self.eligible?(career)
      raise(Error, "career is already active") if career.active?
      raise(Error, "career has already started") unless career.term == 0
      self.muster_out # exit any active career
      @char.log "Entering new career: #{career.name}"
      career.activate
      @active_career = career
      self.basic_training
      self
    end

    def basic_training
      return unless @active_career.term.zero?
      if @careers.length.zero?
        @active_career.class::SERVICE_SKILLS
      else
        skills = @active_career.class::SERVICE_SKILLS
        skills -= @char.skills.keys
        skills.empty? ? [] : [TravellerRPG.choose("Service skill", *skills)]
      end.each { |sym|
        if char.skills.key?(sym)
          @char.log "Basic training for #{sym} already acquired"
        else
          @char.log "Acquired basic training skill: #{sym} 0"
          @char.skills[sym] = 0
        end
      }
    end

    def fallback
      case TravellerRPG.choose("Fallback career:", :draft, :drifter, :none)
      when :draft
        choice = TravellerRPG.choose("Enlist:", 'Army', 'Navy', 'Marines')
        career = TravellerRPG.career_class(choice).new(@char)
        self.enter(career)
      when :drifter
        self.apply(TravellerRPG::Drifter.new(@char))
      end
    end

    def muster_out
      if @active_career
        @active_career.muster_out
        @careers << @active_career
        @active_career = nil
      end
    end
  end
end
