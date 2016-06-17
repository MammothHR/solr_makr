module SolrMakr
  module Commands
    class WriteYaml < ActiveInteraction::Base
      include AbstractCommand

      STDOUT_OUTPUTS = [?-, nil, 'stdout']

      string :name,         description: 'Collection name'
      string :output,       description: 'File to output', default: nil
      string :environment,  default: 'production'
      string :log_level,    default: 'WARNING'

      def execute
        if output_to_stdout?
          buffer.write sunspot_configuration.to_yaml
        else
          File.open(output, 'w') do |f|
            YAML.dump sunspot_configuration, f
          end

          buffer.ok "Wrote configuration to #{output}"
        end
      end

      def output_to_stdout?
        if given?(:output)
          output.in?(STDOUT_OUTPUTS)
        else
          true
        end
      end

      # @!attribute [r] sunspot_configuration
      # @return [SolrMakr::SunspotConfiguration]
      attr_lazy_reader :sunspot_configuration do
        SolrMakr::SunspotConfiguration.new collection: name, environment: environment, log_level: log_level
      end
    end
  end
end
