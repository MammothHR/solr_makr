module SolrMakr
  module Configsets
    class PushToZookeeper < ActiveInteraction::Base
      string :name, description: 'Name of the configset (same as collection name)'

      object :directory, class: 'SolrMakr::Configsets::Directory', default: proc { SolrMakr::LocalConfiguration.default_configset }

      # @return [void]
      def execute
        SolrMakr.with_zookeeper do |client|
          directory.nodes.each do |node|
            client.mkdir_p node.full_name(prefix: "/configs/#{name}"),
              data: node.content, persistent: true
          end
        end
      end
    end
  end
end
