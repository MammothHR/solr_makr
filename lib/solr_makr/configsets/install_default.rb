module SolrMakr
  module Configsets
    class InstallDefault < ActiveInteraction::Base
      object :directory, class: 'SolrMakr::Configsets::Directory'

      def execute
        directory.create_if_missing!

        SolrMakr.default_configset.children.each do |source|
          FileUtils.cp_r source, directory.path.to_s
        end

        return true
      end
    end
  end
end
