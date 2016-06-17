module SolrMakr
  module LocalConfiguration
    class Directory
      include SolrMakr::WrapsDirectory

      DEFAULT = ENV.fetch('SOLR_MAKR_HOME') do
        File.join(Dir.home, '.config', 'solr_makr')
      end

      # @!attribute [r] path
      # @return [Pathname]
      attr_lazy_reader :path do
        Pathname.new(DEFAULT)
      end
    end
  end
end
