module Ensurable
  class NotInstalled < StandardError; end
  class NotRunning < StandardError; end

  autoload :Git, 'ensurables/git'
  autoload :Redis, 'ensurables/redis'

  class << self

    # Ensures that the given programs are installed/running.
    #
    # @param [File] optional file to read defining the ensurables
    # @yield optional block to allow any ensurables to be required
    def ensure(file = nil, &bloc)
      abortables = []
      abortables << (defined?(Rails) && Rails.respond_to?(:env) && Rails.env)
      abortables << ENV['RAILS_ENV']
      abortables << ENV['RACK_ENV']

      abort('Ensurable is not meant for production use!') if abortables.any? {|a| a == 'production'}

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
    def installed(prog)
      # Would be nice to have a nicer fail mechanism if the constant doesn't exist
      klass = const_get(prog.capitalize)

      raise NotInstalled.new("Looks like you don't have #{prog} installed.") unless klass.new.installed?
    end

    # Ensures that the given program is running on the local system
    # @param [String] prog the name of the program that should be running. Requires that 
    #   the constant Ensurable::program exists and follows that API.
    # @raise [NotRunning] raised when the given program is not running on the local system
    def running(prog)
      klass = const_get(prog.capitalize)

      raise NotRunning.new("Looks like you don't have #{prog} running.") unless klass.new.running?
    end
  end
end
