require 'rake/testtask'

Rake::TestTask.new :test do |t|
  t.pattern = "test/*.rb"
  t.warning = true
end

begin
  require 'buildar'

  Buildar.new do |b|
    b.gemspec_file = 'traveller_rpg.gemspec'
    b.version_file = 'VERSION'
    b.use_git = true
  end
rescue LoadError
  warn "buildar tasks unavailable"
end

def chargen *args
  ruby '-Ilib', 'bin/chargen', *args
end

desc "Run chargen"
task :chargen do
  # consume ARGV
  args = []
  found = false
  while !ARGV.empty?
    arg = ARGV.shift
    # skip all args until we reach 'mrbt'
    if found
      args << arg unless arg == '--'
    elsif arg == 'chargen'
      found = true
    end
  end

  begin
    chargen *args
  rescue RuntimeError
    exit 1
  end
end

task :career_stats do
  $LOAD_PATH.unshift(File.join(__dir__, 'lib'))
  require 'traveller_rpg/careers'

  by_stat = {
    strength: {},
    dexterity: {},
    endurance: {},
    intelligence: {},
    education: {},
    social_status: {},
  }

  # for each career, show relevant stats
  ObjectSpace.each_object(Class) { |klass|
    next unless klass < TravellerRPG::Career
    next if klass == TravellerRPG::MilitaryCareer
    name = klass.name.split('::').last
    qual = klass.const_get('QUALIFICATION')
    qual = qual[:choose] if qual and qual[:choose]

    if qual
      qual.each { |stat, check|
        by_stat[stat][:qualification] ||= {}
        by_stat[stat][:qualification][name] = check
      }
    end

    puts "#{name} #{qual}"
    spec = klass.const_get('SPECIALIST')
    spec.each { |asg, cfg|
      puts "\t#{asg} survival: #{cfg[:survival]}"
      puts "\t#{asg} advancement: #{cfg[:advancement]}"

      cfg[:survival].each { |stat, check|
        by_stat[stat][:survival] ||= {}
        by_stat[stat][:survival][name] ||= {}
        by_stat[stat][:survival][name][asg] = check
      }
      cfg[:advancement].each { |stat, check|
        by_stat[stat][:advancement] ||= {}
        by_stat[stat][:advancement][name] ||= {}
        by_stat[stat][:advancement][name][asg] = check
      }
    }
  }

  scores = {}

  def score(num, check_type)
    c = case check_type
        when :qualification then 1
        when :survival then 0.9
        when :advancement then 0.8
        end
    c * (10 - num)
  end

  by_stat.each { |stat, hsh|
#    puts
#    puts stat
#    puts "==="
    scores[stat] = {}
    [:qualification, :survival, :advancement].each { |check_type|
      next unless hsh.key?(check_type)
      hsh[check_type].each { |kls, cfg|
#        puts "#{kls} #{check_type}"
        scores[stat][kls] ||= {}
        scores[stat][kls][:total] ||= 0
        case check_type
        when :qualification
          scores[stat][kls][:total] += score(cfg, check_type)
        when :advancement, :survival
          cfg.each { |asg, check|
#            puts "#{kls} #{asg} #{check_type}"
            scores[stat][kls][:total] += score(check, check_type)
            scores[stat][kls][asg] ||= 0
            scores[stat][kls][asg] += score(check, check_type)
          }
        end
      }
    }
  }

  scores.each { |stat, hsh|
    puts
    puts stat
    puts "==="
    hsh.sort_by { |kls, score_hsh|
      score_hsh[:total]
    }.reverse.each { |kls, score_hsh|
      puts format("%s %0.1f", kls, score_hsh[:total])
      score_hsh.sort_by { |k, v| v }.reverse.each { |k, v|
        next if k == :total
        puts format("\t%s %0.1f", k, v)
      }
    }
  }
end
