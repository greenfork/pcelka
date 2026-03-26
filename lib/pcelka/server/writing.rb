# frozen_string_literal: true
require "pcelka/writer"

# Use the Writer class.
module Pcelka
  class Server
    module Writing
      attr_reader :writer

      private
        def init_writer
          @writer = Writer.new
        end

        def write_programs_output(programs)
          programs.each do |program|
            if out = program.read_stdout
              @writer.write app: program.id, message: out
            end

            if err = program.read_stderr
              @writer.write app: program.id, message: err, is_error: true
            end
          end
        end
    end
  end
end
