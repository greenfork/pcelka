# frozen_string_literal: true

require "pcelka/server/writing"
require "pcelka/server/commandable"

# Server that runs several command line programs.
module Pcelka
  class Server
    include Writing, Commandable

    WAKEUP_BYTE = 1

    # @param spec [Spec]
    # @param client_sink [Object#<<]
    # @param wakeup_io [IO]
    # @param mailbox [Object#pop] receives messages from clients.
    def initialize(spec:, client_sink:, wakeup_io:, mailbox:)
      @spec = spec
      @running_programs = []
      @started_programs = []
      @watch_ios = []
      @client_sink, @wakeup_io, @mailbox = client_sink, wakeup_io, mailbox
      @is_pending_cmd = false
      @should_stop = false
      init_writer
    end

    def run
      until @should_stop
        if ready_io = check_ready_io
          remove_wakeup_io(ready_io[0])
          programs = ready_programs(ready_io[0])
          write_programs_output(programs)
          process_cmd
        end
        prune_dead_programs
      end
    end

    private
      def check_ready_io
        ios_to_watch = @running_programs.flat_map(&:ios)
        ios_to_watch << @wakeup_io
        IO.select(ios_to_watch)
      end

      def ready_programs(ios)
        programs = ios.map{|io| @running_programs.find{ it.mark_ready(io) } }
        programs.uniq!(&:id)
        programs
      end

      def prune_dead_programs
        @running_programs.filter! do |program|
          next true if program.alive?
          program.stop
          false
        end
      end
  end
end
