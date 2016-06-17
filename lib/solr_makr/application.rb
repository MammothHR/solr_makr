module SolrMakr
  class Application
    include Commander::Methods

    # @param [IO, File, #write] output
    def initialize(output: STDOUT)
      @output       = output

      @exit_status  = 0
    end

    attr_reader :output
    attr_reader :exit_status

    delegate :configuration, to: SolrMakr

    def run
      program :name,            SolrMakr::BIN_NAME
      program :version,         SolrMakr::VERSION
      program :description,     'Create and manage solr collections via CLI'
      program :help,            'Author', 'Alexa Grey <alexag@hranswerlink.com>'

      default_command :help

      global_option '-Z', '--zookeeper HOST', String,   "Zookeeper host(s) [default: #{configuration.zookeeper}]"
      global_option '-p', '--solr-port PORT', Integer,  "Port solr is running on [default: #{configuration.solr_port}]"
      global_option '-H', '--solr-host HOST', String,   "Solr Host [default: #{configuration.solr_host}]"
      global_option '-V', '--verbose',                  "Show verbose output."

      ApplicationDispatch.generate_commands! self

      run!.tap do |buffer|
        if buffer.kind_of?(SolrMakr::Commands::Buffer)
          output.write buffer.to_s

          @exit_status = buffer.exit_status
        end
      end
    end
  end
end
