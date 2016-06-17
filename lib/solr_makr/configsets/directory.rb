module SolrMakr
  module Configsets
    class Directory
      include Virtus.value_object strict: true
      include SolrMakr::WrapsDirectory
      include SolrMakr::Utility

      values do
        attribute :path, Pathlike
        attribute :name, String, writer: :private, lazy: true, default: :default_name
      end

      # @return [<SolrMakr::Configsets::Node>]
      def nodes
        SolrMakr::Configsets::GetNodes.run! root: path
      end

      def default_name
        path.basename.to_s
      end

      # @return [Pathname, nil]
      attr_lazy_reader :node_path do
        path_to_configset(path)
      end

      def node_path?
        node_path.present? && node_path.try(:exist?)
      end
    end
  end
end
