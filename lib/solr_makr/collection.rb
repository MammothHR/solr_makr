module SolrMakr
  class Collection
    include Virtus.model strict: true

    attribute :name, String
    attribute :managed, Boolean, lazy: true, default: :detect_if_managed?

    def detect_if_managed?
      false
    end

    # @return [(String, Boolean)]
    def to_table_row
      [name, managed?]
    end
  end
end
