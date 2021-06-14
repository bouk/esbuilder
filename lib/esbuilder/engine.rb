require "rails/railtie"

require "esbuilder/helper"

module Esbuilder
  class Engine < ::Rails::Engine
    config.after_initialize do |app|
      config.base_path = Rails.root.join("app/javascript/packs")
      config.entry_points = ["application"]
      config.manifest_path = Rails.root.join("app/javascript/esbuilder-manifest.json")
      config.use_manifest = Rails.env.production?
      config.output_path = app.paths["public"].existent.first
    end

    initializer "esbuilder.helper" do
      ActiveSupport.on_load :action_controller do
        ActionController::Base.helper Esbuilder::Helper
      end

      ActiveSupport.on_load :action_view do
        include Esbuilder::Helper
      end
    end
  end
end
