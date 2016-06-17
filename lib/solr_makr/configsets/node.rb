module SolrMakr
  module Configsets
    class Node
      include Virtus.value_object strict: true

      values do
        attribute :root,    SolrMakr::Pathlike
        attribute :path,    SolrMakr::Pathlike
        attribute :name,    String, writer: :private, default: :default_name
      end

      # @return [String]
      def full_name(prefix: '')
        File.join(prefix, name)
      end

      # @!attribute [r] content
      # @return [String]
      attr_lazy_reader :content do
        path.read
      end

      def readable?
        content rescue false
      end

      private
      # Derive the name of the node by removing the root path component.
      #
      # @return [String]
      def default_name
        path.relative_path_from(root).to_s
      end

      class << self
        # @param [Pathname] root
        # @return [<SolrMakr::Configsets::Node>]
        def gather(root:)
          [].tap do |nodes|
            root.find do |path|
              unless path.directory?
                nodes << SolrMakr::Configsets::Node.new(root: root, path: path)
              else
                if path.basename.to_s[0] == '.'
                  Find.prune
                else
                  next
                end
              end
            end
          end
        end
      end
    end
  end
end
