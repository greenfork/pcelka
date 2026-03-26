# frozen_string_literal: true
require "pcelka/writer/console_writer"
require "pcelka/writer/generic_writer"

# Container for different concrete writers. Delegates writing to all
# the @writers.
module Pcelka
  class Writer
    def initialize
      @writers = []
    end

    def add_console_writer
      @writers << ConsoleWriter.new
    end

    def add_generic_writer(port)
      @writers << GenericWriter.new(port)
    end

    def write(app:, message:, is_error: false)
      @writers.each{ it.write(app:, message:, is_error:) }
    end
  end
end
