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


	def update
		if params[:gender_preference]
			current_user.update(:gender_preference => params[:gender_preference])
			redirect_to root_path
		end
	end

	def show
		@user = User.find(params[:id])
	end




	def search_users
		#session = Neo4j::Session.open(:server_db,"http://localhost:8000")
		if user_signed_in?
			@gender_preference = if current_user.gender_preference == "Women"
				"Woman"
			elsif current_user.gender_preference == "Men"
				"Man"
			else
				"Woman"||"Man"
			end
		end


		@users = if params[:search].present?
			User.where(username: params[:search])
		elsif params[:filter].present?
			if params[:filter] == "Join"
				User.where(gender: @gender_preference).order(created_at: :asc)
			end	
		else
			if user_signed_in?
				User.where(gender: @gender_preference)
			else
				User.all
			end
		end
	end
end
