class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  include ApplicationHelper
  before_filter :check_authorization

  protect_from_forgery :secret => '41d78fcf840ddcedc5722dfe335e3dcd'
  
  session :session_key => '_rails_space_session_id'
  
  def check_authorization
    authorization_token = cookies[:authorization_token]
    if cookies[:authorization_token] and not logged_in?
      user = User.find_by_authorization_token(authorization_token)
      user.login!(session) if user
    end
  end
end
