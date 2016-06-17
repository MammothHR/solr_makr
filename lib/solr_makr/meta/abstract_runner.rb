module SolrMakr
  module AbstractRunner
    extend ActiveSupport::Concern
    include ActiveSupport::Callbacks
    include ActiveSupport::Configurable
    include SolrMakr::Utility

    included do
      config.command_mapping = {}.with_indifferent_access

      config_accessor :command_mapping
    end

    class_methods do
      # @param [SolrMakr::Application]
      # @return [void]
      def generate_commands!(application)
        command_mapping.values.each do |action|
          application.command action.command_name do |command|
            action.setup_command! command
          end
        end
      end

      # @param [<String>] args
      # @param [Commander::Command::Options] options
      def action!(name, **options, &method_body)
        options[:name] = name

        action = ApplicationAction.new(options).configure(&method_body)

        command_mapping[name] = action
      end
    end
  end
end
