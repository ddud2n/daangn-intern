# LOG파일 위치 지정
log_file_path = "#{Rails.root}/log/#{Rails.env}_sidekiq.log"

Sidekiq.configure_server do |config|
  config.redis = REDIS_POOL
  config.logger = Logger.new(log_file_path)
end

Sidekiq.configure_client do |config|
  config.redis = REDIS_POOL
end
 
# [Option] Exception 사유로 Job이 종료가 될 시, 다시 Job 시도 및 횟수를 정하는 코드입니다.
Sidekiq.default_worker_options = {retry: 1}