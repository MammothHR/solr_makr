module SolrMakr
  module SolrAPI
    # Wrapper around parameters passed to solr api requests.
    #
    # Solr requests are not really RESTful, and instead take the action
    # name in a parameter on the query string.
    class RequestParams
      # @param [String] action (see #action)
      def initialize(action:)
        @action = action
        @query  = {}.with_indifferent_access
        @params = {}.with_indifferent_access
      end

      # @!attribute [r] action
      # The name of the solr action, which is automatically applied to the
      # {#query query string parameters} when the request is made.
      # @return [String]
      attr_reader :action

      # @!attribute [r] params
      # @api private
      # @return [ActiveSupport::HashWithIndifferentAccess]
      attr_reader :params

      # @!attribute [r] query
      # @return [ActiveSupport::HashWithIndifferentAccess]
      attr_reader :query

      delegate :[], :[]=, to: :query

      # Set the body for the request.
      #
      # @param [String, #to_s]
      # @return [void]
      def body(request_body)
        @params[:body] = request_body
      end

      def to_h(options = nil)
        query[:action] = @action

        @params.to_h.merge(query: query)
      end

      alias_method :to_hash, :to_h
      alias_method :as_json, :to_h
    end
  end
end
