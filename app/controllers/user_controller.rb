class UserController < ApplicationController
  include ApplicationHelper

  before_filter :protect, :only => :index

  def index
    @title = "RailsSpace: User centre"
  end

  def register
    @title = "Register"
    if param_posted?(:user)
      @user = User.new(params[:user])
      if @user.save
        @user.login!(session)
        flash[:notice] = "Created new user #{@user.screen_name} is successful!"
        redirect_to_forwarding_url
      else
        @user.clear_password!
      end
    end
  end
  
  def login
    @title = "Login"
    if param_posted?(:user)
      @user = User.new(params[:user])
      user = User.find_by_screen_name_and_password(@user.screen_name, @user.password)
      if user
        user.login!(session)
        flash[:notice] = "User #{user.screen_name} is log in!"
        redirect_to_forwarding_url
      else
        @user.clear_password!
        flash[:notice] = "Incorrect login or password!"
      end
    end
  end
  
  def logout
    User.logout!(session)
    flash[:notice] = "Logout success!"
    redirect_to :action => "index", :controller => "site"
  end
  
  private
  
  def protect
    unless logged_in?
      session[:protected_page] = request.request_uri
      flash[:notice] = "Please log in!"
      redirect_to :action => "login"
      return false
    end
  end
  
  def param_posted?(symbol)
    request.post? and params[symbol]
  end
  
  def redirect_to_forwarding_url
    if (redirect_url = session[:protected_page])
      session[:protected_page] = nil
      redirect_to redirect_url
    else
      redirect_to :action => "index"  
    end
  end
end
