Gem::Specification.new do |s|
  s.name = 'traveller_rpg'
  s.summary = 'Automating portions of Traveller RPG'
  s.description = 'Mostly based on Traveller SRD'
  s.authors = ["Rick Hull"]
  s.homepage = 'https://github.com/rickhull/traveller_rpg'
  s.license = 'GPL'
  s.files = [
    'traveller_rpg.gemspec',
    'VERISON',
    'Rakefile',
    'README.md',
    'lib/traveller_rpg.rb',
    'lib/traveller_rpg/career_path.rb',
    'lib/traveller_rpg/career.rb',
    'lib/traveller_rpg/careers.rb',
    'lib/traveller_rpg/character.rb',
    'lib/traveller_rpg/data.rb',
    'lib/traveller_rpg/generator.rb',
    'lib/traveller_rpg/homeworld.rb',
    'lib/traveller_rpg/.rb',
    'lib/traveller_rpg/.rb',
    'bin/chargen',
  ]
  s.executables = ['chargen']
  s.add_development_dependency 'buildar', '~> 3'
  s.add_development_dependency 'minitest', '~> 5'
  s.required_ruby_version = '~> 2'

  s.version = File.read(File.join(__dir__, 'VERSION')).chomp
end
