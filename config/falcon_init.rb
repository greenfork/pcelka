# frozen_string_literal: true

if defined? Falcon
  # https://github.com/socketry/falcon/issues/333
  class Falcon::Server
    alias __original_accept accept

    def accept(...)
      __original_accept(...)
    rescue Errno::EPIPE, Errno::ECONNRESET
      # Client disconnected mid-response — expected.
    end
  end
end
