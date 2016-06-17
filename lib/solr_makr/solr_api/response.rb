module SolrMakr
  module SolrAPI
    class Response
      # @param [Hash] raw_response
      def initialize(raw_response = {})
        @raw_response = raw_response.with_indifferent_access
      end

      # @!attribute [r] raw_response
      # @return [ActiveSupport::HashWithIndifferentAccess]
      attr_reader :raw_response

      delegate :fetch, to: :raw_response

      # @param [<String, Symbol>] keys path to the desired array
      # @return [Array]
      def array(*keys)
        Array(dig(*keys))
      end

      # Dig into the response data by a given path.
      #
      # @param [<String, Symbol>] keys path to the desired value
      # @return [Object] if non-hashlike
      # @return [ActiveSupport::HashWithIndifferentAccess] if hash-like
      def dig(*keys)
        keys.reduce raw_response do |hsh, key|
          hsh[key] if hsh.respond_to?(:[])
        end
      end

      alias_method :[], :dig

      # @!attribute [r] response_header
      # @return [ActiveSupport::HashWithIndifferentAccess]
      attr_lazy_reader :response_header do
        dig :responseHeader
      end

      # @!attribute [r] failure
      # @return [String]
      attr_lazy_reader :failure do
        unless success?
          exception.fetch(:msg) or error.fetch(:msg) or 'unknown failure'
        end
      end

      attr_lazy_reader :error do
        fetch(:error, {})
      end

      attr_lazy_reader :exception do
        fetch(:exception, {})
      end

      def success?
        status == 0
      end

      attr_lazy_reader :status do
        response_header.fetch :status, 500
      end

      def to_s
        "#<#{self.class.name} #{JSON.pretty_generate(raw_response)}>"
      end
    end
  end
end
