class Template < ActiveRecord::Base

  ### associations ###
  belongs_to :user
  has_many :fields, :dependent => :destroy
  has_many :pages

  ### normalizations ###
  normalize_attributes :name

  ### validations ###
  validates :name, :presence => true, :uniqueness => {:scope => :user_id}
  validates :user_id, :presence => true

end