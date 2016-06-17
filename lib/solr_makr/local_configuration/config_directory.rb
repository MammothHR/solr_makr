module SolrMakr
  module LocalConfiguration
    class ConfigDirectory
      include LocalConfiguration::Helper
      include SolrMakr::WrapsDirectory

      attr_lazy_reader :path do
        local_configuration.join('configsets')
      end

      # @return [SolrMakr::Configset::Directory]
      def [](name)
        SolrMakr::Configsets::Directory.new(path: path.join(name))
      end
    end
  end
end
