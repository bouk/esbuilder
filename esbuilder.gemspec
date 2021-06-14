require_relative "lib/esbuilder/version"

Gem::Specification.new do |spec|
  spec.name        = "esbuilder"
  spec.version     = Esbuilder::VERSION
  spec.authors     = ["Bouke van der Bijl"]
  spec.email       = ["i@bou.ke"]
  spec.homepage    = "https://github.com/bouk/esbuilder"
  spec.summary     = "Summary of Esbuilder."
  spec.description = "Description of Esbuilder."
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "esbuild", ">= 0.1.2"
  spec.add_dependency "rails", "~> 6.1.3", ">= 6.1.3.1"
end
