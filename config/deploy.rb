default_run_options[:pty] = true
set :application, "quest.interactiff.net"
server application, :app, :web, :db, :primary => true
set :deploy_to, "/home/interactiff/quest.interactiff.net"
set :domain, "interactiff@interactiff.net"
set :port, 60321
set :user, "interactiff"
ssh_options[:forward_agent] = true #заставляет сервер юзать ключи компьютера
set :repository, "git@github.com:ulitiy/joygen.git"
set :scm, "git"
set :branch, "master"
set :use_sudo, false
set :deploy_via, :remote_cache #уменьшает количество телодвижений на сервере при деплое
set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH",
  'LANG' => 'ru_RU.UTF-8'
}
set :bundle_flags, "--deployment --quiet --binstubs --shebang ruby-local-exec"
set :whenever_command, "bundle exec whenever"

require 'bundler/capistrano'
require 'capistrano-unicorn'
require "whenever/capistrano"

desc "Remote console"
task :console, :roles => :app do
  run_interactively "bundle exec rails console #{rails_env}"
end

desc "Remote dbconsole"
task :dbconsole, :roles => :app do
  run_interactively "bundle exec rails dbconsole #{rails_env}"
end

def run_interactively(command, server=nil)
  server ||= find_servers_for_task(current_task).first
  exec %Q(ssh #{domain} -p #{port} -t 'source ~/.bash_profile && cd #{current_path} && #{command}')
end

namespace :deploy do
  namespace :assets do
    task :precompile, :except => { :no_release => true } do
      from = source.next_revision(current_revision)
      if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
        run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
      else
        logger.info "Skipping asset pre-compilation because there were no asset changes"
      end
    end
  end
end

namespace :mongoid do
  desc "Create MongoDB indexes"
  task :create_indexes do
    run "cd #{current_path} && bundle exec rake db:mongoid:create_indexes", :once => true
  end
  task :remove_indexes do
    run "cd #{current_path} && bundle exec rake db:mongoid:remove_indexes", :once => true
  end
end

namespace :delayed_job do
  desc "Stop the delayed_job process"
  task :stop, :roles => :app do
    run "cd #{current_path} && RAILS_ENV=production script/delayed_job stop"
  end
  desc "Start the delayed_job process"
  task :start, :roles => :app do
    run "cd #{current_path} && RAILS_ENV=production script/delayed_job start"
  end
  desc "Restart the delayed_job process"
  task :restart, :roles => :app do
    run "cd #{current_path} && RAILS_ENV=production script/delayed_job restart"
  end
end

after "deploy:stop",    "delayed_job:stop"
after "deploy:start",   "delayed_job:start"
after "deploy:restart", "delayed_job:restart"
after "deploy:update", "mongoid:create_indexes"