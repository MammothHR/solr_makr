module SolrMakr
  module SolrAPI
    extend ActiveSupport::Autoload

    autoload :Client
    autoload :ClientMacros
    autoload :RequestParams
    autoload :Response
    autoload :ClusterResponse
    autoload :ListResponse
  end
end
