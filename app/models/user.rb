class User < ActiveRecord::Base
    
    SCREEN_NAME_MIN_LENGTH = 4
    SCREEN_NAME_MAX_LENGTH = 20
    PASSWORD_MIN_LENGTH = 4
    PASSWORD_MAX_LENGTH = 40
    EMAIL_MAX_LENGTH = 50
    SCREEN_NAME_RANGE = SCREEN_NAME_MIN_LENGTH..SCREEN_NAME_MAX_LENGTH
    PASSWORD_RANGE = PASSWORD_MIN_LENGTH..PASSWORD_MAX_LENGTH
    
    HUMANIZED_ATTRIBUTES = {
        :email => "e-Mail",
        :screen_name => "Nick",
        :password => "Password",
    }
    
    # humanize field name
    def self.human_attribute_name(attr)
        HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end
    
    validates_uniqueness_of :screen_name, :email, :message => "has already been taken"
    validates_length_of     :screen_name, :within => SCREEN_NAME_RANGE, :too_short => "is to short (min #{SCREEN_NAME_MIN_LENGTH} char)", :too_long => "is to long (max #{SCREEN_NAME_MAX_LENGTH} char)"
    validates_length_of     :password, :within => PASSWORD_RANGE, :too_short => "is to short (min #{PASSWORD_MIN_LENGTH} char)", :too_long => "is to long (max #{PASSWORD_MAX_LENGTH} char)"
    validates_length_of     :email, :maximum => EMAIL_MAX_LENGTH, :message => "is to long"
    #validates_presence_of   :email, :message => "is not be empty"
    validates_format_of :screen_name,
                        :with => /^[A-ZąćęłńóśżźĄĆĘŁŃÓŻŹ0-9_]*$/i,
                        :message => "contains illegal characters"
    validates_format_of :email,
                        :with => /^[A-Z0-9._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i,
                        :message => "must be correct"
    
    def validate
        errors.add(:email, "must be correct") unless email.include?("@")
        if screen_name.include?(" ")
            errors.add(:screen_name, "can not contain spaces")
        end
    end
end
