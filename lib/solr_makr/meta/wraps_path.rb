module SolrMakr
  module WrapsPath
    extend ActiveSupport::Concern
    include ActiveSupport::Configurable

    included do
      delegate :exist?, to: :path
      alias_method :exists?, :exist?
    end

    # @!attribute [r] path
    # @return [Pathname]

    def inspect
      "#<#{self.class.name} :path => '#{path.to_s}'>"
    end
  end
end
