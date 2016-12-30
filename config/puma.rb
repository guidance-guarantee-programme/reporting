environment ENV.fetch('RAILS_ENV') { 'development' }
daemonize false

pidfile 'tmp/pids/puma.pid'
state_path 'tmp/pids/puma.state'

workers ENV.fetch('WEB_CONCURRENCY') { 2 }
threads_count = ENV.fetch('RAILS_MAX_THREADS') { 5 }.to_i
threads threads_count, threads_count

bind 'unix://tmp/sockets/puma.sock'
port ENV.fetch('PORT') { 3000 }

preload_app!

on_worker_boot do
  ActiveRecord::Base.establish_connection
end

plugin :tmp_restart
