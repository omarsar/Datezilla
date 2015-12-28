class InterestsController < ApplicationController
	before_action :authenticate_user!

	def index	
		@interests = Interest.all
		@users = User.all
	end

end
