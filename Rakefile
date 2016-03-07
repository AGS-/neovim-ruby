require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

namespace :spec do
  desc "Install Neovim and run specs on CI"
  task :ci => ["neovim:install", :spec]
end

namespace :neovim do
  vendor = File.expand_path("../vendor/neovim", __FILE__)

  desc "Install Neovim"
  task :install do
    sh "git submodule update --init && " +
       "cd #{vendor} && " +
       "make distclean && " +
       "make"
  end

  desc "Update Neovim installation"
  task :update do
    sh "git submodule update --init && " +
       "cd #{vendor} && " +
       "make distclean && " +
       "git pull origin master && " +
       "make"
  end
end

task :default => :spec
