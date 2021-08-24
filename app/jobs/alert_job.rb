require 'json'

class AlertJob < ApplicationJob
  queue_as :alert

  def perform(data)
	parsed = JSON.parse(data)  
    alarm = Alarm.new
	alarm.username=parsed["username"]
	alarm.word=parsed["word"]
	alarm.title=parsed["title"]
	alarm.description=parsed["description"]
	alarm.save
  end
end
