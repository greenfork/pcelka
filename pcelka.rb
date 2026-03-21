# frozen_string_literal: true
require "async"
require "pcelka/async_client"
require_relative "db"

procfile = ENV.fetch("PCELKA_PROCFILE", "Procfile")
logs_mailbox = Async::Queue.new
LOGS_READY = Async::Condition.new
PCELKA = Pcelka::AsyncClient.from_procfile procfile
PCELKA.server.writer.add_generic_writer logs_mailbox

Thread.new do
  PCELKA.server.run
  PCELKA << :start_all
end

Thread.new do
  while l = logs_mailbox.pop
    new_id = DB[:logs].insert(app: l[0], log: l[1], is_error: l[2])
    LOGS_READY.signal new_id
  end
end
