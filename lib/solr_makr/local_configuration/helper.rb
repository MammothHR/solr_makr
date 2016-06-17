module SolrMakr
  module LocalConfiguration
    module Helper
      module_function

      def local_configuration
        LocalConfiguration.directory
      end

      def local_settings
        LocalConfiguration.settings
      end

      def create_local_directory_if_missing!
        local_configuration.create_if_missing!
      end
    end
  end
end
