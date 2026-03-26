# frozen_string_literal: true

require "pcelka/server/controllable"
require "pcelka/server/reportable"

# Allow receiving commands and do corresponding actions.
module Pcelka
  class Server
    module Commandable
      include Reportable
      include Controllable

      private
        def remove_wakeup_io(ios)
          if ios.reject!{ it == @wakeup_io }
            byte = @wakeup_io.readbyte
            raise "Unexpected byte: #{byte}" unless byte == WAKEUP_BYTE
            @is_pending_cmd = true
          end
        end

        def process_cmd
          return unless @is_pending_cmd
          @is_pending_cmd = false

          response =
            case @mailbox.pop
            in :start_all
              @writer.write app: "_all", message: "_starting_all"
              start_all
            in :stop_all
              @writer.write app: "_all", message: "_stopping_all"
              stop_all
            in [:start, id]
              @writer.write app: id, message: "_starting"
              start(id)
            in [:stop, id]
              @writer.write app: id, message: "_stopping"
              stop(id)
            in [:restart, id]
              @writer.write app: id, message: "_restarting"
              restart(id)
            in :report
              report
            in :shutdown
              warn "Pcelka shutting down..."
              stop_all
              @should_stop = true
            else
              :unknown
            end

          @client_sink << response
        end
    end
  end
end
