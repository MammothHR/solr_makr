module SolrMakr
  module Commands
    class ListCores
      include Shared

      def run
        say "Listing core(s)."

        cores = solr_config.solr_status

        cores.each do |core|
          say sprintf(" * %s -- %d document(s) / %s", core.name, core.documents, core.size)
        end
      end
    end
  end
end
