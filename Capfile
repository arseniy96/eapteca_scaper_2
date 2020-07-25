# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require 'capistrano/deploy'
require 'capistrano/bundler'
require 'capistrano/rails'
require 'capistrano/rvm'
require 'capistrano/puma'
require 'capistrano/sidekiq'
require "capistrano/scm/git"

install_plugin Capistrano::Puma
install_plugin Capistrano::SCM::Git

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
