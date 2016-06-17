module SolrMakr
  module IndifferentOptions
    delegate :[], :[]=, to: :@table

    def initialize
      @table = {}.with_indifferent_access
    end

    def default(defaults = {})
      @table.reverse_merge! defaults
    end
  end
end
