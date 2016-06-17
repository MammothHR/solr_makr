module SolrMakr
  module Configsets
    class Remote
      include Virtus.value_object strict: true

      values do
        attribute :name, String
      end

      attr_lazy_reader :path do
        "/configs/#{name}"
      end

      # @return [<String>]
      def dependent_collections
        SolrMakr::Configsets::LookupDependentCollections.run! name: name
      end

      def exists?
        SolrMakr.with_zookeeper do |client|
          client.get(path)
        end
      rescue ZK::Exceptions::NoNode
        false
      else
        true
      end
    end
  end
end
