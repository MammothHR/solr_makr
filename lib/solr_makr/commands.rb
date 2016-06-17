module SolrMakr
  # @api private
  module Commands
    extend ActiveSupport::Autoload

    eager_autoload do
      autoload :AbstractCommand
      autoload :Buffer
      autoload :CreateCollection
      autoload :DeleteCollection
      autoload :Execute
      autoload :FetchCollectionList
      autoload :PushConfig
      autoload :ReloadCollection
      autoload :SetUpLocalConfiguration
      autoload :WriteYaml
    end
  end
end
