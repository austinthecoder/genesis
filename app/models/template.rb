class Template < ActiveRecord::Base

  ### associations ###
  belongs_to :user

  ### validations ###
  validates :name, :presence => true, :uniqueness => {:scope => :user_id}
  validates :user_id, :presence => true

end