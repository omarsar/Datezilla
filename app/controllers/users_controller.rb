class UsersController < ApplicationController
	before_filter :search_users

	def index
		#puts "--------------"
		#puts @users
		#render json: @users
	end

	#for follow and unfollow methods
	#API
	# ---> /users/:id/follow
	def followed
		@user = User.find(params[:id])
		current_user.create_rel("FOLLOWING", @user) 
		if request.xhr?
			render json: { count: @user.following.count, id: @user.id }
		else
			redirect_to @user
		end

	end

	def show
		@user = User.find(params[:id])
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
