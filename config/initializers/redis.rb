# Sidekiq threadpool 생성
REDIS_POOL = ConnectionPool.new(:size => 7 + 5, :timeout => 2) { Redis::Namespace.new("sidekiq_job", redis: Redis.new(:url => "redis://#{ENV['REDIS_HOST']}:6379")) }