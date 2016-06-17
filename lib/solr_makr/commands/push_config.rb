module SolrMakr
  module Commands
    class PushConfig < ActiveInteraction::Base
      include AbstractCommand

      string :name,       description: 'the name of the config in zookeeper'
      string :configset,  description: 'the name of the local configset'

      boolean :reload,    description: 'Whether to reload every collection that depends', default: true

      attr_reader :remote

      def execute
        configset_directory = fetch_configset(configset)

        compose_buffer SolrMakr::Configsets::PushToZookeeper, name: name, directory: configset_directory

        buffer.ok "Pushed configuration named `#{name}` to zookeeper."

        @remote = SolrMakr::Configsets::Remote.new name: name

        if reload
          remote.dependent_collections.each do |collection|
            response = solr_client.reload name: collection

            if response.success?
              buffer.ok "Reloaded collection: `#{collection}`"
            else
              buffer.failure "Couldn't reload collection: `#{collection}`: #{response.failure}"
            end
          end
        end
      end
    end
  end
end
