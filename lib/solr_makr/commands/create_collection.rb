module SolrMakr
  module Commands
    class CreateCollection < ActiveInteraction::Base
      include AbstractCommand

      string :name,         description: 'name of the collection'
      string :config_name,  description: 'the name to use in zookeeper',  default: nil
      string :configset,    description: 'local configset to base on',    default: proc { SolrMakr.configuration.default_configset }

      integer :number_of_shards,    default: 1
      integer :replication_factor,  default: 1
      integer :max_shards_per_node, default: 1

      def execute
        configset_directory = fetch_configset(configset)

        unless remote_configset_exists?
          buffer.print ". Zookeeper configuration `#{config_name}` does not exist... creating"

          compose_buffer SolrMakr::Configsets::PushToZookeeper, name: remote_configset_name, directory: configset_directory
        end

        expect_success! solr_client.create(params_for_create)

        buffer.ok "Created collection: #{name}"
      end

      # @api private
      # @return [Hash]
      def params_for_create
        {
          name:                 name,
          config_name:          remote_configset_name,
          number_of_shards:     number_of_shards,
          replication_factor:   replication_factor,
          max_shards_per_node:  max_shards_per_node
        }
      end

      # @!attribute [r] remote_configset_name
      # @return [String]
      attr_lazy_reader :remote_configset_name do
        config_name.presence || name
      end

      attr_lazy_reader :remote_configset do
        SolrMakr::Configsets::Remote.new name: remote_configset_name
      end

      attr_lazy_reader :remote_configset_exists do
        remote_configset.exists?
      end

      alias_method :remote_configset_exists?, :remote_configset_exists
    end
  end
end
