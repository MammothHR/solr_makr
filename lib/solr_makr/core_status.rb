module SolrMakr
  class CoreStatus
    include Virtus.model strict: true

    attribute :name,          String
    attribute :start_time,    Time
    attribute :uptime,        Integer,  default: 0
    attribute :default_core,  Boolean,  default: false
    attribute :size,          String,   default: '0 bytes'
    attribute :size_in_bytes, Integer,  default: 0
    attribute :documents,     Integer,  default: 0

    class << self
      LOOKS_TRUE        = /\At(?:rue)?\z/i

      NAME_XML          = 'str[name="name"]'
      DEFAULT_CORE_XML  = 'bool[name="isDefaultCore"]'
      SIZE_XML          = 'str[name="size"]'
      SIZE_IN_BYTES_XML = 'long[name="sizeInBytes"]'
      START_TIME_XML    = 'date[name="startTime"]'
      UPTIME_XML        = 'long[name="uptime"]'
      DOCUMENTS_XML     = 'int[name="numDocs"]'

      # @return [SolrMakr::CoreStatus]
      def from_xml(node)
        params = {
          name:           text_at_css(node, NAME_XML),
          size:           text_at_css(node, SIZE_XML),
          size_in_bytes:  text_at_css(node, SIZE_IN_BYTES_XML),
          documents:      text_at_css(node, DOCUMENTS_XML),
          uptime:         text_at_css(node, UPTIME_XML)
        }

        params[:default_core] = text_at_css(node, DEFAULT_CORE_XML) do |res|
          res.to_s.match(LOOKS_TRUE).present?
        end

        params[:start_time] = text_at_css(node, START_TIME_XML) do |res|
          Time.parse res if res.present?
        end

        new params
      end

      def text_at_css(node, selector, &block)
        result = node.at_css(selector).try(:text)

        if block_given?
          yield result
        else
          result
        end
      end
    end
  end
end
