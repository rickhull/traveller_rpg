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
