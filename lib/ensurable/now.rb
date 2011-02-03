require 'ensurable'

module Ensurable
  module Now
    def self.now!
      dir = Dir.pwd
      path = dir + '/ensure.rb'
      if File.exist?(path)
        Ensurable.ensure(File.new(path))
      else
        Dir.chdir('..')
        now!
      end
    end
  end
end

Ensurable::Now.now!
