require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users
  
  def setup
    @error_messages = ActiveRecord::Errors.default_error_messages
    @valid_user = users(:valid_user)
    @invalid_user = users(:invalid_user)
  end
  
  # create valid user
  def test_user_validity
    assert @valid_user.valid?
  end
  
  #create invalid user
  def test_user_invalidity
    assert !@invalid_user.valid?
    attributes = [:screen_name, :email, :password]
    attributes.each do |attribute|
      assert @invalid_user.errors.invalid?(attribute)
    end
  end
  
  def test_uniqueness_of_screen_name_and_email
    user_repeat = User.new( :screen_name => @valid_user.screen_name,
                            :email       => @valid_user.email,
                            :password    => @valid_user.password )
    assert !user_repeat.valid?
    assert_equal @error_messages[:taken], user_repeat.errors.on(:screen_name)
    assert_equal @error_messages[:taken], user_repeat.errors.on(:email)
  end
  
  def test_screen_name_length_boundaries
    assert_length :min, @valid_user, :screen_name, User::SCREEN_NAME_MIN_LENGTH
    assert_length :max, @valid_user, :screen_name, User::SCREEN_NAME_MAX_LENGTH
  end
  
  def test_password_length_boundaries
    assert_length :min, @valid_user, :password, User::PASSWORD_MIN_LENGTH
    assert_length :max, @valid_user, :password, User::PASSWORD_MAX_LENGTH
  end
  
  # e-mail is too long
  def test_email_maximum_length
    user = @valid_user
    max_length = User::EMAIL_MAX_LENGTH
    
    # we make too long e-mail
    user.email = "a" * (max_length - user.email.length + 1) + user.email
    assert !user.valid?, "#{user.email} should report an error on a maximum length"
    
    # error message for max length
    correct_error_message = sprintf(@error_messages[:too_long], max_length)
    assert_equal correct_error_message, user.errors.on(:email)
  end
  
  # test validation format e-mail
  def test_email_with_valid_examples
    user = @valid_user
    valid_endings = %w{com org net edu es jp info}
    valid_emails = valid_endings.collect do |ending|
      "foo.bar_1-9@baz-quux0.example.#{ending}"
    end
    
    valid_emails.each do |email|
      user.email = email
      assert user.valid?, "#{email} must be correct"
    end
  end
  
  # test validation incorrect email
  def test_email_with_invalid_examples
    user = @valid_user
    invalid_emails = %w{foobar@example.c @example.com f@com foo@bar..com
                        foobar@example.infod foobar.example.com
                        foo,@example.com foo@ex(ample.com foo@example,com}
    invalid_emails.each do |email|
      user.email = email
      assert !user.valid?, "#{email} should be incorrect but he didn't"
      assert_equal "must be correct", user.errors.on(:email)
    end
  end
  
  def test_screen_name_with_valid_examples
    user = @valid_user
    valid_screen_names = %w{aure michael web_20}
    
    valid_screen_names.each do |screen_name|
      user.screen_name = screen_name
      assert user.valid?, "#{screen_name} must be correct"
    end
  end
  
  def test_screen_name_with_invalid_examples
    user = @valid_user
    invalid_screen_names = %w{rails/rock web2.0 javascript:something}
    
    invalid_screen_names.each do |screen_name|
      user.screen_name = screen_name
      assert !user.valid?, "#{screen_name} shoulb be incorrect but he didn't"
    end
  end
end
