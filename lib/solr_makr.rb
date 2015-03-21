require "fileutils"
require "pathname"
require "yaml"

class Pathname
  alias_method :to_str, :to_s
end

require "active_support/concern"
require "active_support/configurable"
require "active_support/core_ext/object/blank"
require "active_support/core_ext/object/try"
require "active_support/core_ext/module/delegation"
require "attr_lazy"
require "commander"
require "nokogiri"
require "typhoeus"
require "virtus"

require "solr_makr/version"
require "solr_makr/solr_request"
require "solr_makr/core_status"
require "solr_makr/solr_configuration"
require "solr_makr/core"
require "solr_makr/commands"
require "solr_makr/commands/shared"
require "solr_makr/commands/create_core"
require "solr_makr/commands/destroy_core"
require "solr_makr/commands/list_cores"
require "solr_makr/commands/write_yaml"
require "solr_makr/application"

module SolrMakr
  class << self
    TEMPLATE_PATH = Pathname.new(File.dirname(__FILE__)).join('files')

    # @param [String] path
    # @raise [Errno::ENOENT] if undefined template
    # @return [String] contents of file
    def template(path)
      TEMPLATE_PATH.join(path).read
    end
  end
end
