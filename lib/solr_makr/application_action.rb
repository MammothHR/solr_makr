module SolrMakr
  class ApplicationAction
    include Virtus.model strict: true

    attribute :name,                String
    attribute :command_name,        String,   default: :default_command_name
    attribute :description,         String,   default: ''
    attribute :requires_name,       Boolean,  default: false
    attribute :multiple_names,      Boolean,  default: false
    attribute :required_options,    Set,      default: proc { Set.new }
    attribute :specifies_configset, Boolean,  default: false
    attribute :interaction,         String,   default: :derive_default_interaction

    delegate :configuration, to: SolrMakr

    # @return [SolrMakr::Commands::Buffer]
    def execute(args, options)
      buffer    = SolrMakr::Commands::Buffer.new

      execution = SolrMakr::Commands::Execute.run action: self, command_args: args, command_options: options

      buffer.import execution.buffer

      unless execution.valid?
        execution.errors.full_messages.each do |error|
          buffer.error error
        end
      end

      return buffer
    end

    def configure(&block)
      initial_configuration

      yield Configurator.new(self) if block_given?

      return self
    end

    # @param [Commander::Command] command
    # @return [void]
    def setup_command!(command)
      command.syntax = "#{SolrMakr::BIN_NAME} #{command_name}"

      if description.present?
        command.description = description
      end

      add_options_to! command

      format_command! command

      command.when_called self, :execute
    end

    def requires?(option_name)
      option_mapping[option_name].try(:required?)
    end

    # @api private
    # @param [<String>] args
    # @param [Commander::Command::Options] options
    # @return [void]
    def set_default_options!(args, options)
      option_mapping.each do |option|
        option.set_default!(args, options)
      end

      if default_options_formatter.respond_to?(:call)
        instance_exec(args, options, &default_options_formatter)
      end

      return nil
    end

    # @api private
    # @param [Commander::Command] command
    # @return [void]
    def format_command!(command)
      if command_formatter.respond_to?(:call)
        command_formatter.call(command)
      end

      return nil
    end

    # @!attribute [r] interaction_klass
    # @return [Class]
    attr_lazy_reader :interaction_klass do
      "SolrMakr::Commands::#{interaction}".constantize
    end

    # @!attribute [rw] default_options_formatter
    # @api private
    # @return [Proc]
    attr_accessor :default_options_formatter

    # @!attribute [rw] command_formatter
    # @api private
    # @return [Proc]
    attr_accessor :command_formatter

    attr_lazy_reader :option_mapping do
      SolrMakr::OptionMapping.new
    end

    # @param [Symbol] name
    # @param [Hash] attributes
    # @yieldparam [SolrMakr::OptionDefinition] option
    # @yieldreturn [void]
    def add_option!(name, **attributes, &configurator)
      attributes[:name] = name

      option = SolrMakr::OptionDefinition.new(attributes)

      yield option if block_given?

      option_mapping << option

      return nil
    end

    # @api private
    # @return [String]
    def derive_default_interaction
      name.to_s.classify
    end

    # @param [Commander::Command] command
    # @return [void]
    def add_options_to!(command)
      option_mapping.add_to_command! command
    end

    # @api private
    # @return [String]
    def default_command_name
      name.to_s.gsub(/_collections?\z/, '').humanize.downcase
    end

    # @!attribute [r] initial_configuration
    # @return [nil]
    attr_lazy_reader :initial_configuration do
      if requires_name?
        add_option! :name, short_name: 'n', description: 'Name of the collection', type: String, required: true
      end

      if specifies_configset?
        add_option! :configset, value_name: 'NAME', description: 'Name of the configset', type: String, required: true do |c|
          c.default_value = proc { SolrMakr.configuration.default_configset }
        end
      end
    end

    # @api private
    class Configurator
      def initialize(action)
        @action = action
      end

      def description(new_description)
        @action.description = new_description.to_s
      end

      def format_command(&formatter)
        @action.command_formatter = formatter
      end

      def default_options(&formatter)
        @action.default_options_formatter = formatter
      end

      def option(name, **attributes, &configurator)
        @action.add_option!(name, **attributes, &configurator)
      end

      private
      attr_reader :action
    end
  end
end
