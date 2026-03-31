# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("lib", __dir__)
require "pcelka"

Gem::Specification.new do |s|
  s.name = "pcelka"
  s.version = Pcelka::VERSION
  s.summary = "Program runner"
  s.description = "Run several programs at once, control them and watch the logs"
  s.authors = ["Dmitry Matveyev"]
  s.email = "public@greenfork.me"
  s.homepage = "https://rubygems.org/gems/pcelka"
  s.license = "MIT"

  s.required_ruby_version = "~> 4.0"

  s.executables = "pcelka"

  s.files = Dir["**/*"].grep(%r{^(bin/|lib/|assets/|config/|db/|examples/|i18n/|public/|views/|app.rb|config.ru|db.rb|models.rb|pcelka.rb)})

  s.add_dependency "tilt", ">= 2.6"
  s.add_dependency "erubi", ">= 1.5"
  s.add_dependency "roda", ">= 3.89"
  s.add_dependency "sequel"
  s.add_dependency "sqlite3"
  s.add_dependency "refrigerator", ">= 1"
  s.add_dependency "rake"

  s.add_dependency "falcon"
  s.add_dependency "async"
  s.add_dependency "console"

  s.add_dependency "ostruct" # required for roda-i18n
  s.add_dependency "roda-i18n"

  s.add_dependency "datastar"
end
