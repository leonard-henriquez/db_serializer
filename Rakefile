# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'
require 'yard'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

# RDoc::Task.new do |doc|
#   doc.main = 'README.md'
#   doc.title = "ActiveGeo #{ActiveGeo::VERSION} Documentation"
#   doc.options << '--format=sdoc'
#   doc.template = 'rails'
#   doc.rdoc_dir = 'doc'
#   doc.rdoc_files.include('README.md', 'lib/**/*.rb')
#   doc.rdoc_files.exclude('lib/active_geo.rb', 'lib/active_geo/version.rb')
# end

YARD::Rake::YardocTask.new do |t|
  YARD::Config.load_plugin('activesupport-concern')
  t.files = ['lib/**/*.rb']
  t.stats_options = ['--list-undoc']
end

task default: :test
