require "#{File.dirname(__FILE__)}/../test_helper"

class RememberMeTest < ActionController::IntegrationTest
  include ApplicationHelper
  
  fixtures :users
  
  def setup
    @user = users(:valid_user)
  end
  
  def test_remember_me
    post "user/login", :user => { :screen_name => @user.screen_name,
                                  :password    => @user.password,
                                  :remember_me => "1"}
    @request.session[:user_id] = nil
    get "site/index"
    
    assert logged_in?
    assert_equal @user.id, session[:user_id]
  end
end
