module Ensurable
  class NotInstalled < StandardError; end
  class NotRunning < StandardError; end
  class MissingVersion < StandardError; end

  autoload :Git, 'ensurables/git'
  autoload :Redis, 'ensurables/redis'

  class << self

    # Ensures that the given programs are installed/running.
    #
    # @param [File] optional file to read defining the ensurables
    # @yield optional block to allow any ensurables to be required
    def ensure(file = nil, &bloc)
      abortables = []

      begin
        abortables << Rails.env
      rescue NameError, NoMethodError
      end
      abortables << ENV['RAILS_ENV']
      abortables << ENV['RACK_ENV']

      if abortables.any? {|a| a == 'production'}
        $stderr.puts("Ensurable gem is not meant for use in production, nooping.")
        return
      end

      if file
        instance_eval file.read
      else
        instance_eval &bloc
      end
    end

    # Ensures the the given program needs to be installed on the local system
    #
    # @param [String] prog the name of the program that should be installed. Requires that 
    #   the constant Ensurable::program exists and follows that API.
    # @raise [NotInstalled] raised when the given program is not installed on the local system
    def installed(prog, version_requirement = nil)
      # Would be nice to have a nicer fail mechanism if the constant doesn't exist
      klass = const_get(prog.capitalize)
      ensurable = klass.new

      raise NotInstalled.new("Looks like you don't have #{prog} installed.") unless ensurable.installed?

      return unless version_requirement
      ensurable_version = ensurable.version

      unless version_satisfied?(version_requirement, ensurable_version)
        raise MissingVersion.new("#{prog} version #{version_requirement} is required. You have #{ensurable_version}")
      end
    end

    # Ensures that the given program is running on the local system
    # @param [String] prog the name of the program that should be running. Requires that 
    #   the constant Ensurable::program exists and follows that API.
    # @raise [NotRunning] raised when the given program is not running on the local system
    def running(prog, version_requirement = nil)
      klass = const_get(prog.capitalize)
      ensurable = klass.new

      raise NotRunning.new("Looks like you don't have #{prog} running.") unless ensurable.running?

      return unless version_requirement
      ensurable_version = ensurable.version

      unless version_satisfied?(version_requirement, ensurable_version)
        raise MissingVersion.new("#{prog} version #{version_requirement} is required. You have #{ensurable_version}")
      end
    end

    private

    def version_satisfied?(version_requirement, ensurable_version)
      # piggyback off of Gem for now
      require 'rubygems/version'
      require 'rubygems/requirement'

      req = Gem::Requirement.create(version_requirement)
      ver = Gem::Version.create(ensurable_version)

      req.satisfied_by?(ver)
    end
  end
end
