module SolrMakr
  # Disable annoying paging in the Commander gem.
  module DisablePaging
    def enable_paging; nil; end
  end
end
