require File.dirname(__FILE__) + '/../test_helper'
require "user_controller"

class UserController; def rescue_action(e) raise e end; end

class UserControllerTest < ActionController::TestCase
  include ApplicationHelper
  fixtures :users

  def setup
    @controller = UserController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end
  
  def test_registration_page
    get :register
    title = assigns(:title)
    assert_equal "Register", title
    assert_response :success
    assert_template "register"
    
    assert_tag "form", 
                :attributes => {:action => '/user/register',
                               :method => "post"}
    assert_tag "input",
                :attributes => {:name => "user[screen_name]",
                               :type => "text",
                               :size => User::SCREEN_NAME_MAX_SIZE,
                               :maxlength => User::SCREEN_NAME_MAX_LENGTH}
    assert_tag "input",
                :attributes => {:name => "user[email]",
                                :type => "text",
                                :size => User::EMAIL_SIZE,
                                :maxlength => User::EMAIL_MAX_LENGTH}
    assert_tag "input",
                :attributes => {:name => "user[password]",
                                :type => "password",
                                :size => User::PASSWORD_SIZE,
                                :maxlength => User::PASSWORD_MAX_LENGTH}
    assert_tag "input",
                :attributes => {:type => "submit",
                                :value => "Register!"}  
  end
  
  def test_registration_success
    post :register, :user => { :screen_name => "new_screen_name",
                               :email       => "valid@wcample.com",
                               :password    => "long_enough_password"}
                               
    user = assigns(:user)
    assert_not_nil user
    # new user in db
    new_user = User.find_by_screen_name_and_password(user.screen_name, user.password)
    assert_equal new_user, user
    
    # flash msg and redirect
    assert_equal "Created new user #{new_user.screen_name} is successful!", flash[:notice]
    assert_redirected_to :action => "index"
    
    # check login user and value in session
    assert logged_in?
    assert_equal user.id, session[:user_id]
  end
  
  def test_registration_failure
    post :register, :user => { :screen_name => "aa/noyes",
                               :email       => "anoyes@example,com",
                               :password    => "sun"}
    
    assert_response :success
    assert_template "register"
    # error msg
    assert_tag "div",
                :attributes => { :id => "errorExplanation",
                                 :class => "errorExplanation" }
    # error msg list
    assert_tag "li", :content => /Nick/
    assert_tag "li", :content => /e-Mail/
    assert_tag "li", :content => /Password/
    
    # input in correct div
    error_div = { :tag => "div", :attributes => { :class => "fieldWithErrors"}}
    
    assert_tag "input",
                :attributes => { :name  => "user[screen_name]",
                                 :value => "aa/noyes" },
                :parent => error_div
    assert_tag "input",
                :attributes => { :name  => "user[email]",
                                 :value => "anoyes@example,com" },
                :parent => error_div
    assert_tag "input",
                :attributes => { :name  => "user[password]",
                                 :value => nil },
                :parent => error_div
  end
  
  def test_login_page
    get :login
    title = assigns(:title)
    assert_equal "Login", title
    assert_response :success
    assert_template "login"
    
    assert_tag "form", 
                :attributes => {:action => '/user/login',
                               :method => "post"}
    assert_tag "input",
                :attributes => {:name => "user[screen_name]",
                               :type => "text",
                               :size => User::SCREEN_NAME_MAX_SIZE,
                               :maxlength => User::SCREEN_NAME_MAX_LENGTH}
    assert_tag "input",
                :attributes => {:name => "user[password]",
                                :type => "password",
                                :size => User::PASSWORD_SIZE,
                                :maxlength => User::PASSWORD_MAX_LENGTH}
    assert_tag "input",
                :attributes => {:type => "submit",
                                :value => "Login!"}  
  end
  
  # check correct log in
  def test_login_success
    valid_user = users(:valid_user)
    try_to_login valid_user
    assert logged_in?
    assert_equal valid_user.id, session[:user_id]
    assert_equal "User #{valid_user.screen_name} is log in!", flash[:notice]
    assert_redirected_to :action => "index"
  end
  
  # check incorrect log in with wrong login
  def test_login_failure_with_nonexistent_screen_name
    invalid_user = users(:valid_user)
    invalid_user.screen_name = "no such user"
    try_to_login invalid_user
    assert_template "login"
    assert_equal "Incorrect login or password!", flash[:notice]
    
    user = assigns(:user)
    assert_equal invalid_user.screen_name, user.screen_name
    assert_nil user.password
  end
  
  # check incorrect log in with wrong password
  def test_login_failure_with_wrong_password
    invalid_user = users(:valid_user)
    invalid_user.password += "baz"
    try_to_login invalid_user
    assert_template "login"
    assert_equal "Incorrect login or password!", flash[:notice]
    
    user = assigns(:user)
    assert_equal invalid_user.screen_name, user.screen_name
    assert_nil user.password
  end
  
  def test_logout
    valid_user = users(:valid_user)
    try_to_login valid_user
    assert logged_in?
    get :logout
    assert_response :redirect
    assert_redirected_to :action => "index", :controller => "site"
    assert_equal "Logout success!", flash[:notice]
    assert !logged_in?
  end
  
  # test nav after login
  def test_navigation_logged_in
    user = users(:valid_user)
    authorize user
    get :index
    assert_tag "a", :content => /Logout/, :attributes => { :href => '/user/logout' }
    
    assert_no_tag "a", :content => /Register/, :attributes => { :href => "/user/register" }
    assert_no_tag "a", :content => /Login/, :attributes => { :href => "/user/login" }
  end
  
  def test_index_unauthorized
    get :index
    assert_response :redirect
    assert_redirected_to :action => "login"
    assert_equal "Please log in!", flash[:notice]
  end
  
  def test_index_authorized
    authorize users(:valid_user)
    get :index
    assert_response :success
    assert_template "index"
  end
  
  def test_login_friendly_url_forwarding
    valid_user =  users(:valid_user)
    user = { :screen_name => valid_user.screen_name,
             :password    => valid_user.password }
    friendly_url_forwarding_aux(:login, :index, user)
  end
  
  def test_register_friendly_url_forwarding
    valid_user =  users(:valid_user)
    user = { :screen_name => "new_screen_name",
             :email       => "valid@example.com",
             :password    => "long_enough_password" }
    friendly_url_forwarding_aux(:register, :index, user)
  end
  
  private
  
  def try_to_login(user)
   post :login, :user => { :screen_name => user.screen_name,
                           :password    => user.password }
  end
  
  def authorize(user)
    @request.session[:user_id] = user.id
  end
  
  def friendly_url_forwarding_aux(test_page, protected_page, user)
    get protected_page
    assert_response :redirect
    assert_redirected_to :action => "login"
    post test_page, :user => user
    assert_response :redirect
    #assert_redirected_to :action => protected_page
    assert_nil session[:protected_page]
  end
end
