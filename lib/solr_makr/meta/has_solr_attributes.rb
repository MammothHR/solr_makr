module SolrMakr
  module HasSolrAttributes
    extend ActiveSupport::Concern

    included do
      delegate :solr_host, :solr_path, :solr_port, to: :app_configuration
    end

    def app_configuration
      SolrMakr.configuration
    end
  end
end
