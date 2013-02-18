Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.sleep_delay = 1 #каждую секунду
Delayed::Worker.max_attempts = 1
Delayed::Worker.max_run_time = 20.minutes
Delayed::Worker.read_ahead = 1000 #грузить по 1000 работ из очереди, чтобы меньше нагрузка на БД
Delayed::Worker.delay_jobs = !Rails.env.test?

# clear Mongoid::IdentityMap before each job
module Delayed
  module Plugins
    class ClearIdentityMap < Plugin
      callbacks do |lifecycle|
        lifecycle.before(:invoke_job) do |worker, &block|
          Mongoid::IdentityMap.clear
        end
      end
    end
  end
end

Delayed::Worker.plugins << Delayed::Plugins::ClearIdentityMap
