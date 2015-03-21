module SolrMakr
  module Commands
    class CreateCore
      include Shared

      config.acts_on_single_core = true

      def run
        with_message "initializing configuration" do
          core.initialize_configuration!
        end

        with_message "registering new core with solr" do
          core.register_with_solr!
        end

        say "Created core: #{core_name}"
      end
    end
  end
end
