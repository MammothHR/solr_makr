module SolrMakr
  class Application
    include Commander::Methods

    NAME = 'solr-makr'

    def run
      program :name, NAME
      program :version, SolrMakr::VERSION
      program :description, 'Create a solr core programmatically'
      program :help, 'Author', 'Alexa Grey <alexag@hranswerlink.com>'
      program :help_formatter, Commander::HelpFormatter::TerminalCompact

      default_command :help

      global_option '-d', '--solr-home DIR', 'Path to the solr home directory'
      global_option '-p', '--solr-port PORT', Integer, 'Port to use to communicate with the solr API'
      global_option '-V', '--verbose', 'Show verbose output.'

      command :create do |c|
        c.syntax      = "#{NAME} create NAME"

        c.description = "Create and register a solr core."

        c.when_called Commands::CreateCore, :run!
      end

      command :list do |c|
        c.syntax      = "#{NAME} list"

        c.description = "List installed solr cores."

        c.when_called Commands::ListCores, :run!
      end

      command :destroy do |c|
        c.syntax      = "#{NAME} destroy NAME"

        c.option '--purge', 'Purge the solr core\'s instance directory'

        c.description = "Unload and remove a solr core."

        c.when_called Commands::DestroyCore, :run!
      end

      run!
    end
  end
end