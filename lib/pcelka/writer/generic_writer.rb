# frozen_string_literal: true

# Writes a structured message to an `Object#<<`.
module Pcelka
  class Writer
    class GenericWriter
      def initialize(sink)
        @sink = sink
      end

      def write(app:, message:, is_error:)
        @sink << [app, message, is_error]
      end
    end
  end
end
