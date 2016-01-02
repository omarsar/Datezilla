class HomeController < ApplicationController
	before_filter :search_users

	def index
		#@interests = Interest.all
		#@users = User.all
	end

	def search_users
		@users = if params[:search].present?
			User.where(username: params[:search])
		else
			User.all
		end
	end

end
