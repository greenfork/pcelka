# frozen_string_literal: true
require "async"
require "pcelka/async_client"
require "pcelka/logs_collector"

procfile = Pathname(ENV.fetch("PCELKA_PROCFILE", "Procfile"))
unless procfile.exist?
  procfile = Pathname(__FILE__).parent.join("examples/procfile/Procfile")
  Console.warn "Running an example proc!"
  Console.warn "Please run in the directory with Procfile or specify it via the PCELKA_PROCFILE environment variable"
end

logs_mailbox = Async::Queue.new
PCELKA = Pcelka::AsyncClient.from_procfile procfile
PCELKA.server.writer.add_generic_writer logs_mailbox
LOGS_COLLECTOR = Pcelka::LogsCollector.new logs_mailbox
LOGS_COLLECTOR.collect

Thread.new do
  PCELKA.server.run
  PCELKA << :start_all
end
