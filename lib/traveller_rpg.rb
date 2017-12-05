module TravellerRPG
  PLAYER_CHOOSE = ENV['HUMAN']

  ROLL_RGX = %r{
    \A    # starts with
    (\d*) # 0 or more digits; dice count
    [dD]  # character d
    (\d+) # 1 or more digits; face count
    \z    # end str
  }x

  def self.roll(str = nil, faces: 6, dice: 2, count: 1)
    return self.roll_str(str) if str
    rolln = -> (faces, dice) { Array.new(dice) { rand(faces) + 1 } }
    (Array.new(count) { rolln.(faces, dice).sum }.sum.to_f / count).round
  end

  def self.roll_str(str)
    matches = str.match(ROLL_RGX) or raise("bad roll: #{str}")
    dice, faces = matches[1], matches[2]
    self.roll(dice: dice.empty? ? 1 : dice.to_i, faces: faces.to_i)
  end

  def self.choose(msg, *args)
    puts msg + '  (' + args.join('  ') + ')'
    raise "no choices" if args.empty?
    return self.player_choose(msg, *args) if PLAYER_CHOOSE
    choice = args.sample
    puts "> #{choice}"
    choice
  end

  def self.player_choose(msg, *args)
    chosen = false
    while !chosen
      choice = self.player_prompt
      if args.include?(choice)
        chosen = choice
      elsif args.include?(choice.to_sym)
        chosen = choice.to_sym
      else
        puts "Try again.\n"
      end
    end
    chosen
  end

  def self.player_prompt(msg = nil)
    print msg + ' ' if msg
    print '> '
    $stdin.gets(chomp: true)
  end

  # per http://www.traveller-srd.com/core-rules/skills/
  SKILLS = {
    admin:  nil,
    advocate: nil,

    animals_group: nil,
    animals_riding: nil,
    animals_veterinary: nil,
    animals_training: nil,
    animals_farming: nil,

    athletics_group: nil,
    athletics_coordination: nil,
    athletics_endurance: nil,
    athletics_strength: nil,
    athletics_flying: nil,

    art_group: nil,
    art_acting: nil,
    art_dance: nil,
    art_holography: nil,
    art_instrument: nil,
    art_sculpting: nil,
    art_writing: nil,

    astrogation: nil,
    battle_dress: nil,
    broker: nil,
    carouse: nil,
    comms: nil,
    computers: nil,
    deception: nil,
    diplomat: nil,

    drive_group: nil,
    drive_hovercraft: nil,
    drive_mole: nil,
    drive_tracked: nil,
    drive_walker: nil,
    drive_wheeled: nil,

    engineer_group: nil,
    engineer_manoeuvre: nil,
    engineer_jump_drive: nil,
    engineer_electronics: nil,
    engineer_life_support: nil,
    engineer_power: nil,

    explosives: nil,

    flyer_group: nil,
    flyer_airship: nil,
    flyer_grav: nil,
    flyer_rotor: nil,
    flyer_wing: nil,

    gambler: nil,

    gunner_group: nil,
    gunner_turrets: nil,
    gunner_ortillery: nil,
    gunner_screens: nil,
    gunner_capital_weapons: nil,

    gun_combat_group: nil,
    gun_combat_slug_rifle: nil,
    gun_combat_slug_pistol: nil,
    gun_combat_shotgun: nil,
    gun_combat_energy_rifle: nil,
    gun_combat_energy_pistol: nil,

    heavy_weapons_group: nil,
    heavy_weapons_launchers: nil,
    heavy_weapons_man_portable_artillery: nil,
    heavy_weapons_field_artillery: nil,

    investigate: nil,
    jack_of_all_trades: nil,

    language_group: nil,
    language_anglic: nil,

    leadership: nil,

    life_sciences_group: nil,
    life_sciences_biology: nil,
    life_sciences_cybernetics: nil,
    life_sciences_genetics: nil,
    life_sciences_psionicology: nil,

    mechanic: nil,
    medic: nil,

    melee_group: nil,
    melee_unarmed_combat: nil,
    melee_blade: nil,
    melee_bludgeon: nil,
    melee_natural_weapons: nil,

    navigation: nil,
    persuade: nil,

    pilot_group: nil,
    pilot_small_craft: nil,
    pilot_spacecraft: nil,
    pilot_capital_ships: nil,

    physical_sciences_group: nil,
    physical_sciences_physics: nil,
    physical_sciences_chemistry: nil,
    physical_sciences_electronics: nil,

    recon: nil,
    remote_operations: nil,

    seafarer_group: nil,
    seafarer_sail: nil,
    seafarer_submarine: nil,
    seafarer_ocean_ships: nil,
    seafarer_motorboats: nil,

    sensors: nil,

    social_sciences_group: nil,
    social_sciences_archeology: nil,
    social_sciences_economics: nil,
    social_sciences_history: nil,
    social_sciences_linguistics: nil,
    social_sciences_philosophy: nil,
    social_sciences_psychology: nil,
    social_sciences_sophontology: nil,

    space_sciences_group: nil,
    space_sciences_planetology: nil,
    space_sciences_robotics: nil,
    space_sciences_xenology: nil,

    stealth: nil,
    steward: nil,
    streetwise: nil,
    survival: nil,

    tactics_group: nil,
    tactics_military: nil,
    tactics_ground: nil,

    trade_group: nil,
    trade_biologicals: nil,
    trade_civil_engineering: nil,
    trade_space_construction: nil,
    trade_hydroponics: nil,
    trade_polymers: nil,

    vacc_suit: nil,
    zero_g: nil,
  }
end

# compatibility stuff

unless Comparable.method_defined?(:clamp)
  module Comparable
    def clamp(low, high)
      [[self, low].max, high].min
    end
  end
end
