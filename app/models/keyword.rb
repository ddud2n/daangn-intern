class Keyword < ApplicationRecord
	after_commit :notify_pusher, on: [:create]
    def notify_pusher
		Pusher.trigger('keyword', 'new', self.as_json)
    end
end
