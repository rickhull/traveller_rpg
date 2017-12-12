require 'traveller_rpg'
require 'benchmark/ips'

Benchmark.ips do |b|
  b.config time: 1, warmup: 0.1

  b.report("roll") do
    TravellerRPG.roll
  end

  b.report("roll_ary") do
    TravellerRPG.roll_ary
  end

  b.report("roll!") do
    TravellerRPG.roll!
  end

  b.report("roll_ary!") do
    TravellerRPG.roll_ary!
  end

  b.compare!
end
