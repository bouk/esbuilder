require "esbuild"

module Esbuilder
  module Helper
    def entry_point_tag(*entry_points, **options)
      files = build(*entry_points)
      files.map do |file|
        if file.end_with?(".js")
          javascript_include_tag file, **options
        elsif file.end_with?(".css")
          stylesheet_link_tag file, **options
        else
          # Ignore non-js/css files
          ""
        end
      end.join("\n").html_safe
    end

    private

    def build(*entry_points)
      entry_points.reduce(Set.new) { |result, entry_point| result.merge Esbuilder.entry_point_to_outputs(entry_point) }
    end
  end
end
