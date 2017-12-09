module TravellerRPG
  PLAYER_CHOOSE = ENV['HUMAN']

  ROLL_RGX = %r{
    \A    # starts with
    (\d*) # 0 or more digits; dice count
    [dD]  # character d
    (\d+) # 1 or more digits; face count
    \z    # end str
  }x

  def self.roll(spec = 'd6', label: nil, dm: 0)
    matches = spec.match(ROLL_RGX) or raise("bad roll spec: #{spec}")
    roll = self.roll_int(dice: matches[1].empty? ? 1 : matches[1].to_i,
                         faces: matches[2].to_i, label: label)
    puts "#{label} roll (#{spec}): #{roll} (DM #{dm})" if label
    roll + dm
  end

  # this is the fastest, but won't print individual die values
  def self.roll_int(dice: 1, faces: 6)
    val = 0
    dice.times { val += rand(faces) + 1 }
    val
  end

  def self.roll_ary(dice: 1, faces: 6)
    Array.new(dice) { rand(faces) + 1 }.sum
  end

  def self.choose(msg, *args)
    puts msg + '  (' + args.join(' | ') + ')'
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
end

# compatibility stuff

unless Comparable.method_defined?(:clamp)
  module Comparable
    def clamp(low, high)
      [[self, low].max, high].min
    end
  end
end
