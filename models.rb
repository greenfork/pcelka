# frozen_string_literal: true
require_relative "db"

# if %w"development test".include? ENV["RACK_ENV"]
#   require "logger"
#   LOGGER = Logger.new($stdout)
#   LOGGER.level = Logger::FATAL if ENV["RACK_ENV"] == "test"
#   DB.loggers << LOGGER
# end

if %w[development test].include? ENV["RACK_ENV"]
  require "console"
  Console.logger.fatal! if ENV["RACK_ENV"] == "test"
  DB.loggers << Console
end

require "sequel/core"
Sequel.extension :migration
Sequel::Migrator.run(DB, "db/migrations")

Sequel.extension :fiber_concurrency
