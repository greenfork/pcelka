# frozen_string_literal: true

# Provides a "state" of the server together with possible actions.
module Pcelka
  class Server
    module Reportable
      Report = Data.define(:items, :allowed_actions)
      ReportItem = Data.define(:id, :cmd, :status, :allowed_actions)

      def report
        items =
          @spec.keys.sort.map do |id|
            program_spec = @spec[id]
            program = @started_programs.find{ it.id == id }
            status = program_status(program)
            ReportItem.new id:, cmd: program_spec.cmd, status:,
              allowed_actions: allowed_program_actions(status)
          end

        Report.new items:, allowed_actions: allowed_server_actions(items)
      end

      private
        def program_status(program)
          program&.status || :not_started
        end

        NOT_STARTED_ACTIONS = %i[start].freeze
        ALIVE_ACTIONS = %i[stop restart].freeze
        DEAD_ACTIONS = %i[start].freeze
        STOPPING_ACTIONS = [].freeze
        UNKNOWN_ACTIONS = [].freeze
        private_constant :NOT_STARTED_ACTIONS, :ALIVE_ACTIONS, :DEAD_ACTIONS,
          :STOPPING_ACTIONS, :UNKNOWN_ACTIONS

        def allowed_program_actions(status)
          case status
          when :not_started then NOT_STARTED_ACTIONS
          when :alive then ALIVE_ACTIONS
          when :dead then DEAD_ACTIONS
          when :stopping then STOPPING_ACTIONS
          when :unknown then UNKNOWN_ACTIONS
          else raise "Unreachable"
          end
        end

        def allowed_server_actions(items)
          allowed_actions = []
          allowed_actions << :start_all if items.any?{ it.allowed_actions.include?(:start) }
          allowed_actions << :stop_all if items.any?{ it.allowed_actions.include?(:stop) }
          allowed_actions
        end
    end
  end
end
