# frozen_string_literal: true
require "async"
require "pcelka/server"
require "pcelka/spec"

# Public interface to the Server. Server runs in the background,
# and Client communicates with it.
#
# Example usage:
#
#     pcelka = Pcelka::AsyncClient.from_procfile procfile
#     pcelka.server.writer.add_console_writer
#     th = Thread.new { pcelka.server.run }
#     pcelka << :start_all
#     th.join
#
module Pcelka
  class AsyncClient
    def self.from_procfile(procfile)
      spec = Spec.from_procfile(procfile)
      client_sink = Async::Queue.new
      mailbox = Async::Queue.new
      programs_status_changed_cond = Async::Condition.new
      read, write = IO.pipe
      server = Server.new spec:, client_sink:, wakeup_io: read, mailbox:,
        programs_status_changed_cond:;

      new server:, client_sink:, wakeup_io: write, server_mailbox: mailbox,
        programs_status_changed_cond:
    end

    attr_reader :server

    def initialize(server:, client_sink:, wakeup_io:, server_mailbox:, programs_status_changed_cond:)
      @server, @client_sink, @wakeup_io, @server_mailbox, @programs_status_changed_cond =
        server, client_sink, wakeup_io, server_mailbox, programs_status_changed_cond
    end

    def <<(cmd)
      @server_mailbox << cmd
      @wakeup_io.putc Server::WAKEUP_BYTE
      @client_sink.pop
    rescue Errno::EPIPE
      raise "Failed to write to @runner's pipe"
    end

    def programs_status_changed?
      @programs_status_changed_cond.wait
    end
  end
end
