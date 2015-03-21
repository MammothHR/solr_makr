module SolrMakr
  module Commands
    class DestroyCore
      include Shared

      config.acts_on_single_core = true

      def run
        with_message "registering new core with solr" do
          core.unload_from_solr!(purge: options.purge)
        end

        say "Destroyed core: #{core_name}"
      end
    end
  end
end
