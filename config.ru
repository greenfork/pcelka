# frozen_string_literal: true
dev = ENV["RACK_ENV"] == "development"

require "console"
Console.logger.debug!

require_relative "config/falcon_init"
require_relative "config/datastar"

$LOAD_PATH.unshift(File.expand_path("lib", __dir__))
require_relative "pcelka"
require_relative "models"
require_relative "app"
run App.freeze.app

unless dev
  Tilt.finalize!
  RubyVM::YJIT.enable if defined?(RubyVM::YJIT.enable)
end

freeze_core = !dev
if freeze_core
  begin
    require "refrigerator"
  rescue LoadError
  else
    require "nio" if defined?(Puma)
    Refrigerator.freeze_core
  end
end
