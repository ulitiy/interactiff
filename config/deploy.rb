default_run_options[:pty] = true
set :application, "quest.interactiff.net"
server application, :app, :web, :db, :primary => true
set :deploy_to, "/home/interactiff/quest.interactiff.net"
set :domain, "interactiff@interactiff.net"
set :port, 60321
set :user, "interactiff"
ssh_options[:forward_agent] = true #заставляет сервер юзать ключи компьютера
set :repository, "git@github.com:interactiff/joygen.git"
set :scm, "git"
set :branch, "master"
set :use_sudo, false
set :deploy_via, :remote_cache #уменьшает количество телодвижений на сервере при деплое
set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH",
  'LANG' => 'ru_RU.UTF-8'
}
set :bundle_flags, "--deployment --quiet --binstubs --shebang ruby-local-exec"

require 'bundler/capistrano'
require 'capistrano-unicorn'
