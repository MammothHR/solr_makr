require "fileutils"
require "find"
require "pathname"
require "set"
require "yaml"

require "active_support/callbacks"
require "active_support/concern"
require "active_support/configurable"
require 'active_support/core_ext/hash/indifferent_access'
require "active_support/core_ext/object/blank"
require "active_support/core_ext/object/try"
require "active_support/core_ext/object/with_options"
require "active_support/core_ext/module/delegation"
require "active_support/dependencies/autoload"
require "active_interaction"
require "attr_lazy"
require "commander"
require "httparty"
require "lmdb"
require "rugged"
require "toml"
require "terminal-table"
require "virtus"
require "zk"

require "solr_makr/version"

module SolrMakr
  extend ActiveSupport::Autoload

  # Executable name.
  BIN_NAME = 'solr-makr'

  autoload :Application
  autoload :ApplicationAction
  autoload :ApplicationDispatch
  autoload :Collection
  autoload :Commands
  autoload :Configsets
  autoload :Configuration
  autoload :LocalConfiguration
  autoload :SolrAPI
  autoload :SunspotConfiguration

  autoload_under 'errors' do
    autoload :HaltExecution
  end

  autoload_under 'meta' do
    autoload :AbstractRunner
    autoload :BufferInteraction
    autoload :DisablePaging
    autoload :HasSolrAttributes
    autoload :IndifferentOptions
    autoload :SetGlobalOptions
    autoload :OptionDefinition
    autoload :OptionMapping
    autoload :Pathlike
    autoload :Utility
    autoload :WrapsDirectory
    autoload :WrapsPath
  end

  class << self
    delegate :with_zookeeper, to: :configuration

    attr_lazy_reader :buffer do
      SolrMakr::Commands::Buffer.new
    end

    delegate :logger, to: :buffer

    attr_lazy_reader :configuration do
      SolrMakr::Configuration.new
    end

    attr_lazy_reader :root do
      Pathname.new(__dir__)
    end

    attr_lazy_reader :files do
      root.join('solr_makr', 'files')
    end

    attr_lazy_reader :default_configset do
      files.join('default-configset')
    end

    attr_lazy_reader :local_configuration do
      SolrMakr::LocalConfiguration
    end
  end
end

Commander::Command::Options.prepend SolrMakr::IndifferentOptions
Commander::UI.singleton_class.prepend SolrMakr::DisablePaging
