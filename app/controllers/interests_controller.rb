class InterestsController < ApplicationController
	before_action :authenticate_user!

	def index	
		@interests = Interest.all
		@users = User.all
	end


	#to create a new interest
	def new
		@interest = Interest.new	
	end

	def create
		@interest = Interest.create(title: params[:interest_title])
		@interest.score = @interest.score + 1
		@interest.save
		follow_interest(@interest)

		#TODO: notice if mistake using the notificaiton at the top
		redirect_to root_path

	end

	def follow_interest(interest)
		current_user.create_rel("HAS_INTEREST", interest) 	
		#TODO increment score for ranking interests	
	end

	#for follow and unfollow methods
	#API
	# ---> /interests/:id/follow
	def followed
		@interest = Interest.find(params[:id])
		@interest.score = @interest.score + 1
		@interest.save
		current_user.create_rel("HAS_INTEREST", @interest) 
		if request.xhr?
			render json: { id: @interest.id }
		else
			redirect_to @user
		end

	end

	# API
	# ---> /interests/:id/unfollow
	def unfollowed
		@interest = Interest.find(params[:id])
		current_user.interests.delete(@interest)

		if interest.score > 0
			@interest.score = @interest.score - 1
			@interest.save
		end

		if request.xhr?
			render json: { id: @interest.id }
		else
			redirect_to @user
		end
	end


end
