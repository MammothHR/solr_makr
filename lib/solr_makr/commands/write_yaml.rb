module SolrMakr
  module Commands
    class WriteYaml
      include Shared

      config.acts_on_single_core = true

      def run
        options.default log_level: 'WARNING', env: 'production'

        config = build_config

        say config.to_yaml
      end

      # @return [{String => {String => {String => Object}}}]
      def build_config
        {
          options.env => {
            "solr" => {
              "hostname"  => solr_host,
              "port"      => solr_port,
              "log_level" => options.log_level,
              "path"      => "/solr/#{core.name}"
            }
          }
        }
      end
    end
  end
end
