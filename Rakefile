require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

spec = Gem::Specification.new do |s|
  s.name              = 'enumerate_by'
  s.version           = '0.4.4'
  s.platform          = Gem::Platform::RUBY
  s.summary           = 'Adds support for declaring an ActiveRecord class as an enumeration'
  s.description       = s.summary
  
  s.files             = FileList['{lib,test}/**/*'] + %w(CHANGELOG.rdoc init.rb LICENSE Rakefile README.rdoc) - FileList['test/app_root/{log,log/*,script,script/*}']
  s.require_path      = 'lib'
  s.has_rdoc          = true
  s.test_files        = Dir['test/**/*_test.rb']
  
  s.author            = 'Aaron Pfeifer'
  s.email             = 'aaron@pluginaweek.org'
  s.homepage          = 'http://www.pluginaweek.org'
  s.rubyforge_project = 'pluginaweek'
end
  
desc 'Default: run all tests.'
task :default => :test

desc "Test the #{spec.name} plugin."
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.test_files = spec.test_files
  t.verbose = true
end

begin
  require 'rcov/rcovtask'
  namespace :test do
    desc "Test the #{spec.name} plugin with Rcov."
    Rcov::RcovTask.new(:rcov) do |t|
      t.libs << 'lib'
      t.test_files = spec.test_files
      t.rcov_opts << '--exclude="^(?!lib/)"'
      t.verbose = true
    end
  end
rescue LoadError
end

desc "Generate documentation for the #{spec.name} plugin."
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = spec.name
  rdoc.template = '../rdoc_template.rb'
  rdoc.options << '--line-numbers' << '--inline-source' << '--main=README.rdoc'
  rdoc.rdoc_files.include('README.rdoc', 'CHANGELOG.rdoc', 'LICENSE', 'lib/**/*.rb')
end

desc 'Generate a gemspec file.'
task :gemspec do
  File.open("#{spec.name}.gemspec", 'w') do |f|
    f.write spec.to_ruby
  end
end
