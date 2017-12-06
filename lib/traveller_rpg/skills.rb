require 'traveller_rpg/skill'

module TravellerRPG
  def self.skill?(*args)
    case args.first
    when String
      raise(ArgumentError, "only one string arg expected") if args.length != 1
      symbols = Skill.syms(args.first)
    when Symbol
      symbols = args
    else
      raise(ArgumentError, "unexpected args: #{args.first.inspect}")
    end
    return false unless SKILLS.key?(symbols.first)
    return true if symbols.length == 1
    return false if symbols.length > 2
    return false unless SKILLS[symbols.first]
    SKILLS[symbols.first].include?(symbols.last)
  end

  def self.skill(sym)
    subs = SKILLS.fetch(sym)
    if subs.nil?
      Skill.new(Skill.name(sym))
    else
      ComplexSkill.new(Skill.name(sym),
                       skills: subs.map { |s| Skill.new(Skill.name(s)) })
    end
  end

  COMPLEX_SKILLS = {
    'Animals' => {
      'Handling' => '',
      'Veterinary' => '',
      'Training' => '',
    },
    'Art' => {
      'Performer' => '',
      'Holography' => '',
      'Instrument' => '',
      'Visual Media' => '',
      'Write' => '',
    },
    'Athletics' => {
      'Dexterity' => '',
      'Endurance' => '',
      'Strength' => '',
    },
    'Drive' => {
      'Hovercraft' => '',
      'Mole' => '',
      'Track' => '',
      'Walker' => '',
      'Wheel' => '',
    },
    'Electronics' => {
      'Comms' => '',
      'Computers' => '',
      'Remote Ops' => '',
      'Sensors' => '',
    },
    'Engineer' => {
      'Manoeuvre' => '',
      'Jump Drive' => '',
      'Life Support' => '',
      'Power' => '',
    },
    'Flyer' => {
      'Airship' => '',
      'Grav' => '',
      'Ornithopter' => '',
      'Rotor' => '',
      'Wing' => '',
    },
    'Gunner' => {
      'Turret' => '',
      'Ortillery' => '',
      'Screen' => '',
      'Capital' => '',
    },
    'Gun Combat' => {
      'Archaic' => '',
      'Energy' => '',
      'Slug' => '',
    },
    'Heavy Weapons' => {
      'Artillery' => '',
      'Man Portable' => '',
      'Vehicle' => '',
    },
    # language: [:anglic, :vilani, :zdetl, :oynprith],
    'Language' => {
      'Anglic' => '',
      'Vilani' => '',
      'Zdetl' => '',
      'Oynprith' => '',
    },
    'Melee' => {
      'Blade' => '',
      'Bludgeon' => '',
      'Natural' => '',
      'Unarmed' => '',
    },
    'Pilot' => {
      'Small Craft' => '',
      'Spacecraft' => '',
      'Capital' => '',
    },
    'Profession' => {
      'Belter' => '',
      'Biologicals' => '',
      'Civil Engineering' => '',
      'Construction' => '',
      'Hydroponics' => '',
      'Polymers' => '',
    },
    'Science' => {
      'Archaeology' => '',
      'Astronomy' => '',
      'Biology' => '',
      'Chemistry' => '',
      'Cosmology' => '',
      'Cybernetics' => '',
      'Economics' => '',
      'Genetics' => '',
      'History' => '',
      'Linguistics' => '',
      'Philosophy' => '',
      'Physics' => '',
      'Planetology' => '',
      'Psionicology' => '',
      'Psychology' => '',
      'Robotics' => '',
      'Sophontology' => '',
      'Xenology' => '',
    },
    'Seafarer' => {
      'Ocean Ships' => '',
      'Personal' => '',
      'Sail' => '',
      'Submarine' => '',
    },
    'Tactics' => {
      'Military' => '',
      'Naval' => '',
    },
  }

  SIMPLE_SKILLS = {
    'Admin' => '',
    'Advocate' => '',
    'Astrogation' => '',
    'Broker' => '',
    'Carouse' => '',
    'Deception' => '',
    'Diplomat' => '',
    'Explosives' => '',
    'Gambler' => '',
    'Investigate' => '',
    'Jack Of All Trades' => '',
    'Leadership' => '',
    'Mechanic' => '',
    'Medic' => '',
    'Navigation' => '',
    'Persuade' => '',
    'Recon' => '',
    'Stealth' => '',
    'Steward' => '',
    'Streetwise' => '',
    'Survival' => '',
    'Vacc Suit' => '',
  }

###########

  SKILLS = {
    admin:  nil,
    advocate: nil,
    animals: [:handling, :veterinary, :training],
    art: [:performer, :holography, :instrument, :visual_media, :write],
    astrogation: nil,
    athletics: [:dexterity, :endurance, :strength],
    broker: nil,
    carouse: nil,
    deception: nil,
    diplomat: nil,
    drive: [:hovercraft, :mole, :track, :walker, :wheel],
    electronics: [:comms, :computers, :remote_ops, :sensors],
    engineer: [:manoeuvre, :jump_drive, :life_support, :power],
    explosives: nil,
    flyer: [:airship, :grav, :ornithopter, :rotor, :wing],
    gambler: nil,
    gunner: [:turret, :ortillery, :screen, :capital],
    gun_combat: [:archaic, :energy, :slug],
    heavy_weapons: [:artillery, :man_portable, :vehicle],
    investigate: nil,
    jack_of_all_trades: nil,
    language: [:anglic, :vilani, :zdetl, :oynprith],
    leadership: nil,
    mechanic: nil,
    medic: nil,
    melee: [:unarmed, :blade, :bludgeon, :natural],
    navigation: nil,
    persuade: nil,
    pilot: [:small_craft, :spacecraft, :capital_ships],
    profession: [:belter, :biologicals, :civil_engineering,
                 :construction, :hydroponics, :polymers],
    recon: nil,
    science: [:archaeology, :astronomy, :biology, :chemistry,
              :cosmology, :cybernetics, :economics, :genetics,
              :history, :linguistics, :philosophy, :physics,
              :planetology, :psionicology, :psychology, :robotics,
              :sophontology, :xenology],
    seafarer: [:ocean_ships, :personal, :sail, :submarine],
    stealth: nil,
    steward: nil,
    streetwise: nil,
    survival: nil,
    tactics: [:military, :naval],
    vacc_suit: nil,
  }
end
