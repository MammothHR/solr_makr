module SolrMakr
  module SolrAPI
    class ListResponse < Response
      # @return [<String>]
      attr_lazy_reader :collections do
        array(:collections)
      end

      # @yieldparam [String]
      def each_collection
        return enum_for(__method__) unless block_given?

        collections.each do |collection|
          yield collection
        end
      end
    end
  end
end
