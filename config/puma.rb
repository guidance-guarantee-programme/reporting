#!/usr/bin/env puma

rackup DefaultRackup

environment ENV.fetch('RACK_ENV', 'development')
daemonize false

pidfile 'tmp/pids/puma.pid'
state_path 'tmp/pids/puma.state'

workers Integer(ENV.fetch('WEB_CONCURRENCY', 2))
threads Integer(ENV.fetch('MAX_THREADS', 5)), Integer(ENV.fetch('MAX_THREADS', 5))

bind 'unix://tmp/sockets/puma.sock'
port ENV.fetch('PORT', 3000)

preload_app!

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end
