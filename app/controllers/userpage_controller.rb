class UserpageController < ApplicationController
	
	def page
		@username = params[:username]
		@posts = Post.where(username: params[:username]).all
		@keywords = Keyword.where(username: params[:username]).all
		@alarms = Alarm.where(username: params[:username]).all
		
	end
end
