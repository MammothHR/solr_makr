module SolrMakr
  class SetGlobalOptions < ActiveInteraction::Base
    with_options default: nil do
      string  :solr_host,   strip: true
      string  :solr_path,   strip: true
      integer :solr_port

      string  :zookeeper,   strip: true
    end

    validates_numericality_of :solr_port, integer_only: true,
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: 65535,
      message: 'must be a valid port',
      allow_nil: true

    def execute
      inputs.each do |(setting, value)|
        SolrMakr.configuration[setting] = value if given?(setting)
      end
    end
  end
end
