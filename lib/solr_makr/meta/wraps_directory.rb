module SolrMakr
  module WrapsDirectory
    extend ActiveSupport::Concern

    include SolrMakr::WrapsPath

    included do
      delegate :join, to: :path
    end

    # @return [Boolean] if created
    def create_if_missing!
      unless exists?
        path.mkpath

        true
      else
        false
      end
    end

    # @return [<Pathname>]
    def subdirectories
      path.children.select(&:directory?)
    end
  end
end
