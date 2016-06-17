module SolrMakr
  module LocalConfiguration
    extend ActiveSupport::Autoload

    eager_autoload do
      autoload :Cache
      autoload :ConfigDirectory
      autoload :Directory
      autoload :Helper
      autoload :Settings

      autoload :SaveSettings
    end

    class << self
      # @return [SolrMakr::Configsets::Directory]
      def default_configset
        configsets[SolrMakr.configuration.default_configset]
      end

      # @!attribute [r] cache
      attr_lazy_reader :cache do
        SolrMakr::LocalConfiguration::Cache.new
      end

      # @!attribute [r] configsets
      attr_lazy_reader :configsets do
        SolrMakr::LocalConfiguration::ConfigDirectory.new
      end

      # @!attribute [r] directory
      attr_lazy_reader :directory do
        SolrMakr::LocalConfiguration::Directory.new
      end

      # @!attribute [r] settings
      attr_lazy_reader :settings do
        SolrMakr::LocalConfiguration::Settings.new
      end
    end
  end
end
