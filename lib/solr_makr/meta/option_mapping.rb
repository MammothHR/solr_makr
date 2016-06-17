module SolrMakr
  # @api private
  class OptionMapping
    include Enumerable

    def initialize
      @_mapping = {}.with_indifferent_access
    end

    delegate :[], to: :@_mapping

    def <<(definition)
      raise TypeError, "not a definition" unless definition.kind_of?(SolrMakr::OptionDefinition)

      @_mapping[definition.name] = definition

      return self
    end

    def each
      return enum_for(:each) unless block_given?

      @_mapping.each_value do |definition|
        yield definition
      end
    end

    # @param [Commander::Command] command
    # @return [void]
    def add_to_command!(command)
      each do |definition|
        definition.add_to_command! command
      end

      return nil
    end
  end
end
