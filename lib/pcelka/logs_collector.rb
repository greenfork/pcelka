# frozen_string_literal: true
require_relative "../../db"

module Pcelka
  class LogsCollector
    def initialize(logs_mailbox)
      @logs_ready = Async::Condition.new
      @logs_mailbox = logs_mailbox
      @collect_thread = nil
    end

    def collect
      @collect_thread = Thread.new do
        while l = @logs_mailbox.pop
          new_id = DB[:logs].insert(app: l[0], message: l[1], is_error: l[2])
          @logs_ready.signal new_id
        end
      end
    end

    def retrieve_new_logs(last_id = 0)
      logs = DB[:logs].order(:id).where{id > last_id}.all
      unless logs.empty?
        last_id = logs.last[:id]
        logs.each{ yield it }
      end

      while @logs_ready.wait
        logs = DB[:logs].order(:id).where{id > last_id}.all
        unless logs.empty?
          last_id = logs.last[:id]
          logs.each{ yield it }
        end
      end
    end
  end
end
