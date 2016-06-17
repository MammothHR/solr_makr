module SolrMakr
  class ApplicationDispatch
    include SolrMakr::AbstractRunner

    action! :setup, interaction: :SetUpLocalConfiguration do |action|
      action.description 'Setup the config directory for solr-makr.'
    end

    action! :create_collection, requires_name: true, specifies_configset: true do |action|
      action.description 'Create a new collection'

      action.option :config_name, type: String, short_name: 'C' do |o|
        o.description     = "Key of the configset in zookeeper"
        o.default_value   = :name
        o.value_name      = 'NAME'
      end

      action.option :number_of_shards, type: Integer do |o|
        o.description = 'Number of shards for this collection'
        o.value_name  = 'SHARDS'
        o.default_value = 1
      end

      action.option :replication_factor, type: Integer do |o|
        o.description   = 'How many replicas to create'
        o.value_name    = 'FACTOR'
        o.default_value = 1
      end

      action.option :max_shards_per_node, type: Integer do |o|
        o.description   = 'How many shards per solr node'
        o.value_name    = 'MAX'
        o.default_value = 1
      end
    end

    action! :delete_collection, requires_name: true do |action|
      action.description 'Delete a collection'
    end

    action! :reload_collection, requires_name: true do |action|
      action.description 'Reload a collection'
    end

    action! :fetch_collection_list, command_name: 'list' do |action|
      action.description 'List all collections'
    end

    action! :push_config, requires_name: true, specifies_configset: true do |action|
      action.description 'Push a new configuration to zookeeper'

      action.option :reload do |o|
        o.description   = 'Whether to reload all configurations that use this when updating'
        o.default_value = false
      end
    end

    action! :write_yaml, command_name: 'yaml', requires_name: true do |action|
      action.description 'Generate a YAML configuration suitable for use with sunspot'

      action.option :config_name, type: String, short_name: 'C' do |o|
        o.description     = "Key of the configset in zookeeper"
        o.default_value   = :name
        o.value_name      = 'NAME'
      end

      action.option :environment, type: String, short_name: 'e' do |o|
        o.description   = 'Rails environment'
        o.default_value = proc { SunspotConfiguration.default_environment }
        o.value_name    = 'ENV'
      end

      action.option :output, type: String, short_name: 'o' do |o|
        o.description   = 'Write configuration to file'
        o.value_name    = 'FILE'
      end

      action.option :log_level, type: String do |o|
        o.description   = "Sunspot's log level"
        o.default_value = proc { SunspotConfiguration.default_log_level }
        o.value_name    = 'LEVEL'
      end
    end
  end
end
