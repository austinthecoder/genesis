class Template < ActiveRecord::Base

  has_paper_trail

  ### associations ###
  belongs_to :user
  has_many :fields
  has_many :pages

  ### normalizations ###
  normalize_attributes :name

  ### validations ###
  validates :name, :presence => true, :uniqueness => {:scope => :user_id}
  validates :user_id, :presence => true

end