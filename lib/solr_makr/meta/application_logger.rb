module SolrMakr
  class ApplicationLogger < ::Logger
    ARBITRARY = %w[success failure]

    def format_severity(level)
      if level.in? ARBITRARY
        level
      else
        super
      end
    end
  end
end
