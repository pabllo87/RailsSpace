class UserController < ApplicationController
  def index
    @title = "RailsSpace: User centre"
  end

  def register
    @title = "Register"
    if request.post? and params[:user]
      @user = User.new(params[:user])
      if @user.save
        flash[:notice] = "Created new user #{@user.screen_name} is successful!"
        redirect_to :action => "index"  
      end
    end
  end
  
end
