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
    scores[stat] = {}
    [:qualification, :survival, :advancement].each { |check_type|
      next unless hsh.key?(check_type)
      hsh[check_type].each { |kls, cfg|
        scores[stat][kls] ||= {}
        scores[stat][kls][:total] ||= 0
        case check_type
        when :qualification
          scores[stat][kls][:total] += score(cfg, check_type)
        when :advancement, :survival
          cfg.each { |asg, check|
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

task :choose_report do
  $LOAD_PATH.unshift(File.join(__dir__, 'lib'))
  require 'traveller_rpg/careers'

  report = {
    skills: {},
    stat_checks: {},
    ranks: {},
    benefits: {},
  }

  # for each career, show relevant stats
  ObjectSpace.each_object(Class) { |klass|
    next unless klass < TravellerRPG::Career
    next if klass == TravellerRPG::MilitaryCareer
#    next if klass == TravellerRPG::Drifter

    name = klass.name.split('::').last
    qual = klass.const_get('QUALIFICATION')
    if qual and qual[:choose]
      report[:stat_checks][name] ||= []
      report[:stat_checks][name] << :qualification
    end
    %w{PERSONAL_SKILLS SERVICE_SKILLS ADVANCED_SKILLS}.each { |sk|
      skills = klass.const_get(sk) rescue nil
      next unless skills
      skills.each { |item|
        if item.is_a?(Hash) and item[:choose]
          report[:skills][name] ||= []
          report[:skills][name] << sk
        end
      }
    }
    spec = klass.const_get('SPECIALIST')
    if spec
      spec.each { |asg, cfg|
        # ranks, skills, stat_checks
        ranks = cfg.fetch(:ranks)
        ranks.each { |rank, hsh|
          if hsh[:choose] or
            (hsh[:skill].is_a?(Hash) and hsh[:skill][:choose]) or
            (hsh[:stat].is_a?(Hash) and hsh[:stat][:choose])
            report[:ranks][name] ||= []
            report[:ranks][name] << "[#{asg}]"
          else
            # p hsh
          end
        }
        skills = cfg.fetch(:skills)
        skills.each { |item|
          if item.is_a?(Hash) and item[:choose]
            report[:skills][name] ||= []
            report[:skills][name] << "[#{asg}]"
          end
        }
        [:survival, :advancement].each { |sc|
          stat_check = cfg.fetch(sc)
          if stat_check[:choose]
            report[:stat_checks][name] ||= []
            report[:stat_checks][name] << sc
          end
        }
      }
    end

    ben = klass.const_get('BENEFITS')
    if ben
      ben.each { |roll, hsh|
        if hsh.is_a?(Hash) and hsh[:choose]
          report[:benefits][name] ||= []
          report[:benefits][name] << roll
        end
      }
    end

    if klass < TravellerRPG::MilitaryCareer
      oranks = klass.const_get('OFFICER_RANKS')
      oranks.each { |rank, hsh|
        if hsh[:choose] or
          (hsh[:skill].is_a?(Hash) and hsh[:skill][:choose]) or
          (hsh[:stat].is_a?(Hash) and hsh[:stat][:choose])
          report[:ranks][name] ||= []
          report[:ranks][name] << 'Officer'
        else
          # p hsh
        end
      }
    end
  }

  report.each { |item, hsh|
    puts
    puts item
    puts "==="

    hsh.each { |name, stuff|
      puts "#{name}: #{stuff.join(' ')}"
    }
  }
end

task :military_compare do
  $LOAD_PATH.unshift(File.join(__dir__, 'lib'))
  require 'traveller_rpg/careers'
  require 'traveller_rpg/generator'

  include TravellerRPG

  def const_get(class_name, const_name)
    TravellerRPG.const_get(class_name).const_get(const_name)
  end

  char = Generator.character
  scalars = %w{ADVANCED_EDUCATION AGE_PENALTY}
  hashes = %w{QUALIFICATION}
  arrays = %w{PERSONAL_SKILLS SERVICE_SKILLS ADVANCED_SKILLS OFFICER_SKILLS
              CREDITS}
  complex = %w{BENEFITS OFFICER_RANKS SPECIALIST}
  %w{Army Marines Navy}.each { |cname|
    cnamex = cname + 'x'
    (scalars + arrays + hashes).each { |const_name|
      if const_get(cname, const_name) != const_get(cnamex, const_name)
        warn "#{cname}::#{const_name}"
      end
    }
    complex.each { |const_name|
      if const_get(cname, const_name) != const_get(cnamex, const_name)
        warn "#{cname}::#{const_name}"
        old = const_get(cnamex, const_name)
        new = const_get(cname, const_name)
        case old
        when Hash
          warn "mismatch: #{old.class} #{new.class}" unless new.is_a?(Hash)
          if old.size != new.size
            warn "size mismatch: #{old.size} #{new.size}"
          end
          old.each { |k, v|
            if old[k] != new[k]
              warn "mismatched values for #{k}"
              if v.is_a?(Hash)
                v.each { |kk, vv|
                  if vv != new[k][kk]
                    warn "mismatched values for #{kk}"
                  end
                  if vv.is_a?(Hash)
                    vv.each { |kkk, vvv|
                      if vvv != new[k][kk][kkk]
                        warn "mismatched values for #{kkk}"
                      end
                    }
                  else
                    warn "#{kk}: #{vv.class} #{new[k][kk].class}"
                  end
                }
              else
                warn "#{v.class} #{new[k].class}"
              end
            end
          }
        when Array
          warn "ARRAY!"
        else
          warn old.class.name
        end
      end
    }
  }
end

task :naval_officer do
  $LOAD_PATH.unshift(File.join(__dir__, 'lib'))
  require 'traveller_rpg/careers'
  require 'traveller_rpg/generator'

  include TravellerRPG

  char = Generator.character
  char.stats.education = 12
  char.stats.social_status = 12

  career = Navy.new(char)
  career.activate
  career.advancement_roll while !career.officer?
  puts char.report
  4.times { career.run_term if career.active? }
  puts char.report
  career.muster_out
  puts char.report
  puts career.report
end
