module SolrMakr
  module Commands
    class ReloadCollection < ActiveInteraction::Base
      include AbstractCommand

      string :name, description: 'name of the collection to reload'

      def execute
        expect_success! solr_client.reload(name: name), success_message: "Reloaded collection: `#{name}`"
      end
    end
  end
end
