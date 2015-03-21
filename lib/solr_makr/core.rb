module SolrMakr
  # @api private
  class CoreName < Virtus::Attribute
    NAME_FORMAT = /\A[\w\-]+\z/i

    # @param [String] value
    # @return [String]
    def coerce(value)
      value = value.to_s

      raise 'Invalid Core Name' unless value.present?
      raise 'Invalid Core Name Format' unless value =~ NAME_FORMAT

      return value
    end
  end

  class Core
    include Virtus.model strict: true
    include SolrRequest

    CONF_PATH   = 'conf'

    CONF_FILES = %w[schema.xml solrconfig.xml]

    attribute :name, CoreName
    attribute :config, SolrConfiguration

    delegate :core_directory, :host, :port, to: :config
    delegate :exist?, to: :instance_dir

    # @return [Pathname]
    def instance_dir
      core_directory.join name
    end

    def conf_dir
      instance_dir.join(CONF_PATH)
    end

    def initialize_configuration!
      conf_dir.mkpath

      CONF_FILES.each do |conf_file|
        path = conf_dir.join(conf_file)

        path.write(SolrMakr.template(conf_file))
      end
    end

    # @return [void]
    def register_with_solr!
      params = {
        action:         'CREATE',
        name:           name,
        persist:        'true',
        instanceDir:    instance_dir.to_s,
        loadOnStartup:  'true',
        config:         'solrconfig.xml',
        schema:         'schema.xml'
      }

      params[:'collection.configName'] = 'core01'

      solr_request solr_cores_url, params: params
    end

    def reload!
      params = {
        action: 'RELOAD',
        core:   name
      }

      solr_request solr_cores_url, params: params
    end

    def unload_from_solr!(purge: false)
      params = {
        core:           name,
        action:         'UNLOAD',
        deleteIndex:    'true',
        deleteDataDir:  'true'
      }

      if purge
        say "Deleting entire instance dir!!!"
        params[:deleteInstanceDir] = 'true'
      end

      solr_request solr_cores_url, params: params
    end

  end
end
