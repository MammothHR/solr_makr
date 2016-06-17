module SolrMakr
  module Commands
    # Captures output for buffers
    #
    # @api private
    class Buffer
      def initialize(context: nil, **options)
        @context  = context

        @output   = StringIO.new

        @logger   = Logger.new @output

        @logger.formatter = default_formatter

        @exit_status = 0
      end

      attr_reader :context
      attr_reader :output
      attr_reader :logger
      attr_reader :exit_status

      delegate :log, :debug, :error, :warn, :fatal, :info, to: :logger
      delegate :write, to: :output

      def import(buffer)
        write buffer.to_s

        unless buffer.success?
          self.exit_status = buffer.exit_status
        end

        return self
      end

      def error!(status: 1, message: nil)
        if message.present?
          logger.error message
        end

        if exit_status != status
          self.exit_status = status
        end
      end

      def ok(message = 'OK')
        print "\u2713 #{message}"
      end

      alias_method :success, :ok

      def failure(message)
        print "\u2717 #{message}"
      end

      def issue(message)
        print "\u2757 #{message}"
      end

      def separator!
        write "\n\n"
      end

      def print(*lines)
        lines.each { |line| write line }

        write "\n"
      end

      def exit_status=(new_retval)
        @exit_status = Integer(new_retval) rescue -1
      end

      def success?
        @exit_status.zero?
      end

      def to_s
        output.string
      end

      # @return [Proc]
      def default_formatter
        proc do |severity, time, progname, message|
          context_name = progname.presence || context.presence || SolrMakr::BIN_NAME

          [].tap do |parts|
            parts << severity
            parts << "[#{time.iso8601}]" unless STDOUT.tty?
            parts << "[#{context_name}]" if context_name.present?
            parts << message
          end.join(' ') + "\n"
        end
      end
    end
  end
end
