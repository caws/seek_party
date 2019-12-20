lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "search_party/version"

Gem::Specification.new do |spec|
  spec.name          = "search_party"
  spec.version       = SearchParty::VERSION
  spec.authors       = ["Charles Washington"]
  spec.email         = ["charles_was_7@hotmail.com"]

  spec.summary       = %q{SearchParty makes quick work of adding search functionalities to your models.}
  spec.description   = %q{This gem should be used alongside ActiveRecord and uses introspection in order to check the fields of a given model. }
  spec.homepage      = "https://github.com/caws/search_party"
  spec.license       = "MIT"

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/caws/search_party"
  spec.metadata["changelog_uri"] = "https://github.com/caws/search_party"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
