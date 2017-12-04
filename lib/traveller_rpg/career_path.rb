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
        [TravellerRPG.choose("Service skill",
                             *@active_career.class::SERVICE_SKILLS)]
      end.each { |sym|
        unless char.skills.key?(sym)
          @char.log "Acquired basic training skill: #{sym} 0"
          @char.skills[sym] = 0
        end
      }
    end

    def run_term
      raise(Error, "no active career") unless @active_career
      @active_career.run_term
    end

    def muster_out
      if @active_career
        @active_career.muster_out
        @careers << @active_career
        @active_career = nil
      end
    end

    def draft_term
      @char.log "Drafted! (fake)"
    end

    def drifter_term
      @char.log "Became a drifter (fake)"
    end
  end
end
