module SolrMakr
  module BufferInteraction
    extend ActiveSupport::Concern

    # @!attribute [r] buffer
    # @return [SolrMakr::Commands::Buffer]
    attr_lazy_reader :buffer do
      build_buffer
    end

    # @param [ActiveInteraction::Base, SolrMakr::BufferInteraction] other
    # @param [Boolean] raise_interrupt normal behavior for halting with compose
    # @param [Hash] options
    # @return [Object]
    def compose_buffer(other, raise_interrupt: true, **options, &on_failure)
      outcome = other.run(**options)

      if outcome.kind_of?(SolrMakr::BufferInteraction)
        buffer.import outcome.buffer
      end

      if outcome.valid?
        return outcome.result
      else
        if block_given?
          yield outcome
        end

        if raise_interrupt
          throw :interrupt, outcome.errors
        end

        return nil
      end
    end

    def build_buffer
      SolrMakr::Commands::Buffer.new
    end
  end
end
