class Post < ApplicationRecord
	after_commit :notify_pusher, on: [:create]
    def notify_pusher
		Pusher.trigger('post', 'new', self.as_json)
    end
end
