class UsersController < ApplicationController
	before_filter :search_users

	def index
		#puts "--------------"
		#puts @users
		#render json: @users
	end


	def search_users
		#session = Neo4j::Session.open(:server_db,"http://localhost:8000")

		@users = if params[:search].present?
			User.where(username: params[:search])
		elsif params[:filter].present?
			if params[:filter] == "Join"
				User.all.order(created_at: :desc)
			end	
		else
			User.all
		end
	end
end
