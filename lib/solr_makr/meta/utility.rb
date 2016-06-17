module SolrMakr
  module Utility
    module_function

    # These are the minimum files required to configure a collection.
    REQUIRED_SOLR_NODES = %w[schema.xml solrconfig.xml]

    def default_table_options!(**table_options)
      table_options[:style] ||= {}

      width = table_options.delete(:width)

      unless width == false
        table_options[:style].reverse_merge! width: width || 80
      end

      return table_options
    end

    # @param [#each] collection
    # @param [String] if_blank
    # @param [Hash] table_options option that get passed to the `Terminal::Table` constructor
    # @yieldparam [Terminal::Table] t
    # @yieldparam [Array, #to_a, Object] item
    # @return [Terminal::Table]
    def default_table(collection:, if_blank: 'n/a', **table_options, &formatter)
      table_options = default_table_options!(table_options)

      return if_blank if collection.blank?

      Terminal::Table.new table_options do |t|
        collection.each do |item|
          if block_given?
            if formatter.arity == 2
              formatter.call(t, item)
            else
              t << yield(item)
            end
          elsif item.respond_to? :to_table_row
            t << item.to_table_row
          else
            t << Array(item)
          end
        end
      end
    end

    def hash_to_table(hsh, if_blank: 'n/a', **table_options)
      hsh = hsh.to_h

      table_options = default_table_options!(table_options)

      if hsh.present?
        Terminal::Table.new table_options do |t|
          hsh.each do |key, value|
            t << [key.inspect, value.inspect]
          end
        end
      else
        if_blank
      end
    end

    # It's possible the root directory is not what actually contains the nodes
    # for configuring solr (e.g. files are in a `conf` directory). For now let's
    # use `Pathname#find` to figure it out.
    #
    # @param [Pathname] root
    # @return [Pathname]
    # @return [nil]
    def path_to_configset(root)
      root.find do |path|
        return path.dirname if path.basename.to_s.in?(REQUIRED_SOLR_NODES)
      end

      return nil
    end

    # @param [Pathname] conf_path
    # @yield called once for each missing node
    # @yieldparam [String] name
    # @yieldreturn [void]
    def looks_like_a_valid_configset?(conf_path)
      if conf_path.present? && conf_path.try(:exist?)
        missing = REQUIRED_SOLR_NODES.reject do |file|
          conf_path.join(file).exist?
        end

        missing.each do |name|
          yield name if block_given?
        end

        return missing.none?
      else
        false
      end
    end
  end
end
