require 'open3'

module Ensurable
  class Git
    def installed?
      git do |_, _, stderr|
        true if stderr.read.empty?
      end
    end

    def version
      git do |_, stdout, stderr|
        return nil unless stderr.read.empty?
        stdout.read.match(/[\d\.]+/)[0]
      end
    end

    private
    def git
      Open3.popen3('git --version') { |*blockargs|
        yield *blockargs
      }
    end
  end
end
