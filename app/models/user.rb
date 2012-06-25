class User < ActiveRecord::Base
    
    SCREEN_NAME_MIN_LENGTH = 4
    SCREEN_NAME_MAX_LENGTH = 20
    PASSWORD_MIN_LENGTH = 4
    PASSWORD_MAX_LENGTH = 40
    EMAIL_MAX_LENGTH = 50
    SCREEN_NAME_RANGE = SCREEN_NAME_MIN_LENGTH..SCREEN_NAME_MAX_LENGTH
    PASSWORD_RANGE = PASSWORD_MIN_LENGTH..PASSWORD_MAX_LENGTH
    
    SCREEN_NAME_MAX_SIZE = 20
    PASSWORD_SIZE = 10
    EMAIL_SIZE = 30
    
    HUMANIZED_ATTRIBUTES = {
        :email => "e-Mail",
        :screen_name => "Nick",
        :password => "Password",
    }
    
    # humanize field name
    def self.human_attribute_name(attr)
        HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end
    
    validates_uniqueness_of :screen_name, :email
    validates_length_of     :screen_name, :within => SCREEN_NAME_RANGE
    validates_length_of     :password, :within => PASSWORD_RANGE
    validates_length_of     :email, :maximum => EMAIL_MAX_LENGTH
    #validates_presence_of   :email, :message => "is not be empty"
    validates_format_of :screen_name,
                        :with => /^[A-ZąćęłńóśżźĄĆĘŁŃÓŻŹ0-9_]*$/i,
                        :message => "contains illegal characters"
    validates_format_of :email,
                        :with => /^[A-Z0-9._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i,
                        :message => "must be correct"
    
    def validate
        #errors.add(:email, "must be correct") unless email.include?("@")
        if screen_name.include?(" ")
            errors.add(:screen_name, "can not contain spaces")
        end
    end
    
    def login!(session)
      session[:user_id] = self.id
    end
    
    def self.logout!(session)
      session[:user_id] = nil
    end
    
    def clear_password!
      self.password = nil
    end
end
