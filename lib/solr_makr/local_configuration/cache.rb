module SolrMakr
  module LocalConfiguration
    class Cache
      include LocalConfiguration::Helper
      include SolrMakr::WrapsDirectory

      attr_lazy_reader :path do
        local_configuration.join('cache.lmdb')
      end

      attr_lazy_reader :managed_db do
        client.database('managed', create: true)
      end

      # @api private
      attr_lazy_reader :client do
        LMDB.new(path)
      end
    end
  end
end
