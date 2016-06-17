module SolrMakr
  module SolrAPI
    class Client
      include HTTParty
      include SolrMakr::SolrAPI::ClientMacros

      #logger ::Logger.new(STDOUT)

      # Specify the return type should be JSON, not XML.
      default_params wt: 'json'

      def initialize
        self.class.base_uri SolrMakr.configuration.solr_uri
      end

      define_collection_action! :cluster_status, action: 'CLUSTERSTATUS'

      define_collection_action! :create, requires_name: true do |params, options|
        params[:numShards]              = options.fetch(:number_of_shards, 1)
        params[:replicationFactor]      = options.fetch(:replication_factor, 1)
        params[:maxShardsPerNode]       = options.fetch(:max_shards_per_node, 1)
        params['collection.configName'] = options.fetch(:config_name, options.fetch(:name))
      end

      define_collection_action! :delete, requires_name: true

      define_collection_action! :list

      define_collection_action! :reload, requires_name: true
    end
  end
end
