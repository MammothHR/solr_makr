module SolrMakr
  module Configsets
    class LookupDependentCollections < ActiveInteraction::Base
      include SolrMakr::Commands::AbstractCommand

      string :name, description: 'Name in zookeeper'

      # @return [<String>]
      def execute
        cluster_status      = solr_client.cluster_status

        cluster_collections = cluster_status.dig(:cluster, :collections)

        cluster_collections.each_with_object([]) do |(key, info), keys|
          keys << key if info[:configName] == name
        end
      end
    end
  end
end
