class ProfileController < ApplicationController

  def index
    @title = "Profile in RailsSpace"
  end

  def show
    @hide_edit_links = true
    screen_name = params[:screen_name]
    @user = User.find_by_screen_name(screen_name)
    if @user
      @title = "My profile in RailsSpace: #{screen_name}"
      @spec = @user.spec ||= Spec.new
      @faq = @user.faq ||= Faq.new
    else
      flash[:notice] = "User #{screen_name} is not registred in RailsSpace!"
      redirect_to :action => "index"
    end
  end
end
