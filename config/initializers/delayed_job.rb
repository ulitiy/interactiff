Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.sleep_delay = 2 #каждые 2 секунды
Delayed::Worker.max_attempts = 3
Delayed::Worker.max_run_time = 2.minutes
Delayed::Worker.read_ahead = 10 #грузить по 10 работ из очереди, чтобы меньше нагрузка на БД
Delayed::Worker.delay_jobs = !Rails.env.test?