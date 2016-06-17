module SolrMakr
  class Configuration
    include Virtus.model strict: true
    include ActiveSupport::Configurable
    include SolrMakr::Utility

    LOOKUP_DEFAULT = ->(instance, attribute) { instance.lookup_default_for(attribute.name) }

    config.default_default_configset  = 'default'
    config.default_solr_path          = 'solr'
    config.default_solr_host          = 'localhost'
    config.default_solr_port          = 8983
    config.default_zookeeper          = 'localhost:2181'

    with_options default: LOOKUP_DEFAULT do
      attribute :default_configset, String
      attribute :solr_host, String
      attribute :solr_path, String
      attribute :solr_port, Integer
      attribute :zookeeper, String
    end

    def solr_uri
      "#{solr_host}:#{solr_port}/#{solr_path}"
    end

    def to_table
      hash_to_table attributes, width: false
    end

    # @api private
    def lookup_default_for(attribute_name)
      config[:"default_#{attribute_name}"]
    end

    # @yieldparam [ZK::Client::Threaded] zookeeper
    # @yieldreturn [void]
    # @return [void]
    def with_zookeeper(&block)
      ZK.open(zookeeper) do |client|
        yield client if block_given?
      end
    end
  end
end
