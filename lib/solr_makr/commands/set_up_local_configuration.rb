module SolrMakr
  module Commands
    class SetUpLocalConfiguration < ActiveInteraction::Base
      include AbstractCommand

      def execute
        create_local_path! :directory
        create_local_path! :cache
        create_local_path! :configsets

        install_default_configset!

        buffer.ok "Set up local configuration directory."
      end

      def create_local_path!(key, description: nil)
        if local_configuration.__send__(key).create_if_missing!
          buffer.ok "Created #{local_configuration.__send__(key).path}"
        end
      end

      def install_default_configset!
        compose SolrMakr::Configsets::InstallDefault, directory: local_configuration.default_configset
      end
    end
  end
end
