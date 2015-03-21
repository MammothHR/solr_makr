module SolrMakr
  module Commands
    module Shared
      extend ActiveSupport::Concern

      included do
        include ActiveSupport::Configurable

        config.core_name_index = 0
      end

      delegate :name, allow_nil: true, to: :core, prefix: true

      # @!attribute [r] solr_config
      # @return [SolrMakr::SolrConfiguration]
      attr_reader :solr_config

      # @!attribute [r] args
      # @return [<String>]
      attr_reader :args

      # @!attribute [r] options
      # @return [Struct]
      attr_reader :options

      delegate :home, :host, :port, prefix: :solr, to: :solr_config

      alias_method :port, :solr_port

      # @abstract
      # @return [void]
      def run
        raise NotImplementedError, "Must implement #run"
      end

      # @return [void]
      def run!(args, options)
        @args     = args
        @options  = options

        options.default shared_options

        solr_config.home = options.solr_home
        solr_config.host = options.solr_host
        solr_config.port = options.solr_port

        run
      end

      # @!attribute [r] solr_config
      # @return [SolrMakr::SolrConfiguration]
      attr_lazy_reader :solr_config do
        SolrMakr::SolrConfiguration.new
      end

      # @!attribute [r] core
      # @return [SolrMakr::Core]
      attr_lazy_reader :core do
        core_name = args[config.core_name_index]

        if core_name.present? || config.acts_on_single_core
          solr_config.core(name: core_name)
        end
      end

      def with_message(message, &block)
        retval = yield

        if retval != false && options.verbose
          say message
        end
      end

      private
      def shared_options
        {
          solr_home: solr_home,
          solr_host: solr_host,
          solr_port: solr_port
        }
      end
    end
  end
end
