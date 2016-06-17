module SolrMakr
  module Commands
    module AbstractCommand
      extend ActiveSupport::Concern
      include SolrMakr::BufferInteraction
      include SolrMakr::Utility

      included do
        set_callback :validate, :after, :invalid_buffer_if_errors!

        object :buffer, class: 'SolrMakr::Commands::Buffer', default: proc { SolrMakr::Commands::Buffer.new }

        delegate :directory, :settings, :cache, to: :local_configuration, prefix: true
      end

      # @return [SolrMakr::Configsets::Directory]
      def fetch_configset(name)
        SolrMakr.local_configuration.configsets[name]
      end

      def local_configuration
        SolrMakr::LocalConfiguration
      end

      attr_lazy_reader :solr_client do
        SolrMakr::SolrAPI::Client.new
      end

      # @param [SolrMakr::SolrAPI::Response] response
      def expect_success!(response, success_message: nil, error_message: nil, halt_on_error: true, &on_failure)
        if response.success?
          if success_message.present?
            buffer.ok success_message
          end
        else
          errors.add '[solr]', response.failure

          buffer.exit_status = 1

          if error_message.present?
            buffer.logger.error error_message
          elsif block_given?
            yield response
          end

          throw :interrupt, response if halt_on_error
        end

        return response
      end

      private
      def invalid_buffer_if_errors!
        if buffer.success? && errors.any?
          buffer.exit_status = 1
        end
      end
    end
  end
end
