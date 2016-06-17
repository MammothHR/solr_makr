module SolrMakr
  module Commands
    class FetchCollectionList < ActiveInteraction::Base
      include AbstractCommand

      def execute
        response = solr_client.list

        collections = response.array(:collections).map do |name|
          SolrMakr::Collection.new name: name
        end

        buffer.print default_table(collection: collections, headings: %w[Collection Managed?], if_blank: 'No collections.')
      end
    end
  end
end
