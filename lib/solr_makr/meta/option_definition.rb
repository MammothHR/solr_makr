module SolrMakr
  # @api private
  class OptionDefinition
    include Virtus.model

    attribute :name,          String
    attribute :short_name,    String,   default: nil
    attribute :long_name,     String,   default: :default_long_name
    attribute :value_name,    String,   default: ''
    attribute :type,          Object,   default: nil
    attribute :required,      Boolean,  default: false
    attribute :description,   String,   default: ''
    attribute :validator,     Proc,     default: nil
    attribute :default_value, Object,   default: nil

    # @param [Commander::Command] command
    # @return [void]
    def add_to_command!(command)
      command.option *commander_tuple
    end

    def has_default?
      !default_value.nil?
    end

    # @param [<String>] args
    # @param [Commander::Command::Options] options
    # @return [void]
    def set_default!(args, options)
      return unless has_default?

      case default_value
      when Proc
        options.default name => default_value.call
      when Symbol
        options.default name => options[default_value]
      else
        options.default name => default_value
      end

      return
    end

    # @param [Commander::Command::Options] options
    def valid_in?(options)
      if required?
        return options[name].present?
      end

      return true
    end

    # @api private
    # @return [String]
    def default_long_name
      name.dasherize
    end

    # @return [Array]
    def commander_tuple
      [].tap do |ary|
        ary << "-#{short_name}" if short_name.present?
        ary << long_name_with_value
        ary << type if type.present?
        ary << full_description if full_description.present?
      end
    end

    def long_name_with_value
      [].tap do |ary|
        ary << "--#{long_name}"

        unless type.blank?
          ary << ( value_name.presence || name.upcase )
        end
      end.join(' ')
    end

    # @api private
    attr_lazy_reader :full_description do
      [].tap do |ary|
        if required? && !has_default?
          ary << '[REQUIRED]'
        end

        if description.present?
          ary << description

          ary << "[default: #{evaluated_default_value}]" if has_default?
        end
      end.join(' ')
    end

    # @api private
    attr_lazy_reader :evaluated_default_value do
      if default_value.respond_to?(:call)
        default_value.call
      elsif default_value.kind_of?(Symbol)
        "provided #{default_value}"
      else
        default_value
      end
    end
  end
end
