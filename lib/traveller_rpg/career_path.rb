require 'traveller_rpg'
require 'traveller_rpg/careers'
require 'traveller_rpg/skill'


module TravellerRPG
  autoload :Generator, 'traveller_rpg/generator'

  class CareerPath
    class Error < RuntimeError; end
    class Ineligible < Error; end

    DRAFT_CAREERS = {
      1 => ['Navy', nil],
      2 => ['Army', nil],
      3 => ['Marines', nil],
      4 => ['Merchant', 'Merchant Marine'],
      5 => ['Scout', nil],
      6 => ['Agent', 'Law Enforcement'],
    }

    def self.career_class(str)
      TravellerRPG.const_get(str.split('::').last)
    end

    def self.run(careers, character: nil)
      character = Generator.character unless character
      puts "\n", character.report(desc: :long, stuff: false, credits: false)
      path = self.new(character)
      loop {
        careers = path.eligible(careers)
        break if careers.empty?
        choice = TravellerRPG.choose("Choose a career:", *careers)
        career = self.career_class(choice).new(character)
        path.run(career)
        puts "\n", path.report, "\n"
        break if TravellerRPG.choose("Exit career mode?", :yes, :no) == :yes
      }
      path
    end

    attr_reader :char, :careers

    def initialize(character)
      @char = character
      @char.log "Initiated new career path"
      @careers = []
    end

    # Run career to completion; keep running terms while possible
    def run(career)
      career = self.apply(career)
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

    # Pass eligibility and qualify_check
    # Take Drifter or Draft if disqualified
    # Then enter career
    def apply(career)
      raise(Ineligible, career.name) unless self.eligible?(career)
      if career.qualify_check?(dm: -1 * @careers.size)
        @char.log "Qualified for #{career.name}"
        self.enter(career)
      else
        @char.log "Did not qualify for #{career.name}"
        case TravellerRPG.choose("Fallback career:", :drifter, :draft)
        when :drifter
          self.enter TravellerRPG::Drifter.new(@char)
        when :draft
          self.draft
        end
      end
    end

    # return an active career, no qualification, that has completed basic
    # training
    def draft
      roll = TravellerRPG.roll('d6')
      puts "Draft roll: #{roll}"
      dc = self.class::DRAFT_CAREERS.fetch(roll)
      @char.log "Drafted: #{dc.compact.join(', ')}"

      career = CareerPath.career_class(dc.first).new(@char)
      career.activate(dc.last)
      self.basic_training(career)
      career
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
        cls = CareerPath.career_class(career)
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
      if @careers.length > 0
        skills = career.class::SERVICE_SKILLS.flatten.reject { |s|
          @char.skills[s]
        }
        return if skills.empty?
        skills = [TravellerRPG.choose("Choose service skill:", *skills)]
      else
        # Take "all" SERVICE_SKILLS, but choose any choices
        skills = []
        career.class::SERVICE_SKILLS.each { |skill|
          if skill.is_a?(Array)
            skill = skill.reject { |s| @char.skills[s] }
            case skill.size
            when 0
              return
            when 1
              skills << skill
            else
              skills << TravellerRPG.choose("Choose service skill:", *skill)
            end
          else
            skills << skill unless @char.skills[skill]
          end
        }
      end
      skills.each { |skill|
        @char.skills.provide(skill)
        @char.log "Acquired basic training skill: #{skill}"
      }
    end

    def report(char: true, careers: true)
      [@char.report,
       @careers.map(&:report).join("\n\n")].join("\n\n")
    end
  end
end
