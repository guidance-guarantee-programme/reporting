#!/usr/bin/env ruby
require 'pathname'

APP_ROOT = Pathname.new File.expand_path('../../', __FILE__)

Dir.chdir APP_ROOT do
  # This script is a starting point to setup your application.
  # Add necessary setup steps to this file:

  puts '== Installing Ruby dependencies =='
  system 'gem install bundler --conservative'
  system 'bundle check || bundle install'

  puts "\n== Preparing database =="
  system 'bin/rake db:setup'

  puts "\n== Removing old logs and tempfiles =="
  system 'bin/rake log:clear'
  system 'bin/rake tmp:clear'
end
