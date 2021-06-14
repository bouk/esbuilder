require "esbuilder/version"

module Esbuilder
  class UnknownEntryPointError < StandardError; end

  class << self
    def entry_point_to_outputs(entry_point)
      return outputs_from_manifest(entry_point) if Engine.config.use_manifest

      build_entry_point(entry_point)
    end

    def build_entry_point(entry_point)
      assets = Engine.config.base_path
      outdir = Engine.config.output_path

      entry_point_file = assets.join(entry_point).to_s
      result = Esbuild.build(
        outbase: assets.to_s,
        entry_points: [entry_point_file],
        entry_names: "[dir]/[name]-[hash]",
        write: true,
        bundle: true,
        outdir: outdir,
        public_path: "/",
        metafile: true,
        abs_working_dir: Rails.root.to_s
      )
      result.metafile.outputs.each_key.map { |key| "/#{Rails.root.join(key).relative_path_from(outdir)}" }
    end

    private

    def outputs_from_manifest(entry_point)
      unless (outputs = manifest[entry_point])
        raise UnknownEntryPointError, "Unknown entry point #{entry_point}"
      end
      outputs
    end

    def manifest
      @manifest ||= JSON.parse(File.read(Engine.config.manifest_path))
    end
  end
end

require "esbuilder/engine"
