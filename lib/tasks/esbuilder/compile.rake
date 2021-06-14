require "set"

namespace :esbuilder do
  desc "Compile esbuilder entrypoints"
  task compile: :environment do
    entry_points = Esbuilder::Engine.config.entry_points
    entry_point_map = {}
    entry_points.each do |entry_point|
      outputs = Esbuilder.build_entry_point(entry_point)
      entry_point_map[entry_point] = outputs
    end

    File.open(Esbuilder::Engine.config.manifest_path, "w") do |f|
      JSON.dump(entry_point_map, f)
    end
  end
end
