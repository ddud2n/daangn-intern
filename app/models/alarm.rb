class Alarm < ApplicationRecord
	after_commit :notify_pusher, on: [:create]
    def notify_pusher
		Pusher.trigger('alarm', 'new', self.as_json)
    end
end
