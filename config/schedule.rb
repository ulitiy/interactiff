every :reboot do
  command "cd /home/interactiff/interactiff.net/current && bundle exec unicorn -c /home/interactiff/interactiff.net/current/config/unicorn/production.rb -E production -D"
  command "cd /home/interactiff/interactiff.net/current && RAILS_ENV=production script/delayed_job start"
end
