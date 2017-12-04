require 'traveller_rpg/career'

module TravellerRPG
  class CareerPath
    class Error < RuntimeError; end
    class Ineligible < Error; end

    attr_reader :char, :careers

    def initialize(character)
      @char = character
      @char.log "Initiated new career path"
      @careers = []
    end

    def run(career)
      career = self.fallback unless self.apply(career)
      loop {
        career.run_term
        break unless career.active?
        break if career.must_exit?
        next if career.must_remain?
        break if TravellerRPG.choose("Muster out?", :yes, :no) == :yes
      }
      career.muster_out
      @careers << career
      career
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

    def fallback
      choices = self.eligible(%w{Drifter Army Navy Marines})
      choice = TravellerRPG.choose("Fallback career:", *choices)
      career = TravellerRPG.career_class(choice).new(@char)
      self.enter(career)
    end

    def eligible(careers)
      careers.select { |c| self.eligible?(c) }
    end

    def eligible?(career)
      case career
      when Career
        return false if career.active?
        cls = career.class
      when String
        cls = TravellerRPG.career_class(career)
      end
      return true if cls == TravellerRPG::Drifter
      !@careers.any? { |c| c.class == cls }
    end

    def enter(career)
      raise(Ineligible, career.name) unless self.eligible?(career)
      raise(Error, "career is already active") if career.active?
      raise(Error, "career has already started") unless career.term == 0
      @char.log "Entering new career: #{career.name}"
      career.activate
      self.basic_training(career)
      career
    end

    def basic_training(career)
      return unless career.term.zero?
      skills = career.class::SERVICE_SKILLS - @char.skills.keys
      return if skills.empty?
      if @careers.length > 0
        skills = [TravellerRPG.choose("Choose service skill:", *skills)]
      end
      skills.each { |sym|
        raise "unknown skill: #{sym}" unless TravellerRPG::SKILLS.key?(sym)
        @char.log "Acquired basic training skill: #{sym} 0"
        @char.skills[sym] = 0
      }
    end
  end
end
