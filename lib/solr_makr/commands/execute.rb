module SolrMakr
  module Commands
    # Execute an application command based on its configuration.
    class Execute < ActiveInteraction::Base
      include SolrMakr::BufferInteraction
      include SolrMakr::Utility

      object :action, class: 'SolrMakr::ApplicationAction'

      array :command_args, default: [] do
        string
      end

      object :command_options, class: 'Commander::Command::Options', default: proc { Commander::Command::Options.new }

      # @return [SolrMakr::Commands::Buffer]
      def execute
        set_global_options!

        set_default_options!

        validate_options!

        unless errors.any?
          compose_buffer action.interaction_klass, **raw_options
        end

        return buffer
      end

      attr_lazy_reader :verbose do
        command_options.verbose.present?
      end

      alias_method :verbose?, :verbose

      # Set global options for the environment.
      #
      # @return [void]
      def set_global_options!
        compose SolrMakr::SetGlobalOptions, raw_options
      end

      # Inherit default options for the action if any.
      #
      # @return [void]
      def set_default_options!
        action.set_default_options!(command_args, command_options)
      end

      # @return [void]
      def validate_options!
        action.option_mapping.each do |option|
          unless option.valid_in?(command_options)
            errors.add :base, "Missing required argument: #{option.long_name}"
          end
        end
      end

      # @api private
      # @return [Hash]
      def raw_options
        command_options.__hash__.symbolize_keys
      end
    end
  end
end
