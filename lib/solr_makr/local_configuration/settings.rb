module SolrMakr
  module LocalConfiguration
    class Settings
      include LocalConfiguration::Helper
      include SolrMakr::WrapsPath

      attr_lazy_reader :path do
        local_configuration.join 'settings.toml'
      end

      # @!attribute [r] parsed
      # @return [ActiveSupport::HashWithIndifferentAccess]
      attr_lazy_accessor :parsed do
        parse_config_file
      end

      # @return [ActiveSupport::HashWithIndifferentAccess]
      def reparse!
        self.parsed = parse_config_file
      end

      # @return [void]
      def make_backup!
        return unless exists?

        backup_path = path.to_s.gsub(/\.toml$/, ".#{Time.now.utc.to_i}.toml")

        FileUtils.cp_r path.to_s, backup_path

        return nil
      end

      # @param [Hash] new_data
      # @return [void]
      def save!(new_data)
        create_local_directory_if_missing!
      end

      private
      # @return [ActiveSupport::HashWithIndifferentAccess]
      def parse_config_file
        begin
          TOML.load_file path.to_s
        rescue Errno::ENOENT => e
          {}
        end.with_indifferent_access
      end
    end
  end
end
