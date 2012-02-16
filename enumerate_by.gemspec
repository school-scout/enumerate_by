# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
    s.name              = "enumerate_by"
    s.version           = '0.4.4.1'
    s.authors           = ["Aaron Pfeifer"]
    s.email             = "aaron@pluginaweek.org"
    s.homepage          = "http://www.pluginaweek.org"
    s.description       = "Adds support for declaring an ActiveRecord class as an enumeration"
    s.summary           = "Enumerations in ActiveRecord"
    s.require_paths     = ["lib"]
    #s.files             = `git ls-files`.split("\n")
    #s.test_files        = `git ls-files -- test/*`.split("\n")
    s.rdoc_options      = %w(--line-numbers --inline-source --title enumerate_by --main README.rdoc)
    s.extra_rdoc_files  = %w(README.rdoc CHANGELOG.rdoc MIT-LICENSE)
    s.files = Dir["{app,lib,config}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile", "README.rdoc"]
end