module SolrMakr
  module Commands
    class DeleteCollection < ActiveInteraction::Base
      include AbstractCommand

      string :name

      def execute
        expect_success! solr_client.delete(name: name), success_message: "Deleted collection: `#{name}`"
      end
    end
  end
end
