module SolrMakr
  module SolrAPI
    class ClusterResponse < Response
      # @!attribute [r] collections
      # @return [ActiveSupport::HashWithIndifferentAccess]
      attr_lazy_reader :collections do
        dig(:cluster, :collections) || {}.with_indifferent_access
      end

      def each_collection
        return enum_for(__method__) unless block_given?

        collections = dig(:cluster, :collections)

        collections.each do |(key, info)|
          yield key, info
        end
      end
    end
  end
end
