module SolrMakr
  module SolrRequest
    # @return [Typhoeus::Response]
    def solr_request(url, options = {})
      response = Typhoeus.get url, options

      return response if response.success?

      parsed = Nokogiri::XML(response.body)

      message = parsed.css('str[name="msg"]').first.try(:text)

      warn message.presence || response.body

      raise 'problem communicating with solr'
    end

    private
    def solr_cores_url
      "http://localhost:%d/solr/admin/cores" % [port]
    end
  end
end
