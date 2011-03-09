class Content < ActiveRecord::Base

  ### assocications ###
  belongs_to :page
  belongs_to :field

  ### validations ###
  validates :page_id, :presence => true
  validates :field_id,
    :presence => true,
    :uniqueness => {:scope => :page_id}

end