module SolrMakr
  module SolrAPI
    # @api private
    module ClientMacros
      extend ActiveSupport::Concern

      class_methods do
        # Generate a method to connect with the solr collections API.
        #
        # @param [String] name a ruby-safe name for the generated method
        # @param [String] action the name of the action on in the solr API, all upper-case
        # @param [:get, :post, :put, :delete] method the HTTP verb
        # @param [Boolean] requires_name whether the `action` requires a collection name to be passed.
        #   Cluster-level actions, like `list` and `cluster_status`, do not.
        # @param [Class, String, Symbol] response_klass
        # @yield Allows the method to be further customized by formatting params passed to the
        #   API based on options provided to the generated method.
        # @yieldparam [SolrMakr::SolrRequestParams] params
        # @yieldparam [Hash] options
        # @yieldreturn [void]
        # @return [void]
        # @!macro [attach] define_collection_action!
        #   @!method $1(options = {})
        #     @param [Hash] options
        #     @option options [String] :name the name of the collection
        #     @return [SolrMakr::SolrAPI::Response]
        def define_collection_action!(name, action: name.to_s.upcase, method: :get, requires_name: false, response_klass: SolrMakr::SolrAPI::Response, &option_parser)
          response_klass = parse_response_klass(response_klass)

          define_method(name) do |**options|
            params = SolrMakr::SolrAPI::RequestParams.new action: action

            if requires_name
              unless options.key?(:name) && options[:name].present?
                raise ArgumentError, "missing required option: #{name}"
              else
                params[:name] = options[:name]
              end
            end

            if option_parser.respond_to?(:call)
              option_parser.call(params, options)
            end

            response = self.class.__send__(method, '/admin/collections', params)

            response_klass.new(response)
          end
        end

        # @param [Class, String, Symbol] klass
        # @return [Class]
        def parse_response_klass(klass)
          return klass if klass.kind_of?(Class)

          "SolrMakr::SolrAPI::#{klass}".constantize
        end
      end
    end
  end
end
