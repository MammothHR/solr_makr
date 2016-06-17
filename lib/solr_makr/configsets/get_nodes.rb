module SolrMakr
  module Configsets
    class GetNodes < ActiveInteraction::Base
      include SolrMakr::Utility

      object :root,
        class:        'Pathname',
        description:  'The root of the configset',
        default: proc { SolrMakr.local_configuration.default_configset.path }

      validates_presence_of :conf_path, message: 'could not derive solr config path'

      validate :check_for_missing_nodes!

      # @return [<SolrMakr::Configsets::Node>]
      def execute
        SolrMakr::Configsets::Node.gather root: conf_path
      end

      attr_lazy_reader :conf_path do
        path_to_configset(root)
      end

      # @api private
      # @return [void]
      def check_for_missing_nodes!
        looks_like_a_valid_configset?(conf_path) do |name|
          errors.add :base, "missing required solr config file: #{name}"
        end
      end
    end
  end
end
