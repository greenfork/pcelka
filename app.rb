# frozen_string_literal: true
require "roda"
require "datastar"

class App < Roda
  plugin :symbol_views
  plugin :render, escape: true, assume_fixed_locals: true,
    template_opts: {
      scope_class: self,
      freeze: true,
      extract_fixed_locals: true,
      default_fixed_locals: "()",
      chain_appends: true,
      skip_compiled_encoding_detection: true,
    }
  plugin :assets, css: "styles.css", js: "app.js"
  plugin :public
  plugin :part
  plugin :head

  route do |r|
    r.public
    r.assets

    ds = Datastar.from_rack_env(env)

    r.root do
      @report = PCELKA << :report
      :home
    end

    r.get "logs" do
      ds.stream do |sse|
        while new_id = LOGS_READY.wait
          sse.patch_elements(
            %(<div>Hello, World! #{new_id}</div>),
            mode: "append",
            selector: "#main-logs"
          )
        end
      end
    end

    r.on "programs" do
      program_action_response = lambda do
        if ds.sse?
          report = PCELKA << :report
          ds.patch_elements part("home/report", report:)
        else
          r.redirect "/"
        end
      end

      r.post "start_all" do
        PCELKA << :start_all
        program_action_response.call
      end

      r.post "stop_all" do
        PCELKA << :stop_all
        program_action_response.call
      end

      r.on String do |program_id|
        r.post "start" do
          PCELKA << [:start, program_id]
          program_action_response.call
        end

        r.post "stop" do
          PCELKA << [:stop, program_id]
          program_action_response.call
        end

        r.post "restart" do
          PCELKA << [:restart, program_id]
          program_action_response.call
        end
      end
    end
  end
end
