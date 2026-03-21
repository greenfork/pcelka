# frozen_string_literal: true

module Pcelka
  class Server
    module Notifiable
      private
        def init_notifiable(programs_status_changed_cond:)
          @programs_status_changed_cond = programs_status_changed_cond
          @last_programs_statuses = nil
        end

        def notify_programs_status_changed
          new_statuses = gather_statuses
          if @last_programs_statuses.nil? || @last_programs_statuses != new_statuses
            @programs_status_changed_cond.signal true
          end
          @last_programs_statuses = new_statuses
        end

        def gather_statuses
          @started_programs.map{[it.id, it.status]}
        end
    end
  end
end
