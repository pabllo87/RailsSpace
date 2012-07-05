class SpecController < ApplicationController
  before_filter :protect

  def index
    redirect_to :controller => "user", :action => "index"
  end

  # edit user specification
  def edit
    @title = "Edit Spec"
    @user = User.find(session[:user_id])
    @user.spec ||= Spec.new
    @spec = @user.spec
    if param_posted?(:spec)
      if @user.spec.update_attributes(params[:spec])
        flash[:notice] = "Successful update"
        redirect_to :controller => "user", :action => "index"
      end
    end
  end
end
