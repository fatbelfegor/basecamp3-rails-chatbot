# config valid only for current version of Capistrano
lock "3.8.0"

set :application, "basecamp3-rails-chatbot"

set :repo_url, "git@github.com:fatbelfegor/basecamp3-rails-chatbot.git"
set :branch, :cap
set :deploy_to, '/home/deploy/basecamp3-rails-chatbot'
set :pty, true
set :linked_files, %w{config/application.yml}
set :linked_dirs, %w{bin  tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}
set :keep_releases, 5
set :rvm_type, :user
set :rvm_ruby_version, 'ruby-2.3.1' # Edit this if you are using MRI Ruby

set :puma_rackup, -> { File.join(current_path, 'config.ru') }
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"    #accept array for multi-bind
set :puma_conf, "#{shared_path}/puma.rb"
set :puma_access_log, "#{shared_path}/log/puma_error.log"
set :puma_error_log, "#{shared_path}/log/puma_access.log"
set :puma_role, :app
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
set :puma_threads, [1, 5]
set :puma_workers, 1
set :puma_worker_timeout, nil
set :puma_init_active_record, false
set :puma_preload_app, false


namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end