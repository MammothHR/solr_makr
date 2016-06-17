module SolrMakr
  class SunspotConfiguration
    include Virtus.value_object strict: true
    include ActiveSupport::Configurable
    include SolrMakr::HasSolrAttributes

    config_accessor :default_environment, :default_log_level

    config.default_environment  = 'production'
    config.default_log_level    = 'WARNING'

    values do
      attribute :collection,  String,   lazy: true
      attribute :environment, String,   default: :default_environment
      attribute :log_level,   String,   default: :default_log_level

      attribute :hostname,    String,   default: :solr_host
      attribute :port,        Integer,  default: :solr_port
      attribute :path_prefix, String,   default: :solr_path
      attribute :path,        String,   lazy: true, writer: :private, default: :generate_path
    end

    attr_lazy_reader :configuration do
      build_config
    end

    # @return [String]
    def to_yaml(options = {})
      YAML.quick_emit self.object_id, options do |out|
        out.represent_map nil, configuration.to_hash
      end
    end

    # @api private
    # @return [ActiveSupport::HashWithIndifferentAccess]
    def build_config
      {}.tap do |hsh|
        hsh[environment] = {}.tap do |inner_hsh|
          inner_hsh[:solr] = attributes.slice(:hostname, :port, :log_level, :path)
        end
      end.with_indifferent_access
    end

    # @return [String]
    def generate_path
      File.join('/', path_prefix, collection)
    end
  end
end
