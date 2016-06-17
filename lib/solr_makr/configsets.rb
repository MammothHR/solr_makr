module SolrMakr
  module Configsets
    extend ActiveSupport::Autoload

    eager_autoload do
      autoload :Directory
      autoload :GetNodes
      autoload :InstallDefault
      autoload :LookupDependentCollections
      autoload :Node
      autoload :PushToZookeeper
      autoload :Remote
    end
  end
end
