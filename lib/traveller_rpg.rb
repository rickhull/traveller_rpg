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
end

# compatibility stuff

unless Comparable.method_defined?(:clamp)
  module Comparable
    def clamp(low, high)
      [[self, low].max, high].min
    end
  end
end
