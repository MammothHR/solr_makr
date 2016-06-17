module SolrMakr
  class Pathlike < Virtus::Attribute
    # @param [#to_s, Pathname]
    # @return [Pathname]
    def coerce(pathy)
      return Pathname.new(pathy)
    end
  end
end
