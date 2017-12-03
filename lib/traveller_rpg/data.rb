module TravellerRPG
  module Data
    PATH = File.expand_path(File.join(__dir__, '..', '..', 'data'))
    raise "can't find #{PATH}" unless File.directory?(PATH)

    def self.files
      Dir[File.join(PATH, '*')]
    end

    def self.sample(filename)
      path = File.join(PATH, filename)
      raise "#{path} does not exist" unless File.exist?(path)
      if filename.match %r{\.txt\z}
        File.readlines(path).sample.chomp
      else
        raise "can't handle #{filename}"
      end
    end
  end
end
