# frozen_string_literal: true
require "datastar"
require "datastar/async_executor"

# Do not silence logs!
Datastar::AsyncExecutor.prepend(Module.new do
  def initialize; end
end)

Datastar.configure do |config|
  config.finalize = lambda do |_view_context, response|
    throw :halt, response.finish
  end
  config.executor = Datastar::AsyncExecutor.new
  config.logger = Console
end
