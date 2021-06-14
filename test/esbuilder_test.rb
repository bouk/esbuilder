require "test_helper"
require "tmpdir"

class EsbuilderTest < ActiveSupport::TestCase
  include Esbuilder::Helper

  test "it the output file and a manifest" do
    Rails.application.load_tasks

    old_path = Esbuilder::Engine.config.output_path
    old_manifest = Esbuilder::Engine.config.manifest_path
    Dir.mktmpdir do |dir|
      Esbuilder::Engine.config.output_path = dir
      Esbuilder::Engine.config.manifest_path = "#{dir}/esbuilder-manifest.json"

      Rake::Task['esbuilder:compile'].invoke

      manifest = JSON.load(File.read(Esbuilder::Engine.config.manifest_path))
      assert_equal 1, manifest.size
      outputs = manifest["application"]
      assert_not_nil outputs
      assert_equal 1, outputs.size
      assert_equal <<~JS, File.read("#{dir}#{outputs.first}")
        (() => {
          // app/javascript/packs/application.js
          console.log("yay");
        })();
      JS
    ensure
      Esbuilder::Engine.config.output_path = old_path
      Esbuilder::Engine.config.manifest_path = old_manifest
    end
  end

  private

  def javascript_include_tag(file)
    "<script src=#{file}>"
  end
end
