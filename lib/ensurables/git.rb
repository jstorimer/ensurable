require 'open3'

module Ensurable
  class Git
    def installed?
      Open3.popen3('git --version') { |stdin, stdout, stderr|
        true if stderr.read.empty?
      }
    end
  end
end
