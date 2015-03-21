module SolrMakr
  # @api private
  class Pathlike < Virtus::Attribute
    # @param [String / Pathname] value
    # @return [Pathname]
    def coerce(value)
      Pathname.new value
    end
  end

  class SolrConfiguration
    include Virtus.model strict: true
    include SolrRequest

    DEFAULT_HOME  = '/opt/solr/jetty-solr/'
    DEFAULT_PORT  = 8983

    attribute :home, Pathlike, default: :default_home
    attribute :port, Integer, default: :default_port

    def initialize(env = ENV)
      @_env = env

      super()
    end

    def env
      @_env ||= ENV
    end

    def core(name: nil)
      Core.new name: name, config: self
    end

    def cores
      core_directory.children.each_with_object [] do |path, cores|
        cores << core(name: path.basename) if looks_like_core_directory?(path)
      end
    end

    # @return [String]
    def core_directory
      home.join 'solr'
    end

    # @return [<SolrMakr::CoreStatus>]
    def solr_status
      resp = solr_request solr_cores_url, params: { action: 'STATUS' }

      parsed = Nokogiri::XML(resp.body)

      statuses = parsed.at_css('lst[name="status"]').try(:children)

      return [] unless statuses.present?

      statuses.each_with_object [] do |status, list|
        created = SolrMakr::CoreStatus.from_xml status# rescue nil

        list << created if created.present?
      end
    end

    private
    def looks_like_core_directory?(path)
      path.join('data').exist?
    end

    def default_port
      Integer(env.fetch 'SOLR_PORT', DEFAULT_PORT)
    rescue ArgumentError
      DEFAULT_PORT
    end

    def default_home
      Pathname.new env.fetch 'SOLR_HOME', DEFAULT_HOME
    end
  end
end
