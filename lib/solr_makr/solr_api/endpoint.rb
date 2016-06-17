module SolrMakr
  module SolrAPI
    # @abstract
    class Endpoint
      include Virtus.model strict: true

      attribute :name, String
      attribute :path, String

      # @return [SolrMakr::SolrAPI::Response]
      def request(client:, method:, response_klass:, params:)
      end
    end
  end
end
