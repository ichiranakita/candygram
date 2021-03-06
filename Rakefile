require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "candygram"
    gem.summary = %Q{Delayed job queueing for MongoMapper}
    gem.description = %Q{Candygram provides a job queue for the MongoDB document-oriented database, inspired by delayed_job and Resque. It uses the MongoMapper ORM and allows you to queue method calls for execution ASAP or at any time in the future.}
    gem.email = "sfeley@gmail.com"
    gem.homepage = "http://github.com/SFEley/candygram"
    gem.authors = ["Stephen Eley"]
    gem.add_dependency "mongo", ">= 0.18"
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_development_dependency "yard", ">= 0.5.2"
    gem.add_development_dependency "mocha", ">= 0.9.7"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end
