class UsersController < ApplicationController
	before_filter :search_users

	def index
		#User.where(email: "hello@ibelmopan.com").first.following.interests.first.title
		if user_signed_in?
			@otherinterests = current_user.query_as(:b).match('(f:Interest)').where('NOT (b)--(f)').pluck('collect(f)').first
		
			#@suggestedinterests = current_user.following.interests.all.order(score: :asc)
			@suggestedinterests = current_user.query_as(:b).match('(c:User)').match('(f:Interest)').where('NOT (b)--(f) AND (c)--(f)').pluck('collect(f)').first
			@userinterests = current_user.interests.order(created_at: :desc)
		end

		#select match for users if blindating is enabled:
		if user_signed_in? 
			if current_user.blind_date == "yes"
				@bd_interest_collection = []
				@bd_userinterests = current_user.interests.order(created_at: :desc)

				@bd_userinterests.each do |interest|
					@bd_interest_collection << interest.title
				end

				puts "------------------------------------------------->"
				puts @bd_interest_collection

				#User.as(:u).interests.where(title: @bd_interest_collection).pluck(:c)
				@blinddatingusers = current_user.as(:u).following.query_as(:f).match('(i:Interest)').where('(u)--(i) AND (f)--(i)').pluck(:f)[0]

			end
		end

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

	# API
	# ---> /users/:id/unfollow
	def unfollowed
		@user = User.find(params[:id])
		current_user.following.delete(@user)
		if request.xhr?
			render json: {count: @user.following.count, id: @user.id }

		else
			redirect_to @user
		end
	end

	# API
	# ---> /users/:id/turnonbd
	def onbd
		@user = User.find(params[:id])
		@user.blind_date = "yes"
		@user.save
		if request.xhr?
			render json: {id: @user.id }
			
		else
			redirect_to @user
		end
	end


	# API
	# ---> /users/:id/turnoffbd
	def offbd
		@user = User.find(params[:id])
		@user.blind_date = "no"
		@user.save
		if request.xhr?
			render json: {id: @user.id }
			
		else
			redirect_to @user
		end
	end


	def update
		if params[:gender_preference]
			current_user.update(:gender_preference => params[:gender_preference])
			redirect_to root_path
		end

		if params[:age1] and params[:age2]
			current_user.update(:age_preference_min => params[:age1], :age_preference_max => params[:age2])
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
				["Man","Woman", nil,""]
			end
		end

		 #, age: (current_user.age_preference_min)..current_user.age_preference_max

		@users = if params[:search].present?
			#User.where(username: params[:search])
			User.as(:u).interests.where(title: params[:search]).pluck(:u)
		elsif params[:filter].present?
			if params[:filter] == "Join"
				User.all.order(created_at: :asc)
			end	
		else
			if user_signed_in?
				User.where(gender: @gender_preference,  age: (current_user.age_preference_min)..current_user.age_preference_max)
			else
				User.all
			end
		end
	end
end
