# frozen_string_literal: true
require_relative "../../db"

module Pcelka
  class LogsCollector
    LOGS = DB[:logs]

    def initialize(logs_mailbox)
      @logs_ready = Async::Condition.new
      @logs_mailbox = logs_mailbox
      @collect_thread = nil
    end

    def collect
      @collect_thread = Thread.new do
        while l = @logs_mailbox.pop
          new_id = LOGS.insert(app: l[0], message: l[1], is_error: l[2])
          @logs_ready.signal new_id
        end
      end
    end

    def retrieve_new_logs
      logs = LOGS.order(:id).all
      last_id = 0

      unless logs.empty?
        last_id = logs.last[:id]
        logs.each{ yield it }
      end

      while @logs_ready.wait
        logs = LOGS.order(:id).where{id > last_id}.all
        last_id = logs.last[:id]
        logs.each{ yield it }
      end
    end
  end
end
