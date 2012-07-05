class Spec < ActiveRecord::Base
  belongs_to :user
  
  ALL_FIELDS = %w(first_name last_name occupation gender birthdate city state zip_code)
  STRING_FIELDS = %w(first_name last_name occupation city state)
  VALID_GENDER = ["Male", "Female"]
  START_YEAR = 1900
  VALID_DATES = DateTime.new(START_YEAR)..DateTime.now
  ZIP_CODE_LENGTH = 5
  
  HUMANIZED_ATTRIBUTES = {
    :first_name => "First name",
    :last_name => "Last name",
    :occupation => "Occupation",
    :gender => "Gender",
    :birthdate => "Birthdate",
    :city => "City",
    :state => "State",
    :zip_code => "Zip code",
    :spec => "Specification"
  }
  
  def self.human_attribute_name(attr)
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  
  validates_length_of STRING_FIELDS, :maximum => DB_STRING_MAX_LENGTH
  validates_inclusion_of :gender,
                         :in => VALID_GENDER,
                         :allow_nil => true,
                         :message => "must choice male or female"
  validates_inclusion_of :birthdate,
                         :in => VALID_DATES,
                         :allow_nil => true,
                         :message => "is incorrect"
  validates_format_of    :zip_code,
                         :with => /(^$|^[0-9]{#{ZIP_CODE_LENGTH}}$)/,
                         :message => "must be a five digit number"
                         
  def full_name
    [self.first_name, self.last_name].join(" ")
  end
  
  def location
    [self.city, self.state, self.zip_code].join(" ")
  end
end
